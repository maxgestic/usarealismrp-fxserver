import { PlayerManager } from "./cryptoplayer";
import { AquiverCrypto } from "./server-crypto";

global.exports('avcrypto_getPlayerWalletHash', (source) =>
{
    try { return PlayerManager.getPlayerWithSource(source).walletHash; }
    catch { }
});
global.exports('avcrypto_getCryptoBalance', (source) =>
{
    try { return PlayerManager.getPlayerWithSource(source).cryptobalance; }
    catch { }
});
global.exports('avcrypto_getCryptoAmount', (source, crypto) =>
{
    let amount = 0;
    try { amount = PlayerManager.getPlayerWithSource(source).getCrypto(crypto); }
    catch { }
    return amount;
});
global.exports('avcrypto_getAllCrypto', (source) =>
{
    try { return Object.fromEntries(PlayerManager.getPlayerWithSource(source).CRYPTOS); }
    catch { }
});
global.exports('avcrypto_open', (source) =>
{
    try
    {
        const Player = PlayerManager.getPlayerWithSource(source);
        AquiverCrypto.player_openCrypto(Player);
    }
    catch { }
});

/** You can delete this command, and add the export function up above to another resource of yours to open the crypto. */
RegisterCommand('crypto', (source) => {
    global.exports[GetCurrentResourceName()].avcrypto_open(source);
}, false);