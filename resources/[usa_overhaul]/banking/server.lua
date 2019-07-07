local balances = {}

AddEventHandler('playerDropped', function()
	balances[source] = nil
end)

-- HELPER FUNCTIONS
function bankBalance(player)
	return exports["usa-characters"]:GetCharacterField(player, "bank")
end

function deposit(player, amount)
	if amount <= 0 then
		local bankbalance = bankBalance(player)
		local new_balance = bankbalance + math.abs(amount)
		balances[player] = new_balance

		local char = exports["usa-characters"]:GetCharacter(player)
		char.giveBank(math.abs(amount))

		TriggerClientEvent("banking:updateBalance", player, new_balance)
	end
end

function withdraw(player, amount)
	local bankbalance = bankBalance(player)
	local new_balance = bankbalance - math.abs(amount)
	balances[player] = new_balance

	local char = exports["usa-characters"]:GetCharacter(player)
	char.removeBank(math.abs(amount))

	TriggerClientEvent("banking:updateBalance", player, new_balance)
end

function round(num, numDecimalPlaces)
	if num and numDecimalPlaces then
		local mult = 10^(numDecimalPlaces or 0)
		return math.abs(math.floor(num * mult + 0.5) / mult)
	end
end

local notAllowedToDeposit = {}

AddEventHandler('bank:addNotAllowed', function(pl)
	notAllowedToDeposit[pl] = true

	local savedSource = pl
	SetTimeout(300000, function()
		notAllowedToDeposit[savedSource] = nil
	end)
end)

-- Bank Deposit
RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local char = exports["usa-characters"]:GetCharacter(source)
	if notAllowedToDeposit[source] == nil then
		local rounded = math.ceil(tonumber(amount))
		if(string.len(rounded) >= 9) then
			TriggerClientEvent('usa:notify', source, "Amount to deposit too high!")
		else
			local money = char.get("money")
			local bank = char.get("bank")
			if (rounded <= money and rounded > 0) then
				print("BANK: Updating balance of "..GetPlayerName(source).."["..GetPlayerIdentifier(source).."] after depositing money["..rounded.."], with new bank total of bank["..bank.."] and money["..money.."]!")
				TriggerClientEvent("banking:updateBalance", source, (bank + rounded))
				TriggerClientEvent("banking:addBalance", source, rounded)
				char.removeMoney(rounded)
				char.giveBank(rounded)
			else
				TriggerClientEvent('usa:notify', source, "You do not have enough cash!")
			end
		end
	else
		TriggerClientEvent('usa:notify', source, "The bank has rejected your deposit!")
	end
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local char = exports["usa-characters"]:GetCharacter(source)
    local rounded = round(tonumber(amount), 0)
    if (string.len(tostring(rounded)) >= 9) then
    	TriggerClientEvent('usa:notify', source, "Amount to withdraw too high!")
    else
        local money = char.get("money")
		local bank = char.get("bank")
		if bank and tonumber(rounded) then
			if (tonumber(rounded) <= tonumber(bank)) then
				print("BANK: Updating balance of "..GetPlayerName(source).."["..GetPlayerIdentifier(source).."] after withdrawing money["..rounded.."], with new bank total of bank["..bank.."] and money["..money.."]!")
			  	TriggerClientEvent("banking:updateBalance", source, (bank - rounded))
			 	TriggerClientEvent("banking:removeBalance", source, rounded)
				char.giveMoney(rounded)
				char.removeBank(rounded)
			else
			  TriggerClientEvent('usa:notify', source, "Amount to withdraw is over allowance!")
			end
		end
   	end
end)

-- Give Cash
TriggerEvent('es:addCommand', 'givecash', function(source, args, user)
	local fromPlayer
	local toPlayer
	local amount
	if (args[2] ~= nil and tonumber(args[3]) > 0) then
		fromPlayer = tonumber(source)
		toPlayer = tonumber(args[2])
		local char = exports["usa-characters"]:GetCharacter(toPlayer)
		if char then
			local to_user_name = char.getFullName()
			amount = math.ceil(tonumber(args[3]))
			TriggerClientEvent('bank:givecash', source, toPlayer, amount, "test", source)
		end
	else
		TriggerClientEvent('usa:notify', fromPlayer, "~y~Usage: ~s~givecash <id> <amount>")
	end
end, {
	help = "give cash to another player",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "money", help = "Amount of money" }
	}
})

AddEventHandler('rconCommand', function(cmd, args)
	if cmd == "setbank" then
		local target = tonumber(args[1])
		local newAmount = tonumber(args[2])
		if GetPlayerName(target) and newAmount and newAmount > 0 then
			exports["usa-characters"]:SetCharacterField(target, "bank", newAmount)
			TriggerClientEvent('chatMessage', target, "", {255, 255, 255}, "^2^*[SERVER] ^r^0Your bank has been set to ^2^*" .. newAmount..'^r^0.')
			TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Bank of ^2'..GetPlayerName(target)..' ['..target..'] ^0 has been set to ^2^*'..newAmount..'^r^0 by ^2^*console^r^0.')
			print('Bank set!')
			CancelEvent()
		end
	elseif cmd == "givebank" then
		local target = tonumber(args[1])
		local amountToGive = tonumber(args[2])
		if GetPlayerName(target) and newAmount and newAmount > 0 then
			local char = exports["usa-characters"]:GetCharacter(target)
			char.giveBank(amountToGive)
			TriggerClientEvent('chatMessage', target, "", {255, 255, 255}, "^2^*[SERVER] ^r^0You have received ^2^*" .. amount..'^r^0 in your bank.')
			TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(target)..' ['..target..'] ^0 has received ^2^*'..amountToGive..'^r^0 bank money from ^2^*console^r^0.')
			print('Bank set!')
			CancelEvent()
		end
	end
end)

RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
	local char = exports["usa-characters"]:GetCharacter(source)
	local recipient = exports["usa-characters"]:GetCharacter(toPlayer)
	if GetPlayerName(toPlayer) then
		local from_money = char.get("money")
		if (tonumber(from_money) >= tonumber(amount)) then
			char.removeMoney(amount)
			recipient.giveMoney(amount)
			TriggerClientEvent('usa:notify', source, "You've given " .. toPlayer .. " $" .. comma_value(amount))
			TriggerClientEvent('chatMessage', source, "", {}, "You've given " .. toPlayer .. " $" .. comma_value(amount))
			TriggerClientEvent('usa:notify', toPlayer, source .. " has given you $" .. comma_value(amount))
			TriggerClientEvent('chatMessage', toPlayer, "", {}, source .. " has given you $" .. comma_value(amount))
		else
			if (tonumber(from_money) < tonumber(amount)) then
				TriggerClientEvent('usa:notify', toPlayer, "You do not have enough cash!")
			end
		end
	else
		TriggerClientEvent('usa:notify', toPlayer, "Player not found!")
	end
end)

RegisterServerEvent("bank:showBankBalance")
AddEventHandler("bank:showBankBalance", function()
	local bank = exports["usa-characters"]:GetCharacterField(source, "bank")
	TriggerClientEvent("usa:notify", source, "Bank Balance: ~s~$" .. comma_value(bank))
end)

TriggerEvent('es:addCommand', 'bank', function(source, args, char)
	local bank = char.get("bank")
	TriggerClientEvent("usa:notify", source, "Bank Balance: ~s~$" .. comma_value(bank))
end, { help = "view bank balance" })

function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end
