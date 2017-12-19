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
    local money = user.getActiveCharacterData("money")
    print("Player " .. GetPlayerName(source) .. " has loaded.")
    if money then
        print("Money:" .. money)
        --user.setActiveCharacterData("money", money) -- set money GUI in top right (?)
    else
        print("new player, default money!")
    end
    TriggerClientEvent('usa_rp:playerLoaded', source)
end)

RegisterServerEvent("usa_rp:spawnPlayer")
AddEventHandler("usa_rp:spawnPlayer", function()
    print("inside of usa_rp:spawnPlayer!")
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local characters = user.getCharacters()
        local job = user.getActiveCharacterData("job")
        if job then
            print("user.getActiveCharacterData('job') = " .. job)
        end
        local weapons = user.getActiveCharacterData("weapons")
        local model = civSkins[math.random(1,#civSkins)]
        if weapons then
            if #weapons > 0 then
                print("#weapons = " .. #weapons)
            else
                print("user has no weapons")
            end
        end
        user.setActiveCharacterData("job", "civ")
        -- todo: remove unused passed in parameters below??
        TriggerClientEvent("usa_rp:spawn", userSource, model, job, weapons, characters)
    end)
end)

RegisterServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
AddEventHandler("usa_rp:checkJailedStatusOnPlayerJoin", function(source)
	print("inside of checkJailedStatusOnPlayerJoin event handler...")
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			if user.getActiveCharacterData("jailtime") > 0 then
				TriggerClientEvent("jail:jail", userSource)
				TriggerClientEvent("jail:removeWeapons", userSource)
				TriggerClientEvent("jail:changeClothes", userSource)
			end
		end
	end)
end)

-- V E H I C L E  C O N T R O L S
TriggerEvent('es:addCommand', 'rollw', function(source, args, user)
	TriggerClientEvent("RollWindow", source)
end)

TriggerEvent('es:addCommand', 'open', function(source, args, user)
    if args[2] then
        print("opening " .. args[2])
        TriggerClientEvent("veh:openDoor", source, args[2])
        TriggerClientEvent("usa:notify", source, "test")
    end
end)

TriggerEvent('es:addCommand', 'close', function(source, args, user)
    if args[2] then
            TriggerClientEvent("veh:shutDoor", source, args[2])
    end
end)

TriggerEvent('es:addCommand', 'shut', function(source, args, user)
    if args[2] then
            TriggerClientEvent("veh:shutDoor", source, args[2])
    end
end)

TriggerEvent('es:addCommand', 'engine', function(source, args, user)
    if args[2] then
            TriggerClientEvent("veh:toggleEngine", source, args[2])
    end
end)

-- U T I L I T Y  F U N C T I O N S
RegisterServerEvent("usa:checkPlayerMoney")
AddEventHandler("usa:checkPlayerMoney", function(activity, amount, callbackEventName, isServerEvent, takeMoney)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local user_money = user.getActiveCharacterData("money")
        if user_money >= amount then
            if takeMoney then
                user.setActiveCharacterData("money", user_money - amount)
            end
            if isServerEvent then
                TriggerEvent(callbackEventName)
            else
                TriggerClientEvent(callbackEventName, userSource)
            end
        else
            TriggerClientEvent("usa:notify", userSource, "Sorry, you don't have enough money to " .. activity .. "!")
        end
    end)
end)
