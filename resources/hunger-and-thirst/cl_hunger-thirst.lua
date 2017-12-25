--# by: minipunch
-- for USA REALISM RP
-- This script adds a realistic food and water requirement for players to stay alive while playing.

-----------------------
-- SETTINGS / PERSON --
-----------------------
local settings = {
  hud = {
    ["hunger"] = {text = "Full", x = 0.698, y = 1.62, r = 9, g = 179, b = 9, a = 255},
    ["thirst"] = {text = "Thirsty", x = 0.698, y = 1.645, r = 255, g = 128, b = 0, a = 255}
  },
  thirst_global_mult = 0.0013,
  hunger_global_mult = 0.00046,
  walking_mult = 0.0005,
  running_mult = 0.001,
  sprinting_mult = 0.0015,
  debug = true
}

local person = {
  hunger_level = 100.0,
  thirst_level = 100.0
}

---------------
-- MAIN LOOP --
---------------
Citizen.CreateThread(function()
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
        else
          if settings.debug then print("still!") end
          person.thirst_level = person.thirst_level - settings.thirst_global_mult
          person.hunger_level = person.hunger_level - settings.hunger_global_mult
        end
      else
        if settings.debug then
          print("person died!")
          print("HP: " .. GetEntityHealth(myPed))
          print("Hunger Level: " .. person.hunger_level)
          print("Thirst Level: " .. person.thirst_level)
          print("killing...")
        end
        SetEntityHealth(myPed, 0.0)
        person.thirst_level = 100.0
        person.hunger_level = 100.0
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
  elseif person.hunger_level < 60.0 and person.hunger_level > 30.0 then
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
  if person.thirst_level < 100.0 and person.thirst_level >= 60.0 then
    settings.hud["thirst"].text = "Hydrated"
    -- make green
    settings.hud["thirst"].r = 9
    settings.hud["thirst"].g = 179
    settings.hud["thirst"].b = 0
  elseif person.thirst_level < 60.0 and person.thirst_level > 30.0 then
    settings.hud["thirst"].text = "Thirsty"
    -- make orange
    settings.hud["thirst"].r = 255
    settings.hud["thirst"].g = 128
    settings.hud["thirst"].b = 0
  elseif person.thirst_level < 30.0 then
    settings.hud["thirst"].text = "Parched"
    -- make red
    settings.hud["thirst"].r = 255
    settings.hud["thirst"].g = 0
    settings.hud["thirst"].b = 0
  end
  ------------
  -- Draw It --
  ------------
  drawTxt(settings.hud["hunger"].x, settings.hud["hunger"].y, 1.0, 1.5, 0.4, settings.hud["hunger"].text, settings.hud["hunger"].r, settings.hud["hunger"].g, settings.hud["hunger"].b, settings.hud["hunger"].a)
  drawTxt(settings.hud["thirst"].x, settings.hud["thirst"].y, 1.0, 1.5, 0.4, settings.hud["thirst"].text, settings.hud["thirst"].r, settings.hud["thirst"].g, settings.hud["thirst"].b, settings.hud["thirst"].a)
end
