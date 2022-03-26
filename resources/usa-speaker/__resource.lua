resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'cl_*.lua',
    '@salty_tokenizer/init.lua'
}

server_scripts {
    'sv_*.lua',
    '@salty_tokenizer/init.lua'
}

ui_page "html/main.html"

files {
    "html/main.html",
    "html/*.js",
    "html/*.css"
}