import { defineStore } from 'pinia';
import { ModalDataInterface } from '../../../shared/shared-types';
import { useMainStore } from './main.store';

interface ModalState {
    opened: boolean;
    modaldata: ModalDataInterface;
}

export const useModalStore = defineStore('modal', {
    state: () => {
        return {
            opened: false,
            modaldata: {
                question: 'Are you sure?',
                icon: 'fa-solid fa-question-circle',
                buttons: [
                    {
                        name: 'Yes',
                        event: 'asd',
                        args: 1,
                    },
                ],
                inputs: [
                    {
                        id: 'test',
                        placeholder: 'Text',
                        value: '',
                    },
                    {
                        id: 'message',
                        placeholder: 'Message',
                        value: '',
                    },
                ],
            },
        } as ModalState;
    },
    getters: {},
    actions: {
        buttonClicked(event: string, args: any) {
            const MainStore = useMainStore();

            MainStore.TriggerServer({
                event: event,
                data: {
                    args,
                    inputs: this.modaldata.inputs,
                },
            });

            this.opened = false;
        },
    },
});

window.addEventListener('message', (e) => {
    const Aquiver = e.data;
    if (Aquiver.event == 'open-modal-menu') {
        const ModalStore = useModalStore();
        ModalStore.opened = true;
        ModalStore.modaldata = Aquiver.data;
    }
});

window.addEventListener('keyup', (e) => {
    if (useModalStore().opened && e.key == 'Escape') useModalStore().opened = false;
});
