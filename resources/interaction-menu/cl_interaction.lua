local MENU_KEY1 = 244
local MENU_KEY2 = 288
local TACKLE_KEY = 101

local scenarios = {
	{name = "cancel", type = "cancel", dict = "", animname = ""},
	{name = "stop", type = "cancel", dict = "", animname = ""},
	{name = "lean", scenarioName = "WORLD_HUMAN_LEANING"},
	{name = "cop", scenarioName = "WORLD_HUMAN_COP_IDLES"},
	{name = "sit", scenarioName = "WORLD_HUMAN_PICNIC"},
	--{name = "chair", scenarioName = "PROP_HUMAN_SEAT_CHAIR"},
	{name = "cross arms", type = "emote", dict = "amb@world_human_hang_out_street@female_arms_crossed@base", animname = "base"},
	{name = "kneel", scenarioName = "CODE_HUMAN_MEDIC_KNEEL"},
	{name = "notepad", type = "emote", dict = "amb@medic@standing@timeofdeath@base", animname = "base"},
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
	--{name = "smoke", scenarioName = "WORLD_HUMAN_SMOKING"},
	{name = "smoke", type = "emote", dict = "amb@world_human_aa_smoke@male@idle_a", animname = "idle_c"},
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
	{name ="prone", scenarioName = "WORLD_HUMAN_SUNBATHE"},
	{name = "prostitute", scenarioName = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"},
	{name = "hug", type = "emote", dict = "mp_ped_interaction", animname = "hugs_guy_a"},
	{name = "fist bump", type = "emote", dict = "anim@mp_player_intcelebrationpaired@f_f_fist_bump", animname = "fist_bump_right"},
	{name = "high five", type = "emote", dict = "mp_ped_interaction", animname = "highfive_guy_a"},
	{name = "shag 1", type = "emote", dict = "misscarsteal2pimpsex", animname = "shagloop_pimp"},
	{name = "shag 2", type = "emote", dict = "misscarsteal2pimpsex", animname = "shagloop_hooker"},
	{name = "shag 3", type = "emote", dict = "misscarsteal2pimpsex", animname = "pimpsex_hooker"},
	{name = "wave", type = "emote", dict = "gestures@m@standing@casual", animname = "gesture_hello", cancelTime = 0.9},
	{name = "dance 1", type = "emote", dict = "mini@strip_club@private_dance@part1", animname = "priv_dance_p1"},
	{name = "dance 2", type = "emote", dict = "mini@strip_club@private_dance@part2", animname = "priv_dance_p2"},
	{name = "dance 3", type = "emote", dict = "mini@strip_club@private_dance@part3", animname = "priv_dance_p3"},
	{name = "whatup", type = "emote", dict = "friends@laf@ig_5", animname = "whatupnigga"},
	{name = "kiss", type = "emote", dict = "mp_ped_interaction", animname = "kisses_guy_a"},
	{name = "handshake", type = "emote", dict = "mp_ped_interaction", animname = "handshake_guy_a"},
	{name = "cpr", type = "emote", dict = "mini@cpr@char_a@cpr_str", animname = "cpr_pumpchest"},
	{name = "cross arms", type = "emote", dict = "amb@world_human_hang_out_street@female_arms_crossed@base", animname = "base"},
	{name = "dance 4", type = "emote", dict = "rcmnigel1bnmt_1b", animname = "dance_loop_tyler"},
	{name = "dance 5", type = "emote", dict = "missfbi3_sniping", animname =  "dance_m_default"},
	{name = "peace", type = "emote", dict = "mp_player_int_upperpeace_sign", animname = "mp_player_int_peace_sign"},
	{name = "gang 1", type = "emote", dict = "mp_player_int_uppergang_sign_a", animname =  "mp_player_int_gang_sign_a"},
	{name = "gang 2", type = "emote", dict = "mp_player_int_uppergang_sign_b", animname =  "mp_player_int_gang_sign_b"},
	{name = "damn", type = "emote", dict = "gestures@m@standing@casual", animname =  "gesture_damn", cancelTime = 1.5},
	{name = "salute", type = "emote", dict = "anim@mp_player_intuppersalute", animname = "idle_a"}
	--{name = "hug", type = "emote", dict = "", animname = ""},
}

--amb@prop_human_seat_chair@female@arms_folded@idle_a
--idle_a

--mp_safehousevagos@boss
--vagos_boss_keyboard_a

--amb@prop_human_seat_computer@male@base
--base

--
--this._pumpAndIdleMedic.get_AddTask().PlayAnimation("mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8f, 1000, true, 8f);
--this._pumpAndIdleMedic.get_AddTask().PlayAnimation("mini@cpr@char_a@cpr_def", "cpr_pumpchest_idle", 8f, 100000, true, 8f);
--

--[[
	Game.get_Player().get_Character().TaskPlayAnim("mp_ped_interaction", "handshake_guy_a", 8, -1);

	Game.get_Player().get_Character().PlayAmbientSpeech("DRAW_GUN", true);
--]]

local spawned_object = nil
local playing_scenario = false
local playing_anim = nil
local left_hand = 60309
local right_hand = 58868

local player = {
	BAC = 0.00
}

local playerPed, targetPed
local playerPedCoords, targetPedCoords, offsetCoords
local distanceToTargetPed = 0.0
local distanceToClosestTargetPed = 0.0
local rayHandle
local didHit
local hitCoords, hitSurfaceCoords
local hitHandlePed
local hitHandleVehicle = 0
local playerServerId = 0
local playerName = ""
local raycastResult = 0
local voipLevel = 0.0
local menuEnabled = false -- F1 menu gui

RegisterNUICallback('escape', function(data, cb)
	--TriggerEvent("test:escapeFromCSharp")
	--print("inside of escape calling disable gui....")
	DisableGui()
end)

RegisterNUICallback('showPhone', function(data, cb)
	--TriggerEvent("test:escapeFromCSharp")
	--print("inside of SHOW PHONE calling disable gui....")
	DisableGui()
	TriggerServerEvent("interaction:checkForPhone")
end)

RegisterNUICallback('loadInventory', function(data, cb)
	--Citizen.Trace("inventory loading...")
	TriggerServerEvent("interaction:loadInventoryForInteraction")
end)

RegisterNUICallback('getVehicleInventory', function(data, cb)
	--Citizen.Trace("vehicle inventory loading...")
		print("plate #: " .. data.target_vehicle_plate)
	TriggerServerEvent("interaction:loadVehicleInventoryForInteraction", data.target_vehicle_plate)
		--SetVehicleDoorOpen(data.target_vehicle.id, 5, false, false) -- experimental
end)

-- this is called when the player clicks "retrieve" in the interaction menu on a vehicle inventory item
RegisterNUICallback('retrieveVehicleItem', function(data, cb)
	--TriggerEvent("test:escapeFromCSharp")
	DisableGui()
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
							amount = math.floor(amount, 0)
							if ( amount > 0 ) then
								-- play animation:
								local anim = {
									dict = "anim@move_m@trash",
									name = "pickup"
								}
								-- see if item is able to be removed:
								local quantity_to_transfer = amount
								if quantity_to_transfer <= target_item.quantity then
									--print("seeing if item is still in vehicle...")
									TriggerServerEvent("vehicle:isItemStillInVehicle", target_vehicle_plate, target_item, quantity_to_transfer)
									--TriggerEvent("usa:playAnimation", anim.name, anim.dict, 4)
									--TriggerEvent("usa:playAnimation", anim.dict, anim.name, 5, 1, 4000, 31, 0, 0, 0, 0)
									TriggerEvent("usa:playAnimation", anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0,  4)
								else
									TriggerEvent("usa:notify", "Quantity input too high!")
								end
							else
								TriggerEvent("usa:notify", "Quantity input too low!")
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
	local ped = GetPlayerPed(-1)
	ClearPedTasksImmediately(ped)
	playing_anim = false
	playing_scenario = false
	-----------------
	-- shut GUI --
	-----------------
	DisableGui()
	----------------------------------------------------------------
	-- remove any objects for animiations if applicable --
	----------------------------------------------------------------
	if spawned_object then
		RemovePedObject()
		playing_anim = nil
	end
	-------------------------------
	-- play anim / scenario  --
	-------------------------------
	local scenarioName = data.emoteName
		if scenarioName == "cancel" scenarioName == "stop" then
			playing_scenario = false
			playing_anim = nil
			return
		elseif scenarioName == "surrender" then
			TriggerEvent("KneelHU")
			playing_scenario = true
			return
		elseif scenarioName == "mechanic" or scenarioName == "sit" or scenarioName == "drill" or scenarioName == "chillin'" or scenarioName == "golf" then
			TriggerServerEvent("interaction:checkJailedStatusBeforeEmote", scenarioName)
			playing_scenario = true
			return
		end
		for i = 1, #scenarios do
			if scenarioName == string.lower(scenarios[i].name) then
				if ped then
					if scenarios[i].type ~= "emote" then
						TaskStartScenarioInPlace(ped, scenarios[i].scenarioName, 0, true)
						playing_scenario = true
					elseif scenarios[i].type == "emote" then
						if string.find(scenarioName, "shag") or string.find(scenarioName, "dance") then
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5, true, flag)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 7, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 7, 0, 0, 0, 0)
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 7
							}
						elseif string.find(scenarioName, "cpr") or string.find(scenarioName, "cross arms") then
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5, true)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 31, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 53, 0, 0, 0, 0)
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 53
							}
						elseif string.find(scenarioName, "notepad") then
							-----------------------------
							-- give notepad object --
							-----------------------------
							GivePedObject(left_hand, "prop_notepad_01")
							---------------------------
							-- play notepad anim --
							---------------------------
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5, true)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 31, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 53, 0, 0, 0, 0)
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 53
							}
						elseif string.find(scenarioName, "smoke") then
							-------------------------------
							-- give cigarrette object --
							-------------------------------
							GivePedObject(right_hand, "prop_cs_ciggy_01", 0.05, 0.00, 0.02, -270.0, 90.0, 0.0)
							-----------------------------
							-- play smoking anim --
							-----------------------------
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5, true)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 31, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 53, 0, 0, 0, 0)
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 53
							}
						else
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 31, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 53, 0, 0, 0, 0, 4)
							if scenarios[i].cancelTime then
								Wait(scenarios[i].cancelTime * 1000)
								ClearPedTasksImmediately(GetPlayerPed(-1))
							end
							--[[
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 53
							}
							--]]
						end
					elseif scenarios[i].type =="cancel" then
						playing_scenario = false
						playing_anim = nil
						ClearPedTasksImmediately(GetPlayerPed(-1))
					end
				end
			end
		end
end)

RegisterNetEvent("emotes:playEmote")
AddEventHandler("emotes:playEmote", function(scenarioName)
	scenarioName = string.lower(scenarioName)
	local ped = GetPlayerPed(-1)
	ClearPedTasksImmediately(ped)
	playing_anim = false
	playing_scenario = false
	----------------------------------------------------------------
	-- remove any objects for animiations if applicable --
	----------------------------------------------------------------
	if spawned_object then
		RemovePedObject()
		playing_anim = nil
	end
	-------------------------------
	-- play anim / scenario  --
	-------------------------------
		if scenarioName == "cancel" then
			playing_scenario = false
			playing_anim = nil
			return
		elseif scenarioName == "surrender" then
			TriggerEvent("KneelHU")
			playing_scenario = true
			return
		elseif scenarioName == "mechanic" or scenarioName == "sit" or scenarioName == "drill" or scenarioName == "chillin'" or scenarioName == "golf" then
			TriggerServerEvent("interaction:checkJailedStatusBeforeEmote", scenarioName)
			playing_scenario = true
			return
		end
		for i = 1, #scenarios do
			--if string.find(scenarios[i].name, scenarioName) then
			if scenarioName == string.lower(scenarios[i].name) then
				if ped then
					if scenarios[i].type ~= "emote" then
						TaskStartScenarioInPlace(ped, scenarios[i].scenarioName, 0, true)
						playing_scenario = true
					else
						if string.find(scenarioName, "shag") or string.find(scenarioName, "dance") then
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5, true, flag)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 7, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 7, 0, 0, 0, 0)
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 7
							}
						elseif string.find(scenarioName, "cpr") or string.find(scenarioName, "cross arms") then
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5, true)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 31, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 53, 0, 0, 0, 0)
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 53
							}
						elseif string.find(scenarioName, "notepad") then
							-----------------------------
							-- give notepad object --
							-----------------------------
							GivePedObject(left_hand, "prop_notepad_01")
							---------------------------
							-- play notepad anim --
							---------------------------
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5, true)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 31, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 53, 0, 0, 0, 0)
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 53
							}
						elseif string.find(scenarioName, "smoke") then
							-------------------------------
							-- give cigarrette object --
							-------------------------------
							GivePedObject(right_hand, "prop_cs_ciggy_01", 0.05, 0.00, 0.02, -270.0, 90.0, 0.0)
							-----------------------------
							-- play smoking anim --
							-----------------------------
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5, true)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 31, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 53, 0, 0, 0, 0)
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 53
							}
						else
							--TriggerEvent("usa:playAnimation", scenarios[i].animname, scenarios[i].dict, false, 6.5)
							--TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, 5, 1, 1000, 31, 0, 0, 0, 0)
							TriggerEvent("usa:playAnimation", scenarios[i].dict, scenarios[i].animname, -8, 1, -1, 53, 0, 0, 0, 0, 4)
							if scenarios[i].cancelTime then
								Wait(scenarios[i].cancelTime * 1000)
								ClearPedTasksImmediately(GetPlayerPed(-1))
							end
							--[[
							playing_anim = {
								dict = scenarios[i].dict,
								name = scenarios[i].animname,
								flag = 53
							}
							--]]
						end
					end
				end
			end
		end
end)

RegisterNetEvent("emotes:showHelp")
AddEventHandler("emotes:showHelp", function()
	local msg = "^3Options: ^0"
	for i = 1, #scenarios do
		if i == #scenarios then
			msg = msg .. scenarios[i].name
		else
			msg = msg .. scenarios[i].name .. ", "
		end
	end
	TriggerEvent("chatMessage", "", {255, 255, 255}, msg)
end)

function GivePedObject(target_bone, object, x, y, z, rotX, rotY, rotZ)
	object = GetHashKey(object)
	local ped = GetPlayerPed(-1)
	local coords = GetEntityCoords(ped)
    local bone = GetPedBoneIndex(ped, target_bone)
  	RequestModel(object)
  	while not HasModelLoaded(object) do
  		Citizen.Wait(100)
  	end
  	spawned_object = CreateObject(object, coords.x, coords.y, coords.z, 1, 1, 0)
	if rotX and rotY and rotZ and x and y and z then
  		AttachEntityToEntity(spawned_object, ped, bone, x, y, z, rotX, rotY, rotZ, 1, 1, 0, 0, 2, 1)
	else
		AttachEntityToEntity(spawned_object, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	end
end

function RemovePedObject()
	DeleteObject(spawned_object)
	spawned_object = nil
end

RegisterNUICallback('setVoipLevel', function(data, cb)
	DisableGui()
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

RegisterNUICallback('openVehicleDoor', function(data, cb)
	DisableGui()
	local name = string.lower(data.name)
	if name == "hood" then
		TriggerEvent("veh:openDoor", name)
	elseif name == "trunk" then
		TriggerEvent("veh:openDoor", name)
	elseif name == "f left" then
		TriggerEvent("veh:openDoor", "fl")
	elseif name == "f right" then
		TriggerEvent("veh:openDoor", "fr")
	elseif name == "b left" then
		TriggerEvent("veh:openDoor", "bl")
	elseif name == "b right" then
		TriggerEvent("veh:openDoor", "br")
	end
end)

RegisterNUICallback('closeVehicleDoor', function(data, cb)
	DisableGui()
	local name = string.lower(data.name)
	if name == "hood" then
		TriggerEvent("veh:shutDoor", name)
	elseif name == "trunk" then
		TriggerEvent("veh:shutDoor", name)
	elseif name == "f left" then
		TriggerEvent("veh:shutDoor", "fl")
	elseif name == "f right" then
		TriggerEvent("veh:shutDoor", "fr")
	elseif name == "b left" then
		TriggerEvent("veh:shutDoor", "bl")
	elseif name == "b right" then
		TriggerEvent("veh:shutDoor", "br")
	end
end)

RegisterNUICallback('doVehicleAction', function(data, cb)
	DisableGui()
	local name = string.lower(data.name)
	if name == "engine" then
		TriggerEvent("veh:toggleEngine")
	elseif name == "hood" then
		TriggerEvent("veh:toggleDoor", name)
	elseif name == "trunk" then
		TriggerEvent("veh:toggleDoor", name)
	elseif name == "f left" then
		TriggerEvent("veh:toggleDoor", "fl")
	elseif name == "f right" then
		TriggerEvent("veh:toggleDoor", "fr")
	elseif name == "b left" then
		TriggerEvent("veh:toggleDoor", "bl")
	elseif name == "b right" then
		TriggerEvent("veh:toggleDoor", "br")
	end
end)

RegisterNUICallback('performPoliceAction', function(data, cb)
	DisableGui()
	local actionIndex = data.policeActionIndex
	local actionName = string.lower(data.policeActionName)
	local unseatIndex = string.lower(data.unseatIndex)
	TriggerEvent("interaction:performPoliceAction", actionName, unseatIndex)
end)

RegisterNUICallback('inventoryActionItemClicked', function(data, cb)
	DisableGui()
  local actionName = data.actionName
	local itemName = data.itemName
	local wholeItem = data.wholeItem
	local targetPlayerId = data.playerId
	if actionName and itemName and wholeItem and targetPlayerId then
		if actionName == "use" then
			interactionMenuUse(itemName, wholeItem)
		elseif actionName == "drop" then
			if not string.find(itemName, "Driver") and not string.find(itemName, "Firearm") then
				if not IsPedDeadOrDying(GetPlayerPed(-1), 1) and not IsPedCuffed(GetPlayerPed(-1)) then
					local pos = GetEntityCoords(GetPlayerPed(-1), true)
					TriggerServerEvent("interaction:dropItem", itemName, pos.x, pos.y, pos.z)
				else
					print("player who was cuffed or dead was trying to drop an item!")
				end
			else
				print("can't drop DL or firearm permit!!")
			end
		elseif string.find(actionName, "give") then
			if not string.find(itemName, "Driver") then
				TriggerServerEvent("interaction:giveItemToPlayer", wholeItem, targetPlayerId)
			else
				print("can't give DL!!")
			end
		elseif actionName == "store" then
			if not string.find(itemName, "Driver") then
				-- Get quantity to transfer from user input:
				Citizen.CreateThread( function()
					DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
					while true do
						if ( UpdateOnscreenKeyboard() == 1 ) then
							local input_amount = GetOnscreenKeyboardResult()
							if ( string.len( input_amount ) > 0 ) then
								local amount = tonumber( input_amount )
								amount = math.floor(amount, 0)
								if ( amount > 0 ) then
									-- trigger server event to remove money
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
			else
				print("can't store DL!!")
			end
		end
	end
end)

function interactionMenuUse(itemName, wholeItem)
	Citizen.CreateThread(function()
		-------------------
		-- Meth --
		-------------------
		if string.find(itemName, "Meth") or string.find(itemName, "Uncut Cocaine") then
			--Citizen.Trace("meth found to use!!")
			TriggerServerEvent("interaction:removeItemFromPlayer", itemName)
			TriggerEvent("interaction:notify", "You have used: (x1) " .. itemName:sub(6))
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
		---------------
		-- Jerry Can --
		---------------
	elseif string.find(itemName, "Jerry Can") then
		local JERRY_CAN_ANIMATION = {
			dict = "weapon@w_sp_jerrycan",
			name = "fire"
		}

		RequestAnimDict(JERRY_CAN_ANIMATION.dict)
		while not HasAnimDictLoaded(JERRY_CAN_ANIMATION.dict) do
			Wait(100)
		end

		if tonumber(hitHandleVehicle) ~= 0 then
			local jcan = 883325847
			GiveWeaponToPed(GetPlayerPed(-1), jcan, 20, false, true) -- easiest way to remove jerry can object off back when using it (from weapons-on-back resource)
			Wait(1000)
			-- put jerry can object in hand --
			--local can_prop = AttachEntityToPed('prop_ld_jerrycan_01', 36029, 0, 0, 0, 90.0, 90.0, 85.0)
			--local can_prop_net_id = AttachEntityToPed('prop_ld_jerrycan_01', 36029, 0, 0, 0, 3.0, 173.0, 0.0)
			-- play anim --
			--TriggerEvent("usa:playAnimation", JERRY_CAN_ANIMATION.name, JERRY_CAN_ANIMATION.dict, false, 6.5, true)
			--TriggerEvent("usa:playAnimation", JERRY_CAN_ANIMATION.dict, JERRY_CAN_ANIMATION.name, 5, 1, 25000, 31, 0, 0, 0, 0)
			TriggerEvent("usa:playAnimation", JERRY_CAN_ANIMATION.dict, JERRY_CAN_ANIMATION.name, -8, 1, -1, 53, 0, 0, 0, 0, 24.5)
			Wait(25000)
			ClearPedTasksImmediately(GetPlayerPed(-1))
			-- refuel --
			TriggerServerEvent("essence:refuelWithJerryCan", exports.es_AdvancedFuel:getEssence(), GetVehicleNumberPlateText(hitHandleVehicle), GetDisplayNameFromVehicleModel(GetEntityModel(hitHandleVehicle)))
			-- remove jerry can object from hand --
			--DeleteEntity(NetToObj(can_prop_net_id))
			-- remove jerry can weapon from inventory --
			TriggerServerEvent("usa:removeItem", wholeItem, 1)
		else
			TriggerEvent("usa:notify", "No vehicle found!")
		end
		-------------------
		-- First Aid Kit --
		-------------------
		elseif string.find(itemName, "First Aid Kit") then
			TriggerEvent("usa:heal", 35)
			TriggerServerEvent("usa:removeItem", wholeItem, 1)
		-------------------
		-- Lockpick  --
		-------------------
	elseif string.find(itemName, "Lock Pick") then
			local me = GetPlayerPed(-1)
			local veh = getVehicleInFrontOfUser()
			if veh ~= 0 then
				if GetVehicleDoorLockStatus(veh) ~= 1 then
					local start_time = GetGameTimer()
					local duration = 20000
					-- play animation:
			    local anim = {
			      dict = "anim@move_m@trash",
			      name = "pickup"
			    }
				RequestAnimDict(anim.dict)
	            while not HasAnimDictLoaded(anim.dict) do
					Citizen.Wait(100)
	            end
				TaskPlayAnim(me, anim.dict, anim.name, 8.0, -8, -1, 49, 0, 0, 0, 0)
					while GetGameTimer() < start_time + duration do
						Wait(1)
						--[[
						--print("IsEntityPlayingAnim(me, anim.dict, anim.name, 3): " .. tostring(IsEntityPlayingAnim(me, anim.dict, anim.name, 3)))
						if not IsEntityPlayingAnim(me, anim.dict, anim.name, 3) then
							TaskPlayAnim(me, anim.dict, anim.name, 8.0, -8, -1, 48, 0, 0, 0, 0)
						end
						--]]
						DrawSpecialText("~y~Picking lock ~w~[" .. math.ceil((start_time + duration - GetGameTimer()) / 1000) .. "s]")
						local car_coords = GetEntityCoords(veh, 1)
						local my_coords = GetEntityCoords(me, 1)
						if Vdist(car_coords, my_coords) > 2.0 then
							TriggerEvent("usa:notify", "Lock pick ~r~failed~w~, out of range!")
							ClearPedTasks(me)
							return
						end
					end
					if math.random(100) < 27 then
						SetVehicleDoorsLocked(veh, 1)
						TriggerEvent("usa:notify", "Lock pick ~g~success!")
					else
						TriggerEvent("usa:notify", "Lock pick ~r~failed!")
					end
					TriggerServerEvent("usa:removeItem", wholeItem, 1)
				else
					TriggerEvent("usa:notify", "Door is already unlocked!")
				end
			else
				TriggerEvent("usa:notify", "No vehicle detected!")
			end
		-------------------
		-- Binoculars --
		-------------------
		elseif string.find(itemName, "Binoculars") then
			TriggerEvent("binoculars:Activate")
		-------------------
		-- Cell Phone --
		-------------------
		elseif string.find(itemName, "Cell Phone") then
			TriggerEvent("phone:openPhone", wholeItem)
		-------------------
		-- Food Item  --
		-------------------
		elseif wholeItem.type and wholeItem.type == "food" then
			--print("Player used inventory item of type: food!")
			--print("item name: " .. wholeItem.name)
			TriggerEvent("hungerAndThirst:replenish", "hunger", wholeItem)
		-------------------
		-- Drink Item  --
		-------------------
		elseif wholeItem.type and wholeItem.type == "drink" then
			--print("Player used inventory item of type: drink!")
			--print("item name: " .. wholeItem.name)
			TriggerEvent("hungerAndThirst:replenish", "drink", wholeItem)
		---------------------------
		-- Alcoholic Drink Item  --
		---------------------------
		elseif wholeItem.type and wholeItem.type == "alcohol" then
			--print("Player used inventory item of type: alcohol!")
			--print("item name: " .. wholeItem.name)
			TriggerEvent("hungerAndThirst:replenish", "drink", wholeItem)
			--print("old player BAC: " .. player.BAC)
			player.BAC = player.BAC + wholeItem.strength
			--print("new player BAC: " .. player.BAC)
			if player.BAC >= 0.14 then
				intoxicate(false, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
				reality(10)
			elseif player.BAC >= 0.08 then
				intoxicate(false, "MOVE_M@DRUNK@MODERATEDRUNK", 0.6)
				reality(7)
			elseif player.BAC >= 0.04 then
				intoxicate(false, "MOVE_M@DRUNK@SLIGHTLYDRUNK", 0.3)
				reality(4)
			end
		elseif string.find(itemName, "Parachute") then
			GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
			SetPedComponentVariation(GetPlayerPed(-1), 5, 1, 0, 0)
			TriggerServerEvent("parachute:usedParachute")
		else
			TriggerEvent("interaction:notify", "There is no use action for that item!")
		end
	end)
end

Citizen.CreateThread(function()
	local timer = 600000
	local decrement_amount = 0.03
	while true do
		if player.BAC > 0.00 then
			local new_BAC = player.BAC - decrement_amount
			if new_BAC >= 0.00 then
				--print("decrementing BAC! now at: " .. new_BAC)
				player.BAC = new_BAC
			else
				player.BAC = 0.00
			end
		else
			--print("player BAC was not >= 0.00")
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
	--print("client received vehicle inventory... sending NUI message")
	--if inventory then print("#inventory: " .. #inventory) end
	SendNUIMessage({
		type = "vehicleInventoryLoaded",
		vehicle_inventory = inventory
	})
end)

local EMOTE_CANCEL = 32
Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		------------------------------------------------
		-- cancel scenario when W is pressed --
		------------------------------------------------
		if IsControlPressed(1, 32) and playing_scenario then
			ClearPedTasks(ped)
			playing_scenario = false
		end
		--------------------------------------------
		-- Make sure emote stays playing  --
		--------------------------------------------
		if playing_anim and not IsEntityPlayingAnim(ped, playing_anim.dict, playing_anim.name, 3) then
			TaskPlayAnim(ped, playing_anim.dict, playing_anim.name, -8, 1, -1, playing_anim.flag, 0, 0, 0, 0)
		end
		Citizen.Wait(100)
	end
end)

-- getting drunk / high effect
function intoxicate(playScenario, clipset, intensity)
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
		--print("setting movement clipset to: " .. clipset)
		ResetPedMovementClipset(GetPlayerPed(-1), 0)
		RequestAnimSet( clipset )
		while ( not HasAnimSetLoaded( clipset ) ) do
			Citizen.Wait( 1 )
		end
		SetPedMovementClipset(GetPlayerPed(-1), clipset, 0.25)
	end
	SetPedIsDrunk(GetPlayerPed(-1), true)
	DoScreenFadeIn(1000)
	if intensity then
		ShakeGameplayCam("DRUNK_SHAKE", intensity)
	end
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
	StopGameplayCamShaking(true)
	-- Stop the mini mission
	--Citizen.Trace("Going back to reality\n")
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
		if item.components then
			if #item.components > 0 then
				for x = 1, #item.components do
					GiveWeaponComponentToPed(GetPlayerPed(-1), item.hash, GetHashKey(item.components[x]))
				end
			end
		end
		if item.tint then
			SetPedWeaponTintIndex(GetPlayerPed(-1), item.hash, item.tint)
		end
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

-- rewrite from C#: --

-- implement somehow
local draggingHelper = {
	dragging = false,
	targetId = 0
}

function EnableGui(target_vehicle_plate)
	SetNuiFocus(true, true)
	menuEnabled = true
	SetPedCanSwitchWeapon(GetPlayerPed(-1), not menuEnabled)
	SendNUIMessage({
		type = "enableui",
		enable = true,
		playerName = playerName,
		playerId = playerServerId,
		voip = voipLevel,
		target_vehicle_plate = target_vehicle_plate,
		isInVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), true)
	})
end

function DisableGui()
	SetNuiFocus(false, false)
	menuEnabled = false
	SetPedCanSwitchWeapon(GetPlayerPed(-1), not menuEnabled)
	SendNUIMessage({
		type = "enableui",
		enable = false
	})
end

-- event handlers
RegisterNetEvent("interaction:setF1VoipLevel")
AddEventHandler("interaction:setF1VoipLevel", function(level)
	print("set voip level to: " .. level)
	voipLevel = level
end)

RegisterNetEvent("interaction:doVehicleAction")
AddEventHandler("interaction:doVehicleAction", function(action, unseatIndex)

end)

RegisterNetEvent("interaction:performPoliceAction")
AddEventHandler("interaction:performPoliceAction", function(action, unseatIndex)
	if action == "cuff" then
		if playerServerId ~= 0 then
			TriggerServerEvent("cuff:Handcuff", playerServerId)
		else
			TriggerEvent("usa:notify", "No player found to cuff!")
		end
	elseif action == "drag" then
		--if not draggingHelper.dragging then
			if playerServerId ~= 0 then
				TriggerServerEvent("dr:dragPlayer", playerServerId)
				draggingHelper.dragging = not draggingHelper.dragging
				draggingHelper.targetId = playerServerId
			end
		--end
	elseif action == "search" then
		if playerServerId ~= 0 then
			local source = GetPlayerServerId(PlayerId())
			TriggerServerEvent("search:searchPlayer", source, playerServerId)
		end
	elseif action == "mdt" then
		if playerServerId ~= 0 then
			local source = GetPlayerServerId(PlayerId())
			TriggerServerEvent("license:searchForLicense", source, playerServerId)
		end
	elseif action == "place" then
		if draggingHelper.dragging then
			local source = GetPlayerServerId(PlayerId())
			TriggerServerEvent("place:placePerson", draggingHelper.targetId)
		else
			print("no player found to place, must be dragging them!")
		end
	elseif action == "unseat" then
		local driverSeatPlayerId = 0
		local passengerSeatPlayerId = 0
		local backLeftPlayerId = 0
		local backRightPlayerId = 0
		local playerIdToUnseat = 0
		-- compare against all active players
		for x = 0, 64 do
			if NetworkIsPlayerActive(x) then
				playerName = GetPlayerName(x)
				playerServerId = GetPlayerServerId(x)
				targetPed = GetPlayerPed(x)
				targetPedCoords = GetEntityCoords(targetPed, false)
				distanceToTargetPed = Vdist(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
				if GetPedInVehicleSeat(hitHandleVehicle, -1) == targetPed then
					driverSeatPlayerId = playerServerId
				elseif GetPedInVehicleSeat(hitHandleVehicle, 0) == targetPed then
					passengerSeatPlayerId = playerServerId
				elseif GetPedInVehicleSeat(hitHandleVehicle, 1) == targetPed then
					backLeftPlayerId = playerServerId
				elseif GetPedInVehicleSeat(hitHandleVehicle, 2) == targetPed then
					backRightPlayerId = playerServerId
				end
			end
		end
		-- unseat proper position
		if unseatIndex == "front left" then
			TriggerServerEvent("place:unseatPerson", driverSeatPlayerId)
			playerIdToUnseat = driverSeatPlayerId
		elseif unseatIndex == "front right" then
			TriggerServerEvent("place:unseatPerson", passengerSeatPlayerId)
			playerIdToUnseat = passengerSeatPlayerId
		elseif unseatIndex == "back left" then
			TriggerServerEvent("place:unseatPerson", backLeftPlayerId)
			playerIdToUnseat = backLeftPlayerId
		elseif unseatIndex == "back right" then
			TriggerServerEvent("place:unseatPerson", backRightPlayerId)
			playerIdToUnseat = backRightPlayerId
		end
		-- drag them
		if draggingHelper.targetId ~= playerIdToUnseat then
			TriggerServerEvent("dr:dragPlayer", playerIdToUnseat)
			draggingHelper.dragging = true
			draggingHelper.targetId = playerIdToUnseat
		end
	elseif action == "impound" then
		if hitHandleVehicle ~= 0 then
			TriggerServerEvent("impound:impoundVehicle", hitHandleVehicle, GetVehicleNumberPlateText(hitHandleVehicle))
			SetEntityAsMissionEntity(hitHandleVehicle, true, true)
			DeleteEntity(hitHandleVehicle)
		else
			TriggerEvent("usa:notify", "No vehicle detected!")
		end
	elseif action == "seize veh" then
		local veh = getVehicleInFrontOfUser()
		local plate = GetVehicleNumberPlateText(veh)
		TriggerServerEvent("vehicle:seizeContraband", plate)
	end
end)

RegisterNetEvent("interaction:repairVehicle")
AddEventHandler("interaction:repairVehicle", function()
	if hitHandleVehicle ~= 0 then
		if (GetVehicleEngineHealth(hitHandleVehicle) < 1000 or not IsVehicleDriveable(hitHandleVehicle, false) and not IsPedInAnyVehicle(GetPlayerPed(-1), true)) then
			TriggerServerEvent("carDamage:checkForRepairKit", hitHandleVehicle)
		end
	else
		TriggerEvent("usa:notify", "No vehicle detected!")
	end
end)

local last_tackle_time = 0
local tackle_delay = 10000 -- 10 second delay
Citizen.CreateThread(function()
	while true do
		playerName = "no one"
		playerServerId = 0
		hitHandlePed = 0
		hitHandleVehicle = 0
		playerPed = GetPlayerPed(-1)
		playerPedCoords = GetEntityCoords(playerPed, false)
		--offsetCoords = GetOffsetFromEntityGivenWorldCoords(playerPed, playerPedCoords.x, playerPedCoords.y, playerPedCoords.z)
		-- get nearest ped:
		--rayHandle = CastRayPointToPoint(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, offsetCoords.x, offsetCoords.y, offsetCoords.z, 12, GetPlayerPed(-1), 0)
		--rayHandle = StartShapeTestCapsule(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, offsetCoords.x, offsetCoords.y, offsetCoords.z, 1.0, 12, playerPed)
		--a, b, c, d, hitHandlePed = GetRaycastResult(rayHandle)
		-- get nearest veh (temp only get vehicle in front, todo: get closest vehicle regardless of where ped is facing):
		hitHandleVehicle = getVehicleInFrontOfUser()
		--print("veh: " .. hitHandleVehicle)
		-- get closest player server id:
		playerServerId, playerName, distanceToClosestTargetPed = GetClosestPlayerInfo()

		-- watch for open/close menu
		if (IsControlJustPressed( 0, MENU_KEY1 ) or IsControlJustPressed( 0, MENU_KEY2 )) and GetLastInputMethod(2) then
			local target_veh = getVehicleInFrontOfUser()
			local target_veh_plate = GetVehicleNumberPlateText(target_veh)
			EnableGui(target_veh_plate)
			GiveWeaponToPed(GetPlayerPed(-1), 0xA2719263, 0, false, true)
		end

		-- tackling:
		if IsControlJustPressed( 0, TACKLE_KEY ) and GetLastInputMethod(2) then
			if not IsEntityDead(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
				if playerServerId ~= 0 then
					if distanceToClosestTargetPed < 1.2 then
						if not IsPedRagdoll(GetPlayerPed(-1)) and not IsPedCuffed(GetPlayerPed(-1)) then
							if GetGameTimer() > last_tackle_time + tackle_delay then
								TriggerServerEvent("interaction:tackle", playerServerId)
								SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, true, true, false)
								last_tackle_time = GetGameTimer()
							else
								local seconds_left = ((last_tackle_time + tackle_delay) - GetGameTimer())/1000
								TriggerEvent("usa:notify", "Please wait " .. seconds_left .. " more seconds!") -- need to test tackle delay!!!
							end
						end
					else
						TriggerEvent("usa:notify", "Player too far to tackle!")
					end
				else
					TriggerEvent("usa:notify", "No player found to tackle!")
				end
			end
		end

		-- menu
		if menuEnabled then
			DisableControlAction(29, 241, menuEnabled)
			DisableControlAction(29, 242, menuEnabled)
			DisableControlAction(0, 1, menuEnabled)
			DisableControlAction(0, 2, menuEnabled)
			DisableControlAction(0, 142, menuEnabled)
			DisableControlAction(0, 106, menuEnabled)
			--if IsDisabledControlJustReleased(0, 142) then
				--SendNUIMessage({
					--type = "click"
				--})
			--end
		end

		Citizen.Wait(0)
	end
end)

function GetClosestPlayerInfo()
	local closestDistance = 0
	local closestPlayerServerId = 0
	local closestName = ""
	for x = 0, 64 do
		if NetworkIsPlayerActive(x) then
			targetPed = GetPlayerPed(x)
			targetPedCoords = GetEntityCoords(targetPed, false)
			distanceToTargetPed = Vdist(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
			if targetPed ~= GetPlayerPed(-1) then
				if distanceToTargetPed < 10 then
					if closestDistance == 0 then
						closestDistance = distanceToTargetPed
						closestPlayerServerId = GetPlayerServerId(x)
						closestName = GetPlayerName(x)
						hitHandlePed = GetPlayerPed(x)
						--rayHandle = CastRayPointToPoint(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z, 12, GetPlayerPed(-1), 0)
						--a, b, c, d, hitHandlePed = GetRaycastResult(rayHandle)
					else
						if distanceToTargetPed <= closestDistance then
							closestDistance = distanceToTargetPed
							closestPlayerServerId = GetPlayerServerId(x)
							closestName = GetPlayerName(x)
							hitHandlePed = GetPlayerPed(x)
							--rayHandle = CastRayPointToPoint(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z, 12, GetPlayerPed(-1), 0)
							--a, b, c, d, hitHandlePed = GetRaycastResult(rayHandle)
						end
					end
				end
			end
		end
	end
	return closestPlayerServerId, closestName, closestDistance
end

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
		local hashed = GetHashKey(prop)

		RequestModel(hashed)
		while not HasModelLoaded(hashed) do
			Citizen.Wait(100)
		end

		local me = GetPlayerPed(-1)
		BoneID = GetPedBoneIndex(me, bone_ID)
		obj = CreateObject(hashed,  1729.73,  6403.90,  34.56,  true,  true,  false)
		Wait(1000)
		local netid = ObjToNet(obj)
		SetNetworkIdExistsOnAllMachines(netid, true)
		--NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		AttachEntityToEntity(obj,  me,  BoneID, x,y,z, RotX,RotY,RotZ,  1, 1, false, false, 0, true)
		return netid
end
