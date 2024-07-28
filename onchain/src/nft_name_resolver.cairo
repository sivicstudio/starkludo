use starknet::ContractAddress;

#[starknet::interface]
pub trait INFTNameResolver<T> {
    // Get the name associated with an NFT
    fn get_nft_name(self: @T, id: u256) -> felt252;

    // Get the token ID associated with a particular name
    fn get_id_name(self: @T, name: felt252) -> u256;

    // Mint NFT and associate with name
    fn create_nft_name(ref self: T, name: felt252);
}

#[starknet::contract]
mod NFTNameResolver {
    use starknet::{ContractAddress, get_caller_address};
    use starkludo::erc721::{IERC721Dispatcher, IERC721DispatcherTrait};

    #[storage]
    struct Storage {
        name_to_nft: LegacyMap::<felt252, u256>,
        nft_to_name: LegacyMap::<u256, felt252>,
        nft_address: ContractAddress
    }

    /// TODO: Add events

    #[constructor]
    fn constructor(ref self: ContractState, nft_address: ContractAddress) {
        /// TODO: Validate nft_address
        self.nft_address.write(nft_address);
    }

    #[abi(embed_v0)]
    impl NFTNameResolver of super::INFTNameResolver<ContractState> {
        fn get_nft_name(self: @ContractState, id: u256) -> felt252 {
            self.nft_to_name.read(id)
        }

        fn get_id_name(self: @ContractState, name: felt252) -> u256 {
            self.name_to_nft.read(name)
        }

        fn create_nft_name(ref self: ContractState, name: felt252) {
            let caller_address = get_caller_address();
            /// TODO: Validate name length

            // Mint NFT
            let nft_contract = IERC721Dispatcher { contract_address: self.nft_address.read() };
            let new_token_id = nft_contract.get_total_nft();
            nft_contract.mint(caller_address);

            // Resolve NFT Id to name
            self.nft_to_name.write(new_token_id, name);

            // Resolve name to NFT Id
            self.name_to_nft.write(name, new_token_id);
        /// TODO: Emit event
        }
    }
}
