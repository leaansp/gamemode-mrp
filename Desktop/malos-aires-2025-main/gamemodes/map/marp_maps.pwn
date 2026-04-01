#if defined _marp_maps_included
	#endinput
#endif
#define _marp_maps_included

#include <YSI_Coding\y_hooks>

new Textura; //variable a utilizar para almacenar la ide del objeto creado y posteriormente cambiar su textura

hook RemoveMapsBuildings(playerid) {
	//=======================PIZZERIA CERCA DE LICENCIAS========================

	RemoveBuildingForPlayer(playerid, 6073, 1003.8906, -1598.0391, 17.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 6036, 1003.8906, -1598.0391, 17.8438, 0.25);

	//====================TRANSFENDERS Y LUGARES DE TUNEO=======================

	RemoveBuildingForPlayer(playerid, 9093, 2386.6563, 1043.6016, 11.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 11313, -1935.8594, 239.5313, 35.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 5340, 2644.8594, -2039.2344, 14.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 5779, 1041.3516, -1025.9297, 32.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 10575, -2716.3516, 217.4766, 5.3828, 0.25);

	//========================BLOQUEO SALIDA FARO===============================

	RemoveBuildingForPlayer(playerid, 4504, 56.3828, -1531.4531, 6.7266, 0.25);

	//======================POSTE DE LUZ MANSION MAD DOG========================

	RemoveBuildingForPlayer(playerid, 1294, 1378.5938, -869.6953, 43.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1378.5938, -869.6953, 43.6250, 0.25);

	//============================TRANSPORTISTAS================================

	RemoveBuildingForPlayer(playerid, 3744, 2193.2578, -2286.2891, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 5305, 2198.8516, -2213.9219, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2234.3906, -2244.8281, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2226.9688, -2252.1406, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2219.4219, -2259.5234, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2212.0938, -2267.0703, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2204.6328, -2274.4141, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2165.0703, -2288.9688, 13.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2193.2578, -2286.2891, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2204.6328, -2274.4141, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2212.0938, -2267.0703, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2219.4219, -2259.5234, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2194.4766, -2242.8750, 13.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2226.9688, -2252.1406, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2234.3906, -2244.8281, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2235.1641, -2231.8516, 13.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 5244, 2198.8516, -2213.9219, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 13477, -21.9453, 101.3906, 4.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 12914, -75.1797, 12.1719, 3.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 672, -15.2109, 94.8438, 3.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -41.2500, 98.4141, 3.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -36.0156, 96.1875, 3.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 12913, -21.9453, 101.3906, 4.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -34.9297, 131.5469, 2.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -51.7188, 145.9609, 2.9531, 0.25);

	//========================CARTEL DEL EXTERIOR DE LSPD=======================

	RemoveBuildingForPlayer(playerid, 1266, 1538.5234, -1609.8047, 19.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 4229, 1597.9063, -1699.7500, 30.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 4230, 1597.9063, -1699.7500, 30.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1541.4531, -1709.6406, 13.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1547.5703, -1689.9844, 13.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1547.5703, -1661.0313, 13.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1541.4531, -1642.0313, 13.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 1260, 1538.5234, -1609.8047, 19.8438, 0.25);

    //===========================BOLICHE VERONA BEACH===========================

	RemoveBuildingForPlayer(playerid, 6076, 836.5859, -1743.2969, 19.6094, 0.25);
//	RemoveBuildingForPlayer(playerid, 6098, 836.5859, -1743.2969, 19.6094, 0.25);

	//=========================REJA TAPABOMBA DE UNITY==========================

	RemoveBuildingForPlayer(playerid, 5043, 1843.3672, -1856.3203, 13.8750, 0.25);


	return true;
}

hook LoadMaps() {
	print("[INFO] Iniciando carga de mapeos...");

	//==============================REJA TAPABOMBA DE UNITY=========================
	Textura = CreateObject(19325, 1843.19100, -1856.32996, 14.44000, 0.00000, 0.00000, 0.00000);
	SetObjectMaterial(Textura, 0, 6282, "beafron2_law2", "LoadingDoorClean", 0xFFFFFFFF);

//=================================ESTACIONAMIENTO PUBLICO======================
	CreateDynamicObject(994, 1377.013671875, -1659.703125, 12.546875, 0, 0, 90);
	CreateDynamicObject(997, 1376.9912109375, -1663.0107421875, 12.53639793396, 0, 0, 90);
	CreateDynamicObject(994, 1378.8916015625, -1669.0771484375, 12.546875, 0, 0, 107.86376953125);
	CreateDynamicObject(994, 1379.3250732422, -1675.4213867188, 12.546875, 0, 0, 93.998931884766);
	CreateDynamicObject(997, 1379.5831298828, -1678.9580078125, 12.53639793396, 0, 0, 93.75);
	CreateDynamicObject(994, 1377.78515625, -1652.7060546875, 12.546875, 0, 0, 0);
	CreateDynamicObject(994, 1384.1164550781, -1652.6926269531, 12.546875, 0, 0, 0);
	CreateDynamicObject(994, 1390.4899902344, -1652.6882324219, 12.546875, 0, 0, 0);
	CreateDynamicObject(994, 1396.8488769531, -1652.6896972656, 12.546875, 0, 0, 0);
	CreateDynamicObject(994, 1403.2501220703, -1652.6815185547, 12.546875, 0, 0, 0);
	CreateDynamicObject(994, 1409.6002197266, -1652.6804199219, 12.546875, 0, 0, 0);
	CreateDynamicObject(997, 1368.73828125, -1673.5234375, 12.53639793396, 0, 0, 81.83642578125);
	CreateDynamicObject(997, 1369.203125, -1670.251953125, 12.53639793396, 0, 0, 80.826416015625);
	CreateDynamicObject(997, 1369.7890625, -1666.9638671875, 12.53639793396, 0, 0, 114.57092285156);
	CreateDynamicObject(997, 1368.3968505859, -1663.904296875, 12.53639793396, 0, 0, 168.16577148438);
	CreateDynamicObject(997, 1365.1944580078, -1663.2689208984, 12.53639793396, 0, 0, 180.07214355469);
	CreateDynamicObject(997, 1361.7891845703, -1663.2750244141, 12.53639793396, 0, 0, 180.07141113281);
	CreateDynamicObject(997, 1376.9970703125, -1644.11328125, 12.3828125, 0, 0, 359.80773925781);
	CreateDynamicObject(994, 1376.9591064453, -1643.9116210938, 12.546875, 0, 0, 90);
	CreateDynamicObject(994, 1376.9436035156, -1637.5939941406, 12.546875, 0, 0, 90);
	CreateDynamicObject(994, 1370.58203125, -1631.35546875, 12.546875, 0, 0, 0);
	CreateDynamicObject(994, 1364.208984375, -1631.369140625, 12.546875, 0, 0, 0);
	CreateDynamicObject(994, 1357.80078125, -1631.3671875, 12.546875, 0, 0, 0);
	CreateDynamicObject(10183, 1364.5498046875, -1642.4228515625, 12.394755363464, 0, 0, 135.20874023438);
	CreateDynamicObject(8406, 1357.3173828125, -1650.06640625, 20, 0, 0, 90.247192382813);
	CreateDynamicObject(967, 1416.8515625, -1653.9541015625, 12.546875, 0, 0, 89.923095703125);
	CreateDynamicObject(1294, 1375.4072265625, -1632.791015625, 16.900936126709, 0, 0, 39.995727539063);
	CreateDynamicObject(1294, 1362.8255615234, -1663.0451660156, 16.900936126709, 0, 0, 219.99572753906);
	CreateDynamicObject(1294, 1362.8251953125, -1632.791015625, 16.900936126709, 0, 0, 127.99072265625);
	CreateDynamicObject(1294, 1376.794921875, -1655.1083984375, 16.900936126709, 0, 0, 39.995727539063);
	CreateDynamicObject(1294, 1378.712890625, -1669.927734375, 16.900936126709, 0, 0, 39.995727539063);
	CreateDynamicObject(1294, 1373.2962646484, -1700.0479736328, 16.900936126709, 0, 0, 323.99572753906);
	CreateDynamicObject(1294, 1368.7213134766, -1684.6470947266, 16.900936126709, 0, 0, 123.99026489258);
	CreateDynamicObject(3091, 1367.2252197266, -1696.8881835938, 8.5870733261108, 0, 0, 304);
	CreateDynamicObject(3091, 1369.5506591797, -1700.6794433594, 8.6833829879761, 0, 0, 303.99719238281);

//=============================BLOQUEOS PAYNSPRAY===============================
	CreateDynamicObject(985, 720.66430664063, -462.59594726563, 15.60000038147, 0, 0, 180);
	CreateDynamicObject(985, -1420.7413330078, 2591.1958007813, 55, 0, 0, 0);
	CreateDynamicObject(985, -100.21936035156, 1111.3374023438, 19.39999961853, 0, 0, 0);
	CreateDynamicObject(985, 2071.5534667969, -1830.9703369141, 13.382800102234, 0, 0, 270);
	CreateDynamicObject(985, -2425.8344726563, 1028.1407470703, 50.390598297119, 0, 0, 0);
	CreateDynamicObject(985, 1968.4382324219, 2161.9348144531, 10.820300102234, 0, 0, 90);
	CreateDynamicObject(985, 488.38320922852, -1734.6398925781, 11.245200157166, 0, 0, 352);
	CreateDynamicObject(985, 1024.3717041016, -1029.4647216797, 31.529300689697, 0, 0, 0);
	CreateDynamicObject(985, 2394.212890625, 1483.556640625, 10.671899795532, 0, 0, 180);
	CreateDynamicObject(985, -1904.1252441406, 277.83969116211, 41.039100646973, 0, 0, 180);

//=================================JAIL OOC=====================================
	CreateDynamicObject(18856, 1411.23, -2.94, 1001.44, 0.00, 0.00, 0.00);

	//====================PIZERIA CERCA DE LICENCIAS============================
	CreateDynamicObject(6959, 1007.40070, -1602.20544, 12.56320,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 450.0);
	CreateDynamicObject(6959, 966.06000, -1602.20544, 12.56320,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 450.0);
	CreateDynamicObject(13361, 1002.72766, -1597.23315, 19.41589,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1432, 1011.13721, -1592.10083, 12.64789,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(1432, 1007.28241, -1592.38062, 12.64789,   0.00000, 0.00000, 16.08001);
	CreateDynamicObject(1432, 1004.36969, -1589.73694, 12.64789,   0.00000, 0.00000, 16.08001);
	CreateDynamicObject(1432, 992.62061, -1592.07483, 12.64789,   0.00000, 0.00000, 16.08001);
	CreateDynamicObject(1432, 985.90503, -1592.10730, 12.64789,   0.00000, 0.00000, 73.85999);
	CreateDynamicObject(1432, 989.81860, -1589.49512, 12.64789,   0.00000, 0.00000, 69.48000);
	CreateDynamicObject(1522, 997.84497, -1594.47876, 12.52770,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1432, 1016.73486, -1596.11426, 12.64789,   0.00000, 0.00000, 69.71999);
	CreateDynamicObject(1432, 1016.53247, -1601.20410, 12.64789,   0.00000, 0.00000, 95.10001);
	CreateDynamicObject(1232, 1002.63928, -1587.64722, 15.1654,   0.00000, 0.00000, -59.10001);
	CreateDynamicObject(1232, 993.47845, -1587.57739, 15.1654,   0.00000, 0.00000, -120.54001);
	CreateDynamicObject(3460, 1000.33081, -1595.02063, 11.68558,   0.00000, 0.00000, 0.00000);

	//=========================BOLICHE FRENTE A LA PLAYA============================
	Textura = CreateDynamicObject(6098, 836.58588, -1743.29688, 19.60940, 0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 450.0);
	SetDynamicObjectMaterial(Textura, 0, 2369, "shopping_acc", "CJ_Black_metal", 0xFFF3F3F3);
	SetDynamicObjectMaterial(Textura, 1, 6205, "lawartg", "luxorwall01_128", 0xFFDCDCD6);
	SetDynamicObjectMaterial(Textura, 4, 7308, "vgnshopnmall", "gaulle_3", -1);

	//===========================REJAS VARIAS ALCANTARILLAS=====================
	CreateDynamicObject(982, 1845.49561, -1826.07666, 13.53940,   0.00000, 0.00000, 73.50000);
	CreateDynamicObject(982, 1870.06055, -1833.34875, 13.51840,   0.00000, 0.00000, 73.50000);
	CreateDynamicObject(984, 1888.47339, -1838.82764, 13.47640,   0.00000, 0.00000, 73.50000);
	CreateDynamicObject(984, 1900.85034, -1842.05566, 13.45540,   0.00000, 0.00000, 77.28000);
	CreateDynamicObject(982, 1919.57397, -1846.37793, 13.51840,   0.00000, 0.00000, 76.86000);
	CreateDynamicObject(982, 1939.83777, -1851.09863, 13.51840,   0.00000, 0.00000, 76.92000);
	CreateDynamicObject(982, 1845.65393, -1804.50366, 13.23230,   0.00000, 0.00000, 76.44000);
	CreateDynamicObject(982, 1870.53931, -1810.55164, 13.23230,   0.00000, 0.00000, 76.26000);
	CreateDynamicObject(982, 1889.18591, -1815.10510, 13.23230,   0.00000, 0.00000, 76.38600);
	CreateDynamicObject(982, 1914.28967, -1820.08789, 13.23230,   0.00000, 0.00000, 81.15900);
	CreateDynamicObject(982, 1939.42383, -1824.89441, 13.23230,   0.00000, 0.00000, 77.15399);
	CreateDynamicObject(8674, 1359.35083, -1722.04907, 14.12250,   0.00000, 0.00000, -0.18000);
	CreateDynamicObject(8674, 1580.06714, -1751.69104, 14.17542,   0.00000, 0.00000, 89.70000);
	CreateDynamicObject(8674, 1580.05396, -1756.83020, 14.17540,   0.00000, 0.00000, 89.70000);
	CreateDynamicObject(8674, 1401.76355, -1450.53418, 14.10530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8674, 1368.08850, -1573.83899, 14.15828,   0.00000, 0.00000, -16.20000);
	CreateDynamicObject(8674, 1362.92053, -1592.47131, 14.25727,   0.00000, 0.00000, -16.20000);

		
	return true;
}

#include "map\marp_fixed_maps.pwn"

//INTERIORES - Los comentados son interiores viejos, quedan al margen por cualquier bug o problema que pueda surgir con los nuevos.



#include "map\interior\map_hosp_interior.pwn"
#include "map\interior\map_hotel_market.pwn"
#include "map\interior\map_banco_central.pwn"
#include "map\interior\map_casino_interior.pwn"
#include "map\interior\map_tmma_oficina_interior.pwn"
#include "map\interior\map_pma_sala_entrenamiento.pwn"
#include "map\interior\map_carcel.pwn"
#include "map\interior\map_depto_careta_brac.pwn"
#include "map\interior\map_restaurant.pwn"
#include "map\interior\map_antro_bar_boliche.pwn"
#include "map\interior\map_pasillo_merca.pwn"
#include "map\interior\map_casa_villera_1.pwn"
#include "map\interior\map_casa_villera_2.pwn"
#include "map\interior\map_ferreteria_interior.pwn"
#include "map\interior\map_monoblock_seville.pwn"
#include "map\interior\map_fix_casa_canion.pwn"
#include "map\interior\map_bar_motoquero.pwn"
#include "map\interior\map_oficina.pwn"
#include "map\interior\map_bar_vintage.pwn"
#include "map\interior\map_comisaria_dos.pwn"
#include "map\interior\map_inmobiliaria.pwn"
#include "map\interior\map_shop_electro.pwn"
#include "map\interior\map_depto_chico.pwn"
#include "map\interior\map_bar_cafe.pwn"
#include "map\interior\map_casa_chica.pwn"
#include "map\interior\map_shop_almacen.pwn"
#include "map\interior\map_armeria_ilegal.pwn"
#include "map\interior\map_fight_club.pwn"
#include "map\interior\map_gym_rustico.pwn"
#include "map\interior\map_club_strip.pwn"
#include "map\interior\map_club_strip_2.pwn"
#include "map\interior\map_juzgado.pwn"
#include "map\interior\map_casa_chica_9.pwn"
#include "map\interior\map_shop_deporte.pwn"
#include "map\interior\map_shop_ypf.pwn"
#include "map\interior\map_ask_room.pwn"
#include "map\interior\map_fix_mafia_suite.pwn"
#include "map\interior\map_empty_houses.pwn"
#include "map\interior\map_hospital.pwn"
#include "map\interior\map_shop_barrio.pwn"
#include "map\interior\map_monoblock_dos_pisos.pwn"
#include "map\interior\map_garages.pwn"
#include "map\interior\map_comisaria_quince.pwn"
#include "map\interior\map_comisaria_garaje.pwn"
#include "map\interior\map_estretiro.pwn"
#include "map\interior\map_esttorre_bracmercer.pwn"
#include "map\interior\map_acema_interior.pwn"
#include "map\interior\map_talleres_interiores.pwn"
#include "map\interior\map_hospital_boedo.pwn"
//#include "map\interior\map_deptos_brac_2022.pwn" //Deshabilitado hasta q Rawnker lo optimice
#include "map\interior\map_monoblockFA_interior.pwn"
#include "map\interior\map_barrioSom_interiores.pwn"
#include "map\interior\map_prision2022.pwn"
//#include "map\interior\map_estadio_interior.pwn"
#include "map\interior\map_gen_unidad_barrial.pwn"
#include "map\interior\map_genbase_interior.pwn"
#include "map\interior\map_garitabanco_int.pwn"
#include "map\interior\map_247_chino.pwn"
#include "map\interior\map_HQPurple.pwn"

//EXTERIORES      
#include "map\exterior\map_ctr_exterior.pwn"
#include "map\exterior\map_villa_huevo.pwn"
#include "map\exterior\map_ayuntamiento.pwn"
#include "map\exterior\map_verona_beach.pwn"
#include "map\exterior\map_aeropuerto.pwn"
//#include "map\exterior\map_casinos_exterior.pwn"
#include "map\exterior\map_canchas_futbol.pwn"
#include "map\exterior\map_estaciones_servicio.pwn"
#include "map\exterior\map_concesionarias.pwn"
#include "map\exterior\map_basurero.pwn"
#include "map\exterior\map_casa_rosada.pwn"
#include "map\exterior\map_comisaria_east.pwn"
#include "map\exterior\map_fabrica_norte.pwn"
#include "map\exterior\map_desarmadero_willow.pwn"
#include "map\exterior\map_tropicana.pwn"
#include "map\exterior\map_karting_track.pwn"
#include "map\exterior\map_traffic.pwn"
#include "map\exterior\map_plaza_fierro.pwn"
#include "map\exterior\map_alquileres_idlewood.pwn"
#include "map\exterior\map_golden_palms_colinas.pwn"
#include "map\exterior\map_ciruja_via_unity.pwn"
#include "map\exterior\map_ciruja_via_fierro.pwn"
#include "map\exterior\map_ciruja_binco.pwn"
#include "map\exterior\map_empresa_camiones.pwn"
#include "map\exterior\map_bloques_seville.pwn"
#include "map\exterior\map_unity_station_texture.pwn"
#include "map\exterior\map_villa_triple_9rem.pwn"
#include "map\exterior\map_casas_east_santos.pwn"
#include "map\exterior\map_comisaria_quince_ext.pwn"
#include "map\exterior\map_academia_pfa.pwn"
#include "map\exterior\map_donorione.pwn"
#include "map\exterior\map_fuerte_apache2022.pwn"
#include "map\exterior\map_obelisco.pwn"
#include "map\exterior\map_villa_fierro2022.pwn"
#include "map\exterior\map_prision_federal2022.pwn"
#include "map\exterior\map_barrio_som.pwn"
#include "map\exterior\map_tmma2022.pwn"
//#include "map\exterior\map_shopping.pwn"
#include "map\exterior\map_plaza_sanroque.pwn"
//#include "map\exterior\map_claypole.pwn"
#include "map\exterior\map_base_gendarmeria.pwn"
#include "map\exterior\map_gen_upb_exterior.pwn"
#include "map\exterior\map_glenpark.pwn"
#include "map\exterior\map_peajes.pwn"
#include "map\exterior\map_metrobus.pwn"
#include "map\exterior\map_avenidaammu.pwn"
#include "map\exterior\map_plazamarket.pwn"
#include "map\exterior\map_hospital_market.pwn"
#include "map\exterior\map_taxisunity.pwn"
#include "map\exterior\map_busjobterminal.pwn"
#include "map\exterior\map_busstop.pwn"
#include "map\exterior\map_licencias.pwn"
#include "map\exterior\map_ecobici.pwn"
#include "map\exterior\map_garitabanco_ext.pwn"
#include "map\exterior\map_cloacas.pwn"
#include "map\exterior\map_bomberos.pwn"
#include "map\exterior\map_callestierra.pwn"
#include "map\exterior\map_exterior_vtv.pwn"
#include "map\exterior\map_concesionaria_motos.pwn"
#include "map\exterior\map_concesionaria_pinar.pwn"
#include "map\exterior\map_concesionaria_camiones.pwn"
#include "map\exterior\map_concesionaria_barcos.pwn"
#include "map\exterior\map_lomas_burro.pwn"
#include "map\exterior\map_cruce_corona.pwn"
#include "map\exterior\map_cruce_gna.pwn"
#include "map\exterior\map_HQFenrir.pwn"
#include "map\exterior\map_picodromo.pwn"
 
#include <YSI_Coding\y_hooks>

forward LoadMaps();
public LoadMaps() {
	print("[INFO] Carga de mapeos finalizada.");
	return true;
}

forward RemoveMapsBuildings(playerid);
public RemoveMapsBuildings(playerid) {
	return true;
}

CMD:streameritemsdata(playerid, params[]) {
	if(!PlayerInfo[playerid][pAdmin])
		return false;

	SendFMessage(playerid, -1, "SAMP CreateObject %i", GetObjectCount());
	SendFMessage(playerid, -1, "Streamer_CountVisibleItems STREAMER_TYPE_OBJECT %i", Streamer_CountVisibleItems(playerid, STREAMER_TYPE_OBJECT, .serverwide = 1));
	SendFMessage(playerid, -1, "Streamer_CountItems STREAMER_TYPE_OBJECT %i", Streamer_CountItems(STREAMER_TYPE_OBJECT, .serverwide = 1));
	SendFMessage(playerid, -1, "Streamer_GetVisibleItems STREAMER_TYPE_OBJECT %i", Streamer_GetVisibleItems(STREAMER_TYPE_OBJECT, .playerid = -1));
	return true;
}

hook OnGameModeInitEnded() {
    new gateid;

	gateid = Gate_Create(980, 
	 			1534.54236, -1451.39893, 14.45500, 0.00000, 0.00000, 0.00000,
				1545.50000, -1451.39893, 14.45500, 0.00000, 0.00000, 0.00000,
				.worldid = -1, .speed = 2.0, .type = GATE_TYPE_FACTION, .extraid = FAC_GOB, .autoCloseTime = 6000);

	Gate_SetVehicleDetection(gateid, 1534.54236, -1451.39893, 14.45500, .size = 8.0);

	Gate_SetTexture(gateid, 0, 16644, "a51_detailstuff", "roucghstonebrtb");
	Gate_SetTexture(gateid, 1, 16644, "a51_detailstuff", "roucghstonebrtb");
	Gate_SetTexture(gateid, 3, 16644, "a51_detailstuff", "roucghstonebrtb");
	Gate_SetTexture(gateid, 5, 16644, "a51_detailstuff", "roucghstonebrtb");

	return true;
}