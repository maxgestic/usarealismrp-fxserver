resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

server_scripts  {
  "classes/VehInventoryManager.lua",
  "sv_vehicle-inventories.lua"
}

server_exports {
  'GetVehicleInventory',
  'setVehicleBusy',
  'getVehicleBusy',
  'removeVehicleBusy',
  'NewInventory'
}
