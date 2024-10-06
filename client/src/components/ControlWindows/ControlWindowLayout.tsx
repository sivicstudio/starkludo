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
  if (!visible) return null;

  return (
    <div className="window-layout">
      <div>
        <div className="close" onClick={toggle}>
          <FiXSquare size="1.5rem" fontWeight={800} />
        </div>
        <div className="body">
          <div className="heading">
            <div className="main">{title}</div>
            <div className="sub">{subtitle}</div>
            <div className="border"></div>
          </div>
          <div className="body-section">{children}</div>
        </div>
      </div>
    </div>
  );
};

export default ControlWindowLayout;