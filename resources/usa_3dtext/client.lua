local nbrDisplaying = 0

function Display(player, text, offset, factor2, maxDist, time)
	if player ~= -1 then
		local displaying = true
		Citizen.CreateThread(function()
			Wait(time)
			displaying = false
		end)
		Citizen.CreateThread(function()
			nbrDisplaying = nbrDisplaying + 1
			while displaying do
				Wait(0)
				local coords = GetEntityCoords(GetPlayerPed(player), false)
				DrawText3Ds(coords['x'], coords['y'], coords['z']+offset+0.3, text, factor2, maxDist)
			end
			nbrDisplaying = nbrDisplaying - 1
		end)
	end
end

function DrawText3Ds(x,y,z, text, factor2, maxDist)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    if dist > maxDist then
    	doit = false
    else
    	doit = true
    end
    if doit then
	    SetTextScale(0.35, 0.35)
	    SetTextFont(4)
	    SetTextProportional(1)
	    SetTextColour(255, 255, 255, 215)
	    SetTextEntry("STRING")
	    SetTextCentre(1)
	    AddTextComponentString(text)
	    DrawText(_x,_y)
	    local factor = (string.len(text)) / factor2
	    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	end
end

RegisterNetEvent('display:triggerDisplay')
AddEventHandler('display:triggerDisplay', function(source, text, nbrLimit, factor2, maxDist, time, x)
	if x then
		offset = 0 + (nbrDisplaying*0.06)
	else
		offset = 0 + (nbrDisplaying*0.14)
	end
	if nbrDisplaying < nbrLimit then
		Display(GetPlayerFromServerId(source), text, offset, factor2, maxDist, time)
	end
end)

StatSetInt('MP0_STAMINA', 0, true)
StatSetInt('MP0_STRENGTH', 0, true)
StatSetInt('MP0_LUNG_CAPACITY', 0, true)
StatSetInt('MP0_WHEELIE_ABILITY', 0, true)
StatSetInt('MP0_FLYING_ABILITY', 0, true)
StatSetInt('MP0_SHOOTING_ABILITY', 0, true)
StatSetInt('MP0_STEALTH_ABILITY', 0, true)