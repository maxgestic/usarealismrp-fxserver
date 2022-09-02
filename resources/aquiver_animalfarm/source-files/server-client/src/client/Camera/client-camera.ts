import { Vec3 } from "@aquiversdk/shared";

export const Camera = new class {
    cam: number;

    constructor() {
        this.cam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', 0, 0, 0, 0, 0, 0, 40, false, 2);

        on('set-cam-fov', (f: number) => (this.fov = f));
        on('set-cam-rot', (r: Vec3) => (this.rotation = r));
        on('set-cam-pos', (p: Vec3) => (this.position = p));
        on('cam-render', (data: { state: boolean; ease: number }) => this.render(data.state, data.ease));
    }
    render(state: boolean, ease: number) {
        SetCamAffectsAiming(this.cam, !state);
        SetCamActive(this.cam, state);
        RenderScriptCams(state, true, ease, true, true);
    }
    set fov(f: number) {
        if (DoesCamExist(this.cam)) {
            SetCamFov(this.cam, f);
        }
    }
    get fov() {
        if (DoesCamExist(this.cam)) {
            return GetCamFov(this.cam);
        } else return 0;
    }
    set rotation(rot: Vec3) {
        if (DoesCamExist(this.cam)) {
            SetCamRot(this.cam, rot.x, rot.y, rot.z, 2);
        }
    }
    get rotation() {
        if (DoesCamExist(this.cam)) {
            const p = GetCamRot(this.cam, 2);
            return new Vec3(p[0], p[1], p[2]);
        } else return new Vec3(0, 0, 0);
    }
    set position(pos: Vec3) {
        if (DoesCamExist(this.cam)) {
            SetCamCoord(this.cam, pos.x, pos.y, pos.z);
        }
    }
    get position() {
        if (DoesCamExist(this.cam)) {
            const p = GetCamCoord(this.cam);
            return new Vec3(p[0], p[1], p[2]);
        } else return new Vec3(0, 0, 0);
    }
}