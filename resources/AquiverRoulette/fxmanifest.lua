-- Version 2.0.1
-- * Added clientside encryption against script leakers.
-- * On multiply number bets payout was not always correct and pushed players in a big ass array, now the winamounts are adding up together.
-- * In roulett version 1 (lua version) when the player left the table, he still received the winnings, in the version 2 it was a bug that the player did not receive it after he stood up.
-- * getPlayerChips, removePlayerChips and other functions which was events in the previous version, now they are export function(s), for easier understanding and we do not need a callback with it from now on.

-- Warn: If your Roulette resource name is not AquiverRoulette after this update then the resource will not start for you properly!

-- Issues/Bugs reported by: @Sojobo.

fx_version 'adamant'

game 'gta5'

description 'Aquiver Roulette'
author 'freamee'
version '2.0.1'

server_scripts {
    'sv_config.lua',
    'server/server-roulette.js'
}

client_scripts {
    'client/e_client.lua',
    'client/client-roulette.js'
}

lua54 'yes'

escrow_ignore {
    'sv_config.lua'
}

dependencies {
    '/server:4752',
    '/gameBuild:sum',
}


ui_page 'html/index.html'
files {'html/**'}
dependency '/assetpacks'