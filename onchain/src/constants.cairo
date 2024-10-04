use starknet::{ContractAddress, contract_address_const};

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
pub enum TileNode {
    R1,
    R2,
    R3,
    R4,
    R5,
    R6,
    G1,
    G2,
    G3,
    G4,
    G5,
    G6,
    Y1,
    Y2,
    Y3,
    Y4,
    Y5,
    Y6,
    B1,
    B2,
    B3,
    B4,
    B5,
    B6,
    R01,
    R02,
    R03,
    R04,
    G01,
    G02,
    G03,
    G04,
    Y01,
    Y02,
    Y03,
    Y04,
    B01,
    B02,
    B03,
    B04,
}

fn zero_address() -> ContractAddress {
    contract_address_const::<0x0>()
}

