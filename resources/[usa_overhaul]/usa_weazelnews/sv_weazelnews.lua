
local vans_out = {}
local VAN_DEPOSIT_AMOUNT = 150
local BASE_PAY = 20

TriggerEvent('es:addJobCommand', 'cam', { "reporter" }, function(source, args, user, location)
	local userSource = source
    TriggerClientEvent("weazelnews:ToggleCam", userSource)
end, { help = "Take out or put away the camera" })

TriggerEvent('es:addJobCommand', 'mic', { "reporter" }, function(source, args, user, location)
	local userSource = source
    TriggerClientEvent("weazelnews:ToggleMic", userSource)
end, { help = "Take out or put away the microphone" })

local timeout = false
RegisterServerEvent("weazelnews:toggleDuty")
AddEventHandler("weazelnews:toggleDuty", function()
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local user_job = user.getActiveCharacterData("job")
		if user_job == "reporter" then
			print("WEAZEL_NEWS: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] is now OFF-DUTY for REPORTER")
			if vans_out[userSource] then
				vans_out[userSource] = nil
				TriggerClientEvent("weazelnews:notify", userSource, "You didn't return the van! I'm keeping the deposit.")
				--TriggerClientEvent("usa:notify", userSource, "You clocked out without returning the van?! Looks like I'm keeping your deposit.")
			else
				TriggerClientEvent("weazelnews:notify", userSource, "You are now clocked out!")
			end
			user.setActiveCharacterData("job", "civ")

			-- set a timeout to avoid spamming the job
			timeout = true
			SetTimeout(15000, function()
				timeout = false
			end)
		else
			if not timeout then
				print("WEAZEL_NEWS: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] is now ON-DUTY for REPORTER")
				TriggerClientEvent("weazelnews:notify", userSource, "You are now clocked in!")
				user.setActiveCharacterData("job", "reporter")
			else
				print("WEAZEL_NEWS: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] tried to go on-duty during timeout")
				TriggerClientEvent("usa:notify", userSource, "You are clocking in and out too fast!")
			end
		end
	--end)
end)

RegisterServerEvent("weazelnews:verifySpawnVan")
AddEventHandler("weazelnews:verifySpawnVan", function(locationName)
	local userSource = tonumber(source)
	if vans_out[userSource] then
		TriggerClientEvent("weazelnews:notify", userSource, "You already have a van checked out!")
		return
	end

	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_job = user.getActiveCharacterData("job")
	if user_job == "reporter" then
		local user_licenses = user.getActiveCharacterData("licenses")
		local found = false
		for i = 1, #user_licenses do
			local item = user_licenses[i]
			if string.find(item.name, "Driver's License") and item.status ~= "suspended" then
				local plate = generate_random_number_plate()

				-- take van deposit amount from player
				local user_money = user.getActiveCharacterData("money")
				if user_money < VAN_DEPOSIT_AMOUNT then
					TriggerClientEvent("weazelnews:notify", userSource, "You need $" .. VAN_DEPOSIT_AMOUNT .. " for the van deposit.")
					return
				end

				vans_out[userSource] = plate
				user.setActiveCharacterData("money", user_money - VAN_DEPOSIT_AMOUNT)
				print("WEAZEL_NEWS: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] has paid amount["..VAN_DEPOSIT_AMOUNT..'] for a VAN')
				TriggerClientEvent("weazelnews:notify", userSource, "Make sure to bring that van back!")
				TriggerClientEvent("weazelnews:spawnVan", userSource, locationName, plate)
				return
			end
		end
		-- if function reaches this point, then a license was not found or was suspended
		TriggerClientEvent("usa:notify", userSource, "Your driver's license is suspended or invalid.")
	end
end)

RegisterServerEvent('weazelnews:completeCall')
AddEventHandler('weazelnews:completeCall', function(distance)
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_money = user.getActiveCharacterData("money")
	local amountRewarded = math.ceil(BASE_PAY + (0.04 * distance))
	user.setActiveCharacterData("money", user_money + amountRewarded)
	TriggerClientEvent('usa:notify', userSource, 'Call completed, you have received: ~y~$'..amountRewarded..'.00')
	print("WEAZEL_NEWS: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] has received amount["..amountRewarded..'] after distance['..distance..'] for 911 call!')
end)

RegisterServerEvent("weazelnews:verifyReturnVan")
AddEventHandler("weazelnews:verifyReturnVan", function(plate)
	local userSource = source
	if vans_out[userSource] == plate then
		vans_out[userSource] = nil

		-- pay back van deposit
		local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local user_money = user.getActiveCharacterData("money")
		user.setActiveCharacterData("money", user_money + VAN_DEPOSIT_AMOUNT)

		TriggerClientEvent("weazelnews:returnVan", userSource)
	else
		TriggerClientEvent("weazelnews:notify", userSource, "That's not the van you checked out!")
	end
end)


RegisterServerEvent("weazelnews:checkPlate")
AddEventHandler("weazelnews:checkPlate", function(plateGiven)
	local userSource = source
	for key, plate in pairs(vans_out) do
		if plateGiven == plate then
			TriggerClientEvent("weazelnews:checkPlateDone", userSource, true)
			return
		end
	end
	TriggerClientEvent("weazelnews:checkPlateDone", userSource, false)
end)

function generate_random_number_plate()
	local charset = {
		numbers = {},
		letters = {}
	}
	-- QWERTYUIOPASDFGHJKLZXCVBNM1234567890
	for i = 48,  57 do table.insert(charset.numbers, string.char(i)) end -- add numbers 1 - 9
	for i = 65,  90 do table.insert(charset.letters, string.char(i)) end -- add capital letters
	local number_plate = ""
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	print("created random plate: ")
	return number_plate
end
