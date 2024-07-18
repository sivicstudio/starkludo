import React, { useContext } from "react";
import { GameContext } from "../context/game-context";
import { useGame } from "../hooks/game-hook";
import "../style/End.scss";

const End: React.FC = () => {
  const { options } = useContext(GameContext);
  const { endGame } = useGame();

  return (
    <React.Fragment>
      {options.isGame && (
        <div className="end-wrapper">
          <button className="end-btn cancel" onClick={endGame}>End Game</button>
        </div>
      )}
    </React.Fragment>
  );
};

export default End;
