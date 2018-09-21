-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

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
	'CanGroupTarget',
}

