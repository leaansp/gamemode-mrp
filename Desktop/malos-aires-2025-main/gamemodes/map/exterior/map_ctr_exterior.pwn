#if defined _map_ctr_exterior_inc
	#endinput
#endif
#define _map_ctr_exterior_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {

	RemoveBuildingForPlayer(playerid, 6516, 717.687, -1357.280, 18.046, 0.250);
	return true;
}
hook LoadMaps() {
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19482, 647.648681, -1355.356079, 18.128456, 0.000000, 0.000000, 179.699996, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "ASOCIACIÓN DE", 130, "Ariel", 50, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 647.627258, -1359.467529, 18.128456, 0.000000, 0.000000, 179.699996, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "COMUNICACIONES", 130, "Ariel", 50, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 647.648986, -1355.475341, 17.698446, 0.000000, 0.000000, 179.699996, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "Y ENTRETENIMIENTO", 130, "Ariel", 50, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 647.625427, -1359.985839, 17.698446, 0.000000, 0.000000, 179.699996, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "DE MALOS AIRES", 130, "Ariel", 50, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 771.926940, -1385.063598, 14.978424, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "ESTACIONAMIENTO", 130, "Ariel", 40, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 771.926940, -1329.873046, 14.978424, 0.000000, 0.000000, 88.700012, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "ESTACIONAMIENTO", 130, "Ariel", 40, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 754.727111, -1381.525146, 18.478433, 0.000000, 0.000000, -0.199992, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterialText(tmpobjid, 0, "DE 18:00HS A 20:00HS", 130, "Ariel", 50, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 754.727111, -1381.525146, 19.198446, 0.000000, 0.000000, -0.199992, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterialText(tmpobjid, 0, "EL DIARIO", 130, "Ariel", 120, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(8330, 754.385864, -1376.321289, 21.068414, 0.000000, 0.000000, 88.800010, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2811, "gb_ornaments01", "GB_photo01", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19482, 754.768920, -1369.623413, 23.388448, 0.000000, 0.000000, -0.199992, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterialText(tmpobjid, 0, "C9N", 130, "Ariel", 120, 1, 0xFF7B0000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 787.319763, -1380.834838, 14.488414, 0.000000, 0.000000, -1.000005, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 5390, "glenpark7_lae", "ganggraf01_LA", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19482, 787.466491, -1333.377319, 14.488414, 0.000000, 0.000000, -0.100005, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 5114, "beach_las2", "ganggraf04_LA", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(4227, 758.999633, -1329.677856, 14.422829, 0.000000, 0.000000, 178.899963, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(11714, 732.029907, -1347.184936, 13.843911, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18850, 744.315429, -1371.660522, 18.020952, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(11544, 733.267639, -1365.429565, 24.402236, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "metpat64", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 16069, "des_stownstrip1", "sw_metalgate1", 0x00000000);
	tmpobjid = CreateDynamicObject(11544, 733.317687, -1362.877807, 24.402236, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "metpat64", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 16069, "des_stownstrip1", "sw_metalgate1", 0x00000000);
	tmpobjid = CreateDynamicObject(12958, 730.996765, -1378.430053, 26.906257, 0.000000, 0.000000, -0.399998, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 754.617675, -1374.430664, 26.112230, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 754.617675, -1370.728515, 26.112230, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 744.187988, -1384.860595, 26.112230, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 723.788024, -1384.860595, 26.112230, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 703.387695, -1384.860595, 26.112230, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 683.106994, -1384.860595, 26.112230, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 677.545776, -1384.860595, 26.112230, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 657.125671, -1384.840576, 21.992206, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 647.644348, -1374.809814, 22.002206, 0.000000, 0.000000, -90.200004, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 647.734680, -1354.411621, 22.002206, 0.000000, 0.000000, -90.300003, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 647.808532, -1340.547241, 22.002206, 0.000000, 0.000000, -90.300003, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 657.327575, -1330.062744, 22.002206, 0.000000, 0.000000, -179.800003, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8673, 670.116271, -1384.850585, 24.652196, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(13728, 658.484985, -1376.568237, 25.540834, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1694, 663.368713, -1358.046020, 29.358043, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(13728, 658.484985, -1338.576538, 25.540834, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(14793, 746.269165, -1365.640014, 20.114303, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, 746.269165, -1365.640014, 15.814293, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, 742.668823, -1371.901977, 27.174312, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, 740.847900, -1371.861938, 28.234329, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, 724.878662, -1364.150634, 17.694303, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, 724.878662, -1364.150634, 22.464307, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(6516, 717.687988, -1357.280029, 18.046899, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0xFFFFFFFF);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(17969, 787.495300, -1374.780273, 14.452821, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3460, 784.946777, -1375.525512, 16.429845, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3460, 784.946777, -1359.275024, 16.429845, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3460, 784.996826, -1343.021484, 16.429845, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3460, 763.395629, -1332.239868, 16.429845, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3460, 745.965515, -1332.019653, 16.429845, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3460, 734.335937, -1336.997558, 16.429845, 0.000000, 0.000000, -90.599998, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3460, 734.193298, -1350.598388, 16.429845, 0.000000, 0.000000, -90.599998, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3460, 765.626953, -1382.436523, 16.589849, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3785, 723.514709, -1381.122802, 26.977632, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3785, 718.473571, -1381.122802, 26.977632, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3785, 701.764770, -1381.122802, 26.977632, -0.000007, 0.000000, -89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3785, 696.723632, -1381.122802, 26.977632, -0.000007, 0.000000, -89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3785, 680.124511, -1381.122802, 26.977632, -0.000014, 0.000000, -89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3785, 675.083374, -1381.122802, 26.977632, -0.000014, 0.000000, -89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3526, 754.412536, -1371.652587, 30.349737, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3526, 734.632019, -1371.652587, 30.349737, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3526, 744.112670, -1381.743408, 30.349737, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3526, 744.112670, -1361.532470, 30.349737, 0.000000, 0.000000, 450.000000, -1, -1, -1, 200.00, 200.00); 


	return true;
}

hook OnGameModeInitEnded() {
	new gateid;

	gateid = Gate_Create(969,
				773.655273, -1330.539062, 12.706878, 0.000000, 0.000000, -0.700000,
				766.075561, -1330.446533, 12.706878, 0.000000, 0.000000, -0.700000,
				.worldid = -1, .speed = 2, .type = GATE_TYPE_FACTION, .extraid = FAC_MAN, .autoCloseTime = 6000);
	
	Gate_SetVehicleDetection(gateid, 778.2464,-1330.1958,13.5507, .size = 8.0);

	gateid = Gate_Create(969,
				782.067016, -1384.486328, 12.896883, 0.000000, 0.000000, -179.999954,
				774.556579, -1384.486328, 12.896883, 0.000000, 0.000000, -179.999954,
				.worldid = -1, .speed = 2, .type = GATE_TYPE_FACTION, .extraid = FAC_MAN, .autoCloseTime = 6000);
	
	Gate_SetVehicleDetection(gateid, 778.2108,-1384.8882,13.7239, .size = 8.0);

	return true;
}