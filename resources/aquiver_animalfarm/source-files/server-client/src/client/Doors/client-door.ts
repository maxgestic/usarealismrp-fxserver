import { SharedConfig } from '../../../../shared/shared-config';
import * as sdk from "../client";
import * as AquiverShared from "@aquiversdk/shared";
import { Vec3 } from '@aquiversdk/shared';

export interface DoorConstructorInterface {
    pos: Vec3;
    text: string;
    dimension: number;
    entercallback?: Function;
    lockcallback?: Function;
    buymenucallback?: Function;
}

export class AquiverDoor {
    constructor(private _data: DoorConstructorInterface) { }
    get buymenucallback() {
        return this._data.buymenucallback;
    }
    set buymenucallback(cb: Function) {
        this._data.buymenucallback = cb;
    }
    get entercallback() {
        return this._data.entercallback;
    }
    set entercallback(cb: Function) {
        this._data.entercallback = cb;
    }
    get lockcallback() {
        return this._data.lockcallback;
    }
    set lockcallback(cb: Function) {
        this._data.lockcallback = cb;
    }
    get dimension() {
        return this._data.dimension;
    }
    set dimension(dim: number) {
        this._data.dimension = dim;
    }
    get text() {
        return this._data.text;
    }
    set text(str: string) {
        this._data.text = str;
    }
    get position() {
        return this._data.pos;
    }
    set position(v3: Vec3) {
        this._data.pos = v3;
    }
    destroy() {
        const idx = DoorManager.Doors.findIndex((a) => a == this);
        if (idx >= 0) DoorManager.Doors.splice(idx, 1);

        const streamedidx = DoorManager.StreamedDoors.findIndex((a) => a == this);
        if (streamedidx >= 0) DoorManager.StreamedDoors.splice(streamedidx, 1);
    }
}

export const DoorManager = new class {
    public Doors: AquiverDoor[] = [];
    public StreamedDoors: AquiverDoor[] = [];

    private _fastrender: number;

    constructor() {
        setInterval(() => {
            const playerpos = sdk.localPlayer.position;
            this.StreamedDoors = this.Doors.filter((a) => {
                return AquiverShared.Distance(playerpos, a.position) < SharedConfig.DoorManager.StreamRange && sdk.localPlayer.dimension == a.dimension;
            });

            this.renderstate(this.StreamedDoors.length > 0);
        }, SharedConfig.DoorManager.tickerMS);
    }
    new(data: DoorConstructorInterface) {
        const Door = new AquiverDoor(data);
        this.Doors.push(Door);
        return Door;
    }
    private renderstate(state: boolean) {
        if (state) {
            if (this._fastrender) return;

            this._fastrender = setTick(() => {
                if (IsControlJustPressed(0, SharedConfig.DoorManager.EnterKey)) {
                    this.EnterKeyPressed();
                }

                if (IsControlJustPressed(0, SharedConfig.DoorManager.LockKey)) {
                    this.LockKeyPressed();
                }

                if (IsControlJustPressed(0, SharedConfig.DoorManager.BuyMenuKey)) {
                    this.PropertyKeyPressed();
                }

                this.StreamedDoors.forEach((a) => {
                    sdk.methods.DrawText3D(new Vec3(a.position.x, a.position.y, a.position.z + 0.5), a.text, 0.25);

                    DrawMarker(
                        2,
                        a.position.x,
                        a.position.y,
                        a.position.z - 0.25,
                        0,
                        0,
                        0,
                        0,
                        180,
                        0,
                        0.5,
                        0.5,
                        0.5,
                        0,
                        255,
                        0,
                        125,
                        false,
                        true,
                        2,
                        false,
                        null,
                        null,
                        false
                    );
                });
            });
        } else {
            if (this._fastrender) clearTick(this._fastrender), (this._fastrender = null);
        }
    }
    private getClosestDoorInRange(range: number) {
        const playerpos = sdk.localPlayer.position;
        const CloseDoors = this.Doors.filter((a) => {
            return AquiverShared.Distance(a.position, playerpos) < range && sdk.localPlayer.dimension == a.dimension;
        });
        if (CloseDoors.length < 1) return;

        let closest: AquiverDoor;
        let dist = range;
        CloseDoors.forEach((a) => {
            const d = AquiverShared.Distance(a.position, playerpos);
            if (d < dist) {
                dist = d;
                closest = a;
            }
        });

        return closest;
    }
    private LockKeyPressed() {
        const closest = this.getClosestDoorInRange(SharedConfig.DoorManager.LockRange);
        if (closest && typeof closest.lockcallback === 'function') closest.lockcallback();
    }
    private EnterKeyPressed() {
        const closest = this.getClosestDoorInRange(SharedConfig.DoorManager.EnterRange);
        if (closest && typeof closest.entercallback === 'function') closest.entercallback();
    }
    private PropertyKeyPressed() {
        const closest = this.getClosestDoorInRange(SharedConfig.DoorManager.BuyMenuRange);
        if (closest && typeof closest.buymenucallback === 'function') closest.buymenucallback();
    }
}