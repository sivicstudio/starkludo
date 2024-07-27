import React, { useState } from "react";
import { FiUser } from "react-icons/fi";
import "../style/Control.scss";
import GameAccount from "./GameAccount";

const Control = () => {
  const [showAccount, setShowAccount] = useState(false);

  const toggleShowAccount = () =>
    showAccount ? setShowAccount(false) : setShowAccount(true);

  return (
    <div className="control">
      {/* User account button */}
      <div className="user">
        {showAccount ? (
          <GameAccount toggleShowAccount={toggleShowAccount} />
        ) : null}
        <div onClick={() => toggleShowAccount()}>
          <FiUser color="white" style={{ cursor: "pointer" }} size={"2em"} />
        </div>
      </div>
    </div>
  );
};

export default Control;
