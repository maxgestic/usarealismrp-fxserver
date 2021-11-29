fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'PlasmaGame'
version '3.1.0'
author 'Sarish'


ui_page 'html/index.html'

files {
	'html/index.html',
	'html/*.jpg',
	'html/script.js',
	'html/style.css',
	'img/Scoreboard_Death_Match.png'
	-- 'WeaponData/dlctext.meta',
	-- 'WeaponData/pedpersonalitySPR.meta',
	-- 'WeaponData/weaponarchetypesSPR.meta',
	-- 'WeaponData/weaponanimationsSPR.meta',
	-- 'WeaponData/weaponSPR.meta',
	-- 'WeaponData/weapons.meta'
}

server_scripts {
	'config.lua',
	"server.lua"
}

client_scripts {
	"NativeUI.lua",
	-- 'WeaponData/weaponnames.lua',
	'config.lua',
    'client.lua'
}

-- data_file 'WEAPON_METADATA_FILE'   'WeaponData/weaponarchetypesSPR.meta'
-- data_file 'WEAPON_ANIMATIONS_FILE' 'WeaponData/weaponanimationsSPR.meta'
-- data_file 'WEAPONINFO_FILE'        'WeaponData/weaponSPR.meta'
-- data_file 'WEAPONINFO_FILE_PATCH'  'WeaponData/weapons.meta'
-- data_file 'TEXTFILE_METAFILE'      'WeaponData/dlctext.meta'
-- data_file 'PED_PERSONALITY_FILE'   'WeaponData/pedpersonalitySPR.meta'
