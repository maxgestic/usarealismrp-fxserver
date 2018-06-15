local balances = {}

AddEventHandler('es:playerLoaded', function(source, user)
		local bank = user.getActiveCharacterData("bank")
		balances[source] = bank

		TriggerClientEvent('banking:updateBalance', source, bank)
end)

RegisterServerEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local bank = user.getActiveCharacterData("bank")
		balances[source] = bank

		TriggerClientEvent('banking:updateBalance', source, bank)
	end)
end)

AddEventHandler('playerDropped', function()
	balances[source] = nil
end)

-- HELPER FUNCTIONS
function bankBalance(player)
	return exports.essentialmode:getPlayerFromId(player).getActiveCharacterData("bank")
end

function deposit(player, amount)
		if amount <= 0 then
			local bankbalance = bankBalance(player)
			local new_balance = bankbalance + math.abs(amount)
			balances[player] = new_balance

			local user = exports.essentialmode:getPlayerFromId(player)
			TriggerClientEvent("banking:updateBalance", source, new_balance)
			local user_bank = user.getActiveCharacterData("bank")
			local new_bank = user_bank + math.abs(amount)
			user.setActiveCharacterData("bank", new_bank)
	else
			print("can't deposit a negative value, mr/mrs: " .. GetPlayerName(player))
	end
end

function withdraw(player, amount)
	local bankbalance = bankBalance(player)
	local new_balance = bankbalance - math.abs(amount)
	balances[player] = new_balance

	local user = exports.essentialmode:getPlayerFromId(player)
	TriggerClientEvent("banking:updateBalance", source, new_balance)
	local user_bank = user.getActiveCharacterData("bank")
	local new_bank = user_bank - math.abs(amount)
	user.setActiveCharacterData("bank", new_bank)
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
local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		if notAllowedToDeposit[userSource] == nil then
			local rounded = math.ceil(tonumber(amount))
			print("rounded = " .. rounded)
			if(string.len(rounded) >= 9) then
				TriggerClientEvent('chatMessage', userSource, "", {0, 0, 200}, "^1Input too high^0")
			else
					local user_money = user.getActiveCharacterData("money")
					local user_bank = user.getActiveCharacterData("bank")
				if(rounded <= user_money and rounded > 0) then
					--TriggerClientEvent("banking:updateBalance", userSource, (user.getBank() + rounded))
					--TriggerClientEvent("banking:addBalance", userSource, rounded)
		 print("updating user balance! " .. (user_bank + rounded))
					TriggerClientEvent("banking:updateBalance", userSource, (user_bank + rounded))
					TriggerClientEvent("banking:addBalance", userSource, rounded)
					user.setActiveCharacterData("money", user_money - rounded)
					user.setActiveCharacterData("bank", user_bank + rounded)
					--deposit(userSource, rounded)
					--local new_balance = user.getBank()
				else
					TriggerClientEvent('chatMessage', userSource, "", {0, 0, 200}, "^1Not enough cash!^0")
				end
			end
		else
				TriggerClientEvent('es_rp:notify', userSource, "~r~You cannot deposit recently stolen money, please wait 5 minutes.")
		end
	end)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
local userSource = tonumber(source)
  TriggerEvent('es:getPlayerFromId', userSource, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(tostring(rounded)) >= 9) then
        TriggerClientEvent('chatMessage', userSource, "", {0, 0, 200}, "^1Input too high^0")
      else
          local user_bank = user.getActiveCharacterData("bank")
           local user_money = user.getActiveCharacterData("money")
        local bankbalance = user_bank
		if bankbalance and tonumber(rounded) then
			if(tonumber(rounded) <= tonumber(bankbalance)) then
			  TriggerClientEvent("banking:updateBalance", userSource, (user_bank - rounded))
			 TriggerClientEvent("banking:removeBalance", userSource, rounded)

			  --withdraw(userSource, rounded)
			  user.setActiveCharacterData("money", user_money + rounded)
			  user.setActiveCharacterData("bank", user_bank - rounded)
			else
			  TriggerClientEvent('chatMessage', userSource, "", {0, 0, 200}, "^1Not enough money in account!^0")
			end
		end
      end
  end)
end)

-- Bank Transfer
TriggerEvent('es:addCommand', 'transfer', function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {0, 0, 200}, "^3Sorry, transferring is currently out of order!")
    --[[
  local fromPlayer
  local toPlayer
  local amount
  --TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3Sorry, this command is still under construction!")
  if (args[2] ~= nil and tonumber(args[3]) > 0) then
    fromPlayer = tonumber(source)
    toPlayer = tonumber(args[2])
    amount = tonumber(args[3])
    TriggerClientEvent('bank:transfer', source, fromPlayer, toPlayer, amount)
	else
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Use format /transfer [id] [amount]^0")
    return false
  end
  --]]
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {0, 0, 200}, "^3Sorry, transferring is currently out of order!")
    --[[
  if tonumber(fromPlayer) == tonumber(toPlayer) then
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Cannot transfer to self^0")
  else
    TriggerEvent('es:getPlayerFromId', fromPlayer, function(user)
        local rounded = round(tonumber(amount), 0)
        if(string.len(rounded) >= 9) then
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Input too high^0")
        else
          local bankbalance = user.getBank()
          if(tonumber(rounded) <= tonumber(bankbalance)) then
            TriggerClientEvent("banking:updateBalance", source, (user.getBank() - rounded))
            TriggerClientEvent("banking:removeBalance", source, rounded)
            print("removing " .. rounded .. " from player " .. fromPlayer .. " bank")
            --user.removeBank(rounded)
            --user.setBankBalance(bankbalance - rounded)
            withdraw(source, rounded)
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Transferred: ~r~-$".. rounded .." ~n~~s~New Balance: ~g~$" .. user.getBank())
            TriggerEvent('es:getPlayerFromId', toPlayer, function(user2)
              TriggerClientEvent("banking:updateBalance", toPlayer, (user2.getBank() + rounded))
              TriggerClientEvent("banking:addBalance", toPlayer, rounded)
              print("adding " .. rounded .. " from player " .. toPlayer .. " bank")
              --user.addBank(rounded)
              --user.setBankBalance(user2.getBank() + rounded)
                --local recipient = user2.get('identifier')
                deposit(toPlayer, rounded)
                --new_balance2 = user2.getBank()
            end)
          else
            TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Not enough money in account!^0")
          end
        end
    end)
  end
  --]]
end)

-- Give Cash
TriggerEvent('es:addCommand', 'givecash', function(source, args, user)
	local fromPlayer
	local toPlayer
	local amount
	local from_user_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
	if (args[2] ~= nil and tonumber(args[3]) > 0) then
		fromPlayer = tonumber(source)
		toPlayer = tonumber(args[2])
		local toUser = exports["essentialmode"]:getPlayerFromId(toPlayer)
		--TriggerEvent("es:getPlayerFromId", toPlayer, function(toUser)
		if toUser then
			local to_user_name = toUser.getActiveCharacterData("fullName")
			amount = tonumber(args[3])
			amount = round(amount, 0)
			--TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Giving " .. to_user_name .. " ^2$" .. amount .. "^0...");
			TriggerClientEvent('bank:givecash', source, toPlayer, amount, from_user_name, source)
		end
		--end)
	else
		TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Use format /givecash [id] [amount]^0")
		return false
	end
end, {
	help = "give cash to another player",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "money", help = "Amount of money" }
	}
})

RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local user_money_1 = user.getActiveCharacterData("money")
		if (tonumber(user_money_1) >= tonumber(amount)) then
			user.setActiveCharacterData("money", user_money_1 - amount)
			--TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
			local recipient = exports["essentialmode"]:getPlayerFromId(toPlayer)
			local user_money_2 = recipient.getActiveCharacterData("money")
			recipient.setActiveCharacterData("money", user_money_2 + amount)
			TriggerClientEvent("usa:notify", source, "You gave " .. recipient.getActiveCharacterData("fullName") .. " ~y~$".. amount)
			TriggerClientEvent("usa:notify", toPlayer, user.getActiveCharacterData("fullName") .. " gave you ~g~$".. amount)
			TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^0You gave " .. recipient.getActiveCharacterData("fullName") .. " ^3$".. amount)
			TriggerClientEvent('chatMessage', toPlayer, "", {0, 0, 200}, "^0" .. user.getActiveCharacterData("fullName") .. " gave you ^2$".. amount)
			--end)
		else
			if (tonumber(user_money_1) < tonumber(amount)) then
				TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Not enough money in wallet!^0")
			end
		end
	end)
end)

TriggerEvent('es:addCommand', 'bank', function(source, args, user)
	local user_bank = user.getActiveCharacterData("bank")
	TriggerClientEvent("usa:notify", source, "Bank: $" .. comma_value(user_bank))
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
