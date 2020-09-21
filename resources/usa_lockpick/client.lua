local loc = nil
local bank = nil
local shouldBePlayingAnim = false
local dictLoaded = false
local clearedAnim = false

local LOCKPICK_ANIM_DICT = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
local LOCKPICK_ANIM_NAME = "machinic_loop_mechandplayer"

RegisterNetEvent('lockpick:openlockpick')
AddEventHandler('lockpick:openlockpick', function(location, bankLoc)
	if location then
		loc = location
	elseif bankLoc then
		bank = bankLoc
	end
	SetNuiFocus( true, true )
	SendNUIMessage({
		showPlayerMenu = 'open'
	})
	shouldBePlayingAnim = true
	return
end)

RegisterNUICallback('lose', function()
	if loc then
		TriggerServerEvent('lockpick:removeBrokenPick', 'Lockpick')
	else
		TriggerServerEvent('lockpick:removeBrokenPick', 'Advanced Pick')
	end
end)

RegisterNUICallback('win', function()
	SetNuiFocus( false, false )
	SendNUIMessage({
		showPlayerMenu = 'close'
	})
	shouldBePlayingAnim = false
	if loc then
		TriggerServerEvent('properties:lockpickSuccessful', loc)
	else
		TriggerEvent('doormanager:advancedSuccess')
	end
end)

RegisterNetEvent('lockpick:closehtml')
AddEventHandler('lockpick:closehtml', function()
	SetNuiFocus(false, false)
	SendNUIMessage({
		showPlayerMenu = 'close'
	})
	shouldBePlayingAnim = false
end)

Citizen.CreateThread(function()
	while true do
		if shouldBePlayingAnim then
			if not dictLoaded then
				exports.globals:loadAnimDict(LOCKPICK_ANIM_DICT)
				dictLoaded = true
			end
			local myped = PlayerPedId()
			if not IsEntityPlayingAnim(myped, LOCKPICK_ANIM_DICT, LOCKPICK_ANIM_NAME, 3) then
				TaskPlayAnim(myped, LOCKPICK_ANIM_DICT, LOCKPICK_ANIM_NAME, 2.0, 2.0, -1, 51, 0, false, false, false)
				clearedAnim = false
            end
		else
			if not clearedAnim then
				local myped = PlayerPedId()
				ClearPedTasksImmediately(myped)
				clearedAnim = true
			end
		end
		Wait(0)
	end
end)