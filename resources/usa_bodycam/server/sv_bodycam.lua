local POLICE_RANKS = {
	["SASP"] = {
		[1] = "Cadet",
		[2] = "Trooper",
		[3] = "Senior Trooper",
		[4] = "Lead Senior Trooper",
		[5] = "Corporal",
		[6] = "Sergeant",
		[7] = "Staff Sergeant",
		[8] = "Lieutenant",
		[9] = "Captain",
		[10] = "Assistant Commissioner",
		[11] = "Deputy Commissioner",
		[12] = "Commissioner",
		[13] = "Director of Emergency Services"
	},
	["BCSO"] = {
		[1] = "Correctional Deputy",
		[2] = "Senior Correctional Deputy",
		[3] = "Probational Deputy",
		[4] = "Sheriff's Deputy",
		[5] = "Senior Sheriff's Deputy",
		[6] = "Corporal",
		[7] = "Sergeant",
		[8] = "Captain",
		[9] = "Commander",
		[10] = "Undersheriff",
		[11] = "Sheriff"
	},
	["Corrections"] = {
		[1] = "Correctional Deputy",
		[2] = "Senior Correctional Deputy",
		[3] = "Corporal",
		[4] = "Sergeant",
		[5] = "Deputy Warden",
		[6] = "Chief Deputy Warden",
		[7] = "Warden",
	}
}

function GetRankName(rank, dept)
	local department = nil
	if dept == "bcso" then 
		department = "BCSO"
	elseif dept == "sasp" then 
		department = "SASP"
	elseif dept == "corrections" then
		department = "Corrections"
	end
	local retString = department .. " | " .. POLICE_RANKS[department][rank]
	return retString
end

TriggerEvent('es:addJobCommand', 'bodycam', { 'sasp', "bcso", "corrections"}, function(source, args, char)
	local char = exports["usa-characters"]:GetCharacter(source)
	local name = char.getFullName()
	local job = char.get("job")
	local rank = ""

	if job == "sasp" then
		local police_rank = char.get("policeRank")
		if police_rank > 0 then
			rank = GetRankName(police_rank, "sasp")
		end
	elseif job == "bcso" then
		local bcso_rank = char.get("bcsoRank")
		if bcso_rank > 0 then
			rank = GetRankName(bcso_rank, "bcso")
		end
	elseif job == "corrections" then
		local corrections_rank = char.get("correctionsRank")
		if corrections_rank > 0 then
			rank = GetRankName(corrections_rank, "corrections")
		end
	end
	TriggerClientEvent("usa_bodycam:show", source, name, rank)
end, {
	help = "Toggle Bodycam",
	params = {}
})