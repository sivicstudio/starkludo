sncast --account ibs_wallet --url https://free-rpc.nethermind.io/sepolia-juno/ declare --fee-token eth --contract-name ERC721
sncast --account ibs_wallet --url https://free-rpc.nethermind.io/sepolia-juno/ deploy --fee-token eth --class-hash 0x7f41678d7e3f6035a1d9ef82e9cf83228156ad747272c99678d0ba71b64914e --constructor-calldata 5582528760121091438 5067851

NFT CONTRACT ADDRESS => 0x1bcc57f6b411fddfac92bfeffb716cf229b80b9a2f30603fef4530215d70c39


sncast --account ibs_wallet --url https://free-rpc.nethermind.io/sepolia-juno/ declare --fee-token eth --contract-name NFTNameResolver
sncast --account ibs_wallet --url https://free-rpc.nethermind.io/sepolia-juno/ deploy --fee-token eth --class-hash 0x662a9dbaedf3f029469e0cd6339f8114c725bfd801174b378c98313a8b537e3 --constructor-calldata 0x1bcc57f6b411fddfac92bfeffb716cf229b80b9a2f30603fef4530215d70c39

NFT NAME RESOLVER ADDRESS => 0x4ac6bd9b4207488fa84e68d62de34f3e6bb5f287f69f1de00308667a02b552e
