local ACTIVE_EMERGENCY_PERSONNEL = {}

--[[
person = {
 src = 123,
 color = 3,
 name = "Taylor Weitman"
}
]]

-- TODO: check if person is on duty when they drop, if so remove them from the ACTIVE_EMERGENCY_PERSONNEL collection?

RegisterNetEvent("eblips:add")
AddEventHandler("eblips:add", function(person, activate)
	ACTIVE_EMERGENCY_PERSONNEL[person.src] = person
	for k, v in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
		--print("updating client: " .. k)
		TriggerClientEvent("eblips:updateAll", k, ACTIVE_EMERGENCY_PERSONNEL)
	end
	if activate then
		TriggerClientEvent("eblips:toggle", person.src, true)
	end
end)

RegisterNetEvent("eblips:remove")
AddEventHandler("eblips:remove", function(src)
	-- remove from list --
	ACTIVE_EMERGENCY_PERSONNEL[src] = nil
	-- update client blips --
	for k, v in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
		TriggerClientEvent("eblips:remove", tonumber(k), src)
	end
	-- deactive blips when off duty --
	TriggerClientEvent("eblips:toggle", src, false)
end)
