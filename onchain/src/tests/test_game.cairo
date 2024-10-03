#[cfg(test)]
mod tests {
    // Import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // Import test utils
    use dojo::utils::test::{spawn_test_world, deploy_contract};
    // Import test utils
    use starkludo::{
        systems::{
            game_actions::{
                GameActions, IGameActionsDispatcher, DiceTrait, IGameActionsDispatcherTrait,
                DiceImpl
            }
        },
        models::game::{Game, game, GameMode, GameStatus},
    };
    // Import Starknet utils
    use starknet::{testing, contract_address_const, get_caller_address, ContractAddress};

    fn create_and_setup_game(
        game_mode: GameMode,
        number_of_players: u8,
        player_red: felt252,
        player_blue: felt252,
        player_yellow: felt252,
        player_green: felt252,
    ) -> (Game, IGameActionsDispatcher, IWorldDispatcher, ContractAddress,) {
        // Get caller address
        let caller = get_caller_address();
        // Get game models
        let mut models = array![game::TEST_CLASS_HASH];
        // Spawn a new world from game model
        let world = spawn_test_world(["starkludo"].span(), models.span());
        // Deploy world and get contract address
        let contract_address = world
            .deploy_contract('salt', GameActions::TEST_CLASS_HASH.try_into().unwrap());
        // Game actions
        let game_actions = IGameActionsDispatcher { contract_address };
        // Grant writer access to game actions
        world.grant_writer(dojo::utils::bytearray_hash(@"starkludo"), contract_address);

        // Create a new game
        let game: Game = game_actions
            .create(
                caller,
                game_mode,
                player_green,
                player_yellow,
                player_blue,
                player_red,
                number_of_players
            );

        (game, game_actions, world, contract_address,)
    }

    #[test]
    fn test_game_creation() {
        let caller = contract_address_const::<'ibs'>();

        let player_red = 'player_red';
        let player_blue = 'player_blue';
        let player_yellow = 'player_yellow';
        let player_green = 'player_green';
        let number_of_players = 4;
        let game_mode: GameMode = GameMode::MultiPlayer;

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        let (game, _, _, _) = create_and_setup_game(
            game_mode, number_of_players, player_red, player_blue, player_yellow, player_green
        );

        assert_eq!(game.created_by, caller);
        // assert_eq!(game.game_mode, game_mode);
        assert_eq!(game.player_red, player_red.into());
        assert_eq!(game.player_blue, player_blue.into());
        assert_eq!(game.player_yellow, player_yellow.into());
        assert_eq!(game.player_green, player_green.into());
    }

    // TODO: Test number of players
    // TODO: Test game mode

    #[test]
    fn test_restart_game() {
        let caller = contract_address_const::<'Collins'>();
        let zero_address = contract_address_const::<0x0>();

        let player_red = 'player_red';
        let player_blue = 'player_blue';
        let player_yellow = 'player_yellow';
        let player_green = 'player_green';
        let number_of_players = 4;
        let game_mode: GameMode = GameMode::MultiPlayer;

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        //creating a new game
        let (game, game_actions, _, _) = create_and_setup_game(
            game_mode, number_of_players, player_red, player_blue, player_yellow, player_green
        );

        let game_id: u64 = game.id;

        //restarting the game
        game_actions.restart(game_id);

        assert_eq!(game.next_player, zero_address.into());
        assert_eq!(game.rolls_times, 0);
        assert_eq!(game.rolls_count, 0);
        assert_eq!(game.dice_face, 0);
        assert_eq!(game.player_chance, zero_address.into());
        assert_eq!(game.has_thrown_dice, false);
    }
    // // Constants for Dice Tests
    const DICE_FACE_COUNT: u8 = 6;
    const DICE_SEED: felt252 = 'SEED';

    #[test]
    fn test_dice_new_roll() {
        let mut dice = DiceTrait::new(DICE_FACE_COUNT, DICE_SEED);
        assert(dice.roll() == 1, 'Wrong dice value');
        assert(dice.roll() == 6, 'Wrong dice value');
        assert(dice.roll() == 3, 'Wrong dice value');
        assert(dice.roll() == 1, 'Wrong dice value');
        assert(dice.roll() == 4, 'Wrong dice value');
        assert(dice.roll() == 3, 'Wrong dice value');
    }

    #[test]
    fn test_dice_new_roll_overflow() {
        let mut dice = DiceTrait::new(DICE_FACE_COUNT, DICE_SEED);
        dice.nonce = 0x800000000000011000000000000000000000000000000000000000000000000;
        dice.roll();
        assert(dice.nonce == 0, 'Wrong dice nonce');
    }

    #[test]
    #[ignore]
    fn test_terminate_game() {
        let caller = contract_address_const::<'ibs'>();

        let player_red = 'player_red';
        let player_blue = 'player_blue';
        let player_yellow = 'player_yellow';
        let player_green = 'player_green';
        let number_of_players = 4;
        let game_mode: GameMode = GameMode::MultiPlayer;

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        let (game, game_actions, _, _) = create_and_setup_game(
            game_mode, number_of_players, player_red, player_blue, player_yellow, player_green
        );

        assert_eq!(game.created_by, caller);
        // assert_eq!(game.game_mode, game_mode);
        assert_eq!(game.player_red, player_red.into());
        assert_eq!(game.player_blue, player_blue.into());
        assert_eq!(game.player_yellow, player_yellow.into());
        assert_eq!(game.player_green, player_green.into());

        let game_id: u64 = game.id;

        game_actions.terminate_game(game_id);

        assert_eq!(game.game_status, GameStatus::Ended);
    }


    #[test]
    fn test_join_game() {
        // Set up the test environment
        let caller = contract_address_const::<'ben'>();
        let number_of_players = 4;
        let game_mode: GameMode = GameMode::MultiPlayer;
    
        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);
    
        // Create a new game
        let (mut game, game_actions, world, _) = create_and_setup_game(
            game_mode,
            number_of_players,
            0, // Start with no players
            0,
            0,
            0
        );
    
        let game_id = game.id;
    
        // Test joining as red player
        game = game_actions.join_game(game_id, 'red', 'player_red');
        assert_eq!(game.player_red, 'player_red'.into(), "Red player should be joined");
        assert_eq!(game.game_status, GameStatus::Waiting, "Game should still be waiting");
    
        // Test joining as blue player
        game = game_actions.join_game(game_id, 'blue', 'player_blue');
        assert_eq!(game.player_blue, 'player_blue'.into(), "Blue player should be joined");
        assert_eq!(game.game_status, GameStatus::Waiting, "Game should still be waiting");
    
        // Test joining as yellow player
        game = game_actions.join_game(game_id, 'yellow', 'player_yellow');
        assert_eq!(game.player_yellow, 'player_yellow'.into(), "Yellow player should be joined");
        assert_eq!(game.game_status, GameStatus::Waiting, "Game should still be waiting");
    
        // Test joining as green player (last player)
        game = game_actions.join_game(game_id, 'green', 'player_green');
        assert_eq!(game.player_green, 'player_green'.into(), "Green player should be joined");
        assert_eq!(game.game_status, GameStatus::Ongoing, "Game should now be ongoing");
    
        // Create a new game with fewer players
        let (mut game2, game_actions2, _, _) = create_and_setup_game(
            game_mode,
            2, // Only 2 players this time
            0,
            0,
            0,
            0
        );
    
        let game_id2 = game2.id;
    
        // Join with two players
        game2 = game_actions2.join_game(game_id2, 'red', 'player_red_2');
        game2 = game_actions2.join_game(game_id2, 'blue', 'player_blue_2');
    
        // Verify game status changes to Ongoing with fewer players
        assert_eq!(game2.game_status, GameStatus::Ongoing, "Game should be ongoing with 2/2 players");
    }
    
    #[test]
    #[should_panic(expected: ('Game is not waiting for players', ))]
    fn test_join_non_waiting_game() {
        // Set up the test environment
        let caller = contract_address_const::<'test_caller'>();
        let number_of_players = 2;
        let game_mode: GameMode = GameMode::MultiPlayer;
    
        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);
    
        // Create a new game
        let (mut game, game_actions, world, _) = create_and_setup_game(
            game_mode,
            number_of_players,
            0,
            0,
            0,
            0
        );
    
        let game_id = game.id;
    
        // Fill the game
        game = game_actions.join_game(game_id, 'red', 'player_red');
        game = game_actions.join_game(game_id, 'blue', 'player_blue');
    
        // This should panic
        game_actions.join_game(game_id, 'yellow', 'late_player');
    }
    
    #[test]
    #[should_panic(expected: ('Invalid player color', ))]
    fn test_join_game_invalid_color() {
        // Set up the test environment
        let caller = contract_address_const::<'test_caller'>();
        let number_of_players = 4;
        let game_mode: GameMode = GameMode::MultiPlayer;
    
        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);
    
        // Create a new game
        let (game, game_actions, world, _) = create_and_setup_game(
            game_mode,
            number_of_players,
            0,
            0,
            0,
            0
        );
    
        let game_id = game.id;
    
        // This should panic
        game_actions.join_game(game_id, 'purple', 'invalid_player');
    }
}

