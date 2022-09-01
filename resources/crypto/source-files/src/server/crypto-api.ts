import axios from 'axios';
import { ICryptoApiResponse } from './server-crypto';

export default new (class CryptoApi {
    async getPrice(crypto: string): Promise<ICryptoApiResponse> {
        return new Promise(async (resolve, reject) => {
            axios
                .get('https://www.cryptingup.com/api/assets/' + crypto)
                .then((res) => {
                    if (res.status == 200) {
                        const data = res.data;
                        if (!data) return reject();

                        resolve(data.asset);
                    }
                })
                .catch((err) => {
                    reject(err);
                });
        });
    }
})();
