fx_version 'bodacious' 
games { 'gta5' } 

files {
    
    'data/**/weapons.meta',
	'data/**/weaponcomponents.meta',
    'data/**/weaponarchetypes.meta',
    'data/**/shop_weapon.meta',
    'data/**/weaponanimations.meta',
    'data/**/contentunlocks.meta',
	'data/**/loadouts.meta',
    'data/**/pedpersonality.meta',
}

data_file 'WEAPONINFO_FILE'          'data/**/weapons.meta'
data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE'  'data/**/weaponarchetypes.meta'
data_file 'WEAPON_SHOP_INFO'           'data/**/shop_weapon.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'data/**/weaponanimations.meta'
data_file 'CONTENT_UNLOCKING_META_FILE'   'data/**/contentunlocks.meta'
data_file 'LOADOUTS_FILE' 'data/**/loadouts.meta'
data_file 'PED_PERSONALITY_FILE'   'data/**/pedpersonality.meta'
