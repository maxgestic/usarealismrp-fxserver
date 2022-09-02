import { SharedConfig } from "../../../../shared/shared-config";
import { TSL } from "../../../../shared/shared-translations";
import { ObjectDataInterface } from "../../../../shared/shared-types";

import * as sdk from "../client"
import * as AquiverShared from "@aquiversdk/shared";
import { Vec3 } from "@aquiversdk/shared";

export class AquiverObject {
    public handle: number;

    constructor(private _data: ObjectDataInterface) {
        this.addStream();
    }
    get alpha() {
        return this._data.alpha;
    }
    set alpha(amount: number) {
        this._data.alpha = amount;

        if (DoesEntityExist(this.handle)) {
            SetEntityAlpha(this.handle, this.alpha, false);
        }
    }
    get freezed() {
        return this._data.freezed;
    }
    set freezed(state: boolean) {
        this._data.freezed = state;

        if (DoesEntityExist(this.handle)) {
            FreezeEntityPosition(this.handle, this.freezed);
        }
    }
    get rotation() {
        return this._data.rotation;
    }
    set rotation(v3: Vec3) {
        this._data.rotation = v3;

        if (DoesEntityExist(this.handle)) {
            SetEntityRotation(this.handle, v3.x, v3.y, v3.z, 2, false);
        }
    }
    get model() {
        return this._data.model;
    }
    set model(model: string) {
        this._data.model = model;

        if (DoesEntityExist(this.handle)) {
            DeleteEntity(this.handle);
            this.handle = null;
        }

        /** Add to stream again */
        this.addStream();
    }
    get position() {
        return this._data.position;
    }
    set position(v3: Vec3) {
        this._data.position = v3;

        if (DoesEntityExist(this.handle)) {
            SetEntityCoords(this.handle, v3.x, v3.y, v3.z, false, false, false, false);
        }
    }
    get dimension() {
        return this._data.dimension;
    }
    set dimension(dim: number) {
        this._data.dimension = dim;
    }
    get collision() {
        return this._data.collision;
    }
    set collision(state: boolean) {
        this._data.collision = state;

        if (DoesEntityExist(this.handle)) {
            SetEntityCollision(this.handle, this.collision, true);
        }
    }
    get id() {
        return this._data.id;
    }
    get variables() {
        return this._data.variables;
    }
    private async loadModel(modelHash: number) {
        RequestModel(modelHash);
        while (!HasModelLoaded(modelHash)) {
            await sdk.methods.Wait(100);
            RequestModel(modelHash);
        }
        return true;
    }
    async addStream() {
        if (DoesEntityExist(this.handle)) return;

        const hash = GetHashKey(this.model);
        await this.loadModel(hash);

        /** Spawn the object and apply the things. */
        this.handle = CreateObject(hash, this.position.x, this.position.y, this.position.z, false, false, false);

        this.alpha = this.alpha;
        this.freezed = this.freezed;
        this.rotation = this.rotation;
        this.collision = this.collision;
    }
    destroy() {
        if (DoesEntityExist(this.handle)) {
            DeleteEntity(this.handle);
            this.handle = null;
        }

        if (ObjectManager.ClientObjects.has(this.id)) {
            ObjectManager.ClientObjects.delete(this.id);
        }

        if (ObjectManager.TextDistanceObjects.has(this.id)) {
            ObjectManager.TextDistanceObjects.delete(this.id);
        }
    }
}

export const ObjectManager = new class {
    ClientObjects = new Map<number, AquiverObject>();
    TextDistanceObjects = new Map<number, AquiverObject>();
    UpgradeShowcaseObject: number;

    private _fastrender: number;
    private _interval: NodeJS.Timer;

    constructor() {
        onNet('object-append', (data: ObjectDataInterface) => {
            this.ClientObjects.set(
                data.id,
                new AquiverObject(data)
            );
        });
        onNet('object-remove', (id: number) => {
            const Object = this.at(id);
            Object && Object.destroy();
        });
        onNet('object-set-var', (id: number, key: string, value: any) => {
            const Object = this.at(id);
            Object && (Object.variables[key] = value);
        });
        onNet('object-update-data', (id: number, key: string, value: any) => {
            const Object = this.at(id);
            Object && (Object[key] = value);
        });
        onNet('object-set-all-data', (data: ObjectDataInterface[]) => {
            for (let v of this.ClientObjects.values()) {
                v.destroy();
            }

            this.ClientObjects.clear();

            data.forEach(a => {
                this.ClientObjects.set(
                    a.id,
                    new AquiverObject(a)
                );
            });
        });
        onNet('spawn-upgrade-object', (d: { rotation: Vec3; position: Vec3; model: string }) => {
            this.SpawnUpgradeObject(d.rotation, d.position, d.model);
        });
        onNet('delete-upgrade-object', () => {
            this.DeleteUpgradeObject()
        });
    }
    start() {
        if (!this._interval) {
            this._interval = setInterval(() => {
                this.TextDistanceObjects = new Map([...this.ClientObjects].filter(([k, v]) => {
                    return AquiverShared.Distance(sdk.localPlayer.position, v.position) < SharedConfig.ObjectManager.TextDistance;
                }));

                this.renderState(this.TextDistanceObjects.size > 0);
            }, SharedConfig.ObjectManager.tickerMS);
        }
    }
    stop() {
        if (this._interval) {
            clearInterval(this._interval);
            this._interval = null;

            this.renderState(false);
        }
    }
    SpawnUpgradeObject(rotation: Vec3, position: Vec3, model: string) {
        if (DoesEntityExist(this.UpgradeShowcaseObject)) {
            DeleteObject(this.UpgradeShowcaseObject);
            this.UpgradeShowcaseObject = null;
        }

        this.UpgradeShowcaseObject = CreateObject(model, position.x, position.y, position.z, false, false, false);
        SetEntityRotation(this.UpgradeShowcaseObject, rotation.x, rotation.y, rotation.z, 2, false);
        SetEntityAlpha(this.UpgradeShowcaseObject, 155, false);
    }
    DeleteUpgradeObject() {
        if (DoesEntityExist(this.UpgradeShowcaseObject)) {
            DeleteObject(this.UpgradeShowcaseObject);
            this.UpgradeShowcaseObject = null;
        }
    }
    at(x: number | AquiverObject) {
        if (typeof x === 'number') {
            return this.ClientObjects.get(x);
        }
        else if (x instanceof AquiverObject) {
            for (let v of this.ClientObjects.values()) {
                if (v == x) return v;
            }
        }
    }
    atHandle(x: number) {
        for (let v of this.ClientObjects.values()) {
            if (v.handle == x) return v;
        }
    }
    exist(x: number | AquiverObject) {
        if (typeof x === 'number') {
            this.ClientObjects.has(x);
        }
        else if (x instanceof AquiverObject) {
            for (let v of this.ClientObjects.values()) {
                if (v == x) return true;
            }
        }
    }
    existHandle(x: number) {
        for (let v of this.ClientObjects.values()) {
            if (v.handle == x) return true;
        }
    }
    private renderState(state: boolean) {
        if (state) {
            if (this._fastrender) return;

            this._fastrender = setTick(() => {
                this.TextDistanceObjects.forEach(a => {
                    if (typeof a.variables.foodAmount !== 'undefined') {
                        sdk.methods.DrawText3D(
                            new Vec3(a.position.x, a.position.y, a.position.z + 0.85),
                            TSL.format(TSL.list.food_text, [a.variables.foodAmount, SharedConfig.AnimalFarm.maximumFood]),
                            0.25
                        );
                    }

                    if (typeof a.variables.waterAmount !== 'undefined') {
                        sdk.methods.DrawText3D(
                            new Vec3(a.position.x, a.position.y, a.position.z + 0.85),
                            TSL.format(TSL.list.water_text, [a.variables.waterAmount, SharedConfig.AnimalFarm.maximumWater]),
                            0.25
                        );
                    }

                    if (typeof a.variables.constantName !== 'undefined') {
                        sdk.methods.DrawText3D(
                            new Vec3(a.position.x, a.position.y, a.position.z + 0.55),
                            a.variables.constantName,
                            0.25
                        );
                    }

                    if (typeof a.variables.waterTip !== 'undefined') {
                        sdk.methods.DrawText3D(
                            new Vec3(a.position.x, a.position.y, a.position.z + 1),
                            a.variables.waterTipActive ? TSL.list.watertip_filling_text : TSL.list.watertip_text,
                            0.25
                        );
                    }

                    if (typeof a.variables.shitAmount !== 'undefined') {
                        sdk.methods.DrawText3D(
                            new Vec3(a.position.x, a.position.y, a.position.z + 1.7),
                            TSL.format(TSL.list.composter_text, [a.variables.shitAmount, SharedConfig.Composter.maximumWeight]),
                            0.25
                        );
                    }
                });
            });
        }
        else {
            if (this._fastrender) {
                clearTick(this._fastrender);
                this._fastrender = null;
            }
        }
    }
}