local LOG_ENTITY_CREATION = true
local LOG_EXPLOSIONS = true

local BLACKLISTED_MODELS = {
    ["prop_fnclink_05crnr1"] = true,
	["xs_prop_hamburgher_wl"] = true,
	["xs_prop_plastic_bottle_wl"] = true,
	["prop_windmill_01"] = true,
	["p_spinning_anus_s"] = true,
	["stt_prop_ramp_adj_flip_m"] = true,
	["stt_prop_ramp_adj_flip_mb"] = true,
	["stt_prop_ramp_adj_flip_s"] = true,
	["stt_prop_ramp_adj_flip_sb"] = true,
	["stt_prop_ramp_adj_hloop"] = true,
	["stt_prop_ramp_adj_loop"] = true,
	["stt_prop_ramp_jump_l"] = true,
	["stt_prop_ramp_jump_m"] = true,
	["stt_prop_ramp_jump_s"] = true,
	["stt_prop_ramp_jump_xl"] = true,
	["stt_prop_ramp_jump_xs"] = true,
	["stt_prop_ramp_jump_xxl"] = true,
	["stt_prop_ramp_multi_loop_rb"] = true,
	["stt_prop_ramp_spiral_l"] = true,
	["stt_prop_ramp_spiral_l_l"] = true,
	["stt_prop_ramp_spiral_l_m"] = true,
	["stt_prop_ramp_spiral_l_s"] = true,
	["stt_prop_ramp_spiral_l_xxl"] = true,
	["stt_prop_ramp_spiral_m"] = true,
	["stt_prop_ramp_spiral_s"] = true,
    ["stt_prop_ramp_spiral_xxl"] = true,
    ["stt_prop_stunt_jump_loop"] = true,
    ["stt_prop_stunt_jump30"] = true,
    ["stt_prop_stunt_jump45"] = true,
    ["stt_prop_stunt_jump15"] = true,
    ["stt_prop_stunt_track_bumps"] = true,
    ["stt_prop_stunt_track_dwlink_02"] = true,
    ["stt_prop_stunt_track_cutout"] = true,
    ["stt_prop_stunt_track_dwlink"] = true,
    ["stt_prop_stunt_track_dwslope15"] = true,
    ["stt_prop_stunt_track_dwshort"] = true,
    ["stt_prop_stunt_track_dwsh15"] = true,
    ["stt_prop_stunt_track_dwslope30"] = true,
    ["stt_prop_stunt_track_dwslope45"] = true,
    ["stt_prop_stunt_track_dwturn"] = true,
    ["stt_prop_stunt_track_dwuturn"] = true,
    ["stt_prop_stunt_track_exshort"] = true,
    ["stt_prop_stunt_track_fork"] = true,
    ["stt_prop_stunt_track_funlng"] = true,
    ["stt_prop_stunt_track_funnel"] = true,
    ["stt_prop_stunt_track_hill"] = true,
    ["stt_prop_stunt_track_hill2"] = true,
    ["stt_prop_stunt_track_jump"] = true,
    ["stt_prop_stunt_track_link"] = true,
    ["stt_prop_stunt_track_otake"] = true,
    ["stt_prop_stunt_track_sh15"] = true,
    ["stt_prop_stunt_track_sh30"] = true,
    ["stt_prop_stunt_track_sh45"] = true,
    ["stt_prop_stunt_track_sh45_a"] = true,
    ["stt_prop_stunt_track_short"] = true,
    ["stt_prop_stunt_track_slope15"] = true,
    ["stt_prop_stunt_track_slope30"] = true,
    ["stt_prop_stunt_track_slope45"] = true,
    ["stt_prop_stunt_track_st_01"] = true,
    ["stt_prop_stunt_track_st_02"] = true,
    ["stt_prop_stunt_track_start"] = true,
    ["stt_prop_stunt_track_start_02"] = true,
    ["stt_prop_stunt_track_straight"] = true,
    ["stt_prop_stunt_track_straightice"] = true,
    ["stt_prop_stunt_track_turn"] = true,
    ["stt_prop_stunt_track_turnice"] = true,
    ["stt_prop_stunt_track_uturn"] = true,
    ["stt_prop_stunt_tube_crn"] = true,
    ["stt_prop_stunt_tube_crn_15d"] = true,
    ["cargoplane"] = true,
    ["jet"] = true
}

local BLACKLISTED_HASHES = {}

for model, isBlacklisted in pairs(BLACKLISTED_MODELS) do
    BLACKLISTED_HASHES[GetHashKey(model)] = true
end

-- log explosions for now --
AddEventHandler('explosionEvent', function(sender, ev)
    if LOG_EXPLOSIONS then
        print("explosion detected!")
        print(exports.globals:dump(ev))
        --CancelEvent()
    end
end)

-- log entity creations on toggle for now --
AddEventHandler('entityCreating', function(entity)
    if LOG_ENTITY_CREATION then
        local src = NetworkGetEntityOwner(entity)
        local createdEntityModel = GetEntityModel(entity)
        if BLACKLISTED_HASHES[createdEntityModel] then
            print("[anticheese] blacklisted entity with model of " .. createdEntityModel .. " was created by src: " .. src)
            local reason = "Spawning Entities."
            TriggerEvent("anticheese:ViolationDetected", reason, src)
            CancelEvent()
        end
    end
end)


AddEventHandler('rconCommand', function(cmd, args)
    if cmd == 'logentities' then
        LOG_ENTITY_CREATION = not LOG_ENTITY_CREATION
        print("Logging Entities: " .. tostring(LOG_ENTITY_CREATION))
    elseif cmd == 'logexplosions' then 
        LOG_EXPLOSIONS = not LOG_EXPLOSIONS
        print("Logging Entities: " .. tostring(LOG_EXPLOSIONS))
    end
end)