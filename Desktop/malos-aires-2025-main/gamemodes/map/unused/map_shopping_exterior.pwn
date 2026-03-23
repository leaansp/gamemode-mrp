#if defined _map_shopping_exterior_inc
	#endinput
#endif
#define _map_shopping_exterior_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {
	RemoveBuildingForPlayer(playerid, 6130, 1117.5859, -1490.0078, 32.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 6255, 1117.5859, -1490.0078, 32.7188, 0.25);
	return true;
}

hook LoadMaps() {
	CreateDynamicObject(19322, 1117.58594, -1490.00781, 32.71880, 0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 450.0);
	CreateDynamicObject(19323, 1117.58594, -1490.00781, 32.71880, 0.00000, 0.00000, 0.00000);

	//=================================VIDRIOS SHOPPING=============================
	Textura = CreateDynamicObject(19325, 1155.40002, -1434.89001, 16.49000, 0.00000, 0.00000, 0.30000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1155.37000, -1445.41003, 16.31000, 0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1155.29004, -1452.38000, 16.31000, 0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1157.35999, -1468.34998, 16.31000, 0.00000, 0.00000, 18.66000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1160.64001, -1478.37000, 16.31000, 0.00000, 0.00000, 17.76000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1159.83997, -1502.06006, 16.31000, 0.00000, 0.00000, -19.92000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1139.28003, -1523.70996, 16.31000, 0.00000, 0.00000, -69.36000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1117.06006, -1523.43005, 16.51000, 0.00000, 0.00000, -109.44000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1097.18005, -1502.43005, 16.51000, 0.00000, 0.00000, -158.58000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1096.46997, -1478.29004, 16.51000, 0.00000, 0.00000, -197.94000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1099.69995, -1468.27002, 16.51000, 0.00000, 0.00000, -197.94000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1101.81006, -1445.44995, 16.22000, 0.00000, 0.00000, -180.24001);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1101.76001, -1452.46997, 16.22000, 0.00000, 0.00000, -181.62000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1101.77002, -1434.88000, 16.22000, 0.00000, 0.00000, -180.24001);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1094.31006, -1444.92004, 23.47000, 0.00000, 0.00000, -180.24001);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1094.37000, -1458.37000, 23.47000, 0.00000, 0.00000, -179.46001);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1093.01001, -1517.43994, 23.44000, 0.00000, 0.00000, -138.72000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1101.07996, -1526.64001, 23.42000, 0.00000, 0.00000, -137.34000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1155.12000, -1526.38000, 23.46000, 0.00000, 0.00000, -42.12000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1163.08997, -1517.25000, 23.46000, 0.00000, 0.00000, -40.74000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1163.04004, -1442.06006, 23.40000, 0.00000, 0.00000, -0.12000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);
	Textura = CreateDynamicObject(19325, 1163.08997, -1428.46997, 23.50000, 0.00000, 0.00000, 0.54000);
	SetDynamicObjectMaterial(Textura, 0, 10444, "hotelbackpool_sfs", "ws_glass_balustrade", 0xCFFFFFFF);

	return true;
}