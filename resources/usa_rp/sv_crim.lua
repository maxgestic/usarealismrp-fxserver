local SETTINGS = {
	["tie"] = {
		required_item_name = "Sturdy Rope",
		quantity_to_remove_per_use = 1
	},
	["blindfold"] = {
		required_item_name = "Bag",
		quantity_to_remove_per_use = 1
	}
}

------------------------
-- Blindfold a person --
------------------------
TriggerEvent('es:addCommand','removeblindfold', function(source, args, user)
	print("inside /removeblindfold command!")
	local target_player_id = tonumber(args[2])
	if target_player_id ~= tonumber(source) then
		if type(tonumber(args[2])) == "number" then
			-- see if target player has their hands tied before blindfolding
			TriggerClientEvent("crim:blindfold", target_player_id, false)
			-- play animation:
			local anim = {
				dict = "anim@move_m@trash",
				name = "pickup"
			}
			TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
		end
	else
		print("can't target self when removing blindfold!")
	end
end, {
	help = "Remove the blindfold off of someone.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

------------------------
-- Blindfold a person --
------------------------
TriggerEvent('es:addCommand','blindfold', function(source, args, user)
	print("inside /blindfold command!")
	if type(tonumber(args[2])) == "number" then
		-- see if target player has their hands tied before blindfolding
		local target_player_id = tonumber(args[2])
		TriggerClientEvent("crim:areHandsTied", target_player_id, source, target_player_id, "blindfold")
		-- play animation:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
	end
end, {
	help = "Place a bag over someone's head.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

---------------------------
-- Steal a player's cash --
---------------------------
TriggerEvent('es:addCommand','rob', function(source, args, user)
	print("inside /rob command!")
	if type(tonumber(args[2])) == "number" then
		-- see if target player has their hands in the air before tying up
		local target_player_id = tonumber(args[2])
		TriggerClientEvent("crim:areHandsTied", target_player_id, source, target_player_id, "rob")
		-- play animation:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
	end
end, {
	help = "Steal a player's money.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

---------------------------------------
-- bound a player's wrists with rope --
---------------------------------------
TriggerEvent('es:addCommand','tie', function(source, args, user)
	print("inside /tie command!")
	if type(tonumber(args[2])) == "number" then
		-- see if target player has their hands in the air before tying up
		local target_player_id = tonumber(args[2])
		TriggerClientEvent("crim:areHandsUp", target_player_id, source, target_player_id)
		-- play animation:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
	end
end, {
	help = "Tie a person's hands together.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

----------------------
-- untie the player --
----------------------
TriggerEvent('es:addCommand','untie', function(source, args, user)
	if type(tonumber(args[2])) == "number" then
		local target_player_id = tonumber(args[2])
		if target_player_id ~= tonumber(source) then
			-- untie target's hands, assuming their range has already been confirmed
			TriggerClientEvent("crim:untieHands", target_player_id, tonumber(source))
			-- play animation:
			local anim = {
				dict = "anim@move_m@trash",
				name = "pickup"
			}
			TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
		else
			print("can't untie yourself!")
		end
	end
end, {
	help = "Untie a person's hands.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

RegisterServerEvent("crim:continueBounding")
AddEventHandler("crim:continueBounding", function(bound, from_id, target_player_id)
	print("inside crim:continueBounding with from id = " .. from_id .. ", target id = " .. target_player_id)
	local source = tonumber(from_id)
	if bound then
		print("bound was not nil or false!")
		TriggerEvent("usa:getPlayerItem", source, SETTINGS["tie"].required_item_name, function(item)
			if item then
				print("player had item to tie person up!")
				-- remove item:
				TriggerEvent("usa:removeItem", item, SETTINGS["tie"].quantity_to_remove_per_use, source)
				-- bound target:
				print("tying id #" .. target_player_id .. "'s hands!'")
				TriggerClientEvent("crim:tieHands", target_player_id)
				-- notify player
				TriggerClientEvent("usa:notify", source, "You have tied that person's hands together.")
			else
				print("player did not have required item for action!")
				TriggerClientEvent("usa:notify", source, "You need rope to do that!")
			end
		end)
	else
		TriggerClientEvent("usa:notify", source, "Person does not have their hands up or is too far away!")
	end
end)

RegisterServerEvent("crim:continueRobbing")
AddEventHandler("crim:continueRobbing", function(continue_robbing, from_id, target_player_id)
	print("inside crim:continueRobbing with from id = " .. from_id .. ", target id = " .. target_player_id)
	local source = tonumber(from_id)
	if continue_robbing then
		local to_steal_amount = 0
		TriggerEvent("es:getPlayerFromId", tonumber(target_player_id), function(victim)
			to_steal_amount = victim.getActiveCharacterData("money")
			victim.setActiveCharacterData("money", 0)
		end)
		-- give to person stealing:
		print("player is stealing amount $" .. to_steal_amount .. " from a person!")
		TriggerEvent("es:getPlayerFromId", source, function(person_commiting_crime)
			local before_robbery_amount = person_commiting_crime.getActiveCharacterData("money")
			person_commiting_crime.setActiveCharacterData("money", before_robbery_amount + to_steal_amount)
		end)
	else
		TriggerClientEvent("usa:notify", source, "Person does not have their hands tied or is too far away!")
	end
end)

RegisterServerEvent("crim:continueBlindfolding")
AddEventHandler("crim:continueBlindfolding", function(continue_blindfolding, from_id, target_player_id)
	print("inside crim:continueBounding with from id = " .. from_id .. ", target id = " .. target_player_id)
	local source = tonumber(from_id)
	if continue_blindfolding then
		print("bound was not nil or false!")
		TriggerEvent("usa:getPlayerItem", source, SETTINGS["blindfold"].required_item_name, function(item)
			if item then
				print("player had item to tie person up!")
				-- remove item:
				TriggerEvent("usa:removeItem", item, SETTINGS["blindfold"].quantity_to_remove_per_use, source)
				-- bound target:
				print("blindfolding id #" .. target_player_id .. "!")
				TriggerClientEvent("crim:blindfold", target_player_id, true)
				-- notify player
				TriggerClientEvent("usa:notify", source, "You have blindfolded that person.")
			else
				print("player did not have required item for action!")
				TriggerClientEvent("usa:notify", source, "You need duct tape to do that!")
			end
		end)
	else
		TriggerClientEvent("usa:notify", source, "Person does not have their hands tied or is too far away!")
	end
end)
