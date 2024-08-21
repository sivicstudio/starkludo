use starkludo::models::{game::{Game, GameTrait, GameMode}};
use starknet::{ContractAddress};

#[dojo::interface]
trait IGameActions {
    fn create(
        ref world: IWorldDispatcher,
        created_by: ContractAddress,
        game_mode: GameMode,
        player_green: ContractAddress,
        player_yellow: ContractAddress,
        player_blue: ContractAddress,
        player_red: ContractAddress
    );
}

#[dojo::contract]
mod GameActions {
    use super::{IGameActions, Game, GameTrait, GameMode};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn create(
            ref world: IWorldDispatcher,
            created_by: ContractAddress,
            game_mode: GameMode,
            player_green: ContractAddress,
            player_yellow: ContractAddress,
            player_blue: ContractAddress,
            player_red: ContractAddress
        ) {
            let caller = get_caller_address();
            let new_game: Game = GameTrait::new(
                caller, game_mode, player_green, player_yellow, player_blue, player_red
            );

            set!(world, (new_game));
        }
    }
}
