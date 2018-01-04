local locations = {
    {x=1961.061, y=3741.604, z=31.343 },
    { x=374.586, y=326.037, z=102.566 },
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
end

Citizen.CreateThread(function()

  local menu = {
    open = false,
    page = "home",
    title = "General Store",
    key = 38 -- "E"
  }

	while true do
		Citizen.Wait(0)
    ------------------------------
    -- DRAW MARKERS & HELP TEXT --
    ------------------------------
		for i = 1, #locations do
			DrawMarker(27, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 15, 0, 190, 90, 0, 0, 2, 0, 0, 0, 0)
		end
		if isPlayerAtGeneralStore() and not menu.open then
			drawTxt("Press ~g~E~w~ to open the general store menu!",0,1,0.5,0.8,0.6,255,255,255,255)
		end
    -----------------------
    -- OPEN / CLOSE MENU --
    -----------------------
		if IsControlJustPressed(1,menu.key) then
			if isPlayerAtGeneralStore() then
        menu.open = not menu.open
			end
		elseif not isPlayerAtGeneralStore() then
      menu.open = false
		end
    --------------
    -- THE MENU --
    --------------
    if menu.open then
      TriggerEvent("GUI-general:Title", menu.title)
      ---------------
      -- HOME MENU --
      ---------------
      if menu.page == "home" then
  			TriggerEvent("GUI-general:Option", "Drinks", function(cb)
  				if cb then
            menu.page = "drinks"
            menu.title = "Drinks"
  				end
  			end)
        TriggerEvent("GUI-general:Option", "Food", function(cb)
  				if cb then
            menu.page = "food"
            menu.title = "Food"
  				end
  			end)
        TriggerEvent("GUI-general:Option", "Vehicle", function(cb)
  				if cb then
            menu.page = "vehicle"
            menu.title = "Vehicle"
  				end
  			end)
        TriggerEvent("GUI-general:Option", "Electronics", function(cb)
  				if cb then
            menu.page = "electronics"
            menu.title = "Electronics"
  				end
  			end)
        TriggerEvent("GUI-general:Option", "~y~Close", function(cb)
  				if cb then
            menu.page = "home"
            menu.open = false
            menu.title = "General Store"
  				end
  			end)
        ---------------
        -- DRINK MENU --
        ---------------
      elseif menu.page == "drinks" then
        for i = 1, #storeItems["Drinks"] do
          item = storeItems["Drinks"][i]
          TriggerEvent("GUI-general:Option", "(~g~$" .. item.price .. "~w~) " .. item.name, function(cb)
            if cb then
              --print("person wants to buy: " .. item.name)
              buyItem(item)
              menu.page = "home"
              menu.title = "General Store"
            end
          end)
        end
        TriggerEvent("GUI-general:Option", "~y~Back", function(cb)
          if cb then
            menu.page = "home"
            menu.title = "General Store"
          end
        end)
        TriggerEvent("GUI-general:Option", "~y~Close", function(cb)
          if cb then
            menu.page = "home"
            menu.open = false
            menu.title = "General Store"
          end
        end)
        ---------------
        -- FOOD MENU --
        ---------------
      elseif menu.page == "food" then
        for i = 1, #storeItems["Food"] do
          item = storeItems["Food"][i]
          TriggerEvent("GUI-general:Option", "(~g~$" .. item.price .. "~w~) " .. item.name, function(cb)
            if cb then
              --print("person wants to buy: " .. item.name)
              buyItem(item)
              menu.page = "home"
              menu.title = "General Store"
            end
          end)
        end
        TriggerEvent("GUI-general:Option", "~y~Back", function(cb)
          if cb then
            menu.page = "home"
            menu.title = "General Store"
          end
        end)
        TriggerEvent("GUI-general:Option", "~y~Close", function(cb)
          if cb then
            menu.page = "home"
            menu.open = false
            menu.title = "General Store"
          end
        end)
        ------------------
        -- VEHICLE MENU --
        ------------------
      elseif menu.page == "vehicle" then
        for i = 1, #storeItems["Vehicle"] do
          item = storeItems["Vehicle"][i]
          TriggerEvent("GUI-general:Option", "(~g~$" .. item.price .. "~w~) " .. item.name, function(cb)
            if cb then
              --print("person wants to buy: " .. item.name)
              buyItem(item)
              menu.page = "home"
              menu.title = "General Store"
            end
          end)
        end
        TriggerEvent("GUI-general:Option", "~y~Back", function(cb)
          if cb then
            menu.page = "home"
            menu.title = "General Store"
          end
        end)
        TriggerEvent("GUI-general:Option", "~y~Close", function(cb)
          if cb then
            menu.page = "home"
            menu.open = false
            menu.title = "General Store"
          end
        end)
        ----------------------
        -- ElECTRONICS MENU --
        ----------------------
      elseif menu.page == "electronics" then
        for i = 1, #storeItems["Electronics"] do
          item = storeItems["Electronics"][i]
          TriggerEvent("GUI-general:Option", "(~g~$" .. item.price .. "~w~) " .. item.name, function(cb)
            if cb then
              --print("person wants to buy: " .. item.name)
              buyItem(item)
              menu.page = "home"
              menu.title = "General Store"
            end
          end)
        end
        TriggerEvent("GUI-general:Option", "~y~Back", function(cb)
          if cb then
            menu.page = "home"
            menu.title = "General Store"
          end
        end)
        TriggerEvent("GUI-general:Option", "~y~Close", function(cb)
          if cb then
            menu.page = "home"
            menu.open = false
            menu.title = "General Store"
          end
        end)
      end
      TriggerEvent("GUI-general:Update")
    end
	end

end)

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

---------------
-- MENU CODE --
---------------
RegisterNetEvent("GUI-general:Title")
AddEventHandler("GUI-general:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("GUI-general:Option")
AddEventHandler("GUI-general:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("GUI-general:Bool")
AddEventHandler("GUI-general:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI-general:Int")
AddEventHandler("GUI-general:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI-general:StringArray")
AddEventHandler("GUI-general:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI-general:Update")
AddEventHandler("GUI-general:Update", function()
	Menu.updateSelection()
end)
