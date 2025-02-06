#[cfg(test)]
mod tests {
    use starknet::{testing, contract_address_const};
    use dojo_cairo_test::WorldStorageTestTrait;
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::{WorldStorageTrait, WorldStorage};
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef,
    };

    // Systems import
    use starkludo::systems::game_actions::{
        GameActions, IGameActionsDispatcher, IGameActionsDispatcherTrait,
    };

    // Models import
    use starkludo::models::game::{Game, m_Game, GameCounter, m_GameCounter, PlayerColor};
    use starkludo::models::player::{
        Player, m_Player, AddressToUsername, UsernameToAddress, m_AddressToUsername,
        m_UsernameToAddress,
    };

    use starkludo::models::game::{GameMode, GameStatus};
    use starkludo::errors::Errors;
    use starkludo::constants::{find_index, board_to_pos, pos_to_board, contains, pos_reducer};

    /// Defines the namespace configuration for the Starkludo game system
    /// Returns a NamespaceDef struct containing namespace name and associated resources
    fn namespace_def() -> NamespaceDef {
        // Creates a new NamespaceDef struct with:
        // Namespace name "starkludo"
        // Array of TestResource enums for models, contracts and events
        let ndef = NamespaceDef {
            namespace: "starkludo",
            resources: [
                // Register the Game model's class hash
                TestResource::Model(m_Game::TEST_CLASS_HASH),
                TestResource::Model(m_GameCounter::TEST_CLASS_HASH),
                // Register the Player model's class hash
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Model(m_AddressToUsername::TEST_CLASS_HASH),
                TestResource::Model(m_UsernameToAddress::TEST_CLASS_HASH),
                // Register the main contract containing game actions

                TestResource::Contract(GameActions::TEST_CLASS_HASH),
                // Register the GameCreated event's class hash
                TestResource::Event(GameActions::e_GameCreated::TEST_CLASS_HASH),
                TestResource::Event(GameActions::e_GameStarted::TEST_CLASS_HASH),
                TestResource::Event(GameActions::e_PlayerCreated::TEST_CLASS_HASH),
            ]
                .span() // Convert array to a Span type
        };

        // Return the namespace definition
        ndef
    }

    /// Creates a single contract definition for the "GameActions" contract
    /// Sets up write permissions for the contract using a specific hash
    /// Returns the configuration wrapped in a Span container
    fn contract_defs() -> Span<ContractDef> {
        [
            // Create a new contract definition for the StarKLudo game's actions
            // using the ContractDefTrait builder pattern
            ContractDefTrait::new(@"starkludo", @"GameActions")
                // Configure write permissions by specifying which addresses can modify the contract
                // Here, only the address derived from hashing "starkludo" has write access
                .with_writer_of([dojo::utils::bytearray_hash(@"starkludo")].span())
        ]
            .span() // Convert the array to a Span container for return
    }

    fn setup_world() -> (WorldStorage, IGameActionsDispatcher) {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"GameActions").unwrap();
        let game_action_system = IGameActionsDispatcher { contract_address };

        (world, game_action_system)
    }

    #[test]
    fn test_roll() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"GameActions").unwrap();
        let game_action_system = IGameActionsDispatcher { contract_address };

        let mut unique_rolls = ArrayTrait::new();
        let mut i: u8 = 0;
        while i < 100 {
            let (dice1, dice2) = game_action_system.roll();

            assert(dice1 <= 6, 'Dice1 Exceeded Max');
            assert(dice1 > 0, 'Dice1 Below Min');
            assert(dice2 <= 6, 'Dice2 Exceeded Max');
            assert(dice2 > 0, 'Dice2 Below Min');

            let roll_combo = dice1 * 10 + dice2;
            unique_rolls.append(roll_combo);

            i += 1;
        };

        assert(unique_rolls.len() > 1, 'Not enough unique rolls');
    }

    #[test]
    fn test_create_new_game_id() {
        let (world, game_action_system) = setup_world();
        let game_counter: GameCounter = world.read_model('v0');

        let new_game_id = game_action_system.create_new_game_id();
        let expected_new_game_id = game_counter.current_val + 1;

        assert_eq!(new_game_id, expected_new_game_id);
    }

    #[test]
    fn test_get_current_game_id() {
        let (world, game_action_system) = setup_world();
        let game_counter: GameCounter = world.read_model('v0');
        let game_counter_current_val = game_counter.current_val;

        let mut i: u64 = 0;
        let GAME_SAMPLE_SIZE: u64 = 8;
        // Create 8 game IDs
        while i < GAME_SAMPLE_SIZE {
            game_action_system.create_new_game_id();
            i += 1;
        };

        let current_game_id = game_action_system.get_current_game_id();
        let expected_game_counter_id = game_counter_current_val + GAME_SAMPLE_SIZE;

        assert_eq!(current_game_id, expected_game_counter_id);
    }

    #[test]
    #[should_panic(expected: ('USERNAME ALREADY TAKEN', 'ENTRYPOINT_FAILED'))]
    fn test_create_new_player_should_panic_if_username_already_exist() {
        let (_, game_action_system) = setup_world();
        let caller_1 = contract_address_const::<'ibs'>();
        let caller_2 = contract_address_const::<'dreamer'>();
        let username = 'ibs';

        testing::set_contract_address(caller_1);
        game_action_system.create_new_player(username, false);

        testing::set_contract_address(caller_2);
        game_action_system.create_new_player(username, false);
    }

    #[test]
    #[should_panic(expected: ('USERNAME ALREADY CREATED', 'ENTRYPOINT_FAILED'))]
    fn test_create_new_player_should_fail_panic_username_already_created() {
        let (_, game_action_system) = setup_world();
        let caller = contract_address_const::<'ibs'>();
        let username = 'ibs';
        let username1 = 'dreamer';

        testing::set_contract_address(caller);
        // Player create username for the first time
        game_action_system.create_new_player(username, false);
        // Player attempts to create another username for the second time
        game_action_system.create_new_player(username1, false);
    }

    #[test]
    fn test_create_new_player_is_successful() {
        let (world, game_action_system) = setup_world();
        let caller = contract_address_const::<'ibs'>();
        let username = 'ibs';

        testing::set_contract_address(caller);
        game_action_system.create_new_player(username, false);

        let created_player: Player = world.read_model(username);
        assert_eq!(created_player.owner, caller);

        let username_to_address: UsernameToAddress = world.read_model(username);
        assert_eq!(username_to_address.address, caller);

        let address_to_username: AddressToUsername = world.read_model(caller);
        assert_eq!(address_to_username.username, username);
    }

    #[test]
    fn test_get_username_from_address() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"GameActions").unwrap();
        let game_action_system = IGameActionsDispatcher { contract_address };

        let test_address1 = starknet::contract_address_const::<'test_user1'>();
        let test_address2 = starknet::contract_address_const::<'test_user2'>();
        let username1: felt252 = 'alice';
        let username2: felt252 = 'bob';

        let address_to_username1 = AddressToUsername {
            address: test_address1, username: username1,
        };
        let address_to_username2 = AddressToUsername {
            address: test_address2, username: username2,
        };

        world.write_model(@address_to_username1);
        world.write_model(@address_to_username2);

        let retrieved_username1 = game_action_system.get_username_from_address(test_address1);
        let retrieved_username2 = game_action_system.get_username_from_address(test_address2);

        assert(retrieved_username1 == username1, 'Wrong username for address1');
        assert(retrieved_username2 == username2, 'Wrong username for address2');

        let non_existent_address = starknet::contract_address_const::<'non_existent'>();
        let retrieved_username3 = game_action_system
            .get_username_from_address(non_existent_address);
        assert(retrieved_username3 == 0, 'Non-existent should return 0');
    }

    #[test]
    fn test_get_address_from_username() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"GameActions").unwrap();
        let game_action_system = IGameActionsDispatcher { contract_address };

        let bob_address = starknet::contract_address_const::<'bob'>();
        let alice_address = starknet::contract_address_const::<'alice'>();
        let bob_username: felt252 = 'bob';
        let alice_username: felt252 = 'alice';

        let address_to_username1 = UsernameToAddress {
            username: bob_username, address: bob_address,
        };
        let address_to_username2 = UsernameToAddress {
            username: alice_username, address: alice_address,
        };

        world.write_model(@address_to_username1);
        world.write_model(@address_to_username2);

        let address_1 = game_action_system.get_address_from_username(bob_username);
        let address_2 = game_action_system.get_address_from_username(alice_username);

        assert(address_1 == bob_address, 'Wrong address 1');
        assert(address_2 == alice_address, 'Wrong address 2');

        let non_existent_address = starknet::contract_address_const::<'non_existent'>();
        let retrieved_username3 = game_action_system
            .get_username_from_address(non_existent_address);
        assert(retrieved_username3 == 0, 'Non-existent should return 0');
    }

    #[test]
    #[should_panic(expected: ('PLAYERS CAN ONLY BE 2, 3, OR 4', 'ENTRYPOINT_FAILED'))]
    fn test_create_new_game_invalid_player_count() {
        let (_, game_action_system) = setup_world();
        let caller = contract_address_const::<'test_gamer'>();
        let username = 'gamer';
        let no_of_players: u8 = 1;

        testing::set_contract_address(caller);
        game_action_system.create_new_player(username, false);

        game_action_system.create_new_game(GameMode::MultiPlayer, PlayerColor::Blue, no_of_players);
    }

    #[test]
    #[should_panic(expected: ('PLAYER NOT REGISTERED', 'ENTRYPOINT_FAILED'))]
    fn test_create_new_game_unregistered_player() {
        let (_, game_action_system) = setup_world();
        let unregistered_caller = contract_address_const::<'unregistered'>();
        let no_of_players: u8 = 2;

        testing::set_contract_address(unregistered_caller);
        // Try to create game without registering first
        game_action_system
            .create_new_game(GameMode::SinglePlayer, PlayerColor::Blue, no_of_players);
    }

    #[test]
    fn test_create_new_game_successful() {
        let (world, game_action_system) = setup_world();
        let caller = contract_address_const::<'test_gamer'>();
        let username = 'gamer';
        let no_of_players: u8 = 3;

        testing::set_contract_address(caller);
        game_action_system.create_new_player(username, false);

        let game_id = game_action_system
            .create_new_game(GameMode::SinglePlayer, PlayerColor::Blue, no_of_players);

        let created_game: Game = world.read_model(game_id);

        assert(created_game.is_initialised == true, 'Game should be initialized');
        assert(created_game.created_by == username, 'Wrong game creator');
        assert(created_game.mode == GameMode::SinglePlayer, 'Wrong game mode');
        assert(created_game.number_of_players == 3, 'Wrong number of players');
        assert(created_game.player_blue == username, 'Wrong player color assignment');
        assert(created_game.player_red == 0, 'Red should not be assigned');
        assert(created_game.status == GameStatus::Initialised, 'Wrong game status');
    }

    #[test]
    fn test_create_new_game_increments_id() {
        let (_, game_action_system) = setup_world();
        let caller = contract_address_const::<'test_gamer'>();
        let username = 'gamer';

        testing::set_contract_address(caller);
        game_action_system.create_new_player(username, false);

        let first_game_id = game_action_system
            .create_new_game(GameMode::MultiPlayer, PlayerColor::Blue, 2);

        let second_game_id = game_action_system
            .create_new_game(GameMode::SinglePlayer, PlayerColor::Green, 4);

        assert(second_game_id == first_game_id + 1, 'Game ID should increment');
    }

    #[test]
    fn test_find_index() {
        let array = array!['a', 'b', 'c', 'd'];
        let index = find_index('c', array.clone());
        assert(index == 2, 'Index should be 2');

        let index = find_index('e', array.clone());
        assert(index == 0, 'Index should be 0');
    }

    #[test]
    fn test_board_to_pos1() {
        let board_positions = array![0, 13, 26, 1001, 52, 40, 2001, 2002, 3003, 34, 2, 12, 4004];
        let expected_positions = array![0, 13, 26, 52, 39, 27, 52, 53, 54, 8, 28, 38, 55];
        let positions = board_to_pos(board_positions);
        assert(positions == expected_positions, 'Board to pos failed');
    }

    #[test]
    fn test_pos_to_board() {
        let positions = array![0, 13, 26, 52, 39, 27, 52, 53, 54, 8, 28, 38, 55];
        let expected_board_positions = array![
            0, 13, 26, 1001, 52, 40, 2001, 2002, 3003, 34, 2, 12, 4004,
        ];
        let board_positions = pos_to_board(positions);
        assert(board_positions == expected_board_positions, 'Pos to board failed');
    }

    #[test]
    fn test_contains() {
        let array = array![1, 2, 3, 4, 5];
        assert(contains(array.clone(), 3), 'Array should contain 3');
        assert(!contains(array.clone(), 6), 'Array should not contain 6');
    }

    #[test]
    fn test_pos_reducer() {
        let data = array![0, 1001, 23, 32, 2001, 2006, 23, 43, 12, 3006];
        let players_length = 2;
        let expected_output = array![8201, 82001, 23, 32, 71001, 71006, 23, 43];
        let output = pos_reducer(data, players_length);
        assert(output == expected_output, 'Pos reducer failed');
    }

    #[test]
    fn test_move_deducer() {
        let (_, game_action_system) = setup_world();

        // Test case 1: val == 0 and dice_throw == 6
        let (new_val, is_chance, is_thrown) = game_action_system.move_deducer(0, 6);
        assert(new_val == 1, 'New value should be 1');
        assert(!is_chance, 'is_chance should be false');
        assert(!is_thrown, 'is_thrown should be false');

        // Test case 2: val == 0 and dice_throw != 6
        let (new_val, is_chance, is_thrown) = game_action_system.move_deducer(0, 5);
        assert(new_val == 0, 'New value should be 0');
        assert(is_chance, 'is_chance should be true');
        assert(is_thrown, 'is_thrown should be true');

        // Test case 3: val != 0 and val + dice_throw <= 57
        let (new_val, is_chance, is_thrown) = game_action_system.move_deducer(10, 5);
        assert(new_val == 15, 'New value should be 15');
        assert(!is_chance, 'is_chance should be false');
        assert(!is_thrown, 'is_thrown should be false');

        // Test case 4: val != 0 and val + dice_throw > 57
        let (new_val, is_chance, is_thrown) = game_action_system.move_deducer(55, 5);
        assert(new_val == 55, 'New value should be 55');
        assert(is_chance, 'is_chance should be true');
        assert(!is_thrown, 'is_thrown should be false');

        // Test case 5: val != 0 and val + dice_throw == 57
        let (new_val, is_chance, is_thrown) = game_action_system.move_deducer(52, 5);
        assert(new_val == 57, 'New value should be 57');
        assert(is_chance, 'is_chance should be true');
        assert(!is_thrown, 'is_thrown should be false');
    }

    #[test]
    fn test_move_initial_position_with_six() {
        // This test case verifies that a piece can move from its initial position when the dice
        // roll is 6.

        let (mut world, game_action_system) = setup_world();

        let caller = contract_address_const::<'test_alice'>();
        let username = 'alice';

        testing::set_contract_address(caller);
        game_action_system.create_new_player(username, false);

        // Setup initial game state
        let game_id = game_action_system
            .create_new_game(GameMode::MultiPlayer, PlayerColor::Red, 2);

        let mut game: Game = world.read_model(game_id);

        game.dice_face = 6;

        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);

        // Move piece from initial position with dice throw 6
        game_action_system.move('r0', 0);

        let game: Game = world.read_model(game_id);

        let game_condition = array![1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

        assert(game.r0 == 1, 'Piece should move to 1');
        assert(game.game_condition == game_condition, 'Game Condition should match');
    }

    #[test]
    fn test_move_initial_position_without_six() {
        // This test case verifies that a piece cannot move from its initial position if the dice
        // roll is not 6.

        let (mut world, game_action_system) = setup_world();

        let caller = contract_address_const::<'test_alice'>();
        let username = 'alice';

        testing::set_contract_address(caller);
        game_action_system.create_new_player(username, false);

        // Setup initial game state
        let game_id = game_action_system
            .create_new_game(GameMode::MultiPlayer, PlayerColor::Red, 2);

        let mut game: Game = world.read_model(game_id);

        game.dice_face = 5;

        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('r0', 0);

        // Verify the new position
        let game: Game = world.read_model(game_id);

        let game_condition = array![0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

        assert(game.r0 == 8201, 'Piece should not move');
        assert(game.game_condition == game_condition, 'Game Condition should match');
    }

    #[test]
    fn test_move_normal_position() {
        // This test case verifies that a piece can move from a normal position based on the dice
        // roll.

        let (mut world, game_action_system) = setup_world();
        let caller = contract_address_const::<'test_alice'>();
        let username = 'alice';

        testing::set_contract_address(caller);
        game_action_system.create_new_player(username, false);

        // Setup initial game state
        let game_id = game_action_system
            .create_new_game(GameMode::MultiPlayer, PlayerColor::Red, 2);

        let mut game: Game = world.read_model(game_id);
        game.dice_face = 6;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('r1', 0); // move from its initial position to 1.

        let mut game: Game = world.read_model(game_id);
        game.dice_face = 5;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('r1', 0); // move from 1 to 6.

        // Verify the new position
        let game: Game = world.read_model(game_id);

        let game_condition = array![0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

        assert(game.r1 == 6, 'Piece should move to 6');
        assert(game.game_condition == game_condition, 'Game Condition should match');
    }

    #[test]
    fn test_move_to_safe_position() {
        // This test case verifies that a piece can move to a safe position on the board.

        let (mut world, game_action_system) = setup_world();
        let caller = contract_address_const::<'test_alice'>();
        let username = 'alice';

        testing::set_contract_address(caller);
        game_action_system.create_new_player(username, false);

        // Setup initial game state
        let game_id = game_action_system
            .create_new_game(GameMode::MultiPlayer, PlayerColor::Green, 2);

        let mut game: Game = world.read_model(game_id);
        game.dice_face = 6;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('g1', 1); // move from its initial position to 14.

        let mut game: Game = world.read_model(game_id);
        game.dice_face = 5;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('g1', 1); // move from 14 to 19.

        let mut game: Game = world.read_model(game_id);
        game.dice_face = 3;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('g1', 1); // move from 19 to 22.

        // Verify the new position
        let game: Game = world.read_model(game_id);
        let game_condition = array![0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

        assert(game.g1 == 22, 'Piece should move to 22');
        assert(game.game_condition == game_condition, 'Game Condition should match');
    }

    #[test]
    fn test_move_to_occupied_position() {
        //  This test case verifies that a piece can move to an occupied position on the board.

        let (mut world, game_action_system) = setup_world();
        let caller = contract_address_const::<'test_alice'>();
        let username = 'alice';

        testing::set_contract_address(caller);
        game_action_system.create_new_player(username, false);

        // Setup initial game state
        let game_id = game_action_system
            .create_new_game(GameMode::MultiPlayer, PlayerColor::Green, 2);

        let mut game: Game = world.read_model(game_id);
        game.dice_face = 6;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('g1', 1); // move g1 from its initial position to 14.

        let mut game: Game = world.read_model(game_id);
        game.dice_face = 6;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('g2', 1); // move g2 from its initial position to 14.

        let mut game: Game = world.read_model(game_id);
        game.dice_face = 5;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('g1', 1); // move from 14 to 19.

        let mut game: Game = world.read_model(game_id);
        game.dice_face = 5;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('g2', 1); // move from 14 to 19.

        // Verify the new position
        let game: Game = world.read_model(game_id);
        let game_condition = array![0, 0, 0, 0, 0, 19, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0];

        assert(game.g1 == game.g2, 'Both pieces must align');
        assert(game.game_condition == game_condition, 'Game Condition should match');
    }

    #[test]
    fn test_capture_opponent_piece() {
        // This test case verifies the capturing mechanism in the game

        let (mut world, game_action_system) = setup_world();

        let caller_red = contract_address_const::<'test_red'>();
        let username_red = 'red';

        testing::set_contract_address(caller_red);
        game_action_system.create_new_player(username_red, false);

        // Setup initial game state
        let game_id = game_action_system
            .create_new_game(GameMode::MultiPlayer, PlayerColor::Red, 2);

        let mut game: Game = world.read_model(game_id);
        game.game_condition = array![13, 0, 0, 0, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        game.r0 = 13;
        game.g0 = 15;
        game.dice_face = 2;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);

        game = world.read_model(game_id);

        assert(game.r0 == 13, 'Red piece should be at 13');
        assert(game.g0 == 15, 'Green piece should be at 15');

        // Verify the game condition
        let game_condition = array![13, 0, 0, 0, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        assert(game.game_condition == game_condition, 'Game Condition should match');

        // Move red piece to position 15
        game_action_system.move('r0', 0);

        // Verify the new positions
        game = world.read_model(game_id);

        assert(game.r0 == 15, 'Red piece should move to 15');
        assert(game.g0 == 7101, 'Green piece should be captured');

        // Verify the game condition
        let game_condition = array![15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        assert(game.game_condition == game_condition, 'Game Condition should match');
    }

    #[test]
    fn test_capture_opponent_piece_in_safe_zone() {
        // This test case verifies that a player cannot capture an opponent's piece in the safe zone

        let (mut world, game_action_system) = setup_world();

        let caller_red = contract_address_const::<'test_red'>();
        let username_red = 'red';

        testing::set_contract_address(caller_red);
        game_action_system.create_new_player(username_red, false);

        // Setup initial game state
        let game_id = game_action_system
            .create_new_game(GameMode::MultiPlayer, PlayerColor::Red, 2);

        let mut game: Game = world.read_model(game_id);
        game.game_condition = array![13, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        game.r0 = 13;
        game.g0 = 14;
        game.dice_face = 1;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);

        game = world.read_model(game_id);

        assert(game.r0 == 13, 'Red piece should be at 13');
        assert(game.g0 == 14, 'Green piece should be at 14');

        // Verify the game condition
        let game_condition = array![13, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        assert(game.game_condition == game_condition, 'Game Condition should match');

        game_action_system.move('r0', 0);

        // Verify the new positions
        game = world.read_model(game_id);

        assert(game.r0 == 14, 'Red piece should remain at 14');
        assert(game.g0 == 14, 'Green piece should remain at 14');

        // Verify the game condition
        let game_condition = array![14, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        assert(game.game_condition == game_condition, 'Game Condition should match');
    }

    #[test]
    fn test_red_player_wins() {
        // This test case verifies the winning condition in the game.

        let (mut world, game_action_system) = setup_world();

        let caller_red = contract_address_const::<'test_red'>();
        let username_red = 'red';

        testing::set_contract_address(caller_red);
        game_action_system.create_new_player(username_red, false);

        // Setup initial game state
        let game_id = game_action_system
            .create_new_game(GameMode::MultiPlayer, PlayerColor::Red, 2);

        // Move red piece to position 56 (one step away from winning)
        let mut game: Game = world.read_model(game_id);
        game.game_condition = array![1006, 1006, 1006, 1003, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        game.dice_face = 3;
        testing::set_contract_address(game_action_system.contract_address);
        world.write_model(@game);
        game_action_system.move('r3', 0);

        // Verify the new positions and winning state
        game = world.read_model(game_id);

        assert(game.r3 == 82006, 'piece should move to win pos');
        assert(game.winner_1 == game.player_red, 'Red should be the winner');

        // Verify the game condition
        let game_condition = array![1006, 1006, 1006, 1006, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        assert(game.game_condition == game_condition, 'Game Condition should match');
    }
}
