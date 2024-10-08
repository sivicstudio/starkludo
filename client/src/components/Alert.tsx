import React, { useContext } from "react";
import { chance } from "../hooks/utils";
import { FaAward } from "react-icons/fa";
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
              className={`breathing-box alert-${chance[options.playerChance]}`}
            >
              <p>
              {chance[options.playerChance].toUpperCase()}, your move. <br />ROLL!
              </p>
            </div>
          </div>
        </div>
      )}
    </React.Fragment>
  );
};

export default Alert;
