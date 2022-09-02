import { useMainStore } from "@/store/main.store";
import { useModalStore } from "@/store/modal.store";
import { Transition } from "vue";
import { Options, Vue } from "vue-class-component";
import "./style.scss";

@Options({
    watch: {
        'ModalStore.opened'(state: boolean) {
            const MainStore = useMainStore();
            MainStore.FocusNui(state);
        }
    }
})
export default class Modal extends Vue {
    public ModalStore = useModalStore();

    render() {
        return (
            <>
                <Transition enterActiveClass="animate__animated animate__zoomIn animate__faster" leaveActiveClass="animate__animated animate__zoomOut animate__faster" >
                    {this.ModalStore.opened && (
                        <div class='modal-parent'>
                            <div onClick={() => this.ModalStore.opened = false} class='modal-exit-icon'><i class='fa-solid fa-xmark'></i></div>

                            {this.ModalStore.modaldata.icon && <div class='modal-icon'><i class={this.ModalStore.modaldata.icon}></i></div>}
                            <div class='modal-question'>{this.ModalStore.modaldata.question}</div>

                            {this.ModalStore.modaldata.inputs.map(a => {
                                return (
                                    <input onInput={(e: any) => a.value = e.target.value} value={a.value} placeholder={a.placeholder} type="text" class='modal-input-entry' />
                                )
                            })}

                            {this.ModalStore.modaldata.buttons.length > 0 && (
                                <div class='modal-buttons-child'>
                                    {this.ModalStore.modaldata.buttons.map(a => {
                                        return (
                                            <div onClick={() => this.ModalStore.buttonClicked(a.event, a.args)} class='modal-button-entry'>{a.name}</div>
                                        )
                                    })}
                                </div>
                            )}
                        </div>
                    )}
                </Transition>
            </>
        )
    }
}