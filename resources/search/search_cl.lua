RegisterNetEvent("search:failureNotJurisdiction")
AddEventHandler("search:failureNotJurisdiction", function()

	TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Civilians are not allowed to use /search.")

end)

RegisterNetEvent("search:help")
AddEventHandler("search:help", function()

	TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "example: /search <id>")

end)

RegisterNetEvent("search:notifyNoExist")
AddEventHandler("search:notifyNoExist", function(playerId)

	TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "Player with id ^3" .. playerId .. "^0 does not exist.")

end)
