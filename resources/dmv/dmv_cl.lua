local locations = {
	{ x=-447.723, y=6013.65, z=30.700 },
	{ x=441.301, y=-981.434, z=29.689 },
	{ x=1853.616, y=3687.966, z=33.267 },
}

RegisterNetEvent("dmv:insufficientFunds")
AddEventHandler("dmv:insufficientFunds", function()

	TriggerEvent("chatMessage", "DMV", { 255,99,71 }, "^0You don't have enough money to afford a license right now! Sorry!")

end)

RegisterNetEvent("dmv:success")
AddEventHandler("dmv:success", function()

	TriggerEvent("chatMessage", "DMV", { 255,99,71 }, "^0You now have a valid driver's license.")

end)

RegisterNetEvent("dmv:alreadyHaveLicense")
AddEventHandler("dmv:alreadyHaveLicense", function()

	TriggerEvent("chatMessage", "DMV", { 255,99,71 }, "^0You already have a valid driver's license.")

end)

RegisterNetEvent("dmv:notify")
AddEventHandler("dmv:notify", function(msg)
	DrawCoolLookingNotification(msg)
end)

function buyLicense(price)

	TriggerServerEvent("dmv:checkMoney", price)

	Menu.hidden = true -- close menu

end

function dmvMenu()
	MenuTitle = "DMV"
	ClearMenu()
	Menu.addButton("Driver's License ($250)", "buyLicense", 250)
end

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	-- Get the player coords so that we know where to spawn it
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
end

function isPlayerAtDMV()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	for i = 1, #locations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,false) < 5 then
			return true
		end
	end
	return false
end

local playerNotified = false

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		for i = 1, #locations do
			DrawMarker(1, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
		end

		if isPlayerAtDMV() and not playerNotified then
			TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Press E to access the DMV menu.")
			playerNotified = true
		end
		if IsControlJustPressed(1,Keys["E"]) then

			if isPlayerAtDMV() then

				if not stored then
					-- save skin for user canceling
					skinBeforeRandomizing = GetEntityModel(GetPlayerPed(-1))
					stored = true
				end

				dmvMenu()              -- Menu to draw
				Menu.hidden = not Menu.hidden    -- Hide/Show the menu

			end

		elseif not isPlayerAtDMV() then
			playerNotified = false
			Menu.hidden = true
		end

		Menu.renderGUI()     -- Draw menu on each tick if Menu.hidden = false

	end
end)

function DrawCoolLookingNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(0,1)
end
