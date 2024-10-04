<h1 style="text-align: center">StarkLudo</h1>

_<div style="text-align: center">Ludo game, on Starknet</div>_

<div style="text-align: center ">
  <img width="996" alt="image" src="https://github.com/user-attachments/assets/97b4fefc-fdf3-4078-bbe5-a2937464d4ad">
</div>

<div style="width: 100%; display: flex; align-items: center; justify-content: center">
<table >
  <tr>
  </tr>
  <tr>
    <td>Website</td>
    <td><a href="https://starkludo.com">https://starkludo.com</a></td>
  </tr>
  <tr>
    <td>Documentation</td>
    <td><a href="https://hackmd.io/m9AjLcheSXClw9ttzHQmVw">https://hackmd.io/m9AjLcheSXClw9ttzHQmVw</a></td>
  </tr>
</table></div>

## What is StarkLudo?

StarkLudo is a classic board game enjoyed by people of all ages. It’s a game of chance and strategy, where players race their game pieces around the board to be the first to reach the finish spot.

At the start of the game, all players are assigned 4 pieces each. The goal is to move all four pieces to the finish spot through a specific route on the board. Each piece is moved one at a time. Each player takes turn rolling a die, and the output of rolling the die determines how many steps forward a piece can move. The first player that moves all their 4 pieces to the finish spot is declared the winner.

The game can be played by either 2, 3 or four people. In each game, there can only be one loser. For example, if the game is played by 4 people, the first 3 players to reach the finish spot are the winners. The player that reaches first gets the first position, the player that reaches second gets the second position, and the third gets the third position.

## Development
Steps to build and run StarkLudo locally

### Prerequisites
**_Ensure you have the prerequisites installed before proceeding.
Check [here](https://book.dojoengine.org/getting-started#prerequisites) for guide on how to install the prerequisites._**

### Install tools
1. [Install pnpm](https://pnpm.io/installation#using-npm)
```bash
npm install -g pnpm
```

2. [Install Dojo](https://book.dojoengine.org/getting-started#install-dojo-using-dojoup)
```bash
# Install dojoup
curl -L https://install.dojoengine.org | bash

# Install Dojo release
dojoup --version v1.0.0-alpha.13
```

### Build and run StarkLudo
#### Client
```bash
# Navigate to the client directory
cd client

# Install dependencies
pnpm i

# Run 
pnpm dev
``` 

### Onchain
Requires 2 terminals to run
> In both terminals, ensure you are in the `onchain` directory. You can navigate into the `onchain` directory by running this command from the root directory: `cd onchain`

- Terminal 1
```bash
# Start Katana
katana --disable-fee  --allowed-origins "*"
```

- Terminal 2
```bash
# Build contracts
sozo build

# Deploy contracts to Katana
sozo migrate apply

# Run Torii with World address generated from previous command
torii --world <WORLD ADDRESS> --allowed-origins "*"
```

> To locate the world address, scan through the output generated from running `sozo migrate apply`, locate the line similar to: <img width="662" alt="image" src="https://github.com/user-attachments/assets/3b84a16e-10f2-4531-83c1-252838f18226">

### Run contract tests
Use the following command to run the tests for StarkLudo contracts
```bash
# Navigate to the contracts directory
cd onchain

# Run tests
sozo test
```
If you want to run a specific test by the test name, use this command:
```bash
sozo test -f test_contract_deployment
```
> `test_contract_deployment` above is the name of the specific function being tested

> **_For more information about testing, check [Dojo book](https://book.dojoengine.org/framework/testing)_**
 
## License

This project is licensed under the MIT License. See [License](./LICENSE) for more information

## Contributing

For more info and guidance on contributing, join the contributors Telegram group: https://t.me/+hnjQooODZOA2M2Rk
