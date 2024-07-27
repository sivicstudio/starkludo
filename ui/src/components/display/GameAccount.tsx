import React, { useState } from "react";
import { FiXSquare } from "react-icons/fi";
import Draggable from "react-draggable";
import {
  useAccount,
  useConnect,
  useDisconnect,
  useNetwork,
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
              <div className="details">
                <div className="details-address">
                  <span>Address</span>
                  <span>{shortenedAddress}</span>
                </div>
                <div className="details-address">
                  <span>Starknet ID</span>
                  <span>ibs.braavos.stark</span>
                </div>
                <div className="details-address">
                  <span>Network</span>
                  <span>{chain.network.toUpperCase()}</span>
                </div>
              </div>
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
