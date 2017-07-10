local playerCount = 0
local list = {}

RegisterServerEvent('hardcap:playerActivated')

AddEventHandler('hardcap:playerActivated', function()
local numberSource = tonumber(source)
  if not list[numberSource] then
    playerCount = playerCount + 1
    list[numberSource] = true
    print("just added player with numberSource = " .. numberSource .. " to the hardcap list")
	print("player count = " .. playerCount)
  end
end)

AddEventHandler('playerDropped', function()
local numberSource = tonumber(source)
  if list[numberSource] then
    playerCount = playerCount - 1
    list[numberSource] = nil
    print("just removed player with numberSource = " .. numberSource .. " from the hardcap list")
	print("player count = " .. playerCount)
  end
end)

AddEventHandler('playerConnecting', function(name, setReason)
  local cv = GetConvarInt('sv_maxclients', 32)

  print('Connecting: ' .. name)

  if playerCount >= cv then
    print('Full. :(')
    setReason('This server is full (past ' .. tostring(cv) .. ' players).')
    CancelEvent()
  end
end)
