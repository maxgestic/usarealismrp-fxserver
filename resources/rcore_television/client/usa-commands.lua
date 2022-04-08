RegisterNetEvent("tv:playlink")
AddEventHandler("tv:playlink", function(link)
    ExecuteCommand("playlink " .. link)
end)

RegisterNetEvent("tv:volume")
AddEventHandler("tv:volume", function(new)
    ExecuteCommand("tvvolume " .. new)
end)

-- also going to throw in an anticheese flag suppressor bit of code here for now:

print("yessss!")

function isModelATV(model)
    local tvModels = {
        "prop_tv_flat_01",
        "prop_huge_display_01",
        "des_tvsmash_end",
        "des_tvsmash_root",
        "des_tvsmash_start",
        'ex_prop_ex_tv_flat_01',
        "prop_tv_flat_01",
        "prop_tv_flat_01_screen",
        "xm_prop_x17_tv_stand_01a",
        "prop_tv_flat_02",
        "prop_tv_flat_02b",
        "prop_tv_flat_03",
        "prop_tv_flat_03b",
        "prop_tv_flat_michael",
        "sm_prop_smug_tv_flat_01",
        "xm_prop_x17_tv_flat_01",
        1340914825,
        -1158929576
    }
    for i = 1, #tvModels do
        local toCompare = tvModels[i]
        if type(toCompare) == "string" then
            toCompare = GetHashKey(tvModels[i])
        end
        if toCompare == model then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    local anticheeseDisabled = false
    while true do
        if IsControlJustPressed(0, 38) and not anticheeseDisabled then
            for object in exports.globals:EnumerateObjects() do
                local model = GetEntityModel(object)
                if isModelATV(model) then
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