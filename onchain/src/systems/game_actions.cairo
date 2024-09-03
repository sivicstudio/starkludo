use starkludo::models::{game::{Game, GameTrait, GameMode}};
use starknet::{ContractAddress, get_block_timestamp};

#[dojo::interface]
trait IGameActions {
    fn create(
        ref world: IWorldDispatcher,
        created_by: ContractAddress,
        game_mode: GameMode,
        player_green: ContractAddress,
        player_yellow: ContractAddress,
        player_blue: ContractAddress,
        player_red: ContractAddress,
        number_of_players: u8
    ) -> Game;
    fn restart(ref world: IWorldDispatcher, game_id: u64);
}

#[dojo::contract]
mod GameActions {
    use super::{IGameActions, Game, GameTrait, GameMode};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};

    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn create(
            ref world: IWorldDispatcher,
            created_by: ContractAddress,
            game_mode: GameMode,
            player_green: ContractAddress,
            player_yellow: ContractAddress,
            player_blue: ContractAddress,
            player_red: ContractAddress,
            number_of_players: u8
        ) -> Game {
            let id = get_block_timestamp();
            let caller = get_caller_address();
            let new_game: Game = GameTrait::new(
                id,
                caller,
                game_mode,
                player_red,
                player_blue,
                player_yellow,
                player_green,
                number_of_players
            );
            set!(world, (new_game));
            let game_0: Game = get!(world, id, Game);
            game_0
        }
        fn restart(ref world: IWorldDispatcher, game_id: u64) {
            let mut game: Game = get!(world, game_id, (Game));
            game.restart();
            set!(world, (game));
        }
    }
}
