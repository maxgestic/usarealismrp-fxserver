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

RegisterServerEvent("cocaineJob:giveUncut")
AddEventHandler("cocaineJob:giveUncut", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	char.giveItem(uncutCocaine, 1)
end)

RegisterServerEvent("cocaineJob:checkUserMoney")
AddEventHandler("cocaineJob:checkUserMoney", function(supplyType)
	local amount = 200
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.canHoldItem(uncutCocaine) then
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
