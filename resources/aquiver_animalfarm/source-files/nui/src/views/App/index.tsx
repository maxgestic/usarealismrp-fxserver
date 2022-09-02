
import { useMainStore } from "@/store/main.store";
import { Options, Vue } from "vue-class-component";
import "./style.scss";
import Buy from "../Buy";
import Modal from "../Modal";
import FarmPanel from "../FarmPanel";
import Clickmenu from "../Clickmenu";
import AnimalMenu from "../AnimalMenu";
import FarmCreator from "../FarmCreator";

@Options({
    components: {
        Buy,
        Modal,
        FarmPanel,
        Clickmenu,
        AnimalMenu,
        FarmCreator
    }
})
export default class App extends Vue {
    public MainStore = useMainStore();

    render() {
        return (
            <>
                <div id="app" class="main-parent">
                    <Buy />
                    <Modal />
                    <FarmPanel />
                    <Clickmenu />
                    <AnimalMenu />
                    <FarmCreator />
                </div>
            </>
        )
    }
}