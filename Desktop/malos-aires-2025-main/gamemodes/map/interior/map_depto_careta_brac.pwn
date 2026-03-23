#if defined _map_depto_careta_brac_inc
	#endinput
#endif
#define _map_depto_careta_brac_inc

#include <YSI_Coding\y_hooks>

hook LoadMaps() {
	//==============DEPARTAMENTO 1 DORM CHICO SEMI CARETA (JBRACONE)================
	Textura = CreateObject(18981, -512.96765, 2594.70337, 1005.07922,   0.00000, 90.00000, 0.00000); //PISO
    SetObjectMaterial(Textura, 0, 14639, "traidman", "darkgrey_carpet_256", 0xFFE9E9E9);
	Textura = CreateObject(18765, -526.76099, 2586.95117, 1003.09192,   0.00000, 0.00000, 0.00000); //PISO BAÑO
	SetObjectMaterial(Textura, 0, 14639, "traidman", "marbletile8b", -1);
	Textura = CreateDynamicObject(18981, -512.96765, 2594.70337, 1009.54419,   0.00000, 90.00000, 0.00000); //TECHO
	SetDynamicObjectMaterial(Textura, 0, 14639, "traidman", "darkgrey_carpet_256", -1);

	//PAREDES
	CreateDynamicObject(19460, -510.12869, 2591.09424, 1007.30170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19460, -514.85571, 2595.99780, 1007.30170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19460, -514.34479, 2596.66748, 1007.30170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19460, -518.14502, 2589.42676, 1007.30170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19460, -518.48688, 2596.66650, 1007.30170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19460, -524.48950, 2595.99780, 1007.30170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19460, -523.89032, 2596.82202, 1007.30170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19460, -514.32648, 2586.27466, 1007.30170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19460, -526.58881, 2592.08398, 1007.30170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19368, -514.29651, 2587.77588, 1007.30170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19396, -520.16699, 2592.08398, 1007.30170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19396, -521.69739, 2590.39722, 1007.30170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19396, -511.72241, 2589.42676, 1007.30170,   0.00000, 0.00000, 90.00000);

	//PAREDES BAÑO
	CreateDynamicObject(19369, -523.37872, 2592.03979, 1007.30170,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19369, -524.98169, 2590.62964, 1007.30170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19369, -523.32349, 2589.42798, 1007.30170,   0.00000, 0.00000, 90.00000);

	//PLATAFORMA
	Textura = CreateDynamicObject(18856, -516.93079, 2594.67188, 1004.51459,   0.00000, 180.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 1, 14639, "traidman", "darkgrey_carpet_256", -1);

	//MUEBLE DORM
	Textura = CreateDynamicObject(19173, -519.05627, 2592.17651, 1006.40802,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19173, -519.05627, 2595.90308, 1006.40802,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19173, -519.05627, 2593.20410, 1006.40802,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19173, -519.05627, 2594.81104, 1006.40802,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19173, -519.05603, 2593.24976, 1007.08649,   90.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19173, -519.05603, 2595.40942, 1007.08649,   90.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19173, -519.05603, 2593.24976, 1007.47913,   90.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19173, -519.05603, 2595.40942, 1007.47913,   90.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19172, -519.41650, 2593.52075, 1005.26428,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19172, -519.41650, 2596.21948, 1005.26428,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(19455, -518.60199, 2596.98853, 1005.73633,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 0, 2204, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 2204, "cj_office", "CJ_WOOD5", -1);

 	// CAMA
 	Textura = CreateDynamicObject(2298, -519.83752, 2592.71240, 1005.56989,   0.00000, 0.00000, 90.00000);
 	SetDynamicObjectMaterial(Textura, 2, 2204, "cj_office", "CJ_WOOD5", -1);

 	//PARLANTES
	Textura = CreateDynamicObject(2231, -518.88409, 2595.83154, 1007.48572,   0.00000, 90.00000, -80.00000);
	SetDynamicObjectMaterial(Textura, 3, 2232, "cj_hi_fi", "CJ_speaker_6", -1);
	SetDynamicObjectMaterial(Textura, 2, 2232, "cj_hi_fi", "CJ_Black_metal", -1);
	SetDynamicObjectMaterial(Textura, 1, 2229, "cj_hi_fi2", "CJ_SPEAKER2", -1);
	Textura = CreateDynamicObject(2231, -518.86322, 2592.19775, 1007.97992,   0.00000, -90.00000, -100.00000);
	SetDynamicObjectMaterial(Textura, 3, 2232, "cj_hi_fi", "CJ_speaker_6", -1);
	SetDynamicObjectMaterial(Textura, 2, 2232, "cj_hi_fi", "CJ_Black_metal", -1);
	SetDynamicObjectMaterial(Textura, 1, 2229, "cj_hi_fi2", "CJ_SPEAKER2", -1);

	CreateDynamicObject(2138, -510.72321, 2588.84424, 1005.57532,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(14416, -516.39581, 2590.33521, 1002.82281,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2305, -510.72409, 2586.87207, 1005.57538,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2137, -510.72321, 2587.86548, 1005.57532,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2135, -511.68799, 2586.86182, 1005.57532,   0.00000, 0.00000, 180.00000);
 	CreateDynamicObject(2136, -512.66791, 2586.86206, 1005.57532,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2238, -519.12408, 2593.98340, 1006.41687,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2389, -518.93488, 2595.64038, 1006.59668,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2390, -518.93488, 2595.12427, 1006.56860,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2392, -519.16321, 2592.69556, 1006.64099,   0.00000, 0.00000, 0.84000);
	CreateDynamicObject(19871, -519.16528, 2592.15625, 1006.99310,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(2384, -519.05768, 2592.44067, 1006.11499,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2386, -519.09753, 2592.93799, 1006.11499,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2479, -519.11023, 2593.89258, 1007.21722,   0.00000, 0.00000, -85.02000);
	CreateDynamicObject(2694, -519.09222, 2592.58765, 1007.20111,   0.00000, 0.00000, 47.40000);
	CreateDynamicObject(2386, -519.05042, 2595.58496, 1007.19629,   0.00000, 0.00000, -9.84000);
	CreateDynamicObject(2386, -519.10883, 2595.06128, 1007.19629,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2406, -518.61603, 2594.17700, 1008.03699,   0.00000, -70.00000, -90.00000);
	CreateDynamicObject(19565, -519.20734, 2594.23047, 1007.56372,   -80.00000, 90.00000, 17.46000);
	CreateDynamicObject(19566, -519.10901, 2594.45190, 1007.52197,   90.00000, 0.00000, -165.47983);
	CreateDynamicObject(19624, -519.11359, 2593.81958, 1007.58270,   -90.00000, 0.00000, 22.98000);
	CreateDynamicObject(19787, -519.11292, 2594.00684, 1006.54889,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2344, -519.27600, 2594.58350, 1006.02179,   -5.00000, 0.00000, 23.34000);
	CreateDynamicObject(2069, -523.53632, 2592.64136, 1004.67242,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2813, -523.62476, 2593.51318, 1006.37201,   0.00000, 0.00000, -74.34000);
	CreateDynamicObject(2828, -523.53558, 2594.42578, 1006.37329,   0.00000, 0.00000, -110.82000);
	CreateDynamicObject(2824, -523.51379, 2595.34741, 1006.08960,   0.00000, 0.00000, 87.12003);
	CreateDynamicObject(19807, -523.43933, 2592.96777, 1006.15033,   0.00000, 0.00000, 60.71988);
	CreateDynamicObject(1455, -523.72272, 2593.05469, 1006.16052,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2841, -519.74207, 2593.34619, 1005.57281,   0.00000, 0.00000, 89.00000);
	CreateDynamicObject(2526, -524.38141, 2590.23389, 1005.57831,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2528, -523.16058, 2591.45020, 1005.57739,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1491, -521.68707, 2589.65332, 1005.56458,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2523, -522.71320, 2591.43945, 1005.57599,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1491, -519.42407, 2592.09961, 1005.56458,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2635, -513.72827, 2588.79272, 1005.98492,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1811, -512.85663, 2588.90747, 1006.18243,   0.00000, 0.00000, 14.46000);
	CreateDynamicObject(1811, -513.75769, 2588.40039, 1006.18243,   0.00000, 0.00000, -97.92004);
	CreateDynamicObject(1569, -510.64969, 2595.96851, 1005.57318,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2117, -513.63153, 2594.09863, 1005.57336,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1811, -513.79260, 2595.44507, 1006.18237,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19787, -510.15253, 2594.11133, 1007.52283,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1811, -512.55878, 2595.44507, 1006.18237,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1811, -513.79260, 2592.65454, 1006.18237,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1811, -512.55878, 2592.65454, 1006.18237,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2232, -510.41223, 2589.74780, 1006.15881,   0.00000, 0.00000, -135.00000);
	CreateDynamicObject(1809, -510.47519, 2589.81519, 1006.72791,   0.00000, 0.00000, -135.00000);
	CreateDynamicObject(19567, -510.42249, 2589.22437, 1006.62543,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19581, -511.28073, 2587.15112, 1006.67352,   0.00000, 0.00000, -24.71996);
	CreateDynamicObject(19585, -512.08234, 2586.78320, 1006.84418,   0.00000, 0.00000, 74.94000);
	CreateDynamicObject(19582, -511.46674, 2586.71191, 1006.68951,   0.00000, 0.00000, 37.68000);
	CreateDynamicObject(2812, -512.77008, 2586.69043, 1006.62457,   0.00000, 0.00000, -12.30000);
	CreateDynamicObject(3034, -514.18500, 2586.36060, 1007.85059,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(14443, -524.20911, 2594.97827, 1009.88171,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2290, -517.88379, 2593.12329, 1006.00610,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19786, -514.40894, 2594.17725, 1007.58276,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2315, -514.91461, 2593.42554, 1005.94232,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2028, -514.96991, 2594.85229, 1006.52069,   0.00000, 0.00000, -73.62000);
	CreateDynamicObject(1783, -514.75610, 2594.21167, 1006.50873,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2827, -514.89954, 2593.41699, 1006.43781,   0.00000, 0.00000, 33.06001);
	CreateDynamicObject(2835, -517.06268, 2594.47827, 1006.00806,   0.00000, 0.00000, -63.18003);
	CreateDynamicObject(14482, -518.36292, 2588.28662, 1007.43958,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(16101, -529.38757, 2595.67871, 1008.80988,   90.00000, 0.00000, 90.00000);
	CreateDynamicObject(2257, -516.34320, 2595.87549, 1007.66510,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2260, -513.83649, 2589.99292, 1007.49152,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2261, -515.09650, 2590.01099, 1007.49152,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2262, -516.41650, 2589.99902, 1007.72693,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2263, -517.78650, 2590.01709, 1007.43457,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2264, -519.10852, 2590.02100, 1007.58270,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2265, -520.46649, 2590.02100, 1007.58270,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2266, -513.75970, 2592.90967, 1007.56580,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2270, -513.75970, 2594.51172, 1007.56580,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(14461, -512.37738, 2584.33960, 1007.74518,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18066, -522.17120, 2592.18359, 1008.09631,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2239, -514.73102, 2592.55518, 1005.97540,   0.00000, 0.00000, -114.06000);
	CreateDynamicObject(1961, -523.79547, 2593.03979, 1008.18549,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1960, -523.79547, 2594.07178, 1007.69568,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1962, -523.79547, 2595.05566, 1008.03528,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2251, -513.21545, 2594.14209, 1007.22083,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2204, -515.49109, 2589.59521, 1005.56830,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2811, -514.55231, 2589.85718, 1005.57727,   0.00000, 0.00000, 140.88002);
	CreateDynamicObject(948, -518.27472, 2589.79614, 1005.56158,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2084, -510.32816, 2592.21826, 1005.37213,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2250, -510.38681, 2592.89331, 1006.74139,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2247, -510.48181, 2591.85425, 1006.74139,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19807, -510.38229, 2592.61157, 1006.36652,   0.00000, 0.00000, -40.74000);
	CreateDynamicObject(2813, -510.11450, 2592.18018, 1006.29510,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19175, -518.38519, 2594.13232, 1007.94672,   0.00000, 0.00000, 90.00000);

	return true;
}