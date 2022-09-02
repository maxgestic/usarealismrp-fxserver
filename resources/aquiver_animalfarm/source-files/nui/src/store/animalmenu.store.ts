import { defineStore } from 'pinia';
import { AnimalMenuInfos } from '../../../shared/shared-types';
import { useMainStore } from './main.store';

interface ModalState {
    opened: boolean;
    serverInfo: AnimalMenuInfos;
}

export const useAnimalMenuStore = defineStore('animalmenu', {
    state: () => {
        return {
            opened: false,
            serverInfo: {
                animalImg: 'cow.svg',
                animalName: 'Cow',
                bars: [
                    { img: 'water.svg', name: 'Thirst', percentage: 20, color: 'lightblue'  },
                    { img: 'hunger.svg', name: 'Hunger', percentage: 60, color: 'lightgreen' },
                    { img: 'health.svg', name: 'Health', percentage: 45, color: '#FF6E6E' },
                ],
                buttons: [
                    { name: 'Gather', event: '', eventArgs: '', img: 'gather.svg' },
                    { name: 'Sell', event: '', eventArgs: '', img: 'sell.svg' },
                ]
            }
        } as ModalState;
    },
    getters: {},
    actions: {
        ButtonClicked(event: string, eventArgs: any, closeAfterClick?: boolean) {
            const MainStore = useMainStore();
            
            if(event) {
                MainStore.TriggerServer({
                    event: event,
                    data: eventArgs
                });
            }

            if(closeAfterClick) {
                this.opened = false;
            }
        }
    },
});

window.addEventListener('message', (e) => {
    const Aquiver = e.data;
    if(Aquiver.event == 'set-animal-menu-data') {
        const AnimalStore = useAnimalMenuStore();
        AnimalStore.serverInfo = Aquiver.data;
    }
    else if(Aquiver.event == 'animal-menu-opened-state') {
        const AnimalStore = useAnimalMenuStore();
        AnimalStore.opened = Aquiver.data;
    }
});

window.addEventListener('keyup', (e) => {
    if(useAnimalMenuStore().opened && e.key == 'Escape') useAnimalMenuStore().opened = false;
});
