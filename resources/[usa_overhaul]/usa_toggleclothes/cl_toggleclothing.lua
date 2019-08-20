--# Script by MrFRZ & minipunch
--# made for USA REALISM RP
--# Adds /mask, /glasses, /hat, /vest for players to toggle them on and off easily

-- TODO: add watches, gloves

local props = {
	["0"] = { -- hat
		value = nil,
		texture = nil
	},
	["1"] = { -- glasses
		value = nil,
		texture = nil
	}
}

local components = {
	["1"] = { -- mask
		value = nil,
		texture = nil
	},
	["9"] = { -- vest
		value = nil,
		texture = nil
	}
}

RegisterNetEvent("headprops:toggleProp")
AddEventHandler("headprops:toggleProp", function(prop_index)
	local strPropIndex = tostring(prop_index)
	local ped = GetPlayerPed(-1)
	local waitTime = 1000
	TriggerEvent("usa:playAnimation", "clothingspecs", "try_glasses_neutral_c", -8, 1, -1, 53, 0, 0, 0, 0,  1.5)
	-- toggle prop --
	if GetPedPropIndex(ped, prop_index) >= 0 then -- prop is on
		local value = GetPedPropIndex(ped, prop_index)
		local texture = GetPedPropTextureIndex(ped, prop_index)
		-- not stored, store it --
		props[strPropIndex].value = tonumber(value)
		props[strPropIndex].texture = tonumber(texture)
		Wait(waitTime)
		ClearPedProp(ped, prop_index)
	else
		-- stored, put back on --
		Wait(waitTime)
		if not props[strPropIndex] or not props[strPropIndex].value then
			TriggerServerEvent("headprops:loadPropOrComponent", true, strPropIndex, true)
		else 
			ClearPedProp(ped, prop_index)
			SetPedPropIndex(ped, prop_index, props[strPropIndex].value, props[strPropIndex].texture, true)
		end
	end
end)

RegisterNetEvent("headprops:toggleComponent")
AddEventHandler("headprops:toggleComponent", function(component_index)
	local strComponentIndex = tostring(component_index)
	local ped = GetPlayerPed(-1)
	local waitTime = 1000
	if component_index ~= 9 then
		TriggerEvent("usa:playAnimation", "clothingspecs", "try_glasses_neutral_c", -8, 1, -1, 53, 0, 0, 0, 0,  1.5)
	else
		TriggerEvent("usa:playAnimation", "clothingshirt", "try_shirt_neutral_c", -8, 1, -1, 53, 0, 0, 0, 0,  1.5)
	end
	-- toggle component --
	if GetPedDrawableVariation(ped, component_index) > 0 then -- component is on, take off
		local value = GetPedDrawableVariation(ped, component_index)
		local texture = GetPedTextureVariation(ped, component_index)
		components[strComponentIndex].value = tonumber(value)
		components[strComponentIndex].texture = tonumber(texture)
		Wait(waitTime)
		SetPedComponentVariation(ped, component_index, -1, 0, 2)
	else
		-- off, put back on --
		Wait(waitTime)
		if not components[strComponentIndex] or not components[strComponentIndex].value then
			TriggerServerEvent("headprops:loadPropOrComponent", false, strComponentIndex, true)
		else 
			SetPedComponentVariation(ped, component_index, components[strComponentIndex].value, components[strComponentIndex].texture, 2)
		end
	end
end)

RegisterNetEvent("headprops:cacheProp")
AddEventHandler("headprops:cacheProp", function(id, val, tex, doEquip)
	props[id].value = val
	props[id].texture = tex
	if doEquip then
		local numID = tonumber(id)
		local me = PlayerPedId()
		ClearPedProp(me, numID)
		SetPedPropIndex(me, numID, val, tex, true)
	end
end)

RegisterNetEvent("headprops:cacheComponent")
AddEventHandler("headprops:cacheComponent", function(id, val, tex, doEquip)
	components[id].value = val
	components[id].texture = tex
	if doEquip then
		local numID = tonumber(id)
		local me = PlayerPedId()
		SetPedComponentVariation(me, numID, val, tex, 2)
	end
end)
