RegisterNetEvent("tv:playlink")
AddEventHandler("tv:playlink", function(link)
    ExecuteCommand("playlink " .. link)
end)

RegisterNetEvent("tv:volume")
AddEventHandler("tv:volume", function(new)
    ExecuteCommand("tvvolume " .. new)
end)

-- also going to throw in an anticheese flag suppressor bit of code here for now:

Citizen.CreateThread(function()
    local anticheeseDisabled = false
    while true do
        if IsControlJustPressed(0, 38) and not anticheeseDisabled then
            for object in exports.globals:EnumerateObjects() do
                local model = GetEntityModel(object)
                if model == GetHashKey("prop_tv_flat_01") or model == GetHashKey("prop_huge_display_01") then
                    local mycoords = GetEntityCoords(PlayerPedId())
                    local objcoords = GetEntityCoords(object)
                    if #(mycoords - objcoords) < Config.closestObjectRadius then
                        anticheeseDisabled = true
                        exports._anticheese:Disable()
                    end
                end
            end
        elseif (IsControlJustPressed(0, 194) or IsControlJustPressed(0, 200)) and anticheeseDisabled then
            anticheeseDisabled = false
            exports._anticheese:Enable()
        end
        Wait(1)
    end
end)