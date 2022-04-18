local GLOBAL_WEAPON_DAMAGE_MODIFIER = 0.6
local WEAPON_DAMAGE_MODIFIER_INTERVAL = 1000

local whatItShouldBeModifier = nil

local WEAPON_DAMAGE_MODIFIERS = {
  [`WEAPON_MUSKET`] = 0.4,
  [`WEAPON_SNIPERRIFLE`] = 1.0,
  [`WEAPON_SNOWBALL`] = 0.1
}

-- GLOBAL WEAPON DAMAGE MODIFIER:
Citizen.CreateThread(function()
  local lastSelectedWeapon = nil
  local lastCheck = 0
  while true do
    if GetGameTimer() - lastCheck >= WEAPON_DAMAGE_MODIFIER_INTERVAL then
      lastCheck = GetGameTimer()
      local currentSelected = GetSelectedPedWeapon(PlayerPedId())
      if not lastSelectedWeapon or lastSelectedWeapon ~= currentSelected then
        lastSelectedWeapon = currentSelected
        whatItShouldBeModifier = (WEAPON_DAMAGE_MODIFIERS[currentSelected] or GLOBAL_WEAPON_DAMAGE_MODIFIER)
        SetPlayerWeaponDamageModifier(PlayerId(), whatItShouldBeModifier)
      end
    end
    Wait(1)
  end
end)

-- 'modified weapon damage' anti cheat
Citizen.CreateThread(function()
  local lastCheck = 0
  while true do
    if whatItShouldBeModifier and GetGameTimer() - lastCheck >= WEAPON_DAMAGE_MODIFIER_INTERVAL then
      lastCheck = GetGameTimer()
      local currentGlobalModifier = GetPlayerWeaponDamageModifier(PlayerId())
      currentGlobalModifier = tonumber(string.format("%.3f", currentGlobalModifier))
      if currentGlobalModifier ~= whatItShouldBeModifier then
        SetPlayerWeaponDamageModifier(PlayerId(), whatItShouldBeModifier)
        TriggerServerEvent("usa:notifyStaff", "ANTICHEAT: Player with ID #" .. GetPlayerServerId(PlayerId()) .. " has modified their weapon damage! It was reset to what it should be.")
      end
    end
    Wait(1)
  end
end)