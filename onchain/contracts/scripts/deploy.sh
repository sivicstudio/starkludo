sncast --account ibs_wallet --url https://free-rpc.nethermind.io/sepolia-juno/ declare --fee-token eth --contract-name ERC721
sncast --account ibs_wallet --url https://free-rpc.nethermind.io/sepolia-juno/ deploy --fee-token eth --class-hash 0x76afa803a02d2d794dd9a2372b40b2dbc073506ce5e53721e49511ef9a1b654 --constructor-calldata 5582528760121091438 5067851

NFT CONTRACT ADDRESS => 0x1de25bcdc867ca09a75bfa7fb30478a3cb40dc6081b3969b06bee81de747ea5


sncast --account ibs_wallet --url https://free-rpc.nethermind.io/sepolia-juno/ declare --fee-token eth --contract-name NFTNameResolver
sncast --account ibs_wallet --url https://free-rpc.nethermind.io/sepolia-juno/ deploy --fee-token eth --class-hash 0x2e4effee5d35c75fe4fccc304298ecaa5856eade86a06d0766a2783429dc65c --constructor-calldata 0x1de25bcdc867ca09a75bfa7fb30478a3cb40dc6081b3969b06bee81de747ea5

NFT NAME RESOLVER ADDRESS => 0x644a1ea01363a55d809f1009f014b15b9c0df8fe8ceba02c442165dfee6f012
