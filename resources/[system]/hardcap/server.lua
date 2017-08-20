local totalPlayerCount = 0
local publicPlayerCount = 0
local reservedPlayerCount = 0
local publicList = {}
local reservedList = {}
local reservedPlayers = {
    "127.0.0.1",
    "174.59.73.199", -- gray
    "68.4.75.110", -- minipunch
    "24.223.137.159", -- blackie chan
    "98.255.42.60", -- hack
    "92.9.219.85", -- eclipse
    "207.30.128.189", -- lt. dan murphy
    "152.13.236.227", -- barnes
    "75.109.79.69", -- ricky golden
    "178.149.138.10", -- nova
    "71.174.134.162", -- gavin tan
    "73.62.150.126", -- j. freeman
    "174.49.212.55", -- m. lentz
    "99.132.177.228", -- Jeff Saggot
    "89.100.150.246", -- rimka
    "86.0.255.114", -- jack ryan
    "85.227.248.200", -- marcus
    "47.184.33.115", -- otto ottman
    "73.220.46.9", -- miles long
    "86.159.130.161", -- zoidberg (michael anderson) / jack
    "68.2.177.65", -- caddy
    "70.118.135.50", -- michael rodgers
    "73.225.193.85", -- niko caropot
    "84.212.154.83", -- eddie newman
    "107.4.163.14", -- josh stephens
    "109.67.3.134", -- afek
    "50.51.195.104", -- N. Patton
    "68.102.156.211", -- drevv
    "106.70.48.149", -- william harus
    "47.40.127.197", -- don jones
    "23.125.224.73", -- garrett
    "70.55.212.242", -- K. kronin
    "50.51.195.104", -- N. Patton
    "160.3.4.243", -- bentley parker (beee)
    "86.171.251.251", -- k. moretti
    "84.193.236.76", -- henk mason
    "87.100.145.96", -- kol winter
    "79.101.82.135", -- sikkkk
    "85.224.124.15", -- t. williams
    "91.14.241.80", -- weedom boiz (pittsburg)
    "176.27.62.53", -- violette ford
    "23.241.12.132", -- burrito
    "64.186.74.43" -- mike henderson
}

RegisterServerEvent('hardcap:playerActivated')

AddEventHandler('hardcap:playerActivated', function()
    for i = 1, #reservedPlayers do
        if reservedPlayers[i] == GetPlayerEP(source) then
            if not reservedList[source] then
                totalPlayerCount = totalPlayerCount + 1
                reservedPlayerCount = reservedPlayerCount + 1
                reservedList[source] = true
                print("player was reserved...")
                print("totalPlayerCount = " .. totalPlayerCount)
                print("publicPlayerCount = " .. publicPlayerCount)
                print("reservedPlayerCount = " .. reservedPlayerCount)
                return
            end
        end
    end
    -- at this point, player is not reserved
    if not publicList[source] then
        totalPlayerCount = totalPlayerCount + 1
        publicPlayerCount = publicPlayerCount + 1
        publicList[source] = true
    end

    print("player was not reserved...")
    print("totalPlayerCount = " .. totalPlayerCount)
    print("publicPlayerCount = " .. publicPlayerCount)
    print("reservedPlayerCount = " .. reservedPlayerCount)
end)

AddEventHandler('playerDropped', function()
    for i = 1, #reservedPlayers do
        if reservedPlayers[i] == GetPlayerEP(source) then
            if reservedList[source] then
                totalPlayerCount = totalPlayerCount - 1
                reservedPlayerCount = reservedPlayerCount - 1
                reservedList[source] = nil
                return
            end
        end
    end
    -- at this point, player is not reserved
    if publicList[source] then
        totalPlayerCount = totalPlayerCount - 1
        publicPlayerCount = publicPlayerCount - 1
        publicList[source] = nil
    end
end)

AddEventHandler('playerConnecting', function(name, setReason)
    local MAX_PLAYER_COUNT = 32
    print('Connecting: ' .. name)
    print("Player EP: " .. GetPlayerEP(source))
    print("totalPlayerCount = " .. totalPlayerCount)
    print("publicPlayerCount = " .. publicPlayerCount)
    print("reservedPlayerCount = " .. reservedPlayerCount)

    if totalPlayerCount >= MAX_PLAYER_COUNT then
        print('Full (at 32). :(')
        setReason('Full (at 32) :(')
        CancelEvent()
    end

    if publicPlayerCount >= 29 then
        if not playerHasReservedSlot(source) then
            print('All public slots taken :(')
            setReason('All public slots taken :(')
            CancelEvent()
        end
    end

end)

function playerHasReservedSlot(source)
    local playerEP = GetPlayerEP(source)
    for i = 1, #reservedPlayers do
        if reservedPlayers[i] == playerEP then
            -- match found
            return true
        end
    end
    -- no match found
    return false
end
