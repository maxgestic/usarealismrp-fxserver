local markets = {
    ['marketA'] = {
        ['coords'] = {363.83, -1830.4, 28.5},
        ['items'] = {
            {name = 'Pistol', type = 'weapon', hash = 453432689, price = 3000, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(1, 3), objectModel = "w_pi_pistol"},
            {name = 'Vintage Pistol', type = 'weapon', hash = 137902532, price = 4000, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(1, 3), objectModel = "w_pi_vintage_pistol"},
            {name = 'Heavy Pistol', type = 'weapon', hash = -771403250, price = 4500, legality = 'illegal', quantity = 1, weight = 15, stock = math.random(1, 3), objectModel = "w_pi_heavypistol"},
            {name = 'Pistol .50', type = 'weapon', hash = -1716589765, price = 4500, legality = 'illegal', quantity = 1, weight = 18, stock = math.random(1, 2), objectModel = "w_pi_pistol50"},
            {name = 'Pump Shotgun', type = 'weapon', hash = 487013001, price = 9000, legality = 'illegal', quantity = 1, weight = 30, stock = math.random(1, 2), objectModel = "w_sg_pumpshotgun"},
            {name = 'Razor Blade', type = 'misc', price = 500, legality = 'legal', quantity = 1, residue = false, weight = 3, stock = math.random(10, 20)},
            {name = 'Hotwiring Kit', type = 'misc', price = 250, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(10, 20)}
        }
    },
    ['marketB'] = {
        ['coords'] = {1380.87, 2172.51, 97.81},
        ['items'] = {
            {name = 'Hotwiring Kit', type = 'misc', price = 250, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(10, 20)},
            {name = 'Razor Blade', type = 'misc', price = 500, legality = 'legal', quantity = 1, residue = false, weight = 3, stock = math.random(10, 20)},
            {name = 'SMG', type = 'weapon', hash = 736523883, price = 200000, legality = 'illegal', quantity = 1, weight = 55, stock = math.random(0, 1), objectModel = "w_sb_smg"},
            {name = 'Heavy Shotgun', type = 'weapon', hash = 984333226, price = 8000, legality = 'illegal', quantity = 1, weight = 35, stock = math.random(1, 2), objectModel = "w_sg_heavyshotgun"},
            {name = 'SNS Pistol', type = 'weapon', hash = -1076751822, price = 3500, legality = 'illegal', quantity = 1, weight = 8, stock = math.random(1, 3), objectModel = "w_pi_sns_pistol"},
            {name = 'Combat Pistol', type = 'weapon', hash = 1593441988, price = 5000, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(1, 3), objectModel = "w_pi_combatpistol"},
            {name = 'Switchblade', type = 'weapon', hash = -538741184, price = 1500, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(5, 15)},
            {name = 'Brass Knuckles', type = 'weapon', hash = -656458692, price = 1100, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(3, 5)},
        }
    }
}

local MAX_PLAYER_WEAPON_SLOTS = 3

RegisterServerEvent("blackMarket:requestPurchase")
AddEventHandler("blackMarket:requestPurchase", function(key, itemIndex)
  local char = exports["usa-characters"]:GetCharacter(source)
  local weapon = markets[key]['items'][itemIndex]
  if weapon.stock > 0 then
    weapon.uuid = math.random(999999999)
    if char.canHoldItem(weapon) then
      if weapon.type == "weapon" then
        local weapons = char.getWeapons()
        if #weapons < MAX_PLAYER_WEAPON_SLOTS then
          if weapon.price <= char.get("money") then -- see if user has enough money
            char.giveItem(weapon, 1)
            char.removeMoney(weapon.price)
            if weapon.type == "weapon" then
              TriggerClientEvent("blackMarket:equipWeapon", source, weapon.hash, weapon.name) -- equip
            end
            TriggerClientEvent("usa:notify", source, "Purchased: ~y~"..weapon.name..'\n~s~Price: ~y~$'..weapon.price..'.00')
            markets[key]['items'][itemIndex].stock = weapon.stock - 1
          else
            TriggerClientEvent("usa:notify", source, "You cannot afford this purchase!")
          end
        else
          TriggerClientEvent("usa:notify", source, "~r~All weapons slot are full! (" .. MAX_PLAYER_WEAPON_SLOTS .. "/" .. MAX_PLAYER_WEAPON_SLOTS .. ")")
        end
      else
        if char.get("money") >= weapon.price then
          char.giveItem(weapon, 1)
          char.removeMoney(weapon.price)
          TriggerClientEvent("usa:notify", source, "Purchased: ~y~"..weapon.name..'\n~s~Price: ~y~$'..weapon.price..'.00')
        end
      end
    else
      TriggerClientEvent("usa:notify", source, "Inventory is full!")
    end
  else
    TriggerClientEvent("usa:notify", source, "Out of stock! Come back tomorrow!")
  end
end)
