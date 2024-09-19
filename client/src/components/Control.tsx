import { useState } from "react";
import userIcon from "../assets/images/userIcon.svg";
import usersIcon from "../assets/images/usersIcon.svg";
import podiumIcon from "../assets/images/podiumIcon.svg";
import toolBoxIcon from "../assets/images/toolboxIcon.svg";
import helpCircleIcon from "../assets/images/helpCircleIcon.svg";

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

const WINDOW_CONFIGS = [
  {
    id: "account",
    icon: FiUser,
    themeColor: "blue",
    title: "Account",
    subtitle: "Your portal to the StarkLudo world",
    component: GameAccount,
    positionOffset: { x: "0%", y: "0%" },
  },
  {
    id: "leaderboard",
    icon: IoIosPodium,
    themeColor: "yellow",
    title: "Leaderboard",
    subtitle: "Ranking of all players",
    component: Leaderboard,
    positionOffset: { x: "-5%", y: "5%" },
  },
  {
    id: "multiplayer",
    icon: FaUsers,
    themeColor: "green",
    title: "Multiplayer",
    subtitle: "Play StarkLudo with other players in real time",
    component: Multiplayer,
    positionOffset: { x: "-10%", y: "10%" },
  },
  {
    id: "toolbox",
    icon: FaToolbox,
    themeColor: "brown",
    title: "Toolbox",
    subtitle: "Customise the looks and feel of your game",
    component: Toolbox,
    positionOffset: { x: "-15%", y: "15%" },
  },
  {
    id: "help",
    icon: FiHelpCircle,
    themeColor: "gray",
    title: "Help",
    subtitle: "Get guides, tips, and tricks needed for a successful game",
    component: GameHelp,
    positionOffset: { x: "-20%", y: "20%" },
  },
];

const Control = ({
  toggleActiveWindow,
}: {
  toggleActiveWindow: (window: string) => void;
}) => {
  const [windows, setWindows] = useState(
    WINDOW_CONFIGS.map((config) => ({ ...config, show: false, zIndex: 0 }))
  );

  const toggleWindow = (id: string) => {
    setWindows((prevWindows) => {
      const maxZIndex = Math.max(...prevWindows.map((w) => w.zIndex));
      return prevWindows.map((window) =>
        window.id === id
          ? {
              ...window,
              show: !window.show,
              zIndex: window.show ? window.zIndex : maxZIndex + 1,
            }
          : window
      );
    });
  };

  return (
    <div className="control">
      {/* {windows.map(
        (window) =>
          window.show && (
            <ControlWindowLayout
              key={window.id}
              index={window.zIndex}
              toggle={() => toggleWindow(window.id)}
              themeColor={window.themeColor}
              title={window.title}
              subtitle={window.subtitle}
              positionOffset={window.positionOffset}
            >
              <window.component />
            </ControlWindowLayout>
          )
      )} */}

      {/* Control buttons */}
      {/* <div className="control-buttons">
        {windows.map((window) => (
          <div
            key={window.id}
            className="control-button"
            onClick={() => toggleWindow(window.id)}
          >
            <window.icon
              color="white"
              style={{ cursor: "pointer" }}
              size={"2em"}
            />
          </div>
        ))}
      </div> */}

      <div className="control-buttons">
        <div
          className="control-button"
          onClick={() => toggleActiveWindow("account")}
        >
          <img src={userIcon} style={{ cursor: "pointer" }} />
        </div>
        <div
          className="control-button"
          onClick={() => toggleActiveWindow("leaderboard")}
        >
          <img src={podiumIcon} style={{ cursor: "pointer" }} />
        </div>
        <div
          className="control-button"
          onClick={() => toggleActiveWindow("multiplayer")}
        >
          <img src={usersIcon} alt="" style={{ cursor: "pointer" }} />
        </div>
        <div
          className="control-button"
          onClick={() => toggleActiveWindow("toolbox")}
        >
          <img src={toolBoxIcon} alt="" style={{ cursor: "pointer" }} />
        </div>
        <div
          className="control-button"
          onClick={() => toggleActiveWindow("help")}
        >
          <img src={helpCircleIcon} alt="" style={{ cursor: "pointer" }} />
        </div>
      </div>
    </div>
  );
};

export default Control;
