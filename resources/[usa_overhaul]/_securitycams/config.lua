SecurityCamConfig = {}

SecurityCamConfig.DebugMode = false
SecurityCamConfig.HideRadar = true

SecurityCamConfig.Locations = {
    {
        camBox = {label = "Pacific Standard Bank", id = 'bank1'},
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
        }
    },
    {
        camBox = {label = "Bolingbroke Penitentiary", id = 'prison'},
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
        }
    },
    {
        camBox = {label = "Rob's Liquor (El Rancho Blvd.)", id = 'store1'},
        cameras = {
            {label = "Camera 1", x = 1132.95, y = -981.44, z = 48.41, r = {x = -40.0, y = 0.0, z = -90.0}},
            {label = "Camera 2", x = 1130.307, y = -985.84, z = 48.88, r = {x = -40.0, y = 0.0, z = 0.0}},
            {label = "Camera 3", x = 1125.11, y = -983.31, z = 47.52, r = {x = -40.0, y = 0.0, z = 320.0}}
        }
    },
    {
        camBox = {label = "LTD Gasoline (Ginger St.)", id = 'store2'},
        cameras = {
            {label = "Camera 1", x = -705.14, y = -914.26, z = 21.21, r = {x = -40.0, y = 0.0, z =  90.0}},
            {label = "Camera 2", x = -710.52, y = -904.48, z = 21.28, r = {x = -40.0, y = 0.0, z = 214.0}}
        }
    },
    {
        camBox = {label = "247 Supermarket (Paleto Bay)", id = 'store3'},
        cameras = {
            {label = "Camera 1", x = 1730.08, y = 6419.72, z = 37.0, r = {x = -20.0, y = 0.0, z = 200.0}},
            {label = "Camera 2", x = 1736.74, y = 6417.39, z = 37.0, r = {x = -40.0, y = 0.0, z = 30.0}},
        }
    },
    {
        camBox = {label = "247 Supermarket (Innocence Blvd.)", id = 'store4'},
        cameras = {
            {label = "Camera 1", x = 24.43, y = -1342.22, z = 31.49, r = {x = -20.0, y = 0.0, z = 230.0}},
            {label = "Camera 2", x = 31.48, y = -1341.51, z = 31.49, r = {x = -40.0, y = 0.0, z = 47.0}},
        }
    },
    {
        camBox = {label = "Rob's Liquor (San Andreas Ave.)", id = 'store5'},
        cameras = {
            {label = "Camera 1", x = -1222.303, y = -909.87, z = 14.32, r = {x = -40.0, y = 0.0, z = 24.0}},
            {label = "Camera 2", x = -1217.078, y = -910.34, z = 15.00, r = {x = -40.0, y = 0.0, z = 86.0}},
            {label = "Camera 3", x = -1217.222, y = -916.17, z = 13.72, r = {x = -40.0, y = 0.0, z = 62.0}}
        }
    },
    {
        camBox = {label = "247 Supermarket (Alhambra Dr.)", id = 'store6'},
        cameras = {
            {label = "Camera 1", x = 1957.50, y = 3744.393, z = 34.34, r = {x = -20.0, y = 0.0, z = 259.0}},
            {label = "Camera 2", x = 1963.19, y = 3748.604, z = 34.34, r = {x = -40.0, y = 0.0, z = 95.0}},
        }
    },
    {
        camBox = {label = "247 Supermarket (Clinton Ave.)", id = 'store7'},
        cameras = {
            {label = "Camera 1", x = 373.75, y = 331.31, z = 105.56, r = {x = -20.0, y = 0.0, z = 213.0}},
            {label = "Camera 2", x = 380.73, y = 330.38, z = 105.56, r = {x = -40.0, y = 0.0, z = 45.0}},
        }
    },
    {
        camBox = {label = "LTD Gasoline (Grove St.)", id = 'store8'},
        cameras = {
            {label = "Camera 1", x = -46.43, y = -1759.07, z = 31.42, r = {x = -40.0, y = 0.0, z = 50.0}},
            {label = "Camera 2", x = -44.23, y = -1748.11, z = 31.49, r = {x = -40.0, y = 0.0, z = 182.0}},
        }
    },
    {
        camBox = {label = "Rob's Liquor (Route 68)", id = 'store9'},
        cameras = {
            {label = "Camera 1", x = 1166.96, y = 2711.86, z = 40.15, r = {x = -40.0, y = 0.0, z = 163.0}},
            {label = "Camera 2", x = 1163.0, y = 2715.22, z = 40.13, r = {x = -40.0, y = 0.0, z = 234.0}},
            {label = "Camera 3", x = 1166.308, y = 2720.0, z = 39.46, r = {x = -40.0, y = 0.0, z = 212.0}}
        }
    },
    {
        camBox = {label = "LTD Gasoline (Grapeseed Main St.)", id = 'store10'},
        cameras = {
            {label = "Camera 1", x = 1696.95, y = 4922.51, z = 44.06, r = {x = -40.0, y = 0.0, z = 324.0}},
            {label = "Camera 2", x = 1708.07, y = 4921.28, z = 44.129, r = {x = -40.0, y = 0.0, z = 95.0}}
        }
    },
    {
        camBox = {label = "247 Supermarket (Ineseno Rd.)", id = 'store11'},
        cameras = {
            {label = "Camera 1", x = -3043.79, y = 582.93, z = 9.9, r = {x = -20.0, y = 0.0, z = 340.0}},
            {label = "Camera 2", x = -3046.67, y = 589.36, z = 9.9, r = {x = -40.0, y = 0.0, z = 175.0}}
        }
    },
    {
        camBox = {label = "247 Supermarket (Palomino Fwy.)", id = 'store12'},
        cameras = {
            {label = "Camera 1", x = 2552.19, y = 381.01, z = 110.62, r = {x = -20.0, y = 0.0, z = 320.0}},
            {label = "Camera 2", x = 2551.69, y = 388.04, z = 110.62, r = {x = -40.0, y = 0.0, z = 127.0}}
        }
    },
    {
        camBox = {label = "247 Supermarket (Senora Fwy.)", id = 'store13'},
        cameras = {
            {label = "Camera 1", x = 2673.57, y = 3281.84, z = 57.24, r = {x = -20.0, y = 0.0, z = 297.0}},
            {label = "Camera 2", x = 2676.314, y = 3288.30, z = 57.24, r = {x = -40.0, y = 0.0, z = 112.0}}
        }
    },
    {
        camBox = {label = "247 Supermarket (Harmony, Route 68)", id = 'store14'},
        cameras = {
            {label = "Camera 1", x = 549.743, y = 2666.35, z = 44.15, r = {x = -20.0, y = 0.0, z = 57.0}},
            {label = "Camera 2", x = 542.89, y = 2664.57, z = 44.15, r = {x = -40.0, y = 0.0, z = 242.0}}
        }
    },
    {
        camBox = {label = "LTD Gasoline (Banham Canyon Dr.)", id = 'store15'},
        cameras = {
            {label = "Camera 1", x = -1819.03, y = 794.41, z = 140.06, r = {x = -40.0, y = 0.0, z = 130.0}},
            {label = "Camera 2", x = -1829.46, y = 798.02, z = 140.25, r = {x = -40.0, y = 0.0, z = 270.0}}
        }
    },
    {
        camBox = {label = "247 Supermarket (Barbareno Rd.)", id = 'store16'},
        cameras = {
            {label = "Camera 1", x = -3247.27, y = 1000.39, z = 14.83, r = {x = -20.0, y = 0.0, z = 318.0}},
            {label = "Camera 2", x = -3247.449, y = 1007.466, z = 14.83, r = {x = -40.0, y = 0.0, z = 136.0}}
        }
    },
    {
        camBox = {label = "Rob's Liquor (Great Ocean Hwy.)", id = 'store17'},
        cameras = {
            {label = "Camera 1", x = -2965.38, y = 389.67, z = 17.04, r = {x = -40.0, y = 0.0, z = 73.0}},
            {label = "Camera 2", x = -2961.912, y = 393.51, z = 17.01, r = {x = -40.0, y = 0.0, z = 131.0}},
            {label = "Camera 3", x = -2957.23, y = 389.95, z = 16.04, r = {x = -40.0, y = 0.0, z = 130.0}},
        }
    },
    {
        camBox = {label = "Clothing Store (Sinner St.)", id = 'store18'},
        cameras = {
            {label = "Camera 1", x = 427.128, y = -811.91, z = 31.49, r = {x = -20.0, y = 0.0, z = 24.0}},
            {label = "Camera 2", x = 431.04, y = -798.77, z = 31.49, r = {x = -40.0, y = 0.0, z = 133.0}}
        }
    },
    {
        camBox = {label = "LS Customs (La Mesa)", id = 'store19'},
        cameras = {
            {label = "Camera 1", x = 728.73, y = -1065.04, z = 30.31, r = {x = -40.0, y = 0.0, z = 145.0}},
            {label = "Camera 2", x = 738.59, y = -1094.83, z = 26.16, r = {x = -40.0, y = 0.0, z = 37.0}},
            {label = "Camera 3", x = 724.14, y = -1063.56, z = 24.16, r = {x = -40.0, y = 0.0, z = 238.0}}
        }
    },
    {
        camBox = {label = "Herr Kutz Barbers (Carson Ave.)", id = 'store20'},
        cameras = {
            {label = "Camera 1", x = 138.18, y = -1703.68, z = 31.29, r = {x = -40.0, y = 0.0, z = 168.0}}
        }
    },
    {
        camBox = {label = "Clothing Store (Innocence Blvd.)", id = 'store21'},
        cameras = {
            {label = "Camera 1", x = 73.8, y = -1386.76, z = 31.79, r = {x = -40.0, y = 0.0, z = 224.0}},
            {label = "Camera 2", x = 69.84, y = -1400.4, z = 31.38, r = {x = -40.0, y = 0.0, z = 305.0}}
        }
    },
    {
        camBox = {label = "Herr Kutz Barbers (Niland Ave.)", id = 'store22'},
        cameras = {
            {label = "Camera 1", x = 1928.06, y = 3732.89, z = 34.64, r = {x = -30.0, y = 0.0, z = 250.0}}
        }
    },
    {
        camBox = {label = "Yellow Jack Inn (Panorama Dr.)", id = 'store23'},
        cameras = {
            {label = "Camera 1", x = 1982.17, y = 3053.06, z = 49.21, r = {x = -40.0, y = 0.0, z = 230.0}},
            {label = "Camera 2", x = 1996.68, y = 3049.23, z = 49.21, r = {x = -40.0, y = 0.0, z = 114.0}},
            {label = "Camera 3", x = 1991.20, y = 3052.56, z = 48.21, r = {x = -40.0, y = 0.0, z = 99.0}},
        }
    },
}

-- prison cam 1 [x = 1732.7, y = 2649.6, z = 45.6]
-- prison cam 2 [x = 1732.7, y = 2649.6, z = 49.6]
-- prison cam 3 [x = 1732.7, y = 2649.6, z = 53.6]
-- prison camera room [x = 1690.0, y = 2531.9, z = 50.0]
