resource_type 'gametype' { name = 'usa_realism_rp' }

-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/cursor.png'
}

-- Requiring essentialmode
dependency 'essentialmode'

-- General
client_scripts {'client.lua', 'cl_police.lua', 'cl_ems.lua', 'cl_crim.lua', 'cl_jobs.lua'}
server_scripts {'server.lua', 'sv_police.lua', 'sv_ems.lua', 'sv_crim.lua', 'sv_jobs.lua'}
