resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

shared_script '@pmc-callbacks/import.lua'

-- Server
server_scripts {
	'server/server.lua',
	'@salty_tokenizer/init.lua'
}
-- Client
client_scripts {
	'client/hunt.lua',
	'client/furtrade.lua',
	'client/deliver_meat.lua',
	'@salty_tokenizer/init.lua'
}
