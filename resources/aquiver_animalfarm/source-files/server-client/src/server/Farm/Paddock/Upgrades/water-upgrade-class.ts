import { SharedConfig } from '../../../../../../shared/shared-config';
import { UpgradeData } from '../../../../../../shared/shared-types';
import { UpgradeBase } from './upgrade-base';

import { Vec3 } from '@aquiversdk/shared';
import { TSL } from '../../../../../../shared/shared-translations';
import * as sdk from "../../../server";

export class WaterUpgrade extends UpgradeBase {
    /** Private(s) */
    private _waterAmount: number = 0;
    private _serverStartup: boolean = true;

    /** Public */

    constructor(data: UpgradeData) {
        super(data);

        sdk.ServerDatabase.PaddockRepository.find({
            where: {
                farmId: this.data.farmId,
                paddockStrid: this.data.paddockStrid,
                upgradeStrid: this.data.upgradeStrid
            },
            find: ['waterAmount']
        }).then(rows => {
            if (rows && rows[0]) {
                this.waterAmount = rows[0].waterAmount;
                this.upgraded = true;
            }
        }).finally(() => {
            this._serverStartup = false;
        });
    }
    get upgraded() {
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
                    waterAmount: this.waterAmount,
                    raycastName: TSL.list.raycast_water_name
                }
            });

            this.object.interactionPress = async (Player) => {
                try {
                    // Animations, appreciate @Tuna.
                    if (Player.hasAttachment('bucketWithWater')) {
                        if (this.waterAmount >= SharedConfig.AnimalFarm.maximumWater)
                            return Player.Notification(TSL.list.water_trough_already_filled);

                        // Need to modify the attachment position in order to look properly. :D
                        Player.setAttachmentOffset(
                            'bucketWithWater',
                            new Vec3(0.2, 0, 0),
                            new Vec3(185, 10, 40),
                            57005
                        );
                        await Player.PlayAnimationPromise('weapons@misc@jerrycan@', 'fire', 1, 7000);

                        if (!Player.hasAttachment('bucketWithWater')) return;

                        Player.removeAttachment('bucketWithWater');
                        Player.addAttachment('bucketEmpty');

                        let newWater = this.waterAmount + SharedConfig.AnimalFarm.fillWithBucket;
                        if (newWater > SharedConfig.AnimalFarm.maximumWater)
                            newWater = SharedConfig.AnimalFarm.maximumWater;

                        this.waterAmount = newWater;
                    }
                    else {
                        Player.Notification(TSL.list.need_bucket_with_water);
                    }
                }
                catch (error) {
                    console.error(error);
                }
            }
        }

        /** Delete the object if its exist and state is false */
        if (!state && sdk.ObjectManager.exist(this.object)) {
            this.object.destroy();
        }
    }
    get waterAmount() {
        return this._waterAmount;
    }
    set waterAmount(amount: number) {
        amount = Math.floor(amount);
        if (amount < 1) amount = 0;
        else if (amount > SharedConfig.AnimalFarm.maximumWater) amount = SharedConfig.AnimalFarm.maximumWater;

        this._waterAmount = amount;

        if (sdk.ObjectManager.exist(this.object)) {
            this.object.variables.waterAmount = this.waterAmount;
        }

        if (!this._serverStartup) {
            sdk.ServerDatabase.PaddockRepository.update({
                where: {
                    farmId: this.data.farmId,
                    paddockStrid: this.data.paddockStrid,
                    upgradeStrid: this.data.upgradeStrid
                },
                set: {
                    waterAmount: this.waterAmount
                }
            });
        }
    }
    get description(): string {
        return TSL.list.upgrade_water_description;
    }
    get img(): string {
        return 'water_trough.png';
    }
    get name(): string {
        return TSL.list.water_main_name;
    }
    Upgrade(Player: sdk.FarmPlayer): void {
        if (Player.getAccountMoney("bank") < this.data.price)
            return Player.Notification(TSL.list.not_enough_bank);

        Player.removeAccountMoney("bank", this.data.price);

        sdk.ServerDatabase.PaddockRepository.exist({
            farmId: this.data.farmId,
            paddockStrid: this.data.paddockStrid,
            upgradeStrid: this.data.upgradeStrid
        }).then(exist => {
            if (!exist) {
                sdk.ServerDatabase.PaddockRepository.insert({
                    farmId: this.data.farmId,
                    paddockStrid: this.data.paddockStrid,
                    upgradeStrid: this.data.upgradeStrid,
                    waterAmount: this.waterAmount
                });

                this.upgraded = true;
                sdk.PaddockManager.openPaddockUpgradesMenu(Player);
            }
        });
    }
}