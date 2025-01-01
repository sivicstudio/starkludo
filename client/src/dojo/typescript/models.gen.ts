import type { SchemaType as ISchemaType } from "@dojoengine/sdk";

import { BigNumberish } from "starknet";

type WithFieldOrder<T> = T & { fieldOrder: string[] };

// Type definition for `starkludo::models::game::Game` struct
export interface Game {
  id: BigNumberish;
  created_by: BigNumberish;
  is_initialised: boolean;
  status: GameStatus;
  mode: GameMode;
  ready_to_start: boolean;
  player_green: BigNumberish;
  player_yellow: BigNumberish;
  player_blue: BigNumberish;
  player_red: BigNumberish;
  winner_1: BigNumberish;
  winner_2: BigNumberish;
  winner_3: BigNumberish;
  next_player: BigNumberish;
  number_of_players: BigNumberish;
  rolls_count: BigNumberish;
  rolls_times: BigNumberish;
  dice_face: BigNumberish;
  player_chance: string;
  has_thrown_dice: boolean;
  b0: BigNumberish;
  b1: BigNumberish;
  b2: BigNumberish;
  b3: BigNumberish;
  g0: BigNumberish;
  g1: BigNumberish;
  g2: BigNumberish;
  g3: BigNumberish;
  r0: BigNumberish;
  r1: BigNumberish;
  r2: BigNumberish;
  r3: BigNumberish;
  y0: BigNumberish;
  y1: BigNumberish;
  y2: BigNumberish;
  y3: BigNumberish;
}

// Type definition for `starkludo::models::game::GameCounter` struct
export interface GameCounter {
  id: BigNumberish;
  current_val: BigNumberish;
}

// Type definition for `starkludo::models::game::GameCounterValue` struct
export interface GameCounterValue {
  current_val: BigNumberish;
}

// Type definition for `starkludo::models::game::GameValue` struct
export interface GameValue {
  created_by: BigNumberish;
  is_initialised: boolean;
  status: GameStatus;
  mode: GameMode;
  ready_to_start: boolean;
  player_green: BigNumberish;
  player_yellow: BigNumberish;
  player_blue: BigNumberish;
  player_red: BigNumberish;
  winner_1: BigNumberish;
  winner_2: BigNumberish;
  winner_3: BigNumberish;
  next_player: BigNumberish;
  number_of_players: BigNumberish;
  rolls_count: BigNumberish;
  rolls_times: BigNumberish;
  dice_face: BigNumberish;
  player_chance: string;
  has_thrown_dice: boolean;
  b0: BigNumberish;
  b1: BigNumberish;
  b2: BigNumberish;
  b3: BigNumberish;
  g0: BigNumberish;
  g1: BigNumberish;
  g2: BigNumberish;
  g3: BigNumberish;
  r0: BigNumberish;
  r1: BigNumberish;
  r2: BigNumberish;
  r3: BigNumberish;
  y0: BigNumberish;
  y1: BigNumberish;
  y2: BigNumberish;
  y3: BigNumberish;
}

// Type definition for `starkludo::models::player::AddressToUsername` struct
export interface AddressToUsername {
  address: string;
  username: BigNumberish;
}

// Type definition for `starkludo::models::player::AddressToUsernameValue` struct
export interface AddressToUsernameValue {
  username: BigNumberish;
}

// Type definition for `starkludo::models::player::Player` struct
export interface Player {
  username: BigNumberish;
  owner: string;
  is_bot: boolean;
  total_games_played: BigNumberish;
  total_games_won: BigNumberish;
}

// Type definition for `starkludo::models::player::PlayerValue` struct
export interface PlayerValue {
  owner: string;
  is_bot: boolean;
  total_games_played: BigNumberish;
  total_games_won: BigNumberish;
}

// Type definition for `starkludo::models::player::UsernameToAddress` struct
export interface UsernameToAddress {
  username: BigNumberish;
  address: string;
}

// Type definition for `starkludo::models::player::UsernameToAddressValue` struct
export interface UsernameToAddressValue {
  address: string;
}

// Type definition for `starkludo::models::game::GameMode` enum
export enum GameMode {
  SinglePlayer,
  MultiPlayer,
}

// Type definition for `starkludo::models::game::GameStatus` enum
export enum GameStatus {
  Initialised,
  Pending,
  Ongoing,
  Waiting,
  Ended,
}

export enum PlayerColor {
  Green,
  Yellow,
  Blue,
  Red,
}

export interface SchemaType extends ISchemaType {
  starkludo: {
    Game: WithFieldOrder<Game>;
    GameCounter: WithFieldOrder<GameCounter>;
    GameCounterValue: WithFieldOrder<GameCounterValue>;
    GameValue: WithFieldOrder<GameValue>;
    AddressToUsername: WithFieldOrder<AddressToUsername>;
    AddressToUsernameValue: WithFieldOrder<AddressToUsernameValue>;
    Player: WithFieldOrder<Player>;
    PlayerValue: WithFieldOrder<PlayerValue>;
    UsernameToAddress: WithFieldOrder<UsernameToAddress>;
    UsernameToAddressValue: WithFieldOrder<UsernameToAddressValue>;
  };
}
export const schema: SchemaType = {
  starkludo: {
    Game: {
      fieldOrder: [
        "id",
        "created_by",
        "is_initialised",
        "status",
        "mode",
        "ready_to_start",
        "player_green",
        "player_yellow",
        "player_blue",
        "player_red",
        "winner_1",
        "winner_2",
        "winner_3",
        "next_player",
        "number_of_players",
        "rolls_count",
        "rolls_times",
        "dice_face",
        "player_chance",
        "has_thrown_dice",
        "b0",
        "b1",
        "b2",
        "b3",
        "g0",
        "g1",
        "g2",
        "g3",
        "r0",
        "r1",
        "r2",
        "r3",
        "y0",
        "y1",
        "y2",
        "y3",
      ],
      id: 0,
      created_by: 0,
      is_initialised: false,
      status: GameStatus.Initialised,
      mode: GameMode.SinglePlayer,
      ready_to_start: false,
      player_green: 0,
      player_yellow: 0,
      player_blue: 0,
      player_red: 0,
      winner_1: 0,
      winner_2: 0,
      winner_3: 0,
      next_player: 0,
      number_of_players: 0,
      rolls_count: 0,
      rolls_times: 0,
      dice_face: 0,
      player_chance: "",
      has_thrown_dice: false,
      b0: 0,
      b1: 0,
      b2: 0,
      b3: 0,
      g0: 0,
      g1: 0,
      g2: 0,
      g3: 0,
      r0: 0,
      r1: 0,
      r2: 0,
      r3: 0,
      y0: 0,
      y1: 0,
      y2: 0,
      y3: 0,
    },
    GameCounter: {
      fieldOrder: ["id", "current_val"],
      id: 0,
      current_val: 0,
    },
    GameCounterValue: {
      fieldOrder: ["current_val"],
      current_val: 0,
    },
    GameValue: {
      fieldOrder: [
        "created_by",
        "is_initialised",
        "status",
        "mode",
        "ready_to_start",
        "player_green",
        "player_yellow",
        "player_blue",
        "player_red",
        "winner_1",
        "winner_2",
        "winner_3",
        "next_player",
        "number_of_players",
        "rolls_count",
        "rolls_times",
        "dice_face",
        "player_chance",
        "has_thrown_dice",
        "b0",
        "b1",
        "b2",
        "b3",
        "g0",
        "g1",
        "g2",
        "g3",
        "r0",
        "r1",
        "r2",
        "r3",
        "y0",
        "y1",
        "y2",
        "y3",
      ],
      created_by: 0,
      is_initialised: false,
      status: GameStatus.Initialised,
      mode: GameMode.SinglePlayer,
      ready_to_start: false,
      player_green: 0,
      player_yellow: 0,
      player_blue: 0,
      player_red: 0,
      winner_1: 0,
      winner_2: 0,
      winner_3: 0,
      next_player: 0,
      number_of_players: 0,
      rolls_count: 0,
      rolls_times: 0,
      dice_face: 0,
      player_chance: "",
      has_thrown_dice: false,
      b0: 0,
      b1: 0,
      b2: 0,
      b3: 0,
      g0: 0,
      g1: 0,
      g2: 0,
      g3: 0,
      r0: 0,
      r1: 0,
      r2: 0,
      r3: 0,
      y0: 0,
      y1: 0,
      y2: 0,
      y3: 0,
    },
    AddressToUsername: {
      fieldOrder: ["address", "username"],
      address: "",
      username: 0,
    },
    AddressToUsernameValue: {
      fieldOrder: ["username"],
      username: 0,
    },
    Player: {
      fieldOrder: [
        "username",
        "owner",
        "is_bot",
        "total_games_played",
        "total_games_won",
      ],
      username: 0,
      owner: "",
      is_bot: false,
      total_games_played: 0,
      total_games_won: 0,
    },
    PlayerValue: {
      fieldOrder: ["owner", "is_bot", "total_games_played", "total_games_won"],
      owner: "",
      is_bot: false,
      total_games_played: 0,
      total_games_won: 0,
    },
    UsernameToAddress: {
      fieldOrder: ["username", "address"],
      username: 0,
      address: "",
    },
    UsernameToAddressValue: {
      fieldOrder: ["address"],
      address: "",
    },
  },
};
export enum ModelsMapping {
  Game = "starkludo-Game",
  GameCounter = "starkludo-GameCounter",
  GameCounterValue = "starkludo-GameCounterValue",
  GameMode = "starkludo-GameMode",
  GameStatus = "starkludo-GameStatus",
  GameValue = "starkludo-GameValue",
  PlayerColor = "starkludo-PlayerColor",
  AddressToUsername = "starkludo-AddressToUsername",
  AddressToUsernameValue = "starkludo-AddressToUsernameValue",
  Player = "starkludo-Player",
  PlayerValue = "starkludo-PlayerValue",
  UsernameToAddress = "starkludo-UsernameToAddress",
  UsernameToAddressValue = "starkludo-UsernameToAddressValue",
}
