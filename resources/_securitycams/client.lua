local cameraActive = false
local currentCameraIndex = 0
local currentCameraIndexIndex = 0
local createdCamera = 0
local screenEffect = "Seven_Eleven"

RegisterNetEvent('cameras:activateCamera')
AddEventHandler('cameras:activateCamera', function(cameraID)
    local playerPed = PlayerPedId()
    for cam = 1, #SecurityCamConfig.Locations do
        if SecurityCamConfig.Locations[cam].camBox.id == cameraID then
            local camData = SecurityCamConfig.Locations[cam].cameras[1]
            if createdCamera == 0 then
                FreezeEntityPosition(playerPed, true)
                SetFlash(0, 0, 100, 100, 100)
                Citizen.Wait(250)
                Citizen.CreateThread(function()
                    scaleform = GetScaleform('traffic_cam')
                    local beginTime = GetGameTimer()
                    while GetGameTimer() - beginTime < 3200 do
                        Citizen.Wait(0)
                        RenderFullscreen(scaleform)
                    end
                    UnloadScaleform(scaleform)
                end)
                Citizen.Wait(2000)
                SetFocusArea(camData.x, camData.y, camData.z, camData.x, camData.y, camData.z)
                ChangeSecurityCamera(camData.x, camData.y, camData.z, camData.r)
                SendNUIMessage({
                    type = 'enablecam',
                    label = camData.label,
                    box = SecurityCamConfig.Locations[cam].camBox.label
                })
                currentCameraIndex = cam
                currentCameraIndexIndex = 1
                Citizen.Wait(1200)
                SetFlash(0, 0, 100, 100, 100)
            end
            return
        end
    end
end)

Citizen.CreateThread(function()
    local tabletObject = nil
    while true do
        Citizen.Wait(500)
        local playerPed = PlayerPedId()
        if createdCamera ~= 0 then
            local dict = "amb@world_human_seat_wall_tablet@female@base"
            RequestAnimDict(dict)
            if tabletObject == nil then
                tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
                AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
            end
            while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
            if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
            --local tablet = CreateObject(GetHashKey('prop_cs_tablet'), 0.0, 0.0, 0.0, true, false, true)
            --AttachEntityToEntity(tablet, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, 0.0, 0.0, 0.5, 0.0, -0.2, true, true, false, true, 1.0, false)
                TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            end
            --DeleteEntity(tablet)
            Citizen.Wait(2000)
        else
            if tabletObject ~= nil then
                DeleteEntity(tabletObject)
                ClearPedTasks(playerPed)
                tabletObject = nil
            end
        end
    end

end)

Citizen.CreateThread(function()
    while true do
        for a = 1, #SecurityCamConfig.Locations do
            if createdCamera ~= 0 then
                local instructions = CreateInstuctionScaleform("instructional_buttons")
                DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
                SetTimecycleModifier("scanline_cam_cheap")
                SetTimecycleModifierStrength(2.0)

                if SecurityCamConfig.HideRadar then
                    DisplayRadar(false)
                end

                -- CLOSE CAMERAS
                if IsControlJustPressed(1, 194) then
                    SetFlash(0, 0, 100, 100, 100)
                    DoScreenFadeOut(500)
                    Citizen.Wait(500)
                    CloseSecurityCamera()
                    SendNUIMessage({
                        type = "disablecam",
                    })
                    Citizen.Wait(3000)
                    DoScreenFadeIn(500)
                    FreezeEntityPosition(PlayerPedId(), falsef)
                end

                -- GO BACK CAMERA
                if IsControlJustPressed(1, 174) then
                    SetFlash(0, 0, 100, 100, 100)
                    DoScreenFadeOut(500)
                    Citizen.Wait(500)
                    local newCamIndex

                    if currentCameraIndexIndex == 1 then
                        newCamIndex = #SecurityCamConfig.Locations[currentCameraIndex].cameras
                    else
                        newCamIndex = currentCameraIndexIndex - 1
                    end

                    local newCamx = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].x
                    local newCamy = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].y
                    local newCamz = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].z
                    local newCamr = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].r
                    SetFocusArea(newCamx, newCamy, newCamz, newCamx, newCamy, newCamz)
                    SendNUIMessage({
                        type = "updatecam",
                        label = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].label
                    })
                    ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
                    currentCameraIndexIndex = newCamIndex
                    Citizen.Wait(500)
                    DoScreenFadeIn(500)
                end

                -- GO FORWARD CAMERA
                if IsControlJustPressed(1, 175) then
                    SetFlash(0, 0, 100, 100, 100)
                    DoScreenFadeOut(500)
                    Citizen.Wait(500)
                    local newCamIndex
                    
                    if currentCameraIndexIndex == #SecurityCamConfig.Locations[currentCameraIndex].cameras then
                        newCamIndex = 1
                    else
                        newCamIndex = currentCameraIndexIndex + 1
                    end

                    local newCamx = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].x
                    local newCamy = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].y
                    local newCamz = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].z
                    local newCamr = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].r
                    SetFocusArea(newCamx, newCamy, newCamz, newCamx, newCamy, newCamz)
                    SendNUIMessage({
                        type = "updatecam",
                        label = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].label
                    })
                    ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
                    currentCameraIndexIndex = newCamIndex
                    Citizen.Wait(500)
                    DoScreenFadeIn(500)
                end
            end
        end
        Citizen.Wait(0)
    end
end)

---------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------
function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, x, y, z)
    SetCamRot(cam, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Citizen.Wait(250)
    createdCamera = cam
end

function CloseSecurityCamera()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0*scale, 0.35*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function IsPedAllowed(ped, pedList)
    for i = 1, #pedList do
		if GetHashKey(pedList[i]) == GetEntityModel(ped) then
			return true
		end
	end
    return false
end

function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    InstructionButton(GetControlInstructionalButton(1, 175, true))
    InstructionButtonMessage("Go Forward")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(1, 194, true))
    InstructionButtonMessage("Close Camera")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    InstructionButton(GetControlInstructionalButton(1, 174, true))
    InstructionButtonMessage("Go Back")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function InstructionButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end