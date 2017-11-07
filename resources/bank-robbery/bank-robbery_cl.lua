local markerX, markerY, markerZ = -106.358, 6474.25, 30.600 -- paleto
--local markerX, markerY, markerZ = 146.346, -1044.58, 28.2778 -- LS 1
--local markerX, markerY, markerZ = 254.565, 225.495, 100.176 -- LS 2

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	-- Get the player coords so that we know where to spawn it
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
end

RegisterNetEvent("bank:checkRange")
AddEventHandler("bank:checkRange", function(source)
	if getPlayerDistanceFromShop(markerX,markerY,markerZ) < 4 then
		TriggerServerEvent("bank:inRange")
	else
		TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Out of range of bank. No money stolen.")
	end
end)

function robBank()
	TriggerServerEvent("bank:isBusy")
	Menu.hidden = true -- close menu
end

function bankMenu()
	MenuTitle = "US Bank"
	ClearMenu()
	Menu.addButton("Rob Bank", "robBank")
end

local playerNotified = false

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)
		DrawMarker(1, markerX, markerY, markerZ, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
		if getPlayerDistanceFromShop(markerX,markerY,markerZ) < 4 and not playerNotified then
			TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Press E then 'enter' to rob the bank.")
			playerNotified = true
		end
		if IsControlJustPressed(1,Keys["E"]) then

			if getPlayerDistanceFromShop(markerX,markerY,markerZ) < 4 then -- dmv shop

				bankMenu()                -- Menu to draw
				Menu.hidden = not Menu.hidden    -- Hide/Show the menu

			end

		elseif getPlayerDistanceFromShop(markerX,markerY,markerZ) > 4 then

			playerNotified = false
			Menu.hidden = true

		end

		Menu.renderGUI()     -- Draw menu on each tick if Menu.hidden = false

	end
end)

RegisterNetEvent("bank-robbery:notify")
AddEventHandler("bank-robbery:notify", function(msg)
	DrawCoolLookingNotification(msg)
end)

function DrawCoolLookingNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(0,1)
end
