import React from "react";
import "../styles/PieceDesignCard.scss";

interface PieceDesignCardProps {
  option: { name: string; option: string; img: string };
  active: boolean;
  onSelect: () => void;
}

const PieceDesignCard: React.FC<PieceDesignCardProps> = ({
  option,
  active,
  onSelect,
}) => {
  return (
    <button
      className={`piece-design-card ${active ? "active" : ""}`}
      onClick={onSelect}
    >
      <div className="option">
        <div className="name-label">{option?.name}</div>
        <img src={option.img} alt="board" />
      </div>
    </button>
  );
};

export default PieceDesignCard;
