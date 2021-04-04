--[[
   Scripted By: Xander1998 (X. Cross)
--]]

resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/vue.min.js",
    "ui/script.js"
}

client_script "config.lua"
server_script "server.lua"
client_script "client.lua"
client_script "scaleform.lua"