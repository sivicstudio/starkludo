// import "../styles/OptionCard.scss";
import "../styles/OptionCard.scss";

export default function DiceCard({
  img,
  active,
  onSelect,
  option,
}: {
  img?: string;
  active?: boolean;
  onSelect?: () => void;
  option?: any;
}) {
  return (
    <button
      className={`option-container ${active ? "active" : ""}`}
      onClick={onSelect}
    >
      <div className="option">
        <div className="name-label">{option.name}</div>
        <img src={img} alt="board" />
        <div className="option-label">5/6</div>
      </div>
    </button>
  );
}
