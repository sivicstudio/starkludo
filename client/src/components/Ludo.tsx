import React, { useRef, useContext } from "react";
import Marker from "./Marker";
import LudoTiles from "./LudoTiles";
import { GameContext } from "../context/game-context";
import { useSize } from "../hooks/size-hook";
import { markers } from "../hooks/utils";
import "../styles/Ludo.scss";
import { BoardContext } from "../context/board-context";
import CaretRight from "./CaretRight";

const Ludo: React.FC = () => {
  const { size, tileMap } = useSize();
  const boardRef = useRef<HTMLDivElement>(null);
  const { options } = useContext(GameContext);
  const { board } = useContext(BoardContext);

  return (
    <div className={`container ${board} card`} ref={boardRef}>
      {options.gameIsOngoing &&
        markers
          .slice(0, options.playersLength * 4)
          .map((m) => <Marker key={m} pos={m} size={size} tileMap={tileMap} />)}
      <LudoTiles />
      {!options.playersLength && (
        <div className="overlay">
          <div className="overlay-child">
            <p className="text-white">
              Choose the number of players first to begin
            </p>
            <CaretRight />
          </div>
        </div>
      )}
    </div>
  );
};

export default Ludo;
