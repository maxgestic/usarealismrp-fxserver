resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

shared_scripts {
    "@pmc-callbacks/import.lua"
}

server_scripts {
    '@salty_tokenizer/init.lua',
    'bank-robbery_sv.lua'
}

client_scripts {
    '@salty_tokenizer/init.lua',
    "@PolyZone/client.lua",
    'bank-robbery_cl.lua',
    'safecracking.lua'
}
