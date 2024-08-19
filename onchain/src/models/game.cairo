use starknet::ContractAddress;

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
    pub id: ContractAddress,
    pub created_by: ContractAddress,
    pub game_status: GameStatus,
    pub game_mode: GameMode,
    pub player_green: ContractAddress,
    pub player_yellow: ContractAddress,
    pub player_blue: ContractAddress,
    pub player_red: ContractAddress,
    pub winner: ContractAddress,
    pub next_player: ContractAddress,
    pub total_number_of_rolls: u256,
    // pub player_rolls_count: LegacyMapping<ContractAddress, u256>,
}
