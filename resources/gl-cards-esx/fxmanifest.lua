fx_version 'bodacious'
game 'gta5'

author 'Kallock - The Goodlife RP Server'
version '1.0.0'
lua54 'yes'

escrow_ignore {
    'client.lua',
    'server.lua',
    'shared.lua',
}

client_script {
    'client.lua',

}

server_script {
    'server.lua',
}

shared_script 'shared.lua'

ui_page "html/index.html"

files {
    "html/index.html",
    "html/index.js",
    "html/index.css",
    "html/reset.css",
    "html/bttn.min.css",
    'html/images/*.png',
    'html/images/*.gif',
    'html/images/*.jpg'
}
dependency '/assetpacks'