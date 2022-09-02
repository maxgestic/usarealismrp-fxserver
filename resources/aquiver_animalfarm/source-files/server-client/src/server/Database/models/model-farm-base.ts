import * as Aquiver from '@aquiversdk/server';
import { FarmDatabaseInterface } from '../../../../../shared/shared-types';

export class FarmBase {
    public farmId?: number;
    public img: string;
    public locked: boolean;
    public name: string;
    public ownerIdentifier: string;
    public ownerName: string;
    public price: number;
    public x: number;
    public y: number;
    public z: number;
    public egg: number;
    public meal: number;
    public milk: number;

    constructor(data: FarmDatabaseInterface) {
        this.farmId = data.farmId;
        this.img = data.img;
        this.locked = data.locked;
        this.name = data.name;
        this.ownerIdentifier = data.ownerIdentifier;
        this.ownerName = data.ownerName;
        this.price = data.price;
        this.x = data.x;
        this.y = data.y;
        this.z = data.z;
        this.egg = data.egg;
        this.meal = data.meal;
        this.milk = data.milk;
    }
}

export class FarmBaseRepository extends Aquiver.BaseDatabase<FarmBase, FarmDatabaseInterface> {
    constructor(tableName: string) {
        super(tableName);
    }
    constructModel(row: FarmDatabaseInterface): FarmBase {
        return new FarmBase(row);
    }
}
