#if defined _map_unity_station_texture_inc
	#endinput
#endif
#define _map_unity_station_texture_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {
	//RemoveBuildingForPlayer(playerid, 5033, 1745.203, -1882.851, 26.140, 0.250);
	RemoveBuildingForPlayer(playerid, 5055, 1745.203, -1882.851, 26.140, 0.250); 
	return true;
}

hook LoadMaps() {
	Textura = CreateDynamicObject(5033, 1745.203125, -1882.851562, 26.140630, 0.000000, 0.000000, 0.000000, -1, -1, -1, .streamdistance = -1.0, .drawdistance = 550.0);  
	SetDynamicObjectMaterial(Textura, 0, 6522, "cuntclub_law2", "helipad_grey1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(Textura, 2, 3980, "cityhall_lan", "cityhallroof", 0x00000000);
	SetDynamicObjectMaterial(Textura, 4, 10056, "bigoldbuild_sfe", "clubdoor1_256", 0x00000000);
	SetDynamicObjectMaterial(Textura, 5, 3980, "cityhall_lan", "citywall1", 0x00000000);
	SetDynamicObjectMaterial(Textura, 6, 3975, "lanbloke", "lasunion95", 0x00000000);
	SetDynamicObjectMaterial(Textura, 8, 10377, "cityhall_sfs", "ws_cityhall5", 0x00000000);
	SetDynamicObjectMaterial(Textura, 9, 12976, "sw_diner1", "sw_roof01", 0xFFAABFFB);

	Textura = CreateDynamicObject(19482, 1742.389770, -1862.770874, 14.554061, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(Textura, 0, "ESTACION RETIRO", 90, "Ariel", 27, 1, 0xFF000000, 0x00000000, 0);
	Textura = CreateDynamicObject(18762, 1742.880004, -1863.274414, 15.464066, 90.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(Textura, 0, 3980, "cityhall_lan", "citywall1", 0x00000000);
	Textura = CreateDynamicObject(2885, 1788.593017, -1877.485717, 24.964075, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(Textura, 1, 5069, "ctscene_las", "cleargraf02_LA", 0x00000000);
	Textura = CreateDynamicObject(5856, 1788.761962, -1870.321899, 17.311340, 5.099998, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(Textura, 0, 4227, "graffiti_lan01", "cleargraf01_LA", 0x00000000);
	return true;
}
