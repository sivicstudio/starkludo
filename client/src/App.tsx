import { useState, useEffect, useCallback } from "react";
import { Row, Col } from "react-simple-flex-grid";
import { GameContext } from "./context/game-context";
import Ludo from "./components/Ludo";
import Dice from "./components/Dice";
import Menu from "./components/Menu";
import Header from "./components/Header";

import Alert from "./components/Alert";
import Footer from "./components/Footer";
import { chance } from "./hooks/utils";
import "react-simple-flex-grid/lib/main.css";
import RestartGame from "./components/RestartGame";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { OptionsProps } from "./types";
import "./App.css";
import Control from "./components/Control";
import { StarknetProvider } from "./starknet-provider";
import { FiAlertTriangle, FiZap } from "react-icons/fi";
import { BoardContext, BoardType } from "./context/board-context";

const App = () => {
  const [board, setBoard] = useState<BoardType>('classic');

  const toggleBoard = (newBoard: BoardType) => {
    setBoard(newBoard);
  };
  const [gameState, setGameState] = useState({});
  const setGameData = useCallback((game: any) => {
    setGameState(game);
  }, []);

  const [options, setOptions] = useState<OptionsProps>({
    gameIsOngoing: false,
    playersLength: 0,
    diceFace: 0,
    playerChance: 0,
    hasThrownDice: false,
    winners: [],
    gameCondition: [],
  });

  const setGameOptions = useCallback((newOption: Partial<OptionsProps>) => {
    setOptions((option) => {
      return {
        ...option,
        ...newOption,
      };
    });
  }, []);

  useEffect(() => {
    if (options.gameIsOngoing) {
      if (options.winners.length === options.playersLength - 1) {
        toast(
          `The game has ended. Player ${chance[options.winners[0]]
          } is the winner`
        );
        setGameOptions({
          gameIsOngoing: false,
        });
      }
    }
  }, [options, setGameOptions]);

  return (
    <>
      <StarknetProvider>
        <GameContext.Provider value={{
          gameState: gameState,
          setGameData: setGameData,
          options: options,
          setGameOptions: setGameOptions,
        }}>
          <BoardContext.Provider value={{ board, toggleBoard }}>
            <div className="game-behaviour-warning">
              <FiAlertTriangle size={40} style={{ marginRight: "10px" }} />
              StarkLudo is still in active development{" "}
              <FiZap color="yellow" size={20} />
            </div>
            <div className="layout-container">
              <div className="mobile-header">
                <Header />
              </div>
              <Row gutter={0}>
                <Col xs={12} sm={12} md={6} lg={6}>
                  <Ludo />
                </Col>
                <Col xs={12} sm={12} md={6} lg={6}>
                  <div className="desktop-header">
                    <Header />
                  </div>
                  <Menu />
                  <RestartGame />
                  <Alert />
                  <Dice />
                  <Control />
                </Col>
              </Row>
              <Footer />
            </div>
          </BoardContext.Provider>
        </GameContext.Provider>
        <ToastContainer position="bottom-center" />
      </StarknetProvider>
    </>
  );
};

export default App;
