-- this is where you edit the message seen by end user

function helpText(source)
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "^0You will earn $250 every 10 minutes from welfare until you find another job.")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "Look at the icons on your map to see where jobs available jobs are.")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "You can get a cell phone at the general store. You can use it to call for a taxi, towtruck, police, EMS, etc")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "Once you have one, do F1 > Cell Phone > Use to open it.")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "1) ^3/help^0 - this menu")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "2) ^3/commands^0 - available commands")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "3) ^3/discord^0 - discord server link")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "4) ^3/rules^0 - to see the server rules")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "^3WEBSITE: ^0https://www.usarrp.net")
end

function commandsText(source)
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "1) ^3/myjob <msg>^0 - see who you are currently employed with")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "2) ^3/quitjob^0 - quit current transport job")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "3) ^3/waypoint^0 - reset waypoint for current transport job")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "4) ^3/jobs^0 - List the available jobs")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "5) ^3/showid^0 - Show your ID")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "6) ^3/report <msg>^0 - report someone include id")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "7) ^3/me <msg>^0 - talks as yourself doing an action")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "8) ^3/givecash [id] [amount]^0 - to give cash")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "9) ^3/ad <msg>^0 - create an advertisement")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "10) ^3/tweet <msg>^0 - create a tweet message")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "11) ^3F1^0 - open interaction menu")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "12) ^3Press ^2F3^0 to open the players list, see ID #'s'")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "13) ^3Press ^2F2^0 to toggle your voip level")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "14) ^3Press ^2U^0 to lock/unlock vehicles")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "15) ^3/open [option]^0 options: hood, trunk, fr, fl, br, bl, ambulance")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "16) ^3/close [option]^0 options: hood, trunk, fr, fl, br, bl, ambulance")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "17) ^3/engine [option]^0 options: on, off")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "18) Open chat with ''^3T^0' then use ^3Page Up^0 to scroll up")
end

-- end util functions / start commands

--[[
TriggerEvent('es:addCommand', 'help', function(source, args, user)
	helpText(source)
end, {help = "Show help commands."})
--]]

TriggerEvent('es:addCommand', 'commands', function(source, args, user)
	commandsText(source)
end, {help = "Show some server commands. (Full list on website)"})

TriggerEvent('es:addCommand', 'discord', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "Discord: https://discord.gg/pFSZds8")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "^3Join the discord channel to keep up with the community!")
end, {help = "View the server's discord link."})

TriggerEvent('es:addCommand', 'jobs', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "1) Cannabis transport")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "2) FridgeIt trucking")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "3) GoPostal transport")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "4) Bank Robbery")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "5) Bubba's Tow Truck Company")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "5) Fishing")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "7) Downtown Taxi Co.")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "8) Convience store robberies")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "9) Create/sell methamphetamines")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "10) Anything else you can think of to RP :)")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "11) Police and EMS are both whitelisted. You can apply for it at https://www.usarrp.net")
end, {help = "Show some of the available jobs."})
