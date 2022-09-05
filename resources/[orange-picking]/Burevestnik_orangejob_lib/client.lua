-- -- /* 
-- -- ██████╗░██╗░░░██╗██████╗░███████╗██╗░░░██╗███████╗░██████╗████████╗███╗░░██╗██╗██╗░░██╗
-- -- ██╔══██╗██║░░░██║██╔══██╗██╔════╝██║░░░██║██╔════╝██╔════╝╚══██╔══╝████╗░██║██║██║░██╔╝
-- -- ██████╦╝██║░░░██║██████╔╝█████╗░░╚██╗░██╔╝█████╗░░╚█████╗░░░░██║░░░██╔██╗██║██║█████═╝░
-- -- ██╔══██╗██║░░░██║██╔══██╗██╔══╝░░░╚████╔╝░██╔══╝░░░╚═══██╗░░░██║░░░██║╚████║██║██╔═██╗░
-- -- ██████╦╝╚██████╔╝██║░░██║███████╗░░╚██╔╝░░███████╗██████╔╝░░░██║░░░██║░╚███║██║██║░╚██╗
-- -- ╚═════╝░░╚═════╝░╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝╚═════╝░░░░╚═╝░░░╚═╝░░╚══╝╚═╝╚═╝░░╚═╝*/

RegisterNetEvent('bur_nui_orangejob_lib:open')
AddEventHandler('bur_nui_orangejob_lib:open', function()
    SendNUIMessage({showUI = true})
    SetNuiFocus(true,true)
    FreezeEntityPosition(PlayerPedId(), true)
end)

RegisterNUICallback('bur_exit_orangejob_lib', function(data)
    TriggerEvent('bur_nui_orangejob_lib:close')
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNetEvent('bur_nui_orangejob_lib:close')
AddEventHandler('bur_nui_orangejob_lib:close', function()
    SendNUIMessage({showUI = false; })
    SetNuiFocus(false,false)
end)                                                                                       

RegisterNUICallback('bur_buy_orangejob_lib', function(data)
    TriggerServerEvent('bur_orangejob_lib:buy', 1, Config.BuyOrange)
end)

RegisterNUICallback('bur_sell_orangejob_lib', function(data)
    while securityToken == nil do
        Wait(1)
    end
    TriggerServerEvent('bur_orangejob_lib:sell', 1, Config.SellOrange, securityToken)
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, false, -1)
end

if Config.UseBlips == true then
    Citizen.CreateThread(function()
        for i=1, #Config.Blips, 1 do
            Citizen.Wait(0)
            local Blip = Config.Blips[i]
            blip = AddBlipForCoord(Blip["x"], Blip["y"], Blip["z"])
            SetBlipSprite(blip, Blip["id"])
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Blip["scale"])
            SetBlipColour(blip, Blip["color"])
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Blip["text"])
            EndTextCommandSetBlipName(blip)
        end
    end)
end

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        Citizen.Wait(0)
        for i=1, #Config.Blips, 1 do
            local playerPed = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(playerPed, true))
            local Blips = Config.Blips[i]
            if GetDistanceBetweenCoords(x,y,z, Blips["x"], Blips["y"], Blips["z"], true) > 2.0 then
                IsPlayerNearObj = false
            else
                DisplayHelpText(Config.Translation['menu']) 
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('bur_nui_orangejob_lib:open') 
                end
            end
        end
	end 
end)

if Config.UseBlips == true then
    Citizen.CreateThread(function()
        for i=1, #Config.Orange, 1 do
            Citizen.Wait(100)
            local Blip = Config.Orange[i]
            blip = AddBlipForCoord(Blip["x"], Blip["y"], Blip["z"])
            SetBlipSprite(blip, Blip["id"])
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Blip["scale"])
            SetBlipColour(blip, Blip["color"])
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Blip["text"])
            EndTextCommandSetBlipName(blip)
        end
    end)
end


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local playerPed = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(playerPed, true))
        Citizen.Wait(0)
        for i=1, #Config.Orange, 1 do
            local Orange = Config.Orange[i]
            if GetDistanceBetweenCoords(x,y,z, Orange["x"], Orange["y"], Orange["z"], true) > 2.0 then
                IsPlayerNearObj = false
            else
                DisplayHelpText(Config.Translation['menu'])
                if Orange["done"] == true then 
                    DisplayHelpText(Config.Translation['collected']) 
                else 
                    if IsControlJustPressed(0, 38) then
                        Orange["done"] = true
                        TriggerEvent('bur_nui_orangejob:open')
                    end
                end
            end
        end
	end 
end)