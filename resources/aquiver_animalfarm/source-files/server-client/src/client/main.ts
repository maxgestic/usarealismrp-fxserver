import * as sdk from "./client";

onNet('EnteredAnimalFarm', () =>
{
    sdk.Raycast.start();
    sdk.ObjectManager.start();
});
onNet('ExitAnimalFarm', () =>
{
    sdk.Raycast.stop();
    sdk.ObjectManager.stop();
});