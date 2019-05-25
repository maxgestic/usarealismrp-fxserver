RegisterServerEvent("insurance:buyInsurance")
AddEventHandler("insurance:buyInsurance", function(userSource)
	--print("user source = " .. userSource)
	local INSURANCE_COVERAGE_MONTHLY_COST = 500
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local insurance = user.getActiveCharacterData("insurance")
	local user_money = user.getActiveCharacterData("money")
	if user_money >= INSURANCE_COVERAGE_MONTHLY_COST then
		local insurancePlan = {
			planName = "LifeInvader Auto Insurance",
			type = "auto",
			valid = true,
			purchaseDate = os.date('%m-%d-%Y %H:%M:%S', os.time()),
			purchaseTime = os.time()
		}
		user.setActiveCharacterData("insurance", insurancePlan)
		print("taking $" .. INSURANCE_COVERAGE_MONTHLY_COST .. " from player for auto insurance!")
		user.setActiveCharacterData("money", user_money - INSURANCE_COVERAGE_MONTHLY_COST)
		TriggerClientEvent("usa:notify", userSource, "~w~Thanks for purchasing auto insurance coverage! Your coverage expires in ~y~31~w~ days.")
	else
		print("player did not have enough money to buy insurance")
		TriggerClientEvent("usa:notify", userSource, "You ~r~don't have enough money~w~ to buy auto insurance coverage!")
	end
end)

RegisterServerEvent("insurance:fileClaim")
AddEventHandler("insurance:fileClaim", function(vehicle_to_claim)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_bank = user.getActiveCharacterData("bank")
	local BASE_FEE = 100
	local PERCENTAGE = .03
	local CLAIM_PROCESSING_FEE = math.floor(BASE_FEE + (PERCENTAGE * vehicle_to_claim.price))
	if CLAIM_PROCESSING_FEE <= user_bank then
		-- set vehicle stats --
		TriggerEvent('es:exposeDBFunctions', function(couchdb)
		    couchdb.updateDocument("vehicles", vehicle_to_claim.plate, {inventory = {}, stored = true, impounded = false}, function()
				print("** Vehicle updated in DB! **")
				-- remove money --
				user.setActiveCharacterData("bank", user_bank - CLAIM_PROCESSING_FEE)
				-- notifiy --
				if vehicle_to_claim.make and vehicle_to_claim.model then
					TriggerClientEvent("usa:notify", userSource, "Filed an insurance claim for your " .. vehicle_to_claim.make .. " " .. vehicle_to_claim.model .. ".\n~y~Fee:~w~ $" .. CLAIM_PROCESSING_FEE)
				else
					TriggerClientEvent("usa:notify", userSource, "Filed an insurance claim for your " .. vehicle_to_claim.model .. ".\n~y~Fee:~w~ $" .. CLAIM_PROCESSING_FEE)
				end
				-- remove vehicle damages if any --
				TriggerClientEvent("garage:removeDamages", userSource, vehicle_to_claim.plate)
			end)
		end)
	else
		TriggerClientEvent("usa:notify", userSource, "You don't have enough money to make a claim on that vehicle.")
	end
end)

-- for claim --
RegisterServerEvent("insurance:loadVehicles")
AddEventHandler("insurance:loadVehicles", function(check_insurance)
	local vehicles_to_send = {}
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if check_insurance then
		local user_insurance = user.getActiveCharacterData("insurance")
		if user_insurance.type == "auto" then
			-- get the plates of the desired vehicles to use in the query --
			local vehicles = user.getActiveCharacterData("vehicles")
			-- query for the information needed from each vehicle --
			local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehiclesForMenuWithPlates"
			local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
			PerformHttpRequest(url, function(err, responseText, headers)
				if responseText then
					local responseVehArray = {}
					--print(responseText)
					local data = json.decode(responseText)
					if data.rows then
						for i = 1, #data.rows do
							local veh = {
								make = data.rows[i].value[1], -- make
								model = data.rows[i].value[2], -- model
								price = data.rows[i].value[3], -- price
								stored = data.rows[i].value[4], -- 'stored' bool value
								stored_location = data.rows[i].value[5], -- stored_location
								plate = data.rows[i].value[6] -- plate
							}
							if not veh.stored then
								table.insert(responseVehArray, veh)
							end
						end
					end
					-- send vehicles to client for displaying --
					print("# of vehicles loaded for menu: " .. #responseVehArray)
					TriggerClientEvent("insurance:loadedVehicles", userSource, responseVehArray, true)
				end
			end, "POST", json.encode({
				keys = vehicles
				--keys = { "86CSH075" }
			}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
		else
			print("player has no auto insurance!")
			TriggerClientEvent("chatMessage", userSource, "LIFEINVADER INSURANCE", {255, 78, 0}, "You do not have any auto insurance! Can't make a claim!")
			TriggerClientEvent("insurance:loadedVehicles", userSource, vehicles_to_send, true)
		end
	end
end)

RegisterServerEvent("insurance:checkPlayerInsurance")
AddEventHandler("insurance:checkPlayerInsurance", function()
	print("checking for auto insurance!")
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local playerInsurance = user.getActiveCharacterData("insurance")
	if playerInsurance.type == "auto" then
		print("found player auto insurance!")
		if playerHasValidAutoInsurance(playerInsurance) then
			TriggerClientEvent("usa:notify", userSource, "You are already insured!")
		else
			print("renewing auto insurance!")
			TriggerClientEvent("usa:notify", userSource, "Your auto insurance coverage was ~r~expired~w~! Renewing...")
			TriggerEvent("insurance:buyInsurance", userSource)
		end
	else
		print("no auto insurance found!")
		TriggerEvent("insurance:buyInsurance", userSource)
	end
end)

function playerHasValidAutoInsurance(playerInsurance)
	local timestamp = os.date("*t", os.time())
		if playerInsurance.type == "auto" then
			local reference = playerInsurance.purchaseTime
			local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
			local wholedays = math.floor(daysfrom)
			print(wholedays) -- today it prints "1"
			if wholedays < 32 then
				return true -- valid insurance, it was purchased 31 or less days ago
			else
				return false
			end
		else
			-- no insurance at all
			return false
		end
end