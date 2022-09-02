import * as Aquiver from '@aquiversdk/server';
import { AnimalTypes } from '../../../../../shared/shared-types';

export interface AnimalDatabaseInterface {
    aid?: number;
    farmId?: number;
    paddockStrid: string;
    hunger: number;
    age: number;
    thirst: number;
    animalType: AnimalTypes;
    milk: number;
    weight: number;
    health: number;
    extra: number;
}

export class AnimalBase {
    public aid?: number;
    public farmId?: number;
    public age: number;
    public hunger: number;
    public animalType: AnimalTypes;
    public paddockStrid: string;
    public thirst: number;
    public milk: number;
    public weight: number;
    public health: number;
    public extra: number;

    constructor(data: AnimalDatabaseInterface) {
        this.aid = data.aid;
        this.farmId = data.farmId;
        this.age = data.age;
        this.hunger = data.hunger;
        this.animalType = data.animalType;
        this.paddockStrid = data.paddockStrid;
        this.thirst = data.thirst;
        this.milk = data.milk;
        this.weight = data.weight;
        this.health = data.health;
        this.extra = data.extra;
    }
}

export class AnimalBaseRepository extends Aquiver.BaseDatabase<AnimalBase, AnimalDatabaseInterface> {
    constructor(tableName: string) {
        super(tableName);
    }
    constructModel(row: AnimalDatabaseInterface): AnimalBase {
        return new AnimalBase(row);
    }
}
