-- this is where you edit the message seen by end user

function helpText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) /help - this menu")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) /info - about the server")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) /commands - available commands")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) /discord - discord server link")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) /rules to see the server rules")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "If you want to become a cop apply on the forums, or ask about volunteering EMS")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^WEBSITE/RULES: usarrp.enjin.com")
end

function infoText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0You will earn $250 every 10 minutes from welfare until you find another job.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^5Look at the icons on your map to see where gun, vehicles, clothing, etc stores are located.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Hold 'n' to talk in-game.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press 'e' to open the shop menu when at a store.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press ^2F1^0 to open your phone")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press ^2F5^0 then left/right arrow keys for emotes")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press ^2F6^0 to open your inventory")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press ^2F7^0 to open the players list")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^1WEBSITE/RULES: usarrp.enjin.com")
end

function commandsText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) ^3/myjob <msg>^0 - see who you are currently employed with")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) ^3/jobs  - List the available jobs")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) ^3/showid - Show your ID")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) ^3/report <msg>  - report someone include id")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) ^3/me <msg>^0 - talks as yourself doing an action")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) ^3/ooc <msg>^0 - use this out of character")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "7) ^3/givecash [id] [amount]^0 - to give cash")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "8) ^3/ad <msg>^0 - create an advertisement")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "9) ^3/rules^0 to see the server rules")
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
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) Tow Truck Company	 - $500/car + $445 per 10 min")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) Downtown Cab Co.	 - $900/10 min")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) more coming soon ...")
end)

TriggerEvent('es:addCommand', 'job', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) Cannabis transport  - $8,000 per 20g")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) Bank robbery	 	 - $20,000 to $70,000")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) Tow Truck Company	 - $500 per car + $445 per 10 min")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) Downtown Cab Co.	 - $650 per 10 min")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) Public service (i.e. police/ems)")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) anything else you can think of to RP as")
end)
