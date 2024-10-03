import { createContext } from "react";

export type DiceType =
  | ""
  | "basic"
  | "gold"
  | "black"
  | "unique"
  | "red"
  | "silver"
  | string;

interface DiceContextType {
  dice: DiceType;
  changeDice: (newDice: DiceType) => void;
}

export const DiceContext = createContext<DiceContextType>({
  dice: "",
  changeDice: () => {},
});
