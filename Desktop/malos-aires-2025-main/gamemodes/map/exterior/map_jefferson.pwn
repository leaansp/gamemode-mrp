#if defined _map_jefferson_inc
	#endinput
#endif
#define _map_jefferson_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid)
{
	RemoveBuildingForPlayer(playerid, 3582, 2230.610, -1401.780, 25.640, 0.250);
	RemoveBuildingForPlayer(playerid, 3562, 2230.610, -1401.780, 25.640, 0.250);
	RemoveBuildingForPlayer(playerid, 1221, 2226.850, -1404.739, 23.632, 0.250);
	RemoveBuildingForPlayer(playerid, 1264, 2224.979, -1408.910, 23.398, 0.250);
	RemoveBuildingForPlayer(playerid, 1264, 2224.129, -1408.839, 23.398, 0.250);
	RemoveBuildingForPlayer(playerid, 1230, 2223.879, -1396.800, 23.304, 0.250);
	RemoveBuildingForPlayer(playerid, 1221, 2227.949, -1396.849, 23.375, 0.250);
	RemoveBuildingForPlayer(playerid, 1224, 2225.979, -1396.680, 23.531, 0.250);
	RemoveBuildingForPlayer(playerid, 1230, 2225.850, -1394.630, 23.304, 0.250);
	RemoveBuildingForPlayer(playerid, 1220, 2224.860, -1393.959, 23.304, 0.250);
	RemoveBuildingForPlayer(playerid, 1221, 2223.469, -1396.089, 23.375, 0.250);
	RemoveBuildingForPlayer(playerid, 1220, 2222.879, -1396.130, 23.304, 0.250);
	RemoveBuildingForPlayer(playerid, 645, 2237.530, -1395.479, 23.039, 0.250);
	RemoveBuildingForPlayer(playerid, 3582, 2243.709, -1401.780, 25.640, 0.250);
	RemoveBuildingForPlayer(playerid, 3562, 2243.709, -1401.780, 25.640, 0.250);
	RemoveBuildingForPlayer(playerid, 3582, 2256.659, -1401.780, 25.640, 0.250);
	RemoveBuildingForPlayer(playerid, 3562, 2256.659, -1401.780, 25.640, 0.250);
	RemoveBuildingForPlayer(playerid, 3582, 2263.719, -1464.800, 25.437, 0.250);
	RemoveBuildingForPlayer(playerid, 3562, 2263.719, -1464.800, 25.437, 0.250);
	RemoveBuildingForPlayer(playerid, 3582, 2247.530, -1464.800, 25.546, 0.250);
	RemoveBuildingForPlayer(playerid, 3562, 2247.530, -1464.800, 25.546, 0.250);
	RemoveBuildingForPlayer(playerid, 3582, 2232.399, -1464.800, 25.648, 0.250);
	RemoveBuildingForPlayer(playerid, 3562, 2232.399, -1464.800, 25.648, 0.250);
	RemoveBuildingForPlayer(playerid, 1221, 2225.850, -1466.650, 23.273, 0.250);
	RemoveBuildingForPlayer(playerid, 1224, 2225.679, -1468.619, 23.429, 0.250);
	RemoveBuildingForPlayer(playerid, 1230, 2225.800, -1470.729, 23.195, 0.250);
	RemoveBuildingForPlayer(playerid, 1220, 2225.129, -1471.729, 23.195, 0.250);
	RemoveBuildingForPlayer(playerid, 1221, 2225.090, -1471.130, 23.273, 0.250);
	RemoveBuildingForPlayer(playerid, 1220, 2222.959, -1469.739, 23.195, 0.250);
	RemoveBuildingForPlayer(playerid, 1230, 2223.629, -1468.750, 23.195, 0.250);
	RemoveBuildingForPlayer(playerid, 1221, 2251.290, -1461.829, 23.632, 0.250);
	RemoveBuildingForPlayer(playerid, 1220, 2256.659, -1456.900, 22.859, 0.250);
	RemoveBuildingForPlayer(playerid, 1230, 2255.979, -1457.910, 22.859, 0.250);
	RemoveBuildingForPlayer(playerid, 5682, 2241.429, -1433.670, 31.281, 0.250);
	RemoveBuildingForPlayer(playerid, 1221, 2253.219, -1409.890, 23.632, 0.250);
	RemoveBuildingForPlayer(playerid, 700, 2226.520, -1426.770, 23.117, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2243.570, -1423.609, 22.960, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2227.199, -1444.500, 22.960, 0.250);
	RemoveBuildingForPlayer(playerid, 645, 2239.570, -1468.800, 22.687, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2274.580, -1398.489, 22.507, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2265.620, -1410.339, 21.773, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2241.889, -1458.930, 22.960, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2229.020, -1411.640, 22.960, 0.250);
	RemoveBuildingForPlayer(playerid, 3593, 2261.770, -1441.099, 23.500, 0.250);

	return 1;
}

hook LoadMaps()
{
	new tmpobjid;
	tmpobjid = CreateDynamicObject(4857, 2231.352294, -1399.079833, 25.350017, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 6257, "burgsh01_law", "newall2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 12946, "ce_bankalley1", "sw_wind05", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 3066, "ammotrx", "ammotrn92tarp128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 17634, "landlae2b", "compfence5b_LAe", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 6908, "vgndwntwn21", "247sign1_64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 8, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	tmpobjid = CreateDynamicObject(19865, 2242.116699, -1410.678466, 23.008129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_ irongate", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2259.800292, -1405.896484, 23.850019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "carparkwall12_256", 0x00000000);
	tmpobjid = CreateDynamicObject(4857, 2231.212158, -1406.859985, 20.620010, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2232.475830, -1405.896484, 23.810018, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "carparkwall12_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2232.165039, -1461.466552, 23.860019, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "carparkwall12_256", 0x00000000);
	tmpobjid = CreateDynamicObject(638, 2225.070800, -1408.554443, 23.680009, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3444, "vegashse8", "badhousewall07_128", 0x00000000);
	tmpobjid = CreateDynamicObject(638, 2225.070800, -1405.903320, 23.680009, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3444, "vegashse8", "badhousewall07_128", 0x00000000);
	tmpobjid = CreateDynamicObject(4857, 2229.010009, -1400.729248, 20.620010, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 4, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(5682, 2241.429931, -1433.670043, 31.281299, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(19866, 2261.666748, -1423.289062, 22.973241, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2232.215332, -1425.500000, 23.670015, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "carparkwall12_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19866, 2250.048339, -1423.368530, 22.973241, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(19866, 2259.086425, -1420.876953, 22.973241, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(19865, 2235.042236, -1410.678466, 23.008129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_ irongate", 0x00000000);
	tmpobjid = CreateDynamicObject(19866, 2252.460449, -1420.876953, 22.973241, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(17969, 2232.358886, -1407.158813, 24.238468, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 5998, "sunstr_lawn", "ganggraf02_LA", 0x00000000);
	tmpobjid = CreateDynamicObject(17969, 2245.861083, -1431.180541, 25.168489, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4981, "wiresetc2_las", "ganggraf03_LA", 0x00000000);
	tmpobjid = CreateDynamicObject(19922, 2223.247802, -1442.911865, 22.279993, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(19922, 2223.558105, -1442.911865, 22.279993, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(1440, 2230.835205, -1403.902709, 23.508451, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(5341, 2258.165039, -1398.832885, 25.448162, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3649, 2265.492187, -1402.697998, 25.388130, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3589, 2227.521972, -1466.203491, 25.657436, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3649, 2238.480468, -1465.498901, 25.388130, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(5341, 2248.877441, -1468.623046, 25.228158, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(16633, 2229.478515, -1420.735717, 23.502248, 0.000000, 1.600000, 1.899999, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1407, 2246.596191, -1408.520385, 23.748138, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1498, 2254.202392, -1461.094726, 23.220022, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(673, 2260.736083, -1410.339965, 22.143402, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1407, 2248.888427, -1410.941040, 23.748138, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1412, 2262.538574, -1410.609741, 24.235862, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1412, 2269.193847, -1410.609741, 24.235862, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1407, 2229.777099, -1456.659301, 23.748138, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1407, 2222.551513, -1460.332031, 23.748138, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1407, 2225.144775, -1456.659301, 23.748138, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1412, 2244.116210, -1459.257446, 24.202014, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1460, 2234.407714, -1456.780639, 23.698139, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1460, 2241.834472, -1456.780639, 23.698139, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(673, 2243.591308, -1457.338623, 22.960899, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1468, 2247.360839, -1459.304809, 24.228157, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1468, 2260.546142, -1459.304809, 24.228157, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1468, 2257.917724, -1456.733520, 24.228157, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(673, 2223.496093, -1406.209838, 22.960899, 0.000000, 0.000000, 179.999984, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1256, 2224.535644, -1398.513427, 23.659284, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2676, 2253.451904, -1408.736816, 23.480009, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(5341, 2234.056884, -1432.722900, 25.618164, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3589, 2227.521972, -1429.053588, 25.657436, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3649, 2256.164062, -1429.488159, 25.388130, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1412, 2245.749511, -1423.276000, 24.208141, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(700, 2228.971191, -1421.637695, 23.117200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(673, 2243.640625, -1423.258544, 22.960899, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(673, 2227.199951, -1445.860839, 22.960899, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(16633, 2222.481689, -1423.590820, 23.575363, 0.000000, 1.600000, 91.900001, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1412, 2243.057128, -1420.744262, 24.208141, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1728, 2262.336669, -1436.242065, 23.000000, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(760, 2249.446777, -1433.169067, 23.397880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(852, 2246.721435, -1425.600097, 23.057609, -1.599998, 2.700000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(760, 2227.488525, -1438.816772, 23.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3646, 2238.309082, -1402.706420, 25.336858, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1498, 2239.381347, -1425.203857, 23.590030, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1498, 2251.313232, -1406.393310, 23.420026, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2671, 2245.617675, -1403.430541, 23.040000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1358, 2241.211181, -1444.865478, 24.180009, 0.000000, 0.000000, -16.199996, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1358, 2236.149169, -1444.849853, 24.180009, 0.000000, 0.000000, 70.500022, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1440, 2246.437744, -1459.909790, 23.498140, 0.000000, 0.000000, -90.800018, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2671, 2263.217773, -1435.377319, 23.040000, 0.000000, 0.000000, -83.899986, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(19996, 2263.370605, -1438.069702, 23.000000, 0.000000, 0.000000, 151.499984, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1257, 2223.462158, -1442.211914, 24.240009, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 



	return 1;
}