import { defineStore } from 'pinia';
import { ClickMenuInterface } from '../../../shared/shared-types';
import { useMainStore } from './main.store';

interface ModalState
{
    opened: boolean;
    serverInfo: ClickMenuInterface;
}

export const useClickmenuStore = defineStore('clickmenu', {
    state: () =>
    {
        return {
            opened: false,
            serverInfo: {
                header: 'Development',
                buttons: [
                    { name: 'Harvest and gather', icon: 'fa-solid fa-home', event: '', eventArgs: '', closeAfterClick: true }
                ]
            }
        } as ModalState;
    },
    getters: {},
    actions: {
        Clicked(event: string, eventArgs: any, closeAfterClick?: boolean)
        {
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

window.addEventListener('message', (e) =>
{
    const Aquiver = e.data;
    if (Aquiver.event == 'open-clickmenu')
    {
        const Store = useClickmenuStore();
        Store.opened = true;
        Store.serverInfo = Aquiver.data;
    }
});

window.addEventListener('keyup', (e) =>
{
    if (useClickmenuStore().opened && e.key == 'Escape') useClickmenuStore().opened = false;
});
