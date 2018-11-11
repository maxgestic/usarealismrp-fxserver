function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- charge customer --
RegisterServerEvent("clothing-store:chargeCustomer")
AddEventHandler("clothing-store:chargeCustomer", function(property)
	local user_source = source
	local amount = 100
	local player = exports["essentialmode"]:getPlayerFromId(user_source)
	local user_money = player.getActiveCharacterData("money")
	if user_money - amount >= 0 then
		TriggerClientEvent("usa:notify", user_source, "~y~Charged:~w~ $" .. amount)
		player.setActiveCharacterData("money", user_money - amount)
		-- give money to store owner --
		if property then
			TriggerEvent("properties:addMoney", property.name, round(0.20 * amount, 0))
		end
	else
		TriggerClientEvent("usa:notify", user_source, "You don't have enough money!")
	end
end)

RegisterServerEvent("mini:save")
AddEventHandler("mini:save", function(appearance)
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local characters = user.getCharacters()
		for i = 1, #characters do
			--print("characters[i].active = " .. tostring(characters[i].active))
			if characters[i].active == true then
				--characters[i].appearance = appearance -- this line is probably the reason why barbershop/tatto customizations aren't saving when a player hits the save button at the clothing store
				characters[i].appearance.hash = appearance.hash
				characters[i].appearance.componentstexture = appearance.componentstexture
				characters[i].appearance.components = appearance.components
				characters[i].appearance.propstexture = appearance.propstexture
				characters[i].appearance.props = appearance.props
				user.setCharacter(characters[i], i)

				TriggerClientEvent("headprops:cacheProp", userSource, 0, appearance.props[9], appearance.propstexture[9])
				TriggerClientEvent("headprops:cacheProp", userSource, 1, appearance.props[9], appearance.propstexture[9])
				TriggerClientEvent("headprops:cacheComponent", userSource, 1, appearance.components[1], appearance.componentstexture[1])
				TriggerClientEvent("headprops:cacheComponent", userSource, 9, appearance.components[9], appearance.componentstexture[9])

				TriggerClientEvent("chatMessage", userSource, "SYSTEM", {0, 128, 255}, "Your player character has been saved.")

				return
			end
		end
		--TriggerEvent("mini:giveMeMyWeaponsPlease")
	--end)
end)


RegisterServerEvent("mini:giveMeMyWeaponsPlease")
AddEventHandler("mini:giveMeMyWeaponsPlease", function()

    local inventory

    print("inside of giveMeMyWeaponsPlease now!!")
	--print("source = " .. source)
	--print("typeof source = " .. type(source))

    -- Gives the loaded user corresponding to the given player id(second argument).
    --TriggerEvent('es:getPlayerFromId', source, function(user)
		local user = exports["essentialmode"]:getPlayerFromId(source)
		if user then
            local playerWeapons = user.getActiveCharacterData("weapons")
            if playerWeapons then print("#playerWeapons = " .. #playerWeapons) end
            -- todo: ADD A CHECK FOR PLAYER JOB, ONLY GIVE WEAPONS IF POLICE
            TriggerClientEvent("CS:giveWeapons", source, playerWeapons)
		else
			print("no user found!")
		end
    --end)

end)
