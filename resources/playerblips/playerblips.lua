local emergencySkins = {
	{name = "ig_karen_daniels", type="police"},
	{name = "S_M_M_PrisGuard_01", type="police"},
	{name = "S_M_Y_Ranger_01", type="police"},
	{name = "S_F_Y_Ranger_01", type="police"},
	{name = "s_m_m_fiboffice_01", type="police"},
	{name = "ig_andreas", type="police"},
	{name = "ig_stevehains", type="police"},
	{name = "ig_trafficwarden", type="police"},
	{name = "S_M_Y_SWAT_01", type="police"},
	{name = "s_m_m_chemsec_01", type="police"},
	{name = "S_M_Y_HwayCop_01", type="police"},
	{name = "s_m_y_sheriff_01", type="police"},
	{name = "s_f_y_sheriff_01", type="police"},
	{name = "s_m_y_blackops_01", type="police"},
	{name = "s_m_m_fibsec_01", type="police"},
	{name = "s_m_m_fiboffice_01", type="police"},
	{name = "s_m_m_ciasec_01", type="police"},
	{name = "s_m_y_cop_01", type="police"},
	{name = "s_f_y_cop_01", type="police"},
	{name = "s_m_m_paramedic_01", type="fire"},
	{name = "s_m_y_fireman_01", type="fire"},
	{name = "s_f_y_scrubs_01", type="fire"}
}

local magic = {}
local hidden = {}
function magic.add(tabe, id)
	if magic.position(tabe, id) == 0 then
		table.insert(tabe, id)
	end
end

function magic.remove(tabe, id)
	if magic.position(tabe, id) ~= 0 then
    	table.remove(tabe, magic.position(tabe, id))
	end
end

function magic.position(tabe, id)
	for k, v in pairs(tabe) do
		if v == id then
			return k
		end
	end
	return 0
end

RegisterNetEvent("hide:blip")
AddEventHandler("hide:blip", function(user, toogle)
	if not toogle then
		magic.remove(hidden, tonumber(user))
	else
		magic.add(hidden, tonumber(user))
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		for id = 0, 64 do
			x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
			if NetworkIsPlayerActive(id) and GetDistanceBetweenCoords(x,y,z, GetEntityCoords(GetPlayerPed(-1))) < 40 and magic.position(hidden, GetPlayerServerId(id)) == 0 then
				ped = GetPlayerPed(id)
				blip = GetBlipFromEntity(ped)

				if NetworkIsPlayerTalking(id) then
					if GetPlayerPed(id) ~= GetPlayerPed(-1) then
						--DrawMarker(2, x, y, z+1.10, 0, 0, 0, 0, 180.0, 0, 0.3, 0.1, 0.25, 0, 0, 200, 200, 0, GetEntityHeading(GetPlayerPed(-1)), 0, 0)
						--Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(id), false, false, "", false)
						--Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, tostring(GetPlayerServerId(id)), false, false, "", false)
						DrawTracerText(tostring(GetPlayerServerId(id)), 1.2, true)
					end
				elseif GetPlayerPed(id) ~= GetPlayerPed(-1) then
					--DrawMarker(2, x, y, z+1.10, 0, 0, 0, 0, 180.0, 0, 0.3, 0.1, 0.25, 0, 200, 0, 200, 0, GetEntityHeading(GetPlayerPed(-1)), 0, 0)
					--Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(id), false, false, "", false)
					--Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, tostring(GetPlayerServerId(id)), false, false, "", false)
					DrawTracerText(tostring(GetPlayerServerId(id)), 1.2, false)
				end
			end
		end

		-- BELOW THIS LINE IS WHERE SCAMMER'S PLAYERBLIPS SCRIPT BEGINS
		-- MODIFIED TO SHOW ONLY EMERGENCY PERSONEL
		-- extend minimap on keypress
		if IsControlJustPressed( 0, 20 ) then
			if not isRadarExtended then
				SetRadarBigmapEnabled( true, false )
				isRadarExtended = true
				Citizen.CreateThread(function()
					run = true
					while run do
						for i = 0, 500 do
							Wait(1)
							if not isRadarExtended then
								run = false
								break
							end
						end
						SetRadarBigmapEnabled( false, false )
						isRadarExtended = false
					end
				end)
			else
				SetRadarBigmapEnabled( false, false )
				isRadarExtended = false
			end
		end
	end
end)

function IsPedEmergencyPersonnel(ped)
	for i = 1, #emergencySkins do
		local skin = emergencySkins[i].name
		if IsPedModel(ped, GetHashKey(skin)) then
			return true
		end
	end
	return false
end

function getPedEmergencyPersonnelType(ped)
	local personnelIndex = 0
	for i = 1, #emergencySkins do
		local skin = emergencySkins[i].name
		if IsPedModel(ped, GetHashKey(skin)) then
			personnelIndex = i
		end
	end
	if personnelIndex ~= 0 then
		return emergencySkins[personnelIndex].type
	else
		return nil
	end
end

function DrawTracerText(text, spacing, talking)
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
	--Citizen.Trace("playerBlips: dist = " .. dist)

	local scale = (1/dist)*20
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov

	SetTextFont(0)
	SetTextProportional(1)
	if talking then
		SetTextColour(0, 0, 255, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	SetDrawOrigin(x, y, z+spacing, 0)
	SetTextScale(0.3*scale, 0.08*scale)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

-- emergency ped blips

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if isPlayerEmergencyPed(GetPlayerPed(-1)) then
			--Citizen.Trace("player is emergency ped")
			for id = 0, 64 do
				if NetworkIsPlayerActive(id) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then
					local playerPed = GetPlayerPed(id)
					if isPlayerEmergencyPed(playerPed) then
						if getEmergencyPedType(playerPed) == "police" then
							Citizen.Trace("player " .. GetPlayerServerId(id) .. " was emergency ped (police)! applying blip!")
							local blip = GetBlipFromEntity( playerPed )
							if not DoesBlipExist( blip ) then
								blip = AddBlipForEntity( playerPed )
								SetBlipColour(blip, 3)
							end
						elseif getEmergencyPedType(playerPed) == "ems" or getEmergencyPedType(playerPed) == "fire" then
							Citizen.Trace("player " .. GetPlayerServerId(id) .. " was emergency ped (ems)! applying blip!")
							local blip = GetBlipFromEntity( playerPed )
							if not DoesBlipExist( blip ) then
								blip = AddBlipForEntity( playerPed )
								SetBlipColour(blip, 1)
							end
						end
					end
				end
			end
		else
			for x = 0, 64 do
				--Wait(5000)
				--Citizen.Trace("checking " .. GetPlayerName(x))
				local everyPedInGame = GetPlayerPed(x)
				local pedBlip = GetBlipFromEntity(everyPedInGame)
				--Citizen.Trace("everyPedInGame = " .. everyPedInGame)
				--Citizen.Trace("pedBlip = " .. pedBlip)
				if GetBlipSprite( pedBlip ) ~= 2 then -- not invisible already
					--Citizen.Trace("pedBlip was not invisible already... making invisible...")
					SetBlipSprite(pedBlip, 2) -- make invis (ghetto way to remove blip)
					SetBlipScale( pedBlip,  0.01 ) -- set scale (ghetto way to remove blip)
				end
			end
		end
	end
end)

function getEmergencyPedType(ped)
	for i = 1, #emergencySkins do
		local skin = emergencySkins[i].name
		if IsPedModel(ped, GetHashKey(skin)) then
			local pedType = emergencySkins[i].type
			return pedType
		end
	end
	return nil
end

function isPlayerEmergencyPed(ped)
	for i = 1, #emergencySkins do
		local skin = emergencySkins[i].name
		if IsPedModel(ped, GetHashKey(skin)) then
			return true
		end
	end
	return false
end
