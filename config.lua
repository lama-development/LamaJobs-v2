Config = {}

---------------------------------------------------------------
--                                                           --
--                    General Configuration                  --
--                                                           --
---------------------------------------------------------------

-- Leave this to false if you want the jobs to be standalone
-- Set to true if you use ND_Framework (https://forum.cfx.re/t/wip-nd-core/4792200) and allow job payments
Config.UseND = true

-- Choose to enable or disable certain jobs
Config.EnabledJobs = {
    ['car_jacking'] = true,
    ['dock_worker'] = true,
    ['drug_trafficking'] = true,
    ['food_delivery'] = true,
    ['garbage_collector'] = true,
    ['truck_driver'] = true
}

---------------------------------------------------------------
--                                                           --
--                      Car Jacking Job                      --
--                                                           --
---------------------------------------------------------------

-- Set the amount of money the player will be paid for each vehicle theft completed
-- For example, if it is equal to 500, delivering 3 cars will get you $1500
-- Only works if you set UseND to true, otherwise leave this as it is
Config.PayPerTheft = math.random(120, 500)

-- Set to true if you have a /911 script on your server
-- This will allow a random chance of the police being alerted when you steal a car
-- Please note that the 911 command must be /911 [message] otherwise it won't work
Config.Has911Script = true 

-- Set the starting vehicle models used for the job. These are chosen at random
Config.StartingVehicles = {
	'asea',
	'primo',
	'glendale',
    'ingot',
    'warrener'
}

-- Set the location of the blip on the map where the player can start the job
Config.StartBlipLocation = { x = 1394.37, y = 1141.86,  z = 114.6 }

-- Set the location where you want the starting vehicle to spawn at the start of the mission
-- I suggest having this near your BlipLocation
-- h is the heading (what direction the vehicle will face when spawned)
Config.StartingVehicleLocation = { x = 1370.02, y = 1147.07,  z = 113.28,  h = 357.18 }

-- Set the location where to drop off the vehicles
Config.DropoffLocation = { x = 1401.76, y = 1116.46,  z = 114.36}

-- Set the location where to collect your final payment
Config.EndJobLocation = { x = 1411.23, y = 1146.76, z = 114.33}

-- Set the possible locations for the vehicles to spawn
-- h is the heading (what direction the car will face when spawned)
-- Make sure they have a large place to spawn
Config.VehicleLocations = {
    { x = -1159.73, y = 2673.9, z = 17.62, h = 221.05 }, -- Ammunation (403)
    { x = 367.07, y = 2632.13, z = 44.02, h = 27.32 }, -- Easter Motel (241)
    { x = 558.78, y = 2734.15,  z = 41.58,  h = 184.37 }, -- Dollar Pills (244)
    { x = 1098.06, y = 2662.87, z = 37.5, h = 359.79 }, -- Motor Motel (260)
    { x = 2800.34, y = 3497.09, z = 54.43, h = 70.59 }, -- YouTool (313)
    { x = 2465.21, y = 4063.73, z = 37.32, h = 155.64 }, -- Liquor Market (317)
    { x = 1690.88, y = 4778.37, z = 41.43, h = 90.72 } -- Wonderama Arcade (114)
}

-- Set the possible vehicle model names that will be stolen
Config.VehicleModels = {
    'f620',
    'windsor',
    'nightshade',
    'cheetah2',
    'alpha',
    'carbonizzare',
    'jester',
    'adder',
    'bullet',
    'entityxf',
    'feltzer3'
}

---------------------------------------------------------------
--                                                           --
--                   Drug Trafficking Job                    --
--                                                           --
---------------------------------------------------------------

-- The possible vehicle that will be used for the job
Config.DrugVehicle = {
    'speedo',
    'rumpo',
    'rumpo2'
}

-- Set the amount of money the player will be paid for each delivery completed
-- Only works if you set UseND to true, otherwise leave this as it is
Config.DrugPay = 200

-- Set the location where you want the job to start
Config.DrugStartingPosition = vector3(2201.32, 5616.51, 53.78)

-- Set all of the possible delivery locations
Config.DrugPositions = {
    {x = 2051.64, y = 3173.85, z = 43.16}, -- Panorama Dr Shed (3044)
    {x = 1723.41, y = 3306.06, z = 39.33}, -- Sandy Shores Hangar (3037)
    {x = 2134.00, y = 4779.84, z = 38.79}, -- Grapespeed Hangar (2030)
    {x = 1342.41, y = 4318.90, z = 35.82}, -- Millar's Fishery (2015)
    {x = 2557.02, y = 4641.42, z = 31.89}, -- Grapespeed Tree Farm Shad (2040)
    {x = 2712.47, y = 4140.85, z = 41.74}, -- East Joshua Road Shed (2049)
    {x = 2510.50, y = 4076.21, z = 36.42}, -- East Joshua Auto Repairs (2048)
    {x = 1968.75, y = 3821.98, z = 30.2}, -- Trevor's Roulotte (3009)
    {x = 1558.58, y = 3794.97, z = 31.92}, -- Boat House (3022)
    {x = 1377.16, y = 3620.9, z = 32.70}, -- Ace Liquor (3026)
    {x = 903.42, y = 3614.43, z = 30.64}, -- Marina Dr Abandoned Garage (3030)
    {x = 389.00, y = 3589.44, z = 30.11}, -- Marina Dr Tractor Parts (3032)
    {x = 20.73, y = 3715.05, z = 37.51}, -- Stab City (3034)
    {x = 1643.74, y = 4836.80, z = 39.84}, -- Grapespeed Paint Shop (2009)
    {x = 1905.70, y = 4924.23, z = 46.69}, -- Grapespeed Farm (2023)
    {x = 2456.38, y = 4953.71, z = 42.94 } -- O'Neil Brothers 2027
}

---------------------------------------------------------------
--                                                           --
--                     Food Delivery Job                     --
--                                                           --
---------------------------------------------------------------

-- Set the possible vehicle models used for the job
Config.FoodCarModels = {
    'faggio',
    'faggio2',
    'blista',    
    'asbo',
    'dilettante'
}

-- Set how many food deliveries you want to be able to make before having to return to the restaurant
Config.FoodMaxRuns = 3

---------------------------------------------------------------
--                                                           --
--                   Garbage Collector Job                   --
--                                                           --
---------------------------------------------------------------

-- Set the garbage truck model used for the job
Config.GarbageTruck = 'trash'

-- Set the amount of money earned per task completed
-- Only works if you set UseND to true, otherwise leave this as it is
Config.GarbageAmount = 100

-- Set the possible garbage pickup locations
Config.GarbagePos = {
    Pos1 = { x = 948.92, y = -2175.81, z = 29.55 },
    Pos2 = { x = 971.32, y = -1874.2, z = 30.17 },
    Pos3 = { x = 975.3, y = -1816.25, z = 30.14 },
    Pos4 = { x = 969.45, y = -1702.35, z = 28.6 },
    Pos5 = { x = 778.27, y = -1620.87, z = 30.03 },
    Pos6 = { x = 1012.64, y = -2294.66, z = 29.51 },
    Pos7 = { x = 848.94, y = -1982.05, z = 28.3 },
    Pos8 = { x = 731.7, y = -2005.4, z = 28.29 },
    Pos9 = { x = 718.04, y = -2270.18, z = 27.47 },
    Pos10 = { x = 821.1, y = -1976.59, z = 29.28 },
    Pos11 = { x = 954.87, y = -1968.75, z = 30.34 },
    Pos12 = { x = 1040.23, y = -2184.34, z = 31.41 },
    Pos13 = { x = 811.76, y = -2231.12, z = 29.72 },
    Pos14 = { x = 856.07, y = -2254.76, z = 30.34 },
    Pos15 = { x = 819.89, y = -1629.7, z = 31.04 }
}

---------------------------------------------------------------
--                                                           --
--                      Port Cargo Job                       --
--                                                           --
---------------------------------------------------------------

-- Amount of money earned per cargo moved
-- Only works if you set UseND to true, otherwise leave this as it is
Config.CargoAmount = 120

-- Set the cargo props models and their spawning locations
Config.CargoProps = {
    Liv1 = { model = 1842782908, x = 1135.572, y = -3225.1677, z = 4.89},
    Liv2 = { model = 2092857693, x = 756.9169, y = -3194.9477, z = 5.07}, 
    Liv3 = { model = 2343741282, x = 740.6317, y = -3164.3950, z = 4.90}, 
    Liv4 = { model = 4105984272, x = 851.3989, y = -3345.8024, z = 4.90}, 
    Liv5 = { model = 286252949, x = 536.934, y = -2854.749, z = 5.05}, 
    Liv6 = { model = 3079285877, x = 1179.838, y = -3282.6823, z = 5.02}, 
    Liv7 = { model = 1805980844, x = 788.4685, y = -2917.228, z = 4.88}, 
    Liv8 = { model = 2615768110, x = 953.053, y = -3263.194, z = 4.89}, 
    Liv10 = { model = 1474287310, x = 1217.8952, y = -3002.961, z = 4.865}, 
    Liv11 = { model = 1056511355, x = 467.4089, y = -3124.207, z = 5.07}, 
    Liv12 = { model = 1731949568, x = 1207.3117, y = -2921.1137, z = 4.87},
    Liv13 = { model = 3901397587, x = 1017.784, y = -2901.6757, z = 4.90}, 
    Liv14 = { model = 1962326206, x = 663.84375, y = -3004.2668, z = 5.045}, 
    Liv15 = { model = 4059031766, x = 658.01086, y = -3019.2387, z = 5.063}, 
    Liv16 = { model = 3837887815, x = 855.8321, y = -3286.2360, z = 4.89}, 
}

-- Set the possible locations to bring the cargo to
Config.CargoPos = {
    Pos1 = {x= 1226.46, y= -3330.60, z= 5.03},
    Pos2 = {x = 1240.93, y = -3168.47, z = 6.10},
    Pos3 = {x = 464.15, y = -3195.22, z = 5.06},
    Pos4 = {x = 462.98, y = -3273.04, z = 5.06},
    Pos5 = {x = 465.25, y =-2932.20, z = 5.04},
    Pos6 = {x = 603.63, y = -2994.61, z = 6.64},
    Pos7 = {x = 632.54, y = -2965.11, z = 5.13},
    Pos8 = {x = 586.65, y = -2902.77, z = 5.04},
    Pos9 = {x = 1220.78, y = -3010.81, z = 4.86},
    Pos10 = {x = 1218.95, y = -3005.53, z = 4.86},
    Pos11 = {x = 1189.27, y = -3107.06, z = 4.56},
    Pos12 = {x = 1179.02, y = -3132.42, z = 4.54},
    Pos13 = {x = 1183.05, y = -3162.76, z = 6.12},
    Pos14 = {x = 1183.26, y = -3169.42, z = 6.11},
    Pos15 = {x = 1113.88, y = -3298.26, z = 4.89},
    Pos16 = {x = 1182.44, y = -3188.00, z = 6.63}, 
    Pos17 = {x = 1225.98, y = -3064.10, z = 4.90},
    Pos18 = {x = 1012.04, y = -2902.98, z = 4.90},
}

---------------------------------------------------------------
--                                                           --
--                     Truck Driver Job                      --
--                                                           --
---------------------------------------------------------------

-- Set the amount of money the player will be paid for each delivery completed
-- For example, if it is equal to 500, delivering 3 trailers will get you $1500
-- Only works if you set UseND to true, otherwise leave this as it is
Config.PayPerDelivery = 700

-- Set the amount of money the player will be fined for cancelling the job
-- Only works if you set UseND to true, otherwise leave this as it is
Config.Penalty = 250

-- Set the possible truck models used for the job
Config.TruckModel = {
    'phantom',
    'hauler',
    'packer'
}

-- Set the location of the blip on the map where the player can start the job
Config.BlipLocation = { x = 346.05, y = 3407.15,  z = 35.5 }

-- Set the location where you want the truck to spawn at the start of the mission
-- I suggest having this near your BlipLocation
-- h is the heading (what direction the truck will face when spawned)
Config.DepotLocation = { x = 334.67, y = 3411.53,  z = 36.65,  h = 292.12 }

-- Set the possible locations for the trailers to spawn
-- Make sure they have a large place to spawn
Config.TrailerLocations = {
    { x = 167.69,  y = 2756.53,  z = 43.39, h = 239.22 }, -- Small warehouse on Joshua Rd (4014)
    { x = 648.13, y = 2763.6, z = 41.97, h = 184.53 }, -- Harmony Suburban (4020)
    { x = 302.3, y = 2833.88, z = 43.45, h = 305.92 }, -- Harmony Cement Factory (4014)
    { x = 1374.99, y = 3611.88,  z = 34.89,  h = 199.46 }, -- Ace Liquor (3026)
    { x = 2327.29, y = 3138.91, z = 48.17, h = 79.8 }, -- Cat-Claw Ave Recycling Center (3048)
    { x = 2672.65, y = 3517.07, z = 52.71, h = 333.39 }, -- YouTool (3052)
    { x = 2895.51, y = 4381.8, z = 50.38, h = 287.41 }, -- Union Grain Supply Inc (2050)
    { x = 1714.21, y = 4807.46, z = 41.8, h = 101.8 } -- Wonderama Arcade (2010)
}

-- Set the possible destinations where you have to drive the trailer to
Config.Destinations = {
    { x = -3169.63, y = 1102.37, z = 20.74 }, -- Chumash Plaza (5033)
    { x = 31.54, y = 6287.21, z = 31.24 }, -- Cluckin Bell Factory (1021)
    { x = -360.2, y = 6073.27, z = 31.5 }, -- Paleto Bay Market (1036)
    { x = 3640.62, y = 3766.41, z = 28.52 }, -- Humane Labs (2060)  
    { x = 2525.09, y = 2625.93, z = 37.94 }, -- Rex's Diner (3056)
    { x = 2790.15, y = 1408.84, z = 24.44 }, -- Palmer-Taylor Power Station (3063)
    { x = 2551.89, y = 438.54, z = 108.45 }, -- Route 15 Gas Station (7355)
    { x = -1664.99, y = 3121.59, z = 31.72 }, -- Fort Zancudo (5005)
    { x = 1531.33, y = 784.24, z = 77.44 }, -- LS Freeway (7357)
    { x = 789.08, y = 1289.67, z =  360.3}, -- Mt Haan Dr (5025)
    { x = 974.03, y = 3.9, z = 81.04 }, -- Casino (7292) 
    { x = -2030.78, y = -262.44, z = 23.39 }, -- The Jetty Hotel (7009)
    { x = -2962.85, y = 60.93, z =  11.61 }, -- Pacific Bluffs Country Club (5062)
    { x = -802.16, y = 5409.08, z = 33.86 } -- GOH Paleto Forest (1083)
}

-- Set the possible trailer model names that will be used
Config.TrailerModels = {
    'docktrailer',
    'tr4',
    'trailers',
    'trailers2',
    'trailers3',
    'trailers4',
    'trailerlogs',
    'tanker',
    'tanker2'
}