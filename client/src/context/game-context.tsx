import { createContext } from "react";
import { OptionsProps } from "../types";

export const GameContext = createContext<{
  gameState: { [key: string]: string | any };
  setGameData: (game: { [key: string]: string }) => void;
  options: OptionsProps;
  setGameOptions: (newOption: {}) => void;
}>({
  gameState: {},
  setGameData: (game) => {},
  options: {
    gameIsOngoing: false,
    playersLength: 0,
    diceFace: 0,
    playerChance: 0,
    hasThrownDice: false,
    winners: [],
    gameCondition: [],
  },
  setGameOptions: (newOption) => {},
});

// export interface IGameState {
//   [key: string]: string | number | boolean | any[];
// }

// export interface IGameContextType {
//   gameState: IGameState;
//   setGameData: (game: IGameState) => void;
//   options: OptionsProps;
//   setGameOptions: (newOption: Partial<OptionsProps>) => void;
// }

// export const GameContext = createContext<IGameContextType>({
//   gameState: {},
//   setGameData: () => {},
//   options: {
//     gameIsOngoing: false,
//     playersLength: 0,
//     diceFace: 0,
//     playerChance: 0,
//     hasThrownDice: false,
//     winners: [],
//     gameCondition: [],
//   },
//   setGameOptions: () => {},
// });