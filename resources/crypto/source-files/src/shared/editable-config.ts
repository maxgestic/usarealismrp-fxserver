export const Config = {
    updateInterval: 60000 * 10,
    maximumHistoryHold: 500,
    maximumTransactionHold: 500,
    maximumPlayerTransactions: 100,

    feeAmount: 2,
};

export const RegisteredCryptos = ['BTC', 'ETH', 'XMR', 'ALGO', 'QNT', 'LUNA', 'ADA', 'LTC', 'SOL', 'DOT', 'AVAX', 'XRP', 'ATOM', 'XLM'] as const;
export type CryptoNames = typeof RegisteredCryptos[number];