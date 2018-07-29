client_script 'cl_global.lua'
server_script 'sv_global.lua'

-- global client functions/tables
exports {
  'notify',
  'EnumerateObjects',
  'EnumeratePeds',
  'EnumerateVehicles',
  'EnumeratePickups',
}

-- global server functions/tables
server_exports {
  "notifyPlayersWithJob",
  "notifyPlayersWithJobs",
  "setJob"
}
