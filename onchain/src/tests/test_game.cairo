#[cfg(test)]
mod tests {
    use starknet::{testing, contract_address_const};
    use dojo_cairo_test::WorldStorageTestTrait;
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::{WorldStorageTrait, WorldStorage};
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef
    };

    // Systems import
    use starkludo::systems::game_actions::{
        GameActions, IGameActionsDispatcher, IGameActionsDispatcherTrait
    };

    // Models import
    use starkludo::models::game::{Game, m_Game, GameCounter, m_GameCounter, PlayerColor};
    use starkludo::models::player::{
        Player, m_Player, AddressToUsername, UsernameToAddress, m_AddressToUsername,
        m_UsernameToAddress
    };

    use starkludo::models::game::{GameMode, GameStatus};
    use starkludo::errors::Errors;

    /// Defines the namespace configuration for the Starkludo game system
    /// Returns a NamespaceDef struct containing namespace name and associated resources
    fn namespace_def() -> NamespaceDef {
        // Creates a new NamespaceDef struct with:
        // Namespace name "starkludo"
        // Array of TestResource enums for models, contracts and events
        let ndef = NamespaceDef {
            namespace: "starkludo", resources: [
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
            ].span() // Convert array to a Span type
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
        ].span() // Convert the array to a Span container for return
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
    #[should_panic(expected: ('USERNAME ALREADY TAKEN', 'ENTRYPOINT_FAILED',))]
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
    #[should_panic(expected: ('USERNAME ALREADY CREATED', 'ENTRYPOINT_FAILED',))]
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
    fn test_create_bot_player_is_successful() {
        let (_, game_action_system) = setup_world();

        let blue_color = PlayerColor::Blue;
        let green_color = PlayerColor::Green;
        let red_color = PlayerColor::Red;
        let yellow_color = PlayerColor::Yellow;

        let created_blue_bot_player: Player = game_action_system.create_bot_player(blue_color);
        let expected_blue_username = 'blue_bot';
        let expected_blue_address = starknet::contract_address_const::<'blue_bot'>();
        assert_eq!(created_blue_bot_player.username, expected_blue_username);
        assert_eq!(created_blue_bot_player.owner, expected_blue_address);
        assert_eq!(created_blue_bot_player.is_bot, true);

        let created_green_bot_player: Player = game_action_system.create_bot_player(green_color);
        let expected_green_username = 'green_bot';
        let expected_green_address = starknet::contract_address_const::<'green_bot'>();
        assert_eq!(created_green_bot_player.username, expected_green_username);
        assert_eq!(created_green_bot_player.owner, expected_green_address);
        assert_eq!(created_green_bot_player.is_bot, true);

        let created_red_bot_player: Player = game_action_system.create_bot_player(red_color);
        let expected_red_username = 'red_bot';
        let expected_red_address = starknet::contract_address_const::<'red_bot'>();
        assert_eq!(created_red_bot_player.username, expected_red_username);
        assert_eq!(created_red_bot_player.owner, expected_red_address);
        assert_eq!(created_red_bot_player.is_bot, true);

        let created_yellow_bot_player: Player = game_action_system.create_bot_player(yellow_color);
        let expected_yellow_username = 'yellow_bot';
        let expected_yellow_address = starknet::contract_address_const::<'yellow_bot'>();
        assert_eq!(created_yellow_bot_player.username, expected_yellow_username);
        assert_eq!(created_yellow_bot_player.owner, expected_yellow_address);
        assert_eq!(created_yellow_bot_player.is_bot, true);
    }

    #[test]
    fn test_create_existing_bot_player() {
        let (_, game_action_system) = setup_world();

        let blue_color = PlayerColor::Blue;
        let created_blue_bot_player: Player = game_action_system.create_bot_player(blue_color);

        let expected_blue_username = 'blue_bot';
        let expected_blue_address = starknet::contract_address_const::<'blue_bot'>();
        assert_eq!(created_blue_bot_player.username, expected_blue_username);
        assert_eq!(created_blue_bot_player.owner, expected_blue_address);
        assert_eq!(created_blue_bot_player.is_bot, true);

        let existing_blue_bot_player: Player = game_action_system.create_bot_player(blue_color);

        assert_eq!(existing_blue_bot_player.username, expected_blue_username);
        assert_eq!(existing_blue_bot_player.owner, expected_blue_address);
        assert_eq!(existing_blue_bot_player.is_bot, true);
        assert_eq!(created_blue_bot_player.owner, existing_blue_bot_player.owner);
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
            address: test_address1, username: username1
        };
        let address_to_username2 = AddressToUsername {
            address: test_address2, username: username2
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
}
