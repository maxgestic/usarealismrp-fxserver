-- this is where you edit the message seen by end user

function helpText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) ^3/help^0 - this menu")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) ^3/info^0 - about the server")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) ^3/commands^0 - available commands")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) ^3/discord^0 - discord server link")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) ^3/rules^0 - to see the server rules")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3WEBSITE/RULES: ^0usarrp.enjin.com")
end

function infoText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0You will earn $250 every 10 minutes from welfare until you find another job.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^5Look at the icons on your map to see where gun, vehicles, clothing, etc stores and jobs are located.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Hold 'n' (default) to talk in-game.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press 'e' to open the shop menu when at a store.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press ^2F1^0 to the interaction menu.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press ^2F7^0 to open the players list.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Type ^2/commands^0 to see more commands.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3WEBSITE/RULES: ^0usarrp.enjin.com")
end

function commandsText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) ^3/myjob <msg>^0 - see who you are currently employed with")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) ^3/quitjob^0 - quit current transport job")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) ^3/waypoint^0 - reset waypoint for current transport job")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) ^3/jobs^0 - List the available jobs")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) ^3/showid^0 - Show your ID")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) ^3/report <msg>^0 - report someone include id")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "7) ^3/me <msg>^0 - talks as yourself doing an action")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "8) ^3/ooc <msg>^0 - use this out of character")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "9) ^3/givecash [id] [amount]^0 - to give cash")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "10) ^3/ad <msg>^0 - create an advertisement")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "11) ^3/rules^0 - to see the server rules")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "12) ^3F1^0 - open interaction menu")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "12) ^3F5^0 - extra emotes menu")
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
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Join the discord channel to keep up with the community!")
end)

TriggerEvent('es:addCommand', 'DISCORD', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "Discord: https://discord.gg/pFSZds8")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Join the discord channel to keep up with the community!")
end)

TriggerEvent('es:addCommand', 'jobs', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) Cannabis transport")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) FridgeIt trucking")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) GoPostal transport")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) Bank Tobbery")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) Bubba's Tow Truck Company")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) Downtown Taxi Co.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) Convience store robberies")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "7) Create/sell methamphetamines")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "8) anything else you can RP with :)")
end)

TriggerEvent('es:addCommand', 'jobs', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) Cannabis transport")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) FridgeIt trucking")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) GoPostal transport")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) Bank Tobbery")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) Bubba's Tow Truck Company")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) Downtown Taxi Co.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) Convience store robberies")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "7) Create/sell methamphetamines")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "8) anything else you can RP with :)")
end)
