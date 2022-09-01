import { Config, CryptoNames, RegisteredCryptos } from '../shared/editable-config';
import { CRYPTO_EVENTS } from '../shared/events';
import cryptoApi from './crypto-api';
import { Database } from './mysql';
import { Methods } from './server-methods';
import { _U, _UFormat } from '../shared/translations';
import { CryptoPaymentInterface, CryptoPlayer, PlayerManager } from './cryptoplayer';
import { MarketCapManager } from './marketcap-counter';

export interface ICryptoApiResponse {
    asset_id: string;
    name: string;
    description: string;
    website: string;
    ethereum_contract_address: string;
    price: number;
    volume_24h: number;
    change_1h: number;
    change_24h: number;
    change_7d: number;
    total_supply: number;
    circulating_supply: number;
    max_supply: number;
    market_cap: number;
    fully_diluted_market_cap: number;
    status: string;
    created_at: Date;
    updated_at: Date;
}

onNet('crypto_nui_opened', (state: boolean) => {
    const Player = PlayerManager.getPlayerWithSource(global.source);
    Player && (Player.cryptoOpened = state);
});
onNet('crypto_deposit', (amount) => {
    const Player = PlayerManager.getPlayerWithSource(global.source);
    if (!Player) return;
    AquiverCrypto.player_deposit(Player, amount);
});
onNet('crypto_nui_withdraw', (amount) => {
    const Player = PlayerManager.getPlayerWithSource(global.source);
    if (!Player) return;
    AquiverCrypto.player_withdraw(Player, amount);
});
onNet('crypto_buy_crypto', (d) => {
    const Player = PlayerManager.getPlayerWithSource(global.source);
    if (!Player) return;
    AquiverCrypto.player_buyCrypto(Player, d.crypto, d.amount);
});
onNet('crypto_sell_crypto', (d) => {
    const Player = PlayerManager.getPlayerWithSource(global.source);
    if (!Player) return;
    AquiverCrypto.player_sellCrypto(Player, d.crypto, d.amount);
});
onNet('crypto_search_targetwallet', (targetId) => {
    const Player = PlayerManager.getPlayerWithSource(global.source);
    if (!Player) return;
    AquiverCrypto.searchTargetWallet(Player, targetId);
});
onNet('crypto_wallet_exist', (walletHash) => {
    const Player = PlayerManager.getPlayerWithSource(global.source);
    if (!Player) return;
    AquiverCrypto.WalletExist(Player, walletHash);
});
onNet('crypto_send_crypto_target', (d: { target: any | number; amount: any; crypto: any }) => {
    const { target, amount, crypto } = d;
    const Player = PlayerManager.getPlayerWithSource(global.source);
    if (!Player) return;
    AquiverCrypto.SendCryptoToTarget(Player, target, amount, crypto);
});
onNet('get_crypto_history', (d: { crypto: CryptoNames}) => {
    const { crypto } = d;
    const Player = PlayerManager.getPlayerWithSource(global.source);
    if(!Player) return;
    const history = AquiverCrypto.HistoryProxy.filter(a => a.crypto == crypto);
    Player.setCefVariable('cryptoHistory', history);
});

interface ITransactions {
    id?: number;
    walletHash: string;
    date: string;
    type: string;
    crypto: string;
    amount: number;
    price: number;
}

interface IHistory {
    id?: number;
    date: string;
    crypto: string;
    price: number;
}

export const AquiverCrypto = new (class _ {
    Cryptos: ICryptoApiResponse[] = [];

    /** Proxy declared later. */
    HistoryProxy: IHistory[] = [];
    /** Proxy declared later. */
    TransactionsProxy: ITransactions[] = [];

    constructor() {
        setInterval(() => {
            this.updateCryptoPrices().then(() => {
                PlayerManager.playersWithOpenedCrypto.forEach((P) => {
                    P.setCefVariable('cryptoHistory', this.HistoryProxy);
                    P.setCefVariable('cryptos', this.Cryptos);
                });
            });
        }, Config.updateInterval);
    }
    private historyProxyHandler(): ProxyHandler<IHistory[]> {
        return {
            get: (target, key) => {
                let val = target[key];
                if (typeof val === 'function') {
                    if (['push', 'unshift'].includes(key as string)) {
                        return (...args: IHistory[]) => {
                            /** Apply the push here */
                            val.apply(target, args);

                            const pushedData: IHistory = args[0];

                            Database.query(
                                `INSERT INTO cryptohistory SET date = '${pushedData.date}', 
                                crypto = '${pushedData.crypto}', 
                                price = ${pushedData.price} ON DUPLICATE KEY UPDATE price = ${pushedData.price}`
                            );

                            /** Do not overflow the array */
                            if (this.HistoryProxy.length > Config.maximumHistoryHold) {
                                this.HistoryProxy.shift();
                                this.clearHistoryCache();
                            }
                        };
                    }
                }
                return (typeof val === 'function') ? val.bind(target) : val;
            },
        };
    }
    private transactionProxyHandler(): ProxyHandler<ITransactions[]> {
        return {
            get: (target, key) => {
                const val: Function = target[key];
                if (typeof val === 'function') {
                    if (['push', 'unshift'].includes(key as string)) {
                        return (...args: ITransactions[]) => {
                            /** Apply the push here */
                            val.apply(target, args);

                            const pushedData: ITransactions = args[0];

                            if (pushedData) {
                                Database.query(
                                    `INSERT INTO crypto_transactions SET 
                            walletHash = '${pushedData.walletHash}',
                            date = '${Methods.stringCryptoDate()}',
                            type = '${pushedData.type}',
                            crypto = '${pushedData.crypto}',
                            amount = ${pushedData.amount},
                            price = ${pushedData.price}
                            `
                                );

                                PlayerManager.playersWithOpenedCrypto.forEach((P) => {
                                    P.TriggerClient('crypto-add-transaction', pushedData);
                                });
                            }

                            /** Do not overflow the array */
                            if (this.TransactionsProxy.length > Config.maximumTransactionHold) {
                                this.TransactionsProxy.shift();
                                this.clearTransactionsCache();
                            }
                        };
                    }
                    return val.bind(target);
                }
                return val;
            },
        };
    }
    async __init__() {
        try {
            this.clearCache();
            console.info('[AQUIVER_CRYPTO - STARTED LOADING..]');
            console.time('[AQUIVER_CRYPTO - LOADED]');
            this.loadCryptoHistorical();
            this.loadCryptoTransactions();
            await this.updateCryptoPrices();
            console.timeEnd('[AQUIVER_CRYPTO - LOADED]');
            MarketCapManager.load();
        } catch (err) {
            console.error(err);
        }
    }
    SendCryptoToTarget(Player: CryptoPlayer, Target: string | CryptoPlayer, amount: any, crypto: CryptoNames) {
        if (Player.getCrypto(crypto) < amount) return Player.Notification(_U('not_enough_crypto'));

        amount = Methods.toDecimal(amount, 3);

        if (amount > 0 && typeof amount == 'number') {
            if (Methods.isHash(Target as string)) {
                const hash = Target as string;

                if (hash == Player.walletHash) return Player.Notification(_U('action_self'));

                /** If target player is online with wallet hash return the script and send the crypto. */
                const targetPlayer = PlayerManager.getPlayerByWalletHash(hash);
                if (targetPlayer) {
                    this.SendCryptoToTarget(Player, targetPlayer, amount, crypto);
                    return;
                }

                /** If target player is offline search in the database and send the crypto. */
                Database.query(`SELECT * FROM cryptoplayers WHERE walletHash = '${hash}'`, (err, rows, fields) => {
                    if (err) return console.error(err);

                    try {
                        if (!rows || !rows[0]) return Player.Notification(_U('wallet_not_exist'));

                        const data = rows[0];

                        if (Player.getCrypto(crypto) < amount) return Player.Notification(_U('not_enough_crypto'));

                        let mysqlCryptos = Methods.isValidJSON(data.cryptos) ? JSON.parse(data.cryptos) : {};
                        if (typeof mysqlCryptos[crypto] === 'undefined') mysqlCryptos[crypto] = 0;
                        mysqlCryptos[crypto] += amount;
                        mysqlCryptos[crypto] = Methods.toDecimal(mysqlCryptos[crypto], 3);
                        Database.query(`UPDATE cryptoplayers SET cryptos = '${JSON.stringify(mysqlCryptos)}' WHERE walletHash = '${hash}'`);
                        Player.addOrRemoveCrypto(crypto, -amount);
                        Player.Notification(_UFormat('crypto_payment_sent', amount, crypto));

                        Player.PaymentsProxy.push({
                            fromWallet: Player.walletHash,
                            toWallet: rows[0].walletHash,
                            date: Methods.stringCryptoDate(),
                            amount,
                            crypto,
                        });

                        Database.query(`INSERT INTO crypto_player_transactions SET 
                            fromWallet = '${Player.walletHash}',
                            toWallet = '${rows[0].walletHash}',
                            date = '${Methods.stringCryptoDate()}',
                            amount = ${amount},
                            crypto = '${crypto}'
                        `);
                    } catch (err) {
                        console.error(err);
                    }
                });
            } else {
                /** If it was sent with CryptoPlayer class */
                if (Target instanceof CryptoPlayer) {
                    if (Target == Player) return Player.Notification(_U('action_self'));

                    Player.addOrRemoveCrypto(crypto, -amount);
                    Target.addOrRemoveCrypto(crypto, +amount);
                    Player.Notification(_UFormat('crypto_payment_sent', amount, crypto));

                    let obj: CryptoPaymentInterface = {
                        fromWallet: Player.walletHash,
                        toWallet: Target.walletHash,
                        date: Methods.stringCryptoDate(),
                        amount,
                        crypto,
                    }

                    Player.PaymentsProxy.push(obj);
                    Target.PaymentsProxy.push(obj);

                    Database.query(`INSERT INTO crypto_player_transactions SET 
                        fromWallet = '${Player.walletHash}',
                        toWallet = '${Target.walletHash}',
                        date = '${Methods.stringCryptoDate()}',
                        amount = ${amount},
                        crypto = '${crypto}'
                    `);
                } else {
                    /** If it is a simple source ID. */
                    const targetId = parseInt(Target as string);
                    const T = PlayerManager.getPlayerWithSource(targetId);
                    if (!T) return Player.Notification(_U('target_not_exist'));

                    this.SendCryptoToTarget(Player, T, amount, crypto);
                }
            }
        }
    }
    WalletExist(Player: CryptoPlayer, walletHash: string) {
        Database.query(`SELECT COUNT(*) as total FROM cryptoplayers WHERE walletHash = '${walletHash}'`, (err, rows, fields) => {
            if (err) return console.error(err);

            try {
                let total = 0;
                if (rows && rows[0]) total = rows[0].total;

                Player.setCefVariable('targetWalletHash', total > 0 ? walletHash : 'Crypto wallet hash does not exist.');
            } catch (err) {
                console.error(err);
            }
        });
    }
    searchTargetWallet(Player: CryptoPlayer, targetId: any) {
        const Target = PlayerManager.getPlayerWithSource(targetId);
        if (!Target) {
            Player.Notification(_U('target_not_exist'));
            Player.setCefVariable('targetWalletHash', null);
            return;
        }
        Player.setCefVariable('targetWalletHash', Target.walletHash);
    }
    player_openCrypto(Player: CryptoPlayer) {
        Player.updatePlayer();

        Player.setCefVariable('marketCaps', MarketCapManager.MarketCapsObject);
        // Player.setCefVariable('cryptoHistory', this.HistoryProxy);
        Player.setCefVariable('transactions', this.TransactionsProxy);

        Player.setCefVariable('cryptos', this.Cryptos);
        Player.setCefVariable('feeAmount', Config.feeAmount);
        Player.setCefVariable('opened', true);
    }
    player_buyCrypto(Player: CryptoPlayer, crypto: CryptoNames, amount: any) {
        amount = Methods.toDecimal(amount, 3);

        if (amount > 0 && typeof amount === 'number') {
            const selectedCryptoData = this.Cryptos.find((a) => a.asset_id == crypto);
            if (!selectedCryptoData) return Player.Notification(_U('error_unknown_crypto'));

            const finalPrice = Methods.toDecimal(selectedCryptoData.price * amount, 3);
            if (finalPrice < 1) return Player.Notification(_U('bad_input'));

            if (Player.cryptobalance < finalPrice) return Player.Notification(_U('not_enough_cryptobalance'));

            Player.cryptobalance -= finalPrice;
            Player.addOrRemoveCrypto(crypto, +amount);

            Player.Notification(_UFormat('crypto_bought_success', amount, selectedCryptoData.name, finalPrice));
            this.createCryptoTransactionHistory(Player, 'BUY', crypto, amount, finalPrice);
        }
    }
    player_sellCrypto(Player: CryptoPlayer, crypto: CryptoNames, amount: number) {
        amount = Methods.toDecimal(amount, 3);

        if (amount > 0 && typeof amount === 'number') {
            const selectedCryptoData = this.Cryptos.find((a) => a.asset_id == crypto);
            if (selectedCryptoData) {
                const fee = (100 - Config.feeAmount) / 100;
                const finalPrice = Methods.toDecimal(selectedCryptoData.price * amount * fee, 3);
                if (finalPrice < 1) return Player.Notification(_U('bad_input'));

                if (Player.getCrypto(crypto) < amount) return Player.Notification(_UFormat('dont_have_much_crypto', selectedCryptoData.name));

                Player.cryptobalance += finalPrice;
                Player.addOrRemoveCrypto(crypto, -amount);
                Player.Notification(_UFormat('crypto_sold_success', amount, selectedCryptoData.name, finalPrice));

                this.createCryptoTransactionHistory(Player, 'SELL', crypto, amount, finalPrice);
            }
        }
    }
    player_withdraw(Player: CryptoPlayer, amount: any) {
        amount = Math.floor(amount);
        if (isNaN(amount) || amount < 1 || !amount) return Player.Notification(_U('bad_input'));

        if (Player.cryptobalance < amount) return Player.Notification(_U('not_enough_cryptobalance'));

        Player.bank += amount;
        Player.cryptobalance -= amount;
    }
    player_deposit(Player: CryptoPlayer, amount: any) {
        amount = Math.floor(amount);
        if (isNaN(amount) || amount < 1 || !amount) return;

        if (Player.bank < amount) return Player.Notification(_U('not_enough_bank'));

        Player.bank -= amount;
        Player.cryptobalance += amount;
    }
    private async createCryptoTransactionHistory(Player: CryptoPlayer, type: string, crypto: string, amount: number, price: number) {
        this.TransactionsProxy.push({
            amount,
            price,
            crypto,
            type,
            date: Methods.stringCryptoDate(),
            walletHash: Player.walletHash,
        });
    }
    private addCryptoHistory(date: string, crypto: string, price: number) {
        this.HistoryProxy.push({
            crypto,
            price,
            date,
        });
    }
    getCryptoPrice(crypto: CryptoNames) {
        let price = null;
        let f = this.Cryptos.find((a) => a.asset_id == crypto);
        if (f) price = f.price;
        return price;
    }
    private loadCryptoTransactions() {
        Database.query(`SELECT * FROM crypto_transactions`, (err, rows, fields) => {
            if (err) return console.error(err);

            if (!Array.isArray(rows)) return;
            if (rows.length > Config.maximumTransactionHold) rows.length = Config.maximumTransactionHold;

            this.TransactionsProxy = new Proxy(rows, this.transactionProxyHandler());
        });
    }
    private loadCryptoHistorical() {
        Database.query(`SELECT * FROM cryptohistory ORDER BY id ASC`, (err, rows, fields) => {
            if (err) return console.error(err);

            if (!Array.isArray(rows)) return;
            if (rows.length > Config.maximumHistoryHold) rows.length = Config.maximumHistoryHold;

            this.HistoryProxy = new Proxy(rows, this.historyProxyHandler());
        });
    }
    private clearHistoryCache() {
        Database.query(`SELECT COUNT(*) as total FROM cryptohistory`, (err, rows, fields) => {
            if (err) return console.error(err);

            const total = rows[0].total;
            if (total > Config.maximumHistoryHold) {
                const diff = total - Config.maximumHistoryHold;
                if (diff < 1) return;
                Database.query(`DELETE FROM cryptohistory LIMIT ${diff}`, (e) => {
                    if (e) console.error(e);
                });
            }
        });
    }
    private clearTransactionsCache() {
        Database.query(`SELECT COUNT(*) as total FROM crypto_transactions`, (err, rows, fields) => {
            if (err) return console.error(err);

            const total = rows[0].total;
            if (total > Config.maximumTransactionHold) {
                const diff = total - Config.maximumTransactionHold;
                if (diff < 1) return;
                Database.query(`DELETE FROM crypto_transactions LIMIT ${diff}`, (e) => {
                    if (e) console.error(e);
                });
            }
        });
    }
    /** Deleting the mysql tables if it overflowed the maximum config amount. */
    private clearCache() {
        this.clearHistoryCache();
        this.clearTransactionsCache();
    }
    private updateCryptoPrices() {
        return new Promise((resolve) => {
            this.Cryptos = [];

            const length = RegisteredCryptos.length - 1;
            const date = Methods.stringCryptoDate();

            RegisteredCryptos.forEach(async (crypto, index) => {
                await Methods.Wait(500 * index);

                cryptoApi
                    .getPrice(crypto)
                    .then((response) => {
                        response.price = Methods.toDecimal(response.price);
                        this.Cryptos.push(response);

                        MarketCapManager.recalculateWithNewPrices(crypto, response.price);

                        this.addCryptoHistory(date, crypto, response.price);
                    })
                    .catch((err) => {
                        console.error(`Crypto could not be loaded. [${crypto}]`);
                    })
                    .finally(() => {
                        if (length == index) resolve(true);
                    });
            });
        });
    }
})();
