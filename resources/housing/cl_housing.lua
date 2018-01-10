local LOCATIONS = {
  ["Paleto Beach Home"] = {
    info = {
      x = 110.325,
      y = 6914.56,
      z = 20.5
    }
  }
}

local HOUSING_MENU_KEY = 38 -- "E"

Citizen.CreateThread(function()

  local menu = {
    open = false,
    page = "home",
    key = 38 -- "E"
  }

	while true do
    local player_ped = GetPlayerPed(-1)
    local player_ped_coords = GetEntityCoords(player_ped, 1)
    for name, data in pairs(LOCATIONS) do
      if Vdist(player_ped_coords.x, player_ped_coords.y, player_ped_coords.z, data.info.x, data.info.y, data.info.z) < 2.0 then
        DrawSpecialText("Press ~g~E~w~ to access the housing menu.")
        if IsControlJustPressed(1, HOUSING_MENU_KEY) then
          
        end
      end
    end
		Wait(0)
  end

end)

-- utility functions --
function DrawSpecialText(m_text)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end
