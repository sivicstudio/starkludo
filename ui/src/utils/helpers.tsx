import BigNumber from "bignumber.js";
import { AccountInterface } from "starknet";
import {
  getERC721Contract,
  getNftNameResolverContract,
  RPC_PROVIDER,
} from "./constants";

export const getGameProfilesFromAddress = async (
  address: string,
  setGameProfiles: any
) => {
  try {
    // Get all NFT Ids belonging to address
    let ids: any[] = await getERC721Contract().get_token_ids_of_address(
      address
    );

    // Convert Ids to string
    ids = ids.map((id) => new BigNumber(id).toString());

    // Loop through Ids and get the corresponding name associated with the Id
    let names: any[] = [];
    for (let i = 0; i < ids.length; i++) {
      let name = await getNftNameResolverContract().get_name_of_id(ids[i], {
        parseResponse: false,
      });

      // Convert name to string
      //   let bname = new BigNumber(name).toString();
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
    let addProfileTxn = await getNftNameResolverContract(
      account
    ).create_nft_name(profileName);

    await RPC_PROVIDER.waitForTransaction(addProfileTxn.transaction_hash);
  } catch (error) {
    console.log(error);
  }
};
