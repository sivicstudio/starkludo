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
    use starknet::{testing, contract_address_const, get_caller_address, ContractAddress};

    fn create_and_setup_player(
        username: felt252
    ) -> (IPlayerActionsDispatcher, IWorldDispatcher, ContractAddress) {
        // models
        let mut models = array![player::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(["starkludo"].span(), models.span());

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', PlayerActions::TEST_CLASS_HASH.try_into().unwrap());
        let player_actions = IPlayerActionsDispatcher { contract_address };

        world.grant_writer(dojo::utils::bytearray_hash(@"starkludo"), contract_address);

        player_actions.create(username);

        (player_actions, world, contract_address)
    }

    #[test]
    fn test_player_creation() {
        // caller
        let caller = contract_address_const::<'princeibs_address'>();
        let username = 'princeibs';

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        let (_, world, _) = create_and_setup_player(username);

        let mut player = get!(world, username, Player);
        assert_eq!(player.owner, caller);
    }

    #[test]
    fn test_get_address_from_username() {
        // caller
        let caller = contract_address_const::<'princeibs_address'>();
        let username = 'princeibs';

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        let (player_actions, _world, _) = create_and_setup_player(username);

        let princeibs_address = player_actions.get_address_from_username(username);

        assert_eq!(princeibs_address, caller);
    }

    #[test]
    fn test_update_username() {
        // Get the caller
        let caller = contract_address_const::<'nuelo_address'>();
        let old_username = 'neulo';
        let new_username = 'new_nuelo';

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        let (player_actions, world, _) = create_and_setup_player(old_username);

        // Update the player owner
        let mut player = get!(world, caller, (Player));
        player.owner = caller.try_into().unwrap();
        set!(world, (player));

        // Update username
        player_actions.update_username(new_username);

        // Verify the update
        let mut player = get!(world, new_username, Player);
        assert_eq!(player.owner, caller);
        assert_eq!(player.username, new_username);
    }
}
