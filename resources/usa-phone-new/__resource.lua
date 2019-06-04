resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_script "phone_sv.lua"
client_script "phone_cl.lua"

ui_page 'ui/index.html'

files {
  'ui/index.html',
  'ui/js/vue.min.js',
  'ui/js/vue-router.min.js',
  'ui/App.vue',
  'ui/index.js',
  'ui/img/samsung-phone.png',
  'ui/css/w3.css',
  'ui/components/apps/Phone.vue'
}

server_exports {
  'CreateNewPhone'
}
