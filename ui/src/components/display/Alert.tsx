import React, { useContext } from "react";
import { GameContext } from "../context/game-context";
import { chance } from "../hooks/utils";
import { FaDiceD20, FaAward, FaPlay } from "react-icons/fa";
import "../style/Alert.scss";

const Alert = () => {
  const { options } = useContext(GameContext);

  return (
    <React.Fragment>
      {options.isGame && (
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
          <div className={`alert alert-${chance[options.chance]}`}>
            <div className={`alert-container alert-${chance[options.chance]}`}>
              <div className="alert-icon">
                <FaPlay />
              </div>
              Now is your move player {chance[options.chance].toUpperCase()}!
            </div>
          </div>
        </div>
      )}
    </React.Fragment>
  );
};

export default Alert;
