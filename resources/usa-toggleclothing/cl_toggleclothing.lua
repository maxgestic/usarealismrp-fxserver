--# Script by MrFRZ & minipunch
--# made for USA REALISM RP
--# Adds /mask, /glasses, /hat, /vest for players to toggle them on and off easily

-- Props --
local head_props = {
	[0] = { -- hat
		value = nil,
		texture = nil
	},
	[1] = { -- glasses
		value = nil,
		texture = nil
	}
}

RegisterNetEvent("headprops:toggleProp")
AddEventHandler("headprops:toggleProp", function(prop_index)
	local ped = GetPlayerPed(-1)
	local waitTime = 1000

	TriggerEvent("usa:playAnimation", "clothingspecs", "try_glasses_neutral_c", -8, 1, -1, 53, 0, 0, 0, 0,  1.5)

	-- toggle prop --
	if GetPedPropIndex(ped, prop_index) >= 0 then -- prop is on
		local value = GetPedPropIndex(ped, prop_index)
		local texture = GetPedPropTextureIndex(ped, prop_index)
		-- not stored, store it --
		head_props[prop_index].value = tonumber(value)
		head_props[prop_index].texture = tonumber(texture)
		Wait(waitTime)
		ClearPedProp(ped, prop_index)
	else
	-- stored, put back on --
		if not head_props[prop_index].value then
			TriggerServerEvent("headprops:loadPropOrComponent", true, prop_index)
		end
		Wait(waitTime)
		SetPedPropIndex(ped, prop_index, tonumber(head_props[prop_index].value), tonumber(head_props[prop_index].texture), true) -- put head prop back on
	end
end)

-- Components --
local components = {
	[1] = { -- mask
		value = nil,
		texture = nil
	},
	[9] = { -- vest
		value = nil,
		texture = nil
	}
}

RegisterNetEvent("headprops:toggleComponent")
AddEventHandler("headprops:toggleComponent", function(component_index)
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
		components[component_index].value = tonumber(value)
		components[component_index].texture = tonumber(texture)
		Wait(waitTime)
		SetPedComponentVariation(ped, component_index, -1, 0, 2)
	else
	-- off, put back on --
		if not components[component_index].value then
			TriggerServerEvent("headprops:loadPropOrComponent", false, component_index)
		end
		Wait(waitTime)
		SetPedComponentVariation(ped, component_index, tonumber(components[component_index].value), tonumber(components[component_index].texture), 2)
	end
end)

RegisterNetEvent("headprops:cacheProp")
AddEventHandler("headprops:cacheProp", function(id, val, tex)
	head_props[id].value = tonumber(val)
	head_props[id].texture = tonumber(tex)
end)

RegisterNetEvent("headprops:cacheComponent")
AddEventHandler("headprops:cacheComponent", function(id, val, text)
	components[id].value = tonumber(val)
	components[id].texture = tonumber(tex)
end)
