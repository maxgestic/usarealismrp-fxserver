local GLOBAL_WEAPON_DAMAGE_MODIFIER = 0.6
local WEAPON_DAMAGE_MODIFIER_INTERVAL = 1000

local whatItShouldBeModifier = nil

local WEAPON_DAMAGE_MODIFIERS = {
  [`WEAPON_SNOWBALL`] = 0.1,
  [`WEAPON_MUSKET`] = 0.7,
  [`WEAPON_SNIPERRIFLE`] = 2.0,
  [`WEAPON_COMBATPISTOL`] = 1.2,
  [`WEAPON_PISTOL`] = 1.2,
  [`WEAPON_PISTOL_MK2`] = 1.2,
  [`WEAPON_HEAVYPISTOL`] = 1.1,
  [`WEAPON_PISTOL50`] = 1.3,
  [`WEAPON_REVOLVER`] = 0.7,
  [`WEAPON_MARKSMANPISTOL`] = 0.7,
  [`WEAPON_APPISTOL`] = 1.4,
  [`WEAPON_SNSPISTOL`] = 1.3,
  [`WEAPON_VINTAGEPISTOL`] = 1.2,
  [`WEAPON_MACHINEPISTOL`] = 1.3,
  [`WEAPON_MICROSMG`] = 1.8,
  [`WEAPON_SMG`] = 1.6,
  [`WEAPON_MINISMG`] = 1.9,
  [`WEAPON_SMG_MK2`] = 1.5,
  [`WEAPON_GUSENBERG`] = 1.3,
  [`WEAPON_COMPACTRIFLE`] = 1.4,
  [`WEAPON_ASSAULTRIFLE`] = 1.7,
  [`WEAPON_ASSAULTRIFLE_MK2`] = 1.5,
  [`WEAPON_CARBINERIFLE`] = 1.5,
  [`WEAPON_CARBINERIFLE_MK2`] = 1.5,
  [`WEAPON_HEAVYSHOTGUN`] = 0.5,
  [`WEAPON_PUMPSHOTGUN`] = 0.35,
  [`WEAPON_PUMPSHOTGUN_MK2`] = 0.35,
  [`WEAPON_SAWNOFFSHOTGUN`] = 0.30,
  [`WEAPON_BULLPUPSHOTGUN`] = 0.8,
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
        if GetSelectedPedWeapon(PlayerPedId()) ~= `WEAPON_UNARMED` then
          SetPlayerWeaponDamageModifier(PlayerId(), whatItShouldBeModifier)
          TriggerServerEvent("usa:notifyStaff", "ANTICHEAT: Player with ID #" .. GetPlayerServerId(PlayerId()) .. " has modified their weapon damage! It was reset to what it should be.")
        end
      end
    end
    Wait(1)
  end
end)