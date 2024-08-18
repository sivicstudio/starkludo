import React, { useState } from "react";
import { FaToolbox, FaUsers } from "react-icons/fa";
import { FiHelpCircle, FiUser } from "react-icons/fi";
import { IoIosPodium } from "react-icons/io";
import "../styles/Control.scss";
import GameAccount from "./ControlWindows/GameAccount";
import Leaderboard from "./ControlWindows/Leaderboard";
import ControlWindowLayout from "./ControlWindows/ControlWindowLayout";
import Multiplayer from "./ControlWindows/Multiplayer";
import Toolbox from "./ControlWindows/Toolbox";
import GameHelp from "./ControlWindows/GameHelp";

const Control = () => {
  const [showAccount, setShowAccount] = useState(false);
  const [showLeaderboard, setShowLeaderboard] = useState(false);
  const [showMultiplayer, setShowMultiplayer] = useState(false);
  const [showToolbox, setShowToolbox] = useState(false);
  const [showHelp, setShowHelp] = useState(false);

  const toggleShowAccount = () =>
    showAccount ? setShowAccount(false) : setShowAccount(true);
  const toggleShowLeaderboard = () =>
    showLeaderboard ? setShowLeaderboard(false) : setShowLeaderboard(true);
  const toggleShowMultiplayer = () =>
    showMultiplayer ? setShowMultiplayer(false) : setShowMultiplayer(true);
  const toggleShowToolbox = () =>
    showToolbox ? setShowToolbox(false) : setShowToolbox(true);
  const toggleShowHelp = () =>
    showHelp ? setShowHelp(false) : setShowHelp(true);

  return (
    <div className="control">
      {showAccount ? (
        <ControlWindowLayout
          toggle={toggleShowAccount}
          themeColor="blue"
          title="Account"
          subtitle="Your portal to the StarkLudo world"
          positionOffset={{ x: "0%", y: "0%" }}
        >
          <GameAccount />
        </ControlWindowLayout>
      ) : null}

      {showLeaderboard ? (
        <ControlWindowLayout
          toggle={toggleShowLeaderboard}
          themeColor="yellow"
          title="Leaderboard"
          subtitle="Ranking of all players"
          positionOffset={{ x: "-5%", y: "5%" }}
        >
          <Leaderboard />
        </ControlWindowLayout>
      ) : null}

      {showMultiplayer ? (
        <ControlWindowLayout
          toggle={toggleShowMultiplayer}
          themeColor="green"
          title="Multiplayer"
          subtitle="Play StarkLudo with other players in real time"
          positionOffset={{ x: "-10%", y: "10%" }}
        >
          <Multiplayer />
        </ControlWindowLayout>
      ) : null}

      {showToolbox ? (
        <ControlWindowLayout
          toggle={toggleShowToolbox}
          themeColor="brown"
          title="Toolbox"
          subtitle="Customise the looks and feel of your game"
          positionOffset={{ x: "-15%", y: "15%" }}
        >
          <Toolbox />
        </ControlWindowLayout>
      ) : null}

      {showHelp ? (
        <ControlWindowLayout
          toggle={toggleShowHelp}
          themeColor="gray"
          title="Help"
          subtitle="Get guides, tips, and tricks needed for a successful game"
          positionOffset={{ x: "-20%", y: "20%" }}
        >
          <GameHelp />
        </ControlWindowLayout>
      ) : null}

      {/* <GiGamepad
        fill="black"
        color="black"
        style={{ cursor: "pointer" }}
        size={"30em"}
      /> */}

      {/* Control buttons */}
      <div className="control-buttons">
        <div className="control-button" onClick={() => toggleShowAccount()}>
          <FiUser color="white" style={{ cursor: "pointer" }} size={"2em"} />
        </div>
        <div className="control-button" onClick={() => toggleShowLeaderboard()}>
          <IoIosPodium
            color="white"
            style={{ cursor: "pointer" }}
            size={"2em"}
          />
        </div>
        <div className="control-button" onClick={() => toggleShowMultiplayer()}>
          <FaUsers color="white" style={{ cursor: "pointer" }} size={"2em"} />
        </div>
        <div className="control-button" onClick={() => toggleShowToolbox()}>
          <FaToolbox color="white" style={{ cursor: "pointer" }} size={"2em"} />
        </div>
        <div className="control-button" onClick={() => toggleShowHelp()}>
          <FiHelpCircle
            color="white"
            style={{ cursor: "pointer" }}
            size={"2em"}
          />
        </div>
      </div>
    </div>
  );
};

export default Control;
