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

function EnableGui(enable)
    SetNuiFocus(enable)
    phoneEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
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
	SendNUIMessage({
		type = "textMessage",
		conversations = conversations
	})
end)

RegisterNetEvent("phone:openPhone")
AddEventHandler("phone:openPhone", function()
    EnableGui(true)
end)

RegisterNUICallback('getMessagesFromConvo', function(data, cb)
	local partnerId = data.partnerId
	Citizen.Trace("partnerId = " .. partnerId)
	TriggerServerEvent("phone:getMessagesWithThisId", partnerId)
end)

RegisterNUICallback('getMessages', function(data, cb)
	TriggerServerEvent("phone:loadMessages")
    cb('ok')
end)

RegisterNUICallback('sendTextMessage', function(data, cb)
	TriggerServerEvent("phone:sendTextToPlayer", data)
    cb('ok')
end)

RegisterNUICallback('sendPoliceMessage', function(data, cb)
	TriggerServerEvent("phone:sendPoliceMessage", data)
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
