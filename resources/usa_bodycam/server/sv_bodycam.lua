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
	}
}

function GetRankName(rank, dept)
	local department = nil
	if dept == "corrections" then 
		department = "BCSO"
	elseif dept == "sheriff" then 
		department = "SASP"
	end
	local retString = department .. " | " .. POLICE_RANKS[department][rank]
	return retString
end

TriggerEvent('es:addJobCommand', 'bodycam', { 'sheriff', "corrections"}, function(source, args, char)
	local char = exports["usa-characters"]:GetCharacter(source)
	local name = char.getFullName()
	local job = char.get("job")
	local rank = ""

	if job == "sheriff" then
		local police_rank = char.get("policeRank")
		if police_rank > 0 then
			rank = GetRankName(police_rank, "sheriff")
		end
	elseif job == "corrections" then
		local bcso_rank = char.get("bcsoRank")
		if bcso_rank > 0 then
			rank = GetRankName(bcso_rank, "corrections")
		end
	end
	TriggerClientEvent("usa_bodycam:show", source, name, rank)
end, {
	help = "Toggle Bodycam",
	params = {}
})