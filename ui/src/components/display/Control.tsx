import React, { useState } from "react";
import { FiMinimize2, FiUser, FiXSquare } from "react-icons/fi";
import Draggable from "react-draggable";
import "../style/Control.scss";

const Account = ({ toggleShowAccount }) => {
  return (
    <Draggable grid={[15, 15]} handle=".handle">
      <div className="account">
        <div className="handle">
          <div onClick={() => toggleShowAccount()} className="close">
            <FiXSquare size={"1.5rem"} fontWeight={800} />
          </div>
        </div>
        <div className="heading">
          <div className="main">Account</div>
          <div className="sub">Your portal to the StarkLudo world</div>
        </div>
      </div>
    </Draggable>
  );
};

const Control = () => {
  const [showAccount, setShowAccount] = useState(false);

  const toggleShowAccount = () =>
    showAccount ? setShowAccount(false) : setShowAccount(true);

  return (
    <div className="control">
      {/* User account button */}
      <div className="user">
        {showAccount ? <Account toggleShowAccount={toggleShowAccount} /> : null}
        <div onClick={() => toggleShowAccount()}>
          <FiUser color="white" style={{ cursor: "pointer" }} size={"2em"} />
        </div>
      </div>
    </div>
  );
};

export default Control;
