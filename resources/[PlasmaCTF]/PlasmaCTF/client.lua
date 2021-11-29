-- "missarmenian2", "drunk_loop"
-- "missarmenian2", "corpse_search_exit_ped"
local isCurrentlyInGame = false

local isCurrentlyOutInGame = false

local currentTeam = "none"

local currentPartie = 0

local isLockWaiting = false

local blueOrbsObject = 0

local redOrbsObject = 0

local blueOrbsIsTaken = false
local redOrbsIsTaken = false

local IhaveTheblueOrbs = false
local IhaveTheredOrbs = false

function playAnim(animDict, animName, duration)
	print("play anim")
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	print("anim loaded : "..tostring(animDict).." "..tostring(animName))
	TaskPlayAnim(PlayerPedId(), animDict, animName, 32.0, -1.0, duration, 2, 1, false, false, false)
	RemoveAnimDict(animDict)
end

function hasBeenHit()
	Citizen.CreateThread(function()
		ClearEntityLastDamageEntity(PlayerPedId())
		isCurrentlyOutInGame = true
		Wait(100)
		if currentTeam == "blue" then
			if IhaveTheredOrbs then
			print("drop orb blue")
			dropOrb(currentTeam,redOrbsObject)
			end
		else
			if IhaveTheblueOrbs then
			print("drop orb red")
			dropOrb(currentTeam,blueOrbsObject)
			end
		end
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+GunDamage)
		-- TriggerServerEvent("PaintBallCTF:addPoint",currentTeam,currentPartie)
		TriggerServerEvent("PaintBallCTF:EmissiveSync")
		isLockWaiting = true
		Wait(200)
		print("hit")
		
		local animRandom = math.random(1,2)
		-- Wait(3000)
		
		-- "missarmenian2", "drunk_loop"
-- "missarmenian2", "corpse_search_exit_ped"
		
		
		if animRandom == 1 then
			playAnim("missarmenian2","drunk_loop",-1)
		else
			playAnim("missarmenian2","corpse_search_exit_ped",-1)
		end
		
		
		
		FreezeEntityPosition(PlayerPedId(),true)
		Wait(15000)
		FreezeEntityPosition(PlayerPedId(),false)
		local currentMaps = currentSession.maps
		-- print("startGame : "..tostring(currentMaps))
		local redCoords = Maps[currentMaps].redCoords
		local blueCoords = Maps[currentMaps].blueCoords
		
		if currentTeam == "red" then
			-- isLockWaiting = true
			activity = {}
			activity.x = redCoords.x
			activity.y = redCoords.y
			activity.z = redCoords.z
			
			teleport(activity)
			-- SetEntityCoords(PlayerPedId(),activity.x,activity.y,activity.z+1)
		elseif currentTeam == "blue" then
			-- isLockWaiting = true
			activity = {}
			
			activity.x = blueCoords.x
			activity.y = blueCoords.y
			activity.z = blueCoords.z
			
			teleport(activity)
			-- SetEntityCoords(PlayerPedId(),activity.x,activity.y,activity.z+1)
		end
		isCurrentlyOutInGame = false
		isLockWaiting = false
		print("Plasma Game ClearEntityLastDamageEntity")
	end)
end

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if isCurrentlyInGame then
			if currentSession.modes == "CTF" then
				if GetEntityHealth(PlayerPedId()) ~= startHealth then
					SetEntityHealth(PlayerPedId(),startHealth)
				end
				if HasPedBeenDamagedByWeapon(PlayerPedId(),GetHashKey(GunName),0) then
						print("HasPedBeenDamagedByWeapon")
					if not isCurrentlyOutInGame then
						print("is not isCurrentlyOutInGame")
						hasBeenHit()
						Wait(1000)
						-- TriggerServerEvent("PaintBall:GetSourceOfDamage")--NOT WORKING or at least dont work everytime? FiveM Issue
					else
						SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+GunDamage)
					end
				end
			end
		else
			Wait(200)
		end
	end
end)

RegisterNetEvent('PaintBallCTF:SyncOrbTaken')
AddEventHandler('PaintBallCTF:SyncOrbTaken', function(team,status,session)
	-- currentSession = sessiondata
 	-- startGame(color,idx,manche)
	print("PaintBallCTF:SyncOrbTaken : "..tostring(session))
	if session then
	currentSession.ScoreA = session.ScoreA
	currentSession.ScoreB = session.ScoreB
	end
	
	if team == "blue" then
		print("SyncOrbTaken team:"..tostring(team).." my team: "..tostring(currentTeam).." redOrbsIsTaken : "..tostring(status))
		redOrbsIsTaken = status
		if status == true then
			if currentTeam == "blue" then
				notificationCTF(trad[lang]["CTFAlliesTakeOrb"],"success")
			else	
				notificationCTF(trad[lang]["CTFEnnemyTakeOrb"],"error")
			end
		else
			if currentTeam == "blue" then
				notificationCTF(trad[lang]["CTFAlliesStoleOrb"],"success") 
			else	
				notificationCTF(trad[lang]["CTFEnnemyStoleOrb"],"error")
				
			end
		end
	elseif team == "red" then
		print("SyncOrbTaken team:"..tostring(team).." my team: "..tostring(currentTeam).." blueOrbsIsTaken : "..tostring(status))
		blueOrbsIsTaken = status
		if status == true then
			if currentTeam == "red" then
				notificationCTF(trad[lang]["CTFAlliesTakeOrb"],"success")
			else	
				notificationCTF(trad[lang]["CTFEnnemyTakeOrb"],"error")
			end
		else
			if currentTeam == "red" then
				notificationCTF(trad[lang]["CTFAlliesStoleOrb"],"success") 
			else	
				notificationCTF(trad[lang]["CTFEnnemyStoleOrb"],"error")
				
			end
		end
	end
end)


RegisterNetEvent('PaintBallCTF:SyncOrbDrop')
AddEventHandler('PaintBallCTF:SyncOrbDrop', function(team,status)
	-- currentSession = sessiondata
 	-- startGame(color,idx,manche)
	
	if team == "blue" then
		print("SyncOrbTaken team:"..tostring(team).." my team: "..tostring(currentTeam).." redOrbsIsTaken : "..tostring(status))
		redOrbsIsTaken = status
		
			if currentTeam == "blue" then
				notificationCTF(trad[lang]["CTFAlliesDropOrb"],"success") 
			else	
				notificationCTF(trad[lang]["CTFEnnemyDropOrb"],"error")
				
			end
	elseif team == "red" then
		print("SyncOrbTaken team:"..tostring(team).." my team: "..tostring(currentTeam).." blueOrbsIsTaken : "..tostring(status))
		blueOrbsIsTaken = status

			if currentTeam == "red" then
				notificationCTF(trad[lang]["CTFAlliesDropOrb"],"success") 
			else	
				notificationCTF(trad[lang]["CTFEnnemyDropOrb"],"error")
				
			end

	end
end)

RegisterNetEvent("PaintBallCTF:SendEmissiveSync")
AddEventHandler('PaintBallCTF:SendEmissiveSync', function(curPlayer,blink)
	local playerIdx = GetPlayerFromServerId(curPlayer)
	-- print("received SendEmissiveSync curPlayer:"..tostring(curPlayer).." playerIdx:"..tostring(playerIdx).." blink:"..tostring(blink))
	if playerIdx ~= -1 then
	SetPedEmissiveIntensity(GetPlayerPed(playerIdx),blink)
	end
end)

RegisterNetEvent("PaintBallCTF:SendEmissive")
AddEventHandler('PaintBallCTF:SendEmissive', function(blink)
	-- local playerIdx = GetPlayerFromServerId(source)
	-- if playerIdx ~= -1 then
	-- print("received SendEmissive blink:"..tostring(blink))
	SetPedEmissiveIntensity(PlayerPedId(),blink)
	-- end
end)

RegisterNetEvent('PaintBall:GoToLeaveMatchMSG')
AddEventHandler('PaintBall:GoToLeaveMatchMSG', function(winner,maps)
	-- leaveTheGame(winner,maps)
	print("GoToLeaveMatchMSG")
	if currentSession then
	
		-- if IsEntityAttachedToEntity(currentSession.bballs,PlayerPedId()) then
			-- print("blue ball attach to me")
		-- end
		-- if IsEntityAttachedToEntity(currentSession.rballs,PlayerPedId()) then
			-- print("red ball attach to me")
		-- end
		TriggerServerEvent("PaintBallCTF:LeaveTheGame",currentSession.idx)
		isCurrentlyOutInGame = true
		Wait(100)
		if IhaveTheredOrbs then
			-- dropOrb(blue,redOrbsObject)
			print("red ball attach to me")
			dropOrb(currentTeam,redOrbsObject)
		end
		
		if IhaveTheblueOrbs then
			print("blue ball attach to me")
			dropOrb(currentTeam,blueOrbsObject)
		end
		Wait(2000)
		isCurrentlyOutInGame = false
		isCurrentlyInGame = false
		currentTeam = "none"
		isLockWaiting = false
	else
		print("no currentSession")
	end
end)

function takeOrb(myTeam,orbs)
	
	NetworkRequestControlOfEntity(orbs)
	
	Wait(50)
	local hascontrol = NetworkHasControlOfEntity(orbs)
	local cptTimeout = 0
	while not hascontrol and cptTimeout < 5 do
		cptTimeout = cptTimeout + 1
		NetworkRequestControlOfEntity(orbs)
		Wait(20)
	end
	print("takeOrb has control : "..tostring(hascontrol).." cptTimeout: "..tostring(cptTimeout))
	AttachEntityToEntity(orbs,PlayerPedId(),GetPedBoneIndex(PlayerPedId(),  24817), 0.150, -0.25, -0.00, 0.0, 90.0, 0.0, 0.0, false, false, false, false, 2, true)
	Wait(10)
	if IsEntityAttached(orbs) then
		print("Orbs correctly attached")
		TriggerServerEvent("PaintBallCTF:OrbTaken",currentSession.idx,myTeam)
		if myTeam == "blue" then
			IhaveTheredOrbs = true
		elseif myTeam == "red" then
			IhaveTheblueOrbs = true
		end
	else
		print("erreur dattache")
	end
end

function OrbStolen(myTeam,orbs,coords)
	
	NetworkRequestControlOfEntity(orbs)
	
	Wait(50)
	-- local hascontrol = NetworkHasControlOfEntity(orbs)
	-- local cptTimeout = 0
	-- while not hascontrol and cptTimeout < 5 do
		-- cptTimeout = cptTimeout + 1
		-- NetworkRequestControlOfEntity(orbs)
		-- Wait(10)
	-- end
	print("has control : "..tostring(hascontrol))
	DetachEntity(orbs,false,false)
	FreezeEntityPosition(orbs,true)
	Wait(150)
	if IsEntityAttached(orbs) then
		print("erreur de-attache")
	else
		SetEntityCoords(orbs,coords.x,coords.y,coords.z)
		TriggerServerEvent("PaintBallCTF:OrbStolen",currentSession.idx,myTeam)
		if currentTeam == "blue" then
			IhaveTheredOrbs = false
		elseif currentTeam == "red" then
			IhaveTheblueOrbs = false
		end
	end
end

function dropOrb(myTeam,orbs)
	
	NetworkRequestControlOfEntity(orbs)
	print(tostring(myTeam).." dropOrb : "..tostring( NetworkHasControlOfEntity(orbs)).." Does entity Exist: "..tostring( DoesEntityExist(orbs) ))
	Wait(50)
	-- local hascontrol = NetworkHasControlOfEntity(orbs)
	-- local cptTimeout = 0
	-- while not hascontrol and cptTimeout < 5 do
		-- cptTimeout = cptTimeout + 1
		-- NetworkRequestControlOfEntity(orbs)
		-- Wait(10)
	-- end
	print("has control : "..tostring(hascontrol))
	DetachEntity(orbs,false,false)
	FreezeEntityPosition(orbs,true)
	Wait(150)
	if IsEntityAttached(orbs) then
		print("erreur de-attache")
	else
		-- SetEntityCoords(orbs,coords.x,coords.y,coords.z)
		TriggerServerEvent("PaintBallCTF:OrbDropped",currentSession.idx,myTeam)
		if currentTeam == "blue" then
			IhaveTheredOrbs = false
		elseif currentTeam == "red" then
			IhaveTheblueOrbs = false
		end
	end
end

function resetOrb(myTeam,orbs,coords)
	
	NetworkRequestControlOfEntity(orbs)
	
	Wait(50)
	-- local hascontrol = NetworkHasControlOfEntity(orbs)
	-- local cptTimeout = 0
	-- while not hascontrol and cptTimeout < 5 do
		-- cptTimeout = cptTimeout + 1
		-- NetworkRequestControlOfEntity(orbs)
		-- Wait(10)
	-- end
	if not IsEntityAttached(orbs) then
		local hascontrol = NetworkHasControlOfEntity(orbs)
		local cptTimeout = 0
		while not hascontrol and cptTimeout < 5 do
			cptTimeout = cptTimeout + 1
			NetworkRequestControlOfEntity(orbs)
			Wait(20)
		end
		SetEntityCoords(orbs,coords.x,coords.y,coords.z)
	end
	-- TriggerServerEvent("PaintBallCTF:OrbReset",currentSession.idx,myTeam)

end

Citizen.CreateThread(function()
	while true do
		Wait(2)
		if isCurrentlyInGame then
			if currentSession.modes == "CTF" then
				if not isCurrentlyOutInGame then
					local pCoords = {}
					pCoords.x,pCoords.y,pCoords.z = table.unpack(GetEntityCoords(PlayerPedId()))
					
					local boCoords = {}
					boCoords.x,boCoords.y,boCoords.z = table.unpack(GetEntityCoords(blueOrbsObject))
					
					local roCoords = {}
					roCoords.x,roCoords.y,roCoords.z = table.unpack(GetEntityCoords(redOrbsObject))
					
					local currentMaps = currentSession.maps
					-- print("currentMaps : "..tostring(currentSession.maps))
					local redflagCoords = {}
					redflagCoords.x = Maps[currentMaps].redFlagCoords.x
					redflagCoords.y = Maps[currentMaps].redFlagCoords.y
					redflagCoords.z = Maps[currentMaps].redFlagCoords.z
					
					local blueflagCoords = {}
					blueflagCoords.x = Maps[currentMaps].blueFlagCoords.x
					blueflagCoords.y = Maps[currentMaps].blueFlagCoords.y
					blueflagCoords.z = Maps[currentMaps].blueFlagCoords.z
					-- blueflagCoords.x,blueflagCoords.y,blueflagCoords.z = table.unpack(Maps[currentMaps].blueFlagCoords)
					-- Maps[currentMaps].blueFlagCoords
					
					-- local myTeam = currentTeam
					SetEntityLights(blueOrbsObject,false)
					SetEntityLights(redOrbsObject,false)
					
					local boDist = #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(boCoords.x,boCoords.y,boCoords.z))
					local roDist = #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(roCoords.x,roCoords.y,roCoords.z))
					
					local boDistToSpawn = #(vector3(blueflagCoords.x, blueflagCoords.y, blueflagCoords.z) - vector3(boCoords.x,boCoords.y,boCoords.z))
					local roDistToSpawn = #(vector3(redflagCoords.x, redflagCoords.y, redflagCoords.z) - vector3(roCoords.x,roCoords.y,roCoords.z))
					
					local playDistToBlueSpawn = #(vector3(blueflagCoords.x, blueflagCoords.y, blueflagCoords.z) - vector3(pCoords.x,pCoords.y,pCoords.z))
					local playDistToRedSpawn = #(vector3(redflagCoords.x, redflagCoords.y, redflagCoords.z) - vector3(pCoords.x,pCoords.y,pCoords.z))
					-- print("Blue Orb Dist : "..tostring(boDist).." to spawn : "..tostring(boDistToSpawn).." Red Orb Dist : "..tostring(roDist).." to spawn : "..tostring(roDistToSpawn))
					
					if not DoesEntityExist(redOrbsObject) then
						print("Warning redBalls doesnt exist !")
						redOrbsObject = NetworkGetEntityFromNetworkId(currentSession.rballs)
					end
					
					if not DoesEntityExist(blueOrbsObject) then
						print("Warning redBalls doesnt exist !")
						blueOrbsObject = NetworkGetEntityFromNetworkId(currentSession.bballs)
					end
					
					if currentTeam == "blue" then
						if (boDist < 1.0 and boDistToSpawn > 1.5) and not blueOrbsIsTaken then
							print("blue return blue orb to base")
							Wait(200)
							resetOrb(myTeam,blueOrbsObject,blueflagCoords)
							Wait(200)
							-- dropOrb(currentTeam,redOrbsObject)
						end
						if roDist < 1.0 and not redOrbsIsTaken then
							print("blue take red orb")
							takeOrb(currentTeam,redOrbsObject)
							Wait(200)
						end
						if playDistToBlueSpawn < 0.7 and IhaveTheredOrbs then
							print("red orb to my blue base")
							OrbStolen(currentTeam,redOrbsObject,redflagCoords)
							Wait(200)
						end
					elseif currentTeam == "red" then
						if (roDist < 1.0 and roDistToSpawn > 1.5) and not redOrbsIsTaken then
							print("red return red orb to base")
							-- dropOrb(currentTeam,redOrbsObject)
							Wait(200)
							resetOrb(myTeam,redOrbsObject,redflagCoords)
							Wait(200)
						end
						if boDist < 1.0 and not blueOrbsIsTaken then
							print("red take blue orb")
							takeOrb(currentTeam,blueOrbsObject)
							Wait(200)
						end
						if playDistToRedSpawn < 0.7 and IhaveTheblueOrbs then
							print("red orb to my blue base")
							OrbStolen(currentTeam,blueOrbsObject,blueflagCoords)
							Wait(200)
						end
					end
				else
					Wait(200)
				end
			end
		else
			Wait(200)
		end
	end
end)

function teleport(coords)
	local xrand = math.random(-1000,1000) / 1000
	local yrand = math.random(-1000,1000) / 1000
	SetEntityCoords(PlayerPedId(),coords.x+xrand,coords.y+yrand,coords.z+1)
end

function startGame(color,idx,manche)
	
	blueOrbsIsTaken = false
	redOrbsIsTaken = false

	IhaveTheblueOrbs = false
	IhaveTheredOrbs = false
	startHealth = GetEntityHealth(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(),true)
	isCurrentlyOutInGame = false
	local activity = {}
	isLockWaiting = true
	
	local currentMaps = currentSession.maps
	print("startGame : "..tostring(currentMaps))
	local redCoords = Maps[currentMaps].redCoords
	local blueCoords = Maps[currentMaps].blueCoords
	
	if color == "red" then
		activity.x = redCoords.x
		activity.y = redCoords.y
		activity.z = redCoords.z
	elseif color == "blue" then
		activity.x = blueCoords.x
		activity.y = blueCoords.y
		activity.z = blueCoords.z
	end
	DoScreenFadeOut(1000)
	
	Citizen.Wait(2000)
	TriggerEvent("PaintBallCTF:SwitchTenu",color)
	
	-- switchTenu(color)
	-- SetEntityCoords(PlayerPedId(),activity.x,activity.y,activity.z+1)
	
	teleport(activity)
	GiveWeaponToPed(PlayerPedId(),GetHashKey(GunName),250,false,true)
	ClearPedBloodDamage(PlayerPedId())
	ResetPedVisibleDamage(PlayerPedId())
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	
	isCurrentlyInGame = true
	isCurrentlyOutInGame = false
	currentTeam = color
	currentPartie = idx
	
	Citizen.CreateThread(function()
		function Initialize(scaleform)
			local scaleform = RequestScaleformMovie(scaleform)

			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(0)
			end
			PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
			PushScaleformMovieFunctionParameterString(trad[lang]["CTFRound"])
			PushScaleformMovieFunctionParameterString(trad[lang]["CTFRoundDesc"])
			PopScaleformMovieFunctionVoid()
			return scaleform
		end
		scaleform = Initialize("mp_big_message_freemode")
		local temps = 0
		while temps < 500 do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
			temps = temps + 1
		end
		Citizen.Wait(500)
		-- FreezeEntityPosition(PlayerPedId(),false)
		isLockWaiting = false
		print("End Of bannière start")
	end)
end

function endTheGame(winner)

	local activity = {}
	
	-- print("endTheGame winner : "..tostring(winner).." my team : "..tostring(currentTeam))
	local message = "Dumb1"
	local message1 = "Dumb2"
	isCurrentlyOutInGame = false
	if winner == "tie" then
		message = trad[lang]["Tie"]
		message1 = trad[lang]["TieDesc"]
	else
		if winner == currentTeam then
			message = trad[lang]["Win"]
			message1 = trad[lang]["WinDesc"]
		else
			message = trad[lang]["Loose"]
			message1 = trad[lang]["LooseDesc"]
		end
	end
	
		-- local currentMaps = currentSession.maps
	-- print("startGame : "..tostring(currentMaps))
	-- local redCoords = Maps[currentMaps].redCoords
	-- local blueCoords = Maps[currentMaps].blueCoords
	
	local currentShop = currentSession.shop
	local outCoords = PaintBallShop[currentShop]["Out"]
	
	DoScreenFadeOut(1000)
	
	Citizen.Wait(2000)
	TriggerEvent("PaintBallCTF:SwitchTenu",color)
	teleport(outCoords)
	RemoveWeaponFromPed(PlayerPedId(),GetHashKey(GunName))
	ClearPedBloodDamage(PlayerPedId())
	ResetPedVisibleDamage(PlayerPedId())
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	
	isCurrentlyInGame = false
	isCurrentlyOutInGame = false
	currentTeam = "none"
	currentPartie = 0
	FreezeEntityPosition(PlayerPedId(),false)
	Citizen.CreateThread(function()
		function Initialize(scaleform)
			local scaleform = RequestScaleformMovie(scaleform)

			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(0)
			end
			PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
			PushScaleformMovieFunctionParameterString(message)
			PushScaleformMovieFunctionParameterString(message1)
			PopScaleformMovieFunctionVoid()
			return scaleform
		end
		scaleform = Initialize("mp_big_message_freemode")
		local temps = 0
		while temps < 500 do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
			temps = temps + 1
		end
		FreezeEntityPosition(PlayerPedId(),false)
		isLockWaiting = false
	end)
end

Citizen.CreateThread(function()
	while true do
		Wait(1)
		
		if isLockWaiting then
			DisablePlayerFiring(PlayerPedId(),true)
		else
			Wait(500)
		end
	end
end)

RegisterNetEvent('PaintBallCTF:GoToFinMatchMSG')
AddEventHandler('PaintBallCTF:GoToFinMatchMSG', function(winner,sessiondata)
	currentSession = sessiondata
	endTheGame(winner)
end)

RegisterNetEvent('PaintBallCTF:SendtheBalls')
AddEventHandler('PaintBallCTF:SendtheBalls', function(blueBallsID,redBallsID,sessiondata)
	RequestAnimDict("plasma_ball")
	local cptTimeoute=0
	while not HasAnimDictLoaded("plasma_ball") and cptTimeoute < 100 do 
	Citizen.Wait(0) 
	cptTimeoute = cptTimeoute + 1
	end
	print("Ball Anim Loaded")
	
	if NetworkDoesNetworkIdExist(blueBallsID) then
		print("blue ball exist")
		blueOrbsObject = NetworkGetEntityFromNetworkId(blueBallsID)
		SetEntityCollision(blueOrbsObject,false,true)
		print("1-blueOrbsObject : "..tostring(blueOrbsObject))
		PlayEntityAnim(blueOrbsObject,"plasma_ball2","plasma_ball2",8.0,true,true,false,0,0)
	else
		print("^1 ERROR BLUE BALL"..tostring(NetworkDoesNetworkIdExist(sessiondata.bballs)))
		blueOrbsObject = NetworkGetEntityFromNetworkId(NetworkDoesNetworkIdExist(sessiondata.bballs))
		SetEntityCollision(blueOrbsObject,false,true)
		print("2-blueOrbsObject : "..tostring(blueOrbsObject))
		PlayEntityAnim(blueOrbsObject,"plasma_ball2","plasma_ball2",8.0,true,true,false,0,0)
	end
	
	if NetworkDoesNetworkIdExist(redBallsID) then
		print("red ball exist")
		redOrbsObject = NetworkGetEntityFromNetworkId(redBallsID)
		SetEntityCollision(redOrbsObject,false,true)
		print("1-redOrbsObject : "..tostring(redOrbsObject))
		PlayEntityAnim(redOrbsObject,"plasma_ball","plasma_ball",8.0,true,true,false,0,0)
	else
		print("^1 ERROR RED BALL"..tostring(NetworkDoesNetworkIdExist(sessiondata.rballs)))
		redOrbsObject = NetworkGetEntityFromNetworkId(sessiondata.rballs)
		SetEntityCollision(redOrbsObject,false,true)
		print("2-redOrbsObject : "..tostring(redOrbsObject))
		PlayEntityAnim(redOrbsObject,"plasma_ball","plasma_ball",8.0,true,true,false,0,0)
	end
	
	RemoveAnimDict("plasma_ball")
end)

RegisterNetEvent('PaintBallCTF:GoForStartTheGame')
AddEventHandler('PaintBallCTF:GoForStartTheGame', function(color,idx,manche,sessiondata)
	currentSession = sessiondata
 	startGame(color,idx,manche)
end)





-----Scoreboard

Citizen.CreateThread(function()

  local cIcon = CreateRuntimeTxd("scoreboardCTF")
  CreateRuntimeTextureFromImage(cIcon, "scoreboardCTF", "img/Scoreboard_Capture_the_Orb.png")
  
  local cIcon = CreateRuntimeTxd("blueOrbCTF")
  CreateRuntimeTextureFromImage(cIcon, "blueOrbCTF", "img/Blue_Orb.png")
  
  local cIcon = CreateRuntimeTxd("redOrbCTF")
  CreateRuntimeTextureFromImage(cIcon, "redOrbCTF", "img/Red_Orb.png")
  
  end)
  
function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	SetTextJustification(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x, y)
end

  
local indexDecalage = 0.1225
local indexDecalageOrb = 0.165
local teamAScore = 0
local teamBScore = 0
-- local cptBlink = 0
Citizen.CreateThread(function()
	while true do
		Wait(2)
	    
		if isCurrentlyInGame then

			if redOrbsIsTaken then
				DrawSprite("redOrbCTF","redOrbCTF",0.4990-indexDecalageOrb,0.04,(0.045),(0.045*(16/9)),0.0,255,255,255,255)
			end
			
			if blueOrbsIsTaken then
				DrawSprite("blueOrbCTF","blueOrbCTF",0.4990+indexDecalageOrb,0.04,(0.045),(0.045*(16/9)),0.0,255,255,255,255)
			end

			DrawSprite("scoreboardCTF","scoreboardCTF",0.50,0.029,(0.575)/2,(0.064*(16/9))/2,0.0,255,255,255,255)
			teamAScore = 0
			teamBScore = 0
			
			for k,v in pairs(currentSession.ScoreA) do
				teamAScore = teamAScore + v
			end
			
			for k,v in pairs(currentSession.ScoreB) do
				teamBScore = teamBScore + v
			end

			DrawAdvancedText(0.5 - indexDecalage, 0.0, 0.196, 0.00, 0.8, tostring(teamAScore), 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.5 + indexDecalage, 0.0, 0.196, 0.00, 0.8, tostring(teamBScore), 255, 255, 255, 255, 6, 0)
		else
			Wait(2000)
		end
	end

end)










RegisterCommand("anim", function(source, args, fullCommand)
	playAnim("missarmenian2","corpse_search_exit_ped",-1)
end, false)

RegisterCommand("stopanim", function(source, args, fullCommand)
	ClearPedTasks(PlayerPedId())
end, false)


local orbTest = 0
RegisterCommand("orbback", function(source, args, fullCommand)
	-- ClearPedTasks(PlayerPedId())
		tempmodel = GetHashKey("plasma_ball")
		RequestModel(tempmodel)
		timeout = 0
		while not HasModelLoaded(tempmodel) and timeout < 100 do
			RequestModel(tempmodel)
			Citizen.Wait(0)
			timeout = timeout + 1
		end
		print("model loaded")
		if timeout > 99 then print("timeout") else print("not timeout") end

		orbTest = CreateObject(tempmodel,GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,2.0,0.3),false,false,true)
		
		FreezeEntityPosition(orbTest,true)
		
		AttachEntityToEntity(orbTest,PlayerPedId(),GetPedBoneIndex(PlayerPedId(),  24817), 0.150, -0.25, -0.00, 0.0, 90.0, 0.0, 0.0, false, false, false, false, 2, true)
end, false)

RegisterCommand("orbdel", function(source, args, fullCommand)
	-- ClearPedTasks(PlayerPedId())
		DeleteEntity(orbTest)
end, false)

RegisterCommand("balls", function(source, args, fullCommand)
	
	
	local pCoords = {}
	pCoords.x,pCoords.y,pCoords.z = table.unpack(GetEntityCoords(PlayerPedId()))
	
	local boCoords = {}
	boCoords.x,boCoords.y,boCoords.z = table.unpack(GetEntityCoords(blueOrbsObject))
	
	local roCoords = {}
	roCoords.x,roCoords.y,roCoords.z = table.unpack(GetEntityCoords(redOrbsObject))
	
	local boDist = #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(boCoords.x,boCoords.y,boCoords.z))
	local roDist = #(vector3(pCoords.x, pCoords.y, pCoords.z) - vector3(roCoords.x,roCoords.y,roCoords.z))
	
	
					
	print("blue balls : "..tostring(blueOrbsObject).." exist: "..tostring(DoesEntityExist(blueOrbsObject)).." dist: "..tostring(boDist).." coords : "..tostring(vector3(boCoords.x,boCoords.y,boCoords.z)))
	print("red balls : "..tostring(redOrbsObject).." exist: "..tostring(DoesEntityExist(redOrbsObject)).." dist: "..tostring(roDist).." coords : "..tostring(vector3(roCoords.x,roCoords.y,roCoords.z)))
end)