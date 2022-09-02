import { SharedConfig } from '../../../../../shared/shared-config';
import { TSL } from '../../../../../shared/shared-translations';

import * as sdk from '../../server';
import * as Aquiver from "@aquiversdk/server";
import { generateInt, Vec3 } from '@aquiversdk/shared';

interface CompostInterface {
    compostStrid: string;
    pos: Vec3;
    rot: Vec3;
}

const CompostConfig: CompostInterface[] = [
    {
        compostStrid: 'compost-1',
        pos: new Vec3(2002.8, 4819.321, 2.45),
        rot: new Vec3(0, 0, 90),
    },
    {
        compostStrid: 'compost-2',
        pos: new Vec3(2005.07, 4826.972, 2.45),
        rot: new Vec3(0, 0, 2),
    },
];

export class CompostManager {
    static FarmComposters = new Map<number, Map<string, Compost>>();

    static loadFarmComposters(farmId: number) {
        /** Create the empty Map */
        this.FarmComposters.set(farmId, new Map());

        /** Loading the composters inside the Map. */
        CompostConfig.forEach((a) => {
            this.FarmComposters.get(farmId).set(a.compostStrid, new Compost(farmId, a.compostStrid, a.pos, a.rot));
        });
    }
    static getFarmComposters(farmId: number) {
        return this.FarmComposters.get(farmId);
    }
    static getComposter(farmId: number, compostStrid: string) {
        try {
            return this.FarmComposters.get(farmId).get(compostStrid);
        } catch {
            return;
        }
    }
}

class Compost {
    /** Private(s) */
    private _shitAmount: number = 0;
    private _serverStartup: boolean = true;

    /** Public */
    public object: sdk.AquiverObject;

    constructor(public farmId: number, public compostStrid: string, public position: Vec3, public rotation: Vec3) {
        this.object = sdk.ObjectManager.create({
            dimension: this.farmId,
            model: 'avp_farm_composter',
            position: this.position,
            rotation: this.rotation,
            freezed: true,
            variables: {
                shitAmount: this.shitAmount,
            },
        });

        this.object.interactionPress = (Player) => {
            if (Player.hasAttachment('shovelWithShit')) {
                let newAmount = this.shitAmount + generateInt(SharedConfig.Composter.plusCompostAmount.min, SharedConfig.Composter.plusCompostAmount.max);
                /** cap it to the maximum, do not overflow. */
                if (newAmount > SharedConfig.Composter.maximumWeight) newAmount = SharedConfig.Composter.maximumWeight;

                this.shitAmount = newAmount;

                Player.removeAttachment('shovelWithShit');
                Player.addAttachment('shovel');
            } else if (!Player.hasAnyAttachment()) {
                Player.OpenClickMenu({
                    header: 'Composter',
                    buttons: [
                        {
                            event: 'sell-compost',
                            eventArgs: this.compostStrid,
                            icon: 'fa-solid fa-sack-dollar',
                            name: TSL.list.composter_sell,
                            closeAfterClick: true,
                        },
                    ],
                });
            }
        };

        sdk.ServerDatabase.CompostsRepository.exist({
            compostStrid: this.compostStrid,
            farmId: this.farmId,
        }).then((exist) => {
            if (!exist) {
                sdk.ServerDatabase.CompostsRepository.insert({
                    compostStrid: this.compostStrid,
                    farmId: this.farmId,
                    shitAmount: 0,
                });
            } else {
                sdk.ServerDatabase.CompostsRepository.find({
                    where: {
                        compostStrid: this.compostStrid,
                        farmId: this.farmId,
                    },
                    find: ['shitAmount'],
                }).then((rows) => {
                    if (rows && rows[0]) {
                        this.shitAmount = rows[0].shitAmount;
                    }
                });
            }
        });
    }
    get shitAmount() {
        return this._shitAmount;
    }
    set shitAmount(a: number) {
        this._shitAmount = a;

        /** Update object variable(s) */
        if (sdk.ObjectManager.exist(this.object)) {
            this.object.variables.shitAmount = this.shitAmount;
        }

        /** Do not flood mysql when server start, just load the variable. */
        if (!this._serverStartup) {
            /** Update database instant */
            sdk.ServerDatabase.CompostsRepository.update({
                where: {
                    compostStrid: this.compostStrid,
                    farmId: this.farmId,
                },
                set: {
                    shitAmount: this.shitAmount,
                },
            });
        } else {
            this._serverStartup = false;
        }
    }
}

onNet('sell-compost', (compostStrid: string) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    const Composter = sdk.CompostManager.getComposter(Player.dimension, compostStrid);

    if (Composter.shitAmount < 1) return Player.Notification('Composter is empty!');

    const priceCalculation = SharedConfig.Composter.pricePerWeight * Composter.shitAmount;
    if (typeof priceCalculation === 'number' && priceCalculation > 0) {
        Player.addAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, priceCalculation);
        Player.Notification(TSL.format(TSL.list.composter_sold_things, [priceCalculation]));

        Composter.shitAmount = 0;
    }
});
