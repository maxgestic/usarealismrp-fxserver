
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Kanersps/Minipunch'
description 'EssentialMode base by Kanersps. Modified by minipunch for USA REALISM RP.'

ui_page 'ui.html'

-- Server
server_scripts {
	'sv_es-DB-config.lua',
	'server/util.lua',
	'server/main.lua',
	'server/db.lua',
	'server/classes/player.lua',
	'server/classes/groups.lua',
	'server/player/login.lua'
}

-- Client
client_scripts {
	'client/main.lua'
}

-- NUI Files
files {
	'ui.html',
	'pdown.ttf'
}

server_exports {
	'getPlayerFromId',
	'addAdminCommand',
	'addCommand',
	'addGroupCommand',
	'getCommands',
	'CanGroupTarget'
}
