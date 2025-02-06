use starkludo::models::{
    game::{Game, GameCounter, GameTrait, GameMode, GameStatus, PlayerColor},
    player::{Player, PlayerTrait, AddressToUsername, UsernameToAddress},
};
use starknet::{ContractAddress, get_block_timestamp};

#[starknet::interface]
trait IGameActions<T> {
    fn create_new_game(
        ref self: T, game_mode: GameMode, player_color: PlayerColor, number_of_players: u8,
    ) -> u64;
    fn join(ref self: T, player_color: PlayerColor, game_id: u64);
    fn move(ref self: T, pos: felt252, color: u8);
    fn roll(ref self: T) -> (u8, u8);

    fn get_current_game_id(self: @T) -> u64;
    fn create_new_game_id(ref self: T) -> u64;

    fn create_new_player(ref self: T, username: felt252, is_bot: bool);
    fn get_username_from_address(self: @T, address: ContractAddress) -> felt252;
    fn get_address_from_username(self: @T, username: felt252) -> ContractAddress;
    fn move_deducer(ref self: T, val: u32, dice_throw: u32) -> (u32, bool, bool);
}

#[dojo::contract]
pub mod GameActions {
    use core::array::ArrayTrait;
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, contract_address_const,
    };
    use super::{
        IGameActions, Game, GameCounter, GameTrait, GameMode, GameStatus, Player, PlayerColor,
        PlayerTrait, AddressToUsername, UsernameToAddress,
    };

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;
    use origami_random::dice::{Dice, DiceTrait};
    use starkludo::errors::Errors;
    use starkludo::constants::{
        get_markers, find_index, pos_to_board, board_to_pos, get_safe_positions, contains,
        pos_reducer, get_cap_colors,
    };

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameCreated {
        #[key]
        pub game_id: u64,
        pub timestamp: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct PlayerCreated {
        #[key]
        pub username: felt252,
        pub owner: ContractAddress,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameStarted {
        #[key]
        pub game_id: u64,
        pub time_stamp: u64,
    }

    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn create_new_game(
            ref self: ContractState,
            game_mode: GameMode,
            player_color: PlayerColor,
            number_of_players: u8,
        ) -> u64 {
            // Get default world
            let mut world = self.world_default();

            assert(
                number_of_players >= 2 && number_of_players <= 4, 'PLAYERS CAN ONLY BE 2, 3, OR 4',
            );

            // Get the account address of the caller
            let caller_address = get_caller_address();
            let caller_username = self.get_username_from_address(caller_address);
            assert(caller_username != 0, 'PLAYER NOT REGISTERED');

            let game_id = self.create_new_game_id();
            let timestamp = get_block_timestamp();

            let player_green = match player_color {
                PlayerColor::Green => caller_username,
                _ => 0,
            };

            let player_yellow = match player_color {
                PlayerColor::Yellow => caller_username,
                _ => 0,
            };

            let player_blue = match player_color {
                PlayerColor::Blue => caller_username,
                _ => 0,
            };

            let player_red = match player_color {
                PlayerColor::Red => caller_username,
                _ => 0,
            };

            // Create a new game
            let new_game: Game = GameTrait::new(
                game_id,
                caller_username,
                game_mode,
                player_red,
                player_blue,
                player_yellow,
                player_green,
                number_of_players,
            );

            world.write_model(@new_game);

            world.emit_event(@GameCreated { game_id, timestamp });

            game_id
        }

        /// Start game
        /// Change game status to ONGOING
        fn join(ref self: ContractState, player_color: PlayerColor, game_id: u64) {
            // Get world state
            let mut world = self.world_default();

            //get the game state
            let mut game: Game = world.read_model(game_id);

            assert(game.is_initialised, 'GAME NOT INITIALISED');

            // Assert that game is a Multiplayer game
            assert(game.mode == GameMode::MultiPlayer, 'GAME NOT MULTIPLAYER');

            // Assert that game is in Pending state
            assert(game.status == GameStatus::Pending, 'GAME NOT PENDING');

            // Get the account address of the caller
            let caller_address = get_caller_address();
            let caller_username = self.get_username_from_address(caller_address);

            assert(caller_username != 0, 'PLAYER NOT REGISTERED');

            /// Game starts automatically once the last player joins

            // Verify that color is available
            // Assign color to player if available
            match player_color {
                PlayerColor::Red => {
                    if (game.player_red == 0) {
                        game.player_red = caller_username
                    } else {
                        panic!("RED already selected");
                    }
                },
                PlayerColor::Blue => {
                    if (game.player_blue == 0) {
                        game.player_blue = caller_username
                    } else {
                        panic!("BLUE already selected");
                    }
                },
                PlayerColor::Green => {
                    if (game.player_green == 0) {
                        game.player_green = caller_username
                    } else {
                        panic!("GREEN already selected");
                    }
                },
                PlayerColor::Yellow => {
                    if (game.player_yellow == 0) {
                        game.player_yellow = caller_username
                    } else {
                        panic!("YELLOW already selected");
                    }
                },
            }

            // Start game automatically once the last player joins

            const TWO_PLAYERS: u8 = 2;
            const THREE_PLAYERS: u8 = 3;
            const FOUR_PLAYERS: u8 = 4;

            match game.number_of_players {
                0 => panic!("Number of players cannot be 0"),
                1 => panic!("Number of players cannot be 1"),
                2 => {
                    let mut players_joined_count: u8 = 0;

                    if (game.player_red != 0) {
                        players_joined_count += 1;
                    }
                    if (game.player_blue != 0) {
                        players_joined_count += 1;
                    }
                    if (game.player_green != 0) {
                        players_joined_count += 1;
                    }
                    if (game.player_yellow != 0) {
                        players_joined_count += 1;
                    }

                    // Start game once all players have joined
                    if (players_joined_count == TWO_PLAYERS) {
                        game.status = GameStatus::Ongoing;
                    }
                },
                3 => {
                    let mut players_joined_count: u8 = 0;

                    if (game.player_red != 0) {
                        players_joined_count += 1;
                    }
                    if (game.player_blue != 0) {
                        players_joined_count += 1;
                    }
                    if (game.player_green != 0) {
                        players_joined_count += 1;
                    }
                    if (game.player_yellow != 0) {
                        players_joined_count += 1;
                    }

                    // Start game once all players have joined
                    if (players_joined_count == THREE_PLAYERS) {
                        game.status = GameStatus::Ongoing;
                    }
                },
                4 => {
                    let mut players_joined_count: u8 = 0;

                    if (game.player_red != 0) {
                        players_joined_count += 1;
                    }
                    if (game.player_blue != 0) {
                        players_joined_count += 1;
                    }
                    if (game.player_green != 0) {
                        players_joined_count += 1;
                    }
                    if (game.player_yellow != 0) {
                        players_joined_count += 1;
                    }

                    // Start game once all players have joined
                    if (players_joined_count == FOUR_PLAYERS) {
                        game.status = GameStatus::Ongoing;
                    }
                },
                _ => panic!("Invalid number of players"),
            };

            // Update the game state in the world
            world.write_model(@game);
        }

        fn move(ref self: ContractState, pos: felt252, color: u8) {
            // Get world state
            let mut world = self.world_default();

            // Get the current game ID
            let game_id = self.get_current_game_id();

            // Retrieve the game state
            let mut game: Game = world.read_model(game_id);

            // Get the dice throw value
            let diceThrow: u32 = game.dice_face.into();

            // Get the markers array
            let markers = get_markers();

            // Find the index of the current position in the markers array
            let j = find_index(pos, markers); // current_val

            // Initialize flags for chance and thrown status
            let mut isChance = false;
            let mut isThrown = false;

            // Convert the game condition from board positions to array positions
            let current_condition = board_to_pos(game.game_condition.clone());

            // Get the current value at the position
            let mut val = current_condition[j];

            // Determine the new value and update chance and thrown status
            let (newVal, ischance, isthrown) = self.move_deducer(*val, diceThrow);
            isChance = ischance;
            isThrown = isthrown;

            // Update the condition array with the new value
            let mut condition = ArrayTrait::new();
            let mut i: usize = 0;
            loop {
                if i == current_condition.len() {
                    break;
                }
                if i == j {
                    condition.append(newVal);
                } else {
                    condition.append(*current_condition.at(i));
                }
                i += 1;
            };
            condition = pos_to_board(condition);

            // Update the value at the position
            val = condition[j];

            // Get the safe positions array
            let safe_pos = get_safe_positions();

            // Get the number of players
            let players_length = game.number_of_players.try_into().unwrap();

            // Check if the new position is not a safe position
            if !contains(safe_pos, *val) {
                let mut i: u32 = 0;
                loop {
                    if i >= (players_length * 4) {
                        break;
                    }
                    // Check if the position is occupied by an opponent's piece
                    if color != (i / 4).try_into().unwrap() && *condition.at(i) == *val {
                        isChance = true;
                        let mut new_condition = ArrayTrait::new();
                        let mut j: u32 = 0;
                        loop {
                            if j >= condition.len() {
                                break;
                            }
                            if j == i {
                                new_condition.append(0); // Capture the opponent's piece
                            } else {
                                new_condition.append(*condition.at(j));
                            }
                            j += 1;
                        };
                        condition = new_condition;
                    }
                    i += 1;
                };
            }

            // Check if the dice throw is 6
            if diceThrow == 6 {
                isChance = true;
            }

            // Update the game condition
            game.game_condition = condition.clone();

            // Convert the condition back to array positions
            let current_condition = condition;
            let deref = pos_reducer(current_condition, players_length);
            let output = deref.clone();

            // Update the game state with the new positions
            match players_length {
                0 => {},
                1 => {},
                2 => {
                    game.r0 = *output.get(0).unwrap().unbox();
                    game.r1 = *output.get(1).unwrap().unbox();
                    game.r2 = *output.get(2).unwrap().unbox();
                    game.r3 = *output.get(3).unwrap().unbox();
                    game.g0 = *output.get(4).unwrap().unbox();
                    game.g1 = *output.get(5).unwrap().unbox();
                    game.g2 = *output.get(6).unwrap().unbox();
                    game.g3 = *output.get(7).unwrap().unbox();
                },
                3 => {
                    game.r0 = *output.get(0).unwrap().unbox();
                    game.r1 = *output.get(1).unwrap().unbox();
                    game.r2 = *output.get(2).unwrap().unbox();
                    game.r3 = *output.get(3).unwrap().unbox();
                    game.g0 = *output.get(4).unwrap().unbox();
                    game.g1 = *output.get(5).unwrap().unbox();
                    game.g2 = *output.get(6).unwrap().unbox();
                    game.g3 = *output.get(7).unwrap().unbox();
                    game.y0 = *output.get(8).unwrap().unbox();
                    game.y1 = *output.get(9).unwrap().unbox();
                    game.y2 = *output.get(10).unwrap().unbox();
                    game.y3 = *output.get(11).unwrap().unbox();
                },
                4 => {
                    game.r0 = *output.get(0).unwrap().unbox();
                    game.r1 = *output.get(1).unwrap().unbox();
                    game.r2 = *output.get(2).unwrap().unbox();
                    game.r3 = *output.get(3).unwrap().unbox();
                    game.g0 = *output.get(4).unwrap().unbox();
                    game.g1 = *output.get(5).unwrap().unbox();
                    game.g2 = *output.get(6).unwrap().unbox();
                    game.g3 = *output.get(7).unwrap().unbox();
                    game.y0 = *output.get(8).unwrap().unbox();
                    game.y1 = *output.get(9).unwrap().unbox();
                    game.y2 = *output.get(10).unwrap().unbox();
                    game.y3 = *output.get(11).unwrap().unbox();
                    game.b0 = *output.get(12).unwrap().unbox();
                    game.b1 = *output.get(13).unwrap().unbox();
                    game.b2 = *output.get(14).unwrap().unbox();
                    game.b3 = *output.get(15).unwrap().unbox();
                },
                _ => {},
            }

            // Get the current player's pieces
            let mut color_state = ArrayTrait::new();
            let start = color * 4;
            let end = start + 4;
            let mut i: u32 = start.into();
            loop {
                if i >= end.into() || i >= output.len().into() {
                    break;
                }
                color_state.append(*output.at(i));
                i += 1;
            };

            // Get the capture colors array
            let cap_colors = get_cap_colors();
            let mut f: u32 = 0;
            let mut k: u32 = 0;
            loop {
                if k >= color_state.len() {
                    break;
                }
                // Check if the piece is in the winning position
                let c: felt252 = *color_state.at(k);
                let cap_color: felt252 = *cap_colors.at(color.try_into().unwrap());
                let comparison_value: felt252 = (cap_color * 1000 + 6).into();
                if c == comparison_value {
                    f += 1;
                }
                k += 1;
            };

            // Determine the next player
            let mut new_color = if isChance {
                color
            } else {
                (color + 1) % players_length.try_into().unwrap()
            };

            // Get the player addresses
            let red_address = game.player_red;
            let green_address = game.player_green;
            let yellow_address = game.player_yellow;
            let blue_address = game.player_blue;

            // Determine the next player's address
            let mut next_player_address = match new_color {
                0 => red_address,
                1 => green_address,
                2 => yellow_address,
                3 => blue_address,
                _ => 0,
            };

            let mut new_chance = new_color;

            // Get the winner addresses
            let winner_1 = game.winner_1;
            let winner_2 = game.winner_2;
            let winner_3 = game.winner_3;

            // Check if the next player is already a winner
            while next_player_address == winner_1
                || next_player_address == winner_2
                || next_player_address == winner_3 {
                new_chance = (new_chance + 1) % players_length.try_into().unwrap();
                next_player_address = match new_chance {
                    0 => red_address,
                    1 => green_address,
                    2 => yellow_address,
                    3 => blue_address,
                    _ => 0,
                };
            };

            new_color = new_chance;

            // Get the current player's address
            let current_player_address = match color {
                0 => red_address,
                1 => green_address,
                2 => yellow_address,
                3 => blue_address,
                _ => 0,
            };

            // Get the zero address
            let zero_address = contract_address_const::<0x0>();

            // Check if the player has won
            if f == 4 {
                if game.winner_1 == zero_address.into() {
                    game.winner_1 = current_player_address;
                } else if game.winner_2 == zero_address.into() {
                    game.winner_2 = current_player_address;
                } else {
                    game.winner_3 = current_player_address;
                }
            }

            // Update the next player and dice thrown status
            game.next_player = next_player_address;
            game.has_thrown_dice = isThrown;

            // Update the game state in the world
            world.write_model(@game);
        }

        fn move_deducer(ref self: ContractState, val: u32, dice_throw: u32) -> (u32, bool, bool) {
            let mut new_val: u32 = 0;
            let mut is_thrown: bool = false;
            let mut is_chance: bool = false;

            if val == 0 && dice_throw == 6 {
                new_val = 1;
            } else if val == 0 {
                new_val = 0;
                is_chance = true;
                is_thrown = true;
            } else {
                let test_val = val + dice_throw;
                if test_val > 57 {
                    new_val = val;
                    is_chance = true;
                } else if test_val == 57 {
                    new_val = test_val;
                    is_chance = true;
                } else {
                    new_val = test_val;
                }
            }

            (new_val, is_chance, is_thrown)
        }

        fn roll(ref self: ContractState) -> (u8, u8) {
            let seed = get_block_timestamp();

            let mut dice1 = DiceTrait::new(6, seed.try_into().unwrap());
            let mut dice2 = DiceTrait::new(6, (seed + 1).try_into().unwrap());

            let dice1_roll = dice1.roll();
            let dice2_roll = dice2.roll();

            (dice1_roll, dice2_roll)
        }


        fn create_new_game_id(ref self: ContractState) -> u64 {
            let mut world = self.world_default();
            let mut game_counter: GameCounter = world.read_model('v0');
            let new_val = game_counter.current_val + 1;
            game_counter.current_val = new_val;
            world.write_model(@game_counter);
            new_val
        }

        fn get_current_game_id(self: @ContractState) -> u64 {
            let world = self.world_default();
            let game_counter: GameCounter = world.read_model('v0');
            game_counter.current_val
        }

        fn create_new_player(ref self: ContractState, username: felt252, is_bot: bool) {
            let mut world = self.world_default();

            let caller: ContractAddress = get_caller_address();

            let zero_address: ContractAddress = contract_address_const::<0x0>();

            // Validate username
            assert(username != 0, 'USERNAME CANNOT BE ZERO');

            let existing_player: Player = world.read_model(username);

            // Ensure player username is unique
            assert(existing_player.owner == zero_address, 'USERNAME ALREADY TAKEN');

            // Ensure player cannot update username by calling this function
            let existing_username = self.get_username_from_address(caller);

            assert(existing_username == 0, 'USERNAME ALREADY CREATED');

            let new_player: Player = PlayerTrait::new(username, caller, is_bot);
            let username_to_address: UsernameToAddress = UsernameToAddress {
                username, address: caller,
            };
            let address_to_username: AddressToUsername = AddressToUsername {
                address: caller, username,
            };

            world.write_model(@new_player);
            world.write_model(@username_to_address);
            world.write_model(@address_to_username);

            world.emit_event(@PlayerCreated { username, owner: caller });
        }

        fn get_username_from_address(self: @ContractState, address: ContractAddress) -> felt252 {
            let mut world = self.world_default();

            let address_map: AddressToUsername = world.read_model(address);

            address_map.username
        }

        fn get_address_from_username(self: @ContractState, username: felt252) -> ContractAddress {
            let mut world = self.world_default();

            let username_map: UsernameToAddress = world.read_model(username);

            username_map.address
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Use the default namespace "starkludo". This function is handy since the ByteArray
        /// can't be const.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"starkludo")
        }
    }
}
