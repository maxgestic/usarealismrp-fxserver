import { Vec3 } from "@aquiversdk/shared";
import { ObjectDataInterface } from "../../../../shared/shared-types";

import * as sdk from "../server";

export class AquiverObject {
    /** Object binded function when key is pressed. */
    public interactionPress?: (Player?: sdk.FarmPlayer) => void;

    constructor(private _data: ObjectDataInterface) {
        if (typeof this._data.rotation === 'undefined') this._data.rotation = new Vec3(0, 0, 0);
        if (typeof this._data.alpha === 'undefined') this._data.alpha = 255;
        if (typeof this._data.collision === 'undefined') this._data.collision = true;
        if (typeof this._data.freezed === 'undefined') this._data.freezed = false;
        if (typeof this._data.variables === 'undefined') this._data.variables = {}

        /** Spawn the object on every client. */
        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-append', this.data);

        /** Create proxy for variable change and update on clients. */
        this._data.variables = new Proxy(this._data.variables, {
            set: (self, key, value) => {
                if (self[key] === value) return true;

                sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-set-var', this.id, key, value);
                self[key] = value;
                return true;
            },
        });
    }
    get id() {
        return this._data.id;
    }
    get collision() {
        return this._data.collision;
    }
    set collision(state: boolean) {
        this._data.collision = state;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-update-data', this.id, 'collision', this.collision);
    }
    get alpha() {
        return this._data.alpha;
    }
    set alpha(amount: number) {
        if (amount > 255) amount = 255;
        if (amount < 1) amount = 0;
        this._data.alpha = amount;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-update-data', this.id, 'alpha', this.alpha);
    }
    get freezed() {
        return this._data.freezed;
    }
    set freezed(state: boolean) {
        this._data.freezed = state;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-update-data', this.id, 'freezed', this.freezed);
    }
    get rotation() {
        return this._data.rotation;
    }
    set rotation(rot: Vec3) {
        this._data.rotation = rot;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-update-data', this.id, 'rotation', this.rotation);
    }
    get model() {
        return this._data.model;
    }
    set model(model: string) {
        this._data.model = model;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-update-data', this.id, 'model', this.model);
    }
    get position() {
        return this._data.position;
    }
    set position(v3: Vec3) {
        this._data.position = v3;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-update-data', this.id, 'position', this.position);
    }
    get dimension() {
        return this._data.dimension;
    }
    set dimension(dim: number) {
        this._data.dimension = dim;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-update-data', this.id, 'dimension', this.dimension);
    }
    get variables() {
        return this._data.variables;
    }
    get data() {
        return this._data;
    }
    destroy() {
        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'object-remove', this.id);

        if (ObjectManager.ServerObjects.has(this.id)) {
            ObjectManager.ServerObjects.delete(this.id);
        }
    }
}

export class ObjectManager {
    static ServerObjects = new Map<number, AquiverObject>();

    static create(a: ObjectDataInterface) {
        const id = this.generateId();
        a.id = id;

        const Object = new AquiverObject(a);

        this.ServerObjects.set(id, Object);

        return Object;
    }
    static at(x: number | AquiverObject) {
        if (typeof x === 'number') {
            return this.ServerObjects.get(x);
        }
        else if (x instanceof AquiverObject) {
            for (let v of this.ServerObjects.values()) {
                if (v == x)
                    return v;
            }
        }
    }
    static exist(x: number | AquiverObject) {
        if (typeof x === 'number') {
            return this.ServerObjects.has(x);
        }
        else if (x instanceof AquiverObject) {
            for (let v of this.ServerObjects.values()) {
                if (v == x) return true;
            }
        }
    }
    static initOnDimensionChange(Player: sdk.FarmPlayer) {
        const allDataInArray = [...this.ServerObjects.values()].filter(a => a.dimension == Player.dimension).map(a => a.data);
        Player.triggerClient('object-set-all-data', allDataInArray);
    }
    static generateId() {
        let id = 0;
        while (this.ServerObjects.has(id)) {
            id++;
        }
        return id;
    }
}