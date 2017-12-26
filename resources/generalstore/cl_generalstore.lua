local locations = {
    --[[
    {  x=1729.59, y=6415.49, z=33.5 },
	{ x=81.6779, y=-219.006, z=53.5367 },
	{ x=373.794, y=326.504, z=102.566	},
	{ x=1135.6, y=-981.327, z=45.5269	 },
	{ x=-1223.69, y=-907.691, z=11.5264 },
	{ x=25.746, y=-1345.59, z=28.597 },
    {x=1960.4197998047, y = 3742.9755859375, z = 31.343738555908}
    --]]
    {x=1961.061, y=3741.604, z=31.343 },
    { x=374.586, y=326.037, z=102.566     },
    { x=1136.534, y=-971.131, z=45.415 },
    { x=-1224.188, y=-907.065, z=11.326 },
    { x=26.453, y=-1347.059, z=28.497 },
    { x=-48.437, y=-1756.889, z=28.421 },
    {x=-707.712, y=-914.231, z=18.215 },
    { x=1166.5310, y=2708.920, z=37.157 },
    { x=1698.458, y=4924.744, z=42.063 },
    { x=1729.413, y=6414.426, z=34.037 },
    { x=-3039.294, y=586.014, z=6.908 },
    { x=1162.799, y=-324.155, z=68.205 },
    {  x=2556.836, y=382.416, z=107.622 },
    { x=2678.409, y=3280.871, z=54.241 },
    { x=547.486, y=2670.635, z=41.156 },
    { x=-1820.852, y=792.453, z=137.119 },
    { x=-3242.260, y=1001.569, z=11.830 },
    {x=-2968.126, y=390.579, z=14.043 },
    { x=-1487.241, y=379.843, z=39.163 },
}
local inventory

function isPlayerAtGeneralStore()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	for i = 1, #locations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,false) < 1 then
			return true
		end
	end
	return false
end

function buyItem(item)
    TriggerServerEvent("generalStore:buyItem", item)
    Menu.hidden = not Menu.hidden
end

function drinksMenu()
  MenuTitle = "Drinks"
  ClearMenu()
  for i = 1, #storeItems["Drinks"] do
    item = storeItems["Drinks"][i]
    Menu.addButton(item.name .. " ($" .. item.price .. ")","buyItem", item)
  end
end

function foodMenu()
  MenuTitle = "Food"
  ClearMenu()
  for i = 1, #storeItems["Food"] do
    item = storeItems["Food"][i]
    Menu.addButton(item.name .. " ($" .. item.price .. ")","buyItem", item)
  end
end

function vehicleMenu()
  MenuTitle = "Vehicles"
  ClearMenu()
  for i = 1, #storeItems["Vehicle"] do
		item = storeItems["Vehicle"][i]
		Menu.addButton(item.name .. " ($" .. item.price .. ")","buyItem", item)
	end
end

function miscMenu()
    MenuTitle = "Misc"
    ClearMenu()
    for i = 1, #storeItems["Misc"] do
		item = storeItems["Misc"][i]
		Menu.addButton(item.name .. " ($" .. item.price .. ")","buyItem", item)
	end
end

function buyMenu()
	MenuTitle = "Categories"
	ClearMenu()
  Menu.addButton("Drinks", "drinksMenu", nil)
  Menu.addButton("Food", "foodMenu", nil)
	Menu.addButton("Vehicle","vehicleMenu", nil)
  Menu.addButton("Misc","miscMenu", nil)
end

function sellMenu()
	TriggerServerEvent("generalStore:getItemsAndDisplay")
end

function sellItem(item)
	TriggerServerEvent("generalStore:sellItem", item)
	Menu.hidden = true
end

function generalStoreMenu()
    MenuTitle = "General Store"
    ClearMenu()
    Menu.addButton("Buy", "buyMenu", nil)
    Menu.addButton("Sell", "sellMenu", nil)
end

RegisterNetEvent("generalStore:displayItemsToSell")
AddEventHandler("generalStore:displayItemsToSell", function(items)
	MenuTitle = "Sell"
    ClearMenu()
    for i = 1, #items do
        Menu.addButton("(" .. items[i].quantity .. "x) " .. items[i].name, "sellItem", items[i])
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for i = 1, #locations do
			DrawMarker(27, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 15, 0, 190, 90, 0, 0, 2, 0, 0, 0, 0)
		end
		if isPlayerAtGeneralStore() then
			DrawSpecialText("Press ~g~E~w~ to open the general store menu!")
		end
		if IsControlJustPressed(1,Keys["E"]) then
			if isPlayerAtGeneralStore() then
				generalStoreMenu()              -- Menu to draw
				Menu.hidden = not Menu.hidden    -- Hide/Show the menu
			end
		elseif not isPlayerAtGeneralStore() then
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
