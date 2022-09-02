import { Distance, Vec3 } from '@aquiversdk/shared';
import { SharedConfig } from '../../../../shared/shared-config';
import * as sdk from "../client";

export const Raycast = new class {
    private render: NodeJS.Timer;
    private tickrender: number;
    private _entityHitHandle: number;
    private resx: number;
    private resy: number;

    constructor() {
        onNet('raycast-enable', (state: boolean) => {
            state ? this.stop() : this.start();
        });

        [this.resx, this.resy] = GetActiveScreenResolution();
    }
    start() {
        if (!this.render) {
            this.render = setInterval(() => {
                this.RayCastGameplayCamera(SharedConfig.Raycast.distance);
            }, SharedConfig.Raycast.refreshMs);
        }
    }
    stop() {
        this.entityHitHandle = null;

        if (this.render) {
            clearInterval(this.render);
            this.render = null;
        }
    }
    private RayCastGameplayCamera(distance: number) {
        let cameraRotation: number[] | Vec3 = GetGameplayCamRot(2);
        cameraRotation = new Vec3(cameraRotation[0], cameraRotation[1], cameraRotation[2]);

        let cameraCoord: number[] | Vec3 = GetGameplayCamCoord();
        cameraCoord = new Vec3(cameraCoord[0], cameraCoord[1], cameraCoord[2]);

        let direction = this.RotationToDirection(cameraRotation);

        let destination = new Vec3(cameraCoord.x + direction.x * distance, cameraCoord.y + direction.y * distance, cameraCoord.z + direction.z * distance);

        const [shapeTestHandle, hit, endCoords, surfaceNormal, hitHandle] = GetShapeTestResult(
            StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 8 | 1, PlayerPedId(), 0)
        );

        const entityType = GetEntityType(hitHandle);
        /** Object */
        if (entityType == 3) {
            const exist = sdk.ObjectManager.existHandle(hitHandle);
            if (exist) {
                const Object = sdk.ObjectManager.atHandle(hitHandle);
                if (Object) {

                    const d = Distance(Object.position, sdk.localPlayer.position);
                    if (d < 2.5) {
                        this.entityHitHandle = hitHandle;
                    }
                }
            }
        } else if (entityType == 1) {
            /** Ped */
            const exist = sdk.PedManager.existHandle(hitHandle);
            if (exist) {
                const Ped = sdk.PedManager.atHandle(hitHandle);
                if (Ped) {
                    const d = Distance(Ped.position, sdk.localPlayer.position);
                    if (d < 2.5) {
                        this.entityHitHandle = hitHandle;
                    }
                }
            }
        } else {
            this.entityHitHandle = null;
        }
    }
    private RotationToDirection(rotation: Vec3) {
        const pi = Math.PI / 180;
        let adjustedRotation = new Vec3(pi * rotation.x, pi * rotation.y, pi * rotation.z);
        let direction = new Vec3(
            -Math.sin(adjustedRotation.z) * Math.abs(Math.cos(adjustedRotation.x)),
            Math.cos(adjustedRotation.z) * Math.abs(Math.cos(adjustedRotation.x)),
            Math.sin(adjustedRotation.x)
        );
        return direction;
    }
    private set entityHitHandle(e: number) {
        /** Do not trigger if its the same as before */
        if (this.entityHitHandle === e) return;

        this._entityHitHandle = e;

        if (e) {
            if (!this.tickrender) {
                if (!HasStreamedTextureDictLoaded(SharedConfig.Raycast.spriteDict)) {
                    let i = setInterval(() => {
                        if (!HasStreamedTextureDictLoaded(SharedConfig.Raycast.spriteDict)) RequestStreamedTextureDict(SharedConfig.Raycast.spriteDict, true);
                        else clearInterval(i);
                    }, 100);
                }

                this.tickrender = setTick(() => {
                    DisablePlayerFiring(PlayerPedId(), true);

                    const sizeX = this.resy / SharedConfig.Raycast.spriteSize;
                    const sizeY = this.resx / SharedConfig.Raycast.spriteSize; // The big number is the scale, if you reduce it it will become bigger.

                    if (HasStreamedTextureDictLoaded(SharedConfig.Raycast.spriteDict)) {
                        const { r, g, b, a } = SharedConfig.Raycast.spriteColor;
                        DrawSprite(SharedConfig.Raycast.spriteDict, SharedConfig.Raycast.spriteName, 0.5, 0.5, sizeX, sizeY, 0, r, g, b, a);

                        if (this.entityHitObject && this.entityHitObject.variables.raycastName) {
                            sdk.methods.DrawText2D(0.5, 0.505, this.entityHitObject.variables.raycastName);
                        }
                    }

                    if (IsControlJustPressed(0, SharedConfig.Raycast.InteractionKey)) {
                        if (this.entityHitObject) {
                            TriggerServerEvent('object-interaction-press', this.entityHitObject.id);
                        } else if (this.entityHitPed) {
                            TriggerServerEvent('ped-interaction-press', this.entityHitPed.id);
                        }
                    }
                });
            }
        } else {
            if (this.tickrender) clearTick(this.tickrender), (this.tickrender = null);
        }
    }
    private get entityHitHandle() {
        return this._entityHitHandle;
    }
    get entityHitObject() {
        const handle = this.entityHitHandle;
        if (GetEntityType(handle) == 3 && sdk.ObjectManager.existHandle(handle)) {
            return sdk.ObjectManager.atHandle(handle);
        }
    }
    get entityHitPed() {
        const handle = this.entityHitHandle;
        if (GetEntityType(handle) == 1 && sdk.PedManager.existHandle(handle)) {
            return sdk.PedManager.atHandle(handle);
        }
    }
}
