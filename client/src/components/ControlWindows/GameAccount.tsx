import React, { useEffect, useState } from "react";
import {
  useAccount,
  useConnect,
  useDisconnect,
  useNetwork,
  useStarkProfile,
} from "@starknet-react/core";
import { useMemo } from "react";
import { FaArrowAltCircleRight } from "react-icons/fa";
import { useDojo } from "../../dojo/useDojo";
import {
  convertHexToText,
  createGameProfile,
  getGameProfilesFromAddress,
} from "../../utils/helpers";

const ConnectWallet = () => {
  const { connectors, connect } = useConnect();

  return (
    <div className="wallet">
      <span>Choose a wallet: </span>
      <div className="wallet-list">
        {connectors.map((connector) => (
          <div
            key={connector.id}
            onClick={() => connect({ connector })}
            className="wallet-name-btn"
          >
            {connector.id}
          </div>
        ))}
      </div>
    </div>
  );
};

const GameAccount = () => {
  const { address, account } = useAccount();
  const { disconnect } = useDisconnect();
  const { data: profile } = useStarkProfile({ address });
  const [gameProfiles, setGameProfiles] = useState<string[]>();
  const [newProfileName, setNewProfileName] = useState<string | undefined>(
    undefined
  );

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

    if (account === undefined || address === undefined) {
      alert("account is undefined");
      return;
    }

    await system.createUsername(account, newProfileName);
    setNewProfileName("");

    await getGameProfilesFromAddress(address, setGameProfiles);
  };

  useEffect(() => {
    if (address) {
      getGameProfilesFromAddress(address, setGameProfiles);
    }
  }, [address]);

  if (!address) {
    return <ConnectWallet />;
  }

  return (
    <div className="game-account">
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
        <div className="disconnect-btn">
          <button onClick={disconnectWallet}>Disconnect</button>
        </div>
        <div className="border"></div>
      </div>

      <div className="player-stats">
        {[
          { label: "Total Earnings", value: "25025" },
          { label: "Games Won", value: "1500 of 1520" },
          { label: "2 player Wins", value: "1256" },
          { label: "3 player Wins", value: "1256" },
          { label: "4 player Wins", value: "1256" },
          { label: "Win Percentage", value: "89%" },
          { label: "Achievements", value: "361" },
        ].map(({ label, value }) => (
          <div key={label} className="player-stat">
            <div>{label}</div>
            <div>{value}</div>
          </div>
        ))}
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
                    <div key={gameProfile} className="list-profile">
                      <span>{convertHexToText(gameProfile)}</span>
                      <FaArrowAltCircleRight cursor="pointer" />
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
          <button className="add-profile-btn" onClick={addGameProfile}>
            Add new profile
          </button>
        </div>
      </div>
    </div>
  );
};

export default GameAccount;