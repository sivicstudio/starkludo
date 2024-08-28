#[cfg(test)]
mod tests {
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::utils::test::{spawn_test_world, deploy_contract};
    // import test utils
    use starkludo::{
        systems::{
            player_actions::{PlayerActions, IPlayerActionsDispatcher, IPlayerActionsDispatcherTrait}
        },
        models::player::{Player, player}
    };
    use starknet::{testing, contract_address_const, get_caller_address};

    #[test]
    fn test_player_creation() {
        // caller
        let caller = contract_address_const::<'ibs'>();

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        // models
        let mut models = array![player::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(["starkludo"].span(), models.span());

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', PlayerActions::TEST_CLASS_HASH.try_into().unwrap());
        let player_actions = IPlayerActionsDispatcher { contract_address };

        world.grant_writer(dojo::utils::bytearray_hash(@"starkludo"), contract_address);

        player_actions.create('princeibs');

        let mut player = get!(world, 'princeibs', Player);

        assert_eq!(player.owner, caller);
    }
}
