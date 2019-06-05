resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_scripts {
    "@NativeUI/NativeUI.lua",
    "robberies/cl_robbery.lua",
    "cl_businesses.lua"
}

server_scripts {
  "robberies/sv_robbery.lua",
  "sv_businesses.lua"
}

shared_scripts {
  "config.lua"
}
