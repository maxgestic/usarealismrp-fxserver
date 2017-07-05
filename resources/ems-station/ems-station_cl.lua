--local markerX, markerY, markerZ = -366.401, 6103.19, 34.500
local markerX, markerY, markerZ = 318.781, -558.644, 27.6

RegisterNetEvent("emsStation:giveCivWeapons")
AddEventHandler("emsStation:giveCivWeapons", function(playerWeapons)
	Citizen.Trace("#playerWeapons = " .. #playerWeapons)
		for i = 1, #playerWeapons do
			print("playerWeapons[i].hash = " .. playerWeapons[i].hash)
			  GiveWeaponToPed(GetPlayerPed(-1), playerWeapons[i].hash, 1000, false, false)
		end
end)

RegisterNetEvent("emsStation:giveEmsWeapons")
AddEventHandler("emsStation:giveEmsWeapons", function()

	local playerWeapons = { "WEAPON_FLARE", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER" }

	-- weapons
	Citizen.CreateThread(function()

        Wait(2000)

		local name, hash

		for i = 1, #playerWeapons do

			name = playerWeapons[i]

			if string.match(name, "_") then
			  hash = GetHashKey(name)
			  GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
			else
			  GiveWeaponToPed(GetPlayerPed(-1), tonumber(name), 1000, 0, false) -- name already is the hash
			end

		end

    end)

end)

RegisterNetEvent("emsStation:changeSkin")
AddEventHandler("emsStation:changeSkin", function(skinName, playerWeapons)

	if string.match(skinName,"_") then

		skinName = GetHashKey(skinName)

	end

    if skinName == nil then
        Citizen.Trace("skin was null.\n")
        return
    end

    Citizen.CreateThread(function()
		local model = tonumber(skinName)

        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            RequestModel(model)
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)

		Citizen.Trace("#playerWeapons = " .. #playerWeapons)
		for i = 1, #playerWeapons do
			print("playerWeapons[i].hash = " .. playerWeapons[i].hash)
			GiveWeaponToPed(GetPlayerPed(-1), playerWeapons[i].hash, 1000, false, false)
		end
    end)

end)

RegisterNetEvent("emsStation:giveEmsLoadout")
AddEventHandler("emsStation:giveEmsLoadout", function(model)

	-- give max armor
	SetPedArmour(GetPlayerPed(-1), 100)

	-- change into uniform
	TriggerEvent("emsStation:changeSkin", model)
	-- grab weapons
	TriggerEvent("emsStation:giveEmsWeapons")

end)

RegisterNetEvent("emsStation:giveCivLoadout")
AddEventHandler("emsStation:giveCivLoadout", function(model, playerWeapons)
	Citizen.Trace("model = " .. model)
	Citizen.Trace("#playerWeapons = " .. #playerWeapons)
	TriggerEvent("emsStation:changeSkin", model, playerWeapons) -- give skin and weapons
end)

function randomizeComponents()
	SetPedRandomComponentVariation(GetPlayerPed(-1))
end

function toggleDuty()

	MenuTitle = "EMS Duty"
	ClearMenu()
	Menu.addButton("Randomize", "randomizeComponents", nil)
	Menu.addButton("Male Paramedic","giveEmsLoadout", "male:paramedic")
	Menu.addButton("Female Paramedic","giveEmsLoadout", "female:paramedic")
	Menu.addButton("Male Fire","giveEmsLoadout", "male:fire")
	Menu.addButton("Civilian","giveCivLoadout", nil)
	Menu.addButton("Cancel","cancel", nil)

end

function giveEmsLoadout(params)

	TriggerServerEvent("emsStation:toggleDuty", params)

	Menu.hidden = true

end

function giveCivLoadout()
	TriggerServerEvent("emsStation:giveCivStuff")
	Menu.hidden = true
end

function cancel()

	Menu.hidden = true

end

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
end

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)
		DrawMarker(1, markerX, markerY, markerZ, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
		if getPlayerDistanceFromShop(markerX,markerY,markerZ) < 3  and not playerNotified then
			DrawSpecialText("Press [ ~g~E~w~ ] to go on/off duty!")
		end
		if IsControlJustPressed(1,Keys["E"]) then

			if getPlayerDistanceFromShop(markerX,markerY,markerZ) < 3 then

				toggleDuty()

				Menu.hidden = false

			end

		elseif getPlayerDistanceFromShop(markerX,markerY,markerZ) > 3 then
			Menu.hidden = true
		end

		Menu.renderGUI()     -- Draw menu on each tick if Menu.hidden = false

	end
end)

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end
