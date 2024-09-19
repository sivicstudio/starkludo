import "../../styles/GameHelp.scss";

const GameHelp = () => {
  return (
    <div className="game-help">
      <div className="rules">
        <ul className="game-rules-rules">
          <li>
            <span>Rule 1:</span> The game starts with each player choosing a set
            of four pieces (usually colored red, blue, green, and yellow) and
            placing them on the starting square.
          </li>
          <li>
            <span>Rule 2:</span> The objective of the game is to move all four
            pieces around the board and return them to the starting square
            before your opponents.
          </li>
          <li>
            <span>Rule 3:</span> On each turn, players roll two dice to
            determine how many spaces they can move their pieces.
          </li>
          <li>
            <span>Rule 4:</span> The number on each die represents how many
            spaces a piece can move. For example, if a player rolls a 3 and a 6,
            they can move one piece 3 spaces and another piece 6 spaces.
          </li>
          <li>
            <span>Rule 5:</span> Pieces can only move forward, never backward.
          </li>
          <li>
            <span>Rule 6:</span> If a piece lands on a square occupied by an
            opponent’s piece, it can “knock off” that piece and send it back to
            the starting square.{" "}
          </li>
          <li>
            <span>Rule 7:</span> A piece can only be moved to a square that is
            empty or occupied by an opponent’s piece.
          </li>
          <li>
            <span>Rule 8:</span> If a player rolls a double (two 6s), they can
            move one piece the total number of spaces shown on the dice (e.g., 6
            spaces for two 3s).
          </li>
          <li>
            <span>Rule 9:</span> if a player 3 pieces reached Home, only one is
            left. and the piece reached the home column. A person should be
            shifted to one Dice, if the player wants to play with 2 dice he/she
            gets the exact number which in the case of one, is not possible.
          </li>
          <li>
            <span>Rule 10:</span> If a player has no pieces on the board, they
            can only roll the dice to try to get a double, which allows them to
            enter a piece into play.
          </li>
          <li>
            <span>Rule 11:</span> The game ends when one player has all four
            pieces back on the starting square. That player is the winner.
          </li>
        </ul>
      </div>
    </div>
  );
};

export default GameHelp;
