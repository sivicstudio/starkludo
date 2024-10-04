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
