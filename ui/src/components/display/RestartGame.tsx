import React, { useContext } from "react";
import { GameContext } from "../context/game-context";
import { useGame } from "../hooks/game-hook";
import RestartGamePNG from "../../assets/images/restart.png";
import "../style/RestartGame.scss";

const RestartGame: React.FC = () => {
  const { options } = useContext(GameContext);
  const { endGame: restartGame } = useGame();

  return (
    <React.Fragment>
      {options.isGame && (
        <div className="restart-game">
          <div className="restart-icon" onClick={restartGame}>
            <img src={RestartGamePNG} width="60px" />
          </div>
        </div>
      )}
    </React.Fragment>
  );
};

export default RestartGame;
