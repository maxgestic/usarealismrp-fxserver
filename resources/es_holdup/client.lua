local holdingup = false
local store = ""
local secondsRemaining = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(7)
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
	["24/7 Market - Vespucci Blvd. & Mirror Park Dr."] = {
		position = { ['x'] = 1131.3, ['y'] = -979.3, ['z'] = 46.4 },
		nameofstore = "24/7 Market - Vespucci Blvd. & Mirror Park Dr.",
		lastrobbed = 0
	},
	["Blazing Tattoo - Vinewood Blvd."] = {
		position = { ['x'] = 320.6, ['y'] = 182.8, ['z'] = 103.6 },
		nameofstore = "Blazing Tattoo - Vinewood Blvd.",
		lastrobbed = 0
	},
	["Clothing Store - Sinner St."] = {
		position = { ['x'] = 429.4, ['y'] = -808.3, ['z'] = 29.5 },
		nameofstore = "Clothing Store - Sinner St.",
		lastrobbed = 0
	},
	["Ponsbys Clothing"] = {
		position = { ['x'] = -167.1, ['y'] = -299.57, ['z'] = 39.73 },
		nameofstore = "Ponsbys Clothing",
		lastrobbed = 0
	},
	["LTD Gasoline - Ginger St."] = {
		position = { ['x'] = -708.22, ['y'] = -906.09, ['z'] = 19.21 },
		nameofstore = "LTD Gasoline - Ginger St.",
		lastrobbed = 0
	},
	["Xero Gas - Strawberry Ave"] = {
		position = { ['x'] = 265.22, ['y'] = -1263.16, ['z'] = 29.29 },
		nameofstore = "Xero Gas - Strawberry Ave",
		lastrobbed = 0
	},
	["Car Dealership - Harmony"] = {
		position = { ['x'] = 1234.466186, ['y'] = 2737.436035, ['z'] = 38.00539 },
		nameofstore = "Car Dealership - Harmony",
		lastrobbed = 0
	},
	["Auto Repair Shop - Elgin Ave."] = {
		position = { ['x'] = 548.4, ['y'] = -173.3, ['z'] = 54.5 },
		nameofstore = "Auto Repair Shop - Elgin Ave.",
		lastrobbed = 0
	},
	["LS Customs - Vespucci Blvd. & Popular St."] = {
		position = { ['x'] = 726.3, ['y'] = -1072.1, ['z'] = 28.3 },
		nameofstore = "LS Customs - Vespucci Blvd. & Popular St.",
		lastrobbed = 0
	},
	["Herr Kutz Barbershop - Davis/Carson Ave"] = {
		position = { ['x'] = 135.11, ['y'] = -1707.67, ['z'] = 29.29 },
		nameofstore = "Herr Kutz Barbershop - Davis/Carson Ave",
		lastrobbed = 0
	},
	["Clothing Store - Innocence Blvd"] = {
		position = { ['x'] = 71.75, ['y'] = -1390.96, ['z'] = 29.37 },
		nameofstore = "Clothing Store - Innocence Blvd",
		lastrobbed = 0
	},
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
		position = { ['x'] = -664.933, ['y'] = 5808.579, ['z'] = 17.518 },
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
		position = { ['x'] = -568.065, ['y'] = 5253.392, ['z'] = 70.487},
		nameofstore = "FridgeIt Trucking - Paleto",
		lastrobbed = 0
	},
	["Herr Kutz Barber - Paleto"] = {
		position = { ['x'] = -277.958, ['y'] = 6229.62, ['z'] = 31.69},
		nameofstore = "Herr Kuts Barber - Paleto",
		lastrobbed = 0
	},
	["Tattoo Shop - Paleto"] = {
		position = { ['x'] = 292.94, ['y'] = 6197.46, ['z'] = 31.48},
		nameofstore = "Tattoo Shop - Paleto",
		lastrobbed = 0
	},
	["Herr Kutz Barber - Sandy Shores"] = {
		position = { ['x'] = 1930.88, ['y'] = 3728.8, ['z'] = 32.844},
		nameofstore = "Herr Kuts Barber - Sandy Shores",
		lastrobbed = 0
	},
	["Tattoo Shop - Sandy Shores"] = {
		position = { ['x'] = 1863.22, ['y'] = 3751.12, ['z'] = 33.03},
		nameofstore = "Tattoo Shop - Sandy Shores",
		lastrobbed = 0
	},
	["24/7 Market - Innocence Blvd"] = {
		position = { ['x'] = 24.9, ['y'] = -1343.6, ['z'] = 29.5 },
		nameofstore = "24/7 Market - Innocence Blvd",
		lastrobbed = 0
	},
	["Car Dealership - Los Santos"] = {
		position = { ['x'] = -31.5, ['y'] = -1106.9, ['z'] = 26.4 },
		nameofstore = "Car Dealership - Los Santos",
		lastrobbed = 0
	},
	["Clothing Store - Sinner St."] = {
		position = { ['x'] = 429.4, ['y'] = -808.3, ['z'] = 29.5 },
		nameofstore = "Car Dealership - Los Santos",
		lastrobbed = 0
	},
	["Ammunation - Adam's Apple Blvd."] = {
		position = { ['x'] = 14.3, ['y'] = -1106.2, ['z'] = 29.8 },
		nameofstore = "Ammunation - Adam's Apple Blvd.",
		lastrobbed = 0
	},
	["Benny's Garage - Strawberry Ave."] = {
		position = { ['x'] = -207.7, ['y'] = -1339.3, ['z'] = 34.9 },
		nameofstore = "Benny's Garage - Strawberry Ave.",
		lastrobbed = 0
	},
	["Blazing Tattoo - Vinewood Blvd."] = {
		position = { ['x'] = 320.6, ['y'] = 182.8, ['z'] = 103.6 },
		nameofstore = "Blazing Tattoo - Vinewood Blvd.",
		lastrobbed = 0
	},
	["24/7 Market - San Andreas Ave"] = {
		position = { ['x'] = -1220.3, ['y'] = -907.9, ['z'] = 12.3 },
		nameofstore = "24/7 Market - San Andreas Ave",
		lastrobbed = 0
	},
	["Tattoo Shop - Vespucci Beach"] = {
		position = { ['x'] = -1150.7, ['y'] = -1425, ['z'] = 4.9 },
		nameofstore = "Tattoo Shop - Vespucci Beach",
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
