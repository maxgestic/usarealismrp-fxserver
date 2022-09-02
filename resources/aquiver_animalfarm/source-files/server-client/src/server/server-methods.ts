/** Async waiter for loops or any other await. */
export function Wait(ms: number): Promise<void> {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve();
        }, ms);
    });
}

/** Checks if cfx user exist or not. (source) */
export function cfxPlayerExist(source: string | number) {
    return GetPlayerName(source as string) ? true : false;
}

/** Checks if string is valid JSON or not. */
export function isValidJSON(value: string) {
    try {
        if (value) {
            JSON.parse(value);
            return true;
        } else return false;
    } catch (error) {
        return false;
    }
}

export function randomIndexFromArray(array: any[]) {
    return Math.floor(Math.random() * array.length);
}