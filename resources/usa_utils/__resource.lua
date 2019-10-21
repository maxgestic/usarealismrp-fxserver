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
    --"screenshots/cl_screenshots.lua",
    --'commerce/cl_commerce.lua'
    "**/cl_*.lua"
}

server_scripts {
    'sessionmonitor.lua',
    --'screenshots/sv_screenshots.lua',
    --'commerce/sv_commerce.lua'
    "**/sv_*.lua"
}

server_exports {
    "SendServerMonitorDiscordMsg",
    "SendPreRestartServerMonitorDiscordMsg"
}