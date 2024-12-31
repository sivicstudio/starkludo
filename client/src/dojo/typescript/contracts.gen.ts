import { DojoProvider } from "@dojoengine/core";
import { Account, AccountInterface, BigNumberish, CairoOption, CairoCustomEnum, ByteArray } from "starknet";
import * as models from "./models.gen";

export function setupWorld(provider: DojoProvider) {

	const GameActions_create = async (snAccount: Account | AccountInterface, gameMode: models.GameMode, playerGreen: BigNumberish, playerYellow: BigNumberish, playerBlue: BigNumberish, playerRed: BigNumberish, numberOfPlayers: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "GameActions",
					entrypoint: "create",
					calldata: [gameMode, playerGreen, playerYellow, playerBlue, playerRed, numberOfPlayers],
				},
				"starkludo",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const GameActions_start = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "GameActions",
					entrypoint: "start",
					calldata: [],
				},
				"starkludo",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const GameActions_join = async (snAccount: Account | AccountInterface, username: BigNumberish, selectedColor: BigNumberish, gameId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "GameActions",
					entrypoint: "join",
					calldata: [username, selectedColor, gameId],
				},
				"starkludo",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const GameActions_move = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "GameActions",
					entrypoint: "move",
					calldata: [],
				},
				"starkludo",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const GameActions_roll = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "GameActions",
					entrypoint: "roll",
					calldata: [],
				},
				"starkludo",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const GameActions_getCurrentGameId = async () => {
		try {
			return await provider.call("starkludo", {
				contractName: "GameActions",
				entrypoint: "get_current_game_id",
				calldata: [],
			});
		} catch (error) {
			console.error(error);
		}
	};

	const GameActions_createNewGameId = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "GameActions",
					entrypoint: "create_new_game_id",
					calldata: [],
				},
				"starkludo",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const GameActions_createNewPlayer = async (snAccount: Account | AccountInterface, username: BigNumberish, isBot: boolean) => {
		try {
			return await provider.execute(
				snAccount,
				{
					contractName: "GameActions",
					entrypoint: "create_new_player",
					calldata: [username, isBot],
				},
				"starkludo",
			);
		} catch (error) {
			console.error(error);
		}
	};

	const GameActions_getUsernameFromAddress = async (address: string) => {
		try {
			return await provider.call("starkludo", {
				contractName: "GameActions",
				entrypoint: "get_username_from_address",
				calldata: [address],
			});
		} catch (error) {
			console.error(error);
		}
	};

	const GameActions_getAddressFromUsername = async (username: BigNumberish) => {
		try {
			return await provider.call("starkludo", {
				contractName: "GameActions",
				entrypoint: "get_address_from_username",
				calldata: [username],
			});
		} catch (error) {
			console.error(error);
		}
	};

	return {
		GameActions: {
			create: GameActions_create,
			start: GameActions_start,
			join: GameActions_join,
			move: GameActions_move,
			roll: GameActions_roll,
			getCurrentGameId: GameActions_getCurrentGameId,
			createNewGameId: GameActions_createNewGameId,
			createNewPlayer: GameActions_createNewPlayer,
			getUsernameFromAddress: GameActions_getUsernameFromAddress,
			getAddressFromUsername: GameActions_getAddressFromUsername,
		},
	};
}