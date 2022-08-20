export interface IVector3 {
    x: number;
    y: number;
    z: number;
}

export interface IRouletteData {
    pos: IVector3;
    heading: number;
    minbet: number;
    maxbet: number;
}

export interface IRouletteBets {
    source: number;
    betId: number | BetTypes;
    amount: number;
}

export type chair_types = 'Chair_Base_01' | 'Chair_Base_02' | 'Chair_Base_03' | 'Chair_Base_04'
export type STATUS_TYPES = 'NOT_STARTED' | 'STARTED'

export interface IChairData {
    position: IVector3;
    rotation: IVector3;
    chairName: chair_types;
    tableuid: number;
}

export type BetTypes = 'ZERO' | 'DOUBLE-ZERO' | 'RED' | 'BLACK' | 'EVEN' | 'ODD' | '1to18' | '19to36' | '1st12' | '2nd12' | '3rd12' |
    '2to1-first' | '2to1-second' | '2to1-third'

export interface IBetData {
    betId: number | BetTypes;
    hoverpos: number[];
    hovernumbers: number[];
    hovermodel: string;
}