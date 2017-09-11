RegisterNetEvent('printEmoteHelp')
RegisterNetEvent('printInvalidEmote');
RegisterNetEvent('printEmoteList');
RegisterNetEvent('playCopEmote');
RegisterNetEvent('playSitEmote');
RegisterNetEvent('playChairEmote');
RegisterNetEvent('playKneelEmote');
RegisterNetEvent('playMedicEmote');
RegisterNetEvent('playNotepadEmote');
RegisterNetEvent('playTrafficEmote');
RegisterNetEvent('playPhotoEmote');
RegisterNetEvent('playClipboardEmote');
RegisterNetEvent('playLeanEmote');
RegisterNetEvent('playHangOutEmote');
RegisterNetEvent('playPotEmote');
RegisterNetEvent('playFishEmote');
RegisterNetEvent('playPhoneEmote');
RegisterNetEvent('playYogaEmote');
RegisterNetEvent('playBinocularsEmote');
RegisterNetEvent('playCheeringEmote');
RegisterNetEvent('playStatueEmote');
RegisterNetEvent('playJogEmote');
RegisterNetEvent('playFlexEmote');
RegisterNetEvent('playSitUpEmote');
RegisterNetEvent('playPushUpEmote');
RegisterNetEvent('playWeldingEmote');
RegisterNetEvent('playMechanicEmote');

currently_playing_emote = false;

playing_cop_emote = false;
playing_sit_emote = false;
playing_chair_emote = false;
playing_kneel_emote = false;
playing_medic_emote = false;
playing_notepad_emote = false;
playing_traffic_emote = false;
playing_photo_emote = false;
playing_clipboard_emote = false;
playing_lean_emote = false;
playing_hangout_emote = false;
playing_pot_emote = false;
playing_fish_emote = false;
playing_phone_emote = false;
playing_yoga_emote = false;
playing_bino_emote = false;
playing_cheering_emote = false;
playing_statue_emote = false;
playing_jog_emote = false;
playing_flex_emote = false;
playing_situp_emote = false;
playing_pushup_emote = false;
playing_welding_emote = false;
playing_mechanic_emote = false;

AddEventHandler('printEmoteHelp', function()
	TriggerEvent('chatMessage', "^4Emotes", {255, 0, 0}, "^2cop, bino, sit, chair, kneel, medic, notepad, traffic, photo, clipboard, lean, hangout, pot, fish, phone, yoga, cheering, statue, jog, flex, situp, pushup, weld, mechanic");
end)

AddEventHandler('printInvalidEmote', function()
	TriggerEvent('chatMessage', "^4ALERT", {255, 0, 0}, "^1Invalid emote specified, use /emotes");
end)

-- TO ADD:

AddEventHandler('playMechanicEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_mechanic_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_VEHICLE_MECHANIC", 0, true);
			playing_mechanic_emote = true;
		elseif playing_mechanic_emote == true then
			ClearPedTasks(ped);
			playing_mechanic_emote = false;
		end
	end
end)

AddEventHandler('playWeldingEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_welding_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true);
			playing_welding_emote = true;
		elseif playing_welding_emote == true then
			ClearPedTasks(ped);
			playing_welding_emote = false;
		end
	end
end)

AddEventHandler('playPushUpEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_pushup_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_PUSH_UPS", 0, true);
			playing_pushup_emote = true;
		elseif playing_pushup_emote == true then
			ClearPedTasks(ped);
			playing_pushup_emote = false;
		end
	end
end)

AddEventHandler('playSitUpEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_situp_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SIT_UPS", 0, true);
			playing_situp_emote = true;
		elseif playing_situp_emote == true then
			ClearPedTasks(ped);
			playing_situp_emote = false;
		end
	end
end)

AddEventHandler('playFlexEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_flex_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_MUSCLE_FLEX", 0, true);
			playing_flex_emote = true;
		elseif playing_flex_emote == true then
			ClearPedTasks(ped);
			playing_flex_emote = false;
		end
	end
end)

AddEventHandler('playJogEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_jog_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_JOG_STANDING", 0, true);
			playing_jog_emote = true;
		elseif playing_jog_emote == true then
			ClearPedTasks(ped);
			playing_jog_emote = false;
		end
	end
end)

AddEventHandler('playStatueEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_statue_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HUMAN_STATUE", 0, true);
			playing_statue_emote = true;
		elseif playing_statue_emote == true then
			ClearPedTasks(ped);
			playing_statue_emote = false;
		end
	end
end)

AddEventHandler('playCheeringEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_cheering_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CHEERING", 0, true);
			playing_cheering_emote = true;
		elseif playing_cheering_emote == true then
			ClearPedTasks(ped);
			playing_cheering_emote = false;
		end
	end
end)

AddEventHandler('playBinocularsEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_bino_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_BINOCULARS", 0, true);
			playing_bino_emote = true;
		elseif playing_bino_emote == true then
			ClearPedTasks(ped);
			playing_bino_emote = false;
		end
	end
end)

AddEventHandler('playYogaEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_yoga_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_YOGA", 0, true);
			playing_yoga_emote = true;
		elseif playing_yoga_emote == true then
			ClearPedTasks(ped);
			playing_yoga_emote = false;
		end
	end
end)

AddEventHandler('playPhoneEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_phone_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE", 0, true);
			playing_phone_emote = true;
		elseif playing_phone_emote == true then
			ClearPedTasks(ped);
			playing_phone_emote = false;
		end
	end
end)

AddEventHandler('playFishEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_fish_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, true);
			playing_fish_emote = true;
		elseif playing_fish_emote == true then
			ClearPedTasks(ped);
			playing_fish_emote = false;
		end
	end
end)

AddEventHandler('playPotEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_pot_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING_POT", 0, true);
			playing_pot_emote = true;
		elseif playing_pot_emote == true then
			ClearPedTasks(ped);
			playing_pot_emote = false;
		end
	end
end)

AddEventHandler('playHangOutEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_hangout_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true);
			playing_hangout_emote = true;
		elseif playing_hangout_emote == true then
			ClearPedTasks(ped);
			playing_hangout_emote = false;
		end
	end
end)

AddEventHandler('playCopEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_cop_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true);
			playing_cop_emote = true;
		elseif playing_cop_emote == true then
			ClearPedTasks(ped);
			playing_cop_emote = false;
		end
	end
end)

AddEventHandler('playSitEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_sit_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_PICNIC", 0, true);
			playing_sit_emote = true;
		elseif playing_sit_emote == true then
			ClearPedTasks(ped);
			playing_sit_emote = false;
		end
	end
end)
AddEventHandler('playChairEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_chair_emote == false then
			pos = GetEntityCoords(ped);
			head = GetEntityHeading(ped);
			TaskStartScenarioAtPosition(ped, "PROP_HUMAN_SEAT_CHAIR", pos['x'], pos['y'], pos['z'] - 1, head, 0, 0, 1);
			--TaskStartScenarioInPlace(ped, "PROP_HUMAN_SEAT_CHAIR", 0, false);
			playing_chair_emote = true;
		elseif playing_chair_emote == true then
			ClearPedTasks(ped);
			playing_chair_emote = false;
		end
	end
end)

AddEventHandler('playKneelEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_kneel_emote == false then
			TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_KNEEL", 0, true);
			playing_kneel_emote = true;
		elseif playing_kneel_emote == true then
			ClearPedTasks(ped);
			playing_kneel_emote = false;
		end
	end
end)

AddEventHandler('playMedicEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_medic_emote == false then
			TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true);
			playing_medic_emote = true;
		elseif playing_medic_emote == true then
			ClearPedTasks(ped);
			playing_medic_emote = false;
		end
	end
end)

AddEventHandler('playNotepadEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_notepad_emote == false then
			TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true);
			playing_notepad_emote = true;
		elseif playing_notepad_emote == true then
			ClearPedTasks(ped);
			playing_notepad_emote = false;
		end
	end
end)

AddEventHandler('playTrafficEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_traffic_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false);
			playing_traffic_emote = true;
		elseif playing_traffic_emote == true then
			ClearPedTasks(ped);
			playing_traffic_emote = false;
		end
	end
end)

AddEventHandler('playPhotoEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_photo_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_PAPARAZZI", 0, false);
			playing_photo_emote = true;
		elseif playing_photo_emote == true then
			ClearPedTasks(ped);
			playing_photo_emote = false;
		end
	end
end)

AddEventHandler('playClipboardEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_clipboard_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, false);
			playing_clipboard_emote = true;
		elseif playing_clipboard_emote == true then
			ClearPedTasks(ped);
			playing_clipboard_emote = false;
		end
	end
end)

AddEventHandler('playLeanEmote', function()
	ped = GetPlayerPed(-1);

	if ped then
		if playing_lean_emote == false then
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_LEANING", 0, true);
			playing_lean_emote = true;
		elseif playing_lean_emote == true then
			ClearPedTasks(ped);
			playing_lean_emote = false;
		end
	end
end)
