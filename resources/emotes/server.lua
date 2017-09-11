TriggerEvent('es:addCommand', 'emote', function(source, args, user)
	if args[2] == nil then
		TriggerClientEvent('printEmoteHelp', source)
	elseif args[2] == "cop" then
		TriggerClientEvent('playCopEmote', source)
	elseif args[2] == "sit" then
		TriggerClientEvent('playSitEmote', source)
	elseif args[2] == "chair" then
		TriggerClientEvent('playChairEmote', source)
	elseif args[2] == "kneel" then
		TriggerClientEvent('playKneelEmote', source)
	elseif args[2] == "medic" then
		TriggerClientEvent('playMedicEmote', source)
	elseif args[2] == "notepad" then
		TriggerClientEvent('playNotepadEmote', source)
	elseif args[2] == "traffic" then
		TriggerClientEvent('playTrafficEmote', source)
	elseif args[2] == "photo" then
		TriggerClientEvent('playPhotoEmote', source)
	elseif args[2] == "clipboard" then
		TriggerClientEvent('playClipboardEmote', source)
	elseif args[2] == "lean" then
		TriggerClientEvent('playLeanEmote', source)
	elseif args[2] == "drugdealer" then
		TriggerClientEvent('playDrugDealerEmote', source)
	elseif args[2] == "hangout" then
		TriggerClientEvent('playHangOutEmote', source)
	elseif args[2] == "pot" then
		TriggerClientEvent('playPotEmote', source)
	elseif args[2] == "fish" then
		TriggerClientEvent('playFishEmote', source)
	elseif args[2] == "phone" then
		TriggerClientEvent('playPhoneEmote', source)
	elseif args[2] == "fish" then
		TriggerClientEvent('playFishEmote', source)
	elseif args[2] == "yoga" then
		TriggerClientEvent('playYogaEmote', source)
	elseif args[2] == "cheering" then
		TriggerClientEvent('playCheeringEmote', source)
	elseif args[2] == "statue" then
		TriggerClientEvent('playStatueEmote', source)
	elseif args[2] == "jog" then
		TriggerClientEvent('playJogEmote', source)
	elseif args[2] == "flex" then
		TriggerClientEvent('playFlexEmote', source)
	elseif args[2] == "situp" then
		TriggerClientEvent('playSitUpEmote', source)
	elseif args[2] == "pushup" then
		TriggerClientEvent('playPushUpEmote', source)
	elseif args[2] == "weld" then
		TriggerClientEvent('playWeldingEmote', source)
	elseif args[2] == "mechanic" then
		TriggerClientEvent('playMechanicEmote', source)
	end
end)
