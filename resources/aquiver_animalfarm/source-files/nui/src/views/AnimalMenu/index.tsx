import { useAnimalMenuStore } from "@/store/animalmenu.store";
import { useMainStore } from "@/store/main.store";
import { Transition } from "vue";
import { Options, Vue } from "vue-class-component";
import "./style.scss";

@Options({
    watch: {
        'AnimalStore.opened'(state:boolean) {
            const MainStore = useMainStore();
            MainStore.FocusNui(state);
        }
    }
})
export default class AnimalMenu extends Vue {
    public AnimalStore = useAnimalMenuStore();

    render() {
        return (
            <>
                <Transition enterActiveClass="animate__animated animate__zoomIn animate__faster" leaveActiveClass="animate__animated animate__zoomOut animate__faster" >
                    {this.AnimalStore.opened && (
                        <div class='animalmenu-parent'>
                            <div class='animalmenu-modal'>
                                <div class='header'>
                                    <i onClick={() => this.AnimalStore.opened = false} class='fa-solid fa-times exit-icon'></i>
                                    <div class='animal-image' style={{
                                        backgroundImage: `url(${require('@/assets/' + this.AnimalStore.serverInfo.animalImg)})`
                                    }}></div>
                                    <div class='text'>{this.AnimalStore.serverInfo.animalName}</div>
                                </div>

                                {this.AnimalStore.serverInfo.bars.map(a => (
                                    <div class='bar-entry'>
                                        <div class='bar-image' style={{
                                            backgroundImage: `url(${require('@/assets/' + a.img)})`
                                        }}></div>
                                        <div class='bar-text'>{a.name}</div>
                                        <div class='bar'>
                                            <div class='inside' style={{
                                                backgroundColor: a.color,
                                                width: a.percentage + '%'
                                            }}></div>
                                        </div>
                                    </div>
                                ))}
                            </div>
                            <div class='animalmenu-modal'>
                                <div class='buttons'>
                                    {this.AnimalStore.serverInfo.buttons.map(a => (
                                        <div onClick={() => this.AnimalStore.ButtonClicked(a.event, a.eventArgs, a.closeAfterClick)} class='button-entry'>
                                            <div class='button-image' style={{
                                                backgroundImage: `url(${require('@/assets/' + a.img)})`
                                            }}></div>
                                            <div class='button-text'>{a.name}</div>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    )}
                </Transition>
            </>
        )
    }
}