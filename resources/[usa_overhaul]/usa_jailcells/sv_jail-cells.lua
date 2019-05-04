local JAIL_CELLS = {
  ["1"] = {
    locked = false
  },
  ["2"] = {
    locked = false
  },
  ["3"] = {
    locked = false
  }
}

RegisterServerEvent("jail:checkDoorLock")
AddEventHandler("jail:checkDoorLock", function(number)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user_job = user.getActiveCharacterData("job")
    if user_job == "sheriff" then
      local current_lock_status = JAIL_CELLS[number].locked
      if current_lock_status == false then
        JAIL_CELLS[number].locked = true
        print("locking cell #" .. number)
        TriggerClientEvent("usa:notify", userSource, "Cell #" .. number .. ": ~y~Locked")
      else
        JAIL_CELLS[number].locked = false
        print("unlocking cell #" .. number)
        TriggerClientEvent("usa:notify", userSource, "Cell #" .. number .. ": ~y~Unlocked")
      end
      TriggerClientEvent("jail:toggleDoorLock", -1, number, JAIL_CELLS[number].locked)
    end
  --end)
end)
