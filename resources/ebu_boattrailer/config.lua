-----COPYRIGHT/OWNER INFO-----
-- Author: Theebu#9267
-- Copyright- This work is protected by:
-- "http://creativecommons.org/licenses/by-nc-nd/4.0/"
-- Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License
-- You must:    Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made.
--              You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
--              NonCommercial — You may not use the material for commercial purposes. IE you may not sell this



Config = {}

Config.MarkerType   = 25
Config.MarkerColor  = { r = 0, g = 255, b = 100 }
Config.MarkerSize   = { x = 1.0, y = 1.0, z = 1.0 }
Config.ShowMarkers  = true

Config.InvulTime    = 5 --Time in seconds after the disconnect the boat won't take damage


Config.detachCommand = 'Press ~INPUT_CONTEXT~ to detach the watercraft'        -- Text for external detach point
Config.inBoatCommand ='Press ~INPUT_CONTEXT~ to attach/detach the watercraft'   -- Text for in boat attach/detach

Config.Trailers = {

    {  
        model = 'seadoohauler',                                                         --model name
        boats = {'seadoogti215', 'seashark', 'seashark3', 'rxt260'},                                                       --models that can attach
        Position = vector3(0.0, -0.25, 0.2),                                            --offset point for attachment
        HeightOffset = 0.225,                                                           --offset point for bottom of boat to trailer
        DetachPoints = {vector3(0.7, 1.8, -0.4), vector3(-0.7, 1.8, -0.4)},             --external detach points
    },
    {  
        model = 'yftrailer',
        boats = {'42ftyellowfin', 'contender39', 'centercigar', 'quintessential'},
        Position = vector3(0.0, -0.225, 0.2),
        HeightOffset = 1.5,
        DetachPoints = {vector3(1.0, 5.75, -0.4), vector3(-1.0, 5.75, -0.4)},
    },
    {  
        model = 'sstrailer',
        boats = {'speedster200'},
        Position = vector3(0.0, -0.32, 0.2),
        HeightOffset = 0.575,
        DetachPoints = {vector3(1.0, 1.8, -0.4), vector3(-1.0, 1.8, -0.4)},
    },
    {  
        model = 'ptrailer',
        boats = {'tritoon'},
        Position = vector3(0.0, -0.80, 0.2),
        HeightOffset = 0.88,
        DetachPoints = {vector3(1.0, 1.8, -0.4), vector3(-1.0, 1.8, -0.4)},
    },
    {  
        model = 'abtrailer',
        boats = {'airboat'},
        Position = vector3(0.0, -0.85, 0.2),
        HeightOffset = 0.4,
        DetachPoints = {vector3(1.0, 1.8, -0.4), vector3(-1.0, 1.8, -0.4)},
    },
    {  
        model = 'nbtrailer',
        boats = {'nitroboat'},
        Position = vector3(0.15, -0.9, 0.4),
        HeightOffset = 0.2,
        DetachPoints = {vector3(1.0, 1.8, -0.4), vector3(-1.0, 1.8, -0.4)},
    },
    {  
        model = 'ktrailer',
        boats = {'keywest'},
        Position = vector3(0.0, -0.39, 0.2),
        HeightOffset = 0.790,
        DetachPoints = {vector3(1.0, 1.8, -0.4), vector3(-1.0, 1.8, -0.4)},
    },
    {  
        model = 'ktrailer',
        boats = {'26ftyellowfin'},
        Position = vector3(0.0, -1.60, 0.0),
        HeightOffset = 0.2,
        DetachPoints = {vector3(1.0, 1.8, -0.4), vector3(-1.0, 1.8, -0.4)},
    },
--[[
   { 
        model = 'ktrailer',
        boats = {'26ftyellowfintower'},
        Position = vector3(0.0, -1.60, 0.0),
        HeightOffset = 0.2,
        DetachPoints = {vector3(1.0, 1.8, -0.4), vector3(-1.0, 1.8, -0.4)},
    },
]]
    {  
        model = 'gtrailer',
        boats = {'gradywhite'},
        Position = vector3(0.0, -0.65, 0.0),
        HeightOffset = 0.30,
        DetachPoints = {vector3(2.0, 1.8, -1.0), vector3(-2.0, 1.8, -1.0)},
    },
    {  
        model = 'formtrl',
        boats = {'robsfl'},
        Position = vector3(0.0, 0.0, 0.2),
        HeightOffset = 0.3,
        DetachOffset = 2.3,
        DetachPoints = {vector3(1.0, 5.8, 0.0), vector3(-1.0, 5.8, 0.0)},
    },
    {  
        model = 'mystictrailer',                                                         --model name
        boats = {'mystic'},                                                       --models that can attach
        Position = vector3(0.0, -3.0, 1.8),                                            --offset point for attachment
        HeightOffset = 1.05,                                                           --offset point for bottom of boat to trailer
        DetachPoints = {vector3(2.5, 4.8, -0.4), vector3(-2.5, 4.8, -0.4)},            --external detach points
    },
    {  
        model = 'mystic800trailer',                                                         --model name
        boats = {'mystic800'},                                                       --models that can attach
        Position = vector3(0.0, 0.0, 1.5),                                            --offset point for attachment
        HeightOffset = 1.05,                                                           --offset point for bottom of boat to trailer
        DetachPoints = {vector3(2.5, 4.8, -0.2), vector3(-2.5, 4.8, -0.2)},             --external detach points
    },
    {  
        model = 'ftrailer',                                                         --model name
        boats = {'freeman'},                                                       --models that can attach
        Position = vector3(0.0, 0.0, 1.5),                                            --offset point for attachment
        HeightOffset = 1.40,                                                           --offset point for bottom of boat to trailer
        DetachPoints = {vector3(2.5, 4.8, -0.2), vector3(-2.5, 4.8, -0.2)},             --external detach points
    },
    {  
        model = 'ftrailer',                                                         --model name
        boats = {'hydrasport53'},                                                       --models that can attach
        Position = vector3(0.0, 0.8, 1.5),                                            --offset point for attachment
        HeightOffset = 1.00,                                                           --offset point for bottom of boat to trailer
        DetachPoints = {vector3(2.5, 4.8, -0.2), vector3(-2.5, 4.8, -0.2)},             --external detach points
    },
}

