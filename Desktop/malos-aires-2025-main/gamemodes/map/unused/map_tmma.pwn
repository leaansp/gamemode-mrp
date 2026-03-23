#if defined _map_tmma_inc
	#endinput
#endif
#define _map_tmma_inc

#include <YSI_Coding\y_hooks>

new TMTune[5][2];

hook RemoveMapsBuildings(playerid) {
	//=============================TALLER MERCURY===============================
	RemoveBuildingForPlayer(playerid, 620, 2510.5625, -1563.4766, 21.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2542.1719, -1554.0469, 21.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 616, 2528.7109, -1556.6797, 21.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 616, 2542.2188, -1525.3750, 21.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2539.8047, -1515.9531, 23.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 2522.9766, -1508.9609, 26.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 17863, 2467.4609, -1538.2500, 27.6016, 0.25);

	return true;
}

hook LoadMaps() {
	//==================================PORTONES====================================
	TMTune[0][1] = CreateObject(3037, -2716.01, 217.88, 5.48, 0.00, 0.00, 0.00);			// Wheel Arch Angels. CreateObject(3294, -2718.93, 217.42, 7.30,   0.00, 90.00, 0.00);
	TMTune[1][1] = CreateObject(989, 2644.83, -2039.06, 14.32, 0.00, 0.00, -73.08); 		// Loco Low Co. CreateObject(5340, 2644.86, -2040.67, 15.59,   0.00, 90.00, -90.00);
	TMTune[2][1] = CreateObject(971, -1935.01, 238.70, 33.69,   0.00, 0.00, 0.06); 			// Transfender SF. CreateObject(3294, -1935.80, 241.36, 37.27,   0.00, 90.00, 90.00);
	TMTune[3][1] = CreateObject(971, 1043.17, -1025.85, 33.66,   0.00, 0.00, 0.00); 		// Transfender LS. CreateObject(5779, 1041.34, -1024.51, 34.20,   0.00, 90.00, 90.00);
	TMTune[4][1] = CreateObject(971, 2387.38, 1043.45, 11.82,   0.00, 0.00, 0.00); 			// Transfender LV. CreateObject(3294, 2386.67, 1046.04, 13.31,   0.00, 90.00, 90.00);
	
	// ======= Piso base =======
	Textura = CreateDynamicObject(1675, 2501.56348, -1521.54846, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2501.54346, -1535.91748, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2501.56348, -1550.27417, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2516.35791, -1550.27344, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2516.35791, -1535.91760, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2534.65063, -1550.27686, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2531.16479, -1535.91760, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2530.00000, 9988.00000, -1564.00000,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2534.64966, -1564.60144, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2516.35791, -1564.63354, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2501.54858, -1564.64417, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2501.54858, -1578.97253, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2516.35791, -1578.98584, 19.84390,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 5, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(19454, 2525.51318, -1566.98743, 22.92280,   0.00000, 90.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 0, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(19454, 2525.51318, -1557.36243, 22.92280,   0.00000, 90.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 0, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(19454, 2540.31689, -1538.29065, 22.92280,   0.00000, 90.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 0, 4122, "civic06_lan", "tarmacplain_bank", -1);
	Textura = CreateDynamicObject(1675, 2520.06323, -1516.73950, 19.82690,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
	SetDynamicObjectMaterial(Textura, 0, 4122, "civic06_lan", "tarmacplain_bank", -1);


	// ======= Cordones =======
	Textura = CreateDynamicObject(19430, 2504.92578, -1585.36182, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2508.42090, -1585.36182, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2511.91650, -1585.36182, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2515.40894, -1585.36182, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2518.89966, -1585.36182, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2522.01758, -1585.36182, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2522.96680, -1582.82483, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2522.96680, -1579.33862, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2522.96680, -1575.85352, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2522.96655, -1572.35156, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2525.51685, -1570.99756, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2522.96655, -1571.94788, 23.07850,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2529.00977, -1570.99756, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2532.50391, -1570.99756, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2536.00269, -1570.99756, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2539.50000, -1570.99756, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2540.36475, -1571.01697, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1568.47095, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1564.98206, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1561.50537, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1558.02576, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1554.54993, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1551.06226, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1547.57275, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1544.08191, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1540.58606, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1537.13074, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2541.28882, -1535.18994, 23.07650,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2540.21509, -1534.25342, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2537.80518, -1533.30896, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2537.80518, -1530.54138, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2535.26025, -1529.64575, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2531.77856, -1529.64575, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2528.31177, -1529.64575, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2524.84033, -1529.64575, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2521.35913, -1529.64575, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2517.90820, -1529.64575, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2514.45776, -1529.64575, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2510.99634, -1529.64575, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2508.35718, -1528.69751, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2510.69629, -1529.64575, 23.07050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2508.35718, -1525.20081, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2508.35718, -1521.71582, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2508.35718, -1518.24097, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2508.35718, -1516.09058, 23.07650,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.63086, -1539.89185, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.63086, -1536.44482, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.63086, -1532.99768, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.63086, -1529.53064, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.63086, -1526.10315, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.63086, -1522.65149, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.63086, -1519.19482, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.63086, -1516.09521, 23.07650,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2531.29663, -1558.15039, 23.08050,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2529.01636, -1558.15039, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2523.55469, -1558.15039, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2520.07910, -1558.15039, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2516.59497, -1558.15039, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2513.11499, -1558.15002, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2509.62842, -1558.15039, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2506.15259, -1558.15039, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2502.66553, -1558.15039, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2499.19531, -1558.15039, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2498.00049, -1559.08728, 23.07650,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2498.00049, -1562.57227, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.05347, -1565.10461, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2495.93018, -1565.09607, 23.07650,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2494.96533, -1567.64844, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2494.96533, -1567.64844, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2494.96533, -1571.10657, 23.08050,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2494.96533, -1572.56702, 23.07850,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2497.44678, -1573.57642, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2500.90137, -1573.57642, 23.07850,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);
	Textura = CreateDynamicObject(19430, 2501.40186, -1573.57642, 23.07450,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17639, "lae2roads", "Newpavement", -1);


	// ======= Paredes =======
	Textura = CreateDynamicObject(19449, 2498.98291, -1586.23828, 23.72960,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2508.60278, -1586.23828, 23.72960,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2518.22070, -1586.23828, 23.72960,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2523.71240, -1580.75574, 20.24030,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2523.70752, -1577.34546, 20.24030,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2523.70752, -1577.34546, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2529.16211, -1571.86157, 20.24030,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2537.24829, -1571.86365, 20.24030,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2542.14331, -1567.12341, 20.24030,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2542.15454, -1557.51074, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2542.15454, -1547.88257, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2542.15454, -1538.25781, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2540.46899, -1533.40442, 20.59540,   90.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2538.65088, -1531.06226, 20.59540,   90.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2533.17090, -1528.78430, 23.72960,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2523.53516, -1528.78430, 23.72960,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2513.91260, -1528.78430, 23.72960,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2494.14722, -1569.16821, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2494.14722, -1578.77881, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2494.14526, -1581.53943, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2509.07129, -1523.37463, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2509.07324, -1519.50854, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2542.15454, -1567.14001, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2537.24829, -1571.86365, 23.72960,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2529.16211, -1571.86157, 23.72960,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(19449, 2523.71240, -1580.75574, 23.72960,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 17862, "compomark_lae2", "Upt_Conc floorClean", -1);
	Textura = CreateDynamicObject(1506, 2503.11255, -1580.87915, 26.86350,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 1506, "cuntwbt", "des_greyslats", -1);
	Textura = CreateDynamicObject(1506, 2503.11255, -1578.39905, 26.86350,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 1506, "cuntwbt", "des_greyslats", -1);

	// ======= Carteles de cada box =======
	Textura = CreateDynamicObject(2643, 2501.42944, -1556.95068, 26.78310,   0.00000, 0.00000, 180.00000);
	SetDynamicObjectMaterialText(Textura, 0, "BOX 1", 60, "Impact", 40, 1, -16777216, -8092540, 1);
	Textura = CreateDynamicObject(2643, 2510.42944, -1556.95068, 26.78310,   0.00000, 0.00000, 180.00000);
	SetDynamicObjectMaterialText(Textura, 0, "BOX 2", 60, "Impact", 40, 1, -16777216, -8092540, 1);
	Textura = CreateDynamicObject(2643, 2519.42944, -1556.95068, 26.78310,   0.00000, 0.00000, 180.00000);
	SetDynamicObjectMaterialText(Textura, 0, "BOX 3", 60, "Impact", 40, 1, -16777216, -8092540, 1);
	Textura = CreateDynamicObject(2643, 2528.82959, -1556.95068, 26.78310,   0.00000, 0.00000, 180.00000);
	SetDynamicObjectMaterialText(Textura, 0, "BOX 4", 60, "Impact", 40, 1, -16777216, -8092540, 1);

	// ======= Objetos dinámicos del taller =======
	CreateDynamicObject(19430, 2507.22388, -1555.71155, 28.92350,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(9131, 2524.00806, -1572.13354, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2524.00806, -1572.13354, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2541.87524, -1533.61804, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2538.95728, -1533.15601, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2541.87524, -1533.61804, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2538.95728, -1533.15601, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2538.36792, -1529.07910, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2538.36792, -1529.07910, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2509.32715, -1528.51184, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2509.32715, -1528.51184, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2509.27368, -1514.69165, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2509.27368, -1514.69165, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2523.42480, -1585.95862, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2523.42480, -1585.95862, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2541.89600, -1571.61646, 19.81400,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2541.89600, -1571.61646, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2541.89600, -1571.61646, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2508.52368, -1514.69165, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2507.77368, -1514.69165, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2498.17358, -1514.69165, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2497.42358, -1514.69165, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2508.52368, -1514.69165, 24.33630,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2507.77393, -1514.69165, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2498.17358, -1514.69165, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9131, 2497.42358, -1514.69165, 22.07350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19905, 2515.13574, -1549.59399, 22.82150,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19454, 2525.51318, -1566.98743, 22.92280,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 2525.51318, -1557.36243, 22.92280,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 2540.31689, -1538.29065, 22.92280,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(17039, 2498.68701, -1580.23352, 21.30590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2400, 2498.11890, -1585.77832, 23.11160,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1098, 2501.95728, -1585.65430, 25.54100,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1097, 2500.73633, -1585.65430, 25.54100,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1096, 2499.59009, -1585.65430, 25.54100,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1085, 2498.24976, -1585.65430, 25.54100,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1084, 2497.03442, -1585.65430, 25.54100,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1083, 2498.24976, -1585.63428, 24.49680,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1082, 2495.78418, -1585.65430, 25.54100,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1081, 2500.73633, -1585.63428, 24.49680,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1080, 2499.59009, -1585.63428, 23.46080,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1079, 2499.59009, -1585.63428, 24.49680,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1078, 2500.73633, -1585.63428, 23.46080,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1077, 2501.95752, -1585.63428, 24.49680,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2400, 2501.85083, -1585.78296, 23.11156,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1076, 2497.03442, -1585.65430, 24.49680,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1075, 2495.78418, -1585.63428, 24.49680,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1074, 2498.24976, -1585.63428, 23.46080,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1073, 2497.03442, -1585.63428, 23.46080,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3761, 2495.19971, -1579.99792, 24.95590,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1431, 2494.79126, -1584.27014, 23.55000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2475, 2494.43188, -1584.64465, 24.25590,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2477, 2494.57397, -1584.40149, 24.95990,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2478, 2495.59009, -1580.86133, 24.85490,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2502, 2494.45166, -1575.88098, 22.93840,   0.00000, 0.00000, 89.90000);
	CreateDynamicObject(936, 2502.38647, -1582.07251, 23.41220,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(937, 2502.38647, -1583.97046, 23.41220,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19627, 2494.71265, -1575.70337, 23.14670,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2504, 2494.61768, -1575.31970, 24.41626,   0.00000, 0.00000, 89.90000);
	CreateDynamicObject(2503, 2494.61768, -1576.09180, 24.41630,   0.00000, 0.00000, 89.90000);
	CreateDynamicObject(2465, 2495.28149, -1577.87427, 24.00870,   0.00000, 0.00000, 84.00000);
	CreateDynamicObject(2480, 2495.61230, -1580.66541, 23.61250,   0.00000, 0.00000, 84.00000);
	CreateDynamicObject(2041, 2494.65820, -1575.78259, 24.17260,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2041, 2494.65820, -1575.59912, 24.17260,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2358, 2495.16357, -1579.13867, 23.15320,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(964, 2502.27539, -1575.30322, 23.01050,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(930, 2502.25488, -1575.04712, 24.39830,   0.00000, 0.00000, 359.38480);
	CreateDynamicObject(19921, 2502.32471, -1584.32117, 23.97820,   0.00000, 0.00000, 225.00000);
	CreateDynamicObject(19815, 2502.98560, -1583.12366, 24.89040,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19814, 2502.93481, -1582.20923, 24.15710,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19809, 2502.69556, -1581.50024, 23.93210,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19621, 2502.09595, -1581.25464, 23.96910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19627, 2502.45435, -1581.37292, 23.88530,   0.00000, 0.00000, 145.00000);
	CreateDynamicObject(19917, 2500.03931, -1575.24097, 23.42070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19997, 2499.98462, -1575.21997, 23.79410,   0.00000, 180.00000, 90.00000);
	CreateDynamicObject(18633, 2499.43848, -1575.34631, 23.77280,   0.00000, 270.00000, 0.00000);
	CreateDynamicObject(18633, 2499.42871, -1575.13147, 23.77280,   0.00000, 90.00000, 180.00000);
	CreateDynamicObject(18644, 2502.22412, -1581.54309, 23.88540,   0.00000, 90.00000, 180.00000);
	CreateDynamicObject(18635, 2502.09497, -1581.73950, 23.87040,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(18641, 2501.98755, -1584.54419, 23.91660,   0.00000, 90.00000, 234.00000);
	CreateDynamicObject(18634, 2502.39722, -1584.01074, 23.90070,   0.00000, 90.00000, 245.00000);
	CreateDynamicObject(19631, 2502.09448, -1583.81104, 23.54050,   356.00000, 90.00000, 0.00000);
	CreateDynamicObject(19622, 2502.59253, -1585.79138, 23.71550,   10.00000, 0.00000, 0.00000);
	CreateDynamicObject(2690, 2498.25806, -1574.70007, 24.61279,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11738, 2501.99268, -1584.30115, 23.22270,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(11738, 2502.04199, -1583.56165, 23.22270,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(11706, 2497.09814, -1574.91455, 23.00960,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1428, 2496.21411, -1582.29834, 24.39530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3630, 2499.01221, -1582.74731, 19.43470,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(2468, 2495.00122, -1578.17322, 24.54580,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2468, 2495.29663, -1579.23669, 24.54580,   0.00000, 0.00000, 62.00000);
	CreateDynamicObject(2478, 2495.37109, -1579.28467, 25.63400,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(930, 2495.30249, -1582.17529, 26.45270,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(2465, 2494.82178, -1577.95691, 24.00870,   0.00000, 0.00000, 84.00000);
	CreateDynamicObject(2480, 2495.21411, -1580.70862, 23.61250,   0.00000, 0.00000, 84.00000);
	CreateDynamicObject(2480, 2494.76978, -1580.71887, 23.61250,   0.00000, 0.00000, 84.00000);
	CreateDynamicObject(2358, 2495.43848, -1582.40210, 23.15320,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(2358, 2494.91309, -1582.19226, 23.15320,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(3632, 2496.25928, -1575.05786, 23.48500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2358, 2494.53271, -1584.34326, 25.86140,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2478, 2494.76514, -1579.33594, 26.44608,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2478, 2494.76514, -1579.33594, 25.63400,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1428, 2505.01001, -1583.02771, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2508.09082, -1583.02771, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2511.16992, -1583.02771, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2517.33008, -1583.02771, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2514.25000, -1583.02771, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2520.40991, -1583.02771, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2505.01001, -1581.49475, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2508.09082, -1581.49475, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2511.16992, -1581.49475, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2514.25000, -1581.49475, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2517.33008, -1581.49475, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(1428, 2520.40991, -1581.49475, 22.76180,   0.00000, 90.00000, 75.00000);
	CreateDynamicObject(3788, 2521.28418, -1582.26855, 23.52470,   0.00000, 0.00000, 81.00000);
	CreateDynamicObject(1458, 2504.12158, -1583.57825, 23.13830,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1684, 2503.78418, -1553.62549, 33.45360,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1684, 2503.78418, -1553.62549, 30.48100,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1684, 2503.78418, -1549.44348, 30.48100,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1684, 2503.78418, -1549.44348, 33.45360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1684, 2503.77295, -1553.60889, 36.40560,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1684, 2503.78418, -1549.44348, 36.40560,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(12987, 2510.75659, -1557.97485, 26.48310,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(970, 2506.39453, -1555.39380, 29.45830,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2508.01172, -1555.32227, 29.45830,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19449, 2504.02612, -1554.04077, 28.85710,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19449, 2504.02612, -1550.54785, 28.85710,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19449, 2504.01196, -1549.13721, 28.85710,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19449, 2503.51611, -1549.13794, 28.85710,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19449, 2503.51611, -1549.13794, 28.66210,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19449, 2504.02612, -1549.12305, 28.66210,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19449, 2504.02612, -1550.54785, 28.66210,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19449, 2504.02612, -1554.04077, 28.66210,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19430, 2507.22388, -1557.34900, 27.09250,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19448, 2494.27051, -1581.03625, 24.44360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1635, 2509.28955, -1551.54529, 30.38310,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1617, 2508.75488, -1549.29614, 36.93770,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(929, 2520.85107, -1552.89380, 29.57260,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(929, 2522.36914, -1552.89380, 29.57260,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2649, 2510.40063, -1548.23865, 29.07840,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(914, 2511.80786, -1548.18982, 28.55000,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(19815, 2519.42065, -1556.95215, 24.89040,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19815, 2510.55469, -1556.95215, 24.89040,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19815, 2501.53271, -1556.95215, 24.89040,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19815, 2529.83081, -1556.95215, 24.89040,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(936, 2528.80420, -1556.35901, 23.44010,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(937, 2530.73120, -1556.35901, 23.44010,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(936, 2518.52002, -1556.35901, 23.44010,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(937, 2520.44824, -1556.35901, 23.44010,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(936, 2509.58008, -1556.35901, 23.44010,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(937, 2511.50806, -1556.35901, 23.44010,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(936, 2500.49609, -1556.35901, 23.44010,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(937, 2502.42407, -1556.35901, 23.44010,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19814, 2520.62427, -1556.93359, 24.18050,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19814, 2511.60620, -1556.93359, 24.18050,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19814, 2502.58838, -1556.93359, 24.18050,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19899, 2532.01880, -1545.25635, 23.01690,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(11709, 2524.38647, -1556.61157, 23.57700,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(11706, 2521.77808, -1556.44263, 23.01880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11706, 2532.06812, -1556.44263, 23.01880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11706, 2512.79712, -1556.44263, 23.01880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11706, 2503.70508, -1556.44263, 23.01880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(920, 2532.19312, -1554.56213, 23.37650,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(3632, 2497.89453, -1544.89465, 23.49750,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(1636, 2497.86255, -1545.16553, 23.94100,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(1636, 2497.90308, -1544.62695, 23.52800,   269.00000, 0.00000, 0.00000);
	CreateDynamicObject(927, 2497.56274, -1543.25708, 24.61290,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18633, 2497.72192, -1544.46240, 23.66650,   0.00000, 91.00000, 0.00000);
	CreateDynamicObject(18633, 2498.16431, -1545.22266, 23.13550,   45.00000, 0.00000, 90.00000);
	CreateDynamicObject(18633, 2498.16431, -1544.57373, 23.13550,   45.00000, 0.00000, 90.00000);
	CreateDynamicObject(18633, 2497.57422, -1544.57373, 23.13550,   45.00000, 0.00000, 269.00000);
	CreateDynamicObject(18633, 2497.57422, -1545.22266, 23.13550,   45.00000, 0.00000, 269.00000);
	CreateDynamicObject(11709, 2516.20239, -1556.61157, 23.57700,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(11709, 2506.90234, -1556.61157, 23.57700,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2475, 2514.54370, -1556.88452, 24.14640,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2475, 2523.09985, -1556.88452, 24.14640,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2475, 2505.24365, -1556.88452, 24.14640,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19621, 2531.58618, -1555.96179, 24.00810,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19621, 2521.21509, -1555.96179, 24.00620,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19621, 2512.29810, -1555.96179, 24.00620,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19621, 2503.24512, -1555.96179, 24.00810,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(18635, 2531.24194, -1555.97583, 23.88710,   90.00000, 90.00000, 270.00000);
	CreateDynamicObject(18644, 2531.19702, -1556.15576, 23.93210,   90.00000, 90.00000, 270.00000);
	CreateDynamicObject(19627, 2531.08838, -1555.99780, 23.91710,   180.00000, 0.00000, 270.00000);
	CreateDynamicObject(19631, 2531.24097, -1556.43628, 23.92920,   358.00000, 90.00000, 45.00000);
	CreateDynamicObject(19921, 2528.39307, -1556.28162, 24.00620,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19809, 2531.01953, -1556.72205, 23.95920,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11738, 2531.19141, -1556.09937, 23.20280,   0.00000, 0.00000, 179.00000);
	CreateDynamicObject(19622, 2527.55762, -1556.83472, 23.70700,   350.00000, 0.00000, 180.00000);
	CreateDynamicObject(19921, 2518.14307, -1556.28162, 24.00620,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19809, 2520.51953, -1556.72205, 23.95920,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19631, 2520.89111, -1556.43628, 23.92920,   358.00000, 90.00000, 45.00000);
	CreateDynamicObject(18635, 2520.89185, -1555.97583, 23.88710,   90.00000, 90.00000, 270.00000);
	CreateDynamicObject(18644, 2520.84692, -1556.15576, 23.93210,   90.00000, 90.00000, 270.00000);
	CreateDynamicObject(19627, 2520.73828, -1555.99780, 23.91710,   180.00000, 0.00000, 270.00000);
	CreateDynamicObject(11738, 2520.69141, -1556.09937, 23.20280,   0.00000, 0.00000, 179.00000);
	CreateDynamicObject(19921, 2509.24316, -1556.28162, 24.00620,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19809, 2511.56958, -1556.72205, 23.95920,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19631, 2511.99097, -1556.43628, 23.92920,   358.00000, 90.00000, 45.00000);
	CreateDynamicObject(18635, 2511.99194, -1555.97583, 23.88710,   90.00000, 90.00000, 270.00000);
	CreateDynamicObject(18644, 2511.94702, -1556.15576, 23.93210,   90.00000, 90.00000, 270.00000);
	CreateDynamicObject(19627, 2511.83838, -1555.99780, 23.91710,   180.00000, 0.00000, 270.00000);
	CreateDynamicObject(11738, 2511.79321, -1556.09937, 23.20280,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19921, 2500.14307, -1556.28162, 24.00620,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19809, 2502.61938, -1556.72205, 23.95920,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19631, 2502.94092, -1556.43628, 23.92920,   358.00000, 90.00000, 45.00000);
	CreateDynamicObject(18635, 2502.94189, -1555.97583, 23.88710,   90.00000, 90.00000, 270.00000);
	CreateDynamicObject(18644, 2502.89697, -1556.15576, 23.93210,   90.00000, 90.00000, 270.00000);
	CreateDynamicObject(19627, 2502.78833, -1555.99780, 23.91710,   180.00000, 0.00000, 270.00000);
	CreateDynamicObject(11738, 2502.76318, -1556.09937, 23.20280,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19814, 2530.77441, -1556.93359, 24.18050,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19622, 2517.26367, -1556.83472, 23.70700,   350.00000, 0.00000, 180.00000);
	CreateDynamicObject(19622, 2508.26367, -1556.83472, 23.70700,   350.00000, 0.00000, 180.00000);
	CreateDynamicObject(19622, 2499.05762, -1556.83472, 23.70700,   350.00000, 0.00000, 180.00000);
	CreateDynamicObject(18633, 2528.09863, -1556.98804, 24.85820,   270.00000, 90.00000, 270.00000);
	CreateDynamicObject(18633, 2517.69873, -1556.98804, 24.85820,   270.00000, 90.00000, 270.00000);
	CreateDynamicObject(18633, 2508.79858, -1556.98804, 24.85820,   270.00000, 90.00000, 270.00000);
	CreateDynamicObject(18633, 2499.79858, -1556.98804, 24.85820,   270.00000, 90.00000, 270.00000);
	CreateDynamicObject(18634, 2511.33447, -1556.09094, 23.54820,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(18634, 2502.33447, -1556.09094, 23.54820,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(18634, 2520.33447, -1556.09094, 23.54820,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(18634, 2530.83447, -1556.09094, 23.54820,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(11713, 2514.99634, -1541.99207, 24.26410,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(11713, 2498.25806, -1574.60205, 24.61280,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(11729, 2515.91772, -1542.23462, 22.88650,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11713, 2505.99634, -1541.99207, 24.26410,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(11729, 2506.91772, -1542.23462, 22.88650,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11729, 2524.91772, -1542.23462, 22.88650,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11713, 2523.99634, -1541.99207, 24.26410,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1506, 2503.11255, -1580.87915, 26.86350,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(1506, 2503.11255, -1578.39905, 26.86350,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19425, 2505.92896, -1515.52600, 23.01290,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19425, 2502.62891, -1515.52600, 23.01290,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19425, 2499.32910, -1515.52600, 23.01290,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1428, 2497.31543, -1569.38647, 22.76180,   0.00000, 90.00000, 165.00000);
	CreateDynamicObject(1428, 2499.94336, -1569.38647, 22.76180,   0.00000, 90.00000, 165.00000);
	CreateDynamicObject(1428, 2500.14453, -1562.32629, 22.76180,   0.00000, 90.00000, 165.00000);
	CreateDynamicObject(1428, 2502.33447, -1562.32629, 22.76180,   0.00000, 90.00000, 165.00000);
	CreateDynamicObject(1428, 2502.33447, -1565.61133, 22.76180,   0.00000, 90.00000, 165.00000);
	CreateDynamicObject(1428, 2500.14453, -1565.61133, 22.76180,   0.00000, 90.00000, 165.00000);
	CreateDynamicObject(19948, 2537.32813, -1534.35181, 22.68170,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19810, 2537.31030, -1534.35071, 25.01140,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19983, 2498.30005, -1525.55872, 22.68170,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(983, 2512.74951, -1517.85840, 23.47390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 2515.92163, -1523.85071, 23.47390,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 2522.16870, -1523.85071, 23.47390,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 2524.08350, -1523.85071, 23.47390,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 2512.74121, -1520.67957, 23.47390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 2527.33325, -1517.85840, 23.47390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 2527.33325, -1520.67957, 23.47390,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2643, 2501.42944, -1556.95068, 26.78310,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2643, 2510.42944, -1556.95068, 26.78310,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2643, 2519.42944, -1556.95068, 26.78310,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2643, 2528.82959, -1556.95068, 26.78310,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1650, 2523.29395, -1556.78259, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2523.29395, -1556.57263, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2522.94385, -1556.57263, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2522.94385, -1556.78259, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19809, 2522.46289, -1556.65662, 24.32920,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19809, 2513.96045, -1556.67651, 24.32920,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1650, 2514.44385, -1556.57263, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2514.44385, -1556.78259, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2514.79395, -1556.57263, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2514.79395, -1556.78259, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19809, 2504.62036, -1556.67651, 24.32920,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1650, 2505.10376, -1556.57385, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2505.10376, -1556.78259, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2505.47388, -1556.57263, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1650, 2505.47388, -1556.78259, 24.58520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19816, 2504.62036, -1556.67651, 25.20720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19816, 2505.02051, -1556.67651, 25.20720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19816, 2505.42041, -1556.67651, 25.20720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19816, 2513.82031, -1556.67651, 25.20720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19816, 2514.32031, -1556.67651, 25.20720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19816, 2514.82031, -1556.67651, 25.20720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19816, 2522.32031, -1556.67651, 25.20720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19816, 2522.82031, -1556.67651, 25.20720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19816, 2523.32031, -1556.67651, 25.20720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(927, 2532.50537, -1552.42676, 24.36290,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19613, 2532.24365, -1551.13733, 22.98450,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19613, 2531.64380, -1551.13733, 22.98450,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19812, 2531.67920, -1551.14270, 23.29680,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19614, 2532.30371, -1551.13733, 23.66450,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19614, 2532.30371, -1551.13733, 24.22450,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19614, 2531.54297, -1551.13196, 24.64450,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(19615, 2531.51001, -1551.69617, 23.44450,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19586, 2531.61035, -1550.93579, 23.26450,   19.00000, 0.00000, 270.00000);
	CreateDynamicObject(19586, 2531.61035, -1551.13574, 23.26450,   19.00000, 0.00000, 270.00000);
	CreateDynamicObject(19586, 2531.61035, -1551.33582, 23.26450,   19.00000, 0.00000, 270.00000);
	CreateDynamicObject(19626, 2532.23706, -1551.49756, 23.38680,   180.00000, 90.00000, 45.00000);
	CreateDynamicObject(18634, 2531.24292, -1551.59546, 23.22680,   105.00000, 0.00000, 90.00000);
	CreateDynamicObject(1075, 2531.96118, -1553.67395, 23.43480,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1075, 2531.96118, -1553.37402, 23.43480,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1075, 2531.96118, -1553.07397, 23.43480,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1075, 2531.96118, -1552.77405, 23.43480,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1075, 2531.96118, -1552.47400, 23.43480,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18634, 2531.63599, -1551.35388, 24.26550,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(19809, 2532.24780, -1551.11450, 24.86920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2507.73633, -1516.36938, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2507.73633, -1528.36938, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2509.73633, -1530.25000, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2521.73633, -1530.25000, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2537.18628, -1530.25000, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2537.18628, -1534.80005, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2540.68628, -1534.80005, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2540.68628, -1546.80005, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2540.68628, -1558.80005, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2540.68628, -1570.42004, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2524.68628, -1570.42004, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2537.18628, -1534.80005, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2522.35083, -1572.69348, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2522.35083, -1584.78345, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2514.20068, -1584.78345, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2505.00073, -1584.78345, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2527.44312, -1558.79456, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2525.03101, -1558.79456, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2513.03101, -1558.79456, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2532.84302, -1558.79456, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2498.53101, -1558.79456, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2498.53101, -1565.69458, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2495.53101, -1565.69458, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2495.53101, -1572.99463, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 2502.93091, -1572.99463, 23.66250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3281, 2506.05070, -1550.79187, 23.83180,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3281, 2506.04520, -1547.20178, 23.83180,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3281, 2515.04950, -1550.79187, 23.83180,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3281, 2515.04390, -1547.20178, 23.83180,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3281, 2524.02148, -1550.79187, 23.83180,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3281, 2524.01611, -1547.20178, 23.83180,   0.00000, 0.00000, 90.00000);

	return true;
}

hook OnGameModeInitEnded() {
	new gateid;

	/* Reja de entrada */
	gateid = Gate_Create(969,
				2498.6735, -1514.2984, 23.0129, 0.0000, 0.0000, 0.0000,
				2507.5136, -1514.2984, 23.0129, 0.0000, 0.0000, 0.0000,
				.worldid = -1, .speed = 2.0, .type = GATE_TYPE_BUSINESS, .extraid = 84, .autoCloseTime = 5000);

	Gate_SetOnFootFrontDetection(gateid, 2498.2397, -1514.3092, 24.4787, 0.0000, 0.0000, 0.0000, .labelText = "Portón");
	Gate_SetOnFootBackDetection(gateid, 2498.2397, -1515.0692, 24.4787, 0.0000, 0.0000, 180.0000, .labelText = "Portón");
	Gate_SetVehicleDetection(gateid, 2502.8700, -1514.5000, 24.0000, .size = 8.0);

	/* Box 1 */
	gateid = Gate_Create(19906,
				2501.5222, -1541.5526, 26.2443, 0.0000, 0.0000, 0.0000,
				2501.5222, -1545.0025, 26.4569, 85.0000, 0.0000, 0.0000,
				.worldid = -1, .speed = 1.0, .type = GATE_TYPE_BUSINESS, .extraid = 84, .autoCloseTime = 0);

	Gate_SetOnFootFrontDetection(gateid, 2504.9409, -1541.9538, 24.4787, 0.0000, 0.0000, 180.0000, .labelText = "Portón");

	/* Box 2 */
	gateid = Gate_Create(19906,
				2510.5222, -1541.5526, 26.2443, 0.0000, 0.0000, 0.0000,
				2510.5222, -1545.0025, 26.4569, 85.00000, 0.000, 0.0000,
				.worldid = -1, .speed = 1.0, .type = GATE_TYPE_BUSINESS, .extraid = 84, .autoCloseTime = 0);

	Gate_SetOnFootFrontDetection(gateid, 2513.9409, -1541.9538, 24.4787, 0.0000, 0.0000, 180.0000, .labelText = "Portón");

	/* Box 3 */
	gateid = Gate_Create(19906,
				2519.5222, -1541.5526, 26.2443, 0.0000, 0.0000, 0.0000,
				2519.5222, -1545.0025, 26.4569, 85.0000, 0.0000, 0.0000,
				.worldid = -1, .speed = 1.0, .type = GATE_TYPE_BUSINESS, .extraid = 84, .autoCloseTime = 0);

	Gate_SetOnFootFrontDetection(gateid, 2522.9409, -1541.9538, 24.4787, 0.0000, 0.0000, 180.0000, .labelText = "Portón");

	/* Box 4 */
	gateid = Gate_Create(19906,
				2528.5222, -1541.5526, 26.2443, 0.0000, 0.0000, 0.0000,
				2528.5222, -1545.0025, 26.4569, 85.0000, 0.0000, 0.0000,
				.worldid = -1, .speed = 1.0, .type = GATE_TYPE_BUSINESS, .extraid = 84, .autoCloseTime = 0);

	Gate_SetOnFootFrontDetection(gateid, 2531.9409, -1541.9538, 24.4787, 0.0000, 0.0000, 180.0000, .labelText = "Portón");

	/* Almacén de repuestos */
	gateid = Gate_Create(19863,
				2503.0852, -1578.6500, 25.4283, 0.0000, 0.0000, 90.0000,
				2500.5332, -1578.6500, 25.6603, -85.0000, 0.0000, 90.0000,
				.worldid = -1, .speed = 1.0, .type = GATE_TYPE_BUSINESS, .extraid = 84, .autoCloseTime = 0);

	Gate_SetOnFootFrontDetection(gateid, 2503.1777, -1576.1075, 24.4615, 0.0000, 0.0000, 270.0000, .labelText = "Portón");
	Gate_SetOnFootBackDetection(gateid, 2502.9763, -1581.0183, 24.4615, 0.0000, 0.0000, 90.0000, .labelText = "Portón");

	return true;
}