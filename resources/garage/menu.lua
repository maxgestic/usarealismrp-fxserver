local MENU_OPEN_KEY = 38
local closest_shop = nil

---------------------------
-- Set up main menu --
---------------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Garage", "~b~Public Parking", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

-- custom events --
RegisterNetEvent("garage:openMenuWithVehiclesLoaded")
AddEventHandler("garage:openMenuWithVehiclesLoaded", function(userVehicles)
	CreateBarberShopMenu(mainMenu, userVehicles)
end)
-- end custom events --

function CreateBarberShopMenu(menu, vehicles)
	-- remove any previous versions --
	mainMenu:Clear()
	-- Add vehicles to menu --
	for i = 1, #vehicles do
		-- button text --
		local vehicle = vehicles[i]
		local buttonText = "Retrieve " .. vehicle.make .. " " .. vehicle.model
		if vehicle.impounded == true then
			buttonText = buttonText .. " (~y~Impounded~w~)"
		elseif vehicle.stored == false then
			buttonText = buttonText .. " (~r~Not Stored~w~)"
		else
			buttonText = buttonText .. " (~g~Stored~w~)"
		end
		-- make button --
		local item = NativeUI.CreateItem(buttonText, "")
		item.Activated = function(parentmenu, selected)
			if GetVehiclePedIsIn(GetPlayerPed(-1), false) ~= 0 then
				if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
					local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
					TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
						TriggerServerEvent("garage:checkVehicleStatus", vehicle, property)
					end)
				else
					TriggerEvent("usa:notify", "You must be in the driver's seat!")
				end
			else
				local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
				TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
					TriggerServerEvent("garage:checkVehicleStatus", vehicle, property)
				end)
			end
			-- close menu --
			mainMenu:Visible(not mainMenu:Visible())
		end
	  menu:AddItem(item)
	end
	-- exit button --
	local item = NativeUI.CreateItem("Close", "")
	item.Activated = function(parentmenu, selected)
		-- close menu --
		mainMenu:Visible(not mainMenu:Visible())
	end
	menu:AddItem(item)
	-- Open Menu --
	mainMenu:Visible(not mainMenu:Visible())
end

Citizen.CreateThread(function()
	while true do

		-- Process Menu --
		_menuPool:MouseControlsEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:ProcessMenus()
		-----------------------

		Wait(0)
	end
end)
