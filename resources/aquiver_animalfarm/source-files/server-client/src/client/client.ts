import * as Aquiver from "@aquiversdk/client";
Aquiver.Config.Framework = "CUSTOM";

export * from "./Camera/client-camera";
export * from "./Objects/client-object";
export * from "./Particle/client-particle";
export * from "./Peds/client-ped";
export * from "./Doors/client-door";
export * from "./Player/client-player";
export * from "./Raycast/client-raycast";
export * from "./Farm/client-farm";

export * as methods from "./methods"

import "./main.ts"