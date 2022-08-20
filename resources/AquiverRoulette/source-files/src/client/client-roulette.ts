import { EDITABLE_CONFIG } from "../shared/editable-config";
import { CHAIRS, CHAIR_IDS, Delay, EVENTS, NUMBERS, randomFromArray, Vector3, _ } from "../shared/shared-config";
import { IBetData, IChairData, IRouletteBets, IRouletteData, IVector3 } from "../shared/shared.roulette.interface";

if (EDITABLE_CONFIG.loadDefaultInterior) {
    RequestIpl('vw_casino_main')
}

RequestAnimDict('anim_casino_b@amb@casino@games@roulette@table')
RequestAnimDict('anim_casino_b@amb@casino@games@roulette@dealer_female')
RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
StartAudioScene('DLC_VW_Casino_Roulette_Focus_Wheel')
StartAudioScene('DLC_VW_Casino_Table_Games')
RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false)

let SITTING_SCENE: number;
let CURRENT_CHAIR_DATA: IChairData;
let MAIN_CAM: number;
let CAM_VIEW: number = 0;
let CURRENT_BET_AMOUNT: number = 0;
let aimingAtBet: number;
let lastAimedBet: number;
let closestChairData: IChairData;
let closestTable: RouletteClient;
let hoverObjects: number[] = [];
let hide_bets: boolean = false;

let helptext = '~INPUT_CONTEXT~ Sit down to the roulette table\n'
helptext += `~INPUT_PICKUP~ Stand up\n`;
helptext += `~INPUT_NEXT_CAMERA~ Change camera\n`;
helptext += `~INPUT_LOOK_BEHIND~ Hide pot objects\n`;
helptext += `~INPUT_LOOK_LR~ Select number\n`;
helptext += `~INPUT_ATTACK~ Bet number\n`;
helptext += `~INPUT_CELLPHONE_UP~ Raise bet\n`;
helptext += `~INPUT_CELLPHONE_DOWN~ Reduce bet\n`;
helptext += `~INPUT_JUMP~ Custom bet amount\n`;
helptext += `~INPUT_RELOAD~ Hide HUD`;
AddTextEntry('roulette', helptext);

interface IRenders {
    aimrender: number;
    betrender: number;
    closerender: number;
    fastrender: number;
}

class Renders {

    static renders: IRenders = {
        betrender: null,
        aimrender: null,
        closerender: null,
        fastrender: null
    }

    static render_fast(state: boolean) {
        if (state) {
            if (this.renders.fastrender) return;

            this.renders.fastrender = setTick(() => {
                /** If player is not sitting at the chair. */
                if (!CURRENT_CHAIR_DATA) {
                    if (closestChairData) {
                        DrawMarker(20,
                            closestChairData.position.x,
                            closestChairData.position.y,
                            closestChairData.position.z + 1.0,
                            0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, true, true, 2, true, null, null, false
                        )

                    ShowHelpNotification('roulette', false, false, -1);

                        if (IsControlJustPressed(0, 38)) {
                            emitNet(EVENTS['sitdown'], closestChairData);
                        }
                    }

                    if (closestTable) {
                        av_drawText(
                            Vector3(closestTable.tableData.pos.x, closestTable.tableData.pos.y, closestTable.tableData.pos.z + 1.3),
                            `~o~Roulette~s~\n${EDITABLE_CONFIG.STATUS_MESSAGE[closestTable.status]}\n${closestTable.time} seconds.\nMin-max bet: ${closestTable.tableData.minbet}-${closestTable.tableData.maxbet}`,
                            0.3
                        );
                    }
                }
                /** If player is sitting at the roulette chair. (playing) */
                else {
                    DisableControlAction(0, 38, true)
                    DisableControlAction(0, 45, true)
                    DisableControlAction(0, 172, true)
                    DisableControlAction(0, 173, true)
                    DisableControlAction(0, 26, true)
                    DisableControlAction(0, 0, true)
                    DisableControlAction(0, 22, true)

                    /** Standing up */
                    if (IsDisabledControlJustPressed(0, 38)) {
                        let roul = RouletteControllerClient.get(CURRENT_CHAIR_DATA.tableuid);
                        roul && roul.standup();
                    }

                    /** Hide hut */
                    if (IsDisabledControlJustPressed(0, 45)) {
                        SendNUIMessage({ action: 'showstate' });
                    }

                    /** Bet raise with the arrows. */
                    if (IsDisabledControlJustPressed(0, 172)) {
                        CURRENT_BET_AMOUNT += 10;
                        updateCefBetInput();
                    }
                    else if (IsDisabledControlJustPressed(0, 173)) {
                        if (CURRENT_BET_AMOUNT > 0) {
                            CURRENT_BET_AMOUNT -= 10;

                            if (CURRENT_BET_AMOUNT < 0) {
                                CURRENT_BET_AMOUNT = 0;
                            }
                            updateCefBetInput();
                        }
                    }

                    /** Hide bet objects. */
                    if (IsDisabledControlJustPressed(0, 26)) {
                        let roul = RouletteControllerClient.get(CURRENT_CHAIR_DATA.tableuid);
                        roul && roul.hideBets(!hide_bets)
                        PlaySoundFrontend(-1, 'FocusOut', 'HintCamSounds', false)
                    }

                    /** Change camera view. */
                    if (IsDisabledControlJustPressed(0, 0)) {
                        let roul = RouletteControllerClient.get(CURRENT_CHAIR_DATA.tableuid);
                        roul && roul.changeCameraView();
                    }

                    /** Custom bet with (space) */
                    if (IsDisabledControlJustPressed(0, 22)) {
                        startBetInput();
                    }
                }
            });
        }
        else {
            if (this.renders.fastrender) {
                clearTick(this.renders.fastrender);
                this.renders.fastrender = null;
            }
        }
    }
    static render_close(state: boolean) {
        if (state) {
            if (this.renders.closerender) return;

            this.renders.closerender = setTick(async () => {
                await Delay(1000);
                let playerpos = av_GetEntityPosition(PlayerPedId())

                let close = false;
                for (let i = 0; i < RouletteControllerClient.ClientRoulettes.length; i++) {
                    let d = RouletteControllerClient.ClientRoulettes[i];
                    if (!DoesEntityExist(d.tableObject)) continue;

                    let objcoords = av_GetEntityPosition(d.tableObject);
                    let dist = av_GetDistance(playerpos, objcoords);
                    if (dist > 4) continue;

                    if (typeof d.time === "undefined" || typeof d.status === "undefined" || typeof d.playersamount === "undefined")
                        emitNet(EVENTS["request-update"], d.uid);

                    closestChairData = RouletteControllerClient.getClosestChairData(d);
                    closestTable = d;
                    close = true;
                }

                if (!close) {
                    closestTable = null;
                    closestChairData = null;
                }
            });
        }
        else {
            if (this.renders.closerender) {
                clearTick(this.renders.closerender);
                this.renders.closerender = null;
            }
        }
    }
    static render_bet_state(state: boolean) {
        if (state) {
            if (this.renders.betrender) return;

            this.renders.betrender = setTick(async () => {
                await Delay(8);

                if (aimingAtBet != -1 && lastAimedBet != aimingAtBet) {
                    lastAimedBet = aimingAtBet;
                    let bettingData = closestTable.betData[aimingAtBet];
                    if (bettingData) {
                        RouletteControllerClient.hoverNumbers(bettingData.hovernumbers);
                    }
                    else {
                        RouletteControllerClient.hoverNumbers([]);
                    }
                }

                if (aimingAtBet == -1 && lastAimedBet != -1) {
                    RouletteControllerClient.hoverNumbers([]);
                }
            });
        }
        else {
            if (this.renders.betrender) {
                clearTick(this.renders.betrender);
                this.renders.betrender = null;
            }
        }
    }
    static render_aim_state(state: boolean) {
        if (state) {
            if (this.renders.aimrender) return;

            this.renders.aimrender = setTick(() => {
                // ShowCursorThisFrame();

                let e = closestTable;
                if (!e) return;

                let [cursorX, cursorY] = GetNuiCursorPosition();
                let [resolutionX, resolutionY] = GetActiveScreenResolution();
                let n = 30;
                let foundBet = false;

                for (let i = 0; i < e.betData.length; i++) {
                    let bettingData = e.betData[i];
                    let [onScreen, screenX, screenY] = World3dToScreen2d(bettingData.hoverpos[0], bettingData.hoverpos[1], bettingData.hoverpos[2]);
                    let l = Math.sqrt(Math.pow(screenX * resolutionX - cursorX, 2) + Math.pow(screenY * resolutionY - cursorY, 2));
                    if (l < n) {
                        aimingAtBet = i;
                        foundBet = true;

                        if (IsDisabledControlJustPressed(0, 24)) {
                            if (CURRENT_BET_AMOUNT < 1) continue;
                            PlaySoundFrontend(-1, 'DLC_VW_BET_DOWN', 'dlc_vw_table_games_frontend_sounds', true)
                            emitNet(EVENTS.bet, CURRENT_BET_AMOUNT, bettingData)
                        }
                    }
                }

                if (!foundBet) {
                    aimingAtBet = null;
                }
            });
        }
        else {
            if (this.renders.aimrender) {
                clearTick(this.renders.aimrender);
                this.renders.aimrender = null;
            }
        }
    }
}

onNet('4DF0DBF3D0D0C49951448E82C6C5E524F032F0E1DE50CC35070EA471CCC72685', (chairData: IChairData) => {
    let roul = RouletteControllerClient.get(chairData.tableuid);
    roul && (roul.sitdown(chairData));
});
onNet(EVENTS["update-bets"], (uid: number, data: IRouletteBets[]) => {
    let roul = RouletteControllerClient.get(uid);
    roul && (roul.updateBetObjects(data));
});
onNet(EVENTS["update-status"], (uid: number, status: any) => {
    let roul = RouletteControllerClient.get(uid);
    roul && (roul.status = status);
});
onNet(EVENTS["update-time"], (uid: number, time: number) => {
    let roul = RouletteControllerClient.get(uid);
    roul && (roul.time = time);
});
onNet(EVENTS["update-players-count"], (uid: number, playersamount: number) => {
    let roul = RouletteControllerClient.get(uid);
    roul && (roul.playersamount = playersamount);
});
onNet(EVENTS['spin'], (uid: number, tickrate: number) => {
    let roul = RouletteControllerClient.get(uid);
    roul && (roul.spin(tickrate));
});
onNet(EVENTS["anim-bet"], () => anims.bet());
onNet(EVENTS["anim-loss"], () => anims.loss());
onNet(EVENTS["anim-win"], () => anims.win());
onNet(EVENTS["anim-impartial"], () => anims.impartial());
onNet(EVENTS["anim-idle"], () => anims.idle());
onNet(EVENTS["view-set-variable"], (variable: any, data: any) => {
    SendNUIMessage({ action: 'setvar', variable: variable, value: data });
});
onNet(EVENTS["view-push-log"], (log: string) => {
    SendNUIMessage({
        action: 'pushlog',
        log: log
    });
});
onNet(EVENTS["view-update-betinput"], () => updateCefBetInput());
onNet(EVENTS["default-notif"], (msg: string) => {
    ShowNotification(msg);
});

/** Updating cef bet input */
function updateCefBetInput() {
    SendNUIMessage({
        action: 'setvar',
        variable: 'betInput',
        value: _('cef-bet-input', [CURRENT_BET_AMOUNT])
    });
}

/** Array into Vector3, easier management. */
function av_GetEntityPosition(entity: number) {
    let pcoords = GetEntityCoords(entity, false);
    return Vector3(pcoords[0], pcoords[1], pcoords[2]);
}
/** Get distance between to Vector3. */
function av_GetDistance(pos1: IVector3, pos2: IVector3) {
    return Vdist(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
}
/** Drawtext function. */
function av_drawText(coords: IVector3, text: string, size: number = 1, font: number = 0) {
    SetTextScale(size, size)
    SetTextFont(font)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 100)
    SetTextDropShadow()
    // SetTextOutline()
    SetTextCentre(true)

    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
}

async function getGenericTextInput(type: string = '') {
    AddTextEntry('FMMC_MPM_NA', type)
    DisplayOnscreenKeyboard(1, 'FMMC_MPM_NA', type, '', '', '', '', 30)
    while (UpdateOnscreenKeyboard() == 0) {
        DisableAllControlActions(0);
        await Delay(0);
    }

    if (GetOnscreenKeyboardResult()) {
        return parseInt(GetOnscreenKeyboardResult());
    }
}

async function startBetInput() {
    SetNuiFocus(false, false);
    let result = await getGenericTextInput('Betting');
    if (result && result > 0) {
        CURRENT_BET_AMOUNT = result;
        updateCefBetInput();
        SetNuiFocus(true, true);
    }
}

class RouletteControllerClient {

    static ClientRoulettes: RouletteClient[] = [];

    static get(uid: number) {
        if (!this.exist(uid)) return;
        return this.ClientRoulettes.find(a => a.uid == uid);
    }
    static exist(uid: number) {
        return this.ClientRoulettes.findIndex(a => a.uid == uid) >= 0;
    }
    static getClosestChairData(tableData: RouletteClient) {
        let playerpos = av_GetEntityPosition(PlayerPedId());
        if (DoesEntityExist(tableData.tableObject)) {
            for (let i = 0; i < CHAIRS.length; i++) {
                let chairName = CHAIRS[i];
                let bonecoords = GetWorldPositionOfEntityBone(tableData.tableObject, GetEntityBoneIndexByName(tableData.tableObject, chairName));
                let objpos = Vector3(bonecoords[0], bonecoords[1], bonecoords[2])
                let dist = av_GetDistance(playerpos, objpos);
                if (dist < 1.7) {
                    let chairrot = GetWorldRotationOfEntityBone(tableData.tableObject, GetEntityBoneIndexByName(tableData.tableObject, chairName));
                    return {
                        position: objpos,
                        rotation: Vector3(chairrot[0], chairrot[1], chairrot[2]),
                        chairName: chairName,
                        tableuid: tableData.uid
                    }
                }
            }
        }
    }
    static async hoverNumbers(hoveredNumbers: number[]) {
        for (let i = 0; i < hoverObjects.length; i++) {
            if (DoesEntityExist(hoverObjects[i])) {
                DeleteObject(hoverObjects[i]);
            }
        }

        hoverObjects = [];

        for (let i = 0; i < hoveredNumbers.length; i++) {
            let t = closestTable.betData[hoveredNumbers[i] - 1];
            if (!t) continue;

            RequestModel(GetHashKey(t.hovermodel))
            while (!HasModelLoaded(t.hovermodel))
                await Delay(20);

            let obj = CreateObject(GetHashKey(t.hovermodel), t.hoverpos[0], t.hoverpos[1], t.hoverpos[2], false, false, false);
            SetEntityHeading(obj, closestTable.tableData.heading);

            hoverObjects.push(obj);
        }
    }
    static getChipModel(betAmount: number) {
        if (betAmount < 10) return GetHashKey('vw_prop_vw_coin_01a')
        else if (betAmount >= 10 && betAmount < 50) return GetHashKey('vw_prop_chip_10dollar_x1')
        else if (betAmount >= 50 && betAmount < 100) return GetHashKey('vw_prop_chip_50dollar_x1')
        else if (betAmount >= 100 && betAmount < 500) return GetHashKey('vw_prop_chip_100dollar_x1')
        else if (betAmount >= 500 && betAmount < 1000) return GetHashKey('vw_prop_chip_500dollar_x1')
        else if (betAmount >= 1000 && betAmount < 5000) return GetHashKey('vw_prop_chip_1kdollar_x1')
        else if (betAmount >= 5000 && betAmount < 15000) return GetHashKey('vw_prop_vw_chips_pile_01a')
        else if (betAmount >= 15000 && betAmount < 25000) return GetHashKey('vw_prop_vw_chips_pile_02a')
        else if (betAmount >= 25000) return GetHashKey('vw_prop_vw_chips_pile_03a')
    }
}

class RouletteClient {

    betData: IBetData[] = [];
    tableObject: number;
    ped: number;
    ballObject: number;
    betObjects: { source: any; obj: number; amount: number; }[] = [];
    status: string;
    time: number;
    playersamount: number;

    constructor(public tableData: IRouletteData, public uid: number) {
        RouletteControllerClient.ClientRoulettes[this.uid] = this;

        this.create();
    }
    /** Creating the main roulette table things, we needed this under here because of the **async**. */
    async create() {
        let model = GetHashKey('vw_prop_casino_roulette_01');

        RequestModel(model)
        while (!HasModelLoaded(model))
            await Delay(100);

        this.tableObject = CreateObject(model, this.tableData.pos.x, this.tableData.pos.y, this.tableData.pos.z, false, false, false);
        SetEntityHeading(this.tableObject, this.tableData.heading);

        RequestModel(GetHashKey('S_F_Y_Casino_01'))
        while (!HasModelLoaded(GetHashKey('S_F_Y_Casino_01')))
            await Delay(100);

        let pedOffset = GetObjectOffsetFromCoords(this.tableData.pos.x, this.tableData.pos.y, this.tableData.pos.z, this.tableData.heading, 0.0, 0.7, 1.0);
        this.ped = CreatePed(2, GetHashKey('S_F_Y_Casino_01'), pedOffset[0], pedOffset[1], pedOffset[2], this.tableData.heading + 180.0, false, true);
        SetEntityCanBeDamaged(this.ped, false);
        SetPedAsEnemy(this.ped, false);
        SetBlockingOfNonTemporaryEvents(this.ped, true);
        SetPedResetFlag(this.ped, 249, true);
        SetPedConfigFlag(this.ped, 185, true);
        SetPedConfigFlag(this.ped, 108, true);
        SetPedCanEvasiveDive(this.ped, false);
        SetPedCanRagdollFromPlayerImpact(this.ped, false);
        SetPedConfigFlag(this.ped, 208, true);

        SetPedVoiceGroup(this.ped, GetHashKey('S_M_Y_Casino_01_WHITE_01'))
        SetPedComponentVariation(this.ped, 0, 4, 0, 0)
        SetPedComponentVariation(this.ped, 1, 0, 0, 0)
        SetPedComponentVariation(this.ped, 2, 4, 0, 0)
        SetPedComponentVariation(this.ped, 3, 2, 1, 0)
        SetPedComponentVariation(this.ped, 4, 1, 0, 0)
        SetPedComponentVariation(this.ped, 6, 1, 0, 0)
        SetPedComponentVariation(this.ped, 7, 1, 0, 0)
        SetPedComponentVariation(this.ped, 8, 2, 0, 0)
        SetPedComponentVariation(this.ped, 10, 0, 0, 0)
        SetPedComponentVariation(this.ped, 11, 0, 0, 0)
        SetPedPropIndex(this.ped, 1, 0, 0, false)

        this.idleDealer();

        this.createnumbers();
    }
    idleDealer() {
        if (DoesEntityExist(this.ped)) {
            TaskPlayAnim(this.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female',
                randomFromArray(['idle', 'idle_var01', 'idle_var02', 'idle_var03', 'idle_var04', 'idle_var05', 'idle_var06']),
                3.0, 3.0, -1, 1, 0, true, true, true);
        }
    }
    /** Client player sit down to roulette table. */
    async sitdown(chairData: IChairData) {
        CURRENT_CHAIR_DATA = chairData;
        SITTING_SCENE = NetworkCreateSynchronisedScene(
            chairData.position.x, chairData.position.y, chairData.position.z,
            chairData.rotation.x, chairData.rotation.y, chairData.rotation.z, 2, true, false, 1065353216, 0, 1065353216
        );

        let randomsit = ['sit_enter_left', 'sit_enter_right'];
        NetworkAddPedToSynchronisedScene(PlayerPedId(), SITTING_SCENE, 'anim_casino_b@amb@casino@games@shared@player@', randomFromArray(randomsit), 2.0, -2.0, 13, 16, 2.0, 0)
        NetworkStartSynchronisedScene(SITTING_SCENE)
        SetPlayerControl(PlayerId(), false, 0)
        DisplayRadar(false);

        this.speakPed('MINIGAME_DEALER_GREET');

        await Delay(4000);
        SetPlayerControl(PlayerId(), true, 0);
        this.createcamera();
        Renders.render_close(false);
        Renders.render_aim_state(true);
        Renders.render_bet_state(true);
        anims.idle();

        SetNuiFocus(true, true);
        SetNuiFocusKeepInput(true);
    }
    /** Create main roulette camera. **MAIN_CAM** */
    createcamera() {
        if (DoesCamExist(MAIN_CAM)) return;
        let rot = Vector3(270.0, -90.0, this.tableData.heading + 270);
        MAIN_CAM = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA',
            this.tableData.pos.x, this.tableData.pos.y, this.tableData.pos.z + 2.0, rot.x, rot.y, rot.z, 80.0, true, 2
        );
        SetCamActive(MAIN_CAM, true);
        RenderScriptCams(true, true, 900, true, false);
    }
    /** Client player standup from the table. */
    async standup() {
        NetworkStopSynchronisedScene(SITTING_SCENE);

        let anim;
        if (CURRENT_CHAIR_DATA.chairName == "Chair_Base_01")
            anim = 'sit_exit_left';
        else if (CURRENT_CHAIR_DATA.chairName == 'Chair_Base_02')
            anim = 'sit_exit_right';
        else if (CURRENT_CHAIR_DATA.chairName == 'Chair_Base_03')
            anim = randomFromArray(['sit_exit_left', 'sit_exit_right']);
        else if (CURRENT_CHAIR_DATA.chairName == 'Chair_Base_04')
            anim = 'sit_exit_left';

        TaskPlayAnim(PlayerPedId(), 'anim_casino_b@amb@casino@games@shared@player@', anim, 1.0, 1.0, 2500, 0, 0, true, true, true);
        SetPlayerControl(PlayerId(), false, 0);
        await Delay(3000);
        SetPlayerControl(PlayerId(), true, 0);
        DisplayRadar(true);
        emitNet(EVENTS.standup);
        CURRENT_CHAIR_DATA = null;

        if (DoesCamExist(MAIN_CAM)) {
            DestroyCam(MAIN_CAM, false);
        }
        RenderScriptCams(false, true, 900, true, true)
        Renders.render_close(true);
        Renders.render_aim_state(false);
        Renders.render_bet_state(false);
        this.hideBets(false);

        SetNuiFocus(false, false);
        SetNuiFocusKeepInput(false);
        RouletteControllerClient.hoverNumbers([]);
    }
    /** Speak ped function. */
    speakPed(speechName: string) {
        DoesEntityExist(this.ped) && PlayAmbientSpeech1(this.ped, speechName, 'SPEECH_PARAMS_FORCE_NORMAL_CLEAR');
    }
    /** Creating the table numbers data and others. */
    createnumbers() {
        /** Create the simple numbers 1-36 */
        let num = 1;
        for (let i = 0; i < 12; i++) {
            for (let j = 0; j < 3; j++) {
                this.betData.push({
                    betId: num,
                    hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, (0.081 * i) - 0.057, (0.167 * j) - 0.192, 0.9448),
                    hovernumbers: [num],
                    hovermodel: 'vw_prop_vw_marker_02a'
                });
                num++;
            }
        }
        this.betData.push({
            betId: 'ZERO',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, -0.137, -0.148, 0.9448),
            hovernumbers: [37],
            hovermodel: 'vw_prop_vw_marker_01a'
        });
        this.betData.push({
            betId: 'DOUBLE-ZERO',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, -0.133, 0.107, 0.9448),
            hovernumbers: [38],
            hovermodel: 'vw_prop_vw_marker_01a'
        });

        /** Only betData now on, because the numbers are present. */
        this.betData.push({
            betId: 'RED',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.3, -0.4, 0.9448),
            hovernumbers: NUMBERS['RED'],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: 'BLACK',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.5, -0.4, 0.9448),
            hovernumbers: NUMBERS['BLACK'],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: 'EVEN',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.15, -0.4, 0.9448),
            hovernumbers: NUMBERS['EVEN'],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: 'ODD',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.65, -0.4, 0.9448),
            hovernumbers: NUMBERS['ODD'],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: '1to18',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, -0.02, -0.4, 0.9448),
            hovernumbers: NUMBERS['1to18'],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: '19to36',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.78, -0.4, 0.9448),
            hovernumbers: NUMBERS["19to36"],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: '1st12',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.05, -0.3, 0.9448),
            hovernumbers: NUMBERS["1st12"],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: '2nd12',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.4, -0.3, 0.9448),
            hovernumbers: NUMBERS["2nd12"],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: '3rd12',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.75, -0.3, 0.9448),
            hovernumbers: NUMBERS["3rd12"],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: '2to1-first',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.91, -0.15, 0.9448),
            hovernumbers: NUMBERS["2to1-first"],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: '2to1-second',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.91, 0.0, 0.9448),
            hovernumbers: NUMBERS["2to1-second"],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
        this.betData.push({
            betId: '2to1-third',
            hoverpos: GetOffsetFromEntityInWorldCoords(this.tableObject, 0.91, 0.15, 0.9448),
            hovernumbers: NUMBERS["2to1-third"],
            hovermodel: 'vw_prop_vw_marker_02a'
        });
    }
    /** Main roulette spin event function. */
    async spin(tick: number) {
        if (!DoesEntityExist(this.tableObject) || !DoesEntityExist(this.ped)) return;

        RequestModel(GetHashKey('vw_prop_roulette_ball'))
        while (!HasModelLoaded(GetHashKey('vw_prop_roulette_ball')))
            await Delay(100);

        this.speakPed('MINIGAME_DEALER_CLOSED_BETS');
        TaskPlayAnim(this.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'no_more_bets', 3.0, 3.0, -1, 0, 0, true, true, true)
        await Delay(1500);
        if (DoesEntityExist(this.ballObject)) {
            DeleteObject(this.ballObject);
        }

        let LIB = 'anim_casino_b@amb@casino@games@roulette@table'

        TaskPlayAnim(this.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'spin_wheel', 3.0, 3.0, -1, 0, 0, true, true, true)
        await Delay(270);
        PlayEntityAnim(this.tableObject, 'intro_wheel', LIB, 1000.0, false, true, true, 0, 136704)

        let ballOffset = GetWorldPositionOfEntityBone(this.tableObject, GetEntityBoneIndexByName(this.tableObject, 'Roulette_Wheel'))

        await Delay(2850);

        this.ballObject = CreateObject(GetHashKey('vw_prop_roulette_ball'), ballOffset[0], ballOffset[1], ballOffset[2], false, false, false);
        SetEntityCoordsNoOffset(this.ballObject, ballOffset[0], ballOffset[1], ballOffset[2], false, false, false);
        SetEntityHeading(this.ballObject, this.tableData.heading - 5.0)

        let soundId = GetSoundId()
        PlaySoundFromEntity(soundId, 'DLC_VW_ROULETTE_BALL_LOOP', this.ballObject, 'dlc_vw_table_games_sounds', false, 0)
        PlayEntityAnim(this.ballObject, 'intro_ball', LIB, 1000.0, false, true, true, 0, 136704)

        PlayEntityAnim(this.ballObject, 'loop_ball', LIB, 1000.0, false, true, false, 0, 136704)
        PlayEntityAnim(this.tableObject, 'loop_wheel', LIB, 1000.0, false, true, false, 0, 136704)

        await Delay(2000)
        SetEntityCoordsNoOffset(this.ballObject, ballOffset[0], ballOffset[1], ballOffset[2], false, false, false);
        SetEntityHeading(this.ballObject, this.tableData.heading - 5.0)

        this.idleDealer();

        StopSound(soundId)
        ReleaseSoundId(soundId)

        PlaySoundFromEntity(GetSoundId(), `dlc_vw_roulette_exit_${tick}`, this.ballObject, 'dlc_vw_table_games_roulette_exit_sounds', false, 0);
        PlayEntityAnim(this.ballObject, `exit_${tick}_ball`, LIB, 1000.0, false, true, false, 0, 136704)
        PlayEntityAnim(this.tableObject, `exit_${tick}_wheel`, LIB, 1000.0, false, true, false, 0, 136704)

        await Delay(11e3);

        if (DoesEntityExist(this.tableObject) && DoesEntityExist(this.ped)) {
            TaskPlayAnim(this.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone1', 3.0, 3.0, -1, 0, 0, true, true, true)
            await Delay(1500);
            TaskPlayAnim(this.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone2', 3.0, 3.0, -1, 0, 0, true, true, true)
            await Delay(1500);
            TaskPlayAnim(this.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone3', 3.0, 3.0, -1, 0, 0, true, true, true)
            await Delay(2000);
            this.idleDealer();

            if (DoesEntityExist(this.ballObject)) {
                DeleteObject(this.ballObject);
            }

            this.updateBetObjects([]);
        }
    }
    /** Updating && creating bet chip objects. */
    async updateBetObjects(data: IRouletteBets[]) {
        for (let i = 0; i < this.betObjects.length; i++) {
            if (DoesEntityExist(this.betObjects[i].obj)) {
                DeleteObject(this.betObjects[i].obj);
            }
        }

        this.betObjects = [];

        /** Only raise with other player bets, because the player bets merge into each other. */
        var existBetId: { [betId: string]: number } = {};

        for (let i = 0; i < data.length; i++) {
            let d = data[i];
            if (typeof existBetId[d.betId] !== "undefined") existBetId[d.betId]++;
            else existBetId[d.betId] = 0;

            let t = this.betData.find(a => a.betId == d.betId);
            if (!t) continue;

            let chipmodel = RouletteControllerClient.getChipModel(d.amount);
            if (!chipmodel) continue;

            RequestModel(chipmodel);
            while (!HasModelLoaded(chipmodel))
                await Delay(20);

            let obj = CreateObject(
                chipmodel,
                t.hoverpos[0],
                t.hoverpos[1],
                t.hoverpos[2] + (existBetId[d.betId] * 0.0081),
                false, false, false
            );
            SetEntityHeading(obj, this.tableData.heading);

            this.betObjects.push({
                "amount": d.amount,
                "source": d.source,
                "obj": obj
            })
        }
    }
    /** Hide table bet objects. */
    hideBets(state: boolean) {
        hide_bets = state;

        for (let i = 0; i < this.betObjects.length; i++) {
            let d = this.betObjects[i];
            if (!d || !DoesEntityExist(d.obj)) continue;

            SetEntityVisible(d.obj, !state, false);
        }
    }
    /** Changing camera views. */
    async changeCameraView() {
        if (!DoesCamExist(MAIN_CAM)) return;

        DoScreenFadeOut(200);
        while (!IsScreenFadedOut())
            await Delay(10);

        if (CAM_VIEW == 0) {
            let [ox, oy, oz] = GetOffsetFromEntityInWorldCoords(this.tableObject, -1.45, -0.15, 1.45);
            CAM_VIEW = 1;
            SetCamCoord(MAIN_CAM, ox, oy, oz);
            SetCamRot(MAIN_CAM, -25.0, 0.0, this.tableData.heading + 270.0, 2);
            SetCamFov(MAIN_CAM, 40.0);
            ShakeCam(MAIN_CAM, 'HAND_SHAKE', 0.3);
        }
        else if (CAM_VIEW == 1) {
            let [ox, oy, oz] = GetOffsetFromEntityInWorldCoords(this.tableObject, 1.45, -0.15, 2.15);
            CAM_VIEW = 2;
            SetCamCoord(MAIN_CAM, ox, oy, oz);
            SetCamRot(MAIN_CAM, -58.0, 0.0, this.tableData.heading + 90.0, 2);
            ShakeCam(MAIN_CAM, 'HAND_SHAKE', 0.3);
            SetCamFov(MAIN_CAM, 80.0);
        }
        else if (CAM_VIEW == 2) {
            let [ox, oy, oz] = GetWorldPositionOfEntityBone(
                this.tableObject,
                GetEntityBoneIndexByName(this.tableObject, 'Roulette_Wheel')
            );
            CAM_VIEW = 3;
            SetCamCoord(MAIN_CAM, ox, oy, oz + 0.5);
            SetCamRot(MAIN_CAM, 270.0, -90.0, this.tableData.heading + 270.0, 2);
            StopCamShaking(MAIN_CAM, false);
            SetCamFov(MAIN_CAM, 80.0);
        }
        else if (CAM_VIEW == 3) {
            CAM_VIEW = 0;
            SetCamCoord(MAIN_CAM, this.tableData.pos.x, this.tableData.pos.y, this.tableData.pos.z + 2.0);
            SetCamRot(MAIN_CAM, 270.0, -90.0, this.tableData.heading + 270.0, 2);
            SetCamFov(MAIN_CAM, 80.0);
            StopCamShaking(MAIN_CAM, false);
        }

        DoScreenFadeIn(200);
    }
}

(function init() {
    for (let i = 0; i < EDITABLE_CONFIG.TABLES.length; i++) {
        new RouletteClient(EDITABLE_CONFIG.TABLES[i], i);
    }
    Renders.render_close(true);
    Renders.render_fast(true);
})();


const anims = {
    async idle() {
        if (!CURRENT_CHAIR_DATA) return;
        let chairId = CHAIR_IDS[CURRENT_CHAIR_DATA.chairName];
        if (!chairId) return;

        let rot = JSON.parse(JSON.stringify(CURRENT_CHAIR_DATA.rotation));
        let LIB = `anim_casino_b@amb@casino@games@roulette@ped_male@seat_${chairId}@regular@0${chairId}a@idles`;

        if (chairId == 4) rot.z += 90.0;
        else if (chairId == 3) rot.z += -180;
        else if (chairId == 2) rot.z += -90.0;
        else if (chairId == 1) rot.z += -90.0;

        if (GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01')) {
            LIB = `anim_casino_b@amb@casino@games@roulette@ped_female@seat_${chairId}@regular@0${chairId}a@idles`;
        }

        RequestAnimDict(LIB)
        while (!HasAnimDictLoaded(LIB))
            await Delay(20);

        SITTING_SCENE = NetworkCreateSynchronisedScene(
            CURRENT_CHAIR_DATA.position.x,
            CURRENT_CHAIR_DATA.position.y,
            CURRENT_CHAIR_DATA.position.z,
            rot.x,
            rot.y,
            rot.z,
            2, false, true, 1065353216, 0, 1065353216
        )
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(), SITTING_SCENE, LIB,
            randomFromArray(['idle_a', 'idle_b', 'idle_c', 'idle_d']),
            1.0, -2.0, 13, 16, 1148846080, 0
        )
        NetworkStartSynchronisedScene(SITTING_SCENE);
    },
    async impartial() {
        if (!CURRENT_CHAIR_DATA) return;
        let chairId = CHAIR_IDS[CURRENT_CHAIR_DATA.chairName];
        if (!chairId) return;

        let rot = JSON.parse(JSON.stringify(CURRENT_CHAIR_DATA.rotation));
        let LIB = `anim_casino_b@amb@casino@games@roulette@ped_male@seat_${chairId}@regular@0${chairId}a@reacts@v01`;

        if (chairId == 4) rot.z += 90.0;
        else if (chairId == 3) rot.z += -180;
        else if (chairId == 2) rot.z += -90.0;
        else if (chairId == 1) rot.z += -90.0;

        if (GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01')) {
            LIB = `anim_casino_b@amb@casino@games@roulette@ped_female@seat_${chairId}@regular@0${chairId}a@reacts@v01`;
        }

        RequestAnimDict(LIB)
        while (!HasAnimDictLoaded(LIB))
            await Delay(20);

        SITTING_SCENE = NetworkCreateSynchronisedScene(
            CURRENT_CHAIR_DATA.position.x,
            CURRENT_CHAIR_DATA.position.y,
            CURRENT_CHAIR_DATA.position.z,
            rot.x,
            rot.y,
            rot.z,
            2, true, false, 1065353216, 0, 1065353216
        )
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(), SITTING_SCENE, LIB,
            randomFromArray(['reaction_impartial_var01', 'reaction_impartial_var02', 'reaction_impartial_var03']),
            1.0, -2.0, 13, 16, 1148846080, 0
        )
        NetworkStartSynchronisedScene(SITTING_SCENE);
        await Delay(4000);
        anims.idle();
    },
    async bet() {
        if (!CURRENT_CHAIR_DATA) return;
        let chairId = CHAIR_IDS[CURRENT_CHAIR_DATA.chairName];
        if (!chairId) return;

        let rot = JSON.parse(JSON.stringify(CURRENT_CHAIR_DATA.rotation));
        let LIB = `anim_casino_b@amb@casino@games@roulette@ped_male@seat_${chairId}@regular@0${chairId}a@play@v01`;

        if (chairId == 4) rot.z += 90.0;
        else if (chairId == 3) rot.z += -180;
        else if (chairId == 2) rot.z += -90.0;
        else if (chairId == 1) rot.z += -90.0;

        if (GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01')) {
            LIB = `anim_casino_b@amb@casino@games@roulette@ped_female@seat_${chairId}@regular@0${chairId}a@play@v01`;
        }

        RequestAnimDict(LIB)
        while (!HasAnimDictLoaded(LIB))
            await Delay(20);

        SITTING_SCENE = NetworkCreateSynchronisedScene(
            CURRENT_CHAIR_DATA.position.x,
            CURRENT_CHAIR_DATA.position.y,
            CURRENT_CHAIR_DATA.position.z,
            rot.x,
            rot.y,
            rot.z,
            2, true, false, 1065353216, 0, 1065353216
        )
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(), SITTING_SCENE, LIB,
            randomFromArray(['place_bet_zone1', 'place_bet_zone2', 'place_bet_zone3']),
            1.0, -2.0, 13, 16, 1148846080, 0
        )
        NetworkStartSynchronisedScene(SITTING_SCENE);
        await Delay(4000);
        anims.idle();
    },
    async loss() {
        if (!CURRENT_CHAIR_DATA) return;
        let chairId = CHAIR_IDS[CURRENT_CHAIR_DATA.chairName];
        if (!chairId) return;

        let rot = JSON.parse(JSON.stringify(CURRENT_CHAIR_DATA.rotation));
        let LIB = `anim_casino_b@amb@casino@games@roulette@ped_male@seat_${chairId}@regular@0${chairId}a@reacts@v01`;

        if (chairId == 4) rot.z += 90.0;
        else if (chairId == 3) rot.z += -180;
        else if (chairId == 2) rot.z += -90.0;
        else if (chairId == 1) rot.z += -90.0;

        if (GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01')) {
            LIB = `anim_casino_b@amb@casino@games@roulette@ped_female@seat_${chairId}@regular@0${chairId}a@reacts@v01`;
        }

        RequestAnimDict(LIB)
        while (!HasAnimDictLoaded(LIB))
            await Delay(20);

        SITTING_SCENE = NetworkCreateSynchronisedScene(
            CURRENT_CHAIR_DATA.position.x,
            CURRENT_CHAIR_DATA.position.y,
            CURRENT_CHAIR_DATA.position.z,
            rot.x,
            rot.y,
            rot.z,
            2, true, false, 1065353216, 0, 1065353216
        )
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(), SITTING_SCENE, LIB,
            randomFromArray(['reaction_bad_var01', 'reaction_bad_var02', 'reaction_terrible']),
            1.0, -2.0, 13, 16, 1148846080, 0
        )
        NetworkStartSynchronisedScene(SITTING_SCENE);
        await Delay(4000);
        anims.idle();
    },
    async win() {
        if (!CURRENT_CHAIR_DATA) return;
        let chairId = CHAIR_IDS[CURRENT_CHAIR_DATA.chairName];
        if (!chairId) return;

        let rot = JSON.parse(JSON.stringify(CURRENT_CHAIR_DATA.rotation));
        let LIB = `anim_casino_b@amb@casino@games@roulette@ped_male@seat_${chairId}@regular@0${chairId}a@reacts@v01`;

        if (chairId == 4) rot.z += 90.0;
        else if (chairId == 3) rot.z += -180;
        else if (chairId == 2) rot.z += -90.0;
        else if (chairId == 1) rot.z += -90.0;

        if (GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01')) {
            LIB = `anim_casino_b@amb@casino@games@roulette@ped_female@seat_${chairId}@regular@0${chairId}a@reacts@v01`;
        }

        RequestAnimDict(LIB)
        while (!HasAnimDictLoaded(LIB))
            await Delay(20);

        SITTING_SCENE = NetworkCreateSynchronisedScene(
            CURRENT_CHAIR_DATA.position.x,
            CURRENT_CHAIR_DATA.position.y,
            CURRENT_CHAIR_DATA.position.z,
            rot.x,
            rot.y,
            rot.z,
            2, true, false, 1065353216, 0, 1065353216
        )
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(), SITTING_SCENE, LIB,
            'reaction_great',
            1.0, -2.0, 13, 16, 1148846080, 0
        )
        NetworkStartSynchronisedScene(SITTING_SCENE);
        await Delay(4000);
        anims.idle();
    }
}

function ShowHelpNotification(helpTextName: string, thisFrame: boolean, beep: boolean, duration: number) {
    if (thisFrame) DisplayHelpTextThisFrame(helpTextName, true);
    else {
        BeginTextCommandDisplayHelp(helpTextName);
        EndTextCommandDisplayHelp(0, false, beep, duration);
    }
}
function ShowNotification(msg: string) {
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg);
    DrawNotification(false, true);
}