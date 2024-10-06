// Generated by dojo-bindgen on Mon, 30 Sep 2024 04:07:50 +0000. Do not modify this file manually.
// Import the necessary types from the recs SDK
// generate again with `sozo build --typescript`
import { defineComponent, Type as RecsType, World } from "@dojoengine/recs";

export type ContractComponents = Awaited<
  ReturnType<typeof defineContractComponents>
>;

// Type definition for `starkludo::models::game::GameMode` enum
export type GameMode = { type: "SinglePlayer" } | { type: "MultiPlayer" };

export const GameModeDefinition = {
  type: RecsType.String,
  value: RecsType.String,
};

// Type definition for `starkludo::models::game::GameStatus` enum
export type GameStatus =
  | { type: "Ongoing" }
  | { type: "Waiting" }
  | { type: "Ended" };

export const GameStatusDefinition = {
  type: RecsType.String,
  value: RecsType.String,
};

// Type definition for `dojo::model::layout::Layout` enum
export type Layout =
  | { type: "Fixed"; value: RecsType.NumberArray }
  | { type: "Struct"; value: RecsType.StringArray }
  | { type: "Tuple"; value: RecsType.StringArray }
  | { type: "Array"; value: RecsType.StringArray }
  | { type: "ByteArray" }
  | { type: "Enum"; value: RecsType.StringArray };

export const LayoutDefinition = {
  type: RecsType.String,
  value: RecsType.String,
};

// Type definition for `core::byte_array::ByteArray` struct
export interface ByteArray {
  data: String[];
  pending_word: BigInt;
  pending_word_len: Number;
}
export const ByteArrayDefinition = {
  data: RecsType.StringArray,
  pending_word: RecsType.BigInt,
  pending_word_len: RecsType.Number,
};

// Type definition for `dojo::model::layout::FieldLayout` struct
export interface FieldLayout {
  selector: BigInt;
  layout: Layout;
}
export const FieldLayoutDefinition = {
  selector: RecsType.BigInt,
  layout: LayoutDefinition,
};

export const U256Definition = {
  low: RecsType.BigInt,
  high: RecsType.BigInt,
};

// Type definition for `starkludo::models::game::Game` struct
export interface Game {
  id: Number;
  created_by: BigInt;
  game_status: GameStatus;
  game_mode: GameMode;
  player_green: BigInt;
  player_yellow: BigInt;
  player_blue: BigInt;
  player_red: BigInt;
  winner_1: BigInt;
  winner_2: BigInt;
  winner_3: BigInt;
  next_player: BigInt;
  number_of_players: Number;
  rolls_count: U256;
  rolls_times: U256;
  dice_face: Number;
  player_chance: BigInt;
  has_thrown_dice: Boolean;
  b0: BigInt;
  b1: BigInt;
  b2: BigInt;
  b3: BigInt;
  g0: BigInt;
  g1: BigInt;
  g2: BigInt;
  g3: BigInt;
  r0: BigInt;
  r1: BigInt;
  r2: BigInt;
  r3: BigInt;
  y0: BigInt;
  y1: BigInt;
  y2: BigInt;
  y3: BigInt;
}
export const GameDefinition = {
  id: RecsType.Number,
  created_by: RecsType.BigInt,
  game_status: GameStatusDefinition,
  game_mode: GameModeDefinition,
  player_green: RecsType.BigInt,
  player_yellow: RecsType.BigInt,
  player_blue: RecsType.BigInt,
  player_red: RecsType.BigInt,
  winner_1: RecsType.BigInt,
  winner_2: RecsType.BigInt,
  winner_3: RecsType.BigInt,
  next_player: RecsType.BigInt,
  number_of_players: RecsType.Number,
  rolls_count: U256Definition,
  rolls_times: U256Definition,
  dice_face: RecsType.Number,
  player_chance: RecsType.BigInt,
  has_thrown_dice: RecsType.Boolean,
  b0: RecsType.BigInt,
  b1: RecsType.BigInt,
  b2: RecsType.BigInt,
  b3: RecsType.BigInt,
  g0: RecsType.BigInt,
  g1: RecsType.BigInt,
  g2: RecsType.BigInt,
  g3: RecsType.BigInt,
  r0: RecsType.BigInt,
  r1: RecsType.BigInt,
  r2: RecsType.BigInt,
  r3: RecsType.BigInt,
  y0: RecsType.BigInt,
  y1: RecsType.BigInt,
  y2: RecsType.BigInt,
  y3: RecsType.BigInt,
};

// Type definition for `core::integer::u256` struct
export interface U256 {
  low: BigInt;
  high: BigInt;
}

// Type definition for `starkludo::models::player::Player` struct
export interface Player {
  username: BigInt;
  owner: BigInt;
  total_games_played: U256;
  total_games_won: U256;
}
export const PlayerDefinition = {
  username: RecsType.BigInt,
  owner: RecsType.BigInt,
  total_games_played: U256Definition,
  total_games_won: U256Definition,
};

export function defineContractComponents(world: World) {
  return {
    // Model definition for `starkludo::models::game::Game` model
    Game: (() => {
      return defineComponent(
        world,
        {
          id: RecsType.Number,
          created_by: RecsType.BigInt,
          game_status: RecsType.String,
          game_mode: RecsType.String,
          player_green: RecsType.BigInt,
          player_yellow: RecsType.BigInt,
          player_blue: RecsType.BigInt,
          player_red: RecsType.BigInt,
          winner_1: RecsType.BigInt,
          winner_2: RecsType.BigInt,
          winner_3: RecsType.BigInt,
          next_player: RecsType.BigInt,
          number_of_players: RecsType.Number,
          rolls_count: U256Definition,
          rolls_times: U256Definition,
          dice_face: RecsType.Number,
          player_chance: RecsType.BigInt,
          has_thrown_dice: RecsType.Boolean,
          b0: RecsType.BigInt,
          b1: RecsType.BigInt,
          b2: RecsType.BigInt,
          b3: RecsType.BigInt,
          g0: RecsType.BigInt,
          g1: RecsType.BigInt,
          g2: RecsType.BigInt,
          g3: RecsType.BigInt,
          r0: RecsType.BigInt,
          r1: RecsType.BigInt,
          r2: RecsType.BigInt,
          r3: RecsType.BigInt,
          y0: RecsType.BigInt,
          y1: RecsType.BigInt,
          y2: RecsType.BigInt,
          y3: RecsType.BigInt,
        },
        {
          metadata: {
            namespace: "starkludo",
            name: "Game",
            types: [
              "u64",
              "ContractAddress",
              "GameStatus",
              "GameMode",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "u8",
              "u8",
              "ContractAddress",
              "bool",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
              "felt252",
            ],
            customTypes: ["U256", "U256"],
          },
        },
      );
    })(),

    // Model definition for `starkludo::models::player::Player` model
    Player: (() => {
      return defineComponent(
        world,
        {
          username: RecsType.BigInt,
          owner: RecsType.BigInt,
          total_games_played: U256Definition,
          total_games_won: U256Definition,
        },
        {
          metadata: {
            namespace: "starkludo",
            name: "Player",
            types: ["felt252", "ContractAddress"],
            customTypes: ["U256", "U256"],
          },
        },
      );
    })(),
  };
}
