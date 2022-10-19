resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

shared_script '@pmc-callbacks/import.lua'

client_scripts {
    'client/cl_taser.lua',
    'client/cl_ammunition.lua',
    'client/WEP_EXTENDED_MAG_COMPONENTS.lua'
}
server_script 'server/sv_ammunition.lua'