import React, { useState, useContext, useRef } from "react";
import { useGame } from "../hooks/game-hook";
import { Col } from "react-simple-flex-grid";
import "../styles/Dice.scss";
import ThreeDice from 'react-dice-roll';
import { GameContext } from "../context/game-context";
import diceSound from "../assets/audio/shaking-dice-25620.mp3";

const Dice = () => {
  const { moveValidator } = useGame();
  const { options, setGameOptions } = useContext(GameContext);
  const diceRef = useRef<any>(null);

  const deterministicRoll = (value: number) => {
    if (diceRef.current) {
      diceRef.current.rollDice(value); // Call the rollDice method with a fixed value
    }
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
        console.log(x, "Fix");
        deterministicRoll(x);
        moveValidator(x); // Validate move after rolling
      } else {
        // rolls the die by quickly displaying then hiding them
        deterministicRoll(number)
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
    if (!options.hasThrownDice) {
      setGameOptions({ hasThrownDice: true });
      await rollDie(randomRollAmount());
    }
  };

  return (
    <React.Fragment>
      {options.gameIsOngoing && (
        <div className="dice-container">
          <Col xs={options.hasThrownDice ? 12 : 6}>
            <ThreeDice disabled={!options.hasThrownDice} ref={diceRef} sound={diceSound} rollingTime={1000} size={100} />
          </Col>
            <Col xs={6}>
              <div style={{
              visibility: !(!options.hasThrownDice) ? "hidden":"visible"
              }}>
              <div onClick={roller} className="button-container">
                <a className="start-over">Start Over</a>
                <button className="roll-button">
                  <span className="roll-text">ROLL</span>
                </button>
              </div>
              </div>
            </Col>
        </div>
      )}
    </React.Fragment>
  );
};

export default Dice;
