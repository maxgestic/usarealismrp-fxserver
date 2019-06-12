exports["globals"]:PerformDBCheck("usa-businesses", "businesses", nil)

RegisterServerEvent("business:storeMoney")
AddEventHandler("business:storeMoney", function(name, amount)
  amount = math.abs(amount)
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.get("money") >= amount then
    GivePropertyMoney(name, amount, function(success)
      TriggerClientEvent("usa:notify", usource, "Deposited: $" .. comma_value(amount))
    end)
  end
end)

RegisterServerEvent("business:tryOpenMenuByName")
AddEventHandler("business:tryOpenMenuByName", function(name)
  local usource = source
  local char = exports["usa-characters"]:GetCharacter(source)
  local id = char.get("_id")
  GetBusinessByName(name, function(business)
    if business then
      if business.owner.identifiers.id == id then
        -- this player was the owner of this business --
        local inv = FormatInventory(char.get("inventory"))
        TriggerClientEvent("business:showMenu", usource, business, inv)
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
      if char.get("money") >= BUSINESSES[name].price then -- if has enough cash
        char.removeMoney(BUSINESSES[name].price) -- take money
        CreateNewBusiness(usource, name, function() -- create doc
          TriggerClientEvent("usa:notify", usource, "You now own: " .. name .. "!")
        end)
      else
        TriggerClientEvent("usa:notify", usource, "You need $" .. comma_value(BUSINESSES[name].price) .. " to lease this business.")
      end
    end
  end)
end)

function FormatInventory(charInv)
  local inv = {}
  for i = 0, charInv.MAX_CAPACITY - 1 do
    if charInv.items[tostring(i)] then
      table.insert(inv, charInv.items[tostring(i)])
    end
  end
  return inv
end

function GivePropertyMoney(name, amount, cb)
  -- get money --
  local endpoint = "/businesses/_design/businessFilters/_view/getBusinessStorage"
  local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
  PerformHttpRequest(url, function(err, responseText, headers)
    if err == 404 then
      return
    end
    local data = json.decode(responseText)
    if data.total_rows > 0 then
      if data.rows then
        for i = 1, #data.rows do
          local storage = data.rows[i].value
          storage.cash = storage.cash + amount
          -- set money --
          TriggerEvent("es:exposeDBFunctions", function(db)
            db.updateDocument("businesses", RemoveSpaces(name),  { storage = storage}, function(err)
              cb(true)
            end)
          end)
        end
      end
    end
  end, "POST", json.encode({
    keys = { RemoveSpaces(name) }
  }), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

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
    local today = os.date("*t", os.time())
    local leaseEndTime = os.time({day = today.day + LEASE_PERIOD_DAYS, month = today.month, year = today.year}) -- todo: need to make sure 2 week date is calculated correctly,,
    business.fee = {
      price = BUSINESSES[name].price,
      paidAt = os.time(),
      due = {
        time = leaseEndTime,
        date = os.date("%x", leaseEndTime)
      }
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
