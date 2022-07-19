local EXIT_BOWLING_COORDS = vector3(-141.16293334961, -246.87928771973, 44.050975799561)

function GetTargetPlayers()
	local serverIds = {}
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	
	for _, playerId in pairs(GetActivePlayers()) do
		local targetPed = GetPlayerPed(playerId)
		local targetCoords = GetEntityCoords(targetPed)

		if #(targetCoords - coords) < 120.0 then
			table.insert(serverIds, GetPlayerServerId(playerId))
		end
	end

	return serverIds
end

function SubtitleText(text)
	local width = string.len(string.gsub(text, '~%a~', ''))

	SetTextFont(0)
	SetTextScale(0.5, 0.5)
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 255)
	SetTextJustification(0)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.925)

	DrawRect(0.5, 0.945, width * 0.0095, 0.045, 0, 0, 0, 90)
end

local globals = exports.globals

Citizen.CreateThread(function()
	while true do
		local me = PlayerPedId()
		local mycoords = GetEntityCoords(me)
		if #(mycoords - EXIT_BOWLING_COORDS) < 4.5 then
			globals:DrawText3D(EXIT_BOWLING_COORDS.x, EXIT_BOWLING_COORDS.y, EXIT_BOWLING_COORDS.z, "[E] - Stop Bowling")
			if IsControlJustPressed(0, 38) then
				ExecuteCommand("bowlingleave")
			end
		end
		Wait(1)
	end
end)