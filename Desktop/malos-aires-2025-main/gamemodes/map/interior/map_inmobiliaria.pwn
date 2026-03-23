#if defined _map_int_inmobiliaria_inc
	#endinput
#endif
#define _map_int_inmobiliaria_inc

#include <YSI_Coding\y_hooks>

hook LoadMaps() {
	Textura = CreateObject(18981, -400.00000, 760.00000, 1011.00000,   0.00000, 90.00000, 0.00000); //PISO
	SetObjectMaterial(Textura, 0, 18031, "cj_exp", "mp_furn_floor", -1);

	Textura = CreateDynamicObject(19445, -405.91690, 753.00000, 1013.24072,   0.00000, 0.00000, 0.00000); //PAREDES
	SetDynamicObjectMaterial(Textura, 0, 18031, "cj_exp", "mp_cloth_wall", -1);
	Textura = CreateDynamicObject(19445, -405.91690, 762.63397, 1013.24072,   0.00000, 0.00000, 0.00000); //PAREDES
	SetDynamicObjectMaterial(Textura, 0, 18031, "cj_exp", "mp_cloth_wall", -1);
	Textura = CreateDynamicObject(19445, -405.45889, 766.97601, 1013.24072,   0.00000, 0.00000, 90.00000); //PAREDES
	SetDynamicObjectMaterial(Textura, 0, 18031, "cj_exp", "mp_cloth_wall", -1);
	Textura = CreateDynamicObject(19445, -406.36292, 752.40833, 1013.24072,   0.00000, 0.00000, 90.00000); //PAREDES
	SetDynamicObjectMaterial(Textura, 0, 18031, "cj_exp", "mp_cloth_wall", -1);
	Textura = CreateDynamicObject(19445, -392.00000, 753.00000, 1013.24072,   0.00000, 0.00000, 0.00000); //PAREDES
	SetDynamicObjectMaterial(Textura, 0, 18031, "cj_exp", "mp_cloth_wall", -1);
	Textura = CreateDynamicObject(19445, -392.00000, 762.63397, 1013.24072,   0.00000, 0.00000, 0.00000); //PAREDES
	SetDynamicObjectMaterial(Textura, 0, 18031, "cj_exp", "mp_cloth_wall", -1);
	Textura = CreateDynamicObject(19445, -395.82489, 766.97595, 1013.24072,   0.00000, 0.00000, 90.00000); //PAREDES
	SetDynamicObjectMaterial(Textura, 0, 18031, "cj_exp", "mp_cloth_wall", -1);
	Textura = CreateDynamicObject(19445, -396.72919, 752.40833, 1013.24072,   0.00000, 0.00000, 90.00000); //PAREDES
	SetDynamicObjectMaterial(Textura, 0, 18031, "cj_exp", "mp_cloth_wall", -1);

	Textura = CreateDynamicObject(18856, -404.36749, 765.51160, 1010.82959,   0.00000, 180.00000, 0.00000); //PLATAFORMA
	SetDynamicObjectMaterial(Textura, 1, 18031, "cj_exp", "mp_furn_floor", -1);

	Textura = CreateDynamicObject(18980, -401.4037, 762.5519, 1023.9862,   0.00000, 0.00000, 0.00000); //COLUMNA
	SetDynamicObjectMaterial(Textura, 0, 14599, "paperchasebits", "ab_mottleGrey", -1);
	Textura = CreateDynamicObject(14407, -403.83710, 761.19891, 1009.14117,   0.00000, 0.00000, 180.00000); //ESCALERAS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(14407, -400.05130, 765.00043, 1009.14117,   0.00000, 0.00000, -90.00000); //ESCALERAS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(18981, -400.00000, 760.00000, 1015.44336,   0.00000, 90.00000, 0.00000); //TECHO
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "ab_hosWallUpr", -1);

	Textura = CreateDynamicObject(12921, -397.30759, 765.56390, 1014.37372,   0.00000, 0.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -397.30759, 766.62292, 1008.13397,   0.00000, 0.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -389.09421, 758.39728, 1008.13397,   0.00000, 0.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -394.93161, 765.56390, 1014.37372,   0.00000, 0.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -391.83191, 755.37567, 1008.13397,   0.00000, 0.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -397.36429, 762.54303, 1014.37372,   0.00000, 0.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -399.74631, 762.54303, 1014.37372,   0.00000, 0.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -399.74521, 747.45221, 1008.13397,   0.00000, 0.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -407.97879, 752.63263, 1008.13397,   0.00000, 0.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -405.68869, 760.86542, 1008.13397,   0.00000, 0.00000, -90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -389.09421, 758.39728, 1018.30762,   0.00000, 180.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -391.83191, 755.37567, 1018.30762,   0.00000, 180.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -399.74521, 747.45221, 1018.30762,   0.00000, 180.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -397.30759, 766.62292, 1018.30762,   0.00000, 180.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -407.97879, 752.63263, 1018.30762,   0.00000, 180.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -405.68869, 760.86542, 1018.30762,   0.00000, 180.00000, -90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -397.53519, 766.72980, 1018.30701,   0.00000, 180.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -391.53140, 752.63263, 1008.13397,   0.00000, 0.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -391.53140, 752.63263, 1018.30762,   0.00000, 180.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -397.53519, 766.72980, 1008.13397,   0.00000, 0.00000, 0.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -392.23349, 758.50647, 1008.13397,   0.00000, 0.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);
	Textura = CreateDynamicObject(12921, -392.23349, 758.50647, 1018.30701,   0.00000, 180.00000, 90.00000); //PALOS
	SetDynamicObjectMaterial(Textura, 0, 14594, "papaerchaseoffice", "cof_wood2", -1);


	Textura = CreateDynamicObject(2267, -392.12189, 756.83270, 1013.85291,   0.00000, 0.00000, -90.00000);
	SetDynamicObjectMaterial(Textura, 1, 14446, "carter_block", "zebra_skin", -1);//
	Textura = CreateDynamicObject(2267, -405.79709, 762.10217, 1014.01672,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 1, 14425, "madbedrooms", "AH_fancyceil", -1);//
	Textura = CreateDynamicObject(2267, -405.79709, 754.23682, 1014.01672,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 1, 14581, "ab_mafiasuitea", "ab_pic_bridge", -1);
	Textura = CreateDynamicObject(2267, -401.11151, 752.52362, 1013.66400,   0.00000, 0.00000, 180.00000);
	SetDynamicObjectMaterial(Textura, 1, 14640, "chinese_furn", "ab_tv_tricas1", -1);
	Textura = CreateDynamicObject(2261, -401.42181, 761.55078, 1013.45679,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 1, 14599, "paperchasebits", "ab_blueprint2", -1);
	Textura = CreateDynamicObject(2263, -400.40280, 762.53809, 1013.43597,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(Textura, 0, 14640, "paperchasebits", "ab_blueprint4", -1);
	CreateDynamicObject(2264, -400.74731, 766.38068, 1013.36340,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2265, -401.57471, 766.39069, 1013.89380,   0.00000, 0.00000, 0.00000);





	CreateDynamicObject(1649, -397.29391, 760.20831, 1013.04999,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(1649, -397.29391, 763.54132, 1013.04999,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(1649, -397.29391, 766.87433, 1013.04999,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(1649, -399.80981, 753.81482, 1013.04999,   0.00000, 90.00000, -90.00000);
	CreateDynamicObject(1649, -393.33939, 758.35571, 1013.04999,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1649, -395.56021, 755.36102, 1013.04999,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1649, -392.22821, 755.36102, 1013.04999,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(1649, -397.37390, 760.20831, 1013.04999,   0.00000, 90.00000, -90.00000);
	CreateDynamicObject(1649, -397.37390, 763.54132, 1013.04999,   0.00000, 90.00000, -90.00000);
	CreateDynamicObject(1649, -397.37390, 766.87433, 1013.04999,   0.00000, 90.00000, -90.00000);
	CreateDynamicObject(1649, -393.33939, 758.43573, 1013.04999,   0.00000, 90.00000, 180.00000);
	CreateDynamicObject(1649, -395.56021, 755.44098, 1013.04999,   0.00000, 90.00000, 180.00000);
	CreateDynamicObject(1649, -392.22821, 755.44098, 1013.04999,   0.00000, 90.00000, 180.00000);
	CreateDynamicObject(1649, -399.72980, 753.81482, 1013.04999,   0.00000, 90.00000, 90.00000);

	Textura = CreateDynamicObject(1761, -398.10089, 760.85309, 1011.47913,   0.00000, 0.00000, -90.00000); //SILLONES
	SetDynamicObjectMaterial(Textura, 0, 2166, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 1703, "cj_sofa", "CJ-COUCHL2", -1);
	Textura = CreateDynamicObject(1761, -398.10089, 764.75891, 1011.47913,   0.00000, 0.00000, -90.00000); //SILLONES
	SetDynamicObjectMaterial(Textura, 0, 2166, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 1703, "cj_sofa", "CJ-COUCHL2", -1);
	Textura = CreateDynamicObject(1761, -392.68271, 757.88190, 1011.48370,   0.00000, 0.00000, -90.00000); //SILLONES
	SetDynamicObjectMaterial(Textura, 0, 2166, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 1703, "cj_sofa", "CJ-COUCHL2", -1);
	Textura = CreateDynamicObject(1761, -400.49020, 755.01221, 1011.49170,   0.00000, 0.00000, -90.00000); //SILLONES
	SetDynamicObjectMaterial(Textura, 0, 2166, "cj_office", "CJ_WOOD5", -1);
	SetDynamicObjectMaterial(Textura, 1, 1703, "cj_sofa", "CJ-COUCHL2", -1);

	CreateDynamicObject(14599, -404.57770, 750.31750, 1014.21570,   0.00000, 0.00000, -90.00000); //ESCULTURA

	Textura = CreateDynamicObject(1742, -393.04501, 767.02844, 1011.46729,   0.00000, 0.00000, 0.00000); //BIBLIOTECAS
	SetDynamicObjectMaterial(Textura, 2, 2166, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(1742, -394.48169, 767.02838, 1011.46729,   0.00000, 0.00000, 0.00000); //BIBLIOTECAS
	SetDynamicObjectMaterial(Textura, 2, 2166, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(1742, -395.91611, 767.02838, 1011.46729,   0.00000, 0.00000, 0.00000); //BIBLIOTECAS
	SetDynamicObjectMaterial(Textura, 2, 2166, "cj_office", "CJ_WOOD5", -1);
	Textura = CreateDynamicObject(1742, -392.01041, 753.48450, 1011.46729,   0.00000, 0.00000, -90.00000); //BIBLIOTECAS
	SetDynamicObjectMaterial(Textura, 2, 2166, "cj_office", "CJ_WOOD5", -1);

	Textura = CreateDynamicObject(2184, -395.55261, 763.49542, 1011.49249,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(Textura, 1, 2166, "cj_office", "CJ_WOOD5", -1);

	CreateDynamicObject(1714, -394.43585, 765.72961, 1011.46588,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2002, -396.78845, 766.36633, 1011.48993,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14599, -405.67029, 760.30463, 1013.67731,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2169, -395.00125, 752.39874, 1011.49542,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19893, -394.84698, 752.98822, 1012.28168,   0.00000, 0.00000, 100.92000);
	CreateDynamicObject(2894, -395.09409, 753.47937, 1012.28021,   0.00000, 0.00000, 61.44000);
	CreateDynamicObject(2239, -392.43661, 754.40942, 1011.43433,   0.00000, 0.00000, -96.06010);
	CreateDynamicObject(1714, -393.52548, 752.87231, 1011.46588,   0.00000, 0.00000, -116.03999);
	CreateDynamicObject(2002, -396.92859, 754.66962, 1011.48993,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(948, -392.93741, 754.89941, 1011.48163,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2310, -396.29349, 752.89667, 1011.97736,   0.00000, 0.00000, 192.05986);
	CreateDynamicObject(2310, -395.70551, 762.25415, 1011.97742,   0.00000, 0.00000, -110.00000);
	CreateDynamicObject(2310, -393.48032, 762.25885, 1011.97742,   0.00000, 0.00000, -80.00000);
	CreateDynamicObject(3617, -413.60800, 759.72620, 1012.76898,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1823, -398.50800, 761.28552, 1011.48273,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2002, -401.43454, 761.46588, 1011.48993,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2239, -400.64578, 762.62122, 1011.43433,   0.00000, 0.00000, 84.77987);
	CreateDynamicObject(2186, -392.63300, 760.01160, 1011.43445,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2186, -398.22092, 752.92780, 1011.43439,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1569, -398.58640, 766.94281, 1011.49213,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1569, -402.35120, 752.44397, 1011.49213,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1569, -405.35162, 752.43829, 1011.49213,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2166, -405.33459, 759.53699, 1011.50348,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2166, -404.36191, 755.74463, 1011.50348,   0.00000, 0.00000, -180.00000);
	CreateDynamicObject(1714, -405.29495, 755.76129, 1011.46588,   0.00000, 0.00000, -277.08029);
	CreateDynamicObject(2310, -403.21948, 754.74841, 1011.97736,   0.00000, 0.00000, 337.37979);
	CreateDynamicObject(1714, -405.41422, 758.73718, 1011.46588,   0.00000, 0.00000, -272.28058);
	CreateDynamicObject(2310, -403.12805, 755.86914, 1011.97736,   0.00000, 0.00000, 356.87946);
	CreateDynamicObject(2310, -403.14200, 759.53632, 1011.97736,   0.00000, 0.00000, 373.49963);
	CreateDynamicObject(2310, -403.15506, 758.48798, 1011.97736,   0.00000, 0.00000, 362.63968);
	CreateDynamicObject(19893, -404.36206, 758.45233, 1012.28168,   0.00000, 0.00000, 245.58005);
	CreateDynamicObject(19893, -405.01715, 754.79578, 1012.28168,   0.00000, 0.00000, 208.32011);
	CreateDynamicObject(2816, -398.00818, 761.83307, 1011.98279,   0.00000, 0.00000, -145.25990);
	CreateDynamicObject(2824, -393.75146, 764.11328, 1012.26563,   0.00000, 0.00000, -123.90005);
	CreateDynamicObject(19893, -394.37796, 764.00177, 1012.28168,   0.00000, 0.00000, 184.20023);
	CreateDynamicObject(19807, -395.40778, 764.21729, 1012.32648,   0.00000, 0.00000, 139.68001);
	CreateDynamicObject(2854, -395.04379, 752.77777, 1012.26563,   0.00000, 0.00000, -188.09979);
	CreateDynamicObject(1302, -397.88318, 765.98993, 1011.46875,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(18010, -401.32730, 756.12109, 1014.90912,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18010, -394.12601, 756.92029, 1014.90912,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18010, -393.14322, 753.85150, 1014.90912,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18010, -385.72360, 764.75159, 1014.90912,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18010, -384.64560, 764.75159, 1014.90912,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18010, -383.56760, 764.75159, 1014.90912,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(18010, -382.48959, 764.75159, 1014.90912,   0.00000, 0.00000, 180.00000);
	return true;
}