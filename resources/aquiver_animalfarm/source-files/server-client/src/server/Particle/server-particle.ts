import { Vec3 } from "@aquiversdk/shared";
import { ParticleConstructorInterface } from "../../../../shared/shared-types";

import * as sdk from "../server";

export class AquiverLoopedParticle {
    constructor(private _data: ParticleConstructorInterface) {
        /** Spawn the particle on every client. */
        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'particle-append', this.data);
    }
    set position(p: Vec3) {
        this._data.position = p;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'particle-update-data', this.id, 'position', this.position);
    }
    get dimension() {
        return this._data.dimension;
    }
    get position() {
        return this._data.position;
    }
    set scale(s: number) {
        this._data.scale = s;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'particle-update-data', this.id, 'scale', this.scale);
    }
    get scale() {
        return this._data.scale;
    }
    set rotation(r: Vec3) {
        this._data.rotation = r;

        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'particle-update-data', this.id, 'rotation', this.rotation);
    }
    get rotation() {
        return this._data.rotation;
    }
    get id() {
        return this._data.id;
    }
    get data() {
        return this._data;
    }
    destroy() {
        sdk.PlayerManager.TriggerAllClientDimension(this.dimension, 'particle-remove', this.id);

        if (sdk.ParticleManager.ServerParticles.has(this.id)) {
            sdk.ParticleManager.ServerParticles.delete(this.id);
        }
    }
}

export class ParticleManager {
    static ServerParticles = new Map<number, AquiverLoopedParticle>();

    static create(a: ParticleConstructorInterface, timeMS: number) {
        const id = this.generateId();
        a.id = id;

        const Particle = new AquiverLoopedParticle(a);
        this.ServerParticles.set(
            id,
            Particle
        );

        setTimeout(() => {
            if (Particle) Particle.destroy();
        }, timeMS);

        return Particle;
    }
    static at(x: number | AquiverLoopedParticle) {
        if (typeof x === 'number') {
            return this.ServerParticles.get(x);
        }
        else if (x instanceof AquiverLoopedParticle) {
            for (let v of this.ServerParticles.values()) {
                if (v == x) return v;
            }
        }
    }
    static exist(x: number | AquiverLoopedParticle) {
        if (typeof x === 'number') {
            return this.ServerParticles.has(x);
        }
        else if (x instanceof AquiverLoopedParticle) {
            for (let v of this.ServerParticles.values()) {
                if (v == x) return true;
            }
        }
    }
    static initOnDimensionChange(Player: sdk.FarmPlayer) {
        const allDataInArray = [...this.ServerParticles.values()].filter(a => a.dimension == Player.dimension).map(a => a.data);
        Player.triggerClient('particle-set-all-data', allDataInArray);
    }
    static generateId() {
        let id = 0;
        while (this.ServerParticles.has(id)) {
            id++;
        }
        return id;
    }
}