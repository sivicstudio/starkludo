import { QueryBuilder, SDK } from "@dojoengine/sdk";
import { addAddressPadding } from "starknet";
import { useDojoStore } from "../dojo/hooks/useDojoStote";
import { SchemaType } from "../dojo/typescript/models.gen";

export async function getUsernameFromAddress(
  address: string,
  sdk: SDK<SchemaType>,
  state: any
) {
  try {
    await sdk.getEntities({
      query: new QueryBuilder<SchemaType>()
        .namespace("starkludo", (n) =>
          n.entity("AddressToUsername", (e) =>
            e.eq("address", addAddressPadding(address))
          )
        )
        .build(),
      callback: (resp) => {
        if (resp.error) {
          console.error("resp.error.message:", resp.error.message);
          return;
        }
        if (resp.data) {
          state.setEntities(resp.data);
        }
      },
    });
  } catch (error) {
    console.error("Error querying entities:", error);
  }
}
