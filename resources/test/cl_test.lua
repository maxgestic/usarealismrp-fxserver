local scenarios = {
	{name = "lean", scenarioName = "WORLD_HUMAN_LEANING"},
	{name = "cop", scenarioName = "WORLD_HUMAN_COP_IDLES"},
	{name = "sit", scenarioName = "WORLD_HUMAN_PICNIC"},
	{name = "chair", scenarioName = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER"},
	{name = "kneel", scenarioName = "CODE_HUMAN_MEDIC_KNEEL"},
	{name = "medic", scenarioName = "CODE_HUMAN_MEDIC_TEND_TO_DEAD"},
	{name = "notepad", scenarioName = "CODE_HUMAN_MEDIC_TIME_OF_DEATH"},
	{name = "traffic", scenarioName = "WORLD_HUMAN_CAR_PARK_ATTENDANT"},
	{name = "photo", scenarioName = "WORLD_HUMAN_PAPARAZZI"},
	{name = "clipboard", scenarioName = "WORLD_HUMAN_CLIPBOARD"},
	{name = "hangout", scenarioName = "WORLD_HUMAN_HANG_OUT_STREET"},
	{name = "pot", scenarioName = "WORLD_HUMAN_SMOKING_POT"},
	{name = "fish", scenarioName = "WORLD_HUMAN_STAND_FISHING"},
	{name = "phone", scenarioName = "WORLD_HUMAN_STAND_MOBILE"},
	{name = "yoga", scenarioName = "WORLD_HUMAN_YOGA"},
	{name = "bino", scenarioName = "WORLD_HUMAN_BINOCULARS"},
	{name = "cheer", scenarioName = "WORLD_HUMAN_CHEERING"},
	{name = "statue", scenarioName = "WORLD_HUMAN_HUMAN_STATUE"},
	{name = "jog", scenarioName = "WORLD_HUMAN_JOG_STANDING"},
	{name = "flex", scenarioName = "WORLD_HUMAN_MUSCLE_FLEX"},
	{name = "sit up", scenarioName = "WORLD_HUMAN_SIT_UPS"},
	{name = "push up", scenarioName = "WORLD_HUMAN_PUSH_UPS"},
	{name = "weld", scenarioName = "WORLD_HUMAN_WELDING"},
	{name = "mechanic", scenarioName = "WORLD_HUMAN_VEHICLE_MECHANIC"},
	{name = "smoke", scenarioName = "WORLD_HUMAN_SMOKING"},
	{name = "drink", scenarioName = "WORLD_HUMAN_DRINKING"},
	{name = "bum 1", scenarioName = "WORLD_HUMAN_BUM_FREEWAY"},
    {name = "bum 2", scenarioName = "WORLD_HUMAN_BUM_SLUMPED"},
    {name = "bum 3", scenarioName = "WORLD_HUMAN_BUM_STANDING"},
    {name = "bum 4", scenarioName = "WORLD_HUMAN_BUM_WASH"},
    {name = "drill", scenarioName = "WORLD_HUMAN_CONST_DRILL"},
    {name = "blower", scenarioName = "WORLD_HUMAN_GARDENER_LEAF_BLOWER"},
    {name = "chillin'", scenarioName = "WORLD_HUMAN_DRUG_DEALER_HARD"},
	{name = "mobile film", scenarioName = "WORLD_HUMAN_MOBILE_FILM_SHOCKING"},
	{name = "planting", scenarioName = "WORLD_HUMAN_GARDENER_PLANT"},
	{name = "golf", scenarioName = "WORLD_HUMAN_GOLF_PLAYER"},
	{name = "hammer", scenarioName = "WORLD_HUMAN_HAMMERING"},
	{name = "clean", scenarioName = "WORLD_HUMAN_MAID_CLEAN"},
	{name = "musician", scenarioName = "WORLD_HUMAN_MUSICIAN"},
	{name = "party", scenarioName = "WORLD_HUMAN_PARTYING"},
	{name = "prostitute", scenarioName = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}
}

RegisterNUICallback('escape', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
end)

RegisterNUICallback('showPhone', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    TriggerServerEvent("interaction:checkForPhone")
end)

RegisterNUICallback('loadInventory', function(data, cb)
    Citizen.Trace("inventory loading...")
    TriggerServerEvent("interaction:loadInventoryForInteraction")
end)

RegisterNUICallback('playEmote', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    --Citizen.Trace("inside of NUI callback with emote: " .. data.emoteName)
    local scenarioName = data.emoteName
    if scenarioName == "cancel" then
		local ped = GetPlayerPed(-1)
		ClearPedTasks(ped)
		playing_emote = false
		return
	end
	for i = 1, #scenarios do
		if scenarioName == scenarios[i].name then
			Citizen.Trace("found scenario match for: " .. scenarioName)
			local ped = GetPlayerPed(-1)
			if ped then
				TaskStartScenarioInPlace(ped, scenarios[i].scenarioName, 0, true);
				playing_emote = true
			end
		end
	end
end)

RegisterNUICallback('setVoipLevel', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    --Citizen.Trace("setting voice level = " .. data.level)
    local YELL, NORMAL, WHISPER = 0,1,2
    local selected = data.level
    if selected == YELL then
        TriggerEvent("voip", "yell")
    elseif selected == NORMAL then
        TriggerEvent("voip","default")
    elseif selected == WHISPER then
        TriggerEvent("voip","whisper")
    end
end)

RegisterNUICallback('checkPlayerJob', function(data, cb)
    TriggerServerEvent("interaction:checkPlayerJob")
end)

RegisterNUICallback('performPoliceAction', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    local actionIndex = data.policeActionIndex
    if actionIndex == 0 then
        TriggerEvent("interaction:performPoliceAction", "cuff")
    end
end)

RegisterNetEvent("interaction:sendPlayersJob")
AddEventHandler("interaction:sendPlayersJob", function(playerJob)
    SendNUIMessage({
        type = "receivedPlayerJob",
        job = playerJob
    })
end)

RegisterNetEvent("interaction:notify")
AddEventHandler("interaction:notify", function(msg)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

RegisterNetEvent("interaction:playerHadPhone")
AddEventHandler("interaction:playerHadPhone", function()
    TriggerEvent("phone:openPhone")
end)

RegisterNetEvent("interaction:inventoryLoaded")
AddEventHandler("interaction:inventoryLoaded", function(inventory, weapons, licenses)
    --Citizen.Trace("inventory loaded...")
    SendNUIMessage({
        type = "inventoryLoaded",
        inventory = inventory,
        weapons = weapons,
        licenses = licenses
    })
end)

Citizen.CreateThread(function()
    while true do
        -- cancel emote when walking forward
       if IsControlJustPressed(1, 32) then -- INPUT_MOVE_UP_ONLY
           local ped = GetPlayerPed(-1)
           ClearPedTasks(ped);
           playing_emote = false
       end
        if menuEnabled then
            DisableControlAction(29, 241, menuEnabled) -- scroll up
            DisableControlAction(29, 242, menuEnabled) -- scroll down
            DisableControlAction(0, 1, menuEnabled) -- LookLeftRight
            DisableControlAction(0, 2, menuEnabled) -- LookUpDown
            DisableControlAction(0, 142, menuEnabled) -- MeleeAttackAlternate
            DisableControlAction(0, 106, menuEnabled) -- VehicleMouseControlOverride
            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)
