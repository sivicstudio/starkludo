use starknet::ContractAddress;

#[derive(Drop, Copy, Serde)]
#[dojo::model]
pub struct Player {
    #[key]
    pub username: felt252,
    pub owner: ContractAddress,
    pub total_games_played: u256,
    pub total_games_won: u256
}

pub trait PlayerTrait {
    fn spawn(username: felt252, owner: ContractAddress) -> Player;
}

impl PlayerImpl of PlayerTrait {
    fn spawn(username: felt252, owner: ContractAddress) -> Player {
        Player { username, owner, total_games_played: 0, total_games_won: 0 }
    }
}
