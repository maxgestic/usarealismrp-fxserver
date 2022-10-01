fx_version 'cerulean'
game 'gta5'

ui_page 'html/index.html'

files {
  "html/index.html",
  "html/*.js",
  "html/*.css"
}

client_scripts {
  "client/*.lua",
}

server_scripts {
  "server/*.lua",
}

export "taskBar"