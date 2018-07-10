--# Weapon components & tints shop, two kinds -- illegal and legal, each at different locations.
--# for USA REALISM RP
--# by: minipunch

local ITEMS = { -- must be kept in sync with one in cl_weaponeaxtrashop.lua --
  ["Tints"] = {
    [0] = {name = "Normal", price = 100},
    [1] = {name = "Green", price = 400},
    [2] = {name = "Gold", price = 1000},
    [3] = {name = "Pink", price = 600},
    [4] = {name = "Army", price = 500},
    [5] = {name = "LSPD", price = 600},
    [6] = {name = "Orange", price = 500},
    [7] = {name = "Platinum", price = 1000}
  },
  ["Components"] = {
    legal = {
      -- pistols --
      ["Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = 453432689},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_PISTOL_VARMOD_LUXE", price = 3000, weapon_hash = 453432689}
      },
      ["SNS Pistol"] = {
        {name = "Etched Wood Grip Finish", value = "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER", price = 2000, weapon_hash = -1076751822}
      },
      ["Heavy Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = -771403250},
        {name = "Etched Wood Grip Finish", value = "COMPONENT_HEAVYPISTOL_VARMOD_LUXE", price = 2000, weapon_hash = -771403250}
      },
      ["Combat Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = 1593441988},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER", price = 3000, weapon_hash = 1593441988}
      },
      [".50 Cal Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = -1716589765},
        {name = "Platinum Pearl Deluxe Finish", value = "COMPONENT_PISTOL50_VARMOD_LUXE", price = 2700, weapon_hash = -1716589765}
      },
      ["Revolver"] = {
        {name = "Variation 1", value = "COMPONENT_REVOLVER_VARMOD_BOSS", price = 1200, weapon_hash = -1045183535},
        {name = "Variation 2", value = "COMPONENT_REVOLVER_VARMOD_GOON", price = 1200, weapon_hash = -1045183535}
      },
      -- Shotguns --
      ["Pump Shotgun"] = {
        {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 900, weapon_hash = 487013001},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER", price = 3000, weapon_hash = 487013001}
      },
      ["Bullpup Shotgun"] = {
        {name = "Grip", value = "COMPONENT_AT_AR_AFGRIP", price = 700, weapon_hash = -1654528753}
      }
    },
    illegal = {
      -- pistols --
      ["Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_PISTOL_CLIP_02", price = 4500, weapon_hash = 453432689},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP_02", price = 6000, weapon_hash = 453432689}
      },
      ["SNS Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_SNSPISTOL_CLIP_02", price = 4500, weapon_hash = -1076751822}
      },
      ["Heavy Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_HEAVYPISTOL_CLIP_02", price = 4500, weapon_hash = -771403250},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = -771403250}
      },
      ["Combat Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_COMBATPISTOL_CLIP_02", price = 4500, weapon_hash = 1593441988},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = 1593441988}
      },
      [".50 Cal Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_PISTOL50_CLIP_02", price = 4500, weapon_hash = -1716589765},
        {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP_02", price = 6000, weapon_hash = -1716589765}
      },
      ["Vintage Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_VINTAGEPISTOL_CLIP_02", price = 4500, weapon_hash = 137902532},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = 137902532}
      },
      ["AP Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = 584646201},
        {name = "Extended Magazine", value = "COMPONENT_APPISTOL_CLIP_02", price = 4500, weapon_hash = 584646201},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = 584646201},
        {name = "Gilded Gun Metal Finish", value = "COMPONENT_APPISTOL_VARMOD_LUXE", price = 2700, weapon_hash = 584646201}
      },
      -- other --
      ["Switchblade"] = {
          {name = "Variation 1", value = "COMPONENT_SWITCHBLADE_VARMOD_VAR1", price = 2500, weapon_hash = -538741184}
      },
      ["Brass Knuckles"] = {
        {name = "Stock", value = "COMPONENT_KNUCKLE_VARMOD_BASE", price = 500, weapon_hash = -656458692},
        {name = "Pimp", value = "COMPONENT_KNUCKLE_VARMOD_PIMP", price = 900, weapon_hash = -656458692},
        {name = "Ballas", value = "COMPONENT_KNUCKLE_VARMOD_BALLAS", price = 900, weapon_hash = -656458692},
        {name = "Dollars", value = "COMPONENT_KNUCKLE_VARMOD_DOLLAR", price = 900, weapon_hash = -656458692},
        {name = "Diamond", value = "COMPONENT_KNUCKLE_VARMOD_DIAMOND", price = 900, weapon_hash = -656458692},
        {name = "Hate", value = "COMPONENT_KNUCKLE_VARMOD_HATE", price = 900, weapon_hash = -656458692},
        {name = "Love", value = "COMPONENT_KNUCKLE_VARMOD_LOVE", price = 900, weapon_hash = -656458692},
        {name = "Player", value = "COMPONENT_KNUCKLE_VARMOD_PLAYER", price = 900, weapon_hash = -656458692},
        {name = "King", value = "COMPONENT_KNUCKLE_VARMOD_KING", price = 900, weapon_hash = -656458692},
        {name = "Vagos", value = "COMPONENT_KNUCKLE_VARMOD_VAGOS", price = 900, weapon_hash = -656458692}
      },
      ["Sawn Off Shotgun"] = {
          {name = "Gilded Gun Metal Finish", value = "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE", price = 2500, weapon_hash = 2017895192}
      },
      ["Pump Shotgun"] = {
          {name = "Suppressor", value = "COMPONENT_AT_SR_SUPP", price = 6200, weapon_hash = 487013001}
      },
      ["Micro SMG"] = {
          {name = "Extended Magazine", value = "COMPONENT_MICROSMG_CLIP_02", price = 4500, weapon_hash = 324215364},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MACRO", price = 5500, weapon_hash = 324215364},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP_02", price = 6000, weapon_hash = 324215364},
          {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 1500, weapon_hash = 324215364},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_MICROSMG_VARMOD_LUXE", price = 3000, weapon_hash = 324215364}
      },
      ["SMG"] = {
          {name = "Extended Magazine", value = "COMPONENT_SMG_CLIP_02", price = 4500, weapon_hash = 736523883},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MACRO_02", price = 5500, weapon_hash = 736523883},
          {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = 736523883},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 1500, weapon_hash = 736523883},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_SMG_VARMOD_LUXE", price = 3000, weapon_hash = 736523883}
      },
      ["Machine Pistol"] = {
          {name = "Extended Magazine", value = "COMPONENT_MACHINEPISTOL_CLIP_02", price = 4500, weapon_hash = -619010992},
          {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = -619010992}
      },
      ["Tommy Gun"] = {
          {name = "Extended Magazine", value = "COMPONENT_GUSENBERG_CLIP_02", price = 4500, weapon_hash = 1627465347}
      },
      ["AK47"] = {
          {name = "Extended Magazine", value = "COMPONENT_ASSAULTRIFLE_CLIP_02", price = 3500, weapon_hash = -1074790547},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MACRO", price = 5500, weapon_hash = -1074790547},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP_02", price = 6500, weapon_hash = -1074790547},
          {name = "Grip", value = "COMPONENT_AT_AR_AFGRIP", price = 3500, weapon_hash = -1074790547},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 3500, weapon_hash = -1074790547},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE", price = 4000, weapon_hash = -1074790547}
      },
      ["Carbine Rifle"] = {
          {name = "Extended Magazine", value = "COMPONENT_CARBINERIFLE_CLIP_02", price = 4500, weapon_hash = -2084633992},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MEDIUM", price = 5500, weapon_hash = -2084633992},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP", price = 6500, weapon_hash = -2084633992},
          {name = "Grip", value = "COMPONENT_AT_AR_AFGRIP", price = 3500, weapon_hash = -2084633992},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 3500, weapon_hash = -2084633992},
          {name = "Rail Cover", value = "COMPONENT_AT_RAILCOVER_01", price = 3500, weapon_hash = -2084633992},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_CARBINERIFLE_VARMOD_LUXE", price = 4000, weapon_hash = -2084633992}
      },
      ["Bullpup Rifle"] = {
          {name = "Extended Magazine", value = "COMPONENT_BULLPUPRIFLE_CLIP_02", price = 4500, weapon_hash = 2132975508},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_SMALL", price = 5500, weapon_hash = 2132975508},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP", price = 6500, weapon_hash = 2132975508},
          {name = "Grip", value = "COMPONENT_AT_AR_AFGRIP", price = 3500, weapon_hash = 2132975508},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 3500, weapon_hash = 2132975508},
          {name = "Gilded Gun Metal Finish", value = "COMPONENT_BULLPUPRIFLE_VARMOD_LOW", price = 4000, weapon_hash = 2132975508}
      },
      ["Assault SMG"] = {
          {name = "Extended Magazine", value = "COMPONENT_ASSAULTSMG_CLIP_02", price = 4500, weapon_hash = -270015777},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MACRO", price = 5500, weapon_hash = -270015777},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP_02", price = 6500, weapon_hash = -270015777},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 3500, weapon_hash = -270015777},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER", price = 4000, weapon_hash = -270015777}
      }
    }
  }
}

RegisterServerEvent("weaponExtraShop:requestTintPurchase")
AddEventHandler("weaponExtraShop:requestTintPurchase", function(tintId, wephash, property)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local tint = ITEMS["Tints"][tintId]
  local user_weapons = user.getActiveCharacterData("weapons")
  for i = 1, #user_weapons do
    if user_weapons[i].hash == wephash then
      print("found matching weapon hash! saving tint!")
      local user_money = user.getActiveCharacterData("money")
      if tint.price <= user_money then -- see if user has enough money
        user.setActiveCharacterData("money", user_money - tint.price)
        TriggerClientEvent("usa:notify", source, "You have purchased a ~y~" .. tint.name .. "~w~ weapon tint.")
        TriggerClientEvent("weaponExtraShop:applyTint", source, tintId)
        --TriggerClientEvent("bikeShop:toggleMenu", source, false)
        user_weapons[i].tint = tintId
        user.setActiveCharacterData("weapons", user_weapons)
        -- give money to property owner --
        if property then
          TriggerEvent("properties:addMoney", property.name, math.ceil(0.40 * tint.price))
        end
      else
        TriggerClientEvent("usa:notify", source, "Not enough money!")
      end
      return
    end
  end
end)

RegisterServerEvent("weaponExtraShop:requestComponentPurchase")
AddEventHandler("weaponExtraShop:requestComponentPurchase", function(weapon, componentIndex, wephash, legal, property)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local component
  if legal then
    component = ITEMS["Components"].legal[weapon][componentIndex]
  else
    component = ITEMS["Components"].illegal[weapon][componentIndex]
  end
  local user_weapons = user.getActiveCharacterData("weapons")
  for i = 1, #user_weapons do
    if user_weapons[i].hash == wephash then
      print("found matching weapon hash! saving component!")
      local user_money = user.getActiveCharacterData("money")
      if component.price <= user_money then -- see if user has enough money
        user.setActiveCharacterData("money", user_money - component.price)
        TriggerClientEvent("usa:notify", source, "You have purchased a ~y~" .. component.name .. "~w~ weapon component.")
        TriggerClientEvent("weaponExtraShop:applyComponent", source, component)
        --TriggerClientEvent("bikeShop:toggleMenu", source, false)
        if not user_weapons[i].components then
          user_weapons[i].components = {}
        end
        table.insert(user_weapons[i].components, component.value)
        user.setActiveCharacterData("weapons", user_weapons)
        -- give money to property owner --
        if property then
          TriggerEvent("properties:addMoney", property.name, math.ceil(0.40 * component.price))
        end
      else
        TriggerClientEvent("usa:notify", source, "Not enough money!")
      end
      return
    end
  end
  TriggerClientEvent("usa:notify", source, "You don't own that weapon!")
end)
