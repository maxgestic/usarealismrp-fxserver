--
-- Functions
--

function getMoney(playerId)
	local char = exports["usa-characters"]:GetCharacter(playerId)
	return char.get("money")
end

function addMoney(playerId, amount)
	local char = exports["usa-characters"]:GetCharacter(playerId)
	char.giveMoney(amount)
end

function removeMoney(playerId, amount)
	local char = exports["usa-characters"]:GetCharacter(playerId)
	if char.get("money") >= amount then
		char.removeMoney(amount)
		return true
	else
		return false
	end
end

function doesPlayerHaveValidLicense(playerId)
	local status = exports["usa_dmv"]:getLicenseStatus(playerId)
	if not status or status == "suspended" then
		return false
	else 
		return true
	end
end

--
-- Events
--

RegisterNetEvent('encore_trucking:loadDelivered')
AddEventHandler('encore_trucking:loadDelivered', function(totalRouteDistance)
	local playerId = source
	local payout   = math.floor(totalRouteDistance * Config.PayPerMeter)

	addMoney(playerId, payout)

	TriggerClientEvent('encore_trucking:helper:showNotification', playerId, 'Received ~g~$' .. payout .. '~s~ commission from trucking.')
end)

RegisterNetEvent('encore_trucking:rentTruck')
AddEventHandler('encore_trucking:rentTruck', function()
	local playerId = source

	if not doesPlayerHaveValidLicense(playerId) then
		TriggerClientEvent('encore_trucking:helper:showNotification', playerId, 'Your license is suspended!')
		return
	end

	if getMoney(playerId) < Config.TruckRentalPrice then
		TriggerClientEvent('encore_trucking:helper:showNotification', playerId, 'You do not have enough money to rent a truck.')
		return
	end

	if removeMoney(playerId, Config.TruckRentalPrice) then
		TriggerClientEvent('encore_trucking:startJob', playerId)
	else 
		TriggerClientEvent("usa:notify", playerId, "Not enough money for security deposit!")
	end
end)

RegisterNetEvent('encore_trucking:returnTruck')
AddEventHandler('encore_trucking:returnTruck', function()
	local playerId = source

	addMoney(playerId, Config.TruckRentalPrice)

	TriggerClientEvent('encore_trucking:helper:showNotification', playerId, 'Your $' .. Config.TruckRentalPrice .. ' deposit was returned to you.')
end)