RegisterServerEvent("chatMessage")
AddEventHandler('chatMessage', function(source, n, message)

    cm = stringsplit(message, " ")

    if cm[1] == "/place" then
        CancelEvent()
        if tablelength(cm) > 1 then
            TriggerEvent('es:getPlayerFromId', source, function(user)
                if user.getJob() == "sheriff" or user.getJob() == "ems" or user.getJob() == "fire" then
                     local tPID = tonumber(cm[2])
                     TriggerClientEvent("place", tPID)
                else
                    TriggerClientEvent("place:invalidCommand", source, "Only ^3law enforcement/EMS ^0can use /place!")
                end
            end)
        end
    end

end)

function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
