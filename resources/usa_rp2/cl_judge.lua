local DUTY_LOCATIONS = {
  ["Courthouse"] = {
    x = 240.54829406738, y = -1095.3508300781, z = 29.294277191162
  }
}

local KEY = 38

Citizen.CreateThread(function()
	while true do
		local me = GetPlayerPed(-1)
		for name, data in pairs(DUTY_LOCATIONS) do
			DrawText3D(data.x, data.y, data.z, 2, '[E] - On/Off Duty (~y~Judge~s~)')
			if Vdist(GetEntityCoords(me, false), data.x, data.y, data.z) < 1.0 then
				if IsControlJustPressed(1, KEY) then
					TriggerServerEvent("judge:duty")
				end
			end
		end
		-- wait --
		Wait(0)
	end
end)

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