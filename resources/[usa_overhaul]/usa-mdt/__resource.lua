--# by: minipunch
--# for USA REALISM RP

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/vue.min.js",
    "ui/script.js",
    "ui/sasp-badge.png",
    "ui/mdt-border.png"
}

client_script "cl_mdt.lua"
server_script "sv_mdt.lua"
