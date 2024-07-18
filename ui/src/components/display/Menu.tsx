import React, { useState, useContext } from "react";
import { GameContext } from "../context/game-context";
import { useGame } from "../hooks/game-hook";
import { FaPlay } from "react-icons/fa";
import "../style/Menu.css";

const Menu = () => {
  const { options } = useContext(GameContext);
  const { startGame } = useGame();

  const [startBtn, setStartBtn] = useState<string>("show")

  const setSelected = () => {
    if (startBtn === "selected") {
      setStartBtn("show")
    } else {
      setStartBtn("selected")
    }
    return false;
  };

  const gameStarter: ((event: React.MouseEvent<HTMLButtonElement, MouseEvent>) => void) | undefined = (event) => {
    startGame(parseInt((event.target as HTMLInputElement).id));
  };

  return (
    <React.Fragment>
      {!options.isGame && !options.blockLoading && (
        <div className="cmenu">
          <div className="relative-menu">
            <div className="radmenu">
              <button className={startBtn} onClick={setSelected}>
                <FaPlay className="fa-play" />
              </button>
              <ul>
                <li>
                  <button id="4" onClick={gameStarter}>
                    4 Player
                  </button>
                </li>
                <li>
                  <button id="3" onClick={gameStarter}>
                    3 Player
                  </button>
                </li>
                <li>
                  <button id="2" onClick={gameStarter}>
                    2 Player
                  </button>
                </li>
              </ul>
            </div>
          </div>
        </div>
      )}
    </React.Fragment>
  );
};
export default Menu;
