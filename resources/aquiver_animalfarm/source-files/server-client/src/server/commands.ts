import { FarmCreateInfoInterface, FarmCreatorListInterface } from '../../../shared/shared-types';
import { AnimalFarm } from './Farm/server-farm-class';
import * as sdk from './server';
import * as AquiverShared from "@aquiversdk/shared";

/** Development commands

/** You can delete this /farmskin command if you want. I just needed it for the images and video. */
// RegisterCommand('farmskin', (source: string) =>
// {
//     const Player = sdk.PlayerManager.at(source);
//     if (!Player || !Player.isAdmin) return;

//     SetPlayerModel(source, GetHashKey('a_m_m_farmer_01'));
// }, false);

// RegisterCommand('spawnshit', (source: string) =>
// {
//     const Player = sdk.PlayerManager.at(source);
//     if (!Player || !Player.isAdmin) return;

//     const farmPaddocks = sdk.paddocks.getFarmPaddocks(Player.dimension);
//     if (!farmPaddocks) return;
//     farmPaddocks.forEach(paddock =>
//     {
//         paddock.SpawnShit();
//     });
// }, false);

// RegisterCommand('givemilk', (source: string) =>
// {
//     const Player = sdk.PlayerManager.at(source);
//     if (!Player || !Player.isAdmin) return;

//     const farmPaddocks = sdk.paddocks.getFarmPaddocks(Player.dimension);
//     if (!farmPaddocks) return;
//     farmPaddocks.forEach(paddock =>
//     {
//         paddock.Animals.forEach(animal =>
//         {
//             switch (animal.animalType)
//             {
//                 case "COW": {
//                     animal.milk += 85;
//                     break;
//                 }
//                 case "PIG": {
//                     animal.weight += 90;
//                     break;
//                 }
//             }
//         });
//     });

// }, false);

// RegisterCommand('spawnloot', (source: string) =>
// {
//     const Player = sdk.PlayerManager.at(source);
//     if (!Player || !Player.isAdmin) return;

//     const farmLoots = sdk.loots.getFarmLoots(Player.dimension);
//     if (!farmLoots) return;

//     farmLoots.eggLoot = farmLoots.getMaxEggLoot;
//     farmLoots.mealLoot = farmLoots.getMaxMealLoot;
//     farmLoots.milkLoot = farmLoots.getMaxMilkLoot;
// }, false);

// RegisterCommand('farmatt', (source: number | string, args: string[]) =>
// {
//     const Player = sdk.PlayerManager.at(source);
//     if (!Player) return;

//     /** Return instantly if player is not admin. */
//     if (!Player.hasPermission('admin')) return;

//     const [name, pos, rot, bone] = args;

//     if (!name || !pos || !rot || !bone)
//         return Player.sendChat('/farmatt [name] [x-y-z] [x-y-z] [bone]');

//     const [x, y, z] = pos.split('-');
//     const [rx, ry, rz] = rot.split('-');

//     Player.setAttachmentOffset(
//         name as any,
//         new AquiverShared.Vec3(parseFloat(x), parseFloat(y), parseFloat(z)),
//         new AquiverShared.Vec3(parseFloat(rx), parseFloat(ry), parseFloat(rz)),
//         parseInt(bone)
//     );
// }, false);

RegisterCommand(
    'afarm',
    (source: number) => {
        const Player = sdk.PlayerManager.at(source);
        if (!Player) return;
        /** Return instantly if player is not admin. */
        if (!Player.hasPermission('admin')) return;

        const FarmsArray = sdk.FarmsManager.toArray();
        const FarmsFormat: Array<FarmCreatorListInterface> = FarmsArray.map((a) => {
            return {
                id: a.farmId,
                img: a.img,
                locked: a.locked,
                name: a.name,
                opened: false,
                ownerIdentifier: a.ownerIdentifier,
                ownerName: a.ownerName,
                price: a.price,
            };
        });

        Player.TriggerChromium({
            event: 'open-farmcreator',
            data: {
                Farms: FarmsFormat,
            },
        });
    },
    false
);

onNet('farm-admin-set-price', (d: { price: any; farmId: any }) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.hasPermission('admin')) return;

    const farmId = parseInt(d.farmId),
        price = parseInt(d.price);

    if (isNaN(price) || price < 1) return Player.Notification('Invalid price input!');

    const Farm = sdk.FarmsManager.at(farmId);
    if (!Farm) return Player.Notification(`Farm not exist with id: ${farmId}`);

    Farm.price = price;
    Player.Notification(`(${Farm.farmId}) ${Farm.name} price changed to: ${price}.`);
    UpdateFarmCreator(Player, Farm);
});

onNet('farm-admin-set-name', (d: { name: string; farmId: any }) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.hasPermission('admin')) return;

    const farmId = parseInt(d.farmId),
        name = d.name.toString();

    const minChars = 3;

    if (name.length < minChars) return Player.Notification(`Minimum ${minChars} characters for the farm name.`);

    const Farm = sdk.FarmsManager.at(farmId);
    if (!Farm) return Player.Notification(`Farm not exist with id: ${farmId}`);

    Farm.name = name;
    Player.Notification(`(${Farm.farmId}) ${Farm.name} changed name to: ${name}.`);
    UpdateFarmCreator(Player, Farm);
});

onNet('farm-admin-set-image', (d: { url: string; farmId: any }) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.hasPermission('admin')) return;

    const farmId = parseInt(d.farmId),
        url = d.url.toString();

    const Farm = sdk.FarmsManager.at(farmId);
    if (!Farm) return Player.Notification(`Farm not exist with id: ${farmId}`);

    Farm.img = url;
    Player.Notification(`(${Farm.farmId}) ${Farm.name} changed image to: ${url}.`);
    UpdateFarmCreator(Player, Farm);
});

onNet('farm-admin-set-ownerIdentifier', (d: { identifier: string; farmId: any }) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.hasPermission('admin')) return;

    const farmId = parseInt(d.farmId),
        identifier = d.identifier.toString();

    const Farm = sdk.FarmsManager.at(farmId);
    if (!Farm) return Player.Notification(`Farm not exist with id: ${farmId}`);

    Farm.ownerIdentifier = identifier;
    Player.Notification(`${Farm.farmId} ${Farm.name} changed ownerIdentifier to: ${identifier}.`);
    UpdateFarmCreator(Player, Farm);
});

onNet('farm-admin-goto', (farmId: any) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.hasPermission('admin')) return;

    farmId = parseInt(farmId);

    const Farm = sdk.FarmsManager.at(farmId);
    if (!Farm) return Player.Notification(`Farm not exist with id: ${farmId}`);

    Player.position = new AquiverShared.Vec3(Farm.position.x, Farm.position.y, Farm.position.z);
    Player.Notification(`Successfully teleported to (${Farm.farmId}) ${Farm.name}.`);
    UpdateFarmCreator(Player, Farm);
});

onNet('farm-admin-resell', (farmId: any) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.hasPermission('admin')) return;

    farmId = parseInt(farmId);

    const Farm = sdk.FarmsManager.at(farmId);
    if (!Farm) return Player.Notification(`Farm not exist with id: ${farmId}`);

    Farm.ownerIdentifier = null;
    Farm.ownerName = null;
    Player.Notification('You resold the Farm, it is buyable again.');
    UpdateFarmCreator(Player, Farm);
});

onNet('farm-admin-set-position', (farmId: any) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.hasPermission('admin')) return;

    farmId = parseInt(farmId);

    const Farm = sdk.FarmsManager.at(farmId);
    if (!Farm) return Player.Notification(`Farm not exist with id: ${farmId}`);

    Farm.position = Player.position;
    Player.Notification(`(${Farm.farmId}) ${Farm.name} position changed to your location.`);
    UpdateFarmCreator(Player, Farm);
});

onNet('farm-admin-set-lock', (farmId: any) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.hasPermission('admin')) return;

    farmId = parseInt(farmId);

    const Farm = sdk.FarmsManager.at(farmId);
    if (!Farm) return Player.Notification(`Farm not exist with id: ${farmId}`);

    Farm.locked = !Farm.locked;
    Player.Notification(`(${Farm.farmId}) ${Farm.name} ${Farm.locked ? 'locked.' : 'unlocked.'}`);
    UpdateFarmCreator(Player, Farm);
});

onNet('farm-admin-create-farm', (d: FarmCreateInfoInterface) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.hasPermission('admin')) return;

    const Position = Player.position;

    const price = parseInt(d.price as any);
    if (isNaN(price) || price < 1 || typeof price !== 'number') return;

    const minChars = 3;
    if (d.name.length < minChars) return Player.Notification(`Minimum ${minChars} characters for the farm name.`);

    sdk.FarmsManager.insert({
        egg: 0,
        meal: 0,
        milk: 0,
        locked: true,
        img: d.url,
        name: d.name,
        ownerIdentifier: null,
        ownerName: null,
        price: price,
        x: Position.x,
        y: Position.y,
        z: Position.z,
    })
        .then(() => {
            Player.Notification(`Farm successfully created.`);
        })
        .catch((err) => {
            Player.Notification('Farm has not been created, some error happened!');
            console.error(err);
        });
});

function UpdateFarmCreator(Player: sdk.FarmPlayer, Farm: AnimalFarm) {
    const formatData: FarmCreatorListInterface = {
        id: Farm.farmId,
        img: Farm.img,
        locked: Farm.locked,
        name: Farm.name,
        opened: true,
        ownerIdentifier: Farm.ownerIdentifier,
        ownerName: Farm.ownerName,
        price: Farm.price,
    };

    Player.TriggerChromium({
        event: 'update-farm-creator',
        data: formatData,
    });
}
