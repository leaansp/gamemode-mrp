#if defined _map_plaza_marina_inc
	#endinput
#endif
#define _map_plaza_marina_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid)
{
	RemoveBuildingForPlayer(playerid, 3718, 770.343, -1606.406, 16.203, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 761.289, -1625.148, 12.554, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 771.914, -1621.523, 14.781, 0.250);
	RemoveBuildingForPlayer(playerid, 3639, 770.343, -1606.406, 16.203, 0.250);
	RemoveBuildingForPlayer(playerid, 1408, 761.757, -1605.742, 12.960, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 776.343, -1602.968, 12.554, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 777.437, -1599.843, 12.296, 0.250);
	RemoveBuildingForPlayer(playerid, 1408, 777.695, -1596.640, 13.078, 0.250);
	RemoveBuildingForPlayer(playerid, 1408, 772.242, -1596.640, 13.078, 0.250);
	RemoveBuildingForPlayer(playerid, 1408, 766.796, -1596.640, 13.078, 0.250);
	return 1;
}

hook LoadMaps()
{
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19444, 763.407653, -1601.532226, 12.432097, 0.000000, 90.000015, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 766.870483, -1601.532226, 12.432097, 0.000000, 90.000015, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 769.414184, -1602.481811, 12.422097, 0.000007, 90.000000, 89.999977, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 769.414184, -1605.963134, 12.372093, 0.000007, 88.600021, 89.999977, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 769.414184, -1609.464843, 12.332097, 0.000014, 90.000000, 89.999954, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 770.357299, -1612.009277, 12.332097, 0.000000, 90.000015, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 773.838012, -1612.009277, 12.332097, 0.000000, 90.000015, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 771.214599, -1614.575073, 12.332097, 0.000014, 90.000000, 89.999954, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 771.214599, -1618.079956, 12.332097, 0.000014, 90.000000, 89.999954, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 768.676391, -1619.025878, 12.332097, 0.000000, 90.000015, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 767.727661, -1621.578857, 12.332097, 0.000014, 90.000000, 89.999954, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19444, 771.965270, -1601.532226, 12.432097, 0.000000, 90.000015, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19362, 775.302001, -1601.532226, 12.479995, 0.000007, 90.000000, 89.999977, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19362, 777.149291, -1612.070312, 12.352878, 0.000014, 90.000000, 89.999954, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);
	tmpobjid = CreateDynamicObject(19362, 768.677368, -1623.755981, 12.341897, 0.000000, 90.000015, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17508, "barrio1_lae2", "brickred", 0x00000000);

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	tmpobjid = CreateDynamicObject(673, 776.413879, -1623.228271, 10.717086, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(673, 763.998291, -1613.449829, 10.717086, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(673, 769.499694, -1598.458129, 10.717086, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);

	tmpobjid = CreateDynamicObject(1231, 770.673828, -1609.947998, 14.103137, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	tmpobjid = CreateDynamicObject(1231, 770.736389, -1620.699951, 14.103096, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	tmpobjid = CreateDynamicObject(1231, 770.593322, -1603.626098, 14.103096, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);

	tmpobjid = CreateDynamicObject(1280, 777.215637, -1610.731689, 12.817616, 0.000015, 0.000000, 89.999954, -1, -1, -1, 150.00, 150.00);
	tmpobjid = CreateDynamicObject(1280, 777.187927, -1613.479003, 12.842265, -0.000015, 0.000000, -89.999954, -1, -1, -1, 150.00, 150.00);
	tmpobjid = CreateDynamicObject(1280, 775.284118, -1603.037719, 12.950595, -0.000007, 0.000000, -89.999977, -1, -1, -1, 150.00, 150.00);
	tmpobjid = CreateDynamicObject(1280, 775.406188, -1600.350830, 12.970416, 0.000007, 0.000000, 89.999977, -1, -1, -1, 150.00, 150.00);
	tmpobjid = CreateDynamicObject(1280, 768.241333, -1625.115478, 12.816888, 0.000000, 0.000000, -89.500007, -1, -1, -1, 150.00, 150.00);
	tmpobjid = CreateDynamicObject(1280, 770.168640, -1623.487548, 12.817929, 0.000000, 0.000000, 0.399999, -1, -1, -1, 150.00, 150.00);
	tmpobjid = CreateDynamicObject(1359, 770.660644, -1602.860839, 13.141200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 150.00, 150.00);
	tmpobjid = CreateDynamicObject(1359, 770.655639, -1610.695312, 13.036200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 150.00, 150.00);
	tmpobjid = CreateDynamicObject(1359, 771.382629, -1620.446777, 13.036200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 150.00, 150.00);

	tmpobjid = CreateDynamicObject(759, 776.263793, -1623.491088, 11.829830, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(760, 775.470458, -1607.116333, 11.816556, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(760, 774.546813, -1618.024658, 11.765410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(760, 764.745544, -1608.201904, 11.719079, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1419, 763.755615, -1626.776367, 13.386850, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1419, 767.825378, -1626.742187, 13.386850, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1419, 771.914916, -1626.726440, 13.386898, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1419, 776.019409, -1626.743286, 13.386898, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1419, 778.240722, -1596.601440, 13.095236, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1419, 774.187255, -1596.625366, 13.095236, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1419, 770.113647, -1596.658813, 13.095236, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1419, 766.012084, -1596.642700, 13.095236, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1419, 761.731445, -1606.251708, 12.955596, 0.000000, 0.000000, -90.719993, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(682, 773.080566, -1625.184814, 12.378250, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(682, 777.899230, -1619.094482, 12.378250, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(682, 768.466552, -1614.197143, 12.378250, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(682, 772.074707, -1606.156372, 12.378250, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(682, 771.979431, -1598.021972, 12.378250, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(682, 765.274475, -1604.602172, 12.378250, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);

	tmpobjid = CreateDynamicObject(2671, 771.352905, -1604.094726, 12.479900, 0.000000, 0.000000, -101.999992, -1, -1, -1, 50.00, 50.00);
	tmpobjid = CreateDynamicObject(2671, 766.792053, -1615.899047, 12.479900, 0.000000, 0.000000, -179.159988, -1, -1, -1, 50.00, 50.00);
	return 1;
}
