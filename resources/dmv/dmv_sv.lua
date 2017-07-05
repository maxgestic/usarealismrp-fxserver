RegisterServerEvent("dmv:checkMoney")
AddEventHandler("dmv:checkMoney", function(price)
	print("inside check money")
	local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		if user.get("money") >= price then
			local idents = GetPlayerIdentifiers(userSource)
			local playerMoney = user.get("money")
			local newPlayerMoney = playerMoney - price
            TriggerEvent('es:exposeDBFunctions', function(usersTable)
                usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
                    docid = result._id
					if not result.driversLicense then
						local timestamp = os.date("*t", os.time())
						local license = {
							name = "Driver's License",
							number = "F" .. tostring(math.random(1, 2543678)),
							quantity = 1,
							ownerName = GetPlayerName(userSource),
							expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
							status = "valid"
						}
						usersTable.updateDocument("essentialmode", docid ,{driversLicense = license, money = newPlayerMoney},function() end)
						user.removeMoney(tonumber(price))
						TriggerClientEvent("dmv:notify", userSource, "You have ~g~successfully~w~ purchased a driver's license.")
					else
						TriggerClientEvent("dmv:notify", userSource, "You already have a driver's license!")
					end
                end)
            end)
		else
			TriggerClientEvent("dmv:notify", userSource, "You don't have enough money to purchase a driver's license!")
		end
	end)
end)
