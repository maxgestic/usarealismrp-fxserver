import { priceMultiplier, SharedConfig } from '../../../../../shared/shared-config';
import { AnimalEntryInterface, AnimalTypes, UpgradeInterface } from '../../../../../shared/shared-types';
import { Animal } from '../server-farm-animal-class';
import { TroughUpgrade } from './Upgrades/trough-upgrade-class';
import { WaterUpgrade } from './Upgrades/water-upgrade-class';

import * as sdk from '../../server';
import * as Aquiver from '@aquiversdk/server';
import { TSL } from '../../../../../shared/shared-translations';
import { Distance, generateBoolean, generateFloating, Vec3 } from '@aquiversdk/shared';

interface PaddockInterface {
    paddockStrid: string;
    name: string;
    cameraPosition: Vec3;
    cameraRotation: Vec3;
    cameraFov: number;
    waters: Array<{ upgradeStrid: string; price: number; pos: Vec3; rot: Vec3; model: string }>;
    troughs: Array<{ upgradeStrid: string; price: number; pos: Vec3; rot: Vec3; model: string }>;
    availableAnimals: AnimalTypes[];
    shitpositions: Array<{ minY: number; maxY: number; minX: number; maxX: number; fixedZ: number }>;
    animalPositions: Array<{ pos: Vec3; heading: number; actionPos?: Vec3; actionHeading?: number }>;
}

const PaddocksConfig: PaddockInterface[] = [
    {
        paddockStrid: 'paddock-1',
        name: TSL.list.first_paddock,
        cameraPosition: new Vec3(2002, 4823, 5),
        cameraRotation: new Vec3(-30, 0, 267),
        cameraFov: 80.0,
        waters: [
            {
                upgradeStrid: 'water-1',
                price: Math.floor(5000 * priceMultiplier),
                pos: new Vec3(2009.21655, 4825.752, 2.46888328),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_drinker',
            },
            {
                upgradeStrid: 'water-2',
                price: Math.floor(6500 * priceMultiplier),
                pos: new Vec3(2004.57153, 4825.231, 2.4752736),
                rot: new Vec3(0, 0, 5),
                model: 'avp_farm_drinker',
            },
            {
                upgradeStrid: 'water-3',
                price: Math.floor(8000 * priceMultiplier),
                pos: new Vec3(2010.85193, 4820.312, 2.469054),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_drinker',
            },
        ],
        troughs: [
            {
                upgradeStrid: 'trough-1',
                price: Math.floor(7000 * priceMultiplier),
                pos: new Vec3(2012.94312, 4823.054, 2.47527456),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_trough',
            },
            {
                upgradeStrid: 'trough-2',
                price: Math.floor(9850 * priceMultiplier),
                pos: new Vec3(2006.76929, 4820.22559, 2.47534657),
                rot: new Vec3(0, 0, 90),
                model: 'avp_farm_trough',
            },
        ],
        availableAnimals: ['COW', 'PIG'],
        shitpositions: [{ minX: 2004.0, maxX: 2012.2, minY: 4821.04, maxY: 4824.78, fixedZ: 2.5 }],
        animalPositions: [
            {
                pos: new Vec3(2008.2622070313, 4824.4482421875, 2.4878680706024),
                heading: 336,
                actionPos: new Vec3(2007.559, 4824.945, 2.488),
                actionHeading: 189,
            },
            {
                pos: new Vec3(2011.3511962891, 4824.4248046875, 2.4878680706024),
                heading: 278,
                actionPos: new Vec3(2011.111, 4825.315, 2.488),
                actionHeading: 142,
            },
            {
                pos: new Vec3(2007.4013671875, 4821.4291992188, 2.487869977951),
                heading: 207,
                actionPos: new Vec3(2006.272, 4821.0, 2.488),
                actionHeading: 281.5,
            },
            {
                pos: new Vec3(2011.5744628906, 4821.6787109375, 2.4878675937653),
                heading: 164,
                actionPos: new Vec3(2010.649, 4821.962, 2.488),
                actionHeading: 261.7,
            },
        ],
    },
    {
        paddockStrid: 'paddock-2',
        name: TSL.list.second_paddock,
        cameraPosition: new Vec3(2002, 4815, 5),
        cameraRotation: new Vec3(-30, 0, 267),
        cameraFov: 80.0,
        waters: [
            {
                upgradeStrid: 'water-1',
                price: Math.floor(5250 * priceMultiplier),
                pos: new Vec3(2012.50464, 4818.1626, 2.469054),
                rot: new Vec3(0, 0, -45),
                model: 'avp_farm_drinker',
            },
            {
                upgradeStrid: 'water-2',
                price: Math.floor(6500 * priceMultiplier),
                pos: new Vec3(2011.49084, 4812.96436, 2.469054),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_drinker',
            },
            {
                upgradeStrid: 'water-3',
                price: Math.floor(7450 * priceMultiplier),
                pos: new Vec3(2013.02429, 4814.714, 2.46905446),
                rot: new Vec3(0, 0, 90),
                model: 'avp_farm_drinker',
            },
        ],
        troughs: [
            {
                upgradeStrid: 'trough-1',
                price: Math.floor(7350 * priceMultiplier),
                pos: new Vec3(2006.93066, 4818.434, 2.47527456),
                rot: new Vec3(0, 0, 90),
                model: 'avp_farm_trough',
            },
            {
                upgradeStrid: 'trough-2',
                price: Math.floor(9850 * priceMultiplier),
                pos: new Vec3(2007.02515, 4813.04, 2.47488713),
                rot: new Vec3(0, 0, 92),
                model: 'avp_farm_trough',
            },
        ],
        availableAnimals: ['COW', 'PIG'],
        shitpositions: [{ minX: 2004.23, maxX: 2012.05, minY: 4813.9, maxY: 4817.63, fixedZ: 2.5 }],
        animalPositions: [
            {
                pos: new Vec3(2005.502, 4817.423, 2.487),
                heading: 332,
                actionHeading: 225,
                actionPos: new Vec3(2004.558, 4817.563, 2.488),
            },
            {
                pos: new Vec3(2008.642, 4817.171, 2.487),
                heading: 359,
                actionHeading: 247,
                actionPos: new Vec3(2007.672, 4816.829, 2.488),
            },
            {
                pos: new Vec3(2011.421, 4816.981, 2.4878),
                heading: 317,
                actionHeading: 215,
                actionPos: new Vec3(2010.464, 4817.342, 2.487),
            },
            {
                pos: new Vec3(2010.18, 4815.065, 2.4878),
                heading: 279,
                actionHeading: 156,
                actionPos: new Vec3(2009.8, 4816.013, 2.488),
            },
            {
                pos: new Vec3(2007.144, 4814.434, 2.487),
                heading: 126,
                actionHeading: 215,
                actionPos: new Vec3(2006.918, 4815.324, 2.485),
            },
        ],
    },
    {
        paddockStrid: 'paddock-3',
        name: TSL.list.third_big_paddock,
        cameraPosition: new Vec3(1999.2, 4823.41, 5),
        cameraRotation: new Vec3(-30, 0, 88),
        cameraFov: 80.0,
        waters: [
            {
                upgradeStrid: 'water-1',
                price: Math.floor(7500 * priceMultiplier),
                pos: new Vec3(1991.78394, 4827.253, 2.47957325),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_drinker',
            },
            {
                upgradeStrid: 'water-2',
                price: Math.floor(9750 * priceMultiplier),
                pos: new Vec3(1990.08386, 4819.39844, 2.47957754),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_drinker',
            },
            {
                upgradeStrid: 'water-3',
                price: Math.floor(12500 * priceMultiplier),
                pos: new Vec3(1996.84558, 4827.056, 2.47951651),
                rot: new Vec3(0, 0, -20),
                model: 'avp_farm_drinker',
            },
            {
                upgradeStrid: 'water-4',
                price: Math.floor(15250 * priceMultiplier),
                pos: new Vec3(1994.157, 4827.21826, 2.47957325),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_drinker',
            },
        ],
        troughs: [
            {
                upgradeStrid: 'trough-1',
                price: Math.floor(9850 * priceMultiplier),
                pos: new Vec3(1994.59717, 4819.582, 2.47534657),
                rot: new Vec3(0, 0, 93),
                model: 'avp_farm_trough',
            },
            {
                upgradeStrid: 'trough-2',
                price: Math.floor(15500 * priceMultiplier),
                pos: new Vec3(1988.45618, 4823.08936, 2.47518754),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_trough',
            },
            {
                upgradeStrid: 'trough-3',
                price: Math.floor(20000 * priceMultiplier),
                pos: new Vec3(1994.77429, 4823.10547, 2.475179),
                rot: new Vec3(0, 0, 90),
                model: 'avp_farm_trough',
            },
        ],
        availableAnimals: ['COW', 'PIG'],
        shitpositions: [
            { minX: 1989.2, maxX: 1997.6, minY: 4823.8, maxY: 4826.6, fixedZ: 2.5 },
            { minX: 1989.45, maxX: 1997.6, minY: 4820.4, maxY: 4822.36, fixedZ: 2.5 },
        ],
        animalPositions: [
            {
                pos: new Vec3(1996.85, 4820.664, 2.488),
                heading: 184,
                actionPos: new Vec3(1995.909, 4820.673, 2.488),
                actionHeading: 278.3,
            },
            {
                pos: new Vec3(1992.277, 4820.396, 2.488),
                heading: 190,
                actionPos: new Vec3(1991.193, 4820.33, 2.488),
                actionHeading: 273.8,
            },
            {
                pos: new Vec3(1989.7384033203, 4821.2158203125, 2.4878690242767),
                heading: 11,
                actionPos: new Vec3(1990.79, 4821.28, 2.488),
                actionHeading: 88.2,
            },
            {
                pos: new Vec3(1991.0037841797, 4826.40234375, 2.4878690242767),
                heading: 342,
                actionPos: new Vec3(1991.795, 4826.042, 2.488),
                actionHeading: 79,
            },
            {
                pos: new Vec3(1994.8297119141, 4825.765625, 2.4878687858582),
                heading: 22,
                actionPos: new Vec3(1993.874, 4825.293, 2.488),
                actionHeading: 263.3,
            },
            {
                pos: new Vec3(1994.7770996094, 4821.7705078125, 2.4878709316254),
                heading: 8,
                actionPos: new Vec3(1993.873, 4821.511, 2.488),
                actionHeading: 246.7,
            },
        ],
    },
    {
        paddockStrid: 'chicken-paddock-1',
        name: TSL.list.first_chicken_paddock,
        cameraPosition: new Vec3(1996.6, 4816.98, 5.5),
        cameraRotation: new Vec3(-45, 0, 92),
        cameraFov: 90.0,
        waters: [
            {
                upgradeStrid: 'water-1',
                price: Math.floor(3000 * priceMultiplier),
                pos: new Vec3(1993.45569, 4815.862, 2.4706192),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_chicken_drinker',
            },
        ],
        troughs: [
            {
                upgradeStrid: 'trough-1',
                price: Math.floor(2000 * priceMultiplier),
                pos: new Vec3(1995.06665, 4815.68164, 2.4713788),
                rot: new Vec3(0, 0, 90),
                model: 'avp_farm_chicken_feeder',
            },
            {
                upgradeStrid: 'trough-2',
                price: Math.floor(3250 * priceMultiplier),
                pos: new Vec3(1991.83, 4815.67139, 2.47246838),
                rot: new Vec3(0, 0, 90),
                model: 'avp_farm_chicken_feeder',
            },
        ],
        availableAnimals: ['CHICKEN'],
        shitpositions: [{ minX: 1992.11, maxX: 1996.15, minY: 4816.36, maxY: 4818.12, fixedZ: 2.5 }],
        animalPositions: [
            {
                pos: new Vec3(1991.4234619141, 4816.2778320313, 2.4738883972168),
                heading: 195.11102294922,
            },
            {
                pos: new Vec3(1990.6795654297, 4817.7822265625, 3.0080518722534),
                heading: 254,
            },
            {
                pos: new Vec3(1995.254, 4816.305, 2.473),
                heading: 180,
            },
            {
                pos: new Vec3(1992.9848632813, 4816.140625, 2.4738914966583),
                heading: 230,
            },
            {
                pos: new Vec3(1993.289, 4817.901, 2.473),
                heading: 20,
            },
            {
                pos: new Vec3(1994.6197509766, 4816.2446289063, 2.473888874054),
                heading: 162,
            },
        ],
    },
    {
        paddockStrid: 'chicken-paddock-2',
        name: TSL.list.second_chicken_paddock,
        cameraPosition: new Vec3(1997.23, 4813.27, 5.5),
        cameraRotation: new Vec3(-45, 0, 96),
        cameraFov: 90.0,
        waters: [
            {
                upgradeStrid: 'water-1',
                price: Math.floor(2800 * priceMultiplier),
                pos: new Vec3(1996.36316, 4812.395, 2.47117758),
                rot: new Vec3(0, 0, 0),
                model: 'avp_farm_chicken_drinker',
            },
        ],
        troughs: [
            {
                upgradeStrid: 'trough-1',
                price: Math.floor(2150 * priceMultiplier),
                pos: new Vec3(1991.99219, 4811.665, 2.473398),
                rot: new Vec3(0, 0, 95),
                model: 'avp_farm_chicken_feeder',
            },
            {
                upgradeStrid: 'trough-2',
                price: Math.floor(3500 * priceMultiplier),
                pos: new Vec3(1994.13464, 4811.898, 2.47276378),
                rot: new Vec3(0, 0, 95),
                model: 'avp_farm_chicken_feeder',
            },
        ],
        availableAnimals: ['CHICKEN'],
        shitpositions: [{ minX: 1992.42, maxX: 1995.8, minY: 4812.51, maxY: 4814.03, fixedZ: 2.5 }],
        animalPositions: [
            {
                pos: new Vec3(1993.6005859375, 4812.431640625, 2.4738869667053),
                heading: 188,
            },
            {
                pos: new Vec3(1994.6219482422, 4812.4643554688, 2.4738883972168),
                heading: 187,
            },
            {
                pos: new Vec3(1995.9018554688, 4812.6879882813, 2.4738876819611),
                heading: 225,
            },
            {
                pos: new Vec3(1991.7375488281, 4813.80078125, 2.735280752182),
                heading: 91,
            },
            {
                pos: new Vec3(1991.6826171875, 4812.2626953125, 2.473888874054),
                heading: 198,
            },
            {
                pos: new Vec3(1993.650390625, 4814.0170898438, 2.4738912582397),
                heading: 249,
            },
        ],
    },
];

onNet('buy-paddock-upgrade', (d: { paddockStrid: string; upgradeStrid: string }) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    const Paddock = sdk.PaddockManager.getPaddock(Player.dimension, d.paddockStrid);
    if (Paddock) Paddock.Upgrade(Player, d.upgradeStrid);
});

onNet('buy-paddock-animal', (d: { paddockStrid: string; animalType: AnimalTypes }) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    const Paddock = sdk.PaddockManager.getPaddock(Player.dimension, d.paddockStrid);
    if (Paddock) Paddock.BuyAnimal(Player, d.animalType);
});

class Paddock {
    public Troughs: TroughUpgrade[] = [];
    public Waters: WaterUpgrade[] = [];
    public Animals: Animal[] = [];
    public Shits: sdk.AquiverObject[] = [];

    constructor(public farmId: number, public _data: PaddockInterface) {
        _data.waters.forEach((a) => {
            this.Waters.push(
                new WaterUpgrade({
                    farmId: this.farmId,
                    paddockStrid: this.paddockStrid,
                    position: a.pos,
                    price: a.price,
                    rotation: a.rot,
                    upgradeStrid: a.upgradeStrid,
                    model: a.model,
                })
            );
        });

        _data.troughs.forEach((a) => {
            this.Troughs.push(
                new TroughUpgrade({
                    farmId: this.farmId,
                    paddockStrid: this.paddockStrid,
                    position: a.pos,
                    price: a.price,
                    rotation: a.rot,
                    upgradeStrid: a.upgradeStrid,
                    model: a.model,
                })
            );
        });

        sdk.ServerDatabase.AnimalRepository.find({
            where: {
                farmId: this.farmId,
                paddockStrid: this.paddockStrid,
            },
            limit: this._data.animalPositions.length,
        }).then((rows) => {
            rows.forEach((animal) => {
                const spawnPosition = this.getFreeAnimalSpawnPosition();
                if (!spawnPosition) return console.error('No available animal spawn position!');

                this.Animals.push(new Animal(animal, spawnPosition.pos, spawnPosition.heading, spawnPosition.actionPos, spawnPosition.actionHeading));
            });
        });

        setInterval(() => {
            this.SpawnShit();
        }, SharedConfig.Composter.shitSpawnMs);
    }
    get paddockStrid() {
        return this._data.paddockStrid;
    }
    Upgrade(Player: sdk.FarmPlayer, upgradeStrid: string) {
        const Trough = this.Troughs.find((a) => a.data.upgradeStrid == upgradeStrid);
        const Water = this.Waters.find((a) => a.data.upgradeStrid == upgradeStrid);
        if (Water) Water.Upgrade(Player);
        else if (Trough) Trough.Upgrade(Player);
    }
    getFreeAnimalSpawnPosition() {
        for (let i = 0; i < this._data.animalPositions.length; i++) {
            let { pos, heading, actionHeading, actionPos } = this._data.animalPositions[i];
            let near = this.Animals.findIndex((a) => Distance(pos, a.Ped.position) <= 0.5) >= 0;
            if (near) continue;

            return { pos, heading, actionHeading, actionPos };
        }
    }
    async BuyAnimal(Player: sdk.FarmPlayer, animalType: AnimalTypes) {
        const { length: AnimalsAmount } = await sdk.ServerDatabase.AnimalRepository.find({
            where: {
                farmId: this.farmId,
                paddockStrid: this.paddockStrid,
            },
        });

        if (typeof AnimalsAmount !== 'number') return;

        if (AnimalsAmount >= this._data.animalPositions.length) return Player.Notification(TSL.list.can_not_buy_more_animals);

        const spawnPosition = this.getFreeAnimalSpawnPosition();
        if (!spawnPosition) return Player.Notification('Spawn position is not available (animal too close)! Alert your server developer!');

        const typeValid = this._data.availableAnimals.findIndex((a) => a == animalType);
        if (typeValid === -1) return;

        const animalData = SharedConfig.Animals[animalType];
        if (!animalData) return;

        if (Player.getAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount) < animalData.PRICE) return Player.Notification(TSL.list.not_enough_bank);

        Player.removeAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, animalData.PRICE);

        sdk.ServerDatabase.AnimalRepository.insert({
            age: 100,
            animalType: animalType,
            farmId: this.farmId,
            paddockStrid: this.paddockStrid,
            hunger: 100,
            thirst: 100,
            milk: animalType == 'COW' ? 0 : null,
            weight: animalType == 'PIG' ? 0 : null,
            health: 100,
            extra: generateFloating(SharedConfig.AnimalFarm.extraGenerator.min, SharedConfig.AnimalFarm.extraGenerator.max)
        }).then((a) => {
            if (!a) return;
            const insertId = a.insertId;
            sdk.ServerDatabase.AnimalRepository.find({
                where: {
                    aid: insertId,
                },
                limit: 1,
            }).then((rows) => {
                if (rows && rows[0]) {
                    const animal = rows[0];
                    this.Animals.push(new Animal(animal, spawnPosition.pos, spawnPosition.heading, spawnPosition.actionPos, spawnPosition.actionHeading));
                }
            });
        });
    }
    SpawnShit() {
        if (this.Shits.length > SharedConfig.Composter.maximumShitAmountOnGround) return;

        for (let i = 0; i < this.Animals.length; i++) {
            const spawnBool = generateBoolean(SharedConfig.Composter.shitSpawnChance);

            if (!spawnBool) continue;

            const randomArrayIdx = Math.floor(Math.random() * this._data.shitpositions.length);
            const randomPosition = this._data.shitpositions[randomArrayIdx];

            const rX = generateFloating(randomPosition.minX, randomPosition.maxX);
            const rY = generateFloating(randomPosition.minY, randomPosition.maxY);

            const obj = sdk.ObjectManager.create({
                dimension: this.farmId,
                model: 'avp_farm_shit',
                position: new Vec3(rX, rY, randomPosition.fixedZ),
                freezed: true,
                variables: {
                    raycastName: TSL.list.raycast_shit_name,
                },
            });

            obj.interactionPress = function (Player) {
                const self: sdk.AquiverObject = this;
                if (Player.hasAttachment('shovelWithShit')) return;
                if (!Player.hasAttachment('shovel')) return Player.Notification(TSL.list.need_shovel_for_shit);

                Player.removeAttachment('shovel');
                Player.addAttachment('shovelWithShit');

                self.destroy();
            };

            this.Shits.push(obj);
        }
    }
    get allFoodAmount() {
        let amount: number = 0;
        this.Troughs.forEach((a) => {
            amount += a.foodAmount;
        });
        return amount;
    }
    get allWaterAmount() {
        let amount: number = 0;
        this.Waters.forEach((a) => {
            amount += a.waterAmount;
        });
        return amount;
    }
    get interface(): UpgradeInterface {
        return {
            cameraFov: this._data.cameraFov,
            cameraPosition: this._data.cameraPosition,
            cameraRotation: this._data.cameraRotation,
            name: this._data.name,
            id: this._data.paddockStrid,
            upgrades: [...this.Waters.map((a) => a.interface), ...this.Troughs.map((a) => a.interface)],
            maximumAnimals: this._data.animalPositions.length,
            animals: this._data.availableAnimals.map((animalType) => {
                let d: Partial<AnimalEntryInterface> = {
                    buyEvent: 'buy-paddock-animal',
                    buyEventArgs: {
                        paddockStrid: this.paddockStrid,
                        animalType: animalType,
                    },
                    animalType: animalType,
                };

                const animalDataConfig = SharedConfig.Animals[animalType];
                if (animalDataConfig) {
                    d.description = animalDataConfig.DESCRIPTION;
                    d.img = animalDataConfig.IMG;
                    d.name = animalDataConfig.NAME;
                    d.price = animalDataConfig.PRICE;
                }

                return d as AnimalEntryInterface;
            }),
        };
    }
}

export class PaddockManager {
    static FarmPaddocks = new Map<number, Map<string, Paddock>>();

    static loadFarmPaddocks(farmId: number) {
        /** Create empty Map */
        this.FarmPaddocks.set(farmId, new Map());

        /** Create the paddocks and arrange them inside the Map type. */
        PaddocksConfig.forEach((a) => {
            this.FarmPaddocks.get(farmId).set(a.paddockStrid, new Paddock(farmId, a));
        });
    }
    static getFarmPaddocks(farmId: number) {
        return this.FarmPaddocks.get(farmId);
    }
    static getPaddock(farmId: number, paddockStrid: string) {
        try {
            return this.FarmPaddocks.get(farmId).get(paddockStrid);
        } catch {
            return;
        }
    }
    static openPaddockUpgradesMenu(Player: sdk.FarmPlayer) {
        const allPaddocks = this.getFarmPaddocks(Player.dimension);
        if (!allPaddocks) return;

        let list = [...allPaddocks.values()].map((a) => a.interface);

        Player.TriggerChromium({
            event: 'farmpanel-set-data',
            data: {
                list: list,
            },
        });

        Player.TriggerChromium({
            event: 'farmpanel-opened-state',
            data: {
                state: true,
            },
        });
    }
}