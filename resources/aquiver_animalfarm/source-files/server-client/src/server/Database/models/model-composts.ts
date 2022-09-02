import * as Aquiver from '@aquiversdk/server';

interface CompostDatabaseInterface {
    farmId?: number;
    compostStrid: string;
    shitAmount: number;
}

export class CompostBase {
    public farmId?: number;
    public compostStrid: string;
    public shitAmount: number;

    constructor(data: CompostDatabaseInterface) {
        this.farmId = data.farmId;
        this.compostStrid = data.compostStrid;
        this.shitAmount = data.shitAmount;
    }
}

export class CompostsBaseRepository extends Aquiver.BaseDatabase<CompostBase, CompostDatabaseInterface> {
    constructor(tableName: string) {
        super(tableName);
    }
    constructModel(row: CompostDatabaseInterface): CompostBase {
        return new CompostBase(row);
    }
}
