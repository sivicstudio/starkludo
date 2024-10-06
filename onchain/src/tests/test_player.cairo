pub mod Errors {
    pub const INCORRECT_GAME_PLAYED: felt252 = 'Incorrect games played';
    pub const INCORRECT_GAME_WON: felt252 = 'Incorrect games won';
    pub const INCORRECT_TOTAL_POINTS: felt252 = 'Incorrect total points';
    pub const INCORRECT_LEADBOARD_POSITION: felt252 = 'Incorrect leaderboard position';
}

#[cfg(test)]
mod tests {
    use super::Errors;
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
    #[should_panic(expected: ('Cannot create from zero address', 'ENTRYPOINT_FAILED',))]
    fn test_cannot_create_player_from_zero_address() {
        // caller
        let zero_address: ContractAddress = contract_address_const::<0x0>();
        let username = 'princeibs';

        testing::set_account_contract_address(zero_address);
        testing::set_contract_address(zero_address);

        let (_, _, _) = create_and_setup_player(username);
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
    fn test_get_player_stats() {
        // caller
        let caller = contract_address_const::<'fishon_address'>();

        testing::set_account_contract_address(caller);
        testing::set_contract_address(caller);

        let username = 'fishon';
        let (player_actions, world, _) = create_and_setup_player(username);

        // Test modification of the player's stats
        let mut player: Player = get!(world, username, Player);
        player.total_games_played = 10;
        player.total_games_won = 5;
        set!(world, (player));

        // Get the player's stats
        let (games_played, games_won, total_points, leaderboard_position) = player_actions
            .get_player_stats(username);
   
        assert_eq!(games_played, 10, "{}", Errors::INCORRECT_GAME_PLAYED);
        assert_eq!(games_won, 5, "{}", Errors::INCORRECT_GAME_WON);
        assert_eq!(total_points, 5, "{}", Errors::INCORRECT_TOTAL_POINTS);
        assert_eq!(leaderboard_position, 0, "{}", Errors::INCORRECT_LEADBOARD_POSITION);
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
        let mut player: Player = get!(world, old_username, Player);

        assert_eq!(player.username, old_username);

        // Update username
        player_actions.update_username(new_username, old_username);

        set!(world, (player));

        let new_player: Player = get!(world, new_username, Player);

        assert_eq!(new_player.username, new_username);
    }
}
