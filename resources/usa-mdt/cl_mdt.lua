local isVisible = false

RegisterNetEvent("mdt:sendNUIMessage")
AddEventHandler("mdt:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterNetEvent("mdt:toggleVisibilty")
AddEventHandler("mdt:toggleVisibilty", function()
    ToggleGUI()
end)

RegisterNUICallback("close", function(data, cb)
    ToggleGUI()
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

RegisterNUICallback("PerformPlateCheck", function(data, cb)
    TriggerServerEvent("mdt:performPlateCheck", data.plate)
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

function ToggleGUI()
    isVisible = not isVisible
    print("setting menu on to: " .. tostring(isVisible))
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
