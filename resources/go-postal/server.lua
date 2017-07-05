local activeJobs = {}

RegisterServerEvent("postal:giveMoney")
AddEventHandler("postal:giveMoney", function(amount)
	local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		user.addMoney(amount)
		local oldMoney = user.get("money")
		user.set("money", oldMoney + amount)
		TriggerEvent('es:exposeDBFunctions', function(usersTable)
			local idents = GetPlayerIdentifiers(userSource)
			usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
				docid = result._id
				print("docid = " .. docid)
				print("result.money = " .. result.money)
				print("amount = " .. amount)
				local newMoney = result.money + amount
				print("saving new money with newMoney = " .. newMoney)
				usersTable.updateDocument("essentialmode", docid ,{money = newMoney},function() end)
			end)
		end)
	end)
end)

RegisterServerEvent("postal:addJob")
AddEventHandler("postal:addJob", function(job)
	activeJobs[source] = job
end)

TriggerEvent('es:addCommand', 'gopostal', function(source, args, user)
	if activeJobs[source] == nil then
		TriggerClientEvent('chatMessage', source, "Go Postal", {0, 255, 0}, "You're not currently working for Go Postal. Please return to one of our facilities to start your next job.")
	else
		TriggerClientEvent('chatMessage', source, "Go Postal", {0, 255, 0}, "You're current job has been placed on your map.")
		TriggerClientEvent('placeMarker', source, activeJobs[source].x, activeJobs[source].y)
	end
end)
