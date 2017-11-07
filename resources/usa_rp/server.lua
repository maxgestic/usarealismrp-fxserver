local civilianSpawns = {
    --{x = 391.611, y = -948.984, z = 29.3978}, -- atlee & sinner st
    --{x = 95.2552, y = -1310.8, z = 29.2921}, -- near strip club
    --{x = 10.6334, y = -718.769, z = 44.2174} -- pitts suggestion
    --{x = 434.14, y = -646.847, z = 28.7314}, -- daschound bus station 1
    --{x = 434.753, y = -629.007, z = 28.7186}, -- daschound hus station 2
    --{x = 412.16, y = -619.049, z = 28.7015}, -- daschound bus station 3
    --{x = -536.625, y = -218.624, z = 38.8497}, -- DMV spawn in LS
    --{x = 232.919, y = -880.539, z = 30.5921}, -- legion square
    --{x = 233.919, y = -880.539, z = 30.5921}, -- legion square
    --{x = 234.919, y = -880.539, z = 30.5921} -- legion square
    {x = -288.624, y = 6229.223, z = 31.454}, -- paleto (barber shop)
    {x = -201.658, y = 6630.692, z = 31.534}, -- paleto (gas station)
    {x = -391.130, y = 6216.655, z = 31.473} -- paleto (procopio dr)
    --{x = -447.467, y = 6009.258, z = 31.716} -- paleto (police spawn) DONE
    --{x = -368.314, y = 6101.166, z = 35.440} -- paleto (ems spawn) DONE
    --{x = 121.594, y = 6626.484, z = 31.943} -- paleto (car dealer) DONE
    --{x = 65.096, y = 6561.489, z = 29.380} -- paleto (tow truck drop off) DONE
    --{x = 380.562, y = 6119.039, z = 31.631} -- paleto (heal station) DONE
    --{x = -455.301, y = 5984.455, z = 31.308} -- paleto (police vehicle repair) DONE?
    --{x=-240.10, y=6324.22, z=32.43} -- hospital release DONE
    --{x=-1004.18, y=4848.26, z=275.01} -- paleto (weed dealer) DONE
    -- {x=-1000.36, y=4848.59, z=275.01} -- paleto (weed dealer ped walk to location) NOT USED
    -- Weed delivery 1 x 1538.26 y 6324.73 z 24.07 DONE
    -- weed delivery 2 x-2186.82 y 4250.06 z 48.94 heading 37.01 DONE
    -- weed delivery 3 x2352.62 y 3132.28 z 48.21 heading 69.85 DONE
    -- Meth Delivery -402.63 y 6316.12 z 28.95 heading 222.26 DONE
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
        local weapons = user.getWeapons()
        local model
        --local spawn = civilianSpawns[math.random(1,#civilianSpawns)] -- choose random spawn if civilian
        local spawn = civilianSpawns[math.random(1, #civilianSpawns)]

        if not character.hash then
            model = civSkins[math.random(1,#civSkins)]
            TriggerClientEvent("rules:open", userSource)
        end

        if job == "sheriff" or job == "police" then
            spawn.x = -447.467
            spawn.y = 6009.258
            spawn.z = 31.716
            --weapons = {"WEAPON_COMBATPISTOL", "WEAPON_CARBINERIFLE", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
        elseif job == "ems" then
            -- davis fire station
            spawn.x =  -368.314
            spawn.y = 6101.166
            spawn.z = 35.440
		elseif job == "security" then
			spawn.x =  3502.5
            spawn.y = 3762.45
            spawn.z = 29.900
			--weapons = {"WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
        end
        --[[
        elseif job == "taxi" then
            -- davis fire station
            spawn.x =  895.59
            spawn.y = -186.643
            spawn.z = 73.7617
            weapons = user.getWeapons()
            if not weapons then
                weapons = {}
            end
        elseif job == "tow" then
            -- davis fire station
            spawn.x =  398.27
            spawn.y = -1641.33
            spawn.z = 29.292
            weapons = user.getWeapons()
            if not weapons then
                weapons = {}
            end
        end
        --]]
        if #weapons > 0 then
            print("#weapons = " .. #weapons)
        else
            print("user has no weapons")
        end

        user.setJob("civ")

        TriggerClientEvent("usa_rp:spawn", userSource, model, job, spawn, weapons, character)
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
