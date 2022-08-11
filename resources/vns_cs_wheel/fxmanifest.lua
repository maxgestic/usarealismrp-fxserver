fx_version 'adamant'
game 'gta5'
description 'VNS Lucky Wheel'
version '1.5.8'
lua54 'yes'

shared_script '@pmc-callbacks/import.lua'

server_scripts {
  'locales/*.lua',
	'config.lua',
	'server.lua',
  '@salty_tokenizer/init.lua'
}

client_scripts {
  'locales/*.lua',
	'config.lua',
	'client.lua',
  '@salty_tokenizer/init.lua'
}

escrow_ignore {
  '**/*',
  '*',
}
dependency '/assetpacks'