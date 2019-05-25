local POLICE_LAWYER_PAY = 500

RegisterServerEvent('legal:checkBarCertificate')
AddEventHandler('legal:checkBarCertificate', function()
  local playerSource = source
  local user = exports["essentialmode"]:getPlayerFromId(playerSource)
  if user.getActiveCharacterData('job') ~= 'lawyer' then
	  local licenses = user.getActiveCharacterData("licenses")
	    for i = 1, #licenses do
	      if licenses[i].name == 'Bar Certificate' then
	          TriggerClientEvent('usa:notify', playerSource, 'You are now signed ~g~on-duty~s~ as an attorney.')
	          print('LEGAL: '..GetPlayerName(playerSource)..'['..GetPlayerIdentifier(playerSource)..'] has signed ON-DUTY as an attorney!')
	          user.setActiveCharacterData("job", "lawyer")
	          return
	      end
	    end
	    TriggerClientEvent('usa:notify', playerSource, 'You do not have a Bar Certificate!')
	    return
  else
   	TriggerClientEvent('usa:notify', playerSource, 'You are now signed ~y~off-duty~s~ as an attorney.')
   	print('LEGAL: '..GetPlayerName(playerSource)..'['..GetPlayerIdentifier(playerSource)..'] has signed OFF-DUTY as an attorney!')
   	user.setActiveCharacterData('job', 'civ')
  end
end)

TriggerEvent('es:addJobCommand', 'paylawyer', { 'sheriff', 'police' , 'judge'}, function(source, args, user)
	local user = exports['essentialmode']:getPlayerFromId(source)
	local targetSource = tonumber(args[2])
	local targetAmount = tonumber(args[3])
	local target = exports['essentialmode']:getPlayerFromId(targetSource)
	if target.getActiveCharacterData('job') == 'lawyer' then
		if not GetPlayerName(targetSource) then
			TriggerClientEvent('usa:notify', source, '~y~Player not found!')
		else
			if user.getActiveCharacterData('job') == 'judge' then
				if targetAmount > 0 and targetAmount < 10000 then
					TriggerClientEvent('lawyer:checkDistanceForPayment', source, targetSource, targetAmount)
				else
					TriggerClientEvent('usa:notify', source, '~y~Invalid amount, please contact staff to do this.')
				end
			else
				if targetAmount > 500 then targetAmount = POLICE_LAWYER_PAY end
				TriggerClientEvent('lawyer:checkDistanceForPayment', source, targetSource, targetAmount)
			end
		end
	else
		TriggerClientEvent('usa:notify', source, '~y~This player is not a lawyer!')
	end
end, {
	help = "Pay an attorney for state services",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "amount", help = "judges only for over 500" }
	}
})

RegisterServerEvent('legal:openMDT')
AddEventHandler('legal:openMDT', function()
	local user = exports['essentialmode']:getPlayerFromId(source)
	local da_rank = user.getActiveCharacterData('daRank')
	if da_rank and da_rank > 0 then
		TriggerClientEvent('mdt:toggleVisibilty', source)
	else
		TriggerClientEvent('usa:notify', source, 'Incorrect username or password!')
	end
end)

RegisterServerEvent('lawyer:payLawyer')
AddEventHandler('lawyer:payLawyer', function(targetSource, targetAmount)
	local target = exports['essentialmode']:getPlayerFromId(targetSource)
	local targetMoney = target.getActiveCharacterData('bank')
	local targetName = target.getActiveCharacterData('fullName')
	target.setActiveCharacterData('bank', math.floor(targetMoney + targetAmount))
	TriggerClientEvent('usa:notify', source, targetName.. ' has been paid ~y~$'..targetAmount..'~s~ by the ~y~San Andreas Court Administration~s~.')
	TriggerClientEvent('usa:notify', targetSource, 'You have been paid ~y~$'..targetAmount..'~s~ by the ~y~San Andreas Court Administration~s~.')
	print('LEGAL: '..GetPlayerName(source)..'['..GetPlayerIdentifier(source)..'] has paid (for free) amount['..targetAmount..'] to '..GetPlayerName(targetSource)..'['..GetPlayerIdentifier(targetSource)..'] for legal reward.')
end)

RegisterServerEvent('legal:onDutyDAI')
AddEventHandler('legal:onDutyDAI', function()
	local user = exports['essentialmode']:getPlayerFromId(source)
	local da_rank = user.getActiveCharacterData('daRank')
	local user_job = user.getActiveCharacterData('job')
	if user_job == 'dai' then
		user.setActiveCharacterData('job', 'civ')
		TriggerClientEvent('interaction:setPlayersJob', source, 'civ')
		TriggerClientEvent('usa:notify', source, 'You are now off-duty as a DAI.')
	else
		if da_rank and da_rank == 2 then
			user.setActiveCharacterData('job', 'dai')
			TriggerClientEvent('interaction:setPlayersJob', source, 'dai')
			TriggerClientEvent('usa:notify', source, 'You are now on-duty as a DAI.')
		else
			TriggerClientEvent('usa:notify', source, 'You are not whitelisted for DAI!')
		end
	end
end)