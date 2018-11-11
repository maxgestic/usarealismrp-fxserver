randomPrice = true --Random the price of each stations
price = 20 --If random price is on False, set the price here for 1 liter

local players = {}
local serverEssenceArray = {}
local StationsPrice = {}

RegisterServerEvent("essence:addPlayer")
AddEventHandler("essence:addPlayer", function()
	local _source = source
	TriggerClientEvent("essence:sendPrice", _source, StationsPrice)
	table.insert(players,_source)
end)


RegisterServerEvent("essence:playerSpawned")
AddEventHandler("essence:playerSpawned", function()
	local _source = source
	SetTimeout(2000, function()
		TriggerClientEvent("essence:sendPrice", _source, StationsPrice)
		--TriggerClientEvent("essence:sendEssence", _source, serverEssenceArray)
	end)
end)

AddEventHandler("playerDropped", function(reason)
	local _source = source
	local newPlayers = {}

	for _,k in pairs(players) do
		if(k~=_source) then
			table.insert(newPlayers, k)
		end
	end

	players = {}
	players = newPlayers
end)

RegisterServerEvent("essence:refuelWithJerryCan")
AddEventHandler("essence:refuelWithJerryCan", function(essence, vplate, vmodel)
	local percent = math.random(65, 75)
	local new_amount = (percent/100)*0.142
	local _source = source
	local bool, ind = searchByModelAndPlate(vplate, vmodel)
	if(bool and ind ~= nil) then
		if serverEssenceArray[ind].es < new_amount then
			serverEssenceArray[ind].es = new_amount -- set to 75% of a full tank
			TriggerClientEvent("usa:notify", _source, "Refuel complete!")
		else
			TriggerClientEvent("usa:notify", _source, "Tank already filled!")
		end
	else
		if(vplate ~= nil and vmodel~= nil) then
			table.insert(serverEssenceArray,{plate=vplate,model=vmodel,es=new_amount})
			TriggerClientEvent("usa:notify", _source, "Refuel complete!")
		end
	end
end)

RegisterServerEvent("essence:setToAllPlayerEscense")
AddEventHandler("essence:setToAllPlayerEscense", function(essence, vplate, vmodel)
	local _source = source
	local bool, ind = searchByModelAndPlate(vplate, vmodel)
	if(bool and ind ~= nil) then
		serverEssenceArray[ind].es = essence
	else
		if(vplate ~=nil and vmodel~=nil and essence ~=nil) then
			table.insert(serverEssenceArray,{plate=vplate,model=vmodel,es=essence})
			print("inserted vehicle: " .. vmodel)
		end
	end
end)

RegisterServerEvent("essence:buy")
AddEventHandler("essence:buy", function(amount, index, e, property)
	local _source = source


	local price = StationsPrice[index]

	if(e) then
		price = index
	end

	--TriggerEvent("es:getPlayerFromId", _source,function(user)

	local user = exports["essentialmode"]:getPlayerFromId(_source)

		local userJob = user.getActiveCharacterData("job")
		local user_money = user.getActiveCharacterData("money")
		local toPay = round(amount*70,0)
		if userJob == "sheriff" or userJob == "ems" or userJob == "fire" or userJob == "corrections" then
			TriggerClientEvent("essence:hasBuying", _source, amount)
			-- give some money to store owner --
			if property then
				TriggerEvent("properties:addMoney", property.name, round(0.20 * toPay, 0))
			end
		else
			toPay = round(amount*price,0)
			if(toPay > user_money) then
					TriggerClientEvent("showNotif", _source, "~r~You don't have enough money.")
			else
				user.setActiveCharacterData("money", user_money - toPay)
				print("user.getJob() was not sheriff/ems/fire: " .. userJob)

				TriggerClientEvent("essence:hasBuying", _source, amount)
			end
			-- give some money to store owner --
			if property then
				TriggerEvent("properties:addMoney", property.name, round(0.20 * toPay, 0))
			end
		end
	--end)

end)


RegisterServerEvent("essence:requestPrice")
AddEventHandler("essence:requestPrice",function()
	TriggerClientEvent("essence:sendPrice", source, StationsPrice)
end)


RegisterServerEvent("vehicule:getFuel")
AddEventHandler("vehicule:getFuel", function(plate,model)
	local _source = source
	local bool, ind = searchByModelAndPlate(plate, model)

	if(bool) then
		TriggerClientEvent("vehicule:sendFuel", _source, 1, serverEssenceArray[ind].es)
	else
		TriggerClientEvent("vehicule:sendFuel", _source, 0, 0)
	end
end)


function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end


function renderPrice()
    for i=0,34 do
        if(randomPrice) then
            StationsPrice[i] = math.random(15,35)
        else
        	StationsPrice[i] = price
        end
    end
end


renderPrice()

function searchByModelAndPlate(plate, model)

	if(plate ~= nil and model ~= nil) then
		for i,k in pairs(serverEssenceArray) do
			if(k.plate == plate and k.model == model) then
				return true, i
			end
		end
	end

	return false, -1
end
