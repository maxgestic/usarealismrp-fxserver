fx_version 'cerulean'
game 'gta5'

author 'SirChainsmokerGollum'
description 'Trains'
version '1.0.0'

this_is_a_map "yes"

data_file "DLC_ITYP_REQUEST" "trainstations"

client_scripts {'client/*.lua'}

server_scripts {'server/*.lua'}

replace_level_meta 'gta5'
	files {
	'gta5.meta',
	'trains.xml'
}