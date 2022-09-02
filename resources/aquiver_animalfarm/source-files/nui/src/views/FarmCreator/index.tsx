import { useFarmCreatorStore } from "@/store/farmcreator.store";
import { useMainStore } from "@/store/main.store";
import { Transition } from "vue";
import { Options, Vue } from "vue-class-component";
import "./style.scss";

@Options({
    watch: {
        'FarmCreatorStore.opened'(state: boolean) {
            const MainStore = useMainStore();
            MainStore.FocusNui(state);

            /** Reset */
            if (!state) {
                const FarmCreatorStore = useFarmCreatorStore();
                FarmCreatorStore.page = 1;
                FarmCreatorStore.createInfo = {
                    name: '',
                    price: 0,
                    url: ''
                }
            }
        }
    }
})
export default class FarmCreator extends Vue {
    public FarmCreatorStore = useFarmCreatorStore();
    public MainStore = useMainStore();

    render() {
        const FarmsPage = () => {
            return (
                <div class="farm-list-child">
                    {
                        this.FarmCreatorStore.serverInfo.Farms.map(a => (
                            <div style={
                                {
                                    width: '100%'
                                }
                            }>
                                <div onClick={() => a.opened = !a.opened} class="farm-list-entry">
                                    <i class={a.opened ? 'fa-solid fa-chevron-down' : 'fa-solid fa-chevron-right'}></i>
                                    {a.name}
                                </div>

                                {a.opened && (
                                    <div class="farm-list-edit">

                                        <div class="farm-image">
                                            <div style={{
                                                backgroundImage: `url('${a.img}')`
                                            }} class="image"></div>
                                        </div>


                                        <div class="farm-edit-box">
                                            <div class="farm-edit-text">
                                                Informations
                                            </div>
                                            <div class="farm-edit-input">
                                                <div class="input-name">Name</div>
                                                <input onChange={(e: any) => this.MainStore.TriggerServer({
                                                    event: 'farm-admin-set-name',
                                                    data: {
                                                        name: e.target.value,
                                                        farmId: a.id
                                                    }
                                                })} onInput={(e: any) => a.name = e.target.value} value={a.name} type="text" />
                                            </div>
                                            <div class="farm-edit-input">
                                                <div class="input-name">Image URL</div>
                                                <input onChange={(e: any) => this.MainStore.TriggerServer({
                                                    event: 'farm-admin-set-image',
                                                    data: {
                                                        url: e.target.value,
                                                        farmId: a.id
                                                    }
                                                })} onInput={(e: any) => a.img = e.target.value} value={a.img} type="text" />
                                            </div>
                                            <div class="farm-edit-input">
                                                <div class="input-name">Price</div>
                                                <input onChange={(e: any) => this.MainStore.TriggerServer({
                                                    event: 'farm-admin-set-price',
                                                    data: {
                                                        price: e.target.value,
                                                        farmId: a.id
                                                    }
                                                })} onInput={(e: any) => a.price = e.target.value} value={a.price} type="text" />
                                            </div>
                                            <div class="farm-edit-input">
                                                <div class="input-name">Owner</div>
                                                <input disabled value={a.ownerName} type="text" />
                                            </div>
                                            <div class="farm-edit-input">
                                                <div class="input-name">Owner identifier</div>
                                                <input onChange={(e: any) => this.MainStore.TriggerServer({
                                                    event: 'farm-admin-set-ownerIdentifier',
                                                    data: {
                                                        identifier: e.target.value,
                                                        farmId: a.id
                                                    }
                                                })} onInput={(e: any) => a.ownerIdentifier = e.target.value} value={a.ownerIdentifier} type="text" />
                                            </div>
                                            <div class="farm-edit-input">
                                                <div class="input-name">Locked</div>
                                                <input disabled value={a.locked ? "Yes" : "No"} type="text" />
                                            </div>
                                        </div>
                                        <div class="farm-edit-box">
                                            <div class="farm-edit-text">
                                                Actions
                                            </div>
                                            <div onClick={() => this.MainStore.TriggerServer({
                                                event: 'farm-admin-goto',
                                                data: a.id
                                            })} class="farm-edit-button">
                                                Goto
                                            </div>
                                            <div onClick={() => this.MainStore.TriggerServer({
                                                event: 'farm-admin-resell',
                                                data: a.id
                                            })} class="farm-edit-button">
                                                Resell
                                            </div>
                                            <div onClick={() => this.MainStore.TriggerServer({
                                                event: 'farm-admin-set-position',
                                                data: a.id
                                            })} class="farm-edit-button">
                                                Set Position
                                            </div>
                                            <div onClick={() => this.MainStore.TriggerServer({
                                                event: 'farm-admin-set-lock',
                                                data: a.id
                                            })} class="farm-edit-button">
                                                Lock / Unlock
                                            </div>
                                        </div>
                                    </div>
                                )}
                            </div>
                        ))
                    }
                </div>
            )
        }

        const CreatePage = () => {
            return (
                <div class="farm-list-child">
                    <div class="farm-list-edit">
                        <div class="farm-image">
                            <div style={{
                                backgroundImage: `url('${this.FarmCreatorStore.createInfo.url}')`
                            }} class="image"></div>
                        </div>

                        <div class="farm-edit-box">
                            <div class="farm-edit-text">
                                Informations
                            </div>
                            <div class="farm-edit-input">
                                <div class="input-name">Name</div>
                                <input onInput={(e: any) => this.FarmCreatorStore.createInfo.name = e.target.value} value={this.FarmCreatorStore.createInfo.name} type="text" />
                            </div>
                            <div class="farm-edit-input">
                                <div class="input-name">Image URL</div>
                                <input onInput={(e: any) => this.FarmCreatorStore.createInfo.url = e.target.value} value={this.FarmCreatorStore.createInfo.url} type="text" />
                            </div>
                            <div class="farm-edit-input">
                                <div class="input-name">Price</div>
                                <input onInput={(e: any) => this.FarmCreatorStore.createInfo.price = e.target.value} value={this.FarmCreatorStore.createInfo.price} type="text" />
                            </div>
                            <div class="farm-edit-input">
                                <div class="input-name">Position</div>
                                <input disabled value="Your current position." type="text" />
                            </div>
                        </div>
                        <div class="farm-edit-box">
                            <div class="farm-edit-text">
                                Actions
                            </div>
                            <div onClick={() => {
                                this.MainStore.TriggerServer({
                                    event: 'farm-admin-create-farm',
                                    data: this.FarmCreatorStore.createInfo
                                });

                                /** Close the menu after. */
                                this.FarmCreatorStore.opened = false;

                            }} class="farm-edit-button">
                                Create
                            </div>
                        </div>
                    </div>
                </div>
            )
        }

        return (
            <>
                <Transition enterActiveClass="animate__animated animate__zoomIn animate__faster" leaveActiveClass="animate__animated animate__zoomOut animate__faster" >
                    {this.FarmCreatorStore.opened && (

                        <div class="creator-parent">
                            <div class="creator-header">
                                Farm Manager
                                <i onClick={() => this.FarmCreatorStore.opened = false} class="fa-solid fa-times exit"></i>
                            </div>
                            <div class="creator-navbar">
                                <div onClick={() => this.FarmCreatorStore.page = 1} class={this.FarmCreatorStore.page == 1 ? 'navbar-button active' : 'navbar-button'}>Farms</div>
                                <div onClick={() => this.FarmCreatorStore.page = 2} class={this.FarmCreatorStore.page == 2 ? 'navbar-button active' : 'navbar-button'}>Create Farm</div>
                            </div>


                            {this.FarmCreatorStore.page == 1 && FarmsPage()}
                            {this.FarmCreatorStore.page == 2 && CreatePage()}
                        </div>
                    )}
                </Transition>
            </>
        )
    }
}