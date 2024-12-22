import React from "react";
import close from "../../assets/images/close_icon.svg";
import "../../styles/GameHelp.scss";

interface GameHelpProps {
  onClose: () => void;
}

interface GameRule {
  id: number;
  description: string;
}

const GAME_RULES: GameRule[] = [
  {
    id: 1,
    description:
      "The game starts with each player choosing a set of four pieces (usually colored red, blue, green, and yellow) and placing them on the starting square.",
  },
  {
    id: 2,
    description:
      "The objective of the game is to move all four pieces around the board and return them to the starting square before your opponents.",
  },
  {
    id: 3,
    description:
      "On each turn, players roll two dice to determine how many spaces they can move their pieces.",
  },
  {
    id: 4,
    description:
      "The number on each die represents how many spaces a piece can move. For example, if a player rolls a 3 and a 6, they can move one piece 3 spaces and another piece 6 spaces.",
  },
  {
    id: 5,
    description: "Pieces can only move forward, never backward.",
  },
  {
    id: 6,
    description:
      'If a piece lands on a square occupied by an opponent\'s piece, it can "knock off" that piece and send it back to the starting square.',
  },
  {
    id: 7,
    description:
      "A piece can only be moved to a square that is empty or occupied by an opponent's piece.",
  },
  {
    id: 8,
    description:
      "If a player rolls a double (two 6s), they can move one piece the total number of spaces shown on the dice.",
  },
  {
    id: 9,
    description:
      "If a player has 3 pieces reached Home with only one left, and the piece reached the home column, the player should be shifted to one Dice. Playing with 2 dice requires getting the exact number, which is not possible with one.",
  },
  {
    id: 10,
    description:
      "If a player has no pieces on the board, they can only roll the dice to try to get a double, which allows them to enter a piece into play.",
  },
  {
    id: 11,
    description:
      "The game ends when one player has all four pieces back on the starting square. That player is the winner.",
  },
];

const GameHelp: React.FC<GameHelpProps> = ({ onClose }) => {
  return (
    <div className="modal-overlay">
      <div className="modal-content">
        <div className="modal-header">
          <h2>Get Guides, Tips, And Tricks Needed For A Successful Game</h2>
          <button onClick={onClose} className="close-button">
            <img src={close} alt="close icon" />
          </button>
        </div>
        <hr className="border_help" />
        <div className="game-help">
          <ul className="game-rules-rules">
            {GAME_RULES.map(({ id, description }) => (
              <li key={id}>
                <span>Rule {id}:</span>
                <div>{description}</div>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default GameHelp;
