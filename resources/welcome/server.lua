-- this is where you edit the message seen by end user

function helpText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) /help - this menu")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) /info - about the server")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) /commands - available commands")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) /discord - discord server link")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^WEBSITE/RULES: usarrp.enjin.com")
end

function infoText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^0You will earn $250 every 10 minutes from welfare until you find another job.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^5Look at the icons on your map to see where gun, vehicles, clothing, etc stores are located")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Hold 'n' to talk in-game.")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Press F1 then left/right arrow keys for emotes")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^1WEBSITE/RULES: usarrp.enjin.com")
end

function commandsText(source)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) ^3/loadout help^0 - see all available character loadouts")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) ^3/pv^0 - spawn currently owned personal vehicle")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) ^3/dv^0 - delete vehicle")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) ^3/spawn^0 - spawn work vehicles")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) ^3/me <msg>^0 - talks as yourself doing an action")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "6) ^3/911 <msg>^0 - call 911, make sure to report a location and description")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "7) ^3/text <id> <msg>^0 - send private message to someone")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "8) ^3Press 'e' to open the shop menu when at a store")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "9) ^3Press ^2NUM7^0 then left/right arrow keys for emotes")
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
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) Cannabis transport - $1000 per run")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) Bank Robbery		- $45000 per run")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) Tow truck driver 	- $350 per car")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) Public service (cop, ems, fire)")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) more coming soon ...")
end)

TriggerEvent('es:addCommand', 'job', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "1) Cannabis transport - $1000 per run")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "2) Bank Robbery		- $45000 per run")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "3) Tow truck driver 	- $350 per car")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "4) Public service (cop, ems, fire)")
	TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "5) more coming soon ...")
end)
