import { useContext } from "react";
import "../../styles/Toolbox.scss";
import { BoardContext } from "../../context/board-context";
import OptionCard from "../OptionCard";
import { DiceContext } from "../../context/dice-context";
import dice10 from "../../assets/images/dice-10.svg";
import dice9 from "../../assets/images/dice-9.svg";
import dice8 from "../../assets/images/dice-8.svg";
import dice7 from "../../assets/images/dice-7.svg";
import dice6 from "../../assets/images/dice-6.svg";
import dice5 from "../../assets/images/dice-5.svg";
import DiceCard from "../DiceCard";

interface ToolboxProps {
  activeCategory: string;
  onCategoryClick: (category: string) => void;
}

const Toolbox = ({ activeCategory, onCategoryClick }: ToolboxProps) => {
  const { board, toggleBoard } = useContext(BoardContext);
  const { dice, changeDice } = useContext(DiceContext);

  const boardOptions = [
    { name: "Classic", option: "classic" },
    { name: "Wooden", option: "wooden-board" },
    { name: "Fire", option: "fire-board" },
  ];

  const diceOptions = [
    { name: "Basic Dice", option: "basic", img: dice5 },
    { name: "Gold Dice", option: "gold", img: dice6 },
    { name: "Black Dice", option: "black", img: dice7 },
    { name: "Unique Dice", option: "unique", img: dice8 },
    { name: "Red Dice", option: "red", img: dice9 },
    { name: "Silver Dice", option: "silver", img: dice10 },
  ];

  return (
    <div className="toolbox">
      <div className="categories">
        <button
          className={`category ${activeCategory === "BOARD" ? "active" : ""}`}
          onClick={() => onCategoryClick("BOARD")}
        >
          BOARD
        </button>
        <button
          className={`category ${activeCategory === "DICE" ? "active" : ""}`}
          onClick={() => onCategoryClick("DICE")}
        >
          DICE
        </button>
        <button
          className={`category ${activeCategory === "AVATAR" ? "active" : ""}`}
          onClick={() => onCategoryClick("AVATAR")}
        >
          AVATAR
        </button>
        <button
          className={`category ${activeCategory === "COLOR" ? "active" : ""}`}
          onClick={() => onCategoryClick("COLOR")}
        >
          COLOR
        </button>
      </div>
      <div className="active-category">
        <h3>Active Dice</h3>
        <h5>{dice.charAt(0).toUpperCase()+dice.slice(1).toLowerCase()} dice</h5>
      </div>
      {activeCategory === "BOARD" && <div className="options">
        {boardOptions.map((item) => (
          <OptionCard
            key={item.option}
            option={item}
            active={board === item.option}
            onSelect={() => {
              toggleBoard(item.option);
            }}
          />
        ))}
      </div>}
      {activeCategory === "DICE" && <div className="dice-options">
        {diceOptions.map((item) => (
          <DiceCard
            img={item.img}
            key={item.option}
            option={item}
            active={board === item.option}
            onSelect={() => {
              changeDice(item.option);
            }}
          />
        ))}
      </div>}
    </div>
  );
};

export default Toolbox;
