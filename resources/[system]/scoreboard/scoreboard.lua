local listOn = false
local key = 168 -- F7 = 168, LALT = 19

Citizen.CreateThread(function()
    
    while true do
        if IsControlPressed(0, key) then
			if listOn == false then
				TriggerServerEvent("getScoreboard", GetPlayers())
				listOn = true
			end
		end
		if IsControlReleased(0, key) then
            if listOn == true then
				SendNUIMessage({
					meta = 'close'
				})
			listOn = false
			end
        end
		Wait(0)
    end
end)

RegisterNetEvent("scoreboard")
AddEventHandler("scoreboard", function(html)
	SendNUIMessage({ text = html })
end)

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end
	table.sort(players)
    return players
end
