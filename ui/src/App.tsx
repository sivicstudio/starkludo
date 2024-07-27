import React, { useState, useEffect, useCallback } from "react";
import { Row, Col } from "react-simple-flex-grid";
import { GameContext } from "./components/context/game-context";
import Ludo from "./components/display/Ludo";
import Dice from "./components/display/Dice";
import Menu from "./components/display/Menu";
import Head from "./components/display/Head";
import Alert from "./components/display/Alert";
import { chance } from "./components/hooks/utils";
import "react-simple-flex-grid/lib/main.css";
import End from "./components/display/End";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { OptionsProps } from "./types";
import "./App.css";
import Control from "./components/display/Control";
import { StarknetProvider } from "./starknet-provider";

const App = () => {
  const [gameState, setGameState] = useState({});
  const setGameData = useCallback((game) => {
    setGameState(game);
  }, []);

  const [options, setOptions] = useState<OptionsProps>({
    isGame: false,
    playersLength: 0,
    throw: 0,
    chance: 0,
    thrown: false,
    winners: [],
    gameCondition: [],
    isChain: false,
    blockLoading: false,
  });

  const setGameOptions = useCallback((newOption) => {
    setOptions((option) => {
      return {
        ...option,
        ...newOption,
      };
    });
  }, []);

  useEffect(() => {
    if (options.isGame) {
      if (options.winners.length === options.playersLength - 1) {
        toast(
          `The game has ended. Player ${
            chance[options.winners[0]]
          } is the winner`
        );
        setGameOptions({
          isGame: false,
        });
      }
    }
  }, [options, setGameOptions, alert]);

  return (
    <>
      <StarknetProvider>
        <GameContext.Provider
          value={{
            gameState: gameState,
            setGameData: setGameData,
            options: options,
            setGameOptions: setGameOptions,
          }}
        >
          <Row gutter={0}>
            <Col xs={12} sm={12} md={6} lg={6} xl={8}>
              <Ludo />
            </Col>
            <Col xs={12} sm={12} md={6} lg={6} xl={2}>
              <Head />
              <Menu />
              <End />
              <Alert />
              <Dice />
              <Control />
            </Col>
          </Row>
        </GameContext.Provider>
        <ToastContainer position="bottom-center" />
      </StarknetProvider>
    </>
  );
};

export default App;
