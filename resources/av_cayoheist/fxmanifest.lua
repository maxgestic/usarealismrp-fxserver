fx_version 'cerulean'
game 'gta5'
description 'AV Cayo Heist'
version '2.0.0'
lua54 'yes'
shared_script '@pmc-callbacks/import.lua'

client_scripts {
	'config.lua',
	'client/*.lua',
	'functions/*.lua',
	'@salty_tokenizer/init.lua'
}

server_scripts {
	'config.lua',
	'server/*.lua',
	'@salty_tokenizer/init.lua'
}

escrow_ignore {
  'config.lua',
  'client/*.lua',
  'server/server_editable.lua',
}

dependencies {
    '/server:4752', -- requires at least server build 4752
	'/gameBuild:h4', -- requires at least game build 2189
}

