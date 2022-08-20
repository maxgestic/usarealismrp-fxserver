import { EDITABLE_CONFIG } from "../shared/editable-config";
import { EVENTS, _ } from "../shared/shared-config";
import { PlayerController, RouletteControllerServer } from "./server-roulette";

export class ViewController {
    static updateAll(source: any) {
        if (!PlayerController.exist(source)) return;

        this.chips(source);
        this.timeLeft(source);
        this.statusMessage(source);
        emitNet(EVENTS["view-update-betinput"], source);
        emitNet(EVENTS["view-set-variable"], source, 'maxlogs', EDITABLE_CONFIG.MaximumLog)
    }
    static opened(source: any, state: boolean) {
        if (!PlayerController.exist(source)) return;
        emitNet(EVENTS["view-set-variable"], source, 'opened', state);
    }
    static chips(source: any) {
        if (!PlayerController.exist(source)) return;

        emitNet(EVENTS["view-set-variable"], source, 'chipsAmount', _('cef-owned-chips', [PlayerController.getPlayerChips(source)]));
        let roul = RouletteControllerServer.getPlayerRoulette(source);
        if (roul) {
            emitNet(EVENTS["view-set-variable"], source, 'roundBets', _('cef-round-bets', [roul.getPlayerBetAmount(source)]));
        }
    }
    static timeLeft(source: any) {
        if (!PlayerController.exist(source)) return;

        let roul = RouletteControllerServer.getPlayerRoulette(source);
        if (roul) {
            emitNet(
                EVENTS["view-set-variable"],
                source,
                'timeLeft',
                roul.time > 0 ? _('cef-time-remain', [roul.time]) : ''
            );
        }
    }
    static statusMessage(source: any) {
        if (!PlayerController.exist(source)) return;

        let roul = RouletteControllerServer.getPlayerRoulette(source);
        if (roul) {
            emitNet(EVENTS["view-set-variable"], source, 'statusmessage', EDITABLE_CONFIG.STATUS_MESSAGE[roul.status]);
        }
    }
    static createLog(source: any, log: string) {
        emitNet(EVENTS["view-push-log"], source, `[${createDate()}] ${log}`);
    }
}
function createDate() {
    const date = new Date();
    let hours = date.getHours(),
        minutes = date.getMinutes(),
        seconds = date.getSeconds();
    if (minutes < 10) minutes = '0' + minutes as any;
    if (seconds < 10) seconds = '0' + seconds as any;
    return `${hours}:${minutes}:${seconds}`;
}