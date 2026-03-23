#if defined _marp_fixed_maps_included
	#endinput
#endif
#define _marp_fixed_maps_included

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {
	//_______________________________FIX WORLD OF COQ________________________________

	RemoveBuildingForPlayer(playerid, 18017, 449.2109, -16.9688, 1000.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 18016, 451.2578, -10.6250, 1001.9766, 0.25);

	//_______________________________ARBOLES EN INTERIORES___________________________

	RemoveBuildingForPlayer(playerid, 762, 1175.3594, -1420.1875, 19.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 615, 1166.3516, -1417.6953, 13.9531, 0.25);

	//_______________________________FIX GRANERO KYLIE_______________________________

	RemoveBuildingForPlayer(playerid, 14871, 286.1875, 307.6094, 1002.0078, 0.25);

	return true;
}

hook LoadMaps() {
	//_______________________________FIX WORLD OF COQ________________________________

	CreateDynamicObject(19376, 451.73251, -4.74720, 1003.28802, 0.00000, 90.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(19376, 441.23251, -4.74720, 1003.28802, 0.00000, 90.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	Textura = CreateDynamicObject(19357, 453.81500, -18.16140, 1001.77667, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18009, "genintrestrest1", "rest_wall5", -1);
	Textura = CreateDynamicObject(19446, 443.68820, -23.11110, 1001.98364, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18009, "genintrestrest1", "koen_win", -1);
	Textura = CreateDynamicObject(19446, 453.32199, -23.11110, 1001.98358, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18009, "genintrestrest1", "koen_win", -1);
	Textura = CreateDynamicObject(19446, 453.92899, -23.53720, 1001.98358, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18009, "genintrestrest1", "koen_win", -1);
	Textura = CreateDynamicObject(19446, 455.01740, -10.08520, 1001.61591, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18009, "genintrestrest1", "koen_win", -1);
	Textura = CreateDynamicObject(19446, 437.45740, -10.08520, 1001.61591, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18009, "genintrestrest1", "koen_win", -1);
	CreateDynamicObject(2441, 454.20410, -11.41230, 999.72858, 0.00000, 0.00000, -90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(2441, 454.20410, -12.41230, 999.72858, 0.00000, 0.00000, -90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(2441, 454.20410, -13.41230, 999.72858, 0.00000, 0.00000, -90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(2441, 454.20410, -13.41230, 999.72858, 0.00000, 0.00000, -90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(2441, 454.20410, -14.41230, 999.72858, 0.00000, 0.00000, -90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(1557, 455.77649, -10.99167, 999.71680, 0.00000, 0.00000, -90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(1541, 455.66260, -13.53840, 1001.96143, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(1541, 455.66260, -14.95840, 1001.96143, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	Textura = CreateDynamicObject(19357, 448.60629, -22.02100, 1001.77667, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18009, "genintrestrest1", "rest_wall5", -1);
	Textura = CreateDynamicObject(19357, 445.41998, -22.02189, 1001.77667, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18009, "genintrestrest1", "rest_wall5", -1);
	Textura = CreateDynamicObject(19427, 443.03229, -22.02100, 1001.77667, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18009, "genintrestrest1", "rest_wall5", -1);
	CreateDynamicObject(1536, 453.79199, -18.93620, 1000.10938, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);

	//_______________________________FIX WELCOME PUMP________________________________

	CreateDynamicObject(19360, 681.58691, -450.60730, -26.49362, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(19360, 681.58691, -450.60730, -22.99600, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(1498, 680.74298, -450.68509, -26.66410, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);

	//_______________________________FIX DEPTO WOOZY_________________________________

	CreateDynamicObject(19380, -2173.78345, 639.91302, 1049.77441, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(1557, -2171.83545, 639.89178, 1051.37329, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(1557, -2168.81006, 639.89398, 1051.37329, 0.00000, 0.00000, 180.00000, -1, -1, -1, 40.00, 40.00);

	//_______________________________FIX RESTO INVISIBLE_____________________________

	CreateDynamicObject(18981, 438.23386, -59.60804, 999.33893, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 444.92401, -57.74580, 998.17303, 0.00000, 90.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 442.47885, -69.58891, 999.33893, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(1557, 439.85699, -49.21550, 998.66217, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(1557, 442.88599, -49.21320, 998.66217, 0.00000, 0.00000, 180.00000, -1, -1, -1, 40.00, 40.00);
	Textura = CreateDynamicObject(18981, 443.97189, -61.22620, 999.33893, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18029, "genintintsmallrest", "GB_restaursmll05", -1);
	Textura = CreateDynamicObject(18981, 441.67053, -48.78267, 999.33893, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, 18029, "genintintsmallrest", "GB_restaursmll05", -1);

	//_______________________________FIX GRANERO KYLIE_______________________________

	CreateDynamicObject(19881, 286.188, 307.609, 1002.01, 0.0, 0.0, 0.0, -1, -1, -1, 40.00, 40.00);

	//___________________________FIX MONOAMBIENTE AINTERIORES 9______________________

	Textura = CreateDynamicObject(18981, 1532.907958, -5.803569, 1001.074035, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0xFF000000);
	Textura = CreateDynamicObject(18981, 1532.112792, -14.696909, 1001.073974, 0.000000, 0.000000, 90.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0xFF000000);
	Textura = CreateDynamicObject(18981, 1528.513793, -5.875120, 1001.073974, 0.000000, 0.000000, 90.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0xFF000000);
	Textura = CreateDynamicObject(18981, 1523.206420, -6.386390, 1001.073974, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0xFF000000);
	Textura = CreateDynamicObject(18981, 1524.538940, -21.819200, 1001.073974, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0xFF000000);
	Textura = CreateDynamicObject(19464, 1530.217529, -7.602000, 1003.612915, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0x0FFFFFFF);
	Textura = CreateDynamicObject(19464, 1529.304809, -15.085300, 1003.612915, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0x0FFFFFFF);
	Textura = CreateDynamicObject(18981, 1532.112792, -14.216905, 1004.157226, 0.000000, 90.000000, 90.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0xFF000000);
	Textura = CreateDynamicObject(3498, 1529.757446, -10.610181, 1001.097106, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0x00FFFFFF);
	SetDynamicObjectMaterial(Textura, 1, -1, "none", "none", 0x00FFFFFF);
	Textura = CreateDynamicObject(3498, 1529.757446, -10.610181, 1001.097106, 0.000000, 0.000000, 0.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0x00FFFFFF);
	SetDynamicObjectMaterial(Textura, 1, -1, "none", "none", 0x00FFFFFF);
	Textura = CreateDynamicObject(2560, 1529.706298, -15.512463, 1001.777282, 0.000000, 0.000000, 90.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 1, 15040, "cuntcuts", "AH_pinkcurtain", 0xDBFFFFFF);
	Textura = CreateDynamicObject(2560, 1529.025634, -11.532450, 1001.777282, 0.000000, 0.000000, 270.000000, -1, -1, -1, 40.00, 40.00);
	SetDynamicObjectMaterial(Textura, 1, 15040, "cuntcuts", "AH_pinkcurtain", 0xDBFFFFFF);

	//__________________________FIX CAFETERIA AINTERIORES 19_________________________

	CreateDynamicObject(18981, 449.72580, -112.47690, 998.04938, 0.00000, 90.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 452.08090, -102.99510, 991.34631, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 453.04059, -112.19700, 991.34631, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 461.58011, -115.87650, 991.34631, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 441.37610, -115.97950, 991.34631, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(8653, 459.71210, -106.21080, 998.60968, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);

	//___________________________FIX OFICINA AINTERIORES 5___________________________

	CreateDynamicObject(18981, 1038.95850, 5.04913, 999.76440, 0.00000, 90.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 1035.52795, 5.64570, 995.06311, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 1038.19556, 12.55340, 995.06311, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 1037.81604, -5.25055, 995.06311, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 1052.71130, 7.95340, 995.06311, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 1044.95813, 8.67040, 995.06311, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 1040.71289, -4.05190, 995.06311, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(1536, 1040.27527, -1.43678, 1000.25574, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);

	//________________________________FIX CASA OG LOC________________________________

	CreateDynamicObject(18981, 522.53827, -13.15025, 1000.06415, 0.00000, 90.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 521.98560, -13.35980, 993.88348, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 509.90790, -12.74400, 993.88348, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 521.35608, -6.20960, 993.88348, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 527.89459, -16.24160, 993.88348, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(18981, 515.89447, -28.14570, 993.88348, 0.00000, 0.00000, 0.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(19447, 512.48822, -20.48200, 1002.24072, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(19447, 512.40674, -20.88546, 1002.24072, 0.00000, 0.00000, 59.58007, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(19447, 510.27179, -22.14874, 1002.24072, 0.00000, 0.00000, 119.76015, -1, -1, -1, 40.00, 40.00);
	CreateDynamicObject(19447, 519.13971, -19.72290, 1002.24072, 0.00000, 0.00000, 90.00000, -1, -1, -1, 40.00, 40.00);

	return true;
}