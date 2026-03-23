#if defined _map_casas_east_santos_inc
	#endinput
#endif
#define _map_casas_east_santos_inc

#include <YSI_Coding\y_hooks>

hook LoadMaps() {
	new tmpobjid;
	tmpobjid = CreateDynamicObject(3356, 2397.253662, -1295.350830, 28.527582, 0.000000, -0.399998, -89.899993, -1, -1, -1, 350.00, 350.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17566, "contachou1_lae2", "comptwall27", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 3603, "bevmans01_la", "rooftiles1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 17566, "contachou1_lae2", "comptwall27", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2396.206542, -1311.683349, 27.066474, 0.000000, 0.500000, 180.000000, -1, -1, -1, 350.00, 350.00);
	SetDynamicObjectMaterial(tmpobjid, 10, 17555, "eastbeach3c_lae2", "eastwall1_LAe2", 0x00000000);
	tmpobjid = CreateDynamicObject(1496, 2394.866943, -1291.697143, 24.702623, 0.000000, -0.400000, 270.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	tmpobjid = CreateDynamicObject(669, 2382.661376, -1304.512084, 23.364036, 0.000000, 0.000000, 88.600006, -1, -1, -1, 350.00, 350.00);
	tmpobjid = CreateDynamicObject(14468, 2390.546142, -1299.267456, 24.663908, 10.800001, 1.000000, -89.800041, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(801, 2389.016845, -1316.384277, 23.105117, 0.000000, 0.000000, 54.799987, -1, -1, -1, 100.00, 100.00);
	return true;
}