--# by: minipunch
--# for USA REALISM rp
--# This script keeps a server sided track of frozen states on objects like doors or gates that can be toggled by being in the activation area and pressing "E"

local DOORS = {
  {name = "Bolingbroke Prison", x = 1818.662, y = 2606.8, z = 45.59, model = 741314661, locked = true, _dist = 8.0, gate = true, offset={0.0, 3.65, 2.8}, lockedCoords={1818.54, 2604.811, 44.607}, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Bolingbroke Prison", x = 1845.05, y = 2607.21, z = 45.57, model = 741314661, locked = true, _dist = 8.0, gate = true, offset={0.0, 3.65, 2.8}, lockedCoords={1844.99, 2604.811, 44.636}, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  --{name = "BCSO Paleto / Side 1", model = -1156020871, locked = false, _dist = 1.5, offset = {0.0, 1.6, -0.09}, heading=135, allowedJobs = {'sheriff'}},
  --{name = "BCSO Paleto / Side 2", model = -1156020871, locked = true, _dist = 1.5, static = true, allowedJobs = {'sheriff'}},
  {name = "Mission Row / Door 1", x = 464.192, y = -1003.638, z = 24.9, model = -1033001619, locked = true, offset={0.0, -1.13, 0.05}, heading=0, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Door 2", x = 463.72, y = -992.7, z = 24.9, model = 631614199, locked = true, offset={0.0, 1.12, 0.025}, heading=0, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Cell 1", x = 461.7, y = -993.6, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=270, _dist = 1.0, allowedJobs = {'sheriff','corrections'}},
  {name = "Mission Row / Cell 2", x = 462.75, y = -998.3, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=90, _dist = 1.0, allowedJobs = {'sheriff','corrections'}},
  {name = "Mission Row / Cell 3", x = 462.7, y = -1001.9, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=90, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Office", x = 447.3,  y = -980.4, z = 30.7, model = -1320876379, locked = true, offset={0.0, 1.15, -0.1}, heading=180, _dist = 1.0, allowedJobs = {'sheriff'}},
  {name = "EMS Station - Paleto", x = -361.8, y = 6129.8, z = 31.4, model = -250842784, locked = false, _dist = 1.5, allowedJobs = {'ems'}},
  {name = "Mission Row / Roof", x = 461.2, y = -986.0, z = 30.7, model = 749848321, locked = true, offset={0.0, 1.05, 0.10}, heading=89, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  --{name = "BCSO Station Gate - Paleto", model = -1483471451, locked = false, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "BCSO Station - Sidewalk", x = -449.8, y = 6024.3, z = 31.5, model = -1156020871, locked = true, offset={0.0, -1.5, -0.095}, heading=315, _dist = 1.0, allowedJobs = {'sheriff'}},
  {name = "BCSO Station - Sandy Shores", x = 1855.0, y = 3683.5, z = 34.2, model = -1765048490, locked = false, offset={0.0, 1.24, -0.1}, heading=30, _dist = 1.0, allowedJobs = {'sheriff'}},
  {name = "Prison Block / Cell 1", x = 1729.7, y = 2624.0, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 2", x = 1729.8, y = 2628.1, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 3", x = 1730.1, y = 2632.3, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 4", x = 1729.9, y = 2636.4, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 5", x = 1730.0, y = 2640.5, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 6", x = 1729.8, y = 2644.5, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 7", x = 1729.9, y = 2648.6, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 8", x = 1743.3, y = 2631.6, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 9", x = 1743.5, y = 2635.9, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 10", x = 1743.1, y = 2639.8, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 11", x = 1743.0, y = 2644.0, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 12", x = 1743.4, y = 2648.0, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 13", x = 1729.4, y = 2624.13, z = 49.25, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 14", x = 1729.4, y = 2628.07, z = 49.29, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 15", x = 1729.4, y = 2632.43, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 16", x = 1729.4, y = 2636.39, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 17", x = 1729.4, y = 2640.65, z = 49.28, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 18", x = 1729.4, y = 2644.57, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 19", x = 1729.4, y = 2648.07, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 20", x = 1743.8, y = 2623.47, z = 49.25, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 21", x = 1743.8, y = 2627.50, z = 49.26, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 22", x = 1743.8, y = 2631.81, z = 49.26, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 23", x = 1743.8, y = 2635.90, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 24", x = 1743.8, y = 2639.50, z = 49.28, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 25", x = 1743.8, y = 2643.50, z = 49.28, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 26", x = 1743.8, y = 2647.50, z = 49.26, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 27", x = 1729.4, y = 2624.50, z = 53.06, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 28", x = 1729.4, y = 2628.10, z = 53.06, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 29", x = 1729.4, y = 2632.50, z = 53.07, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 30", x = 1729.4, y = 2636.50, z = 53.07, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 31", x = 1729.4, y = 2640.50, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 32", x = 1729.4, y = 2644.50, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 33", x = 1729.4, y = 2648.50, z = 53.09, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 34", x = 1743.8, y = 2623.60, z = 53.07, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 35", x = 1743.8, y = 2627.60, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 36", x = 1743.8, y = 2631.70, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 37", x = 1743.8, y = 2635.70, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 38", x = 1743.8, y = 2639.80, z = 53.09, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 39", x = 1743.8, y = 2643.80, z = 53.09, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Prison Block / Cell 40", x = 1743.8, y = 2647.95, z = 53.10, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Holding Cells Entrance 1", x = 468.1, y = -1014.3299, z = 26.4, model = -2023754432, locked = true, offset={0.0, -1.12, 0.0}, heading=0, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Holding Cells Entrance 2", x = 469.3, y = -1014.4, z = 26.4, model = -2023754432, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Back Gate", x = 488.90, y = -1019.88, z = 28.21, model = -1603817716, locked = true, _dist = 8.0, gate = true, offset={0.0, -3.0, 1.5}, lockedCoords={488.89, -1017.35, 27.14}, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Cells Door 1", x = 443.9, y = -988.6, z = 30.7, model = 185711165, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Cells Door 2", x = 445.22, y = -989.4, z = 30.7, model = 185711165, locked = true, offset={0.0, 1.24, 0.0}, heading=0, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Side Room 1", x = 443.7, y = -992.4, z = 30.7, model = -131296141, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff'}},
  {name = "Mission Row / Side Room 2", x = 443.6, y = -993.9, z = 30.7, model = -131296141, locked = false, offset={0.0, 1.24, 0.0}, heading=270, _dist = 1.5, allowedJobs = {'sheriff'}},
  --{name = "Mission Row / Vehicle Gate", model = 725274945, locked = false, _dist = 1.5, allowedJobs = {'sheriff'}},
  --{name = "Mission Row / Vehicle Access", x = 423.9, y = -998.8, z = 30.7, model = -1635579193, locked = false, _dist = 1.5, allowedJobs = {'sheriff'}},
  {name = "SSPD / Cell 1", x = 1848.6, y = 3708.2, z = 1.06, model = -642608865, locked = false, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "SSPD / Cell 2", x = 1847.6, y = 3709.9, z = 1.05, model = -642608865, locked = false, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "SSPD / Cell 3", x = 1844.8, y = 3705.2, z = 1.06, model = -642608865, locked = false, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "SSPD / Cell 4", x = 1843.5, y = 3707.0, z = 1.06, model = -642608865, locked = false, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = 'Hospital / Door 1', x = 328.3, y = -585.03, z = 43.3, model = -770740285, locked = false, offset={0.0, 1.02, 0.05}, heading = 160, _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor'}},
  {name = 'Hospital / Door 2', x = 331.1, y = -586.03, z = 43.3, model = -770740285, locked = false, offset={0.0, 1.02, 0.05}, heading = 340, _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor'}},
  {name = 'BCSO Paleto - Door 1', x = -443.16, y = 6015.41, z = 31.71, model = -1501157055, locked = false, offset={0.0, 1.24, -0.1}, heading = 315, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = 'BCSO Paleto - Door 2', x = -444.3, y = 6016.3, z = 31.71, model = -1501157055, locked = true, _dist = 1.5, static = true, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = 'Mission Row / Armory', x = 452.71, y = -982.616, z = 30.6, model = 749848321, locked = true, offset={0.0, 1.05, 0.3}, heading = 270, _dist = 1.5, allowedJobs = {'sheriff'}},
  {name = 'Mission Row / Door 3', x = 465.26, y = -988.99, z = 24.91, model = -131296141, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff'}},
  {name = 'Mission Row / Door 4', x = 465.54, y = -990.56, z = 24.91, model = -131296141, locked = false, offset={0.0, 1.22, 0.025}, heading = 270, _dist = 1.5, allowedJobs = {'sheriff'}},
  {name = 'Mission Row / Interview Room', x = 468.00, y = -992.85, z = 24.91, model = -131296141, locked = true, offset={0.0, 1.22, 0.025}, heading = 0, _dist = 1.5, allowedJobs = {'sheriff'}},
  {name = 'Mission Row / Interview Door', x = 470.36, y = -994.47, z = 24.91, model = -131296141, locked = true, offset={0.0, 1.22, 0.025}, heading = 90, _dist = 1.5, allowedJobs = {'sheriff'}},
  {name = 'Mission Row / Photo Door', x = 470.22, y = -987.20, z = 24.91, model = -131296141, locked = true, offset={0.0, 1.22, 0.025}, heading = 180, _dist = 1.5, allowedJobs = {'sheriff'}},
  {name = 'Mission Row / Interview Door 2', x = 477.70, y = -987.27, z = 24.91, model = -131296141, locked = true, offset={0.0, 1.22, 0.025}, heading = 359, _dist = 1.5, allowedJobs = {'sheriff'}},
  {name = 'Courthouse / Office', x = 226.89, y = -415.70, z = -118.46, model = 34120519, locked = true, offset={0.0, 1.1, 0.0}, heading = 250, _dist = 1.0, allowedJobs = {'sheriff', 'judge'}},
  {name = 'Courthouse / Door 1', x = 238.94, y = -420.29, z = -118.46, model = 110411286, locked = true, offset={0.0, -1.2, 0.0}, heading = 250, _dist = 1.0, allowedJobs = {'judge'}},
  {name = 'Courthouse / Door 2', x = 238.33, y = -421.69, z = -118.46, model = 110411286, locked = true, static = true, _dist = 1.0, allowedJobs = {'judge'}},
  {name = 'Courthouse / Entrance 1', x = 234.42, y = -416.00, z = -118.46, model = 110411286, locked = false, offset={0.0, -1.2, 0.0}, heading = 160, _dist = 1.0, allowedJobs = {'judge'}},
  {name = 'Courthouse / Entrance 2', x = 232.99, y = -415.870, z = -118.46, model = 110411286, locked = true, static = true, _dist = 1.0, allowedJobs = {'judge'}},
  {name = 'Nightclub / Door 1', x = -1621.88, y = -3016.0, z = -75.20, model = -1119680854, locked = true, static = true, _dist = 1.0},
  {name = 'Nightclub / Door 2', x = -1621.15, y = -3019.06, z = -75.20, model = 1695461688, locked = true, static = true, _dist = 1.0},
  {name = 'Nightclub / Door 3', x = -1610.8, y = -3004.98, z = -79.0, model = 1743859485, locked = true, static = true, _dist = 1.0},
  {name = 'Legal Offices / Door 1', x = 121.21, y = -757.02, z = 242.15, model = -1821777087, locked = true, static = true, _dist = 1.0},
  {name = 'Legal Offices / Door 2', x = 143.16, y = -759.65, z = 242.15, model = -1821777087, locked = true, static = true, _dist = 1.0},
  {name = 'LSSD Davis / Door 1', x = 392.31, y = -1635.45, z = 29.29, model = -1156020871, locked = true, offset={0.0, -1.6, -0.1}, heading = 50, _dist = 1.0, allowedJobs = {'sheriff'}},
  {name = 'LSSD Davis / Gate 1', x = 398.32, y = -1607.73, z = 29.29, model = 1286535678, locked = true, _dist = 8.0, gate = true, offset={3.0, -2.5, 1.5}, lockedCoords = {397.88, -1607.38, 28.33}, allowedJobs = {'sheriff'}},
  {name = 'Mission Row / Front Gate', x = 411.4, y = -1028.26, z = 29.39, model = -512634970, locked = true, _dist = 10.0, gate = true, offset={0.0, 3.0, 1.5}, lockedCoords = {410.80, -1028.15, 28.38}, allowedJobs = {'sheriff', 'corrections', 'dai'}},
  {name = "Mission Row / Garage Door", x = 427.42, y = -1016.92, z = 28.97, model = 631614199, locked = true, offset={0.0, 1.12, 0.025}, heading=81, _dist = 1.0, allowedJobs = {'sheriff','corrections'}},
  {name = "Eclipse Towers / Heist Room", x = -767.55, y = 331.14, z = 211.39, model = 34120519, locked = true, static = true, _dist = 1.0},
  {name = "Pacific Standard Bank / Door 1", x = 261.96, y = 221.79, z= 106.28, model = 746855201, locked = true, offset ={0.0, -1.2, 0.0}, heading = 250.0, _dist = 1.0, lockpickable = true, allowedJobs = {'sheriff'}},
  {name = "Pacific Standard Bank / Door 2", x = 256.89, y = 220.34, z = 106.28, model = -222270721, locked = true, offset ={0.0, -1.2, 0.0}, heading = 340.0, _dist = 1.0, lockpickable = true, allowedJobs = {'sheriff'}},
  {name = "Pacific Standard Bank / Door 3", x = 256.76, y = 206.78, z = 110.28, model = 1956494919, locked = true, offset ={0.0, 1.25, -0.2}, heading = 250.0, _dist = 1.0, lockpickable = true, allowedJobs = {'sheriff'}},
  {name = "DA Office / Door 1", x = -74.45, y = -821.88, z = 243.38, model = 220394186, locked = true, offset = {0.0, 0.7, 0.05}, heading = 340.0, _dist = 1.0, allowedJobs = {'da', 'judge'}},
  {name = "DA Office / Door 2", x = -75.15, y = -821.65, z = 243.38, model = 220394186, locked = true, static = true, _dist = 1.0},
  {name = "DA Office / Door 3", x = -77.35, y = -808.07, z = 243.38, model = -88942360, locked = true, offset = {0.0, 1.12, -0.02}, heading = 340.0, _dist = 1.0, allowedJobs = {'da', 'judge'}},
  {name = "DA Office / Door 4", x = -77.79, y = -814.25, z = 243.38, model = -88942360, locked = true, offset = {0.0, 1.12, -0.02}, heading = 250.0, _dist = 1.0, allowedJobs = {'da', 'judge'}},
}

-- allowedJobs - table of job names allowed to use door, the player's job must match any value in the list for the door to lock/unlock
-- offsetX, offsetY, offsetZ - 3D text offset from the object's coordinates (used to display text)
-- static - true will result in the door being left in the state defined (locked/unlocked), and will prevent text from displaying for locking/unlocking (used to lock one of two double doors permanently)
-- _dist - distance which needs to be met before the door can be locked/unlocked
-- heading - the heading of the door in it's regular position (when a player is not holding it open) -- this value should always be somewhat a multiple of 5 as rockstar like uniformity e.g., 270, 90, 180, 30, 315
-- ymap - true will result in the door not using any of the above new values for 3D text, and having the text display at the x, y, z coords on the list

RegisterServerEvent("doormanager:checkDoorLock")
AddEventHandler("doormanager:checkDoorLock", function(index, x, y, z, lockpicked)
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local user_job = user.getActiveCharacterData("job")
  local da_rank = user.getActiveCharacterData('daRank')
  --print(DOORS[index].name)
  for i = 1, #DOORS[index].allowedJobs do
    if user_job == DOORS[index].allowedJobs[i] or (lockpicked and DOORS[index].lockpickable) or (DOORS[index].allowedJobs[i] == 'da' and da_rank and da_rank > 0) then
        if not DOORS[index].locked then
          DOORS[index].locked = true
        else
          DOORS[index].locked = false
        end
        TriggerClientEvent("doormanager:toggleDoorLock", -1, index, DOORS[index].locked, x, y, z)
        break
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

