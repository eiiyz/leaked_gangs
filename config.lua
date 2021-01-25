Config = {}

-- GANGS --
Config.RaidCooldown = 5 -- in minutes

Config.StockPrices = {
	["ItemStock"] = {
		onehundedpcs = 50000 
	},

	["WeaponStock"] = {
		twentypcs = 100000
	}
}

Config.admins = {
	'steam:11000013af55e45', -- cfx
	'steam:110000119b9b40b', -- JIMBOY
	'steam:110000140412dff', -- DON B
}

Config.DoorList = {

	-- GANG 1 (TONGVA HILLS)
	{
		gangName = 'Gang1',
		objName = 'v_ilev_fh_frontdoor',
		objYaw = 185.63,
		openYaw = -105.0,
		closeYaw = 185.0,
		objCoords  = vector3(-2588.85, 1910.29, 167.62),
		textCoords = vector3(-2588.85, 1910.29, 167.62),
		locked = true
	},

	{
		gangName = 'Gang1',
		objName = 'hei_v_ilev_fh_heistdoor1',
		objYaw = 6.0,
		openYaw = 86.0,
		closeYaw = 6.0,
		objCoords  = vector3(-2599.442, 1917.331, 167.62),
		textCoords = vector3(-2599.442, 1917.331, 167.62),
		locked = true
	},

	{
		gangName = 'Gang1',
		objName = 'hei_v_ilev_fh_heistdoor1',
		objYaw = 42.70,
		openYaw = 121.70,
		closeYaw = 42.70,
		objCoords  = vector3(-2583.81, 1894.031, 163.87),
		textCoords = vector3(-2583.81, 1894.031, 163.87),
		locked = true
	},	

	-- GANG 2 (RESORTSV3)
	{
		gangName = 'Gang2',
		destroyed = false,
		objName = 1033441082,
		objYaw = 204.915,
		openYaw = 284.76,
		closeYaw = -204.915,
		objCoords  = vector3(-1500.635, 856.67, 181.72),
		textCoords = vector3(-1500.635, 856.67, 181.72),
		locked = true
	},	

	{
		gangName = 'Gang2',
		destroyed = false,
		textCoords = vector3(-1516.9, 851.57, 181.59),
		locked = true,
		doors = {
			{
				objName = 1033441082,
				objYaw = 160.0,
				objCoords = vector3(-1515.803, 850.72, 181.718)
			},

			{
				objName = 1033441082,
				objYaw = 340.0,
				objCoords = vector3(-1518.027, 851.55, 181.718)
			}
		}
	},	

	{
		gangName = 'Gang2',
		destroyed = false,
		objName = 1033441082,
		objYaw = 23.823,
		openYaw = 304.93,
		closeYaw = 23.823,
		objCoords  = vector3(-1520.77, 848.32, 181.72),
		textCoords = vector3(-1520.77, 848.32, 181.72),
		locked = true
	},	

	{
		gangName = 'Gang2',
		destroyed = false,
		objName = -1785293089,
		objYaw = 25.46,
		openYaw = 305.34,
		closeYaw = 25.46,
		objCoords  = vector3(-1500.82, 844.46, 181.72),
		textCoords = vector3(-1500.82, 844.46, 181.72),
		locked = true
	},

	{
		gangName = 'Gang2',
		destroyed = false,
		objName = -710818483,
		objYaw = 113.0,
		openYaw = 194.32,
		closeYaw = 113.0,
		objCoords  = vector3(-1493.702, 834.92, 177.20),
		textCoords = vector3(-1493.702, 834.92, 177.20),
		locked = true
	},					

	{
		gangName = 'Gang2',
		destroyed = false,
		textCoords = vector3(-1491.46, 853.1828, 181.59),
		locked = true,
		doors = {
			{
				objName = 1033441082,
				objYaw = 115.0,
				objCoords = vector3(-1490.46, 851.0336, 181.59)
			},
			
			{
				objName = 1033441082,
				objYaw = 295.0,
				objCoords = vector3(-1491.46, 853.1828, 181.59)
			}
		}
	},	

	-- GANG 3 (RANCHO)
	{ 
		gangName = 'Gang3', -- -190780785
		destroyed = false,
		objName = 'v_ilev_ra_door4r',
		objYaw = 180.0,
		openYaw = 100.0,
		closeYaw = 180.0,
		objCoords  = vector3(1407.55, 1128.32, 114.49),
		textCoords = vector3(1407.55, 1128.32, 114.49),
		locked = true
	},

	--{ 
	--	gangName = 'Gang3', -- -710818483
	--	destroyed = false,
	--	objName = 'v_ilev_rc_door2',
	--	objYaw = 270.0,
	--	openYaw = 190.0,
	--	closeYaw = 270.0,
	--	objCoords  = vector3(1400.051, 1134.62, 109.90),
	--	textCoords = vector3(1400.051, 1134.62, 109.90),
	--	authorizedNames = { 'steam:11000010e233a02' },
	--	locked = false
	--},

	{ 
		gangName = 'Gang3', -- -710818483
		destroyed = false,
		objName = 'v_ilev_rc_door2',
		objYaw = 90.0,
		openYaw = 9.0,
		closeYaw = 90.0,
		objCoords  = vector3(1400.046, 1136.13, 109.90),
		textCoords = vector3(1400.046, 1136.13, 109.90),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},	

	{
		gangName = 'Gang3',
		destroyed = false,
		textCoords = vector3(1390.424, 1163.43, 114.48),
		locked = true,
		doors = {
			{
				objName = 'v_ilev_ra_door1_r',
				objYaw = 90.0,
				objCoords = vector3(1390.424, 1163.43, 114.48)
			},

			{
				objName = 'v_ilev_ra_door1_l',
				objYaw = 90.0,
				objCoords = vector3(1390.411, 1161.241, 114.48)
			}
		}
	},	

	{
		gangName = 'Gang3',
		destroyed = false,
		textCoords = vector3(1408.166, 1165.85, 114.48),
		locked = true,
		doors = {
			{
				objName = 'v_ilev_ra_door1_r',
				objYaw = 90.0,
				objCoords = vector3(1408.166, 1165.85, 114.48)
			},

			{
				objName = 'v_ilev_ra_door1_l',
				objYaw = 90.0,
				objCoords = vector3(1408.171, 1163.63, 114.48)
			}
		}
	},	

	{
		gangName = 'Gang3',
		destroyed = false,
		textCoords = vector3(1390.424, 1163.43, 114.48),
		locked = true,
		doors = {
			{
				objName = 'v_ilev_ra_door1_r',
				objYaw = 90.0,
				objCoords = vector3(1408.167, 1161.155, 114.48)
			},

			{
				objName = 'v_ilev_ra_door1_l',
				objYaw = 90.0,
				objCoords = vector3(1408.157, 1158.956, 114.48)
			}
		}
	},
	
	{
		gangName = 'Gang3',
		destroyed = false,
		textCoords = vector3(1390.424, 1163.43, 114.48),
		locked = true,
		doors = {
			{
				objName = 'v_ilev_ra_door1_r',
				objYaw = 180.0,
				objCoords = vector3(1399.393, 1128.314, 114.48)
			},

			{
				objName = 'v_ilev_ra_door1_l',
				objYaw = 180.0,
				objCoords = vector3(1401.59, 1128.314, 114.48)
			}
		}
	},	

	{
		gangName = 'Gang3',
		destroyed = false,
		textCoords = vector3(1390.424, 1163.43, 114.48),
		locked = true,
		doors = {
			{
				objName = 'v_ilev_ra_door1_r',
				objYaw = 90.0,
				objCoords = vector3(1390.66, 1133.317, 114.48)
			},

			{
				objName = 'v_ilev_ra_door1_l',
				objYaw = 90.0,
				objCoords = vector3(1390.66, 1131.117, 114.48)
			}
		}
	},

	{
		gangName = 'Gang3',
		destroyed = false,
		textCoords = vector3(1390.424, 1163.43, 114.48),
		locked = true,
		doors = {
			{
				objName = 'v_ilev_ra_door4r',
				objYaw = 90.0,
				objCoords = vector3(1395.92, 1140.705, 114.48)
			},

			{
				objName = 'v_ilev_ra_door4l',
				objYaw = 270.0,
				objCoords = vector3(1395.92, 1142.904, 114.48)
			}
		}
	},

	-- GANG 5 FAMILIES		
	{
		gangName = 'Gang5',
		destroyed = false,
		objName = 'prop_gang_door_01',
		objYaw = -20.0,
		openYaw = -30.0,
		closeYaw = -110.0,
		objCoords  = vector3(-140.42, -1599.57, 34.83),
		textCoords = vector3(-140.42, -1599.57, 34.83),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},	

	{
		gangName = 'Gang5',
		destroyed = false,
		objName = 'prop_gang_door_01',
		objYaw = 230.0,
		openYaw = -30.0,
		closeYaw = -110.0,
		objCoords  = vector3(-147.82, -1596.48, 34.83),
		textCoords = vector3(-147.82, -1596.48, 34.83),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},	

	{
		gangName = 'Gang5',
		destroyed = false,
		objName = 'v_ilev_trev_doorbath',
		objYaw = 340.0,
		openYaw = -30.0,
		closeYaw = -110.0,
		objCoords  = vector3(-152.67, -1599.92, 35.03),
		textCoords = vector3(-152.67, -1599.92, 35.03),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},

	{
		gangName = 'Gang5',
		destroyed = false,
		objName = 'v_ilev_janitor_frontdoor',
		objYaw = 250.0,
		openYaw = -30.0,
		closeYaw = -110.0,
		objCoords  = vector3(-136.24, -1603.28, 35.03),
		textCoords = vector3(-136.24, -1603.28, 35.03),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},

	{
		gangName = 'Gang5',
		destroyed = false,
		objName = 'prop_ret_door_02',
		objYaw = 340.0,
		openYaw = -30.0,
		closeYaw = -110.0,
		objCoords  = vector3(-139.51, -1608.08, 35.03),
		textCoords = vector3(-139.51, -1608.08, 35.03),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},

	{
		gangName = 'Gang5',
		destroyed = false,
		objName = 'prop_gang_door_02',
		objYaw = 233.0,
		openYaw = -30.0,
		closeYaw = -110.0,
		objCoords  = vector3(-157.93, -1596.08, 35.03),
		textCoords = vector3(-157.93, -1596.08, 35.03),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},	

	-- GANG 6
	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy2',
				objYaw = 160.0,
				objCoords = vector3(-1889.67, 2051.58, 141.00)
			},

			{
				objName = 'ball_prop_italy2',
				objYaw = 340.0,
				objCoords = vector3(-1888.32, 2051.38, 141.01)
			}
		}
	},

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy2',
				objYaw = 160.0,
				objCoords = vector3(-1887.05, 2050.60, 141.01)
			},

			{
				objName = 'ball_prop_italy2',
				objYaw = 340.0,
				objCoords = vector3(-1885.82, 2050.10, 140.98)
			}
		}
	},			

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy3',
				objYaw = 140.0,
				objCoords = vector3(-1909.34, 2072.69, 140.40)
			},

			{
				objName = 'ball_prop_italy3',
				objYaw = 320.0,
				objCoords = vector3(-1908.45, 2071.94, 140.40)
			}
		}
	},

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy3',
				objYaw = 140.0,
				objCoords = vector3(-1911.88, 2074.78, 140.39)
			},

			{
				objName = 'ball_prop_italy3',
				objYaw = 320.0,
				objCoords = vector3(-1910.90, 2073.98, 140.40)
			}
		}
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy3',
				objYaw = 50.0,
				objCoords = vector3(-1910.81, 2080.41, 140.41)
			},

			{
				objName = 'ball_prop_italy3',
				objYaw = 230.0,
				objCoords = vector3(-1911.76, 2079.49, 140.38)
			}
		}
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy3',
				objYaw = 50.0,
				objCoords = vector3(-1906.50, 2085.12, 140.40)
			},

			{
				objName = 'ball_prop_italy3',
				objYaw = 230.0,
				objCoords = vector3(-1907.59, 2084.40, 140.38)
			}
		}
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy3',
				objYaw = 320.0,
				objCoords = vector3(-1901.21, 2085.67, 140.40)
			},

			{
				objName = 'ball_prop_italy3',
				objYaw = 140.0,
				objCoords = vector3(-1902.17, 2086.49, 140.40)
			}
		}
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy3',
				objYaw = 320.0,
				objCoords = vector3(-1898.72, 2083.61, 140.39)
			},

			{
				objName = 'ball_prop_italy3',
				objYaw = 140.0,
				objCoords = vector3(-1899.64, 2084.36, 140.40)
			}
		}
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy2',
				objYaw = 320.0,
				objCoords = vector3(-1893.06, 2075.14, 141.00)
			},

			{
				objName = 'ball_prop_italy2',
				objYaw = 140.0,
				objCoords = vector3(-1893.94, 2075.99, 141.00)
			}
		}
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy2',
				objYaw = 340.0,
				objCoords = vector3(-1885.36, 2074.08, 141.00)
			},

			{
				objName = 'ball_prop_italy2',
				objYaw = 160.0,
				objCoords = vector3(-1886.60, 2074.54, 141.00)
			}
		}
	},

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy2',
				objYaw = 340.0,
				objCoords = vector3(-1873.86, 2069.88, 141.00)
			},

			{
				objName = 'ball_prop_italy2',
				objYaw = 160.0,
				objCoords = vector3(-1874.96, 2070.29, 141.00)
			}
		}
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy2',
				objYaw = 180.0,
				objCoords = vector3(-1860.95, 2053.68, 140.98)
			},

			{
				objName = 'ball_prop_italy2',
				objYaw = 0.0,
				objCoords = vector3(-1859.73, 2053.67, 140.98)
			}
		}
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_fridge_mafia_l',
				objYaw = 270.0,
				objCoords = vector3(-1864.66, 2060.96, 140.98)
			},

			{
				objName = 'ball_fridge_mafia_r',
				objYaw = 270.0,
				objCoords = vector3(-1864.67, 2060.11, 140.98)
			}
		}
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		objName = 'v_ilev_cm_door1',
		objYaw = 270.0,
		openYaw = -30.0,
		closeYaw = -110.0,
		objCoords  = vector3(-1864.44, 2058.42, 135.46),
		textCoords = vector3(-1864.44, 2058.42, 135.46),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		objName = 'v_ilev_cm_door1',
		objYaw = 270.0,
		openYaw = -30.0,
		closeYaw = -110.0,
		objCoords  = vector3(-1861.11, 2058.28, 135.46),
		textCoords = vector3(-1861.11, 2058.28, 135.46),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},

	{
		gangName = 'Gang6',
		destroyed = false,
		objName = 'ball_prop_italy1',
		objYaw = 250.0,
		openYaw = -30.0,
		closeYaw = -110.0,
		objCoords  = vector3(-1878.48, 2056.97, 140.98),
		textCoords = vector3(-1878.48, 2056.97, 140.98),
		authorizedNames = { 'steam:11000010e233a02' },
		locked = true
	},	

	{
		gangName = 'Gang6',
		destroyed = false,
		textCoords = vector3(1395.81, 1141.90, 114.65),
		locked = true,
		doors = {
			{
				objName = 'ball_prop_italy1',
				objYaw = 160.0,
				objCoords = vector3(-1885.15, 2060.12, 145.57)
			},

			{
				objName = 'ball_prop_italy1',
				objYaw = 340.0,
				objCoords = vector3(-1883.96, 2059.68, 145.57)
			}
		}
	},											
}

-- GANG 1 --
Config.Zone = {

	["Gang1"] = {
		process1 = vector3(-2580.94, 1892.33, 163.72),
		processText1 = '[E] Get kevlar cloth',
		item1 = 'kevlar_cloth',
		amount = 2,
		itemStock = 100,
		requiredItem2 = 5,
		process2 = vector3(-2583.67, 1890.33, 163.72),
		processText2 = '[E] Assemble Kevlar',
		item2 = 'kevlar',
		authorizedNames = { 'steam:11000010e233a02' },
		isGangHarvesting1 = false,
		isGangHarvesting2 = false,
		processWait1 = 15000,
		processWait2 = 30000,
		dict1 = "amb@prop_human_bum_bin@base",
		anim1 = "base",
		label1 = "Processing...",
		armory = vector3(-2580.7, 1890.23, 163.72),
		weapon = 'WEAPON_KNIFE',
		weaponStock = 3,
		weaponAmmo = 42,
		setDelivery = vector3(-2592.65, 1884.42, 163.72),
		spawnDelivery = { x = -2583.95, y = 1918.76, z = 167.12, h = 5.47 },
		requiredItem = 5, -- for delivery
		deliveryPoint = vector3(1614.8, -2251.19, 106.98),
		stashRaid = vector3(-2585.07, 1892.05, 163.72),
		lastRaid = 0,
		raidTime = 600000,
		redZone = vector3(961.20, -137.82, 74.45),
		lastDelivery = 0,
		canRobStash = false

	},

	["Gang2"] = {
		process1 = vector3(-1486.2, 835.94, 177.0),
		processText1 = '[E] Get kevlar cloth',
		item1 = 'kevlar_cloth',
		amount = 2,
		itemStock = 100,
		requiredItem2 = 5,
		process2 = vector3(-1490.49, 833.94, 177.0),
		processText2 = '[E] Assemble Kevlar',
		item2 = 'kevlar',
		authorizedNames = { 'steam:11000012d179880' },
		isGangHarvesting1 = false,
		isGangHarvesting2 = false,
		processWait1 = 15000,
		processWait2 = 30000,
		dict1 = "amb@prop_human_bum_bin@base",
		anim1 = "base",
		label1 = "Processing...",
		armory = vector3(-1489.06, 842.63, 177.0),
		weapon = 'WEAPON_KNIFE',
		weaponStock = 10,
		weaponAmmo = 42,
		setDelivery = vector3(-1496.49, 843.03, 181.61),
		spawnDelivery = { x = -1486.11, y = 848.46, z = 181.41, h = 23.91 },
		requiredItem = 5, -- for delivery
		deliveryPoint = vector3(2136.78, 4774.9, 40.97),
		stashRaid = vector3(-1495.01, 840.43, 177.0),
		lastRaid = 0,
		raidTime = 600000,
		redZone = vector3(115.89, -1320.12, 28.94),
		lastDelivery = 0,
		canRobStash = false		
	},

	["Gang3"] = {
		process1 = vector3(1405.87, 1138.07, 109.75),
		processText1 = '[E] Get kevlar cloth',
		item1 = 'kevlar_cloth',
		amount = 2,
		itemStock = 100,
		requiredItem2 = 5,
		process2 = vector3(1403.16, 1136.55, 109.75),
		processText2 = '[E] Assemble Kevlar',
		item2 = 'kevlar',
		authorizedNames = { 'steam:11000012d179880' },
		isGangHarvesting1 = false,
		isGangHarvesting2 = false,
		processWait1 = 15000,
		processWait2 = 30000,
		dict1 = "amb@prop_human_bum_bin@base",
		anim1 = "base",
		label1 = "Processing...",
		armory = vector3(1401.36, 1139.86, 109.75),
		weapon = 'WEAPON_KNIFE',
		weaponStock = 10,
		weaponAmmo = 42,
		setDelivery = vector3(1393.3, 1159.98, 114.33),
		spawnDelivery = { x = 1414.14, y = 1120.54, z = 114.48, h = 92.35 },
		requiredItem = 5, -- for delivery
		deliveryPoint = vector3(-1579.01, 5160.61, 19.77),
		stashRaid = vector3(1404.18, 1139.87, 109.75),
		lastRaid = 0,
		raidTime = 600000,
		redZone = vector3(962.14, -1815.41, 31.08),
		lastDelivery = 0,
		canRobStash = false		
	},

	--[[["Gang4"] = {
		-- BODY ARMOR
		process1 = vector3(-27.33, -1398.81, 24.56),
		processText1 = '[E] Get kevlar cloth',
		item1 = 'kevlar_cloth',
		amount = 2,
		itemStock = 100,
		requiredItem2 = 5,
		process2 = vector3(-23.75, -1397.27, 24.56),
		processText2 = '[E] Assemble Kevlar',
		item2 = 'kevlar',
		authorizedNames = { 'steam:11000012d179880' },
		isGangHarvesting1 = false,
		isGangHarvesting2 = false,
		processWait1 = 15000,
		processWait2 = 30000,
		dict1 = "amb@prop_human_bum_bin@base",
		anim1 = "base",
		label1 = "Processing...",
		armory = vector3(-27.88, -1396.37, 24.56),
		weapon = 'WEAPON_PISTOL50',
		weaponStock = 10,
		weaponAmmo = 42,
		setDelivery = vector3(-31.40, -1397.44, 29.51),
		spawnDelivery = { x = -7.06, y = -1403.68, z = 29.35, h = 31.96 },
		requiredItem = 20, -- for delivery
		deliveryPoint = vector3(1728.41, 3322.61, 40.22),
		stashRaid = vector3(-29.75, -1401.88, 24.56),
		lastRaid = 0,
		raidTime = 600000,
		redZone = vector3(-10.72, -1389.95, 29.36),
		lastDelivery = 0,
		canRobStash = false		
	},]]

	["Gang5"] = {
		-- SMG BULLET
		process1 = vector3(-131.40, -1607.02, 35.03),
		processText1 = '[E] Get kevlar cloth',
		item1 = 'kevlar_cloth',
		amount = 2,
		itemStock = 100,
		requiredItem2 = 5,
		process2 = vector3(-136.66, -1606.75, 35.03),
		processText2 = '[E] Assemble Kevlar',
		item2 = 'kevlar',
		authorizedNames = { 'steam:11000012d179880' },
		isGangHarvesting1 = false,
		isGangHarvesting2 = false,
		processWait1 = 15000,
		processWait2 = 30000,
		dict1 = "amb@prop_human_bum_bin@base",
		anim1 = "base",
		label1 = "Processing...",
		armory = vector3(-137.70, -1609.78, 35.03),
		weapon = 'WEAPON_KNIFE',
		weaponStock = 10,
		weaponAmmo = 42,
		setDelivery = vector3(-144.24, -1607.47, 35.03),
		spawnDelivery = { x = -113.73, y = -1609.72, x = 31.68, h = 318.73 },
		requiredItem = 5, -- for delivery
		deliveryPoint = vector3(409.24, 6622.5, 28.18),
		stashRaid = vector3(-155.60, -1604.03, 35.04),
		lastRaid = 0,
		raidTime = 600000,
		redZone = vector3(-150.82, -1582.90, 34.68),
		lastDelivery = 0,
		canRobStash = false		
	},

	["Gang6"] = {
		-- COMBAT PDW
		process1 = vector3(-1868.39, 2057.59, 135.44),
		processText1 = '[E] Get kevlar cloth',
		item1 = 'kevlar_cloth',
		amount = 2,
		itemStock = 100,
		requiredItem2 = 5,
		process2 = vector3(-1870.51, 2061.27, 135.43),
		processText2 = '[E] Assemble Kevlar',
		item2 = 'kevlar',
		authorizedNames = { 'steam:11000012d179880' },
		isGangHarvesting1 = false,
		isGangHarvesting2 = false,
		processWait1 = 15000,
		processWait2 = 30000,
		dict1 = "amb@prop_human_bum_bin@base",
		anim1 = "base",
		label1 = "Processing...",
		armory = vector3(-1866.19, 2065.52, 135.43),
		weapon = 'WEAPON_KNIFE',
		weaponStock = 10,
		weaponAmmo = 42,
		setDelivery = vector3(-1876.15, 2062.59, 145.57),
		spawnDelivery = { x = -1892.45, y = 2019.83, z = 140.80, h = 180.29 },
		requiredItem = 5, -- for delivery
		deliveryPoint = vector3(160.91, -3290.66, 5.98),
		stashRaid = vector3(-1879.55, 2062.51, 135.92),
		lastRaid = 0,
		raidTime = 600000,
		redZone = vector3(-1894.35, 2027.04, 140.73),
		lastDelivery = 0,
		canRobStash = false		
	}					
}

