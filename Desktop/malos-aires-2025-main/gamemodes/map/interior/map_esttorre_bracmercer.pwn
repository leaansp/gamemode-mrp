#if defined _map_esttorre_bracmercer_inc
	#endinput
#endif
#define _map_esttorre_bracmercer_inc

#include <YSI_Coding\y_hooks>

/*	Si es un interior, completar esto y dejarlo comentado. la POS y el ANGLE tiene q ser el lugar de entrada,
	con el pj mirando hacia la puerta para definir el angulo.

  		  Nombre   Descripcion	PosX	PosY	PosZ	Angle	Int		Tags				
		{"Nombre","Descripcion",0.000, 0.000, 0.000, 	0.0,	0,		(TAG_UNO | TAG_DOS...)}

*/

hook RemoveMapsBuildings(playerid) //en caso de no tener Removes, Borrar este hook
{
	return true;
}

hook LoadMaps() {
	new tmpobjid;
	tmpobjid = CreateObject(8419, -1600.000000, 3200.000000, 2300.000000, 0.000000, 0.000000, 0.000000); 
	SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetObjectMaterial(tmpobjid, 4, 9515, "bigboxtemp1", "tarmacplain_bank", 0x00000000);
	SetObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1620.939575, 3200.000000, 2311.633056, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1620.939575, 3175.106689, 2311.633056, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1577.656982, 3192.910156, 2311.633056, 0.000000, 90.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1577.656982, 3234.635986, 2311.633056, 0.000000, 90.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1600.000000, 3200.000000, 2328.837890, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 4, 6102, "gazlaw1", "law_gazwhite1", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1632.902709, 3200.000000, 2300.082031, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "concretewall22_256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "sjmhoodlawn42", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1565.090332, 3200.000000, 2300.082031, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "concretewall22_256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "sjmhoodlawn42", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1585.781127, 3163.082031, 2300.072021, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "concretewall22_256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "sjmhoodlawn42", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1652.734130, 3247.092041, 2300.072021, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "concretewall22_256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "sjmhoodlawn42", 0x00000000);
	tmpobjid = CreateDynamicObject(8419, -1545.182495, 3247.092041, 2300.072021, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "concretewall22_256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "sjmhoodlawn42", 0x00000000);
	tmpobjid = CreateDynamicObject(9093, -1599.027465, 3222.944091, 2313.473388, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(14793, -1598.991088, 3212.372314, 2317.016357, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, -1594.300781, 3212.372314, 2317.016357, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, -1589.288085, 3212.372314, 2317.016357, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, -1598.991088, 3191.261718, 2317.016357, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, -1594.300781, 3191.261718, 2317.016357, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, -1589.288085, 3191.261718, 2317.016357, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateObject(8419, -1548.489013, 3206.712890, 2300.002197, 0.000000, 0.000000, 90.000000); 
	SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetObjectMaterial(tmpobjid, 4, 10778, "airportcpark_sfse", "ws_carpark1", 0x00000000);
	SetObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(11714, -1589.374267, 3194.003417, 2313.057861, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateObject(8419, -1649.589233, 3206.712890, 2300.002197, 0.000000, 0.000000, 90.000000); 
	SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetObjectMaterial(tmpobjid, 4, 10778, "airportcpark_sfse", "ws_carpark1", 0x00000000);
	SetObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	return true;
}