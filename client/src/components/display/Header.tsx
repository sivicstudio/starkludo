import React from "react";
import "../style/Header.css";
import DoubleDice from "../../assets/images/double-dice.png";

const Header: React.FC = () => {
  return (
    <div className="header">
      <div className="starkludo">
        StarkLudo <img src={DoubleDice} width="80px" />
      </div>
      <div className="sub-header">The Ludo game on Starknet</div>
    </div>
  );
};

export default Header;
