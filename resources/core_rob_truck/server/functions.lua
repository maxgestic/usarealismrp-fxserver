local Functions = {}

Citizen.CreateThread(function()
	if cfg.framework == "esx" then
		TriggerEvent('esx:getSharedObject', function(obj) Functions = obj end)
	end
	if cfg.framework == "qbcore" then
		Functions = exports['qb-core']:GetCoreObject()
	end
	if cfg.framework == "vrp" then
		local Proxy = module("vrp", "lib/Proxy")
		Functions = Proxy.getInterface("vRP")
	end
	if cfg.framework == "vrpex" then
		local Proxy = module("vrp", "lib/Proxy")
		Functions = Proxy.getInterface("vRP")
	end
end)

RegisterServerEvent('CORE_ROB_TRUCK:CheckIfItemExists_s') -- THIS EVENT CHECKS FOR ITEMS
AddEventHandler('CORE_ROB_TRUCK:CheckIfItemExists_s',function(player,item,itemamount,cb)
	if cfg.framework == "standalone" then
		local char = exports["usa-characters"]:GetCharacter(player)
        if char.hasItem(item, itemamount) then
			cb(true)
		else
			cb(false)
		end
	end
end)
RegisterServerEvent('CORE_ROB_TRUCK:GiveItem_s') -- THIS EVENT ADDS ITEMS
AddEventHandler('CORE_ROB_TRUCK:GiveItem_s',function(player,item,amount)
	if cfg.framework == "standalone" then
		local char = exports["usa-characters"]:GetCharacter(player)
		if item == "money" then
			char.set("money", char.get("money") + amount)
			TriggerClientEvent("usa:notify",player, "You got $"..amount..".")
		else
			if item == "Stolen Goods" then
				local nItem = {name = "Stolen Goods", price = math.random(50, 300), legality = "illegal", quantity = amount, type = "misc", weight = 2.0 }
				char.giveItem(nItem)
				TriggerClientEvent("usa:notify",player, "You got "..nItem.name..".")
			else	
				local nItem = { name = item, quantity = amount, legality = "illegal", weight = 3 }
				char.giveItem(nItem)
				TriggerClientEvent("usa:notify",player, "You got "..nItem.name..".")
			end
		end
	end
	TriggerEvent("CORE_ROB_TRUCK:Log_s","giveitem",player,{item = item,amount = amount})
end)
RegisterServerEvent('CORE_ROB_TRUCK:RemoveItem_s') -- THIS EVENT REMOVES ITEMS
AddEventHandler('CORE_ROB_TRUCK:RemoveItem_s', function(player,item,amount)
	if cfg.framework == "standalone" then
		local char = exports["usa-characters"]:GetCharacter(player)
		local hasItem = char.hasItem(item)
		if hasItem then
			char.removeItem(item, amount)
		end
		if item == "Bank Laptop" then
			Wait(25000)
			TriggerClientEvent("usa:notify", player, "Your laptop overheated and broke!")
		end
	end
end)
RegisterServerEvent('CORE_ROB_TRUCK:CheckForPolice_s') -- THIS EVENT CHECKS FOR POLICE
AddEventHandler('CORE_ROB_TRUCK:CheckForPolice_s', function(cb)
	if cfg.framework == "standalone" then
		local sasp = exports["usa-characters"]:GetNumCharactersWithJob("sheriff")
		local bcso = exports["usa-characters"]:GetNumCharactersWithJob("corrections")
		local copsOnline = sasp + bcso
		if copsOnline >= cfg.policeneeded then
			cb(true)
		end 
		if copsOnline < cfg.policeneeded then cb(false) end
		-- print("THERE ARE "..copsOnline.." COP(S) ON DUTY")
	end
end)
RegisterServerEvent('CORE_ROB_TRUCK:CallCops_s') -- THIS EVENT CALLS THE COPS
AddEventHandler('CORE_ROB_TRUCK:CallCops_s',function(_coords)
	local coords = _coords
	if cfg.framework == "standalone" then
        TriggerEvent('911:BankTruck', coords.x, coords.y, coords.z)
    end
end)
RegisterServerEvent('CORE_ROB_TRUCK:Notification_s') -- THIS EVENT CALLS AN NOTIFICATION
AddEventHandler('CORE_ROB_TRUCK:Notification_s',function(player,msg)
	TriggerClientEvent("CORE_ROB_TRUCK:Notification_c",player,msg)
end)
RegisterServerEvent('CORE_ROB_TRUCK:Log_s') -- THIS EVENT CALLS AN LOG
AddEventHandler('CORE_ROB_TRUCK:Log_s',function(type,player,data)
	if logs.active then
		local identifiers = GetPlayerIdentifiers(player)
		local ids = {["rockstar"] = "Unknown",["discord"] = "Unknown",["ip"] = "Unknown",["steam"] = "Unknown",}
		local embeds = nil
		for k,v in pairs(identifiers) do
			if string.match(v, "license") then ids["rockstar"] = split(v,":")[math.floor(2)] end
			if string.match(v, "discord") then ids["discord"] = split(v,":")[math.floor(2)] end
			if string.match(v, "steam") then ids["steam"] = split(v,":")[math.floor(2)] end
			if string.match(v, "ip") then ids["ip"] = split(v,":")[math.floor(2)] end
		end
		if type == "start" then
			embeds = {{
				["color"] = math.floor(16711680),
				["title"] = logs.log[type].title,
				["description"] = "**[LOG] : "..logs.log[type].msg.."**\n **[DATE] : "..os.date("%x").."**\n **[TIME] : "..os.date("%X").."**\n\n **PLAYER DATA**\n\n **[PLAYER] : "..GetPlayerName(player).."**\n **[DISCORD] : <@"..ids["discord"]..">**\n **[ROCKSTAR] : "..ids["rockstar"].."**\n **[STEAM] : "..ids["steam"].."\n** **[IP] : "..ids["ip"].."**",
				["footer"] = {
					["text"] = logs.log[type].footer,
				},
			}}
		end
		if type == "giveitem" then
			embeds = {{
				["color"] = math.floor(16711680),
				["title"] = logs.log[type].title,
				["description"] = "**[LOG] : "..logs.log[type].msg.." "..data.item.." x"..data.amount.."**\n **[DATE] : "..os.date("%x").."**\n **[TIME] : "..os.date("%X").."**\n\n **PLAYER DATA**\n\n **[PLAYER] : "..GetPlayerName(player).."**\n **[DISCORD] : <@"..ids["discord"]..">**\n **[ROCKSTAR] : "..ids["rockstar"].."**\n **[STEAM] : "..ids["steam"].."\n** **[IP] : "..ids["ip"].."**",
				["footer"] = {
					["text"] = logs.log[type].footer,
				},
			}}
		end
		PerformHttpRequest(logs.log[type].webhook,function(err,text,headers)end,'POST',json.encode({username=logs.log[type].username,embeds=embeds,avatar_url=logs.log[type].avatar}), {['Content-Type']='application/json'})
	end
end)
function split(str, sep) local array = {} local reg = string.format("([^%s]+)", sep) for mem in string.gmatch(str, reg) do table.insert(array, mem) end return array end

-- Testing Phase
-- TriggerEvent('es:addCommand', 'testingitems', function(source, args, char)
--     local char = exports["usa-characters"]:GetCharacter(source)
--     local itemOne = { name = "Bank Laptop", type = "misc",  quantity = 1,  legality = "legal", notStackable = true,  weight = 10,  objectModel = "imp_prop_impexp_tablet" }
--     local itemTwo = { name = "Sticky Bomb", type = "weapon", hash = GetHashKey("WEAPON_STICKYBOMB"), quantity = 1, weight = 25, objectModel = "prop_bomb_01_s" }
-- 	local itemThree = { name = "Crumpled Paper", type = "misc", quantity = 1, legality = "legal", notStackable = true, weight = 1, objectModel = "prop_paper_ball"}
--     char.giveItem(itemOne)
--     char.giveItem(itemTwo)
-- 	char.giveItem(itemThree)
-- end, { help = "For bank truck" })

-- TriggerEvent('es:addCommand', 'getweed', function(source, args, char)
--     local char = exports["usa-characters"]:GetCharacter(source)
--     local drug = {name = "Packaged Weed", quantity = 10, weight = 1.0, type = "drug", legality = "illegal", objectModel = "bkr_prop_weed_bag_01a"}
--     char.giveItem(drug)
-- end, { help = "For hints" })