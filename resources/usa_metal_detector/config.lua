config = {

    detectors = {
		{ -- Courthouse Right
			info = { id = 1, sound = { range = 10 } },
			coords = { x = 241.3592, y = -1079.2256, z = 29.2941, radius = 0.5 },
			entity = { enable = false, heading = nil }
		},
		{ -- Courthouse Left
			info = { id = 2, sound = { range = 10 } },
			coords = { x = 245.6187, y = -1079.1475, z = 29.2941, radius = 0.5 },
			entity = { enable = false, heading = nil }
		},
		{ -- Prison Corridor Left
			info = { id = 3, sound = { range = 10 } },
			coords = { x = 1827.3799, y = 2592.0012, z = 45.9524, radius = 0.5 },
			entity = { enable = true, heading = 3 }
		},
		{ -- Prison Corridor Right
			info = { id = 4, sound = { range = 10 } },
			coords = { x = 1828.4799, y = 2592.0012, z = 45.9524, radius = 0.5 },
			entity = { enable = true, heading = 3 }
		},
	},

	debug = false -- Prints debug information for trouble shooting.

}

-- Config Information --

-- "players" --
-- "detectors" = A list of detector id's that you want to give the player access to.

-- "detectors" --
-- "info/id" = The id of the metal detector. (They cannot be the same!)
-- "info/sound/range" = The range that you want to alarm to be heard.
-- "coords/x" = The 'x' coordinate of the metal detector.
-- "coords/y" = The 'y' coordinate of the metal detector.
-- "coords/z" = The 'z' coordinate of the metal detector.
-- "coords/radius" = The radius of the metal detector to start scanning them.
-- "entity/enable" = If 'true' this creates a metal detector at the coords defined above.
-- "entity/heading" = If "entity/enable" is 'true' this sets the heading of the metal detector. (Set to 'nil' if "entity/enable" is 'false'.)