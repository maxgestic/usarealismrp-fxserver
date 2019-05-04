--[[
Los Santos Customs V1.1
Credits - MythicalBro
/////License/////
Do not reupload/re release any part of this script without my permission
]]
local tbl = {
[1] = {locked = false, player = nil},
[2] = {locked = false, player = nil},
[3] = {locked = false, player = nil},
[4] = {locked = false, player = nil},
[5] = {locked = false, player = nil},
[6] = {locked = false, player = nil},
}
RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		tbl[tonumber(garage)].player = nil
	else
		tbl[tonumber(garage)].player = source
	end
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local usource = source
	if button.price then -- check if button have price
		local player = exports["essentialmode"]:getPlayerFromId(usource)
		local mymoney = player.getActiveCharacterData("money")
		local myjob = player.getActiveCharacterData("job")
		button.price = math.abs(button.price) -- prevent mem hack to gain money
		if button.price <= mymoney or myjob == "sheriff" or myjob == "police" or myjob == "ems" or myjob == "fire" then
			-- take money from player, apply customization --
			TriggerClientEvent("LSC:buttonSelected", usource, name, button, true)
			if myjob ~= "sheriff" and myjob ~= "police" and myjob ~= "ems" and myjob ~= "fire" then
				mymoney  = mymoney - button.price
				player.setActiveCharacterData("money", mymoney)
			end
		else
			TriggerClientEvent("LSC:buttonSelected", usource, name, button, false)
		end
	end
end)

RegisterServerEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local model = veh.model --Display name from vehicle model(comet2, entityxf)
	local mods = veh.mods
	--[[
	mods[0].mod - spoiler
	mods[1].mod - front bumper
	mods[2].mod - rearbumper
	mods[3].mod - skirts
	mods[4].mod - exhaust
	mods[5].mod - roll cage
	mods[6].mod - grille
	mods[7].mod - hood
	mods[8].mod - fenders
	mods[10].mod - roof
	mods[11].mod - engine
	mods[12].mod - brakes
	mods[13].mod - transmission
	mods[14].mod - horn
	mods[15].mod - suspension
	mods[16].mod - armor
	mods[23].mod - tires
	mods[23].variation - custom tires
	mods[24].mod - tires(Just for bikes, 23:front wheel 24:back wheel)
	mods[24].variation - custom tires(Just for bikes, 23:front wheel 24:back wheel)
	mods[25].mod - plate holder
	mods[26].mod - vanity plates
	mods[27].mod - trim design
	mods[28].mod - ornaments
	mods[29].mod - dashboard
	mods[30].mod - dial design
	mods[31].mod - doors
	mods[32].mod - seats
	mods[33].mod - steering wheels
	mods[34].mod - shift leavers
	mods[35].mod - plaques
	mods[36].mod - speakers
	mods[37].mod - trunk
	mods[38].mod - hydraulics
	mods[39].mod - engine block
	mods[40].mod - cam cover
	mods[41].mod - strut brace
	mods[42].mod - arch cover
	mods[43].mod - aerials
	mods[44].mod - roof scoops
	mods[45].mod - tank
	mods[46].mod - doors
	mods[48].mod - liveries

	--Toggle mods
	mods[20].mod - tyre smoke
	mods[22].mod - headlights
	mods[18].mod - turbo
	veh.neonlightenabled - under glow?

	--]]

	print("saving car customizations...")
	TriggerEvent("customs:saveCarData", veh, veh.plate, source) -- save car customization

	--print("type(mods[12]): " .. type(mods[12].mod))

	local color = veh.color
	local extracolor = veh.extracolor
	local neoncolor = veh.neoncolor
	local smokecolor = veh.smokecolor
	local plateindex = veh.plateindex
	local windowtint = veh.windowtint
	local wheeltype = veh.wheeltype
	local bulletProofTyres = veh.bulletProofTyres

--[[
	--  mod debug info: --
	for i = 1, #mods do
		print("mod #" .. i .. ": " .. tostring(mods[i].mod))
	end

	-- other mod debug info --
	print("color: ")
	for i = 1, #color do
		print("color["..i.."]: " .. color[i])
	end

	if type(extracolor) == "table" then
		print("extracolor: ")
		for i = 1, #extracolor do
			print("extracolor["..i.."]: " .. extracolor[i])
		end
	else
		print("extracolor: " .. extracolor)
	end

	if type(neoncolor) == "table" then
		print("neoncolor: ")
		for i = 1, #neoncolor do
			print("neoncolor["..i.."]: " .. neoncolor[i])
		end
	else
		print("neoncolor: " .. neoncolor)
	end

	if type(smokecolor) == "table" then
		print("smokecolor: ")
		for i = 1, #smokecolor do
			print("smokecolor["..i.."]: " .. smokecolor[i])
		end
	else
		print("smokecolor: " .. smokecolor)
	end

	if type(plateindex) == "table" then
		print("plateindex: ")
		for i = 1, #plateindex do
			print("plateindex["..i.."]: " .. plateindex[i])
		end
	else
		print("plateindex: " .. plateindex)
	end

	if type(windowtint) == "table" then
		print("windowtint: ")
		for i = 1, #windowtint do
			print("windowtint["..i.."]: " .. windowtint[i])
		end
	else
		print("windowtint: " .. tostring(windowtint))
	end
	if type(wheeltype) == "table" then
		print("wheeltype: ")
		for i = 1, #wheeltype do
			print("wheeltype["..i.."]: " .. wheeltype[i])
		end
	else
		print("wheeltype: " .. wheeltype)
	end

	if type(bulletProofTyres) == "table" then
		print("bulletProofTyres: ")
		for i = 1, #bulletProofTyres do
			print("bulletProofTyres["..i.."]: " .. bulletProofTyres[i])
		end
	else
		print("bulletProofTyres: " .. tostring(bulletProofTyres))
	End
	--]]
	--Do w/e u need with all this stuff when vehicle drives out of lsc
end)

RegisterServerEvent("customs:saveCarData")
AddEventHandler("customs:saveCarData", function(data, plate, source)
	if plate then
		TriggerEvent('es:exposeDBFunctions', function(couchdb)
			couchdb.updateDocument("vehicles", plate, { customizations = data }, function()
				print("Customizations saved!")
			end)
		end)
	end
end)