use starknet::{ContractAddress, get_block_timestamp, contract_address_const};
use starkludo::models::player::{Player};

// Represents the status of the game
// Can either be Ongoing or Ended
#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum GameStatus {
    Initialised,
    Pending,
    Ongoing,
    Waiting,
    Ended,
}

// Represents the game mode
// Can either be SinglePlayer or Multiplayer
#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
pub enum GameMode {
    SinglePlayer, // Play with computer
    MultiPlayer, // Play online with friends
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
pub enum PlayerColor {
    Green,
    Yellow,
    Blue,
    Red
}

// Game model
// Keeps track of the state of the game
#[derive(Drop, Serde)]
#[dojo::model]
pub struct Game {
    #[key]
    pub id: u64, // Unique id of the game
    pub created_by: felt252, // Address of the game creator
    pub is_initialised: bool, // Indicate whether game with given Id has been created/initialised
    pub status: GameStatus, // Status of the game
    pub mode: GameMode, // Mode of the game
    pub ready_to_start: bool, // Indicate whether game can be started
    pub player_green: felt252, // Player contract address
    pub player_yellow: felt252, // Player contract address
    pub player_blue: felt252, // Player contract address
    pub player_red: felt252, // Player contract address
    pub winner_1: felt252, // First winner position 
    pub winner_2: felt252, // Second winner position
    pub winner_3: felt252, // Third winner position
    pub next_player: felt252, // Address of the player to make the next move
    pub number_of_players: u8, // Number of players in the game
    pub rolls_count: u256, //  Sum of all the numbers rolled by the dice
    pub rolls_times: u256, // Total number of times the dice has been rolled
    pub dice_face: u8, // Last value of dice thrown
    pub player_chance: ContractAddress, // Next player to make move
    pub has_thrown_dice: bool, // Whether the dice has been thrown or not
    pub b0: felt252, // blue piece position on board
    pub b1: felt252, // blue piece position on board
    pub b2: felt252, // blue piece position on board
    pub b3: felt252, // blue piece position on board
    pub g0: felt252, // green piece position on board
    pub g1: felt252, // green piece position on board
    pub g2: felt252, // green piece position on board
    pub g3: felt252, // green piece position on board
    pub r0: felt252, // red piece position on board
    pub r1: felt252, // red piece position on board
    pub r2: felt252, // red piece position on board
    pub r3: felt252, // red piece position on board
    pub y0: felt252, // yellow piece position on board
    pub y1: felt252, // yellow piece position on board
    pub y2: felt252, // yellow piece position on board
    pub y3: felt252, // yellow piece position on board
}

pub trait GameTrait {
    // Create and return a new game
    fn new(
        id: u64,
        created_by: felt252,
        game_mode: GameMode,
        player_red: felt252,
        player_blue: felt252,
        player_yellow: felt252,
        player_green: felt252,
        number_of_players: u8
    ) -> Game;
    fn restart(ref self: Game);
    fn terminate_game(ref self: Game);
}

impl GameImpl of GameTrait {
    fn new(
        id: u64,
        created_by: felt252,
        game_mode: GameMode,
        player_red: felt252,
        player_blue: felt252,
        player_yellow: felt252,
        player_green: felt252,
        number_of_players: u8
    ) -> Game {
        let zero_address = contract_address_const::<0x0>();
        Game {
            id,
            created_by,
            is_initialised: true,
            status: GameStatus::Initialised,
            mode: game_mode,
            ready_to_start: false,
            player_green,
            player_yellow,
            player_blue,
            player_red,
            next_player: zero_address.into(),
            winner_1: zero_address.into(),
            winner_2: zero_address.into(),
            winner_3: zero_address.into(),
            rolls_times: 0,
            rolls_count: 0,
            number_of_players,
            dice_face: 0,
            player_chance: zero_address.into(),
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

    fn restart(ref self: Game) {
        let zero_address = contract_address_const::<0x0>();
        self.next_player = zero_address.into();
        self.rolls_times = 0;
        self.rolls_count = 0;
        self.number_of_players = 0;
        self.dice_face = 0;
        self.player_chance = zero_address.into();
        self.has_thrown_dice = false;
    }

    fn terminate_game(ref self: Game) {
        self.status = GameStatus::Ended;
    }
}


#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
#[dojo::model]
pub struct GameCounter {
    #[key]
    pub id: felt252,
    pub current_val: u64,
}

