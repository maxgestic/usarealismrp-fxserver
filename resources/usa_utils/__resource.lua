resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "commerce/ui/index.html"

files {
    "commerce/ui/index.html",
    "commerce/ui/css/CHome.css",
    "commerce/ui/js/vue.min.js",
    "commerce/ui/js/components/CHome.js",
    "commerce/ui/js/App.js",
    "commerce/ui/js/eventListener.js"
}

client_scripts { 
    "screenshots/cl_screenshots.lua",
    'commerce/client/*.lua',
    'antimodder/cl_commerce.lua',
    'antilynx/config_c.lua',
    'antilynx/lcac_c.lua'
}

server_scripts {
    'sessionmonitor.lua',
    'screenshots/sv_screenshots.lua',
    'commerce/server/*.lua',
    'antimodder/sv_antimodder.lua',
   'antilynx/lcac_s.lua'
}

server_exports {
    "SendServerMonitorDiscordMsg",
    "SendPreRestartServerMonitorDiscordMsg",
    "RunPreRestartSaveEvents"
}