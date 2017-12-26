local holdingup = false
local store = ""
local secondsRemaining = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local stores = {
	["paleto_tattoo"] = {
		position = { ['x'] = -292.211, ['y'] = 6200.350, ['z'] = 31.487 },
		reward = 3400,
		nameofstore = "Tattoo Shop (Dulouz Ave. & Paleto Blvd.)",
		lastrobbed = 0
	},
	["paleto_barber"] = {
		position = { ['x'] = -277.842, ['y'] = 6230.185, ['z'] = 31.696 },
		reward = 2500,
		nameofstore = "Herr Kutz Barbershop (Dulouz Ave. & Paleto Blvd.)",
		lastrobbed = 0
	},
	["paleto_twentyfourseven"] = {
		position = { ['x'] = 1728.77, ['y'] = 6417.61, ['z'] = 35.0372161865234 },
		reward = 5000,
		nameofstore = "24/7 (Paleto Bay)",
		lastrobbed = 0
	},
	["sandyshores_tattoo"] = {
		position = { ['x'] = 1862.851, ['y'] = 3748.209, ['z'] = 33.0 },
		reward = 3500,
		nameofstore = "Tattoo Shop (Sandy Shores)",
		lastrobbed = 0
	},
	["sandyshores_barber"] = {
		position = { ['x'] = 1930.556, ['y'] = 3728.216, ['z'] = 32.8 },
		reward = 3500,
		nameofstore = "O'Sheas Barber Shop (Alhambra Dr. & Niland Ave.)",
		lastrobbed = 0
	},
	["sandyshores_twentyfourseven"] = {
		position = { ['x'] = 1959.772, ['y'] = 3740.07, ['z'] = 32.344 },
		reward = 5000,
		nameofstore = "24/7 (Sandy Shores)",
		lastrobbed = 0
	},
	["bar_one"] = {
		position = { ['x'] = 1986.1240234375, ['y'] = 3053.8747558594, ['z'] = 47.215171813965 },
		reward = 5000,
		nameofstore = "Yellow Jack. (Sandy Shores)",
		lastrobbed = 0
	},
	["harmony_twentyfourseven"] = {
		position = { ['x'] = 549.563, ['y'] = 2669.187, ['z'] = 42.157 },
		reward = 2500,
		nameofstore = "24/7 (Route 68, Harmony)",
		lastrobbed = 0
	}
	--[[
	["littleseoul_twentyfourseven"] = {
		position = { ['x'] = -709.17022705078, ['y'] = -904.21722412109, ['z'] = 19.215591430664 },
		reward = 5000,
		nameofstore = "24/7 (Little Seoul)",
		lastrobbed = 0
	},
	-- custom
	["innocence_twentyfourseven"] = {
		position = { ['x'] = 30.1535, ['y'] = -1339.85, ['z'] = 29.497 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Innocence Blvd)",
		lastrobbed = 0
	},
	["grove_twentyfourseven"] = {
		position = { ['x'] = -43.0506, ['y'] = -1749.41, ['z'] = 29.421 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Grove St.)",
		lastrobbed = 0
	},
	["mirrorParkVespucci_twentyfourseven"] = {
		position = { ['x'] = 1130.58, ['y'] = -982.055, ['z'] = 46.4158 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Mirror Park & Vespucci)",
		lastrobbed = 0
	},
	["sanAndreasBayCity_twentyfourseven"] = {
		position = { ['x'] = -1221.14, ['y'] = -912.147, ['z'] = 12.3263 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (San Andreas Ave. & Bay City Ave.)",
		lastrobbed = 0
	},
	["prosperityBlvdDelPerro_twentyfourseven"] = {
		position = { ['x'] = -1482.62, ['y'] = -376.534, ['z'] = 40.1634 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Prosperity St. & Blvd Del Perro)",
		lastrobbed = 0
	},
	["clintonAve_twentyfourseven"] = {
		position = { ['x'] = 373.058, ['y'] = 329.096, ['z'] = 103.566 },
		reward = 5000,
		nameofstore = "Twenty-Four Seven. (Clinton Ave.)",
		lastrobbed = 0
	}
	--]]
}

RegisterNetEvent('es_holdup:currentlyrobbing')
AddEventHandler('es_holdup:currentlyrobbing', function(robb)
	holdingup = true
	store = robb
	secondsRemaining = 120
end)

RegisterNetEvent('es_holdup:toofarlocal')
AddEventHandler('es_holdup:toofarlocal', function(robb)
	holdingup = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "The robbery was cancelled, you will receive nothing.")
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)


RegisterNetEvent('es_holdup:robberycomplete')
AddEventHandler('es_holdup:robberycomplete', function(robb)
	holdingup = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Robbery done, you received: ^2" .. stores[store].reward)
	store = ""
	secondsRemaining = 0
	incircle = false
end)

Citizen.CreateThread(function()
	while true do
		if holdingup then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

--[[ don't create blips
Citizen.CreateThread(function()
	for k,v in pairs(stores)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 52)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Robbable Store")
		EndTextCommandSetBlipName(blip)
	end
end)
--]]
incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(stores)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if not holdingup then
					DrawMarker(27, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) then
							DisplayHelpText("Press ~INPUT_CONTEXT~ to rob ~b~" .. v.nameofstore .. "~w~ beware, the police will be alerted!")
						end
						incircle = true
						if(IsControlJustReleased(1, 51))then
							TriggerServerEvent('es_holdup:rob', k)
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end

		if holdingup then

			drawTxt(0.86, 1.44, 1.0,1.0,0.4, "Robbing store: ~r~" .. secondsRemaining .. "~w~ seconds remaining", 255, 255, 255, 255)

			local pos2 = stores[store].position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 7.5)then
				TriggerServerEvent('es_holdup:toofar', store)
			end
		end

		Citizen.Wait(0)
	end
end)
