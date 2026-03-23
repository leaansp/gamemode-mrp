#if defined _map_monoblockFA_interior_inc
	#endinput
#endif
#define _map_monoblockFA_interior_inc

#include <YSI_Coding\y_hooks>

/*	Si es un interior, completar esto y dejarlo comentado. la POS y el ANGLE tiene q ser el lugar de entrada,
	con el pj mirando hacia la puerta para definir el angulo.

  		  Nombre   Descripcion	PosX	PosY	PosZ	Angle	Int		Tags				
		{"Nombre","Descripcion",0.000, 0.000, 0.000, 	0.0,	0,		(TAG_UNO | TAG_DOS...)}

*/

hook LoadMaps() {
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19456, 0.000000, 2200.000000, 2000.000000, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 17562, "coast_apts", "scumtiles1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -1.604740, 2200.047363, 2001.787475, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3653, "beachapts_lax", "Bow_dryclean_wall_upr", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -0.986060, 2198.329345, 2001.810546, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3653, "beachapts_lax", "Bow_dryclean_wall_upr", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -0.328330, 2204.721679, 2001.810546, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3653, "beachapts_lax", "Bow_dryclean_wall_upr", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 1.629609, 2200.196777, 2001.787475, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3653, "beachapts_lax", "Bow_dryclean_wall_upr", 0x00000000);
	tmpobjid = CreateDynamicObject(17969, 1.502402, 2201.558105, 2001.617431, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 5390, "glenpark7_lae", "ganggraf01_LA", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 0.000000, 2200.680664, 2003.462524, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(18664, -1.505312, 2203.345214, 2001.616821, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 5998, "sunstr_lawn", "ganggraf02_LA", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(3061, -1.565050, 2201.087646, 2001.260986, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2959, 1.574146, 2198.517333, 2000.069824, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2671, -0.395702, 2203.495605, 2000.095947, 0.000000, 0.000000, -98.999992, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2959, 1.574146, 2204.632080, 2000.069824, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2674, -1.053205, 2199.190917, 2000.105957, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(911, -0.891845, 2199.143066, 2000.636352, 0.000000, 0.000000, 96.299919, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1449, 1.342607, 2201.830566, 2000.536376, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1265, -1.110670, 2204.106933, 2000.546386, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 

	return true;
}