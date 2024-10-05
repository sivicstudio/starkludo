import { getEvents } from "@dojoengine/utils";
import { AccountInterface } from "starknet";
import { ClientComponents } from "./createClientComponents";

import type { IWorld } from "./typescript/contracts.gen";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { client }: { client: IWorld },
  /* eslint-disable @typescript-eslint/no-unused-vars */
  contractComponents: ClientComponents
) {
  /* eslint-disable  @typescript-eslint/no-explicit-any */
  const createUsername = async (account: AccountInterface, username: any) => {
    try {
      const { transaction_hash } = await client.PlayerActions.create({
        account,
        username,
      });
      const transaction = await account.waitForTransaction(transaction_hash, {
        retryInterval: 100,
      });

      const events = getEvents(transaction);
      console.log("events: ", events);
    } catch (error) {
      console.log(error);
    }
  };

  return { createUsername };
}