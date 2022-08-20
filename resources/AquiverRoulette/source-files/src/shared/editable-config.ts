import { Vector3 } from "./shared-config";
import { BetTypes, IRouletteData, STATUS_TYPES } from "./shared.roulette.interface";

/** Roulette start time. */
const START_TIME = 40;
/** Locale selector. */
const Locale = 'en';
/** Maximum log history to show in the cef, after the limit it will start to delete them. */
const MaximumLog = 100;
/** Enable or disable the Debug logs in the server/client console. */
const Debugger = true;
/** Enable or disable the default GTA V casino interior. */
const loadDefaultInterior = true;
/** Roulette number multipliers. */
const MULTIPLIERS: { [key in BetTypes | any]?: number } = {
    "RED": 2,
    "BLACK": 2,
    "ODD": 2,
    "EVEN": 2,
    "1to18": 2,
    "19to36": 2,
    "1st12": 3,
    "2nd12": 3,
    "3rd12": 3,
    "2to1-first": 3,
    "2to1-second": 3,
    "2to1-third": 3,
    "ZERO": 35,
    "DOUBLE-ZERO": 35,
    "SINGLE_NUMBERS": 35
}
/** Roulette status messages. */
const STATUS_MESSAGE: { [key in STATUS_TYPES]: string } = {
    "NOT_STARTED": "Waiting for the game to start.",
    "STARTED": "Game is started."
}
/** Translations, edit or add your locale here and do not forget to modify the **Locale** at the top of this. */
const TRANSLATIONS: { [language: string]: { [key: string]: string } } = {
    "en": {
        "chair-occupied": "This chair is occupied!",
        "not-enough-chips": "You do not have enough chips!",
        "more-then-maxbet": "You can not bet more chips because you would exceed the limit of the table!",
        "started-can-not-bet": "The game already started, you can not bet!",

        /** Formatteds */
        "min-bet-is": "Minimum bet is _%_ chips.",

        /** Cef (View, HTML) */
        "cef-owned-chips": "You have _%_ chips.",
        "cef-round-bets": "You betted _%_ chips in this round.",
        "cef-bet-input": "Currently placing pots with _%_ chips.",
        "cef-time-remain": "_%_ seconds.",
        "cef-log-placed-bet": "_%_ placed _%_ chips for _%_.",
        "cef-new-game-starting": "New game is starting...",
        'cef-game-ended': 'Game ended, the winner number was: _%_.'
    },
    "hu": {
        "chair-occupied": "Ez a hely foglalt!",
        "not-enough-chips": "Nincs elég chiped!",
        "more-then-maxbet": "Nem rakhatsz több tétet mert az asztal limiten túl lépnél!",
        "started-can-not-bet": "The game already started, you can not bet!",

        /** Formatteds */
        "min-bet-is": "Minimális tét _%_ chips.",

        /** Cef (View, HTML) */
        "cef-owned-chips": "You have _%_ chips.",
        "cef-round-bets": "You betted _%_ chips in this round.",
        "cef-bet-input": "Currently placing pots with _%_ chips.",
        "cef-time-remain": "_%_ seconds.",
        "cef-log-placed-bet": "_%_ placed _%_ chips for _%_.",
        "cef-new-game-starting": "New game is starting...",
        'cef-game-ended': 'Game ended, the winner number was: _%_'
    }
}
/** Roulette table positions, add yours here. */
const TABLES = <IRouletteData[]>[
    {
        pos: Vector3(1150.718505859375, 262.52783203125, -52.840850830078125),
        heading: -45.0,
        minbet: 25,
        maxbet: 3000
    },
    {
        pos: Vector3(1144.732421875, 268.14117431640625, -52.840850830078125),
        heading: 135.0,
        minbet: 25,
        maxbet: 3000
    },
    {
        pos: Vector3(1133.68115234375, 262.01678466796875, -52.03075408935547),
        heading: -156.0,
        minbet: 1000,
        maxbet: 6000
    },
    {
        pos: Vector3(1129.53955078125, 267.06097412109375, -52.03075408935547),
        heading: 26.0,
        minbet: 1000,
        maxbet: 6000
    }
]

export const EDITABLE_CONFIG = {
    MULTIPLIERS,
    STATUS_MESSAGE,
    TABLES,
    START_TIME,
    Locale,
    TRANSLATIONS,
    MaximumLog,
    Debugger,
    loadDefaultInterior
}