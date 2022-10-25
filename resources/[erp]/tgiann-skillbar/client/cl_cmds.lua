local jailed = false

RegisterNetEvent("erp:erp")
AddEventHandler("erp:erp", function(id)
    if not jailed then
        ExecuteCommand("erp " .. id)
    end
end)

RegisterNetEvent("erp:erpcancel")
AddEventHandler("erp:erpcancel", function()
    if not jailed then
        ExecuteCommand("erpcancel")
    end
end)

RegisterNetEvent("erp:p1")
AddEventHandler("erp:p1", function()
    if not jailed then
        ExecuteCommand("p1")
    end
end)

RegisterNetEvent("erp:p2")
AddEventHandler("erp:p2", function()
    if not jailed then
        ExecuteCommand("p2")
    end
end)

RegisterNetEvent("erp:p3")
AddEventHandler("erp:p3", function()
    if not jailed then
        ExecuteCommand("p3")
    end
end)

RegisterNetEvent("erp:p4")
AddEventHandler("erp:p4", function()
    if not jailed then
        ExecuteCommand("p4")
    end
end)

RegisterNetEvent("erp:p5")
AddEventHandler("erp:p5", function()
    if not jailed then
        ExecuteCommand("p5")
    end
end)

RegisterNetEvent("erp:p6")
AddEventHandler("erp:p6", function()
    if not jailed then
        ExecuteCommand("p6")
    end
end)

RegisterNetEvent("erp:p7")
AddEventHandler("erp:p7", function()
    if not jailed then
        ExecuteCommand("p7")
    end
end)

RegisterNetEvent("usa:toggleJailedStatus")
AddEventHandler("usa:toggleJailedStatus", function(toggle)
    jailed = toggle
end)