<h1 style="text-align: center">StarkLudo</h1>

_<div style="text-align: center">Ludo game, on Starknet</div>_

<div style="text-align: center ">
  <img src="./assets/starkludo.jpeg" width="355px"/>
</div>

<div style="width: 100%; display: flex; align-items: center; justify-content: center">
<table >
  <tr>
  </tr>
  <tr>
    <td>Website</td>
    <td><a href="https://starkludo.onrender.com">https://starkludo.onrender.com</a></td>
  </tr>
  <tr>
    <td>Documentation</td>
    <td><a href="https://hackmd.io/m9AjLcheSXClw9ttzHQmVw">https://hackmd.io/m9AjLcheSXClw9ttzHQmVw</a></td>
  </tr>
</table></div>

## What is StarkLudo?

StarkLudo is an online classic board game enjoyed by people of all ages. It’s a game of chance and strategy, where players race their game pieces around the board to be the first to reach the finish line.

The objective is to move all four of your game pieces around the board and reach the finish line first and the gaming experience should be on chain fostering togetherness and entertainment while competing amongs friends and loved ones. With the on-chain interaction the players that wins every round of the game will be rewarded with a token.

## Development
Steps to build and run StarkLudo locally

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
dojoup --version v1.0.0-alpha.6
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

> To locate the world address, scan through the output generated from running `sozo migrate apply`, locate the line similar to:  _**🎉 Successfully migrated World on block #3 at address 0xb4079627ebab1cd3cf9fd075dda1ad2454a7a448bf659591f259efa2519b18**_
 

## License

This project is licensed under the MIT License. See [License](./LICENSE) for more information

## Contributing

For more info and guidance on contributing, join the contributors Telegram group: https://t.me/+hnjQooODZOA2M2Rk
