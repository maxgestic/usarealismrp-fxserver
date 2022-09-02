import { useBuyStore } from "@/store/buy.store";
import { useMainStore } from "@/store/main.store";
import { useModalStore } from "@/store/modal.store";
import { Transition } from "vue";
import { Options, Vue } from "vue-class-component";
import "./style.scss";

@Options({
    watch: {
        'BuyStore.opened'(state: boolean) {
            const MainStore = useMainStore();
            MainStore.FocusNui(state);
        }
    }
})
export default class Buy extends Vue {
    public BuyStore = useBuyStore();
    public ModalStore = useModalStore();

    render() {
        const textsView = () => {
            let d: JSX.Element[] = [];

            this.BuyStore.buydata.texts.forEach(a => {
                d.push(
                    <div class='text-header'>{a.header}</div>
                )
                d.push(
                    <div class='texts-child'>
                        {a.entries.map(entry => (
                            <div class='text-entry'>
                                <div class='question'>{entry.question}</div>
                                <div class='answer'>{entry.answer}</div>
                            </div>
                        ))}
                    </div>
                )
            });

            return d;
        }

        const buttonsView = () => {
            let d: JSX.Element[] = [];

            this.BuyStore.buydata.buttons.forEach(a => {
                d.push(
                    <div class='text-header'>{a.header}</div>
                )

                d.push(
                    <div class='buttons-child'>
                        {a.entries.map(entry => (
                            <div onClick={() => this.BuyStore.buttonClicked(entry.event, entry.args)} class='button-entry'>{entry.name.toUpperCase()}</div>
                        ))}
                    </div>
                )
            });

            return d;
        }

        return (
            <>
                <Transition enterActiveClass="animate__animated animate__fadeIn animate__faster" leaveActiveClass="animate__animated animate__fadeOut animate__faster" >
                    {this.BuyStore.opened && (
                        <div style={{
                            opacity: this.ModalStore.opened ? 0.5 : 1.0,
                            pointerEvents: this.ModalStore.opened ? 'none' : 'all'
                        }} class='buy-parent'>
                            <div class='image' style={{
                                backgroundImage: `url(${this.BuyStore.buydata.image})`
                            }}></div>

                            <div class='buy-child'>
                                {textsView()}
                                {buttonsView()}
                            </div>
                        </div>
                    )}

                </Transition>
            </>
        )
    }
}