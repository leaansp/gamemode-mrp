/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2020-05-14 21:50:32" by "Cope_Delgado"
	Created by "Cope_Delgado"
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#if defined _map_talleres_interiores_inc
	#endinput
#endif
#define _map_talleres_interiores_inc

#include <YSI_Coding\y_hooks>

hook LoadMaps() {
	//___________________________________INTERIOR 1_______________________________________________________________//
	new tmpobjid;
	tmpobjid = CreateDynamicObject(14776, 2000.000000, 2300.000000, 2700.000000, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(19817, 2001.950073, 2294.182373, 2692.551269, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(18981, 2003.177124, 2283.396484, 2693.492187, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(18981, 1997.333984, 2289.991455, 2692.901611, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);

	//___________________________________INTERIOR 2_______________________________________________________________//
	
	tmpobjid = CreateDynamicObject(14798, -2000.000000, 2100.000000, 2600.000000, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 11, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, -2002.310058, 2101.572265, 2598.716552, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3452, "bballvgnint", "Bow_Abattoir_Conc2", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(10558, -2007.284179, 2100.927001, 2600.027832, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19376, -2007.123901, 2101.572265, 2600.708496, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14798, "int_kbsgarage3", "ab_wall_flake", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19376, -2007.123901, 2091.940185, 2600.708496, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14798, "int_kbsgarage3", "ab_wall_flake", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19376, -2002.310058, 2091.935791, 2598.716552, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3452, "bballvgnint", "Bow_Abattoir_Conc2", 0xFFFFFFFF);

	return true;
}