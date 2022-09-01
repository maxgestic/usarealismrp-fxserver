Vue.config.productionTip = false;
Vue.config.devtools = false;

Vue.component('line-chart', {
    extends: VueChartJs.Line,
    props: {
        chartdata: {
            default: [],
            type: Array,
        },
    },
    watch: {
        chartdata: function (val) {
            this.rerender();
        }
    },
    methods: {
        rerender() {
            this.renderChart(
                {
                    labels: this.chartdata.map((a) => a.date),
                    datasets: [
                        {
                            label: 'Price',
                            borderColor: 'rgb(0, 255, 0)',
                            data: this.chartdata.map((a) => a.price),
                        },
                    ],
                },
                {
                    fill: true,
                    maintainAspectRatio: false,
                    legend: {
                        display: false,
                    },
                    elements: {
                        point: {
                            hoverRadius: 7,
                            hitRadius: 20,
                            radius: 3,
                        },
                    },
                    scales: {
                        xAxes: [
                            {
                                display: false,
                            },
                        ],
                    },
                }
            );
        }
    },
});

const cryptomarket = new Vue({
    el: '#cryptomarket',
    data: {
        opened: false,
        cryptos: [
            {
                asset_id: 'ALGO',
                name: 'Algorand',
                description: '',
                website: '',
                ethereum_contract_address: '',
                price: 0.9859151816748626,
                volume_24h: 65558324.300630786,
                change_1h: -2.433299350902827,
                change_24h: -3.614163614225707,
                change_7d: 3.422065740765443,
                total_supply: 0,
                circulating_supply: 0,
                max_supply: 0,
                market_cap: 0,
                fully_diluted_market_cap: 0,
                status: 'recent',
                created_at: '2021-09-21T01:27:16',
                updated_at: '2022-02-06T15:32:40.724681',
            },
            {
                asset_id: 'BTC',
                name: 'Bitcoin',
                description:
                    'Bitcoin uses peer-to-peer technology to operate with no central authority or banks; managing transactions and the issuing of bitcoins is carried out collectively by the network.\r\nBitcoin is open-source; its design is public, nobody owns or controls Bitcoin and everyone can take part. Through many of its unique properties, Bitcoin allows exciting uses that could not be covered by any previous payment system.',
                website: '',
                ethereum_contract_address: '',
                price: 41481.40418582851,
                volume_24h: 3157830080.508341,
                change_1h: -0.8220303678652098,
                change_24h: -0.7996891310012294,
                change_7d: 9.091757280377156,
                total_supply: 18950387,
                circulating_supply: 18950387,
                max_supply: 21000000,
                market_cap: 786088662624.8702,
                fully_diluted_market_cap: 871109487902.3988,
                status: 'recent',
                created_at: '2021-09-21T01:27:16',
                updated_at: '2022-02-06T15:32:42.304204',
            },
            {
                asset_id: 'ETH',
                name: 'Ethereum',
                description:
                    'Ethereum is a platform powered by blockchain technology that is best known for its native cryptocurrency, called Ether, or ETH, or simply Ethereum. The distributed nature of blockchain technology is what makes the Ethereum platform secure, and that security enables ETH to accrue value.\r\nThe Ethereum platform supports Ether in addition to a network of decentralized apps, otherwise known as dApps. Smart contracts, which originated on the Ethereum platform, are a central component of how the platform operates. Many decentralized finance (DeFi) and other applications use smart contracts in conjunction with blockchain technology.',
                website: '',
                ethereum_contract_address: '',
                price: 2991.095243701396,
                volume_24h: 2139452654.7279115,
                change_1h: -1.162437107749445,
                change_24h: -2.0380466263704986,
                change_7d: 14.247747878557796,
                total_supply: 119470061.999,
                circulating_supply: 119470061.999,
                max_supply: 0,
                market_cap: 357346334209.9198,
                fully_diluted_market_cap: 357346334209.9198,
                status: 'recent',
                created_at: '2021-09-21T01:53:50',
                updated_at: '2022-02-06T15:32:44.712388',
            },
        ],
        cryptoHistory: [],
        selected: null,
        page: 1,
        sorting: '-name',
        chart: null,
        form: {
            buy: '',
            sell: '',
            deposit: '',
            withdraw: '',
            send: '',
            target: '',
        },
        paymentSelected: null,
        targetWalletHash: null,
        playerWalletHash: null,
        bankBalance: 0,
        cryptoBalance: 0,
        ownedCryptos: {
            BTC: 0.25,
        },
        marketCaps: {},
        transactions: [],
        playerPayments: [],
        feeAmount: 0.98,
    },
    watch: {
        'page'() {
            this.selectEffekt();
        },
        'selected'(a) {
            a != null && (this.page = 2);
        },
        'opened'(state) {
            this.sendEvent('crypto_nui_opened', state);

            if(!state) {
                this.selected = null;
                this.page = 1;
            }
        },
        'form.buy': function (a) {
            var t = a;
            this.form.buy = t.indexOf('.') >= 0 ? t.substr(0, t.indexOf('.')) + t.substr(t.indexOf('.'), 4) : t;
        },
        'form.sell': function (a) {
            var t = a;
            this.form.sell = t.indexOf('.') >= 0 ? t.substr(0, t.indexOf('.')) + t.substr(t.indexOf('.'), 4) : t;
        },
        'form.send': function (a) {
            var t = a;
            this.form.send = t.indexOf('.') >= 0 ? t.substr(0, t.indexOf('.')) + t.substr(t.indexOf('.'), 4) : t;
        },
    },
    computed: {
        getPlayerPayments() {
            return this.playerPayments.reverse();
        },
        getChartData() {
            if (this.getSelected) {
                const filtered = this.cryptoHistory.filter((a) => a.crypto == this.getSelected.asset_id);
                return filtered;
            } else return [];
        },
        getCryptoTransactions() {
            if (this.getSelected) {
                return this.transactions.filter((a) => a.crypto == this.getSelected.asset_id).reverse();
            }
            return [];
        },
        getPlayerCryptoAmount() {
            if (this.paymentSelected) {
                return this.ownedCryptos[this.paymentSelected] || 0;
            }
        },
        PlayerOwnedCryptos() {
            const entries = Object.keys(this.ownedCryptos);
            let filtered = entries.map((key) => {
                if (this.ownedCryptos[key] > 0) {
                    return {
                        amount: this.ownedCryptos[key],
                        asset_id: key,
                    };
                }
            });
            filtered = filtered.filter((a) => a);
            return filtered;
        },
        getSelected() {
            return this.getCryptos[this.selected];
        },
        getCryptos() {
            const cryptosnotref = this.cryptos.slice();

            if (this.sorting == '-price') return cryptosnotref.sort((a, b) => b.price - a.price);
            else if (this.sorting == '+price') return cryptosnotref.sort((a, b) => a.price - b.price);
            else if (this.sorting == '-name')
                return cryptosnotref.sort(function (a, b) {
                    return a.name.localeCompare(b.name);
                });
            else if (this.sorting == '+name')
                return cryptosnotref.sort(function (a, b) {
                    return b.name.localeCompare(a.name);
                });
            else if (this.sorting == '-change') return cryptosnotref.sort((a, b) => b.change_7d - a.change_7d);
            else if (this.sorting == '+change') return cryptosnotref.sort((a, b) => a.change_7d - b.change_7d);
            else if (this.sorting == '-owned')
                return cryptosnotref.sort((a, b) => this.getPlayerOwnedCrypto(b.asset_id) - this.getPlayerOwnedCrypto(a.asset_id));
            else if (this.sorting == '+owned')
                return cryptosnotref.sort((a, b) => this.getPlayerOwnedCrypto(a.asset_id) - this.getPlayerOwnedCrypto(b.asset_id));
            else if (this.sorting == '-marketcap') return cryptosnotref.sort((a, b) => this.getMarketCap(b.asset_id) - this.getMarketCap(a.asset_id));
            else if (this.sorting == '+marketcap') return cryptosnotref.sort((a, b) => this.getMarketCap(a.asset_id) - this.getMarketCap(b.asset_id));

            return this.cryptos;
        },
        topGainers() {
            let cryptosnotref = this.cryptos.slice();
            let sorted = cryptosnotref.sort((a, b) => b.change_7d - a.change_7d);
            if (sorted.length > 3) sorted.length = 3;
            return sorted;
        },
        topVolumes() {
            let cryptosnotref = this.cryptos.slice();
            let sorted = cryptosnotref.sort((a, b) => b.price - a.price);
            if (sorted.length > 3) sorted.length = 3;
            return sorted;
        },
        topMarkets() {
            let cryptosnotref = this.cryptos.slice();
            let sorted = cryptosnotref.sort((a, b) => this.getMarketCap(b.asset_id) - this.getMarketCap(a.asset_id));
            if (sorted.length > 3) sorted.length = 3;
            return sorted;
        },
    },
    methods: {
        changeSelected(index) {
            this.selected = index;

            const selectedData = this.getSelected;
            if (selectedData) {
                this.sendEvent('get_crypto_history', {
                    crypto: selectedData.asset_id,
                });
            }
        },
        getMarketCap(asset_id) {
            return this.marketCaps[asset_id] || 0;
        },
        getPlayerOwnedCrypto(asset_id) {
            return this.ownedCryptos[asset_id] || 0;
        },
        isHash(str) {
            const regexExp = /^[a-f0-9]{64}$/gi;
            return regexExp.test(str);
        },
        sendCryptoToTarget() {
            this.sendEvent('crypto_send_crypto_target', {
                target: this.form.target,
                amount: this.form.send,
                crypto: this.paymentSelected,
            });
            this.selectEffekt();
        },
        searchWallet() {
            if (this.form.target.length > 0) {
                if (this.isHash(this.form.target)) {
                    console.log('HASH');
                    this.sendEvent('crypto_wallet_exist', this.form.target);
                } else {
                    console.log('NOTHASH');
                    this.sendEvent('crypto_search_targetwallet', parseInt(this.form.target));
                }
            } else {
                if (this.targetWalletHash != null) this.targetWalletHash = null;
            }
        },
        sendEvent(eventName, args = []) {
            $.post(`https://${GetParentResourceName()}/${eventName}`, JSON.stringify(args));
        },
        sellCrypto() {
            const asset_id = this.getSelected.asset_id;
            if (asset_id) {
                this.sendEvent('crypto_sell_crypto', {
                    crypto: asset_id,
                    amount: this.form.sell,
                });
                this.selectEffekt();
            }
        },
        buyCrypto() {
            const asset_id = this.getSelected.asset_id;
            if (asset_id) {
                this.sendEvent('crypto_buy_crypto', {
                    crypto: asset_id,
                    amount: this.form.buy,
                });
                this.selectEffekt();
            }
        },
        withdrawCrypto() {
            this.sendEvent('crypto_nui_withdraw', this.form.withdraw);
            this.selectEffekt();
        },
        depositCrypto() {
            this.sendEvent('crypto_nui_deposit', this.form.deposit);
            this.selectEffekt();
        },
        gotSortingIcon(where) {
            if (this.sorting == '-price' && where == 'price') return 'fas fa-chevron-up';
            else if (this.sorting == '+price' && where == 'price') return 'fas fa-chevron-down';
            else if (this.sorting == '-name' && where == 'name') return 'fas fa-chevron-up';
            else if (this.sorting == '+name' && where == 'name') return 'fas fa-chevron-down';
            else if (this.sorting == '-change' && where == 'change') return 'fas fa-chevron-up';
            else if (this.sorting == '+change' && where == 'change') return 'fas fa-chevron-down';
            else if (this.sorting == '-owned' && where == 'owned') return 'fas fa-chevron-up';
            else if (this.sorting == '+owned' && where == 'owned') return 'fas fa-chevron-down';
            else if (this.sorting == '-marketcap' && where == 'marketcap') return 'fas fa-chevron-up';
            else if (this.sorting == '+marketcap' && where == 'marketcap') return 'fas fa-chevron-down';
        },
        changeSort(where) {
            if (where == 'price') {
                if (this.sorting == '+price') this.sorting = '-price';
                else this.sorting = '+price';
            } else if (where == 'name') {
                if (this.sorting == '+name') this.sorting = '-name';
                else this.sorting = '+name';
            } else if (where == 'change') {
                if (this.sorting == '+change') this.sorting = '-change';
                else this.sorting = '+change';
            } else if (where == 'owned') {
                if (this.sorting == '+owned') this.sorting = '-owned';
                else this.sorting = '+owned';
            } else if (where == 'marketcap') {
                if (this.sorting == '+marketcap') this.sorting = '-marketcap';
                else this.sorting = '+marketcap';
            }
        },
        hoverEffekt() {
            this.PlaySound('SELECT', 'HUD_FREEMODE_SOUNDSET');
        },
        selectEffekt() {
            this.PlaySound('Apt_Style_Purchase', 'DLC_APT_Apartment_SoundSet');
        },
        PlaySound(soundName, soundSetName) {
            this.sendEvent('crypto_playsound', {
                soundName: soundName,
                soundSetName: soundSetName,
            });
        },
        formatMoney: function (n, c, d, t) {
            var c = isNaN((c = Math.abs(c))) ? 0 : c,
                d = d == undefined ? '.' : d,
                t = t == undefined ? ',' : t,
                s = n < 0 ? '-' : '',
                i = String(parseInt((n = Math.abs(Number(n) || 0).toFixed(c)))),
                j = (j = i.length) > 3 ? j % 3 : 0;
            return (
                s +
                (j ? i.substr(0, j) + t : '') +
                i.substr(j).replace(/(\d{3})(?=\d)/g, '$1' + t) +
                (c
                    ? d +
                      Math.abs(n - i)
                          .toFixed(c)
                          .slice(2)
                    : '')
            );
        },
    },
    template: '#cryptomarket',
});

window.addEventListener('keyup', function (event) {
    if (cryptomarket.opened && event.key == 'Escape') {
        cryptomarket.opened = false;
    }
});

window.addEventListener('message', (event) => {
    if (event.data.action == 'set_cef') {
        set(cryptomarket, event.data.path, event.data.value);
    } else if (event.data.action == 'add-transaction') {
        cryptomarket.transactions.push(event.data.value);
    }
});
