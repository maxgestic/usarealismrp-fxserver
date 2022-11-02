local blackoutActive = false
local blackoutCars = false

-- Functions

function toggleBlackout(blackoutBool, carBool) -- Function to toggle blackout
	TriggerClientEvent("usa_blackout:triggerBlackoutClient", -1, blackoutBool, carBool)
    blackoutActive = blackoutBool
    blackoutCars = carBool
end

function stringToBool(string) -- Function to convert string to bool
	if string == "true" or string == "True" then
		return true
	elseif string == "false" or string == "False" then
		return false
	else
		return nil
	end
end

-- Events

RegisterServerEvent("usa_blackout:triggerBlackoutServer")  -- Server Event for other Scripts to use in the future
AddEventHandler("usa_blackout:triggerBlackoutServer", function(blackoutBool, carBool)
	toggleBlackout(blackoutBool, carBool)
end)

RegisterServerEvent("usa_blackout:sync")
AddEventHandler("usa_blackout:sync", function() -- Server Event to sync blackout state when client joins
	TriggerClientEvent("usa_blackout:triggerBlackoutClient", source, blackoutActive, blackoutCars)
end)

-- Commands

TriggerEvent('es:addGroupCommand', 'blackout', "admin", function(source, args, user) -- Admin Command to toggle blackout
    local enabled = stringToBool(args[2])
    local carLightsEnabled = stringToBool(args[3])

    if enabled == nil then
    	TriggerClientEvent("usa:notify", source, "You need to specify true or false for the blackout!")
    else
    	if carLightsEnabled == nil then
    		carLightsEnabled = true
    	end
    	toggleBlackout(enabled, carLightsEnabled)
    end
end,
	{
		help = "Enables or Disables Statewide Blackout",
		params = {
			{ name = "toggle city blackout", help = "true or false"},
            { name = "if headlights should be disabled by blackout (optional, true if not given)", help = "true or false" }
		}
	}
)

RegisterCommand("blackout", function(source, args, rawCommand) -- Console Command to troggle blackout
	if args[1] == nil then
		print("Invalid argmuents usage: blackout {true/false for blackout} {true/false for cars being blackouted}")
	else
		if source == 0 then
			local enabled = stringToBool(args[1])
	    	local carLightsEnabled = stringToBool(args[2])
	    	if carLightsEnabled == nil then
	    		carLightsEnabled = true
	    	end
			toggleBlackout(enabled, carLightsEnabled)
			print("Setting blackout to "..args[1].." and cars being blackouted (if blackout is on) to "..(args[2] or "true"))
		end
	end
end, false)
