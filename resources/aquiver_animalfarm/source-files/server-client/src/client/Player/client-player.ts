import { AttachmentNames, SharedAttachments } from '../../../../shared/shared-attachments';
import { SharedConfig } from '../../../../shared/shared-config';
import { DisableKeyTypes, PlayerSharedVariables } from '../../../../shared/shared-types';

import * as Aquiver from '@aquiversdk/client';
import { Vec3 } from '@aquiversdk/shared';
import * as sdk from '../client';

class Player extends Aquiver.ClientPlayer<PlayerSharedVariables> {
    private _dimension: number = SharedConfig.DimensionManager.DefaultDimension;
    private keyDisableRender: number;
    private _attachments = new Map<string, number>();

    constructor() {
        super();

        onNet('player-set-dimension', (dim: number) => {
            this.dimension = dim;
        });
        onNet('player-keys-disabled', (type: DisableKeyTypes) => {
            this.keysDisabled = type;
        });
        onNet('add-attachment', (name: keyof typeof AttachmentNames) => {
            this.addAttachment(name);
        });
        onNet('remove-attachment', (name: keyof typeof AttachmentNames) => {
            this.removeAttachment(name);
        });
        onNet('setAttachmentOffset', (name, pos, rot, bone) => {
            this.setAttachmentOffset(name, pos, rot, bone);
        });
    }

    private async loadModel(modelHash: number) {
        RequestModel(modelHash);
        while (!HasModelLoaded(modelHash)) {
            await sdk.methods.Wait(100);
            RequestModel(modelHash);
        }
        return true;
    }
    setAttachmentOffset(name: keyof typeof AttachmentNames, pos: Vec3, rot: Vec3, bone: number) {
        let aObject = this._attachments.get(name);
        if (aObject && DoesEntityExist(aObject)) {
            if (IsEntityAttached(aObject)) {
                DetachEntity(aObject, true, false);
                console.log('detached');
            }

            console.log('modify');

            AttachEntityToEntity(
                aObject,
                PlayerPedId(),
                GetPedBoneIndex(PlayerPedId(), bone),
                pos.x,
                pos.y,
                pos.z,
                rot.x,
                rot.y,
                rot.z,
                true,
                true,
                false,
                false,
                2,
                true
            );
        }
    }
    async addAttachment(name: keyof typeof AttachmentNames) {
        const attachmentData = SharedAttachments[name];
        if (!attachmentData) return;

        const hash = GetHashKey(attachmentData.model);
        await this.loadModel(hash);

        const obj = CreateObject(hash, this.position.x, this.position.y, this.position.z, true, true, false);

        AttachEntityToEntity(
            obj,
            PlayerPedId(),
            GetPedBoneIndex(PlayerPedId(), attachmentData.bone),
            attachmentData.pos.x,
            attachmentData.pos.y,
            attachmentData.pos.z,
            attachmentData.rot.x,
            attachmentData.rot.y,
            attachmentData.rot.z,
            true,
            true,
            false,
            false,
            2,
            true
        );

        this._attachments.set(name, obj);
    }
    async removeAttachment(name: keyof typeof AttachmentNames) {
        if (this._attachments.has(name)) {
            const handle = this._attachments.get(name);
            if (handle) {
                if (DoesEntityExist(handle)) {
                    DeleteEntity(handle);
                }

                this._attachments.delete(name);
            }
        }
    }
    set keysDisabled(type: DisableKeyTypes) {
        if (type == 'all') {
            if (this.keyDisableRender) return;

            this.keyDisableRender = setTick(() => {
                DisableAllControlActions(0);
            });
        } else if (type == 'some') {
            if (this.keyDisableRender) return;

            this.keyDisableRender = setTick(() => {
                SharedConfig.Player.DisabledKeysWhileTool.forEach((a) => {
                    DisableControlAction(0, a, true);
                });
            });
        } else {
            if (this.keyDisableRender) {
                clearTick(this.keyDisableRender);
                this.keyDisableRender = null;
            }
        }
    }

    get dimension() {
        return this._dimension;
    }
    set dimension(dim: number) {
        this._dimension = dim;
    }
}
export const localPlayer = new Player();
