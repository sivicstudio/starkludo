import React, { useContext } from "react";
import { chance } from "../hooks/utils";
import { FaAward, FaPlay } from "react-icons/fa";
import "../styles/Alert.scss";
import { GameContext } from "../context/game-context";

const Alert = () => {
  const { options } = useContext(GameContext);

  return (
    <React.Fragment>
      {options.gameIsOngoing && (
        <div className="section alert-section">
          {options.winners.map((w, i) => (
            <div key={i} className="alert alert-win">
              <div className="alert-container">
                <div className="alert-icon">
                  <FaAward className={`prize-${i + 1}`} />
                </div>
                Player {chance[w].toUpperCase()}
              </div>
            </div>
          ))}
          <div className={`alert alert-${chance[options.playerChance]}`}>
            <div
              className={`alert-container alert-${chance[options.playerChance]}`}
            >
              <div className="alert-icon">
                <FaPlay />
              </div>
              Now is your move player{" "}
              {chance[options.playerChance].toUpperCase()}!
            </div>
          </div>
        </div>
      )}
    </React.Fragment>
  );
};

export default Alert;
