client_script 'cl_global.lua'
server_script 'sv_global.lua'

-- global client functions/tables
exports {
  'notify',
  'EnumerateObjects',
  'EnumeratePeds',
  'EnumerateVehicles',
  'EnumeratePickups',
  'GetUserInput',
  "MaxItemTradeDistance",
  "MaxTackleDistance",
  "comma_value",
  "Draw3DTextForOthers"
}

-- global server functions/tables
server_exports {
  "sendLocalActionMessage",
  "sendLocalActionMessageChat",
  "notifyPlayersWithJob",
  "notifyPlayersWithJobs",
  "setJob",
  "comma_value",
  "GetHoursFromTime"
}
