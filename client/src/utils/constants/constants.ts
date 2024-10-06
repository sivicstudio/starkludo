import { AccountInterface, Contract, RpcProvider } from "starknet";
import ERC721_ABI from "../abi/erc721.json";
import NFT_NAME_RESOLVER_ABI from "../abi/nft_name_resolver.json";

export const RPC_PROVIDER = new RpcProvider({
  nodeUrl: "https://free-rpc.nethermind.io/sepolia-juno/",
});

export const ERC721_ADDRESS =
  "0x1de25bcdc867ca09a75bfa7fb30478a3cb40dc6081b3969b06bee81de747ea5";

export const NFT_NAME_RESOLVER_ADDRESS =
  "0x644a1ea01363a55d809f1009f014b15b9c0df8fe8ceba02c442165dfee6f012";

export const getERC721Contract = (account?: AccountInterface): Contract => {
  // const { abi: ERC721_ABI } = await RPC_PROVIDER.getClassAt(ERC721_ADDRESS);

  // if (ERC721_ABI === undefined) {
  //   throw new Error("no ERC721 abi");
  // }

  const contract = new Contract(ERC721_ABI, ERC721_ADDRESS, RPC_PROVIDER);

  if (account) {
    contract.connect(account);
    return contract;
  }

  return contract;
};

export const getNftNameResolverContract = (
  account?: AccountInterface
): Contract => {
  // const { abi: NFT_NAME_RESOLVER_ABI } = await RPC_PROVIDER.getClassAt(
  //   NFT_NAME_RESOLVER_ADDRESS
  // );

  // if (NFT_NAME_RESOLVER_ABI === undefined) {
  //   throw new Error("no NFT_NAME_RESOLVER abi");
  // }
  const contract = new Contract(
    NFT_NAME_RESOLVER_ABI,
    NFT_NAME_RESOLVER_ADDRESS,
    RPC_PROVIDER
  );

  if (account) {
    contract.connect(account);
    return contract;
  }

  return contract;
};
