resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_scripts {
  'client/classes/String.lua',
  'client/classes/Blip.lua',
  'client/classes/Marker.lua',
  'client/classes/Scenes.lua',
  'client/classes/Vector.lua',
  'client/classes/Vehicle.lua',
  'client/classes/Scaleforms.lua',

  'client/scripts/BlipHandler.lua',
  'client/scripts/MarkerHandler.lua',
  'client/scripts/Networking.lua',
  'client/scripts/Streaming.lua',
  'client/scripts/Teleporter.lua',
  'client/scripts/Notifications.lua',
  'client/scripts/Controls.lua',
  'client/scripts/VehicleProperties.lua',
}

server_scripts {
  'server/classes/String.lua',  
  'server/classes/Table.lua',  
  'server/classes/Json.lua',  

  'server/scripts/Utilities.lua',
  'server/scripts/_.lua',
}