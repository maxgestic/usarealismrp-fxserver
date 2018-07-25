-- Hat prop on / off --
TriggerEvent('es:addCommand', 'hat', function(source, args, user, location)
	TriggerClientEvent("headprops:toggleProp", source, 0)
end, { help = "Take your hat on / off." })

-- Glasses prop on / off --
TriggerEvent('es:addCommand', 'glasses', function(source, args, user, location)
	TriggerClientEvent("headprops:toggleProp", source, 1)
end, { help = "Take your glasses on / off." })

-- Glasses prop on / off --
TriggerEvent('es:addCommand', 'mask', function(source, args, user, location)
	TriggerClientEvent("headprops:toggleComponent", source, 1)
end, { help = "Take your mask on / off." })

RegisterNetEvent("headprops:loadHeadProp")
AddEventHandler("headprops:loadHeadProp", function(propid)
	print("loading prop...")
	local userSource = source
	local player = exports["essentialmode"]:getPlayerFromId(userSource)
	local characters = player.getCharacters()
	for i = 1, #characters do
		if characters[i].active == true then
			if propid == 0 then  -- hat
				if characters[i].appearance.props then
					TriggerClientEvent(
						"headprops:cacheHat",
						userSource,
						characters[i].appearance.props["0"],
						characters[i].appearance.propstexture["0"]
					)
				end
			elseif propid == 1 then  -- glasses
				if characters[i].appearance.props then
					TriggerClientEvent(
						"headprops:cacheGlasses",
						userSource,
						characters[i].appearance.props["1"],
						characters[i].appearance.propstexture["1"]
					)
				end
			else -- mask
				TriggerClientEvent(
					"headprops:cacheMask",
					userSource,
					characters[i].appearance.components["1"],
					characters[i].appearance.componentstexture["1"]
				)
			end
			return
		end
	end
end)
