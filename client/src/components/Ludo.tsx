import React, { useRef, useContext } from "react";
import Marker from "./Marker";
import LudoTiles from "./LudoTiles";
import { GameContext } from "../context/game-context";
import { useSize } from "../hooks/size-hook";
import { markers } from "../hooks/utils";
import "../styles/Ludo.scss";

const Ludo: React.FC = () => {
  const { size, tileMap } = useSize();
  const boardRef = useRef<HTMLDivElement>(null);
  const { options } = useContext(GameContext);

  return (
    <div className="container card" ref={boardRef}>
      {options.isGame &&
        markers
          .slice(0, options.playersLength * 4)
          .map((m) => <Marker key={m} pos={m} size={size} tileMap={tileMap} />)}
      <LudoTiles />
    </div>
  );
};

export default Ludo;
