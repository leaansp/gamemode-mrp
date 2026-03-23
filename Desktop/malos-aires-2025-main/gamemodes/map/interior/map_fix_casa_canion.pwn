#if defined _map_fix_casa_canion_inc
	#endinput
#endif
#define _map_fix_casa_canion_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {
	//===========================FIX CASA CON CAÑON=============================
	RemoveBuildingForPlayer(playerid, 2046, 2806.2266, -1174.5703, 1026.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 2049, 2805.2109, -1173.4922, 1026.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 2060, 2810.3047, -1172.8516, 1025.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 2060, 2810.3047, -1172.8516, 1025.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 2060, 2810.3047, -1172.8516, 1024.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 2060, 2810.3047, -1172.8516, 1024.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 2060, 2811.6016, -1172.8516, 1024.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 2060, 2811.6016, -1172.8516, 1024.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 2060, 2811.6016, -1172.8516, 1025.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 2060, 2811.6016, -1172.8516, 1025.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 2048, 2805.2109, -1172.0547, 1026.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 2055, 2805.1953, -1170.5391, 1026.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 2060, 2810.0234, -1171.2266, 1024.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 2064, 2810.8359, -1171.8984, 1025.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 2068, 2809.2031, -1169.3672, 1027.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 1821, 2810.5938, -1167.6172, 1024.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 2053, 2810.6094, -1167.5781, 1024.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 2058, 2809.6406, -1165.3359, 1024.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 2297, 2811.0234, -1165.0625, 1024.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 2050, 2813.1250, -1173.3359, 1026.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 2051, 2813.1250, -1171.2891, 1026.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 2121, 2813.9531, -1172.4609, 1025.0859, 0.25);
	RemoveBuildingForPlayer(playerid, 2121, 2815.3828, -1172.4844, 1025.0859, 0.25);
	RemoveBuildingForPlayer(playerid, 2156, 2813.6484, -1167.0000, 1024.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 2047, 2817.3125, -1170.9688, 1031.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2160, 2815.8984, -1164.9063, 1024.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 2159, 2817.2656, -1164.9063, 1024.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 2157, 2818.7109, -1173.9531, 1024.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 2157, 2818.6406, -1164.9063, 1024.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 2046, 2819.4453, -1174.0000, 1026.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 2157, 2820.6328, -1167.3125, 1024.5703, 0.25);

	return true;
}

hook LoadMaps() {
	//==============================FIX CASA CON CAÑON==========================
	CreateDynamicObject(2297, 2811.60791, -1165.25024, 1024.55701,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1742, 2813.24048, -1171.31360, 1024.55078,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1764, 2812.90967, -1172.91687, 1024.54932,   0.00000, 0.00000, 194.51991);
	CreateDynamicObject(1765, 2809.82007, -1173.25269, 1024.54285,   0.00000, 0.00000, 131.03999);
	CreateDynamicObject(2108, 2812.87329, -1173.74500, 1024.57007,   0.00000, 0.00000, 22.26000);
	CreateDynamicObject(1817, 2810.61694, -1171.90332, 1024.54968,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1999, 2805.73267, -1171.51758, 1024.55103,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1671, 2806.43140, -1170.54578, 1025.02014,   0.00000, 0.00000, -90.71997);
	CreateDynamicObject(2147, 2820.33423, -1165.17395, 1024.56140,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2135, 2815.33936, -1165.16589, 1024.54016,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2136, 2816.32007, -1165.16614, 1024.54016,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2139, 2818.31006, -1165.18298, 1024.54016,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2140, 2814.34497, -1165.16589, 1024.54016,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2138, 2819.31006, -1165.17700, 1024.55127,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2120, 2814.02246, -1172.14917, 1025.14844,   0.00000, 0.00000, 124.62003);
	CreateDynamicObject(2120, 2815.39160, -1172.26428, 1025.14844,   0.00000, 0.00000, 76.02004);
	CreateDynamicObject(1737, 2818.27173, -1169.42517, 1024.54919,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2120, 2818.36743, -1168.64124, 1025.14844,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2120, 2819.16748, -1168.64124, 1025.14844,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2120, 2819.16748, -1170.26123, 1025.14844,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2120, 2818.36743, -1170.26123, 1025.14844,   0.00000, 0.00000, -90.00000);
	
	return true;
}