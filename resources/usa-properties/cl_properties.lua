--# by: MINIPUNCH
--# for: USA REALISM RP
--# desc: this is a script to simulate the owning of robbing of player owned properties

local PROPERTIES = {} -- loaded from the server on first load or whenever a change is made. below data is only for reference whle making

local my_property_identifier = nil -- gets updated by the server on first load, this is the hex steam ID of the player

local nearest_property_info = nil

local menu = {
    enabled = false,
	page = "home",
    key = 38,
	user_items = nil,
	property_items = nil
}

------------------------------------
-- set player property identifier --
------------------------------------
AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent("properties:getPropertyIdentifier")
    TriggerServerEvent("properties:getProperties")
    --print("getting property list and property identifier!")
end)

RegisterNetEvent("properties:setPropertyIdentifier")
AddEventHandler("properties:setPropertyIdentifier", function(ident)
    my_property_identifier = ident
    --print("property identifier set!")
end)

---------------------------------------
-- update client list of properties  --
---------------------------------------
RegisterNetEvent("properties:update")
AddEventHandler("properties:update", function(properties, close_menu)
    PROPERTIES = properties
    if close_menu then menu.enabled = false end
    --print("properties loaded!")
end)

-- list items to store --
RegisterNetEvent("properties:setItemsToStore")
AddEventHandler("properties:setItemsToStore", function(items)
	menu.user_items = items
	print("menu user items set!")
end)

-- list items to retrieve --
RegisterNetEvent("properties:loadedStorage")
AddEventHandler("properties:loadedStorage", function(items)
	menu.property_items = items
	print("**menu property items set!**")
	for k = 1, #items do 
		print("name: " .. items[k].name .. ", quantity: " .. items[k].quantity)
	end
end)
--

---------------------------------------------
-- get closest property from given (usually player) coords  --
---------------------------------------------
RegisterNetEvent("properties:getPropertyGivenCoords")
AddEventHandler("properties:getPropertyGivenCoords", function(x,y,z, cb)
    local closest = 1000000000000.0
    local closest_property = nil
    --print("getting property given coords! x: " .. x)
    for name, info in pairs(PROPERTIES) do 
        --print("Vdist(x, y, z, info.x, info.y, info.z): " .. Vdist(x, y, z, info.x, info.y, info.z))
        if Vdist(x, y, z, info.x, info.y, info.z)  < 50.0 and Vdist(x, y, z, info.x, info.y, info.z) < closest then
            closest = Vdist(x, y, z, info.x, info.y, info.z)
            closest_property = info
            --print("found new closest store: " .. info.name)
        end
    end
    if closest_property then
        --print("returning closest property: " .. closest_property.name) 
        cb(closest_property)
    else 
        --print("no store found! returning nil")
        cb(nil)
    end
end)

--------------------------------------------
-- see if player is close to any property --
--------------------------------------------
Citizen.CreateThread(function()
    local closest = {}
    closest.x = nil
    closest.y = nil
    closest.z = nil
	while true do
		Wait(0)
	    for name, info in pairs(PROPERTIES) do
			if GetDistanceBetweenCoords(info.x, info.y, info.z, GetEntityCoords(GetPlayerPed(-1))) < 50 then
                if info.owner.name then
				    DrawMarker(27, info.x, info.y, info.z-0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 124--[[r]], 41 --[[g]], 153 --[[b]], 90, 0, 0, 2, 0, 0, 0, 0)
                else 
                    DrawMarker(27, info.x, info.y, info.z-0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 183 --[[r]], 240 --[[g]], 65 --[[b]], 90, 0, 0, 2, 0, 0, 0, 0)
                end
            end
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info.x, info.y, info.z) < 2 then
				nearest_property_info = PROPERTIES[name]
                if not menu.enabled then
                    drawTxt("Press [ ~b~E~w~ ] to access the " .. name .. " property menu!",0,1,0.5,0.8,0.6,255,255,255,255)
                    if IsControlJustPressed(0, menu.key) then
                        menu.enabled = true
                        closest.x, closest.y, closest.z = info.x, info.y, info.z
                    end
                end
			end
            -- close menu when out of range -- 
            if menu.enabled and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), closest.x, closest.y, closest.z) > 2 then 
				closest.x, closest.y, closest.z = nil, nil, nil
				menu.enabled = false
				menu.page = "home"
				menu.property_items = nil
				menu.user_items = nil
            end
		end
	end
end)

----------------------
-- M E N U  C O D E --
----------------------
RegisterNetEvent("properties-GUI:Title")
AddEventHandler("properties-GUI:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("properties-GUI:Option")
AddEventHandler("properties-GUI:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("properties-GUI:Bool")
AddEventHandler("properties-GUI:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("properties-GUI:Int")
AddEventHandler("properties-GUI:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("properties-GUI:StringArray")
AddEventHandler("properties-GUI:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("properties-GUI:Update")
AddEventHandler("properties-GUI:Update", function()
	Menu.updateSelection()
end)

-- custom events / functions menu --

------------------------------------

--[[
    potential scenarios:
        [No owner] = menu items needed will be only the purchase price, a purchase button, and an exit button
        [An owner] = {
            visitor = menu items needed will be owner name, a button to rob available items or money, a button to Exit,
            owner = menu items needed will be Earnings, storage section button which has buttons to store, list, and retrieve items,
                    Fee section with next fee due date and a button to pay the fee and an item to display paid status, and an Exit button
        }
]]

Citizen.CreateThread(function()

	--local menu = false
	--local bool = false
	--local int = 0
	local selected_index = 1
	local rob_options = {"Money", "Items"}

	while true do

		if(menu.enabled) then
        
			TriggerEvent("properties-GUI:Title", nearest_property_info.name)

            -------------------------
            -- check for any owner --
            -------------------------
            if nearest_property_info.owner.name then

                -------------------------------------
                -- see if this player is the owner --
                -------------------------------------
                if nearest_property_info.owner.identifier == my_property_identifier then
				
					if menu.page == "home" then

						TriggerEvent("properties-GUI:Option", "You own this property!", function(cb)
							if cb then end
						end)
						
						TriggerEvent("properties-GUI:Option", "Next Fee Due: " .. nearest_property_info.fee.end_date, function(cb) if cb then end end)

						TriggerEvent("properties-GUI:Option", "Money: ~g~$" .. comma_value(nearest_property_info.storage.money), function(cb)
							if cb then end
						end)
						
						TriggerEvent("properties-GUI:Option", "Store Money", function(cb)
							if cb then
								--print("player wants to withdraw from their property!")
								menu.enabled = false
								-- get withdraw amount from user input --
								Citizen.CreateThread( function()
									DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
									while true do
										if ( UpdateOnscreenKeyboard() == 1 ) then
											local input_amount = GetOnscreenKeyboardResult()
											if ( string.len( input_amount ) > 0 ) then
												local amount = tonumber( input_amount )
												amount = math.floor(amount, 0)
												if ( amount > 0 ) then
													TriggerServerEvent("properties:storeMoney", nearest_property_info.name, amount)
												end
												break
											else
												DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
											end
										elseif ( UpdateOnscreenKeyboard() == 2 ) then
											break
										end
										Citizen.Wait( 0 )
									end
								end )
								--TriggerServerEvent("properties:withdraw")
							end
						end)

						TriggerEvent("properties-GUI:Option", "Withdraw", function(cb)
							if cb then
								--print("player wants to withdraw from their property!")
								menu.enabled = false
								-- get withdraw amount from user input --
								Citizen.CreateThread( function()
									DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
									while true do
										if ( UpdateOnscreenKeyboard() == 1 ) then
											local input_amount = GetOnscreenKeyboardResult()
											if ( string.len( input_amount ) > 0 ) then
												local amount = tonumber( input_amount )
												amount = math.floor(amount, 0)
												if ( amount > 0 ) then
													TriggerServerEvent("properties:withdraw", nearest_property_info.name, amount)
												end
												break
											else
												DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
											end
										elseif ( UpdateOnscreenKeyboard() == 2 ) then
											break
										end
										Citizen.Wait( 0 )
									end
								end )
								--TriggerServerEvent("properties:withdraw")
							end
						end)
						
						TriggerEvent("properties-GUI:Option", "Storage", function(cb)
							if cb then
								menu.property_items = nil
								TriggerServerEvent("properties:loadStorage", nearest_property_info.name)
								--TriggerServerEvent("properties:getUserItemsToStore")
								menu.page = "storage"
							end
						end)
						
					else 
					
						if menu.page == "storage" then
					
							if menu.property_items and #menu.property_items > 0 then 
							
								for x = 1, #menu.property_items do 
									local item = menu.property_items[x]
									--print("item: " .. item.name .. ", quantity: " .. item.quantity)
									local color = ""
									if item.legality == "legal" then
										color = "~w~"
									else 
										color = "~r~"
									end
									TriggerEvent("properties-GUI:Option", color .. "(" .. math.floor(item.quantity) .. "x) " .. item.name, function(cb)
										if cb then 
											-- ask for quantity to retrieve, then try to retrieve it
											Citizen.CreateThread( function()
												DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
												while true do
													if ( UpdateOnscreenKeyboard() == 1 ) then
														local input_amount = GetOnscreenKeyboardResult()
														if ( string.len( input_amount ) > 0 ) then
															local amount = tonumber( input_amount )
															amount = math.floor(amount, 0)
															if ( amount > 0 ) then
																if item.quantity - amount >= 0 then
																	TriggerServerEvent("properties:retrieve", nearest_property_info.name, item, amount)
																else 
																	TriggerEvent("usa:notify", "Quantity input too high!")
																end
																menu.page = "home"
															else 
																TriggerEvent("usa:notify", "Quantity input too low!")
															end
															break
														else
															DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
														end
													elseif ( UpdateOnscreenKeyboard() == 2 ) then
														break
													end
													Citizen.Wait( 0 )
												end
											end )
										end
									end)
								end
							
							else
							
								TriggerEvent("properties-GUI:Option", "No items stored!", function(cb) if cb then end end)
							
							end
							
							TriggerEvent("properties-GUI:Option", "~g~Store Items", function(cb)
								if cb then 
									-- remove previous items 
									menu.user_items = nil
									-- list items to store
									menu.page = "storage--store"
									-- get items to store --
									TriggerServerEvent("properties:getUserItemsToStore")
								end
							end)
							
						elseif menu.page == "storage--store" then
						
							if menu.user_items then
						
								if #menu.user_items > 0 then 
								
									for x = 1, #menu.user_items do 
										local item = menu.user_items[x]
										local color = ""
										if item.legality == "legal" then
											color = "~w~"
										else 
											color = "~r~"
										end
										TriggerEvent("properties-GUI:Option", color .. "(" .. math.floor(item.quantity, 0) .. "x) " .. item.name, function(cb)
											if cb then 
												-- ask for quantity to store, then try to store it --
												Citizen.CreateThread( function()
													DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
													while true do
														if ( UpdateOnscreenKeyboard() == 1 ) then
															local input_amount = GetOnscreenKeyboardResult()
															if ( string.len( input_amount ) > 0 ) then
																local amount = tonumber( input_amount )
																
																	amount = math.floor(amount, 0)
																	if amount > 0 then
																		if item.quantity - amount >= 0 then
																			print("storing item [" .. item.name .. "] with quantity [" .. item.quantity .. "]")
																			TriggerServerEvent("properties:store", nearest_property_info.name, item, amount)
																		else 
																			TriggerEvent("usa:notify", "Quantity input too high!")
																		end
																	else 
																		TriggerEvent("usa:notify", "Quantity input too low!")
																	end
																	menu.page = "home"
															
																break
															else
																DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
															end
														elseif ( UpdateOnscreenKeyboard() == 2 ) then
															break
														end
														Citizen.Wait( 0 )
													end
												end )
											end
										end)
									end
								
								else
								
									TriggerEvent("properties-GUI:Option", "No items to store!", function(cb) if cb then end end)
								
								end
							
							end
						
						end
					
					end

                ----------------------------------
                -- this player is not the owner --
                ----------------------------------
                else

                    TriggerEvent("properties-GUI:Option", "~y~Owner:~w~ " .. nearest_property_info.owner.name, function(cb) end)

                    TriggerEvent("properties-GUI:Option", "~y~End Date:~w~ " .. nearest_property_info.fee.end_date, function(cb) end)

                    -- todo: add a peek option to see store inventory items before robbnig --

                    --[[
                    TriggerEvent("properties-GUI:StringArray", "Rob:", rob_options, selected_index, function(cb)
                        selected_index = cb
                        print("selected index to rob: " .. selected_index)
                        --print("Person is trying to steal $" .. nearest_property_info.storage.money .. " from the " .. nearest_property_info.name .. "!")
                    end)
                    --]]

                    TriggerEvent("properties-GUI:Option", "~r~Rob", function(cb)
                        if cb then
                            print("player wants to rob store!")
                            TriggerServerEvent('es_holdup:rob', nearest_property_info.name)
                            menu.enabled = false
                        end
                    end)

                end

            ------------------------
            -- store has no owner --
            ------------------------
            else

                TriggerEvent("properties-GUI:Option", "Price: $" .. comma_value(nearest_property_info.fee.price), function(cb) if cb then end end)

                TriggerEvent("properties-GUI:Option", "~g~Purchase", function(cb)
                    if cb then
                        -- if player has enough money, make them the owner of the property 
                        TriggerServerEvent("properties:purchaseProperty", nearest_property_info)
                    end
                end)

            end

			TriggerEvent("properties-GUI:Option", "Close", function(cb)
				if(cb) then
					menu.enabled = false
					menu.page = "home"
				end
			end)

			--[[
			TriggerEvent("properties-GUI:Bool", "bool", bool, function(cb)
				bool = cb
			end)

			TriggerEvent("properties-GUI:Int", "int", int, 0, 55, function(cb)
				int = cb
			end)

			TriggerEvent("properties-GUI:StringArray", "string:", array, position, function(cb)
				position = cb
			end)
			--]]

			TriggerEvent("properties-GUI:Update")
		end

		Wait(0)

	end
end)
--------------------------------------------------------------------
--------------------------------------------------------------------

-----------------------
-- utility functions --
-----------------------
function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end