<<<<<<< HEAD
import { useContext } from "react";
import { DojoContext } from "./DojoContext";

export const useDojo = () => {
    const context = useContext(DojoContext);
    if (!context)
        throw new Error(
            "The `useDojo` hook must be used within a `DojoProvider`"
        );

    return {
        setup: context,
        account: context.account,
    };
};
=======
import { useContext } from "react";
import { DojoContext } from "./DojoContext";

export const useDojo = () => {
  const context = useContext(DojoContext);
  if (!context)
    throw new Error("The `useDojo` hook must be used within a `DojoProvider`");

  return {
    setup: context,
    account: context.account,
    system: context.systemCalls,
  };
};
>>>>>>> c43c6f1d481754a137db14df3d2d25dbafa13db0
