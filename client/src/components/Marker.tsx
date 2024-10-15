import React, { useEffect, useRef, useContext } from "react";
import { GameContext } from "../context/game-context";
import { useGame } from "../hooks/game-hook";
import { MarkerProps } from "../types";
import { ColorContext } from "../context/color-context";
import markerSound from "../assets/seed_click_sound.wav";

import "../styles/Marker.scss";

const Marker: React.FC<MarkerProps> = ({ pos, size, tileMap }) => {
  const { moveMarker } = useGame();
  const clickMap: Record<string, number> = { r: 0, g: 1, y: 2, b: 3 };
  const markerRef = useRef<HTMLDivElement>(null);
  const { gameState, options } = useContext(GameContext);
  const { design } = useContext(ColorContext);

  useEffect(() => {
    const countInArray = (array: string[], val: string) => {
      return array.filter((item) => item === val).length;
    };

    const randomNumber = () => {
      const max = 0.03;
      const min = -0.03;
      return Math.random() * (max - min) + min;
    };

    if (Object.keys(gameState).length > 0) {
      let c = countInArray(Object.values(gameState), gameState[pos]);
      c = c > 1 ? randomNumber() / 2 : 0;
      const t = tileMap[gameState[pos]];
      if (markerRef.current !== null) {
        markerRef.current.style.left = `${100 * (t[0] + c)}%`;
        markerRef.current.style.top = `${1 + 100 * (t[1] + c)}%`;
      }
    }
  }, [gameState, pos, size, tileMap]);

  const move = () => {
    const sound = new Audio(markerSound);
    sound.play();
    moveMarker(pos, clickMap[pos.charAt(0)]);
  };

  return (
    <div
      className={`marker-${pos.charAt(0)} marker-${design}`}
      ref={markerRef}
      onClick={
        options.hasThrownDice &&
        clickMap[pos.charAt(0)] === options.playerChance
          ? move
          : undefined
      }
    >
      <div className="pin" />
    </div>
  );
};

export default Marker;
