local detectableItems = {'weed', 'cocaine', 'meth', 'pseudo', 'phosphorus'}

TriggerEvent('es:addJobCommand', 'k9', {'sheriff', 'police'}, function(source, args, user, location)
	TriggerClientEvent('k9:openMenu', source)
end, {
	help = "Open the K9 interaction menu",
})

RegisterServerEvent('k9:playAnimOnAll')
AddEventHandler('k9:playAnimOnAll', function(net, dict, anim, a, b, c, d, e)
	TriggerClientEvent('k9:playAnim', -1, net, dict, anim, a, b, c, d, e)
end)

RegisterServerEvent('k9:smellPlayer')
AddEventHandler('k9:smellPlayer', function(targetSource)
	local userSource = source
	local target = exports["essentialmode"]:getPlayerFromId(targetSource)
	local targetInv = target.getActiveCharacterData('inventory')
	for i = 1, #targetInv do
		local item = targetInv[i]
		if IsItemDetectable(item.name) or item.residue then
			TriggerClientEvent('k9:returnSmell', userSource)
			return
		end
	end
end)

RegisterServerEvent('k9:smellVehicle')
AddEventHandler('k9:smellVehicle', function(targetPlate)
	local userSource = source
	GetVehicleInventory(targetPlate, function(inv)
		for i = 1, #inv do
			local item = inv[i]
			if IsItemDetectable(item.name) or item.residue then
				TriggerClientEvent('k9:returnSmell', userSource)
				return
			end
		end
	end)
end)

function IsItemDetectable(itemName)
	for i = 1, #detectableItems do
		local item = detectableItems[i]
		if string.find(string.lower(itemName), item) then
			return true
		end
	end
	return false
end

function GetVehicleInventory(plate, cb)
	-- query for the information needed from each vehicle --
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehicleInventoryByPlate"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local inventory = {}
			--print("veh inventory: " .. responseText)
			local data = json.decode(responseText)
			if data.rows[1] then
				inventory = data.rows[1].value[1] -- inventory
			end
			cb(inventory)
		end
	end, "POST", json.encode({
		keys = { plate }
		--keys = { "86CSH075" }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end