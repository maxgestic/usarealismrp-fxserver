local _menuPool = NativeUI.CreatePool()
local mainMenu = NativeUI.CreateMenu("Police Dogs", "~b~Need a bitch? No problem.", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

local exemptPlayers = {}

local k9 = {
	handle = nil,
	staying = false,
	busy = false
}

function CreateMenu()
	local item = NativeUI.CreateItem("Follow/Stay", "Make the K9 follow you or stay.")
	item:SetRightBadge(BadgeStyle.Armour)
	item.Activated = function(parentmenu, selected)
		if k9.staying then
			TriggerEvent('usa:notify', 'K9 is now following you.')
			ClearPedSecondaryTask(k9.handle)
			k9.staying = false
		else
			TriggerEvent('usa:notify', 'K9 is now stopped.')
			TriggerServerEvent('k9:playAnimOnAll', PedToNet(k9.handle), 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 8.0, -8, -1, 1, 0)
			k9.staying = true
		end
	end
	mainMenu:AddItem(item)
	local item = NativeUI.CreateItem("Enter/Exit Vehicle", "Enter and exit vehicle faced, or in.")
	item:SetRightBadge(BadgeStyle.Lock)
	item.Activated = function(parentmenu, selected)
		teleportPetToPlayerVehicle()
	end
	mainMenu:AddItem(item)
	local item = NativeUI.CreateItem("Attack Nearest", "Attack the nearest person.")
	item:SetRightBadge(BadgeStyle.Alert)
	item.Activated = function(parentmenu, selected)
		attackNearestPlayer()
	end
	mainMenu:AddItem(item)
	local item = NativeUI.CreateItem("Smell Person", "Smell the nearest player.")
	item:SetRightBadge(BadgeStyle.Ammo)
	item.Activated = function(parentmenu, selected)
		smellNearestPlayer()
	end
	mainMenu:AddItem(item)
	local item = NativeUI.CreateItem("Smell Vehicle", "Smell the nearest vehicle.")
	item:SetRightBadge(BadgeStyle.Car)
	item.Activated = function(parentmenu, selected)
		smellNearestVehicle()
	end
	mainMenu:AddItem(item)
	local item = NativeUI.CreateItem("Find Person", "Find any person near you.")
	item:SetRightBadge(BadgeStyle.Mask)
	item.Activated = function(parentmenu, selected)
		findNearestPerson()
	end
	mainMenu:AddItem(item)
	local item = NativeUI.CreateItem("Deploy/Return", "Spawn or return a K9.")
	item:SetRightBadge(BadgeStyle.Tick)
	item.Activated = function(parentmenu, selected)
		if not k9.handle then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			k9.handle = CreateAPed(1126154828, playerCoords)
			TriggerEvent('usa:notify', 'K9 has been deployed!')
		else
			deletePet()
			TriggerEvent('usa:notify', 'K9 has been returned.')
		end
	end
	mainMenu:AddItem(item)
end

CreateMenu(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0, -0.5, 0))

		if not k9.staying and k9.handle then
			local k9Coords = GetEntityCoords(k9.handle)
			local dist = Vdist(x, y, z, k9Coords)
			TaskGoToCoordAnyMeans(k9.handle, x, y, z, 10.0, 0, 0, 0, 0)

			local old = k9.handle
			while dist > 1.0 do
				Wait(70)
				if k9.handle == nil or k9.handle ~= old or k9.staying then break end
				k9Coords = GetEntityCoords(k9.handle)
				dist = Vdist(x, y, z, k9Coords)
			end
		end

		Wait(70)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		_menuPool:MouseControlsEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:ProcessMenus()
	end

end)

function getVehicleInFront()
	local playerPed = PlayerPedId()
	local coordA = GetEntityCoords(playerPed, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function getPedInFront()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed, false)
	local playerOffset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(playerCoords, playerOffset, 1.0, 12, playerPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

function teleportPetToPlayer()
	if k9.handle ~= nil then
		local playerOffset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, -0.5, 0)
		SetEntityCoordsNoOffset(k9.handle, playerOffset)
		k9.staying = false
	end
end

function teleportPetToPlayerVehicle()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed) then
		local playerVeh = GetVehiclePedIsUsing(playerPed)
		if k9.handle ~= nil then
			if not IsPedInAnyVehicle(k9.handle) then
				for i = 0, GetVehicleMaxNumberOfPassengers(playerVeh) do
					if IsVehicleSeatFree(playerVeh, i) then
						TaskWarpPedIntoVehicle(k9.handle, playerVeh, i)
						TriggerEvent('usa:notify', 'K9 has entered vehicle.')
					end
				end
			else
				teleportPetToPlayer()
				TriggerEvent('usa:notify', 'K9 has exited vehicle.')
			end
		end
	else
		if getVehicleInFront() then
			local playerVeh = getVehicleInFront()
			if k9.handle ~= nil then
				if not IsPedInAnyVehicle(k9.handle) then
					for i = 0, GetVehicleMaxNumberOfPassengers(playerVeh) do
						if IsVehicleSeatFree(playerVeh, i) then
							TaskWarpPedIntoVehicle(k9.handle, playerVeh, i)
							TriggerEvent('usa:notify', 'K9 has entered vehicle.')
						end
					end
				else
					teleportPetToPlayer()
					TriggerEvent('usa:notify', 'K9 has exited vehicle.')
				end
			end
		end
	end
end

function deletePet()
	if DoesEntityExist(k9.handle) then
		SetEntityAsMissionEntity(k9.handle, true, true)
		DeleteEntity(k9.handle)
	end
	k9.handle = nil
	k9.busy = false
end

function attackNearestPlayer()
	Citizen.CreateThread(function()
		k9.busy = true
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed, false)
		for x = 0, 64 do
			if NetworkIsPlayerActive(x) then
				local targetPed = GetPlayerPed(x)
				local targetCoords = GetEntityCoords(targetPed)
				if not IsEntityDead(targetPed) and not IsPedExempt(targetPed) and Vdist(targetCoords, playerCoords) < 20.0 and targetPed ~= playerPed then
					k9.staying = true
					TaskCombatPed(k9.handle, targetPed, 0, 16)
					TriggerEvent('usa:notify', 'K9 is now attacking!')
					while not IsEntityDead(targetPed) do
						if not k9.handle or not k9.staying then return end
						Citizen.Wait(100)
					end
					k9.staying = false
					k9.busy = false
				end
			end
		end
	end)
end

function smellNearestPlayer()
	Citizen.CreateThread(function()
		k9.busy = true
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed, false)
		for a = 0, 64 do
			if NetworkIsPlayerActive(a) then
				local targetPed = GetPlayerPed(a)
				local x, y, z = table.unpack(GetEntityCoords(targetPed))
				if not IsEntityDead(targetPed) and not IsPedExempt(targetPed) and Vdist(x, y, z, playerCoords) < 5.0 and targetPed ~= playerPed then
					TriggerEvent('usa:notify', 'K9 is now smelling...')
					k9.staying = true
					TaskGoToCoordAnyMeans(k9.handle, x, y, z, 2.0, 0, 0, 0, 0)
					while Vdist(GetEntityCoords(k9.handle), GetEntityCoords(targetPed)) > 1.0 do Citizen.Wait(100) if not k9.handle or not k9.staying then return end end
					TriggerServerEvent('k9:smellPlayer', tonumber(GetPlayerServerId(a)))
					k9.staying = false
					k9.busy = false
				end
			end
		end
	end)
end

function smellNearestVehicle()
	Citizen.CreateThread(function()
		k9.busy = true
		local nearestVehicle = getVehicleInFront()
		if DoesEntityExist(nearestVehicle) then
			local vehPlate = GetVehicleNumberPlateText(nearestVehicle)
			k9.staying = true
			TaskGoToCoordAnyMeans(k9.handle, GetEntityCoords(nearestVehicle), 2.0, 0, 0, 0, 0)
			while Vdist(GetEntityCoords(k9.handle), GetEntityCoords(nearestVehicle)) > 2.0 do Citizen.Wait(100) if not k9.handle or not k9.staying then return end end
			TriggerEvent('usa:notify', 'K9 is now smelling...')
			TriggerServerEvent('k9:smellVehicle', vehPlate)
			k9.staying = false
			k9.busy = false
		end
	end)
end

function findNearestPerson()
	Citizen.CreateThread(function()
		k9.busy = true
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed, false)
		for x = 0, 64 do
			if NetworkIsPlayerActive(x) then
				local targetPed = GetPlayerPed(x)
				local targetCoords = GetEntityCoords(targetPed)
				if not IsEntityDead(targetPed) and not IsPedExempt(targetPed) and Vdist(targetCoords, playerCoords) < 50.0 and targetPed ~= playerPed then
					TriggerEvent('usa:notify', 'K9 is now searching...')
					k9.staying = true
					ClearPedTasksImmediately(k9.handle)
					TaskWanderStandard(k9.handle, 0, 0)
					Citizen.Wait(15000)
					TriggerEvent('usa:notify', 'K9 found a scent!')
					TaskGoToCoordAnyMeans(k9.handle, GetEntityCoords(targetPed), 1.0, 0, 0, 0, 0)
					while Vdist(GetEntityCoords(k9.handle), GetEntityCoords(targetPed)) > 2.0 do Citizen.Wait(100) if not k9.handle or not k9.staying then return end end
					TriggerServerEvent('k9:playAnimOnAll', PedToNet(k9.handle), 'creatures@rottweiler@amb@world_dog_sitting@idle_a', 'idle_c' , 8.0, -8, -1, 1, 0)
					k9.busy = false
				end
			end
		end
	end)
end

function CreateAPed(hash, pos)
	local handle = nil
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		Citizen.Wait(100)
	end
	handle = CreatePed(5, hash, pos.x, pos.y, pos.z, 0, true, false)
	SetBlockingOfNonTemporaryEvents(handle, true)
	SetBlockingOfNonTemporaryEvents(handle, true)
	SetPedFleeAttributes(handle, 0, 0)
	SetEntityAsMissionEntity(handle, true, true)
	pet_net = PedToNet(handle)
	SetNetworkIdExistsOnAllMachines(pet_net, true)
	NetworkSetNetworkIdDynamic(pet_net, true)
	SetNetworkIdCanMigrate(pet_net, false)

	return handle
end

function IsPedExempt(targetPed)
	if IsPedAPlayer(targetPed) then
		for src, info in pairs(exemptPlayers) do
			if targetPed == GetPlayerPed(GetPlayerFromServerId(src)) then
				return true
			end
		end
	end
	return false
end

RegisterNetEvent('k9:openMenu')
AddEventHandler('k9:openMenu', function()
	mainMenu:Visible(true)
end)

RegisterNetEvent('k9:playAnim')
AddEventHandler('k9:playAnim', function(net, dict, name, a, b, c, d, e)
	ClearPedTasksImmediately(NetToPed(net))
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
	TaskPlayAnim(NetToPed(net), dict, name, a, b, c, d, e, false, false, false)
end)

RegisterNetEvent("eblips:updateAll")
AddEventHandler("eblips:updateAll", function(_exemptPlayers)
	exemptPlayers = _exemptPlayers
end)

RegisterNetEvent('k9:returnSmell')
AddEventHandler('k9:returnSmell', function()
	TriggerServerEvent('k9:playAnimOnAll', PedToNet(k9.handle), 'creatures@rottweiler@amb@world_dog_sitting@idle_a', 'idle_c' , 8.0, -8, -1, 1, 0)
	k9.staying = true
end)