local IsFireFighter = false
local FireBlips = {}

if Config.UseESX then
	Citizen.CreateThread(function()
		while not ESX do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(500)
		end
	end)

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        ESX.PlayerData = xPlayer
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
            IsFireFighter = true
        else 
            IsFireFighter = false
        end
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        ESX.PlayerData.job = job
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
            IsFireFighter = true
        else
            IsFireFighter = false
        end
    end)
elseif Config.UseQBUS then
    RegisterNetEvent('FireScript:')
    AddEventHandler('usa_rp:playerLoaded', function()
        local char = exports["usa-characters"]:GetCharacter(source)
        local job = char.get("job")
        if job == "fire" or job == "ems" then
            IsFireFighter = true
        else
            IsFireFighter = false
        end
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
        local PlayerJob = job
        if PlayerJob.name == Config.JobName then
            IsFireFighter = true
        else
            IsFireFighter = false
        end
    end)
else
    --Gives The Player FireHose Perms
    if Config.UseFireJobWhitelist then
        TriggerServerEvent('FireScript:RequestPermissions')
    else
        IsFireFighter = true
    end
end

RegisterNetEvent('FireScript:RequestPermissions')
AddEventHandler('FireScript:RequestPermissions', function(allowed)
    IsFireFighter = allowed
end)

--[[Fire Detection Stuff For WhiteListed Players Only]]--
RegisterNetEvent('FireScript:FireStarted')
AddEventHandler('FireScript:FireStarted', function(id, position, sendMessage)
    if IsFireFighter then
        if not FireBlips[id] then
            CreateMapPing(position, Config.FireWarnings.Ping)
            CreateFireBlip(position, id, Config.FireWarnings.Blip)
        end

        if Config.FireWarnings.Message.Enabled and sendMessage then
            local x, y, z = table.unpack(mycoords)
            local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
            local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
            TriggerServerEvent("911:UncontrolledFire", x, y, z, lastStreetNAME)
        end
    end
end)

RegisterNetEvent('FireScript:FireStopped')
AddEventHandler('FireScript:FireStopped', function(id, position)
    if IsFireFighter then
        if id then
            DeleteFireBlip(id)

            if Config.FireWarnings.Message.Enabled then
                local x, y, z = table.unpack(mycoords)
                local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
                local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
                TriggerServerEvent("911:UncontrolledFire", x, y, z, lastStreetNAME)
            end
        else--All Fires Are Stopped
            for id, data in ipairs(FireBlips) do
                DeleteFireBlip(id)
            end
            if Config.FireWarnings.Message.Enabled then
                TriggerEvent('usa:notify', 'Fire Stopped, All Locations')
            end
        end
    end
end)

--[[Functions]]--
function CreateMapPing(targetCoords, data)
    if data.Enabled then
        CreateThread(function()
            local alpha = data.StartAlpha
            local blip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, data.Radius)

            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, data.Color)
            SetBlipAlpha(blip, alpha)
            SetBlipAsShortRange(blip, false)

            while alpha ~= 0 do
                Citizen.Wait(data.FadeTimer * 4)
                alpha = alpha - 1
                SetBlipAlpha(blip, alpha)

                if alpha == 0 then
                    RemoveBlip(blip)
                    return
                end
            end
        end)
    end
end

function CreateFireBlip(targetCoords, id, data)
    if data.Enabled then
        CreateThread(function()
            FireBlips[id] = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

            SetBlipSprite(FireBlips[id], data.Sprite)
            SetBlipHighDetail(FireBlips[id], true)
            SetBlipColour(FireBlips[id], data.Color)
            SetBlipAlpha(FireBlips[id], data.Alpha)
            SetBlipAsShortRange(FireBlips[id], false)
            BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(data.Name)
			EndTextCommandSetBlipName(FireBlips[id])
        end)
    end
end

function DeleteFireBlip(id)
    if FireBlips[id] then
        RemoveBlip(FireBlips[id])
        FireBlips[id] = nil
    end
end