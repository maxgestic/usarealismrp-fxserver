local menu = false
local ownedVehicles = {}
local alreadyCalled = false

RegisterNetEvent("GUI:Title")
AddEventHandler("GUI:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("GUI:Option")
AddEventHandler("GUI:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("GUI:Bool")
AddEventHandler("GUI:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI:Int")
AddEventHandler("GUI:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI:StringArray")
AddEventHandler("GUI:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI:Update")
AddEventHandler("GUI:Update", function()
	Menu.updateSelection()
end)

-- custom events

RegisterNetEvent("garage:openMenuWithVehiclesLoaded")
AddEventHandler("garage:openMenuWithVehiclesLoaded", function(userVehicles)
	ownedVehicles = userVehicles
	alreadyCalled = false
	menu = true
end)

-- end custom events

Citizen.CreateThread(function()

	--local menu = false
	--local bool = false
	--local int = 0
	--local position = 1
	--local array = {"TEST", "TEST2", "TEST3", "TEST4"}

	while true do

		if(menu) then
			-- title of menu
			TriggerEvent("GUI:Title", "LS Storage")
			for i = 1, #ownedVehicles do
				local vehicle = ownedVehicles[i]
				-- each vehicle the player owns
				TriggerEvent("GUI:Option", "Retrieve ~y~" .. vehicle.model, function(cb)
					if(cb) then
						Citizen.Trace("Trying to retrieve vehicle...")
						menu = false
						if not alreadyCalled then
							alreadyCalled = true
							Citizen.Trace("calling garage:checkVehicleStatus with vehicle = " .. vehicle.model)
							TriggerServerEvent("garage:checkVehicleStatus", vehicle)
						else
								Citizen.Trace("Vehicle already retrieved...")
						end
					else
					end
				end)
			end
			TriggerEvent("GUI:Option", "Close Menu", function(cb)
				if(cb) then
					menu = false
				end
			end)
			--[[
			TriggerEvent("GUI:Bool", "bool", bool, function(cb)
				bool = cb
			end)

			TriggerEvent("GUI:Int", "int", int, 0, 55, function(cb)
				int = cb
			end)

			TriggerEvent("GUI:StringArray", "string:", array, position, function(cb)
				position = cb
			end)
			--]]
			TriggerEvent("GUI:Update")
		end

		Wait(0)
	end
end)
