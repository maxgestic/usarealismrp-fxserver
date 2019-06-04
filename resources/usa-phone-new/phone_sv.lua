--# by: minipunch
--# for USA REALISM rp
--# Phone to make phone calls, send texts, and more with various apps

function CreateNewPhone(phone)
	TriggerEvent('es:exposeDBFunctions', function(db)
		db.createDocumentWithId("phones", phone, phone.number, function(success)
			if success then
				print("* Phone created!! *")
			else
				print("* Error: phone failed to be created!! *")
			end
		end)
	end)
end

RegisterServerEvent("phone:getPhone")
AddEventHandler("phone:getPhone", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local item = char.getItem("Cell Phone")
	if item then
		TriggerClientEvent("phone:openPhone", source, item)
	else
		TriggerClientEvent("usa:notify", source, "You have no cell phone!")
	end
end)

-- PERFORM FIRST TIME DB CHECK--
exports["globals"]:PerformDBCheck("usa-phone", "phones")
