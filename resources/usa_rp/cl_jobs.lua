local jobs = {
    {name = "Meth", blip = {x = 1389.28, y = 3604.6, z = 38.1, sprite = 499, color = 75}}
}

-- job blips
Citizen.CreateThread(function()
    for i=1,#jobs do
		local blip = AddBlipForCoord(jobs[i].blip.x, jobs[i].blip.y, jobs[i].blip.z)
		SetBlipSprite(blip, jobs[i].blip.sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.9)
		SetBlipColour(blip, jobs[i].blip.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(jobs[i].blip.name)
		EndTextCommandSetBlipName(blip)
    end
end)

local playingAnim = false
-- set animation for job here (default meth atm)
local animDict = "timetable@jimmy@ig_1@idle_a"
local animName = "hydrotropic_bud_or_something"

-- handle job animations
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
        if playingAnim then
            if not IsEntityPlayingAnim(GetPlayerPed(-1), animDict, animName, 3) then
				RequestAnimDict(animDict)
				while not HasAnimDictLoaded(animDict) do
					Citizen.Wait(100)
				end
				TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
			end
        end
        -- TODO: draw special text
        for i = 1, #jobs do
            -- draw meth job marker
            DrawMarker(1, jobs[i].blip.x,jobs[i].blip.y,jobs[i].blip.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 255, 102, 255, 90, 0, 0, 2, 0, 0, 0, 0)
            -- check distance for jobs
		    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), jobs[i].blip.x, jobs[i].blip.y, jobs[i].blip.z, true ) < 3 then
                drawTxt('Press ~g~E~s~ to start creating meth',0,1,0.5,0.8,0.6,255,255,255,255)
                if not playingAnim then
                    Citizen.Trace("close to meth job! playing animation!")
                    RequestAnimDict(animDict)
    			    while not HasAnimDictLoaded(animDict) do
    				    Citizen.Wait(100)
    			    end
                    TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
                    playingAnim = true
                end
                --SetPedAlternateMovementAnim(GetPlayerPed(-1), 0, "amb@world_human_bum_standing@drunk@", "idle_a")
                --TaskPlayAnim(GetPlayerPed(-1), "anim@sports@ballgame@handball@", "ball_idle", 8.0, -8.0, -1,49, 0.0, 0, 0, 0)
            else
                playingAnim = false
                ClearPedSecondaryTask(GetPlayerPed(-1))
                StopAnimTask(GetPlayerPed(-1), animDict, animName, false)
            end
        end
    end
end)

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end
