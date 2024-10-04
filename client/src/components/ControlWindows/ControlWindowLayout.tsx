import React from "react";
import { FiXSquare } from "react-icons/fi";
import "../../styles/ControlWindowLayout.scss";

const ControlWindowLayout = ({
  children,
  toggle,
  title,
  subtitle,
  visible,
}: {
  children: React.ReactNode;
  toggle: () => void;
  visible?: boolean;
  title: string;
  subtitle?: string;
}) => {
  return (
    <div className={`window-layout ${visible ? "visible" : ""}`}>
      <div>
        <div onClick={() => toggle()} className="close">
          <FiXSquare size={"1.5rem"} fontWeight={800} />
        </div>
        <div className="body">
          {/* Heading */}
          <div className="heading">
            <div className="main">{title}</div>
            <div className="sub">{subtitle}</div>

            <div className="border"></div>
          </div>
          {/* Body */}
          <div className="body-section">{children}</div>
        </div>
      </div>
    </div>
  );
};

export default ControlWindowLayout;
