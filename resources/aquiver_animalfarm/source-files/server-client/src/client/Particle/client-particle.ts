import { Vec3 } from "@aquiversdk/shared";
import { ParticleConstructorInterface } from "../../../../shared/shared-types";
import * as sdk from "../client";

class AquiverLoopedParticle {
    public particleHandle: number;

    constructor(
        private _data: ParticleConstructorInterface
    ) {
        this.create();
    }
    private async create() {

        if (!HasNamedPtfxAssetLoaded(this._data.dict)) {
            while (!HasNamedPtfxAssetLoaded(this._data.dict)) {
                RequestNamedPtfxAsset(this._data.dict);
                await sdk.methods.Wait(100);
            }
        }

        UseParticleFxAssetNextCall(this._data.dict);
        this.particleHandle = StartParticleFxLoopedAtCoord(
            this._data.particleName,
            this._data.position.x,
            this._data.position.y,
            this._data.position.z,
            this._data.rotation.x,
            this._data.rotation.y,
            this._data.rotation.z,
            this._data.scale,
            false,
            false,
            false,
            false
        );
    }
    set position(p: Vec3) {
        this._data.position = p;

        if (DoesParticleFxLoopedExist(this.particleHandle)) {
            SetParticleFxLoopedOffsets(this.particleHandle, this.position.x, this.position.y, this.position.z, this.rotation.x, this.rotation.y, this.rotation.z);
        }
    }
    get position() {
        return this._data.position;
    }
    set rotation(r: Vec3) {
        this._data.rotation = r;

        if (DoesParticleFxLoopedExist(this.particleHandle)) {
            SetParticleFxLoopedOffsets(this.particleHandle, this.position.x, this.position.y, this.position.z, this.rotation.x, this.rotation.y, this.rotation.z);
        }
    }
    get rotation() {
        return this._data.rotation;
    }
    set scale(amount: number) {
        this._data.scale = amount;

        if (DoesParticleFxLoopedExist(this.particleHandle)) {
            SetParticleFxLoopedScale(this.particleHandle, this.scale);
        }
    }
    get scale() {
        return this._data.scale;
    }
    get id() {
        return this._data.id;
    }
    destroy() {
        if (DoesParticleFxLoopedExist(this.particleHandle)) {
            StopParticleFxLooped(this.particleHandle, false);
        }

        if (ParticleManager.Particles.has(this.id)) {
            ParticleManager.Particles.delete(this.id);
        }
    }
}

export const ParticleManager = new class {
    Particles = new Map<number, AquiverLoopedParticle>();

    constructor() {
        onNet('particle-append', (data: ParticleConstructorInterface) => {
            this.Particles.set(
                data.id,
                new AquiverLoopedParticle(data)
            );
        });
        onNet('particle-remove', (id: number) => {
            const Particle = this.at(id);
            Particle && Particle.destroy();
        });
        onNet('particle-update-data', (id: number, key: string, value: any) => {
            const Particle = this.at(id);
            Particle && (Particle[key] = value);
        });
        onNet('particle-set-all-data', (data: ParticleConstructorInterface[]) => {
            for (let v of this.Particles.values()) {
                v.destroy();
            }

            this.Particles.clear();

            data.forEach(a => {
                this.Particles.set(
                    a.id,
                    new AquiverLoopedParticle(a)
                );
            });
        });
    }
    at(x: number | AquiverLoopedParticle) {
        if (typeof x === 'number') {
            return this.Particles.get(x);
        }
        else if (x instanceof AquiverLoopedParticle) {
            for (let v of this.Particles.values()) {
                if (v == x) return v;
            }
        }
    }
    atHandle(x: number) {
        for (let v of this.Particles.values()) {
            if (v.particleHandle == x)
                return v;
        }
    }
    exist(x: number | AquiverLoopedParticle) {
        if (typeof x === 'number') {
            return this.Particles.has(x);
        }
        else if (x instanceof AquiverLoopedParticle) {
            for (let v of this.Particles.values()) {
                if (v == x) return true;
            }
        }
    }
    existHandle(x: number) {
        for (let v of this.Particles.values()) {
            if (v.particleHandle == x) return true;
        }
    }
}