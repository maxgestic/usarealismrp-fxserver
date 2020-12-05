local JOB_NAME = "ems"

local LOADOUT_ITEMS = {
  { name = "Flashlight", hash = -1951375401, price = 15, weight = 4 },
  { name = "Flare", hash = 1233104067, price = 25, weight = 9 },
  { name = "Fire Extinguisher", hash = 101631238, price = 25, weight = 20 },
  { name = "EMS Radio", price = 500, weight = 5, type = "misc" },
}

for i = 1, #LOADOUT_ITEMS do
    LOADOUT_ITEMS[i].serviceWeapon = true
    LOADOUT_ITEMS[i].notStackable = true
    LOADOUT_ITEMS[i].quantity = 1
    LOADOUT_ITEMS[i].legality = "legal"
    if not LOADOUT_ITEMS[i].type then
      LOADOUT_ITEMS[i].type = "weapon"
    end
end

RegisterServerEvent("ems:getLoadout")
AddEventHandler("ems:getLoadout", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    for i = 1, #LOADOUT_ITEMS do
        local item = LOADOUT_ITEMS[i]
        local letters = {}
        for i = 65,  90 do table.insert(letters, string.char(i)) end -- add capital letters
        local serialEnding = math.random(100000000, 999999999)
        local serialLetter = letters[math.random(#letters)]
        item.serialNumber = serialLetter .. serialEnding
        item.uuid = item.serialNumber
        if char.get("money") >= item.price then
            if char.canHoldItem(item) then
                char.removeMoney(item.price)
                char.giveItem(item)
                if item.hash then
                  TriggerClientEvent("mini:equipWeapon", source, item.hash)
                end
                TriggerClientEvent("usa:notify", source, "Retrieved a " .. item.name)
            else
                TriggerClientEvent("usa:notify", source, "Unable to get " .. item.name ..". Inventory full.")
            end
        end
    end
end)

RegisterServerEvent("emsstation2:loadOutfit")
AddEventHandler("emsstation2:loadOutfit", function(slot)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local char = exports["usa-characters"]:GetCharacter(source)
  local character = user.getEmsCharacter()
  TriggerClientEvent("emsstation2:setCharacter", source, character[tostring(slot)])
  if char.get('job') ~= JOB_NAME then
    char.set("job",JOB_NAME)
    TriggerEvent('job:sendNewLog', source, JOB_NAME, true)
  end
  TriggerClientEvent('interaction:setPlayersJob', source, JOB_NAME)
  TriggerEvent("eblips:add", {name = char.getName(), src = source, color = 1})
end)

RegisterServerEvent("emsstation2:saveOutfit")
AddEventHandler("emsstation2:saveOutfit", function(character, slot)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local job = exports["usa-characters"]:GetCharacterField(source, "job")
  local emsCharacter = user.getEmsCharacter()
  emsCharacter[tostring(slot)] = character
  if job == JOB_NAME then
    user.setEmsCharacter(emsCharacter)
    TriggerClientEvent("usa:notify", source, "Outfit in slot "..slot.." has been saved.")
  else
    TriggerClientEvent("usa:notify", source, "You must be on-duty to save a uniform.")
  end
end)

RegisterServerEvent("emsstation2:onduty")
AddEventHandler("emsstation2:onduty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
  if char.get("job") ~= JOB_NAME then
    char.set("job", JOB_NAME)
    TriggerEvent('job:sendNewLog', source, JOB_NAME, true)
    TriggerEvent("eblips:add", {name = char.getName(), src = source, color = 1})
  end
end)

RegisterServerEvent("emsstation2:offduty")
AddEventHandler("emsstation2:offduty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
  local playerWeapons = char.getWeapons()
  TriggerClientEvent("emsstation2:setciv", source, char.get("appearance"), playerWeapons) -- need to test
  if char.get('job') == JOB_NAME then
      char.set("job", "civ")
      TriggerEvent('job:sendNewLog', source, JOB_NAME, false)
      TriggerEvent("eblips:remove", source)
      TriggerClientEvent("radio:unsubscribe", source)
  end
end)

RegisterServerEvent("emsstation2:checkWhitelist")
AddEventHandler("emsstation2:checkWhitelist", function()
	if exports["usa-characters"]:GetCharacterField(source, "emsRank") > 0 then
		TriggerClientEvent("emsstation2:isWhitelisted", source)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not whitelisted for EMS. Apply at https://www.usarrp.net.")
	end
end)

function RemoveServiceWeapons(char)
      local weps = char.getWeapons()
      for i = #weps, 1, -1 do
          if weps[i].serviceWeapon then
              char.removeItemWithField("serialNumber", weps[i].serialNumber)
          end
      end
end
