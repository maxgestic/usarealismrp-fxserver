--------------------
-- EVENT HANDLERS --
--------------------
RegisterServerEvent("judge:duty")
AddEventHandler("judge:duty", function()
  local usource = source
  local user = exports["essentialmode"]:getPlayerFromId(usource)
  local user_job = user.getActiveCharacterData("job")
  local user_judge_rank = user.getActiveCharacterData("judgeRank")
  if user_job ~= "judge" and user_judge_rank > 0 then
	local user_char_name = user.getActiveCharacterData("fullName")
    user.setActiveCharacterData("job", "judge")
    TriggerClientEvent("usa:notify", usource, "You are now ~g~on duty~w~ as a judge.")
	TriggerClientEvent('chatMessage', -1, "", {0, 0, 0}, "^0" .. user_char_name .. " has just gone on duty as an official judge.")
  else
    user.setActiveCharacterData("job", "civ")
    TriggerClientEvent("usa:notify", usource, "You are now ~y~off duty~w~ as a judge.")
  end
end)

-----------------------------
-- LAWYER / JUDGE COMMANDS --
-----------------------------
TriggerEvent('es:addJobCommand', 'removesuspension', {'judge', 'lawyer'}, function(source, args, user)
	print("removing suspension")
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local target_item_name = nil
	if type and GetPlayerName(target) then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "fp" then
			target_item_name = "Firearm Permit"
		end
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local licenses = target_player.getActiveCharacterData("licenses")
        local player_name = target_player.getActiveCharacterData("fullName")
		for i = 1, #licenses do
			if licenses[i].name == target_item_name then
				if licenses[i].status == "suspended" then
					licenses[i].status = "valid"
					target_player.setActiveCharacterData("licenses", licenses)
					TriggerClientEvent("usa:notify", target, "Your " .. target_item_name .. " has been ~g~reinstated~w~!")
					TriggerClientEvent("usa:notify", usource, "You reinstated " .. player_name .. "'s " .. target_item_name .. "!")
				end
			end
		end
	end
end, {
	help = "Remove a driver's license or firearm permit suspension",
	params = {
		{ name = "license type", help = "either FP or DL" },
		{ name = "id", help = "id of player" }
	}
})

TriggerEvent('es:addJobCommand', 'checksuspensions', {'judge', 'lawyer'}, function(source, args, user)
	print("checking suspension")
	local usource = source
	local target = tonumber(args[2])
	local target_item_name = nil
	local found = false
	if GetPlayerName(target) then
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local licenses = target_player.getActiveCharacterData("licenses")
    local user_name = target_player.getActiveCharacterData("fullName")
    TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0------------------------------")
    TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0Name: " .. user_name)
		for i = 1, #licenses do
      TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0License: " .. licenses[i].name)
			if licenses[i].status == "suspended" then
        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0Status: ^1" .. licenses[i].status)
        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0Suspenion Duration: " .. licenses[i].suspension_days)
        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0Suspension Start Date: " .. licenses[i].suspension_start_date)
			else
        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0Status: ^2" .. licenses[i].status)
			end
			found = true
		end
		if not found then
			TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0No firearm permit or driver's license found on that person.")
		end
    TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0------------------------------")
	end
end, {
	help = "Check the status of a person's driver's license and firearm permit.",
	params = {
		{ name = "id", help = "id of player" }
	}
})

-- todo: finish below
TriggerEvent('es:addJobCommand', 'changesuspension', {'judge', 'lawyer'}, function(source, args, user)
	print("changing suspension")
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local days = tonumber(args[4])
	local target_item_name = nil
	if type and GetPlayerName(target) and days then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "fp" then
			target_item_name = "Firearm Permit"
		end
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local licenses = target_player.getActiveCharacterData("licenses")
        local player_name = target_player.getActiveCharacterData("fullName")
		for i = 1, #licenses do
			if licenses[i].name == target_item_name then
				if licenses[i].status == "suspended" then
					licenses[i].suspension_days = days
					target_player.setActiveCharacterData("licenses", licenses)
					TriggerClientEvent("usa:notify", target, "Your " .. target_item_name .. " suspension was modified to end in " .. days .. " day(s).")
					TriggerClientEvent("usa:notify", usource, "You changed " .. player_name .. "'s " .. target_item_name .. " suspension to end in " .. days .. " day(s).")
					return
				end
			end
		end
	end
end, {
	help = "Alter a driver's license or firearm permit suspension",
	params = {
		{ name = "license type", help = "either FP or DL" },
		{ name = "id", help = "id of player" },
		{ name = "days", help = "days to set license/permit suspension to" },
	}
})

TriggerEvent('es:addJobCommand', 'issue', {'judge', 'lawyer'}, function(source, args, user)
	print("removing suspension")
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local target_item_name = nil
	local target_item = nil
	if type and GetPlayerName(target) then
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local timestamp = os.date("*t", os.time())
		if type == "dl" then
			target_item_name = "Driver's License"
			target_item = {
				name = "Driver\'s License",
				number = "F" .. tostring(math.random(1, 2543678)),
				quantity = 1,
				ownerName = target_player.getActiveCharacterData("fullName"),
				issued_by = user.getActiveCharacterData("fullName"),
				ownerDob = user.getActiveCharacterData("dateOfBirth"),
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid",
				type = "license"
			}
		elseif type == "fp" then
			target_item_name = "Firearm Permit"
			target_item = {
				name = "Firearm Permit",
				number = "G" .. tostring(math.random(1, 254367)),
				quantity = 1,
				ownerName = target_player.getActiveCharacterData("fullName"),
				issued_by = user.getActiveCharacterData("fullName"),
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid",
				type = "license"
			}
		end
		local licenses = target_player.getActiveCharacterData("licenses")
        local player_name = target_player.getActiveCharacterData("fullName")
		for i = 1, #licenses do
			if licenses[i].name == target_item_name then
				TriggerClientEvent("usa:notify", usource, player_name .. " already has a " .. target_item_name .. "!")
				return
			end
		end
		-- not found at this point, issue it to them --
		table.insert(licenses, target_item)
		target_player.setActiveCharacterData("licenses", licenses)
		TriggerClientEvent("usa:notify", usource, "You issued a " .. target_item_name .. " to " .. player_name .. "!")
		TriggerClientEvent("usa:notify", target, "You were issued a " .. target_item_name .. "!")
	end
end, {
	help = "Issue a driver's license or firearm permit",
	params = {
		{ name = "license type", help = "either FP or DL" },
		{ name = "id", help = "id of player" }
	}
})

TriggerEvent('es:addJobCommand', 'suspend', {'judge', 'lawyer'}, function(source, args, user)
	print("adding suspension")
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
    local days = tonumber(args[4])
	local target_item_name = nil
	if type and GetPlayerName(target) then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "fp" then
			target_item_name = "Firearm Permit"
		else
            TriggerClientEvent("usa:notify", usource, "~r~Error:~w~ wrong input for [type]. Options: 'DL' or 'FP'")
            return
        end
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local licenses = target_player.getActiveCharacterData("licenses")
        local target_player_name = target_player.getActiveCharacterData("fullName")
        for i = 1, #licenses do
            local license =  licenses[i]
            if  license.name == target_item_name then
                licenses[i].status = "suspended"
                licenses[i].suspension_start = os.time()
                licenses[i].suspension_days = days
                licenses[i].suspension_start_date = os.date('%m-%d-%Y %H:%M:%S', os.time())
                print(target_item_name .. " suspended for " .. days)
                TriggerClientEvent("usa:notify", usource,  "You have suspended " .. target_player_name .. "'s " .. target_item_name .. " for " .. days .. " day(s).")
                TriggerClientEvent("usa:notify", target,  "Your " .. target_item_name .. " has been suspended for " .. days .. " day(s).")
				target_player.setActiveCharacterData("licenses", licenses)
                return
            end
        end
        print(target_player_name .. " had no " .. target_item_name .. "!")
        TriggerClientEvent("usa:notify", usource, target_player_name .. " had no " .. target_item_name .. "!")
	end
end, {
	help = "Suspend a driver's license or firearm permit",
	params = {
		{ name = "license type", help = "either FP or DL" },
		{ name = "id", help = "id of player" },
        { name  = "days", help = "# of days to suspend driver's license or firearm permit for"}
	}
})
--[[
TriggerClientEvent("usa:notify", usource, "You issued that person a " .. target_item_name .. "!")
TriggerClientEvent("usa:notify", usource, "You were issued a " .. target_item_name .. "!")

local licenses = user.getActiveCharacterData("licenses")
for i = 1, #licenses do
    local license =  licenses[i]
    if  license.name == "Firearm Permit" then
        licenses[i].status = status
        if status == "suspended" then
            licenses[i].suspension_start = os.time()
            licenses[i].suspension_days = days
            licenses[i].suspension_start_date = os.date('%m-%d-%Y %H:%M:%S', os.time())
        end
        print("gun permit set to: " .. status .. " for " .. days)
        user.setActiveCharacterData("licenses", licenses)
        return
    end
end
print("person had no firearm permit!")
]]

--[[
 /issue [type] [id]
/changesuspension [type] [id] [days]
/checksuspension [id]
/removesuspension [type] [id]

todo: add /suspend [type] [id] [days]
]]