use starknet::ContractAddress;
use snforge_std::{declare, ContractClassTrait};
use starkludo::nft_name_resolver::{INFTNameResolverDispatcher, INFTNameResolverDispatcherTrait};

use starkludo::erc721::{IERC721Dispatcher, IERC721DispatcherTrait};

pub mod Accounts {
    use starknet::ContractAddress;

    pub fn address1() -> ContractAddress {
        'address1'.try_into().unwrap()
    }

    pub fn address2() -> ContractAddress {
        'address2'.try_into().unwrap()
    }
}

// Deploys contract and returns the address
pub fn deploy_contracts() -> (ContractAddress, ContractAddress) {
    // Declare and deploy NFT contract
    let contract = declare("ERC721").unwrap();
    let nft_name = 'My Token'.into();
    let nft_symbol = 'MTK'.into();
    let constructor_calldata = array![nft_name, nft_symbol];
    let (nft_contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

    // Declare and deploy NFTNameResolver contract
    let contract = declare("NFTNameResolver").unwrap();
    let constructor_calldata = array![nft_contract_address.into()];
    let (nft_name_resolver_contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

    (nft_contract_address, nft_name_resolver_contract_address)
}

#[test]
fn test_get_token_ids_of_address() {
    let address1: ContractAddress = Accounts::address1();
    let address2: ContractAddress = Accounts::address2();

    // Deploy contract
    let (nft_contract_address, _) = deploy_contracts();

    // Get contract dispatcher
    let nft_dispatcher = IERC721Dispatcher { contract_address: nft_contract_address };

    // Mint NFTs
    nft_dispatcher.mint(address1);
    nft_dispatcher.mint(address2);
    nft_dispatcher.mint(address1);

    let account1_tokens: Array<u256> = nft_dispatcher.get_token_ids_of_address(address1);
    let account2_tokens: Array<u256> = nft_dispatcher.get_token_ids_of_address(address2);

    assert_eq!(account1_tokens, array![1, 3]);
    assert_eq!(account2_tokens, array![2]);
}
