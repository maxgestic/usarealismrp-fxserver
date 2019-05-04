local userData = {
	employed = false,
	employeeType = nil,
} 

local vehicles = {}
local spawnedVehicles = {}
local showroomData = {
	['slot1'] = {
		position = {
			x = -39.46, 
			y = -1097.177, 
			z = 25.42, 
			heading = 120.0
		},
		vehicleModel = nil,
		vehiclePrice = nil,
		storageCapacity = nil
	},
	['slot2'] = {
		position = {
			x = -41.96, 
			y = -1095.51,
			z = 25.42, 
			heading = 120.0
		},
		vehicleModel = nil,
		vehiclePrice = nil,
		storageCapacity = nil
	},
	['slot3'] = {
		position = {
			x = -44.868, 
			y = -1093.90, 
			z = 25.42, 
			heading = 120.0
		},
		vehicleModel = nil,
		vehiclePrice = nil,
		storageCapacity = nil
	},
	['slot4'] = {
		position = {
			x = -48.68, 
			y = -1092.82, 
			z = 25.42, 
			heading = 120.0
		},
		vehicleModel = nil,
		vehiclePrice = nil,
		storageCapacity = nil
	},
	['slot5'] = {
		position = {
			x = -47.68, 
			y = -1101.5, 
			z = 25.42, 
			heading = 70.0
		},
		vehicleModel = nil,
		vehiclePrice = nil,
		storageCapacity = nil
	},
	['slot6'] = {
		position = {
			x = -40.07, 
			y = -1104.187, 
			z = 25.42, 
			heading = 15.0
		},
		vehicleModel = nil,
		vehiclePrice = nil,
		storageCapacity = nil
	}
}

TriggerServerEvent('carDealership:returnShowroomData')

RegisterNetEvent('carDealership:updateVehicleInShowroom')
AddEventHandler('carDealership:updateVehicleInShowroom', function(slotName, vehicleModel, vehiclePrice, storageCapacity)
	showroomData[slotName].vehicleModel = vehicleModel
	showroomData[slotName].vehiclePrice = vehiclePrice
	showroomData[slotName].storageCapacity = storageCapacity
	UpdateShowroom()
end)

RegisterNetEvent('carDealership:updateShowroomData')
AddEventHandler('carDealership:updateShowroomData', function(data)
	for slot = 1, 6 do
		showroomData['slot'..slot].vehicleModel = data['slot'..slot].vehicleModel
		showroomData['slot'..slot].vehiclePrice = data['slot'..slot].vehiclePrice
		showroomData['slot'..slot].storageCapacity = data['slot'..slot].storageCapacity
		UpdateShowroom()
	end
end)

RegisterNetEvent('carDealership:triggerMenu')
AddEventHandler('carDealership:triggerMenu', function(isManager, businessData, playerSteam, _vehicles)
	vehicles = _vehicles
	if isManager then
		mainMenu:Clear()
		_menuPool:Remove()
		CreateManagerMenu(businessData, playerSteam)
		_menuPool:RefreshIndex()
		mainMenu:Visible(not mainMenu:Visible())
	else
		mainMenu:Clear()
		_menuPool:Remove()
		CreateEmployeeMenu()
		_menuPool:RefreshIndex()
		mainMenu:Visible(not mainMenu:Visible())
	end
end)

function CreateManagerMenu(businessData, playerSteam)
	_menuPool:Clear()
	local employeesMenu = _menuPool:AddSubMenu(mainMenu, "Employees", 'View the business employees', true)
	local addEmployee = NativeUI.CreateItem('Add Employee', 'Add an employee to the business')
	addEmployee.Activated = function(parentmenu, selected)
		local source = KeyboardInput('Enter server ID')
		if tonumber(source) then
			employeesMenu:Visible(false)
			TriggerServerEvent('carDealership:addEmployee', tonumber(source))
		end
	end
	employeesMenu:AddItem(addEmployee)
	for steam, name in pairs(businessData.employees) do
		local employee = _menuPool:AddSubMenu(employeesMenu, steam, 'Manage '..name, true)
		local remove = NativeUI.CreateItem('Remove Employee', 'Fire the employee from the business')
		local promote = NativeUI.CreateItem('Promote Employee', 'Promote the employee to a manager')
		remove.Activated = function(parentmenu, selected)
			employee:Visible(false)
			TriggerServerEvent('carDealership:fireEmployee', steam, name)
		end
		promote.Activated = function(parentmenu, selected)
			employee:Visible(false)
			TriggerServerEvent('carDealership:promoteEmployee', steam, name)
		end
		employeesMenu:AddItem(employee)
		employee:AddItem(remove)
		employee:AddItem(promote)
	end
	mainMenu:AddItem(employeesMenu)
	local managersMenu = _menuPool:AddSubMenu(mainMenu, "Managers", "View the business managers", true)
	for steam, name in pairs(businessData.managers) do
		if steam ~= playerSteam then
			local manager = _menuPool:AddSubMenu(managersMenu, steam, 'Manage '..name, true)
			local remove = NativeUI.CreateItem('Remove Manager', 'Fire the manager from the business')
			local demote = NativeUI.CreateItem('Demote Manager', 'Demote the manager to an employee')
			remove.Activated = function(parentmenu, selected)
				manager:Visible(false)
				TriggerServerEvent('carDealership:fireEmployee', steam, name)
			end
			demote.Activated = function(parentmenu, selected)
				manager:Visible(false)
				TriggerServerEvent('carDealership:demoteManager', steam, name)
			end
			mainMenu:AddItem(managersMenu)
			manager:AddItem(remove)
			manager:AddItem(demote)
		end
	end
	mainMenu:AddItem(managersMenu)
	local businessFinance = _menuPool:AddSubMenu(mainMenu, 'Finance', 'View the business finance', true)
	local businessBalance = NativeUI.CreateItem('~r~Business Funds: $'..math.floor(businessData.businessBalance)..'.00', 'Balance of the business account')
	local setPayrate = NativeUI.CreateItem('Set Employee Paycheck', 'Employees are currently paid: $'..businessData.employeePay)
	local withdrawMoney = NativeUI.CreateItem('Withdraw Funds', 'Funds available: $'..math.floor(businessData.businessBalance))
	local depositMoney = NativeUI.CreateItem('Deposit Funds', 'Funds available: $'..math.floor(businessData.businessBalance))
	setPayrate.Activated = function(parentmenu, selected)
		newPayrate = KeyboardInput('Enter new paycheck', tostring(businessData.employeePay), 4)
		if tonumber(newPayrate) then
			TriggerServerEvent('carDealership:setEmployeePayrate', newPayrate)
		end
		businessFinance:Visible(false)
	end 
	withdrawMoney.Activated = function(parentmenu, selected)
		amount = KeyboardInput('Enter amount to withdraw', '', 10)
		if tonumber(amount) then
			TriggerServerEvent('carDealership:withdrawMoney', amount)
		end 
		businessFinance:Visible(false)
	end
	depositMoney.Activated = function(parentmenu, selected)
		amount = KeyboardInput('Enter amount to deposit', '', 10)
		if tonumber(amount) then
			TriggerServerEvent('carDealership:depositMoney', amount)
		end
		businessFinance:Visible(false)
	end
	mainMenu:AddItem(businessFinance)
	businessFinance:AddItem(businessBalance)
	businessFinance:AddItem(setPayrate)
	businessFinance:AddItem(withdrawMoney)
	businessFinance:AddItem(depositMoney)
	CreateEmployeeMenu()
end

function CreateEmployeeMenu()
	_menuPool:Clear()
	local showroomMenu = _menuPool:AddSubMenu(mainMenu, "Showroom", 'Manage vehicles in the showroom', true)
	for i = 1, 6 do
		local slot = _menuPool:AddSubMenu(showroomMenu, 'Vehicle Slot '..i, 'Amend the vehicle in slot '..i, true)
		for category, items in pairs(vehicles) do
			local category_submenu = _menuPool:AddSubMenu(slot, category, "View " .. category.. ' vehicles', true)
			for x = 1, #items do
			  local item = NativeUI.CreateItem("($" .. items[x].price .. ") " .. items[x].make .. " " .. items[x].model, " (Storage Capacity: " .. items[x].storage_capacity .. ")")
			  item.Activated = function(parentmenu, selected)
			  	TriggerServerEvent('carDealership:updateShowroomSlot', 'slot'..i, category, x)
			  end
			  category_submenu:AddItem(item)
			end
		end
	end
end

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Premium Deluxe", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		_menuPool:MouseControlsEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:ProcessMenus()
		for k, v in pairs(showroomData) do
			local vehicleData = showroomData[k]
			if vehicleData.vehiclePrice then
				DrawText3D(vehicleData.position.x, vehicleData.position.y, vehicleData.position.z+1.5, 5, '[ALT + E] - Buy (~g~$'..vehicleData.vehiclePrice..'.00~s~)')
			end
		end
		if IsControlJustPressed(0, 38) then
			if Vdist(GetEntityCoords(playerPed), -27.70, -1104.03, 26.42) < 3.0 then
				TriggerServerEvent('carDealership:toggleMenu')
			end
		end
		DrawText3D(-27.70, -1104.03, 26.42, 3, '[E] - Management')
	end
end)


function DrawText3D(x, y, z, distance, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
      SetTextScale(0.35, 0.35)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 215)
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
      local factor = (string.len(text)) / 500
      DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
  end
end

function UpdateShowroom()
	Citizen.CreateThread(function()
		for _, veh in pairs(spawnedVehicles) do
			SetEntityAsMissionEntity(veh)
			DeleteVehicle(veh)
		end
		for k, v in pairs(showroomData) do
			local vehicleData = showroomData[k]
			if vehicleData.vehicleModel then
				if type(vehicleData.vehicleModel) == 'string' then
					vehicleHash = GetHashKey(showroomData[k].vehicleModel)
					print(vehicleHash)
				else
					vehicleHash = vehicleData.vehicleModel
				end
				RequestModel(vehicleHash)
		        while not HasModelLoaded(vehicleHash) do
		            Citizen.Wait(100)
		        end
				local vehicle = CreateVehicle(vehicleHash, vehicleData.position.x, vehicleData.position.y, vehicleData.position.z, vehicleData.position.heading, false)
				FreezeEntityPosition(vehicle, true)
				SetVehicleDoorsLocked(vehicle, 2)
				SetVehicleDoorsLockedForAllPlayers(vehicle, true)
				table.insert(spawnedVehicles, vehicle)
			end
		end
	end)
end

function KeyboardInput(textEntry, inputText, maxLength) -- Thanks to Flatracer for the function.
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end