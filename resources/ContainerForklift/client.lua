-- map blip id: 371

-- job sign in: x = 1192.2296142578, y = -3254.0080566406, z = 6.0287671089172
-- truck spawn: x = 1182.6973876953, y = -3243.505859375, z = 6.0287652015686, h = 0
-- truck return: x = 1178.8041992188, y = -3270.1596679688, z = 5.6969623565674

local CONTAINER_DROP_OFF = { x = 1273.4604492188, y = -3299.0146484375, z = 5.9015979766846 }

isAttached = false
isDroppingOff = false
canSleep = false

truckHandle = nil
dropOffBlip = nil

RegisterNetEvent("containerjob:startJob")
AddEventHandler("containerjob:startJob", function(container, paidForTruck)
    -- set drop off map blip
    dropOffBlip = AddBlipForCoord(CONTAINER_DROP_OFF.x, CONTAINER_DROP_OFF.y, CONTAINER_DROP_OFF.z)
    SetBlipSprite(dropOffBlip, 355)
    SetBlipScale(dropOffBlip, 0.6)
    SetBlipColour(dropOffBlip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Container Drop Off")
    EndTextCommandSetBlipName(dropOffBlip)
    if paidForTruck then
        -- spawn truck
        spawnTruck()
    end
    -- spawn container
    spawnContainer(container)
    -- set map waypoint to container
    TriggerEvent("swayam:SetWayPointWithAutoDisable", container.x, container.y, container.z, 280, 60, "Container")
    if paidForTruck then
        -- notify
        exports.globals:notify("Your container has been marked on the map", "INFO: Your container has been marked on the map. Pick it up and drive it to the drop off location marked as a green 'D' on your map.")
    else
        exports.globals:notify("New container marked")
    end
end)

function spawnTruck()
    local vehicleHash = GetHashKey("handler")
    RequestModel(vehicleHash)
	while not HasModelLoaded(vehicleHash) do
		Wait(1)
	end
    truckHandle = CreateVehicle(vehicleHash, 1182.6973876953, -3243.505859375, 6.0, 0.0, true, false)
    SetEntityAsMissionEntity(truckHandle)
	SetVehicleOnGroundProperly(truckHandle)
	local vehPlate = GetVehicleNumberPlateText(truckHandle)
    TriggerServerEvent("containerjob:dropKeys", vehPlate)
end

function spawnContainer(info)
    local containerModel = 874602658
    RequestModel(containerModel)
	while not HasModelLoaded(containerModel) do
		Wait(1)
	end
    containerHandle = CreateObject(containerModel, info.x, info.y, info.z, true)
    SetEntityAsMissionEntity(containerHandle)
    SetEntityHeading(containerHandle, info.h)
    PlaceObjectOnGroundProperly(containerHandle)
    local netid = ObjToNet(containerHandle)
    SetNetworkIdExistsOnAllMachines(netid, true)
    NetworkSetNetworkIdDynamic(netid, true)
    SetNetworkIdCanMigrate(netid, false)
    -- draw pick up and drop off markers:
    Citizen.CreateThread(function()
        while containerHandle and DoesEntityExist(containerHandle) do
            if isAttached and not isDroppingOff then
                -- instruct and draw container drop off marker:
                exports.globals:notify("Take the container to the drop off location")
                Citizen.CreateThread(function()
                    while DoesEntityExist(containerHandle) do
                        DrawMarker(27, CONTAINER_DROP_OFF.x, CONTAINER_DROP_OFF.y, CONTAINER_DROP_OFF.z - 0.85, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 5.0, 255 --[[r]], 150 --[[g]], 70 --[[b]], 90 --[[alpha]], 0, 0, 2, 0, 0, 0, 0)
                        Wait(1)
                    end
                end)
                isDroppingOff = true
            else
                if not isAttached then
                    -- draw pick up marker:
                    local coords = GetEntityCoords(containerHandle)
                    DrawMarker(0, coords.x, coords.y, coords.z + 4.0, 0, 0, 0, 0, 0, 0, 0.91, 0.91, 0.91, 255 --[[r]], 150 --[[g]], 30 --[[b]], 90 --[[alpha]], 0, 0, 2, 0, 0, 0, 0)
                    -- dropping off:
                    if #(GetEntityCoords(containerHandle) - vector3(CONTAINER_DROP_OFF.x, CONTAINER_DROP_OFF.y, CONTAINER_DROP_OFF.z)) < 5 then
                        while securityToken == nil do
                            Wait(1)
                        end
                        TriggerServerEvent("containerjob:reward", securityToken)
                        DeleteObject(containerHandle)
                        isDroppingOff = false
                        TriggerServerEvent("containerjob:startJob", false)
                        break
                    end
                end
            end
            Wait(1)
        end
    end)
end

Citizen.CreateThread(function()
    AddTextEntry("press_attach_vehicle", "Press ~INPUT_DETONATE~ to pick up this container up")
    AddTextEntry("press_detach_vehicle", "Press ~INPUT_DETONATE~ to detach this container")
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetEntityModel(veh) == `handler` then  -- Hash > Handler
                local pedCoords = GetEntityCoords(ped, 0)
                local objectId = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z+5.0, 5.0, GetHashKey("prop_contr_03b_ld"), false)
                if objectId ~= 0 then
                    if isAttached then

                        if IsEntityAttachedToHandlerFrame(veh, objectId) == false then
                            isAttached = false
                            Wait(2000)
                        end

                        DisplayHelpTextThisFrame("press_detach_vehicle")
                    else
                        if IsHandlerFrameAboveContainer(veh, objectId) == 1 then
                            DisplayHelpTextThisFrame("press_attach_vehicle")
                        end
                    end
                    
                    if IsControlJustPressed(0, 47) then
                        if isAttached ~= true and IsHandlerFrameAboveContainer(veh, objectId) == 1 then
                            AttachContainerToHandlerFrame(veh, objectId) -- // Attach Container to Handler Frame (Thx Indra :3)
                            isAttached = true
                        else
                            DetachContainerFromHandlerFrame(veh)
                            isAttached = false
                            Wait(2000)
                        end
                    end
                    canSleep = false
                else
                    if not isAttached then
                        canSleep = true
                    end
                end
            end
        end
        if canSleep then
            Citizen.Wait(2000)
        end
    end
end)

exports.globals:createCulledNonNetworkedPedAtCoords("s_m_m_postal_01", {
    {x = 1192.2296142578, y = -3254.0080566406, z = 6.0287671089172, heading = 41.0}
}, 300.0, "[E] - Toggle Job", 5.0, function()
    local onJob = TriggerServerCallback {
        eventName = "containerjob:isOnJob",
        args = {}
    }
    if not onJob then
        TriggerServerEvent("containerjob:startJob", true)
    else
        local truckExists = DoesEntityExist(truckHandle)
        TriggerServerEvent("containerjob:stopJob", truckExists)
        if truckExists then
            DeleteVehicle(truckHandle)
        end
        if DoesEntityExist(containerHandle) then
            DeleteObject(containerHandle)
        end
        RemoveBlip(dropOffBlip)
        TriggerEvent("swayam:RemoveWayPoint")
    end
end, 38)