-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			--Citizen.InvokeNative(0x170F541E1CADD1DE, false)
			--Citizen.InvokeNative(0x0772DF77852C2E30, 1, 1)

			TriggerServerEvent('es:firstJoinProper')
			TriggerEvent('es:allowedToSpawn')
			return
		end
	end
end)

local loaded = false
local cashy = 0
local oldPos

--[[
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local pos = GetEntityCoords(GetPlayerPed(-1))

		if(oldPos ~= pos)then
			--TriggerServerEvent('es:updatePositions', pos.x, pos.y, pos.z)

			if(loaded)then
				SendNUIMessage({
					setmoney = true,
					money = cashy
				})

				loaded = false
			end
			oldPos = pos
		end
	end
end)
--]]

local myDecorators = {}

RegisterNetEvent("es:setPlayerDecorator")
AddEventHandler("es:setPlayerDecorator", function(key, value, doNow)
	myDecorators[key] = value
	DecorRegister(key, 3)

	if(doNow)then
		DecorSetInt(GetPlayerPed(-1), key, value)
	end
end)

local firstSpawn = true
AddEventHandler("playerSpawned", function()
	for k,v in pairs(myDecorators)do
		DecorSetInt(GetPlayerPed(-1), k, v)
	end

	if firstSpawn then
		firstSpawn = false
		--SetMultiplayerBankCash()
	--	N_0xc2d15bef167e27bc()
	--	SetPlayerCashChange(1, 1)
	--	Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	--	SetPlayerCashChange(-1, -1)
	end
end)

RegisterNetEvent('es:setMoneyIcon')
AddEventHandler('es:setMoneyIcon', function(i)
	SendNUIMessage({
		seticon = true,
		icon = i
	})
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(e)
	SendNUIMessage({
		setmoney = true,
		money = e
	})
end)

RegisterNetEvent('es:displayMoney')
AddEventHandler('es:displayMoney', function(a)
	-- Found by FiveM forum user @Lobix300
	--N_0xc2d15bef167e27bc()
	--SetPlayerCashChange(1, 0)
	--Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	--SetPlayerCashChange(a - 1, 0)
end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(a)
	-- Found by FiveM forum user @Lobix300
	--SetMultiplayerBankCash()
	--SetPlayerCashChange(0, 1)
	--Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	--SetPlayerCashChange(0, a - 1)
end)

RegisterNetEvent("es:addedMoney")
AddEventHandler("es:addedMoney", function(m, native)

	if not native then
		SendNUIMessage({
			addcash = true,
			money = m
		})
	else
		--Citizen.InvokeNative(0x170F541E1CADD1DE, true)
		--Citizen.InvokeNative(0x0772DF77852C2E30, math.floor(m), 0)
	end

end)

RegisterNetEvent("es:removedMoney")
AddEventHandler("es:removedMoney", function(m, native, current)
	if not native then
		SendNUIMessage({
			removecash = true,
			money = m
		})
	else
		--Citizen.InvokeNative(0x170F541E1CADD1DE, true)
		--Citizen.InvokeNative(0x0772DF77852C2E30, -math.floor(m), 0)
	end
end)

RegisterNetEvent('es:addedBank')
AddEventHandler('es:addedBank', function(m)
	--Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	--Citizen.InvokeNative(0x0772DF77852C2E30, 0, math.floor(m))
end)

RegisterNetEvent('es:removedBank')
AddEventHandler('es:removedBank', function(m)
	--Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	--Citizen.InvokeNative(0x0772DF77852C2E30, 0, -math.floor(m))
end)

RegisterNetEvent("es:setMoneyDisplay") -- briefly display money
AddEventHandler("es:setMoneyDisplay", function(val, amount)
	if not amount then
		SendNUIMessage({
			setDisplay = true,
			display = val
		})
	else
		SendNUIMessage({
			setDisplay = true,
			display = val,
			amount = amount
		})
	end
	Wait(5000)
	SendNUIMessage({
		setDisplay = true,
		display = 0
	})
end)

RegisterNetEvent("es:enablePvp")
AddEventHandler("es:enablePvp", function()
	NetworkSetFriendlyFireOption(true)
	Citizen.CreateThread(function()
		local lastSavedPed = nil
		while true do
			local currentPed = PlayerPedId()
			if lastSavedPed ~= currentPed then
				lastSavedPed = currentPed
				if DoesEntityExist(currentPed) then
					SetCanAttackFriendly(currentPed, true, true)
				end
			end
			Wait(1000)
		end
	end)
end)
