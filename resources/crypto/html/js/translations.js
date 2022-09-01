const LANGUAGE = 'en';

let translations = new Object;

translations['en'] = {
    "page_homepage": "Homepage",
    "crypto_header": "Aquiver Crypto",
    "page_my_account": "My account",
    "page_send_crypto": "Send Crypto",
    "send_crypto_header": "Send Crypto Payment",
    "your_wallethash": "Your wallet hash:",
    "target_wallethash": "Target wallet hash",
    "recent_payments": "Recent payments",
    "account_balance": "Account balance",
    "withdraw": "Withdraw",
    "deposit": "Deposit",
    "latest_transactions": "Latest transactions",
    "sell": "Sell",
    "buy": "Buy",
    "top_gainers": "Top Gainers",
    "top_volumes": "Top Volumes",
    "top_markets": "Top Markets"
}

translations['hu'] = {

}

function _U(a) {
    try {
        return translations[LANGUAGE][a] || 'UNKNOWN_TRANSLATION';
    }
    catch {
        return 'UNKNOWN_TRANSLATION';
    }
}