--# by: minipunch
-- for USA REALISM RP
-- This script adds a realistic food and water requirement for players to stay alive while playing. Also tacked on in game time due to not wanting to create a separate script for it ;o

-----------------------
-- SETTINGS / PERSON --
-----------------------
local settings = {
	hud = {
		["hunger"] = {text = "Full", x = 0.698, y = 1.62, r = 9, g = 179, b = 9, a = 255},
		["thirst"] = {text = "Thirsty", x = 0.698, y = 1.645, r = 255, g = 128, b = 0, a = 255},
		-- ["clock"] = {text = "0:00", x = 0.75, y = 1.645, r = 255, g = 255, b = 255, a = 255}
		["clock"] = {text = "0:00", x = 0.698, y = 1.595, r = 224, g = 227, b = 218, a = 255}
	},
	thirst_global_mult = 0.000245,
	hunger_global_mult = 0.000185,
	walking_mult = 0.00050,
	running_mult = 0.00095,
	sprinting_mult = 0.00145,
	biking_mult = 0.00075,
	--sound_params = {-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0},
	sound_params = {-1, "FocusIn", "HintCamSounds", 1},
	debug = false
}

local person = {
	hunger_level = 100.0,
	thirst_level = 100.0
}

---------------
-- API FUNCS --
---------------
RegisterNetEvent("hungerAndThirst:replenish")
AddEventHandler("hungerAndThirst:replenish", function(type, item)
	if type == "hunger" then
		local animation = {
			dict = "amb@code_human_wander_eating_donut@male@idle_a",
			name = "idle_c",
			duration = 18
		}
		local new_hunger_level = person.hunger_level + item.substance
		-- adjust level, notify and remove item
		if new_hunger_level <= 100.0 then
			person.hunger_level = new_hunger_level
			TriggerEvent("usa:notify", "Consumed: ~y~" .. item.name)
			TriggerServerEvent("usa:removeItem", item, 1)
		else
			local diff = new_hunger_level - 100.0
			--print("went over by: " .. diff)
			person.hunger_level = 100.0
			TriggerEvent("usa:notify", "You are now totally full!")
			--print("calling usa:removeItem!!")
			TriggerServerEvent("usa:removeItem", item, 1)
		end
		--print("playing food animation!")
		-- play animation:
		TriggerEvent("usa:playAnimation", animation.name, animation.dict, animation.duration)
	elseif type == "drink" then
		local animation = {
			dict = "amb@code_human_wander_drinking_fat@male@idle_a",
			name = "idle_c",
			duration = 12
		}
		local new_thirst_level = person.thirst_level + item.substance
		-- adjust level, notify and remove item
		if new_thirst_level <= 100.0 then
			person.thirst_level = new_thirst_level
			TriggerEvent("usa:notify", "Consumed: ~y~" .. item.name)
			TriggerServerEvent("usa:removeItem", item, 1)
		else
			local diff = new_thirst_level - 100.0
			--print("went over by: " .. diff)
			person.thirst_level = 100.0
			TriggerEvent("usa:notify", "You are now totally hydrated!")
			TriggerServerEvent("usa:removeItem", item, 1)
		end
		--print("playing drink animation!")
		-- play animation:
		TriggerEvent("usa:playAnimation", animation.name, animation.dict, animation.duration)
	else
		print("error: no item type specified!")
	end
end)

---------------
-- MAIN LOOP --
---------------
Citizen.CreateThread(function()
	local notified = false

	while true do
		Citizen.Wait(1)
		local myPed = GetPlayerPed(-1)
		--------------------
		-- debug messages --
		--------------------
		if settings.debug and not IsPedDeadOrDying(myPed, 1) then
			print("thirst_level: " .. person.thirst_level)
			print("hunger_level: " .. person.hunger_level)
		end
		-------------------------------------
		-- draw hunger & thirst indicators --
		-------------------------------------
		drawHud(person)
		-----------------------------------------------------------------------
		-- Tick down hunger & thirst levels until death (if not replenished) --
		-----------------------------------------------------------------------
		if not IsPedDeadOrDying(myPed, 1) then
			if person.thirst_level > 0.0 and person.hunger_level > 0.0 then
				if IsPedWalking(myPed) then
					if settings.debug then print("walking!") end
					person.thirst_level = person.thirst_level - (settings.thirst_global_mult + settings.walking_mult)
					person.hunger_level = person.hunger_level - (settings.hunger_global_mult + settings.walking_mult)
				elseif IsPedRunning(myPed) then
					if settings.debug then print("running!") end
					person.thirst_level = person.thirst_level - (settings.thirst_global_mult + settings.running_mult)
					person.hunger_level = person.hunger_level - (settings.hunger_global_mult + settings.running_mult)
				elseif IsPedSprinting(myPed) then
					if settings.debug then print("sprinting!") end
					person.thirst_level = person.thirst_level - (settings.thirst_global_mult + settings.sprinting_mult)
					person.hunger_level = person.hunger_level - (settings.hunger_global_mult + settings.sprinting_mult)
				elseif GetVehicleClass(GetVehiclePedIsIn(myPed, false)) == 13 then -- bicycles
					if settings.debug then print("bicycling!") end
					person.thirst_level = person.thirst_level - (settings.thirst_global_mult + settings.biking_mult)
					person.hunger_level = person.hunger_level - (settings.hunger_global_mult + settings.biking_mult)
				else
					if settings.debug then print("still!") end
					person.thirst_level = person.thirst_level - settings.thirst_global_mult
					person.hunger_level = person.hunger_level - settings.hunger_global_mult
				end
				-------------------------------------------------------------
				-- send notification when close to dying / LOWER PLAYER HP --
				-------------------------------------------------------------
				if not notified then
					if person.thirst_level < 10.0 then
						TriggerEvent("usa:notify", "~y~You are going to pass out from thirst soon!")
						PlaySoundFrontend(table.unpack(settings.sound_params))
						notified = true
					elseif person.hunger_level < 10.0 then
						TriggerEvent("usa:notify", "~y~You are going to pass out from hunger soon!")
						PlaySoundFrontend(table.unpack(settings.sound_params))
						notified = true
					else
						notified = false
					end
				end
			else
				local cause = "Undefined"
				if person.hunger_level <= 0.0 then cause = "Hunger" end
				if person.thirst_level <= 0.0 then cause = "Thirst" end
				if settings.debug then
					print("person died from hunger or thirst!")
					print("HP: " .. GetEntityHealth(myPed))
					print("Hunger Level: " .. person.hunger_level)
					print("Thirst Level: " .. person.thirst_level)
					print("killing...")
					print("cause: " .. cause)
				end
				SetEntityHealth(myPed, 0.0)
				person.thirst_level = 100.0
				person.hunger_level = 100.0
				TriggerEvent("usa:notify", "You have died from: ~y~" .. cause)
				TriggerEvent("chatMessage", "", {}, "You have died from: ^3" .. cause)
			end
		else
			if settings.debug then
				print("person is dead!")
			end
		end
	end
end)

-------------------
-- HUD FUNCTIONS --
-------------------
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(6)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

---------------------------------
-- HUNGER & THIRST HUD DISPLAY --
---------------------------------
function drawHud(person)
	------------
	-- Hunger Settings --
	------------
	if person.hunger_level < 100.0 and person.hunger_level >= 60.0 then
		settings.hud["hunger"].text = "Full"
		-- make green
		settings.hud["hunger"].r = 0
		settings.hud["hunger"].g = 179
		settings.hud["hunger"].b = 0
	elseif person.hunger_level < 60.0 and person.hunger_level >= 30.0 then
		settings.hud["hunger"].text = "Hungry"
		-- make orange
		settings.hud["hunger"].r = 255
		settings.hud["hunger"].g = 128
		settings.hud["hunger"].b = 0
	elseif person.hunger_level < 30.0 then
		-- make red
		settings.hud["hunger"].text = "Starving"
		settings.hud["hunger"].r = 255
		settings.hud["hunger"].g = 0
		settings.hud["hunger"].b = 0
	end
	------------
	-- Thirst Settings --
	------------
	if person.thirst_level < 100.0 and person.thirst_level >= 50.0 then
		settings.hud["thirst"].text = "Hydrated"
		-- make green
		settings.hud["thirst"].r = 9
		settings.hud["thirst"].g = 179
		settings.hud["thirst"].b = 0
	elseif person.thirst_level < 50.0 and person.thirst_level > 25.0 then
		settings.hud["thirst"].text = "Thirsty"
		-- make orange
		settings.hud["thirst"].r = 255
		settings.hud["thirst"].g = 128
		settings.hud["thirst"].b = 0
	elseif person.thirst_level < 25.0 then
		settings.hud["thirst"].text = "Parched"
		-- make red
		settings.hud["thirst"].r = 255
		settings.hud["thirst"].g = 0
		settings.hud["thirst"].b = 0
	end
	---------------
	-- SET CLOCK --
	---------------
	local hours = GetClockHours()
	local minutes = GetClockMinutes()
	local suffix = ""
	if hours > 12 then
		hours = hours - 12
		suffix = "PM"
	else
		if hours == 0 then hours = 12 end
		suffix = "AM"
	end
	local display_time = string.format("%d:%02d %s", hours, minutes, suffix)
	settings.hud["clock"].text = display_time
	------------
	-- Draw It --
	------------
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		drawTxt(0.66, 1.69, 1.0, 1.5, 0.4, settings.hud["clock"].text, settings.hud["clock"].r, settings.hud["clock"].g, settings.hud["clock"].b, 255) 
	else
		drawTxt(0.66, 1.714, 1.0, 1.5, 0.4, settings.hud["clock"].text, settings.hud["clock"].r, settings.hud["clock"].g, settings.hud["clock"].b, 255)
	end

	-- Background
	DrawRect(0.08555, 0.992, 0.14, 0.0149999999999998, 0, 0, 0, 140)

	-- Left Hunger
	Hunger = (person.hunger_level / 100) * 0.069
	DrawRect(0.0155 + (Hunger / 2), 0.991, Hunger, 0.00833, 221, 173, 122, 230)
	DrawRect(0.0504, 0.991, 0.07, 0.00833, 221, 173, 122, 130)

	-- Right Thirst
	Thirst = (person.thirst_level / 100) * 0.0685
	DrawRect(0.087 + (Thirst / 2), 0.991, Thirst, 0.00833, 188, 152, 206, 230)
	DrawRect(0.1214, 0.991, 0.069, 0.00833, 188, 152, 206, 130)
end
