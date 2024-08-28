#[cfg(test)]
mod tests {
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::utils::test::{spawn_test_world, deploy_contract};
    // import test utils
    use starkludo::{
        systems::{game_actions::{GameActions, IGameActionsDispatcher, IGameActionsDispatcherTrait}},
        models::game::{Game, game, GameMode},
    };
    use starknet::{testing, contract_address_const, get_caller_address, ContractAddress};

    fn create_and_setup_game(
        game_mode: GameMode,
        number_of_players: u8,
        player_red: ContractAddress,
        player_blue: ContractAddress,
        player_yellow: ContractAddress,
        player_green: ContractAddress,
    ) -> (Game, IGameActionsDispatcher, IWorldDispatcher, ContractAddress,) {
        let caller = get_caller_address();
        let mut models = array![game::TEST_CLASS_HASH];
        let world = spawn_test_world(["starkludo"].span(), models.span());
        let contract_address = world
            .deploy_contract('salt', GameActions::TEST_CLASS_HASH.try_into().unwrap());
        let game_actions = IGameActionsDispatcher { contract_address };
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

        let player_red = contract_address_const::<'player_red'>();
        let player_blue = contract_address_const::<'player_blue'>();
        let player_yellow = contract_address_const::<'player_yellow'>();
        let player_green = contract_address_const::<'player_green'>();
        let number_of_players = 4;
        let game_mode: GameMode = GameMode::MultiPlayer;

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        let (game, _, _, _) = create_and_setup_game(
            game_mode, number_of_players, player_red, player_blue, player_yellow, player_green
        );

        assert_eq!(game.created_by, caller);
        // assert_eq!(game.game_mode, game_mode);
        assert_eq!(game.player_red, player_red);
        assert_eq!(game.player_blue, player_blue);
        assert_eq!(game.player_yellow, player_yellow);
        assert_eq!(game.player_green, player_green);
    }
    // TODO: Test number of players
// TODO: Test game mode
}
