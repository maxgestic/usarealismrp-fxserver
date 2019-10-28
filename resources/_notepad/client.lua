local display = false
local notepad = {
    hash = GetHashKey("prop_notepad_01"),
    handle = nil,
    targetHandBone = 60309,
    animDict = 'amb@medic@standing@timeofdeath@base',
    animName = 'base'
}

RegisterNetEvent("notepad:gotSaved")
AddEventHandler("notepad:gotSaved", function(content)
    SetNuiFocus(true, true)
    display = true
    SendNUIMessage({
        type = "ui",
        enable = true,
        content = content
    })
end)

RegisterNetEvent("notepad:toggle")
AddEventHandler("notepad:toggle", function()
    if not IsPedCuffed(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
        SetGui(not display)
    end
end)

RegisterNUICallback('exit', function(data)
    SetGui(false)
end)

RegisterNUICallback('error', function(data)
    SetGui(false)
    exports.globals:notify("Error")
end)

RegisterNUICallback('save', function(data)
    SetGui(false)
    exports.globals:notify("Saved")
    TriggerServerEvent("notepad:save", data.main)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if display then
            local me = GetPlayerPed(-1)
            DisableControlAction(0, 1, display) -- LookLeftRight
            DisableControlAction(0, 2, display) -- LookUpDown
            DisableControlAction(0, 142, display) -- MeleeAttackAlternate
            DisableControlAction(0, 18, display) -- Enter
            DisableControlAction(0, 322, display) -- ESC
            DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
            if not IsEntityPlayingAnim(me, notepad.animDict, notepad.animName, 3) and not IsPedInAnyVehicle(me, true) then
                if not notepad.handle then
                    GivePedNotepad()
                end
                RequestAnimDict(notepad.animDict)
                while not HasAnimDictLoaded(notepad.animDict) do
                    Wait(100)
                end
                TaskPlayAnim(me, notepad.animDict, notepad.animName, 1.0, -1, -1, 50, 0, false, false, false)
            end
        end
    end
end)

function SetGui(enable)
    if not enable then
        SetNuiFocus(enable, enable)
        display = enable
        SendNUIMessage({
            type = "ui",
            enable = false
        })
        if not IsPedInAnyVehicle(PlayerPedId()) then
            ClearPedTasksImmediately(PlayerPedId())
        end
        if notepad.handle then
            RemovePedNotepad()
        end
    else
        TriggerServerEvent("notepad:getSaved")
    end
end

function GivePedNotepad()
	local ped = GetPlayerPed(-1)
	local coords = GetEntityCoords(ped)
    local bone = GetPedBoneIndex(ped, notepad.targetHandBone)
  	RequestModel(notepad.hash)
  	while not HasModelLoaded(notepad.hash) do
  		Citizen.Wait(100)
  	end
  	notepad.handle = CreateObject(notepad.hash, coords.x, coords.y, coords.z, 1, 1, 0)
	if rotX and rotY and rotZ and x and y and z then
  		AttachEntityToEntity(notepad.handle, ped, bone, x, y, z, rotX, rotY, rotZ, 1, 1, 0, 0, 2, 1)
	else
		AttachEntityToEntity(notepad.handle, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	end
end

function RemovePedNotepad()
	DeleteObject(notepad.handle)
	notepad.handle = nil
end
