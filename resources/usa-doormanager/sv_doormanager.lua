--# by: minipunch
--# for USA REALISM rp
--# This script keeps a server sided track of frozen states on objects like doors or gates that can be toggled by being in the activation area and pressing "E"

local DOORS = {
  {name = "Bolingbroke Prison", locations = {{x = 1836.1, y = 2604.6,  z = 45.6}, {x = 1852.8, y = 2613.3, z = 45.7}}, distance = 30.0, model = 741314661, locked = false, draw_marker = true},
  {name = "Bolingbroke Prison", locations = {{x = 1826.6, y = 2605.1, z = 45.6}, {x = 1812.6, y = 2598.2, z = 45.5}}, distance = 30.0, model = 741314661, locked = false, draw_marker = true},
  {name = "BCSO Paleto / Side 1", locations = {{x = -429.9, y = 5986.8, z = 31.5}}, distance = 30.0, model = -1156020871, locked = false, draw_marker = true},
  {name = "BCSO Paleto / Side 2", locations = {{x = -431.4, y = 5988.3, z = 31.5}}, distance = 30.0, model = -1156020871, locked = false, draw_marker = true},
  {name = "Mission Row / Door 1", x = 464.2, y = -1002.6, z = 24.9, distance = 2.0, model = -1033001619, locked = false, draw_marker = false},
  {name = "Mission Row / Door 2", x = 463.8, y = -991.9, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false},
  {name = "Mission Row / Cell 1", x = 462.8, y = -993.7, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false},
  {name = "Mission Row / Cell 2", x = 462.75, y = -998.3, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false},
  {name = "Mission Row / Cell 3", x = 462.7, y = -1001.9, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false},
  {name = "Mission Row / Roof", x = 460.8, y = -985.8, z = 30.7, distance = 2.0, model = 749848321, locked = false, draw_marker = false},
  {name = "Mission Row / Office", x = 447.3,  y = -980.4, z = 30.7, distance = 2.0, model = -1320876379, locked = false, draw_marker = false},
  {name = "EMS Station - Paleto", x = -361.8, y = 6129.8, z = 31.4, distance = 30.0, model = -250842784, locked = false, draw_marker = false},
  {name = "BCSO Station Gate - Paleto", locations = {{x = -455.4, y = 6031.7, z = 31.3}, {x = -459.3, y = 6015.6, z = 31.5}}, distance = 30.0, model = -1483471451, locked = false, draw_marker = true},
  {name = "BCSO Station - Right Door", x = -443.6, y = 6015.3, z = 31.7, distance = 2.0, model = -1501157055, locked = false, draw_marker = false},
  {name = "BCSO Station - Left Door", x = -444.5, y = 6016.2, z = 31.7, distance = 2.0, model = -1501157055, locked = false, draw_marker = false},
  {name = "BCSO Station - Sidewalk", x = -449.8, y = 6024.5, z = 31.5, distance = 30.0, model = -1156020871, locked = false, draw_marker = false},
  {name = "BCSO Station - Sandy Shores", x = 1854.7, y = 3684.2, z = 34.3, distance = 20.0, model = -1765048490, locked = false, draw_marker = false},
  {name = "Prison Block / Cell 1", x = 1729.7, y = 2624.0, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 2", x = 1729.8, y = 2628.1, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 3", x = 1730.1, y = 2632.3, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 4", x = 1729.9, y = 2636.4, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 5", x = 1730.0, y = 2640.5, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 6", x = 1729.8, y = 2644.5, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 7", x = 1729.9, y = 2648.6, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 8", x = 1743.3, y = 2631.6, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 9", x = 1743.5, y = 2635.9, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 10", x = 1743.1, y = 2639.8, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 11", x = 1743.0, y = 2644.0, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 12", x = 1743.4, y = 2648.0, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 13", x = 1729.4, y = 2624.13, z = 49.25, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 14", x = 1729.4, y = 2628.07, z = 49.29, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 15", x = 1729.4, y = 2632.43, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 16", x = 1729.4, y = 2636.39, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 17", x = 1729.4, y = 2640.65, z = 49.28, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 18", x = 1729.4, y = 2644.57, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 19", x = 1729.4, y = 2648.07, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 20", x = 1743.8, y = 2623.47, z = 49.25, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 21", x = 1743.8, y = 2627.50, z = 49.26, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 22", x = 1743.8, y = 2631.81, z = 49.26, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 23", x = 1743.8, y = 2635.90, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 24", x = 1743.8, y = 2639.50, z = 49.28, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 25", x = 1743.8, y = 2643.50, z = 49.28, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 26", x = 1743.8, y = 2647.50, z = 49.26, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 27", x = 1729.4, y = 2624.50, z = 53.06, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 28", x = 1729.4, y = 2628.1, z = 53.06, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 29", x = 1729.4, y = 2632.50, z = 53.07, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 30", x = 1729.4, y = 2636.50, z = 53.07, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 31", x = 1729.4, y = 2640.50, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 32", x = 1729.4, y = 2644.50, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 33", x = 1729.4, y = 2648.50, z = 53.09, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 34", x = 1743.8, y = 2623.60, z = 53.07, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 35", x = 1743.8, y = 2627.60, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 36", x = 1743.8, y = 2631.70, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 37", x = 1743.8, y = 2635.70, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 38", x = 1743.8, y = 2639.80, z = 53.09, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 39", x = 1743.8, y = 2643.80, z = 53.09, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 40", x = 1743.8, y = 2647.95, z = 53.10, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Mission Row / Holding Cells Entrance 1", x = 469.3, y = -1015.2, z = 26.4, distance = 5.0, model = -2023754432, locked = false, draw_marker = false, cell_block = false},
  {name = "Mission Row / Holding Cells Entrance 2", x = 468.1, y = -1015.1, z = 26.4, distance = 5.0, model = -2023754432, locked = false, draw_marker = false, cell_block = false},
  {name = "Mission Row / Front Door 1", x = 434.3, y = -980.9, z = 30.7, distance = 2.0, model = -1215222675, locked = false, draw_marker = false, cell_block = false},
  {name = "Mission Row / Front Door 2", x = 434.1, y = -982.6, z = 30.7, distance = 2.0, model = 320433149, locked = false, draw_marker = false, cell_block = false},
  {name = "Mission Row / Back Gate", locations = {{x = 487.4, y = -1024.3, z = 28.1}, {x = 490.1, y = -1024.1, z = 28.1}}, distance = 30.0, model = -1603817716, locked = false, draw_marker = true, cell_block = false},
  {name = "Mission Row / Cells Door 1", x = 443.9, y = -988.6, z = 30.7, distance = 2.0, model = 185711165, locked = false, draw_marker = false, cell_block = false},
  {name = "Mission Row / Cells Door 2", x = 445.4, y = -988.6, z = 30.7, distance = 2.0, model = 185711165, locked = false, draw_marker = false, cell_block = false},
  {name = "Mission Row / Side Room 1", x = 443.7, y = -992.4, z = 30.7, distance = 2.0, model = -131296141, locked = false, draw_marker = false, cell_block = false},
  {name = "Mission Row / Side Room 2", x = 443.6, y = -993.9, z = 30.7, distance = 2.0, model = -131296141, locked = false, draw_marker = false, cell_block = false},
  {name = "Mission Row / Vehicle Gate", locations = {{x = 406.3, y = -1016.8, z = 29.4}, {x = 422.6, y = -1018.5, z = 29.1}}, distance = 30.0, model = 725274945, locked = false, draw_marker = true, cell_block = false},
  {name = "Mission Row / Vehicle Access", x = 423.9, y = -998.8, z = 30.7, distance = 5.0, model = -1635579193, locked = false, draw_marker = false, cell_block = false},
  {name = "SSPD / Cell 1", x = 1848.6, y = 3708.2, z = 1.06, distance = 2.0, model = -642608865, locked = false, draw_marker = false},
  {name = "SSPD / Cell 2", x = 1847.6, y = 3709.9, z = 1.05, distance = 2.0, model = -642608865, locked = false, draw_marker = false},
  {name = "SSPD / Cell 3", x = 1844.8, y = 3705.2, z = 1.06, distance = 2.0, model = -642608865, locked = false, draw_marker = false},
  {name = "SSPD / Cell 4", x = 1843.5, y = 3707.0, z = 1.06, distance = 2.0, model = -642608865, locked = false, draw_marker = false}
}

RegisterServerEvent("doormanager:checkDoorLock")
AddEventHandler("doormanager:checkDoorLock", function(index, door, x, y, z)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local user_job = user.getActiveCharacterData("job")
  if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "judge" then
    if not DOORS[index].locked then
      DOORS[index].locked = true
      TriggerClientEvent("usa:notify", source, "Door has been ~y~locked")
    else
      DOORS[index].locked = false
      TriggerClientEvent("usa:notify", source, "Door has been ~y~unlocked")
    end
    TriggerClientEvent("doormanager:toggleDoorLock", -1, index, DOORS[index].locked, x, y, z)
    if DOORS[index].locked then
      TriggerClientEvent("chatMessage", source, "", {}, "^0You locked " .. door.name .. ".")
    else
      TriggerClientEvent("chatMessage", source, "", {}, "^0You unlocked " .. door.name .. ".")
    end
  else
    TriggerClientEvent("usa:notify", source,"Area prohibited!")
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
