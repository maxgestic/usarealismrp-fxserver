--# by: minipunch
--# for USA REALISM rp
--# This script keeps a server sided track of frozen states on objects like doors or gates that can be toggled by being in the activation area and pressing "E"
--# make sure both the DOORS collection on the sv file and the DOORS_TO_MANAGE collection on the cl file have an equal # of entries, and their "locked" attirbute are matching to work properly

local DOORS = {
  [1] = {locked = false, coords = nil},
  [2] = {locked = false, coords = nil},
  [3] = {locked = false, coords = nil},
  [4] = {locked = false, coords = nil},
  [5] = {locked = false, coords = nil},
  [6] = {locked = false, coords = nil},
  [7] = {locked = false, coords = nil},
  [8] = {locked = false, coords = nil},
  [9] = {locked = false, coords = nil},
  [10] = {locked = false, coords = nil},
  [11] = {locked = false, coords = nil},
  [12] = {locked = false, coords = nil},
  [13] = {locked = false, coords = nil},
  [14] = {locked = false, coords = nil},
  [15] = {locked = true, coords = nil},
  [16] = {locked = true, coords = nil},
  [17] = {locked = true, coords = nil},
  [18] = {locked = true, coords = nil},
  [19] = {locked = true, coords = nil},
  [20] = {locked = true, coords = nil},
  [21] = {locked = true, coords = nil},
  [22] = {locked = true, coords = nil},
  [23] = {locked = true, coords = nil},
  [24] = {locked = true, coords = nil},
  [25] = {locked = true, coords = nil},
  [26] = {locked = true, coords = nil},
  [27] = {locked = true, coords = nil},
  [28] = {locked = true, coords = nil},
  [29] = {locked = true, coords = nil},
  [30] = {locked = true, coords = nil},
  [31] = {locked = true, coords = nil},
  [32] = {locked = true, coords = nil},
  [33] = {locked = true, coords = nil},
  [34] = {locked = true, coords = nil},
  [35] = {locked = true, coords = nil},
  [36] = {locked = true, coords = nil},
  [37] = {locked = true, coords = nil},
  [38] = {locked = true, coords = nil},
  [39] = {locked = true, coords = nil},
  [40] = {locked = true, coords = nil},
  [41] = {locked = true, coords = nil},
  [42] = {locked = true, coords = nil},
  [43] = {locked = true, coords = nil},
  [44] = {locked = true, coords = nil},
  [45] = {locked = true, coords = nil},
  [46] = {locked = true, coords = nil},
  [47] = {locked = true, coords = nil},
  [48] = {locked = true, coords = nil},
  [49] = {locked = true, coords = nil},
  [50] = {locked = true, coords = nil},
  [51] = {locked = true, coords = nil},
  [52] = {locked = true, coords = nil}
}

RegisterServerEvent("doormanager:checkDoorLock")
AddEventHandler("doormanager:checkDoorLock", function(index, door, x, y, z)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local user_job = user.getActiveCharacterData("job")
  if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "judge" then
    if not DOORS[index].locked then
      DOORS[index].locked = true
      --print("locking door #" .. index)
      TriggerClientEvent("usa:notify", source, "Door has been ~y~locked")
    else
      DOORS[index].locked = false
      --print("unlocking door #" .. index)
      TriggerClientEvent("usa:notify", source, "Door has been ~y~unlocked")
    end
    TriggerClientEvent("doormanager:toggleDoorLock", -1, index, DOORS[index].locked, x, y, z)
  else
    TriggerClientEvent("usa:notify", source,"Area prohibited!")
  end
end)

RegisterServerEvent("doormanager:updateCoords")
AddEventHandler("doormanager:updateCoords", function(index, coords)
  if not DOORS[index].coords then
    DOORS[index].coords = coords
  end
end)

RegisterNetEvent("doormanager:firstJoin")
AddEventHandler("doormanager:firstJoin", function()
  TriggerClientEvent("doormanager:update", source, DOORS)
end)
