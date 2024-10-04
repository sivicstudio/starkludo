<<<<<<< HEAD
import { createContext } from "react";

export type BoardType = "" | "wooden-board" | "fire-board" | string;

interface BoardContextType {
  board: BoardType;
  toggleBoard: (newBoard: BoardType) => void;
}

export const BoardContext = createContext<BoardContextType>({
  board: "",
  toggleBoard: () => {},
});
=======
import { createContext } from "react";

export type BoardType = "" | "wooden-board" | "fire-board" | string;

interface BoardContextType {
  board: BoardType;
  toggleBoard: (newBoard: BoardType) => void;
}

export const BoardContext = createContext<BoardContextType>({
  board: "",
  toggleBoard: () => undefined,
});
>>>>>>> c43c6f1d481754a137db14df3d2d25dbafa13db0
