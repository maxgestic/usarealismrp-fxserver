import { EDITABLE_CONFIG } from '../shared/editable-config';
import { EVENTS, Delay, randomInt, TICKRATE_NUMBERS, NUMBERS, winMultiply, randomFromArray, sLogger, _U, _ } from '../shared/shared-config';
import { chair_types, IBetData, IChairData, IRouletteBets, IRouletteData, STATUS_TYPES } from '../shared/shared.roulette.interface';
import { ViewController } from './server-roulette-view';

export class PlayerController {
    static getPlayerChips(source: any) {
        return global.exports[GetCurrentResourceName()].getPlayerChips(source);
    }
    static giveChips(source: any, amount: number) {
        global.exports[GetCurrentResourceName()].givePlayerChips(source, amount);
        ViewController.chips(source);
    }
    static removeChips(source: any, amount: number) {
        global.exports[GetCurrentResourceName()].removePlayerChips(source, amount);
        ViewController.chips(source);
    }
    static notification(source: any, msg: string) {
        emitNet(EVENTS['default-notif'], source, msg);
    }
    static playerName(source: any) {
        return global.exports[GetCurrentResourceName()].getPlayerName(source);
    }
    static exist(source: any) {
        return GetPlayerName(source) != null;
    }
}

export class RouletteControllerServer {
    static ServerRoulettes: RouletteServer[] = [];
    static timer = setInterval(() => RouletteControllerServer.tick(), 1000);

    /**
     * Get Roulette class by **uid**, then you can call functions on it.
     * @param uid - Roulette **UID**.
     */
    static get(uid: number) {
        if (!this.exist(uid)) return;
        return this.ServerRoulettes.find((a) => a.uid == uid);
    }
    /** Get roulette child class what the player is using. */
    static getPlayerRoulette(source: any) {
        for (let i = 0; i < this.ServerRoulettes.length; i++) {
            let d = this.ServerRoulettes[i];
            if (d.players.filter((a) => a.source == source).length > 0) {
                return this.ServerRoulettes[i];
            }
        }
    }
    /** Ticking all roulette tables. */
    static tick() {
        for (let i = 0; i < this.ServerRoulettes.length; i++) {
            this.ServerRoulettes[i].tick();
        }
    }
    /**
     * Check if Roulette table Class is exist.
     * @param uid - Roulette **UID**.
     */
    static exist(uid: number) {
        return this.ServerRoulettes.findIndex((a) => a.uid == uid) >= 0;
    }
    /** Event is triggered when the player left the server. */
    static playerDropped(source: any) {
        for (let i = 0; i < this.ServerRoulettes.length; i++) {
            let d = this.ServerRoulettes[i];

            let idx = d.players.findIndex((a) => a.source == source);
            if (idx >= 0) {
                d.players.splice(idx, 1);
                d.updatePlayers();
                sLogger(`Player (${source}) dropped while he sit at roulette table.`);
            }
        }
    }
}

export class RouletteServer {
    players: { source: any; chairName: chair_types }[] = [];
    private _time: number = EDITABLE_CONFIG.START_TIME;
    private _status: STATUS_TYPES = 'NOT_STARTED';
    tickrate: number;
    bets: IRouletteBets[] = [];

    constructor(public tableData: IRouletteData, public uid: number) {
        RouletteControllerServer.ServerRoulettes[this.uid] = this;
    }
    sitdown(source: any, chairData: IChairData) {
        if (this.isChairOccupied(chairData.chairName)) return PlayerController.notification(source, `Chair is occupied!`);

        emitNet(EVENTS['sitdown-callback'], source, chairData);

        this.players.push({
            source: source,
            chairName: chairData.chairName,
        });
        this.updatePlayers();
        ViewController.updateAll(source);
        ViewController.opened(source, true);
    }
    standup(source: any) {
        const idx = this.players.findIndex((a) => a.source == source);
        if (idx >= 0) {
            this.players.splice(idx, 1);
            this.updatePlayers();
            sLogger(`Player (${source}) stood up from the roulette table. tableuid: ${this.uid}`);
        }
        ViewController.opened(source, false);
    }
    async tick() {
        if (this.players.length < 1) return; // Do not tick if no-one is playing.

        if (this.status == 'NOT_STARTED') {
            this.time--;

            if (this.time < 1) {
                this.status = 'STARTED';
                this.tickrate = randomInt(1, 38);
                emitNet(EVENTS['spin'], -1, this.uid, this.tickrate);
                await Delay(20000);
                this.sortwinners();
                await Delay(1500);
                this.reset();
            }
        }
    }
    reset() {
        this.status = 'NOT_STARTED';
        this.time = EDITABLE_CONFIG.START_TIME;
        this.bets = [];
        this.tickrate = null;

        /** Cef update, round bets amount to 0. */
        for (let i = 0; i < this.players.length; i++) {
            if (!PlayerController.exist(this.players[i].source)) continue;
            ViewController.chips(this.players[i].source);
            ViewController.createLog(this.players[i].source, _U('cef-new-game-starting'));
        }
    }
    sortwinners() {
        let winnerplayers: { source: number; amount: number }[] = [];

        let number = TICKRATE_NUMBERS[this.tickrate];
        let wintypes = [number];

        for (const type in NUMBERS) {
            if (NUMBERS[type].includes(number)) {
                wintypes.push(type);
            }
        }

        for (let i = 0; i < this.bets.length; i++) {
            let d = this.bets[i];

            if (!PlayerController.exist(d.source)) continue;

            if (wintypes.includes(d.betId)) {
                let winmultiply = winMultiply(d.amount, d.betId);
                let idx = winnerplayers.findIndex((a) => a.source == d.source);
                if (idx >= 0) {
                    winnerplayers[idx].amount += winmultiply;
                } else {
                    winnerplayers.push({ source: d.source, amount: winmultiply });
                }
            }
        }

        for (let i = 0; i < winnerplayers.length; i++) {
            let Winner = winnerplayers[i];

            /** Continue if player is not exist. */
            if (!PlayerController.exist(Winner.source)) continue;

            PlayerController.giveChips(Winner.source, Winner.amount);
            emitNet(EVENTS['anim-win'], Winner.source);
        }

        /** Play the sad animation */
        for (let i = 0; i < this.players.length; i++) {
            let Player = this.players[i];
            /** Continue if player is not exist. */
            if (!PlayerController.exist(Player.source)) continue;

            ViewController.createLog(Player.source, _('cef-game-ended', [number]));

            let idx = winnerplayers.findIndex((a) => a.source == Player.source);
            if (idx >= 0) continue;

            emitNet(randomFromArray([EVENTS['anim-loss'], EVENTS['anim-impartial']]), Player.source);
        }
    }
    isChairOccupied(chairName: string) {
        return this.players.filter((a) => a.chairName == chairName).length > 0;
    }
    bet(source: any, amount: number, betData: IBetData) {
        let chipsAmount = PlayerController.getPlayerChips(source);
        if (chipsAmount < amount) return PlayerController.notification(source, _U('not-enough-chips'));

        if (this.getPlayerBetAmount(source) + amount > this.tableData.maxbet) return PlayerController.notification(source, _U('more-then-maxbet'));

        if (amount < this.tableData.minbet) return PlayerController.notification(source, _('min-bet-is', [this.tableData.minbet]));

        if (this.status != 'NOT_STARTED') return PlayerController.notification(source, _U('started-can-not-bet'));

        PlayerController.removeChips(source, amount);

        let idx = this.bets.findIndex((a) => a.source == source && a.betId == betData.betId);
        if (idx >= 0) {
            this.bets[idx].amount += amount;
        } else {
            this.bets.push({
                source: source,
                betId: betData.betId,
                amount: amount,
            });
        }

        emitNet(EVENTS['anim-bet'], source);
        emitNet(EVENTS['update-bets'], -1, this.uid, this.bets);
        ViewController.chips(source);

        for (let i = 0; i < this.players.length; i++) {
            if (!PlayerController.exist(this.players[i].source)) continue;
            ViewController.createLog(
                this.players[i].source,
                _('cef-log-placed-bet', [
                    PlayerController.playerName(source),
                    amount,
                    typeof betData.betId == 'string' ? betData.betId : 'NUMBER ' + betData.betId,
                ])
            );
        }
    }
    getPlayerBetAmount(source: any) {
        let amount = 0;
        for (let i = 0; i < this.bets.length; i++) {
            let d = this.bets[i];
            if (d.source == source) {
                amount += d.amount;
            }
        }
        return amount;
    }
    updatePlayers() {
        emitNet(EVENTS['update-players-count'], -1, this.uid, this.players.length);
    }
    requestUpdate(source: any) {
        emitNet(EVENTS['update-players-count'], source, this.uid, this.players.length);
        emitNet(EVENTS['update-status'], source, this.uid, this.status);
        emitNet(EVENTS['update-time'], source, this.uid, this.time);
        emitNet(EVENTS['update-bets'], source, this.uid, this.bets);
    }
    set status(val: STATUS_TYPES) {
        this._status = val;

        emitNet(EVENTS['update-status'], -1, this.uid, this.status);

        /** Update cef status message on every player who sits at the table. */
        if (this.players.length > 0) {
            for (let i = 0; i < this.players.length; i++) {
                if (!PlayerController.exist(this.players[i].source)) continue;
                ViewController.statusMessage(this.players[i].source);
            }
        }
    }
    get status() {
        return this._status;
    }
    set time(val: number) {
        this._time = val;
        emitNet(EVENTS['update-time'], -1, this.uid, this.time);

        /** Update cef time on every player who sits at the table. */
        if (this.players.length > 0) {
            for (let i = 0; i < this.players.length; i++) {
                if (!PlayerController.exist(this.players[i].source)) continue;
                ViewController.timeLeft(this.players[i].source);
            }
        }
    }
    get time() {
        return this._time;
    }
}

(function init() {
    for (let i = 0; i < EDITABLE_CONFIG.TABLES.length; i++) {
        new RouletteServer(EDITABLE_CONFIG.TABLES[i], i);
    }
})();

onNet(EVENTS['sitdown'], (d: IChairData) => {
    let roul = RouletteControllerServer.get(d.tableuid);
    roul && roul.sitdown(source, d);
});
onNet(EVENTS['standup'], () => {
    let roul = RouletteControllerServer.getPlayerRoulette(source);
    roul && roul.standup(source);
});
onNet(EVENTS['bet'], (amount: number, betData: IBetData) => {
    let roul = RouletteControllerServer.getPlayerRoulette(source);
    roul && roul.bet(source, amount, betData);
});
onNet(EVENTS['request-update'], (uid: number) => {
    let roul = RouletteControllerServer.get(uid);
    roul && roul.requestUpdate(source);
});
onNet('playerDropped', () => {
    RouletteControllerServer.playerDropped(source);
});
