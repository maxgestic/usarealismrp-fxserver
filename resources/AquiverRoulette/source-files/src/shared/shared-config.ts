import { EDITABLE_CONFIG } from "./editable-config";
import { BetTypes, chair_types, IVector3 } from "./shared.roulette.interface";

export const CHAIRS = <chair_types[]>[
    "Chair_Base_01",
    "Chair_Base_02",
    "Chair_Base_03",
    "Chair_Base_04"
];
export const CHAIR_IDS = {
    "Chair_Base_01": 4,
    "Chair_Base_02": 3,
    "Chair_Base_03": 2,
    "Chair_Base_04": 1
}

/** Do not modify them, otherwise you will fuck them up. */
export const EVENTS = {
    'sitdown': 'aquiver-roulette-sitdown',
    'sitdown-callback': 'aquiver-roulette-sitdown-callback',
    'standup': 'aquiver-roulette-standup',
    'bet': 'aquiver-roulette-bet',
    'update-bets': 'aquiver-roulette-update-bets',
    'anim-bet': 'aquiver-roulette-anim-bet',
    'anim-loss': 'aquiver-roulette-anim-loss',
    'anim-win': 'aquiver-roulette-anim-win',
    'anim-impartial': 'aquiver-roulette-anim-impartial',
    'anim-idle': 'aquiver-roulette-anim-idle',
    'update-status': 'aquiver-roulette-update-status',
    'update-time': 'aquiver-roulette-update-time',
    'update-players-count': 'aquiver-roulette-update-players-count',
    'request-update': 'aquiver-roulette-request-update',
    'spin': 'aquiver-roulette-spin',
    'view-set-variable': 'aquiver-roulette-view-set-variable',
    'view-update-betinput': 'aquiver-roulette-view-update-betinput',
    'view-push-log': 'aquiver-roulette-push-log',
    'default-notif': 'aquiver-roulette-default-notif'
}

export function Delay(ms: number) {
    return new Promise(res => setTimeout(res, ms));
}

export function randomInt(min: number, max: number) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

export function randomFromArray(arr: any[]) {
    return arr[Math.floor(Math.random() * arr.length)];
}

export function Vector3(x: number, y: number, z: number) {
    return <IVector3>{ x, y, z }
}

export const NUMBERS: { [key in BetTypes]?: number[] } = {
    ['RED']: [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36],
    ['BLACK']: [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35],
    ['EVEN']: [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36],
    ['ODD']: [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35],
    ['1to18']: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
    ['19to36']: [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36],
    ['1st12']: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    ['2nd12']: [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24],
    ['3rd12']: [25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36],
    ['2to1-first']: [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34],
    ['2to1-second']: [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35],
    ['2to1-third']: [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36],
    ["ZERO"]: [37],
    ["DOUBLE-ZERO"]: [38]
}

export function sLogger(log: string) {
    if (EDITABLE_CONFIG.Debugger) console.debug(log);
}

export function winMultiply(amount: number, betId: any) {
    let multiplier = EDITABLE_CONFIG.MULTIPLIERS[betId];
    if (typeof multiplier !== "undefined") {
        return Math.floor(amount * multiplier);
    }
    else {
        /** Most likely number.. can not be anything else */
        return Math.floor(amount * EDITABLE_CONFIG.MULTIPLIERS['SINGLE_NUMBERS']);
    }
}

export function _U(t: string) {
    try {
        return EDITABLE_CONFIG.TRANSLATIONS[EDITABLE_CONFIG.Locale][t];
    }
    catch {
        return 'UNKNOWN_TRANSLATION';
    }
}

export function _(t: string, args: any[]) {
    try {
        let message = EDITABLE_CONFIG.TRANSLATIONS[EDITABLE_CONFIG.Locale][t];
        for (let i = 0; i < args.length; i++) {
            message = message.replace('_%_', args[i]);
        }
        return message;
    }
    catch {
        return 'UNKNOWN_TRANSLATION'
    }
}

/** First is the tickrate, second is the betId number. */
export const TICKRATE_NUMBERS = {
    1: 6,
    2: 21,
    3: 33,
    4: 16,
    5: 4,
    6: 23,
    7: 35,
    8: 14,
    9: 2,
    10: 'ZERO', // ZERO
    11: 28,
    12: 9,
    13: 26,
    14: 30,
    15: 11,
    16: 7,
    17: 20,
    18: 32,
    19: 17,
    20: 5,
    21: 22,
    22: 34,
    23: 15,
    24: 3,
    25: 24,
    26: 36,
    27: 13,
    28: 1,
    29: 'DOUBLE-ZERO', // DOUBLE-ZERO
    30: 27,
    31: 10,
    32: 25,
    33: 29,
    34: 12,
    35: 8,
    36: 19,
    37: 31,
    38: 18
}