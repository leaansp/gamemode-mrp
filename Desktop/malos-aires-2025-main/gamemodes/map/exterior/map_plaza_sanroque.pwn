#if defined _map_ext_plaza_sanroque_inc
	#endinput
#endif
#define _map_ext_plaza_sanroque_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) //en caso de no tener Removes, Borrar este hook
{
	
	RemoveBuildingForPlayer(playerid, 3646, 2390.110, -1365.010, 25.328, 0.250);
	RemoveBuildingForPlayer(playerid, 3706, 2390.110, -1365.010, 25.328, 0.250);
	RemoveBuildingForPlayer(playerid, 714, 2403.290, -1368.609, 22.757, 0.250);
	return true;
}

hook LoadMaps() {
	new tmpobjid;
	tmpobjid = CreateDynamicObject(3660, 2399.480224, -1364.497558, 24.987974, 0.000000, -1.499999, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 17505, "lae2roads", "craproad3_LAe", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 17505, "lae2roads", "craproad3_LAe", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(3660, 2390.909912, -1365.458740, 24.868076, -1.899999, 1.700000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 17505, "lae2roads", "craproad3_LAe", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 17505, "lae2roads", "craproad3_LAe", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(983, 2381.175048, -1371.059326, 23.622215, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 17510, "blackwestran1_lae2", "des_indrails", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	tmpobjid = CreateDynamicObject(983, 2406.124023, -1374.190551, 23.992223, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 17510, "blackwestran1_lae2", "des_indrails", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	tmpobjid = CreateDynamicObject(984, 2387.585937, -1374.255859, 23.670015, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 8, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 9, 17510, "blackwestran1_lae2", "des_indrails", 0x00000000);
	tmpobjid = CreateDynamicObject(984, 2391.229248, -1374.255859, 23.630014, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 8, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 9, 17510, "blackwestran1_lae2", "des_indrails", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2389.348388, -1363.245971, 24.027156, -1.800000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6404, "beafron1_law2", "shutter02LA", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2396.825195, -1363.245971, 24.332107, -0.599999, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6404, "beafron1_law2", "shutter02LA", 0x00000000);
	tmpobjid = CreateDynamicObject(1428, 2387.585449, -1370.549072, 23.808223, 15.499998, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "bluemetal02", 0x00000000);
	tmpobjid = CreateDynamicObject(1428, 2389.136230, -1370.549072, 25.338174, 105.500000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16293, "a51_undergrnd", "Was_scrpyd_door_in_hngr", 0x00000000);
	tmpobjid = CreateDynamicObject(1428, 2391.730712, -1370.549072, 24.183460, 151.700012, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concreteyellow256 copy", 0x00000000);
	tmpobjid = CreateDynamicObject(11699, 2390.684570, -1370.274047, 25.316184, 180.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "redmetal", 0x00000000);
	tmpobjid = CreateDynamicObject(11699, 2390.684570, -1370.774414, 25.316184, 180.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "redmetal", 0x00000000);
	tmpobjid = CreateDynamicObject(11699, 2405.456542, -1370.274047, 25.636192, 180.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "concreteyellow256 copy", 0x00000000);
	tmpobjid = CreateDynamicObject(11699, 2405.456542, -1370.274047, 25.626192, 270.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "redmetal", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	tmpobjid = CreateDynamicObject(11699, 2405.456542, -1367.614013, 25.626192, 180.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concreteyellow256 copy", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "concreteyellow256 copy", 0x00000000);
	tmpobjid = CreateDynamicObject(2120, 2405.497070, -1368.202392, 24.096817, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16322, "a51_stores", "des_ghotwood1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	tmpobjid = CreateDynamicObject(1269, 2405.448486, -1367.958007, 24.880098, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16322, "a51_stores", "metalic128", 0x00000000);
	tmpobjid = CreateDynamicObject(1269, 2405.448486, -1368.448486, 24.870098, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16322, "a51_stores", "metalic128", 0x00000000);
	tmpobjid = CreateDynamicObject(1269, 2405.438476, -1369.939819, 24.880098, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16322, "a51_stores", "metalic128", 0x00000000);
	tmpobjid = CreateDynamicObject(2120, 2405.497070, -1369.703857, 24.096817, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16322, "a51_stores", "des_ghotwood1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	tmpobjid = CreateDynamicObject(1269, 2405.448486, -1369.459350, 24.870098, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16322, "a51_stores", "metalic128", 0x00000000);
	tmpobjid = CreateDynamicObject(2659, 2381.135986, -1367.902221, 25.392229, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FFFFFF} Plazoleta San Roque", 120, "Calibri", 27, 1, 0x00000000, 0x00000000, 1);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(760, 2383.449218, -1359.385864, 22.712438, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2389.558837, -1360.886352, 22.583320, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1231, 2401.375244, -1365.185302, 26.080059, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(760, 2408.279052, -1373.212158, 23.408397, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19981, 2381.148193, -1367.897827, 22.729993, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2396.362060, -1370.111816, 22.416006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2676, 2381.240478, -1368.111694, 23.182039, 1.600000, 0.500000, -78.900016, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2405.153320, -1359.575927, 23.051008, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1265, 2380.781738, -1369.111206, 23.452217, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2671, 2403.164062, -1374.254638, 23.374963, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(910, 2405.370849, -1374.967163, 24.566707, 0.000000, 0.000000, 5.899997, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1442, 2401.726318, -1366.332153, 23.900514, -14.800003, 81.299957, 29.799999, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2673, 2402.364746, -1365.421264, 23.694292, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 

	return true;
}