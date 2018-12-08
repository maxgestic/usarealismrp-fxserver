local DUTY_LOCATIONS = {
  ["Courthouse"] = {
    x = 226.92,
    y = -422.51,
    z = -118.41
  }
}

local KEY = 38


Citizen.CreateThread(function()
	while true do
		local me = GetPlayerPed(-1)
		for name, data in pairs(DUTY_LOCATIONS) do
			-- draw markers --
			DrawMarker(27, data.x, data.y, data.z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
			-- listen for keypress & check range --
			if Vdist(GetEntityCoords(me, false), data.x, data.y, data.z) < 1.0 then
				DrawSpecialText("Press ~g~E~w~ to go on/off duty!")
				if IsControlJustPressed(1, KEY) then
					TriggerServerEvent("judge:duty")
				end
			end
		end
		-- wait --
		Wait(0)
	end
end)

function DrawSpecialText(m_text)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end
