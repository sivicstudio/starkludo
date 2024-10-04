<<<<<<< HEAD
import { overridableComponent } from "@dojoengine/recs";
import { ContractComponents } from "./generated/contractComponents";

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
    contractComponents,
}: {
    contractComponents: ContractComponents;
}) {
    return {
        ...contractComponents,
        Position: overridableComponent(contractComponents.Position),
        Moves: overridableComponent(contractComponents.Moves),
    };
}
=======
import { ContractComponents } from "./typescript/models.gen";

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
  contractComponents,
}: {
  contractComponents: ContractComponents;
}) {
  return {
    ...contractComponents,
  };
}
>>>>>>> c43c6f1d481754a137db14df3d2d25dbafa13db0
