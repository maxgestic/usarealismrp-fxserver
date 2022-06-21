fx_version 'cerulean'
game 'gta5'

shared_script '@pmc-callbacks/import.lua'

client_scripts {
    'client/utils.lua',
    'client/presets.lua',
    'client/client.lua',
    'client/bigScreen.lua',
    
    'client/screens/*.lua',
    '@salty_tokenizer/init.lua'
}

server_scripts {
    'server/server.lua',
    '@salty_tokenizer/init.lua'
}