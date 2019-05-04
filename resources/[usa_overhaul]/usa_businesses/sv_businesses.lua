exports["globals"]:PerformDBCheck("usa_businesses", "businesses")
RegisterServerEvent('businesses:updateBusinessData')
RegisterServerEvent('businesses:returnBusinessData')
RegisterServerEvent('businesses:createBusinessDocument')
RegisterServerEvent('businesses:resourceDatabaseCheck')

AddEventHandler('businesses:resourceDatabaseCheck', function(businessName, businessData)
	GetBusinessData(businessName, function(data)
		if not data then
			CreateBusinessDocument(businessName, businessData)
		end
	end)
end)

AddEventHandler('businesses:updateBusinessData', function(businessName, businessData)
	print(businessData.showroomData['slot1'].vehicleName)
	local data = businessData
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
        couchdb.updateDocument("businesses", businessName, data, function(success)
        	if success then
        		print("* business data updated["..businessName.."] *")
        	else
        		print("* Error: business data failed to update["..businessName.."]! *")
            end
        end)
    end)
end)

AddEventHandler('businesses:returnBusinessData', function(businessName, cb)
	GetBusinessData(businessName, function(business)
		cb(business)
	end)
end)

AddEventHandler('businesses:createBusinessDocument', function(businessName, businessData)
	CreateBusinessDocument(businessName, businessData)
end)

function GetBusinessData(businessName, cb)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
        couchdb.getDocumentById("businesses", businessName, function(data)
            if data then
                cb(data)
            else
            	cb(false)
            end
        end)
    end)
end

function CreateBusinessDocument(businessName, businessData)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
	    couchdb.createDocumentWithId("businesses", businessData, businessName, function(success)
	        if success then
	            print("* business data created["..businessName.."] *")
	        else
	            print("* Error: business data failed to create["..businessName.."]! * ")
	        end
	    end)
	end)
end
