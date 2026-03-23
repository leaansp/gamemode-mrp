#if defined _marp_vehicles_data_included
	#endinput
#endif
#define _marp_vehicles_data_included

static enum e_VEH_MODEL_DATA
{
	mName[32],
	mType,
	mPrice,
	mTrunkSpace,
	mSeats
};

static const CarModels[][e_VEH_MODEL_DATA] = {

/*400*/	{
	/*mName*/ "Landstalker",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 100000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*401*/	{
	/*mName*/ "Bravura",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 40000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*402*/	{
	/*mName*/ "Buffalo",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 750000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*403*/	{
	/*mName*/ "Linerunner",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 480000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*404*/	{
	/*mName*/ "Perenniel",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 45000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*405*/	{
	/*mName*/ "Sentinel",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 75000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*406*/	{
	/*mName*/ "Dumper",
	/*mType*/ VTYPE_MONSTER,
	/*mPrice*/ 758250,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*407*/	{
	/*mName*/ "Firetruck",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 450550,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 2
	},
/*408*/	{
	/*mName*/ "Trashmaster",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 280000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*409*/	{
	/*mName*/ "Stretch",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 550000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*410*/	{
	/*mName*/ "Manana",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 36000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*411*/	{
	/*mName*/ "Infernus",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 1000000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*412*/	{
	/*mName*/ "Voodoo",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 69100,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*413*/	{
	/*mName*/ "Pony",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 105100,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 4
	},
/*414*/	{
	/*mName*/ "Mule",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 98200,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 4
	},
/*415*/	{
	/*mName*/ "Cheetah",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 750400,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*416*/	{
	/*mName*/ "Ambulance",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 550100,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*417*/	{
	/*mName*/ "Leviathan",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 1750000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 2
	},
/*418*/	{
	/*mName*/ "Moonbeam",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 80400,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*419*/	{
	/*mName*/ "Esperanto",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 58000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*420*/	{
	/*mName*/ "Taxi",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 86000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*421*/	{
	/*mName*/ "Washington",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 75100,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*422*/	{
	/*mName*/ "Bobcat",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 35800,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 2
	},
/*423*/	{
	/*mName*/ "Mr Whoopee",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 98800,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*424*/	{
	/*mName*/ "BF Injection",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 95000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*425*/	{
	/*mName*/ "Hunter",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 10000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*426*/	{
	/*mName*/ "Premier",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 90000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*427*/	{
	/*mName*/ "Enforcer",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 400000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 4
	},
/*428*/	{
	/*mName*/ "Securicar",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 400000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 4
	},
/*429*/	{
	/*mName*/ "Banshee",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 595000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*430*/	{
	/*mName*/ "Predator",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 1000000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 1
	},
/*431*/	{
	/*mName*/ "Bus",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 592000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 9
	},
/*432*/	{
	/*mName*/ "Rhino",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 10000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*433*/	{
	/*mName*/ "Barracks",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 400000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 2
	},
/*434*/	{
	/*mName*/ "Hotknife",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 384000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*435*/	{
	/*mName*/ "Article Trailer",
	/*mType*/ VTYPE_TRAILER,
	/*mPrice*/ 150000,
	/*mTrunkSpace*/ 500,
	/*mSeats*/ 1
	},
/*436*/	{
	/*mName*/ "Previon",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 39000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*437*/	{
	/*mName*/ "Coach",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 599000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 9
	},
/*438*/	{
	/*mName*/ "Cabbie",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 79000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*439*/	{
	/*mName*/ "Stallion",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 65000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*440*/	{
	/*mName*/ "Rumpo",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 95000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 4
	},
/*441*/	{
	/*mName*/ "RC Bandit",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*442*/	{
	/*mName*/ "Romero",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 105000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*443*/	{
	/*mName*/ "Packer",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 428000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*444*/	{
	/*mName*/ "Monster",
	/*mType*/ VTYPE_MONSTER,
	/*mPrice*/ 675000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*445*/	{
	/*mName*/ "Admiral",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 76750,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*446*/	{
	/*mName*/ "Squallo",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 425000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 1
	},
/*447*/	{
	/*mName*/ "Seasparrow",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 2000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*448*/	{
	/*mName*/ "Pizzaboy",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 25000,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*449*/	{
	/*mName*/ "Tram",
	/*mType*/ VTYPE_TRAIN,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*450*/	{
	/*mName*/ "Article Trailer 2",
	/*mType*/ VTYPE_TRAILER,
	/*mPrice*/ 150000,
	/*mTrunkSpace*/ 500,
	/*mSeats*/ 1
	},
/*451*/	{
	/*mName*/ "Turismo",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 1050000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*452*/	{
	/*mName*/ "Speeder",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 355000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 1
	},
/*453*/	{
	/*mName*/ "Reefer",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 415000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 1
	},
/*454*/	{
	/*mName*/ "Tropic",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 830000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 1
	},
/*455*/	{
	/*mName*/ "Flatbed",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 180000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 2
	},
/*456*/	{
	/*mName*/ "Yankee",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 155000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 2
	},
/*457*/	{
	/*mName*/ "Caddy",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 85000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*458*/	{
	/*mName*/ "Solair",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 80000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*459*/	{
	/*mName*/ "Berkley's RC Van",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 90000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 4
	},
/*460*/	{
	/*mName*/ "Skimmer",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 405000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*461*/	{
	/*mName*/ "PCJ-600",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 98000,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*462*/	{
	/*mName*/ "Faggio",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 7855,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*463*/	{
	/*mName*/ "Freeway",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 82950,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*464*/	{
	/*mName*/ "RC Baron",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*465*/	{
	/*mName*/ "RC Raider",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*466*/	{
	/*mName*/ "Glendale",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 55000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*467*/	{
	/*mName*/ "Oceanic",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 47770,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*468*/	{
	/*mName*/ "Sanchez",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 68790,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*469*/	{
	/*mName*/ "Sparrow",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 415000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*470*/	{
	/*mName*/ "Patriot",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 315000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*471*/	{
	/*mName*/ "Quad",
	/*mType*/ VTYPE_QUAD,
	/*mPrice*/ 30000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*472*/	{
	/*mName*/ "Coastguard",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 115000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 1
	},
/*473*/	{
	/*mName*/ "Dinghy",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 55000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*474*/	{
	/*mName*/ "Hermes",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 76000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*475*/	{
	/*mName*/ "Sabre",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 100000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*476*/	{
	/*mName*/ "Rustler",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 1500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*477*/	{
	/*mName*/ "ZR-350",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 625000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*478*/	{
	/*mName*/ "Walton",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 29950,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*479*/	{
	/*mName*/ "Regina",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 70000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*480*/	{
	/*mName*/ "Comet",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*481*/	{
	/*mName*/ "BMX",
	/*mType*/ VTYPE_BMX,
	/*mPrice*/ 6500,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*482*/	{
	/*mName*/ "Burrito",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 125000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 4
	},
/*483*/	{
	/*mName*/ "Camper",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 66000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 3
	},
/*484*/	{
	/*mName*/ "Marquis",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 485000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 1
	},
/*485*/	{
	/*mName*/ "Baggage",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 40000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*486*/	{
	/*mName*/ "Dozer",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*487*/	{
	/*mName*/ "Maverick",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 1200000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*488*/	{
	/*mName*/ "SAN News Maverick",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 1200000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*489*/	{
	/*mName*/ "Rancher",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 105000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*490*/	{
	/*mName*/ "FBI Rancher",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 150000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*491*/	{
	/*mName*/ "Virgo",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 55000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*492*/	{
	/*mName*/ "Greenwood",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 70000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*493*/	{
	/*mName*/ "Jetmax",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 470000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 1
	},
/*494*/	{
	/*mName*/ "Hotring Racer",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 1000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*495*/	{
	/*mName*/ "Sandking",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 1000000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*496*/	{
	/*mName*/ "Blista Compact",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 100500,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*497*/	{
	/*mName*/ "Police Maverick",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 1500000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*498*/	{
	/*mName*/ "Boxville",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 95000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 4
	},
/*499*/	{
	/*mName*/ "Benson",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 90000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 2
	},
/*500*/	{
	/*mName*/ "Mesa",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 75000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*501*/	{
	/*mName*/ "RC Goblin",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*502*/	{
	/*mName*/ "Hotring Racer",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 1000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*503*/	{
	/*mName*/ "Hotring Racer",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 1000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*504*/	{
	/*mName*/ "Bloodring Banger",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 200000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*505*/	{
	/*mName*/ "Rancher",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 105000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*506*/	{
	/*mName*/ "Super GT",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 700000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*507*/	{
	/*mName*/ "Elegant",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 90000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*508*/	{
	/*mName*/ "Journey",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 180000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 2
	},
/*509*/	{
	/*mName*/ "Bike",
	/*mType*/ VTYPE_BMX,
	/*mPrice*/ 2500,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*510*/	{
	/*mName*/ "Mountain Bike",
	/*mType*/ VTYPE_BMX,
	/*mPrice*/ 10000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*511*/	{
	/*mName*/ "Beagle",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 415000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*512*/	{
	/*mName*/ "Cropduster",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 400000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*513*/	{
	/*mName*/ "Stuntplane",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 420000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*514*/	{
	/*mName*/ "Tanker",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 440000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*515*/	{
	/*mName*/ "Roadtrain",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 485000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*516*/	{
	/*mName*/ "Nebula",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 55000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*517*/	{
	/*mName*/ "Majestic",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 60000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*518*/	{
	/*mName*/ "Buccaneer",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 45000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*519*/	{
	/*mName*/ "Shamal",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 1500000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 1
	},
/*520*/	{
	/*mName*/ "Hydra",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 10000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*521*/	{
	/*mName*/ "FCR-900",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 110000,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*522*/	{
	/*mName*/ "NRG-500",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 775000,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*523*/	{
	/*mName*/ "HPV1000",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 100000,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*524*/	{
	/*mName*/ "Cement Truck",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 285000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*525*/	{
	/*mName*/ "Towtruck",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 75000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*526*/	{
	/*mName*/ "Fortune",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 85000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*527*/	{
	/*mName*/ "Cadrona",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 41000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*528*/	{
	/*mName*/ "FBI Truck",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 250000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*529*/	{
	/*mName*/ "Willard",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 55000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*530*/	{
	/*mName*/ "Forklift",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 90000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*531*/	{
	/*mName*/ "Tractor",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 40000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*532*/	{
	/*mName*/ "Combine Harvester",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 600000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*533*/	{
	/*mName*/ "Feltzer",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 110000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*534*/	{
	/*mName*/ "Remington",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 86000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*535*/	{
	/*mName*/ "Slamvan",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 90000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*536*/	{
	/*mName*/ "Blade",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 100000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*537*/	{
	/*mName*/ "Freight",
	/*mType*/ VTYPE_TRAIN,
	/*mPrice*/ 2000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*538*/	{
	/*mName*/ "Brownstreak",
	/*mType*/ VTYPE_TRAIN,
	/*mPrice*/ 2000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*539*/	{
	/*mName*/ "Vortex",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 1550000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*540*/	{
	/*mName*/ "Vincent",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 70000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*541*/	{
	/*mName*/ "Bullet",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 900000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*542*/	{
	/*mName*/ "Clover",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 45000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*543*/	{
	/*mName*/ "Sadler",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 50000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 2
	},
/*544*/	{
	/*mName*/ "Firetruck LA",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 400000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 2
	},
/*545*/	{
	/*mName*/ "Hustler",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 325000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*546*/	{
	/*mName*/ "Intruder",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 65000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*547*/	{
	/*mName*/ "Primo",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 50000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*548*/	{
	/*mName*/ "Cargobob",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 1600000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 2
	},
/*549*/	{
	/*mName*/ "Tampa",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 50000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*550*/	{
	/*mName*/ "Sunrise",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 85000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*551*/	{
	/*mName*/ "Merit",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 110000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*552*/	{
	/*mName*/ "Utility Van",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 230000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*553*/	{
	/*mName*/ "Nevada",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 1250000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 1
	},
/*554*/	{
	/*mName*/ "Yosemite",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 90000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 2
	},
/*555*/	{
	/*mName*/ "Windsor",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 150000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*556*/	{
	/*mName*/ "Monster A",
	/*mType*/ VTYPE_MONSTER,
	/*mPrice*/ 700000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*557*/	{
	/*mName*/ "Monster B",
	/*mType*/ VTYPE_MONSTER,
	/*mPrice*/ 700000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*558*/	{
	/*mName*/ "Uranus",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 350000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*559*/	{
	/*mName*/ "Jester",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*560*/	{
	/*mName*/ "Sultan",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 600000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*561*/	{
	/*mName*/ "Stratum",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 200000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*562*/	{
	/*mName*/ "Elegy",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*563*/	{
	/*mName*/ "Raindance",
	/*mType*/ VTYPE_HELI,
	/*mPrice*/ 1350000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*564*/	{
	/*mName*/ "RC Tiger",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*565*/	{
	/*mName*/ "Flash",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 400000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*566*/	{
	/*mName*/ "Tahoma",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 92000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*567*/	{
	/*mName*/ "Savanna",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 85000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*568*/	{
	/*mName*/ "Bandito",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 65000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*569*/	{
	/*mName*/ "Freight Flat Trailer",
	/*mType*/ VTYPE_TRAIN,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*570*/	{
	/*mName*/ "Streak Trailer",
	/*mType*/ VTYPE_TRAIN,
	/*mPrice*/ 1000000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*571*/	{
	/*mName*/ "Kart",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 25000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*572*/	{
	/*mName*/ "Mower",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 15000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*573*/	{
	/*mName*/ "Dune",
	/*mType*/ VTYPE_MONSTER,
	/*mPrice*/ 1000000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 2
	},
/*574*/	{
	/*mName*/ "Sweeper",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 50000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*575*/	{
	/*mName*/ "Broadway",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 85000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*576*/	{
	/*mName*/ "Tornado",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 68000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*577*/	{
	/*mName*/ "AT400",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 3500000,
	/*mTrunkSpace*/ 300,
	/*mSeats*/ 2
	},
/*578*/	{
	/*mName*/ "DFT-30",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 190000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*579*/	{
	/*mName*/ "Huntley",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 250000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*580*/	{
	/*mName*/ "Stafford",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 100000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*581*/	{
	/*mName*/ "BF-400",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 60000,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*582*/	{
	/*mName*/ "Newsvan",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 125000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*583*/	{
	/*mName*/ "Tug",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 25000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*584*/	{
	/*mName*/ "Petrol Trailer",
	/*mType*/ VTYPE_TRAILER,
	/*mPrice*/ 300000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*585*/	{
	/*mName*/ "Emperor",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 50000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*586*/	{
	/*mName*/ "Wayfarer",
	/*mType*/ VTYPE_BIKE,
	/*mPrice*/ 50000,
	/*mTrunkSpace*/ 15,
	/*mSeats*/ 2
	},
/*587*/	{
	/*mName*/ "Euros",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 400000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*588*/	{
	/*mName*/ "Hotdog",
	/*mType*/ VTYPE_HEAVY,
	/*mPrice*/ 90000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*589*/	{
	/*mName*/ "Club",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 150000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*590*/	{
	/*mName*/ "Freight Box Trailer",
	/*mType*/ VTYPE_TRAIN,
	/*mPrice*/ 350000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*591*/	{
	/*mName*/ "Article Trailer 3",
	/*mType*/ VTYPE_TRAILER,
	/*mPrice*/ 200000,
	/*mTrunkSpace*/ 500,
	/*mSeats*/ 1
	},
/*592*/	{
	/*mName*/ "Andromada",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 3500000,
	/*mTrunkSpace*/ 500,
	/*mSeats*/ 2
	},
/*593*/	{
	/*mName*/ "Dodo",
	/*mType*/ VTYPE_PLANE,
	/*mPrice*/ 525000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*594*/	{
	/*mName*/ "RC Cam",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*595*/	{
	/*mName*/ "Launch",
	/*mType*/ VTYPE_SEA,
	/*mPrice*/ 725000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 1
	},
/*596*/	{
	/*mName*/ "Patrullero Premier",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 100000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*597*/	{
	/*mName*/ "Patrullero Premier",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 100000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*598*/	{
	/*mName*/ "Patrullero PFA",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 100000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*599*/	{
	/*mName*/ "Patrullero Rancher",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 135000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*600*/	{
	/*mName*/ "Picador",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 40000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*601*/	{
	/*mName*/ "S.W.A.T.",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 450000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 2
	},
/*602*/	{
	/*mName*/ "Alpha",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 350000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*603*/	{
	/*mName*/ "Phoenix",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 500000,
	/*mTrunkSpace*/ 100,
	/*mSeats*/ 2
	},
/*604*/	{
	/*mName*/ "Glendale Shit",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 22000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 4
	},
/*605*/	{
	/*mName*/ "Sadler Shit",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 22000,
	/*mTrunkSpace*/ 200,
	/*mSeats*/ 2
	},
/*606*/	{
	/*mName*/ "Baggage Trailer A",
	/*mType*/ VTYPE_TRAILER,
	/*mPrice*/ 50000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*607*/	{
	/*mName*/ "Baggage Trailer B",
	/*mType*/ VTYPE_TRAILER,
	/*mPrice*/ 50000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*608*/	{
	/*mName*/ "Tug Stairs Trailer",
	/*mType*/ VTYPE_TRAILER,
	/*mPrice*/ 50000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*609*/	{
	/*mName*/ "Boxville",
	/*mType*/ VTYPE_CAR,
	/*mPrice*/ 95000,
	/*mTrunkSpace*/ 400,
	/*mSeats*/ 4
	},
/*610*/	{
	/*mName*/ "Farm Trailer",
	/*mType*/ VTYPE_TRAILER,
	/*mPrice*/ 75000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	},
/*611*/	{
	/*mName*/ "Utility Trailer",
	/*mType*/ VTYPE_TRAILER,
	/*mPrice*/ 75000,
	/*mTrunkSpace*/ 0,
	/*mSeats*/ 1
	}
};

Veh_GetModelName(modelid)
{
	new name[32] = "";

	if(Veh_IsValidModel(modelid)) {
		strcat(name, CarModels[modelid-400][mName], sizeof(name));
	}

	return name;
}

Veh_GetName(vehicleid)
{
	new name[32] = "", modelid = GetVehicleModel(vehicleid);

	if(modelid != 0) {
		strcat(name, CarModels[modelid-400][mName], sizeof(name));
	}

	return name;
}

stock Veh_GetModelModelType(modelid) {
	return (Veh_IsValidModel(modelid)) ? (CarModels[modelid-400][mType]) : (0);
}

Veh_GetModelType(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);
	return (modelid == 0) ? (0) : (CarModels[modelid-400][mType]);
}

Veh_GetModelPrice(modelid) {
	return (Veh_IsValidModel(modelid)) ? (CarModels[modelid-400][mPrice] / 100 * ServerInfo[sVehiclePricePercent]) : (0);
}

Veh_GetPrice(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);
	return (modelid == 0) ? (0) : (CarModels[modelid-400][mPrice] / 100 * ServerInfo[sVehiclePricePercent]);
}

Veh_GetModelTrunkSpace(modelid) {
	return (Veh_IsValidModel(modelid)) ? (CarModels[modelid-400][mTrunkSpace]) : (0);
}

Veh_GetTrunkSpace(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);
	return (modelid == 0) ? (0) : CarModels[modelid-400][mTrunkSpace];
}

Veh_GetMaxSeats(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);
	return (modelid == 0) ? (0) : CarModels[modelid-400][mSeats];
}