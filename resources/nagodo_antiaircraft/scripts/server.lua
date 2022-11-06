RegisterServerCallback {
	eventName = 'antiaircraft:checkJob',
	eventCallback = function(source)		
		local char = exports["usa-characters"]:GetCharacter(source)
        if char == nil then
            print("Player loading in")
        else
            return char.get("job")
        end
	end
}

RegisterServerCallback {
	eventName = "antiaircraft:numCopsOn",
	eventCallback = function(source)
		local waiting = true
		local retVal = nil
		exports.globals:getNumCops(function(numCops)
			retVal = numCops
			waiting = false
		end)
		while waiting do
			Wait(1)
		end
		return retVal
	end
}