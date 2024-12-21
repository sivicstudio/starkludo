import React, { useState } from "react";
import "../styles/Settings.scss";
import x from "../assets/images/settings/x.svg";
import dice from "../assets/images/settings/dice.svg";
import play from "../assets/images/settings/play.svg";
import music_off from "../assets/images/settings/music-off.svg";
import music_on from "../assets/images/settings/music-on.svg";
import sound_off from "../assets/images/settings/sound-off.svg";
import sound_on from "../assets/images/settings/sound-on.svg";

const Settings: React.FC = () => {
  const [soundLevel, setSoundLevel] = useState(5);
  const [musicLevel, setMusicLevel] = useState(5);
  const [difficultyLevel, setDifficultyLevel] = useState("beginner");

  const handleSettingChange = (type: string, value: any) => {
    switch (type) {
      case "sound":
        setSoundLevel(value);
        break;
      case "music":
        setMusicLevel(value);
        break;
      case "difficulty":
        setDifficultyLevel(value);
        break;
      default:
        break;
    }
  };

  const renderLevelButtons = (type: string, currentValue: number | string, levels: any[]) =>
    levels.map((level, index) => (
      <button
        key={`${type}-${index}`}
        type="button"
        className={`settings-select-btn ${
          currentValue >= level ? "settings-select-btn-active" : ""
        }`}
        onClick={() => handleSettingChange(type, level)}
      ></button>
    ));

  return (
    <div className="settings">
      <div className="settings-container">
        <div className="settings-box">
          {/* Menu */}
          <div className="settings-menu__box">
            <div className="settings-menu__box-left">
              {["Single Player", "Multi Player", "Account", "Leader Board", "Toolbox"].map((item, index) => (
                <button key={index} className="settings-menu__box-left-btn">
                  {item}
                </button>
              ))}
            </div>
            <div className="settings-menu__box-right">
              <button className="settings-menu__box-right-btn">Connect Wallet</button>
            </div>
          </div>

          {/* Game Settings */}
          <div className="settings-game">
            <div className="settings-game-header">
              <h3 className="settings-game-header-title">Game Settings</h3>
              <div className="settings-game-header-close">
                <img src={x} alt="close" />
              </div>
            </div>
            <div className="settings-game-body">
              {/* Sound Settings */}
              <div className="settings-group">
                <h3 className="settings-title">Sound</h3>
                <div className="settings-select">
                  <img src={sound_off} alt="Sound Off" onClick={() => handleSettingChange("sound", -1)} />
                  {renderLevelButtons("sound", soundLevel, Array.from({ length: 10 }, (_, i) => i))}
                  <img src={sound_on} alt="Sound On" onClick={() => handleSettingChange("sound", 9)} />
                </div>
              </div>

              {/* Music Settings */}
              <div className="settings-group">
                <h3 className="settings-title">Music</h3>
                <div className="settings-select">
                  <img src={music_off} alt="Music Off"  onClick={() => handleSettingChange("music", -1)}/>
                  {renderLevelButtons("music", musicLevel, Array.from({ length: 10 }, (_, i) => i))}
                  <img src={music_on} alt="Music On"  onClick={() => handleSettingChange("music", 9)}/>
                </div>
              </div>

              {/* Difficulty Settings */}
              <div className="settings-difficulty">
                <h3 className="settings-title">Difficulty</h3>
                <div className="settings-difficulty-select">
                  {["beginner", "experienced", "professional"].map((level) => (
                    <button
                      key={level}
                      type="button"
                      className={`settings-difficulty-select-btn ${
                        difficultyLevel === level ? "settings-difficulty-select-btn-active" : ""
                      }`}
                      onClick={() => handleSettingChange("difficulty", level)}
                    >
                      {level.charAt(0).toUpperCase() + level.slice(1)}
                    </button>
                  ))}
                </div>
              </div>

              {/* Change Background */}
              <div className="settings-change__game__background">
                <h3 className="settings-title">
                  Change game background
                </h3>
                <div className="settings-change__game__background-play">
                  <img src={play} alt="play" />
                </div>
              </div>

            </div>
          </div>

          {/* Footer */}
          <div className="settings-footer">
            <div className="settings-footer-left">
              <button className="settings-footer-left-btn">
                <img src={dice} alt="Dice" />
                <span>New Game</span>
              </button>
            </div>
            <div className="settings-footer-right">
              <button className="settings-footer-right-btn settings-footer-right-btn-active">Settings</button>
              <button className="settings-footer-right-btn">Help</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Settings;
