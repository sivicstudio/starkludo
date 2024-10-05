export type OptionsProps = {
  gameIsOngoing: boolean; // true if game is ongoing, false otherwise
  playersLength: number; // Number of players in current game
  diceFace: number; // Current number on dice face
  playerChance: number; // Next player to take action. 0 => red, 1 blue...
  hasThrownDice: boolean; // true if dice has been thrown and waiting for action from player, false otherwise
  winners: number[];
  gameCondition: number[];
};

type WinnerList = number[];

export type GameOptions = {
  isChance: boolean;
  isThrown: boolean;
  chance: number;
  playersLength: number;
  winners: WinnerList;
  win: boolean;
};

//Marker Component
export type MarkerProps = {
  pos: string;
  size: number;
  tileMap: Record<number, number[]>;
};
