--# by: minipunch
--# for USA REALISM rp
--# Phone script to make phone calls and send texts in game with GUI phone
--# requires database(s): "phones"

local phoneEnabled = false
local phoneModel = GetHashKey('prop_npc_phone_02')
local on_call = false
local cellphone_object = nil
local partner_call_source = nil
local voiceChannel = 0
local currChannel

local TIME_TO_ANSWER_CALL = 15

local BACKSPACE_KEY = 177

function DrawCoolLookingNotificationNoPic(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

RegisterNetEvent("phone:notify")
AddEventHandler("phone:notify", function(msg)
	-- play sound
	local soundParams = {-1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 0}
	PlaySoundFrontend(table.unpack(soundParams))
	DrawCoolLookingNotificationNoPic(msg)
end)

-- start of NUI menu

function EnableGui(enable, phone)
	local me = PlayerPedId()
	SetNuiFocus(enable, enable)
	phoneEnabled = enable
	if phone then
		SendNUIMessage({
			type = "enableui",
			enable = enable,
			number = phone.number,
			owner = phone.owner
		})
	else
		SendNUIMessage({
			type = "enableui",
			enable = enable
		})
	end
	if enable and IsEntityDead(me) or IsPedCuffed(me) then 
		TriggerServerEvent('display:shareDisplay', 'starts using cell phone', 2, 370, 10, 7500)
	end
end

RegisterNetEvent("phone:loadedMessagesFromId")
AddEventHandler("phone:loadedMessagesFromId", function(messages, replyIdent)
	--print("loaded msgs with # = " .. #messages)
	SendNUIMessage({
		type = "messagesHaveLoaded",
		messages = messages,
		replyIdent = replyIdent
	})
end)

RegisterNetEvent("phone:loadedMessages")
AddEventHandler("phone:loadedMessages", function(conversations)
	--print("loaded conversations with #conversations = " .. #conversations)
	SendNUIMessage({
		type = "textMessage",
		conversations = conversations
	})
end)

RegisterNetEvent("phone:loadedContacts")
AddEventHandler("phone:loadedContacts", function(contacts)
	SendNUIMessage({
		type = "loadedContacts",
		contacts = contacts
	})
end)

RegisterNetEvent("phone:openPhone")
AddEventHandler("phone:openPhone", function(phone)
	local me = PlayerPedId()
	if not IsPedCuffed(me) then
		EnableGui(true, phone)
	end
end)

RegisterNUICallback('deleteContact', function(data, cb)
	--print("attempting to delete phone contact!")
	TriggerServerEvent("phone:deleteContact", data)
end)

RegisterNUICallback('getContacts', function(data, cb)
	--print("retrieving contacts!")
	TriggerServerEvent("phone:getContacts", data.number)
end)

RegisterNUICallback('addNewContact', function(data, cb)
	--print("adding new contact!")
	TriggerServerEvent("phone:addContact", data)
end)

RegisterNUICallback('getMessagesFromConvo', function(data, cb)
	local partnerId = data.partnerId
	local sourcePhone = data.sourcePhone
	Citizen.Trace("partnerId = " .. partnerId)
	TriggerServerEvent("phone:getMessagesWithThisId", partnerId, sourcePhone)
end)

RegisterNUICallback('getMessages', function(data, cb)
	TriggerServerEvent("phone:loadMessages", data.number)
    cb('ok')
end)

-- request a phone call with user inputted phone number:
RegisterNUICallback('requestCall', function(data, cb)
	--print(data.from_number .. " is requesting a phone call with #: " .. data.phone_number)
	if tonumber(data.phone_number) then
		print("requesting call, my number " .. data.from_number ..", channel: " .. data.channel)
		TriggerServerEvent("phone:requestCall", data)
	else
		--print("invalid phone number format to call")
	end
end)

local time_to_respond = TIME_TO_ANSWER_CALL
local timer = false
local responded = false
-- accept/deny inbound phone call:
RegisterNetEvent("phone:requestCallPermission")
AddEventHandler("phone:requestCallPermission", function(phone_number, caller_source, caller_name, channel)
	if not on_call then
		responded = false
		timer = true
		Citizen.CreateThread(function()
			while not responded and time_to_respond > 0 do
				-- handle response --
				DrawSpecialText("Accept call from " .. caller_name .. "? ~g~Y~w~/~r~BACKSPACE~w~ (" .. time_to_respond .. ")" )
				if IsControlJustPressed(1, 246) then -- Y key
					--print("player accepted phone call from: " .. caller_name)
					TriggerEvent("chatMessage", "", {}, "Started call with: " .. caller_name)
					responded = true
					TriggerServerEvent("phone:respondedToCall", channel, true, phone_number, caller_source, caller_name)
					return
				elseif IsControlJustPressed(1, 177) then -- BACKSPACE key
					--print("player rejected phone call from: " .. caller_name)
					TriggerEvent("chatMessage", "", {}, "Rejected call from: " .. caller_name)
					responded = true
					TriggerServerEvent("phone:respondedToCall", channel, false, phone_number, caller_source, caller_name)
					return
				end
				Wait(0)
			end
			-------------------------------
			-- missed call at this point --
			-------------------------------
			TriggerEvent("chatMessage", "", {}, "Missed call from: " .. caller_name)
		end)
	else
		--print("Player was already on a call! Putting on busy!")
		TriggerServerEvent("phone:respondedToCall", peerIdentifier, false, phone_number, caller_source, caller_name, true)
		PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
	end
end)

Citizen.CreateThread(function()
	while true do
		if timer then
			while time_to_respond > 0 do
				if not responded then
					-------------------
					-- play ringtone --
					-------------------
					PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", 0, 1)
				end
				-- decrement each second --
				time_to_respond = time_to_respond - 1
				Wait(1000)
			end
			time_to_respond = TIME_TO_ANSWER_CALL
			timer = false
			Wait(1)
		end
		Wait(1)
	end
end)

-- start a connection (p2p voice call)
RegisterNetEvent("phone:startCall")
AddEventHandler("phone:startCall", function(phone_number, partner_source, channel)
	currChannel = channel
	on_call = true
	partner_call_source = partner_source
	if channel then -- target calls the source
		print("starting call on channel: " .. channel)
		exports.tokovoip_script:addPlayerToRadio(channel)
	end
end)

-- other player ended a connection (p2p voice call)
RegisterNetEvent("phone:endCall")
AddEventHandler("phone:endCall", function(channel)
	currChannel = nil
	print('ended call on channel: '.. channel)
	exports.tokovoip_script:removePlayerFromRadio(channel)
	on_call = false
	--ClearPedTasks(GetPlayerPed(-1))
	StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_in", 1.0)
	TriggerEvent("swayam:notification", "Whiz Wireless", "Call ~r~ended~w~.", "CHAR_MP_DETONATEPHONE")
end)

RegisterNUICallback('sendTextMessage', function(data, cb)
	TriggerServerEvent("phone:sendTextToPlayer", data)
    cb('ok')
end)

RegisterNUICallback('send911Message', function(data, cb)
	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
	local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
	TriggerServerEvent('911:PlayerCall', x, y, z, lastStreetNAME, data.message)
	TriggerEvent('usa:showHelp', true, 'Emergency services have been notified, you will be alerted when units are enroute.')
end)

RegisterNUICallback('sendTaxiMessage', function(data, cb)
	-- get location of sender and send to server function:
	local playerPos = GetEntityCoords( GetPlayerPed( -1 ), true )
	local streetA, streetB = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
	local street = {}
	if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
		-- Ignores the switcharoo while doing circles on intersections
		lastStreetA = streetA
		lastStreetB = streetB
	end
	if lastStreetA ~= 0 then
		table.insert( street, GetStreetNameFromHashKey( lastStreetA ) )
	end
	if lastStreetB ~= 0 then
		table.insert( street, GetStreetNameFromHashKey( lastStreetB ) )
	end
	data.location = table.concat( street, " & " )
	data.pos = {
		x = playerPos.x,
		y = playerPos.y,
		z = playerPos.z
	}
	-- call server function, check if any is online:
	TriggerServerEvent("phone:sendTaxiMessage", data)
    cb('ok')
end)

RegisterNUICallback('sendMechanicMessage', function(data, cb)
	-- get location of sender and send to server function:
	local playerPos = GetEntityCoords( GetPlayerPed( -1 ), true )
	local streetA, streetB = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
	local street = {}
	if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
		-- Ignores the switcharoo while doing circles on intersections
		lastStreetA = streetA
		lastStreetB = streetB
	end
	if lastStreetA ~= 0 then
		table.insert( street, GetStreetNameFromHashKey( lastStreetA ) )
	end
	if lastStreetB ~= 0 then
		table.insert( street, GetStreetNameFromHashKey( lastStreetB ) )
	end
	data.location = table.concat( street, " & " )
	data.pos = {
		x = playerPos.x,
		y = playerPos.y,
		z = playerPos.z
	}
	TriggerServerEvent("phone:sendMechanicMessage", data)
    cb('ok')
end)

RegisterNUICallback('sendTweet', function(data, cb)
	TriggerServerEvent("phone:sendTweet", data)
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
	--ClearPedTasks(GetPlayerPed(-1))
	StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_in", 1.0)
	EnableGui(false)
  	cb('ok')
end)

-- various things to help handle player phone call --
Citizen.CreateThread(function()
	while true do
		-- disable some controls while phone GUI active, also play scenario --
		if phoneEnabled then
			DisableControlAction(0, 1, phoneEnabled) -- LookLeftRight
			DisableControlAction(0, 2, phoneEnabled) -- LookUpDown
			DisableControlAction(0, 142, phoneEnabled) -- MeleeAttackAlternate
			DisableControlAction(0, 106, phoneEnabled) -- VehicleMouseControlOverride
		end
		-- play phone call anim when on call --
		if on_call then
			-- give cell phone object --
			if not cellphone_object then
				AttachPhone()
			end
			-- make sure phone call anim is playing --
			if not IsEntityPlayingAnim(GetPlayerPed(-1), 'cellphone@', 'cellphone_call_listen_base', 3) then
				RequestAnimDict('cellphone@')
				while not HasAnimDictLoaded('cellphone@') do
					Citizen.Wait(100)
				end
				TaskPlayAnim(GetPlayerPed(-1), 'cellphone@', 'cellphone_call_listen_base', 1.0, -1, -1, 50, 0, false, false, false)
			end
			-- listen for phone call hang up --
			if IsControlJustPressed( 1, BACKSPACE_KEY ) then
				Wait(500)
				if IsControlPressed( 1, BACKSPACE_KEY ) then
					on_call = false
					--ClearPedTasks(GetPlayerPed(-1))
					StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_call_listen_base", 1.0)
					TriggerServerEvent("phone:endedCall", partner_call_source, currChannel) -- notify caller of hang up
					TriggerEvent("swayam:notification", "Whiz Wireless", "Call ~r~ended~w~.", "CHAR_MP_DETONATEPHONE")
				end
			end
		end

		-- listen for phone hotkey press --
		if IsControlJustPressed(1, 288) and GetLastInputMethod(0) then -- "F1"
			if not phoneEnabled then
					TriggerServerEvent("phone:getPhone")
			else
				--ClearPedTasks(GetPlayerPed(-1))
				StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_in", 1.0)
			  	EnableGui(false)
			end
			Wait(500)
		end

		Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(2)
		if on_call then
			DrawSpecialText("Hold ~y~BACKSPACE~w~ to hang up!")
		end
	end
end)

Citizen.CreateThread(function()
	RequestAnimDict('cellphone@')
	while true do
		Wait(2)
		if phoneEnabled and not on_call then
			if not cellphone_object then
				AttachPhone()
			end
			if not IsEntityPlayingAnim(GetPlayerPed(-1), 'cellphone@', 'cellphone_text_in', 3) then
				TaskPlayAnim(GetPlayerPed(-1), 'cellphone@', 'cellphone_text_in', 1.0, -1, -1, 50, 0, false, false, false)
			end
		elseif not phoneEnabled then
			if cellphone_object then
				DeleteObject(cellphone_object)
				cellphone_object = nil
			end
		end
	end
end)

-- utlity functions --
function DrawSpecialText(m_text)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

function AttachPhone()
  local coords = GetEntityCoords(GetPlayerPed(-1))
  local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Citizen.Wait(100)
	end
	cellphone_object = CreateObject(phoneModel, coords.x, coords.y, coords.z, 1, 1, 1)
	AttachEntityToEntity(cellphone_object, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end
