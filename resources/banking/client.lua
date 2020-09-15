-- Settings
local depositAtATM = false -- Allows the player to deposit at an ATM rather than only in banks (Default: false)
local giveCashAnywhere = false -- Allows the player to give CASH to another player, no matter how far away they are. (Default: false)
local withdrawAnywhere = false -- Allows the player to withdraw cash from bank account anywhere (Default: false)
local depositAnywhere = false -- Allows the player to deposit cash into bank account anywhere (Default: false)
local enableBankingGui = true -- Enables the banking GUI (Default: true) // MAY HAVE SOME ISSUES

-- ATMS
local atms = {
  "prop_atm_01",
  "prop_atm_02",
  "prop_atm_03",
  "prop_fleeca_atm",
}

local CHECK_RADIUS = 0.7


-- Banks
local banks = {
  {name="Bank", x = 149.766, y=-1041.303, z=29.8074},
  {name="Bank", x = -1212.080, y=-331.141, z=38.087},
  {name="Bank", x = -2961.882, y=483.127, z=16.103},
  {name="Bank", x = -111.582, y=6469.615, z=32.066},
  {name="Bank", x = 313.937, y=-279.781, z=54.570},
  {name="Bank", x = -351.034, y=-50.689, z=49.442},
  {name="Bank", x = 1175.0, y = 2707.5, z = 38.5},
  {name="Bank", x = 237.9, y = 218.16, z = 106.6}
}


-- NUI Variables
local atBank = false
local atATM = false
local bankOpen = false
local atmOpen = false

-- Open Gui and Focus NUI
function openGui(bal)
  SetNuiFocus(true, true)
  SendNUIMessage({openBank = true, bal = bal})
end

-- Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openBank = false})
  bankOpen = false
  atmOpen = false
end

-- If GUI setting turned on, listen for INPUT_PICKUP keypress
if enableBankingGui then
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      for i = 1, #banks do
        DrawText3D(banks[i].x, banks[i].y, banks[i].z, 5, '[E] - Banking')
      end
      if IsControlJustPressed(1, 51) and (IsNearBank() or IsNearATM()) then -- IF INPUT_PICKUP Is pressed
        if IsInVehicle() then
          TriggerEvent('usa:notify', '~y~You cannot access the bank while in a vehicle!')
        else
          if bankOpen then
            closeGui()
            bankOpen = false
          else
            TriggerServerEvent("bank:getBalanceForGUI")
            Wait(500)
          end
        end
    	else
        if atmOpen or bankOpen and not (IsNearBank() or IsNearATM()) then
          closeGui()
        end
        atBank = false
        atmOpen = false
        bankOpen = false
      end
    end
  end)
end

-- Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if bankOpen or atmOpen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisableControlAction(0, 24, active) -- Attack
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('balance', function(data, cb)
  SendNUIMessage({openSection = "balance"})
  cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
  SendNUIMessage({openSection = "withdraw"})
  cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
  SendNUIMessage({openSection = "deposit"})
  cb('ok')
end)

RegisterNUICallback('transfer', function(data, cb)
  SendNUIMessage({openSection = "transfer"})
  cb('ok')
end)

RegisterNUICallback('quickCash', function(data, cb)
  TriggerEvent('bank:withdraw', 100)
  cb('ok')
end)

RegisterNUICallback('withdrawSubmit', function(data, cb)
  TriggerEvent('bank:withdraw', data.amount)
  cb('ok')
end)

RegisterNUICallback('depositSubmit', function(data, cb)
  TriggerEvent('bank:deposit', data.amount)
  cb('ok')
end)

RegisterNUICallback('transferSubmit', function(data, cb)
  TriggerEvent('bank:transfer', tonumber(data.toPlayer), tonumber(data.amount))
  cb('ok')
end)

-- Check if player is near an atm
function IsNearATM()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for i = 1, #atms do
    local obj = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, CHECK_RADIUS, GetHashKey(atms[i]), false, false, false)
    if DoesEntityExist(obj) then
      return true
    end
  end
end

-- Check if player is in a vehicle
function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- Check if player is near a bank
function IsNearBank()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for _, item in pairs(banks) do
    local distance = Vdist(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"])
    if distance <= 4 then
      return true
    end
  end
end

-- Check if player is near another player
function IsNearPlayer(player)
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 0)
  local distance = Vdist(ply2Coords["x"], ply2Coords["y"], ply2Coords["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"])
  if(distance <= 5) then
    return true
  end
end

RegisterNetEvent('bank:getBalanceForGUI')
AddEventHandler('bank:getBalanceForGUI', function(bal)
    openGui(bal)
    bankOpen = true
end)

-- Process deposit if conditions met
RegisterNetEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  if(IsNearBank() == true or depositAtATM == true and IsNearATM() == true or depositAnywhere == true ) then
    if (IsInVehicle()) then
      TriggerEvent('usa:notify', "~y~You cannot do this in a vehicle!");
    else
      TriggerServerEvent("bank:deposit", tonumber(amount))
    end
  else
    TriggerEvent('usa:notify', "~y~You can only deposit at a bank!");
  end
end)

-- Process withdraw if conditions met
RegisterNetEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
  if(IsNearATM() or IsNearBank() or withdrawAnywhere) then
    if (IsInVehicle()) then
      TriggerEvent('usa:notify', "~y~You cannot do this in a vehicle!");
    else
      if not IsNearBank() then
        if IsNearATM() and tonumber(amount) > 5000 then
          TriggerEvent('usa:notify', '~y~Please use a bank to withdraw this amount!')
          return
        end
      end
      TriggerServerEvent('bank:withdraw', tonumber(amount))
    end
  else
    TriggerEvent('usa:notify', '~y~You are not near an ATM or bank!')
  end
end)

-- Process give cash if conditions met
RegisterNetEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount, fromName, src)
  if (IsNearPlayer(toPlayer) == true or giveCashAnywhere == true) then
      local name = GetPlayerName(toPlayer)
    local player2 = GetPlayerFromServerId(toPlayer)
    local playing = IsPlayerPlaying(player2)
    if playing then
      TriggerServerEvent("bank:givecash", toPlayer, tonumber(amount))
      --TriggerEvent('chatMessage', "", {255, 255, 255}, fromName .. " has given you ^2$" .. amount .. "^0.");
      --TriggerServerEvent('altchat:localChatMessage', src, "^6* " .. fromName .. " hands over money.")
    else
      TriggerEvent('usa:notify', '~y~Player not found!')
    end
  else
    TriggerEvent('usa:notify', '~y~You are not near this player!')
  end
end)

-- Process bank transfer if player is online
RegisterNetEvent('bank:transfer')
AddEventHandler('bank:transfer', function(toPlayer, amount)
  local player2 = GetPlayerFromServerId(toPlayer)
  local playing = IsPlayerPlaying(player2)
  if (playing ~= false) then
    TriggerServerEvent("bank:transfer", toPlayer, tonumber(amount))
  else
    TriggerEvent('usa:notify', '~y~Player not found!')
  end
end)

-- Send NUI message to update bank balance
RegisterNetEvent('banking:updateBalance')
AddEventHandler('banking:updateBalance', function(balance)
  local id = PlayerId()
  local playerName = GetPlayerName(id)
	SendNUIMessage({
		updateBalance = true,
		balance = balance,
    player = playerName
	})
end)

-- Send NUI Message to display add balance popup
RegisterNetEvent("banking:addBalance")
AddEventHandler("banking:addBalance", function(amount)
	SendNUIMessage({
		addBalance = true,
		amount = amount
	})

end)

-- Send NUI Message to display remove balance popup
RegisterNetEvent("banking:removeBalance")
AddEventHandler("banking:removeBalance", function(amount)
	SendNUIMessage({
		removeBalance = true,
		amount = amount
	})
end)

----------------------
---- Set up blips ----
----------------------
for i = 1, #banks do
  local blip = AddBlipForCoord(banks[i].x, banks[i].y, banks[i].z)
  SetBlipSprite(blip, 500)
  SetBlipDisplay(blip, 4)
  SetBlipScale(blip, 0.8)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip, 11)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Bank')
  EndTextCommandSetBlipName(blip)
end
-----------------
-----------------
-----------------

function DrawText3D(x, y, z, distance, text)
  if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 470
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
  end
end
