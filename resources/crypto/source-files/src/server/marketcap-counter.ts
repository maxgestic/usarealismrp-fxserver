import { CryptoNames, RegisteredCryptos } from "../shared/editable-config";
import { PlayerManager } from "./cryptoplayer";
import { Database } from "./mysql";
import { AquiverCrypto } from "./server-crypto";
import { Methods } from "./server-methods";

export class MarketCapManager
{
    /** Holds up every amount of crypto that the player's has. */
    static CryptoAmounts = new Map<CryptoNames, number>();
    /** Cryptos with prices * cryptoamount */
    static MarketCaps = new Map<CryptoNames, number>();

    static load()
    {
        Database.query(`SELECT cryptos FROM cryptoplayers`, (err, rows, fields) =>
        {
            if (err) return console.error(err);
            if (!rows || !Array.isArray(rows)) return;

            rows.forEach((a, index) =>
            {
                if (!Methods.isValidJSON(a.cryptos)) return;

                a.cryptos = JSON.parse(a.cryptos);

                for (const crypto in a.cryptos)
                {
                    const amount = a.cryptos[crypto];
                    if (amount <= 0) return;

                    this.addOrRemoveCryptoAmount(crypto as CryptoNames, +amount);
                }
            });
        });
    }
    static getAllCryptoAmount(crypto: CryptoNames)
    {
        let v = 0;
        if (this.CryptoAmounts.has(crypto)) v = this.CryptoAmounts.get(crypto);
        return v;
    }
    /** Recalculate the marketcaps when the crypto price gets updated from the API. */
    static recalculateWithNewPrices(crypto: CryptoNames, withPrice?: number)
    {
        let price = withPrice;
        if (price === undefined) price = AquiverCrypto.getCryptoPrice(crypto);
        if (price === null) return;

        if(!this.MarketCaps.has(crypto)) this.MarketCaps.set(crypto, 0);

        const cryptoAmount = this.getAllCryptoAmount(crypto);
        if(cryptoAmount > 0) {
            this.MarketCaps.set(crypto, Methods.toDecimal(price * cryptoAmount))
        }
    }
    static addOrRemoveCryptoAmount(crypto: CryptoNames, cryptoAmount: number)
    {
        if (!this.CryptoAmounts.has(crypto)) this.CryptoAmounts.set(crypto, 0);

        let newValue = this.getAllCryptoAmount(crypto) + cryptoAmount;
        if (newValue < 0) newValue = 0;

        this.CryptoAmounts.set(crypto, newValue);

        /** Update crypto marketcap with price */
        if (!this.MarketCaps.has(crypto)) this.MarketCaps.set(crypto, 0);

        const cryptoPrice = AquiverCrypto.getCryptoPrice(crypto);
        if (cryptoPrice !== null)
        {
            this.MarketCaps.set(crypto, Methods.toDecimal(newValue * cryptoPrice));

            PlayerManager.playersWithOpenedCrypto.forEach(P =>
            {
                P.setCefVariable('marketCaps', this.MarketCapsObject);
            });
        }
    }
    static get MarketCapsObject()
    {
        return Object.fromEntries(this.MarketCaps);
    }
}