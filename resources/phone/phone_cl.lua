local scenario = "WORLD_HUMAN_STAND_MOBILE"
local startedTask = false

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

RegisterNetEvent("pm:sendMessage")
AddEventHandler("pm:sendMessage", function(from, msg)
	TriggerEvent("chatMessage", "TEXT (" .. from .. ")", { 255, 162, 0 }, msg)
end)

RegisterNetEvent("pm:help")
AddEventHandler("pm:help", function()
	TriggerEvent("chatMessage", "TEXT", { 255, 162, 0 }, "^0Usage: /text <id> <msg>")
end)

-- start of NUI menu

local phoneEnabled = false

function EnableGui(enable, phone)
	print("inside of enablegui with phone = " .. type(phone))
    SetNuiFocus(enable, enable)
    phoneEnabled = enable
	SendNUIMessage({
	    type = "enableui",
	    enable = enable,
		phone = phone
	})
end

RegisterNetEvent("phone:loadedMessagesFromId")
AddEventHandler("phone:loadedMessagesFromId", function(messages, replyIdent)
	Citizen.Trace("loaded msgs with # = " .. #messages)
	SendNUIMessage({
		type = "messagesHaveLoaded",
		messages = messages,
		replyIdent = replyIdent
	})
end)

RegisterNetEvent("phone:loadedMessages")
AddEventHandler("phone:loadedMessages", function(conversations)
	print("loaded conversations with #conversations = " .. #conversations)
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
	if phone then
		print("inside of phone:openPhone with phone set!")
    	EnableGui(true, phone)
	else
		EnableGui(true)
	end
end)

RegisterNUICallback('deleteContact', function(data, cb)
	print("attempting to delete phone contact!")
	TriggerServerEvent("phone:deleteContact", data)
end)

RegisterNUICallback('getContacts', function(data, cb)
	print("retrieving contacts!")
	TriggerServerEvent("phone:getContacts", data.number)
end)

RegisterNUICallback('addNewContact', function(data, cb)
	print("adding new contact!")
	TriggerServerEvent("phone:addContact", data)
end)

RegisterNUICallback('getMessagesFromConvo', function(data, cb)
	local partnerId = data.partnerId
	Citizen.Trace("partnerId = " .. partnerId)
	TriggerServerEvent("phone:getMessagesWithThisId", partnerId)
end)

RegisterNUICallback('getMessages', function(data, cb)
	TriggerServerEvent("phone:loadMessages", data.number)
    cb('ok')
end)

RegisterNUICallback('sendTextMessage', function(data, cb)
	TriggerServerEvent("phone:sendTextToPlayer", data)
    cb('ok')
end)

RegisterNUICallback('send911Message', function(data, cb)
	TriggerServerEvent("phone:send911Message", data)
    cb('ok')
end)

RegisterNUICallback('sendEmsMessage', function(data, cb)
	TriggerServerEvent("phone:sendEmsMessage", data)
    cb('ok')
end)

RegisterNUICallback('sendTaxiMessage', function(data, cb)
	TriggerServerEvent("phone:sendTaxiMessage", data)
    cb('ok')
end)

RegisterNUICallback('sendTowMessage', function(data, cb)
	TriggerServerEvent("phone:sendTowMessage", data)
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
	startedTask = false
	ClearPedTasks(GetPlayerPed(-1))
    EnableGui(false)
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        if phoneEnabled then
			if not startedTask and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
				ClearPedTasks(GetPlayerPed(-1))
				TaskStartScenarioInPlace(GetPlayerPed(-1), scenario, 0, true);
				startedTask = true
			end
            DisableControlAction(0, 1, phoneEnabled) -- LookLeftRight
            DisableControlAction(0, 2, phoneEnabled) -- LookUpDown
            DisableControlAction(0, 142, phoneEnabled) -- MeleeAttackAlternate
            DisableControlAction(0, 106, phoneEnabled) -- VehicleMouseControlOverride
            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(1)
    end
end)
