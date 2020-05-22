Citizen.CreateThread(function()
	local CodeEnteredCorrect = false
	while true do
		Citizen.Wait(0)
		local PlayerPos = GetEntityCoords(PlayerPedId(), true)
		local Terminal = {['x'] = 253.3081, ['y'] = 228.4226, ['z'] = 101.6833}
		local VaultDoor = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, 961976194, 0, 0, 0)
		if VaultDoor ~= nil and VaultDoor ~= 0 then
			FreezeEntityPosition(VaultDoor, true)
			if Vdist(PlayerPos.x, PlayerPos.y, PlayerPos.z, Terminal.x, Terminal.y, Terminal.z) <= 0.5 then
				if not CodeEnteredCorrect and CodeNeeded then
					DisplayHelpText('Press ~INPUT_CONTEXT~ to enter the unlock Code')
					if GetIsControlJustReleased(51) and UpdateOnscreenKeyboard() ~= 0 then
						local EnteredCode = KeyboardInput('Enter the Code', '', Code:len() + 10, false)
						if EnteredCode then
							if EnteredCode:lower() == Code:lower() then
								drawNotification('~g~The entered Code is correct!')
								CodeEnteredCorrect = true
							else
								drawNotification('~r~The entered Code is not correct!')
								CodeEnteredCorrect = false
							end
						end
					end
				elseif CodeEnteredCorrect or not CodeNeeded then
					local CurrentHeading = GetEntityHeading(VaultDoor)
					if round(CurrentHeading, 1) == 158.7 then
						CurrentHeading = CurrentHeading - 0.1
					end
					if round(CurrentHeading, 1) ~= 0.0 and round(CurrentHeading, 1) ~= 160.0 then
						DisplayHelpText('Hold ~INPUT_CELLPHONE_LEFT~ to Open the Vault~n~Hold ~INPUT_CELLPHONE_RIGHT~ to Close the Vault')
					elseif round(CurrentHeading, 1) == 0.0 then
						DisplayHelpText('Hold ~INPUT_CELLPHONE_RIGHT~ to Close the Vault')
					elseif round(CurrentHeading, 1) == 160.0 then
						DisplayHelpText('Hold ~INPUT_CELLPHONE_LEFT~ to Open the Vault')
					end
					while GetIsControlPressed(174) and round(CurrentHeading, 1) ~= 0.0 do -- Open
						Citizen.Wait(0)
						SetEntityHeading(VaultDoor, round(CurrentHeading, 1) - Speed)
						CurrentHeading = GetEntityHeading(VaultDoor)
					end
					while GetIsControlPressed(175) and round(CurrentHeading, 1) ~= 160.0 do -- Close
						Citizen.Wait(0)
						SetEntityHeading(VaultDoor, round(CurrentHeading, 1) + Speed)
						CurrentHeading = GetEntityHeading(VaultDoor)
					end
				end
			else
				CodeEnteredCorrect = false
			end
		end
	end
end)

function DisplayHelpText(Text)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(Text)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function drawNotification(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, true)
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function GetIsControlJustReleased(Control)
	if IsControlJustReleased(1, Control) or IsDisabledControlJustReleased(1, Control) then
		return true
	end
	return false
end

function GetIsControlPressed(Control)
	if IsControlPressed(1, Control) or IsDisabledControlPressed(1, Control) then
		return true
	end
	return false
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght, NoSpaces)
	AddTextEntry(GetCurrentResourceName() .. '_KeyboardHead', TextEntry)
	DisplayOnscreenKeyboard(1, GetCurrentResourceName() .. '_KeyboardHead', '', ExampleText, '', '', '', MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		if NoSpaces == true then
			drawNotification('~y~NO SPACES!')
		end
		Citizen.Wait(0)
	end
	
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

