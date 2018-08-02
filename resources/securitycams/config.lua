SecurityCamConfig = {}

SecurityCamConfig.DebugMode = false
SecurityCamConfig.HideRadar = true

SecurityCamConfig.Locations = {
    {
        camBox = {label = "Pacific Standard Bank", x = 283.67, y = 264.41, z = 105.80},
        cameras = {
            {label = "Camera 1", x = 257.45, y = 210.07, z = 109.08, r = {x = -25.0, y = 0.0, z = 28.05}},
            {label = "Camera 2", x = 269.66, y = 223.67, z = 113.23, r = {x = -30.0, y = 0.0, z = 111.29}},
            {label = "Camera 3", x = 241.64, y = 233.83, z = 111.48, r = {x = -35.0, y = 0.0, z = 120.46}},
            {label = "Camera 4", x = 232.86, y = 221.46, z = 107.83, r = {x = -25.0, y = 0.0, z = -140.91}},
            {label = "Camera 5", x = 261.50, y = 218.08, z = 107.95, r = {x = -25.0, y = 0.0, z = -149.49}},
            {label = "Camera 6", x = 261.98, y = 217.92, z = 113.25, r = {x = -40.0, y = 0.0, z = -159.49}},
            {label = "Camera 7", x = 258.44, y = 204.97, z = 113.25, r = {x = -30.0, y = 0.0, z = 10.50}},
            {label = "Camera 8", x = 235.53, y = 227.37, z = 113.23, r = {x = -35.0, y = 0.0, z = -160.29}},
            {label = "Camera 9", x = 254.72, y = 206.06, z = 113.28, r = {x = -35.0, y = 0.0, z = 44.70}},
            {label = "Camera 10", x = 269.89, y = 223.76, z = 106.48, r = {x = -35.0, y = 0.0, z = 112.62}},
            {label = "Camera 11", x = 252.27, y = 225.52, z = 103.99, r = {x = -35.0, y = 0.0, z = -74.87}}
        },
        allowedModels = {}
    },
    {
        camBox = {label = "Bolingbroke Penitentiary", x = 1690.0, y = 2531.9, z = 50.0},
        cameras = {
            --{label = "Cell Block / Level 1", x = 1732.7, y = 2649.6, z = 45.6, r = {x = 0.0, y = 0.0, z = 180.0}}, -- not working
            --{label = "Cell Block / Level 2", x = 1732.7, y = 2649.6, z = 49.6, r = {x = 0.0, y = 0.0, z = 180.0}}, -- not working
            --{label = "Cell Block / Level 3", x = 1732.7, y = 2649.6, z = 53.6, r = {x = 0.0, y = 0.0, z = 180.0}} -- not working
            {label = "Front Gate 1", x = 1834.0, y = 2604.3, z = 48.8, r = {x = 0.0, y = 0.0, z = -90.0}},
            {label = "Front Gate 2", x = 1827.7, y = 2605.4, z = 47.8, r = {x = 0.0, y = 0.0, z = 90.0}},
            {label = "Parking Lot 1", x = 1905.2, y = 2605.4, z = 51.8, r = {x = 0.0, y = 0.0, z = 90.0}},
            {label = "Parking Lot 2", x = 1849.6, y = 2699.6, z = 68.7, r = {x = -20.0, y = 0.0, z = 210.0}},
            {label = "Parking Lot 3", x = 1824.2, y = 2473.7, z = 68.7, r = {x = -10.0, y = 0.0, z = -40.0}},
            {label = "Intake", x = 1678.4, y = 2613.0, z = 53.6, r = {x = -20.0, y = 0.0, z = 230.0}},
            {label = "Yard 1", x = 1627.2, y = 2565.6,  z = 54.6, r = {x = -20.0, y = 0.0, z = 200.0}},
            {label = "Yard 2", x = 1629.2, y = 2489.7, z = 54.6, r = {x = -20.0, y = 0.0, z = -35.0}},
        },
        allowedModels = {}
    }
}

-- prison cam 1 [x = 1732.7, y = 2649.6, z = 45.6]
-- prison cam 2 [x = 1732.7, y = 2649.6, z = 49.6]
-- prison cam 3 [x = 1732.7, y = 2649.6, z = 53.6]
-- prison camera room [x = 1690.0, y = 2531.9, z = 50.0]
