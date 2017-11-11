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
    print("inside of usa_rp:spawnPlayer!")
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local characters = user.getCharacters()
        local job = user.getJob() -- add spawn point for taxi and tow jobs
        local weapons = user.getWeapons()
        local model = civSkins[math.random(1,#civSkins)]
        --local spawn = civilianSpawns[math.random(1,#civilianSpawns)] -- choose random spawn if civilian
        --[[
        if not characters[1].firstName then
            TriggerClientEvent("rules:open", userSource)
        end
        --]]
        if #weapons > 0 then
            print("#weapons = " .. #weapons)
        else
            print("user has no weapons")
        end
        user.setJob("civ")
        TriggerClientEvent("usa_rp:spawn", userSource, model, job, weapons, characters)
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
