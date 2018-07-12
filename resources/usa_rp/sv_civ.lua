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

local VEH_GARAGE_MAXIMUM_STORAGE_NUM = 12

------------------------
-- Blindfold a person --
------------------------
TriggerEvent('es:addCommand','removeblindfold', function(source, args, user)
	print("inside /removeblindfold command!")
	TriggerClientEvent("crim:attemptToBlindfoldNearestPerson", source, false)
	--[[
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
	--]]
end, {
	help = "Remove the blindfold off of the nearest person."
})

------------------------
-- Blindfold a person --
------------------------
TriggerEvent('es:addCommand','blindfold', function(source, args, user)
	print("inside /blindfold command!")
	TriggerClientEvent("crim:attemptToBlindfoldNearestPerson", source, true)
	--[[
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
	--]]
end, {
	help = "Place a bag over the nearest person's head."
})

RegisterServerEvent("crim:foundPlayerToBlindfold")
AddEventHandler("crim:foundPlayerToBlindfold", function(id, blindfold)
	if blindfold then
		TriggerClientEvent("crim:areHandsTied", id, source, id, "blindfold")
	else
		TriggerClientEvent("crim:blindfold", id, false)
	end
	-- play animation:
	local anim = {
		dict = "anim@move_m@trash",
		name = "pickup"
	}
	TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
end)

---------------------------
-- Steal a player's cash --
---------------------------
TriggerEvent('es:addCommand','rob', function(source, args, user)
	print("inside /rob command!")
	--[[
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
	--]]
	TriggerClientEvent("crim:attemptToRobNearestPerson", source)
end, {
	help = "Steal the nearest player's money."
})

RegisterServerEvent("crim:foundPlayerToRob")
AddEventHandler("crim:foundPlayerToRob", function(id)
	TriggerClientEvent("crim:areHandsTied", id, source, id, "rob")
	-- play animation:
	local anim = {
		dict = "anim@move_m@trash",
		name = "pickup"
	}
	TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
end)

---------------------------------------
-- bound a player's wrists with rope --
---------------------------------------
TriggerEvent('es:addCommand','tie', function(source, args, user)
	print("inside /tie command!")
	TriggerClientEvent("crim:attemptToTieNearestPerson", source, true)
	--if type(tonumber(args[2])) == "number" then
		-- see if target player has their hands in the air before tying up
		--local target_player_id = tonumber(args[2])
		--TriggerClientEvent("crim:areHandsUp", target_player_id, source, target_player_id)
		--[[ play animation:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
		--]]
	--end
end, {
	help = "Tie the nearest person's hands together."
})

RegisterServerEvent("crim:foundPlayerToTie")
AddEventHandler("crim:foundPlayerToTie", function(id, tying_up)
	if tying_up then
		TriggerClientEvent("crim:areHandsUp", id, source, id)
	else
		TriggerClientEvent("crim:untieHands", id, source)
	end
	local anim = {
		dict = "anim@move_m@trash",
		name = "pickup"
	}
	TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
end)

----------------------
-- untie the player --
----------------------
TriggerEvent('es:addCommand','untie', function(source, args, user)
	TriggerClientEvent("crim:attemptToTieNearestPerson", source, false)
end, {
	help = "Untie the nearest person's hands."
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
				TriggerClientEvent("usa:notify", source, "You need a bag to do that!")
			end
		end)
	else
		TriggerClientEvent("usa:notify", source, "Person does not have their hands tied or is too far away!")
	end
end)

local walkstyles = {
    {display_name = "Tough (Male)", clipset_name ="MOVE_M@TOUGH_GUY@"},
    {display_name = "Tough (Female)", clipset_name ="MOVE_F@TOUGH_GUY@"},
    {display_name = "Posh (Male)", clipset_name ="MOVE_M@POSH@"},
    {display_name = "Posh (Female)", clipset_name ="MOVE_F@POSH@"},
    {display_name = "Gangster 1 (Male)", clipset_name ="MOVE_M@GANGSTER@NG"},
    {display_name = "Gangster 1 (Female)", clipset_name ="MOVE_F@GANGSTER@NG"},
    {display_name = "Femme (Male)", clipset_name ="MOVE_M@FEMME@"},
    {display_name = "Femme (Female)", clipset_name ="MOVE_F@FEMME@"},
    {display_name = "Slow", clipset_name ="move_p_m_zero_slow"},
    {display_name = "Gangster 2", clipset_name ="move_m@gangster@var_i"},
    {display_name = "Casual", clipset_name ="move_m@casual@d"},
	{display_name = "Injured", clipset_name ="move_injured_generic"},
	{display_name = "Flee", clipset_name ="move_f@flee@a"},
	{display_name = "Scared", clipset_name ="move_f@scared"},
	{display_name = "Sexy", clipset_name ="move_f@sexy@a"},
	{display_name = "Slightly Drunk", clipset_name ="MOVE_M@DRUNK@SLIGHTLYDRUNK"},
	{display_name = "Moderately Drunk", clipset_name ="MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP"},
    {display_name = "Very Drunk", clipset_name ="MOVE_M@DRUNK@VERYDRUNK"}
}

----------------------------
-- Change your walk style --
----------------------------
TriggerEvent('es:addCommand', 'walkstyle', function(source, args, user, location)
	local style_number = args[2]
	if not style_number then
		TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0" .. "[0] Default")
		for i = 1, #walkstyles do
			TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0" .. "[" .. i .. "] " .. walkstyles[i].display_name)
		end
	else
		if tonumber(style_number) ~= 0 then
			TriggerClientEvent("civ:changeWalkStyle", source, walkstyles[tonumber(style_number)].clipset_name)
		else
			TriggerClientEvent("civ:changeWalkStyle", source, tonumber(style_number))
		end
	end
end, {
	help = "Change your walking style.",
	params = {
		{ name = "style name", help = "Options: 1 - " .. #walkstyles .. ", do /walkstyle for list" }
	}
})

------------------------------------------------
-- trade / sell vehicles to other players --
------------------------------------------------
TriggerEvent('es:addCommand', 'sellvehicle', function(source, args, user, location)
	local veh_number = tonumber(args[2])
	local target = tonumber(args[3])
	local price = tonumber(args[4])
	local user_vehicles = user.getActiveCharacterData("vehicles")
	if veh_number and GetPlayerName(target) and price and target ~= tonumber(source) then
		price = math.floor(price)
		local veh_to_sell = user_vehicles[veh_number]
		if veh_to_sell then
			local target_player = exports["essentialmode"]:getPlayerFromId(target)
			local target_player_vehicles = target_player.getActiveCharacterData("vehicles")
			local target_player_money  = target_player.getActiveCharacterData("money")
			local target_player_bank = target_player.getActiveCharacterData("bank")
			if #target_player_vehicles < VEH_GARAGE_MAXIMUM_STORAGE_NUM then
				local seller = user.getActiveCharacterData("fullName")
				if target_player_money >= price or target_player_bank >= price then
					local details = {
						source = source,
						target = target,
						user = user,
						target_player = target_player,
						user_vehicles = user_vehicles,
						target_player_vehicles = target_player_vehicles,
						seller = seller,
						price = price,
						veh_to_sell = veh_to_sell,
						target_player_money = target_player_money,
						target_player_bank = target_player_bank,
						veh_number = veh_number
					}
					TriggerClientEvent("vehicle:confirmSell", target, details)
				end
			else
				print("Error: target player has reached limit of " .. VEH_GARAGE_MAXIMUM_STORAGE_NUM .. " vehicles!")
			end
		end
	else
		-- print list of vehs --
		for i = 1, #user_vehicles do
			local vehicle = user_vehicles[i]
			TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0---------------------- #" .. i .. " -------------------------")
			TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0VEH: " .. vehicle.make .. " " .. vehicle.model)
			TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0PLATE: " .. vehicle.plate)
			TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0----------------------------------------------------")
		end
	end
end, {
	help = "Offer one of your vehicles to another player.",
	params = {
		{ name = "vehicle #", help = "The vehicle number from your list of vehicles [hint: do /sellvehicle]." },
		{ name = "target", help = "The ID # of the player to sell the vehicle to." },
		{ name = "price", help = "The price you are offering the vehicle for." }
	}
})

RegisterServerEvent("vehicle:confirmSell")
AddEventHandler("vehicle:confirmSell", function(details, wants_to_buy)
	if wants_to_buy then
		TradeVehicle(details)
	else
		TriggerClientEvent("usa:notify", details.source, "Person ~r~rejected~w~ your offer!")
		TriggerClientEvent("usa:notify", details.target, "You ~r~rejected~w~ the offer!")
	end
end)

function SendDiscordMessage(content, url, color)
	PerformHttpRequest(url, function(err, text, headers)
		if text then
			print(text)
		end
	end, "POST", json.encode({
		embeds = {
			{
				description = content,
				color = color, --524288
				author = {
					name = "Department of Motor Vehicles"
				}
			}
		}
	}), { ["Content-Type"] = 'application/json' })
end

function TradeVehicle(details)
	local buyer = exports["essentialmode"]:getPlayerFromId(details.target)
	local seller = exports["essentialmode"]:getPlayerFromId(details.source)
	-- trade money --
	if details.target_player_money >= details.price then
		print("player had enough money!")
		buyer.setActiveCharacterData("money", details.target_player_money - details.price)
		seller.setActiveCharacterData("money", seller.getActiveCharacterData("money") + details.price)
	elseif details.target_player_bank >= details.price then
		buyer.setActiveCharacterData("bank", details.target_player_bank - details.price)
		seller.setActiveCharacterData("bank", seller.getActiveCharacterData("bank") + details.price)
	else
		TriggerClientEvent("usa:notify", details.target, "Not enough money to pruchase vehicle!")
		TriggerClientEvent("usa:notify", details.source, "Person did not have enough money to pruchase vehicle!")
		return
	end
	-- remove vehicle from seller --
	print("veh to sell: " .. details.veh_to_sell.make .. " " .. details.veh_to_sell.model)
	table.remove(details.user_vehicles, details.veh_number)
	seller.setActiveCharacterData("vehicles", details.user_vehicles)
	print("removed vehicle from: " .. GetPlayerName(details.source))
	print("giving to player: " .. GetPlayerName(details.target))
	-- transfer ownership details --
	details.veh_to_sell.owner = buyer.getActiveCharacterData("fullName")
	-- give vehicle to target --
	table.insert(details.target_player_vehicles, details.veh_to_sell)
	buyer.setActiveCharacterData("vehicles", details.target_player_vehicles)
	print("vehicle successfully transferred!")
	-- send discord msg to log --
	local timestamp = os.date("*t", os.time())
	local desc = "\n**Vehicle:** " .. details.veh_to_sell.make .. " " .. details.veh_to_sell.model ..
	"\n**Seller:** " .. details.seller ..
	"\n**Buyer:** " .. details.veh_to_sell.owner ..
	"\n**Price:** $" .. details.price ..
	"\n**Date:** ".. timestamp.month .. "/" .. timestamp.day .."/" .. timestamp.year
	SendDiscordMessage(desc, "https://discordapp.com/api/webhooks/436965351004307466/FY-o_sGScUYFQpo9Y18-ZP-L_HdWRXoDZ1eO2AeD7uXzmg5JwWzqlb07Bbf1Yvv0_W-k", 524288)
	TriggerClientEvent("usa:notify", details.source, "Transaction ~g~successful~w~!")
	TriggerClientEvent("usa:notify", details.target, "Transaction ~g~successful~w~!")
end
