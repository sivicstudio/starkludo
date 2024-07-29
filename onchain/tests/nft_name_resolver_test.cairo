use starknet::ContractAddress;
use snforge_std::{declare, ContractClassTrait};
use starkludo::nft_name_resolver::{INFTNameResolverDispatcher, INFTNameResolverDispatcherTrait};
use starkludo::erc721::{IERC721Dispatcher, IERC721DispatcherTrait};

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
fn test_create_nft_name() {
    // Deploy contract
    let (_, nft_name_resolver_contract_address) = deploy_contracts();

    // Get contract dispatcher
    let nft_name_resolver_dispatcher = INFTNameResolverDispatcher {
        contract_address: nft_name_resolver_contract_address
    };

    // Create nft name for first time
    nft_name_resolver_dispatcher.create_nft_name('princeibs');

    let id_of_name = nft_name_resolver_dispatcher.get_id_of_name('princeibs'.into());
    let name_of_id = nft_name_resolver_dispatcher.get_name_of_id(id_of_name);

    // Check
    assert_eq!(name_of_id, 'princeibs'.into());

    // Create nft name for second time
    nft_name_resolver_dispatcher.create_nft_name('maxv');

    let id_of_name_1 = nft_name_resolver_dispatcher.get_id_of_name('maxv'.into());
    let name_of_id_1 = nft_name_resolver_dispatcher.get_name_of_id(id_of_name_1);

    // Check
    assert_eq!(name_of_id_1, 'maxv'.into());
}

#[test]
#[should_panic(expected: 'name already claimed!')]
fn test_cannot_claim_existing_nft_name() {
    // Deploy contract
    let (_, nft_name_resolver_contract_address) = deploy_contracts();

    // Get contract dispatcher
    let nft_name_resolver_dispatcher = INFTNameResolverDispatcher {
        contract_address: nft_name_resolver_contract_address
    };

    // Create nft name for first time
    nft_name_resolver_dispatcher.create_nft_name('princeibs');

    let id_of_name = nft_name_resolver_dispatcher.get_id_of_name('princeibs'.into());
    let name_of_id = nft_name_resolver_dispatcher.get_name_of_id(id_of_name);

    // Check
    assert_eq!(name_of_id, 'princeibs'.into());

    // Create nft name for second time with already claimed name
    nft_name_resolver_dispatcher.create_nft_name('princeibs');
}
