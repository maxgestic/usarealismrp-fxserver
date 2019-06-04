--# by: minipunch
--# for USA REALISM rp
--# Phone to make phone calls, send texts, and more with various apps

local PHONE_ENABLED = false

-- listen for phone hotkey press --
Citizen.CreateThread(function()
 while true do
   if IsControlJustPressed(1, 288) and GetLastInputMethod(0) then -- "F1"
     if not PHONE_ENABLED then
        TriggerServerEvent("phone:getPhone") -- check if user has phone, get number, then display GUI
     else
       ClearPedTasks(GetPlayerPed(-1))
       EnableGui(false)
     end
     Wait(300)
   end
   Wait(1)
 end
end)

function EnableGui(enable, phone)
  PHONE_ENABLED = enable
  SetNuiFocus(enable, enable)
  if enable then
    print("enabling UI!")
  	SendNUIMessage({
  		type = "enableui",
  		enable = enable,
  		number = phone.number or nil,
  		owner = phone.owner or nil
  	})
  end
end

RegisterNetEvent("phone:openPhone")
AddEventHandler("phone:openPhone", function(phone)
  EnableGui(true, phone)
end)
