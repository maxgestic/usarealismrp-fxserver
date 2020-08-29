local TOGGLE_KEY = 38 -- E

local pets = {
	["Cat"]  		= {hash = 1462895032, price = 600},
	["Husky"] 		= {hash = 1318032802, price = 1050},
	["Pug"] 		= {hash = 1832265812, price = 650},
	["Poodle"] 		= {hash = 1125994524, price = 950},
	["Rottweiler"] 	= {hash = -1788665315, price = 900},
	["Retriever"] 	= {hash = 882848737, price = 900},
	["Shepherd"] 	= {hash = 1126154828, price = 900},
	["Westy"] 		= {hash = -1384627013, price = 650}
}

local random_names = {"Mini", "Jamie", "Ash", "HD", "Otto", "Revsta", "Mandalor", "Mia", "Tim", "Chan", "Glitter", "Luke", "Marcus", "Swayam", "Weedem", "Trevor"}

local my_pet ={
	handle = nil,
	hash = pets["Husky"].hash,
	name = random_names[math.random(#random_names)],
	showName = true
}

-- TODO: adjust menu or change menu to allow for multiple locations (current menu does not work well for multiple)
local stores = {
	--[[
	["Paleto"] = {
		x = -269.47,
		y = 6283.28,
		z = 31.48,
		name = "Paleto Pets"
	},
	--]]
	["Sandy"] = {
		x = 562.2,
		y = 2740.9,
		z = 42.8,
		name = "Animal Ark"
	}
}

local closest = nil

-----------
-- blips --
-----------
Citizen.CreateThread(function()
  for name, info in pairs(stores) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, 267)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.9)
		SetBlipColour(info.blip, 4)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.name)
		EndTextCommandSetBlipName(info.blip)
  end
end)

--+++++++
-- MENU +
--+++++++
Citizen.CreateThread(function()
	CreateWarMenu('PET_MENU', 'Paleto Pets', 'Welcome!', {0.7, 0.1}, 1.0, {75,175,75,255})
	CreateWarSubMenu('PET_SPAWN', 'PET_MENU', 'PET LIST', tablelength(pets).." PETS AVAILABLE", {0.7, 0.1}, 1.0, {75,175,50,255})
	while true do Wait(0)
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.5, 0))
		for name, info in pairs(stores) do
			---------------------------
			-- draw pet store marker --
			---------------------------
			DrawMarker(27, info.x, info.y, info.z - 0.9, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 130, 105, 90, 0, 0, 2, 0, 0, 0, 0)
			-------------------
			-- rest of stuff --
			-------------------
			if IsControlJustReleased(0, TOGGLE_KEY) and Vdist(x,y,z, info.x, info.y, info.z) < 3.0 then -- U
				closest = info
				WarMenu.OpenMenu('PET_MENU')
			end
			if WarMenu.IsMenuOpened('PET_MENU') then
				if WarMenu.MenuButton('Purchase Pet', 'PET_SPAWN') then
				elseif WarMenu.Button('Change Name', my_pet.name) then
					local name = Input(my_pet.name)
					if name ~= nil or name ~= '' then
						my_pet.name = name
						TriggerServerEvent("pets:changeName", name)
					else
						my_pet.name = '~r~INVALID NAME'
					end
				elseif WarMenu.Button('Show/Hide Name') then
					my_pet.showName = not my_pet.showName
					TriggerServerEvent("pets:showName", my_pet.showName)
				elseif WarMenu.Button('~r~Return Pet') then
						TriggerServerEvent("pets:sellPet", my_pet)
				end
				WarMenu.Display()
			elseif WarMenu.IsMenuOpened('PET_SPAWN') then
				for key,value in pairs(pets) do
					if WarMenu.Button("($" ..value.price .. ") " .. key) then
						-------------------------------------
						-- check player money for purchase --
						-------------------------------------
						TriggerServerEvent("pets:checkMoney", key, value, x, y, z, my_pet)
					end
				end
				WarMenu.Display()
			end
			if my_pet.handle ~= nil and my_pet.showName then
	        	aPos = GetEntityCoords(my_pet.handle)
	        	DrawText3d(aPos.x, aPos.y, aPos.z + 0.6, 0.5, 0, my_pet.name, 255, 255, 255, false)
			end
			-- close menu if far away --
			if closest then
				if Vdist(x,y,z, closest.x, closest.y, closest.z) > 3.0 then
					WarMenu.CloseMenu()
				end
			end
		end
	end
end)

local staying = false
--+++++++++++++++++++++++++++++
-- F O L L O W      O W N E R +
--+++++++++++++++++++++++++++++
Citizen.CreateThread(function()
	while true do Wait(70)
		if my_pet.handle ~= nil then
			--print("my_pet.handle is " .. my_pet.handle)
			--print("my_pet.handle was not nil!")
			local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -0.5, 0))
			local a,b,c = table.unpack(GetEntityCoords(my_pet.handle))
			local dist = Vdist(x, y, z, a, b, c)
			if dist > 2.5 and not staying then
				--print("ped is following!")
				TaskGoToCoordAnyMeans(my_pet.handle, x, y, z, 10.0, 0, 0, 0, 0)
				local old = my_pet.handle
				while dist > 2.5 do
					Wait(70)
					if my_pet.handle == nil or my_pet.handle ~= old then break end
					a,b,c = table.unpack(GetEntityCoords(my_pet.handle))
					dist = Vdist(x, y, z, a, b, c)
				end
			end
		end
	end
end)

--++++++++++++++
-- E V E N T S +
--++++++++++++++
RegisterNetEvent("pets:givePet")
AddEventHandler("pets:givePet", function(name, hash, x, y, z)
	--if my_pet.handle == nil then
		Notify("~g~Here is your pet!")
		my_pet.handle = CreateAPed(tonumber(hash),{x = x, y = y, z = z, rot = 0})
		--print("(pets:givePet) set my_pet.handle to: " .. my_pet.handle)
	--else
		--Notify("~r~Already have a pet!")
	--end
end)

RegisterNetEvent("pets:setPet")
AddEventHandler("pets:setPet", function(pets)
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -0.5, 0))
	my_pet.handle = CreateAPed(tonumber(pets[1].hash),{x = x, y = y, z = z, rot = 0})
	my_pet.name = pets[1].name
	my_pet.showName = pets[1].showName
	--print("(pets:setPet) my_pet.handle set to: " .. my_pet.handle)
end)

RegisterNetEvent("pets:storePet")
AddEventHandler("pets:storePet", function()
	StorePet(my_pet.handle)
	my_pet.stored = true
	TriggerEvent("usa:notify", "Your pet has been ~g~stored~w~!")
end)

RegisterNetEvent("pets:TP")
AddEventHandler("pets:TP", function()
	if DoesEntityExist(my_pet.handle) then
		TeleportPet()
	end
end)

RegisterNetEvent("pets:LoadIntoVehicle")
AddEventHandler("pets:LoadIntoVehicle", function()
	if DoesEntityExist(my_pet.handle) then
		LoadIntoVehicle()
	end
end)

RegisterNetEvent("pets:toggleName")
AddEventHandler("pets:toggleName", function()
	if my_pet.handle then
		my_pet.showName = not my_pet.showName
		TriggerServerEvent("pets:showName", my_pet.showName)
	end
end)

RegisterNetEvent("pets:remove")
AddEventHandler("pets:remove", function()
	if DoesEntityExist(my_pet.handle) then
		DeletePed(my_pet.handle)
	end
end)

RegisterNetEvent("pets:stay")
AddEventHandler("pets:stay", function()
	if DoesEntityExist(my_pet.handle) then
		staying = not staying
		if staying then
			TriggerEvent("usa:notify", my_pet.name .. " is staying")
		else
			TriggerEvent("usa:notify", my_pet.name .. " has stopped staying")
		end
	end
end)

RegisterNetEvent("pets:deleteForAll")
AddEventHandler("pets:deleteForAll", function(ped_net)
	--print("deleting all from net id: " .. ped_net)
	--print("(pets:deleteForAll) calling NetToPed, ped_net: " .. ped_net)
	local pet_from_net = NetToPed(ped_net) -- -> should be net to ped?
	--print("finished, ped from net: " .. pet_from_net)
	if DoesEntityExist(pet_from_net) then
		--print("net pet existed!")
		SetEntityAsMissionEntity(pet_from_net, true, true)
		DeleteEntity(pet_from_net)
		--print("deleted ped from net!")
	end
end)

--++++++++++++
-- F U N C S +
--++++++++++++
function LoadIntoVehicle()
	if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
		local car = GetVehiclePedIsUsing(GetPlayerPed(-1))
		if my_pet.handle ~= nil then
			if not IsPedInAnyVehicle(my_pet.handle, true) then
				for i = 1, GetVehicleMaxNumberOfPassengers(car) do
					if IsVehicleSeatFree(car, i) then
						TaskWarpPedIntoVehicle(my_pet.handle, car, i)
					end
				end
			end
		end
	end
end

function TeleportPet()
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -0.5, 0))
	SetEntityCoordsNoOffset(my_pet.handle, x, y, z)
end

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(true, false)
end
function Input(help)
	TriggerEvent("hotkeys:enable", false)
	local var = ''
	DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP8", "", help, "", "", "", 60)
	while UpdateOnscreenKeyboard() == 0 do
		DisableAllControlActions(0)
		Citizen.Wait(0)
	end
	if GetOnscreenKeyboardResult() then
		var = GetOnscreenKeyboardResult()
	end
	TriggerEvent("hotkeys:enable", true)
	return var
end
function DeletePed(handle)
	if DoesEntityExist(handle) then
		SetEntityAsMissionEntity(handle, true, true)
		DeleteEntity(handle)
	end
	my_pet.handle = nil
	my_pet.name = random_names[math.random(#random_names)]
	--print("set my_pet.handle to nil!")
end

local pet_net

function StorePet(handle)

	--[[
	local pet_from_net = NetToObj(ped_net)
	if DoesEntityExist(pet_from_net) then
		print("net pet existed!")
		SetEntityAsMissionEntity(pet_from_net, true, true)
		DeleteEntity(pet_from_net)
	end
	--]]

	TriggerServerEvent("pets:deleteForAll", pet_net)

	if DoesEntityExist(handle) then
		SetEntityAsMissionEntity(handle, true, true)
		DeleteEntity(handle)
		--print("trying to delete pet...")
	end

end

function CreateAPed(hash, pos)
	local handle = nil
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		Citizen.Wait(1)
	end
	handle = CreatePed(5, hash, pos.x, pos.y, pos.z, rot, true, false)
	SetEntityInvincible(handle, true)
	SetBlockingOfNonTemporaryEvents(handle, true)
	TaskSetBlockingOfNonTemporaryEvents(handle, true)
	SetPedFleeAttributes(handle, 0, 0)
	--SetModelAsNoLongerNeeded(hash)
	SetEntityAsMissionEntity(handle, true, true)
	--print("calling PedToNet...")
	pet_net = PedToNet(handle)
	SetNetworkIdExistsOnAllMachines(pet_net, true)
	NetworkSetNetworkIdDynamic(pet_net, true)
	SetNetworkIdCanMigrate(pet_net, false)
	--print("finished in CreateAPed, net: " .. pet_net)

	return handle
end
function CreateWarMenu(id, title, subtitle, pos, width, rgba)
	local x,y = table.unpack(pos)
	local r,g,b,a = table.unpack(rgba)
	WarMenu.CreateMenu(id, title)
	WarMenu.SetSubTitle(id, subtitle)
	WarMenu.SetMenuX(id, x)
	WarMenu.SetMenuY(id, y)
	WarMenu.SetMenuWidth(id, width)
	WarMenu.SetTitleBackgroundColor(id, r, g, b, a)
	WarMenu.SetTitleColor(id, 255, 255, 255, a)
end
function CreateWarSubMenu(id, base, title, subtitle)
	WarMenu.CreateSubMenu(id, base, title)
	WarMenu.SetSubTitle(id, subtitle)
end
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
function DrawText3d(x,y,z, size, font, text, r, g, b, outline)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

	if onScreen then
		SetTextScale(size*scale, size*scale)
		SetTextFont(font)
		SetTextProportional(1)
		SetTextColour(r, g, b, 255)
		if not outline then
			SetTextDropshadow(0, 0, 0, 0, 55)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextDropShadow()
			SetTextOutline()
		end
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		SetDrawOrigin(x,y,z, 0)
		DrawText(0.0, 0.0)
		ClearDrawOrigin()
	end
end
