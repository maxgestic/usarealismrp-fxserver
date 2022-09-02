import { useFarmPanelStore } from "@/store/farmpanel.store";
import { useMainStore } from "@/store/main.store";
import { Transition, TransitionGroup } from "vue";
import { Options, Vue } from "vue-class-component";
import "./style.scss";

@Options({
    watch: {
        'FarmPanelStore.opened'(state: boolean) {
            const MainStore = useMainStore();
            MainStore.FocusNui(state);
            MainStore.TriggerClient({
                event: 'raycast-enable',
                data: state
            });
        }
    }
})
export default class FarmPanel extends Vue {
    public FarmPanelStore = useFarmPanelStore();

    render() {

        const Arrows = () => {
            return (
                <div class='farm-arrows-parent'>
                    <div class='text'>{this.FarmPanelStore.selectedListData.name}</div>
                    <div class='selected-list-index-arrows'>{this.FarmPanelStore.selectedListIndex} / {this.FarmPanelStore.data.list.length - 1}</div>
                    <i onClick={this.FarmPanelStore.previousList} class='fa-solid fa-chevron-left arrow left'></i>
                    <i onClick={this.FarmPanelStore.nextList} class='fa-solid fa-chevron-right arrow right'></i>
                </div>
            )
        }

        const UpgradesPage = () => {
            return (
                <>
                    {Arrows()}

                    <div class='farm-upgrades-parent'>
                        <TransitionGroup enterActiveClass="animate__animated animate__zoomIn animate__faster" leaveActiveClass="animate__animated animate__zoomOut animate__faster" >
                            {
                                this.FarmPanelStore.selectedListData.upgrades.map((a, index) => {
                                    return (
                                        <div key={index} onClick={() => this.FarmPanelStore.SelectUpgrade(index)}
                                            class={this.FarmPanelStore.selectedUpgradeIndex == index ? 'upgrade-entry active' : 'upgrade-entry'}>

                                            {/* Render the check circle if has the upgrade  */}
                                            {a.has && <i class='fa-solid fa-check-circle upgrade-already'></i>}

                                            <div style={{
                                                backgroundImage: `url(${require('@/assets/' + a.img)})`
                                            }} class='img'></div>
                                            <div class='upgrade-text'>{a.name}</div>
                                        </div>
                                    )
                                })
                            }
                        </TransitionGroup>
                    </div>

                    {this.FarmPanelStore.selectedUpgradeData && (
                        <div class='farm-upgrade-information-parent'>
                            <div class='header'><i class='fa-solid fa-info-circle'></i> {this.FarmPanelStore.selectedUpgradeData.name}</div>
                            <div class='text small'><b>Description</b> <br /> {this.FarmPanelStore.selectedUpgradeData?.description}</div>
                            <div class='text small'><b>Price</b> <br /> ${this.FarmPanelStore.selectedUpgradeData?.price}</div>
                            <div onClick={this.FarmPanelStore.BuyUpgrade} class='button'>Buy Upgrade</div>
                        </div>
                    )}
                </>
            )
        }

        const AnimalsPage = () => {
            return (
                <>
                    {Arrows()}

                    <div class='maximum-animals-amount'>
                        Maximum animals: {this.FarmPanelStore.selectedListData.maximumAnimals}
                    </div>

                    <div class='farm-upgrades-parent'>
                        <TransitionGroup enterActiveClass="animate__animated animate__zoomIn animate__faster" leaveActiveClass="animate__animated animate__zoomOut animate__faster" >
                            {
                                this.FarmPanelStore.selectedListData.animals.map((a, index) => {
                                    return (
                                        <div key={index} onClick={() => this.FarmPanelStore.SelectAnimal(index)}
                                            class={this.FarmPanelStore.selectedAnimalIndex == index ? 'upgrade-entry active' : 'upgrade-entry'}>

                                            <div style={{
                                                backgroundImage: `url(${require('@/assets/' + a.img)})`
                                            }} class='img'></div>
                                            <div class='upgrade-text'>{a.name}</div>
                                        </div>
                                    )
                                })
                            }
                        </TransitionGroup>
                    </div>

                   {this.FarmPanelStore.selectedAnimalData && (
                        <div class='farm-upgrade-information-parent'>
                            <div class='header'><i class='fa-solid fa-info-circle'></i> {this.FarmPanelStore.selectedAnimalData.name}</div>
                            <div class='text small'><b>Description</b> <br /> {this.FarmPanelStore.selectedAnimalData?.description}</div>
                            <div class='text small'><b>Price</b> <br /> ${this.FarmPanelStore.selectedAnimalData?.price}</div>
                            <div onClick={this.FarmPanelStore.BuyAnimal} class='button'>Buy Animal</div>
                        </div>
                    )} 
                </>
            )
        }

        return (
            <Transition enterActiveClass="animate__animated animate__fadeIn animate__faster" leaveActiveClass="animate__animated animate__fadeOut animate__faster" >
                {this.FarmPanelStore.opened && (
                    <div class='farmpanel-main'>
                        <div class='farm-pages-parent'>
                            {
                                this.FarmPanelStore.pages.map((a, index) => {
                                    return (
                                        <div onClick={() => this.FarmPanelStore.changePage(index)} class={this.FarmPanelStore.page == index ? 'farm-page-entry active' : 'farm-page-entry'}>{a}</div>
                                    )
                                })
                            }
                        </div>


                        {this.FarmPanelStore.page == 0 && UpgradesPage()}
                        {this.FarmPanelStore.page == 1 && AnimalsPage()}
                    </div>
                )}
            </Transition>
        )
    }
}