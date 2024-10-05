import boardImg from "../assets/images/ludo-board-img.svg";
import "../styles/OptionCard.scss";

export default function OptionCard({
  active,
  onSelect,
  option,

}: {
  active?: boolean;
  onSelect?: () => void;
  option?: { name: string };
}) {
  return (
    <button
      className={`option-container ${active ? "active" : ""}`}
      onClick={onSelect}
    >
      <div className="option">
        <img src={boardImg} alt="board" />
        <div className="option-label">{option?.name}</div>
      </div>
    </button>
  );
}
