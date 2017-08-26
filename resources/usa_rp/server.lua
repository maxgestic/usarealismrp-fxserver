local civilianSpawns = {
    --{x = 391.611, y = -948.984, z = 29.3978}, -- atlee & sinner st
    {x = 95.2552, y = -1310.8, z = 29.2921}, -- near strip club
    --{x = 10.6334, y = -718.769, z = 44.2174} -- pitts suggestion
    {x = 434.14, y = -646.847, z = 28.7314}, -- daschound bus station 1
    --{x = 434.753, y = -629.007, z = 28.7186}, -- daschound hus station 2
    --{x = 412.16, y = -619.049, z = 28.7015}, -- daschound bus station 3
    {x = -536.625, y = -218.624, z = 38.8497} -- DMV spawn in LS
}
local civSkins = {
    "a_m_m_beach_01",
    "a_m_m_bevhills_01",
    "a_m_m_bevhills_02",
    "a_m_m_business_01",
    "a_m_m_eastsa_01",
    "a_m_m_eastsa_02",
    "a_m_m_farmer_01",
    "a_m_m_genfat_01",
    "a_m_m_golfer_01",
    "a_m_m_hillbilly_01",
    "a_m_m_indian_01",
    "a_m_m_mexcntry_01",
    "a_m_m_paparazzi_01",
    "a_m_m_tramp_01",
    "a_m_y_hiker_01",
    "a_m_y_genstreet_01",
    "a_m_m_socenlat_01",
    "a_m_m_og_boss_01",
    "a_f_y_tourist_02",
    "a_f_y_tourist_01",
    "a_f_y_soucent_01",
    "a_f_y_scdressy_01",
    "a_m_y_cyclist_01",
    "a_m_y_golfer_01",
    "S_M_M_Linecook",
    "S_M_Y_Barman_01",
    "S_M_Y_BusBoy_01",
    "S_M_Y_Waiter_01",
    "A_M_Y_StBla_01",
    "A_M_M_Tennis_01",
    "A_M_Y_BreakDance_01",
    "A_M_Y_SouCent_03",
    "S_M_M_Bouncer_01",
    "S_M_Y_Doorman_01",
    "A_F_M_Tramp_01"
}

AddEventHandler('es:playerLoaded', function(source, user)
    local money = user.getMoney()
    local bank = user.getBank()
    print("Player " .. GetPlayerName(source) .. " has loaded.")
    print("Money:" .. money)
    user.setMoney(money)
    --user.displayMoney(money)
    --user.displayBank(bank)
    TriggerClientEvent('usa_rp:playerLoaded', source)
end)

RegisterServerEvent("usa_rp:spawnPlayer")
AddEventHandler("usa_rp:spawnPlayer", function()
    local usingRandomSkin = false
    print("inside of usa_rp:spawnPlayer!")
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        --local model = user.getModel()
        local character = user.getCharacters()
        local job = user.getJob() -- add spawn point for taxi and tow jobs
        local weapons = {}
        local spawn = civilianSpawns[math.random(1,#civilianSpawns)] -- choose random spawn if civilian
        if not character.hash then
            model = civSkins[math.random(1,#civSkins)]
            TriggerClientEvent("rules:open", userSource)
            -- put in clothing store since they are new and don't have one saved
            spawn.x = 425.073
            spawn.y = -806.207
            spawn.z = 29.4911
        end
        if job == "civ" then
            weapons = user.getWeapons()
            if not weapons then
                weapons = {}
            end
        elseif job == "sheriff" then
            spawn.x = 451.255
            spawn.y = -992.41
            spawn.z = 30.6896
            --weapons = {"WEAPON_COMBATPISTOL", "WEAPON_CARBINERIFLE", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
            weapons = user.getWeapons()
            user.setJob("civ") -- spawn as a civ
            job = "civ"
        elseif job == "ems" then
            -- davis fire station
            spawn.x =  207.106
            spawn.y = -1641.45
            spawn.z = 29.8
            --weapons = {"WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
            weapons = user.getWeapons()
            user.setJob("civ") -- spawn as a civ
            job = "civ"
        elseif job == "taxi" then
            -- davis fire station
            spawn.x =  895.59
            spawn.y = -186.643
            spawn.z = 73.7617
            weapons = {}
        elseif job == "tow" then
            -- davis fire station
            spawn.x =  398.27
            spawn.y = -1641.33
            spawn.z = 29.292
            weapons = {"WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
        else
            spawn = civilianSpawns[math.random(1,#civilianSpawns)] -- choose random spawn if civilian
            weapons = {}
        end
        if weapons then
            print("#weapons = " .. #weapons)
        else
            print("user has no weapons")
        end
        local characters = user.getCharacters()
        TriggerClientEvent("usa_rp:spawn", userSource, model, job, spawn, weapons, characters)
    end)
end)

RegisterServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
AddEventHandler("usa_rp:checkJailedStatusOnPlayerJoin", function()
	print("inside of checkJailedStatusOnPlayerJoin event handler...")
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			if user.getJailtime() > 0 then
				TriggerClientEvent("jail:jail", userSource)
				TriggerClientEvent("jail:removeWeapons", userSource)
				TriggerClientEvent("jail:changeClothes", userSource)
			end
		end
	end)
end)
