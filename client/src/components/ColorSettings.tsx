import "../styles/ColorSettings.scss";
import xmark from "../assets/images/xmark.svg";
import blueGem from "../assets/images/blue_gem.svg";
import greenGem from "../assets/images/green_gem.svg";
import orangeGem from "../assets/images/orange_gem.svg";
import redGem from "../assets/images/red_gem.svg";
import triangle from "../assets/images/Play.svg";
import triangleDown from "../assets/images/PlayDown.svg";
import { ColorContext, PieceDesign } from "../context/color-context";
import { useContext, useEffect, useState } from "react";
import triangleLight from "../assets/images/PlayLight.svg";
import { useGame } from "../hooks/game-hook";

const СolorSettings = () => {
  const { design, changeDesign } = useContext(ColorContext);
  const [isWindowVisible, setIsWindowVisible] = useState<boolean>(true); 
  const { startGame } = useGame();

  const pieceDesigns = [
    { name: "Blue", option: "blue", img: blueGem },
    { name: "Green", option: "green", img: greenGem },
    { name: "Orange", option: "orange", img: orangeGem },
    { name: "Red", option: "red", img: redGem },
  ];

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      switch (e.key.toLowerCase()) {
        case "b":
          changeDesign("blue");
          break;
        case "g":
          changeDesign("green");
          break;
        case "o":
          changeDesign("orange");
          break;
        case "r":
          changeDesign("red");
          break;
        default:
          break;
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [changeDesign]);

  return (
    <div className="settings-bg">
      <div className="settings-header">
        <div className="settings-header-items">
          <div className="settings-box header-item">Single player</div>
          <div className="settings-box header-item">Multiplayer</div>
          <div className="settings-box header-item">Account</div>
          <div className="settings-box header-item">Leader board</div>
          <div className="settings-box header-item">Toolbox</div>
        </div>
        <button className="connect-wallet">Connect wallet</button>
      </div>
      <div className="nav">
        <div className="settings-box nav-item">
          <img src={triangle} alt="" />
          <div>Select board</div>
        </div>
        <div className="settings-box nav-item">
          <img src={triangle} alt="" />
          <div>Your avatar</div>
        </div>
        <div className="settings-box nav-item">
          <img src={triangle} alt="" />
          <div>Choose dice</div>
        </div>
        <div
          className="settings-box nav-item active"
          onClick={() => setIsWindowVisible(!isWindowVisible)} 
          style={{ cursor: "pointer" }} 
        >
          <img src={isWindowVisible? triangleDown : triangle} alt="" />
          <div>Pick colour</div>
        </div>
      </div>

      {isWindowVisible && ( 
        <div className="window settings-box">
          <div className="settings-box-header">
            <div>Choose Your Starting Colour</div>
            <div>
              <img
                src={xmark}
                alt=""
                onClick={() => setIsWindowVisible(false)} 
                style={{ cursor: "pointer" }} 
              />
            </div>
          </div>
          <div className="color-gems-container">
            {pieceDesigns.map((item) => (
              <div key={item.option} className="color-gem-item">
                <div>{item.name}</div>
                <img
                  onClick={() => changeDesign(item.option as PieceDesign)}
                  src={item.img}
                  alt=""
                  className={`${
                    design === item.option ? "active" : ""
                  } gem-image`}
                />
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="settigs-footer">
        <div
          onClick={async () => startGame(1)}
          className="nav-item new-game-button"
        >
          <img src={triangleLight} alt="" />
          <div>New game</div>
        </div>
        <div className="settings-footer-buttons nav-item">
          <div className="settings-box header-item">Settings</div>
          <div className="settings-box header-item">Help</div>
        </div>
      </div>
    </div>
  );
};

export default СolorSettings;
