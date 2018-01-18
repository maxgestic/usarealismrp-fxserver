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

local player = {
	BAC = 0.00
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

RegisterNUICallback('getVehicleInventory', function(data, cb)
	Citizen.Trace("vehicle inventory loading...")
		print("plate #: " .. data.target_vehicle_plate)
	TriggerServerEvent("interaction:loadVehicleInventoryForInteraction", data.target_vehicle_plate)
		--SetVehicleDoorOpen(data.target_vehicle.id, 5, false, false) -- experimental
end)

-- this is called when the player clicks "retrieve" in the interaction menu on a vehicle inventory item
RegisterNUICallback('retrieveVehicleItem', function(data, cb)
	TriggerEvent("test:escapeFromCSharp")
	local target_vehicle_plate = data.target_vehicle_plate
	local target_item = data.wholeItem
	local current_job = data.current_job
	--print("current_job: " .. current_job)
	local facing_vehicle = getVehicleInFrontOfUser()
	if (facing_vehicle ~= 0 and GetVehicleDoorLockStatus(facing_vehicle) ~= 2) or current_job == "police" then
		-- If item.type == "weapon" then check if player has < 3 weapons:
		if target_item.type == "weapon" then
			TriggerServerEvent("vehicle:checkPlayerWeaponAmount", target_item, target_vehicle_plate)
		else
			-- Get quantity to transfer from user input:
			Citizen.CreateThread( function()
				DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
				while true do
					if ( UpdateOnscreenKeyboard() == 1 ) then
						local input_amount = GetOnscreenKeyboardResult()
						if ( string.len( input_amount ) > 0 ) then
							local amount = tonumber( input_amount )
							if ( amount > 0 ) then
								-- play animation:
								local anim = {
									dict = "anim@move_m@trash",
									name = "pickup"
								}
								TriggerEvent("usa:playAnimation", anim.name, anim.dict, 4)
									-- see if item is able to be removed:
									amount = round(amount, 0)
									local quantity_to_transfer = amount
									if quantity_to_transfer <= target_item.quantity then
										print("seeing if item is still in vehicle...")
										TriggerServerEvent("vehicle:isItemStillInVehicle", target_vehicle_plate, target_item, quantity_to_transfer)
									else
										TriggerEvent("usa:notify", "Quantity input too high!")
									end
								end
							break
						else
							DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
						end
					elseif ( UpdateOnscreenKeyboard() == 2 ) then
						break
					end
				Citizen.Wait( 0 )
				end
			end )
		end
	else
		TriggerEvent("usa:notify", "Can't retrieve item. Vehicle is locked.")
	end
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
		elseif actionName == "store" then
			-- Get quantity to transfer from user input:
			Citizen.CreateThread( function()
				DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
				while true do
					if ( UpdateOnscreenKeyboard() == 1 ) then
						local input_amount = GetOnscreenKeyboardResult()
						if ( string.len( input_amount ) > 0 ) then
							local amount = tonumber( input_amount )
							if ( amount > 0 ) then
								-- trigger server event to remove money
								amount = round(amount, 0)
								local quantity_to_transfer = amount
								if quantity_to_transfer <= wholeItem.quantity then
									TriggerEvent("vehicle:checkTargetVehicleForStorage", wholeItem, quantity_to_transfer)
								end
							end
							break
						else
							DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
						end
					elseif ( UpdateOnscreenKeyboard() == 2 ) then
						break
					end
					Citizen.Wait( 0 )
				end
			end )
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
		intoxicate(true, nil)
		reality(5)
	-------------------
	-- Hash --
	-------------------
	elseif string.find(itemName, "Hash") then
		--Citizen.Trace("meth found to use!!")
		TriggerServerEvent("interaction:removeItemFromPlayer", itemName)
		TriggerEvent("interaction:notify", "You have used: (x1) Hash")
		intoxicate(true, nil)
		reality(3)
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
	---------------------------
	-- Alcoholic Drink Item  --
	---------------------------
	elseif wholeItem.type and wholeItem.type == "alcohol" then
		print("Player used inventory item of type: alcohol!")
		print("item name: " .. wholeItem.name)
		TriggerEvent("hungerAndThirst:replenish", "drink", wholeItem)
		print("old player BAC: " .. player.BAC)
		player.BAC = player.BAC + wholeItem.strength
		print("new player BAC: " .. player.BAC)
		if player.BAC >= 0.12 then
			intoxicate(false, "MOVE_M@DRUNK@VERYDRUNK")
			reality(4)
		elseif player.BAC >= 0.08 then
			intoxicate(false, "MOVE_M@DRUNK@MODERATEDRUNK")
			reality(7)
		elseif player.BAC >= 0.04 then
			intoxicate(false, "MOVE_M@DRUNK@SLIGHTLYDRUNK")
			reality(10)
		end
	else
		TriggerEvent("interaction:notify", "There is no use action for that item!")
	end
end

Citizen.CreateThread(function()
	local timer = 600000
	local decrement_amount = 0.03
	while true do
		if player.BAC > 0.00 then
			local new_BAC = player.BAC - decrement_amount
			if new_BAC >= 0.00 then
				print("decrementing BAC! now at: " .. new_BAC)
				player.BAC = new_BAC
			else
				player.BAC = 0.00
			end
		else
			print("player BAC was not >= 0.00")
		end
		Wait(timer) -- every x seconds, decrement player.BAC
	end
end)

RegisterNetEvent("breathalyze:breathalyzePerson")
AddEventHandler("breathalyze:breathalyzePerson", function(source)
	TriggerEvent("usa:notify", "You are being breathalyzed.")
	TriggerServerEvent("breathalyze:receivedResults", player.BAC, source)
end)

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
	SendNUIMessage({
		type = "inventoryLoaded",
		inventory = inventory,
		weapons = weapons,
		licenses = licenses
	})
end)

RegisterNetEvent("interaction:vehicleInventoryLoaded")
AddEventHandler("interaction:vehicleInventoryLoaded", function(inventory)
	print("client received vehicle inventory... sending NUI message")
	if inventory then print("#inventory: " .. #inventory) end
	SendNUIMessage({
		type = "vehicleInventoryLoaded",
		vehicle_inventory = inventory
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
function intoxicate(playScenario, clipset)
	if playScenario then
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, 1)
	end
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(GetPlayerPed(-1), true)
		if clipset then
		print("setting movement clipset to: " .. clipset)
		ResetPedMovementClipset(GetPlayerPed(-1), 0)
		RequestAnimSet( clipset )
		while ( not HasAnimSetLoaded( clipset ) ) do
			Citizen.Wait( 1 )
		end
		SetPedMovementClipset(GetPlayerPed(-1), clipset, 0.25)
	end
	SetPedIsDrunk(GetPlayerPed(-1), true)
	DoScreenFadeIn(1000)
 end

 function reality(minutes)
	minutes = minutes * 60 * 1000
	Citizen.Wait(minutes)
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

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function getVehicleInFrontOfUser()
	local playerped = GetPlayerPed(-1)
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end
