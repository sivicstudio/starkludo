use starknet::ContractAddress;

// Player model
#[derive(Drop, Copy, Serde)]
#[dojo::model]
pub struct Player {
    #[key]
    pub username: felt252, // Unique username of player
    pub owner: ContractAddress, // Account owner of player. An account can own multiple players
    pub is_bot: bool,
    pub total_games_played: u256, // Count of total games played by this player
    pub total_games_won: u256, // Count of total games won by this player
}


#[derive(Drop, Copy, Serde)]
#[dojo::model]
pub struct UsernameToAddress {
    #[key]
    pub username: felt252,
    pub address: ContractAddress
}

#[derive(Drop, Copy, Serde)]
#[dojo::model]
pub struct AddressToUsername {
    #[key]
    pub address: ContractAddress,
    pub username: felt252,
}

pub trait PlayerTrait {
    // Create a new player
    // `username` - Username to assign to the new player
    // `owner` - Account owner of player
    // returns the created player
    fn new(username: felt252, owner: ContractAddress, is_bot: bool) -> Player;
}

impl PlayerImpl of PlayerTrait {
    fn new(username: felt252, owner: ContractAddress, is_bot: bool) -> Player {
        Player { username, owner, is_bot, total_games_played: 0, total_games_won: 0 }
    }
}
