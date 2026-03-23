#if defined _map_gen_exterior_inc
	#endinput
#endif
#define _map_gen_exterior_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {
	RemoveBuildingForPlayer(playerid, 17349, -542.0078, -522.8438, 29.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 17019, -606.0313, -528.8203, 30.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -573.0547, -559.6953, 38.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -541.4297, -561.2266, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 17012, -542.0078, -522.8438, 29.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -513.7578, -561.0078, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 1441, -503.6172, -540.5313, 25.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -502.6094, -528.6484, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -502.1172, -521.0313, 25.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1441, -502.4063, -513.0156, 25.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -620.4141, -490.5078, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -619.6250, -473.4531, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -552.7656, -479.9219, 38.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -553.6875, -481.6328, 25.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1441, -554.4531, -496.1797, 25.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 1441, -537.0391, -469.1172, 25.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -532.4688, -479.9219, 38.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -516.9453, -496.6484, 25.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -503.1250, -509.0000, 25.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -512.1641, -479.9219, 38.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 17030, -501.0625, -434.0313, 18.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -491.8594, -479.9219, 38.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 17020, -475.9766, -544.8516, 28.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -471.5547, -479.9219, 38.6250, 0.25);

	return true;
}

hook LoadMaps() {
	CreateDynamicObject(9241, -515.39948, -546.97711, 25.78820,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3279, -470.45639, -558.88452, 24.50180,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3279, -619.12238, -473.04791, 24.36450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3279, -619.12238, -557.73578, 24.36450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3279, -470.53610, -473.04791, 24.50180,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(984, -585.75812, -491.56219, 25.16760,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(984, -572.96960, -491.61597, 25.16760,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(984, -560.20050, -491.68909, 25.16760,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(984, -521.77539, -491.80649, 25.16760,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(984, -508.94849, -491.81799, 25.16760,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19447, -623.13470, -546.40851, 26.24770,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2051, -623.01093, -549.85083, 26.12950,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2051, -623.00098, -545.30042, 26.12950,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2051, -622.99719, -547.69427, 26.12950,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2051, -622.99908, -543.34210, 26.12950,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19408, -604.07501, -543.33405, 26.24780,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19447, -618.41302, -541.66827, 26.24770,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19447, -618.41296, -551.17511, 26.24770,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(8527, -538.36493, -498.12979, 29.91900,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1352, -419.99860, -641.17163, 10.35791,   0.00000, 0.00000, 39.59579);
	CreateDynamicObject(3864, -478.99802, -558.55225, 30.46673,   0.00000, 0.00000, 53.64665);
	CreateDynamicObject(3864, -498.28265, -558.84467, 30.46673,   0.00000, 0.00000, 115.73677);
	CreateDynamicObject(8874, -494.61929, -563.87048, 31.24670,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8874, -481.71811, -563.86041, 31.28670,   0.00000, 0.00000, -63.60000);
	CreateDynamicObject(4193, -605.88562, -519.27484, 38.55540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3465, -536.92285, -548.81958, 25.85640,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3286, -512.51050, -505.45093, 29.24650,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3268, -546.57062, -546.95868, 24.52460,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2075, -544.36108, -547.21112, 32.55971,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19815, -549.36591, -556.88287, 26.88460,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19815, -546.36578, -556.88861, 26.88460,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19815, -552.36591, -556.88287, 26.88460,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19447, -608.79608, -551.17511, 26.24770,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19447, -608.79608, -541.66827, 26.24770,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19408, -604.07501, -545.33398, 26.24780,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19408, -604.07501, -547.83398, 26.24780,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19408, -604.07501, -549.65002, 26.24780,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(967, -482.38266, -562.01978, 24.51591,   0.00000, 0.00000, 269.32272);
	CreateDynamicObject(19356, -481.56311, -562.83875, 24.04750,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19356, -481.56311, -563.01270, 24.04750,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19356, -496.24100, -563.08643, 25.86750,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19356, -496.22141, -562.91632, 25.86750,   0.00000, 0.00000, 90.00000);

	return true;
}

hook OnGameModeInitEnded() {
    new gateid;

	gateid = Gate_Create(980, 
	 			-488.87921, -562.93433, 24.97090, 0.00000, 0.00000, 180.00000,
				-500.2542, -562.9343, 24.9709, 0.00, 0.00, 180.00,
				.worldid = -1, .speed = 2.0, .factionid = FAC_GOB, .autoCloseTime = 6000);

	Gate_SetVehicleDetection(gateid, -488.8792, -562.9343, 24.9709, .size = 8.0);

	return true;
}