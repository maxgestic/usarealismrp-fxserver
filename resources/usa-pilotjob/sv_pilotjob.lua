-- PERFORM FIRST TIME DB CHECK--
exports["globals"]:PerformDBCheck("usa-pilotjob", "pilotjob")

-- MISSIONS --
local MISSIONS = {
    ["Trainee"] = {
        {
            name = "Training Flight",
            description = "Fly to and land the mammatus at the airport in Sandy Shores and then come back and land at LSA then park it in the hangar.",
            checkpoints = {
                {
                    name = "Mammatus",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Mammatus and prepare yourself and Instructor Blackfoot for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Sandy Shores Airport",
                    coords = { x = 1673.0, y = 3243.9, z = 40.9 },
                    requirement = "Fly safely and properly to the Sandy Shores Airport with Instructor Blackfoot."
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "You did it! Now let's take the Mammatus back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Nice! Now park it in the hangar, and check in with staff, and that will be all for your training flight! Congratulations!"
                }
            },
            pay = 6000,
            plane_spawn = {
                model = "mammatus",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 0
            }
        }
    },
    ["Junior Flight Officer"] = {
        {
                name = "Flight to Grapeseed with the Instructor",
                description = "We are going to see how you can handle dirt runways. Take the Cuban 800 and instructor to the Grapeseed airfield and make a clean landing.",
                checkpoints = {
                    {
                        name = "Cuban 800",
                        coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                        requirement = "Get into the Cuban 800 and prepare yourself and Instructor Mark for flight."
                    },
                    {
                        name = "Runway 1",
                        coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                        requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                        sound = "atc3"
                    },
                    {
                        name = "Grapeseed Airport",
                        coords = { x = 2124.5, y = 4806.1, z = 41.2 },
                        requirement = "Fly safely and properly to the Grapeseed Airport and make a clean landing."
                    },
                    {
                        name = "LSA",
                        coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                        requirement = "Nice job! You did it! Now take the Cuban 800 back to Los Santos Airport."
                    },
                    {
                        name = "LSA Hangar",
                        coords = { x = -943.7, y = -2964.3, z = 13.9 },
                        requirement = "Nice! Now park it in the hangar, and check in with staff, and that will be all for this task!"
                    }
                },
                pay = 9000,
                plane_spawn = {
                    model = "cuban800",
                    location = { x = -962.2, y = -2991.7, z = 13.9 },
                    passengers = 0
                }
        },
        {
                name = "Sea plane flight with the Instructor",
                description = "Now we are going to see how you can handle water runways. Take the Dodo and the instructor to the coast on the North side of Paleto Bay and make a clean landing.",
                checkpoints = {
                    {
                        name = "Dodo",
                        coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                        requirement = "Get into the Dodo and prepare yourself and Instructor Mark for flight."
                    },
                    {
                        name = "Runway 1",
                        coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                        requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                        sound = "atc3"
                    },
                    {
                        name = "Paleto Bay",
                        coords = { x = -930.2, y = 6985.8, z = 1.9 },
                        requirement = "Make a smooth landing in the water just North of Paleto Bay."
                    },
                    {
                        name = "LSA",
                        coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                        requirement = "Nice! Now take this thing back to LSA for another nice, smooth landing!"
                    },
                    {
                        name = "LSA Hangar",
                        coords = { x = -962.2, y = -2991.7, z = 13.9 },
                        requirement = "Nice job! Let's park the Dodo back in the hangar and you'll be finished for this task!"
                    }
                },
                pay = 10000,
                plane_spawn = {
                    model = "dodo",
                    location = { x = -962.2, y = -2991.7, z = 13.9 },
                    passengers = 0
                }
        },
        {
                name = "Helicopter Flight",
                description = "Our pilots need to know how to also fly helicopters! Take the frogger out for a quick spin for some practice.",
                checkpoints = {
                    {
                        name = "Frogger",
                        coords = { x = -1112.2, y = -2883.9, z = 13.3 },
                        requirement = "Get into the Frogger and prepare yourself and your instructor for flight.",
                        sound = "atc3"
                    },
                    {
                        name = "Sandy Shores Airport",
                        coords = { x = 1770.3, y = 3239.7, z = 41.5 },
                        requirement = "Take the frogger to the Sandy Shores airport and land on the helipad."
                    },
                    {
                        name = "LSA",
                        coords = { x = -1112.2, y = -2883.9, z = 13.3 },
                        requirement = "Good job! Let's take it back to LSA now and land back where we took off from."
                    },
                    {
                        name = "Staff",
                        coords = { x = -943.7, y = -2964.3, z = 13.9 },
                        requirement = "Nice! Go check in with staff and let them know you finished."
                    }
                },
                pay = 9000,
                plane_spawn = {
                    model = "frogger",
                    location = { x = -1112.2, y = -2883.9, z = 13.3 },
                    passengers = 0
                }
        },
        {
                name = "Small Jet Flight to Grapeseed with the Instructor",
                description = "We are going to see how you can handle a small jet aircraft on a dirt runway. Take the Vestra and the instructor to the Grapeseed airfield and make a clean landing.",
                checkpoints = {
                    {
                        name = "Vestra",
                        coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                        requirement = "Get into the Vestra and prepare yourself and the instructor for flight."
                    },
                    {
                        name = "Runway 1",
                        coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                        requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                        sound = "atc3"
                    },
                    {
                        name = "Grapeseed Airport",
                        coords = { x = 2124.5, y = 4806.1, z = 41.2 },
                        requirement = "Fly safely and properly to the Grapeseed Airport and make a clean landing."
                    },
                    {
                        name = "LSA",
                        coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                        requirement = "Nice job! You did it! Now take the Vestra back to Los Santos Airport."
                    },
                    {
                        name = "LSA Hangar",
                        coords = { x = -943.7, y = -2964.3, z = 13.9 },
                        requirement = "Nice! Now park it in the hangar, and check in with staff, and that will be all for this task!"
                    }
                },
                pay = 9000,
                plane_spawn = {
                    model = "vestra",
                    location = { x = -962.2, y = -2991.7, z = 13.9 },
                    passengers = {
                        { model = -413447396 }
                    }
                }
        }
    },
    ["Flight Officer"] = {
        {
            name = "Shamal Passenger Flight",
            description = "Take the Shamal and its passengers to the Sandy Shores Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Shamal",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Shamal and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Sandy Shores Airport",
                    coords = { x = 1673.0, y = 3243.9, z = 40.9 },
                    requirement = "Fly safely and properly to the Sandy Shores Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Shamal back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 9000,
            plane_spawn = {
                model = "shamal",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 5
            }
        },
        {
            name = "Nimbus Passenger Flight",
            description = "Take the Nimbus and its passengers to Grapeseed Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Nimbus",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Nimbus and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Grapeseed Airport",
                    coords = { x = 2124.5, y = 4806.1, z = 41.2 },
                    requirement = "Fly safely and properly to the Grapeseed Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Nimbus back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 9000,
            plane_spawn = {
                model = "nimbus",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 5
            }
        },
        {
            name = "Luxor Passenger Flight",
            description = "Take the Luxor and its passengers to the Sandy Shores Airport safely and let them out there. You will be carrying a famous rap artist and his crew.",
            checkpoints = {
                {
                    name = "Luxor",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Luxor and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Sandy Shores Airport",
                    coords = { x = 1673.0, y = 3243.9, z = 40.9 },
                    requirement = "Fly safely and properly to the Sandy Shores Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Luxor back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 11000,
            plane_spawn = {
                model = "luxor2",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = {
                    {
                        model = -413447396
                    },
                    {
                        model = 1459905209
                    },
                    {
                        model = 51789996
                    },
                    {
                        model = -2078561997
                    },
                    {
                        model = 1198698306
                    },
                    {
                        model = -1249041111
                    }
                }
            }
        },
        {
            name = "Nimbus Passenger Flight",
            description = "Take the Nimbus and its passengers to the Sandy Shores Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Nimbus",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Nimbus and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Sandy Shores Airport",
                    coords = { x = 1673.0, y = 3243.9, z = 40.9 },
                    requirement = "Fly safely and properly to the Sandy Shores Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Nimbus back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 9000,
            plane_spawn = {
                model = "nimbus",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 6
            }
        },
        {
            name = "Shamal Passenger Flight 2",
            description = "Take the Shamal and its passengers to Grapeseed Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Shamal",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Shamal and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Grapeseed Airport",
                    coords = { x = 2124.5, y = 4806.1, z = 41.2 },
                    requirement = "Fly safely and properly to the Grapeseed Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Shamal back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 9000,
            plane_spawn = {
                model = "shamal",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 5
            }
        },
        {
            name = "Luxor Passenger Flight 2",
            description = "Take the Luxor and its passengers to the Sandy Shores Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Luxor",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Luxor and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Sandy Shores Airport",
                    coords = { x = 1673.0, y = 3243.9, z = 40.9 },
                    requirement = "Fly safely and properly to the Sandy Shores Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Luxor back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 9000,
            plane_spawn = {
                model = "luxor",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 7
            }
        },
        {
                name = "Vestra Flight to Grapeseed",
                description = "Take the Vestra and its passengers to the Grapeseed airfield and make a clean landing.",
                checkpoints = {
                    {
                        name = "Vestra",
                        coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                        requirement = "Get into the Vestra and prepare yourself and your passengers for flight."
                    },
                    {
                        name = "Runway 1",
                        coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                        requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                        sound = "atc3"
                    },
                    {
                        name = "Grapeseed Airport",
                        coords = { x = 2124.5, y = 4806.1, z = 41.2 },
                        requirement = "Fly safely and properly to the Grapeseed Airport and make a clean landing."
                    },
                    {
                        name = "LSA",
                        coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                        requirement = "Take the Vestra back to Los Santos Airport."
                    },
                    {
                        name = "LSA Hangar",
                        coords = { x = -943.7, y = -2964.3, z = 13.9 },
                        requirement = "Park the Vestra in the hangar, and check in with staff, and that will be all for this flight!"
                    }
                },
                pay = 9000,
                plane_spawn = {
                    model = "vestra",
                    location = { x = -962.2, y = -2991.7, z = 13.9 },
                    passengers = 4
                }
        }
    },
    ["First Officer"] = {
        {
            name = "Titan Cargo Flight",
            description = "Take the Titan and its cargo to the Sandy Shores Airport safely.",
            checkpoints = {
                {
                    name = "Titan",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Titan and prepare yourself for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Sandy Shores Airport",
                    coords = { x = 1673.0, y = 3243.9, z = 40.9 },
                    requirement = "Fly safely and properly to the Sandy Shores Airport to drop your cargo off there.",
                    cargo_drop = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Titan back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 14000,
            plane_spawn = {
                model = "titan",
                location = { x = -962.2, y = -2991.7, z = 13.9 }
            }
        },
        {
            name = "Titan Cargo Flight 2",
            description = "Take the Titan and its cargo to the Fort Zancudo Airbase safely.",
            checkpoints = {
                {
                    name = "Titan",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Titan and prepare yourself for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Fort Zancudo Airbase",
                    coords = { x = -2480.2, y = 3262.6, z = 32.2 },
                    requirement = "Fly safely and properly to the Fort Zancudo Airbase to drop your cargo off there.",
                    cargo_drop = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Titan back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 15000,
            plane_spawn = {
                model = "titan",
                location = { x = -962.2, y = -2991.7, z = 13.9 }
            }
        },
        {
            name = "Nimbus Passenger Flight",
            description = "Take the Nimbus and its passengers to the Sandy Shores Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Nimbus",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Nimbus and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Sandy Shores Airport",
                    coords = { x = 1673.0, y = 3243.9, z = 40.9 },
                    requirement = "Fly safely and properly to the Sandy Shores Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Nimbus back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 9000,
            plane_spawn = {
                model = "nimbus",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 6
            }
        },
        {
            name = "Shamal Passenger Flight 2",
            description = "Take the Shamal and its passengers to Grapeseed Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Shamal",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Shamal and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Grapeseed Airport",
                    coords = { x = 2124.5, y = 4806.1, z = 41.2 },
                    requirement = "Fly safely and properly to the Grapeseed Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Shamal back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 9000,
            plane_spawn = {
                model = "shamal",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 5
            }
        },
        {
            name = "Luxor Passenger Flight 2",
            description = "Take the Luxor and its passengers to the Sandy Shores Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Luxor",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Luxor and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Sandy Shores Airport",
                    coords = { x = 1673.0, y = 3243.9, z = 40.9 },
                    requirement = "Fly safely and properly to the Sandy Shores Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Luxor back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 9000,
            plane_spawn = {
                model = "luxor",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 7
            }
        },
        {
                name = "Vestra Flight to Grapeseed",
                description = "Take the Vestra and its passengers to the Grapeseed airfield and make a clean landing.",
                checkpoints = {
                    {
                        name = "Vestra",
                        coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                        requirement = "Get into the Vestra and prepare yourself and your passengers for flight."
                    },
                    {
                        name = "Runway 1",
                        coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                        requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                        sound = "atc3"
                    },
                    {
                        name = "Grapeseed Airport",
                        coords = { x = 2124.5, y = 4806.1, z = 41.2 },
                        requirement = "Fly safely and properly to the Grapeseed Airport and make a clean landing."
                    },
                    {
                        name = "LSA",
                        coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                        requirement = "Take the Vestra back to Los Santos Airport."
                    },
                    {
                        name = "LSA Hangar",
                        coords = { x = -943.7, y = -2964.3, z = 13.9 },
                        requirement = "Park the Vestra in the hangar, and check in with staff, and that will be all for this flight!"
                    }
                },
                pay = 9000,
                plane_spawn = {
                    model = "vestra",
                    location = { x = -962.2, y = -2991.7, z = 13.9 },
                    passengers = 4
                }
        },
        {
                name = "Velum Flight to Grapeseed",
                description = "Take the Velum and its passengers to the Grapeseed airfield and make a clean landing.",
                checkpoints = {
                    {
                        name = "Velum",
                        coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                        requirement = "Get into the Velum and prepare yourself and your passengers for flight."
                    },
                    {
                        name = "Runway 1",
                        coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                        requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                        sound = "atc3"
                    },
                    {
                        name = "Grapeseed Airport",
                        coords = { x = 2124.5, y = 4806.1, z = 41.2 },
                        requirement = "Fly safely and properly to the Grapeseed Airport and make a clean landing."
                    },
                    {
                        name = "LSA",
                        coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                        requirement = "Take the Velum back to Los Santos Airport."
                    },
                    {
                        name = "LSA Hangar",
                        coords = { x = -943.7, y = -2964.3, z = 13.9 },
                        requirement = "Park the Velum in the hangar, and check in with staff, and that will be all for this flight!"
                    }
                },
                pay = 10000,
                plane_spawn = {
                    model = "velum",
                    location = { x = -962.2, y = -2991.7, z = 13.9 },
                    passengers = 4
                }
        },
        {
            name = "Shamal Passenger Flight",
            description = "Take the Shamal and its passengers to the Sandy Shores Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Shamal",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Shamal and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Sandy Shores Airport",
                    coords = { x = 1673.0, y = 3243.9, z = 40.9 },
                    requirement = "Fly safely and properly to the Sandy Shores Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Shamal back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 10000,
            plane_spawn = {
                model = "shamal",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 5
            }
        },
        {
            name = "Nimbus Passenger Flight",
            description = "Take the Nimbus and its passengers to Grapeseed Airport safely and let your passengers out there. ",
            checkpoints = {
                {
                    name = "Nimbus",
                    coords = {  x = -962.2, y = -2991.7, z = 13.9 },
                    requirement = "Get into the Nimbus and prepare yourself and your passengers for flight."
                },
                {
                    name = "Runway 1",
                    coords = {  x = -1058.1, y = -3103.1, z = 14.6 },
                    requirement = "When the coast is clear, get ready for takeoff and line up on Runway 1.",
                    sound = "atc3"
                },
                {
                    name = "Grapeseed Airport",
                    coords = { x = 2124.5, y = 4806.1, z = 41.2 },
                    requirement = "Fly safely and properly to the Grapeseed Airport to drop your passengers off there.",
                    passengers_exit = true
                },
                {
                    name = "LSA",
                    coords = { x = -1072.3, y = -3102.5, z = 13.9 },
                    requirement = "Take the Nimbus back to Los Santos Airport."
                },
                {
                    name = "LSA Hangar",
                    coords = { x = -943.7, y = -2964.3, z = 13.9 },
                    requirement = "Park it in the hangar, and check in with staff, and that will be all for this flight! Nice job, Flight Officer!"
                }
            },
            pay = 10000,
            plane_spawn = {
                model = "nimbus",
                location = { x = -962.2, y = -2991.7, z = 13.9 },
                passengers = 5
            }
        }
    }
}

RegisterServerEvent("pilotjob:newJob")
AddEventHandler("pilotjob:newJob", function()
    local usource = source
    local player = exports["essentialmode"]:getPlayerFromId(usource)
    TriggerEvent('es:exposeDBFunctions', function(couchdb)
        local query = {
            ["name"] = {
                ["first"] = player.getActiveCharacterData("firstName"),
                ["last"] = player.getActiveCharacterData("lastName")
            },
            ["dateOfBirth"] = player.getActiveCharacterData("dateOfBirth")
        }
        couchdb.getDocumentByRows("pilotjob", query, function(employee)
            if type(employee) ~= "boolean" then
                print("Pilot job employee existed!")
                NotifyPerson(usource, "Welcome back, " .. employee.rank.name .. " " .. employee.name.last .. "! You have completed " .. employee.flights.successes .. " flight(s) with us!")
                BeginNewJob(usource, employee)
            else
                ---------------------------------------------------
                -- CREATE NEW PILOT EMPLOYEE --
                ---------------------------------------------------
                print("Creating new pilot job employee...")
                local employee = {
                    name = {
                        first = player.getActiveCharacterData("firstName"),
                        last = player.getActiveCharacterData("lastName"),
                    },
                    dateOfBirth = player.getActiveCharacterData("dateOfBirth"),
                    rank = {
                        name = "Trainee",
                        number = 1
                    },
                    flights = {
                        successes = 0,
                        failures = 0,
                        total = 0
                    }
                }
                couchdb.createDocument("pilotjob", employee, function()
                    print("pilot job employee created!")
                    NotifyPerson(usource, "Welcome, " .. employee.rank.name .. " " .. employee.name.last .. "!")
                    BeginNewJob(usource, employee)
                end)
            end
        end)
    end)
end)

function BeginNewJob(src, employee)
    print("employee rank: " .. employee.rank.name)
    print("# missions for that rank: " .. #MISSIONS[employee.rank.name])
    local newjob = MISSIONS[employee.rank.name][math.random(#MISSIONS[employee.rank.name])]
    print("starting job: " .. newjob.name)
    NotifyPerson(src, "You've been assigned a " .. newjob.name .. ". " .. newjob.description)
    TriggerClientEvent("pilotjob:beginJob", src, newjob)
end

RegisterServerEvent("pilotjob:jobComplete")
AddEventHandler("pilotjob:jobComplete", function(job, givemoney)
    local usource = source
    local player = exports["essentialmode"]:getPlayerFromId(usource)
    if givemoney then
        TriggerEvent('es:exposeDBFunctions', function(couchdb)
            local query = {
                ["name"] = {
                    ["first"] = player.getActiveCharacterData("firstName"),
                    ["last"] = player.getActiveCharacterData("lastName")
                },
                ["dateOfBirth"] = player.getActiveCharacterData("dateOfBirth")
            }
            couchdb.getDocumentByRows("pilotjob", query, function(employee)
                if type(employee) ~= "boolean" then
                    print("Pilot job employee existed!")
                    -- pay money reward --
                    local reward
                    for i = 1, #MISSIONS[employee.rank.name] do
                        local m = MISSIONS[employee.rank.name][i]
                        if m.name == job.name then
                            reward = m.pay
                            print("reward set to: $" .. reward)
                            break
                        end
                    end
                    player.setActiveCharacterData("bank", player.getActiveCharacterData("bank") + reward)
                    print("pilot paid!")
                    -- log flight completion --
                    local new_total = employee.flights.total + 1
                    local new_successes = employee.flights.successes + 1
                    -- check rank promotion (incomplete) --
                    local rank_updated = false
                    if new_successes == 1 then
                        employee.rank.number = 2
                        employee.rank.name = "Junior Flight Officer"
                        rank_updated = true
                    elseif new_successes == 5 then
                        employee.rank.number = 3
                        employee.rank.name = "Flight Officer"
                        rank_updated = true
                    elseif new_successes == 12 then
                        employee.rank.number = 4
                        employee.rank.name = "First Officer"
                        rank_updated = true
                    end
                    -- update --
                    local update
                    if rank_updated then
                        update = {
                            flights = {
                                total = new_total,
                                successes = new_successes
                            },
                            rank = {
                                name = employee.rank.name,
                                number = employee.rank.number
                            }
                        }
                        print("rank updated!")
                        local sound = {soundset = "DLC_HEIST_HACKING_SNAKE_SOUNDS", name = "Goal"}
                        NotifyPerson(usource, "You have been promoted! New Rank: " .. employee.rank.name, false, sound)
                    else
                        update = {
                            flights = {
                                total = new_total,
                                successes = new_successes
                            }
                        }
                    end
                    couchdb.updateDocument("pilotjob", employee._id, update, function()
                        print("Flight successes updated!")
                        print("Total flights updated!")
                        NotifyPerson(usource, "Mission complete! You have been direct deposited: ^2$" .. comma_value(reward) .. "^0.", true)
                    end)
                end
            end)
        end)
    else
        NotifyPerson(usource, "Where is the plane?!")
    end
end)

function NotifyPerson(src, msg, chat_only, sound)
    TriggerClientEvent('chatMessage', src, "", {0, 0, 0}, "^3MISSION INFO:^0 " .. msg)
    if not chat_only then
        TriggerClientEvent("usa:notify", src, msg)
    end
    if sound then
        TriggerClientEvent("pilotjob:playSound", src, sound)
    end
end

function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end
