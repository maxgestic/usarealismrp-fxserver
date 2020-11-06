local evidenceDropped = {}
local weaponNames = {
	[453432689] = 'Pistol',
	[3219281620] = 'Pistol Mk. 2',
	[1593441988] = 'Combat Pistol',
	[-1716589765] = 'Pistol .50',
	[-1076751822] = 'SNS Pistol',
	[-771403250] = 'Heavy Pistol',
	[137902532] = 'Vintage Pistol',
	[-598887786] = 'Marksman Pistol',
	[-1045183535] = 'Revolver',
	[584646201] = 'AP Pistol',
	[911657153] = 'Stun Gun',
	[1198879012] = 'Flare Gun',
	[324215364] = 'Micro SMG',
	[-619010992] = 'Machine Pistol',
	[736523883] = 'SMG',
	[2024373456] = 	'SMG Mk. 2',
	[-270015777] = 'Assault SMG',
	[171789620] = 'Combat PDW',
	[-1660422300] = 'MG',
	[2144741730] = 'Combat MG',
	[3686625920] = 'Combat MG Mk. 2',
	[1627465347] = 'Gusenberg',
	[-1121678507] = 'Mini SMG',
	[-1074790547] = 'Assault Rifle',
	[961495388] = 'Assault Rifle Mk. 2',
	[-2084633992] = 'Carbine Rifle',
	[4208062921] = 'Carbine Rifle Mk. 2',
	[-1357824103] = 'Advanced Rifle',
	[-1063057011] = 'Special Carbine',
	[2132975508] = 'Bullpup Rifle',
	[1649403952] = 'Compact Rifle',
	[100416529] = 'Sniper Rifle',
	[205991906] = 'Heavy Sniper',
	[177293209] = 'Heavy Sniper Mk. 2',
	[-952879014] = 'Marksman Rifle',
	[487013001] = 'Pump Shotgun',
	[2017895192] = 'Sawn-off Shotgun',
	[-1654528753] = 'Bullpup Shotgun',
	[-494615257] = 'Assault Shotgun',
	[-1466123874] = 'Musket',
	[984333226] = 'Heavy Shotgun',
	[-275439685] = 'Double Barrel Shotgun',
	[2138347493] = 'Firework Launcher'
}

local exempt_evidence = {
	vector3(151.39, -1007.74, -99.0),
	vector3(266.14, -1007.61, -101.00),
	vector3(346.47, -1013.05, -99.19),
	vector3(-781.77, 322.00, 211.99)
}

local NEARBY_DISTANCE = 100

TriggerEvent('es:addJobCommand', 'breathalyze', { "police", "sheriff", "ems", "corrections" }, function(source, args, char)
	TriggerClientEvent("evidence:breathalyzeNearest", source)
end, {
	help = "breathalyze the nearest person"
})

TriggerEvent('es:addJobCommand', 'dnasample', { "police", "sheriff", "corrections", "ems" }, function(source, args, char)
	TriggerClientEvent("evidence:dnaNearest", source)
end, {
	help = "dna sample the nearest person"
})

RegisterServerEvent('evidence:returnDNA')
AddEventHandler('evidence:returnDNA', function(targetSource)
	local target = exports["usa-characters"]:GetCharacter(targetSource)
	local targetEncoded = enc(target.get("_id"))
	TriggerClientEvent('chatMessage', source, '^3^*[DNA SAMPLE]^r ^7Sample of ^3'..target.getName()..'^7 returns value: ^3'..targetEncoded..'^7.')
end)

RegisterServerEvent('evidence:breathalyzePlayer')
AddEventHandler('evidence:breathalyzePlayer', function(playerToBreathalyze)
	TriggerClientEvent('evidence:getBreathalyzeResult', playerToBreathalyze, source)
end)

RegisterServerEvent('evidence:returnBreathalyzeResult')
AddEventHandler('evidence:returnBreathalyzeResult', function(levelBAC, sourceReturnedTo)
	if levelBAC >= 0.08 then
		TriggerClientEvent('usa:notify', sourceReturnedTo, source .. ' - BAC: ' .. levelBAC)
	else
		TriggerClientEvent('usa:notify', sourceReturnedTo, source .. ' - BAC: ' .. levelBAC)
	end
	local soundParams = {-1, "PIN_BUTTON", "ATM_SOUNDS", 1}
	TriggerClientEvent("usa:playSound", sourceReturnedTo, soundParams)
end)

-- GSR test --
TriggerEvent('es:addJobCommand', 'gsr', { "police", "sheriff", "corrections" }, function(source, args, char)
	TriggerClientEvent("evidence:gsrNearest", source)
end, {
	help = "gun shot residue test the nearest person"
})

RegisterServerEvent('evidence:gsrPerson')
AddEventHandler('evidence:gsrPerson', function(playerToTest)
	TriggerClientEvent('evidence:getGSRResult', playerToTest, source)
end)

RegisterServerEvent('evidence:newCasing')
AddEventHandler('evidence:newCasing', function(playerCoords, playerWeapon)
	local evidence = {
		type = 'casing',
		string = 'Casing',
		weapon = weaponNames[playerWeapon],
		coords = playerCoords,
		made = os.time()
	}
	for i = 1, #exempt_evidence do
		if find_distance(playerCoords, exempt_evidence[i]) < 50.0 then
			return
		end
	end
	for i = 1, #evidenceDropped do
		if find_distance(playerCoords, evidenceDropped[i].coords) < 1.0 then
			return
		end
	end
	table.insert(evidenceDropped, evidence)
end)

RegisterServerEvent('evidence:newDNA')
AddEventHandler('evidence:newDNA', function(playerCoords)
	local char = exports["usa-characters"]:GetCharacter(source)
	local charEncoded = enc(char.get("_id"))
	local evidence = {
		type = 'dna',
		string = 'DNA',
		DNA = charEncoded,
		coords = playerCoords,
		made = os.time()
	}
	for i = 1, #exempt_evidence do
		if find_distance(playerCoords, exempt_evidence[i]) < 50.0 then
			return
		end
	end
	for i = 1, #evidenceDropped do
		if find_distance(playerCoords, evidenceDropped[i].coords) < 1.0 then
			return
		end
	end
	table.insert(evidenceDropped, evidence)
end)

RegisterServerEvent('evidence:discardEvidence')
AddEventHandler('evidence:discardEvidence', function(coords)
	for i = 1, #evidenceDropped do
		local item = evidenceDropped[i]
		if item.coords == coords then
			table.remove(evidenceDropped, i)
			return
		end
	end
end)

RegisterServerEvent('evidence:returnGSRResult')
AddEventHandler('evidence:returnGSRResult', function(residue, sourceReturnedTo)
	if residue then
		TriggerClientEvent('usa:notify', sourceReturnedTo, source .. ' - residue detected!')
	else
		TriggerClientEvent('usa:notify', sourceReturnedTo, source .. ' - residue not found.')
	end
	local soundParams = {-1, "PIN_BUTTON", "ATM_SOUNDS", 1}
	TriggerClientEvent("usa:playSound", sourceReturnedTo, soundParams)
end)

RegisterServerEvent('evidence:checkJobForMenu')
AddEventHandler('evidence:checkJobForMenu', function()
	local job = exports["usa-characters"]:GetCharacterField(source, "job")
	if job == 'police' or job == 'sheriff' or job == 'corrections' then
		TriggerClientEvent('evidence:openEvidenceMenu', source)
	else
		TriggerClientEvent('usa:notify', source, '~y~You are not on-duty for POLICE.')
	end
end)

RegisterServerEvent('evidence:makeObservations')
AddEventHandler('evidence:makeObservations', function(targetSource)
	local job = exports["usa-characters"]:GetCharacterField(source, "job")
	if job == 'corrections' or job == 'sheriff' or job == "ems" then
		TriggerClientEvent('evidence:getObservations', targetSource, source)
	end
end)

RegisterServerEvent('evidence:returnObservations')
AddEventHandler('evidence:returnObservations', function(observations, sourceReturnedTo)
	TriggerClientEvent('evidence:displayObservations', sourceReturnedTo, observations, source)
end)

RegisterServerEvent("evidence:loadNearbyEvidence")
AddEventHandler("evidence:loadNearbyEvidence", function(coords)
	local nearby = {}
	for i = 1, #evidenceDropped do
		local item = evidenceDropped[i]
		if find_distance(item.coords, coords) < NEARBY_DISTANCE then
			table.insert(nearby, item)
		end
	end
    TriggerClientEvent("evidence:loadNearbyEvidence", source, nearby)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		for i = #evidenceDropped, 1, -1 do
			local item = evidenceDropped[i]
			if getMinutesFromTime(item.made) >= 45 then
				table.remove(evidenceDropped, i)
			end
		end
	end
end)

-- character table string
local b='abcdefghijklmnopqrstuvwxyz10'

-- encoding
function enc(data)
  return ((data:gsub('.', function(x)
    local r,b='',x:byte()
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    return r;
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if (#x < 6) then return '' end
    local c=0
    for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
    return b:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function dec(data)
  data = string.gsub(data, '[^'..b..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(b:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
  end))
end

function getMinutesFromTime(t)
  local reference = t
  local minutesfrom = os.difftime(os.time(), reference) / 60
  local minutes = math.floor(minutesfrom)
  return minutes
end

function find_distance(coords1, coords2)
  xdistance =  math.abs(coords1.x - coords2.x)

  ydistance = math.abs(coords1.y - coords2.y)

  zdistance = math.abs(coords1.z - coords2.z)

  return nroot(3, (xdistance ^ 3 + ydistance ^ 3 + zdistance ^ 3))
end

function nroot(root, num)
  return num^(1/root)
end
