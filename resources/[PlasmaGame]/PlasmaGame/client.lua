



--Dont Touch This
local playerTenu = {
[3] = {model = 0, color = 2},
[4] = {model = 0, color = 2},
[6] = {model = 0, color = 3},
						   
[7] = {model = 0, color = 2},
[8] = {model = 0, color = 2},
[11] = {model = 0, color = 2}
}

local playerMask = {model = 0, color = 2}



-- Dont touch This

local isCostumed = false

local isCurrentlyInGame = false

local isCurrentlyOutInGame = false

local currentTeam = "none"

local currentPartie = 0

local isLockWaiting = false

local currentShop = "none"

local currentSession = {}

local startHealth = 200.0

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function teleport(coords)
	local xrand = math.random(-1000,1000) / 1000
	local yrand = math.random(-1000,1000) / 1000
	SetEntityCoords(PlayerPedId(),coords.x+xrand,coords.y+yrand,coords.z+1)
end

incircle = false
print(PaintBallShop)
Citizen.CreateThread(function()

	for k,v in pairs(PaintBallShop) do
		-- v["blip"]
		-- print("k : "..tostring(k).." v : "..tostring(v["Blip"].x))
		blip=AddBlipForCoord(v["Blip"].x,v["Blip"].y,v["Blip"].z)

		SetBlipSprite(blip, v["Blip"].sprite)
		SetBlipScale(blip, v["Blip"].scale)
		SetBlipColour(blip, v["Blip"].colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(k))
		EndTextCommandSetBlipName(blip)
	
	end
end)

local incircle = {}
Citizen.CreateThread(function()
	local sleep = 2000
	local sleepTrigger1 = false
	while true do
		Wait(sleep)
		local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(), true))
		sleepTrigger1 = false
		for k,v in pairs(PaintBallShop) do
			for k1,v1 in pairs(v["Create"]) do
				local pdist = #(vector3(px, py, pz) - vector3(v1.x,v1.y,v1.z))
				if( pdist < 15.0 )then
					sleepTrigger1 = true
					DrawMarker(3, v1.x, v1.y, v1.z , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 255, 0, 0,165, 1, 0, 0,0)
					if( pdist < 1.0 )then
						if (incircle[k1] == false) then
							DisplayHelpText(trad[lang]["CreateLob"])
							incircle[k1] = true
							
					   end
					    if IsControlJustReleased(1, 51) then
							EnableGui(true,k)
						end
					elseif ( pdist > 3.0 ) then
						incircle[k1] = false
					end
				else
				
				end
			end
		end
		if sleepTrigger1 then
			sleep = 2
		else
			sleep = 2000
		end
	end
end)

local incircle2 = {}
Citizen.CreateThread(function()
	local sleep = 2000
	local sleepTrigger2 = false
	while true do
		Wait(sleep)
		local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(), true))
		sleepTrigger2 = false
		for k,v in pairs(PaintBallShop) do
			for k1,v1 in pairs(v["Join"]) do
				local pdist = #(vector3(px, py, pz) - vector3(v1.x,v1.y,v1.z))
				if( pdist < 15.0 )then
					sleepTrigger2 = true
					DrawMarker(3, v1.x, v1.y, v1.z , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 255, 0,165, 1, 0, 0,0)
					if( pdist < 1.0 )then
						if (incircle2[k1] == false) then
							DisplayHelpText(trad[lang]["JoinLob"])
							incircle2[k1] = true
							
					   end
					   if IsControlJustReleased(1, 51) then
							-- EnableGui(true)
							TriggerServerEvent("PaintBall:GetAllSessions",k)
					   end
					elseif ( pdist > 3.0 ) then
						incircle2[k1] = false
					end
				else
				
				end
			end
		end
		if sleepTrigger2 then
			sleep = 2
		else
			sleep = 2000
		end
	end
end)

local incircle3 = {}
Citizen.CreateThread(function()
	local sleep = 2000
	local sleepTrigger3 = false
	while true do
		Wait(sleep)
		local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(), true))
		sleepTrigger3 = false
		for k,v in pairs(Maps) do
			if v["mapBlueOutCoords"] ~= nil then
				for k1,v1 in pairs(v["mapRedOutCoords"]) do
					local pdist = #(vector3(px, py, pz) - vector3(v1.x,v1.y,v1.z))
					if( pdist < 15.0 )then
						sleepTrigger3 = true
						DrawMarker(3, v1.x, v1.y, v1.z , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 255, 0,165, 1, 0, 0,0)
						if( pdist < 1.5 )then
							if (incircle3[k1] == false) then
								DisplayHelpText(trad[lang]["LeaveGame"])
								incircle3[k1] = true
						   end
						   -- print("incircle3")
							if IsControlJustReleased(1, 51) then
								print("LeaveTheGame blue")
								TriggerServerEvent("PaintBall:LeaveTheGame",currentPartie,currentShop)
							end
						elseif ( pdist > 3.0 ) then
							incircle3[k1] = false
						end
					else
					
					end
				end
			end
		end
		if sleepTrigger3 then
			sleep = 2
		else
			sleep = 2000
		end
	end
end)

local incircle4 = {}
Citizen.CreateThread(function()
	local sleep = 2000
	local sleepTrigger4 = false
	while true do
		Wait(sleep)
		local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(), true))
		sleepTrigger4 = false
		for k,v in pairs(Maps) do
			if v["mapBlueOutCoords"] ~= nil then
				for k1,v1 in pairs(v["mapBlueOutCoords"]) do
					local pdist = #(vector3(px, py, pz) - vector3(v1.x,v1.y,v1.z))
					if( pdist < 15.0 )then
						sleepTrigger4 = true
						DrawMarker(3, v1.x, v1.y, v1.z , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 255, 0,165, 1, 0, 0,0)
						if( pdist < 1.5 )then
							if (incircle4[k1] == false) then
								DisplayHelpText(trad[lang]["LeaveGame"])
								incircle4[k1] = true
								
						   end
						   if IsControlJustReleased(1, 51) then
								print("LeaveTheGame red")
								TriggerServerEvent("PaintBall:LeaveTheGame",currentPartie,currentShop)
						   end
						elseif ( pdist > 3.0 ) then
							incircle4[k1] = false
						end
					else
					
					end
				end
			end
		end
		if sleepTrigger4 then
			sleep = 2
		else
			sleep = 2000
		end
	end
end)
--print("trad : "..tostring())

--Citizen.CreateThread(function()
--	local sleep = 2000
--	local triggeredChangeSleep = false
--    while true do
--        Citizen.Wait(sleep)
--		-- print("test")
--        local pos = GetEntityCoords(PlayerPedId(), true)
--		triggeredChangeSleep = false
--        for k,v in ipairs(PaintBallShop) do
--            if(#(vector3(pos.x, pos.y, pos.z) - vector3(v.x, v.y, v.z)) < 15.0)then
--				triggeredChangeSleep = true
--                DrawMarker(3, v.x, v.y, v.z , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,165, 0, 0, 0,0)
--                if(#(vector3(pos.x, pos.y, pos.z) - vector3(v.x, v.y, v.z)) < 1.0)then
--                    if (incircle == false) then
--						if v.typeM == "create" then
--							
--							DisplayHelpText(trad[lang]["CreateLob"])
--						else
--							DisplayHelpText(trad[lang]["JoinLob"])
--						end
--                    end
--                    incircle = true
--                    if IsControlJustReleased(1, 51) then
--						if v.typeM == "create" then
--							EnableGui(true)
--						else
--							TriggerServerEvent("PaintBall:GetAllSessions")
--						end
--                    end
--                elseif(#(vector3(pos.x, pos.y, pos.z) - vector3(v.x, v.y, v.z)) > 3.0)then
--                    incircle = false
--                end
--            end
--		end
--		if triggeredChangeSleep then
--			sleep = 1
--		else
--			sleep = 3000
--		end
--    end
--end)
--
--local incircleRed = false
--Citizen.CreateThread(function()
--	-- local sleep = 2000
--    while true do
--        Citizen.Wait(1)
--        local pos = GetEntityCoords(PlayerPedId(), true)
--        -- for k,v in ipairs(PaintBallShop) do
--		
--		if(#(vector3(pos.x, pos.y, pos.z) - vector3(mapRedOutCoords.x, mapRedOutCoords.y, mapRedOutCoords.z)) < 5.0)then
--			DrawMarker(3, mapRedOutCoords.x, mapRedOutCoords.y, mapRedOutCoords.z , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,165, 0, 0, 0,0)
--			if(#(vector3(pos.x, pos.y, pos.z) - vector3(mapRedOutCoords.x, mapRedOutCoords.y, mapRedOutCoords.z)) < 1.0)then
--				if (incircleRed == false) then
--					-- if v.typeM == "create" then
--						DisplayHelpText(trad[lang]["LeaveGame"])
--					-- else
--						-- DisplayHelpText("Press sur ~INPUT_CONTEXT~ to join a Lobby.")
--					-- end
--				end
--				incircleRed = true
--				if IsControlJustReleased(1, 51) then
--					TriggerServerEvent("PaintBall:LeaveTheGame",currentPartie)
--				end
--			elseif(#(vector3(pos.x, pos.y, pos.z) - vector3(mapRedOutCoords.x, mapRedOutCoords.y, mapRedOutCoords.z)) > 3.0)then
--				incircleRed = false
--			end
--		else
--			Citizen.Wait(2000)
--		end
--		-- end
--    end
--end)
--
--local incircleBlue = false
--Citizen.CreateThread(function()
--    while true do
--        Citizen.Wait(1)
--        local pos = GetEntityCoords(PlayerPedId(), true)
--        -- for k,v in ipairs(PaintBallShop) do
--		
--		if(#(vector3(pos.x, pos.y, pos.z) - vector3(mapBlueOutCoords.x, mapBlueOutCoords.y, mapBlueOutCoords.z)) < 5.0)then
--			DrawMarker(3, mapBlueOutCoords.x, mapBlueOutCoords.y, mapBlueOutCoords.z , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,165, 0, 0, 0,0)
--			if(#(vector3(pos.x, pos.y, pos.z) - vector3(mapBlueOutCoords.x, mapBlueOutCoords.y, mapBlueOutCoords.z)) < 1.0)then
--				if (incircleRed == false) then
--					-- if v.typeM == "create" then
--						DisplayHelpText(trad[lang]["LeaveGame"])
--						
--					-- else
--						-- DisplayHelpText("Press sur ~INPUT_CONTEXT~ to join a Lobby.")
--					-- end
--				end
--				incircleRed = true
--				if IsControlJustReleased(1, 51) then
--					TriggerServerEvent("PaintBall:LeaveTheGame",currentPartie)
--				end
--			elseif(#(vector3(pos.x, pos.y, pos.z) - vector3(mapBlueOutCoords.x, mapBlueOutCoords.y, mapBlueOutCoords.z)) > 3.0)then
--				incircleRed = false
--			end
--		else
--			Citizen.Wait(2000)
--		end
--		-- end
--    end
--end)


function EnableGui(state,shop)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = "enableui",
		enable = state,
		shop = shop
	})
end




RegisterNUICallback('escape', function(data, cb)
	EnableGui(false)
end)

RegisterNUICallback('validate', function(data, cb)
	-- if hasIdentity then
	local reason = ""
	local gamemodeAvailable = false
	local gamemodeAvailable2 = false
	local mapsAvailable = false
	EnableGui(false)
	print("validate shop : "..tostring(data["curshop"]))
	for theData, value in pairs(data) do
		if theData == "sessionname" then
			if value == "" or value == nil then
				reason = trad[lang]["InvalidSession"]
				break
			end
		elseif theData == "creatorname" then
			if value == "" or value == nil then
				reason = trad[lang]["InvalidPseudo"]
				break
			end
		elseif theData == "gamemode" then
			for k,v in pairs(PaintBallShop[data["curshop"]]["ModAvailable"]) do
				print("Mod : "..tostring(v))
				if v == value then
					gamemodeAvailable = true
					print("Mod available")
					break
				end
			end
			if Maps[data["maps"]][value] then
				gamemodeAvailable2 = true
			end
		elseif theData == "maps" then
			for k,v in pairs(PaintBallShop[data["curshop"]]["MapAvailable"]) do
				print("Maps : "..tostring(v))
				if v == value then
					mapsAvailable = true
					print("Map available")
					break
				end
			end
			
		elseif theData == "curshop" then
			
		end
	end
	
	if not gamemodeAvailable then
		reason = trad[lang]["modeUnavailable"]
	end
	if not gamemodeAvailable2 then
		reason = trad[lang]["modeUnavailable2"]
	end
	if not mapsAvailable then
		reason = trad[lang]["mapUnavailable"]
	end
	if data["gamemode"] == "CTF" and data["nbmanche"] == "1" then
		reason = trad[lang]["CTFRoundCompatibility"]
	end
	if reason == "" then
		TriggerServerEvent("PaintBall:NewSession",data)
		-- notification(trad[lang]["LobbyCreated"],"success")
		
	else
		notification(reason,"error")
		-- TriggerEvent("pNotify:SendNotification", {text = reason, type = "error", timeout = 3000, layout = "bottomLeft"})
	end
end)

-- local items = {}
local allSession = {}


function JoinBlue(idx)
	TriggerServerEvent("PaintBall:JoinBlue",idx)
end

function JoinRed(idx)
	TriggerServerEvent("PaintBall:JoinRed",idx)
end

function StartTheGame(idx)
	TriggerServerEvent("PaintBall:StartTheGame",idx)
end

RegisterNetEvent("PaintBall:SendAllSessions")
AddEventHandler('PaintBall:SendAllSessions', function(data)

	allSession = {}
	allSession = data
	
	openMenuMain(allSession)
end)

RegisterNetEvent("PaintBall:SendEmissiveSync")
AddEventHandler('PaintBall:SendEmissiveSync', function(curPlayer,blink)
	local playerIdx = GetPlayerFromServerId(curPlayer)
	-- print("received SendEmissiveSync curPlayer:"..tostring(curPlayer).." playerIdx:"..tostring(playerIdx).." blink:"..tostring(blink))
	if playerIdx ~= -1 then
	SetPedEmissiveIntensity(GetPlayerPed(playerIdx),blink)
	end
end)

RegisterNetEvent("PaintBall:SendEmissive")
AddEventHandler('PaintBall:SendEmissive', function(blink)
	-- local playerIdx = GetPlayerFromServerId(source)
	-- if playerIdx ~= -1 then
	-- print("received SendEmissive blink:"..tostring(blink))
	SetPedEmissiveIntensity(PlayerPedId(),blink)
	-- end
end)

RegisterNetEvent("PaintBall:Notif")
AddEventHandler('PaintBall:Notif', function(data,typeOfNotif)
	notification(data,typeOfNotif)
end)

_menuPool = MenuPool.New()
mainMenu = UIMenu.New("Plasma Game", trad[lang]["Lobby"])
_menuPool:Add(mainMenu)
-- _menuPool:MouseControlsEnabled (false);
-- _menuPool:MouseEdgeEnabled (false);
-- _menuPool:ControlDisablingEnabled(false);

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		 if (_menuPool:IsAnyMenuOpen()) then
            _menuPool:ProcessMenus()
		else 
        Citizen.Wait(50)
        end

    end
end)


local newitem = {}
local blueitem = {}
local reditem = {}
local launchitem = {}

function openMenuMain(data)
	mainMenu = UIMenu.New("Plasma Game", trad[lang]["Lobby"])
	_menuPool:Add(mainMenu)
	
	-- _menuPool:MouseControlsEnabled (false)
	-- _menuPool:MouseEdgeEnabled (false)
	-- _menuPool:ControlDisablingEnabled(false)
	
	for k,v in pairs(allSession) do
		if v.CurStat == "WaitingPeople" then
			
			newitem[k] = _menuPool:AddSubMenu(mainMenu, trad[lang]["JoinLobby1"]..tostring(v.creator)..trad[lang]["JoinLobby2"].." ("..tostring(v.modes)..")")
			
			EquipeBleu = v.EquipA
			EquipeRouge = v.EquipB
			
			blueitem[k] = UIMenuItem.New(trad[lang]["JoinBlue"].. tostring(#EquipeBleu) .."/"..tostring(v.nbpersequip), "")
			newitem[k]:AddItem(blueitem[k])
			
			reditem[k] = UIMenuItem.New(trad[lang]["JoinRed"].. tostring(#EquipeRouge) .."/"..tostring(v.nbpersequip), "")
			newitem[k]:AddItem(reditem[k])
			
			if GetPlayerFromServerId(k) ~= -1 then
				if GetPlayerPed(GetPlayerFromServerId(k)) == PlayerPedId() then
					launchitem[k] = UIMenuItem.New(trad[lang]["StartGame"], trad[lang]["StartGameDesc"])
					newitem[k]:AddItem(launchitem[k])
					
				end
			end
			
			
			newitem[k].OnItemSelect = function(sender, item, index)
			
				newitem[k]:Visible(false)
				
				for k2,v2 in pairs(blueitem) do
					if v2 == item then
						JoinBlue(k)
					end
				end
				
				for k2,v2 in pairs(reditem) do
					if v2 == item then
						JoinRed(k)
					end
				end
				
				for k2,v2 in pairs(launchitem) do
					if v2 == item then
						StartTheGame(k)
					end
				end
			end
			
			
			
		end
	end

	mainMenu:Visible(true)
end


function switchTenu(color)
	local sex 
	local ped = PlayerPedId()
	if IsPedModel(ped,GetHashKey('mp_m_freemode_01')) then
		sex = "men"
	elseif IsPedModel(ped,GetHashKey('mp_f_freemode_01')) then
		sex = "women"
	end
	
	if not isCostumed then -- Si n' pas sa tenue
		playerTenu[11].model = GetPedDrawableVariation(ped,11)
		playerTenu[11].color = GetPedTextureVariation(ped,11)
		
		playerTenu[4].model = GetPedDrawableVariation(ped,4)
		playerTenu[4].color = GetPedTextureVariation(ped,4)
		
		playerTenu[6].model = GetPedDrawableVariation(ped,6)
		playerTenu[6].color = GetPedTextureVariation(ped,6)
		
		playerTenu[7].model = GetPedDrawableVariation(ped,7)
		playerTenu[7].color = GetPedTextureVariation(ped,7)
		
		playerTenu[8].model = GetPedDrawableVariation(ped,8)
		playerTenu[8].color = GetPedTextureVariation(ped,8)
		
		playerTenu[3].model = GetPedDrawableVariation(ped,3)
		playerTenu[3].color = GetPedTextureVariation(ped,3)
		if sex == "men" then
			if color == "blue" then
				isCostumed = true
				for k,v in pairs(TenuHomme) do
					SetPedComponentVariation(ped,k,v.model,v.colorA,2)
				end
				if useCustomMask then
					local randMath = math.random(1,2)
					playerMask.model = GetPedDrawableVariation(PlayerPedId(), 1)
					playerMask.color = GetPedTextureVariation(PlayerPedId(), 1)
					print("Mask : "..tostring(playerMask.model).." "..tostring(playerMask.color))
					SetPedComponentVariation(PlayerPedId(), 1, MaskHomme[randMath].model, MaskHomme[randMath].colorA, 0)
				end
			elseif color == "red" then
				isCostumed = true
				for k,v in pairs(TenuHomme) do
					SetPedComponentVariation(ped,k,v.model,v.colorB,2)
				end
				if useCustomMask then
					local randMath = math.random(1,2)
					playerMask.model = GetPedDrawableVariation(PlayerPedId(), 1)
					playerMask.color = GetPedTextureVariation(PlayerPedId(), 1)
					print("Mask : "..tostring(playerMask.model).." "..tostring(playerMask.color))
					SetPedComponentVariation(PlayerPedId(), 1, MaskHomme[randMath].model, MaskHomme[randMath].colorB, 0)
				end
			else
				-- print("error color must be specified")
			end
		else
			if color == "blue" then
				isCostumed = true
				for k,v in pairs(TenuFemme) do
					SetPedComponentVariation(ped,k,v.model,v.colorA,2)
				end
				if useCustomMask then
					local randMath = math.random(1,2)
					playerMask.model = GetPedDrawableVariation(PlayerPedId(), 1)
					playerMask.color = GetPedTextureVariation(PlayerPedId(), 1)
					print("Mask : "..tostring(playerMask.model).." "..tostring(playerMask.color))
					SetPedComponentVariation(PlayerPedId(), 1, MaskFemme[randMath].model, MaskFemme[randMath].colorA, 0)
					-- MaskHomme()
				end
			elseif color == "red" then
				isCostumed = true
				for k,v in pairs(TenuFemme) do
					SetPedComponentVariation(ped,k,v.model,v.colorB,2)
				end
				if useCustomMask then
					local randMath = math.random(1,2)
					playerMask.model = GetPedDrawableVariation(PlayerPedId(), 1)
					playerMask.color = GetPedTextureVariation(PlayerPedId(), 1)
					print("Mask : "..tostring(playerMask.model).." "..tostring(playerMask.color))
					SetPedComponentVariation(PlayerPedId(), 1, MaskFemme[randMath].model, MaskFemme[randMath].colorB, 0)
					-- MaskHomme()
				end
			else
				-- print("error color must be specified")
			end
		end
	else
		isCostumed = false
		for k,v in pairs(playerTenu) do
			SetPedComponentVariation(ped,k,v.model,v.color,2)
		end
		if useCustomMask then
			SetPedComponentVariation(PlayerPedId(), 1, playerMask.model, playerMask.color, 0)
		end
	end
end

RegisterNetEvent("PaintBall:GoForUnFreeze")
AddEventHandler('PaintBall:GoForUnFreeze', function(data)
	print("Unfreeze")
	FreezeEntityPosition(PlayerPedId(),false)
	isLockWaiting = false
end)



 
function startGame(color,idx,manche)
	exports["_anticheese"]:Disable()
	FreezeEntityPosition(PlayerPedId(),true)
	isCurrentlyOutInGame = false
	local activity = {}
	isLockWaiting = true
	startHealth = GetEntityHealth(PlayerPedId())
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
	switchTenu(color)
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
			PushScaleformMovieFunctionParameterString(trad[lang]["Round"]..tostring(manche))
			PushScaleformMovieFunctionParameterString(trad[lang]["RoundDesc"])
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
		-- isLockWaiting = false
		print("End Of bannière start")
	end)
end



function startNextGame(color,idx,manche)
	isCurrentlyOutInGame = false
	isLockWaiting = true
	
	local currentMaps = currentSession.maps
	print("startGame : "..tostring(currentMaps))
	local redCoords = Maps[currentMaps].redCoords
	local blueCoords = Maps[currentMaps].blueCoords
	
	
	local activity = {}
	FreezeEntityPosition(PlayerPedId(),true)
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
			PushScaleformMovieFunctionParameterString(trad[lang]["Round"]..tostring(manche))
			PushScaleformMovieFunctionParameterString(trad[lang]["RoundDesc"])
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
		-- isLockWaiting = false
		print("End Of bannière next game")
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
	dontLeaveSpectate = false
	EndFreeCam()
					
	local currentShop = currentSession.shop
	local outCoords = PaintBallShop[currentShop]["Out"]
	
	DoScreenFadeOut(1000)
	
	Citizen.Wait(2000)
	switchTenu(color)
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
	-- dontLeaveSpectate = false
	dontLeaveSpectate = false
	EndFreeCam()
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
	dontLeaveSpectate = false
	EndFreeCam()

	exports["_anticheese"]:Enable()
	
end
-- TriggerClientEvent("PaintBall:GoForStartTheGame",v)

function leaveTheGame(winner,maps)

	local activity = {}
	
	-- print("endTheGame winner : "..tostring(winner).." my team : "..tostring(currentTeam))
	local message = trad[lang]["Leave"]
	local message1 = trad[lang]["LeaveDesc"]
	isCurrentlyOutInGame = false

	DoScreenFadeOut(1000)
	
	Citizen.Wait(2000)
	if isCostumed then
		switchTenu(color)
	end
	print("maps: "..tostring(maps))
	if maps ~= nil and maps ~= "none" then
		teleport(PaintBallShop[maps]["Out"])
	else
		teleport(defaultOutCoords)
	end
	
	
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

local didDisableHotkeys = false
Citizen.CreateThread(function()
	while true do
		Wait(1)
		if isCurrentlyInGame then
			DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
			DisableControlAction(1, 263, true)
			DisableControlAction(1, 264, true)
			DisableControlAction(1, 244, true) -- M
			if not didDisableHotkeys then
				didDisableHotkeys = true
				TriggerEvent("hotkeys:enable", false)
			end
		else
			if didDisableHotkeys then
				didDisableHotkeys = false
				TriggerEvent("hotkeys:enable", true)
			end
			Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if isCurrentlyInGame then
			if currentSession.modes ~= "CTF" then
				if GetEntityHealth(PlayerPedId()) ~= startHealth then
					SetEntityHealth(PlayerPedId(),startHealth)
				end
				if HasPedBeenDamagedByWeapon(PlayerPedId(),GetHashKey(GunName),0) then
						print("HasPedBeenDamagedByWeapon")
					if not isCurrentlyOutInGame then
						print("is not isCurrentlyOutInGame")
						-- TriggerServerEvent("PaintBall:GetSourceOfDamage")--NOT WORKING or at least dont work everytime? FiveM Issue
						isCurrentlyOutInGame = true
						SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+GunDamage)
						TriggerServerEvent("PaintBall:addPoint",currentTeam,currentPartie)
						TriggerServerEvent("PaintBall:EmissiveSync")
						isLockWaiting = true
						Wait(3000)
						print("hit")
						FreezeEntityPosition(PlayerPedId(),true)
						
						-- Wait(3000)
						
						local currentMaps = currentSession.maps
						print("startGame : "..tostring(currentMaps))
						local redCoords = Maps[currentMaps].redCoords
						local blueCoords = Maps[currentMaps].blueCoords
						
						if currentTeam == "red" then
							isLockWaiting = true
							activity = {}
							activity.x = redCoords.x
							activity.y = redCoords.y
							activity.z = redCoords.z
							
							teleport(activity)
							-- SetEntityCoords(PlayerPedId(),activity.x,activity.y,activity.z+1)
						elseif currentTeam == "blue" then
							isLockWaiting = true
							activity = {}
							
							activity.x = blueCoords.x
							activity.y = blueCoords.y
							activity.z = blueCoords.z
							
							teleport(activity)
							-- SetEntityCoords(PlayerPedId(),activity.x,activity.y,activity.z+1)
						end
						ClearEntityLastDamageEntity(PlayerPedId())
						print("Plasma Game ClearEntityLastDamageEntity")
					end
				end
			end
		else
			Wait(200)
		end
	end
end)



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



RegisterNetEvent('PaintBall:GoToNextMancheMSG')
AddEventHandler('PaintBall:GoToNextMancheMSG', function(winner)
	-- print("GoToNextMancheMSG winner :"..tostring(winner).. "currentTeam : "..tostring(currentTeam)) 
	FreezeEntityPosition(PlayerPedId(),true)
	isLockWaiting = true
	local message = "Dumb Message 1"
	local message2 = "Dumb Message 2"
	
	if winner == "tie" then
		message = trad[lang]["RoundTie"]
		message2 = trad[lang]["RoundTieDesc"]
	else
		if winner == currentTeam then
			message = trad[lang]["RoundWin"]
			message2 = trad[lang]["RoundWinDesc"]
		else
			message = trad[lang]["RoundLoose"]
			message2 = trad[lang]["RoundLooseDesc"]
		end
	end
	
	
	
	Citizen.CreateThread(function()
		function Initialize(scaleform)
			local scaleform = RequestScaleformMovie(scaleform)

			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(0)
			end
			PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
			PushScaleformMovieFunctionParameterString(message)
			PushScaleformMovieFunctionParameterString(message2)
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
		-- FreezeEntityPosition(PlayerPedId(),false)
	end)
end)

RegisterNetEvent('PaintBall:GoForTheNextGame')
AddEventHandler('PaintBall:GoForTheNextGame', function(color,idx,manche,sessiondata)
	currentSession = sessiondata
	startNextGame(color,idx,manche)
end)


RegisterNetEvent('PaintBall:GoForStartTheGame')
AddEventHandler('PaintBall:GoForStartTheGame', function(color,idx,manche,sessiondata)
	currentSession = sessiondata
 	startGame(color,idx,manche)
end)

RegisterNetEvent('PaintBall:GoToFinMatchMSG')
AddEventHandler('PaintBall:GoToFinMatchMSG', function(winner,sessiondata)
	currentSession = sessiondata
	endTheGame(winner)
end)

RegisterNetEvent('PaintBall:GoToLeaveMatchMSG')
AddEventHandler('PaintBall:GoToLeaveMatchMSG', function(winner,maps)
	leaveTheGame(winner,maps)
end)

--[[
RegisterCommand("unfreeze", function(source, args, fullCommand)
	FreezeEntityPosition(PlayerPedId(),false)
	isLockWaiting = true
end, false)

RegisterCommand('giveplasma', function(source, args, fullCommand)
	GiveWeaponToPed(PlayerPedId(),GetHashKey(GunName),250,false,true)
end, false)
--]]


-- RegisterCommand("switchTenu", function(source, args, fullCommand)
	-- print("Switch tenue args : "..tostring(args).." args[1] "..tostring(args[1]))
	-- switchTenu(args[1])
-- end, false)


-- RegisterNetEvent('PaintBall:Test')
-- AddEventHandler('PaintBall:Test', function(color,idx,manche)
	-- print("hfdkjigsbgskgsbk")
-- end)




--------------CTF WRAPPER------------
RegisterNetEvent("PaintBallCTF:SwitchTenu")
AddEventHandler('PaintBallCTF:SwitchTenu', function(color)
	switchTenu(color)
end)





-----Scoreboard

Citizen.CreateThread(function()

  local cIcon = CreateRuntimeTxd("scoreboard")
  CreateRuntimeTextureFromImage(cIcon, "scoreboard", "img/Scoreboard_Death_Match.png")
  
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
local teamAScore = 0
local teamBScore = 0
Citizen.CreateThread(function()
	while true do
		Wait(2)
	
		if isCurrentlyInGame then
			DrawSprite("scoreboard","scoreboard",0.50,0.029,(0.575)/2,(0.064*(16/9))/2,0.0,255,255,255,255)
			teamAScore = 0
			teamBScore = 0
			local nbA = #currentSession.EquipA
			local nbB = #currentSession.EquipB
			
			for i=1, currentSession.nbmanche do
				-- print("i : "..tostring(i).." manche: "..tostring(currentSession.manche))
				if i < currentSession.manche then
					print("Manche:"..tostring(i).." Score A : "..tostring(currentSession.ScoreA[i]).." ScoreB: "..tostring(currentSession.ScoreB[i]))
					
					
					
					if currentSession.ScoreA[i] and currentSession.ScoreB[i] then
						-- if currentSession.ScoreA[i] > currentSession.ScoreB[i] then
							-- teamAScore = teamAScore + 1
						-- elseif currentSession.ScoreA[i] < currentSession.ScoreB[i] then
							-- teamBScore = teamBScore + 1
						-- else
							-- teamAScore = teamAScore + 1
							-- teamBScore = teamBScore + 1
						-- end
						if currentSession.ScoreA[i] == nbB then
							teamAScore = teamAScore + 1
						elseif currentSession.ScoreB[i] == nbA then
							teamBScore = teamBScore + 1
						else
							teamAScore = teamAScore + 1
							teamBScore = teamBScore + 1
						end
						
					else
						teamAScore = 0
						teamBScore = 0
					end
				end 
			end
			-- for k,v in pairs (currentSession.ScoreB) do
				-- teamBScore = teamBScore + v
			-- end
			-- currentSession.ScoreB
			DrawAdvancedText(0.5 - indexDecalage, 0.0, 0.196, 0.00, 0.8, tostring(teamAScore), 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.5 + indexDecalage, 0.0, 0.196, 0.00, 0.8, tostring(teamBScore), 255, 255, 255, 255, 6, 0)
		else
			Wait(2000)
		end
	end

end)
  
  
  
  
  
  



disabledControls = {
    30,     -- A and D (Character Movement)
    31,     -- W and S (Character Movement)
    21,     -- LEFT SHIFT
    36,     -- LEFT CTRL
    22,     -- SPACE
    44,     -- Q
    38,     -- E
    71,     -- W (Vehicle Movement)
    72,     -- S (Vehicle Movement)
    59,     -- A and D (Vehicle Movement)
    60,     -- LEFT SHIFT and LEFT CTRL (Vehicle Movement)
    85,     -- Q (Radio Wheel)
    86,     -- E (Vehicle Horn)
    15,     -- Mouse wheel up
    14,     -- Mouse wheel down
    37,     -- Controller R1 (PS) / RT (XBOX)
    80,     -- Controller O (PS) / B (XBOX)
    228,    -- 
    229,    -- 
    172,    -- 
    173,    -- 
    37,     -- 
    44,     -- 
    178,    -- 
    244    -- 
}

local camDisableControl = false

Citizen.CreateThread(function()
	while true do
		if camDisableControl then
			Citizen.Wait(2)
			for k, v in pairs(disabledControls) do
				DisableControlAction(0, v, true)
			end
		else
			Citizen.Wait(50)
		end
		
	end
end)

function StartFreeCam(fov,entity)
    ClearFocus()

    locFov = GetGameplayCamFov()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(entity), 0, 0, 0, locFov * 1.0)

    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, false)
    
    SetCamAffectsAiming(cam, false)

    -- AttachCamToEntity(cam, entity, 0.0, -3.5, 1.0, true)
	return cam
end

function EndFreeCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    
    offsetRotX = 0.0
    offsetRotY = 0.0
    offsetRotZ = 0.0

    isAttached = false

    speed       = 1.0
    precision   = 1.0
    currFov     = GetGameplayCamFov()

    cam = nil
	camDisableControl = false
end

function goToSpectate(data)

	local playerIdx = GetPlayerFromServerId(data)
	local playerPedx = GetPlayerPed(playerIdx)
	local dontLeaveSpectate = true
	print("Go in spectate ped : "..tostring(GetPlayerPed(playerIdx)).." data "..tostring(playerIdx))
	offsetRotX = 0.0
	offsetRotZ = 0.0
	offsetRotY = 0.0


	Citizen.CreateThread(function()
		pedToSpectate = playerPedx
		currentcam = StartFreeCam(90.0,pedToSpectate)
		camDisableControl = true
		while dontLeaveSpectate do
			Wait(0)
			pedToSCoords = GetEntityCoords(pedToSpectate)
			pedToSCoordsOffset = GetOffsetFromEntityInWorldCoords(pedToSpectate,0.0,-2.5,0.0)
			pedToSHeading = GetEntityHeading(pedToSpectate)

			SetCamCoord(currentcam,pedToSCoordsOffset.x,pedToSCoordsOffset.y,pedToSCoordsOffset.z+1.0)
			
			offsetRotX = offsetRotX - (GetDisabledControlNormal(1, 2) * 1.5 * 2.0)
			offsetRotZ = offsetRotZ - (GetDisabledControlNormal(1, 1) * 1.5 * 2.0) -- gauche droite
			if (offsetRotX > 90.0) then offsetRotX = 90.0 elseif (offsetRotX < -90.0) then offsetRotX = -90.0 end
			if (offsetRotY > 90.0) then offsetRotY = 90.0 elseif (offsetRotY < -90.0) then offsetRotY = -90.0 end
			if (offsetRotZ > 360.0) then offsetRotZ = offsetRotZ - 360.0 elseif (offsetRotZ < -360.0) then offsetRotZ = offsetRotZ + 360.0 end

			SetCamRot(currentcam,offsetRotX,0.0,pedToSHeading+offsetRotZ,2)
			
			--if IsControlJustPressed(1, 177) then
			--	
			--	dontLeaveSpectate = false
			--	EndFreeCam()
			--
			--	camDisableControl = false
			--	Wait(500)
			--	
			--end
		end
	end)
end

-- RegisterCommand("testSpectate", function(source, args, fullCommand)
	
	-- local playerIdx = GetPlayerFromServerId(tonumber(args[1]))
	-- if playerIdx then
		-- goToSpectate(tonumber(args[1]))
	-- else
	-- print("error number player")
	
	-- end
-- end)

-- RegisterCommand("endSpectate", function(source, args, fullCommand)
	-- dontLeaveSpectate = false
	-- EndFreeCam()

	-- camDisableControl = false

-- end)






local isCurrentlyInSpectateMode = false
local spectatePedList = {}
local currentspectateIDX = 1
-------Spectate Mode

Citizen.CreateThread(function()
	while true do
		Wait(2)
	
		if isCurrentlyInGame then
			if isCurrentlyOutInGame then
				if IsControlJustPressed(1, 174) then---- <---
					dontLeaveSpectate = false
					EndFreeCam()

					-- camDisableControl = false
					currentspectateIDX = currentspectateIDX - 1
					if currentspectateIDX <= 0 then
						currentspectateIDX = #spectatePedList
					end
					goToSpectate(spectatePedList[currentspectateIDX])
					
				end
				
				if IsControlJustPressed(1, 175) then---- ---->
					dontLeaveSpectate = false
					EndFreeCam()

					-- camDisableControl = false
					currentspectateIDX = currentspectateIDX + 1
					if currentspectateIDX > #spectatePedList then
						currentspectateIDX = 1
					end
					goToSpectate(spectatePedList[currentspectateIDX])
				end
				
				if not isCurrentlyInSpectateMode then
					Wait(4000)
					local tempList = {}
					if currentTeam == "red" then
						tempList = {}
						for k,v in pairs(currentSession.EquipB) do
							local playFromSID = GetPlayerFromServerId(v)
							print("k: "..tostring(k).." v: "..tostring(v).." playFromSID: "..tostring(playFromSID))
							if playFromSID ~= -1 then 
								local playerPedx = GetPlayerPed(playFromSID)
								if playerPedx ~= PlayerPedId() then
									tempList[#tempList+1] = v
								end
							end
						end
						-- spectatePedList=
						
						-- GetPlayerPed(playerIdx)
						-- goToSpectate(tonumber(args[1]))
					elseif currentTeam == "blue" then
						tempList = {}
						for k,v in pairs(currentSession.EquipA) do
							
							local playFromSID = GetPlayerFromServerId(v)
							print("k: "..tostring(k).." v: "..tostring(v).." playFromSID: "..tostring(playFromSID))
							if playFromSID ~= -1 then 
								local playerPedx = GetPlayerPed(playFromSID)
								if playerPedx ~= PlayerPedId() then
									tempList[#tempList+1] = v
								end
							end
						end
					end
					print("templist")
					for k,v in pairs(tempList) do
						print("k : "..tostring(k).." v: "..tostring(v))
					end
					spectatePedList = tempList
					if spectatePedList[1] then
						isCurrentlyInSpectateMode = true
						goToSpectate(spectatePedList[1])
					end
				end
			else
				if isCurrentlyInSpectateMode then
					dontLeaveSpectate = false
					EndFreeCam()

					camDisableControl = false
					isCurrentlyInSpectateMode = false
				end
			end
		else
			Wait(2000)
		end
	end

end)