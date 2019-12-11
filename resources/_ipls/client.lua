Citizen.CreateThread(function()
	Citizen.Wait(30000)
	LoadMpDlcMaps()
	EnableMpDlcMaps(true)
	-- north yankton --
	--[[
	RequestIpl("prologue01")
	RequestIpl("prologue01c")
	RequestIpl("prologue01d")
	RequestIpl("prologue01e")
	RequestIpl("prologue01f")
	RequestIpl("prologue01g")
	RequestIpl("prologue01h")
	RequestIpl("prologue01i")
	RequestIpl("prologue01j")
	RequestIpl("prologue01k")
	RequestIpl("prologue01z")
	RequestIpl("prologue02")
	RequestIpl("prologue03")
	RequestIpl("prologue03b")
	RequestIpl("prologue03_grv_dug")
	RequestIpl("prologue_grv_torch")
	RequestIpl("prologue04")
	RequestIpl("prologue04b")
	RequestIpl("prologue04_cover")
	RequestIpl("prologue05")
	RequestIpl("prologue05b")
	RequestIpl("prologue06")
	RequestIpl("prologue06b")
	RequestIpl("prologue06_int")
	RequestIpl("prologue06_pannel")
	RequestIpl("plg_occl_00")
	RequestIpl("prologue_occl")
	RequestIpl("prologuerd")
	RequestIpl("prologuerdb")
	--end north yankton --
	--]]
	-- yachts --
	RequestIpl("smboat")
	RequestIpl("smboat_lod")
	RequestIpl("hei_yacht_heist")
	RequestIpl("hei_yacht_heist_enginrm")
	RequestIpl("hei_yacht_heist_Lounge")
	RequestIpl("hei_yacht_heist_Bridge")
	RequestIpl("hei_yacht_heist_Bar")
	RequestIpl("hei_yacht_heist_Bedrm")
	RequestIpl("hei_yacht_heist_DistantLights")
	RequestIpl("hei_yacht_heist_LODLights")
	RequestIpl("gr_heist_yacht2")
	RequestIpl("gr_heist_yacht2_bar")
	RequestIpl("gr_heist_yacht2_bedrm")
	RequestIpl("gr_heist_yacht2_bridge")
	RequestIpl("gr_heist_yacht2_enginrm")
	RequestIpl("gr_heist_yacht2_lounge")
	-- end yachts --
	-- clubhouses --
	RequestIpl("bkr_biker_interior_placement_interior_0_biker_dlc_int_01_milo")
	RequestIpl("bkr_biker_interior_placement_interior_1_biker_dlc_int_02_milo")
	-- end clubhouses --
	RequestIpl("chop_props")
	RequestIpl("FIBlobby")
	RemoveIpl("FIBlobbyfake")
	RequestIpl("FBI_colPLUG")
	RequestIpl("FBI_repair")
	RequestIpl("v_tunnel_hole")
	RequestIpl("TrevorsMP")
	RequestIpl("TrevorsTrailer")
	RequestIpl("TrevorsTrailerTidy")
	RemoveIpl("farm_burnt")
	RemoveIpl("farm_burnt_lod")
	RemoveIpl("farm_burnt_props")
	RemoveIpl("farmint_cap")
	RemoveIpl("farmint_cap_lod")
	RequestIpl("farm")
	RequestIpl("farmint")
	RequestIpl("farm_lod")
	RequestIpl("farm_props")
	RequestIpl("facelobby")
	RemoveIpl("CS1_02_cf_offmission")
	RequestIpl("CS1_02_cf_onmission1")
	RequestIpl("CS1_02_cf_onmission2")
	RequestIpl("CS1_02_cf_onmission3")
	RequestIpl("CS1_02_cf_onmission4")
	RequestIpl("v_rockclub")
	RemoveIpl("hei_bi_hw1_13_door")
	RequestIpl("bkr_bi_hw1_13_int")
	RequestIpl("ufo")
	RemoveIpl("v_carshowroom")
	RemoveIpl("shutter_open")
	RemoveIpl("shutter_closed")
	RemoveIpl("shr_int")
	RemoveIpl("csr_inMission")
	RequestIpl("v_carshowroom")
	RequestIpl("shr_int")
	RequestIpl("shutter_closed")
	RequestIpl("smboat")
	RequestIpl("cargoship")
	RequestIpl("railing_start")
	RemoveIpl("sp1_10_fake_interior")
	RemoveIpl("sp1_10_fake_interior_lod")
	RequestIpl("sp1_10_real_interior")
	RequestIpl("sp1_10_real_interior_lod")
	RemoveIpl("id2_14_during_door")
	RemoveIpl("id2_14_during1")
	RemoveIpl("id2_14_during2")
	RemoveIpl("id2_14_on_fire")
	RemoveIpl("id2_14_post_no_int")
	RemoveIpl("id2_14_pre_no_int")
	RemoveIpl("id2_14_during_door")
	RequestIpl("id2_14_during1")
	RequestIpl("coronertrash")
	RequestIpl("Coroner_Int_On")
	RemoveIpl("bh1_16_refurb")
	RemoveIpl("jewel2fake")
	RemoveIpl("bh1_16_doors_shut")
	RequestIpl("refit_unload")
	RequestIpl("post_hiest_unload")
	RequestIpl("Carwash_with_spinners")
	RequestIpl("ferris_finale_Anim")
	RemoveIpl("ch1_02_closed")
	RequestIpl("ch1_02_open")
	RequestIpl("AP1_04_TriAf01")
	RequestIpl("CS2_06_TriAf02")
	RequestIpl("CS4_04_TriAf03")
	RemoveIpl("scafstartimap")
	RequestIpl("scafendimap")
	RemoveIpl("DT1_05_HC_REMOVE")
	RequestIpl("DT1_05_HC_REQ")
	RequestIpl("DT1_05_REQUEST")
	RequestIpl("FINBANK")
	RemoveIpl("DT1_03_Shutter")
	RemoveIpl("DT1_03_Gr_Closed")
	RequestIpl("ex_sm_13_office_01a")
	RequestIpl("ex_sm_13_office_01b")
	RequestIpl("ex_sm_13_office_02a")
	RequestIpl("ex_sm_13_office_02b")
	RequestIpl("hei_carrier")
	RequestIpl("hei_carrier_DistantLights")
	RequestIpl("hei_Carrier_int1")
	RequestIpl("hei_Carrier_int2")
	RequestIpl("hei_Carrier_int3")
	RequestIpl("hei_Carrier_int4")
	RequestIpl("hei_Carrier_int5")
	RequestIpl("hei_Carrier_int6")
	RequestIpl("hei_carrier_LODLights")
	RequestIpl("des_farmhouse")
	RemoveIpl("rc12b_default")
	RemoveIpl("rc12b_hospitalinterior")
	RemoveIpl("rc12b_hospitalinterior_lod")
	RequestIpl("sm_smugdlc_interior_placement")
	RequestIpl("sm_smugdlc_interior_placement_interior_0_smugdlc_int_01_milo_")
	RequestIpl("xm_x17dlc_int_placement")
	RequestIpl("xm_x17dlc_int_placement_interior_0_x17dlc_int_base_ent_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_10_x17dlc_int_tun_straight_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_11_x17dlc_int_tun_slope_flat_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_12_x17dlc_int_tun_flat_slope_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_13_x17dlc_int_tun_30d_r_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_14_x17dlc_int_tun_30d_l_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_15_x17dlc_int_tun_straight_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_16_x17dlc_int_tun_straight_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_17_x17dlc_int_tun_slope_flat_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_18_x17dlc_int_tun_slope_flat_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_19_x17dlc_int_tun_flat_slope_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_1_x17dlc_int_base_loop_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_20_x17dlc_int_tun_flat_slope_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_21_x17dlc_int_tun_30d_r_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_22_x17dlc_int_tun_30d_r_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_23_x17dlc_int_tun_30d_r_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_24_x17dlc_int_tun_30d_r_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_25_x17dlc_int_tun_30d_l_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_26_x17dlc_int_tun_30d_l_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_27_x17dlc_int_tun_30d_l_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_28_x17dlc_int_tun_30d_l_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_29_x17dlc_int_tun_30d_l_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_2_x17dlc_int_bse_tun_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_30_v_apart_midspaz_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_31_v_studio_lo_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_32_v_garagem_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_33_x17dlc_int_02_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_34_x17dlc_int_lab_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_35_x17dlc_int_tun_entry_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_3_x17dlc_int_base_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_4_x17dlc_int_facility_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_5_x17dlc_int_facility2_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_6_x17dlc_int_silo_01_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_7_x17dlc_int_silo_02_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_8_x17dlc_int_sub_milo_")
	RequestIpl("xm_x17dlc_int_placement_interior_9_x17dlc_int_01_milo_")
	RequestIpl("xm_x17dlc_int_placement_strm_0")
	RequestIpl("xm_bunkerentrance_door")
	RequestIpl("xm_hatch_01_cutscene")
	RequestIpl("xm_hatch_02_cutscene")
	RequestIpl("xm_hatch_03_cutscene")
	RequestIpl("xm_hatch_04_cutscene")
	RequestIpl("xm_hatch_06_cutscene")
	RequestIpl("xm_hatch_07_cutscene")
	RequestIpl("xm_hatch_08_cutscene")
	RequestIpl("xm_hatch_09_cutscene")
	RequestIpl("xm_hatch_10_cutscene")
	RequestIpl("xm_hatch_closed")
	RequestIpl("xm_hatches_terrain")
	RequestIpl("xm_hatches_terrain_lod")
	RequestIpl("xm_mpchristmasadditions")
	RequestIpl("xm_siloentranceclosed_x17")
	-- oneils farm --
	RequestIpl("farm")
	RequestIpl("farm_props")
	RequestIpl("farm_int")
end)

local xnmark = xnmark or {}
local distance = 50.5999

xnmark.locations = {
	["Doomsday Finale"] = {
		["markin"] = {-354.6,4825.0,144.3},
		["markout"] = {1256.2868652344, 4798.3833007812, -39.471000671386},
		["locin"] = {1259.5418701172, 4812.1196289062, -39.77448272705, 344.82873535156},
		["locout"] = {-355.9, 4823.3, 142.9}
	},
	["Doomsday Silo"] = {
		["markin"] = {598.3062133789, 5556.9243164062, -716.76141357422}, -- Not Used
		["markout"] = {369.55322265625, 6319.6455078125, -159.92749023438},
		["locin"] = {369.46231079102, 6319.7626953125, -659.92739868164}, -- Not Used
		["locout"] = {602.27032470704, 5546.9267578125, 716.38928222656, 246.04162597656},
	},
	["Doomsday Facility"] = {
		["markin"] = {1286.9239501954, 2845.8833007812, 49.394256591796},
		["markout"] = {489.0622253418, 4785.3623046875, -58.929149627686},
		["locin"] = {483.2006225586, 4810.5405273438, -58.919288635254, 18.04705619812},
		["locout"] = {1267.4091796875, 2830.9741210938, 48.444499969482, 128.1668395996},
	},
	["IAA Facility"] = {
		["markin"] = {2049.8181152344, 2949.5847167968, 47.735733032226},
		["markout"] = {2155.0627441406, 2921.0417480468, -61.902416229248},
		["locin"] = {2151.1369628906, 2921.3303222656, -61.901874542236, 85.827827453614},
		["locout"] = {2053.8020019532, 2953.4047851562, 47.664855957032, 354.8461303711},
	},
	["IAA Server"] = {
		["markin"] = {2477.6774902344, -402.14556884766, 94.817413330078},
		["markout"] = {2154.7639160156, 2921.0678710938, -81.075424194336},
		["locin"] = {2158.1184082032, 2920.9382324218, -81.075386047364, 270.48007202148},
		["locout"] = {2482.9174804688, -405.25631713868, 93.735389709472, 318.76651000976},
	},
	["Doomsday Sub"] = {
		["markin"] = {493.83395385742, -3222.7514648438, 10.49820137024},
		["markout"] = {514.42980957032, 4888.4028320312, -62.589431762696},
		["locin"] = {514.29266357422, 4885.8706054688, -62.589862823486, 180.25909423828},
		["locout"] = {496.30267333984, -3222.6359863282, 6.0695104599, 270.0},
	},
}

function TeleportIntoInterior(locationdata, ent)
	local x,y,z,h = table.unpack(locationdata)
	DoScreenFadeOut(1000)
	while IsScreenFadingOut() do Citizen.Wait(0) end
	NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
	Wait(1000)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), h)
	NetworkFadeInEntity(GetPlayerPed(-1), 0)
	Wait(1000)
	FreezeEntityPosition(PlayerPedId(), false)
	SetGameplayCamRelativeHeading(0.0)
	DoScreenFadeIn(1000)
	while IsScreenFadingIn() do Citizen.Wait(0)	end
end

function TeleportIntoInteriorVehicle(locationdata, ent)
	local x,y,z,h = table.unpack(locationdata)
	DoScreenFadeOut(1000)
	while IsScreenFadingOut() do Citizen.Wait(0) end
	NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
	Wait(1000)
	SetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false), x, y, z)
	SetEntityHeading(GetVehiclePedIsIn(PlayerPedId(), false), h)
	NetworkFadeInEntity(GetPlayerPed(-1), 0)
	Wait(1000)
	FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
	SetGameplayCamRelativeHeading(0.0)
	DoScreenFadeIn(1000)
	while IsScreenFadingIn() do Citizen.Wait(0)	end
end

function SpawnFacility()
	interiorID = GetInteriorAtCoordsWithType(345.0041, 4842.001, -59.9997, "xm_x17dlc_int_02")

	if IsValidInterior(interiorID) then
		EnableInteriorProp(interiorID, "set_int_02_decal_01")
		EnableInteriorProp(interiorID, "set_int_02_lounge1")
		EnableInteriorProp(interiorID, "set_int_02_cannon")
		EnableInteriorProp(interiorID, "set_int_02_clutter1")
		EnableInteriorProp(interiorID, "set_int_02_crewemblem")
		EnableInteriorProp(interiorID, "set_int_02_shell")
		EnableInteriorProp(interiorID, "set_int_02_security")
		EnableInteriorProp(interiorID, "set_int_02_sleep")
		EnableInteriorProp(interiorID, "set_int_02_trophy1")
		EnableInteriorProp(interiorID, "set_int_02_paramedic_complete")
		EnableInteriorProp(interiorID, "set_Int_02_outfit_paramedic")
		EnableInteriorProp(interiorID, "set_Int_02_outfit_serverfarm")
		SetInteriorPropColor(interiorID, "set_int_02_decal_01", 1)
		SetInteriorPropColor(interiorID, "set_int_02_lounge1", 1)
		SetInteriorPropColor(interiorID, "set_int_02_cannon", 1)
		SetInteriorPropColor(interiorID, "set_int_02_clutter1", 1)
		SetInteriorPropColor(interiorID, "set_int_02_shell", 1)
		SetInteriorPropColor(interiorID, "set_int_02_security", 1)
		SetInteriorPropColor(interiorID, "set_int_02_sleep", 1)
		SetInteriorPropColor(interiorID, "set_int_02_trophy1", 1)
		SetInteriorPropColor(interiorID, "set_int_02_paramedic_complete", 1)
		SetInteriorPropColor(interiorID, "set_Int_02_outfit_paramedic", 1)
		SetInteriorPropColor(interiorID, "set_Int_02_outfit_serverfarm", 1)
		RefreshInterior(interiorID)
	end
end

function DespawnFacility()
	interiorID = GetInteriorAtCoordsWithType(345.0041, 4842.001, -59.9997, "xm_x17dlc_int_02")

	DisableInteriorProp(interiorID,  "set_int_02_decal_01")
	DisableInteriorProp(interiorID,  "set_int_02_lounge1")
	DisableInteriorProp(interiorID,  "set_int_02_cannon")
	DisableInteriorProp(interiorID,  "set_int_02_clutter1")
	DisableInteriorProp(interiorID,  "set_int_02_crewemblem")
	DisableInteriorProp(interiorID,  "set_int_02_shell")
	DisableInteriorProp(interiorID,  "set_int_02_security")
	DisableInteriorProp(interiorID,  "set_int_02_sleep")
	DisableInteriorProp(interiorID,  "set_int_02_trophy1")
	DisableInteriorProp(interiorID,  "set_int_02_paramedic_complete")
	DisableInteriorProp(interiorID,  "Set_Int_02_outfit_paramedic")
	DisableInteriorProp(interiorID,  "Set_Int_02_outfit_serverfarm")
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not IsEntityDead(PlayerPedId(-1)) then
			for k,v in pairs(xnmark.locations) do

				local ix,iy,iz = table.unpack(v["markin"])
				local ox,oy,oz = table.unpack(v["markout"])

				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ix, iy, iz, true) < 50.5999 then -- Outside Marker
					DrawMarker(2, ix,iy,iz, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.75, 0.75, 0.75, 255, 255, 0, 100, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ix, iy, iz, true) < 1.0 then
						if k == "Doomsday Facility" then
							if IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), false) then
								FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
								TeleportIntoInteriorVehicle(v["locin"], false)
								SpawnFacility()
							else
								FreezeEntityPosition(PlayerPedId(), true)
								SpawnFacility()
								TeleportIntoInterior(v["locin"], false)
							end
						elseif k == "Doomsday Finale" then
							if IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), false) then
								FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
								TeleportIntoInteriorVehicle(v["locin"], false)
							else
								FreezeEntityPosition(PlayerPedId(), true)
								TeleportIntoInterior(v["locin"], false)
							end
						else
							FreezeEntityPosition(PlayerPedId(), true)
							TeleportIntoInterior(v["locin"], false)
						end
					end
				end
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ox, oy, oz, true) < 50.5999 then -- Inside Marker
					DrawMarker(2, ox, oy, oz, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.75, 0.75, 0.75, 255, 255, 0, 100, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ox, oy, oz, true) < 1.0 then
						if k == "Doomsday Facility" then
							if IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), false) then
								FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
								TeleportIntoInteriorVehicle(v["locout"], false)
								DespawnFacility()
							else
								FreezeEntityPosition(PlayerPedId(), true)
								TeleportIntoInterior(v["locout"], false)
								DespawnFacility()
							end
						elseif k == "Doomsday Finale" then
							if IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), false) then
								FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
								TeleportIntoInteriorVehicle(v["locout"], false)
							else
								FreezeEntityPosition(PlayerPedId(), true)
								TeleportIntoInterior(v["locout"], false)
							end
						else
							FreezeEntityPosition(PlayerPedId(), true)
							TeleportIntoInterior(v["locout"], false)
						end
					end
				end

			end
		end
	end
end)
