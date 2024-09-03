use starkludo::models::{game::{Game, GameTrait, GameMode}};
use starknet::{ContractAddress, get_block_timestamp};
use core::poseidon::PoseidonTrait;
use core::hash::HashStateTrait;

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