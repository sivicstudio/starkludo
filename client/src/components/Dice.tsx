import React, { useState, useContext } from "react";
import { useGame } from "../hooks/game-hook";
import { Row, Col } from "react-simple-flex-grid";
import "../styles/Dice.scss";
import { GameContext } from "../context/game-context";

const Dice = () => {
  const { moveValidator } = useGame();
  const [diceClass, setDiceClass] = useState("");
  const { options, setGameOptions } = useContext(GameContext);

  // cc = center-center; tl = top-left; br = bottom-right; etc.
  const combinations: { [key: number]: string[] }[] = [
    { 1: ["cc"] },
    { 2: ["tl", "br"] },
    { 3: ["tl", "cc", "br"] },
    { 4: ["tl", "tr", "bl", "br"] },
    { 5: ["tl", "tr", "cc", "bl", "br"] },
    { 6: ["tl", "tr", "cl", "cr", "bl", "br"] },
  ];

  const eraseDots = async (number: number) => {
    // iterate over combinations array to remove numbers
    combinations[number - 1][number].forEach((set) => {
      // add class 'show'
      document.getElementById(`${set}`)?.classList.remove("show");
    });
  };

  const makeDots = async (number: number) => {
    // Spin animation
    // dicebody.classList.add("spin-die");
    setDiceClass((d) => (d === "spin-die" ? d : d + "spin-die"));
    // iterate over combinations array to show numbers
    combinations[number - 1][number].forEach((set) => {
      // add class 'show'
      document.getElementById(`${set}`)?.classList.add("show");
    });
  };

  // The is the argument for the rollDie function
  const randomRollAmount = () => {
    let rollAmount = Math.floor(Math.random() * 30 + 15);
    return rollAmount;
  };

  // The end result is simply a random number picked between 1 and 6
  const randomRollResult = async () => {
    let rollResult: number = 6;

    rollResult = Math.floor(Math.random() * 6 + 1);

    moveValidator(rollResult);
    return rollResult;
  };

  // This adds a setInterval to make the dots on the die

  const rollDie = async (numberOfRolls: number) => {
    let counter = 1;
    let number = 1;
    const rollState = async () => {
      // when to stop the roll
      if (counter >= numberOfRolls) {
        clearInterval(rolling);
        // The result on die
        let x = await randomRollResult();
        makeDots(x);
        // remove CSS animation spin effect
        setDiceClass((d) => d.replace("spin-die", ""));
      } else {
        // rolls the die by quickly displaying then hiding them
        makeDots(number);
        setTimeout(eraseDots, 80, number);
        // incrementer values for setInterval
        counter += 1;
        // which dots to show on die for 1 to 6
        number += 1;
        // Keep looping the values from 1 to 6
        if (number > 6) {
          number = 1;
        }
      }
    };
    const rolling = setInterval(rollState, 125);
  };

  const roller = async () => {
    if (!options.thrown) {
      setGameOptions({ thrown: true });
      await rollDie(randomRollAmount());
    }
  };

  return (
    <React.Fragment>
      {options.isGame && (
        <Row gutter={0} className="dice-container">
          <Col xs={options.thrown ? 12 : 6}>
            <div id="dice-body" className={`${diceClass}`}>
              <div id="tl" className="dot" />
              <div id="tc" className="dot" />
              <div id="tr" className="dot" />
              <div id="cl" className="dot" />
              <div id="cc" className="dot show" />
              <div id="cr" className="dot" />
              <div id="bl" className="dot" />
              <div id="bc" className="dot" />
              <div id="br" className="dot" />
            </div>
          </Col>

          {!options.thrown && (
            <Col xs={6}>
              <div>
                <button className="roll-btn" onClick={roller}>
                  Roll
                </button>
              </div>
            </Col>
          )}
        </Row>
      )}
    </React.Fragment>
  );
};

export default Dice;
