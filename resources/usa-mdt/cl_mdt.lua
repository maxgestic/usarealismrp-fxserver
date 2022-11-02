local isVisible = false
local tabletObject = nil

RegisterNetEvent("mdt:sendNUIMessage")
AddEventHandler("mdt:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterNetEvent("mdt:toggleVisibilty")
AddEventHandler("mdt:toggleVisibilty", function()
    local playerPed = PlayerPedId()
    if not isVisible then
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
    else
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
    end
    ToggleGUI()
end)

RegisterNUICallback("close", function(data, cb)
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
    cb('ok')
end)

RegisterNUICallback("updatePhoto", function(data, cb)
    TriggerServerEvent("mdt:updatePhoto", data.url, data.fname, data.lname, data.dob)
    cb('ok')
end)

RegisterNUICallback("updateDNA", function(data, cb)
    TriggerServerEvent("mdt:updateDNA", data.dna, data.fname, data.lname, data.dob)
    cb('ok')
end)

RegisterNUICallback("PerformPersonCheckBySSN", function(data, cb)
    TriggerServerEvent("mdt:PerformPersonCheckBySSN", tonumber(data.ssn))
    cb('ok')
end)

RegisterNUICallback("PerformPersonCheckByName", function(data, cb)
    TriggerServerEvent("mdt:PerformPersonCheckByName", data)
    cb('ok')
end)

RegisterNUICallback("PerformPersonCheckByDNA", function(data, cb)
    TriggerServerEvent("mdt:PerformPersonCheckByDNA", data)
    cb('ok')
end)

RegisterNUICallback("PerformPlateCheck", function(data, cb)
    TriggerServerEvent("mdt:performPlateCheck", data.plate)
    cb('ok')
end)

RegisterNUICallback("PerformMarkAddress", function(data, cb)
    if not data.ssn then data.ssn = 0 end
    TriggerServerEvent("properties:markAddress", data.ssn, data.fname, data.lname)
    cb('ok')
end)

RegisterNUICallback("PerformWeaponCheck", function(data, cb)
    TriggerServerEvent("mdt:performWeaponCheck", data.serial)
    cb('ok')
end)

RegisterNUICallback("fetchWarrants", function(data, cb)
    TriggerServerEvent("mdt:fetchWarrants")
    cb('ok')
end)

RegisterNUICallback("createWarrant", function(data, cb)
    TriggerServerEvent("mdt:createWarrant", data.warrant)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("mdt:deleteWarrant", data.warrant_id, data.warrant_rev)
    cb('ok')
end)

RegisterNUICallback("createBOLO", function(data, cb)
    TriggerServerEvent("mdt:createBOLO", data.bolo)
    cb('ok')
end)

RegisterNUICallback("fetchBOLOs", function(data, cb)
    TriggerServerEvent("mdt:fetchBOLOs")
    cb('ok')
end)

RegisterNUICallback("deleteBOLO", function(data, cb)
    TriggerServerEvent("mdt:deleteBOLO", data.bolo_id, data.bolo_rev)
    cb('ok')
end)

RegisterNUICallback("fetchPoliceReports", function(data, cb)
    TriggerServerEvent("mdt:fetchPoliceReports")
    cb('ok')
end)

RegisterNUICallback("fetchPoliceReportDetails", function(data, cb)
    TriggerServerEvent("mdt:fetchPoliceReportDetails", data.id)
    cb('ok')
end)

RegisterNUICallback("CreatePoliceReport", function(data, cb)
    TriggerServerEvent("mdt:createPoliceReport", data.report)
    cb('ok')
end)

RegisterNUICallback("deletePoliceReport", function(data, cb)
    TriggerServerEvent("mdt:deletePoliceReport", data.police_report_id, data.police_report_rev)
    cb('ok')
end)

RegisterNUICallback("fetchEmployee", function(data, cb)
    TriggerServerEvent("mdt:fetchEmployee")
    cb('ok')
end)

RegisterNUICallback("getAddressInfo", function(data, cb)
    TriggerServerEvent("mdt:getAddressInfo", data)
end)

RegisterNUICallback("getNameSearchDropdownResults", function(data, cb)
    TriggerServerEvent("mdt:getNameSearchDropdownResults", data.name)
    cb('ok')
end)

RegisterNUICallback("performPersonCheckByCharID", function(data, cb)
    TriggerServerEvent("mdt:performPersonCheckByCharID", data.id)
    cb('ok')
end)

RegisterNUICallback("saveNote", function(data, cb)
    TriggerServerEvent("mdt:saveNote", data.targetCharId, data.targetCharFName, data.targetCharLName, data.value)
    cb('ok')
end)

RegisterNUICallback("saveVehNote", function(data, cb)
    TriggerServerEvent("mdt:saveVehNote", data.plate, data.value)
    cb('ok')
end)

RegisterNUICallback("saveWepNote", function(data, cb)
    TriggerServerEvent("mdt:saveWepNote", data.serial, data.value)
    cb('ok')
end)

function ToggleGUI(explicit_status)
  if explicit_status ~= nil then
    isVisible = explicit_status
  else
    isVisible = not isVisible
  end
  SetNuiFocus(isVisible, isVisible)
  SendNUIMessage({
    type = "enable",
    isVisible = isVisible
  })
end

----------------------
-- person check --
---------------------
RegisterNetEvent("mdt:performPersonCheck")
AddEventHandler("mdt:performPersonCheck", function(person_info)
    SendNUIMessage({
        type = "personInfoLoaded",
        person_info = person_info
    })
end)

----------------------
-- plate check --
---------------------
RegisterNetEvent("mdt:performPlateCheck")
AddEventHandler("mdt:performPlateCheck", function(plate_info)
    SendNUIMessage({
        type = "plateInfoLoaded",
        plate_info = plate_info
    })
end)

----------------------
-- weapon check --
---------------------
RegisterNetEvent("mdt:performWeaponCheck")
AddEventHandler("mdt:performWeaponCheck", function(weapon_info)
    SendNUIMessage({
        type = "weaponInfoLoaded",
        weapon_info = weapon_info
    })
end)

-----------------------
-- fetch warrants --
-----------------------
RegisterNetEvent("mdt:fetchWarrants")
AddEventHandler("mdt:fetchWarrants", function(warrants)
    SendNUIMessage({
        type = "warrantsLoaded",
        warrants = warrants
    })
end)
