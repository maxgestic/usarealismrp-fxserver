import { SharedConfig } from '../../../../shared/shared-config';
import { TSL } from '../../../../shared/shared-translations';

import * as sdk from '../server';
import * as Aquiver from '@aquiversdk/server';
import { generateInt, Vec3 } from '@aquiversdk/shared';

const LOOT_POSITIONS = {
    MILK: {
        boxPerAmount: 150,
        positions: [
            { pos: new Vec3(1997.41577, 4830.673, 2.713805), rot: new Vec3(0, 0, 75) },
            { pos: new Vec3(1997.41577, 4830.673, 3.02801824), rot: new Vec3(0, 0, 60) },
            { pos: new Vec3(1997.41577, 4830.673, 3.335261), rot: new Vec3(0, 0, 95) },

            { pos: new Vec3(1998.14063, 4830.882, 2.713805), rot: new Vec3(0, 0, 65) },
            { pos: new Vec3(1998.14063, 4830.882, 3.03046656), rot: new Vec3(0, 0, 75) },
            { pos: new Vec3(1998.14063, 4830.882, 3.34778142), rot: new Vec3(0, 0, 94) },
            { pos: new Vec3(1998.14063, 4830.882, 3.66244483), rot: new Vec3(0, 0, 65) },

            { pos: new Vec3(1997.55054, 4831.476, 2.713805), rot: new Vec3(0, 0, 155) },
            { pos: new Vec3(1997.512, 4831.467, 3.02821922), rot: new Vec3(0, 0, 160) },
            { pos: new Vec3(1997.512, 4831.467, 3.34015179), rot: new Vec3(0, 0, 150) },
            { pos: new Vec3(1997.512, 4831.467, 3.65185213), rot: new Vec3(0, 0, 157) },
        ],
    },
    MEAL: {
        boxPerAmount: 20,
        positions: [
            { pos: new Vec3(1996.06677, 4831.39648, 2.713805), rot: new Vec3(0, 0, 60) },
            { pos: new Vec3(1996.11926, 4831.37256, 3.026964), rot: new Vec3(0, 0, 65) },
            { pos: new Vec3(1996.12378, 4831.36865, 3.34014726), rot: new Vec3(0, 0, 75) },
            { pos: new Vec3(1996.16333, 4831.314, 3.66029978), rot: new Vec3(0, 0, 60) },

            { pos: new Vec3(1996.197, 4830.61035, 2.7138052), rot: new Vec3(0, 0, 210) },
            { pos: new Vec3(1996.21936, 4830.604, 3.02731586), rot: new Vec3(0, 0, 215) },

            { pos: new Vec3(1995.47729, 4830.671, 2.71377134), rot: new Vec3(0, 0, 95) },
            { pos: new Vec3(1995.45923, 4830.676, 3.030056), rot: new Vec3(0, 0, 100) },
            { pos: new Vec3(1995.492, 4830.696, 3.34457731), rot: new Vec3(0, 0, 110) },
        ],
    },
    EGG: {
        boxPerAmount: 25,
        positions: [
            { pos: new Vec3(1993.52661, 4830.999, 2.71378636), rot: new Vec3(0, 0, 75) },
            { pos: new Vec3(1993.52661, 4830.999, 3.02858019), rot: new Vec3(0, 0, 70) },
            { pos: new Vec3(1993.52661, 4830.999, 3.341085), rot: new Vec3(0, 0, 80) },
            { pos: new Vec3(1993.53455, 4830.96533, 3.65369821), rot: new Vec3(0, 0, 68) },

            { pos: new Vec3(1993.34668, 4830.25244, 2.713786), rot: new Vec3(0, 0, -15) },
            { pos: new Vec3(1993.34668, 4830.25244, 3.024943), rot: new Vec3(0, 0, -10) },
            { pos: new Vec3(1993.35718, 4830.289, 3.336598), rot: new Vec3(0, 0, -25) },

            { pos: new Vec3(1994.24133, 4830.43, 2.71379948), rot: new Vec3(0, 0, 100) },
            { pos: new Vec3(1994.24133, 4830.43, 3.02685642), rot: new Vec3(0, 0, 110) },
            { pos: new Vec3(1994.302, 4830.4043, 3.33901978), rot: new Vec3(0, 0, 105) },
        ],
    },
};

type LootType = Array<{ pos: Vec3; rot: Vec3; object: sdk.AquiverObject; fromAmount: number }>;

class FarmLoot {
    /** Private(s) */
    private _milkLoot: number = 0;
    private _mealLoot: number = 0;
    private _eggLoot: number = 0;
    private _serverStartup: boolean = true;

    /** Public */
    public loot_milks: LootType = [];
    public loot_meals: LootType = [];
    public loot_eggs: LootType = [];

    /** Do not judge, i know this code could be better. holo */
    constructor(public farmId: number) {
        this.loot_milks = LOOT_POSITIONS.MILK.positions.map((a, index) => {
            let Object: sdk.AquiverObject = null;

            const fromAmount = (index + 1) * LOOT_POSITIONS.MILK.boxPerAmount;

            /** Spawn the object if the amount is higher. */
            if (this.milkLoot >= fromAmount) {
                Object = this.createMilkObject(a.pos, a.rot);
            }

            return {
                object: Object,
                pos: a.pos,
                rot: a.rot,
                fromAmount: fromAmount,
            };
        });

        this.loot_meals = LOOT_POSITIONS.MEAL.positions.map((a, index) => {
            let Object: sdk.AquiverObject = null;

            const fromAmount = (index + 1) * LOOT_POSITIONS.MEAL.boxPerAmount;

            /** Spawn the object if the amount is higher. */
            if (this.mealLoot >= fromAmount) {
                Object = this.createMealObject(a.pos, a.rot);
            }

            return {
                object: Object,
                pos: a.pos,
                rot: a.rot,
                fromAmount: fromAmount,
            };
        });

        this.loot_eggs = LOOT_POSITIONS.EGG.positions.map((a, index) => {
            let Object: sdk.AquiverObject = null;

            const fromAmount = (index + 1) * LOOT_POSITIONS.EGG.boxPerAmount;

            if (this.eggLoot >= fromAmount) {
                Object = this.createEggObject(a.pos, a.rot);
            }

            return {
                object: Object,
                pos: a.pos,
                rot: a.rot,
                fromAmount: fromAmount,
            };
        });

        sdk.ServerDatabase.FarmRepository.find({
            where: {
                farmId: this.farmId,
            },
            find: ['egg', 'milk', 'meal'],
            limit: 1,
        })
            .then((res) => {
                if (res && res[0]) {
                    this.milkLoot = res[0].milk;
                    this.mealLoot = res[0].meal;
                    this.eggLoot = res[0].egg;
                }
            })
            .finally(() => {
                this._serverStartup = false;
            });
    }
    get eggLoot() {
        return this._eggLoot;
    }
    set eggLoot(amount: number) {
        this._eggLoot = amount;

        if (this.eggLoot > this.getMaxEggLoot) this.eggLoot = this.getMaxEggLoot;

        this.loot_eggs.forEach((a) => {
            if (this.eggLoot >= a.fromAmount && !sdk.ObjectManager.exist(a.object)) {
                a.object = this.createEggObject(a.pos, a.rot);
            } else if (this.eggLoot < a.fromAmount && sdk.ObjectManager.exist(a.object)) {
                a.object.destroy();
            }
        });

        if (!this._serverStartup) {
            sdk.ServerDatabase.FarmRepository.update({
                set: {
                    egg: this.eggLoot,
                },
                where: {
                    farmId: this.farmId,
                },
            });
        }
    }
    get mealLoot() {
        return this._mealLoot;
    }
    set mealLoot(amount: number) {
        this._mealLoot = amount;

        if (this.mealLoot > this.getMaxMealLoot) this.mealLoot = this.getMaxMealLoot;

        this.loot_meals.forEach((a) => {
            if (this.mealLoot >= a.fromAmount && !sdk.ObjectManager.exist(a.object)) {
                a.object = this.createMealObject(a.pos, a.rot);
            } else if (this.mealLoot < a.fromAmount && sdk.ObjectManager.exist(a.object)) {
                a.object.destroy();
            }
        });

        if (!this._serverStartup) {
            sdk.ServerDatabase.FarmRepository.update({
                where: {
                    farmId: this.farmId,
                },
                set: {
                    meal: this.mealLoot,
                },
            });
        }
    }
    get milkLoot() {
        return this._milkLoot;
    }
    set milkLoot(amount: number) {
        this._milkLoot = amount;

        if (this.milkLoot > this.getMaxMilkLoot) this.milkLoot = this.getMaxMilkLoot;

        /** Handle the object(s) spawn/despawn. */
        this.loot_milks.forEach((a) => {
            if (this.milkLoot >= a.fromAmount && !sdk.ObjectManager.exist(a.object)) {
                a.object = this.createMilkObject(a.pos, a.rot);
            } else if (this.milkLoot < a.fromAmount && sdk.ObjectManager.exist(a.object)) {
                a.object.destroy();
            }
        });

        if (!this._serverStartup) {
            sdk.ServerDatabase.FarmRepository.update({
                where: {
                    farmId: this.farmId,
                },
                set: {
                    milk: this.milkLoot,
                },
            });
        }
    }
    get getMaxMilkLoot() {
        return this.loot_milks.length * LOOT_POSITIONS.MILK.boxPerAmount;
    }
    get getMaxMealLoot() {
        return this.loot_meals.length * LOOT_POSITIONS.MEAL.boxPerAmount;
    }
    get getMaxEggLoot() {
        return this.loot_eggs.length * LOOT_POSITIONS.EGG.boxPerAmount;
    }
    private createEggObject(position: Vec3, rotation: Vec3) {
        const Object = sdk.ObjectManager.create({
            dimension: this.farmId,
            model: 'v_ind_meatboxsml_02',
            position: position,
            rotation: rotation,
            collision: true,
            freezed: true,
            variables: {
                raycastName: TSL.list.raycast_loot_egg_name,
            },
        });

        Object.interactionPress = (Player) => {
            Player.OpenClickMenu({
                header: TSL.list.egg,
                buttons: [
                    {
                        event: 'sell-loot',
                        eventArgs: {
                            type: 'egg',
                            all: false,
                        },
                        icon: 'fa-solid fa-dollar-sign',
                        name: TSL.list.menu_sell_one_box,
                        closeAfterClick: true,
                    },
                    {
                        event: 'sell-loot',
                        icon: 'fa-solid fa-sack-dollar',
                        eventArgs: {
                            type: 'egg',
                            all: true,
                        },
                        name: TSL.list.menu_sell_all_box,
                        closeAfterClick: true,
                    },
                ],
            });
        };

        return Object;
    }
    private createMealObject(position: Vec3, rotation: Vec3) {
        const Object = sdk.ObjectManager.create({
            dimension: this.farmId,
            model: 'v_ind_meatboxsml_02',
            position: position,
            rotation: rotation,
            collision: true,
            freezed: true,
            variables: {
                raycastName: TSL.list.raycast_loot_meal_name,
            },
        });

        Object.interactionPress = (Player) => {
            Player.OpenClickMenu({
                header: TSL.list.meal,
                buttons: [
                    {
                        event: 'sell-loot',
                        eventArgs: {
                            type: 'meal',
                            all: false,
                        },
                        icon: 'fa-solid fa-dollar-sign',
                        name: TSL.list.menu_sell_one_box,
                        closeAfterClick: true,
                    },
                    {
                        event: 'sell-loot',
                        icon: 'fa-solid fa-sack-dollar',
                        eventArgs: {
                            type: 'meal',
                            all: true,
                        },
                        name: TSL.list.menu_sell_all_box,
                        closeAfterClick: true,
                    },
                ],
            });
        };

        return Object;
    }
    private createMilkObject(position: Vec3, rotation: Vec3) {
        const Object = sdk.ObjectManager.create({
            dimension: this.farmId,
            model: 'v_ind_meatboxsml_02',
            position: position,
            rotation: rotation,
            collision: true,
            freezed: true,
            variables: {
                raycastName: TSL.list.raycast_loot_milk_name,
            },
        });

        Object.interactionPress = (Player) => {
            Player.OpenClickMenu({
                header: TSL.list.milk,
                buttons: [
                    {
                        event: 'sell-loot',
                        eventArgs: {
                            type: 'milk',
                            all: false,
                        },
                        icon: 'fa-solid fa-dollar-sign',
                        name: TSL.list.menu_sell_one_box,
                        closeAfterClick: true,
                    },
                    {
                        event: 'sell-loot',
                        icon: 'fa-solid fa-sack-dollar',
                        eventArgs: {
                            type: 'milk',
                            all: true,
                        },
                        name: TSL.list.menu_sell_all_box,
                        closeAfterClick: true,
                    },
                ],
            });
        };

        return Object;
    }
}

onNet('sell-loot', (d: { all: boolean; type: 'meal' | 'milk' | 'egg' }) => {
    const { all, type } = d;

    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    if (!Player.isPlayerInOwnedFarm()) return Player.Notification(TSL.list.farm_player_not_owner);

    const farmLoots = sdk.LootManager.getFarmLoots(Player.dimension);
    if (!farmLoots) return;

    if (all) {
        let price: number;
        let msg: string;

        switch (type) {
            case 'egg': {
                if (farmLoots.eggLoot < 1) return;

                const boxAmount = Math.floor(farmLoots.eggLoot / LOOT_POSITIONS.EGG.boxPerAmount);
                if (boxAmount > 0) {
                    if (Aquiver.Config.ResourceExtra.GiveLootAsItems) {
                        Player.addItem(Aquiver.Config.ResourceExtra.ItemNames.egg, boxAmount);
                        farmLoots.eggLoot = 0;
                    } else {
                        price = generateInt(SharedConfig.Loot.EggPricePerBox.min, SharedConfig.Loot.EggPricePerBox.max) * boxAmount;

                        msg = TSL.format(TSL.list.eggs_sold_all_notification, [boxAmount, price]);
                        farmLoots.eggLoot = 0;
                        Player.addAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, price);
                        Player.Notification(msg);
                    }
                }
                break;
            }
            case 'meal': {
                if (farmLoots.mealLoot < 1) return;

                // @ts-ignore
                const boxAmount = Math.floor(farmLoots.mealLoot / LOOT_POSITIONS.MEAL.boxPerAmount);
                if (boxAmount > 0) {
                    if (Aquiver.Config.ResourceExtra.GiveLootAsItems) {
                        Player.addItem(Aquiver.Config.ResourceExtra.ItemNames.meal, boxAmount);
                        farmLoots.mealLoot = 0;
                    } else {
                        price = generateInt(SharedConfig.Loot.MealPricePerBox.min, SharedConfig.Loot.MealPricePerBox.max) * boxAmount;

                        msg = TSL.format(TSL.list.meal_sold_all_notification, [boxAmount, price]);
                        farmLoots.mealLoot = 0;
                        Player.addAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, price);
                        Player.Notification(msg);
                    }
                }
                break;
            }
            case 'milk': {
                if (farmLoots.milkLoot < 1) return;

                // @ts-ignore
                const boxAmount = Math.floor(farmLoots.milkLoot / LOOT_POSITIONS.MILK.boxPerAmount);
                if (boxAmount > 0) {
                    if (Aquiver.Config.ResourceExtra.GiveLootAsItems) {
                        Player.addItem(Aquiver.Config.ResourceExtra.ItemNames.milk, boxAmount);
                        farmLoots.milkLoot = 0;
                    } else {
                        price = generateInt(SharedConfig.Loot.MilkPricePerBox.min, SharedConfig.Loot.MilkPricePerBox.max) * boxAmount;

                        msg = TSL.format(TSL.list.milk_sold_all_notification, [boxAmount, price]);
                        farmLoots.milkLoot = 0;
                        Player.addAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, price);
                        Player.Notification(msg);
                    }
                }
                break;
            }
        }
    } else {
        let msg: string;

        switch (type) {
            case 'egg': {
                if (farmLoots.eggLoot < 1) return;

                if (Aquiver.Config.ResourceExtra.GiveLootAsItems) {
                    Player.addItem(Aquiver.Config.ResourceExtra.ItemNames.egg, 1);
                } else {
                    let price = generateInt(SharedConfig.Loot.EggPricePerBox.min, SharedConfig.Loot.EggPricePerBox.max);
                    Player.addAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, price);
                    msg = TSL.format(TSL.list.egg_sold_notification, [price]);
                    Player.Notification(msg);
                }

                farmLoots.eggLoot -= LOOT_POSITIONS.EGG.boxPerAmount;
                break;
            }
            case 'meal': {
                if (farmLoots.mealLoot < 1) return;

                if (Aquiver.Config.ResourceExtra.GiveLootAsItems) {
                    Player.addItem(Aquiver.Config.ResourceExtra.ItemNames.meal, 1);
                } else {
                    let price = generateInt(SharedConfig.Loot.MealPricePerBox.min, SharedConfig.Loot.MealPricePerBox.max);
                    Player.addAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, price);
                    msg = TSL.format(TSL.list.meal_sold_notification, [price]);
                    Player.Notification(msg);
                }

                farmLoots.mealLoot -= LOOT_POSITIONS.MEAL.boxPerAmount;
                break;
            }
            case 'milk': {
                if (farmLoots.milkLoot < 1) return;

                if (Aquiver.Config.ResourceExtra.GiveLootAsItems) {
                    Player.addItem(Aquiver.Config.ResourceExtra.ItemNames.milk, 1);
                } else {
                    let price = generateInt(SharedConfig.Loot.MilkPricePerBox.min, SharedConfig.Loot.MilkPricePerBox.max);
                    Player.addAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, price);
                    msg = TSL.format(TSL.list.milk_sold_notification, [price]);
                    Player.Notification(msg);
                }

                farmLoots.milkLoot -= LOOT_POSITIONS.MILK.boxPerAmount;
                break;
            }
        }
    }
});

export class LootManager {
    static FarmLoots = new Map<number, FarmLoot>();

    static loadFarmLoots(farmId: number) {
        this.FarmLoots.set(farmId, new FarmLoot(farmId));
    }
    static getFarmLoots(farmId: number) {
        return this.FarmLoots.get(farmId);
    }
}