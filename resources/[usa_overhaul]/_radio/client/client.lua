local Channels = {}

local KEYS = {
  SHIFT = 21,
  F7 = 168,
  F2 = 289
}

local isRadioShowing = false
local currentChannelIndex = 1
local currentChannel = { id = 1, name = "Off"}

RegisterNetEvent("radio:toggle")
AddEventHandler("radio:toggle", function(permittedChannels)
  Channels = permittedChannels
  ToggleRadio()
end)

RegisterNetEvent("radio:unsubscribe")
AddEventHandler("radio:unsubscribe", function()
  if isRadioShowing then
    ToggleRadio()
  end
  Unsubscribe()
end)

function GetNextChannel()
  local newIdx = currentChannelIndex + 1
  if newIdx > #Channels then return nil end
  currentChannelIndex = newIdx
  return Channels[newIdx]
end

function GetPreviousChannel()
  local newIdx = currentChannelIndex - 1
  if newIdx < 0 then return nil end
  currentChannelIndex = newIdx
  return Channels[newIdx]
end

function ToggleRadio()
  isRadioShowing = not isRadioShowing;
  SendNUIMessage({type = "pixelated.radio", display = isRadioShowing})
  if isRadioShowing then
    SendNUIMessage({type = "pixelated.radio", text = currentChannel.name})
    Citizen.CreateThread(function()
      local newChannel
      while isRadioShowing do
        Wait(5)
        if IsControlJustPressed(0, 174) then
          newChannel = GetPreviousChannel()
        elseif IsControlJustPressed(0, 175) then
          newChannel = GetNextChannel()
        end

        if newChannel ~= nil and newChannel ~= currentChannel then
          Unsubscribe()

          if (newChannel["id"] ~= 1) then 
            exports.tokovoip_script:addPlayerToRadio(newChannel["id"] - 1)
          end

          currentChannel = newChannel

          SendNUIMessage({type = "pixelated.radio", text = newChannel["name"]})
          TriggerServerEvent("InteractSound_SV:PlayOnSource", "radio-beep", 0.3)
        end
      end
    end)
  end
end

function Unsubscribe()
  if Channels then
    for i = 2, #Channels do
      if (exports.tokovoip_script:isPlayerInChannel(Channels[i].id - 1)) then
        exports.tokovoip_script:removePlayerFromRadio(Channels[i].id - 1)
      end
    end
  end
end

AddEventHandler('onClientResourceStart', function (resourceName)
  if(GetCurrentResourceName() ~= resourceName) then return end
  Unsubscribe()
end)

Citizen.CreateThread(function()
    while true do
      Wait(5)
      if IsControlPressed(0, KEYS.SHIFT) and IsControlJustPressed(0, KEYS.F2) and GetLastInputMethod(0) then
          TriggerServerEvent("radio:accessCheck")
      end
    end
end)