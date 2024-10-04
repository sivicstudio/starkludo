import React, { useEffect, useState } from "react";
import {
  useAccount,
  useConnect,
  useDisconnect,
  useNetwork,
  useStarkProfile,
} from "@starknet-react/core";
import { useMemo } from "react";
import "../../styles/GameAccount.scss";
import {
  convertHexToText,
  createGameProfile,
  getGameProfilesFromAddress,
} from "../../utils/helpers";
import { FaArrowAltCircleRight } from "react-icons/fa";

const ConnectWallet = () => {
  const { connectors, connect } = useConnect();

  return (
    <div className="wallet">
      <span>Choose a wallet: </span>
      <div className="wallet-list">
        {connectors.map((connector) => {
          return (
            <div
              key={connector.id}
              onClick={() => connect({ connector })}
              className="wallet-name-btn"
            >
              {connector.id}
            </div>
          );
        })}
      </div>
    </div>
  );
};

const ProfilePage = () => {
  return <div style={{ color: "white" }}>Profile page</div>;
};

const GameAccount = () => {
  const { address, account } = useAccount();
  const { chain } = useNetwork();
  const { disconnect } = useDisconnect();
  const { data: profile } = useStarkProfile({ address });
  const [gameProfiles, setGameProfiles] = useState<string[]>();
  const [newProfileName, setNewProfileName] = useState<string | undefined>(
    undefined
  );
  const [pagesStack, setPagesStack] = useState<string[]>(["MAIN_PAGE"]);

  const shortenedAddress = useMemo(() => {
    if (!address) return "";
    return `${address.slice(0, 5)}...${address.slice(-4)}`;
  }, [address]);

  const disconnectWallet = () => {
    setGameProfiles(undefined);
    disconnect();
  };

  const addGameProfile = async () => {
    if (newProfileName === undefined || newProfileName?.length < 2) {
      alert("profile name must be greater than 2");
      return;
    }

    if (account === undefined || address === undefined) {
      alert("account is undefined");
      return;
    }

    await createGameProfile(newProfileName, account);
    setNewProfileName("");

    await getGameProfilesFromAddress(address, setGameProfiles);
  };

  useEffect(() => {
    if (address) {
      getGameProfilesFromAddress(address, setGameProfiles);
    }

    return () => {};
  }, [address]);

  const enum pagesName {
    MAIN_PAGE = "MAIN_PAGE",
    PROFILE_PAGE = "PROFILE_PAGE",
  }

  const mainPage = {
    name: pagesName.MAIN_PAGE,
    content: (
      <div>
        {!address ? (
          <ConnectWallet />
        ) : (
          <div>
            <div className="avatar">
              <div className="avatar-outer-ring">
                <div className="avatar-inner-ring">
                  <div className="avatar-inner-inner-ring">
                    <div>
                      <img src="" alt="" />
                    </div>
                  </div>
                </div>
              </div>
              <h3>{profile?.name ? profile.name : "---"}</h3>
              <h4>{shortenedAddress}</h4>
            </div>

            <div className="streak">
              <div className="streak-num">
                <h3>Current win streak</h3>
                <h5>5</h5>
              </div>
              <div
                onClick={() => disconnectWallet()}
                className="disconnect-btn"
              >
                <button>Disconnect</button>
              </div>
              <div className="border"></div>
            </div>
            <div className="player-stats">
              <div className="player-stat">
                <div>Total Earnings</div>
                <div>25025</div>
              </div>
              <div className="player-stat">
                <div>Games Won</div>
                <div>1500 of 1520</div>
              </div>
              <div className="player-stat">
                <div>2 player Wins</div>
                <div>1256</div>
              </div>
              <div className="player-stat">
                <div>3 player Wins</div>
                <div>1256</div>
              </div>
              <div className="player-stat">
                <div>4 player Wins</div>
                <div>1256</div>
              </div>
              <div className="player-stat">
                <div>4 player Wins</div>
                <div>1256</div>
              </div>
              <div className="player-stat">
                <div>Win Percentage</div>
                <div>89%</div>
              </div>
              <div className="player-stat">
                <div>Archivements</div>
                <div>361</div>
              </div>
            </div>
            <div className="player-actions">
              <button>DELETE</button>
              <button>SELL</button>
            </div>
          </div>
        )}
      </div>
    ),
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
