use starknet::{ContractAddress};
use starkludo::models::{player::{Player, PlayerTrait}};

#[dojo::interface]
trait IPlayerActions {
    fn create(ref world: IWorldDispatcher, username: felt252);
    fn get_address_from_username(ref world: IWorldDispatcher, username: felt252) -> ContractAddress;
}

#[dojo::contract]
mod PlayerActions {
    use super::{IPlayerActions, Player, PlayerTrait};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl PlayerActionsImpl of IPlayerActions<ContractState> {
        fn create(ref world: IWorldDispatcher, username: felt252) {
            let caller = get_caller_address();

            let new_player: Player = PlayerTrait::new(username, caller);

            // Ensure player username is unique
            let mut existing_player = get!(world, username, (Player));

            assert(existing_player.owner == 0.try_into().unwrap(), 'username already taken');

            set!(world, (new_player));
        }

        fn get_address_from_username(
            ref world: IWorldDispatcher, username: felt252
        ) -> ContractAddress {
            let mut player: Player = get!(world, username, (Player));

            // Validate username
            assert(player.owner != 0.try_into().unwrap(), 'player with username not found');

            player.owner
        }
    }
}
