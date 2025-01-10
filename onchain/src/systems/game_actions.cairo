use starkludo::models::{
    game::{Game, GameCounter, GameTrait, GameMode, GameStatus, PlayerColor},
    player::{Player, PlayerTrait, AddressToUsername, UsernameToAddress}
};
use starknet::{ContractAddress, get_block_timestamp};

#[starknet::interface]
trait IGameActions<T> {
    fn create_new_game(
        ref self: T, game_mode: GameMode, player_color: PlayerColor, number_of_players: u8
    ) -> u64;
    fn start_game(ref self: T, game_id: u64);
    fn join(ref self: T, username: felt252, selected_color: felt252, game_id: u64);
    fn move(ref self: T);
    fn roll(ref self: T) -> (u8, u8);

    fn get_current_game_id(self: @T) -> u64;
    fn create_new_game_id(ref self: T) -> u64;

    fn create_new_player(ref self: T, username: felt252, is_bot: bool);
    fn create_bot_player(ref self: T, bot_color: PlayerColor) -> Player;
    fn get_username_from_address(self: @T, address: ContractAddress) -> felt252;
    fn get_address_from_username(self: @T, username: felt252) -> ContractAddress;
}

#[dojo::contract]
pub mod GameActions {
    use core::array::ArrayTrait;
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, contract_address_const
    };
    use super::{
        IGameActions, Game, GameCounter, GameTrait, GameMode, GameStatus, Player, PlayerColor,
        PlayerTrait, AddressToUsername, UsernameToAddress
    };

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;
    use origami_random::dice::{Dice, DiceTrait};
    use starkludo::errors::Errors;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameCreated {
        #[key]
        pub game_id: u64,
        pub timestamp: u64
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct PlayerCreated {
        #[key]
        pub username: felt252,
        pub owner: ContractAddress
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameStarted {
        #[key]
        pub game_id: u64,
        pub time_stamp: u64
    }

    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn create_new_game(
            ref self: ContractState,
            game_mode: GameMode,
            player_color: PlayerColor,
            number_of_players: u8
        ) -> u64 {
            // Get default world
            let mut world = self.world_default();

            assert(
                number_of_players >= 2 && number_of_players <= 4, 'PLAYERS CAN ONLY BE 2, 3, OR 4'
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
                number_of_players
            );

            world.write_model(@new_game);

            world.emit_event(@GameCreated { game_id, timestamp });

            game_id
        }

        fn start_game(ref self: ContractState, game_id: u64) {
            // Get game world
            let mut world = self.world_default();

            // Get game from world
            let mut game: Game = world.read_model(game_id);

            assert(game.is_initialised, 'GAME NOT INITIALISED');

            let game_mode: GameMode = game.mode;

            // Create bot players (if they have not been created)
            let green_bot: Player = self.create_bot_player(PlayerColor::Green);
            let yellow_bot: Player = self.create_bot_player(PlayerColor::Yellow);
            let blue_bot: Player = self.create_bot_player(PlayerColor::Blue);
            let red_bot: Player = self.create_bot_player(PlayerColor::Red);

            match game_mode {
                GameMode::SinglePlayer => {
                    // Check for color the player selected
                    if game.player_green != 0 {
                        if game.number_of_players == 4 {
                            game.player_yellow == yellow_bot.username;
                            game.player_blue == blue_bot.username;
                            game.player_red == red_bot.username;
                        } else if game.number_of_players == 3 {
                            game.player_yellow == yellow_bot.username;
                            game.player_blue == blue_bot.username;
                        } else if game.number_of_players == 2 {
                            game.player_yellow == yellow_bot.username;
                        }
                    } else if game.player_yellow != 0 {
                        if game.number_of_players == 4 {
                            game.player_blue == blue_bot.username;
                            game.player_red == red_bot.username;
                            game.player_green == green_bot.username;
                        } else if game.number_of_players == 3 {
                            game.player_blue == blue_bot.username;
                            game.player_green == green_bot.username;
                        } else if game.number_of_players == 2 {
                            game.player_green == green_bot.username;
                        }
                    } else if game.player_red != 0 {
                        if game.number_of_players == 4 {
                            game.player_yellow == yellow_bot.username;
                            game.player_blue == blue_bot.username;
                            game.player_green == green_bot.username;
                        } else if game.number_of_players == 3 {
                            game.player_green == green_bot.username;
                            game.player_blue == blue_bot.username;
                        } else if game.number_of_players == 2 {
                            game.player_blue == blue_bot.username;
                        }
                    } else if game.player_blue != 0 {
                        if game.number_of_players == 4 {
                            game.player_yellow == yellow_bot.username;
                            game.player_green == green_bot.username;
                            game.player_red == red_bot.username;
                        } else if game.number_of_players == 3 {
                            game.player_yellow == yellow_bot.username;
                            game.player_blue == blue_bot.username;
                        } else if game.number_of_players == 2 {
                            game.player_blue == blue_bot.username;
                        }
                    }
                },
                GameMode::MultiPlayer => {}
            };
        }

        fn join(ref self: ContractState, username: felt252, selected_color: felt252, game_id: u64) {
            // Get world state
            let mut world = self.world_default();

            //get the game state
            let mut game: Game = world.read_model(game_id);
            //

            game.player_red = match selected_color {
                0 => 0,
                1 => username,
                _ => 0
            };
            game.player_yellow = match selected_color {
                0 => 0,
                1 => username,
                _ => 0
            };
            game.player_blue = match selected_color {
                0 => 0,
                1 => username,
                _ => 0
            };
            game.player_green = match selected_color {
                0 => 0,
                1 => username,
                _ => 0
            };
        }

        fn move(ref self: ContractState) {}

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
                username, address: caller
            };
            let address_to_username: AddressToUsername = AddressToUsername {
                address: caller, username
            };

            world.write_model(@new_player);
            world.write_model(@username_to_address);
            world.write_model(@address_to_username);

            world.emit_event(@PlayerCreated { username, owner: caller });
        }

        // TODO: Make function private
        fn create_bot_player(ref self: ContractState, bot_color: PlayerColor) -> Player {
            let mut world = self.world_default();
            let mut username: felt252 = 0;
            let zero_address: ContractAddress = contract_address_const::<0x0>();
            let mut player_address: ContractAddress = zero_address;

            // Derive username and player address from bot color
            match bot_color {
                PlayerColor::Green => {
                    username = 'green_bot';
                    player_address = contract_address_const::<'green_bot'>();
                },
                PlayerColor::Yellow => {
                    username = 'yellow_bot';
                    player_address = contract_address_const::<'yellow_bot'>();
                },
                PlayerColor::Blue => {
                    username = 'blue_bot';
                    player_address = contract_address_const::<'blue_bot'>();
                },
                PlayerColor::Red => {
                    username = 'red_bot';
                    player_address = contract_address_const::<'red_bot'>();
                }
            };

            let existing_player: Player = world.read_model(username);

            // If bot player has not been created
            if existing_player.owner == zero_address {
                let is_bot: bool = true;

                let new_player: Player = PlayerTrait::new(username, player_address, is_bot);
                let username_to_address: UsernameToAddress = UsernameToAddress {
                    username, address: player_address
                };
                let address_to_username: AddressToUsername = AddressToUsername {
                    address: player_address, username
                };

                world.write_model(@new_player);
                world.write_model(@username_to_address);
                world.write_model(@address_to_username);

                world.emit_event(@PlayerCreated { username, owner: player_address });

                new_player
            } else {
                // If bot player has been created
                existing_player
            }
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
