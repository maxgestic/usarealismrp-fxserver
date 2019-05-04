RegisterServerEvent("emsstation2:loadOutfit")
AddEventHandler("emsstation2:loadOutfit", function(slot)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
  character = user.getEmsCharacter()
  TriggerClientEvent("emsstation2:setCharacter", userSource, character[slot])
  --TriggerClientEvent("policestation2:giveDefaultLoadout", userSource)
  if user.getActiveCharacterData('job') ~= 'ems' then
    user.setActiveCharacterData("job", "ems")
    TriggerEvent('job:sendNewLog', userSource, 'ems', true)
  end
  TriggerClientEvent('interaction:setPlayersJob', userSource, 'ems')
  TriggerEvent("eblips:add", {name = user.getActiveCharacterData("fullName"), src = userSource, color = 1}, true)
  --end)
end)

RegisterServerEvent("emsstation2:saveOutfit")
AddEventHandler("emsstation2:saveOutfit", function(character, slot)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_job = user.getActiveCharacterData("job")
  local emsCharacter = user.getEmsCharacter()
  emsCharacter[slot] = character
  if user_job == "ems" then
    user.setEmsCharacter(emsCharacter)
    TriggerClientEvent("usa:notify", userSource, "Outfit in slot "..slot.." has been saved.")
  else
    TriggerClientEvent("usa:notify", userSource, "You must be on-duty to save a uniform.")
  end
end)

RegisterServerEvent("emsstation2:onduty")
AddEventHandler("emsstation2:onduty", function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
    if user.getActiveCharacterData("job") ~= "ems" then
        user.setActiveCharacterData("job", "ems")
        TriggerEvent('job:sendNewLog', source, 'ems', true)
        TriggerEvent("eblips:add", {name = user.getActiveCharacterData("fullName"), src = userSource, color = 1}, true)
    end
end)

RegisterServerEvent("emsstation2:offduty")
AddEventHandler("emsstation2:offduty", function()
    local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
    local playerWeapons = user.getActiveCharacterData("weapons")
    local chars = user.getCharacters()
    for i = 1, #chars do
      if chars[i].active == true then
        TriggerClientEvent("emsstation2:setciv", userSource, chars[i].appearance, playerWeapons) -- need to test
        break
      end
    end
    if user.getActiveCharacterData('job') == 'ems' then
        user.setActiveCharacterData("job", "civ")
        TriggerEvent('job:sendNewLog', source, 'ems', false)
        TriggerEvent("eblips:remove", userSource)
    end
end)

RegisterServerEvent("emsstation2:checkWhitelist")
AddEventHandler("emsstation2:checkWhitelist", function(clientevent)
	local playerIdentifiers = GetPlayerIdentifiers(source)
	local playerGameLicense = ""
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user.getActiveCharacterData("emsRank") > 0 then
		TriggerClientEvent(clientevent, userSource)
	else
		TriggerClientEvent("usa:notify", userSource, "~y~You are not whitelisted for EMS. Apply at https://www.usarrp.net.")
	end
end)
