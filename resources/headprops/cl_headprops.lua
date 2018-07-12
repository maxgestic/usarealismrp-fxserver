
-- Toggling props --
local head_props = {
	[0] = {
		value = nil,
		texture = nil
	},
	[1] = {
		value = nil,
		texture = nil
	}
}

RegisterNetEvent("headprops:toggleProp")
AddEventHandler("headprops:toggleProp", function(prop_index)
	local ped = GetPlayerPed(-1)
	local waitTime = 1000
	TriggerEvent("usa:playAnimation", "try_glasses_neutral_c", "clothingspecs", 1.5)

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
			TriggerServerEvent("headprops:loadHeadProp", prop_index)
		end
		Wait(waitTime)
		SetPedPropIndex(ped, prop_index, tonumber(head_props[prop_index].value), tonumber(head_props[prop_index].texture), true) -- put head prop back on
	end
end)

-- Toggling components --
local components = {
	[1] = {
		value = nil,
		texture = nil
	}
}

RegisterNetEvent("headprops:toggleComponent")
AddEventHandler("headprops:toggleComponent", function(component_index)
	local ped = GetPlayerPed(-1)
	local waitTime = 1000
	TriggerEvent("usa:playAnimation", "try_glasses_neutral_c", "clothingspecs", 1.5)

	-- toggle component --
	if GetPedDrawableVariation(ped, 1) > 0 then -- mask is on
		local value = GetPedDrawableVariation(ped, 1)
		local texture = GetPedTextureVariation(ped, 1)
		-- not stored, store it --
		components[component_index].value = tonumber(value)
		components[component_index].texture = tonumber(texture)
		Wait(waitTime)
		SetPedComponentVariation(ped, component_index, -1, 0, 2)
	else
	-- stored, put back on --
		if not components[component_index].value then
			TriggerServerEvent("headprops:loadHeadProp", 2)
		end
		Wait(waitTime)
		SetPedComponentVariation(ped, component_index, tonumber(components[component_index].value), tonumber(components[component_index]).texture, 2)
	end
end)

RegisterNetEvent("headprops:cacheHat")
AddEventHandler("headprops:cacheHat", function(hatVal, hatTex)
	head_props[0].value = tonumber(hatVal)
	head_props[0].texture = tonumber(hatTex)
end)

RegisterNetEvent("headprops:cacheGlasses")
AddEventHandler("headprops:cacheGlasses", function(glassesVal, glassesTex)
	head_props[1].value = tonumber(glassesVal)
	head_props[1].texture = tonumber(glassesTex)
end)

RegisterNetEvent("headprops:cacheMask")
AddEventHandler("headprops:cacheMask", function(maskVal, maskTex)
	components[1].value = tonumber(maskVal)
	components[1].texture = tonumber(maskTex)
end)

