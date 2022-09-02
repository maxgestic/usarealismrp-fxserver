import { Vec3 } from "@aquiversdk/shared";

export enum AttachmentNames {
    'shovel' = 'shovel',
    'shovelWithShit' = 'shovelWithShit',
    'foodBag' = 'foodBag',
    'bucketEmpty' = 'bucketEmpty',
    'bucketWithWater' = 'bucketWithWater',
    'bucketWithMilk' = 'bucketWithMilk'
}

interface AttachmentInterface {
    model: string;
    bone: number;
    pos: Vec3;
    rot: Vec3;
}

export const SharedAttachments: Record<AttachmentNames, AttachmentInterface> = {
    bucketEmpty: {
        model: 'avp_farm_bucket_01',
        bone: 57005,
        pos: new Vec3(0.65, -0.1, 0.0),
        rot: new Vec3(208.0, -85.0, -7.0),
    },
    bucketWithWater: {
        model: 'avp_farm_bucket_newwater', // // avp_farm_bucket_02 is the gta V type of water. (only works with high graphics, we made another model for static water inside the bucketto.)
        bone: 57005,
        pos: new Vec3(0.65, -0.1, 0.0),
        rot: new Vec3(208.0, -85.0, -7.0)
    },
    bucketWithMilk: {
        model: 'avp_farm_bucket_03',
        bone: 57005,
        pos: new Vec3(0.65, -0.1, 0.0),
        rot: new Vec3(208.0, -85.0, -7.0)
    },
    shovelWithShit: {
        model: 'avp_farm_shovel_shit',
        bone: 18905,
        pos: new Vec3(0.1, 0, 0),
        rot: new Vec3(0, 81, -95),
    },
    shovel: {
        model: 'avp_farm_shovel',
        bone: 18905,
        pos: new Vec3(0.1, 0, 0),
        rot: new Vec3(0, 81, -95),
    },
    foodBag: {
        model: 'avp_farm_animal_feed_02',
        bone: 57005,
        pos: new Vec3(0.62, 0, -0.035),
        rot: new Vec3(0, -90, 0)
    }
};