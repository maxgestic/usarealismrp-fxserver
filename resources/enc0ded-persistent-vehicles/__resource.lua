resource_manifest_version  '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description 'Enc0ded Persistent Vehicles: https://github.com/enc0ded/enc0ded-persistent-vehicles'

version '1.0.0'

client_scripts {
	'config.lua',
	'client/entityiter.lua',
	'client/_utils.lua',
	'client/main.lua',
}

server_scripts {
	'config.lua',
	'server/main.lua',
}
