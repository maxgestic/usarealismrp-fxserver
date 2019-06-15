-- ROB ON KEY HOLD --
Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0, KEYS.K) then
			Wait(500)
			if IsControlPressed(0, KEYS.K) then
        local closestStore = GetClosestStore(1.5)
        if closestStore then
          if not isRobbingStore then
            TriggerServerEvent('business:beginRobbery', closestStore, IsPedMale(playerPed), GetNumberOfPlayers())
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
      if closestStore then
        TriggerServerEvent("business:tryOpenMenu", closestStore)
      end
		end
    Wait(0)
	end
end)

-- DRAW 3D TEXT  --
Citizen.CreateThread(function()
	while true do
		for name, data in pairs(BUSINESSES) do
			local x, y, z = table.unpack(data.position)
			DrawText3D(x, y, z, 4, '[E] - Open | [HOLD K] - Rob')
		end
    Wait(0)
  end
end)

-- Get closest store within given range or nil if not close to any --
function GetClosestStore(range)
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)
  for name, data in pairs(BUSINESSES)do
    local x, y, z = table.unpack(data.position)
    if Vdist(playerCoords, x, y, z) < range then
      return name
    end
  end
  return nil
end
