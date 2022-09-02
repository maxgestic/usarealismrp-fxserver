import { Vec3 } from "@aquiversdk/shared";

export function Wait(ms: number): Promise<void> {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve();
        }, ms);
    });
}

export function DrawText3D(coords: Vec3, text: string, size: number = 0.3, font: number = 0) {
    SetTextScale(size, size);
    SetTextFont(font);
    SetTextColour(255, 255, 255, 255);
    SetTextDropshadow(0, 0, 0, 0, 100);
    SetTextDropShadow();
    // SetTextOutline()
    SetTextCentre(true);
    SetDrawOrigin(coords.x, coords.y, coords.z, 0);
    BeginTextCommandDisplayText('STRING');
    AddTextComponentSubstringPlayerName(text);
    EndTextCommandDisplayText(0.0, 0.0);
    ClearDrawOrigin();
}

export function DrawText2D(x: number, y: number, text: string, size: number = 0.25, font: number = 0) {
    SetTextFont(font);
    SetTextProportional(false);
    SetTextScale(size, size);
    SetTextColour(255, 255, 255, 255);
    SetTextDropshadow(0, 0, 0, 0, 100);
    SetTextDropShadow();
    SetTextCentre(true);
    SetTextEntry('STRING');
    AddTextComponentString(text);
    DrawText(x, y);
}