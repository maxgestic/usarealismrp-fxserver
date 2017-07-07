require "resources/essentialmode/lib/MySQL"

-- MySQL:open("IP", "databasname", "user", "pw")
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "minipunch", "redlego123")

local MAX_PLAYER_WEAPON_SLOTS = 3

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function getPlayerIdentifierEasyMode(source)
	local rawIdentifiers = GetPlayerIdentifiers(source)
	if rawIdentifiers then
		for key, value in pairs(rawIdentifiers) do
			playerIdentifier = value
		end
    else
		print("IDENTIFIERS DO NOT EXIST OR WERE NOT RETIREVED PROPERLY")
	end
	return playerIdentifier -- should usually be only 1 identifier according to the wiki
end

function setPlayerInventory(source, inventory)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        user.inventory = inventory
    end)
end

function addPlayerItem(source, inventory, item)
    table.insert(inventory, item)
    setPlayerInventory(source, inventory)
end

function playerHasMaxWeapons(targetPlayerId, inventory)
	local count = 0
	for i = 1, #inventory do
		if inventory[i].type == "weapon" then
			count = count + 1
		end
	end
	if count >= MAX_PLAYER_WEAPON_SLOTS then
		return true
	else
		return false
	end
end

function removeWeaponFromInventory(targetPlayerId, inventory, weapon)
	local removed = false
	for i = 1, #inventory do
		if inventory[i].name == weapon.name and not removed then
			table.remove(inventory, i)
			removed = true
			setPlayerInventory(targetPlayerId, inventory)
			return
		end
	end
end

RegisterServerEvent("gunShop:buyPermit")
AddEventHandler("gunShop:buyPermit", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        user:setMoney(user.money - 2000)
        local timestamp = os.date("*t", os.time())
        local permit = {
            name = "Firearm Permit",
            number = "G" .. tostring(math.random(1, 254367)),
            quantity = 1,
            ownerName = GetPlayerName(source),
            expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
            status = "valid"
        }
        if user.inventory ~= nil then
            table.insert(user.inventory, permit)
        else
            print("setting user.inventory = {} inside of gunShop:buyPermit")
            user.inventory = "{}"
        end
    end)
end)

RegisterServerEvent("gunShop:checkPermit")
AddEventHandler("gunShop:checkPermit", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local inventory = user.inventory
		if inventory == nil then
			print("PLAYER TRIED TO USE GUN-SHOP BUT INVENTORY WAS NIL")
			inventory = {}
			user.inventory = {}
		end
        if inventory ~= nil and #inventory > 0 then
            for i = 1, #inventory do
				if i <= #inventory and i ~= 0 then
                    print("inside gunShop:checkPermit with #inventory = " .. #inventory)
                    if inventory[i] ~= nil then
                        print("inventory[1].name = " .. inventory[1].name)
    					local item = inventory[i]
    					if item.name == "Firearm Permit" then
    						TriggerClientEvent("gunShop:showGunShopMenu", source)
    						return
    					end
                    end
				end
            end
            TriggerClientEvent("gunShop:showNoPermitMenu", source)
        else
            TriggerClientEvent("gunShop:showNoPermitMenu", source)
            print("#INVENTORY <= 0 IN GUN SHOP")
        end
    end)
end)

RegisterServerEvent("gunShop:refreshWeaponList")
AddEventHandler("gunShop:refreshWeaponList", function()

    TriggerEvent('es:getPlayerFromId', source, function(user)
        local inventory = user.inventory
		local weapons = {}
		local index = 1
        if inventory ~= nil then
    		for i = 1, #inventory do
    			if inventory[i].type == "weapon" then
    				weapons[index] = inventory[i]
    				index = index + 1
    			end
    		end
		    TriggerClientEvent("gunShop:refreshWeapons", source, weapons)
        else
            print("inventory was nil during weapon list refresh")
        end
    end)

end)

RegisterServerEvent("gunShop:sellWeapon")
AddEventHandler("gunShop:sellWeapon",function(weapon)
	local weapons = {}
	local index = 1
	TriggerEvent('es:getPlayerFromId', source, function(user)
		user:setMoney(round(user.money + .50*(weapon.price), 0))
        local inventory = user.inventory
        local weapons = {}
        if inventory ~= nil then
            for i = 1, #inventory do
                if inventory[i].name == weapon.name then
                    table.remove(inventory,i)
                    break
                end
            end
        else
            print("inventory was nil during gunShop:sellWeapon")
        end
        removeWeaponFromInventory(source, inventory, weapon)
        TriggerClientEvent("gunShop:refreshWeapons", source, weapons)
	end)
	if Menu then
		Menu.hidden = true
	end
end)

RegisterServerEvent("mini:checkGunMoney")
AddEventHandler("mini:checkGunMoney", function(weapon)
	TriggerEvent('es:getPlayerFromId', source, function(user)
        print("weapon.name = " .. weapon.name)
        print("weapon.hash = " .. weapon.hash)
        print("type(weapon.hash) = " .. type(weapon.hash))
        print("user = " .. user)
        print("user.inventory = " .. user.inventory)
		local inventory = user.inventory
        if inventory ~= nil then
    		if not playerHasMaxWeapons(source, inventory) then
                print("player with source = " .. source .. " doesn't have max weapons")
    				if weapon.price <= user.money then -- see if user has enough money
    					TriggerClientEvent("mini:equipWeapon", source, source, weapon.hash, weapon.name) -- equip
    					user:setMoney(user.money - weapon.price) -- subtract price from user's money and store resulting amount
    					-- update db/inventory
    					addPlayerItem(source, inventory, weapon)
    					TriggerClientEvent("chatMessage", source, "Gun Store", {41, 103, 203}, "^0You now own a ^3" .. weapon.name .. "^0!")
    				else
    					TriggerClientEvent("mini:insufficientFunds", source, weapon.price, "gun")
    				end

    		else
    			TriggerClientEvent("chatMessage", source, "Gun Store", {41, 103, 203}, "^1All weapon slots full! (" .. MAX_PLAYER_WEAPON_SLOTS .. "/" .. MAX_PLAYER_WEAPON_SLOTS .. ")") -- all slots full, notify user
    		end

        end
    end)
end)
