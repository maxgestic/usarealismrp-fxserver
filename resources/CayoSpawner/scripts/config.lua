--Resource: 'Cayo Perico Loader/Unloader by TayMcKenzieNZ'
--Version: '3.0.0'
--Requirements: 'gamebuild 2189'
--Details: 'Spawns the island and concealment into freeroam without requiring a hopper'


CreateThread(function()
	for i = #requestedIpl, 1, -1 do
		RequestIpl(requestedIpl[i])
		requestedIpl[i] = nil
	end

	requestedIpl = nil
end)

CreateThread(function()
	while true do
		SetRadarAsExteriorThisFrame()
		SetRadarAsInteriorThisFrame(`h4_fake_islandx`, vec(4700.0, -5145.0), 0, 0)
		Wait(0)
	end
end)

CreateThread(function()
	SetDeepOceanScaler(0.0)
	local islandLoaded = false
	local islandCoords = vector3(4840.571, -5174.425, 2.0)

	while true do
		local pCoords = GetEntityCoords(PlayerPedId())

		if #(pCoords - islandCoords) < 2000.0 then
			if not islandLoaded then
			print('Switching to Cayo Perico...') -- Will print in console to determine when and if the script has loaded in Cayo Perico
				islandLoaded = true
				Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", 1)
				Citizen.InvokeNative(0xF74B1FFA4A15FBEA, 1) -- island path nodes (from Disquse)
				SetScenarioGroupEnabled('Heist_Island_Peds', 1)
				-- SetAudioFlag('PlayerOnDLCHeist4Island', 1) --- Disables Radio Wheel, This has been ignored
				RemoveIpl("h4_islandairstrip_doorsclosed")
				RemoveIpl("h4_islandairstrip_doorsclosed_lod")
				RequestIpl("h4_islandairstrip_doorsopen_lod")
				RequestIpl("h4_islandairstrip_doorsopen")
				RequestIpl("h4_islandairstrip_props")
				RequestIpl("h4_islandairstrip_propsb_slod")
				RequestIpl("h4_islandairstrip_props_slod")
				RequestIpl("h4_islandairstrip_lod")
				RequestIpl("h4_islandairstrip_hangar_props")
				RequestIpl("h4_mph4_airstrip_interior_0_airstrip_hanger")
				RequestIpl("h4_islandairstrip_slod")
				RequestIpl("h4_islandairstrip_propsb")
				RequestIpl("h4_islandairstrip_hangar_props_lod")
				RequestIpl("h4_islandairstrip_hangar_props_slod")
				RequestIpl("h4_islandx_disc_strandedwhale")
				RequestIpl("h4_islandx_disc_strandedwhale_lod")
				RequestIpl("h4_islandx_disc_strandedshark")
				RequestIpl("h4_islandx_disc_strandedshark_lod")
				SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', 1, 1)
                SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", true, true)
                SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, true)
				EnableInteriorProp(interiorid, "h4_prop_h4_art_pant_01a")
			end
		else
			if islandLoaded then
			print('Switching to San Andreas...') -- Will print in console to determine when and if the script has unloaded Cayo Perico and switched back to Los Santos
				islandLoaded = false
				Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", 0)
				Citizen.InvokeNative(0xF74B1FFA4A15FBEA, 0)
				SetScenarioGroupEnabled('Heist_Island_Peds', 0)
				RemoveIpl("h4_islandairstrip_doorsopen_lod")
				RemoveIpl("h4_islandairstrip_doorsopen")
				-- SetAudioFlag('PlayerOnDLCHeist4Island', 0)
				SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', 0, 0)
				SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', 1, 0)
			end
		end

		Wait(5000)
	end
end)

Citizen.CreateThread(function()
  SetDeepOceanScaler(0.0)
end)