import manifest from "../onchain/manifests/dev/deployment/manifest.json";

import { createDojoConfig } from "@dojoengine/core";

export const dojoConfig = createDojoConfig({
  manifest,
  toriiUrl: "http://localhost:8080",
  rpcUrl: "http://localhost:5050",
});
