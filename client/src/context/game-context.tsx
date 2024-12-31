import { createContext } from "react";
import { OptionsProps } from "../types";

export const GameContext = createContext<{
  /* eslint-disable  @typescript-eslint/no-explicit-any */
  gameState: { [key: string]: string | any };
  setGameData: (game: { [key: string]: string }) => void;
  options: OptionsProps;
  setGameOptions: (newOption: object) => void;
}>({
  gameState: {},
  /* eslint-disable @typescript-eslint/no-unused-vars */
  setGameData: (game) => undefined,
  options: {
    gameIsOngoing: false,
    playersLength: 0,
    diceFace: 0,
    playerChance: 0,
    hasThrownDice: false,
    winners: [],
    gameCondition: [],
  },

  setGameOptions: (newOption) => undefined,
});
