import * as Aquiver from '@aquiversdk/server';
Aquiver.Config.Framework = 'CUSTOM';
Aquiver.Config.SqlDebug = true;
Aquiver.Config.sqlResource = 'mysql-async';
/** If you set this true then the loot pickups (boxes) will give you items instead of instant money. */
Aquiver.Config.ResourceExtra.GiveLootAsItems = false;
/** Set item names, only needed if you set to give loot as items. */
Aquiver.Config.ResourceExtra.ItemNames = {
    egg: 'bandage',
    meal: 'gold',
    milk: 'iron',
};
Aquiver.Config.ResourceExtra.selectedAccount = 'bank';
Aquiver.Config.checkResourceVersion = true;

Aquiver.checkVersion();

setImmediate(() => {
    switch (Aquiver.Config.Framework) {
        case 'ESX_LEGACY': {
            onNet(Aquiver.Events.ESX.PlayerLoaded, (sourceId) => {
                PlayerManager.playerJoining(sourceId);
                FarmsManager.playerJoining(sourceId);
            });
            break;
        }
        case 'QBCORE': {
            onNet(Aquiver.Events.QBCORE.PlayerLoaded, (QBPlayer: QBCore_Player) => {
                PlayerManager.playerJoining(QBPlayer.PlayerData.source);
                FarmsManager.playerJoining(QBPlayer.PlayerData.source);
            });
            break;
        }
        case 'CUSTOM': {
            onNet('playerJoining', () => {
                PlayerManager.playerJoining(globalThis.source);
                FarmsManager.playerJoining(globalThis.source);
            });
        }
    }
});

onNet('onResourceStart', async (resource: string) => {
    if (GetCurrentResourceName() !== resource) return;

    await FarmsManager.loadAll();

    /** Needed timeout for clientside to load. */
    setTimeout(() => {
        const Players = getPlayers();
        Players.forEach((p) => {
            PlayerManager.playerJoining(p);
            FarmsManager.playerJoining(p);
        });
    }, 5000);
});

onNet('playerDropped', () => {
    PlayerManager.playerDropped(globalThis.source);
});

export * as methods from './server-methods';
export * as tools from './Farm/tools';
export * from './Peds/server-ped';
export * from './Player/server-player';
export * from './Particle/server-particle';
export * from './Objects/server-object';
export * from './Farm/server-farm-manager';
export * from './Farm/Compost/server-compost';
export * from './Farm/Paddock/server-farm-paddock';
export * from './Farm/server-farm-loot';
export * from './Farm/server-farm-ticker';

/** Database export */
export * from './Database/server-database';

/** Importing Commands */
import './commands';
import { FarmsManager } from './Farm/server-farm-manager';
import { PlayerManager } from './Player/server-player';