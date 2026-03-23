#if defined _map_ext_comisaria_east_inc
	#endinput
#endif
#define _map_ext_comisaria_east_inc

#include <YSI_Coding\y_hooks>

//Mapeo exterior de la Comisaría Número 53 de la PFA por Rawnker, año 2022.

hook LoadMaps() {
	new tmpobjid;
	
	tmpobjid = CreateDynamicObject(9243, 2337.942382, -1357.072265, 24.911148, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 3, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, -1, "none", "none", 0xFF0066FF);
	SetDynamicObjectMaterial(tmpobjid, 6, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19459, 2337.651123, -1366.935302, 23.078329, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "plaintarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(19459, 2347.239990, -1366.935302, 23.078329, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "plaintarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(19459, 2328.050292, -1366.935302, 23.078329, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "plaintarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(2256, 2331.596191, -1366.650146, 25.133966, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(2256, 2343.858398, -1366.650146, 25.133966, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(2256, 2348.029541, -1366.650146, 25.133966, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(2256, 2327.397460, -1366.650146, 25.133966, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(2256, 2322.776367, -1366.650146, 25.133966, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(2256, 2317.984619, -1366.650146, 25.133966, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(2256, 2352.855712, -1366.650146, 25.133966, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(2256, 2357.516357, -1366.650146, 25.133966, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(19483, 2335.750488, -1366.654052, 27.358169, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "POLICIA", 130, "Ariel", 70, 1, 0xFF00305B, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 2337.239990, -1366.654052, 27.358169, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "FEDERAL", 130, "Ariel", 70, 1, 0xFF00305B, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 2339.318847, -1366.654052, 27.358161, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "ARGENCHOLINA", 130, "Ariel", 70, 1, 0xFF00305B, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 2337.790527, -1366.654052, 27.088163, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "COMISARIA N°53", 130, "Ariel", 50, 1, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19459, 2356.210937, -1366.935302, 23.078329, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "plaintarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(19459, 2319.434570, -1366.935302, 23.078329, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "plaintarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2314.672851, -1342.726684, 24.725820, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2314.672851, -1333.095947, 24.725820, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2314.672851, -1315.752441, 24.725820, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2319.411865, -1311.001098, 24.725820, 0.000000, 0.000000, 450.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2328.731933, -1311.001464, 24.725820, 0.000000, 0.000000, 450.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2332.705810, -1342.763061, 24.725820, 0.000000, 0.000000, 540.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2332.705810, -1333.172363, 24.725820, 0.000000, 0.000000, 540.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2332.705810, -1323.561401, 24.725820, 0.000000, 0.000000, 540.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2332.706542, -1315.750366, 24.725820, 0.000000, 0.000000, 540.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(12951, 2337.507324, -1317.081542, 22.877086, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13078, "cewrehse", "corr_roof1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 5766, "capitol_lawn", "hilcouwall2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 5766, "capitol_lawn", "hilcouwall2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 5766, "capitol_lawn", "hilcouwall2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 5766, "capitol_lawn", "hilcouwall2", 0x00000000);
	tmpobjid = CreateDynamicObject(13296, 2351.378417, -1331.155517, 26.052843, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 7, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2343.762207, -1342.744262, 24.725820, 0.000000, 0.000000, 540.000000, -1, -1, -1, 150.00, 150.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2343.762207, -1333.124633, 24.725820, 0.000000, 0.000000, 540.000000, -1, -1, -1, 150.00, 150.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2343.762207, -1323.475219, 24.725820, 0.000000, 0.000000, 540.000000, -1, -1, -1, 150.00, 150.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2343.762207, -1315.823120, 24.725820, 0.000000, 0.000000, 540.000000, -1, -1, -1, 150.00, 150.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(11433, 2339.413330, -1330.840820, 25.096059, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12848, "cunte_town1", "wall256hi", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 11490, "des_ranch", "newindow11128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 17064, "cw2_storesnstuff", "comptdoor4", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 3374, "ce_farmxref", "sw_barndoor1", 0x00000000);
	tmpobjid = CreateDynamicObject(11433, 2339.412353, -1339.813842, 25.096059, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12848, "cunte_town1", "wall256hi", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 11490, "des_ranch", "newindow11128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 17064, "cw2_storesnstuff", "comptdoor4", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2338.962646, -1347.624633, 24.725820, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10856, "bakerybit_sfse", "ws_oldwarehouse10a", 0x00000000);
	tmpobjid = CreateDynamicObject(5069, 2322.798095, -1314.710083, 23.837924, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(19483, 2323.528564, -1347.493896, 25.238149, -0.000000, 0.000007, 89.999938, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "POLICIA", 130, "Ariel", 70, 1, 0xFF00305B, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 2322.039062, -1347.493896, 25.238149, -0.000000, 0.000007, 89.999938, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "FEDERAL", 130, "Ariel", 70, 1, 0xFF00305B, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 2319.960205, -1347.493896, 25.238142, -0.000000, 0.000007, 89.999938, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "ARGENCHOLINA", 130, "Ariel", 70, 1, 0xFF00305B, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 2321.488525, -1347.493896, 24.968143, -0.000000, 0.000007, 89.999938, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "COMISARIA N°53", 130, "Ariel", 50, 1, 0xFF000000, 0x00000000, 1);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(1536, 2334.863769, -1366.601562, 23.147855, 0.000000, 0.000022, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1536, 2337.845947, -1366.571533, 23.147855, 0.000000, -0.000022, 179.999862, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1536, 2337.793701, -1366.601562, 23.147855, 0.000000, 0.000022, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1536, 2340.796630, -1366.571533, 23.147855, 0.000000, -0.000022, 179.999862, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 2340.843505, -1368.619628, 23.233909, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 2328.680175, -1368.619628, 23.233909, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 2322.379150, -1368.619628, 23.233909, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 2316.097900, -1368.619628, 23.233909, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 2347.170654, -1368.619628, 23.233909, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(994, 2353.471923, -1368.619628, 23.233909, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(11714, 2329.667968, -1347.535278, 24.272033, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2314.719482, -1330.926269, 24.863264, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2314.719482, -1336.156372, 24.863264, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2314.719482, -1341.396362, 24.863264, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2314.719482, -1344.826782, 24.863264, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2314.719482, -1317.895263, 24.863264, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2314.719482, -1313.632080, 24.863264, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2317.310546, -1311.039916, 24.863264, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2322.570068, -1311.039916, 24.863264, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2327.811523, -1311.039916, 24.863264, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2330.143066, -1311.039916, 24.863264, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2332.734130, -1313.631225, 24.863264, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2332.734130, -1318.881835, 24.863264, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2332.734130, -1324.152099, 24.863264, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2332.734130, -1329.401611, 24.863264, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2332.734130, -1334.651977, 24.863264, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2332.734130, -1339.931152, 24.863264, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19868, 2332.734130, -1344.861083, 24.863264, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19302, 2343.324951, -1312.359375, 24.420173, 0.000000, 0.000000, -111.300056, -1, -1, -1, 150.00, 150.00); 
	tmpobjid = CreateDynamicObject(1223, 2343.782470, -1340.173706, 21.921661, 0.000000, 0.000000, 180.000000, -1, -1, -1, 150.00, 150.00); 
	tmpobjid = CreateDynamicObject(1223, 2343.782470, -1323.773803, 21.921661, 0.000000, 0.000000, 180.000000, -1, -1, -1, 150.00, 150.00); 
	tmpobjid = CreateDynamicObject(11433, 2335.761718, -1339.813842, 24.786052, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(11433, 2335.761718, -1330.812377, 24.786052, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3465, 2356.930908, -1333.782470, 24.293287, 0.000000, 0.000000, 360.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(3465, 2356.930908, -1331.782226, 24.293287, 0.000000, 0.000000, 360.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(3465, 2356.930908, -1329.031738, 24.293287, 0.000000, 0.000000, 360.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(3465, 2356.930908, -1327.081420, 24.293287, 0.000000, 0.000000, 360.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(970, 2357.593017, -1328.035400, 23.553430, 0.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(970, 2357.593017, -1332.745849, 23.553430, 0.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(970, 2356.503906, -1332.745849, 23.553430, 0.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(970, 2356.503906, -1328.035278, 23.553430, 0.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(1345, 2345.117431, -1314.041259, 23.879644, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(1440, 2347.586425, -1313.944580, 23.587558, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(1450, 2349.906250, -1314.134643, 23.640142, 0.000000, 0.000000, 180.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(1338, 2344.543457, -1312.748046, 23.346073, 0.000000, 0.000000, 90.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(851, 2346.229980, -1312.260498, 23.445459, 0.000000, 0.000000, 360.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(850, 2349.231445, -1312.061523, 23.225164, 0.000000, 0.000000, 108.700042, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(1358, 2353.008056, -1346.040283, 24.155754, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00); 
	tmpobjid = CreateDynamicObject(2558, 2346.917724, -1321.291748, 24.516952, 0.000007, 0.000000, 89.999977, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(2558, 2346.917724, -1323.992553, 24.516952, 0.000007, 0.000000, 89.999977, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(2558, 2346.917724, -1322.692260, 24.516952, 0.000007, 0.000000, 89.999977, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(2558, 2346.177001, -1322.941406, 24.516952, -0.000007, -0.000007, -89.999984, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(2558, 2346.177001, -1320.240722, 24.516952, -0.000007, -0.000007, -89.999984, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(2558, 2346.177001, -1321.541015, 24.516952, -0.000007, -0.000007, -89.999984, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(14861, 2345.073242, -1322.968139, 23.438756, 0.000000, 0.000000, 0.000000, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(1442, 2344.206787, -1320.248657, 23.663833, 0.000000, 0.000000, 0.000000, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(1349, 2345.676269, -1320.255859, 23.615243, 0.000000, 0.000000, 180.000000, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(3119, 2345.134033, -1321.849365, 23.340923, 0.000000, 0.000000, 270.000000, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(2674, 2344.740966, -1321.165649, 23.105691, 0.000000, 0.000000, 0.000000, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(2670, 2346.551025, -1323.025024, 23.150789, 0.000000, 0.000000, 90.000000, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(2788, 2342.173583, -1341.508544, 23.538105, 0.000000, 0.000000, 177.799926, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(1773, 2343.303222, -1347.066772, 23.834651, 0.000000, 0.000000, -177.299819, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(911, 2342.358642, -1346.793701, 23.595882, 0.000000, 0.000000, 90.000000, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(1449, 2343.460205, -1345.220825, 23.541099, 0.000000, 0.000000, 270.000000, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(1462, 2342.361816, -1338.883300, 23.044527, 0.000000, 0.000000, 90.000000, -1, -1, -1, 50.00, 50.00); 
	tmpobjid = CreateDynamicObject(3801, 2333.745605, -1366.931030, 26.230407, 0.000000, 0.000000, -90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3801, 2342.002197, -1366.931030, 26.230407, 0.000000, 0.000000, -90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3801, 2350.305175, -1366.931030, 26.230407, 0.000000, 0.000000, -90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3801, 2359.467285, -1366.931030, 26.230407, 0.000000, 0.000000, -90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3801, 2324.933105, -1366.931030, 26.230407, 0.000000, 0.000000, -90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(3801, 2315.689941, -1366.931030, 26.230407, 0.000000, 0.000000, -90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(4227, 2314.665527, -1345.108764, 24.501564, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
	return true;
}

hook OnGameModeInitEnded() {
	new gateid;

	gateid = Gate_Create(969, 
	 			2314.8164, -1328.5238, 23.3116, 0.00000, 0.00000, 90.00000,
				2314.8164, -1320.1013, 23.3116, 0.00000, 0.00000, 90.00000,
				.worldid = -1, .speed = 2.0, .type = GATE_TYPE_FACTION, .extraid = FAC_PMA, .autoCloseTime = 6000, .staticObject = true);
	Gate_SetVehicleDetection(gateid, 2314.6853,-1324.2372,24.0772, .size = 8.0);
	return true;
}