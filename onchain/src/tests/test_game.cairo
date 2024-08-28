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
    use starknet::{testing, contract_address_const, get_caller_address};

    #[test]
    fn test_game_creation() {
        // caller
        let caller = contract_address_const::<'ibs'>();
        let player_red = contract_address_const::<'player_red'>();
        let player_blue = contract_address_const::<'player_blue'>();
        let player_yellow = contract_address_const::<'player_yellow'>();

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        let mut models = array![game::TEST_CLASS_HASH];
        let world = spawn_test_world(["starkludo"].span(), models.span());
        let contract_address = world
            .deploy_contract('salt', GameActions::TEST_CLASS_HASH.try_into().unwrap());
        let game_actions = IGameActionsDispatcher { contract_address };
        world.grant_writer(dojo::utils::bytearray_hash(@"starkludo"), contract_address);

        game_actions
            .create(
                caller, GameMode::SinglePlayer, caller, player_yellow, player_blue, player_red, 4
            );

        let mut game = get!(world, 0, Game);

        println!("{:?}", game.b0);
    }
}
