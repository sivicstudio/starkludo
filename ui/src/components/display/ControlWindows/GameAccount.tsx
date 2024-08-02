import React, { useEffect, useState } from "react";
import {
  useAccount,
  useConnect,
  useDisconnect,
  useNetwork,
  useStarkProfile,
} from "@starknet-react/core";
import { useMemo } from "react";
import "../../style/GameAccount.scss";
import {
  createGameProfile,
  getGameProfilesFromAddress,
} from "../../../utils/helpers";

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

const GameAccount = () => {
  const { address, account } = useAccount();
  const { chain } = useNetwork();
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

  return (
    <div className="body-section">
      {!address ? (
        <ConnectWallet />
      ) : (
        <div className="body-details">
          {/* Wallet details */}
          <div className="wallet-details">
            <div className="details-address">
              <span>Address</span>
              <span>{shortenedAddress}</span>
            </div>
            <div className="details-address">
              <span>Starknet ID</span>
              <span>{profile?.name ? profile.name : "---"}</span>
            </div>
            <div className="details-address">
              <span>Network</span>
              <span>{chain.network.toUpperCase()}</span>
            </div>
          </div>
          {/* Game Profiles */}
          <div className="game-profiles">
            <div className="profile-heading">Game Profiles</div>
            <div className="game-profiles">
              {gameProfiles !== undefined ? (
                <div>
                  {gameProfiles?.length > 0 ? (
                    <div>
                      {gameProfiles.map((gameProfile) => (
                        <div>{gameProfile}</div>
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
          {/* Disconnect button */}
          <div onClick={() => disconnectWallet()} className="disconnect-btn">
            Disconnect
          </div>
        </div>
      )}
    </div>
  );
};

export default GameAccount;
