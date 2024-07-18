import React, { useEffect, useRef, useContext } from "react";
import { GameContext } from "../context/game-context";
import { useGame } from "../hooks/game-hook";

import "../style/Marker.scss";

const Marker = ({ pos, size, tileMap }) => {
  const { moveMarker } = useGame();
  const clickMap = { r: 0, g: 1, y: 2, b: 3 };
  const markerRef = useRef<HTMLDivElement>(null);
  const { gameState, options } = useContext(GameContext);

  useEffect(() => {
    const countInArray = (array: string[], val: string) => {
      return array.filter(item => item === val).length;
    }

    const randomNumber = () => { 
      const max = 0.05
      const min = -0.05 
      return Math.random() * (max - min) + min; 
    } 
    
    if (Object.keys(gameState).length > 0) {
      let c = countInArray(Object.values(gameState), gameState[pos])
      c = c > 1 ? randomNumber()/2 : 0
      const t = tileMap[gameState[pos]];
      if (markerRef.current !== null) {
        markerRef.current.style.left = `${size * (t[0] + c)}px`;
        markerRef.current.style.top = `${size * (t[1] + c)}px`;
      }
    }
  }, [gameState, pos, size, tileMap]);

  const move: ((event: React.MouseEvent<HTMLDivElement, MouseEvent>) => void) | undefined = () => {
    moveMarker(pos, clickMap[pos.charAt(0)]);
  };

  return (
    <div
      className={`marker-${pos.charAt(0)}`}
      ref={markerRef}
      onClick={
        options.thrown && clickMap[pos.charAt(0)] === options.chance
          ? move
          : undefined
      }
    >
      <div className="pin" />
      <div className="shadow" />
    </div>
  );
};

export default Marker;
