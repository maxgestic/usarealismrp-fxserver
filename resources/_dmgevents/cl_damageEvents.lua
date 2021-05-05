local littleTrickToSkipGettingScrambledByParser = "gameEventTriggered"
AddEventHandler(littleTrickToSkipGettingScrambledByParser, function(event, data)
    if event == "CEventNetworkEntityDamage" then
        victim = data[1]
        attacker = data[2]
        victimDied = data[6]
        weaponHash = data[7]
        isMeleeDamage = data[12]
        vehicleDamageTypeFlag = data[13]

        if victim and attacker then
            if victimDied then
                if IsEntityAVehicle(victim) then 
                    TriggerEvent("DamageEvents:VehicleDestroyed", victim, attacker, weaponHash, isMeleeDamage, vehicleDamageTypeFlag)
                else
                    if IsEntityAPed(victim) then
                        if IsEntityAVehicle(attacker, true) then 
                            TriggerEvent("DamageEvents:PedKilledByVehicle", victim, attacker)
                        elseif IsEntityAPed(attacker) then 
                            if IsPedAPlayer(attacker) then 
                                player = NetworkGetPlayerIndexFromPed(attacker)
                                TriggerEvent("DamageEvents:PedKilledByPlayer", victim, player, weaponHash, isMeleeDamage)
                            else 
                                TriggerEvent("DamageEvents:PedKilledByPed", victim, attacker, weaponHash, isMeleeDamage)
                            end
                        else 
                            TriggerEvent("DamageEvents:PedDied", victim, attacker, weaponHash, isMeleeDamage)
                        end
                    else 
                        TriggerEvent("DamageEvents:EntityKilled", victim, attacker, weaponHash, isMeleeDamage)
                    end
                end
            else 
                if not IsEntityAVehicle(victim) then
                    TriggerEvent("DamageEvents:EntityDamaged", victim, attacker, weaponHash, isMeleeDamage)
                else 
                    TriggerEvent("DamageEvents:VehicleDamaged", victim, attacker, weaponHash, isMeleeDamage, vehicleDamageTypeFlag)
                end
            end
        end
    end
end)
