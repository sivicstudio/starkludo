use starludo::models::{
    game::{Game, GameCounter, GameTrait, GameMode, GameStatus, PlayerColor},
    player::{Player, PlayerTrait, AddressToUsername, UsernameToAddress},
};
use starknet::{ContractAddress, get_block_timestamp};

#[starknet::interface]
pub trait IGameActions<T> {
    fn create_new_game(
        ref self: T, game_mode: GameMode, player_color: PlayerColor, number_of_players: u8,
    ) -> u64;
    fn join(ref self: T, player_color: PlayerColor, game_id: u64);
    fn move(ref self: T, pos: felt252, game_id: u64);
    fn roll(ref self: T) -> (u8, u8);

    fn get_current_game_id(self: @T) -> u64;
    fn create_new_game_id(ref self: T) -> u64;

    fn create_new_player(ref self: T, username: felt252, is_bot: bool);
    fn get_username_from_address(self: @T, address: ContractAddress) -> felt252;
    fn get_address_from_username(self: @T, username: felt252) -> ContractAddress;
    fn move_deducer(ref self: T, val: u32, dice_throw: u32) -> (u32, bool, bool);
    fn get_next_color(ref self: T, current_color: u8, isChance: bool, game_id: u64) -> u8;
    fn get_active_colors(self: @T, game_id: u64) -> Array<u8>;
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
    use starludo::errors::Errors;
    use starludo::helpers::{
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
            let mut new_game: Game = GameTrait::new(
                game_id,
                caller_username,
                game_mode,
                player_red,
                player_blue,
                player_yellow,
                player_green,
                number_of_players,
            );

            // If it's a multiplayer game, set status to Pending,
            // else mark it as Ongoing (for single-player).
            if game_mode == GameMode::MultiPlayer {
                new_game.status = GameStatus::Pending;
            } else {
                new_game.status = GameStatus::Ongoing;
            }

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

            // Verify that player has not already joined the game
            assert(game.player_red != caller_username, 'ALREADY SELECTED RED');
            assert(game.player_blue != caller_username, 'ALREADY SELECTED BLUE');
            assert(game.player_green != caller_username, 'ALREADY SELECTED GREEN');
            assert(game.player_yellow != caller_username, 'ALREADY SELECTED YELLOW');

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
                        game.player_yellow = caller_username;
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

        fn move(ref self: ContractState, pos: felt252, game_id: u64) {
            // Get world state
            let mut world = self.world_default();

            // Retrieve the game state
            let mut game: Game = world.read_model(game_id);

            let caller_address = get_caller_address();
            let caller_username = self.get_username_from_address(caller_address);

            let color: u8 = if caller_username == game.player_red.try_into().unwrap() {
                0_u8
            } else if caller_username == game.player_green.try_into().unwrap() {
                1_u8
            } else if caller_username == game.player_yellow.try_into().unwrap() {
                2_u8
            } else if caller_username == game.player_blue.try_into().unwrap() {
                3_u8
            } else {
                panic!("CALLER NOT REGISTERED AS A PLAYER")
            };

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

            let active_colors = self.get_active_colors(game_id);

            // Check if the new position is not a safe position
            if !contains(safe_pos, *val) {
                // Loop over each active color block (active_colors holds the colors in use)
                let active_colors_len = active_colors.len();
                let mut block_idx: u32 = 0;
                loop {
                    if block_idx >= active_colors_len {
                        break;
                    }
                    // Get the color id from active_colors for the current block
                    let current_active_color = *active_colors.at(block_idx);
                    let mut piece: u32 = 0;
                    loop {
                        if piece >= 4 {
                            break;
                        }
                        let global_index = current_active_color.into() * 4 + piece;

                        // Check if this piece does not belong to the caller and if its position
                        // equals *val.
                        if (current_active_color != color)
                            && (*condition.at(global_index) == *val) {
                            isChance = true;
                            // Rebuild condition array with captured piece replaced with 0.
                            let mut new_condition = ArrayTrait::new();
                            let mut k: u32 = 0;
                            loop {
                                if k >= condition.len() {
                                    break;
                                }
                                if k == global_index {
                                    new_condition.append(0); // Capture opponent's piece.
                                } else {
                                    new_condition.append(*condition.at(k));
                                }
                                k += 1;
                            };
                            condition = new_condition;
                            break;
                        }
                        piece += 1;
                    };
                    block_idx += 1;
                };
            }

            // Check if the dice throw is 6
            if diceThrow == 6 {
                isChance = true;
            }

            // Update the game condition
            game.game_condition = condition.clone();

            let active_colors = self.get_active_colors(game_id);

            // Convert the condition back to array positions
            let current_condition = condition;
            let deref = pos_reducer(current_condition, active_colors.clone());
            let output = deref.clone();

            let mut offset: usize = 0;

            for c_i in 0..active_colors.len() {
                let c = *active_colors.at(c_i);
                match c {
                    0 => {
                        game.r0 = *output.get(offset).unwrap().unbox();
                        game.r1 = *output.get(offset + 1).unwrap().unbox();
                        game.r2 = *output.get(offset + 2).unwrap().unbox();
                        game.r3 = *output.get(offset + 3).unwrap().unbox();
                    },
                    1 => {
                        game.g0 = *output.get(offset).unwrap().unbox();
                        game.g1 = *output.get(offset + 1).unwrap().unbox();
                        game.g2 = *output.get(offset + 2).unwrap().unbox();
                        game.g3 = *output.get(offset + 3).unwrap().unbox();
                    },
                    2 => {
                        game.y0 = *output.get(offset).unwrap().unbox();
                        game.y1 = *output.get(offset + 1).unwrap().unbox();
                        game.y2 = *output.get(offset + 2).unwrap().unbox();
                        game.y3 = *output.get(offset + 3).unwrap().unbox();
                    },
                    3 => {
                        game.b0 = *output.get(offset).unwrap().unbox();
                        game.b1 = *output.get(offset + 1).unwrap().unbox();
                        game.b2 = *output.get(offset + 2).unwrap().unbox();
                        game.b3 = *output.get(offset + 3).unwrap().unbox();
                    },
                    _ => {},
                };
                offset += 4;
            };

            world.write_model(@game);

            // Retrieve the game state
            let mut game: Game = world.read_model(game_id);

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

            let mut new_color = self.get_next_color(color, isChance, game_id);

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
                new_chance = (new_chance + 1) % active_colors.len().try_into().unwrap();
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

        fn get_next_color(
            ref self: ContractState, current_color: u8, isChance: bool, game_id: u64,
        ) -> u8 {
            // Gather only active colors
            let mut active_colors: Array<u8> = self.get_active_colors(game_id);

            // Find the index of current_color
            let mut idx = 0_usize;
            loop {
                if idx >= active_colors.len() {
                    panic!("Current color not found in active colors");
                }
                if *active_colors.at(idx) == current_color {
                    break;
                }
                idx += 1;
            };

            // move to the next color
            if !isChance {
                idx = (idx + 1) % active_colors.len();
            }

            let mut new_color = *active_colors.at(idx);
            new_color
        }

        fn get_active_colors(self: @ContractState, game_id: u64) -> Array<u8> {
            let mut world = self.world_default();
            let game: Game = world.read_model(game_id);
            let mut colors: Array<u8> = ArrayTrait::new();
            if game.player_red != 0 {
                colors.append(0);
            }
            if game.player_green != 0 {
                colors.append(1);
            }
            if game.player_yellow != 0 {
                colors.append(2);
            }
            if game.player_blue != 0 {
                colors.append(3);
            }
            colors
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Use the default namespace "starludo". This function is handy since the ByteArray
        /// can't be const.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"starludo")
        }
    }
}
