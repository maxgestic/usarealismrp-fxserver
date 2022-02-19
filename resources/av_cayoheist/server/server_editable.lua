webhook = nil -- Your Discord webhook for logs.

-- Framework
CreateThread(function()
	if Config.Framework == 'ESX' then
		ESX = nil
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	elseif Config.Framework == 'QB' then
		QBCore = exports['qb-core']:GetCoreObject()
	end
	while not cargado do
		Citizen.Wait(100)
	end
	print('^2[AV Cayo Heist]:^7 '..Config.Framework..' Framework')
	RegisterServerCallback {
		eventName = 'av_cayoheist:inicio', 
		eventCallback = function(source, ...)
		return data
	end}
	TriggerClientEvent('av_cayoheist:doors:initialize', -1, doorState)
end)

-- Rewards
RegisterServerEvent('av_cayoheist:rewards')
AddEventHandler('av_cayoheist:rewards', function(codigo, type, securityToken)
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
	if data['z'] ~= codigo then
		local src = source
		local user = GetPlayerName(src)
		local content = {
			{
				["color"] = '5015295',
				["title"] = "**AV Scripts**",
				["description"] = "**".. user .."** got caught Cheating",
				["footer"] = {
					["text"] = "AV SCRIPTS",
				},
			}
		}
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = user, embeds = content}), { ['Content-Type'] = 'application/json' })
		DropPlayer(src, 'C H E A T E R')
		return
	end
	if Config.Framework == 'ESX' then
		local xPlayer = ESX.GetPlayerFromId(source)
		if type == 'Panther' then
			xPlayer.addInventoryItem(Config.PantherItem, 1)
		else
			local reward = Config.Rewards[type]
			xPlayer.addAccountMoney('black_money',reward)
			TriggerClientEvent('av_cayoheist:notify',source,Config.Lang['moneyreward']..reward)
		end
	elseif Config.Framework == 'QB' then
		local Player = QBCore.Functions.GetPlayer(source)
		if type == 'Panther' then
			Player.Functions.AddItem(Config.PantherItem, 1)
		else
			local reward = Config.Rewards[type]
			Player.Functions.AddMoney('cash', reward, '')
		end
	else
		-- Insert your Custom addItem and GiveMoney function here
		local char = exports["usa-characters"]:GetCharacter(source)
		if type == 'Panther' then
			print("giving panther item!")
			local pantherItem = {
				name = "Panther",
				type = "misc",
				quantity = 1,
				weight = 25.0,
				objectModel = "v_club_vu_statue"
			}
			char.giveItem(pantherItem)
		else
			local moneyReward = Config.Rewards[type]
			char.giveMoney(moneyReward)
			TriggerClientEvent("usa:notify", source, "You found $" .. exports.globals:comma_value(moneyReward), "INFO: You found $" .. exports.globals:comma_value(moneyReward))
		end
	end
end)

-- Get Online Cops
RegisterServerCallback {eventName = 'av_cayoheist:getCops', eventCallback = function(source)
	local cops = CopsCount()
	return cops
end}

-- Item Check
RegisterServerCallback { eventName = 'av_cayoheist:hasItem', eventCallback = function(source, itemName, remove)
	if Config.Framework == 'ESX' then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getInventoryItem(itemName).count >= 1 then
			return true
		else
			return false
		end
	elseif Config.Framework == 'QB' then
		local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
		local item = xPlayer.Functions.GetItemByName(itemName)
		if xPlayer.PlayerData.items ~= nil then
			if item ~= nil then
				if item.amount >= 1 then
					return true
				else
					return false
				end
			else
				return false
			end
			return false
		end
	else
		local char = exports["usa-characters"]:GetCharacter(source)
		local hasItem = char.hasItem(itemName)
		if hasItem and remove then
			char.removeItem(itemName, 1)
		end
		return hasItem
	end
end}

local zones = {}

RegisterServerCallback { eventName = 'av_cayoheist:isZoneBusy', eventCallback = function(source, zoneIndex)
	return zones[zoneIndex]
end}

RegisterServerEvent('av_cayoheist:setZoneBusy')
AddEventHandler('av_cayoheist:setZoneBusy', function(zoneIndex, val)
	zones[zoneIndex] = val
end)

-- C4 Remove
RegisterServerEvent('av_cayoheist:removeC4')
AddEventHandler('av_cayoheist:removeC4', function()
	local itemName = Config.C4Item
	if Config.Framework == 'ESX' then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getInventoryItem(itemName).count >= 1 then
			xPlayer.removeInventoryItem(itemName,1)
		end
	elseif Config.Framework == 'QB' then
		local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
		local item = xPlayer.Functions.GetItemByName(itemName)
		if xPlayer.PlayerData.items ~= nil then
			if item ~= nil then
				if item.amount >= 1 then
					xPlayer.Functions.RemoveItem(itemName, 1, false)
					TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[itemName], "remove")
				end
			end
		end
	elseif Config.Framework == '' then
		-- Remove the C4 item
		print("removing C-4 item!")
		local char = exports["usa-characters"]:GetCharacter(source)
		char.removeItem("C-4", 1)
	end
end)

-- Get Cops Function
function CopsCount()
	if Config.Framework == 'ESX' then
		local xPlayers = ESX.GetPlayers()
		local cops = 0		
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == Config.PoliceJobName then
				cops = cops + 1
			end		
		end 
		return cops
	elseif Config.Framework == 'QB' then
		local cops = 0
		for k, v in pairs(QBCore.Functions.GetPlayers()) do
			local Player = QBCore.Functions.GetPlayer(v)
			if Player ~= nil then 
				if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
					cops = cops + 1
				end
			end
		end
		return cops
	else
		local ret = nil
		exports.globals:getNumCops(function(num)
			ret = num
		end)
		while ret == nil do
			Wait(1)
		end
		return ret
	end
end

RegisterServerEvent('av_cayoheist:removeGoods')
AddEventHandler('av_cayoheist:removeGoods', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.hasItem("Panther") then
		char.removeItem("Panther", 1)
	end
	char.removeMoney(char.get("money"))
	TriggerClientEvent("usa:notify", source, "The cartel took their stuff back!")
end)