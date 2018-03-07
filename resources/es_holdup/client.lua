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
	["Los Santos Customs - Paleto"] = {
		position = { ['x'] = 99.053, ['y'] = 6620.112, ['z'] = 32.44 },
		nameofstore = "Los Santos Customs - Paleto",
		lastrobbed = 0
	},
	["Car Dealership - Paleto"] = {
		position = { ['x'] = 123.356, ['y'] = 6629.426, ['z'] = 31.9117 },
		nameofstore = "Car Dealership - Paleto",
		lastrobbed = 0
	},
	["24/7 Paleto"] = {
		position = { ['x'] = 1728.77, ['y'] = 6417.61, ['z'] = 35.0372161865234 },
		nameofstore = "24/7 (Paleto Bay)",
		lastrobbed = 0
	},
	["Gun Store - Sandy Shores"] = {
		position = { ['x'] = 1689.613, ['y'] = 3758.355, ['z'] = 34.705 },
		nameofstore = "Gun Store - Sandy Shores",
		lastrobbed = 0
	},
	["Pizza Delivery - Sandy Shores"] = {
		position = { ['x'] = 1902.687, ['y'] = 3734.021, ['z'] = 32.588 },
		nameofstore = "Pizza Delivery - Sandy Shores",
		lastrobbed = 0
	},
	["24/7 Sandy Shores"] = {
		position = { ['x'] = 1960.033, ['y'] = 3748.403, ['z'] = 32.343 },
		nameofstore = "24/7 (Sandy Shores)",
		lastrobbed = 0
	},
	["Los Santos Customs - Route 68, Harmony"] = {
		position = { ['x'] = 1187.163, ['y'] = 2636.262, ['z'] = 38.401 },
		nameofstore = "Los Santos Customs - Route 68, Harmony",
		lastrobbed = 0
	},
	["Revsta's Boat Shop - Sandy Shores"] = {
		position = { ['x'] = 2392.283, ['y'] = 4292.408, ['z'] = 31.998 },
		nameofstore = "Revsta's Boat Shop - Sandy Shores",
		lastrobbed = 0
	},
	["Revsta's Boat Shop - Paleto"] = {
		position = { ['x'] = 254.205, ['y'] = 6635.504, ['z'] = 1.784 },
		nameofstore = "Revsta's Boat Shop - Paleto",
		lastrobbed = 0
	},
	["Seaview Aircraft - Grapeseed"] = {
		position = { ['x'] = 2119.411, ['y'] = 4783.381, ['z'] = 40.97 },
		nameofstore = "Seaview Aircraft - Grapeseed",
		lastrobbed = 0
	},
	["Seaview Aircraft - Sandy Shores"] = {
		position = { ['x'] = 1723.332, ['y'] = 3290.0451, ['z'] = 41.196 },
		nameofstore = "Seaview Aircraft - Sandy Shores",
		lastrobbed = 0
	},
	["Garage - Paleto"] = {
		position = { ['x'] = -306.659, ['y'] = 6127.877, ['z'] = 31.499 },
		nameofstore = "Garage - Paleto",
		lastrobbed = 0
	},
	["Garage - Grapeseed"] = {
		position = { ['x'] = 1702.25, ['y'] = 4938.936, ['z'] = 42.078 },
		nameofstore = "Garage - Grapeseed",
		lastrobbed = 0
	},
	["Clothing Store - Paleto"] = {
		position = { ['x'] = 3.715, ['y'] = 6505.654, ['z'] = 31.877 },
		nameofstore = "Clothing Store - Paleto",
		lastrobbed = 0
	},
	["Blaine County Savings Bank"] = {
		position = { ['x'] = 103.53, ['y'] = 6477.866, ['z'] = 31.626 },
		nameofstore = "Blaine County Savings Bank",
		lastrobbed = 0
	},
	["Gas Station - Sandy Shores"] = {
		position = { ['x'] = 2001.7367, ['y'] = 3779.16, ['z'] = 32.18 },
		nameofstore = "Gas Station - Sandy Shores",
		lastrobbed = 0
	},
	["Gas Station - Paleto Blvd & Cascabel"] = {
		position = { ['x'] = 95.917, ['y'] = 6412.034, ['z'] = 31.468 },
		nameofstore = "Gas Station - Paleto Blvd & Cascabel",
		lastrobbed = 0
	},
	["Gas Station - Great Ocean Hwy & Procopio Dr."] = {
		position = { ['x'] = 180.0967, ['y'] = 6602.671, ['z'] = 31.868 },
		nameofstore = "Gas Station - Great Ocean Hwy & Procopio Dr.",
		lastrobbed = 0
	},
	["Car Wash - Paleto Blvd & Cascabel"] = {
		position = { ['x'] = 68.998, ['y'] = 6430.853, ['z'] = 31.438 },
		nameofstore = "Car Wash - Paleto Blvd & Cascabel",
		lastrobbed = 0
	},
	["Fish Restaurant - Paleto"] = {
		position = { ['x'] = 664.933, ['y'] = 5808.579, ['z'] = 17.518 },
		nameofstore = "Fish Restaurant - Paleto",
		lastrobbed = 0
	},
	["Ammunation - Route 68"] = {
		position = { ['x'] = 1122.222, ['y'] = 2697.431, ['z'] = 18.554},
		nameofstore = "Ammunation - Route 68",
		lastrobbed = 0
	},
	["Gun Store - Paleto"] = {
		position = { ['x'] = -334.4107, ['y'] = 6082.485, ['z'] = 31.455},
		nameofstore = "Gun Store - Paleto",
		lastrobbed = 0
	},
	-- below need testing: 
	["Tow Truck - Paleto"] = {
		position = { ['x'] = -191.731, ['y'] = 6269.85, ['z'] = 31.489},
		nameofstore = "Tow Truck - Paleto",
		lastrobbed = 0
	},
	["Taxi Cab Co. - Paleto"] = {
		position = { ['x'] = -45.186, ['y'] = 6439.616, ['z'] = 31.490},
		nameofstore = "Taxi Cab Co. - Paleto",
		lastrobbed = 0
	},
	["Go-Postal - Paleto"] = {
		position = { ['x'] = -422.1905, ['y'] = 6135.021, ['z'] = 31.877},
		nameofstore = "Go-Postal - Paleto",
		lastrobbed = 0
	},
	["FridgeIt Trucking - Paleto"] = {
		position = { ['x'] = -422.1905, ['y'] = 5253.392, ['z'] = 70.487},
		nameofstore = "FridgeIt Trucking - Paleto",
		lastrobbed = 0
	}
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
AddEventHandler('es_holdup:robberycomplete', function(reward)
	holdingup = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Robbery done, you received: ^2$" .. reward)
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
					--DrawMarker(27, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) then
							--DisplayHelpText("Press ~INPUT_CONTEXT~ to rob ~b~" .. v.nameofstore .. "~w~ beware, the police will be alerted!")
						end
						incircle = true
						--if(IsControlJustReleased(1, 51))then
							--TriggerServerEvent('es_holdup:rob', k)
						--end
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
