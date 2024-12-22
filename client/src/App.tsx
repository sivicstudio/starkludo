import { useState, useEffect, useCallback } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { Row, Col } from "react-simple-flex-grid";
import { GameContext } from "./context/game-context";
import Ludo from "./components/Ludo";
import Dice from "./components/Dice";
import Menu from "./components/Menu";
import Header from "./components/Header";
import ColorSettings from "./components/ColorSettings";
import Alert from "./components/Alert";
import Footer from "./components/Footer";
import { chance } from "./hooks/utils";
import "react-simple-flex-grid/lib/main.css";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { OptionsProps } from "./types";
import "./App.css";
import Control from "./components/Control";
import { StarknetProvider } from "./starknet-provider";
import { FiAlertTriangle, FiZap } from "react-icons/fi";
import { BoardContext, BoardType } from "./context/board-context";
import { DiceProvider } from "./context/dice-context";
import { ColorProvider } from "./context/color-context";
import ControlWindowLayout from "./components/ControlWindows/ControlWindowLayout";
import GameHelp from "./components/ControlWindows/GameHelp";
import Toolbox from "./components/ControlWindows/Toolbox";
import Multiplayer from "./components/ControlWindows/Multiplayer";
import Leaderboard from "./components/ControlWindows/Leaderboard";
import GameAccount from "./components/ControlWindows/GameAccount";
import MobileResponsiveWarning from "./components/MobileResponsiveWarning";
import { StarkludoSchemaType } from "./dojo/gen/models.gen";
import { SDK } from "@dojoengine/sdk";
import Settings from "./components/Settings";

const App = ({ sdk }: { sdk: SDK<StarkludoSchemaType> }) => {
  console.log("SDK initialized:", sdk);

  const [activeWindow, setActiveWindow] = useState("");
  const [showMobileResponsiveWarning, setShowMobileResponsiveWarning] =
    useState(false);
  const [board, setBoard] = useState<BoardType>("classic");
  const [gameState, setGameState] = useState({});
  const [activeCategory, setActiveCategory] = useState("BOARD");
  const [options, setOptions] = useState<OptionsProps>({
    gameIsOngoing: false,
    playersLength: 0,
    diceFace: 0,
    playerChance: 0,
    hasThrownDice: false,
    winners: [],
    gameCondition: [],
  });

  const toggleActiveWindow = (window: string) => {
    if (window === activeWindow) {
      setActiveWindow("");
      return;
    }
    setActiveWindow(window);
  };

  const toggleBoard = (newBoard: BoardType) => {
    setBoard(newBoard);
  };

  const handleCategoryClick = (category: string) => {
    setActiveCategory(category);
  };

  const setGameData = useCallback((game: object) => {
    setGameState(game);
  }, []);

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
          `The game has ended. Player ${
            chance[options.winners[0]]
          } is the winner`
        );
        setGameOptions({
          gameIsOngoing: false,
        });
      }
    }

    const trackScreenSize = () => {
      setShowMobileResponsiveWarning(window.innerWidth < 845);
    };

    trackScreenSize();

    window.addEventListener("resize", trackScreenSize);

    return () => {
      window.removeEventListener("resize", trackScreenSize);
    };
  }, [options, setGameOptions]);

  return (
    <>
      <Router>
        {showMobileResponsiveWarning ? (
          <MobileResponsiveWarning />
        ) : (
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
                <BoardContext.Provider value={{ board, toggleBoard }}>
                  <ColorProvider>
                    <DiceProvider>
                      <Routes>
                        <Route
                          path="/color-settings"
                          element={<ColorSettings />}
                        />
                        <Route path="/settings" element={<Settings />} />
                        <Route
                          path="/"
                          element={
                            <>
                              <div className="game-behaviour-warning">
                                <FiAlertTriangle size={20} />
                                StarkLudo is still in active development{" "}
                                <FiZap color="yellow" size={20} />
                              </div>
                              <div className="layout-container">
                                <div className="layout-stretch-lock">
                                  <div className="mobile-header">
                                    <Header />
                                  </div>
                                  <Row gutter={0}>
                                    <Col xs={12} sm={12} md={7} lg={7}>
                                      <Ludo />
                                    </Col>
                                    <Col xs={12} sm={12} md={5} lg={5}>
                                      <div className="sidebar">
                                        <div>
                                          <div>
                                            <div className="desktop-header">
                                              <Header />
                                            </div>
                                            <Menu />
                                            {/* <RestartGame /> */}
                                            <Alert />
                                            <Dice />
                                            {activeWindow === "account" ? (
                                              <ControlWindowLayout
                                                toggle={() =>
                                                  setActiveWindow("")
                                                }
                                                title="PROFILE"
                                                subtitle="Your Profile Information"
                                              >
                                                <GameAccount />
                                              </ControlWindowLayout>
                                            ) : null}

                                            {activeWindow === "leaderboard" ? (
                                              <ControlWindowLayout
                                                toggle={() =>
                                                  setActiveWindow("")
                                                }
                                                title="LEADERBOARD"
                                                subtitle="Global Player Rankings"
                                              >
                                                <Leaderboard />
                                              </ControlWindowLayout>
                                            ) : null}

                                            {activeWindow === "multiplayer" ? (
                                              <ControlWindowLayout
                                                toggle={() =>
                                                  setActiveWindow("")
                                                }
                                                title="MULTIPLAYER"
                                                subtitle="Choose An Account To Play With"
                                              >
                                                <Multiplayer />
                                              </ControlWindowLayout>
                                            ) : null}

                                            {activeWindow === "toolbox" ? (
                                              <ControlWindowLayout
                                                toggle={() =>
                                                  setActiveWindow("")
                                                }
                                                title="TOOLBOX"
                                                subtitle="Get All Your Items And Settings Done"
                                              >
                                                <Toolbox
                                                  activeCategory={
                                                    activeCategory
                                                  }
                                                  onCategoryClick={
                                                    handleCategoryClick
                                                  }
                                                />
                                              </ControlWindowLayout>
                                            ) : null}

                                            {activeWindow === "help" && (
                                              <GameHelp
                                                onClose={() =>
                                                  setActiveWindow("")
                                                }
                                              />
                                            )}
                                            <Control
                                              toggleActiveWindow={
                                                toggleActiveWindow
                                              }
                                            />
                                          </div>
                                        </div>
                                      </div>
                                    </Col>
                                  </Row>
                                </div>
                              </div>
                              <Footer />
                            </>
                          }
                        />
                      </Routes>
                    </DiceProvider>
                  </ColorProvider>
                </BoardContext.Provider>
              </GameContext.Provider>
              <ToastContainer position="bottom-center" />
            </StarknetProvider>
          </>
        )}
      </Router>
    </>
  );
};

export default App;
