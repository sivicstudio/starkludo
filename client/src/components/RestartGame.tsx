import React, { useContext, useState } from "react";
import RestartGamePNG from "../assets/images/restart.png";
import "../styles/RestartGame.scss";
import { GameContext } from "../context/game-context";
import { useGame } from "../hooks/game-hook";
import RestartModal from "./RestartModal";

const RestartGame: React.FC = () => {
  const { options } = useContext(GameContext);
  const { endGame: restartGame } = useGame();
  const [restart, setRestart] = useState(false);

  function handleRestartGame() {
    setRestart(true);
  }

  function handleConfirm() {
    restartGame();
    setRestart(false);
  }

  function handleCancle() {
    setRestart(false);
  }

  return (
    <React.Fragment>
      {options.gameIsOngoing && (
        <div className="restart-game">
          <div className="restart-icon" onClick={handleRestartGame}>
            <img src={RestartGamePNG} width="60px" />
          </div>
        </div>
      )}

      {restart && (
        <RestartModal
          message="Are you sure you want to restart the game?"
          extraMessage="If you click yes, there’s no going back"
          onConfirm={handleConfirm}
          onCancel={handleCancle}
        />
      )}
    </React.Fragment>
  );
};

export default RestartGame;
