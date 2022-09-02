import { Vec3 } from '@aquiversdk/shared';
import { PedDataInterface } from '../../../../shared/shared-types';
import * as sdk from '../client';

export class AquiverPed {
    public handle: number;

    constructor(private _data: PedDataInterface) {
        this.spawn();
    }
    private async spawn() {
        const modelHash = GetHashKey(this.model);
        RequestModel(modelHash);
        while (!HasModelLoaded(modelHash)) {
            await sdk.methods.Wait(100);
        }

        this.handle = CreatePed(2, modelHash, this.position.x, this.position.y, this.position.z, this.heading, false, false);
        /** Just to re-apply the functions under the setter. */
        this.dead = this.dead;
        TaskSetBlockingOfNonTemporaryEvents(this.handle, true);
        FreezeEntityPosition(this.handle, true);
    }
    get model() {
        return this._data.model;
    }
    get dead() {
        return this._data.dead;
    }
    set dead(state: boolean) {
        this._data.dead = state;

        if (DoesEntityExist(this.handle)) {
            if (state) {
                if (this.model === 'a_c_hen') {
                    this.position = new Vec3(this.position.x, this.position.y, this.position.z + 0.6);
                }

                SetEntityHealth(this.handle, 0);
            } else {
                SetEntityHealth(this.handle, 200);
                ResurrectPed(this.handle);
            }
        }
    }
    get position() {
        return this._data.position;
    }
    set position(pos: Vec3) {
        this._data.position = pos;

        if (DoesEntityExist(this.handle)) {
            SetEntityCoords(this.handle, pos.x, pos.y, pos.z, false, false, false, false);
        }
    }
    get heading() {
        return this._data.heading;
    }
    set heading(h: number) {
        this._data.heading = h;

        if (DoesEntityExist(this.handle)) {
            SetEntityHeading(this.handle, this.heading);
        }
    }
    get dimension() {
        return this._data.dimension;
    }
    set dimension(dim: number) {
        this._data.dimension = dim;
    }
    get id() {
        return this._data.id;
    }
    get variables() {
        return this._data.variables;
    }
    destroy() {
        if (DoesEntityExist(this.handle)) {
            DeleteEntity(this.handle);
            this.handle = null;
        }

        if (PedManager.ClientPeds.has(this.id)) {
            PedManager.ClientPeds.delete(this.id);
        }
    }
}

export const PedManager = new (class {
    ClientPeds = new Map<number, AquiverPed>();

    constructor() {
        onNet('ped-set-all-data', (data: PedDataInterface[]) => {
            for (let v of this.ClientPeds.values()) {
                v.destroy();
            }

            this.ClientPeds.clear();

            data.forEach((a) => {
                this.ClientPeds.set(a.id, new AquiverPed(a));
            });
        });
        onNet('ped-append', (data: PedDataInterface) => {
            this.ClientPeds.set(data.id, new AquiverPed(data));
        });
        onNet('ped-remove', (id: number) => {
            const Ped = this.at(id);
            Ped && Ped.destroy();
        });
        onNet('ped-set-var', (id: number, key: string, value: any) => {
            const Ped = this.at(id);
            Ped && (Ped.variables[key] = value);
        });
        onNet('ped-update-data', (id: number, key: string, value: any) => {
            const Ped = this.at(id);
            Ped && (Ped[key] = value);
        });
    }
    at(x: number | AquiverPed) {
        if (typeof x === 'number') {
            return this.ClientPeds.get(x);
        } else if (x instanceof AquiverPed) {
            for (let v of this.ClientPeds.values()) {
                if (v == x) return v;
            }
        }
    }
    atHandle(x: number) {
        for (let v of this.ClientPeds.values()) {
            if (v.handle == x) return v;
        }
    }
    exist(x: number | AquiverPed) {
        if (typeof x === 'number') {
            return this.ClientPeds.has(x);
        } else if (x instanceof AquiverPed) {
            for (let v of this.ClientPeds.values()) {
                if (v == x) return true;
            }
        }
    }
    existHandle(x: number) {
        for (let v of this.ClientPeds.values()) {
            if (v.handle == x) return true;
        }
    }
})();
