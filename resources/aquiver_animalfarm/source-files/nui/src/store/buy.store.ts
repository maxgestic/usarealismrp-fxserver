import { defineStore } from 'pinia';
import { BuyDataInterface } from '../../../shared/shared-types';
import { useMainStore } from './main.store';

interface BuyState {
    opened: boolean;
    buydata: BuyDataInterface;
}

export const useBuyStore = defineStore('buy', {
    state: () => {
        return {
            opened: false,
            buydata: {
                image: 'https://oyster.ignimgs.com/mediawiki/apis.ign.com/grand-theft-auto-5/9/97/GTAV.PS4.1080P.284.jpg',
                buttons: [
                    {
                        header: 'Actions',
                        entries: [{ name: 'Buy', event: 'buy', args: ['asd'] }],
                    },
                ],
                texts: [
                    {
                        header: 'Farm',
                        entries: [
                            {
                                question: 'Name',
                                answer: 'Washington farm',
                            },
                        ],
                    },
                ],
            },
        } as BuyState;
    },
    getters: {},
    actions: {
        buttonClicked(event: string, args: any) {
            const MainStore = useMainStore();
            MainStore.TriggerServer({
                event: event,
                data: args,
            });

            this.opened = false;
        },
    },
});

window.addEventListener('message', (e) => {
    const Aquiver = e.data;
    if (Aquiver.event == 'farm-buypanel-state') useBuyStore().opened = Aquiver.data.state;
    else if (Aquiver.event == 'farm-buypanel-data') useBuyStore().buydata = Aquiver.data.buydata;
});

window.addEventListener('keyup', (e) => {
    if (useBuyStore().opened && e.key == 'Escape') useBuyStore().opened = false;
});
