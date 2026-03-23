#if defined _map_cruce_piedras_avenida_inc
	#endinput
#endif
#define _map_cruce_piedras_avenida_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {
	//======================CRUCE CON PIEDRAS DE AVENIDA========================
	RemoveBuildingForPlayer(playerid, 647, 1407.4375, -1436.5859, 14.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1405.7656, -1424.2500, 13.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1406.6797, -1405.3984, 14.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1411.3672, -1437.7656, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1409.7969, -1429.2734, 14.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1411.6250, -1430.1328, 13.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1408.5313, -1425.3984, 14.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1409.8672, -1418.1328, 14.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1411.5703, -1416.5391, 12.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1409.1875, -1410.3281, 14.6250, 0.25);

	return true;
}

hook LoadMaps() {
	//========================CRUCE CON PIEDRAS AVENIDA=============================
	CreateDynamicObject(673, 1402.99695, -1403.38782, 12.90625,   356.85840, 0.00000, 3.14159);
	CreateDynamicObject(880, 1411.95654, -1406.06958, 14.50760,   0.00000, 0.00000, 123.24000);
	CreateDynamicObject(880, 1406.05823, -1410.46790, 14.50760,   0.00000, 0.00000, -32.46000);
	CreateDynamicObject(880, 1411.74634, -1419.67065, 14.50760,   0.00000, 0.00000, 87.00000);
	CreateDynamicObject(880, 1406.70203, -1419.81067, 14.50760,   0.00000, 0.00000, -94.80000);
	CreateDynamicObject(880, 1409.48633, -1427.46130, 14.50760,   0.00000, 0.00000, -0.72000);
	CreateDynamicObject(880, 1405.67639, -1428.82825, 14.50760,   0.00000, 0.00000, -86.94000);
	CreateDynamicObject(880, 1409.01794, -1436.68518, 14.50760,   0.00000, 0.00000, 5.16000);
	CreateDynamicObject(673, 1411.72986, -1413.19348, 12.90625,   356.85840, 0.00000, 3.14159);
	CreateDynamicObject(673, 1404.97534, -1416.28308, 12.90625,   356.85840, 0.00000, 3.14159);
	CreateDynamicObject(673, 1406.69946, -1425.43896, 12.90625,   356.85840, 0.00000, 3.14159);
	CreateDynamicObject(673, 1405.14783, -1436.59363, 12.90625,   356.85840, 0.00000, 3.14159);
	CreateDynamicObject(673, 1417.25732, -1439.34119, 12.90625,   356.85840, 0.00000, 3.14159);

	return true;
}