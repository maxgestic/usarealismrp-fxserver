--# Script by MrFRZ & minipunch
--# made for USA REALISM RP
--# Adds /mask, /glasses, /hat, /vest for players to toggle them on and off easily

-- Hat prop on / off --
TriggerEvent('es:addCommand', 'hat', function(source, args, char, location)
	TriggerClientEvent("headprops:toggleProp", source, 0)
end, { help = "Take your hat on / off." })

-- Glasses prop on / off --
TriggerEvent('es:addCommand', 'glasses', function(source, args, char, location)
	TriggerClientEvent("headprops:toggleProp", source, 1)
end, { help = "Take your glasses on / off." })

-- Mask component on / off --
TriggerEvent('es:addCommand', 'mask', function(source, args, char, location)
	TriggerClientEvent("headprops:toggleComponent", source, 1)
end, { help = "Take your mask on / off." })

-- Vest component on / off --
TriggerEvent('es:addCommand', 'vest', function(source, args, char, location)
	TriggerClientEvent("headprops:toggleComponent", source, 9)
end, { help = "Take your vest on / off." })

RegisterNetEvent("headprops:loadPropOrComponent")
AddEventHandler("headprops:loadPropOrComponent", function(isProp, id)
	local char = exports["usa-characters"]:GetCharacter(source)
	local appearance = char.get("appearance")
	if isProp then
		if appearance.props then
			TriggerClientEvent("headprops:cacheProp", source, id, appearance.props[id], appearance.propstexture[id])
		end
	else
		if appearance.components then
			TriggerClientEvent("headprops:cacheComponent", source, id, appearance.components[id], appearance.componentstexture[id])
		end
	end
	return
end)
