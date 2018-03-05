local timeout = false

local DUTY_FEE = 300

RegisterServerEvent("taxi:setJob")
AddEventHandler("taxi:setJob", function(property)
  TriggerEvent("es:getPlayerFromId", source, function(user)
  
	local first, last = user.getActiveCharacterData("firstName"), user.getActiveCharacterData("lastName")
	if not first then first = "" elseif not last then last = "" end
	local name = first .. " " .. last
    local user_licenses = user.getActiveCharacterData("licenses")
    local user_money = user.getActiveCharacterData("money")
    if user.getActiveCharacterData("job") == "taxi" then
      print("user " .. GetPlayerName(source) .. " just went off duty for downtown taxi cab co.!")
      user.setActiveCharacterData("job", "civ")
      TriggerClientEvent("taxi:offDuty", source)
    else
      if user_money - DUTY_FEE >= 0 then
        if not timeout then
          print("user " .. name .. " just is trying to go on duty for downtown taxi cab co.!")
          for i = 1, #user_licenses do
            local item = user_licenses[i]
            if string.find(item.name, "Driver") then
              print("DL found! checking validity")
              if item.status == "valid" then
                user.setActiveCharacterData("job", "taxi")
                TriggerClientEvent("taxi:onDuty", source, name)
                -- take money --
                user.setActiveCharacterData("money", user_money - DUTY_FEE)
                -- give money to taxi shop owner --
                if property then 
                  TriggerEvent("properties:addMoney", property.name, round(0.20 * DUTY_FEE, 0))
                end
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
      else 
        print("player did not have enough money to go on duty for taxi!")
        TriggerClientEvent("usa:notify", source, "You don't have enough money to pay the security fee!")
      end
    end
  end)
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end