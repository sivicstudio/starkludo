import React, { useContext } from "react";
import '../../styles/Toolbox.scss';
import { BoardContext, BoardType } from "../../context/board-context";

const Toolbox = () => {
  const { board, toggleBoard } = useContext(BoardContext);

  const boardOptions: BoardType[] = ['classic', 'texture'];

  return (
  <div>
    <div>
      <h2 className="title">
        Choose board
      </h2>
      <div>
        <div className="radio-buttons-switch-board">
        {boardOptions.map((option) => (
          <div key={option} >
            <label className="button-item">
              <input
                type="radio"
                value={option}
                checked={board === option}
                onChange={() => {
                  toggleBoard(option)
                }}
              />
              <span >{option}</span>
            </label>
          </div>
        ))}
        </div>
      </div>
    </div>
  </div>)
};

export default Toolbox;
