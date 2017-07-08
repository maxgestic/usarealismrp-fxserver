RegisterNetEvent("PH:rappel")
AddEventHandler("PH:rappel", function()
    Citizen.CreateThread(function()
        if not IsPedInAnyHeli(GetPlayerPed(-1)) then
            TriggerEvent("chatMessage", "Error", {255, 0, 0}, "You aren't in a heli.")
            return
        end

        heli = GetVehiclePedIsIn(GetPlayerPed(-1), false)

        if not IsVehicleModel(heli, GetHashKey("maverick")) and not IsVehicleModel(heli, GetHashKey("polmav")) then
            TriggerEvent("chatMessage", "Error", {255, 0, 0}, "You can't rappel from this vehicle.")
            return
        end

        if GetPedInVehicleSeat(heli, -1) == GetPlayerPed(-1) or GetPedInVehicleSeat(heli, 0) == GetPlayerPed(-1) then
            TriggerEvent("chatMessage", "Error", {255, 0, 0}, "You have to sit on the side to rappel.")
            return
        end

        TaskRappelFromHeli(GetPlayerPed(-1), 0)
    end)
end)

local spotLight = {}
RegisterNetEvent("PH:toogleSpotlight")
AddEventHandler("PH:toogleSpotlight", function(user, target, enable)
	spotLight[user] = enable
	local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(user)), false)

	if IsVehicleSearchlightOn(heli) then
		if spotLight[user] then
			SetVehicleSearchlight(heli, false, false)
		end

		Citizen.CreateThread(function()
			while spotLight[user] do
				if IsPedSittingInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(user))) and IsPedInAnyHeli(GetPlayerPed(GetPlayerFromServerId(user))) then
					Citizen.Wait(0)
					x, y, z = table.unpack(GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(user)), false), true))
					xa, ya, za = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)), true))
					DrawSpotLightWithShadow(x, y, z-2, xa-x, ya-y, za-z, 255, 255, 255, 230.0, 1.5, 50.0, 10.0, 50.0, 0.0)
					-- DrawLine(x, y, z-2, xa, ya, za, 255, 255, 255, 230.0)
				else
					TriggerServerEvent("PH:spotlightOff", user)
				end
			end
		end)
	else
		spotLight[user] = false
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and IsPedInAnyHeli(GetPlayerPed(-1)) then
			if IsControlJustPressed(0, 38) then -- E
				local heli = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				if IsVehicleModel(heli, GetHashKey("maverick")) or IsVehicleModel(heli, GetHashKey("polmav")) then
			        if GetPedInVehicleSeat(heli, -1) == GetPlayerPed(-1) or GetPedInVehicleSeat(heli, 0) == GetPlayerPed(-1) then
						if IsVehicleSearchlightOn(heli) then
							SetVehicleSearchlight(heli, false, false)
							PlaySound(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
						else
							TriggerServerEvent("PH:spotlightOff", -1)
							SetVehicleSearchlight(heli, true, true)
							PlaySound(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
						end
					end
				end
			end
		end
	end
end)
