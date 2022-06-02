fx_version 'bodacious'
game 'gta5'

description 'rcore spray'

version '1.1.0'


client_scripts {
	'config.lua',
	'client/warmenu.lua',
	'client/fonts.lua',
	'client/determinant.lua',
	'client/raycast.lua',
	'client/client.lua',
	'client/spray_rotation.lua',
	'client/control.lua',
	'client/remove.lua',
	'client/time.lua',
	'client/cancellable_progress.lua',
}

server_scripts {
	'config.lua',

	--'@mysql-async/lib/MySQL.lua',

	'server/bridge/*.lua',

	'server/mysql/ghmattimysql.lua',
	'server/mysql/disabledmysql.lua',

	'server/db.lua',
	'server/server.lua',
	'server/remove.lua',
}

lua54 "yes"

escrow_ignore {
	'config.lua',

	'server/bridge/*.lua',
	'server/mysql/*.lua',
	'server/*.lua',
	'client/*.lua',
}