#if defined _map_HQFenrir_inc
	#endinput
#endif
#define _map_HQFenrir_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid)
{   
    RemoveBuildingForPlayer(playerid, 3169, 1297.280, 173.578, 19.460, 0.250);
    RemoveBuildingForPlayer(playerid, 3339, 1297.280, 173.578, 19.460, 0.250);
    RemoveBuildingForPlayer(playerid, 3168, 1295.979, 158.742, 19.382, 0.250);
    RemoveBuildingForPlayer(playerid, 3343, 1295.979, 158.742, 19.382, 0.250);
    RemoveBuildingForPlayer(playerid, 3168, 1305.040, 184.914, 19.343, 0.250);
    RemoveBuildingForPlayer(playerid, 3343, 1305.040, 184.914, 19.343, 0.250);
    RemoveBuildingForPlayer(playerid, 764, 1303.630, 173.397, 18.937, 0.250);
    RemoveBuildingForPlayer(playerid, 775, 1301.270, 164.266, 19.351, 0.250);
    RemoveBuildingForPlayer(playerid, 1440, 1293.550, 163.882, 19.945, 0.250);
    RemoveBuildingForPlayer(playerid, 1440, 1297.069, 179.227, 19.945, 0.250);
    RemoveBuildingForPlayer(playerid, 780, 1301.589, 154.507, 19.328, 0.250);
    RemoveBuildingForPlayer(playerid, 3167, 1308.400, 168.141, 19.406, 0.250);
    RemoveBuildingForPlayer(playerid, 3340, 1308.400, 168.141, 19.406, 0.250);
	return true;
}

hook LoadMaps() {
    
    new tmpobjid;
    tmpobjid = CreateDynamicObject(11504, 1299.259033, 173.108612, 19.460937, 0.000000, 0.000000, 250.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10891, "bakery_sfse", "ws_altz_wall4", 0xFFC4C4C4);
    SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFFC4C4C4);
    SetDynamicObjectMaterial(tmpobjid, 2, 11100, "bendytunnel_sfse", "ws_altz_wall10b", 0xFFC4C4C4);
    SetDynamicObjectMaterial(tmpobjid, 3, -1, "none", "none", 0xFFC4C4C4);
    SetDynamicObjectMaterial(tmpobjid, 4, 3187, "cxref_quarrytest", "gs_wind1", 0xFFC4C4C4);
    SetDynamicObjectMaterial(tmpobjid, 5, 3374, "ce_farmxref", "sw_barndoor2", 0xFFC4C4C4);
    SetDynamicObjectMaterial(tmpobjid, 6, 5819, "buildtestlawn", "alleydoor8", 0xFFC4C4C4);
    SetDynamicObjectMaterial(tmpobjid, 7, 5520, "bdupshouse_lae", "compdoor4_LAe", 0xFFC4C4C4);
    SetDynamicObjectMaterial(tmpobjid, 8, 5819, "buildtestlawn", "alleydoor8", 0xFFC4C4C4);
    SetDynamicObjectMaterial(tmpobjid, 9, -1, "none", "none", 0xFFC4C4C4);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(1294, 1282.644287, 165.713699, 23.293424, -3.599999, 2.999998, -161.200393, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1294, 1300.956420, 146.058456, 23.374319, 0.000000, 0.000000, 79.199928, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1294, 1309.817382, 174.450759, 23.352790, -1.299998, -2.299998, -172.699874, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3594, 1296.232299, 201.758178, 19.920948, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3594, 1292.970825, 204.738555, 20.028728, -12.100002, 0.000000, 71.000030, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11500, 1270.995971, 172.421752, 18.309122, 0.000000, 0.000000, 48.499988, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1413, 1267.373779, 174.326019, 19.665718, 0.000000, 0.000000, -113.800010, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1413, 1273.325683, 187.821823, 19.665718, 0.000000, 0.000000, -113.800010, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1419, 1286.105346, 153.471435, 19.923233, 0.000000, 0.000000, 13.799998, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1419, 1283.626220, 164.776290, 19.923233, 0.000000, 0.000000, 13.799998, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1419, 1286.105346, 163.325256, 19.923233, 0.000000, 0.000000, 283.799987, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1419, 1287.708618, 155.924804, 19.923233, 0.000000, 0.000000, 101.800003, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1459, 1271.228393, 175.532043, 18.802839, 100.299980, 8.500000, 6.900012, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3262, 1272.239013, 173.973236, 18.592405, -3.999998, 3.999999, -129.699920, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1459, 1271.864135, 175.911376, 18.776592, 2.099997, -24.600002, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11289, 1265.047973, 169.048828, 20.534317, 0.000000, 0.000000, -111.800102, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3170, 1307.593383, 167.154907, 19.320934, 0.000000, 0.000000, -16.500007, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(9227, 1289.619384, 143.884445, 21.083112, 0.000000, 0.000000, -148.099945, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3168, 1297.987304, 154.833679, 19.355569, 0.000000, 0.000000, 24.399997, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1410, 1287.382080, 150.143447, 20.205156, 0.000000, 0.000000, -178.400054, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1410, 1304.405151, 137.810821, 20.205156, 0.000000, 0.000000, 99.699943, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1410, 1305.222412, 133.030090, 20.205156, 0.000000, 0.000000, 99.699943, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(16629, 1312.963378, 171.788330, 20.020942, 0.000000, 0.000000, 163.899963, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(16629, 1309.720825, 160.556732, 20.020942, 0.000000, 0.000000, 163.899963, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(16629, 1312.254150, 161.917312, 19.992301, 14.800020, 0.000000, 433.899963, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3260, 1294.521728, 158.614013, 20.438182, -5.299997, 0.000000, -103.099975, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1414, 1282.753906, 161.565307, 20.968912, 0.000000, 0.000000, 12.800013, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3408, 1269.849609, 175.928405, 18.411436, 0.000000, 0.000000, -166.899963, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1327, 1286.221069, 180.099365, 19.736444, 0.000000, -93.100013, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1327, 1287.742431, 180.080139, 20.124235, 0.000000, -61.299999, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1369, 1271.011230, 171.493057, 19.384880, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(913, 1276.447875, 192.623641, 19.415634, -3.099998, 0.000000, 67.699913, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1338, 1273.238647, 185.328659, 19.150634, 0.000000, -4.099998, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(910, 1275.240234, 184.444427, 19.864318, 0.000000, -3.599997, -25.499986, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1430, 1276.593872, 183.598724, 19.049808, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1450, 1277.542724, 183.068618, 19.371761, -3.699999, -2.700001, 44.799987, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1449, 1295.461303, 175.421096, 19.990949, 0.000000, 0.000000, -108.299980, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(852, 1282.414672, 170.838897, 19.229436, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(851, 1284.810668, 179.155059, 19.510629, -1.399999, -1.100000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1440, 1307.360839, 187.191024, 19.960943, 0.000000, 0.000000, -144.200027, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1349, 1288.085205, 181.565933, 19.885196, 0.000000, 4.599999, 173.600006, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1442, 1274.537597, 172.716247, 19.417169, 0.000000, -2.400000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1347, 1275.281494, 173.185516, 19.289314, -91.599990, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18688, 1274.535400, 172.710205, 17.907772, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1679, 1289.132812, 184.320037, 19.760929, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1712, 1297.708618, 182.184814, 19.466976, 0.000000, 0.000000, -110.599983, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1358, 1286.733154, 208.128372, 19.938533, 0.000000, -2.799998, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1294, 1294.077880, 188.247009, 23.680694, -3.299998, -5.899998, 93.099990, -1, -1, -1, 300.00, 300.00); 
	return true;
}