import { useClickmenuStore } from "@/store/clickmenu.store";
import { useMainStore } from "@/store/main.store";
import { Transition } from "vue";
import { Options, Vue } from "vue-class-component";
import "./style.scss";

@Options({
    watch: {
        'ClickMenuStore.opened'(state:boolean) {
            const MainStore = useMainStore();
            MainStore.FocusNui(state);
        }
    }
})
export default class Clickmenu extends Vue {
    public ClickMenuStore = useClickmenuStore();

    render() {
        return (
            <>
                <Transition enterActiveClass="animate__animated animate__zoomIn animate__faster" leaveActiveClass="animate__animated animate__zoomOut animate__faster" >
                    {this.ClickMenuStore.opened && (
                        <div class='clickmenu-parent'>
                            <div class='clickmenu-header'>{this.ClickMenuStore.serverInfo.header}</div>
                            
                            {this.ClickMenuStore.serverInfo.buttons.map(a => (
                            <div onClick={() => this.ClickMenuStore.Clicked(a.event, a.eventArgs, a.closeAfterClick)} class='clickmenu-entry'>
                                {a.icon && (<i class={a.icon}></i>)}
                                {a.name}
                            </div>    
                            ))}
                        </div>
                    )}
                </Transition>
            </>
        )
    }
}