fx_version 'adamant'
games { 'gta5' }

lua54 'yes'

client_scripts { 
	"cfg/config.lua",
	"client/client.lua",
	"client/functions.lua",
}
server_scripts { 
	"cfg/config.lua",
	"server/server.lua",
	"server/functions.lua",
}

escrow_ignore {
	'server/functions.lua',
	'client/functions.lua',
	'cfg/config.lua',
}
dependency '/assetpacks'