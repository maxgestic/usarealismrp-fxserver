local WAIT_DURATION_MINUTES = 20

local lastPaidTimes = {}

AddEventHandler("playerDropped", function(reason)
	if lastPaidTimes[source] then 
		lastPaidTimes[source] = nil
	end
end)

RegisterServerEvent('paycheck:welfare')
AddEventHandler('paycheck:welfare', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if not char then
		return
	end
    local isWelfare = false
    local paycheckAmount = 0

	-- don't trust the clients wait duration --
    local lastPaidTime = lastPaidTimes[source]
    if lastPaidTime then
		if GetMinutesFromTime(lastPaidTime) < WAIT_DURATION_MINUTES then
            --TriggerClientEvent("usa:notify", source, "Something went wrong when trying to deposit your paycheck!")
            print("Something went wrong when trying to deposit player with source id " .. source .. "'s paycheck!")
			return
		end
	end

    lastPaidTimes[source] = os.time()

    local job = char.get("job")

    if job == "cop" or job == "sheriff" or job == "highwaypatrol" or job ==
        "fbi" then
        local cop_rank = char.get("policeRank")
        paycheckAmount = 150
        if cop_rank == 2 then
            paycheckAmount = 225
        elseif cop_rank == 3 then
            paycheckAmount = 275
        elseif cop_rank == 4 then
            paycheckAmount = 335
        elseif cop_rank == 5 then
            paycheckAmount = 360
        elseif cop_rank == 6 then
            paycheckAmount = 390
        elseif cop_rank == 7 then
            paycheckAmount = 415
        elseif cop_rank == 8 then
            paycheckAmount = 430
        elseif cop_rank == 9 then
            paycheckAmount = 470
        elseif cop_rank == 10 then
            paycheckAmount = 480
        end
    elseif job == "ems" or job == "fire" then
        local rank = char.get("emsRank")
        paycheckAmount = 120
        if rank == 2 then
            paycheckAmount = 215
        elseif rank == 3 then
            paycheckAmount = 275
        elseif rank == 4 then
            paycheckAmount = 320
        elseif rank == 5 then
            paycheckAmount = 350
        elseif rank == 6 then
            paycheckAmount = 370
        elseif rank == 7 then
            paycheckAmount = 395
        end
    elseif job == "security" then
        paycheckAmount = 500
    elseif job == "taxi" then
        paycheckAmount = 30
    elseif job == "tow" then
        paycheckAmount = 30
    elseif job == "reporter" then
        paycheckAmount = 35
    elseif job == "judge" then
        paycheckAmount = 300
    elseif job == "corrections" then
        paycheckAmount = 150
    elseif job == "lawyer" then
        paycheckAmount = 220
    elseif job == "doctor" then
        paycheckAmount = 330
    elseif job == "dai" then
        paycheckAmount = 95
    else
        paycheckAmount = 25 -- welfare amount (no job)
        isWelfare = true
    end

    char.giveBank(paycheckAmount)

    local msg = "You received a "
    if isWelfare then
        msg = msg .. "welfare check "
    else
        msg = msg .. "check "
    end
    if job == "taxi" then
        msg = msg .. "of $" .. paycheckAmount .. " from ~y~Downtown Cab Co.~s~."
    elseif job == "tow" then
        msg = msg .. "of $" .. paycheckAmount .. " from ~y~Bubba's Tow Co.~s~."
    elseif job == "reporter" then
        msg = msg .. "of $" .. paycheckAmount .. " from ~y~Weazel News~s~."
    elseif job == "sheriff" then
        msg = msg .. "of $" .. paycheckAmount .. " from the ~y~San Andreas State Police~s~."
    elseif job == "corrections" then
        msg = msg .. "of $" .. paycheckAmount .. " from the ~y~San Andreas Department of Corrections~s~."
    elseif job == "ems" then
        msg = msg .. "of $" .. paycheckAmount .. " from ~y~Los Santos Fire Department~s~."
    elseif job == "lawyer" then
        msg = msg .. "of $" .. paycheckAmount .. " from the ~y~San Andreas Legal Association~s~."
    elseif job == 'judge' then
        msg = msg .. "of $" .. paycheckAmount .. " from the ~y~San Andreas Court Administration~s~."
    elseif job == 'doctor' then
        msg = msg .. "of $" .. paycheckAmount .. " from the ~y~Pillbox Medical Center~s~."
    elseif job == 'dai' then
        msg = msg .. "of $" .. paycheckAmount .. " from the ~y~District Attorney Investigation Branch~s~."
    else
        msg = msg .. "of $" .. paycheckAmount .. "."
	end
	
    -- sort of a bad place for this but also keep track of in game time.
    local user_time = char.get("ingameTime")
	char.set("ingameTime", user_time + WAIT_DURATION_MINUTES)
	
	-- notify user
    TriggerClientEvent('usa:notify', source, msg)
end)

TriggerEvent('es:addCommand', 'job', function(source, args, char)
    local job = char.get("job")
    myJob(job, source)
end, {help = "See what your active job is"})

TriggerEvent('es:addCommand', 'myjob', function(source, args, char)
    local job = char.get("job")
    myJob(job, source)
end, {help = "See what your active job is"})

function myJob(job, source)
    if job == "civ" then
        TriggerClientEvent('usa:notify', source,
                           "You do not currently work for any companies.")
    elseif job == "taxi" then
        TriggerClientEvent('usa:notify', source,
                           "You currently work for ~y~Downtown Cab Co~s~.")
    elseif job == "tow" then
        TriggerClientEvent('usa:notify', source,
                           "You currently work for ~y~Bubba's Tow Co.~s~.")
    elseif job == "sheriff" then
        TriggerClientEvent('usa:notify', source,
                           "You currently work for the ~y~San Andreas State Police~s~.")
    elseif job == "police" then
        TriggerClientEvent('usa:notify', source,
                           "You currently work for the ~y~Los Santos Police Department~s~.")
    elseif job == "ems" then
        TriggerClientEvent('usa:notify', source,
                           "You currently work for the ~y~Los Santos Fire Department~s~.")
    elseif job == "fire" then
        TriggerClientEvent('usa:notify', source,
                           "You currently work for the ~y~Los Santos Fire Department~s~.")
    elseif job == "chickenFactory" then
        TriggerClientEvent('usa:notify', source,
                           "You currently work for ~y~Cluckin' Bell~s~.")
    elseif job == 'corrections' then
        TriggerClientEvent('usa:notify', source,
                           "You currently work for the ~y~San Andreas Department of Corrections~s~.")
    elseif job == 'lawyer' then
        TriggerClientEvent('usa:notify', source,
                           "You currently work for the ~y~San Andreas Legal Association~s~.")
    elseif job == 'judge' then
        TriggerClientEvent('usa:notify', source,
                           'You are currently working for the ~y~San Andreas Court Administration~s~.')
    elseif job == 'doctor' then
        TriggerClientEvent('usa:notify', source,
                           'You are currently working for the ~y~Pillbox Medical Center~s~.')
    elseif job == "gopostal" then
        TriggerClientEvent("usa:notify", source,
                           'You are currently working for ~y~GoPostal~s~.')
    end
end

function GetMinutesFromTime(time)
	local minutesfrom = os.difftime(os.time(), time) / 60
	local wholemins = math.floor(minutesfrom)
	return wholemins
end