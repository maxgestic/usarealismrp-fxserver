resource_type 'gametype' { name = 'usa_realism_rp' }

-- Manifest
resource_manifest_version 'f15e72ec-3972-4fe4-9c7d-afc5394ae207'

-- Requiring essentialmode
dependency 'essentialmode'

-- General
client_scripts {'client.lua', 'cl_police.lua'}
server_scripts {'server.lua', 'sv_police.lua'}
