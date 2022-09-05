-- -- /* 
-- -- ██████╗░██╗░░░██╗██████╗░███████╗██╗░░░██╗███████╗░██████╗████████╗███╗░░██╗██╗██╗░░██╗
-- -- ██╔══██╗██║░░░██║██╔══██╗██╔════╝██║░░░██║██╔════╝██╔════╝╚══██╔══╝████╗░██║██║██║░██╔╝
-- -- ██████╦╝██║░░░██║██████╔╝█████╗░░╚██╗░██╔╝█████╗░░╚█████╗░░░░██║░░░██╔██╗██║██║█████═╝░
-- -- ██╔══██╗██║░░░██║██╔══██╗██╔══╝░░░╚████╔╝░██╔══╝░░░╚═══██╗░░░██║░░░██║╚████║██║██╔═██╗░
-- -- ██████╦╝╚██████╔╝██║░░██║███████╗░░╚██╔╝░░███████╗██████╔╝░░░██║░░░██║░╚███║██║██║░╚██╗
-- -- ╚═════╝░░╚═════╝░╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝╚═════╝░░░░╚═╝░░░╚═╝░░╚══╝╚═╝╚═╝░░╚═╝*/

RegisterNetEvent('bur_nui_orangejob:open')
AddEventHandler('bur_nui_orangejob:open', function()
    SendNUIMessage({showUI = true})
    SetNuiFocus(true,true)
    FreezeEntityPosition(PlayerPedId(), true)
    animationPlay("anim@heists@ornate_bank@grab_cash", "intro")
end)

RegisterNUICallback('bur_exit_orangejob', function(data)
    TriggerEvent('bur_nui_orangejob:close')
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNetEvent('bur_nui_orangejob:close')
AddEventHandler('bur_nui_orangejob:close', function()
    SendNUIMessage({showUI = false; })
    SetNuiFocus(false,false)
end)                                                                                       

RegisterNUICallback('bur_done_orangejob', function(data)
    orange = data.orange
    ClearPedTasks(PlayerPedId())
    while securityToken == nil do
        Wait(1)
    end
    TriggerServerEvent('bur_orangejob:item', orange, securityToken)
end)

function animationPlay(ad,an)
    Citizen.CreateThread(function()
        ClearPedTasks(PlayerPedId())
        SetCurrentPedWeapon(PlayerPedId(), `weapon_unarmed`, true)
        RequestAnimDict(ad)
        while (not HasAnimDictLoaded(ad)) do Citizen.Wait(0) end
        TaskPlayAnim(PlayerPedId(), ad, an, 1.0, -1.0, 2000, 48, 1, false, false, false )
        TaskPlayAnim(PlayerPedId(), ad, an, 8.0, -1, -1, 50, 0, false, false, false )
    end)
end