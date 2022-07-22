local isInRagdoll = false

Citizen.CreateThread(function()
 while true do
    Citizen.Wait(10)
    if isInRagdoll then
      SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local isAltKeyPressed = (IsControlPressed(2, Config.RagdollKeybind2) or IsDisabledControlPressed(2, Config.RagdollKeybind2))
    if IsControlJustPressed(2, Config.RagdollKeybind) and isAltKeyPressed and Config.RagdollEnabled and IsPedOnFoot(PlayerPedId()) then
      if isInRagdoll then
          isInRagdoll = false
      else
          isInRagdoll = true
          Wait(500)
      end
    end
  end
end)

