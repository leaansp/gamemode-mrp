#if defined _map_hosp_exterior_inc
	#endinput
#endif
#define _map_hosp_exterior_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid)
{
	RemoveBuildingForPlayer(playerid, 5935, 1120.156, -1303.453, 18.570, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, 1085.703, -1361.023, 13.265, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, 1141.984, -1346.109, 13.265, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, 1148.679, -1385.187, 13.265, 0.250);
	RemoveBuildingForPlayer(playerid, 5737, 1120.156, -1303.453, 18.570, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, 1141.979, -1346.109, 13.265, 0.250);
	return 1;
}

hook LoadMaps()
{
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19905, 1132.123657, -1299.001586, 12.432031, 0.150000, 0.179998, 180.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4550, "skyscr1_lan2", "sl_librarywall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	tmpobjid = CreateDynamicObject(19905, 1132.108642, -1298.995605, 17.009605, -0.400000, 0.180000, 180.005004, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4550, "skyscr1_lan2", "sl_librarywall1", 0x00000000);
	tmpobjid = CreateDynamicObject(5737, 1115.511596, -1335.658447, 6.746322, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 6487, "councl_law2", "tarmacplain2_bank", 0xFFF9FFEE);
	tmpobjid = CreateDynamicObject(5737, 1106.312011, -1335.658447, 6.745800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 6487, "councl_law2", "tarmacplain2_bank", 0xFFF9FFEE);
	tmpobjid = CreateDynamicObject(18762, 1113.679321, -1291.354980, 15.052700, -0.259999, 0.000000, -0.500000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2887, "a51_spotlight", "stormdrain5_nt", 0x00000000);

	tmpobjid = CreateDynamicObject(19362, 1132.051147, -1306.820068, 18.903778, -0.199999, -0.499998, 90.099998, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
	tmpobjid = CreateDynamicObject(19447, 1087.002441, -1362.436279, 14.511072, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19362, 1120.852661, -1306.841430, 18.863779, -0.199999, -0.499998, 90.099998, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
	tmpobjid = CreateDynamicObject(19447, 1145.698242, -1291.325195, 18.811946, -0.199774, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
	tmpobjid = CreateDynamicObject(19447, 1136.607666, -1291.345214, 18.780212, -0.199774, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
	tmpobjid = CreateDynamicObject(19447, 1127.497436, -1291.345214, 18.748409, -0.199774, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
	tmpobjid = CreateDynamicObject(19447, 1118.825683, -1291.355224, 18.718135, -0.199774, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
	tmpobjid = CreateDynamicObject(19362, 1143.231689, -1306.801879, 18.943780, 0.000000, -0.499998, 90.099998, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
	tmpobjid = CreateDynamicObject(2963, 1140.911376, -1306.475219, 13.682065, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16322, "a51_stores", "steel64", 0x00000000);
	tmpobjid = CreateDynamicObject(19377, 1089.526855, -1333.662475, 13.927309, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 2887, "a51_spotlight", "stormdrain5_nt", 0x00000000);

	tmpobjid = CreateDynamicObject(19428, 1181.331054, -1328.103515, 12.361766, 0.000000, -64.999977, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6282, "beafron2_law2", "concretebigb256128", 0x00000000);
	tmpobjid = CreateDynamicObject(19428, 1181.031738, -1327.389038, 11.713768, -64.999977, 0.000000, 89.999931, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6282, "beafron2_law2", "concretebigb256128", 0x00000000);
	tmpobjid = CreateDynamicObject(1616, 1150.009643, -1291.710449, 25.234226, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5708, "hospital_lawn", "hosp03b_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19428, 1174.968872, -1328.103515, 13.571800, 0.000000, -65.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6282, "beafron2_law2", "concretebigb256128", 0x00000000);
	tmpobjid = CreateDynamicObject(19428, 1174.669555, -1327.389038, 12.923800, -65.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6282, "beafron2_law2", "concretebigb256128", 0x00000000);
	tmpobjid = CreateDynamicObject(2372, 1173.984252, -1327.542724, 13.760196, -25.000000, 0.000000, -90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "white_girdr", 0x00000000);

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	tmpobjid = CreateDynamicObject(8658, 1139.230957, -1370.121093, 13.769100, 0.000000, 0.000000, 179.940002, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(4639, 1148.745727, -1382.112060, 14.199996, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(3876, 1162.218872, -1333.403808, -5.868319, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(966, 1146.829467, -1384.871582, 12.699996, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);

	tmpobjid = CreateDynamicObject(3578, 1194.500976, -1327.119140, 11.696470, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	tmpobjid = CreateDynamicObject(3578, 1189.089965, -1332.012695, 11.696470, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	tmpobjid = CreateDynamicObject(3578, 1194.500976, -1316.819335, 11.696470, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	tmpobjid = CreateDynamicObject(3578, 1194.500976, -1306.530029, 11.696470, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	tmpobjid = CreateDynamicObject(3578, 1189.599609, -1301.119140, 11.696470, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	tmpobjid = CreateDynamicObject(647, 1181.333007, -1300.673217, 15.071390, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
	tmpobjid = CreateDynamicObject(3458, 1147.939697, -1354.497558, 14.200900, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
	tmpobjid = CreateDynamicObject(640, 1149.645629, -1377.313720, 13.439700, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);

	tmpobjid = CreateDynamicObject(11714, 1145.392089, -1327.710449, 13.775407, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(640, 1145.018432, -1332.039306, 13.279996, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(640, 1145.019287, -1323.374023, 13.279996, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3934, 1161.514648, -1315.852783, 30.494260, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3051, 1160.609985, -1330.469726, 31.859199, 0.000000, 0.000000, 136.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3051, 1161.781250, -1330.469726, 31.853420, 0.000000, 0.000000, 135.994262, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1687, 1161.328247, -1294.139282, 31.310358, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1689, 1160.585083, -1380.926635, 26.802200, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1695, 1159.892578, -1361.082031, 26.111280, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1687, 1178.955566, -1376.937011, 23.804489, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1635, 1173.593139, -1370.748046, 23.800159, 0.000000, 0.000000, 179.994506, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1173.234375, -1340.898437, 19.246810, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1173.284301, -1328.795898, 19.240240, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1173.294311, -1316.593750, 19.237159, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1215, 1165.387207, -1330.263916, 31.038530, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1215, 1157.620483, -1330.355102, 31.073320, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1233, 1189.548706, -1316.884033, 14.124836, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1233, 1189.622192, -1342.379638, 14.124320, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(2649, 1163.073120, -1344.126464, 26.113740, 0.000000, 0.000000, 270.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1695, 1159.892578, -1364.358154, 26.117380, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1173.184326, -1340.898437, 26.003740, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1173.204345, -1328.795898, 26.003740, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1173.214355, -1316.593750, 26.003740, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1179.667114, -1292.858764, 25.326459, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1166.295043, -1290.404296, 25.356779, 0.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1166.245239, -1290.404296, 20.492479, 0.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1155.568969, -1290.404296, 20.492479, 0.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1175.895507, -1305.675292, 25.269979, 0.000000, 0.000000, 270.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3470, 1158.301025, -1342.649780, 29.709680, 0.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3934, 1161.514648, -1302.031982, 30.494260, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(11714, 1149.520874, -1298.720703, 13.865409, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1366, 1189.422607, -1346.316162, 13.180100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1616, 1145.376953, -1330.940429, 17.917289, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1215, 1185.582885, -1342.282714, 13.758870, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(1243, 1162.139282, -1333.213256, 25.200000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3398, 1117.214599, -1335.082031, 10.000000, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3398, 1104.178344, -1335.082031, 10.000000, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3398, 1131.540161, -1335.079589, 10.000000, 0.000000, 0.000000, 142.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1149.623779, -1343.671386, 20.669250, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(3813, 1149.625732, -1346.857910, 23.154199, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(640, 1131.972045, -1344.224731, 13.659796, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	tmpobjid = CreateDynamicObject(640, 1131.979858, -1337.764282, 13.659796, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	return 1;
}

hook OnGameModeInitEnded()
{
	new gateid;

	gateid = Gate_Create(968,
				1147.03149, -1384.87317, 13.46000, 0.00000, -90.00000, 0.00000,
				1147.03149, -1384.87317, 13.33400, 0.00000, 0.00000, 0.00000,
				.worldid = -1, .speed = 0.125, .type = GATE_TYPE_FACTION, .extraid = FAC_HOSP, .autoCloseTime = 4500);

	Gate_SetVehicleDetection(gateid, 1143.42, -1384.82, 13.79, .size = 6.0);

	gateid = Gate_Create(19906,
				1145.49902, -1290.86206, 15.87810, 0.15000, 0.18000, 180.00000,
				1145.50024, -1290.00000, 15.85910, 90.00000, 0.00000, 180.00000,
				.worldid = -1, .speed = 0.50, .type = GATE_TYPE_FACTION, .extraid = FAC_HOSP, .autoCloseTime = 0);

	Gate_SetOnFootFrontDetection(gateid, 1148.88403, -1291.35596, 14.20000, 0.00000, 0.00000, 180.00000, .labelText = "Portón");
	Gate_SetVehicleDetection(gateid, 1145.4517, -1290.8928, 13.54, .size = 6.0);
	Gate_SetTexture(gateid, 0, 10763, "airport1_sfse", "ws_rollerdoor_fire");

	gateid = Gate_Create(19906,
				1136.49976, -1290.86206, 15.84910, 0.15000, 0.18000, 180.00000,
				1136.49976, -1290.00000, 15.83510, 90.00000, 0.00000, 180.00000,
				.worldid = -1, .speed = 0.50, .type = GATE_TYPE_FACTION, .extraid = FAC_HOSP, .autoCloseTime = 0);

	Gate_SetOnFootFrontDetection(gateid, 1139.93665, -1291.35596, 14.20000, 0.00000, 0.00000, 180.00000, .labelText = "Portón");
	Gate_SetVehicleDetection(gateid, 1136.4517, -1290.8928, 13.54, .size = 6.0);
	Gate_SetTexture(gateid, 0, 10763, "airport1_sfse", "ws_rollerdoor_fire");

	gateid = Gate_Create(19906,
				1127.49915, -1290.86206, 15.82010, 0.15000, 0.18000, 180.00000,
				1127.49915, -1290.00000, 15.80510, 90.00000, 0.00000, 180.00000,
				.worldid = -1, .speed = 0.50, .type = GATE_TYPE_FACTION, .extraid = FAC_HOSP, .autoCloseTime = 0);

	Gate_SetOnFootFrontDetection(gateid, 1130.93604, -1291.35596, 14.20000, 0.00000, 0.00000, 180.00000, .labelText = "Portón");
	Gate_SetVehicleDetection(gateid, 1127.4517, -1290.8928, 13.54, .size = 6.0);
	Gate_SetTexture(gateid, 0, 10763, "airport1_sfse", "ws_rollerdoor_fire");

	gateid = Gate_Create(19906,
				1118.49976, -1290.86206, 15.79210, 0.15000, 0.18000, 180.00000,
				1118.49963, -1289.99805, 15.77710, 90.00000, 0.00000, 180.00000,
				.worldid = -1, .speed = 0.50, .type = GATE_TYPE_FACTION, .extraid = FAC_HOSP, .autoCloseTime = 0);

	Gate_SetOnFootFrontDetection(gateid, 1121.92542, -1291.35596, 14.20000, 0.00000, 0.00000, 180.00000, .labelText = "Portón");
	Gate_SetVehicleDetection(gateid, 1118.4517, -1290.8928, 13.54, .size = 6.0);
	Gate_SetTexture(gateid, 0, 10763, "airport1_sfse", "ws_rollerdoor_fire");

	gateid = Gate_Create(988,
				1110.38000, -1290.87561, 13.53010, 0.000000, 0.000000, 180.000000,
				1104.97839, -1290.87561, 13.53007, 0.000000, 0.000000, 180.000000,
				.worldid = -1, .speed = 1.8, .type = GATE_TYPE_FACTION, .extraid = FAC_HOSP, .autoCloseTime = 5500);

	Gate_SetVehicleDetection(gateid, 1110.4387, -1290.8928, 13.54, .size = 6.0);
	return 1;
}