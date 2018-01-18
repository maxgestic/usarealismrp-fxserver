-- Camping created by Vespura (Contributor: SPJESTER)
local prevtent = 0

RegisterNetEvent("camping:tent")
AddEventHandler("camping:tent", function()
  if prevtent == 0 then
    if prevtent ~= 0 then
        SetEntityAsMissionEntity(prevtent)
        DeleteObject(prevtent)
        prevtent = 0
    end
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.95))
    local tents = {
        'prop_skid_tent_01',
        'prop_skid_tent_01b',
        'prop_skid_tent_03',
    }
    local randomint = math.random(1,3)
    local tent = GetHashKey(tents[randomint])
    local prop = CreateObject(tent, x, y, z, true, false, true)
    SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
    prevtent = prop
  end
end)

local prevfire = 0
RegisterNetEvent("camping:campfire")
AddEventHandler("camping:campfire", function()
  if prevfire == 0 then
    if prevfire ~= 0 then
        SetEntityAsMissionEntity(prevfire)
        DeleteObject(prevfire)
        prevfire = 0
    end
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.55))
    local prop = CreateObject(GetHashKey("prop_beach_fire"), x, y, z, true, false, true)
    SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
    prevfire = prop
    TriggerServerEvent("camping:removeItem", "campfire")
  end
end)

local prevchair = 0
RegisterNetEvent("camping:chair")
AddEventHandler("camping:chair", function()
  print("inside camping:chair event handler!")
  if prevchair == 0 then
    if prevchair ~= 0 then
        SetEntityAsMissionEntity(prevchair)
        DeleteObject(prevchair)
        prevchair = 0
    end
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.02))
    local chair = {
        'prop_chair_02',
        'prop_chair_05',
		'prop_chair_10'
    }
    local randomint = math.random(1,3)
    local chair = GetHashKey(chair[randomint])
    local prop = CreateObject(chair, x, y, z, true, false, true)
    SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
    prevchair = prop
  end
end)

RegisterNetEvent("camping:delete")
AddEventHandler("camping:delete", function()
    local prop = 0
    local deelz = 10
    local deelxy = 2
    for offsety=-2,2 do
        for offsetx=-2,2 do
            for offsetz=-8,8 do
                local CoordFrom = GetEntityCoords(PlayerPedId(), true)
                local CoordTo = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
                local RayHandle = StartShapeTestRay(CoordFrom.x, CoordFrom.y, CoordFrom.z-(offsetz/deelz), CoordTo.x+(offsetx/deelxy), CoordTo.y+(offsety/deelxy), CoordTo.z-(offsetz/deelz), 16, PlayerPedId(), 0)
                local _, _, _, _, object = GetShapeTestResult(RayHandle)
                if object ~= 0 then
                    prop = object
                    break
                end
            end
        end
    end
    if prop == 0 then
        TriggerEvent('chatMessage', '', {255,255,255}, '^8Error: ^0could not detect object.')
    else
      if prop == prevchair or prop == prevfire or prop == prevtent then
        SetEntityAsMissionEntity(prop)
        DeleteObject(prop)
        if prop == prevchair then prevchair = 0 end
        if prop == prevfire then prevfire = 0 end
        if prop == prevtent then prevtent = 0 end
      end
    end
end)
