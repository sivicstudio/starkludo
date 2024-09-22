import React, { useState, useContext } from "react";
import { GameContext } from "../context/game-context";
import { useGame } from "../hooks/game-hook";
import "../styles/Menu.scss";
import DiceTwo from "../svg/DiceTwo";
import DiceThree from "../svg/DiceThree";
import DiceFour from "../svg/DiceFour";

const Menu = () => {
  const { options } = useContext(GameContext);
  const { startGame } = useGame();
  const [selected, setSelected] = useState<number | undefined>(undefined);

  function handleSelect(num: number) {
    if (selected === num) {
      setSelected(undefined);
      return;
    }
    setSelected(num);
  }

  return (
    <React.Fragment>
      {!options.gameIsOngoing && (
        <div>
          <div className="game-menu-container">
            <div className="game-menu">
              <div className="play-now">Select No. Of Players</div>
              <div className="select-players">
                <button
                  className={`select-player ${selected === 2 && "selected"}`}
                  onClick={() => handleSelect(2)}
                >
                  <DiceTwo />
                  <div className="select-info">2 players</div>
                </button>
                <button
                  className={`select-player ${selected === 3 && "selected"}`}
                  onClick={() => handleSelect(3)}
                >
                  <DiceThree />
                  <div className="select-info">3 players</div>
                </button>
                <button
                  className={`select-player ${selected === 4 && "selected"}`}
                  onClick={() => handleSelect(4)}
                >
                  <DiceFour />
                  <div className="select-info">4 players</div>
                </button>
              </div>
            </div>
          </div>
          {selected && (
            <div className="start">
              <button
                onClick={async () => startGame(selected)}
                className="start-button"
              >
                GO
              </button>
            </div>
          )}
        </div>
      )}
    </React.Fragment>
  );
};
export default Menu;
