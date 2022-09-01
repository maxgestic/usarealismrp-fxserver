import { createHash } from 'crypto';

export const Methods = new (class _ {
    hash(str: string) {
        return createHash('sha256').update(str).digest('hex');
    }
    isValidJSON(value: string) {
        try {
            if (value) {
                JSON.parse(value);
                return true;
            } else return false;
        } catch (error) {
            return false;
        }
    }
    isHash(str: string) {
        const regexExp = /^[a-f0-9]{64}$/gi;
        return regexExp.test(str);
    }
    getIdentifier(source: any) {
        if (!this.PlayerExist(source)) return;
        const identifiers = GetNumPlayerIdentifiers(source);

        for (let i = 0; i < identifiers; i++) {
            const id = GetPlayerIdentifier(source, i);
            if (id.includes('license:')) {
                return id;
            }
        }
    }
    PlayerExist(source: any) {
        if (!source) return false;
        return GetPlayerName(source) ? true : false;
    }
    generateDate() {
        const date = new Date();
        let year = date.getFullYear(),
            month: number | string = date.getMonth() + 1,
            day: number | string = date.getDate(),
            hours = date.getHours(),
            minutes: number | string = date.getMinutes();

        if (month.toString().length < 2) {
            month = ('0' + month).toString();
        }
        if (day.toString().length < 2) {
            day = ('0' + day).toString();
        }
        if (minutes < 10) {
            minutes = ('0' + minutes).toString();
        }

        return `${year}-${month}-${day} ${hours}:${minutes}`;
    }
    Wait(ms: number): Promise<void> {
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve();
            }, ms);
        });
    }
    toDecimal(value: any, decimal: number = 3) {
        return parseFloat(parseFloat(value).toFixed(decimal));
    }
    stringCryptoDate() {
        const date = new Date();
        let year = date.getFullYear(),
            month = date.getMonth() + 1,
            day = date.getDate(),
            hours = date.getHours(),
            minutes = date.getMinutes();

        // @ts-ignore
        if (month.length < 2) {
            // @ts-ignore
            month = '0' + month;
        }
        // @ts-ignore
        if (day.length < 2) {
            // @ts-ignore
            day = '0' + day;
        }
        // @ts-ignore
        if (minutes < 10) {
            // @ts-ignore
            minutes = '0' + minutes;
        }

        const str = `${year}-${month}-${day} ${hours}:${minutes}`;
        return str;
    }
})();
