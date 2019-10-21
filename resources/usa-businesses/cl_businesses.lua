-- ROB ON KEY HOLD --
Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0, KEYS.K) then
			local me = PlayerPedId()
			Wait(500)
			if IsControlPressed(0, KEYS.K) then
				local closestStore = GetClosestStore(1.5)
				if closestStore then
					if IsPedArmed(me, 7) then
						if not isRobbingStore then
							TriggerServerEvent('business:beginRobbery', closestStore, IsPedMale(me), GetNumberOfPlayers())
						end
					else
						exports.globals:notify("I am not intimidated!")
					end
				end
			end
		end
		Wait(0)
	end
end)

-- OPEN MENU ON KEY PRESS --
Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0, KEYS.E) then
			local closestStore = GetClosestStore(1.5)
			if closestStore and BUSINESSES[closestStore].price then
				Wait(500)
				if IsControlPressed(0, KEYS.E) then
					TriggerServerEvent("business:lease", closestStore)
	      		else
	        		TriggerServerEvent("business:tryOpenMenuByName", closestStore)
				end
				Wait(1000)
			end
		end
    Wait(0)
	end
end)

-- DRAW 3D TEXT  --
Citizen.CreateThread(function()
	while true do
		for name, data in pairs(BUSINESSES) do
			local pos = data.position
			if data.price then
				DrawText3D(pos[1], pos[2], pos[3], 4, '[E] - Open | [HOLD K] - Rob')
			else
				DrawText3D(pos[1], pos[2], pos[3], 4, '[HOLD K] - Rob')
			end
		end
    Wait(0)
  end
end)

-- Get closest store within given range or nil if not close to any --
function GetClosestStore(range)
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)
  for name, data in pairs(BUSINESSES) do
    local pos = data.position
    if Vdist(playerCoords.x, playerCoords.y, playerCoords.z, pos[1], pos[2], pos[3]) < range then
      return name
    end
  end
	return nil
end
