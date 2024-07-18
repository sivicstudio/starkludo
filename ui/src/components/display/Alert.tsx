import React, { useContext } from "react";
import { GameContext } from "../context/game-context";
import { chance } from "../hooks/utils";
import { FaDiceD20, FaAward } from "react-icons/fa";
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
            <div className="alert-container">
              <div className="alert-icon">
                <FaDiceD20 />
              </div>
              <b className="alert-info">Player Chance</b> Player{" "}
              {chance[options.chance].toUpperCase()} make your move!
            </div>
          </div>
        </div>
      )}
    </React.Fragment>
  );
};

export default Alert;
