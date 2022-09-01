const LANGUAGE = 'en';

let translations = {};

translations['en'] = {
    not_enough_bank: 'You do not have enough balance on your bank account!',
    not_enough_cryptobalance: 'You do not have enough balance on your crypto account!',
    bad_input: 'Bad input value!',
    error_unknown_crypto: 'Something happened, crypto is not exist?',
    config_fee_error: 'ERROR IN THE CONFIG! BAD CRYPTO FEE SETUP!',
    target_not_exist: 'Target does not exist!',
    wallet_not_exist: 'Wallet hash is not exist!',
    not_enough_crypto: 'You do not have that much crypto!',
    action_self: 'Why would you send crypto to yourself?',

    // FORMATTED
    crypto_bought_success: 'You successfully bought {REPLACE} {REPLACE} - ${REPLACE}!',
    dont_have_much_crypto: 'You do not have that much {REPLACE}!',
    crypto_sold_success: 'You sold {REPLACE} {REPLACE} for ${REPLACE}!',
    crypto_payment_sent: 'You successfully sent {REPLACE} {REPLACE}!',
};

translations['hu'] = {};

export function _U(a: string) {
    try {
        return translations[LANGUAGE][a] || 'UNKNOWN_TRANSLATION';
    } catch {
        return 'UNKNOWN_TRANSLATION';
    }
}

export function _UFormat(a: string, ...args: any[]) {
    try {
        let tr = translations[LANGUAGE][a];
        args.forEach((text) => {
            tr = tr.replace('{REPLACE}', text);
        });
        return tr;
    } catch {
        return 'UNKNOWN_TRANSLATION';
    }
}
