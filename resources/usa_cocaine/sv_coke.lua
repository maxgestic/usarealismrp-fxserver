--
--  MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.
--

local uncutCocaine = {
    name = "Uncut Cocaine",
    legality = "illegal",
    quantity = 1,
    type = "chemical",
    weight = 10
}

local cocaineProduced = {
	name = "Packaged Cocaine",
	type = "drug",
	legality = "illegal",
	quantity = 1,
	weight = 6
}

RegisterServerEvent("cocaineJob:giveUncut")
AddEventHandler("cocaineJob:giveUncut", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.canHoldItem(uncutCocaine) then
	  	char.giveItem(uncutCocaine)
	else
		TriggerClientEvent("usa:notify", source, "Your inventory is full. Can't carry anymore!")
	end
end)

RegisterServerEvent("cocaineJob:givePackaged")
AddEventHandler("cocaineJob:givePackaged", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.canHoldItem(cocaineProduced) then
    char.removeItem("Uncut Cocaine")
  	char.giveItem(cocaineProduced)
		TriggerClientEvent("usa:notify", source, "You have successfully proccessed the uncut cocaine into packaged product!")
	else
		TriggerClientEvent("usa:notify", source, "Your inventory is full. Can't carry anymore!")
	end
end)

RegisterServerEvent('cocaineJob:completeDelivery')
AddEventHandler('cocaineJob:completeDelivery', function()
	TriggerClientEvent("cocaine:validateDelivery", source)
end)

RegisterServerEvent("cocaine:exploitDetected")
AddEventHandler("cocaine:exploitDetected", function()
	exports["es_admin"]:BanPlayer(source, "Modding (code injection). If you feel this was a mistake please let a staff member know.")
end)

RegisterServerEvent("cocaine:locationValidated")
AddEventHandler("cocaine:locationValidated", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local reward = math.random(1500, 2400)
	-- bonus when police are online --
	local policeOnline = exports["usa-characters"]:GetNumCharactersWithJob("sheriff")
	local bonus = 0
	if policeOnline >= 2 then
		bonus = math.floor((reward * 1.10) - reward)
	end
	if char.hasItem("Packaged Cocaine") then
		char.removeItem("Packaged Cocaine", 1)
		TriggerClientEvent('usa:notify', source, 'You have been paid $'.. exports.globals:comma_value(reward + bonus) ..'~s~.')
		char.giveMoney(reward + bonus)
		print('COCAINE: Player '..GetPlayerName(source)..'['..GetPlayerIdentifier(source)..'] has completed cocaine delivery and received money['..reward..'] with bonus['..bonus..']!')
	end
end)

RegisterServerEvent('cocaineJob:residueRazor')
AddEventHandler('cocaineJob:residueRazor', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local razor = char.getItem("Razor Blade")
	if razor and not razor.residue then
		char.modifyItem("Razor Blade", "residue", true)
		TriggerClientEvent('usa:notify', source, 'Your Razor Blade has traces of cocaine.')
	end
end)

RegisterServerEvent("cocaineJob:checkUserJobSupplies")
AddEventHandler("cocaineJob:checkUserJobSupplies", function(jobItem, jobSupply)
	local hasJobItem = false
	local hasJobSupply = false
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.hasItem(jobItem) then
		hasJobItem = true
	end

	if char.hasItem(jobSupply) then
        if hasJobItem then
            char.removeItem(jobSupply, 1)
        end
		hasJobSupply = true
	end

	TriggerClientEvent("cocaineJob:doesUserHaveJobSupply", source, hasJobItem, hasJobSupply)
end)

RegisterServerEvent('cocaineJob:doesUserHaveProductToSell')
AddEventHandler('cocaineJob:doesUserHaveProductToSell', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.hasItem("Packaged Cocaine") then
		TriggerClientEvent('cocaineJob:doesUserHaveProductToSell', source, true)
	else
		TriggerClientEvent('cocaineJob:doesUserHaveProductToSell', source, false)
	end
end)

RegisterServerEvent("cocaineJob:startTimer")
AddEventHandler("cocaineJob:startTimer", function(timerType)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(source)
	local messages = {
		"Hurdle on friend, just wait up here...",
		"In the market for this junk? Interesting, wait here.",
		"Lester, the molester. Be right back.",
		"This'll kill you before your genes do, but I don't judge. Be right back.",
		"Perfect, we're on our heads. Just wait here."
	}
	TriggerClientEvent("usa:notify", source, messages[math.random(1, tonumber(#messages))])
	if timerType == "coke_supplies_ped" then
		local seconds = 45 -- must be synced with DrawTimer on client
		local time = seconds * 1000
		SetTimeout(time, function()
			TriggerClientEvent("chatMessage", usource, "", {}, "^3Lester:^0 Alright, let me know if you need more. Go and cut this first at that warehouse down on the docks (make sure you have a Razor Blade) and then look for the red pill on your map to deliver the final product.")
			TriggerClientEvent('cocaineJob:setDelivery', usource)
			TriggerClientEvent("cocaineJob:returnPedToStartPosition", usource, timerType)
			local uncutCocaine = {
				name = "Uncut Cocaine",
				legality = "illegal",
				quantity = 1,
				type = "chemical",
				weight = 10
			}
			char.giveItem(uncutCocaine)
		end)
	end
end)

RegisterServerEvent("cocaineJob:checkUserMoney")
AddEventHandler("cocaineJob:checkUserMoney", function(supplyType)
	local amount = 200
	local char = exports["usa-characters"]:GetCharacter(source)
	local uncut_cocaine = {
		name = "coke bruh",
		weight = 10,
		quantity = 1,
		type = "drug"
		}
	if char.canHoldItem(uncut_cocaine) then
		local money = char.get("money")
		if money >= amount then
		  TriggerClientEvent("cocaineJob:getSupplies", source)
		  char.removeMoney(amount)
		else
		  TriggerClientEvent("usa:notify", source, "Come back when you have ~y~$" .. amount .. "~w~ to get the cocaine!")
		end
	else
		TriggerClientEvent("usa:notify", source, "Inventory is full!")
	end
end)
