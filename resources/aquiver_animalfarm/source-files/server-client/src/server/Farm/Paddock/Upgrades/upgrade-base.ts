import { UpgradeData, UpgradeEntryInterface } from "../../../../../../shared/shared-types";

import * as sdk from "../../../server";

export abstract class UpgradeBase
{
    /** Private(s) */
    private _upgraded: boolean = false;

    /** Public */
    public object: sdk.AquiverObject;

    constructor(
        public data: UpgradeData
    ) { }

    abstract get description(): string;
    abstract get name(): string;
    abstract get img(): string;
    abstract Upgrade(Player: sdk.FarmPlayer): void;

    get upgraded()
    {
        return this._upgraded;
    }
    set upgraded(state: boolean)
    {
        this._upgraded = state;
    }
    get interface(): UpgradeEntryInterface
    {
        return {
            buyEvent: 'buy-paddock-upgrade',
            buyEventArgs: {
                paddockStrid: this.data.paddockStrid,
                upgradeStrid: this.data.upgradeStrid
            },
            description: this.description,
            img: this.img,
            name: this.name,
            model: this.data.model,
            position: this.data.position,
            price: this.data.price,
            rotation: this.data.rotation,
            upgradeStrid: this.data.upgradeStrid,
            has: this.upgraded
        }
    }
}