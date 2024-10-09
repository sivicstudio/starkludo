###  Account
![image](https://hackmd.io/_uploads/SkSx7uXFC.png)

The account component is made up of Wallet and Profile.

#### Wallet
- Details about the connected Starknet wallet
- They includes wallet address, Starknet ID, Network, and other helpful details about the connected wallet

#### Profile
- This is the list of profiles the player has created
- A single connected wallet can have unlimited number of profiles
- Each profile is an [Non-fungible Tokenbound Account](https://tokenbound.gitbook.io/starknet-tokenbound) the player uses to interact with the game
- All game data of that player is stored in the tokenbound account
- The player can use this profile to perform other actions like purchase game assets, claim NFT rewards and other game rewards from game play, transfer game assets to other players, etc
