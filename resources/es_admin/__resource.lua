-- Manifest
resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

-- Requiring essentialmode
--dependency 'essentialmode'

client_script 'cl_admin.lua'
server_script 'sv_admin.lua'

server_exports {
    "BanPlayer"
}