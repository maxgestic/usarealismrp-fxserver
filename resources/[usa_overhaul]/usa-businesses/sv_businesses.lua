exports["globals"]:PerformDBCheck("usa-businesses", "businesses", nil)

RegisterServerEvent("business:tryOpenMenuByName")
AddEventHandler("business:tryOpenMenuByName", function(name)
  local usource = source
  local char = exports["usa-characters"]:GetCharacter(source)
  local id = char.get("_id")
  GetBusinessByName(name, function(business)
    if business then
      if business.owner.identifiers.id == id then
        -- this player was the owner of this business --
        TriggerClientEvent("business:showMenu", usource, business)
      else
        -- this player is not the owner of this business --
        TriggerClientEvent("business:notOwner", usource, business)
        local message = "This business is owned by ~y~" .. business.owner.name.full .. "~w~!"
        TriggerClientEvent("usa:notify", usource, message)
      end
    else
      -- no one owns this business --
      local message = "This business is for ~g~sale~w~!"
      message = message .. "\n"
      message = message .. "Hold ~y~E~w~ to lease for $" .. comma_value(BUSINESSES[name].price) .. " / biweekly"
      TriggerClientEvent("usa:notify", usource, message)
    end
  end)
end)

RegisterServerEvent("business:lease")
AddEventHandler("business:lease", function(name)
  print("player wants to purchase business with name: " .. name)
  local usource = source
  GetBusinessByName(name, function(business)
    if business then
      TriggerClientEvent("usa:notify", usource, "~y~Owner:~w~ " .. business.owner.name.full)
    else
      local char = exports["usa-characters"]:GetCharacter(usource)
      if char.get("money") >= BUSINESSES[name].price then
        char.removeMoney(BUSINESSES[name].price)
        -- create new doc --
        CreateNewBusiness(usource, name, function()
          TriggerClientEvent("usa:notify", usource, "You now own: " .. name .. "!")
        end)
      end
    end
  end)
end)

function CreateNewBusiness(src, name, cb)
  local owner = exports["usa-characters"]:GetCharacter(src)
  TriggerEvent('es:exposeDBFunctions', function(db)
    local business = {}
    business.name = name
    business.owner = {
      identifiers = {
        id = owner.get("_id"),
        steam = GetPlayerIdentifiers(src)[1]
      },
      name = {
        full = owner.getFullName(),
      }
    }
    business.storage = {
      cash = 0,
      items = {}
    }
    business.purchase = {
      time = os.time()
    }
    db.createDocumentWithId("businesses", business, RemoveSpaces(name), function(success)
      if success then
        cb()
      else
        TriggerClientEvent("usa:notify", src, "There was a problem signing the lease!")
      end
    end)
  end)
end

function GetBusinessByName(name, cb)
  local endpoint = "/businesses/_design/businessFilters/_view/getBusinessByName"
  local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
  PerformHttpRequest(url, function(err, responseText, headers)
    if err == 404 then
      cb(nil)
      return
    end
    local data = json.decode(responseText)
    if data.total_rows > 0 then
      if data.rows then
        for i = 1, #data.rows do
          local business = data.rows[i].value
          cb(business)
        end
      end
    else
      cb(nil)
    end
  end, "POST", json.encode({
    keys = { RemoveSpaces(name) }
  }), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

function RemoveSpaces(s)
  return s:gsub("%s+", "")
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
