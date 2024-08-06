# StarkLudo
Ludo game, on Starknet

<div align="center">
  <img src="./assets/starkludo.jpeg" width="355px"/>
</div>

|  |  |
| :---         | :---           |
| Website   | https://starkludo.onrender.com/   |
| Documentation     | https://hackmd.io/m9AjLcheSXClw9ttzHQmVw    |

## What is StarkLudo? 
StarkLudo is an online classic board game enjoyed by people of all ages. It’s a game of chance and strategy, where players race their game pieces around the board to be the first to reach the finish line.

The objective is to move all four of your game pieces around the board and reach the finish line first and the gaming experience should be on chain fostering togetherness and entertainment while competing amongs friends and loved ones. With the on-chain interaction the players that wins every round of the game will be rewarded with a token.

## Development
Steps to build and run StarkLudo locally
### Frontend: 
 ```
   # Navigate into the UI directory
   cd ui

   # Install dependencies
   yarn

   # Start local server
   yarn run start
   ```
### Onchain: 
```
# Navigate to the onchain directory
cd onchain

# Build contracts
scarb build

# Run tests
scarb test

```

## License
This project is licensed under the MIT License. See [License](./LICENSE) for more information
