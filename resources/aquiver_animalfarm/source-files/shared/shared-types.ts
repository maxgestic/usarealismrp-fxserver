import { SharedConfig } from './shared-config';
import { Vec3 } from "@aquiversdk/shared";

export interface FarmDatabaseInterface {
    farmId?: number;
    ownerIdentifier: string;
    ownerName: string;
    price: number;
    x: number;
    y: number;
    z: number;
    img: string;
    name: string;
    locked: boolean;
    milk: number;
    egg: number;
    meal: number;
}

export interface PlayerSharedVariables { }

export interface ObjectSharedVariables {
    waterAmount: number;
    foodAmount: number;
    waterTip: boolean;
    waterTipActive: boolean;
    shitAmount: number;
    raycastName: string;
    constantName: string;
}

export interface ObjectDataInterface {
    id?: number;
    model: string;
    position: Vec3;
    dimension: number;
    collision?: boolean;
    alpha?: number;
    freezed?: boolean;
    rotation?: Vec3;
    variables?: Partial<ObjectSharedVariables>;
}

export interface EventTriggerInterface {
    data: any;
    event: string;
}

export interface BuyDataInterface {
    image?: string;
    texts: Array<{
        header: string;
        entries: Array<{ question: string; answer: string }>;
    }>;
    buttons: Array<{
        header: string;
        entries: Array<{ name: string; event: string; args: any }>;
    }>;
}

export interface ModalDataInterface {
    question: string;
    icon?: string;
    buttons: Array<{ name: string; event: string; args: any }>;
    inputs: Array<{ id: string; placeholder: string; value?: string }>;
}

export interface ModalDataButtonTriggerInterface {
    args: any;
    inputs: Array<{ id: string; placeholder: string; value: string }>;
}

export interface UpgradeInterface {
    id: string;
    name: string;
    cameraPosition: Vec3;
    cameraRotation: Vec3;
    cameraFov: number;
    upgrades: UpgradeEntryInterface[];
    animals: AnimalEntryInterface[];
    maximumAnimals: number;
}

export interface AnimalEntryInterface {
    animalType: AnimalTypes;
    name: string;
    price: number;
    img: string;
    description: string;
    buyEvent: string;
    buyEventArgs: any;
}

export type AnimalTypes = keyof typeof SharedConfig.Animals;

export interface UpgradeEntryInterface {
    upgradeStrid: string;
    img: string;
    name: string;
    price: number;
    description: string;
    has?: boolean;
    buyEvent: string;
    buyEventArgs: any;
    position: Vec3;
    rotation: Vec3;
    model: string;
}

export interface UpgradeData {
    model: string;
    farmId: number;
    paddockStrid: string;
    upgradeStrid: string;
    price: number;
    position: Vec3;
    rotation: Vec3;
}

export interface PedDataInterface {
    id?: number;
    position: Vec3;
    dimension: number;
    model: string;
    heading: number;
    dead: boolean;
    variables: Partial<PedSharedVariables>;
}

export interface PedSharedVariables { }

export interface RGBA {
    r: number;
    g: number;
    b: number;
    a: number;
}

export interface ParticleConstructorInterface {
    id?: number;
    dict: string;
    dimension: number;
    particleName: string;
    position: Vec3;
    rotation: Vec3;
    scale: number;
}

export interface AnimalMenuInfos {
    animalName: string;
    animalImg: string;
    bars: Array<{ name: string; percentage: number; color: string; img: string; }>;
    buttons: Array<{ name: string; img: string; event: string; eventArgs: any; closeAfterClick?: boolean; }>
}

export interface ClickMenuInterface {
    header: string;
    buttons: Array<{
        name: string;
        icon: string;
        event: string;
        eventArgs?: any;
        closeAfterClick?: boolean;
    }>;
}

export type DisableKeyTypes = 'all' | 'some';

export interface FarmCreatorListInterface {
    id: number;
    name: string;
    opened: boolean;
    ownerIdentifier: string;
    ownerName: string;
    price: number;
    locked: boolean;
    img: string;
}

export interface FarmCreateInfoInterface {
    name: string;
    url: string;
    price: number;
}