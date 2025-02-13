local chatInputActive = false
local chatInputActivating = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:removeSuggestionAll')
RegisterNetEvent('chat:clear')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')
RegisterNetEvent('_chat:messageEntered')

-- Character Name
characterName = nil

RegisterNetEvent("chat:setCharName")
AddEventHandler("chat:setCharName", function(name)
	characterName = name
end)

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
	local args = { text }
	if author ~= "" then
		table.insert(args, 1, author)
	end
	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = {
			color = color,
			multiline = true,
			args = args
		}
	})
end)

-- Create Loction Based Messaged
RegisterNetEvent('chatMessageLocation')
AddEventHandler('chatMessageLocation', function(name, color, message, pos, range)
	if string.sub(message, 1, string.len("/")) ~= "/" and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pos[1], pos[2], pos[3], true) < range then
		local args = { message }
		if name ~= "" then
			table.insert(args, 1, name)
		end
		SendNUIMessage({
			type = 'ON_MESSAGE',
			message = {
				color = color,
				multiline = true,
				args = args
			}
		})
	end
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
	print(msg)

	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = {
			color = { 0, 0, 0 },
			multiline = true,
			args = { msg }
		}
	})
end)

AddEventHandler('chat:addMessage', function(message)
	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = message
	})
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
	SendNUIMessage({
		type = 'ON_SUGGESTION_ADD',
		suggestion = {
			name = name,
			help = help,
			params = params or nil
		}
	})
end)

AddEventHandler('chat:removeSuggestion', function(name)
	SendNUIMessage({
		type = 'ON_SUGGESTION_REMOVE',
		name = name
	})
end)

AddEventHandler('chat:removeSuggestionAll', function(name)
	SendNUIMessage({
		type = 'ON_SUGGESTION_REMOVE_ALL'
	})
end)

AddEventHandler('chat:addTemplate', function(id, html)
	SendNUIMessage({
		type = 'ON_TEMPLATE_ADD',
		template = {
			id = id,
			html = html
		}
	})
end)

AddEventHandler('chat:clear', function(name)
	SendNUIMessage({
		type = 'ON_CLEAR'
	})
end)

RegisterNUICallback('chatResult', function(data, cb)
	chatInputActive = false
	SetNuiFocus(false)

	if not data.canceled then
		local id = PlayerId()

		--deprecated
		local r, g, b = 0, 0x99, 255

		if not characterName then
			characterName = ""
		end

		local author = (characterName.first or "" ) .. " " .. (characterName.last or "" )

		-- if data.message:sub(1, 1) == '/' then
		-- 	ExecuteCommand(data.message:sub(2))
		-- else
			local pos = GetEntityCoords(GetPlayerPed(-1), true)
			TriggerServerEvent('_chat:messageEntered', author, { r, g, b }, data.message, {pos.x, pos.y, pos.z})
		-- end
	end

	cb('ok')
end)

RegisterNUICallback('loaded', function(data, cb)
	TriggerServerEvent('chat:init');

	cb('ok')
end)

-- opening / closing input bar
Citizen.CreateThread(function()
	SetTextChatEnabled(false)
	SetNuiFocus(false)

	while true do
		Wait(0)

		if not chatInputActive then
			if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
				chatInputActive = true
				chatInputActivating = true

				SendNUIMessage({
					type = 'ON_OPEN'
				})
			end
		end

		if chatInputActivating then
			if not IsControlPressed(0, 245) then
				SetNuiFocus(true)

				chatInputActivating = false
			end
		end
	end
end)

-- hide on HUD black bars (immersion) bars --
AddEventHandler("usa:toggleImmersion", function(shouldHUDBeEnabled)
	SendNUIMessage({
		type = 'ON_IMMERSION',
		shouldHUDBeEnabled = shouldHUDBeEnabled
	})
	if not shouldHUDBeEnabled then
		chatInputActive = false
		chatInputActivating = false
		SetNuiFocus(false)
	end
end)