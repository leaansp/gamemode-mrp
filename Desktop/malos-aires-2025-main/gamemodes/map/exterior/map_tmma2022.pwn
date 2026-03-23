#if defined _map_tmma2022_inc
	#endinput
#endif
#define _map_tmma2022_inc

#include <YSI_Coding\y_hooks>



hook RemoveMapsBuildings(playerid) {
	//=============================TALLER MERCURY===============================
	RemoveBuildingForPlayer(playerid, 616, 2542.219, -1525.380, 21.960, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2543.439, -1515.260, 22.695, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2563.959, -1515.339, 22.296, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2542.169, -1554.050, 21.601, 0.250);
	RemoveBuildingForPlayer(playerid, 616, 2528.709, -1556.680, 21.468, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2510.560, -1563.479, 21.804, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2526.219, -1581.640, 20.929, 0.250);

	return true;
}

hook LoadMaps() {
	new tmpobjid;
	tmpobjid = CreateObject(5737, 2510.398193, -1527.405883, 16.959985, 0.000000, 0.000007, 0.000000); 
	SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetObjectMaterial(tmpobjid, 1, 9515, "bigboxtemp1", "tarmacplain_bank", 0x00000000);
	SetObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateObject(5737, 2526.387695, -1527.405883, 16.957002, 0.000000, 0.000014, 0.000000); 
	SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetObjectMaterial(tmpobjid, 1, 9515, "bigboxtemp1", "tarmacplain_bank", 0x00000000);
	SetObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateObject(5737, 2526.387695, -1550.937255, 16.956001, 0.000000, 0.000014, 0.000000); 
	SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetObjectMaterial(tmpobjid, 1, 9515, "bigboxtemp1", "tarmacplain_bank", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 9515, "bigboxtemp1", "tarmacplain_bank", 0x00000000);
	SetObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateObject(5737, 2510.256347, -1550.937255, 16.955001, 0.000000, 0.000007, 0.000000); 
	SetObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetObjectMaterial(tmpobjid, 1, 9515, "bigboxtemp1", "tarmacplain_bank", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 9515, "bigboxtemp1", "tarmacplain_bank", 0x00000000);
	SetObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(19460, 2497.381103, -1528.717407, 24.334684, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2497.381103, -1519.097656, 24.334684, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2497.381103, -1538.337158, 24.334684, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2497.381103, -1547.957153, 24.334684, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2497.381103, -1557.577026, 24.334684, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2497.382568, -1559.267944, 24.334684, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2539.414062, -1528.717407, 24.334684, 0.000000, 0.000022, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2539.414062, -1519.097656, 24.334684, 0.000000, 0.000022, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2539.414062, -1538.337158, 24.334684, 0.000000, 0.000022, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2539.414062, -1547.957153, 24.334684, 0.000000, 0.000022, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2539.414062, -1557.577026, 24.334684, 0.000000, 0.000022, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2539.415527, -1559.267944, 24.334684, 0.000000, 0.000022, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2534.685058, -1564.009399, 24.334684, 0.000007, 0.000014, 89.999977, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2525.056152, -1564.009399, 24.334684, 0.000007, 0.000014, 89.999977, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2515.436523, -1564.009399, 24.334684, 0.000007, 0.000014, 89.999977, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2505.816406, -1564.009399, 24.334684, 0.000007, 0.000014, 89.999977, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2502.116943, -1564.010253, 24.334684, 0.000000, 0.000014, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12928, 2531.135986, -1520.030395, 23.015993, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12928, 2531.135986, -1530.100952, 23.015993, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12928, 2531.135986, -1540.062011, 23.015993, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12928, 2531.135986, -1549.842651, 23.015993, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12928, 2531.135986, -1559.712646, 23.015993, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(11504, 2501.850830, -1526.497558, 22.987989, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1482, 2499.351318, -1540.918823, 24.303003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1482, 2499.351318, -1547.608398, 24.303003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1482, 2499.351318, -1554.297607, 24.303003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(13591, 2502.968750, -1560.902465, 23.413021, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 2, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0x00000000);
	tmpobjid = CreateDynamicObject(1358, 2500.572265, -1555.965332, 24.183019, 0.000000, 0.000000, -27.100006, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1426, 2521.271728, -1562.885986, 23.004009, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(850, 2517.699462, -1562.536132, 23.094020, 0.000000, 0.000000, -73.100051, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(851, 2503.307861, -1556.511840, 23.253013, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1438, 2508.734619, -1562.471191, 22.974004, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1440, 2506.164794, -1562.862060, 23.512998, 0.000000, 0.000000, 35.800006, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2502.111083, -1514.366088, 24.334684, 0.000000, 0.000007, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2534.693603, -1514.366088, 24.334684, 0.000000, 0.000007, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2525.072753, -1514.366088, 24.334684, 0.000000, 0.000007, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2504.307617, -1514.366943, 24.334684, 0.000000, 0.000007, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19460, 2522.708496, -1514.366943, 24.334684, 0.000000, 0.000007, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1338, 2522.343750, -1533.041381, 23.683425, 0.000000, 0.000000, 107.199989, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1462, 2507.537109, -1514.980957, 23.030942, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19482, 2523.131591, -1522.149658, 25.320013, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "BOX - I", 130, "Calibri", 50, 1, 0xFF0244A2, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 2523.131591, -1532.211059, 25.320013, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "BOX - II", 130, "Calibri", 50, 1, 0xFF0244A2, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 2523.131591, -1542.161010, 25.320013, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "BOX - III", 130, "Calibri", 50, 1, 0xFF0244A2, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 2523.131591, -1551.861328, 25.320013, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "BOX - IV", 130, "Calibri", 50, 1, 0xFF0244A2, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 2523.131591, -1561.861206, 25.320013, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "BOX - V", 130, "Calibri", 50, 1, 0xFF0244A2, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(5043, 2536.471679, -1523.862915, 24.546005, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(5043, 2536.471679, -1533.924072, 24.556005, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(5043, 2536.471679, -1543.854858, 24.556005, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(5043, 2536.471679, -1553.654907, 24.546005, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(5043, 2536.471679, -1563.526245, 24.546005, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12929, 2531.133056, -1520.036010, 22.999956, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12929, 2531.133056, -1530.097412, 22.999956, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12929, 2531.133056, -1540.067626, 22.999956, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12929, 2531.133056, -1549.837402, 22.999956, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(12929, 2531.133056, -1559.717773, 22.999956, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(11729, 2523.635986, -1523.272216, 23.007989, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19815, 2538.842773, -1520.036621, 24.815999, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(10282, 2530.644042, -1519.935791, 23.135982, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 8, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 9, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 12, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 13, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 14, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1518.990112, 23.506002, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1520.981445, 23.506002, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2994, 2536.222412, -1522.127685, 23.516002, 0.000000, 0.000000, 138.900024, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19631, 2538.455078, -1519.341918, 24.076004, -180.000000, 90.000000, -29.400001, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18635, 2536.140625, -1522.132202, 23.875995, 90.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18644, 2536.155517, -1522.345092, 23.905998, 0.000000, 90.000000, -155.600021, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19627, 2536.010009, -1522.187377, 23.895996, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18633, 2538.450195, -1521.720947, 24.076007, 180.000000, 90.000000, -123.899993, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19921, 2538.281738, -1520.690795, 24.125989, 0.000000, 0.000000, -93.699989, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(918, 2538.631591, -1523.381835, 23.385999, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18634, 2538.446777, -1520.017456, 24.123556, 17.700008, 89.599975, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19996, 2537.855957, -1516.883422, 23.015993, 0.000000, 0.000000, -31.999998, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1116, 2527.878173, -1517.200927, 24.305995, 90.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(935, 2529.281738, -1516.806152, 23.566005, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(935, 2530.182373, -1516.806152, 23.566005, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1431, 2531.937011, -1516.868896, 23.555995, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(11729, 2523.635986, -1533.344970, 23.007989, 0.000007, 0.000000, 89.999977, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19815, 2538.842773, -1530.109375, 24.815999, -0.000007, -0.000000, -89.999977, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1529.062866, 23.506002, -0.000007, -0.000000, -89.999977, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1531.054199, 23.506002, -0.000007, -0.000000, -89.999977, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2994, 2536.222412, -1532.200439, 23.516002, 0.000005, -0.000005, 138.900024, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19631, 2538.455078, -1529.414672, 24.076004, -0.000000, 270.000000, 150.599990, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18635, 2536.140625, -1532.204956, 23.875995, 89.999992, 180.000000, -89.999992, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18644, 2536.155517, -1532.417846, 23.905998, -0.000003, 89.999992, -155.599975, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19627, 2536.010009, -1532.260131, 23.895996, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18633, 2538.450195, -1531.793701, 24.076007, 0.000000, -89.999984, 56.100017, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19921, 2538.281738, -1530.763549, 24.125989, -0.000007, -0.000000, -93.699966, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18634, 2538.446777, -1530.090209, 24.123556, 17.700006, 89.599967, 179.999969, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(11729, 2523.635986, -1543.286499, 23.007989, 0.000015, 0.000000, 89.999954, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19815, 2538.842773, -1540.050903, 24.815999, -0.000015, 0.000000, -89.999954, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1539.004394, 23.506002, -0.000015, 0.000000, -89.999954, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1540.995727, 23.506002, -0.000015, 0.000000, -89.999954, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2994, 2536.222412, -1542.141967, 23.516002, 0.000010, -0.000011, 138.900024, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19631, 2538.455078, -1539.356201, 24.076004, 0.000003, 270.000000, 150.599945, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18635, 2536.140625, -1542.146484, 23.875995, 89.999992, 180.000000, -89.999977, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18644, 2536.155517, -1542.359375, 23.905998, -0.000006, 89.999984, -155.599929, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19627, 2536.010009, -1542.201660, 23.895996, 0.000000, 0.000015, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18633, 2538.450195, -1541.735229, 24.076007, 0.000006, -89.999977, 56.100006, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19921, 2538.281738, -1540.705078, 24.125989, -0.000015, -0.000000, -93.699943, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18634, 2538.446777, -1540.031738, 24.123556, 17.700004, 89.599960, 179.999938, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(11729, 2523.635986, -1553.086059, 23.007989, 0.000022, 0.000000, 89.999931, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19815, 2538.842773, -1549.850463, 24.815999, -0.000022, 0.000000, -89.999931, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1548.803955, 23.506002, -0.000022, 0.000000, -89.999931, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1550.795288, 23.506002, -0.000022, 0.000000, -89.999931, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2994, 2536.222412, -1551.941528, 23.516002, 0.000015, -0.000017, 138.900024, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19631, 2538.455078, -1549.155761, 24.076004, 0.000007, 270.000000, 150.599899, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18635, 2536.140625, -1551.946044, 23.875995, 89.999992, 180.000015, -89.999969, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18644, 2536.155517, -1552.158935, 23.905998, -0.000009, 89.999977, -155.599884, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19627, 2536.010009, -1552.001220, 23.895996, 0.000000, 0.000022, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18633, 2538.450195, -1551.534790, 24.076007, 0.000012, -89.999969, 56.099994, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19921, 2538.281738, -1550.504638, 24.125989, -0.000022, -0.000001, -93.699920, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18634, 2538.446777, -1549.831298, 24.123556, 17.700002, 89.599952, 179.999908, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(11729, 2523.635986, -1562.947021, 23.007989, 0.000030, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19815, 2538.842773, -1559.711425, 24.815999, -0.000030, 0.000000, -89.999908, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1558.664916, 23.506002, -0.000030, 0.000000, -89.999908, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2626, 2538.483154, -1560.656250, 23.506002, -0.000030, 0.000000, -89.999908, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "tool_store2", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 14776, "genintintcarint3", "Metal2_256128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(2994, 2536.222412, -1561.802490, 23.516002, 0.000020, -0.000022, 138.900024, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19631, 2538.455078, -1559.016723, 24.076004, 0.000011, 270.000000, 150.599853, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18635, 2536.140625, -1561.807006, 23.875995, 89.999992, 180.000030, -89.999961, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18644, 2536.155517, -1562.019897, 23.905998, -0.000012, 89.999969, -155.599868, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19627, 2536.010009, -1561.862182, 23.895996, 0.000000, 0.000030, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18633, 2538.450195, -1561.395751, 24.076007, 0.000018, -89.999961, 56.099994, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19921, 2538.281738, -1560.365600, 24.125989, -0.000030, -0.000001, -93.699897, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18634, 2538.446777, -1559.692260, 24.123556, 17.700000, 89.599945, 179.999877, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(10282, 2530.644042, -1529.995483, 23.135982, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 8, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 9, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 12, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 13, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 14, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(10282, 2535.505371, -1559.636596, 23.135982, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 8, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 9, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 12, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 13, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 14, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(930, 2524.093994, -1526.885864, 23.486003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(930, 2533.048095, -1543.506469, 23.486003, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1431, 2526.103515, -1526.752929, 23.556003, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1431, 2528.745117, -1553.203735, 23.556003, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19900, 2535.929443, -1527.269531, 23.005992, 0.000000, 0.000000, 36.599998, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(935, 2527.950439, -1526.837524, 23.566005, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(935, 2528.851074, -1526.837524, 23.566005, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1431, 2530.605712, -1526.900268, 23.555995, 0.000000, -0.000007, 179.999954, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(935, 2527.019531, -1536.769042, 23.566005, 0.000000, 0.000015, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(935, 2527.920166, -1536.769042, 23.566005, 0.000000, 0.000015, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1431, 2529.674804, -1536.831787, 23.555995, 0.000000, -0.000015, 179.999908, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(935, 2535.497070, -1556.511840, 23.566005, 0.000007, 0.000022, 179.999877, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(935, 2534.596435, -1556.511840, 23.566005, 0.000007, 0.000022, 179.999877, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1431, 2532.841796, -1556.449340, 23.555995, -0.000007, -0.000022, -0.000129, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(11392, 2530.379638, -1529.102661, 23.017992, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(11392, 2530.379638, -1549.543457, 23.017992, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(19482, 2516.816894, -1519.651611, 23.027992, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 5069, "ctscene_las", "ruffroadlas", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19482, 2513.679443, -1535.095825, 23.027992, 0.000000, 90.000000, -127.199989, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 5069, "ctscene_las", "ruffroadlas", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19482, 2516.462646, -1551.295532, 23.027992, 0.000000, 90.000000, -35.800003, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 5069, "ctscene_las", "ruffroadlas", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19482, 2511.147949, -1526.332397, 23.027992, 0.000000, 90.000000, -35.800003, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "crackedgroundb", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19482, 2517.963134, -1538.115722, 23.027992, 0.000000, 90.000000, -35.800003, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "crackedgroundb", 0xFFFFFFFF);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(2674, 2520.885986, -1516.039794, 23.030706, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2531.231201, -1520.548339, 27.125991, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2674, 2502.460937, -1539.500366, 23.030706, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2674, 2503.832275, -1552.610961, 23.030706, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1449, 2506.216064, -1527.535034, 23.496633, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1450, 2522.531005, -1527.066528, 23.584407, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1344, 2502.815185, -1538.044799, 23.826271, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(4227, 2539.425048, -1529.590576, 24.136800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(17969, 2535.728515, -1514.231445, 24.465759, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1294, 2507.820068, -1519.126708, 27.487991, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1294, 2507.840087, -1530.377563, 27.487991, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1294, 2499.007324, -1543.218994, 27.487991, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1294, 2499.007324, -1549.999145, 27.487991, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1294, 2499.007324, -1556.809570, 27.487991, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1294, 2504.507568, -1562.259521, 27.467990, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1294, 2515.858886, -1562.259521, 27.487991, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2524.753173, -1516.825927, 23.015993, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2527.412841, -1516.825927, 23.015993, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2712, 2534.125488, -1523.558349, 23.585987, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(11727, 2523.139648, -1520.070068, 27.358013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2712, 2534.125488, -1533.631103, 23.585987, -0.000007, -0.000000, -89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2712, 2534.125488, -1543.572631, 23.585987, -0.000015, 0.000000, -89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2712, 2534.125488, -1553.372192, 23.585987, -0.000022, 0.000000, -89.999931, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(2712, 2534.125488, -1563.233154, 23.585987, -0.000030, 0.000000, -89.999908, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2532.105957, -1536.827392, 23.015993, -0.000007, -0.000000, -89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2534.765625, -1536.827392, 23.015993, -0.000007, -0.000000, -89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2528.103271, -1546.686889, 23.015993, -0.000015, 0.000000, -89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2530.762939, -1546.686889, 23.015993, -0.000015, 0.000000, -89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2530.022216, -1562.958007, 23.015993, -0.000015, 0.000007, 89.999984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2527.362548, -1562.958007, 23.015993, -0.000015, 0.000007, 89.999984, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2532.233642, -1533.337524, 23.015993, -0.000007, 0.000007, 89.999961, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19899, 2529.573974, -1533.337524, 23.015993, -0.000007, 0.000007, 89.999961, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(11727, 2523.139648, -1530.090087, 27.358013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(11727, 2523.139648, -1540.051513, 27.358013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(11727, 2523.139648, -1549.831665, 27.358013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(11727, 2523.139648, -1559.703125, 27.358013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2537.231445, -1520.548339, 27.125991, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2525.229248, -1520.548339, 27.125991, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2528.780761, -1520.548339, 27.125991, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2533.561767, -1520.548339, 27.125991, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2531.231201, -1530.591552, 27.125991, 0.000007, 0.000000, 89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2537.231445, -1530.591552, 27.125991, 0.000007, 0.000000, 89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2525.229248, -1530.591552, 27.125991, 0.000007, 0.000000, 89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2528.780761, -1530.591552, 27.125991, 0.000007, 0.000000, 89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2533.561767, -1530.591552, 27.125991, 0.000007, 0.000000, 89.999977, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2531.231201, -1540.592163, 27.125991, 0.000015, 0.000000, 89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2537.231445, -1540.592163, 27.125991, 0.000015, 0.000000, 89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2525.229248, -1540.592163, 27.125991, 0.000015, 0.000000, 89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2528.780761, -1540.592163, 27.125991, 0.000015, 0.000000, 89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2533.561767, -1540.592163, 27.125991, 0.000015, 0.000000, 89.999954, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2531.231201, -1550.362792, 27.125991, 0.000022, 0.000000, 89.999931, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2537.231445, -1550.362792, 27.125991, 0.000022, 0.000000, 89.999931, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2525.229248, -1550.362792, 27.125991, 0.000022, 0.000000, 89.999931, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2528.780761, -1550.362792, 27.125991, 0.000022, 0.000000, 89.999931, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2533.561767, -1550.362792, 27.125991, 0.000022, 0.000000, 89.999931, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2531.231201, -1560.214843, 27.125991, 0.000030, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2537.231445, -1560.214843, 27.125991, 0.000030, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2525.229248, -1560.214843, 27.125991, 0.000030, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2528.780761, -1560.214843, 27.125991, 0.000030, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1893, 2533.561767, -1560.214843, 27.125991, 0.000030, 0.000000, 89.999908, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19898, 2532.415039, -1539.857910, 23.025993, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19898, 2527.194335, -1518.717285, 23.025993, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(5088, 2491.156738, -1494.017456, 31.607999, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(5088, 2417.727050, -1500.108276, 31.638000, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(11392, 2503.523437, -1546.892944, 23.007991, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 


	return true;
}

hook OnGameModeInitEnded() {
	new gateid;

	gateid = Gate_Create(969,
				2509.203857, -1514.531860, 22.989999, 0.000000, 0.000000, 0.000000,
				2516.705566, -1514.531860, 22.989999, 0.000000, 0.000000, 0.000000,
				.worldid = -1, .speed = 2.0, .type = GATE_TYPE_FACTION, .extraid = FAC_MECH, .autoCloseTime = -1);
	
	Gate_SetVehicleDetection(gateid, 2513.4490,-1514.1332,24.0000, .size = 8.0);
	Gate_SetOnFootFrontDetection(gateid, 2508.583007, -1514.251220, 24.660015, 0.000000, 0.000000, 0.000000, .labelText = "");
	Gate_SetOnFootBackDetection(gateid, 2508.583007, -1514.471435, 24.660015, 0.000000, 0.000000, 180.000000, .labelText = "");

	//Box 1
	gateid = Gate_Create(10149,
				2523.229492, -1520.052490, 24.508003, 0.000000, 0.000000, 90.000000,
				2524.460693, -1520.052490, 25.988035, -89.999992, -44.999996, 44.999996,
				.worldid = -1, .speed = 2.0, .type = GATE_TYPE_FACTION, .extraid = FAC_MECH, .autoCloseTime = 0, .staticObject = false);

	
	Gate_SetOnFootFrontDetection(gateid,   2523.804443, -1524.062744, 24.660015, 0.000000, 0.000000, 540.000000,  .labelText = "");
	
	//Box 2
	gateid = Gate_Create(10149,
				2523.229492, -1530.123413, 24.508003, 0.000000, 0.000000, 90.000000,
				2524.460693, -1530.123413, 25.988035, -89.999992, -44.999996, 44.999996,
				.worldid = -1, .speed = 2.0, .type = GATE_TYPE_FACTION, .extraid = FAC_MECH, .autoCloseTime = 0, .staticObject = false);

	
	Gate_SetOnFootFrontDetection(gateid,   2523.804443, -1534.113891, 24.660015, 0.000000, 0.000000, 540.000000, .labelText = "");

   //Box 3
	gateid = Gate_Create(10149,
				2523.229492, -1540.084472, 24.508003, 0.000000, 0.000000, 90.000000, 
				2524.460693, -1540.084472, 25.988035, -89.999992, -44.999996, 44.999996,
				.worldid = -1, .speed = 2.0, .type = GATE_TYPE_FACTION, .extraid = FAC_MECH, .autoCloseTime = 0, .staticObject = false);

	
	Gate_SetOnFootFrontDetection(gateid, 2523.804443, -1544.075927, 24.660015, 0.000000, 0.000000, 540.000000,   .labelText = "");

	//Box 4
	gateid = Gate_Create(10149,
				2523.229492, -1549.855468, 24.508003, 0.000000, 0.000000, 90.000000,
				2524.460693, -1549.855468, 25.988035, -89.999992, -44.999996, 44.999996,
				.worldid = -1, .speed = 2.0, .type = GATE_TYPE_FACTION, .extraid = FAC_MECH, .autoCloseTime = 0, .staticObject = false);

	
	Gate_SetOnFootFrontDetection(gateid,  2523.804443, -1553.856689, 24.660015, 0.000000, 0.000000, 540.000000, .labelText = "");


	//Box 5
	gateid = Gate_Create(10149,
				2523.229492, -1559.735839, 24.508003, 0.000000, 0.000000, 90.000000,
				2524.460693, -1559.735839, 25.988035, -89.999992, -44.999996, 44.999996, 
				.worldid = -1, .speed = 2.0, .type = GATE_TYPE_FACTION, .extraid = FAC_MECH, .autoCloseTime = 0, .staticObject = false);

	
	Gate_SetOnFootFrontDetection(gateid, 2523.804443, -1555.698120, 24.660015, 0.000000, 0.000000, 720.000000, .labelText = "");
	return true;
}