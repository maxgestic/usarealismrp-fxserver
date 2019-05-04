licensePrices = {
	["Driver's License"] = 500,
	["Firearm Permit"] = 2000,
	["Bar Certificate"] = 15000,
	["Boat License"] = 5000,
	["Aircraft License"] = 7500
}

--------------------
-- EVENT HANDLERS --
--------------------
RegisterServerEvent("judge:duty")
AddEventHandler("judge:duty", function()
  local usource = source
  local user = exports["essentialmode"]:getPlayerFromId(usource)
  local user_job = user.getActiveCharacterData("job")
  local user_judge_rank = user.getActiveCharacterData("judgeRank")
  if not user_judge_rank then
    TriggerClientEvent("usa:notify", usource, "You are not whitelisted for Judge!")
    return
  end
  if user_job ~= "judge" and user_judge_rank > 0 then
	   local user_char_name = user.getActiveCharacterData("fullName")
     user.setActiveCharacterData("job", "judge")
     TriggerClientEvent("usa:notify", usource, "You are now in service as a Judge.")
	   TriggerClientEvent('chatMessage', -1, "", {0, 0, 0}, "^6^*[COURTHOUSE] ^r^7A Judge is now available for all legal affairs!")
  else
    user.setActiveCharacterData("job", "civ")
    TriggerClientEvent("usa:notify", usource, "You are now out of service as a Judge.")
  end
end)

-----------------------------
-- LAWYER / JUDGE COMMANDS --
-----------------------------
TriggerEvent('es:addJobCommand', 'removesuspension', {'judge', 'sheriff'}, function(source, args, user)
	print("removing suspension")
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local target_item_name = nil
    -- check SGT + rank for police --
    if user.getActiveCharacterData("job") == "sheriff" then
        if user.getActiveCharacterData("policeRank") < 4 then
            TriggerClientEvent("usa:notify", usource, "Not high enough rank!")
            return
        end
    end
	if type and GetPlayerName(target) then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		end
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local licenses = target_player.getActiveCharacterData("licenses")
        local player_name = target_player.getActiveCharacterData("fullName")
		for i = 1, #licenses do
			if licenses[i].name == target_item_name then
				if licenses[i].status == "suspended" then
					licenses[i].status = "valid"
					target_player.setActiveCharacterData("licenses", licenses)
					TriggerClientEvent("usa:notify", target, "Your " .. target_item_name .. " has been ~g~reinstated~s~!")
					TriggerClientEvent("usa:notify", usource, "You reinstated " .. player_name .. "'s ~y~" .. target_item_name .. "~s~!")
					return
				end
			end
		end
		TriggerClientEvent('usa:notify', usource, "License not found on person, or is not suspended!")
		return
	end
end, {
	help = "Remove a license suspension.",
	params = {
		{ name = "license type", help = "either BL, AL or DL" },
		{ name = "id", help = "id of player" }
	}
})

TriggerEvent('es:addJobCommand', 'checksuspensions', {'judge', 'sheriff'}, function(source, args, user)
	print("checking suspension")
	local usource = source
	local target = tonumber(args[2])
	local target_item_name = nil
	local found = false
	if GetPlayerName(target) then
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local licenses = target_player.getActiveCharacterData("licenses")
	    local user_name = target_player.getActiveCharacterData("fullName")
	    local user_dob = target_player.getActiveCharacterData('dateOfBirth')
	    TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^*^7---------------------------------------")
	    TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Name: ^r^7" .. user_name)
		for i = 1, #licenses do
			if licenses[i].status == "suspended" then
				TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*License: ^r^7" .. licenses[i].name)
		        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Status: ^r^1" .. licenses[i].status)
		        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Duration: ^r^7" .. licenses[i].suspension_days .. ' day(s)')
		        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Start Date: ^r^7" .. licenses[i].suspension_start_date)
		        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^*^7---------------------------------------")
		        found = true
			end
		end
		if not found then
			TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^0No licenses or suspensions found on that person.")
			TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^*^7---------------------------------------")
		end
	end
end, {
	help = "Check the status of a person's licenses.",
	params = {
		{ name = "id", help = "id of player" }
	}
})

TriggerEvent('es:addJobCommand', 'checklicense', {'judge', 'lawyer', 'sheriff'}, function(source, args, user)
	print("checking individual license")
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local target_item_name = nil
	if type and GetPlayerName(target) then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		elseif type == 'fp' then
			target_item_name = 'Firearm Permit'
		elseif type == 'bar' then
			target_item_name = 'Bar Certificate'
		end
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local licenses = target_player.getActiveCharacterData("licenses")
	    local user_name = target_player.getActiveCharacterData("fullName")
	    local user_dob = target_player.getActiveCharacterData('dateOfBirth')
	    for i = 1, #licenses do
	    	if licenses[i].name == target_item_name then
			    TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^*^7---------------------------------------")
			    TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Name: ^r^7" .. user_name)
			    TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Date of Birth: ^r^7" .. user_dob)
		        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*License: ^r^7" .. licenses[i].name)
		        if licenses[i].status == 'suspended' then
		        	TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Status: ^r^1" .. licenses[i].status)
			        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Duration: ^r^7" .. licenses[i].suspension_days .. ' day(s)')
			        TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Start Date: ^r^7" .. licenses[i].suspension_start_date)
			    else
			    	TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Status: ^r^2" .. licenses[i].status)
				end
				if licenses[i].issued_by then
		        	TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Issuer: ^r^7" .. licenses[i].issued_by)
		        end
		        if licenses[i].expire then
		        	TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3^*Expires: ^r^7" .. licenses[i].expire)
		        end
				TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^*^7---------------------------------------")
				return
			end
		end
		TriggerClientEvent('chatMessage', usource, "", {0, 0, 0}, "^3"..user_name..' ^7does not own a ^3'..target_item_name..'^7.')
		return
	end
end, {
	help = "Check the information of a person's individual license.",
	params = {
		{ name = 'license type', help = 'either FP, AL, BL, BAR, or DL'},
		{ name = "id", help = "id of player" }
	}
})

TriggerEvent('es:addJobCommand', 'citynotify', {'judge'}, function(source, args, user)
	table.remove(args,1)
	local msg = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "", {0, 0, 0}, "^3^*[SAN ANDREAS COURT] ^r^7"..msg)
end, {
	help = "Send a state-wide announcement.",
	params = {
		{ name = "message", help = "message to be sent" }
	}
})

TriggerEvent('es:addJobCommand', 'expunge', {'sheriff', 'judge'}, function(source, args, user)
	local targetSource = tonumber(args[2])
	local recordid = args[3]
	if user.getActiveCharacterData("job") == "sheriff" then
        if user.getActiveCharacterData("policeRank") < 4 then
            TriggerClientEvent("usa:notify", usource, "Not high enough rank!")
            return
        end
    end
	if targetSource and GetPlayerName(targetSource) and recordid then
		local target = exports["essentialmode"]:getPlayerFromId(targetSource)
		local history = target.getActiveCharacterData("criminalHistory")
		for i = 1, #history do
			local offence = history[i]
			if offence.number == recordid then
				table.remove(history, i)
				TriggerClientEvent('usa:notify', source, 'Offence ~y~'..offence.number..'~s~ has been expunged from ~y~'..target.getActiveCharacterData('fullName')..'~s~!')
				target.setActiveCharacterData("criminalHistory", history)
				return
			end
		end
		TriggerClientEvent('usa:notify', source, 'Offence not found!')
	else
		TriggerClientEvent('usa:notify', source, 'Incorrect usage!')
	end
end, {
	help = "Expunge a record from a person.",
	params = {
		{ name = "id", help = "id of player" },
		{ name = "recordid", help = "record number" }
	}
})


-- todo: finish below
TriggerEvent('es:addJobCommand', 'changesuspension', {'judge'}, function(source, args, user)
	print("changing suspension")
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local days = tonumber(args[4])
	local target_item_name = nil
    -- check SGT + rank for police --
    if user.getActiveCharacterData("job") == "sheriff" then
        if user.getActiveCharacterData("policeRank") < 4 then
            TriggerClientEvent("usa:notify", usource, "Not high enough rank!")
            return
        end
    end
	if type and GetPlayerName(target) and days then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		end
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local licenses = target_player.getActiveCharacterData("licenses")
        local player_name = target_player.getActiveCharacterData("fullName")
		for i = 1, #licenses do
			if licenses[i].name == target_item_name then
				if licenses[i].status == "suspended" then
					licenses[i].suspension_days = days
					target_player.setActiveCharacterData("licenses", licenses)
					TriggerClientEvent("usa:notify", target, "Your ~y~" .. target_item_name .. " suspension~s~ was modified to end in ~y~" .. days .. " day(s)~s~.")
					TriggerClientEvent("usa:notify", usource, "You changed " .. player_name .. "'s ~y~" .. target_item_name .. "~s~ suspension to end in ~y~" .. days .. " day(s)~s~.")
					return
				end
			end
		end
		TriggerClientEvent('usa:notify', usource, 'License not found on person, or is not suspended!')
		return
	end
end, {
	help = "Alter a license suspension.",
	params = {
		{ name = "license type", help = "either BL, AL or DL" },
		{ name = "id", help = "id of player" },
		{ name = "days", help = "days to set license suspension to" },
	}
})

TriggerEvent('es:addJobCommand', 'issue', {'judge', 'sheriff'}, function(source, args, user)
	print("removing suspension")
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local target_item_name = nil
	local target_item = nil
	local isPolice
    -- check SGT + rank for police --
    if user.getActiveCharacterData("job") == "sheriff" then
        if user.getActiveCharacterData("policeRank") < 4 then
            TriggerClientEvent("usa:notify", usource, "Not high enough rank!")
            return
        else
        	isPolice = true
        end
    end
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
				ownerDob = target_player.getActiveCharacterData("dateOfBirth"),
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid",
				notDroppable = false,
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
				ownerDob = target_player.getActiveCharacterData('dateOfBirth'),
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid",
				notDroppable = false,
				type = "license"
			}
		elseif type == 'bl' then
			if isPolice then
				return
			else
				target_item_name = "Boat License"
				target_item = {
					name = 'Boat License',
					number = 'BL' .. tostring(math.random(1, 254367)),
					quantity = 1,
					ownerName = target_player.getActiveCharacterData('fullName'),
					issued_by = user.getActiveCharacterData('fullName'),
					ownerDob = target_player.getActiveCharacterData('dateOfBirth'),
					expire = timestamp.month .. '/' .. timestamp.day .. '/' ..timestamp.year + 1,
					status = 'valid',
					notDroppable = false,
					type = 'license'
				}
			end
		elseif type == 'al' then
			if isPolice then
				return
			else
				target_item_name = "Aircraft License"
				target_item = {
					name = 'Aircraft License',
					number = 'AL' .. tostring(math.random(1, 254367)),
					quantity = 1,
					ownerName = target_player.getActiveCharacterData('fullName'),
					issued_by = user.getActiveCharacterData('fullName'),
					ownerDob = target_player.getActiveCharacterData('dateOfBirth'),
					expire = timestamp.month .. '/' .. timestamp.day .. '/' ..timestamp.year + 1,
					status = 'valid',
					notDroppable = false,
					type = 'license'
				}
			end
		elseif type == 'bar' then
			if isPolice then
				return
			else
				target_item_name = 'Bar Certificate'
				target_item = {
					name = 'Bar Certificate',
					number = 'B' .. tostring(math.random(1, 254367)),
					quantity = 1,
					ownerName = target_player.getActiveCharacterData('fullName'),
					issued_by = user.getActiveCharacterData('fullName'),
					ownerDob = target_player.getActiveCharacterData('dateOfBirth'),
					expire = timestamp.month .. '/' .. timestamp.day .. '/' ..timestamp.year + 3,
					status = 'valid',
					notDroppable = true,
					type = 'license'
				}
			end
		end
		local licenses = target_player.getActiveCharacterData("licenses")
        local player_name = target_player.getActiveCharacterData("fullName")
		for i = 1, #licenses do
			if licenses[i].name == target_item_name then
				TriggerClientEvent("usa:notify", usource, player_name .. " already has a ~y~" .. target_item_name .. "~s~!")
				return
			end
		end
		-- not found at this point, issue it to them --
		local judgeMoney = user.getActiveCharacterData('money')
		local amountPaid = nil
		for license, price in pairs(licensePrices) do
			if license == target_item_name then
				if judgeMoney - price >= 0  then
					amountPaid = price
					user.setActiveCharacterData('money', judgeMoney - price)
				else
					TriggerClientEvent('usa:notify', usource, 'You require ~y~$'..price..'.00~s~ to issue this license.')
					return
				end
			end
		end
		table.insert(licenses, target_item)
		target_player.setActiveCharacterData("licenses", licenses)
		TriggerClientEvent("usa:notify", usource, "You issued a ~y~" .. target_item_name .. "~s~ to " .. player_name .. " for ~y~$"..amountPaid..'.00~s~!')
		TriggerClientEvent("usa:notify", target, "You were issued a ~y~" .. target_item_name .. "~s~!")
	end
end, {
	help = "Issue a license to a person (COLLECT MONEY FIRST).",
	params = {
		{ name = "license type", help = "either FP, BL, AL, BAR, or DL" },
		{ name = "id", help = "id of player" }
	}
})

-- TODO: check if police rank is SGT + for use of below command ...
TriggerEvent('es:addJobCommand', 'suspend', {'judge', "sheriff"}, function(source, args, user)
	print("adding suspension")
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
    local days = tonumber(args[4])
	local target_item_name = nil
    -- check SGT + rank for police --
    if user.getActiveCharacterData("job") == "sheriff" then
        if user.getActiveCharacterData("policeRank") < 4 then
            TriggerClientEvent("usa:notify", usource, "Not high enough rank!")
            return
        end
    end
	if type and GetPlayerName(target) then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		elseif type == 'bar' then
			target_item_name = "Bar Certificate"
		end
		if target_item_name then
			local target_player = exports["essentialmode"]:getPlayerFromId(target)
			local licenses = target_player.getActiveCharacterData("licenses")
	        local target_player_name = target_player.getActiveCharacterData("fullName")
	        for i = 1, #licenses do
	            local license =  licenses[i]
	            if license.name == target_item_name then
	            	if license.status ~= 'suspended' then
		                licenses[i].status = "suspended"
		                licenses[i].suspension_start = os.time()
		                licenses[i].suspension_days = days
		                licenses[i].suspension_start_date = os.date('%m-%d-%Y %H:%M:%S', os.time())
		                print(target_item_name .. " suspended for " .. days)
		                TriggerClientEvent("usa:notify", usource,  "You have suspended " .. target_player_name .. "'s ~y~" .. target_item_name .. "~s~ for ~y~" .. days .. " day(s)~s~.")
		                TriggerClientEvent("usa:notify", target,  "Your ~y~" .. target_item_name .. "~s~ has been ~y~suspended~s~ for ~y~" .. days .. " day(s)~s~.")
						target_player.setActiveCharacterData("licenses", licenses)
		                return
		            else
		            	TriggerClientEvent('usa:notify', usource, 'This license is already suspended!')
		            	return
		            end
	            end
	        end
	    end
        TriggerClientEvent("usa:notify", usource, "License type not found!")
        return
	end
end, {
	help = "Suspend a person's license.",
	params = {
		{ name = "license type", help = "either BL, AL or DL"},
		{ name = "id", help = "id of player" },
        { name  = "days", help = "# of days to suspend license for"}
	}
})

TriggerEvent('es:addJobCommand', 'revoke', {'judge', 'sheriff'}, function(source, args, user)
	print('revoking a license')
	local usource = source
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local target_item_name = nil
    -- check SGT + rank for police --
    if user.getActiveCharacterData("job") == "sheriff" then
        if user.getActiveCharacterData("policeRank") < 4 then
            TriggerClientEvent("usa:notify", usource, "Not high enough rank!")
            return
        end
    end
	if type and GetPlayerName(target) then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		elseif type == 'fp' then
			target_item_name = 'Firearm Permit'
		elseif type == 'bar' then
			target_item_name = 'Bar Certificate'
		end
		local target_player = exports["essentialmode"]:getPlayerFromId(target)
		local licenses = target_player.getActiveCharacterData("licenses")
        local target_player_name = target_player.getActiveCharacterData("fullName")
        for i = 1, #licenses do
            local license =  licenses[i]
            if license.name == target_item_name then
            	table.remove(licenses, i)
				target_player.setActiveCharacterData("licenses", licenses)
				TriggerClientEvent("usa:notify", usource,  "You have revoked " .. target_player_name .. "~s~'s ~y~" .. target_item_name .. "~s~.")
	            TriggerClientEvent("usa:notify", target,  "Your ~y~" .. target_item_name .. "~s~ has been revoked.")
	            return
            end
        end
        print(target_player_name .. " had no " .. target_item_name .. "!")
        TriggerClientEvent("usa:notify", usource, target_player_name .. " had no ~y~" .. target_item_name .. "~s~!")
        return
	end
end, {
	help = "Revoke a person's license.",
	params = {
		{ name = "license type", help = "either FP, BL, AL, BAR or DL"},
		{ name = "id", help = "id of player" }
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
