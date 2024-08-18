import React, { useState, useContext } from "react";
import { GameContext } from "../context/game-context";
import { useGame } from "../hooks/game-hook";
import Dice2 from "../assets/images/dice-2.png";
import Dice3 from "../assets/images/dice-3.png";
import Dice4 from "../assets/images/dice-4.png";
import "../styles/Menu.scss";

const Menu = () => {
  const { options } = useContext(GameContext);
  const { startGame } = useGame();

  return (
    <React.Fragment>
      {!options.isGame && !options.blockLoading && (
        <div className="game-menu">
          <div className="play-now">Play now!</div>
          <div className="select-players">
            <div className="select-player" onClick={async () => startGame(2)}>
              <img src={Dice2} width="60px" />
              <div className="select-info">2 players</div>
            </div>
            <div className="select-player" onClick={async () => startGame(3)}>
              <img src={Dice3} width="60px" />
              <div className="select-info">3 players</div>
            </div>
            <div className="select-player" onClick={async () => startGame(4)}>
              <img src={Dice4} width="60px" />
              <div className="select-info">4 players</div>
            </div>
          </div>
        </div>
      )}
    </React.Fragment>
  );
};
export default Menu;
