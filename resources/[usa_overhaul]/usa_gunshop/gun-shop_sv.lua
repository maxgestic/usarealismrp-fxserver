local sv_storeWeapons = {
  ["Melee"] = {
    { name = "Flashlight", type = "weapon", hash = -1951375401, price = 200, legality = "legal", quantity = 1, weight = 5, objectModel = "p_cs_police_torch_s" },
    { name = "Hammer", type = "weapon", hash = 1317494643, price = 50, legality = "legal", quantity = 1, weight = 5, objectModel = "prop_tool_hammer" },
    { name = "Knife", type = "weapon", hash = -1716189206, price = 200, legality = "legal", quantity = 1, weight = 3, objectModel = "w_me_knife_01" },
    { name = "Bat", type = "weapon", hash = -1786099057, price = 100, legality = "legal", quantity = 1, weight = 10, objectModel = "w_me_bat" },
    { name = "Crowbar", type = "weapon", hash = -2067956739, price = 150, legality = "legal", quantity = 1, weight = 10, objectModel = "w_me_crowbar" },
    { name = "Hatchet", type = "weapon", hash = -102973651, price = 250, legality = "legal", quantity = 1, weight = 8, objectModel = "w_me_hatchet" },
    { name = "Wrench", type = "weapon", hash = 419712736, price = 400, legality = "legal", quantity = 1, weight = 10, objectModel = "prop_tool_wrench" },
    { name = "Machete", type = "weapon", hash = -581044007, price = 250, legality = "legal", quantity = 1, weight = 7, objectModel = "prop_ld_w_me_machette" },
    { name = "Nightstick", type = "weapon", hash = 1737195953, price = 500, legality = "legal", quantity = 1, weight = 7, objectModel = "w_me_nightstick" }

  },
  ["Handguns"] = {
    { name = "Pistol", type = "weapon", hash = 453432689, price = 600, legality = "legal", quantity = 1, weight = 6, objectModel = "w_pi_pistol" },
    { name = "Heavy Pistol", type = "weapon", hash = -771403250, price = 1500, legality = "legal", quantity = 1, weight = 9, objectModel = "w_pi_heavypistol" },
    { name = ".50 Caliber", type = "weapon", hash = -1716589765, price = 2000, legality = "legal", quantity = 1, weight = 8, objectModel = "w_pi_pistol50" },
    { name = "SNS Pistol", type = "weapon", hash = -1076751822, price = 800, legality = "legal", quantity = 1, weight = 3, objectModel = "w_pi_sns_pistol" },
    { name = "Combat Pistol", type = "weapon", hash = 1593441988, price = 800, legality = "legal", quantity = 1, weight = 6, objectModel = "w_pi_combatpistol" },
    { name = "MK2", type = "weapon", hash = 3219281620, price = 1250, legality = "legal", quantity = 1, weight = 6 },
    { name = "Vintage Pistol", type = "weapon", hash = 137902532, price = 1250, legality = "legal", quantity = 1, weight = 9, objectModel = "w_pi_vintage_pistol" },
    --{ name = "Stun Gun", type = "weapon", hash = 911657153, price = 1500, legality = "legal", quantity = 1, weight = 5, objectModel = "w_pi_stungun" }
    --{ name = "Marksman Pistol", type = "weapon", hash = -598887786, price = 1000, legality = "legal", quantity = 1, weight = 15 }

  },
  ["Shotguns"] = {
    { name = "Pump Shotgun", type = "weapon", hash = 487013001, price = 4000, legality = "legal", quantity = 1, weight = 20, objectModel = "w_sg_pumpshotgun" },
    { name = "Bullpup Shotgun", type = "weapon", hash = -1654528753, price = 6000, legality = "legal", quantity = 1, weight = 25, objectModel = "w_sg_bullpupshotgun" },
    { name = "Musket", type = "weapon", hash = -1466123874, price = 1500, legality = "legal", quantity = 1, weight = 30, objectModel = "w_ar_musket" },
    { name = "Firework Gun", type = "weapon", hash = 2138347493, price = 10000, legality = "legal", quantity = 1, weight = 50, objectModel = "w_lr_firework" }
  },
  ["Extras"] = {
    { name = "Parachute", type = "weapon", hash = "GADGET_PARACHUTE", price = 500, legality = "legal", quantity = 1, weight = 20, objectModel = "prop_parachute" },
    { name = "Body Armor", type = "misc", price = 1000, legality = "legal", quantity = 1, weight = 20, objectModel = "prop_bodyarmour_03" }
  }
}

local LICENSE_PURCHASE_PRICE = 7000

exports["globals"]:PerformDBCheck("usa_gunshop", "legalweapons")

RegisterServerEvent("gunShop:requestPurchase")
AddEventHandler("gunShop:requestPurchase", function(category, index)
  local usource = source
  local weapon = sv_storeWeapons[category][index]
  local char = exports["usa-characters"]:GetCharacter(usource)
  local permit_status = checkPermit(char)
  if permit_status == "valid" then
    local money = char.get("money")
    if money - sv_storeWeapons[category][index].price >= 0 then
  	  local user_weapons = char.getWeapons()
  	  if (#user_weapons >= 3 and weapon.type == "weapon") or not char.canHoldItem(weapon) then
  		  TriggerClientEvent("usa:notify", source, "Cannot carry more than 3 weapons, or full inventory!")
  		  return
  	  end
      local timestamp = os.date("*t", os.time())
      local letters = {}
      for i = 65,  90 do table.insert(letters, string.char(i)) end -- add capital letters
      local serialEnding = math.random(100000, 999999)
      local serialLetter = letters[math.random(#letters)]
      weapon.uuid = math.random(999999999)
      weapon.serialNumber = serialLetter .. serialEnding
      local weaponDB = {}
      weaponDB.name = weapon.name
      weaponDB.serialNumber = serialLetter .. serialEnding
      weaponDB.ownerName = char.getFullName()
      weaponDB.ownerDOB = char.get('dateOfBirth')
      weaponDB.issueDate = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year
      char.giveItem(weapon, 1)
      char.removeMoney(sv_storeWeapons[category][index].price)
      TriggerClientEvent("mini:equipWeapon", usource, sv_storeWeapons[category][index].hash) -- equip
      TriggerClientEvent('gunShop:addRecentlyPurchased', usource)
      TriggerClientEvent('usa:notify', usource, 'Purchased: ~y~'..weapon.name..'\n~s~Serial Number: ~y~'..weapon.serialNumber..'\n~s~Price: ~y~$'..sv_storeWeapons[category][index].price)
      TriggerEvent('es:exposeDBFunctions', function(couchdb)
        couchdb.createDocumentWithId("legalweapons", weaponDB, weaponDB.serialNumber, function(success)
            if success then
                print("* Weapon created serial["..weaponDB.serialNumber.."] name["..weaponDB.name.."] owner["..weaponDB.ownerName.."] *")
            else
                print("* Error: Weapon failed to be created!! *")
            end
        end)
      end)
    else
      TriggerClientEvent("usa:notify", source, "Not enough money!")
    end
  elseif permit_status == "suspended" then
    TriggerClientEvent("usa:notify", usource, "Your permit is suspended!")
  elseif permit_status == "none" then
    TriggerClientEvent("usa:notify", usource, "You do not have a valid ~y~Firearm Permit~s~!")
  end
end)

RegisterServerEvent('gunShop:requestOpenMenu')
AddEventHandler('gunShop:requestOpenMenu', function()
  local char = exports["usa-characters"]:GetCharacter(source)
  local permit_status = checkPermit(char)
  if permit_status == 'valid' then
    TriggerClientEvent('gunShop:openMenu', source)
  else
    TriggerClientEvent('usa:notify', source, 'No license! Hold E to purchase one for $' .. comma_value(LICENSE_PURCHASE_PRICE))
  end
end)

RegisterServerEvent("gunShop:purchaseLicense")
AddEventHandler("gunShop:purchaseLicense", function()
  local timestamp = os.date("*t", os.time())
  local char = exports["usa-characters"]:GetCharacter(source)
  local NEW_GUN_LICENSE = {
    name = 'Gun License',
    number = 'GL' .. tostring(math.random(1, 254367)),
    quantity = 1,
    ownerName = char.getFullName(),
    issued_by = "Ammunation",
    ownerDob = char.get("dateOfBirth"),
    expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
    status = "valid",
    type = "license",
    notDroppable = true,
    weight = 2.0
  }
  if char.hasItem(NEW_GUN_LICENSE) then
    TriggerClientEvent("usa:notify", source, "You already have a gun license!")
    return
  end
  if char.canHoldItem(NEW_GUN_LICENSE) then
    char.giveItem(NEW_GUN_LICENSE)
    char.removeMoney(LICENSE_PURCHASE_PRICE)
    TriggerClientEvent("usa:notify", source, "You have been issued a pilot's license!")
  else
    TriggerClientEvent("usa:notify", source, "Inventory full!")
  end
end)

function checkPermit(char)
  local license = char.getItem("Gun License")
  if license then
    return license.status
  end
  return "none"
end

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
