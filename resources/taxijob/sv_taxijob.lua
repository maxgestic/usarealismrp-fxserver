local timeout = false

RegisterServerEvent("taxi:setJob")
AddEventHandler("taxi:setJob", function()
  TriggerEvent("es:getPlayerFromId", source, function(user)
  
	local first, last = user.getActiveCharacterData("firstName"), user.getActiveCharacterData("lastName")
	if not first then first = "" elseif not last then last = "" end
	local name = first .. " " .. last
    local user_licenses = user.getActiveCharacterData("licenses")
    if user.getActiveCharacterData("job") == "taxi" then
      print("user " .. GetPlayerName(source) .. " just went off duty for downtown taxi cab co.!")
      user.setActiveCharacterData("job", "civ")
      TriggerClientEvent("taxi:offDuty", source)
    else
      if not timeout then
        print("user " .. name .. " just is trying to go on duty for downtown taxi cab co.!")
        for i = 1, #user_licenses do
          local item = user_licenses[i]
          if string.find(item.name, "Driver") then
            print("DL found! checking validity")
            if item.status == "valid" then
              user.setActiveCharacterData("job", "taxi")
              TriggerClientEvent("taxi:onDuty", source, name)
              timeout = true
              SetTimeout(15000, function()
                timeout = false
              end)
              return
            else 
				TriggerClientEvent("usa:notify", source, "Your license is suspended!")
				return
			end
          end
        end
        -- at this point, no valid DL was found
        TriggerClientEvent("usa:notify", source, "You don't have a valid driver's license!")
      else
        print("player is on timeout and cannot go on duty for downtown taxi co!")
        TriggerClientEvent("usa:notify", source, "Can't retrieve another car! Please wait a little.")
      end
    end
  end)
end)
