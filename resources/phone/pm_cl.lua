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
AddEventHandler("phone:loadedMessagesFromId", function(messages)
	Citizen.Trace("loaded msgs with # = " .. #messages)
	SendNUIMessage({
		type = "messagesHaveLoaded",
		messages = messages
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
    EnableGui(false)
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        if phoneEnabled then
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

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if GetLastInputMethod(2) then -- using keyboard only, no controller support
			if IsControlJustReleased(0, 288) then -- F1 = 288
				TriggerServerEvent("phone:checkForPhone") -- see if player bought a phone
			end
		end
	end
end)
