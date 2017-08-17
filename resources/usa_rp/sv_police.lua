TriggerEvent('es:addCommand', 'ticket', function(source, args, user)
    --[[
    local targetPlayer = args[2]
    local amount = tonumber(args[3])
    local reason = args[3]
    Trigger
    --]]
end)

-- /dispatch
-- 911 DISPATCH
TriggerEvent('es:addCommand', 'dispatch', function(source, args, user)
	local userSource = tonumber(source)
	local target = args[2]
	table.remove(args,1)
	table.remove(args,1)
	TriggerClientEvent('chatMessage', target, "DISPATCH", {255, 20, 10}, table.concat(args, " "))
	TriggerClientEvent('chatMessage', userSource, "DISPATCH", {255, 20, 10}, table.concat(args, " "))
	-- set waypoint...
    print("setting waypoint with target = " .. target)
	TriggerClientEvent("dispatch:setWaypoint", userSource, tonumber(target))
end)
