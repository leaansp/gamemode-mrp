#if defined _map_barrioSom_interiores_inc
	#endinput
#endif
#define _map_barrioSom_interiores_inc

#include <YSI_Coding\y_hooks>

/*	Si es un interior, completar esto y dejarlo comentado. la POS y el ANGLE tiene q ser el lugar de entrada,
	con el pj mirando hacia la puerta para definir el angulo.

  		  Nombre   Descripcion	PosX	PosY	PosZ	Angle	Int		Tags				
		{"Nombre","Descripcion",0.000, 0.000, 0.000, 	0.0,	0,		(TAG_UNO | TAG_DOS...)}

*/


hook LoadMaps() {

	//__________________________________________________PLANTA ALTA BARRIO SOM___________________________________________________________
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19456, 6.955698, 2000.246948, 2001.692993, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.147218, 1995.499023, 2001.692993, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.136508, 2004.985229, 2001.692993, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -4.796236, 2000.304931, 2001.692993, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.382040, 1995.495361, 2001.692993, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.447659, 2004.983032, 2001.692993, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 1.742339, 2000.235107, 1999.841674, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 5.182343, 2000.234130, 2003.312988, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, 6.820997, 2000.246582, 2001.739257, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, 6.706663, 2003.517944, 2001.739257, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.087638, 2003.231323, 2001.692993, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19391, -0.332513, 2001.698486, 2001.697143, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.227646, 2000.031250, 2001.692993, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19391, 0.527486, 2000.017456, 2001.697143, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.062339, 1995.271118, 2001.692993, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 3.743762, 2007.425781, 1999.171752, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19403, 5.260786, 2001.652465, 2001.647338, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 5.222342, 2000.235107, 1999.841674, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -1.747660, 2000.235107, 1999.841674, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.237656, 2000.235107, 1999.841674, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	tmpobjid = CreateDynamicObject(19355, 5.276173, 2004.949462, 2000.247802, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19355, 6.926187, 2004.499267, 2000.247802, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19355, -4.763815, 2001.687011, 2001.708862, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19355, -3.613811, 2001.687011, 1998.437133, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19355, -5.293813, 2001.626953, 1999.868530, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.227645, 2000.061279, 2001.713012, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19391, -0.352512, 2001.698486, 2001.697143, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.087637, 2003.221313, 2001.713012, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 1.692342, 2000.234130, 2003.312988, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -1.767657, 2000.234130, 2003.312988, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.247654, 2000.234130, 2003.312988, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, -1.599002, 1995.634277, 2001.739257, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18200, "w_town2cs_t", "inwindow1128", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(3061, -4.640450, 2004.608886, 2001.116455, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2160, 5.373285, 2004.736572, 1999.935791, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2159, 6.723527, 2005.140258, 1999.935791, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2159, 6.723527, 2003.759643, 1999.935791, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1502, -0.274423, 2000.936035, 1999.927612, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1502, 1.275575, 2000.025390, 1999.927612, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(14494, -4.134964, 2001.398315, 2001.949340, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2514, -2.982290, 2002.635498, 1999.927612, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2518, -2.454494, 2002.626220, 1999.927612, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 

	//_____________________________________________PASILLO BARRIO SOM__________________________________________________________________________
	tmpobjid = CreateDynamicObject(19456, 0.488806, 1797.316406, 1998.470703, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.071201, 1796.075317, 2002.033447, 180.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.751207, 1800.965698, 2003.664428, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14570, "traidaqua", "sa_wood06_128", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -6.401215, 1800.593750, 2002.021850, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -6.401215, 1810.214843, 2002.011840, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -4.101198, 1796.184936, 1996.759399, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18038, "vegas_munation", "mp_gun_floorred", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, -5.531317, 1796.247070, 2001.983642, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3601, "hillhousex4_5", "inwindow1", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, -6.241294, 1799.297119, 2001.993652, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3601, "hillhousex4_5", "inwindow1", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, -6.221294, 1808.440063, 2001.993652, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3601, "hillhousex4_5", "inwindow1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -4.101198, 1794.483764, 1998.620849, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 0.778792, 1799.224975, 1998.500732, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(13011, -0.833392, 1796.732299, 1996.865112, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.421205, 1796.075317, 1998.540771, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -4.101202, 1802.045166, 2001.991821, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -4.101202, 1811.675537, 2001.991821, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -3.991203, 1791.171752, 1998.620849, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 0.778810, 1797.316406, 2001.952514, 180.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 0.778792, 1799.224975, 2001.943359, 180.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -4.101198, 1794.283569, 2000.352539, 0.000000, 90.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14570, "traidaqua", "sa_wood06_128", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 4.548793, 1796.075317, 2002.033447, 180.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -2.111212, 1815.032348, 2002.001831, 180.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12964, "sw_block09", "sjmbwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.881209, 1800.965698, 2000.262573, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18038, "vegas_munation", "mp_gun_floorred", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.881209, 1810.585205, 2000.261230, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18038, "vegas_munation", "mp_gun_floorred", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -5.751207, 1810.586425, 2003.664428, 0.000000, 90.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14570, "traidaqua", "sa_wood06_128", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -2.281208, 1800.967163, 2003.664428, 0.000000, 90.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14570, "traidaqua", "sa_wood06_128", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 1.208791, 1800.967163, 2003.664428, 0.000000, 90.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 14570, "traidaqua", "sa_wood06_128", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -1.228417, 1797.906860, 1996.497558, 50.199966, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	tmpobjid = CreateDynamicObject(18663, -6.290931, 1805.013061, 2001.177368, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 11013, "crackdrive_sfse", "ws_carskidmarks", 0x00000000);
	tmpobjid = CreateDynamicObject(18663, -3.880924, 1795.011596, 1998.547973, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 5390, "glenpark7_lae", "ganggraf01_LA", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(2671, -5.344200, 1801.382446, 2000.348510, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3061, 0.617043, 1794.727416, 1997.996459, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3061, -4.150456, 1804.680053, 2001.469360, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3061, -4.130455, 1814.743164, 2001.469360, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2674, -5.229513, 1806.852172, 2000.387207, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(913, -4.573656, 1810.090332, 2001.176635, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2671, -2.295952, 1794.983764, 1996.910278, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1440, -2.409934, 1795.239013, 1997.328247, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 

	//______________________________________________PLANTA BAJA BARRIO SOM__________________________________________________________________
	tmpobjid = CreateDynamicObject(19456, 2.216207, 1603.217407, 2000.529296, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19428, -5.793835, 1600.352783, 1995.620971, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.216207, 1599.746215, 2000.529296, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, 6.844008, 1597.434814, 1998.897583, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13059, "ce_fact03", "sw_garwind", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, 6.794011, 1602.648681, 1998.837524, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13059, "ce_fact03", "sw_garwind", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, 5.534016, 1604.868652, 1998.977661, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13059, "ce_fact03", "sw_garwind", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, 1.744012, 1604.808593, 1998.907592, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13059, "ce_fact03", "sw_garwind", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, -1.895985, 1604.808593, 1998.907592, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13059, "ce_fact03", "sw_garwind", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, -5.035987, 1604.838623, 1998.907592, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13059, "ce_fact03", "sw_garwind", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, 4.194013, 1596.106689, 1998.907592, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13059, "ce_fact03", "sw_garwind", 0x00000000);
	tmpobjid = CreateDynamicObject(2733, -6.785970, 1598.197631, 1998.907592, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13059, "ce_fact03", "sw_garwind", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -6.993846, 1600.095825, 1998.878173, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.156208, 1595.967651, 1998.878173, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 6.976170, 1600.095825, 1998.838134, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19428, -5.793835, 1601.023437, 1995.620971, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -6.843772, 1601.847656, 1998.868164, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -6.893782, 1599.495971, 1998.677978, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4595, "crparkgm_lan2", "gm_LAcarpark2", 0x00000000);
	tmpobjid = CreateDynamicObject(19394, -2.100800, 1600.312988, 1998.878173, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 9514, "711_sfw", "rebrckwall_128", 0x00000000);
	tmpobjid = CreateDynamicObject(19394, -0.400802, 1598.801879, 1998.878173, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19394, 2.799194, 1598.801879, 1998.878173, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 9.186226, 1598.796752, 1998.878173, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 0.466248, 1594.045776, 1998.677978, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 9.386247, 1601.828125, 1996.486206, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19403, 3.466209, 1603.365844, 1998.883911, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.156208, 1604.998413, 1998.838134, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.503796, 1604.998413, 1998.828125, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.463779, 1595.967651, 1998.878173, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "hilcouwall1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19428, -7.473844, 1601.033447, 1997.042114, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19428, -7.473844, 1600.352783, 1997.042114, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19428, -6.973840, 1600.352783, 1998.803344, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19428, -6.983839, 1601.023437, 1998.803344, 0.000000, 180.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -6.893782, 1599.515991, 1998.597900, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19394, -2.140799, 1600.302978, 1998.878173, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 9514, "711_sfw", "rebrckwall_128", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -6.843772, 1601.827636, 1998.868164, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19371, 6.539577, 1604.982421, 1997.097167, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19371, 6.909584, 1603.360961, 1997.097167, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12853, "cunte_gas01", "sw_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.086209, 1603.217407, 1997.016967, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.176208, 1599.718627, 1997.016967, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.136209, 1596.226196, 1997.016967, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.483796, 1596.226196, 1997.016967, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.433795, 1599.716918, 1997.016967, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.543797, 1603.219848, 1997.016967, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13724, "docg01_lahills", "ab_tile2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2.216207, 1596.285766, 2000.529296, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.363789, 1596.285766, 2000.529296, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.363789, 1599.776367, 2000.529296, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, -7.363789, 1603.257202, 2000.529296, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4835, "airoads_las", "concretenewb256", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 14668, "711c", "forumstand1_LAe", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(3061, 6.863179, 1600.644042, 1998.267700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(3061, -6.946823, 1602.435546, 1998.267700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1502, -2.055439, 1599.550170, 1997.126708, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1502, 0.364578, 1598.807128, 1997.126708, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2160, 5.421358, 1604.804443, 1997.077148, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2159, 6.787479, 1605.196289, 1997.057128, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2159, 6.788959, 1603.830932, 1997.047119, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(1502, 2.024529, 1598.819091, 1997.126708, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(14494, -6.289000, 1600.612548, 1999.173950, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2518, -4.549220, 1601.173217, 1997.312011, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(2514, -5.035490, 1601.234130, 1997.282348, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 



	return true;
}