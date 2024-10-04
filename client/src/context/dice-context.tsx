import { createContext, ReactNode, useState} from "react";
import dice5 from "../assets/images/dice-5.svg"

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
  img: string;
  changeDice: (newDice: DiceType, newImg: string) => void;
}

export const DiceContext = createContext<DiceContextType>({
  dice: "",
  img: dice5,
  changeDice: () => {
    throw new Error("changeDice function must be overridden");
  },
});

export const DiceProvider = ({ children }: { children: ReactNode }) => {
  const [dice, setDice] = useState<DiceType>("basic");
  const [img, setImg] = useState<string>(dice5);

  const changeDice = (newDice: DiceType, newImg: string) => {
    setDice(newDice);
    setImg(newImg);
  };

  return (
    <DiceContext.Provider value={{ dice, img, changeDice }}>
      {children}
    </DiceContext.Provider>
  );
};
