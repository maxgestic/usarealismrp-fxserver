local policeLawyerPay = 500

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
	local _source = source
	local user = exports['essentialmode']:getPlayerFromId(_source)
	local targetSource = tonumber(args[2])
	local targetAmount = tonumber(args[3])
	local target = exports['essentialmode']:getPlayerFromId(targetSource)
	if target.getActiveCharacterData('job') == 'lawyer' then
		if not GetPlayerName(targetSource) then
			TriggerClientEvent('usa:notify', _source, '~y~Player not found!')
		else
			if user.getActiveCharacterData('job') == 'judge' then
				if targetAmount > 0 and targetAmount < 10000 then
					TriggerClientEvent('lawyer:checkDistanceForPayment', _source, targetSource, targetAmount)
				else
					TriggerClientEvent('usa:notify', _source, '~y~Invalid amount, please contact staff to do this.')
				end
			else
				TriggerClientEvent('lawyer:checkDistanceForPayment', _source, targetSource, policeLawyerPay)
			end
		end
	else
		TriggerClientEvent('usa:notify', _source, '~y~This player is not a lawyer!')
	end
end, {
	help = "Pay an attorney for state services",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "amount", help = "(judges only)" }
	}
})

RegisterServerEvent('lawyer:payLaywer')
AddEventHandler('lawyer:paylawyer', function(targetSource, targetAmount)
	local _source = source
	local target = exports['essentialmode']:getPlayerFromId(targetSource)
	local targetMoney = target.getActiveCharacterData('bank')
	local targetName = target.getActiveCharacterData('fullName')
	target.setActiveCharacterData('bank', math.floor(targetMoney + targetAmount))
	TriggerClientEvent('usa:notify', _source, targetName.. ' has been paid ~y~$'..targetAmount..'~s~ by the ~y~San Andreas Court Administration~s~.')
	TriggerClientEvent('usa:notify', targetSource, 'You have been paid ~y~$'..targetAmount..'~s~ by the ~y~San Andreas Court Administration~s~.')
	print('LEGAL: '..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source)..'] has paid (for free) amount['..targetAmount..'] to '..GetPlayerName(targetSource)..'['..GetPlayerIdentifier(targetSource)..'] for legal reward.')
end)
