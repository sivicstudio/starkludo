use starknet::{ContractAddress, get_block_timestamp, contract_address_const};

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
pub enum GameStatus {
    Ongoing,
    Ended,
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
pub enum GameMode {
    SinglePlayer, // Play with computer
    MultiPlayer, // Play online with friends
}

#[derive(Drop, Copy, Serde)]
#[dojo::model]
pub struct Game {
    #[key]
    pub id: u64,
    pub created_by: ContractAddress,
    pub game_status: GameStatus,
    pub game_mode: GameMode,
    pub player_green: ContractAddress,
    pub player_yellow: ContractAddress,
    pub player_blue: ContractAddress,
    pub player_red: ContractAddress,
    pub winner_1: ContractAddress,
    pub winner_2: ContractAddress,
    pub winner_3: ContractAddress,
    pub next_player: ContractAddress,
    pub rolls_count: u256, //  Sum of all the numbers rolled by the dice
    pub rolls_times: u256, // Total number of times the dice has been rolled
    // pub player_rolls_count: LegacyMapping<ContractAddress, u256>,
}

pub trait GameTrait {
    fn new(
        created_by: ContractAddress,
        game_mode: GameMode,
        player_green: ContractAddress,
        player_yellow: ContractAddress,
        player_blue: ContractAddress,
        player_red: ContractAddress
    ) -> Game;
}

impl GameImpl of GameTrait {
    fn new(
        created_by: ContractAddress,
        game_mode: GameMode,
        player_green: ContractAddress,
        player_yellow: ContractAddress,
        player_blue: ContractAddress,
        player_red: ContractAddress
    ) -> Game {
        let zero_address = contract_address_const::<0x0>();
        Game {
            id: get_block_timestamp(),
            created_by,
            game_status: GameStatus::Ongoing,
            game_mode,
            player_green: match game_mode {
                GameMode::SinglePlayer => zero_address,
                GameMode::MultiPlayer => player_green
            },
            player_yellow: match game_mode {
                GameMode::SinglePlayer => zero_address,
                GameMode::MultiPlayer => player_yellow
            },
            player_blue: match game_mode {
                GameMode::SinglePlayer => zero_address,
                GameMode::MultiPlayer => player_blue
            },
            player_red: match game_mode {
                GameMode::SinglePlayer => zero_address,
                GameMode::MultiPlayer => player_red
            },
            next_player: zero_address,
            winner_1: zero_address,
            winner_2: zero_address,
            winner_3: zero_address,
            rolls_times: 0,
            rolls_count: 0
        }
    }
}
