import { createContext } from 'react';

export type BoardType = 'classic' | 'texture' | string;

interface BoardContextType {
  board: BoardType;
  toggleBoard: (newBoard: BoardType) => void;
}

export const BoardContext = createContext<BoardContextType>({
  board: 'classic',
  toggleBoard: () => {},
});


