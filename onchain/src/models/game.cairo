use starknet::{ContractAddress, get_block_timestamp, contract_address_const};
use super::constants::TileNode;

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

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
pub enum PiecePosition {
    SinglePlayer, // Play with computer
    MultiPlayer, // Play online with friends
}

#[derive(Drop, Serde)]
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
    pub number_of_players: u8,
    pub rolls_count: u256, //  Sum of all the numbers rolled by the dice
    pub rolls_times: u256, // Total number of times the dice has been rolled
    pub dice_face: u8,
    pub player_chance: ContractAddress,
    pub has_thrown_dice: bool,
    pub b0: felt252,
    pub b1: felt252,
    pub b2: felt252,
    pub b3: felt252,
    pub g0: felt252,
    pub g1: felt252,
    pub g2: felt252,
    pub g3: felt252,
    pub r0: felt252,
    pub r1: felt252,
    pub r2: felt252,
    pub r3: felt252,
    pub y0: felt252,
    pub y1: felt252,
    pub y2: felt252,
    pub y3: felt252,
}

pub trait GameTrait {
    fn new(
        created_by: ContractAddress,
        game_mode: GameMode,
        player_green: ContractAddress,
        player_yellow: ContractAddress,
        player_blue: ContractAddress,
        player_red: ContractAddress,
        number_of_players: u8
    ) -> Game;
}

impl GameImpl of GameTrait {
    fn new(
        created_by: ContractAddress,
        game_mode: GameMode,
        player_green: ContractAddress,
        player_yellow: ContractAddress,
        player_blue: ContractAddress,
        player_red: ContractAddress,
        number_of_players: u8
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
            rolls_count: 0,
            number_of_players,
            dice_face: 0,
            player_chance: zero_address,
            has_thrown_dice: false,
            b0: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 'B01',
                3 => 'B01',
                4 => 'B01',
                _ => panic!("invalid number of players")
            },
            b1: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 'B02',
                3 => 'B02',
                4 => 'B02',
                _ => panic!("invalid number of players")
            },
            b2: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 'B03',
                3 => 'B03',
                4 => 'B03',
                _ => panic!("invalid number of players")
            },
            b3: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 'B04',
                3 => 'B04',
                4 => 'B04',
                _ => panic!("invalid number of players")
            },
            g0: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 'G01',
                3 => 'G01',
                4 => 'G01',
                _ => panic!("invalid number of players")
            },
            g1: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 'G02',
                3 => 'G02',
                4 => 'G02',
                _ => panic!("invalid number of players")
            },
            g2: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 'G03',
                3 => 'G03',
                4 => 'G03',
                _ => panic!("invalid number of players")
            },
            g3: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 'GO4',
                3 => 'GO4',
                4 => 'GO4',
                _ => panic!("invalid number of players")
            },
            r0: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 0,
                3 => 'R01',
                4 => 'R01',
                _ => panic!("invalid number of players")
            },
            r1: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 0,
                3 => 'R02',
                4 => 'R02',
                _ => panic!("invalid number of players")
            },
            r2: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 0,
                3 => 'R03',
                4 => 'R03',
                _ => panic!("invalid number of players")
            },
            r3: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 0,
                3 => 'R04',
                4 => 'R04',
                _ => panic!("invalid number of players")
            },
            y0: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 0,
                3 => 0,
                4 => 'Y01',
                _ => panic!("invalid number of players")
            },
            y1: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 0,
                3 => 0,
                4 => 'Y02',
                _ => panic!("invalid number of players")
            },
            y2: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 0,
                3 => 0,
                4 => 'Y03',
                _ => panic!("invalid number of players")
            },
            y3: match number_of_players {
                0 => panic!("number of players cannot be 0"),
                1 => panic!("number of players cannot be 1"),
                2 => 0,
                3 => 0,
                4 => 'Y04',
                _ => panic!("invalid number of players")
            },
        }
    }
}
