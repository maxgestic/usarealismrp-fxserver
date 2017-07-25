local locations = {
    {  x=1729.59, y=6415.49, z=33.5 },
	{ x=81.6779, y=-219.006, z=53.5367 },
	{ x=373.794, y=326.504, z=102.566	},
	{ x=1135.6, y=-981.327, z=45.5269	 },
	{ x=-1223.69, y=-907.691, z=11.5264 },
	{ x=25.746, y=-1345.59, z=28.597 },
}
local inventory

function isPlayerAtGeneralStore()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	for i = 1, #locations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,false) < 5 then
			return true
		end
	end
	return false
end

function buyItem(item)
    TriggerServerEvent("generalStore:buyItem", item)
    Menu.hidden = not Menu.hidden
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
			DrawMarker(1, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 15, 0, 190, 90, 0, 0, 2, 0, 0, 0, 0)
		end
		if isPlayerAtGeneralStore() and not playerNotified then
			TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Press E to open general store menu!")
			playerNotified = true
		end
		if IsControlJustPressed(1,Keys["E"]) then
			if isPlayerAtGeneralStore() then
				generalStoreMenu()              -- Menu to draw
				Menu.hidden = not Menu.hidden    -- Hide/Show the menu
			end
		elseif not isPlayerAtGeneralStore() then
			playerNotified = false
			Menu.hidden = true
		end
		Menu.renderGUI()     -- Draw menu on each tick if Menu.hidden = false
	end
end)
