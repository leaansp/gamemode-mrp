#if defined _map_plazamarket_inc
	#endinput
#endif
#define _map_plazamarket_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) //en caso de no tener Removes, Borrar este hook
{   
    RemoveBuildingForPlayer(playerid, 739, 1231.140, -1341.849, 12.734, 0.250);
    RemoveBuildingForPlayer(playerid, 739, 1231.140, -1356.209, 12.734, 0.250);
    RemoveBuildingForPlayer(playerid, 739, 1231.140, -1328.089, 12.734, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1222.660, -1374.609, 12.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1222.660, -1356.550, 12.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1222.660, -1335.050, 12.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1222.660, -1317.739, 12.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1222.660, -1300.920, 12.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1240.920, -1300.920, 12.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1240.920, -1317.739, 12.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1240.920, -1335.050, 12.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1240.920, -1374.609, 12.296, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1240.920, -1356.550, 12.296, 0.250);
	return true;
}

hook LoadMaps() {   
    new tmpobjid;
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1379.354248, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1369.594970, 14.094606, 0.000022, 0.000000, 89.999931, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1359.314941, 14.094606, 0.000022, 0.000000, 89.999931, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1349.015502, 14.094606, 0.000022, 0.000000, 89.999931, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1338.715332, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1328.425537, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1318.145507, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1307.846069, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1297.555664, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1216.528320, -1296.524658, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1221.708984, -1291.323974, 14.094606, 0.000007, -0.000022, 179.999832, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1231.989257, -1291.323974, 14.094606, 0.000007, -0.000022, 179.999832, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1240.229858, -1291.323974, 14.094606, 0.000007, -0.000022, 179.999832, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1379.354248, 14.094606, 0.000037, 0.000000, 89.999885, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1369.594970, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1359.314941, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1349.015502, 14.094606, 0.000029, 0.000000, 89.999908, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1338.715332, 14.094606, 0.000037, 0.000000, 89.999885, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1328.425537, 14.094606, 0.000037, 0.000000, 89.999885, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1318.145507, 14.094606, 0.000037, 0.000000, 89.999885, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1307.846069, 14.094606, 0.000037, 0.000000, 89.999885, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1297.555664, 14.094606, 0.000037, 0.000000, 89.999885, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1245.410522, -1296.524658, 14.094606, 0.000037, 0.000000, 89.999885, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1221.708984, -1384.495727, 14.094606, 0.000007, -0.000029, 179.999786, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1231.989257, -1384.495727, 14.094606, 0.000007, -0.000029, 179.999786, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    tmpobjid = CreateDynamicObject(8674, 1240.229858, -1384.495727, 14.094606, 0.000007, -0.000029, 179.999786, -1, -1, -1, 250.00, 250.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(703, 1231.734008, -1316.365356, 13.149427, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(703, 1231.734008, -1329.979248, 13.149427, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(703, 1231.734008, -1344.297851, 13.149427, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(703, 1231.734008, -1362.959838, 13.149427, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(776, 1219.789306, -1313.344970, 12.006552, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(776, 1243.189697, -1334.094848, 12.006552, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(776, 1236.889892, -1301.512817, 12.006552, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(776, 1232.000610, -1375.634033, 12.006552, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(776, 1219.320434, -1379.904418, 12.006552, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(775, 1240.846923, -1343.145385, 12.024301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(775, 1221.056152, -1343.145385, 12.024301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(775, 1221.056152, -1363.535400, 12.024301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(775, 1239.616455, -1381.166137, 12.024301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(775, 1226.686523, -1305.966064, 12.024301, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(778, 1219.630981, -1295.065307, 12.222969, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(778, 1229.680541, -1298.505615, 12.222969, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(778, 1240.260620, -1316.715698, 12.222969, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(778, 1221.050292, -1323.185668, 12.222969, 0.000000, 0.000000, 180.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(770, 1220.976684, -1332.028808, 12.329945, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(770, 1239.256469, -1324.848510, 12.329945, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(770, 1241.507080, -1352.529296, 12.329945, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(763, 1240.101196, -1361.826049, 12.205006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(763, 1243.220581, -1372.445190, 12.205006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(763, 1225.200439, -1369.455322, 12.205006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(763, 1222.310302, -1353.405395, 11.215000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(782, 1224.413330, -1337.278320, 12.209278, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(782, 1242.684204, -1305.437377, 12.209278, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(782, 1232.544067, -1308.227294, 12.209278, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(700, 1220.323486, -1306.608642, 12.796557, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(700, 1241.923950, -1293.519653, 12.796557, 0.000000, 0.000000, 0.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(1231, 1245.375854, -1384.500610, 15.207577, 0.000000, 0.000000, 45.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(1231, 1216.465209, -1384.500610, 15.207577, 0.000000, 0.000000, 135.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(1231, 1245.375854, -1356.346557, 15.207577, 0.000000, 0.000007, 90.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(1231, 1216.465209, -1356.346557, 15.207577, 0.000000, 0.000007, 90.000000, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(1231, 1245.375854, -1324.702026, 15.207577, 0.000007, 0.000007, 89.999977, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(1231, 1216.465209, -1324.702026, 15.207577, 0.000007, 0.000007, 89.999977, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(1231, 1245.375854, -1291.389892, 15.207577, 0.000014, 0.000007, 134.999954, -1, -1, -1, 250.00, 250.00); 
    tmpobjid = CreateDynamicObject(1231, 1216.465209, -1291.389892, 15.207577, 0.000014, 0.000007, 224.999954, -1, -1, -1, 250.00, 250.00); 
	return true;
}