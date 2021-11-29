fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'PlasmaCTF'
version '1.0.0'
author 'Sarish'


files {
	'img/Scoreboard_Capture_the_Orb.png',
	'img/Blue_Orb.png',
	'img/Red_Orb.png'
}

server_scripts {
	'@PlasmaGame/config.lua',
	"server.lua"
}

client_scripts {
	'@PlasmaGame/config.lua',
    'client.lua'
}

