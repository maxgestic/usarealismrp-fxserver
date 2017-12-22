local Settings = {

	["UserGroup"] = "user",

	--Should the scoreboard draw player ID?
	["PlayerID"] = true,

	--Display time in milliseconds
	["DisplayTime"] = 3000,

	--Keys that will activate the scoreboard.
	--Change only the number value, NOT the 'true'
	--Multiple keys can be used, simply add another row with another number
	--See: https://wiki.gtanet.work/index.php?title=Game_Controls

	-- F7
	[170] = true,
}

local xOffset, yOffset = 0.55, 0

-- END OF SETTINGS --

RegisterNetEvent("jscoreboard:setUserGroup")
AddEventHandler("jscoreboard:setUserGroup", function(group)
	print("setting scoreboard user group to: " .. group)
	Settings["UserGroup"] = group
end)

local function DrawPlayerList()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive( i ) then
            table.insert( players, {i,GetPlayerServerId(i)})
        end
    end

	-- sort
	table.sort(players, function(a,b)
		return a[2] > b[2]
	end)

	--Top bar
	DrawRect( 0.11 + xOffset, 0.025, 0.2, 0.03, 0, 0, 0, 220 )

	--Top bar title
	SetTextFont( 4 )
	SetTextProportional( 0 )
	SetTextScale( 0.45, 0.45 )
	SetTextColour( 255, 255, 255, 255 )
	SetTextDropShadow( 0, 0, 0, 0, 255 )
	SetTextEdge( 1, 0, 0, 0, 255 )
	SetTextEntry( "STRING" )
	AddTextComponentString( "Players: " .. #players )
	DrawText( 0.01 + xOffset, 0.007 )

	for k, v in pairs( players ) do
		local r
		local g
		local b

		if k % 2 == 0 then
			r = 28
			g = 47
			b = 68
		else
			r = 38
			g = 57
			b = 74
		end

		--Row BG
		DrawRect( 0.11 + xOffset, 0.025 + ( k * 0.03 ), 0.2, 0.03, r, g, b, 220 )

		--Name Label
		SetTextFont( 4 )
		SetTextScale( 0.45, 0.45 )
		SetTextColour( 255, 255, 255, 255 )
		SetTextEntry( "STRING" )
		AddTextComponentString( v[2] .. " | " .. GetPlayerName( v[1] ) )
		DrawText( 0.01 + xOffset, 0.007 + ( k * 0.03 ) )

	end
end

-- ID #'s overhead
function DrawTracerText(text, spacing, talking)
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
	--Citizen.Trace("playerBlips: dist = " .. dist)

	local scale = (1/dist)*40
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov

	SetTextFont(0)
	SetTextProportional(1)
	if talking then
		SetTextColour(0, 0, 255, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	SetDrawOrigin(x, y, z+spacing, 0)
	SetTextScale(0.3*scale, 0.08*scale)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function ShowIds()
	local viewDistance = 0
	if Settings["UserGroup"] == "user" then
		viewDistance = 10
	else
		viewDistance = 40
	end
	for id = 0, 64 do
		x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
		if NetworkIsPlayerActive(id) and GetDistanceBetweenCoords(x,y,z, GetEntityCoords(GetPlayerPed(-1))) < viewDistance then
			ped = GetPlayerPed(id)
			blip = GetBlipFromEntity(ped)

			if NetworkIsPlayerTalking(id) then
				--if GetPlayerPed(id) ~= GetPlayerPed(-1) then
					--DrawMarker(2, x, y, z+1.10, 0, 0, 0, 0, 180.0, 0, 0.3, 0.1, 0.25, 0, 0, 200, 200, 0, GetEntityHeading(GetPlayerPed(-1)), 0, 0)
					--Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(id), false, false, "", false)
					--Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, tostring(GetPlayerServerId(id)), false, false, "", false)
					DrawTracerText(tostring(GetPlayerServerId(id)), 1.2, true)
			--	end
			else
				--DrawMarker(2, x, y, z+1.10, 0, 0, 0, 0, 180.0, 0, 0.3, 0.1, 0.25, 0, 200, 0, 200, 0, GetEntityHeading(GetPlayerPed(-1)), 0, 0)
				--Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(id), false, false, "", false)
				--Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, tostring(GetPlayerServerId(id)), false, false, "", false)
				DrawTracerText(tostring(GetPlayerServerId(id)), 1.2, false)
			end
		end
	end
end

local LastPress = 0

Citizen.CreateThread( function()
	RequestStreamedTextureDict( "mplobby" )
	RequestStreamedTextureDict( "mpleaderboard" )

	while true do
		Wait( 0 )

		for k, v in pairs( Settings ) do
			if type( k ) == "number" and v == true then
				if IsControlPressed( 0, k ) and GetLastInputMethod(2) then
					LastPress = GetGameTimer()
				end
			end
		end

		if GetGameTimer() < LastPress + Settings["DisplayTime"] then
			DrawPlayerList()
			ShowIds()
		end

	end
end )
