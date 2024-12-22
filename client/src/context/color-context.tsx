/* eslint-disable @typescript-eslint/no-empty-function */
import React, { createContext, useState, useContext } from "react";

export type PieceDesign = "default" | "king" | "box" | "circle" | 'red' | 'green' | 'orange' | 'blue';

interface ColorContextType {
  design: PieceDesign;
  changeDesign: (newDesign: PieceDesign) => void;
}

const ColorContext = createContext<ColorContextType>({
  design: "default",
  changeDesign: () => {},
});

// eslint-disable-next-line react-refresh/only-export-components
export const useColor = () => useContext(ColorContext);

export const ColorProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [design, setDesign] = useState<PieceDesign>("default");

  const changeDesign = (newDesign: PieceDesign) => {
    setDesign(newDesign);
  };

  return (
    <ColorContext.Provider value={{ design, changeDesign }}>
      {children}
    </ColorContext.Provider>
  );
};

export { ColorContext };
