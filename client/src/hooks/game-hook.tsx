import { useCallback, useContext } from "react";
import { GameContext } from "../context/game-context";
import { GameOptions } from "../types";
import {
  BoardToPos,
  PosToBoard,
  capColors,
  coloredBlocks,
  markers,
  posReducer,
  safePos,
  startState,
} from "./utils";

export const useGame = () => {
  const { gameState, setGameData, options, setGameOptions } =
    useContext(GameContext);

  const startGame = useCallback(
    async (playersLength: number) => {
      const newGame: { [key: string]: string } = {};
      Object.entries(startState)
        .slice(0, playersLength * 4)
        .map((entry) => {
          newGame[entry[0]] = entry[1];
          return true;
        });
      console.log("START GAME STATE: ", newGame);
      setGameData(newGame);
      setGameOptions({
        gameIsOngoing: true,
        playersLength: playersLength,
        gameCondition: new Array(16).fill(0),
      });
    },
    [setGameData, setGameOptions]
  );

  const incrementChance = useCallback(
    ({
      isChance,
      isThrown,
      chance,
      winners,
      playersLength,
      win,
    }: GameOptions) => {
      let newChance: number;
      newChance = isChance ? chance : (chance + 1) % playersLength;
      while (options.winners.includes(newChance)) {
        newChance = (newChance + 1) % playersLength;
      }
      if (win) {
        winners.push(chance);
        setGameOptions({
          hasThrownDice: isThrown,
          playerChance: newChance,
          winners: winners,
        });
      } else {
        setGameOptions({
          hasThrownDice: isThrown,
          playerChance: newChance,
        });
      }
    },
    [options, setGameOptions]
  );

  const moveValidator = useCallback(
    (diceThrow: number) => {
      setGameOptions({ diceFace: diceThrow });
      const color = options.playerChance;
      const sp = Object.values(startState);
      const colorState = Object.values(gameState).slice(
        color * 4,
        color * 4 + 4
      );
      const check: (0 | 1)[] = colorState.map((c) => {
        if (sp.includes(c) && diceThrow !== 6) {
          return 0;
        } else if (coloredBlocks.includes(c)) {
          const x = parseInt(c.charAt(1));
          if (x === 6 || x + diceThrow > 6) return 0;
        }
        return 1;
      });
      const count = check.filter((v) => v === 0).length;
      if (count === 4) {
        let newChance = (options.playerChance + 1) % options.playersLength;
        while (options.winners.includes(newChance)) {
          newChance = (newChance + 1) % options.playersLength;
        }
        setGameOptions({
          playerChance: newChance,
          hasThrownDice: false,
        });
      }
    },
    [gameState, options, setGameOptions]
  );

  const moveDeducer = (val: number, diceThrow: number) => {
    let newVal: number;
    let isthrown = false;
    let ischance = false;
    if (val === 0 && diceThrow === 6) {
      newVal = 1;
    } else if (val === 0) {
      newVal = 0;
      ischance = true;
      isthrown = true;
    } else {
      const testVal = val + diceThrow;
      if (testVal > 57) {
        newVal = val;
        ischance = true;
      } else if (testVal === 57) {
        newVal = testVal;
        ischance = true;
      } else {
        newVal = testVal;
      }
    }
    return { newVal, ischance, isthrown };
  };

  const moveMarker = useCallback(
    async (pos: string, color: number) => {
      const diceThrow = options.diceFace;

      const j = markers.indexOf(pos);

      // Fetch Current Game Condition
      const gameCondition = options.gameCondition;

      let currentGame: number[] = new Array(16).fill(0);
      let isChance = false;
      let isThrown = false;

      currentGame = BoardToPos(gameCondition);
      let val = currentGame[j];
      const { newVal, ischance, isthrown } = moveDeducer(val, diceThrow);
      isChance = ischance;
      isThrown = isthrown;
      currentGame[j] = newVal;
      currentGame = PosToBoard(currentGame);
      val = currentGame[j];

      if (!safePos.includes(val)) {
        for (let i = 0; i < options.playersLength * 4; i++) {
          // Unsafe Position
          if (color !== Math.floor(i / 4) && currentGame[i] === val) {
            isChance = true;
            currentGame[i] = 0;
          }
        }
      }

      if (diceThrow === 6) {
        isChance = true;
      }

      // -- XX --
      setGameOptions({ gameCondition: currentGame });
      const newGameState = posReducer(currentGame, options.playersLength);
      const colorState = Object.values(newGameState).slice(
        color * 4,
        color * 4 + 4
      );

      let f = 0;
      colorState.map((c) => c === `${capColors[color]}6` && f++);

      setGameData(newGameState);

      incrementChance({
        isChance: isChance,
        isThrown: isThrown,
        chance: options.playerChance,
        playersLength: options.playersLength,
        winners: options.winners,
        win: f === 4,
      });
    },
    [setGameData, options, setGameOptions, incrementChance]
  );

  const endGame = useCallback(() => {
    setGameOptions({
      gameIsOngoing: false,
      playersLength: 0,
      diceFace: 0,
      playerChance: 0,
      hasThrownDice: false,
      winners: [],
      gameCondition: null,
    });
    setGameData({});
  }, [setGameData, setGameOptions]);

  return { startGame, moveValidator, moveMarker, endGame };
};
