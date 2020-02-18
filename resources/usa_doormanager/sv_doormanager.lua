--# by: minipunch
--# for USA REALISM rp
--# This script keeps a server sided track of frozen states on objects like doors or gates that can be toggled by being in the activation area and pressing "E"

local DOORS = {
  {name = "Bolingbroke Prison", x = 1818.662, y = 2606.8, z = 45.59, model = 741314661, locked = true, _dist = 8.0, gate = true, offset={0.0, 3.65, 2.8}, lockedCoords={1818.54, 2604.811, 44.607}, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Bolingbroke Prison", x = 1845.05, y = 2607.21, z = 45.57, model = 741314661, locked = true, _dist = 8.0, gate = true, offset={0.0, 3.65, 2.8}, lockedCoords={1844.99, 2604.811, 44.636}, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Door 1", x = 464.192, y = -1003.638, z = 24.9, model = -1033001619, locked = true, offset={0.0, -1.13, 0.05}, heading=0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Door 2", x = 463.72, y = -992.7, z = 24.9, model = 631614199, locked = true, offset={0.0, 1.12, 0.025}, heading=0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cell 1", x = 461.7, y = -993.6, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=270, _dist = 1.5, allowedJobs = {'sheriff','corrections'}},
  {name = "Mission Row / Cell 2", x = 462.75, y = -998.3, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=90, _dist = 1.5, allowedJobs = {'sheriff','corrections'}},
  {name = "Mission Row / Cell 3", x = 462.7, y = -1001.9, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=90, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Lower Entry 1", x = 463.57867431641,y = -1004.1882324219, z = 24.914945602417, model = 185711165, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  --{name = "BCSO Paleto / Side 1", model = -1156020871, locked = false, _dist = 1.5, offset = {0.0, 1.6, -0.09}, heading=135, allowedJobs = {'sheriff'}},
  --{name = "BCSO Paleto / Side 2", model = -1156020871, locked = true, _dist = 1.5, static = true, allowedJobs = {'sheriff'}},
  {name = "Mission Row / Door 1", x = 464.192, y = -1003.638, z = 24.9, model = -1033001619, locked = true, offset={0.0, -1.13, 0.05}, heading=0, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Door 2", x = 463.72, y = -992.7, z = 24.9, model = 631614199, locked = true, offset={0.0, 1.12, 0.025}, heading=0, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cell 1", x = 461.7, y = -993.6, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=270, _dist = 1.0, allowedJobs = {'sheriff','corrections'}},
  {name = "Mission Row / Cell 2", x = 462.75, y = -998.3, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=90, _dist = 1.0, allowedJobs = {'sheriff','corrections'}},
  {name = "Mission Row / Cell 3", x = 462.7, y = -1001.9, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=90, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cell 4", x = 467.16943359375,y = -998.13598632813, z = 24.914945602417, model = 871712474, locked = true, offset={0.0, 1.12, 0.025}, heading=0, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cell 5", x = 469.29229736328,y = -999.87762451172, z = 24.914936065674, model = 871712474, locked = true, offset={0.0, 1.12, 0.025}, heading=270, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cell 6", x = 468.23550415039,y = -1003.1491088867, z = 24.914926528931, model = 871712474, locked = true, offset={0.0, 1.12, 0.025}, heading=180, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Evidence", x = 473.89660644531,y = -988.15203857422, z = 24.914939880371, model = -1033001619, locked = false, offset={0.0, -1.0, 0.0}, heading=180, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', "ems", "judge"}},
  {name = "Mission Row / Lower Entry 1", x = 463.57867431641,y = -1004.1882324219, z = 24.914945602417, model = 185711165, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Aux 1", x = 466.12319946289,y = -990.48913574219, z = 24.914930343628, model = 185711165, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  --{name = "Mission Row / Lower Aux 1", x = 466.30242919922,y = -989.45874023438, z = 24.914945602417, model = 185711165, locked = true, offset={0.0, 1.15, -0.1}, heading=90, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems"}},
  {name = "Mission Row / Aux 1", x = 466.12319946289,y = -990.48913574219, z = 24.914930343628, model = 185711165, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Aux 2", x = 466.26898193359,y = -989.31799316406, z = 24.914930343628, model = 185711165, locked = false, offset={0.0, 1.24, 0.0}, heading=90, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "EMS Station - Paleto", x = -361.8, y = 6129.8, z = 31.4, model = -250842784, locked = false, _dist = 1.5, allowedJobs = {'ems'}},
  {name = "Mission Row / Roof", x = 461.2, y = -986.0, z = 30.7, model = 749848321, locked = true, offset={0.0, 1.05, 0.10}, heading=89, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "BCSO Station Gate - Paleto", model = -1483471451, locked = false, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "BCSO Station - Sidewalk", x = -449.8, y = 6024.3, z = 31.5, model = -1156020871, locked = true, offset={0.0, -1.5, -0.095}, heading=315, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  {name = "BCSO Station - Sandy Shores", x = 1855.0, y = 3683.5, z = 34.2, model = -1765048490, locked = false, offset={0.0, 1.24, -0.1}, heading=30, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  {name = "BCSO Station - Cell 1", x = -432.09231567383, y = 5999.8515625, z = 31.716178894043, model = 631614199, locked = false, offset={0.0, 1.24, -0.1}, heading=315, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  {name = "BCSO Station - Cell 2", x = -429.02087402344,y = 5996.828125, z = 31.716180801392, model = 631614199, locked = false, offset={0.0, 1.24, -0.1}, heading=315, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  {name = "BCSO Station - Questioning", x = -453.81491088867,y = 6010.7387695313, z = 31.716337203979, model = -519068795, locked = false, offset={0.0, -1.0, -0.1}, heading=10, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  {name = "Prison Block / Cell 1", x = 1729.7, y = 2624.0, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 2", x = 1729.8, y = 2628.1, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 3", x = 1730.1, y = 2632.3, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 4", x = 1729.9, y = 2636.4, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 5", x = 1730.0, y = 2640.5, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 6", x = 1729.8, y = 2644.5, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 7", x = 1729.9, y = 2648.6, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 8", x = 1743.3, y = 2631.6, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 9", x = 1743.5, y = 2635.9, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 10", x = 1743.1, y = 2639.8, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 11", x = 1743.0, y = 2644.0, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 12", x = 1743.4, y = 2648.0, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 13", x = 1729.4, y = 2624.13, z = 49.25, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 14", x = 1729.4, y = 2628.07, z = 49.29, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 15", x = 1729.4, y = 2632.43, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 16", x = 1729.4, y = 2636.39, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 17", x = 1729.4, y = 2640.65, z = 49.28, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 18", x = 1729.4, y = 2644.57, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 19", x = 1729.4, y = 2648.07, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 20", x = 1743.8, y = 2623.47, z = 49.25, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 21", x = 1743.8, y = 2627.50, z = 49.26, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 22", x = 1743.8, y = 2631.81, z = 49.26, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 23", x = 1743.8, y = 2635.90, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 24", x = 1743.8, y = 2639.50, z = 49.28, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 25", x = 1743.8, y = 2643.50, z = 49.28, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 26", x = 1743.8, y = 2647.50, z = 49.26, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 27", x = 1729.4, y = 2624.50, z = 53.06, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 28", x = 1729.4, y = 2628.10, z = 53.06, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 29", x = 1729.4, y = 2632.50, z = 53.07, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 30", x = 1729.4, y = 2636.50, z = 53.07, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 31", x = 1729.4, y = 2640.50, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 32", x = 1729.4, y = 2644.50, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 33", x = 1729.4, y = 2648.50, z = 53.09, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 34", x = 1743.8, y = 2623.60, z = 53.07, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 35", x = 1743.8, y = 2627.60, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 36", x = 1743.8, y = 2631.70, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 37", x = 1743.8, y = 2635.70, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 38", x = 1743.8, y = 2639.80, z = 53.09, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 39", x = 1743.8, y = 2643.80, z = 53.09, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Prison Block / Cell 40", x = 1743.8, y = 2647.95, z = 53.10, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Holding Cells Entrance 1", x = 468.1, y = -1014.3299, z = 26.4, model = -2023754432, locked = true, offset={0.0, -1.12, 0.0}, heading=0, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Holding Cells Entrance 2", x = 469.3, y = -1014.4, z = 26.4, model = -2023754432, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Back Gate", x = 488.90, y = -1019.88, z = 28.21, model = -1603817716, locked = true, _dist = 8.0, gate = true, offset={0.0, -3.0, 1.5}, lockedCoords={488.89, -1017.35, 27.14}, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cells Door 1", x = 443.9, y = -988.6, z = 30.7, model = 185711165, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cells Door 2", x = 445.22, y = -989.4, z = 30.7, model = 185711165, locked = true, offset={0.0, 1.24, 0.0}, heading=0, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Side Room 1", x = 443.7, y = -992.4, z = 30.7, model = -131296141, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Side Room 2", x = 443.6, y = -993.9, z = 30.7, model = -131296141, locked = false, offset={0.0, 1.24, 0.0}, heading=270, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "SSPD / Door 1", x = 1851.1119384766,y = 3683.1423339844, z = 34.286640167236, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=120, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Cell 1", x = 1848.771484375,y = 3681.3623046875, z = 34.286636352539, model = 631614199, locked = false, offset={0.0, 1.24, 0.0}, heading=120, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Cell 2", x = 1846.3103027344,y = 3685.2182617188, z = 34.286636352539, model = 631614199, locked = false, offset={0.0, 1.24, 0.0}, heading=300, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 2", x = 1845.7978515625,y = 3688.4809570313, z = 34.286602020264, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=30, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 3", x = 1843.3763427734,y = 3691.2065429688, z = 34.286617279053, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=300, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 4", x = 1849.0443115234,y = 3690.3146972656, z = 34.286636352539, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=25, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 5", x = 1850.6782226563,y = 3693.7448730469, z = 34.286636352539, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=120, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 6", x = 1854.0256347656,y = 3694.3923339844, z = 34.286655426025, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=30, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 7", x = 1856.3859863281,y = 3690.396484375, z = 34.286685943604, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=30, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = 'Hospital / Ward A 1', x = 303.23297119141,y = -582.19818115234, z = 43.284023284912, model = -434783486, locked = false, offset={0.0, -1.0, 0.00}, heading = 340, _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor', "corrections"}},
  {name = 'Hospital / Ward A 2', x = 304.57992553711,y = -582.55187988281, z = 43.284008026123, model = -1700911976, locked = true, static = true,  _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor', "corrections"}},
  {name = 'Hospital / Ward A 3', x = 326.43518066406,y = -579.94946289063, z = 43.284027099609, model = -1700911976, locked = false, offset={0.0, 1.0, 0.00}, heading = 250, _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor', "corrections"}},
  {name = 'Hospital / Ward A 4', x = 326.91903686523,y = -578.595703125, z = 43.284027099609, model = -434783486, locked = true, static = true,  _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor', "corrections"}},
  {name = 'BCSO Paleto - Door 1', x = -443.16, y = 6015.41, z = 31.71, model = -1501157055, locked = false, offset={0.0, 1.24, -0.1}, heading = 315, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = 'BCSO Paleto - Door 2', x = -444.3, y = 6016.3, z = 31.71, model = -1501157055, locked = true, _dist = 1.5, static = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = 'Mission Row / Armory', x = 452.71, y = -982.616, z = 30.6, model = 749848321, locked = true, offset={0.0, 1.05, 0.3}, heading = 270, _dist = 1.5, allowedJobs = {'sheriff', "corrections"}},
  {name = 'Nightclub / Door 1', x = -1621.88, y = -3016.0, z = -75.20, model = -1119680854, locked = true, static = true, _dist = 1.0},
  {name = 'Nightclub / Door 2', x = -1621.15, y = -3019.06, z = -75.20, model = 1695461688, locked = true, static = true, _dist = 1.0},
  {name = 'Nightclub / Door 3', x = -1610.8, y = -3004.98, z = -79.0, model = 1743859485, locked = true, static = true, _dist = 1.0},
  {name = 'Legal Offices / Door 1', x = 121.21, y = -757.02, z = 242.15, model = -1821777087, locked = true, static = true, _dist = 1.0},
  {name = 'Legal Offices / Door 2', x = 143.16, y = -759.65, z = 242.15, model = -1821777087, locked = true, static = true, _dist = 1.0},
  {name = 'LSSD Davis / Door 1', x = 392.31, y = -1635.45, z = 29.29, model = -1156020871, locked = true, offset={0.0, -1.6, -0.1}, heading = 50, _dist = 1.0, allowedJobs = {'sheriff'}},
  {name = 'LSSD Davis / Gate 1', x = 398.32, y = -1607.73, z = 29.29, model = 1286535678, locked = true, _dist = 8.0, gate = true, offset={3.0, -2.5, 1.5}, lockedCoords = {397.88, -1607.38, 28.33}, allowedJobs = {'sheriff'}},
  {name = 'Mission Row / Front Gate', x = 411.4, y = -1028.26, z = 29.39, model = -512634970, locked = true, _dist = 10.0, gate = true, offset={0.0, 3.0, 1.5}, lockedCoords = {410.80, -1028.15, 28.38}, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Garage Door", x = 427.42, y = -1016.92, z = 28.97, model = 631614199, locked = true, offset={0.0, 1.12, 0.025}, heading=81, _dist = 1.0, allowedJobs = {'sheriff','corrections'}},
  {name = "Eclipse Towers / Heist Room", x = -767.55, y = 331.14, z = 211.39, model = 34120519, locked = true, static = true, _dist = 1.0},
  {name = "Pacific Standard Bank / Door 1", x = 261.96, y = 221.79, z= 106.28, model = 746855201, locked = true, offset ={0.0, -1.2, 0.0}, heading = 250.0, _dist = 1.0, lockpickable = true, allowedJobs = {'sheriff'}},
  {name = "Pacific Standard Bank / Door 2", x = 256.89, y = 220.34, z = 106.28, model = -222270721, locked = true, offset ={0.0, -1.2, 0.0}, heading = 340.0, _dist = 1.0, lockpickable = true, allowedJobs = {'sheriff'}},
  {name = "Pacific Standard Bank / Door 3", x = 256.76, y = 206.78, z = 110.28, model = 1956494919, locked = true, offset ={0.0, 1.25, -0.2}, heading = 250.0, _dist = 1.0, lockpickable = true, allowedJobs = {'sheriff'}},
  {name = "DA Office / Door 1", x = -74.45, y = -821.88, z = 243.38, model = 220394186, locked = true, offset = {0.0, 0.7, 0.05}, heading = 340.0, _dist = 1.0, allowedJobs = {'da', 'judge'}},
  {name = "DA Office / Door 2", x = -75.15, y = -821.65, z = 243.38, model = 220394186, locked = true, static = true, _dist = 1.0},
  {name = "DA Office / Door 3", x = -77.35, y = -808.07, z = 243.38, model = -88942360, locked = true, offset = {0.0, 1.12, -0.02}, heading = 340.0, _dist = 1.0, allowedJobs = {'da', 'judge'}},
  {name = "DA Office / Door 4", x = -77.79, y = -814.25, z = 243.38, model = -88942360, locked = true, offset = {0.0, 1.12, -0.02}, heading = 250.0, _dist = 1.0, allowedJobs = {'da', 'judge'}},
  {name = "Court House / Front 1", x = 242.60382080078,y = -1074.208984375, z = 29.287979125977, model = 110411286, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Court House / Front 2", x = 243.99006652832,y = -1074.3812255859, z = 29.286693572998, model = 110411286, locked = false, offset={0.0, -1.24, 0.0}, heading=180, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Pacific Standard Bank / Door 3", x = -106.34, y = 6475.35, z = 31.63, model = 1309269072, locked = true, offset ={0.0, -1.0, -0.2}, heading = 310.0, _dist = 1.0, lockpickable = true, allowedJobs = {'sheriff', "corrections"}},
  {name = "Pacific Standard Bank / Door 3", x = -105.8, y = 6473.4, z = 31.63, model = 1622278560, locked = true, offset ={0.0, 1.0, -0.2}, heading = 41.0, _dist = 1.0, lockpickable = true, allowedJobs = {'sheriff', "corrections"}},

}

-- allowedJobs - table of job names allowed to use door, the player's job must match any value in the list for the door to lock/unlock
-- offsetX, offsetY, offsetZ - 3D text offset from the object's coordinates (used to display text)
-- static - true will result in the door being left in the state defined (locked/unlocked), and will prevent text from displaying for locking/unlocking (used to lock one of two double doors permanently)
-- _dist - distance which needs to be met before the door can be locked/unlocked
-- heading - the heading of the door in it's regular position (when a player is not holding it open) -- this value should always be somewhat a multiple of 5 as rockstar like uniformity e.g., 270, 90, 180, 30, 315
-- ymap - true will result in the door not using any of the above new values for 3D text, and having the text display at the x, y, z coords on the list

RegisterServerEvent("doormanager:checkDoorLock")
AddEventHandler("doormanager:checkDoorLock", function(index, x, y, z, lockpicked)
  local char = exports["usa-characters"]:GetCharacter(source)
  local job = char.get("job")
  local da_rank = char.get('daRank')
  for i = 1, #DOORS[index].allowedJobs do
    if job == DOORS[index].allowedJobs[i] or (lockpicked and DOORS[index].lockpickable) or (DOORS[index].allowedJobs[i] == 'da' and da_rank and da_rank > 0) then
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

RegisterServerEvent("doormanager:firstJoin")
AddEventHandler("doormanager:firstJoin", function()
  TriggerClientEvent("doormanager:update", source, DOORS)
end)

TriggerEvent('es:addGroupCommand', 'lockdebug', 'owner', function(source, args, char)
  TriggerClientEvent("doormanager:debug", source)
end, {
	help = "DEBUG: Debug the door lock system"
})

