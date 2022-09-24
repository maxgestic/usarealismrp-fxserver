-- These weapons will have their reticle enabled
Config = {
    Weapons = {},
    Crosshair = {
        Enabled = false
    }
}

Config.Weapons = {}
Config.Weapons.Reticle = {
	[`WEAPON_SNIPERRIFLE`] = true,
	[`WEAPON_HEAVYSNIPER`] = true,
	[`WEAPON_HEAVYSNIPER_MK2`] = true,
	[`WEAPON_MARKSMANRIFLE`] = true,
	[`WEAPON_MARKSMANRIFLE_MK2`] = true
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		-- If weapon does not require reticle, remove reticle
		if not Config.Crosshair.Enabled and not Config.Weapons.Reticle[GetSelectedPedWeapon(PlayerPedId())] and not IsPedInAnyVehicle(PlayerPedId(), true) then
			HideHudComponentThisFrame(14)
		end

		-- Hide weapon icon
		HideHudComponentThisFrame(2)
		-- Hide weapon wheel stats
		HideHudComponentThisFrame(20)
		-- Hide hud weapons
		HideHudComponentThisFrame(22)
	end
end)

RegisterNetEvent("inferno-weapons:toggleCrosshair") 
AddEventHandler("inferno-weapons:toggleCrosshair", function(status)
	if not status then status = not Config.Crosshair.Enabled end
	Config.Crosshair.Enabled = status
	if status then
		exports.globals:notify("Crosshair enabled")
	else
		exports.globals:notify("Crosshair disabled")
	end
end)

Citizen.CreateThread(function()
	Config.Crosshair.Enabled = TriggerServerCallback { 
		eventName = "inferno-weapons:fetchCrosshairSetting",
		args = {}
	}
end)