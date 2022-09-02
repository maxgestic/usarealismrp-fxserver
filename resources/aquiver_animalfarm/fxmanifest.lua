
-- version: 1.0.1
-- * config.lua now only loads on serverside. 
-- * mysql dependency updated to mysql2 npm.
-- * new dev admin command: /farmatt (we needed it to modify the attachment position to hand, you can delete it from the commands.ts if you want.)
-- * added animation when filling water into the trough
-- * added animation when filling the milk into the barrel
-- * upgrading your farm did not remove the money from the player and did not even check it.
-- * new modelled water bucket (with low graphics the water was not visible because of the GTA rendering and i did not like that shit. 🤪 )
-- If you want to use the old one with the gta water, you need to change shared_attachments.ts file, avp_farm_bucket_newwater to avp_farm_bucket_02
-- * some translations were missing, i added them inside the shared-translations.ts

-- Two new functions for setting the attachment position without destroying the object on the player:
-- Server
-- resetAttachmentDefaultPosition: void;
-- setAttachmentOffset: void;

-- Client
-- setAttachmentOffset: void; 

-- version: 1.0.2
-- * Buying an animal did not remove the money from the player.
-- * Age variable could go over +100 and below 0 value.
-- * Mysql connection string got removed from the sharedConfig, it is only modifiable in the `server-database.ts` file.
-- * Custom models gave warnings in the client console. (fixed poly)

-- version:  1.0.3
-- * Pig weight was not increasing.
-- * Some calculations did not reduce but increase the animal age.
-- * Reduced the pig aging. (it was aging fast.)
-- * Config, animal balance changes.

-- version 1.0.4
-- * Chicken dead position fixed. (was under the ground)

-- version 1.0.5
-- * /farm command entirely moved to a custom NUI panel. (use /afarm command to open)
-- More information on our Discord.

-- version 1.0.6
-- * Water bucket could be picked up by multiple players if they pressed the interaction key at the same time.
-- * maximumWater / maximumFood config did not work well with the property setters. (Water could have not go over +100)
-- * Milk attachment (barrel) await fix.
-- * Eggchance generating was not working properly.
-- * Added the new database handler, so it should work with the server.cfg mysql_connection_string.

-- version 1.0.7
-- * Selling a farm to another player did not give the target player the money amount.

-- version 2.0
-- * Aquiver module added for easier framework setup
-- * .sql file changed (utf imports failed)
-- * export & import functions fixes
-- * other unmentionable fixes.

-- version 2.1
-- * Stable Aquiver Module SDK added.
-- * ChanceSDK got removed, less filesize we have on serverside so less % in resmon.

-- version 2.2
-- * Farm did not show up after creation, this was due to mispelled event name.
-- * Added version checker. (You can disable it in the server.ts file)

fx_version 'adamant'
game 'gta5'

version '2.2'
author 'freamee'
description 'Aquiver Farm with Aquiver module'

lua54 'yes'

server_scripts {
    'files/obf_server.lua',
    'files/server.js',
    'custom-framework-exports.lua'
}

client_scripts {
    'files/obf_client.lua',
    'files/client.js'
}

ui_page 'files/nui/index.html'

files {
    'files/nui/**',
}

file 'avp_farm_props_ytyp.ytyp'
data_file 'DLC_ITYP_REQUEST' 'avp_farm_props_ytyp.ytyp'

dependency '/assetpacks'