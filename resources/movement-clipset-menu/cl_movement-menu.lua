RegisterNetEvent("GUI-movement:Title")
AddEventHandler("GUI-movement:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("GUI-movement:Option")
AddEventHandler("GUI-movement:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("GUI-movement:Bool")
AddEventHandler("GUI-movement:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI-movement:Int")
AddEventHandler("GUI-movement:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI-movement:StringArray")
AddEventHandler("GUI-movement:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI-movement:Update")
AddEventHandler("GUI-movement:Update", function()
	Menu.updateSelection()
end)

local CLIPSETS = {
  page_one = {
    {display_name = "Tough (Male)", clipset_name ="MOVE_M@TOUGH_GUY@"},
    {display_name = "Tough (Female)", clipset_name ="MOVE_F@TOUGH_GUY@"},
    {display_name = "Posh (Male)", clipset_name ="MOVE_M@POSH@"},
    {display_name = "Posh (Female)", clipset_name ="MOVE_F@POSH@"},
    {display_name = "Gangster 1 (Male)", clipset_name ="MOVE_M@GANGSTER@NG"},
    {display_name = "Gangster 1 (Female)", clipset_name ="MOVE_F@GANGSTER@NG"},
    {display_name = "Femme (Male)", clipset_name ="MOVE_M@FEMME@"},
    {display_name = "Femme (Female)", clipset_name ="MOVE_F@FEMME@"},
    {display_name = "Slow", clipset_name ="move_p_m_zero_slow"},
    {display_name = "Gangster 2", clipset_name ="move_m@gangster@var_i"},
    {display_name = "Casual", clipset_name ="move_m@casual@d"},
    {display_name = "Very Drunk", clipset_name ="MOVE_M@DRUNK@VERYDRUNK"}
  },
  page_two = {
    {display_name = "Very Drunk", clipset_name ="MOVE_M@DRUNK@VERYDRUNK"},
    {display_name = "Garbage", clipset_name ="missfbi4prepp1_garbageman"}
  }
}

Citizen.CreateThread(function()
	local menu = {
    open = false,
    key = 311, -- "K",
    page = 0-- home
  }
	while true do
    --print("menu.open: " .. tostring(menu.open))
    --print("menu.page: " .. menu.page)
    --print("last input method: " .. GetLastInputMethod(2))
		if IsControlJustPressed(0, menu.key) and GetLastInputMethod(2) then
      print("TOGGLING MOVEMENT CLIPSET MENU!!")
			menu.open = not menu.open
		end
    if menu.open then
      if menu.page == 0 then
  			TriggerEvent("GUI-movement:Title", "How ya feeling?")
  			TriggerEvent("GUI-movement:Option", "Page 1", function(cb)
  				if(cb) then
  					menu.page = 1
  				end
  			end)
        TriggerEvent("GUI-movement:Option", "Page 2", function(cb)
  				if(cb) then
  					menu.page = 2
  				end
  			end)
        TriggerEvent("GUI-movement:Option", "Reset", function(cb)
  				if(cb) then
  					menu.page = 0
            ResetPedMovementClipset( GetPlayerPed(-1), 0 )
  				end
  			end)
        TriggerEvent("GUI-movement:Option", "~y~Close", function(cb)
  				if(cb) then
  					menu.page = 0
            menu.open = false
  				end
  			end)
      elseif menu.page == 1 then
        TriggerEvent("GUI-movement:Title", "Page One")
        for i = 1, #CLIPSETS.page_one do
          local clip = CLIPSETS.page_one[i]
          TriggerEvent("GUI-movement:Option", clip.display_name, function(cb)
            if(cb) then
              -- set clipset:
              ResetPedMovementClipset( GetPlayerPed(-1), 0 )
              RequestAnimSet( clip.clipset_name )
              while ( not HasAnimSetLoaded( clip.clipset_name ) ) do
                Citizen.Wait( 1 )
              end
              SetClipset(clip.clipset_name)
              -- go to home:
              menu.page = 0
            end
          end)
        end
      elseif menu.page == 2 then
        TriggerEvent("GUI-movement:Title", "Page One")
        for i = 1, #CLIPSETS.page_two do
          local clip = CLIPSETS.page_two[i]
          TriggerEvent("GUI-movement:Option", clip.display_name, function(cb)
            if(cb) then
              -- set clipset:
              ResetPedMovementClipset( GetPlayerPed(-1), 0 )
              RequestAnimSet( clip.clipset_name )
              while ( not HasAnimSetLoaded( clip.clipset_name ) ) do
                Citizen.Wait( 1 )
              end
              SetClipset(clip.clipset_name)
              -- close menu:
              menu.page = 0
            end
          end)
        end
      end
			TriggerEvent("GUI-movement:Update")
		end

		Wait(0)
	end
end)

function SetClipset(clipset)
  local ped = GetPlayerPed( -1 )
  if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
    if ( not IsPauseMenuActive() ) then
      if not IsPedInAnyVehicle(ped, true) then
        print("clipset set: " .. clipset)
        SetPedMovementClipset( ped, clipset, 0.25 )
      end
    end
  end
end
