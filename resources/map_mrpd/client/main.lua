-- clearing MRPD (?) of peds --
--[[
Citizen.CreateThread(function()
    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(myCoords, 975.76763916016,-120.56567382813,74.223541259766, true ) < 80 then
            ClearAreaOfPeds(975.76763916016,-120.56567382813,74.223541259766, 80.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 471.90618896484,-989.65802001953,24.914854049683, true ) < 20 then
            ClearAreaOfPeds(471.90618896484,-989.65802001953,24.914854049683, 80.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 243.72465515137,-1096.3624267578,29.30615234375, true ) < 30 then
            ClearAreaOfPeds(243.72465515137,-1096.3624267578,29.30615234375, 80.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 478.77, -1009.05, 35.93, true ) < 30 then
            ClearAreaOfPeds(478.77, -1009.05, 35.93, 80.0, 0)
        elseif GetDistanceBetweenCoords(myCoords, 445.8, -981.62, 26.67, true ) < 30 then
            ClearAreaOfPeds(445.8, -981.62, 26.67, 80.0, 0)
        end
        Wait(1)
    end
end)
--]]

-- start ATM at MRPD --
local atm = {
	objectHash = GetHashKey("prop_atm_02"),
	--coords = { x = 427.91198730469, y = -942.13202490234, z = 28.881920700073 }
	coords = vector3(427.9, -942.13, 28.88)
}

function CreateObjectByHash(hash, coords)
	local obj = CreateObject(hash, coords.x, coords.y, coords.z, false, false, true)
	SetEntityCollision(obj, true, true)
	SetEntityAsMissionEntity(obj, true, true)
	FreezeEntityPosition(obj, true)
	SetEntityRotation(obj, 0.0, 0.0, 0.0, true)
end

CreateObjectByHash(atm.objectHash, atm.coords)

--[[
-- spawn ATM inside when close, delete when far
Citizen.CreateThread(function()
	while true do
		local me = PlayerPedId()
		local mycoords = GetEntityCoords(me)
		if atm.coords then
			--if Vdist2(atm.coords.x, atm.coords.y, atm.coords.z, mycoords.x, mycoords.y, mycoords.z) < 500 then
			if #(atm.coords - mycoords) < 500 then
				--local atmObject = GetClosestObjectOfType(atm.coords.x, atm.coords.y, atm.coords.z, 1.0, atm.objectHash, false, false, false)
				if atm.handle and not DoesEntityExist(atm.handle) then
					CreateObjectByHash(atm.objectHash, atm.coords)
				end
			else 
				--local atmObject = GetClosestObjectOfType(atm.coords.x, atm.coords.y, atm.coords.z, 1.0, atm.objectHash, false, false, false)
				if atm.handle and DoesEntityExist(atm.handle) then
					SetEntityAsMissionEntity(atm.handle, true, true)
					DeleteEntity(atm.handle)
					atm.handle = nil
				end
			end
		end
		Wait(1000)
	end
end)
--]]