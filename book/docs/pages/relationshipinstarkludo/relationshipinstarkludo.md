## Starknet wallet, NFT, and Tokenbound account Relationship in StarkLudo

How StarkLudo integrates these various components together:
1. Connect Starknet wallet
2. Create profile name
3. Mint new NFT and assign profile name to NFT Id using the `NFTNameResolver` contract
4. Create new Tokenbound account using the same NFT Id assigned to profile name
5. The profile name now resolves the newly created Tokenbound account
> - princeibs (profile name) -> 999 (token id) -> 0x12342 (tokenbound account)
> - _therefore_, princeibs -> 0x12342

> User can create as many profile name as desired, and therefore create as many tokenbound account as desired

![image](https://hackmd.io/_uploads/rJaeBwEKR.png)
