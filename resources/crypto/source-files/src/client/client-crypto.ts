import { CRYPTO_EVENTS } from '../shared/events';

onNet(CRYPTO_EVENTS.set_cef, (path, value) => {
    SendNUIMessage({
        action: CRYPTO_EVENTS.set_cef,
        path: path,
        value: value,
    });
});

onNet('crypto-add-transaction', (val) => {
    SendNUIMessage({
        action: 'add-transaction',
        value: val
    })
});

RegisterNuiCallbackType('crypto_nui_opened');
RegisterNuiCallbackType('crypto_nui_deposit');
RegisterNuiCallbackType('crypto_nui_withdraw');
RegisterNuiCallbackType('crypto_buy_crypto');
RegisterNuiCallbackType('crypto_sell_crypto');
RegisterNuiCallbackType('crypto_search_targetwallet');
RegisterNuiCallbackType('crypto_wallet_exist');
RegisterNuiCallbackType('crypto_send_crypto_target');
RegisterNuiCallbackType('crypto_playsound');
RegisterNuiCallbackType('get_crypto_history');

on('__cfx_nui:crypto_nui_opened', (state, cb) => {
    SetNuiFocus(state, state);
    emitNet('crypto_nui_opened', state);
});
on('__cfx_nui:crypto_nui_deposit', (amount, cb) => {
    emitNet('crypto_deposit', amount);
});
on('__cfx_nui:crypto_nui_withdraw', (amount, cb) => {
    emitNet('crypto_nui_withdraw', amount);
});
on('__cfx_nui:crypto_buy_crypto', (d, cb) => {
    emitNet('crypto_buy_crypto', d);
});
on('__cfx_nui:crypto_sell_crypto', (d, cb) => {
    emitNet('crypto_sell_crypto', d);
});
on('__cfx_nui:crypto_search_targetwallet', (targetId, cb) => {
    emitNet('crypto_search_targetwallet', targetId);
});
on('__cfx_nui:crypto_wallet_exist', (walletHash, cb) => {
    emitNet('crypto_wallet_exist', walletHash);
});
on('__cfx_nui:crypto_send_crypto_target', (d, cb) => {
    emitNet('crypto_send_crypto_target', d);
});
on('__cfx_nui:crypto_playsound', (d, cb) => {
    PlaySoundFrontend(-1, d.soundName, d.soundSetName, true);
});
on('__cfx_nui:get_crypto_history', (d, cb) => {
    emitNet('get_crypto_history', d);
});