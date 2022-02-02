fx_version 'cerulean'
game 'gta5'
description 'AV Warehouse'
version '1.1.0'

lua54 'yes'
shared_script '@pmc-callbacks/import.lua'

client_scripts {
	'config.lua',
	'client/cl_hint.lua',
	'client/main.lua',
	'@salty_tokenizer/init.lua'
}

server_scripts {
	'config.lua',
	'server/main.lua',
	'@salty_tokenizer/init.lua'
}
