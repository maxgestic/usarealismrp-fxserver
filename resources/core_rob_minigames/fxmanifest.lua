fx_version "cerulean"
game "gta5"
author "Nuno Radio Man"
description "[Robbery] Minigames"

lua54 'yes'

client_scripts{ 
    'cfg/*',
    'client/*',
}

escrow_ignore {
	'cfg/cfg.lua',
}
dependency '/assetpacks'