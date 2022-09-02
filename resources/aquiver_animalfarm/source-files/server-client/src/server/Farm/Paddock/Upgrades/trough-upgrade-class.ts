import { SharedConfig } from '../../../../../../shared/shared-config';
import { UpgradeData } from '../../../../../../shared/shared-types';
import { UpgradeBase } from './upgrade-base';

import * as sdk from '../../../server';
import { TSL } from '../../../../../../shared/shared-translations';
import * as Aquiver from "@aquiversdk/server";

export class TroughUpgrade extends UpgradeBase {
    /** Private(s) */
    private _foodAmount: number = 0;
    private _serverStartup: boolean = true;

    /** Public */

    constructor(data: UpgradeData) {
        super(data);

        sdk.ServerDatabase.PaddockRepository.find({
            where: {
                farmId: this.data.farmId,
                paddockStrid: this.data.paddockStrid,
                upgradeStrid: this.data.upgradeStrid,
            },
            find: ['foodAmount'],
        })
            .then((rows) => {
                if (rows && rows[0]) {
                    this.foodAmount = rows[0].foodAmount;
                    this.upgraded = true;
                }
            })
            .finally(() => {
                this._serverStartup = false;
            });
    }
    get foodAmount() {
        return this._foodAmount;
    }
    set foodAmount(amount: number) {
        amount = Math.floor(amount);
        if (amount < 1) amount = 0;
        else if (amount > SharedConfig.AnimalFarm.maximumFood) amount = SharedConfig.AnimalFarm.maximumFood;

        this._foodAmount = amount;

        if (sdk.ObjectManager.exist(this.object)) {
            this.object.variables.foodAmount = this.foodAmount;
        }

        if (!this._serverStartup) {
            sdk.ServerDatabase.PaddockRepository.update({
                where: {
                    farmId: this.data.farmId,
                    paddockStrid: this.data.paddockStrid,
                    upgradeStrid: this.data.upgradeStrid,
                },
                set: {
                    foodAmount: this.foodAmount,
                },
            });
        }
    }
    get description(): string {
        return TSL.list.upgrade_trough_description;
    }
    get img(): string {
        return 'trough.png';
    }
    get name(): string {
        return TSL.list.trough_main_name;
    }
    get upgraded(): boolean {
        return super.upgraded;
    }
    set upgraded(state: boolean) {
        super.upgraded = state;

        /** Create the object if not exist and state turned to true */
        if (state && !sdk.ObjectManager.exist(this.object)) {
            this.object = sdk.ObjectManager.create({
                dimension: this.data.farmId,
                model: this.data.model,
                position: this.data.position,
                rotation: this.data.rotation,
                freezed: true,
                variables: {
                    foodAmount: this.foodAmount,
                    raycastName: TSL.list.raycast_trough_name,
                },
            });

            this.object.interactionPress = async (Player) => {
                try {
                    if (Player.hasAttachment('foodBag')) {
                        if (this.foodAmount >= SharedConfig.AnimalFarm.maximumFood) return Player.Notification(TSL.list.trough_already_filled);

                        await Player.PlayAnimationPromise('anim@move_m@trash', 'pickup', 1, 2000);

                        if (!Player.hasAttachment('foodBag')) return;

                        let newFood = this.foodAmount + SharedConfig.AnimalFarm.fillWithBag;
                        if (newFood > SharedConfig.AnimalFarm.maximumFood) newFood = SharedConfig.AnimalFarm.maximumFood;

                        this.foodAmount = newFood;

                        Player.removeAttachment('foodBag');
                    } else {
                        Player.Notification(TSL.list.trough_need_foodbag);
                    }
                } catch (error) {
                    console.error(error);
                }
            };
        }

        /** Delete the object if its exist and state is false */
        if (!state && sdk.ObjectManager.exist(this.object)) {
            this.object.destroy();
        }
    }
    Upgrade(Player: sdk.FarmPlayer): void {
        if (Player.getAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount) < this.data.price) return Player.Notification(TSL.list.not_enough_bank);

        Player.removeAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, this.data.price);

        sdk.ServerDatabase.PaddockRepository.exist({
            farmId: this.data.farmId,
            paddockStrid: this.data.paddockStrid,
            upgradeStrid: this.data.upgradeStrid,
        }).then((exist) => {
            if (!exist) {
                sdk.ServerDatabase.PaddockRepository.insert({
                    farmId: this.data.farmId,
                    paddockStrid: this.data.paddockStrid,
                    upgradeStrid: this.data.upgradeStrid,
                    foodAmount: this.foodAmount,
                });

                this.upgraded = true;
                sdk.PaddockManager.openPaddockUpgradesMenu(Player);
            }
        });
    }
}
