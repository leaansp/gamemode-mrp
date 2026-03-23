#if defined _map_ext_desarmadero_willow_inc
	#endinput
#endif
#define _map_ext_desarmadero_willow_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {
	RemoveBuildingForPlayer(playerid, 3723, 2178.7344, -1971.2656, 16.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3770, 2197.9766, -1970.5625, 14.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 5357, 2177.9922, -2006.7578, 23.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 5291, 2177.9922, -2006.7578, 23.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 3722, 2178.7344, -1971.2656, 16.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3626, 2197.9766, -1970.5625, 14.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 2209.5859, -1977.5234, 16.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 5190, 2203.7969, -1992.1641, 14.2578, 0.25);
	return true;
}

hook LoadMaps() {
	// Cerco perimetral

	Textura = CreateDynamicObject(19445, 2203.685527, -1966.872680, 14.300100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2197.823486, -1961.349121, 14.300100, 0.000000, 0.000000, 90.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2188.189453, -1961.349121, 14.300100, 0.000000, 0.000000, 90.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2178.555664, -1961.349121, 14.300100, 0.000000, 0.000000, 90.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2168.921630, -1961.349121, 14.300100, 0.000000, 0.000000, 90.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2164.189697, -1966.077148, 14.300100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19426, 2203.685527, -1972.491943, 14.300100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19426, 2203.677490, -1980.984741, 14.300100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2203.677490, -1986.602416, 14.300100, 0.000000, 0.000007, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2203.677490, -1996.236450, 14.300100, 0.000000, 0.000007, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2198.948486, -2004.176513, 14.300100, 0.000000, 0.000000, 90.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19353, 2203.677490, -2002.658447, 14.300100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2189.317382, -2004.176513, 14.300100, 0.000000, 0.000000, 90.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2179.689453, -2004.176513, 14.300100, 0.000000, 0.000000, 90.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2164.189697, -1975.711059, 14.300100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2164.189697, -1985.341064, 14.300100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2164.189697, -1994.975097, 14.300100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19353, 2174.235595, -2004.176025, 14.300100, 0.000000, 0.000000, 90.000000, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);

	// Parte interna

	Textura = CreateDynamicObject(16400, 2192.413818, -1965.547119, 12.532999, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(Textura, 0, 3442, "vegashse4", "Est_corridor_ceiling", 0x00000000);
	SetDynamicObjectMaterial(Textura, 2, 13059, "ce_fact03", "sw_newcorrug", 0x00000000);
	Textura = CreateDynamicObject(12929, 2168.418212, -1981.952148, 12.527198, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(Textura, 2, 1413, "break_f_mesh", "CJ_CORRIGATED", 0x00000000);

	Textura = CreateDynamicObject(1413, 2166.032958, -2001.652221, 13.820100, 0.000000, 0.000000, -44.199989, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19379, 2169.418457, -1978.040039, 12.549400, 0.000000, 90.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	Textura = CreateDynamicObject(19379, 2169.418457, -1986.112060, 12.548998, 0.000000, 90.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	Textura = CreateDynamicObject(2957, 2176.250488, -1976.701049, 12.282999, 100.000000, 0.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 4835, "airoads_las", "concretenewb256", 0xFFDFE3E7);
	Textura = CreateDynamicObject(12928, 2168.418212, -1981.952148, 12.527198, 0.000000, 0.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 2, 1413, "break_f_mesh", "CJ_CORRIGATED", 0x00000000);
	Textura = CreateDynamicObject(2957, 2168.345947, -1992.513916, 12.282999, 100.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 4835, "airoads_las", "concretenewb256", 0xFFDFE3E7);
	Textura = CreateDynamicObject(2258, 2164.626220, -1981.822387, 14.103598, 0.000000, 0.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 10281, "michgar", "toolwall2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2205.529541, -2008.593139, 14.300100, 0.000000, 0.000000, 22.699998, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2209.247314, -2017.485473, 14.300100, 0.000000, 0.000000, 22.699998, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(19445, 2212.954589, -2026.350219, 14.300100, 0.000000, 0.000000, 22.699998, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 1413, "break_f_mesh", "meetwalv2", 0x00000000);
	Textura = CreateDynamicObject(8335, 2195.968994, -2018.529785, 16.476280, 0.000000, 0.000000, -45.500003, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 3621, "dockcargo1_las", "lasdkcrtgr1", 0x00000000);
	SetDynamicObjectMaterial(Textura, 1, 3621, "dockcargo1_las", "lasdkcrtgr1s", 0x00000000);
	SetDynamicObjectMaterial(Textura, 2, 16055, "des_quarry", "lasdkcrtgr1111", 0x00000000);
	SetDynamicObjectMaterial(Textura, 3, 3621, "dockcargo1_las", "lasdkcrtgr111", 0x00000000);
	SetDynamicObjectMaterial(Textura, 4, 16055, "des_quarry", "lasdkcrtgr1ssss", 0x00000000);
	SetDynamicObjectMaterial(Textura, 5, 3621, "dockcargo1_las", "lasdkcrtgr1sss", 0x00000000);
	Textura = CreateDynamicObject(8886, 2181.207275, -2011.135620, 15.907135, 0.000000, 0.000000, 224.600006, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 3621, "dockcargo1_las", "lasdkcrtgr11", 0x00000000);
	SetDynamicObjectMaterial(Textura, 1, 3621, "dockcargo1_las", "lasdkcrtgr1ss", 0x00000000);
	SetDynamicObjectMaterial(Textura, 2, 3621, "dockcargo1_las", "lasdkcrtgr111", 0x00000000);
	SetDynamicObjectMaterial(Textura, 3, 3621, "dockcargo1_las", "lasdkcrtgr1sss", 0x00000000);
	SetDynamicObjectMaterial(Textura, 4, 16055, "des_quarry", "lasdkcrtgr1111", 0x00000000);
	SetDynamicObjectMaterial(Textura, 5, 16055, "des_quarry", "lasdkcrtgr1ssss", 0x00000000);
	Textura = CreateDynamicObject(7025, 2193.951660, -2016.994995, 23.907140, 0.000000, 0.000000, 44.600009, -1, -1, -1, 75.00, 75.00);
	SetDynamicObjectMaterial(Textura, 0, 3621, "dockcargo1_las", "lasdkcrtgr111", 0x00000000);
	SetDynamicObjectMaterial(Textura, 1, 3621, "dockcargo1_las", "lasdkcrtgr1sss", 0x00000000);
	SetDynamicObjectMaterial(Textura, 2, 3621, "dockcargo1_las", "lasdkcrtgr1", 0x00000000);
	SetDynamicObjectMaterial(Textura, 3, 3621, "dockcargo1_las", "lasdkcrtgr1s", 0x00000000);
	SetDynamicObjectMaterial(Textura, 4, 16055, "des_quarry", "lasdkcrtgr1111", 0x00000000);
	SetDynamicObjectMaterial(Textura, 5, 16055, "des_quarry", "lasdkcrtgr1ssss", 0x00000000);

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	CreateDynamicObject(18248, 2186.13525, -1998.91650, 20.36320, 0.00000, 0.00000, 35.07394, -1, -1, -1, 300.00, 300.00);

	CreateDynamicObject(3593, 2171.576171, -1962.855834, 14.040900, 0.000000, 9.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(13591, 2169.545654, -1964.636352, 13.248900, 0.000000, 0.000000, 180.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(12957, 2189.291748, -1996.828613, 13.202098, 0.000000, 0.000000, -35.099998, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1327, 2182.256591, -1963.541503, 13.954098, 0.000000, 5.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1327, 2181.499755, -1961.698608, 13.954098, 0.000000, 5.000000, 70.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(13591, 2179.039306, -2000.480346, 13.248900, 0.000000, 0.000000, 169.700042, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1226, 2209.549316, -1974.168579, 16.418399, 0.000000, 0.000000, 180.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(3761, 2171.317138, -1981.911743, 14.016400, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1150, 2171.643310, -1980.838134, 15.246809, -75.000000, 0.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1178, 2170.959716, -1980.741088, 15.336396, -90.000000, 0.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1192, 2171.279052, -1980.424804, 15.428961, 210.000000, 0.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(936, 2165.249755, -1981.828247, 13.104598, 0.000000, 0.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(18644, 2165.658447, -1982.647460, 13.596500, 87.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(18641, 2165.518310, -1982.497192, 13.602499, 92.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(18635, 2165.261474, -1982.367919, 13.572500, 91.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(18633, 2165.141601, -1982.367919, 13.596500, 2.000000, 90.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1271, 2171.227539, -1979.711059, 13.975000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1185, 2170.973632, -1980.396850, 13.831797, 0.000000, 0.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1180, 2171.363525, -1980.516601, 13.841797, 0.000000, 0.000000, -90.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1138, 2171.009277, -1983.729736, 13.645796, 0.000000, 0.000000, -90.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19917, 2171.354980, -1979.562133, 12.837960, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(927, 2164.655029, -1984.704956, 13.632498, 0.000000, 0.000000, 90.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1619, 2164.638183, -1983.985595, 13.169198, 0.000000, 0.000000, 180.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(2673, 2165.716064, -1983.947143, 12.721098, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(2671, 2168.039794, -1977.957885, 12.641698, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19898, 2168.449462, -1977.793212, 12.643098, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19898, 2168.062255, -1983.106445, 12.642800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19898, 2168.288085, -1981.481933, 12.642800, 0.000000, 0.000000, 100.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(1441, 2176.491943, -1962.226562, 13.673398, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19772, 2181.860839, -1965.417602, 13.404500, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19772, 2181.493652, -1966.975585, 13.404500, 0.000000, 0.000000, -10.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19772, 2181.739746, -1966.137451, 14.598500, 0.000000, 0.000000, -20.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19308, 2171.516845, -1983.999633, 15.371998, 0.000000, 0.000000, 45.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19308, 2171.114746, -1984.221557, 15.371998, 0.000000, 0.000000, 45.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(19308, 2171.114746, -1984.641601, 15.371998, 0.000000, 0.000000, 45.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(864, 2191.875244, -2000.912475, 12.548910, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(864, 2176.921142, -1999.661254, 12.542830, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(864, 2182.001953, -2000.919921, 12.542510, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(864, 2167.980957, -1970.428344, 12.545220, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	CreateDynamicObject(866, 2177.783447, -1992.104248, 12.538028, 0.000000, 0.000000, 0.000000, -1, -1, -1, 75.00, 75.00);
	return true;
}