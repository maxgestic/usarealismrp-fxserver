--# by: minipunch
--# for USA REALISM rp
--# This script keeps a server sided track of frozen states on objects like doors or gates that can be toggled by being in the activation area and pressing "E"

local DOORS = {
  {name = "Bolingbroke Prison", locations = {{x = 1836.1, y = 2604.6,  z = 45.6}, {x = 1852.8, y = 2613.3, z = 45.7}}, distance = 30.0, model = 741314661, locked = true, draw_marker = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Bolingbroke Prison", locations = {{x = 1826.6, y = 2605.1, z = 45.6}, {x = 1812.6, y = 2598.2, z = 45.5}}, distance = 30.0, model = 741314661, locked = true, draw_marker = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "BCSO Paleto / Side 1", locations = {{x = -429.9, y = 5986.8, z = 31.5}}, distance = 30.0, model = -1156020871, locked = false, draw_marker = true, _dist = 1.5, offsetX=0, offsetY=1.6, offsetZ=-0.09, heading=135, angle=360, ymap = false, allowedJobs = {'sheriff'}},
  {name = "BCSO Paleto / Side 2", locations = {{x = -431.4, y = 5988.3, z = 31.5}}, distance = 30.0, model = -1156020871, locked = true, draw_marker = true, _dist = 1.5, static = true, ymap = false, allowedJobs = {'sheriff'}},
  {name = "Mission Row / Door 1", x = 464.192, y = -1003.638, z = 24.9, distance = 2.0, model = -1033001619, locked = true, draw_marker = false, offsetX=0, offsetY=1.13, offsetZ=0.05, heading=0, angle=360, _dist = 1.0, ymap = false, allowedJobs = {'sheriff', 'doc'}},
  {name = "Mission Row / Door 2", x = 463.72, y = -992.7, z = 24.9, distance = 2.0, model = 631614199, locked = true, draw_marker = false, offsetX=0, offsetY=1.12, offsetZ=0.025, heading=0, angle=180, _dist = 1.0, ymap = false, allowedJobs = {'sheriff', 'doc'}},
  {name = "Mission Row / Cell 1", x = 461.7, y = -993.6, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false, offsetX=0, offsetY=1.12, offsetZ=0.025, heading=270, angle=180, _dist = 1.0, ymap = false, allowedJobs = {'sheriff','doc'}},
  {name = "Mission Row / Cell 2", x = 462.75, y = -998.3, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false, offsetX=0, offsetY=1.12, offsetZ=0.025, heading=90, angle=180, _dist = 1.0, ymap = false, allowedJobs = {'sheriff','doc'}},
  {name = "Mission Row / Cell 3", x = 462.7, y = -1001.9, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false, offsetX=0, offsetY=1.12, offsetZ=0.025, heading=90, angle=180, _dist = 1.0, ymap = false, allowedJobs = {'sheriff', 'doc'}},
  {name = "Mission Row / Office", x = 447.3,  y = -980.4, z = 30.7, distance = 2.0, model = -1320876379, locked = true, draw_marker = false, offsetX=0, offsetY=1.15, offsetZ=-0.1, heading=180, angle=180, _dist = 1.0, ymap = false, allowedJobs = {'sheriff'}},
  {name = "EMS Station - Paleto", x = -361.8, y = 6129.8, z = 31.4, distance = 30.0, model = -250842784, locked = false, draw_marker = false, _dist = 1.5, ymap = true, allowedJobs = {'ems'}},
  {name = "Mission Row / Roof", x = 461.2, y = -986.0, z = 30.7, distance = 2.0, model = 749848321, locked = true, draw_marker = false, offsetX=0, offsetY=-1.05, offsetZ=0.10, heading=89, angle=360, _dist = 1.0, ymap = false, allowedJobs = {'sheriff', 'doc'}},
  {name = "BCSO Station Gate - Paleto", locations = {{x = -455.4, y = 6031.7, z = 31.3}, {x = -459.3, y = 6015.6, z = 31.5}}, distance = 30.0, model = -1483471451, locked = false, draw_marker = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "BCSO Station - Sidewalk", x = -449.8, y = 6024.3, z = 31.5, distance = 2.0, model = -1156020871, locked = true, draw_marker = false, offsetX=0, offsetY=1.5, offsetZ=-0.095, heading=315, angle=360, _dist = 1.0, ymap = false, allowedJobs = {'sheriff'}},
  {name = "BCSO Station - Sandy Shores", x = 1855.0, y = 3683.5, z = 34.2, distance = 1.0, model = -1765048490, locked = false, draw_marker = false, offsetX=0, offsetY=1.24, offsetZ=-0.1, heading=30, angle=180, _dist = 1.0, ymap = false, allowedJobs = {'sheriff'}},
  {name = "Prison Block / Cell 1", x = 1729.7, y = 2624.0, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 2", x = 1729.8, y = 2628.1, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 3", x = 1730.1, y = 2632.3, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 4", x = 1729.9, y = 2636.4, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 5", x = 1730.0, y = 2640.5, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 6", x = 1729.8, y = 2644.5, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 7", x = 1729.9, y = 2648.6, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 8", x = 1743.3, y = 2631.6, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 9", x = 1743.5, y = 2635.9, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 10", x = 1743.1, y = 2639.8, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 11", x = 1743.0, y = 2644.0, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 12", x = 1743.4, y = 2648.0, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 13", x = 1729.4, y = 2624.13, z = 49.25, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 14", x = 1729.4, y = 2628.07, z = 49.29, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 15", x = 1729.4, y = 2632.43, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 16", x = 1729.4, y = 2636.39, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 17", x = 1729.4, y = 2640.65, z = 49.28, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 18", x = 1729.4, y = 2644.57, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 19", x = 1729.4, y = 2648.07, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 20", x = 1743.8, y = 2623.47, z = 49.25, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 21", x = 1743.8, y = 2627.50, z = 49.26, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 22", x = 1743.8, y = 2631.81, z = 49.26, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 23", x = 1743.8, y = 2635.90, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 24", x = 1743.8, y = 2639.50, z = 49.28, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 25", x = 1743.8, y = 2643.50, z = 49.28, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 26", x = 1743.8, y = 2647.50, z = 49.26, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 27", x = 1729.4, y = 2624.50, z = 53.06, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 28", x = 1729.4, y = 2628.10, z = 53.06, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 29", x = 1729.4, y = 2632.50, z = 53.07, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 30", x = 1729.4, y = 2636.50, z = 53.07, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 31", x = 1729.4, y = 2640.50, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 32", x = 1729.4, y = 2644.50, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 33", x = 1729.4, y = 2648.50, z = 53.09, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 34", x = 1743.8, y = 2623.60, z = 53.07, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 35", x = 1743.8, y = 2627.60, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 36", x = 1743.8, y = 2631.70, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 37", x = 1743.8, y = 2635.70, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 38", x = 1743.8, y = 2639.80, z = 53.09, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 39", x = 1743.8, y = 2643.80, z = 53.09, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "Prison Block / Cell 40", x = 1743.8, y = 2647.95, z = 53.10, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  -- {name = 'Mission Row / Armory Entrance', x = 453.118, y = -982.452, z = 30.689, distance = 0.1, model = 749848321, locked = true, draw_marker = false, offsetX=0, offsetY=1.05, offsetZ=0.25, heading=270, angle=180, _dist = 1.5, ymap = false}, doesnt work?
  {name = "Mission Row / Holding Cells Entrance 1", x = 468.1, y = -1014.3299, z = 26.4, distance = 5.0, model = -2023754432, locked = true, draw_marker = false, cell_block = false, offsetX=0, offsetY=1.12, offsetZ=0, heading=0, angle=360, _dist = 1.0, ymap = false, allowedJobs = {'sheriff', 'doc'}},
  {name = "Mission Row / Holding Cells Entrance 2", x = 469.3, y = -1014.4, z = 26.4, distance = 5.0, model = -2023754432, locked = true, draw_marker = false, cell_block = false, static = true, _dist = 1.0, ymap = false, allowedJobs = {'sheriff', 'doc'}},
  {name = "Mission Row / Back Gate", locations = {{x = 487.4, y = -1024.3, z = 28.1}, {x = 490.1, y = -1024.1, z = 28.1}}, distance = 30.0, model = -1603817716, locked = false, draw_marker = true, cell_block = false, _dist = 1.0, ymap = false, allowedJobs = {'sheriff', 'doc'}},
  {name = "Mission Row / Cells Door 1", x = 443.9, y = -988.6, z = 30.7, distance = 2.0, model = 185711165, locked = true, draw_marker = false, cell_block = false, static = true, _dist = 1.0, ymap = false, allowedJobs = {'sheriff', 'doc'}},
  {name = "Mission Row / Cells Door 2", x = 445.22, y = -989.4, z = 30.7, distance = 2.0, model = 185711165, locked = true, draw_marker = false, cell_block = false, offsetX=0, offsetY=1.24, offsetZ=0, heading=0, angle=180, _dist = 1.0, ymap = false, allowedJobs = {'sheriff', 'doc'}},
  {name = "Mission Row / Side Room 1", x = 443.7, y = -992.4, z = 30.7, distance = 2.0, model = -131296141, locked = true, draw_marker = false, cell_block = false, static = true, _dist = 1.0, ymap = false, allowedJobs = {'sheriff'}},
  {name = "Mission Row / Side Room 2", x = 443.6, y = -993.9, z = 30.7, distance = 2.0, model = -131296141, locked = false, draw_marker = false, cell_block = false, offsetX=0, offsetY=1.24, offsetZ=0, heading=270, angle=180, _dist = 1.5, ymap = false, allowedJobs = {'sheriff'}},
  {name = "Mission Row / Vehicle Gate", locations = {{x = 406.3, y = -1016.8, z = 29.4}, {x = 422.6, y = -1018.5, z = 29.1}}, distance = 30.0, model = 725274945, locked = false, draw_marker = true, cell_block = false, _dist = 1.5, ymap = true, allowedJobs = {'sheriff'}},
  {name = "Mission Row / Vehicle Access", x = 423.9, y = -998.8, z = 30.7, distance = 5.0, model = -1635579193, locked = false, draw_marker = false, cell_block = false, _dist = 1.5, ymap = true, allowedJobs = {'sheriff'}},
  {name = "SSPD / Cell 1", x = 1848.6, y = 3708.2, z = 1.06, distance = 2.0, model = -642608865, locked = false, draw_marker = false, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "SSPD / Cell 2", x = 1847.6, y = 3709.9, z = 1.05, distance = 2.0, model = -642608865, locked = false, draw_marker = false, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "SSPD / Cell 3", x = 1844.8, y = 3705.2, z = 1.06, distance = 2.0, model = -642608865, locked = false, draw_marker = false, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}},
  {name = "SSPD / Cell 4", x = 1843.5, y = 3707.0, z = 1.06, distance = 2.0, model = -642608865, locked = false, draw_marker = false, _dist = 1.5, ymap = true, allowedJobs = {'sheriff', 'doc'}}
}

-- allowedJobs - table of job names allowed to use door, the player's job must match any value in the list for the door to lock/unlock
-- offsetX, offsetY, offsetZ - 3D text offset from the object's coordinates (used to display text)
-- static - true will result in the door being left in the state defined (locked/unlocked), and will prevent text from displaying for locking/unlocking (used to lock one of two double doors permanently)
-- _dist - distance which needs to be met before the door can be locked/unlocked
-- heading - the heading of the door in it's regular position (when a player is not holding it open) -- this value should always be somewhat a multiple of 5 as rockstar like uniformity e.g., 270, 90, 180, 30, 315
-- angle - whether the axis of the door is inverted, this is either 180 or 360 (used to display text, as sometimes text is displayed on the opposite axis to the one on door)
-- ymap - true will result in the door not using any of the above new values for 3D text, and having the text display at the x, y, z coords on the list

RegisterServerEvent("doormanager:checkDoorLock")
AddEventHandler("doormanager:checkDoorLock", function(index, door, x, y, z)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local user_job = user.getActiveCharacterData("job")
  for i = 1, #DOORS[index].allowedJobs do
    if user_job == DOORS[index].allowedJobs[i] then
        if not DOORS[index].locked then
          DOORS[index].locked = true
        else
          DOORS[index].locked = false
        end
        TriggerClientEvent("doormanager:toggleDoorLock", -1, index, DOORS[index].locked, x, y, z)
        if DOORS[index].locked then
          TriggerClientEvent("usa:notify", source, "Locked " .. door.name .. ".")
        else
          TriggerClientEvent("usa:notify", source, "Unlocked " .. door.name .. ".")
        end
        break
    else
      TriggerClientEvent("usa:notify", source,"Area prohibited!")
    end
  end
end)

RegisterNetEvent("doormanager:firstJoin")
AddEventHandler("doormanager:firstJoin", function()
    print("** loading usa-doormanager doors **")
  TriggerClientEvent("doormanager:update", source, DOORS)
end)

TriggerEvent('es:addGroupCommand', 'lockdebug', 'owner', function(source, args, user)
  TriggerClientEvent("doormanager:debug", source)
end, {
	help = "DEBUG: Debug the door lock system"
})

