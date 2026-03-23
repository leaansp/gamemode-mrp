#if defined _map_garages_inc
	#endinput
#endif
#define _map_garages_inc

#include <YSI_Coding\y_hooks>

hook LoadMaps() {
    new tmpobjid;
    /*__________________________GARAJE GRANDE-ESTACIONAMIENTO_____________________________*/
    CreateDynamicObject(4232, -2800.000000, -2400.000000, 3800.000000, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0);
    CreateDynamicObject(4032, -2800.000000, -2400.000000, 3800.000000, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0);
    CreateDynamicObject(3037, -2771.131347, -2387.614990, 3796.234130, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(16775, -2763.630615, -2387.544677, 3797.716552, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10051, "carimpound_sfe", "poundwall1_sfe", 0x00000000);
    tmpobjid = CreateDynamicObject(16775, -2778.264160, -2387.544677, 3797.716552, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10051, "carimpound_sfe", "poundwall1_sfe", 0x00000000);

    /*__________________________GARAJE GRANDE-ESTACIONAMIENTO_____________________________*/
    CreateDynamicObject(10051, -2800.000000, -2000.000000, 3800.000000, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0);
    tmpobjid = CreateDynamicObject(16775, -2840.652832, -1970.341552, 3803.696044, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10051, "carimpound_sfe", "poundwall1_sfe", 0x00000000);
    tmpobjid = CreateDynamicObject(16775, -2840.652832, -1984.983520, 3803.696044, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10051, "carimpound_sfe", "poundwall1_sfe", 0x00000000);
    CreateDynamicObject(3037, -2840.636962, -1975.431762, 3802.045654, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 

    /*__________________________GARAJE MEDIANO-ESTACIONAMIENTO_____________________________*/
    CreateDynamicObject(7245, -2800.000000, -1600.000000, 3959.191162, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0);
    tmpobjid = CreateDynamicObject(18762, -2811.616699, -1601.342163, 3958.199951, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10756, "airportroads_sfse", "Heliconcrete", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, -2811.617919, -1592.342895, 3958.129882, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10756, "airportroads_sfse", "Heliconcrete", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, -2813.606201, -1596.843017, 3960.432861, 90.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10756, "airportroads_sfse", "Heliconcrete", 0x00000000);
    tmpobjid = CreateDynamicObject(3037, -2811.229736, -1596.942382, 3957.720947, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 

    /*________________________________GARAJE MEDIANO-TALLER________________________________*/
    tmpobjid = CreateDynamicObject(19545, -2798.540527, -2804.596923, 3996.874023, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
    SetDynamicObjectMaterial(tmpobjid, 0, 17079, "cuntwland", "ws_sub_pen_conc2", 0x00000000);
    tmpobjid = CreateDynamicObject(19545, -2804.322021, -2804.589355, 3996.870117, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
    SetDynamicObjectMaterial(tmpobjid, 0, 17079, "cuntwland", "ws_sub_pen_conc2", 0x00000000);
    tmpobjid = CreateDynamicObject(11389, -2800.000000, -2800.000000, 4000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(11390, -2800.051757, -2800.018310, 4001.229980, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 14584, "ab_abbatoir01", "cj_sheetmetal", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 9, 1257, "bustopm", "CJ_GREENMETAL", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 10, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(11388, -2800.056396, -2800.000488, 4003.509765, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1413, "break_f_mesh", "CJ_CORRIGATED", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1413, "break_f_mesh", "CJ_CORRIGATED", 0x00000000);
    tmpobjid = CreateDynamicObject(11102, -2791.097900, -2787.896484, 3998.958496, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3306, "cunte_house1", "garargeb2", 0x00000000);
    tmpobjid = CreateDynamicObject(11102, -2791.097900, -2796.396484, 3998.958496, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3306, "cunte_house1", "garargeb2", 0x00000000);
    tmpobjid = CreateDynamicObject(11102, -2804.523925, -2816.061279, 3998.991210, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3306, "cunte_house1", "garargeb2", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -2793.719970, -2810.464599, 4000.496826, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19449, -2794.139892, -2805.744628, 4002.196777, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19449, -2798.879882, -2810.464599, 4002.196777, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19859, -2791.201416, -2810.942138, 3998.169189, 0.000000, 0.000000, -90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1508, "dyn_garage", "CJ_metalDOOR1", 0x00000000);
    tmpobjid = CreateDynamicObject(1501, -2791.160400, -2810.948730, 3999.586181, 0.000000, 90.000000, -90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(11392, -2801.279785, -2799.540039, 3996.879882, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11387, -2790.632568, -2816.007568, 4000.219970, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 

    /*________________________________GARAJE MEDIANO-CASA________________________________*/
    tmpobjid = CreateDynamicObject(19377, -2400.517578, -2800.256347, 3954.791992, 0.000000, 90.000007, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0);
    SetDynamicObjectMaterial(tmpobjid, 0, 14577, "casinovault01", "vaultFloor", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, -2396.374511, -2800.247070, 3956.468261, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9515, "bigboxtemp1", "poshbox3c", 0x00000000);
    tmpobjid = CreateDynamicObject(19864, -2405.750000, -2800.249023, 3957.368164, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9515, "bigboxtemp1", "ws_garagedoor3_white", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, -2401.101562, -2805.154296, 3956.468261, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9515, "bigboxtemp1", "poshbox3c", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, -2405.830078, -2800.249023, 3956.468261, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9515, "bigboxtemp1", "poshbox3c", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, -2401.124023, -2795.340820, 3956.468261, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9515, "bigboxtemp1", "poshbox3c", 0x00000000);
    tmpobjid = CreateDynamicObject(11738, -2398.479248, -2795.790527, 3955.744140, 0.000000, 0.000000, -88.700035, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18641, "flashlight1", "metalblack1-2", 0x00000000);
    tmpobjid = CreateDynamicObject(941, -2397.067382, -2798.517089, 3955.334472, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "plywood_gym", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "ws_metalpanel1", 0x00000000);
    tmpobjid = CreateDynamicObject(2063, -2399.546386, -2795.770019, 3955.786132, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD1(EDGE)", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1736, "cj_ammo", "CJ_SHEET2HOLES", 0x00000000);
    tmpobjid = CreateDynamicObject(19859, -2398.428710, -2805.074218, 3956.127685, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0x00000000);
    tmpobjid = CreateDynamicObject(1945, -2399.827148, -2795.803222, 3955.261962, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1736, "cj_ammo", "CJ_Black_metal", 0x00000000);
    tmpobjid = CreateDynamicObject(1650, -2398.511230, -2795.869873, 3955.534423, 0.000007, 0.000001, -167.599975, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10031, "chinatown2", "ws_plasterwall2", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, -2400.517578, -2800.256347, 3958.291992, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "ws_whitewall2_top", 0x00000000);
    tmpobjid = CreateDynamicObject(2121, -2398.206054, -2797.815429, 3955.318847, 0.000003, 0.000006, 29.999994, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1948, "kbslotnu", "slot_black", 0x00000000);
    tmpobjid = CreateDynamicObject(1945, -2399.827148, -2795.803222, 3955.322021, 90.000000, 0.000000, 74.600044, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1736, "cj_ammo", "CJ_Black_metal", 0x00000000);
    tmpobjid = CreateDynamicObject(2464, -2399.661132, -2795.722900, 3955.849609, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(2481, -2399.175048, -2795.759277, 3955.309814, -90.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(918, -2397.252441, -2796.107421, 3955.239257, 0.000000, 0.000000, -15.100006, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2740, -2400.657714, -2800.249023, 3958.068359, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19815, -2396.445312, -2798.232421, 3956.346679, -0.000007, 0.000000, -89.999977, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(918, -2397.718261, -2795.896484, 3955.239257, 0.000007, 0.000000, 74.999992, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18635, -2400.579589, -2795.908447, 3955.700439, 90.000000, 152.399871, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(14772, -2400.371582, -2795.805664, 3955.402343, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18632, -2398.143554, -2796.025878, 3955.046630, 3.600002, 180.000000, -89.999992, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1328, -2405.111328, -2796.033691, 3955.340820, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2226, -2398.885498, -2795.777099, 3956.565917, 0.000000, 0.000000, -14.900003, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18644, -2397.271484, -2798.735839, 3955.833984, 89.999992, 145.213897, -99.213897, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1501, -2398.268554, -2805.124267, 3954.716308, 0.000000, -90.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2712, -2396.748291, -2796.581787, 3955.429931, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19626, -2400.869384, -2795.761962, 3955.639892, 23.800006, 0.000000, 95.299957, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19829, -2398.928222, -2805.072265, 3956.206054, 0.000000, 89.999992, 179.999954, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2190, -2400.145751, -2795.512451, 3956.568115, 0.000000, 0.000000, 6.099997, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19918, -2400.600341, -2795.813232, 3956.152343, 0.000000, 0.000000, 86.700042, -1, -1, -1, 300.00, 300.00); 

    return true;
}