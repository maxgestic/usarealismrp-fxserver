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

RegisterNetEvent("search:attemptToSearchNearest")
AddEventHandler("search:attemptToSearchNearest", function()
	TriggerEvent("usa:getClosestPlayer", 1.6, function(player)
		if player.id ~= 0 then
			-- play animation:
			local anim = {
				dict = "anim@move_m@trash",
				name = "pickup"
			}
			--TriggerEvent("usa:playAnimation", anim.name, anim.dict, 4)
			--TriggerEvent("usa:playAnimation", anim.dict, anim.name, 5, 1, 4000, 31, 0, 0, 0, 0)
			TriggerEvent("usa:playAnimation", anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 4)
			TriggerServerEvent("search:searchPlayer", player.id)
		else
			TriggerEvent("usa:notify", "No person found to search!")
		end
	end)
end)
