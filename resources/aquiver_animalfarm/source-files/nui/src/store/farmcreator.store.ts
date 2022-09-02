import { defineStore } from 'pinia';
import { FarmCreateInfoInterface, FarmCreatorListInterface } from '../../../shared/shared-types';
import { useMainStore } from './main.store';

interface ModalState {
    opened: boolean;
    serverInfo: {
        Farms: Array<FarmCreatorListInterface>;
    };
    createInfo: FarmCreateInfoInterface;
    page: number;
}

export const useFarmCreatorStore = defineStore('farmcreator', {
    state: () => {
        return {
            opened: false,
            serverInfo: {
                Farms: [
                    {
                        id: 1,
                        name: 'Yellowstone Ranch',
                        opened: false,
                        ownerIdentifier: 'license-elon-musk',
                        ownerName: 'freamee',
                        price: 25000,
                        locked: false,
                        img: 'imgur.img',
                    },
                    {
                        id: 2,
                        name: 'Farm 2',
                        opened: false,
                    },
                    {
                        id: 3,
                        name: 'Farm 3',
                        opened: false,
                    },
                ],
            },
            createInfo: {
                name: '',
                price: 0,
                url: '',
            },
            page: 1,
        } as ModalState;
    },
    getters: {},
    actions: {
        Clicked(event: string, eventArgs: any, closeAfterClick?: boolean) {
            const MainStore = useMainStore();

            if (event) {
                MainStore.TriggerServer({
                    event: event,
                    data: eventArgs,
                });
            }

            if (closeAfterClick) {
                this.opened = false;
            }
        },
    },
});

window.addEventListener('message', (e) => {
    const Aquiver = e.data;
    if (Aquiver.event == 'open-farmcreator') {
        const Store = useFarmCreatorStore();
        Store.opened = true;
        Store.serverInfo = Aquiver.data;
    } else if (Aquiver.event == 'update-farm-creator') {
        const Store = useFarmCreatorStore();
        let farmIdx = Store.serverInfo.Farms.findIndex((a) => a.id == Aquiver.data.id);
        if (farmIdx >= 0 && Store.serverInfo.Farms[farmIdx]) {
            Store.serverInfo.Farms[farmIdx] = Aquiver.data;
        }
    }
});

window.addEventListener('keyup', (e) => {
    const Store = useFarmCreatorStore();
    if (Store.opened && e.key == 'Escape') {
        Store.opened = false;
    }
});
