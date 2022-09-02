import { FarmDatabaseInterface, ModalDataButtonTriggerInterface } from '../../../../shared/shared-types';
import { AnimalFarm } from './server-farm-class';

import * as Aquiver from '@aquiversdk/server';
import { Distance } from '@aquiversdk/shared';
import { SharedConfig } from '../../../../shared/shared-config';
import { TSL } from '../../../../shared/shared-translations';
import * as sdk from '../server';

onNet('farm-enter', (id: number) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;
    const Farm = sdk.FarmsManager.at(id);
    Farm && Farm.Enter(Player);
});
onNet('farm-exit', (id: number) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;
    const Farm = sdk.FarmsManager.at(id);
    Farm && Farm.Exit(Player);
});
onNet('farm-lock', (id: number) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;
    const Farm = sdk.FarmsManager.at(id);
    Farm && Farm.LockFarm(Player);
});
onNet('farm-open-buymenu', (id: number) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;
    const Farm = sdk.FarmsManager.at(id);
    Farm && Farm.OpenBuyMenu(Player);
});

onNet('farm-buy-prompt', (id: number) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    Player.OpenModalMenu({
        icon: 'fa-solid fa-exclamation-circle',
        question: TSL.list.buy_farm_question,
        buttons: [
            {
                name: TSL.list.button_yes,
                event: 'farm-buy-accept',
                args: id,
            },
            {
                name: TSL.list.button_cancel,
                event: '',
                args: '',
            },
        ],
        inputs: [],
    });
});

onNet('farm-buy-accept', (data: ModalDataButtonTriggerInterface) => {
    const id = data.args;
    const Farm = sdk.FarmsManager.at(id);
    Farm && Farm.Buy(global.source);
});
onNet('farm-rename-prompt', (id: number) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    Player.OpenModalMenu({
        icon: 'fa-solid fa-question-circle',
        question: TSL.list.rename_farm_question,
        buttons: [
            {
                name: TSL.list.button_rename,
                event: 'farm-rename-accept',
                args: id,
            },
            {
                name: TSL.list.button_cancel,
                event: '',
                args: '',
            },
        ],
        inputs: [
            {
                id: 'name_input',
                placeholder: TSL.list.placeholder_rename,
            },
        ],
    });
});
onNet('farm-rename-accept', (data: ModalDataButtonTriggerInterface) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    const id = data.args;
    const filteredInput = data.inputs.find((a) => a.id == 'name_input');

    const Farm = sdk.FarmsManager.at(id);
    if (Farm && Farm.isOwner(Player)) {
        Farm.name = filteredInput.value;
    }
});

onNet('farm-sell-prompt', (id: number) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    Player.OpenModalMenu({
        icon: 'fa-solid fa-exclamation-circle',
        question: TSL.list.sell_farm_question,
        buttons: [
            {
                name: TSL.list.button_sell,
                event: 'farm-sell-accept',
                args: id,
            },
            {
                name: TSL.list.button_cancel,
                event: '',
                args: '',
            },
        ],
        inputs: [
            {
                id: 'source_input',
                placeholder: TSL.list.placeholder_targetId,
            },
            {
                id: 'price_input',
                placeholder: TSL.list.placeholder_price,
            },
        ],
    });
});

onNet('farm-sell-accept', (data: ModalDataButtonTriggerInterface) => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    const id = data.args;
    const targetSource = data.inputs.find((a) => a.id == 'source_input').value;
    const price = data.inputs.find((a) => a.id == 'price_input').value;

    const Farm = sdk.FarmsManager.at(id);
    if (Farm && Farm.isOwner(Player)) {
        const Target = sdk.PlayerManager.at(targetSource);
        if (!Target) return Player.Notification(TSL.list.target_not_exist);
        if (Player.identifier == Target.identifier) return;
        if (Distance(Player.position, Target.position) > 5) return Player.Notification(TSL.list.target_is_far);
        if (Target.getAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount) < parseInt(price)) return Player.Notification(TSL.list.target_not_enough_bank);

        Target.serverVariables.sellOfferedByIdentifier = Player.identifier;
        Target.serverVariables.sellOfferPrice = parseInt(price);
        Target.serverVariables.sellOfferFarmId = parseInt(id);

        Target.OpenModalMenu({
            icon: 'fa-solid fa-question-circle',
            question: TSL.format(TSL.list.sell_farm_prompt_question, [Player.name, price]),
            inputs: [],
            buttons: [
                {
                    name: TSL.list.button_yes,
                    event: 'farm-sell-offer-accept',
                    args: '',
                },
                {
                    name: TSL.list.button_cancel,
                    event: '',
                    args: '',
                },
            ],
        });

        if (Target.serverVariables.sellTimeouter) {
            clearTimeout(Target.serverVariables.sellTimeouter);
            Target.serverVariables.sellTimeouter = null;
        }

        Target.serverVariables.sellTimeouter = setTimeout(() => {
            clearTimeout(Target.serverVariables.sellTimeouter);
            Target.serverVariables.sellTimeouter = null;

            /** Reset to null */
            Target.serverVariables.sellOfferedByIdentifier = null;
            Target.serverVariables.sellOfferPrice = null;
            Target.serverVariables.sellOfferFarmId = null;
        }, 15000);
    }
});
onNet('farm-sell-offer-accept', () => {
    const Player = sdk.PlayerManager.at(global.source);
    if (!Player) return;

    const Farm = sdk.FarmsManager.at(Player.serverVariables.sellOfferFarmId);
    if (!Farm) return;

    const OfferedByPlayer = sdk.PlayerManager.getPlayerWithIdentifier(Player.serverVariables.sellOfferedByIdentifier);
    if (!OfferedByPlayer || Farm.ownerIdentifier !== OfferedByPlayer.identifier) return;

    if (Player.getAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount) < Player.serverVariables.sellOfferPrice) return Player.Notification(TSL.list.not_enough_bank);

    const FarmsAmount = new Map([...sdk.FarmsManager.ServerFarms].filter(([k, v]) => v.ownerIdentifier == Player.identifier));
    if (FarmsAmount.size >= SharedConfig.AnimalFarm.MaximumOwnable) {
        Player.Notification(TSL.list.farm_limit_buy);
        OfferedByPlayer.Notification(TSL.list.farm_target_limit_buy);
        return;
    }

    Farm.ownerIdentifier = Player.identifier;
    Farm.ownerName = Player.name;
    Player.removeAccountMoney("bank", Player.serverVariables.sellOfferPrice);
    OfferedByPlayer.addAccountMoney("bank", Player.serverVariables.sellOfferPrice);

    OfferedByPlayer.Notification(TSL.format(TSL.list.farm_sold, [Player.serverVariables.sellOfferPrice]));
    Player.Notification(TSL.format(TSL.list.farm_bought, [Player.serverVariables.sellOfferPrice]));
});

export class FarmsManager {
    static ServerFarms = new Map<number, AnimalFarm>();

    // static async delete(farmId: number) {
    // return new Promise(resolve => {
    //     let Farm = this.ServerFarms.get(farmId);
    //     if(!Farm) return;

    //     if(this.exist(farmId)) {
    //         this.ServerFarms.delete(farmId);
    //     }

    //     sdk.ServerDatabase.FarmRepository.delete({
    //         where: {
    //             farmId: farmId
    //         },
    //         limit: 1
    //     });
    // });
    // }
    static toArray() {
        return Array.from(this.ServerFarms.values());
    }
    static async insert(d: FarmDatabaseInterface) {
        return new Promise((resolve) => {
            sdk.ServerDatabase.FarmRepository.insert(d).then((res) => {
                if (!res) return;
                const insertId = res.insertId;
                if (typeof insertId !== 'number') return;

                sdk.ServerDatabase.FarmRepository.find({
                    where: {
                        farmId: insertId,
                    },
                }).then((a) => {
                    if (a && a[0]) {
                        const data = a[0];

                        this.ServerFarms.set(data.farmId, new AnimalFarm(data));

                        sdk.CompostManager.loadFarmComposters(data.farmId);
                        sdk.PaddockManager.loadFarmPaddocks(data.farmId);
                        sdk.LootManager.loadFarmLoots(data.farmId);
                        resolve(true);
                    }
                });
            });
        });
    }
    static async loadAll() {
        const rows = await sdk.ServerDatabase.FarmRepository.all();
        rows.forEach((a) => {
            this.ServerFarms.set(a.farmId, new AnimalFarm(a));

            /** Loading composters... */
            sdk.CompostManager.loadFarmComposters(a.farmId);

            /** Loading the paddocks... */
            sdk.PaddockManager.loadFarmPaddocks(a.farmId);

            /** Loading the loots... */
            sdk.LootManager.loadFarmLoots(a.farmId);
        });

        console.info(`Loaded ${rows.length} farms.`);

        /** Start the interval tickers. */
        sdk.FarmTickers.start();
    }
    static at(x: number | AnimalFarm) {
        if (typeof x === 'number') {
            return this.ServerFarms.get(x);
        } else if (x instanceof AnimalFarm) {
            for (let v of this.ServerFarms.values()) {
                if (v == x) return v;
            }
        }
    }
    static exist(x: number | AnimalFarm) {
        if (typeof x === 'number') {
            return this.ServerFarms.has(x);
        } else if (x instanceof AnimalFarm) {
            for (let v of this.ServerFarms.values()) {
                if (v == x) return true;
            }
        }
    }
    static playerJoining(source: string | number) {
        this.ServerFarms.forEach((a) => {
            TriggerClientEvent('load-farm', source, a.data);
        });
    }
}
