import { useContext } from "react";
import "../../styles/Toolbox.scss";
import { BoardContext } from "../../context/board-context";
import OptionCard from "../OptionCard";

const Toolbox = () => {
  const { board, toggleBoard } = useContext(BoardContext);

  const boardOptions = [
    { name: "Classic", option: "classic" },
    { name: "Wooden", option: "wooden-board" },
    { name: "Fire", option: "fire-board" },
  ];

  return (
    <div className="toolbox">
      <div className="categories">
        <button className="category">BOARD</button>
        <button className="category">DICE</button>
        <button className="category">AVATAR</button>
        <button className="category">COLOR</button>
      </div>
      <div className="active-category">
        <h3>Active Dice</h3>
        <h5>Basic</h5>
      </div>
      <div className="options">
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
      </div>
    </div>
  );
};

export default Toolbox;
