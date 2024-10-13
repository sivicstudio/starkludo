use starkludo::models::{game::{Game, GameTrait, GameMode}, player::{Player}};
use starknet::{ContractAddress, get_block_timestamp};
use core::poseidon::PoseidonTrait;
use core::hash::HashStateTrait;

#[dojo::interface]
trait IGameActions {
    fn create(
        ref world: IWorldDispatcher,
        created_by: ContractAddress,
        game_mode: GameMode,
        player_green: felt252,
        player_yellow: felt252,
        player_blue: felt252,
        player_red: felt252,
        number_of_players: u8
    ) -> Game;
    fn restart(ref world: IWorldDispatcher, game_id: u64);
    fn terminate_game(ref world: IWorldDispatcher, game_id: u64);
    fn invite_player(ref world: IWorldDispatcher, game_id: u64, player_username: felt252);
}

#[dojo::contract]
mod GameActions {
    // use Zero;
    // use core::num::traits::Zero;
    use core::array::ArrayTrait;
    use super::{IGameActions, Game, GameTrait, GameMode, Player};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};

    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn create(
            ref world: IWorldDispatcher,
            created_by: ContractAddress,
            game_mode: GameMode,
            player_green: felt252,
            player_yellow: felt252,
            player_blue: felt252,
            player_red: felt252,
            number_of_players: u8
        ) -> Game {
            // Get the current block timestamp
            let id = get_block_timestamp();
            // Get the account address of the caller
            let caller = get_caller_address();

            // Create a new game
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

            // Update the world state with the newly created game
            set!(world, (new_game));
            // Get the newly created game from the world
            let game_0: Game = get!(world, id, Game);
            // Return the newly created game
            game_0
        }

        fn restart(ref world: IWorldDispatcher, game_id: u64) {
            let mut game: Game = get!(world, game_id, (Game));
            game.restart();
            set!(world, (game));
        }

        fn terminate_game(ref world: IWorldDispatcher, game_id: u64) {
            let mut game: Game = get!(world, game_id, (Game));

            let players: Array<felt252> = array![
                game.player_blue, game.player_green, game.player_red, game.player_yellow,
            ];
            let mut i: u32 = 0;

            loop {
                if i > players.len() {
                    break;
                }

                let username: felt252 = *players[i];

                if !username.is_zero() {
                    let mut player: Player = get!(world, username, (Player));
                    let total_games_played = player.total_games_played;
                    player.total_games_played = total_games_played + 1;
                    set!(world, (player));
                };

                i += 1;
            };

            let winner_1 = game.winner_1;
            let mut j: u32 = 0;

            if !winner_1.is_zero() {
                loop {
                    if j > players.len() {
                        break;
                    }

                    let username: felt252 = *players[i];

                    if !username.is_zero() && username == winner_1 {
                        let mut player: Player = get!(world, username, (Player));
                        let total_games_won = player.total_games_won;
                        player.total_games_won = total_games_won + 1;
                        set!(world, (player));
                    };

                    j += 1;
                };
            }

            game.terminate_game();
            set!(world, (game));
        }

        fn invite_player(ref world: IWorldDispatcher, game_id: u64, player_username: felt252) {
            // get the caller's address
            let caller: ContractAddress = get_caller_address();

            //get the game using the game id
            let mut game: Game = get!(world, game_id, (Game));

            //ensure that caller is the game creator
            assert(game.created_by == caller, 'Cannot invite players');

            let mut player: Player = get!(world, player_username, (Player));

            assert(player.owner != 0.try_into().unwrap(), 'Player does not exist');

            // Check if the player is already part of the game
            let players = array![
                game.player_green, game.player_yellow, game.player_blue, game.player_red
            ];

            let players_span = players.span();

            //iterating through the player array checking if the player is already part of the game
            let mut i = 0;
            while i < 4 {
                assert(players_span[i] != @player_username, 'Player already in game');
                i += i;
            };

            //The player is added to the game invitations list when all checks are passed
            game.invited_players.append(player_username);

            // Update the game state in the world
            set!(world, (game));
        }
    }
}


#[derive(Drop)]
pub struct Dice {
    pub face_count: u8,
    pub seed: felt252,
    pub nonce: felt252,
}

pub trait DiceTrait {
    fn new(face_count: u8, seed: felt252) -> Dice;

    fn roll(ref self: Dice) -> u8;
}

pub impl DiceImpl of DiceTrait {
    #[inline(always)]
    fn new(face_count: u8, seed: felt252) -> Dice {
        Dice { face_count, seed, nonce: 0 }
    }

    #[inline(always)]
    fn roll(ref self: Dice) -> u8 {
        let mut state = PoseidonTrait::new();
        state = state.update(self.seed);
        state = state.update(self.nonce);
        self.nonce += 1;

        let random: u256 = state.finalize().into();
        (random % self.face_count.into() + 1).try_into().unwrap()
    }
}
