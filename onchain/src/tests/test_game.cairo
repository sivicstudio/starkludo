pub mod Errors {
    pub const WRONG_DICE_VALUE: felt252 = 'Wrong dice value';
    pub const WRONG_DICE_NONCE: felt252 = 'Wrong dice nonce';
    pub const INVALID_PLAYER: felt252 = 'Player was not invited';
}

#[cfg(test)]
mod tests {
    use super::Errors;
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
        assert(dice.roll() == 1, Errors::WRONG_DICE_VALUE);
        assert(dice.roll() == 6, Errors::WRONG_DICE_VALUE);
        assert(dice.roll() == 3, Errors::WRONG_DICE_VALUE);
        assert(dice.roll() == 1, Errors::WRONG_DICE_VALUE);
        assert(dice.roll() == 4, Errors::WRONG_DICE_VALUE);
        assert(dice.roll() == 3, Errors::WRONG_DICE_VALUE);
    }

    #[test]
    fn test_dice_new_roll_overflow() {
        let mut dice = DiceTrait::new(DICE_FACE_COUNT, DICE_SEED);
        dice.nonce = 0x800000000000011000000000000000000000000000000000000000000000000;
        dice.roll();
        assert(dice.nonce == 0, Errors::WRONG_DICE_NONCE);
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
    #[ignore]
    fn test_invite_player() {
        let caller = contract_address_const::<'Collins'>(); // The game creator
        let player_red = 'player_red';
        let player_blue = 'player_blue';
        let player_yellow = 'player_yellow';
        let player_green = 'player_green';
        let number_of_players = 4;
        let game_mode: GameMode = GameMode::MultiPlayer;

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        // Creating and setting up a new game
        let (mut game, game_actions, world, _) = create_and_setup_game(
            game_mode, number_of_players, player_red, player_blue, player_yellow, player_green
        );

        let game_id: u64 = game.id;
        let new_player = 'player_orange';

        // Inviting a new player to the game
        game_actions.invite_player(game_id, new_player);

        // Retrieving the game and checking if the invited player has been added to the
        // invited_players array
        game = get!(world, game_id, Game);
        // Manual check if the new player is in the invited_players array using a custom contains
    // method
    // let is_player_invited = contains(game.invited_players, new_player.into());

        // // Assert that the player was invited. if false then player was not invited
    // assert(is_player_invited, Errors::INVALID_PLAYER);
    }
}

