import { useState } from "react";
import UserIcon from "../svg/UserIcon";
import UsersIcon from "../svg/UsersIcon";
import PodiumIcon from "../svg/PodiumIcon";
import ToolboxIcon from "../svg/ToolboxIcon";

import HelpIcon from "../svg/HelpIcon";

import "../styles/Control.scss";
import GameAccount from "./ControlWindows/GameAccount";
import Leaderboard from "./ControlWindows/Leaderboard";
import Multiplayer from "./ControlWindows/Multiplayer";
import Toolbox from "./ControlWindows/Toolbox";
import GameHelp from "./ControlWindows/GameHelp";

const WINDOW_CONFIGS = [
  {
    id: "account",
    icon: <UserIcon />,
    themeColor: "blue",
    title: "Account",
    subtitle: "Your portal to the StarkLudo world",
    component: GameAccount,
    positionOffset: { x: "0%", y: "0%" },
  },
  {
    id: "leaderboard",
    icon: <PodiumIcon />,
    themeColor: "yellow",
    title: "Leaderboard",
    subtitle: "Ranking of all players",
    component: Leaderboard,
    positionOffset: { x: "-5%", y: "5%" },
  },
  {
    id: "multiplayer",
    icon: <UsersIcon />,
    themeColor: "green",
    title: "Multiplayer",
    subtitle: "Play StarkLudo with other players in real time",
    component: Multiplayer,
    positionOffset: { x: "-10%", y: "10%" },
  },
  {
    id: "toolbox",
    icon: <ToolboxIcon />,
    themeColor: "brown",
    title: "Toolbox",
    subtitle: "Customise the looks and feel of your game",
    component: Toolbox,
    positionOffset: { x: "-15%", y: "15%" },
  },
  {
    id: "help",
    icon: <HelpIcon />,
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

  /* eslint-disable @typescript-eslint/no-unused-vars */
  const [windows, setWindows] = useState(
    WINDOW_CONFIGS.map((config) => ({ ...config, show: false, zIndex: 0 }))
  );

  return (
    <div className="control">
      {/* Control buttons */}
      <div className="control-buttons">
        {WINDOW_CONFIGS.map((window) => (
          <div>
            <div
              key={window.id}
              className="control-button"
              onClick={() => toggleActiveWindow(window.id)}
            >
              <div className="control-button-outer-ring">
                <div className="control-button-inner-ring">
                  <div className="control-button-inner-inner-ring">
                    <div>{window.icon}</div>
                  </div>
                </div>
              </div>
            </div>
            <h3 className="control-button-label">{window.title}</h3>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Control;
