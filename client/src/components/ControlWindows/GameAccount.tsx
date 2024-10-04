import {
  useAccount,
  useConnect,
  useDisconnect,
  useStarkProfile,
} from "@starknet-react/core";
import { useEffect, useMemo, useState } from "react";
import { FaArrowAltCircleRight } from "react-icons/fa";
import { useDojo } from "../../dojo/useDojo";
import "../../styles/GameAccount.scss";
import {
  convertHexToText,
  getGameProfilesFromAddress
} from "../../utils/helpers";

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


/* eslint-disable @typescript-eslint/no-unused-vars */
const ProfilePage = () => {
  return <div style={{ color: "white" }}>Profile page</div>;
};

const GameAccount = () => {
  const { address, account } = useAccount();
  // const { chain } = useNetwork();
  const { disconnect } = useDisconnect();
  const { data: profile } = useStarkProfile({ address });
  const [, setGameProfiles] = useState<string[]>();
  const [newProfileName, setNewProfileName] = useState<string | undefined>(
    undefined
  );
  const [pagesStack, ] = useState<string[]>(["MAIN_PAGE"]);

  const shortenedAddress = useMemo(() => {
    if (!address) return "";
    return `${address.slice(0, 5)}...${address.slice(-4)}`;
  }, [address]);

  const disconnectWallet = () => {
    setGameProfiles(undefined);
    disconnect();
  };


  const { system } = useDojo();

  const addGameProfile = async () => {
    if (newProfileName === undefined || newProfileName?.length < 2) {
      alert("profile name must be greater than 2");
      return;
    }

  //   if (account === undefined || address === undefined) {
  //     alert("account is undefined");
  //     return;
  //   }

    // await createGameProfile(newProfileName, account);
    await system.createUsername(account, newProfileName);
    await setNewProfileName("");

  //   await getGameProfilesFromAddress(address, setGameProfiles);
  // };

  useEffect(() => {
    if (address) {
      getGameProfilesFromAddress(address, setGameProfiles);
    }


    return () => undefined;
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

            <div className="game-profiles">
              <div className="profile-heading">Game Profiles</div>
              <div className="game-profiles-outer-list">
                {gameProfiles !== undefined ? (
                  <div className="game-profiles-inner-list">
                    {gameProfiles?.length > 0 ? (
                      <div className="games-profiles-core-list">
                        {gameProfiles.map((gameProfile) => (
                          <div className="list-profile">
                            <span>{convertHexToText(gameProfile)}</span>

                            <FaArrowAltCircleRight cursor={"pointer"} />
                          </div>
                        ))}
                      </div>
                    ) : (
                      <div style={{ color: "gray" }}>--no profile found--</div>
                    )}
                  </div>
                ) : (
                  <div style={{ color: "gray" }} className="loading-txt">
                    Loading...
                  </div>
                )}
              </div>
              <div className="add-profile">
                <input
                  placeholder="username"
                  value={newProfileName}
                  onChange={(e) => setNewProfileName(e.target.value)}
                />
                <button
                  className="add-profile-btn"
                  onClick={() => addGameProfile()}
                >
                  Add new profile
                </button>
              </div>
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
