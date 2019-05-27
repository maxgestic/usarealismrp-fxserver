RegisterServerEvent("emsstation2:loadOutfit")
AddEventHandler("emsstation2:loadOutfit", function(slot)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local char = exports["usa-characters"]:GetCharacter(source)
  local character = user.getEmsCharacter()
  TriggerClientEvent("emsstation2:setCharacter", source, character[slot])
  if char.get('job') ~= 'ems' then
    char.set("job", "ems")
    TriggerEvent('job:sendNewLog', source, 'ems', true)
  end
  TriggerClientEvent('interaction:setPlayersJob', source, 'ems')
  TriggerEvent("eblips:add", {name = char.getName(), src = source, color = 1})
  --end)
end)

RegisterServerEvent("emsstation2:saveOutfit")
AddEventHandler("emsstation2:saveOutfit", function(character, slot)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local job = exports["usa-characters"]:GetCharacterField(source, "job")
  local emsCharacter = user.getEmsCharacter()
  emsCharacter[slot] = character
  if job == "ems" then
    user.setEmsCharacter(emsCharacter)
    TriggerClientEvent("usa:notify", source, "Outfit in slot "..slot.." has been saved.")
  else
    TriggerClientEvent("usa:notify", source, "You must be on-duty to save a uniform.")
  end
end)

RegisterServerEvent("emsstation2:onduty")
AddEventHandler("emsstation2:onduty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
  if char.get("job") ~= "ems" then
    char.set("job", "ems")
    TriggerEvent('job:sendNewLog', source, 'ems', true)
    TriggerEvent("eblips:add", {name = char.getName(), src = source, color = 1})
  end
end)

RegisterServerEvent("emsstation2:offduty")
AddEventHandler("emsstation2:offduty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
  local playerWeapons = char.getWeapons()
  TriggerClientEvent("emsstation2:setciv", source, char.get("appearance"), playerWeapons) -- need to test
  if char.get('job') == 'ems' then
      char.set("job", "civ")
      TriggerEvent('job:sendNewLog', source, 'ems', false)
      TriggerEvent("eblips:remove", source)
  end
end)

RegisterServerEvent("emsstation2:checkWhitelist")
AddEventHandler("emsstation2:checkWhitelist", function(clientevent)
	if exports["usa-characters"]:GetCharacterField(source, "emsRank") > 0 then
		TriggerClientEvent(clientevent, source)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not whitelisted for EMS. Apply at https://www.usarrp.net.")
	end
end)
