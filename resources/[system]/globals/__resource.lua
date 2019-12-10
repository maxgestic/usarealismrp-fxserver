resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

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
  "Draw3DTextForOthers",
  "DrawTimerBar",
  "dump",
  "loadAnimDict"
}

-- global server functions/tables
server_exports {
  "sendLocalActionMessage",
  "sendLocalActionMessageChat",
  "notifyPlayersWithJob",
  "notifyPlayersWithJobs",
  "setJob",
  "comma_value",
  "GetHoursFromTime",
  "GetSecondsFromTime",
  "SendDiscordLog",
  "replaceChar",
  "getCoordDistance",
  "dump"
}
