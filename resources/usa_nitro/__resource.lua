resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

name 'sw-nitro'
description 'The most advanced nitro system for FiveM'
author 'Deltanic - https://github.com/Deltanic/'
url 'https://github.com/swcfx/sw-nitro'

client_script 'client/utils.lua'
client_script 'client/fuel.lua'
client_script 'client/ptfx.lua'
client_script 'client/boost.lua'
client_script 'client/purge.lua'
client_script 'client/trails.lua'
client_script 'client/main.lua'
client_script 'client/gauge/gauge.lua'

server_script 'server/main.lua'
server_script 'server/gauge/gauge.lua'

ui_page 'client/gauge/gauge.html'

files {
    'client/gauge/*.html',
    'client/gauge/libs/*.js',
    'client/gauge/*.js',
}
