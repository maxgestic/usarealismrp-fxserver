fx_version 'cerulean'
game 'gta5'

lua54 'yes'

escrow_ignore {
    'config.lua',
    'client/menu.lua',
    'client/framework/esx.lua',
    'client/framework/qbcore.lua',
    'client/framework/custom.lua',
    'client/framework/no_framework.lua',
    'server/framework/esx.lua',
    'server/framework/qbcore.lua',
    'server/framework/custom.lua',
    'server/framework/no_framework.lua',
    'server/db/bridge.lua',
    'server/db/api.lua',
    'stream/*',
}

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/framework/esx.lua',
    'client/framework/qbcore.lua',
    'client/framework/custom.lua',
    'client/framework/no_framework.lua',
    'client/client.lua',
    'client/editor.lua',
    'client/sticker.lua',
    'client/utils.lua',
    'client/menu.lua',
    'client/tooltip.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/framework/esx.lua',
    'server/framework/qbcore.lua',
    'server/framework/custom.lua',
    'server/framework/no_framework.lua',
    'server/db/bridge.lua',
    'server/db/api.lua',
    'server/utils.lua',
    'server/server.lua',
}

dependencies {
    '/server:4752',
    '/onesync',
}
dependency '/assetpacks'