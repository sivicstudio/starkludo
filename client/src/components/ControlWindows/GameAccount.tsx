import { QueryBuilder, SDK } from "@dojoengine/sdk";
import { useAccount, useConnect } from "@starknet-react/core";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import BigNumber from "bignumber.js";
import { useEffect, useMemo, useState } from "react";
import { addAddressPadding, shortString } from "starknet";
import { useDojo } from "../../dojo/hooks/useDojo";
import { useDojoStore } from "../../dojo/hooks/useDojoStote";
import { ModelsMapping, SchemaType } from "../../dojo/typescript/models.gen";
import "../../styles/GameAccount.scss";
import useModel from "../../dojo/hooks/useModel";
import { getUsernameFromAddress } from "../../utils/helpers";

const ConnectWallet = ({ sdk }: { sdk: SDK<SchemaType> }) => {
  const {
    account,
    setup: { client },
  } = useDojo();
  const [playerName, setPlayerName] = useState("");

  let state = useDojoStore((state) => state);
  const entityId = useMemo(
    () => getEntityIdFromKeys([BigInt(account?.account.address)]),
    [account?.account.address]
  );

  async function createPlayerName() {
    if (!playerName) alert("Empty player name");
    try {
      await client.GameActions.createNewPlayer(
        account.account,
        playerName,
        false
      );
    } catch (error) {
      console.log("FAILED TO CRETE PLAYER: ", error);
    }
  }

  let addressToUsername = useModel(entityId, ModelsMapping.AddressToUsername);
  let username;

  if (!addressToUsername) {
    console.log("username not set");
  } else {
    username = shortString.decodeShortString(
      addressToUsername.username.toString()
    );
  }

  useEffect(() => {
    // Update state
    getUsernameFromAddress(account.account.address, sdk, state);
  }, [sdk, account?.account.address]);

  return (
    <div className="wallet">
      <span>Connect wallet: </span>
      <div onClick={() => account.create()} className="wallet-name-burner">
        <button>
          {account?.isDeploying ? "Deploying Burner..." : "Create Burner"}
        </button>
      </div>

      <div className="bg-gray-800 shadow-md rounded-lg p-4 sm:p-6 mb-6 w-full max-w-md">
        <div className="">{`Burners Deployed: ${account.count}`}</div>
        <div className="mb-4">
          <label
            htmlFor="signer-select"
            className="block text-sm font-medium text-gray-300 mb-2"
          >
            Select Signer:
          </label>
          <select
            id="signer-select"
            className="w-full"
            value={account ? account.account.address : ""}
            onChange={(e) => account.select(e.target.value)}
          >
            {account?.list().map((account, index) => (
              <option value={account.address} key={index}>
                {account.address}
              </option>
            ))}
          </select>
        </div>
        <button className="" onClick={() => account.clear()}>
          Clear Burners
        </button>
      </div>

      <div>
        <input
          value={playerName}
          onChange={(e) => setPlayerName(e.target.value)}
        />
        <button onClick={async () => createPlayerName()}>
          create username
        </button>
      </div>

      <div>
        <p>{username}</p>
      </div>
    </div>
  );
};

const GameAccount = ({ sdk }: { sdk: SDK<SchemaType> }) => {
  const { address } = useAccount();
  const [pagesStack, setPagesStack] = useState<string[]>(["MAIN_PAGE"]);

  const enum pagesName {
    MAIN_PAGE = "MAIN_PAGE",
    PROFILE_PAGE = "PROFILE_PAGE",
  }

  const mainPage = {
    name: pagesName.MAIN_PAGE,
    content: <ConnectWallet sdk={sdk} />,
  };

  const profilePage = {
    name: pagesName.PROFILE_PAGE,
    content: <div>Profile</div>,
  };

  const pages = [mainPage, profilePage];

  const resolvePageToReturn = () => {
    // Get last page name
    const lastPage =
      pagesStack[pagesStack.length - 1 > 0 ? pagesStack.length - 1 : 0];

    let pageToReturn;

    for (let i = 0; i < pages.length; i++) {
      if (pages[i].name.toString() === lastPage.toString()) {
        pageToReturn = pages[i].content;
        break;
      }
    }

    return pageToReturn;
  };

  // Show the last page in the stack
  return <div className="body-section">{resolvePageToReturn()}</div>;
};

export default GameAccount;
