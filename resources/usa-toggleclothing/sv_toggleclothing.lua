--# Script by MrFRZ & minipunch
--# made for USA REALISM RP
--# Adds /mask, /glasses, /hat, /vest for players to toggle them on and off easily

-- Hat prop on / off --
TriggerEvent('es:addCommand', 'hat', function(source, args, user, location)
	TriggerClientEvent("headprops:toggleProp", source, 0)
end, { help = "Take your hat on / off." })

-- Glasses prop on / off --
TriggerEvent('es:addCommand', 'glasses', function(source, args, user, location)
	TriggerClientEvent("headprops:toggleProp", source, 1)
end, { help = "Take your glasses on / off." })

-- Mask component on / off --
TriggerEvent('es:addCommand', 'mask', function(source, args, user, location)
	TriggerClientEvent("headprops:toggleComponent", source, 1)
end, { help = "Take your mask on / off." })

-- Vest component on / off --
TriggerEvent('es:addCommand', 'vest', function(source, args, user, location)
	TriggerClientEvent("headprops:toggleComponent", source, 9)
end, { help = "Take your vest on / off." })

RegisterNetEvent("headprops:loadPropOrComponent")
AddEventHandler("headprops:loadPropOrComponent", function(isProp, id)
	local userSource = source
	local player = exports["essentialmode"]:getPlayerFromId(userSource)
	local characters = player.getCharacters()
	for i = 1, #characters do
		if characters[i].active == true then
			if isProp then
				if characters[i].appearance.props then
					TriggerClientEvent("headprops:cacheProp", userSource, id, characters[i].appearance.props[id], characters[i].appearance.propstexture[id])
				end
			else
				if characters[i].appearance.components then
					TriggerClientEvent("headprops:cacheComponent", userSource, id, characters[i].appearance.components[id], characters[i].appearance.componentstexture[id])
				end
			end
			return
		end
	end
end)
