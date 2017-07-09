-- this is where you edit the message seen by end user

function helpText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) /help - this menu")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) /info - about the server")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) /commands - available commands")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) /discord - discord server link")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) /rules to see the server rules")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "If you want to become a cop or ems apply on the forums")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^WEBSITE/RULES: usarrp.enjin.com")
end

function infoText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0You will earn $250 every 10 minutes from welfare until you find another job.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^5Look at the icons on your map to see where gun, vehicles, clothing, etc stores are located")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Hold 'n' to talk in-game.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press 'e' to open the shop menu when at a store")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press ^2F5^0 then left/right arrow keys for emotes")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press ^2F6^0 to open your inventory")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press ^2F7^0 to open the players list")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^1WEBSITE/RULES: usarrp.enjin.com")
end

function commandsText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) ^3/me <msg>^0 - talks as yourself doing an action")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) ^3/ooc <msg>^0 - use this out of character")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) ^3/911 <msg>^0 - call 911, make sure to report a location and description")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) ^3/ad <msg>^0 - create an advertisement")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) ^3/text <id> <msg>^0 - send private message to someone")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) ^3/emote^0 to see more emotes")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) ^3/rules^0 to see the server rules")
end

-- end util functions / start commands

TriggerEvent('es:addCommand', 'help', function(source, args, user)
	helpText(source)
end)

TriggerEvent('es:addCommand', 'Help', function(source, args, user)
	helpText(source)
end)

TriggerEvent('es:addCommand', 'HELP', function(source, args, user)
	helpText(source)
end)

TriggerEvent('es:addCommand', 'info', function(source, args, user)
	infoText(source)
end)

TriggerEvent('es:addCommand', 'INFO', function(source, args, user)
	infoText(source)
end)

TriggerEvent('es:addCommand', 'commands', function(source, args, user)
	commandsText(source)
end)

TriggerEvent('es:addCommand', 'Commands', function(source, args, user)
	commandsText(source)
end)

TriggerEvent('es:addCommand', 'COMMANDS', function(source, args, user)
	commandsText(source)
end)

TriggerEvent('es:addCommand', 'discord', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "Discord: https://discord.gg/pFSZds8")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Join the discord channel for an up to date list of available commands.")
end)

TriggerEvent('es:addCommand', 'DISCORD', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "Discord: https://discord.gg/pFSZds8")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Join the discord channel for an up to date list of available commands.")
end)

TriggerEvent('es:addCommand', 'jobs', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) Cannabis transport  - $8,000 per 20g")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) Bank robbery	 	 - $20,000 to $70,000")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) Tow Truck Company	 - $500/car")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) Downtown Cab Co.	 - $900/10 min")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) more coming soon ...")
end)

TriggerEvent('es:addCommand', 'job', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) Cannabis transport  - $8,000 per 20g")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) Bank robbery	 	 - $20,000 to $70,000")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) Tow Truck Company	 - $500/car")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) Downtown Cab Co.	 - $900/10 min")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) more coming soon ...")
end)
