RegisterNetEvent("govfunding:check")
AddEventHandler("govfunding:check", function(src)
    if not IsPedCuffed(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
        TriggerServerEvent("govfunding:getSaved")
    end
end)