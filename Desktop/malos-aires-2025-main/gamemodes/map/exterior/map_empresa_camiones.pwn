#if defined _map_empresa_camiones_inc
	#endinput
#endif
#define _map_empresa_camiones_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) //en caso de no tener Removes, Borrar este hook
{   
    RemoveBuildingForPlayer(playerid, 5726, 1238.910, -1164.949, 26.898, 0.250);
    RemoveBuildingForPlayer(playerid, 5953, 1238.910, -1164.949, 26.898, 0.250);
	return true;
}

hook LoadMaps() {

    new tmpobjid;
    tmpobjid = CreateDynamicObject(5726, 1238.910034, -1164.949951, 26.898399, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 5397, "barrio1_lae", "corporate3green_128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 4682, "dtbuil1_lan2", "greenshoptop1_256", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 10051, "carimpound_sfe", "poundwall1_sfe", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 17933, "carter_mainmap", "mp_carter_greenwall", 0x00000000);
    tmpobjid = CreateDynamicObject(19432, 1234.794067, -1157.868408, 26.729488, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "greendirt1", 0x00000000);
    tmpobjid = CreateDynamicObject(19432, 1231.304199, -1157.868408, 26.729488, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "greendirt1", 0x00000000);
    tmpobjid = CreateDynamicObject(19432, 1238.275024, -1157.868408, 26.729488, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "greendirt1", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 1237.912353, -1157.746215, 26.953563, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "SINDICATO Y OBRA", 120, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1234.432739, -1157.746215, 26.953563, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "SOCIAL DE CHOFERES", 120, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1231.353149, -1157.746215, 26.953563, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "DE CAMIONES", 120, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1237.912353, -1157.766235, 26.953563, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "SINDICATO Y OBRA", 120, "Ariel", 35, 1, 0xFF000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1234.432739, -1157.766235, 26.953563, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "SOCIAL DE CHOFERES", 120, "Ariel", 35, 1, 0xFF000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1231.353149, -1157.766235, 26.953563, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "DE CAMIONES", 120, "Ariel", 35, 1, 0xFF000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1234.783081, -1157.746215, 26.223548, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "SEDE MALOS AIRES", 130, "Ariel", 20, 1, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 1234.783081, -1157.766235, 26.223548, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "SEDE MALOS AIRES", 130, "Ariel", 20, 1, 0xFF000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19449, 1234.716186, -1159.556884, 26.635246, 360.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
	return true;
}