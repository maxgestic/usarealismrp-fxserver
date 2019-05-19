local robbingStore = false
local control = 311

local stores = {
	["Rob's Liquor (El Rancho Blvd.)"] = {
		position = {1134.21, -979.33, 46.41}
	},
	["LTD Gasoline (Ginger St.)"] = {
		position = {-705.89, -911.89, 19.21}
	},
	["247 Supermarket (Paleto Bay)"] = {
		position = {1729.37, 6418.29, 35.03}
	},
	["247 Supermarket - (Innocence Blvd.)"] = {
		position = {24.44, -1343.922, 29.49}
	},
	["247 Supermarket - (San Andreas Ave.)"] = {
		position = {-1224.64, -909.504, 12.32}
	},
	["247 Supermarket (Alhambra Dr.)"] = {
		position = {1958.38, 3743.11, 32.34}
	},
	['247 Supermarket (Clinton Ave.)'] = {
		position = {373.25, 329.68, 103.56}
	},
	["LTD Gasoline (Grove St.)"] = {
		position = {-45.50, -1756.71, 29.42}
	},
	["Rob's Liquor (Route 68)"] = {
		position = {1168.00, 2711.08, 38.15}
	},
	["LTD Gasoline (Grapeseed Main St.)"] = {
		position = {1699.34, 4921.74, 42.06}
	},
	["247 Supermarket (Ineseno Rd.)"] = {
		position = {-3041.47, 583.62, 7.90}
	},
	["247 Supermarket (Palomino Fwy.)"] = {
		position = {2554.50, 380.78, 108.62},
	},
	["247 Supermarket (Senora Fwy.)"] = {
		position = {2675.65, 3280.58, 55.24}
	},
	["247 Supermarket (Harmony, Route 68)"] = {
		position = {549.51, 2668.76, 42.15}
	},
	["LTD Gasoline (Banham Canyon Dr.)"] = {
		position = {-1821.10, 795.60, 138.09}
	},
	["247 Supermarket (Barbareno Rd.)"] = {
		position = {-3244.92, 1000.0, 12.83}
	},
	["Rob's Liquor (Great Ocean Hwy.)"] = {
		position = {-2966.24, 388.91, 15.04}
	},
	["Clothing Store (Sinner St.)"] = {
		position = {427.34, -807.00, 29.49}
	},
	["LS Customs (La Mesa)"] = {
		position = {725.80, -1070.75, 28.31}
	},
	["Herr Kutz Barbers (Carson Ave.)"] = {
		position = {134.45, -1707.75, 29.29}
	},
	["Clothing Store (Innocence Blvd.)"] = {
		position = {73.98, -1392.14, 29.37}
	},
	["Herr Kutz Barbers (Niland Ave.)"] = {
		position = {1930.57, 3728.08, 32.84}
	},
	["Yellow Jack Inn (Panorama Dr.)"] = {
		position = {1984.26, 3049.39, 47.21}
	}
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for name, data in pairs(stores) do
			local x, y, z = table.unpack(data.position)
			DrawText3D(x, y, z, 4, '[HOLD K] - Rob Business')
		end
		if IsControlJustPressed(0, control) then
			Citizen.Wait(500)
			if IsControlPressed(0, control) then
				local playerPed = PlayerPedId()
				local playerCoords = GetEntityCoords(playerPed)

				for name, data in pairs(stores)do
					local x, y, z = table.unpack(data.position)
					if Vdist(playerCoords, x, y, z) < 1.5 then
						if not robbingStore then
							TriggerServerEvent('storeRobbery:beginRobbery', name, IsPedMale(playerPed), GetNumberOfPlayers())
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent('storeRobbery:robStore')
AddEventHandler('storeRobbery:robStore', function(storeName)
	local x, y, z = table.unpack(stores[storeName].position)
	local playerPed = PlayerPedId()
	local beginTime = GetGameTimer()
	robbingStore = true
	Citizen.CreateThread(function()
		while GetGameTimer() - beginTime < 150000 and robbingStore do
			Citizen.Wait(0)
			local playerCoords = GetEntityCoords(playerPed)
			if Vdist(playerCoords, x, y, z) > 10 then
				TriggerEvent('usa:notify', 'You have left the store before receiving money, robbery has been ~y~cancelled~s~!')
				TriggerServerEvent('storeRobbery:cancelRobbery', storeName)
				robbingStore = false
			end
			DrawTimer(beginTime, 150000, 1.42, 1.475, 'ROBBING')
		end
		if robbingStore then
			robbingStore = false
			TriggerServerEvent('storeRobbery:finishRobbery', storeName)
		end
	end)
end)

function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end

function DrawText3D(x, y, z, distance, text)
  if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
  end
end