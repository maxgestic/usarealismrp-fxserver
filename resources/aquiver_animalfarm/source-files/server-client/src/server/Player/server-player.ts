import { AttachmentNames, SharedAttachments } from '../../../../shared/shared-attachments';
import { SharedConfig } from '../../../../shared/shared-config';
import { ClickMenuInterface, DisableKeyTypes, EventTriggerInterface, ModalDataInterface, PlayerSharedVariables } from '../../../../shared/shared-types';
import * as sdk from '../server';
import * as Aquiver from '@aquiversdk/server';
import { Vec3 } from '@aquiversdk/shared';

interface ServerPlayerVariables {
    sellOfferedByIdentifier: string;
    sellOfferPrice: number;
    sellOfferFarmId: number;
    sellTimeouter: any;

    bucketMilkLiters: number;
}

export class FarmPlayer extends Aquiver.ServerPlayer<ServerPlayerVariables, PlayerSharedVariables> {
    private _dimension: number = SharedConfig.DimensionManager.DefaultDimension;
    private attachments = new Set<keyof typeof AttachmentNames>();

    constructor(source: number) {
        super(source);
    }

    set keysDisabled(type: DisableKeyTypes) {
        this.triggerClient('player-keys-disabled', type);
    }
    get dimension() {
        return this._dimension;
    }
    set dimension(dim: number) {
        this._dimension = dim;
        this.triggerClient('player-set-dimension', this.dimension);
        SetPlayerRoutingBucket(this.source.toString(), this.dimension);

        /** Load the objects and every other thing in the dimension. */
        sdk.ParticleManager.initOnDimensionChange(this);
        sdk.PedManager.initOnDimensionChange(this);
        sdk.ObjectManager.initOnDimensionChange(this);

        /** Delete all attachment on dimension change */
        this.deleteAllAttachments();
    }

    resetAttachmentDefaultPosition(name: keyof typeof AttachmentNames) {
        if (!this.attachments.has(name)) return;

        const attachmentData = SharedAttachments[name];
        if (attachmentData) {
            this.setAttachmentOffset(name, attachmentData.pos, attachmentData.rot, attachmentData.bone);
        }
    }
    setAttachmentOffset(name: keyof typeof AttachmentNames, pos: Vec3, rot: Vec3, bone: number) {
        if (!this.attachments.has(name)) return;

        this.triggerClient('setAttachmentOffset', name, pos, rot, bone);
    }
    addAttachment(name: keyof typeof AttachmentNames) {
        if (this.attachments.has(name)) return;

        this.attachments.add(name);
        this.triggerClient('add-attachment', name);

        switch (name) {
            case 'bucketEmpty': {
                this.keysDisabled = 'some';
                break;
            }
            case 'bucketWithMilk': {
                this.keysDisabled = 'some';
                break;
            }
            case 'bucketWithWater': {
                this.keysDisabled = 'some';
                break;
            }
            case 'shovel': {
                this.PlayAnimation('timetable@gardener@clean_pool@', 'base_gardener', 49);
                this.keysDisabled = 'some';
                break;
            }
            case 'shovelWithShit': {
                this.PlayAnimation('timetable@gardener@clean_pool@', 'base_gardener', 49);
                this.keysDisabled = 'some';
                break;
            }
            case 'foodBag': {
                this.keysDisabled = 'some';
                break;
            }
        }
    }
    removeAttachment(name: keyof typeof AttachmentNames) {
        if (this.attachments.has(name)) {
            this.attachments.delete(name);
            this.triggerClient('remove-attachment', name);

            switch (name) {
                case 'bucketEmpty': {
                    this.keysDisabled = null;
                    break;
                }
                case 'bucketWithMilk': {
                    this.keysDisabled = null;
                    break;
                }
                case 'bucketWithWater': {
                    this.keysDisabled = null;
                    break;
                }
                case 'shovel': {
                    this.StopAnimation();
                    this.keysDisabled = null;
                    break;
                }
                case 'shovelWithShit': {
                    this.StopAnimation();
                    this.keysDisabled = null;
                    break;
                }
                case 'foodBag': {
                    this.keysDisabled = null;
                    break;
                }
            }
        }
    }
    hasAttachment(name: keyof typeof AttachmentNames) {
        return this.attachments.has(name);
    }
    hasAnyAttachment() {
        return this.attachments.size > 0;
    }
    deleteAllAttachments() {
        if (this.attachments.size > 0) {
            this.attachments.forEach((name) => {
                this.removeAttachment(name);
            });

            this.attachments.clear();
        }
    }
    TriggerChromium(trigger: EventTriggerInterface) {
        TriggerClientEvent('aqv-trigger-chromium', this.source, trigger);
    }
    OpenModalMenu(data: ModalDataInterface) {
        this.TriggerChromium({
            event: 'open-modal-menu',
            data: data,
        });
    }
    OpenClickMenu(data: ClickMenuInterface) {
        this.TriggerChromium({
            event: 'open-clickmenu',
            data: data,
        });
    }
    /** Whether the current farm is that you own or not. */
    isPlayerInOwnedFarm() {
        const Farm = sdk.FarmsManager.at(this.dimension);
        return Farm && Farm.isOwner(this);
    }
}

export class PlayerManager {
    static Players = new Map<number, FarmPlayer>();

    static at(source: number | string) {
        if (typeof source !== 'number') source = Number(source);

        const Player = this.Players.get(source);
        if (!Player || !Player.exist()) return;
        return Player;
    }
    static exist(source: number | string) {
        const Player = this.at(source);
        return Player && Player.exist();
    }
    static getPlayerWithIdentifier(identifier: string) {
        for (let v of this.Players.values()) {
            if (v.identifier == identifier) return v;
        }
    }
    static playerJoining(source: string | number) {
        if (typeof source !== 'number') source = Number(source);

        this.Players.set(source, new FarmPlayer(source));
    }
    static playerDropped(source: string | number) {
        if (typeof source !== 'number') source = Number(source);

        // const Player = this.at(source);
        // if (Player) {
        //     const Farm = sdk.FarmsManager.at(Player.dimension);
        //     if (Farm) {
        //         const { x, y, z } = Farm.position;
        //         /** Here you should somehow save this x,y,z coordinates in your framework */
        //         global.exports["some_lua_resource"]: saveLastPosition(Player.identifier, x, y, z);
        //     }
        // }

        if (this.Players.has(source)) this.Players.delete(source);
    }
    /** Trigger client event for players in dimension. */
    static TriggerAllClientDimension(dimension: number, event: string, ...args: any[]) {
        for (let v of this.Players.values()) {
            if (v.dimension == dimension) TriggerClientEvent(event, v.source, ...args);
        }
    }
    /** Trigger client event on all of the players. */
    static TriggerAllClient(event: string, ...args: any[]) {
        for (let v of this.Players.values()) {
            TriggerClientEvent(event, v.source, ...args);
        }
    }
}

onNet('object-interaction-press', (objectId: number) => {
    const Player = PlayerManager.at(global.source);
    if (!Player) return;
    const Object = sdk.ObjectManager.at(objectId);
    if (!Object || typeof Object.interactionPress !== 'function') return;

    Object.interactionPress(Player);
});
onNet('ped-interaction-press', (pedId: number) => {
    const Player = PlayerManager.at(global.source);
    if (!Player) return;
    const Ped = sdk.PedManager.at(pedId);
    if (!Ped || typeof Ped.interactionPress !== 'function') return;

    Ped.interactionPress(Player);
});
