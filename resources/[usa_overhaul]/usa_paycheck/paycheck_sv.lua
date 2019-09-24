local CHECK_RECEIVE_INTERVAL_MINUTES = 20
local TIME_CHECK_INTERVAL_MINUTES = 1

local lastPaidTimes = {}

local lastCheckTime = 0

AddEventHandler("playerDropped", function(reason)
	if lastPaidTimes[source] then 
		lastPaidTimes[source] = nil
	end
end)

AddEventHandler("character:loaded", function(char)
    lastPaidTimes[char.get("source")] = os.time()
end)

function DepositPayCheck(char)
	if not char then
		return
    end
    local source = char.get("source")
    local isWelfare = false
    local paycheckAmount = 0

    local job = char.get("job")

    if job == "cop" or job == "sheriff" or job == "highwaypatrol" or job == "fbi" then
        local cop_rank = char.get("policeRank")
        paycheckAmount = 225
        if cop_rank == 2 then
            paycheckAmount = 275
        elseif cop_rank == 3 then
            paycheckAmount = 325
        elseif cop_rank == 4 then
            paycheckAmount = 365
        elseif cop_rank == 5 then
            paycheckAmount = 385
        elseif cop_rank == 6 then
            paycheckAmount = 400
        elseif cop_rank == 7 then
            paycheckAmount = 410
        elseif cop_rank == 8 then
            paycheckAmount = 420
        elseif cop_rank == 9 then
            paycheckAmount = 430
        elseif cop_rank == 10 then
            paycheckAmount = 440
        end
    elseif job == "ems" or job == "fire" then
        local rank = char.get("emsRank")
        paycheckAmount = 300
        if rank == 2 then
            paycheckAmount = 315
        elseif rank == 3 then
            paycheckAmount = 325
        elseif rank == 4 then
            paycheckAmount = 335
        elseif rank == 5 then
            paycheckAmount = 350
        elseif rank == 6 then
            paycheckAmount = 370
        elseif rank == 7 then
            paycheckAmount = 395
        end
    elseif job == "taxi" then
        paycheckAmount = 40
    elseif job == "tow" then
        paycheckAmount = 40
    elseif job == "reporter" then
        paycheckAmount = 35
    elseif job == "judge" then
        paycheckAmount = 350
    elseif job == "corrections" then
        paycheckAmount = 210
    elseif job == "lawyer" then
        paycheckAmount = 300
    elseif job == "doctor" then
        paycheckAmount = 300
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
    else
        msg = msg .. "of $" .. paycheckAmount .. "."
    end
    
    TriggerClientEvent('usa:notify', source, msg)
end

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
                           "You currently work for the ~y~Blaine County Sheriff's Office~s~.")
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
        TriggerClientEvent("usa:notify", source,'You are currently working for ~y~GoPostal~s~.')
    else 
        TriggerClientEvent("usa:notify", source,'You are currently working as ~y~'.. job .. '~s~.')
    end
end

function GetMinutesFromTime(time)
	local minutesfrom = os.difftime(os.time(), time) / 60
	local wholemins = math.floor(minutesfrom)
	return wholemins
end

Citizen.CreateThread(function()
    Wait(15000)
    while true do
        if GetMinutesFromTime(lastCheckTime) >= TIME_CHECK_INTERVAL_MINUTES then
            lastCheckTime = os.time()
            exports["usa-characters"]:GetCharacters(function(chars)
                for id, char in pairs(chars) do
                    -- not a good place for this but, for now: --
                    char.set("ingameTime", char.get("ingameTime") + TIME_CHECK_INTERVAL_MINUTES)
                    -- paycheck --
                    local doPay = true
                    if not lastPaidTimes[id] then
                        lastPaidTimes[id] = os.time()
                    end
                    if GetMinutesFromTime(lastPaidTimes[id]) < CHECK_RECEIVE_INTERVAL_MINUTES then
                        doPay = false
                    end
                    if doPay then
                        DepositPayCheck(char)
                        lastPaidTimes[id] = os.time()
                    end
                end
            end)
        end
        Wait(1000)
    end
end)

TriggerEvent('es:addCommand', 'job', function(source, args, char)
    local job = char.get("job")
    myJob(job, source)
end, {help = "See what your active job is"})

TriggerEvent('es:addCommand', 'myjob', function(source, args, char)
    local job = char.get("job")
    myJob(job, source)
end, {help = "See what your active job is"})