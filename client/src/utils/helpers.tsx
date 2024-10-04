import BigNumber from "bignumber.js";
import { AccountInterface } from "starknet";
import {
  getERC721Contract,
  getNftNameResolverContract,
  RPC_PROVIDER,
} from "./constants/constants";

export const convertHexToText = (hexValue: string) => {
  const stripHex = hexValue[0].slice(2);

  if (!stripHex) {
    return "--Error--";
  }

  const stringValue = stripHex
    .toString()
    .match(/.{1,2}/g)
    ?.reduce((acc, char) => acc + String.fromCharCode(parseInt(char, 16)), "");
  return stringValue;
};

export const getGameProfilesFromAddress = async (
  address: string,
  setGameProfiles: (args: string[]) => void
) => {
  try {
    // Get all NFT Ids belonging to address
    let ids: string[] =
      await getERC721Contract().get_token_ids_of_address(address);

    // Convert Ids to string
    ids = ids.map((id) => new BigNumber(id).toString());

    const names: string[] = [];

    // Loop through Ids and get the corresponding name associated with the Id
    // Reverse the list
    for (let i = ids.length; i > 0; i--) {
      const name = await getNftNameResolverContract().get_name_of_id(ids[i - 1], {
        parseResponse: false,
      });

      names.push(name);
    }

    setGameProfiles(names);
  } catch (error) {
    console.log(error);
  }
};

export const createGameProfile = async (
  profileName: string,
  account: AccountInterface
) => {
  try {
    const addProfileTxn =
      await getNftNameResolverContract(account).create_nft_name(profileName);

    await RPC_PROVIDER.waitForTransaction(addProfileTxn.transaction_hash);
  } catch (error) {
    console.log(error);
  }
};
