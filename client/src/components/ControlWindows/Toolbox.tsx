import React, { useContext } from "react";
import '../../styles/Toolbox.scss';
import { BoardContext } from "../../context/board-context";

const Toolbox = () => {
  const { board, toggleBoard } = useContext(BoardContext);

  const boardOptions = [
    {name: 'Classic', option: 'classic'}, 
    {name: 'Wooden', option: 'wooden-board'},
    {name: 'Fire', option: 'fire-board'}
  ];

  return (
  <div>
    <div>
      <h2 className="title">
        Choose board
      </h2>
      <div>
        <div className="radio-buttons-switch-board">
        {boardOptions.map((item) => (
          <div key={item.option} >
            <label className="button-item">
              <input
                type="radio"
                value={item.option}
                checked={board === item.option}
                onChange={() => {
                  toggleBoard(item.option)
                }}
              />
              <span >{item.name}</span>
            </label>
          </div>
        ))}
        </div>
      </div>
    </div>
  </div>)
};

export default Toolbox;
