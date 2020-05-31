local hospitalBeds = {
	{
		occupied = nil,
		objCoords  = {324.28768920898, -582.46478271484, 44.20397567749},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {322.63815307617, -587.11682128906, 44.203971862793},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {319.43954467773, -580.97912597656, 44.203964233398},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {317.73867797852, -585.37567138672, 44.20397567749},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {314.52270507813, -584.27429199219, 44.203926086426},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {313.83673095703, -579.06793212891, 44.20397567749},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {311.08102416992, -583.05340576172, 44.20397567749},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {307.62704467773, -581.96899414063, 44.20397567749},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {309.33361816406, -577.29541015625, 44.203971862793},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {366.71246337891, -581.64465332031, 44.213802337646},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {365.01702880859, -585.91979980469, 44.213794708252},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords  = {363.98107910156, -589.18029785156, 44.213802337646},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords = {315.34, -566.4, 43.11},
		objModel = -1519439119
	},
	{
		occupied = nil,
		objCoords = {321.07, -568.35, 43.09},
		objModel = -1519439119
	},
	{
		occupied = nil,
		objCoords = {326.77, -571.03, 43.09},
		objModel = -1519439119
	},
	{
		occupied = nil,
		objCoords = {359.85, -585.25, 43.28},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords = {361.6, -580.3, 43.28},
		objModel = 1631638868
	},
	{
		occupied = nil,
		objCoords = {354.87, -599.26, 43.28},
		objModel = 1631638868
	}
}


RegisterServerEvent('ems:resetBed')
AddEventHandler('ems:resetBed', function()
	for i = 1, #hospitalBeds do
		if hospitalBeds[i].occupied == source then
			hospitalBeds[i].occupied = nil
		end
	end
end)

RegisterServerEvent('injuries:getHospitalBeds')
AddEventHandler('injuries:getHospitalBeds', function(callback)
	callback(hospitalBeds)
end)

RegisterServerEvent('ems:occupyBed')
AddEventHandler('ems:occupyBed', function(index)
	hospitalBeds[index].occupied = source
end)

AddEventHandler('playerDropped', function()
	for i = 1, #hospitalBeds do
		if hospitalBeds[i].occupied == source then
			print('source was hospitalized, left and now bed is being freed!')
			hospitalBeds[i].occupied = nil
		end
	end
end)

-- /admit [id] [time] [reason]
TriggerEvent('es:addJobCommand', 'admit', { "ems", "fire", "police", "sheriff", "corrections", "doctor" }, function(source, args, char)
	local targetPlayerId = tonumber(args[2])
	local bed = nil
	table.remove(args, 1)
	table.remove(args, 1)
	local reasonForAdmission = table.concat(args, " ")
	if not reasonForAdmission or not GetPlayerName(targetPlayerId) then return end
	print("USARRP2: "..GetPlayerName(source)..'['..GetPlayerIdentifier(source)..'] has admitted '..GetPlayerName(targetPlayerId)..'['..GetPlayerIdentifier(targetPlayerId)..'] to hospital with reason['..reasonForAdmission..']')
	for i = 1, #hospitalBeds do
		if hospitalBeds[i].occupied == nil then
			hospitalBeds[i].occupied = targetPlayerId
			bed = {
				heading = hospitalBeds[i].heading,
				coords = hospitalBeds[i].objCoords,
				model = hospitalBeds[i].objModel
			}
			break
		end
	end
	-- get player's character name:
	local target_player = exports["usa-characters"]:GetCharacter(targetPlayerId)
	TriggerClientEvent("ems:admitMe", targetPlayerId, bed, reasonForAdmission)
	TriggerClientEvent('usa:notify', source, 'Person has been hospitalized.')
	--send to discord #ems-logs
	local url = 'https://discordapp.com/api/webhooks/618095236211802113/IaUzzsbJWD97IHModohSjbruGjOz6eBQ-xRrRTwcYhbdbG9MqEiL4SRuiCHPH_R6OXrH'
	PerformHttpRequest(url, function(err, text, headers)
		if text then
			print(text)
		end
	end, "POST", json.encode({
		embeds = {
			{
				description = "**Patient:** " .. target_player.getFullName() .. "\n**Details:** " .. reasonForAdmission .. "\n**Responder:** " .. char.getFullName() .."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
				color = 263172,
				author = {
					name = "Pillbox Medical Records"
				}
			}
		}
	}), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end, {
	help = "Admit someone to the hospital",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "reason", help = "Reason" }
	}
})

TriggerEvent('es:addCommand', 'bed', function(source, args, char)
	TriggerClientEvent('ems:getNearestBedIndex', source, hospitalBeds)
end, {
	help = "Enter a hospital bed",
})
