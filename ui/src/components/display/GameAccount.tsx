import React, { useState } from "react";
import { FiXSquare } from "react-icons/fi";
import Draggable from "react-draggable";
import {
  useAccount,
  useConnect,
  useDisconnect,
  useNetwork,
  useStarkProfile,
} from "@starknet-react/core";
import { useMemo } from "react";
import "../style/GameAccount.scss";

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

const GameAccount = ({ toggleShowAccount }) => {
  const { address } = useAccount();
  const { chain } = useNetwork();
  const { disconnect } = useDisconnect();
  const { data: profile } = useStarkProfile({ address });
  console.log("profile: ", profile);

  const shortenedAddress = useMemo(() => {
    if (!address) return "";
    return `${address.slice(0, 5)}...${address.slice(-4)}`;
  }, [address]);

  return (
    <Draggable grid={[15, 15]} handle=".handle">
      <div className="account">
        <div className="handle">
          <div onClick={() => toggleShowAccount()} className="close">
            <FiXSquare size={"1.5rem"} fontWeight={800} />
          </div>
        </div>
        <div className="heading">
          <div className="main">Account</div>
          <div className="sub">Your portal to the StarkLudo world</div>
        </div>
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
                <div className="add-profile">
                  {" "}
                  <input placeholder="username" />
                  <button className="add-profile-btn">Add new profile</button>
                </div>
              </div>
              {/* Disconnect button */}
              <div onClick={() => disconnect()} className="disconnect-btn">
                Disconnect
              </div>
            </div>
          )}
        </div>
      </div>
    </Draggable>
  );
};

export default GameAccount;
