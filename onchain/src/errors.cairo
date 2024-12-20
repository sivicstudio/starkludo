pub mod Errors {
    pub const ADDRESS_ZERO: felt252 = 'Cannot create from zero address';
    pub const USERNAME_TAKEN: felt252 = 'username already taken';
    pub const USERNAME_NOT_FOUND: felt252 = 'player with username not found';
    pub const USERNAME_EXIST: felt252 = 'username already exist';
    pub const ONLY_OWNER_USERNAME: felt252 = 'only user can udpate username';
    pub const ONLY_GAME_CREATOR: felt252 = 'caller is not the game creator';
    pub const GAME_NOT_PENDING: felt252 = 'game status must be pending';
}
