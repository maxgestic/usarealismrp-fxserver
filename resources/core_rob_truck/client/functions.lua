Citizen.CreateThread(function()
	Citizen.Wait(2000)
	while true do
		local sleep = 1000
		local ped = PlayerPedId()
		local playerpos = GetEntityCoords(ped)
		local dispatch = {x = 148.46914672852, y = -768.45269775391, z = 262.87182617188}
		if cfg.doestheplayerneedtohavebag then local bag = GetPedDrawableVariation(ped,math.floor(5)) for k,v in pairs(cfg.bagsavailable) do if v == bag then cansee = true end end	else cansee = true end
		if cansee then
			if robbery.status ~= nil then
				if robbery.status == false then
					if using == false then
						for k,v in pairs(cfg.hacklocations) do
							if GetDistanceBetweenCoords(playerpos.x,playerpos.y,playerpos.z,v.pos[math.floor(1)],v.pos[math.floor(2)],v.pos[math.floor(3)],true) <= 1.0 then
								sleep = 1
								if marker_id == nil then TriggerEvent("CORE_MARKERMENU:ShowMarker_c",v.text,function(_id) marker_id = _id end) end
								if IsControlJustPressed(math.floor(1),v.text_key) then
									TriggerEvent("CORE_MARKERMENU:StopMarker_c",marker_id)
									marker_id = nil
				
									TriggerServerEvent("CORE_ROB_TRUCK:HackPanel_s",k)
									TriggerServerEvent("911:TruckAtRisk", dispatch.x,dispatch.y,dispatch.z)
								end
								goto done
							end
						end
					end
				else
					if NetworkDoesEntityExistWithNetworkId(robbery.vehicle_net_id) then
						if robbery.open_status == false then
							if GetDistanceBetweenCoords(playerpos.x,playerpos.y,playerpos.z,GetOffsetFromEntityInWorldCoords(NetworkGetEntityFromNetworkId(robbery.vehicle_net_id),0.0,-4.0,0.0),true) <= 1.2 then
								sleep = 1
								if marker_id == nil then TriggerEvent("CORE_MARKERMENU:ShowMarker_c",cfg.bombitem_text,function(_id) marker_id = _id end) end
								if IsControlJustPressed(math.floor(1),cfg.bombitem_key) then
									TriggerEvent("CORE_MARKERMENU:StopMarker_c",marker_id)
									marker_id = nil
									TriggerServerEvent("CORE_ROB_TRUCK:Bomb_s",k)
								end
								goto done
							end
						else
							if robbery.money > math.floor(0) then
								if GetDistanceBetweenCoords(playerpos.x,playerpos.y,playerpos.z,GetOffsetFromEntityInWorldCoords(NetworkGetEntityFromNetworkId(robbery.vehicle_net_id),0.0,-4.0,0.0),true) <= 1.2 then
									sleep = 1
									if marker_id == nil then TriggerEvent("CORE_MARKERMENU:ShowMarker_c",cfg.collectitem_text,function(_id) marker_id = _id end) end
									if IsControlJustPressed(math.floor(1),cfg.collectitem_key) then
										TriggerEvent("CORE_MARKERMENU:StopMarker_c",marker_id)
										marker_id = nil
	
										TriggerServerEvent("CORE_ROB_TRUCK:GrabMoney_s")
			
										local animdict = "pickup_object" while not HasAnimDictLoaded(animdict) do Citizen.Wait(1) RequestAnimDict(animdict) end
										TaskPlayAnim(ped,"pickup_object","pickup_low",1.0,1.0,1.0,math.floor(16),0.0,false,false,false)
										Citizen.Wait(600)
										DeleteEntity(GetClosestObjectOfType(playerpos.x,playerpos.y,playerpos.z,10.0,GetHashKey('prop_cash_pile_02')))
										Citizen.Wait(400)
									end
									goto done
								end
							end
						end
					end
				end
			end
			if marker_id ~= nil then
				TriggerEvent("CORE_MARKERMENU:StopMarker_c",marker_id)
				marker_id = nil
			end
			::done::
		end
		Citizen.Wait(sleep)
	end
end)

RegisterNetEvent("CORE_ROB_TRUCK:Notification_c")
AddEventHandler("CORE_ROB_TRUCK:Notification_c", function(msg)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandThefeedPostTicker(true, false)
end)
RegisterNetEvent("CORE_ROB_TRUCK:PoliceNotification_c")
AddEventHandler("CORE_ROB_TRUCK:PoliceNotification_c", function(coords,msg)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandThefeedPostTicker(true, false)

	local blip = AddBlipForCoord(coords.x,coords.y,coords.z)
	SetBlipSprite(blip,477)
	SetBlipColour(blip,1)
	SetBlipScale(blip,2.0)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Truck Robbery")
	EndTextCommandSetBlipName(blip)

	Citizen.CreateThread(function()
		local alpha = 255
		local status = true
		while true do
			local sleep = 1
			if status == true then alpha = alpha - 1 else alpha = alpha + 1 end
			if alpha == 0 then status = false end
			if alpha == 255 then status = true end
			SetBlipAlpha(blip,alpha)
			Citizen.Wait(sleep)
		end
	end)
	Citizen.Wait(1000 * 60 * 5)

	RemoveBlip(blip)
end)

RegisterNetEvent("core_rob_truck:hint")
AddEventHandler("core_rob_truck:hint", function()
	local CasinoHint = "^0[^5Terminal At Risk^0] The upper exterior level of the Casino. The terminal company is BLICK and is located [^9REDACTED^0]"
	local HawickBankHint = "^0[^5Terminal At Risk^0] The exterior of the Bank at Hawick Ave. & Meteor St. The terminal company is BLICK and is located [^9REDACTED^0]"
	local GreatOceanHint = "^0[^5Terminal At Risk^0] The exterior of the Bank at Great Ocean Highway. The terminal company is BLICK and is located [^9REDACTED^0]"

	TriggerEvent("chatMessage", '', {0,0,0}, "^0[^3Technician Report^0] Vulnerabilities found in terminals across the city. [^9REDACTED^0] Exposes active bank truck locations. [^9REDACTED^0]")
	Wait(3000)
	TriggerEvent("chatMessage", '', {0,0,0}, "^0[^3Risk Analysis^0] Security Software is outdated and contains a vulnerability that can be used by hackers to expose precise GPS locations of trucks.")
	Wait(3000)
	local chance = math.random()
	if chance <= 0.35 then
		TriggerEvent("chatMessage", '', {0,0,0}, CasinoHint)
	elseif chance >= 0.65 then
		TriggerEvent("chatMessage", '', {0,0,0}, HawickBankHint)
	else
		TriggerEvent("chatMessage", '', {0,0,0}, GreatOceanHint)
	end
	Wait(4500)
	TriggerEvent("chatMessage", '', {0,0,0}, "^0[^2Hint^0] You'll definitely need a bag to store a laptop, money, and something... that goes boom... to get into the truck...")
	Wait(1000)
	TriggerEvent("chatMessage", '', {0,0,0}, "^0[^2Hint^0] Once you hack a terminal with a laptop, you'll get an approximate location.")
end)

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance and not IsPlayerSwitchInProgress() then
    	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	    SetTextScale(0.35, 0.35)
	    SetTextFont(4)
	    SetTextProportional(1)
	    SetTextColour(255, 255, 255, 215)
	    SetTextEntry("STRING")
	    SetTextCentre(1)
	    AddTextComponentString(text)
	    DrawText(_x,_y)
	    local factor = (string.len(text)) / 430
	    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
	end
end


function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize())) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end