resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/css/CHome.css",
    "ui/css/CNewRace.css",
    "ui/js/vue.min.js",
    "ui/js/components/CNewRace.js",
    "ui/js/components/CHome.js",
    "ui/js/App.js",
    "ui/js/eventListener.js"
}

client_scripts { 
    'cl_races.lua'
}

server_scripts {
    'sv_races.lua'
}