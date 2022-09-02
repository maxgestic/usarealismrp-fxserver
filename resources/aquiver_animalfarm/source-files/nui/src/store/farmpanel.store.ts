import { defineStore } from 'pinia';
import { TSL } from '../../../shared/shared-translations';
import { AnimalEntryInterface, UpgradeEntryInterface, UpgradeInterface } from '../../../shared/shared-types';
import { Camera, useMainStore } from './main.store';
import { Vec3 } from "@aquiversdk/shared";

interface ModalState {
    opened: boolean;
    selectedListIndex: number;
    selectedUpgradeIndex: number;
    selectedAnimalIndex: number;
    page: number;
    pages: string[];
    data: {
        list: UpgradeInterface[];
    };
}

export const useFarmPanelStore = defineStore('farmpanel', {
    state: () => {
        return {
            opened: false,
            selectedListIndex: 0,
            selectedUpgradeIndex: 0,
            selectedAnimalIndex: 0,
            page: 0,
            pages: [TSL.list.nui_upgrades, TSL.list.nui_animals],
            data: {
                list: [
                    {
                        name: "Test",
                        cameraFov: 80.0,
                        cameraPosition: new Vec3(),
                        cameraRotation: new Vec3(),
                        id: 'test',
                        maximumAnimals: 3,
                        upgrades: [
                            {
                                buyEvent: '',
                                buyEventArgs: null,
                                description: 'Test description',
                                img: 'trough.png',
                                model: 'test_model',
                                name: 'Feeding trough',
                                position: new Vec3(),
                                price: 2000,
                                rotation: new Vec3(),
                                upgradeStrid: '',
                            }
                        ],
                        animals: [
                            {
                                animalType: 'PIG',
                                buyEvent: '',
                                buyEventArgs: '',
                                description: 'Description',
                                img: 'pig.svg',
                                name: 'Pig',
                                price: 2000
                            }
                        ]
                    },
                    {
                        name: "Test Second",
                        cameraFov: 80.0,
                        cameraPosition: new Vec3(0, 0, 0),
                        cameraRotation: new Vec3(0, 0, 0),
                        id: 'test-second',
                        maximumAnimals: 2,
                        upgrades: [],
                        animals: []
                    }
                ],
            },
        } as ModalState;
    },
    getters: {
        selectedListData(): UpgradeInterface {
            return this.data.list[this.selectedListIndex];
        },
        selectedUpgradeData(): UpgradeEntryInterface | undefined {
            const d = this.selectedListData;
            if (d && d.upgrades[this.selectedUpgradeIndex]) {
                return d.upgrades[this.selectedUpgradeIndex];
            }
        },
        selectedAnimalData(): AnimalEntryInterface | undefined {
            const d = this.selectedListData;
            if (d && d.animals[this.selectedAnimalIndex]) {
                return d.animals[this.selectedAnimalIndex];
            }
        }
    },
    actions: {
        changePage(page: number) {
            this.page = page;

            if (this.page == 1) this.DeleteUpgradeObject();
            else if (this.page == 0) this.SelectUpgrade(0);
        },
        nextList() {
            if (this.data.list[this.selectedListIndex + 1]) this.selectedListIndex++;
            else this.selectedListIndex = 0;

            Camera.position = this.selectedListData.cameraPosition;
            Camera.rotation = this.selectedListData.cameraRotation;
            Camera.fov = this.selectedListData.cameraFov;
            Camera.render(true, 900);

            this.SelectUpgrade(0);
        },
        previousList() {
            if (this.data.list[this.selectedListIndex - 1]) this.selectedListIndex--;
            else this.selectedListIndex = this.data.list.length - 1;

            Camera.position = this.selectedListData.cameraPosition;
            Camera.rotation = this.selectedListData.cameraRotation;
            Camera.fov = this.selectedListData.cameraFov;
            Camera.render(true, 900);

            this.SelectUpgrade(0);
        },
        open(state: boolean) {
            this.opened = state;

            if (state) {
                Camera.position = this.selectedListData.cameraPosition;
                Camera.rotation = this.selectedListData.cameraRotation;
                Camera.fov = this.selectedListData.cameraFov;
                Camera.render(true, 900);

                this.SelectUpgrade(0);
            } else {
                Camera.render(false, 900);

                this.DeleteUpgradeObject();
            }
        },
        SelectUpgrade(index: number) {
            if (this.page == 1) return this.DeleteUpgradeObject();

            this.selectedUpgradeIndex = index;

            if (this.selectedUpgradeData) {
                const MainStore = useMainStore();
                MainStore.TriggerClient({
                    data: {
                        position: this.selectedUpgradeData?.position,
                        model: this.selectedUpgradeData?.model,
                        rotation: this.selectedUpgradeData?.rotation,
                    },
                    event: 'spawn-upgrade-object',
                });
            }
        },
        DeleteUpgradeObject() {
            const MainStore = useMainStore();
            MainStore.TriggerClient({
                data: '',
                event: 'delete-upgrade-object',
            });
        },
        BuyUpgrade() {
            if (this.selectedListData && this.selectedUpgradeData) {
                const MainStore = useMainStore();
                MainStore.TriggerServer({
                    event: this.selectedUpgradeData.buyEvent,
                    data: this.selectedUpgradeData.buyEventArgs,
                });
            }
        },
        SelectAnimal(index: number) {
            this.selectedAnimalIndex = index;
        },
        BuyAnimal() {
            if (this.selectedListData && this.selectedAnimalData) {
                const MainStore = useMainStore();
                MainStore.TriggerServer({
                    event: this.selectedAnimalData.buyEvent,
                    data: this.selectedAnimalData.buyEventArgs
                });
            }
        }
    },
});

window.addEventListener('message', (e) => {
    const Aquiver = e.data;
    if (Aquiver.event == 'farmpanel-opened-state') useFarmPanelStore().open(Aquiver.data.state);
    else if (Aquiver.event == 'farmpanel-set-data') useFarmPanelStore().data.list = Aquiver.data.list;
});

window.addEventListener('keyup', (e) => {
    if (useFarmPanelStore().opened && e.key == 'Escape') useFarmPanelStore().open(false);
});
