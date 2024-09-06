import React from "react";
import Draggable from "react-draggable";
import { FiXSquare } from "react-icons/fi";
import "../../styles/ControlWindowLayout.scss";

const ControlWindowLayout = ({
  children,
  toggle,
  themeColor,
  title,
  subtitle,
  positionOffset,
}: {
  children: React.ReactNode;
  toggle: () => void;
  themeColor: string;
  title: string;
  subtitle?: string;
  positionOffset: { x: string; y: string };
}) => {
  return (
    <Draggable grid={[15, 15]} positionOffset={positionOffset} handle=".handle">
      <div
        className="window-layout"
        style={{ border: `solid 2px ${themeColor}` }}
      >
        <div className="handle" style={{ backgroundColor: `${themeColor}` }}>
          <div onClick={() => toggle()} className="close">
            <FiXSquare size={"1.5rem"} fontWeight={800} />
          </div>
        </div>
        <div className="body">
          {/* Heading */}
          <div className="heading">
            <div className="main" style={{ color: themeColor }}>
              {title}
            </div>
            <div className="sub" style={{ color: themeColor }}>
              {subtitle}
            </div>
          </div>
          {/* Body */}
          <div className="body-section">{children}</div>
        </div>
      </div>
    </Draggable>
  );
};

export default ControlWindowLayout;
