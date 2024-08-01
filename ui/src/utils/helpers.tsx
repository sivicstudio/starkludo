import BigNumber from "bignumber.js";
import { getERC721Contract, getNftNameResolverContract } from "./constants";

export const getGameProfilesFromAddress = async (
  address: string,
  setGameProfiles: any
) => {
  try {
    // Get all NFT Ids belonging to address
    let ids: any[] = await getERC721Contract().then((contract) =>
      contract.get_token_ids_of_address(address)
    );
    // Convert Ids to string
    ids = ids.map((id) => new BigNumber(id).toString());

    // Loop through Ids and get the corresponding name associated with the Id
    let names: any[] = [];
    for (let i = 0; i < ids.length; i++) {
      let name = await getNftNameResolverContract().then((contract) =>
        contract.get_name_of_id(ids[i])
      );
      // Convert name to string
      let bname = new BigNumber(name).toString();
      names.push(bname);
    }

    setGameProfiles(names);
  } catch (error) {
    console.log(error);
  }
};

export const addGameProfile = async (profileName: string) => {
  let added = await getNftNameResolverContract().then((contract) =>
    contract.create_nft_name(profileName)
  );
};
