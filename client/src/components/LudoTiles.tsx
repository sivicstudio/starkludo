import React, { useRef } from "react";
import EmptySquareSound from "../assets/audio/square_sound.wav";
import FilledSqaureSound from "../assets/audio/fill_square_sound.mp3";

const LudoTiles: React.FC = () => {
  const emptySquareAudioRef = useRef(new Audio(EmptySquareSound));
  const fillSquareAudioRef = useRef(new Audio(FilledSqaureSound));

  const handleEmptySquareAudio = () => {
    emptySquareAudioRef.current.play();
  };

  const handleFillSquareAudio = () => {
    fillSquareAudioRef.current.play();
  };

  return (
    <React.Fragment>
      <div className="container-row1 clearfix">
        <div className="row1-col1">
          <div className="row1-col1-child clearfix ">
            <div className="green" />
            <div className="green" />
            <div className="green" />
            <div className="green" />
          </div>
        </div>
        <div className="row1-col2 clearfix">
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="yellow" onClick={handleFillSquareAudio} />
          <div className="yellow" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="yellow" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="yellow" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="yellow" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="yellow" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
        </div>
        <div className="row1-col3">
          <div className="row1-col3-child clearfix">
            <div className="yellow" />
            <div className="yellow" />
            <div className="yellow" />
            <div className="yellow" />
          </div>
        </div>
      </div>

      <div className="container-row2 clearfix">
        <div className="row2-col1 clearfix">
          <div onClick={handleEmptySquareAudio} />
          <div className="green" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="green" onClick={handleFillSquareAudio} />
          <div className="green" onClick={handleFillSquareAudio} />
          <div className="green" onClick={handleFillSquareAudio} />
          <div className="green" onClick={handleFillSquareAudio} />
          <div className="green" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
        </div>
        <div className="row2-col2">
          <div className="contain-triangles">
            <div className="white" />
            <div className="white" />
            <div className="white" />
            <div className="white" />
          </div>
        </div>
        <div className="row2-col3 clearfix">
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="blue" onClick={handleFillSquareAudio} />
          <div className="blue" onClick={handleFillSquareAudio} />
          <div className="blue" onClick={handleFillSquareAudio} />
          <div className="blue" onClick={handleFillSquareAudio} />
          <div className="blue" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="blue" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
        </div>
      </div>

      <div className="container-row3 clearfix">
        <div className="row3-col1">
          <div className="row3-col1-child clearfix">
            <div className="red" />
            <div className="red" />
            <div className="red" />
            <div className="red" />
          </div>
        </div>
        <div className="row3-col2 clearfix">
          <div onClick={handleEmptySquareAudio} />
          <div className="red" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="red" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="red" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="red" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div className="red" onClick={handleFillSquareAudio} />
          <div className="red" onClick={handleFillSquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
          <div onClick={handleEmptySquareAudio} />
        </div>
        <div className="row3-col3">
          <div className="row3-col3-child clearfix">
            <div className="blue" />
            <div className="blue" />
            <div className="blue" />
            <div className="blue" />
          </div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default LudoTiles;
