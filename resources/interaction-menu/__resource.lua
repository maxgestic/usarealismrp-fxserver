resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_scripts {
  "cl_interaction.lua",
  "cl_droppedItems.lua"
}
server_scripts {
  "sv_interaction.lua",
  "sv_droppedItems.lua"
}

ui_page 'ui/index.html'

files {
  'ui/index.html',
  'ui/js/jquery-ui.min.js',
  'ui/js/FitText.min.js',
  'ui/js/vue.min.js',
  'ui/js/script.js',
  'ui/css/style.css'
}
