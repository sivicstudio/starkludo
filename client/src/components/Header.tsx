import React from "react";
import "../styles/Header.scss";
import DoubleDice from "../assets/images/double-dice.png";

const Header: React.FC = () => {
  return (
    <div className="header">
      <div className="starkludo">
        StarkLudo <img src={DoubleDice} width="49px" />
      </div>
      <div className="sub-header">The Ludo game on Starknet</div>
    </div>
  );
};

export default Header;
