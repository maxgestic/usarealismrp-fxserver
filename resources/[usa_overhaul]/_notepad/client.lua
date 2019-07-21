local display = false
local t = {"This is a note."}
local notepad = {
    hash = GetHashKey("prop_notepad_01"),
    handle = nil,
    targetHandBone = 60309,
    animDict = 'amb@medic@standing@timeofdeath@base',
    animName = 'base'
}

RegisterNetEvent("notepad:toggle")
AddEventHandler("notepad:toggle", function(src)
    if not IsPedCuffed(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
        SetGui(not display)
    end
end)

RegisterNUICallback('exit', function(data)
    updateNotes(t)
    SetGui(false)
end)

RegisterNUICallback('error', function(data)
    updateNotes(t)
    SetGui(false)
    notify("~r~Error:~s~\n"..data.error)
end)

RegisterNUICallback('save', function(data)
    SetGui(false)
    table.insert(t, data.main)
    notify("Saved Note ~h~#"..table.length(t))
    updateNotes(t)
end)

RegisterNUICallback('clear', function(data)
    SetGui(false)
    notify("Cleared ~h~"..table.length(t).."~s~ notes")
    t = {}
    updateNotes(t)
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

-- for debugging idk
function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end



function SetGui(enable)
    SetNuiFocus(enable, enable)
    display = enable

    SendNUIMessage({
        type = "ui",
        enable = enable,
        data = t
    })

    if not enable then
        if not IsPedInAnyVehicle(PlayerPedId()) then
            ClearPedTasksImmediately(PlayerPedId())
        end
        if notepad.handle then
            RemovePedNotepad()
        end
    end
end

function table.length(tbl)
    local cnt = 0
    for _ in pairs(tbl) do cnt = cnt + 1 end
    return cnt
  end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~y~~h~"..GetCurrentResourceName()..":~s~~n~"..string)
    DrawNotification(true, false)
    DrawNotificationWithIcon(1,1,"asd")
end

function updateNotes(tbl)
    SendNUIMessage({
        type = "ui",
        data = json.encode(tbl)
    })
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
