resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
}

client_scripts {
  'cl_trunkhide.lua',
}

server_script 'sv_trunkhide.lua'

exports {
    "IsInTrunk"
}
