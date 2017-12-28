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

RegisterNUICallback('performPoliceAction', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    local actionIndex = data.policeActionIndex
	local actionName = string.lower(data.policeActionName)
	local unseatIndex = string.lower(data.unseatIndex)
	Citizen.Trace("unseat index = " .. unseatIndex)
    TriggerEvent("interaction:performPoliceAction", actionName, unseatIndex)
end)

RegisterNUICallback('inventoryActionItemClicked', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    local actionName = data.actionName
	local itemName = data.itemName
	local wholeItem = data.wholeItem
	local targetPlayerId = data.playerId
	--Citizen.Trace("data.playerId = " .. data.playerId)
	if actionName and itemName and wholeItem and targetPlayerId then
		--Citizen.Trace("button name = " .. actionName .. ", item = " .. itemName)
		if actionName == "use" then
			interactionMenuUse(itemName, wholeItem)
		elseif actionName == "drop" then
			if not IsPedDeadOrDying(GetPlayerPed(-1), 1) and not IsPedCuffed(GetPlayerPed(-1)) then
				TriggerEvent("interaction:notify", "Dropping item: " .. removeQuantityFromItemName(itemName))
				TriggerServerEvent("interaction:dropItem", itemName)
			else
				print("player who was cuffed or dead was trying to drop an item!")
			end
		elseif string.find(actionName, "give") then
			TriggerServerEvent("interaction:giveItemToPlayer", wholeItem, targetPlayerId)
		end
	end
end)

function interactionMenuUse(itemName, wholeItem)
	-------------------
	-- Meth --
	-------------------
	if string.find(itemName, "Meth") then
		--Citizen.Trace("meth found to use!!")
		TriggerServerEvent("interaction:removeItemFromPlayer", itemName)
		TriggerEvent("interaction:notify", "You have used: (x1) Meth")
		intoxicate()
		reality()
	-------------------
	-- Repair Kit --
	-------------------
	elseif string.find(itemName, "Repair Kit") then
		TriggerEvent("interaction:repairVehicle")
	-------------------
	-- Cell Phone --
	-------------------
	elseif string.find(itemName, "Cell Phone") then
		print("Player is using a cell phone from the F1 menu with its number = " .. wholeItem.number)
		TriggerEvent("phone:openPhone", wholeItem)
	-------------------
	-- Food Item  --
	-------------------
	elseif wholeItem.type and wholeItem.type == "food" then
		print("Player used inventory item of type: food!")
		print("item name: " .. wholeItem.name)
		TriggerEvent("hungerAndThirst:replenish", "hunger", wholeItem)
	-------------------
	-- Drink Item  --
	-------------------
	elseif wholeItem.type and wholeItem.type == "drink" then
		print("Player used inventory item of type: drink!")
		print("item name: " .. wholeItem.name)
		TriggerEvent("hungerAndThirst:replenish", "drink", wholeItem)
	else
		TriggerEvent("interaction:notify", "There is no use action for that item!")
	end

end

RegisterNetEvent("interaction:ragdoll")
AddEventHandler("interaction:ragdoll", function()
	SetPedToRagdoll(GetPlayerPed(-1), 5500, 5500, 0, true, true, false);
end)

-- update players job for interaction menu
RegisterNetEvent("interaction:setPlayersJob")
AddEventHandler("interaction:setPlayersJob", function(playerJob)
	-- update interaction menu variable
    SendNUIMessage({
        type = "setPlayerJob",
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
        Citizen.Wait(0)
    end
end)

-- getting drunk / high effect
function intoxicate()
   TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, 1)
   Citizen.Wait(5000)
   DoScreenFadeOut(1000)
   Citizen.Wait(1000)
   ClearPedTasksImmediately(GetPlayerPed(-1))
   SetTimecycleModifier("spectator5")
   SetPedMotionBlur(GetPlayerPed(-1), true)
   SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
   SetPedIsDrunk(GetPlayerPed(-1), true)
   DoScreenFadeIn(1000)
 end

 function reality()
   Citizen.Wait(180000)
   DoScreenFadeOut(1000)
   Citizen.Wait(1000)
   DoScreenFadeIn(1000)
   ClearTimecycleModifier()
   ResetScenarioTypesEnabled()
   ResetPedMovementClipset(GetPlayerPed(-1), 0)
   SetPedIsDrunk(GetPlayerPed(-1), false)
   SetPedMotionBlur(GetPlayerPed(-1), false)
   -- Stop the mini mission
   Citizen.Trace("Going back to reality\n")
 end

 -- end drunk / high effect

 function removeQuantityFromItemName(itemName)
     if string.find(itemName,"%)") then
         local i = string.find(itemName, "%)")
         i = i + 2
         itemName = string.sub(itemName, i)
         --print("new item name = " .. itemName)
     end
     return itemName
 end

RegisterNetEvent("interaction:equipWeapon")
AddEventHandler("interaction:equipWeapon", function(item, equip)
	if equip then
		GiveWeaponToPed(GetPlayerPed(-1), item.hash, 1000, false, false)
	else
		RemoveWeaponFromPed(GetPlayerPed(-1), item.hash)
	end
end)
