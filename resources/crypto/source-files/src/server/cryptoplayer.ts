import { Config, CryptoNames } from '../shared/editable-config';
import { CRYPTO_EVENTS } from '../shared/events';
import { MarketCapManager } from './marketcap-counter';
import { Database } from './mysql';
import { AquiverCrypto } from './server-crypto';
import { Methods } from './server-methods';

interface IPlayer {
    cryptobalance: number;
    cryptos: CryptoNames;
    walletHash: string;
}

export interface CryptoPaymentInterface {
    id?: number;
    fromWallet: string;
    toWallet: string;
    date: string;
    amount: number;
    crypto: CryptoNames;
}

export class CryptoPlayer {
    public cryptoOpened: boolean = false;
    public CRYPTOS = new Map<CryptoNames, number>();

    /** Proxy declared later. */
    PaymentsProxy: CryptoPaymentInterface[] = [];

    constructor(public source: number | string, private _data: IPlayer) {
        /** Parsing the script into Object. */
        this._data.cryptos = Methods.isValidJSON(this._data.cryptos as any) ? JSON.parse(this._data.cryptos as any) : {};

        for (const [crypto, amount] of Object.entries(this._data.cryptos)) {
            this.CRYPTOS.set(crypto as CryptoNames, Methods.toDecimal(amount));
        }

        if (!Database.connected) {
            let c = setInterval(() => {
                if (Database.connected) {
                    this.load();
                    if (c) {
                        clearInterval(c);
                        c = null;
                    }
                }
            }, 500);
        } else {
            this.load();
        }
    }
    private paymentProxyHandler(): ProxyHandler<CryptoPaymentInterface[]> {
        return {
            get: (target, key) => {
                const val = target[key];
                if (typeof val === 'function') {
                    if (['push', 'unshift'].includes(key as string)) {
                        return (...args: CryptoPaymentInterface[]) => {
                            /** Apply the push here */
                            val.apply(target, args);

                            const pushedData: CryptoPaymentInterface = args[0];

                            let Player = PlayerManager.getPlayerByWalletHash(pushedData.fromWallet);
                            if (Player && Player.cryptoOpened) Player.updatePlayer();

                            /** Do not overflow the array */
                            if (this.PaymentsProxy.length > Config.maximumPlayerTransactions) {
                                this.PaymentsProxy.shift();
                                this.clearPlayerTransactionCache();
                            }
                        };
                    }
                }
                return val;
            },
        };
    }
    private load() {
        Database.query(
            `SELECT * FROM crypto_player_transactions WHERE fromWallet = '${this.walletHash}' OR toWallet = '${this.walletHash}'`,
            (err, rows, fields) => {
                if (err) return console.error(err);

                if (!Array.isArray(rows)) return;

                this.PaymentsProxy = new Proxy(rows, this.paymentProxyHandler());
            }
        );
    }
    private clearPlayerTransactionCache() {
        Database.query(`SELECT COUNT(*) as total FROM crypto_player_transactions`, (err, rows, fields) => {
            if (err) return console.error(err);

            const total = rows[0].total;
            if (total > Config.maximumPlayerTransactions) {
                const diff = total - Config.maximumPlayerTransactions;
                if (diff < 1) return;
                Database.query(`DELETE FROM crypto_player_transactions WHERE fromWallet = '${this.walletHash}' LIMIT ${diff}`, (e) => {
                    if (e) console.error(e);
                });
            }
        });
    }
    Notification(message: string) {
        global.exports[GetCurrentResourceName()].avcrypto_notification(this.source, message);
    }
    get bank() {
        return global.exports[GetCurrentResourceName()].avcrypto_getBank(this.source);
    }
    set bank(amount: number) {
        global.exports[GetCurrentResourceName()].avcrypto_setBank(this.source, amount);
    }
    get cryptobalance() {
        return this._data.cryptobalance;
    }
    set cryptobalance(amount: number) {
        this._data.cryptobalance = Methods.toDecimal(amount);
        this.setCefVariable('cryptoBalance', this.cryptobalance);
        this.Save();
    }
    get walletHash() {
        return this._data.walletHash;
    }
    getCrypto(crypto: CryptoNames) {
        let v = 0;
        if (this.CRYPTOS.has(crypto)) v = this.CRYPTOS.get(crypto);
        return v;
    }
    addOrRemoveCrypto(crypto: CryptoNames, amount: number) {
        if (!this.CRYPTOS.has(crypto)) this.CRYPTOS.set(crypto, 0);

        const currentAmount = this.getCrypto(crypto);
        let newAmount = Methods.toDecimal(currentAmount + amount);
        if (newAmount < 0) newAmount = 0;

        this.CRYPTOS.set(crypto, newAmount);

        this.setCefVariable('ownedCryptos', Object.fromEntries(this.CRYPTOS));

        if (Math.sign(amount) === 1) {
            MarketCapManager.addOrRemoveCryptoAmount(crypto, +amount);
        } else if (Math.sign(amount) === -1) {
            MarketCapManager.addOrRemoveCryptoAmount(crypto, -Math.abs(amount));
        }
        this.Save();
    }
    updatePlayer() {
        const bankBalance = global.exports[GetCurrentResourceName()].avcrypto_getBank(this.source);
        if (typeof bankBalance === 'number') {
            this.setCefVariable('bankBalance', bankBalance);
        }

        this.setCefVariable('cryptoBalance', this.cryptobalance);
        this.setCefVariable('ownedCryptos', Object.fromEntries(this.CRYPTOS));
        this.setCefVariable('playerWalletHash', this.walletHash);
        this.setCefVariable('playerPayments', this.PaymentsProxy);
    }
    Save() {
        Database.query(
            `UPDATE cryptoplayers SET cryptobalance = ${this.cryptobalance}, cryptos = '${JSON.stringify(
                Object.fromEntries(this.CRYPTOS)
            )}' WHERE walletHash = '${this.walletHash}'`,
            (err) => {
                if (err) console.error(err);
            }
        );
    }
    setCefVariable(path: string, value: any) {
        emitNet(CRYPTO_EVENTS.set_cef, this.source, path, value);
    }
    exist() {
        return GetPlayerName(this.source as any) !== null;
    }
    TriggerClient(eventName: string, ...args: any[]) {
        TriggerClientEvent(eventName, this.source, ...args);
    }
}

export class PlayerManager {
    static Players: Record<number | string, CryptoPlayer> = {};

    static async playerJoining(source: number | string) {
        if (!Methods.PlayerExist(source)) return;
        const identifier = await Methods.getIdentifier(source);
        if (!identifier) return;

        Database.query(`SELECT * FROM cryptoplayers WHERE identifier = '${identifier}'`, (err, rows, fields) => {
            if (err) return console.error(err);
            const data = rows[0];

            if (data) {
                this.Players[source] = new CryptoPlayer(source, {
                    cryptobalance: data.cryptobalance,
                    cryptos: data.cryptos,
                    walletHash: data.walletHash,
                });
            } else {
                Database.query(
                    `INSERT INTO cryptoplayers SET walletHash = '${Methods.hash(identifier)}', cryptobalance = 0, identifier = '${identifier}'`,
                    (err, rows, fields) => {
                        if (err) return console.error(err);

                        /** Rerun this function again, after the mysql insert done. */
                        this.playerJoining(source);
                    }
                );
            }
        });
    }
    static playerDropped(source: number | string) {
        if (this.Players[source]) {
            delete this.Players[source];
        }
    }
    static get playersInArray() {
        return Object.values(this.Players);
    }
    static get playersWithOpenedCrypto() {
        return this.playersInArray.filter((a) => a.cryptoOpened);
    }
    static getPlayerWithSource(source: number | string) {
        const Player = this.Players[source];
        if (Player && Player.exist()) {
            return Player;
        }
    }
    static getPlayerByWalletHash(walletHash: string) {
        return this.playersInArray.find((a) => a.walletHash == walletHash);
    }
}

onNet('character:loaded', (char) => {
    PlayerManager.playerJoining(char.get("source"));
});
onNet('playerDropped', () => {
    PlayerManager.playerDropped(global.source);
});
onNet('onResourceStart', (resource: string) => {
    if (resource !== GetCurrentResourceName()) return;
    const players = getPlayers();
    players.forEach((src) => {
        PlayerManager.playerJoining(src);
    });
});
