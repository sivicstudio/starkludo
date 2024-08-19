use starkludo::models::{game::{Game, GameTrait}};

#[dojo::interface]
trait IPlayerActions {
    fn create(ref world: IWorldDispatcher, username: felt252);
}

#[dojo::contract]
mod PlayerActions {
    use super::{IPlayerActions, Player, PlayerTrait};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl PlayerActionsImpl of IPlayerActions<ContractState> {
        fn create(ref world: IWorldDispatcher, username: felt252) {
            let caller = get_caller_address();

            let new_player: Player = PlayerTrait::spawn(username, caller);

            // Ensure player username is unique
            let mut existing_player = get!(world, username, (Player));

            assert(existing_player.owner == 0.try_into().unwrap(), 'username already taken');

            set!(world, (new_player));
        }
    }
}
