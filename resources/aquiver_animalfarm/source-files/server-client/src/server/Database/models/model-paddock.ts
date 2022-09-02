import * as Aquiver from '@aquiversdk/server';

interface PaddockDatabaseInterface {
    farmId?: number;
    paddockStrid: string;
    upgradeStrid: string;
    foodAmount: number;
    waterAmount: number;
}

export class PaddockBase {
    public farmId?: number;
    public foodAmount: number;
    public paddockStrid: string;
    public upgradeStrid: string;
    public waterAmount: number;

    constructor(data: PaddockDatabaseInterface) {
        this.farmId = data.farmId;
        this.paddockStrid = data.paddockStrid;
        this.upgradeStrid = data.upgradeStrid;

        this.waterAmount = data.waterAmount;
        this.foodAmount = data.foodAmount;
    }
}

export class PaddockBaseRepository extends Aquiver.BaseDatabase<PaddockBase, PaddockDatabaseInterface> {
    constructor(tableName: string) {
        super(tableName);
    }
    constructModel(row: PaddockDatabaseInterface): PaddockBase {
        return new PaddockBase(row);
    }
}
