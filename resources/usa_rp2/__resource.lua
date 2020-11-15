resource_type 'gametype' { name = 'usa_realism_rp' }

-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
}

-- Requiring essentialmode
dependency 'essentialmode'

-- General
client_scripts {'client.lua', 'cl_police.lua', 'cl_ems.lua', 'cl_civ.lua',  'cl_judge.lua'}
server_scripts {'config.lua', 'server.lua', 'sv_police.lua', 'sv_ems.lua', 'sv_civ.lua', 'sv_judge.lua'}

exports {
  "areHandsTied",
  "areHandsUp",
  "isBlindfolded"
}

server_exports {
  "handlePlayerDropDutyLog"
}
