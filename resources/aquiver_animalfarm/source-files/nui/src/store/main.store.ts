import { defineStore } from 'pinia';
import { EventTriggerInterface } from '../../../shared/shared-types';
import { Vec3 } from "@aquiversdk/shared";

interface RootState {
    page: number;
    opened: boolean;
}

export const useMainStore = defineStore('main', {
    state: () => {
        return {
            page: 1,
            opened: true,
        } as RootState;
    },
    getters: {},
    actions: {
        TriggerClient(trigger: EventTriggerInterface) {
            // @ts-ignore
            if (typeof GetParentResourceName === 'function') {
                // @ts-ignore
                fetch(`https://${GetParentResourceName()}/aqv-trigger-client`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({ event: trigger.event, data: trigger.data }),
                })
                    .catch()
                    .then();
            }
        },
        TriggerServer(trigger: EventTriggerInterface) {
            // @ts-ignore
            if (typeof GetParentResourceName === 'function') {
                // @ts-ignore
                fetch(`https://${GetParentResourceName()}/aqv-trigger-server`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({ event: trigger.event, data: trigger.data }),
                })
                    .catch()
                    .then();
            }
        },
        FocusNui(state: boolean) {
            this.TriggerClient({
                event: 'aqv-nui-focus',
                data: state,
            });
        },
    },
});

export const Camera = {
    set fov(f: number) {
        const MainStore = useMainStore();
        MainStore.TriggerClient({
            data: f,
            event: 'set-cam-fov',
        });
    },
    set rotation(r: Vec3) {
        const MainStore = useMainStore();
        MainStore.TriggerClient({
            data: r,
            event: 'set-cam-rot',
        });
    },
    set position(p: Vec3) {
        const MainStore = useMainStore();
        MainStore.TriggerClient({
            data: p,
            event: 'set-cam-pos',
        });
    },
    render(state: boolean, ease: number) {
        const MainStore = useMainStore();
        MainStore.TriggerClient({
            data: {
                state,
                ease,
            },
            event: 'cam-render',
        });
    },
};
