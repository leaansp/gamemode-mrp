#if defined _marp_interiors_list_inc
	#endinput
#endif
#define _marp_interiors_list_inc

//__________________________________CONFIG__________________________________

#define INT_MAX_NAME_LENGTH 32
#define INT_MAX_DESC_LENGTH 64
#define INT_MAX_DLG_LINES_TO_SHOW 18 // Para no tener que scrollear, lo máximo que muestran los dialogs nativos de SA:MP es 20 (menos 2 de Volver/Siguiente)

//________________________________DONT CHANGE_______________________________

#define INT_MAX_DLG_LENGTH 4096
#define INT_MAX_DLG_LINE_LENGTH (INT_MAX_NAME_LENGTH+INT_MAX_DESC_LENGTH+7) // name + desc + 'id_' + '\t' + '\n'
#define INT_MAX_DLG_LINES ((INT_MAX_DLG_LENGTH-48)/INT_MAX_DLG_LINE_LENGTH) // - "Nombre\tDescripción\n<<< Anterior\nSiguiente >>>"

#if (INT_MAX_DLG_LINES_TO_SHOW > INT_MAX_DLG_LINES)
	#warning Cantidad de lineas a mostrar no puede superar el máximo permitido
#endif

//___________________________________DATA___________________________________

static enum e_INTERIOR_INFO {
	iName[INT_MAX_NAME_LENGTH],
	iDesc[INT_MAX_DESC_LENGTH],
	Float:iX,
	Float:iY,
	Float:iZ,
	Float:iAngle,
	iInt,
	e_INTERIOR_TAGS:iTags
};

static enum e_INTERIOR_TAGS(<<= 1) {
	TAG_MUYCHICO=1,	TAG_CHICO,		TAG_MEDIANO,	TAG_GRANDE,	TAG_GIGANTE,
	TAG_CASA,		TAG_NEGOCIO,	TAG_EDIFICIO,	TAG_HQ,		TAG_TIENDA,
	TAG_RESTO,		TAG_BAR,		TAG_247,		TAG_BANCO,	TAG_POLICIA,
	TAG_HOSPITAL,	TAG_FERRETERIA,	TAG_ESTADIO,	TAG_HOTEL,	TAG_MONOAMBIENTE,
	TAG_SERVICIOS,	TAG_OFICINAS,	TAG_FABRICA,	TAG_GYM,	TAG_MAPPING,
	TAG_DOSPISOS,	TAG_PELUQUERIA,	TAG_ROPA,		TAG_AMMU,	TAG_CASINO,
	TAG_CLUB,		TAG_GARAJE
}

static enum e_INTERIOR_TAGS_DATA {
	e_INTERIOR_TAGS:it_flag,
	it_name[20]
}

static const INTERIOR_TAGS_DATA[][e_INTERIOR_TAGS_DATA] = {
	{TAG_MUYCHICO, "TAG_MUYCHICO"},
	{TAG_CHICO, "TAG_CHICO"},
	{TAG_MEDIANO, "TAG_MEDIANO"},
	{TAG_GRANDE, "TAG_GRANDE"},
	{TAG_GIGANTE, "TAG_GIGANTE"},
	{TAG_CASA, "TAG_CASA"},
	{TAG_NEGOCIO, "TAG_NEGOCIO"},
	{TAG_EDIFICIO, "TAG_EDIFICIO"},
	{TAG_HQ, "TAG_HQ"},
	{TAG_TIENDA, "TAG_TIENDA"},
	{TAG_RESTO, "TAG_RESTO"},
	{TAG_BAR, "TAG_BAR"},
	{TAG_247, "TAG_247"},
	{TAG_BANCO, "TAG_BANCO"},
	{TAG_POLICIA, "TAG_POLICIA"},
	{TAG_HOSPITAL, "TAG_HOSPITAL"},
	{TAG_FERRETERIA, "TAG_FERRETERIA"},
	{TAG_ESTADIO, "TAG_ESTADIO"},
	{TAG_MONOAMBIENTE, "TAG_MONOAMBIENTE"},
	{TAG_SERVICIOS, "TAG_SERVICIOS"},
	{TAG_OFICINAS, "TAG_OFICINAS"},
	{TAG_FABRICA, "TAG_FABRICA"},
	{TAG_HOTEL, "TAG_HOTEL"},
	{TAG_MAPPING, "TAG_MAPPING"},
	{TAG_DOSPISOS, "TAG_DOSPISOS"},
	{TAG_PELUQUERIA, "TAG_PELUQUERIA"},
	{TAG_ROPA, "TAG_ROPA"},
	{TAG_GYM, "TAG_GYM"},
	{TAG_CASINO, "TAG_CASINO"},
	{TAG_AMMU, "TAG_AMMU"},
	{TAG_CLUB, "TAG_CLUB"},
	{TAG_GARAJE, "TAG_GARAJE"}
};

static const ServerInteriors[][e_INTERIOR_INFO] = {
//		Nombre								Descripcion															PosX	PosY	PosZ	Angle				Int		Tags				
/*00*/	{"Nombre",							"Descripcion",														0.000, 0.000, 0.000, 0.0, 					0, 	e_INTERIOR_TAGS:0},
/*01*/	{"Gym Ganton",						"Chico, 2 rings", 													772.21, -4.61, 1000.70, 0.0, 				5, 	(TAG_NEGOCIO | TAG_GYM | TAG_CHICO | TAG_MEDIANO)},
/*02*/	{"Hotel Rosa",						"Chico, con bar y escenario", 										974.94, -8.58, 1001.18, 90.0, 				3, 	(TAG_EDIFICIO | TAG_HOTEL | TAG_NEGOCIO | TAG_CHICO | TAG_MEDIANO)},
/*03*/	{"Hotel 2",							"Chico, 4 habitaciones y Jacuzzi", 									964.65, -53.19, 1001.13, 90.0, 				3, 	(TAG_EDIFICIO | TAG_HOTEL | TAG_NEGOCIO | TAG_CHICO | TAG_MEDIANO)},
/*04*/	{"Oficina de apuestas",				"Oficina de apuestas de Woozie", 									834.25, 7.32, 1004.19, 90.0, 				3, 	(TAG_EDIFICIO | TAG_NEGOCIO | TAG_TIENDA | TAG_MUYCHICO | TAG_CHICO | TAG_OFICINAS | TAG_SERVICIOS)},
/*05*/	{"Oficina Records",					"Pequeño con poco mobiliario",										1039.65, -0.67, 1001.28, 90.0, 				3, 	(TAG_EDIFICIO | TAG_NEGOCIO | TAG_OFICINAS | TAG_CHICO | TAG_MUYCHICO)},
/*06*/	{"Cabaret 1",						"Pequeño, con 2 pistas de baile", 									1212.14, -26.47, 1000.95, 180.00, 			3, 	(TAG_EDIFICIO | TAG_NEGOCIO | TAG_HOTEL | TAG_CHICO)},
/*07*/	{"Galpon 1",						"Grande, estilo deposito con varios portones", 						1309.72, 3.74, 1002.40, 90.00, 				18, (TAG_EDIFICIO | TAG_GRANDE | TAG_FABRICA)},
/*08*/	{"Galpon 2",						"Grande, sin uso y sin techo", 										1419.8701, 3.7397, 1002.4200, 90.00, 		1, 	(TAG_EDIFICIO | TAG_GRANDE | TAG_MEDIANO | TAG_FABRICA)},
/*09*/	{"Monoambiente 1 Sucio",			"Sucio, chico y oscuro", 											1529.9778, -13.6701, 1002.09, 0.00, 		3, 	(TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*10*/	{"Monoambiente 2 Lindo",			"Sala de estar cuadrada, con sillon y television", 					1527.4165, -48.0774, 1002.1105, 90.00, 		2, 	(TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*11*/	{"Casa chica OG Loc",				"Chica, con equipo de DJ", 											520.7251, -9.1145, 1001.5800, 90.00, 		3, 	(TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*12*/	{"Peluqueria 1",					"Chica, luminosa y prolija", 										418.6541, -84.3202, 1001.8002, 0.00, 		3, 	(TAG_NEGOCIO | TAG_PELUQUERIA | TAG_CHICO | TAG_MUYCHICO | TAG_TIENDA)},
/*13*/	{"Planning Dpt.",					"Original del GTA:SA. Enorme. Varios pisos", 						389.9549, 173.8189, 1008.4008, 90.00, 		3, 	(TAG_EDIFICIO | TAG_GRANDE | TAG_GIGANTE | TAG_HQ | TAG_SERVICIOS | TAG_DOSPISOS)},
/*14*/	{"[M]Policia Malos Aires",			"(NO USAR)", 														238.7357, 139.0853, 1003.0291, 0.00, 		3, 	(TAG_EDIFICIO | TAG_GRANDE | TAG_GIGANTE | TAG_POLICIA | TAG_HQ | TAG_SERVICIOS)},
/*15*/	{"Ropa Pro-Laps",					"Mediano, estilo deportivo", 										207.2047, -140.0915, 1003.5175, 0.00, 		3, 	(TAG_NEGOCIO | TAG_TIENDA | TAG_ROPA | TAG_MEDIANO | TAG_CHICO)},
/*16*/	{"Sex Shop",						"Original GTA:SA, mediano",											-100.3956, -24.7697, 1000.7315, 0.00, 		3, 	(TAG_NEGOCIO | TAG_TIENDA | TAG_MEDIANO)},
/*17*/	{"Salon Tattoo",					"Sala de tatuajes", 												-204.3715, -44.1342, 1002.3048, 0.00, 		3, 	(TAG_NEGOCIO | TAG_CHICO | TAG_MUYCHICO)},
/*18*/	{"24/7 grande 1",					"Grande", 															-25.9467, -187.6093, 1003.5643, 0.00, 		17, (TAG_NEGOCIO | TAG_TIENDA | TAG_247 | TAG_GRANDE)},
/*19*/	{"Resto chico 1",					"Estilo cafeteria", 												458.9277, -111.0812, 999.5453, 0.00, 		5, 	(TAG_NEGOCIO | TAG_RESTO | TAG_BAR | TAG_CHICO | TAG_MUYCHICO)},
/*20*/	{"Pizzeria Idle",					"Original GTA:SA. Mediana",											372.3227, -133.3751, 1001.5038, 0.00, 		5, 	(TAG_NEGOCIO | TAG_RESTO | TAG_MEDIANO | TAG_CHICO)},
/*21*/	{"Resto Donuts",					"Estilo cafeteria", 												377.1342, -192.9989, 1000.6400, 0.00, 		17, (TAG_NEGOCIO | TAG_RESTO | TAG_MEDIANO | TAG_CHICO)},
/*22*/	{"Armeria grande 1",				"Grande, de 2 pisos", 												315.7964, -143.3963, 999.6108, 0.00, 		7, 	(TAG_NEGOCIO | TAG_AMMU | TAG_GRANDE | TAG_DOSPISOS)},
/*23*/	{"Ropa Victim",						"Mediana, de calidad", 												227.0508, -8.3646, 1002.2202, 90.00, 		5, 	(TAG_NEGOCIO | TAG_TIENDA | TAG_ROPA | TAG_CHICO)},
/*24*/	{"[M]HQ SIDE",						"Basado en interior de Policia SF. Enorme, muchas habitaciones",	246.3873, 108.1393, 1003.2212, 0.00, 		10, (TAG_EDIFICIO | TAG_POLICIA  | TAG_GIGANTE | TAG_GRANDE | TAG_HQ | TAG_SERVICIOS | TAG_DOSPISOS)},
/*25*/	{"24/7 grande 2",					"Grande", 															6.0930, -31.1454, 1003.5630, 0.00, 			10, (TAG_NEGOCIO | TAG_TIENDA | TAG_247 | TAG_GRANDE)},
/*26*/	{"Gym LV",							"chico, 1 ring", 													773.9100, -78.5618, 1000.6590, 0.00, 		7, 	(TAG_NEGOCIO | TAG_GYM | TAG_CHICO)},
/*27*/	{"Resto chico 2",					"Pintoresco, con patio cerrado", 									453.0605, -18.2261, 1001.1388, 90.00, 		1, 	(TAG_NEGOCIO | TAG_RESTO | TAG_BAR | TAG_CHICO | TAG_MEDIANO)},
/*28*/	{"Armeria mediana 1",				"Mediana", 															285.4289, -41.3258, 1001.5127, 0.00, 		1, 	(TAG_NEGOCIO | TAG_AMMU | TAG_MEDIANO)},
/*29*/	{"Ropa Suburban",					"Chico, estilo urbano", 											203.8014, -50.2754, 1001.8487, 0.00, 		1, 	(TAG_NEGOCIO | TAG_TIENDA | TAG_ROPA | TAG_CHICO | TAG_MEDIANO)},
/*30*/	{"Habitacion 1",					"Chica, sucia", 													243.8669, 304.9016, 999.1604, 270.00, 		1, 	(TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*31*/	{"Granero Kyle",					"Original GTA:SA. Chico", 											293.1952, 309.9422, 999.1604, 90.00, 		3, 	(TAG_CASA | TAG_EDIFICIO | TAG_CHICO | TAG_MUYCHICO | TAG_DOSPISOS)},
/*32*/	{"Policia Chica",					"Original GTA:SA. Sin uso", 										322.1985, 302.3954, 999.1568, 0.00, 		5, 	(TAG_EDIFICIO | TAG_POLICIA | TAG_HQ | TAG_SERVICIOS | TAG_CHICO)},
/*33*/	{"Estadio Bowl",					"Original GTA:SA. Bug", 											-1415.0392, 21.2922, 1041.5343, 0.00, 		1, 	(TAG_EDIFICIO | TAG_ESTADIO | TAG_GRANDE | TAG_GIGANTE)},
/*34*/	{"Estadio Eight Track",				"Ideal para carreras. Mision de carrera Hotring", 					-1405.3026, -260.4494, 1043.6676, 351.00, 	7, 	(TAG_EDIFICIO | TAG_ESTADIO | TAG_GRANDE | TAG_GIGANTE)},
/*35*/	{"Pig Pen",							"Cabaret grande", 													1204.8309, -13.6056, 1000.9267, 0.00, 		2, 	(TAG_NEGOCIO | TAG_HOTEL | TAG_EDIFICIO | TAG_GRANDE)},
/*36*/	{"Casino 4 Dragons",				"Original GTA:SA. grande", 											2018.8287, 1017.9037, 996.8762, 90.00, 		10, (TAG_NEGOCIO | TAG_GRANDE | TAG_CASINO | TAG_GIGANTE)},
/*37*/	{"Casa mediana Ryder",				"Mediana. Living, cocina, baño", 									2468.3232, -1698.2595, 1013.5409, 90.00, 	2, 	(TAG_CASA | TAG_MEDIANO | TAG_GRANDE)},
/*38*/	{"Casa mediana Sweet",				"Mediana. 1 habitacion, cocina, comedor, baño", 					2524.5388, -1679.3506, 1015.4941, 270.00, 	1, 	(TAG_CASA | TAG_MEDIANO)},
/*39*/	{"Campo RC",						"Campo grande de combate RC", 										-1052.3308, 1099.7179, 1343.1096, 180.00, 	10, (TAG_EDIFICIO | TAG_GRANDE | TAG_POLICIA | TAG_HQ | TAG_SERVICIOS)},
/*40*/	{"Casa grande CJ",					"Original GTA:SA. Grande, 2 pisos", 								2495.9363, -1692.2682, 1014.7517, 180.00, 	3, 	(TAG_CASA | TAG_GRANDE | TAG_DOSPISOS)},
/*41*/	{"Burger Shot",						"Original GTA:SA. Mediano", 										363.1019, -75.0694, 1001.5327, 315.00, 		10, (TAG_NEGOCIO | TAG_RESTO | TAG_MEDIANO | TAG_BAR)},
/*42*/	{"Casino Caligula",					"Original GTA:SA. Enorme", 											2233.8694, 1714.4656, 1012.3792, 180.00, 	1, 	(TAG_NEGOCIO | TAG_CASINO | TAG_GRANDE)},
/*43*/	{"Habitación 2",					"Chica, muy luminosa", 												266.7310, 304.9392, 999.1638, 270.00, 		2, 	(TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*44*/	{"Peluqueria 2",					"Mediana", 															411.6674, -22.7692, 1001.8120, 0.00, 		2, 	(TAG_NEGOCIO | TAG_CHICO | TAG_MUYCHICO | TAG_MEDIANO)},
/*45*/	{"Casa rodante",					"Chica, bien amoblada", 											1.8014, -3.1568, 999.5142, 90.00, 			2, 	(TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*46*/	{"24/7 grande 3",					"Grande y cuadrado",												-31.0231, -91.6403, 1003.5605, 0.00, 		18, (TAG_NEGOCIO | TAG_TIENDA | TAG_247 | TAG_GRANDE)},
/*47*/	{"Ropa Zip",						"Grande, de calidad", 												161.4063, -96.5118, 1001.8493, 0.00, 		18, (TAG_NEGOCIO | TAG_TIENDA | TAG_ROPA | TAG_MEDIANO | TAG_GRANDE)},
/*48*/	{"Club Pl. Domes",					"Enorme, varios pisos.", 											-2636.6494, 1402.7452, 906.4791, 0.00, 		3, 	(TAG_NEGOCIO | TAG_CLUB | TAG_BAR | TAG_GRANDE | TAG_GIGANTE | TAG_DOSPISOS)},
/*49*/	{"Mansion Madd",					"Original GTA:SA. Gigante", 										1261.4380, -785.4536, 1091.9102, 270.00, 	5, 	(TAG_CASA | TAG_GRANDE | TAG_GIGANTE | TAG_DOSPISOS)},
/*50*/	{"Crack Palace B.S",				"Original GTA:SA. Gigante", 										2541.6389, -1304.0529, 1025.0845, 270.00, 	2, 	(TAG_EDIFICIO | TAG_GRANDE | TAG_DOSPISOS | TAG_GIGANTE | TAG_HQ)},
/*51*/	{"Casa incendio",					"De mision. 2 pisos. Bug", 											2352.4492, -1180.9203, 1027.9719, 90.00, 	5, 	(TAG_CASA | TAG_MEDIANO | TAG_DOSPISOS)},
/*52*/	{"Dpto Wu-zi-mu",					"Chica. Pasillo, y living-comedor", 								-2170.3198, 639.2894, 1052.3829, 180.00, 	1, 	(TAG_CASA | TAG_CHICO | TAG_MUYCHICO | TAG_MONOAMBIENTE)},
/*53*/	{"Monoambiente 3 Sucio",			"Chico y descuidado", 												422.1588, 2536.5698, 10.0028, 90.00, 		10, (TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*54*/	{"Cambiador GTA",					"Original GTA:SA. Muy chico", 										254.4666, -41.5954, 1002.0363, 270.00, 		14, (TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*55*/	{"Ropa Did. Sachs",					"Mediana, muy elegante", 											204.3011, -168.7544, 1000.5459, 0.00, 		14, (TAG_NEGOCIO | TAG_TIENDA | TAG_ROPA | TAG_CHICO | TAG_MEDIANO)},
/*56*/	{"Casino S/N",						"Mediano y modesto", 												1133.1091, -15.0731, 1000.6964, 0.00, 		12, (TAG_NEGOCIO | TAG_CASINO | TAG_MEDIANO)},
/*57*/	{"Estadio Cross",					"Mision de Stunt con Motocross", 									-1464.6306, 1556.2800, 1052.5574, 0.00, 	14, (TAG_EDIFICIO | TAG_ESTADIO | TAG_GRANDE | TAG_GIGANTE)},
/*58*/	{"Club Alhambra",					"Original GTA:SA. Grande", 											493.4646, -24.6414, 1000.6997, 0.00, 		17, (TAG_NEGOCIO | TAG_CLUB | TAG_BAR | TAG_GRANDE | TAG_DOSPISOS)},
/*59*/	{"Atrium LS",						"Original GTA:SA. Mision", 											1726.9672, -1638.5774, 20.2373, 180.00, 	18, (TAG_EDIFICIO | TAG_DOSPISOS | TAG_GRANDE | TAG_GIGANTE | TAG_SERVICIOS)},
/*60*/	{"Habitacion 3",					"De hotel. Luminosa", 												2233.7556, -1115.0404, 1050.8777, 0.00, 	5, 	(TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*61*/	{"Casa Mediana 1",					"3 habitaciones, living, cocina/comedor, baño", 					2196.7109, -1204.3798, 1049.0378, 90.00, 	6, 	(TAG_CASA | TAG_MEDIANO | TAG_DOSPISOS)},
/*62*/	{"Casa Grande 1",					"2 pisos, 1 habitacion, 2living, cocina/comedor y baño", 			2317.8132, -1026.6815, 1050.2144, 0.00, 	9, 	(TAG_CASA | TAG_MEDIANO | TAG_GRANDE | TAG_DOSPISOS)},
/*63*/	{"Habitacion Hotel",				"Desprolija. 2 camas con baño", 									2259.5039, -1135.8936, 1050.6407, 270.00, 	10, (TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO | TAG_HOTEL)},
/*64*/	{"Central electrica",				"Original GTA:SA. Con 5 generadores", 								-959.6284, 1955.1801, 9.0033, 180.00, 		17, (TAG_EDIFICIO | TAG_GRANDE | TAG_GIGANTE | TAG_SERVICIOS | TAG_FABRICA | TAG_HQ)},
/*65*/	{"24/7 grande 4",					"Grande rectancular, muy blanco", 									-25.9346, -141.3467, 1003.5412, 0.00, 		16, (TAG_NEGOCIO | TAG_GRANDE | TAG_TIENDA | TAG_247)},
/*66*/	{"Hotel Jefferson",					"Original GTA:SA. Enorme, dos pisos y muchas habitaciones", 		2215.0347, -1150.5554, 1025.8090, 270.00, 	15, (TAG_EDIFICIO | TAG_DOSPISOS | TAG_GRANDE | TAG_GIGANTE | TAG_HOTEL)},
/*67*/	{"Jet de mision",					"Original GTA:SA. De la mision.", 									3.3423, 23.1134, 1199.6064, 90.00, 			1, 	(TAG_EDIFICIO | TAG_CHICO)},
/*68*/	{"Bar Welcome Pump",				"Original GTA:SA. Chico, estilo de motero", 						681.4095, -451.2346, -25.6095, 180.00, 		1, 	(TAG_NEGOCIO | TAG_BAR | TAG_CHICO)},
/*69*/	{"Casa grande 2",					"2 pisos, 2 habitaciones, 2 living, cocina y baño", 				235.2933, 1186.8483, 1080.2782, 0.00, 		3, 	(TAG_CASA | TAG_GRANDE | TAG_DOSPISOS)},
/*70*/	{"Casa mediana 2",					"Oscura, living, cocina y habitacion", 								225.9748, 1239.9778, 1082.1826, 90.00, 		2, 	(TAG_CASA | TAG_MEDIANO)},
/*71*/	{"Casa chica 1",					"Living, cocina, baño y habitacion. Estilo dpto",					223.1224, 1287.1857, 1082.1481, 0.00, 		1, 	(TAG_CASA | TAG_CHICO)},
/*72*/	{"Casa muy grande 1",				"Dos pisos, 3 habitaciones, 2 baños, cocina, living, comedor",		226.6097, 1114.2683, 1080.9854, 270.00, 	5, 	(TAG_CASA | TAG_GRANDE | TAG_GIGANTE | TAG_DOSPISOS)},
/*73*/	{"Ropa Binco",						"Mediano, tipo estandar", 											207.7297, -110.6961, 1005.1569, 0.00, 		15, (TAG_NEGOCIO | TAG_CHICO | TAG_MEDIANO | TAG_ROPA | TAG_TIENDA)},
/*74*/	{"Casa mediana 3",					"Estandar. Pasillo, living, comedor, cocina, baño y habitacion", 	295.0848, 1472.3938, 1080.2736, 0.00, 		15, (TAG_CASA | TAG_MEDIANO)},
/*75*/	{"Estadio Derby",					"Grande e ideal para demolition Derby", 							-1367.2147, 932.3317, 1036.3369, 270.00, 	15, (TAG_EDIFICIO | TAG_GRANDE | TAG_GIGANTE | TAG_ESTADIO)},
/*76*/	{"Monoambiente 4 Oscuro",			"Estilo habitacion de motel. Oscura y sucia", 						446.6256, 506.9976, 1001.4393, 0.00, 		12, (TAG_CASA | TAG_CHICO | TAG_MONOAMBIENTE)},
/*77*/	{"Banco Palomino",					"Original GTA:SA. Chico", 											2305.3662, -16.0640, 26.7593, 270.00, 		0, 	(TAG_EDIFICIO | TAG_SERVICIOS | TAG_BANCO)},
/*78*/	{"Restaurant Palomino",				"Original GTA:SA. Chico. BUG", 										2333.1948, 6.2651, 26.4756, 90.00, 			0, 	(TAG_NEGOCIO | TAG_BAR | TAG_RESTO | TAG_CHICO)},
/*79*/	{"Tienda Gas Station Dillimore",	"Original GTA:SA. Chica, BUG. ", 									662.5134, -573.3748, 16.3471, 270.00, 		0, 	(TAG_NEGOCIO | TAG_TIENDA | TAG_CHICO)},
/*80*/	{"Bar UFO Lil Probe Inn",			"Original GTA:SA. Chico, con pool, estilo ruta.", 					-228.9795, 1401.2047, 27.8051, 270.00, 		18, (TAG_NEGOCIO |TAG_BAR | TAG_RESTO | TAG_CHICO)},
/*81*/	{"Rancho de Toreno",				"Exterior, sin uso", 												-688.1941, 942.7937, 13.6596, 180.00, 		0, 	(TAG_CASA | TAG_CHICO)},
/*82*/	{"Licoreria Blueberry",				"Chico, sin uso y BUG", 											254.4944, -60.8333, 1.5854, 0.00, 			0, 	(TAG_NEGOCIO | TAG_TIENDA | TAG_CHICO)},
/*83*/	{"Casa mediana 4",					"Estandar. pasillo, cocina, comedor, living, baño y habitacion", 	447.0369, 1397.2445, 1084.3042, 0.00, 		2, 	(TAG_CASA | TAG_MEDIANO)},
/*84*/	{"Casa mediana 5",					"Garito original GTA:SA. Living, cocina/comedor, 2 habiaciones", 	318.6104, 1114.6663, 1083.8933, 0.00, 		5, 	(TAG_CASA | TAG_MEDIANO | TAG_HQ)},
/*85*/	{"Casa mediana 6",					"1 habitacion, cocina, comedor, living y baño", 					260.9974, 1284.5479, 1080.2645, 0.00, 		4, 	(TAG_CASA | TAG_MEDIANO)},
/*86*/	{"Armeria mediana 2",				"Forma en L, tamaño normal", 										285.8632, -86.4381, 1001.5519, 0.00, 		4, 	(TAG_NEGOCIO | TAG_AMMU | TAG_MEDIANO)},
/*87*/	{"Cafeteria Jays Dinner",			"Original GTA:SA. mediana, estilo suburbana", 						460.0225, -88.5965, 999.5768, 90.00, 		4, 	(TAG_NEGOCIO | TAG_BAR | TAG_RESTO | TAG_MEDIANO)},
/*88*/	{"24/7 mediano 1",					"Rectangular estirado", 											-27.3796, -31.2794, 1003.5690, 0.00, 		4, 	(TAG_NEGOCIO | TAG_MEDIANO | TAG_247 | TAG_TIENDA)},
/*89*/	{"Casa chica 2",					"Original GTA:SA. Estilo campestre, con sotano.", 					300.2447, 310.8411, 1003.3053, 270.00, 		4, 	(TAG_CASA | TAG_CHICO | TAG_MEDIANO | TAG_DOSPISOS)},
/*90*/	{"Casa mediana 7",					"Elegante. 2 pisos, living comedor habitacion y baño", 				23.8629, 1340.3345, 1084.3993, 0.00, 		10, (TAG_CASA | TAG_MEDIANO | TAG_DOSPISOS)},
/*91*/	{"Matadero Sindacco",				"Original GTA:SA. Estilo fabrica de carnes", 						964.6194, 2107.8513, 1011.0499, 90.00, 		1, 	(TAG_EDIFICIO | TAG_NEGOCIO | TAG_FABRICA | TAG_GRANDE | TAG_GIGANTE)},
/*92*/	{"Casa chica 3",					"Desprolija, pasillo con cocina living y habitacion", 				222.0446, 1140.6156, 1082.6235, 0.00, 		4, 	(TAG_CASA | TAG_CHICO)},
/*93*/	{"Casa lujosa 1",					"No tan grande, dos pisos, 2 habitaciones, sala de estar", 			2324.3711, -1149.2927, 1050.7261, 0.00, 	12, (TAG_CASA | TAG_MEDIANO | TAG_GRANDE)},
/*94*/	{"Habitacion sadomasoquista",		"Original GTA:SA. Desprolija y con elementos sucios", 				43.8741, 304.9199, 999.1641, 270.00, 		6, 	(TAG_CASA | TAG_CHICO | TAG_MONOAMBIENTE)},
/*95*/	{"Peluqueria 3",					"Muy elegante, cuadrada y mediana", 								411.9159, -54.1573, 1001.9000, 0.00, 		12, (TAG_NEGOCIO | TAG_CHICO | TAG_MEDIANO | TAG_PELUQUERIA)},
/*96*/	{"Estadio circuito Motocross",		"Grande, ideal para carreras de Cross", 							-1425.8673, -749.9901, 1054.1436, 0.00, 	4, 	(TAG_EDIFICIO | TAG_GRANDE | TAG_ESTADIO)},
/*97*/	{"Gym Cobra oriental",				"Grande y elegante, con plataforma de artes marciales.", 			774.0718, -50.0305, 1000.5831, 0.00, 		6, 	(TAG_NEGOCIO | TAG_GYM | TAG_GRANDE | TAG_MEDIANO)},
/*98*/	{"Policia Los Santos",				"Original GTA:SA. Grande, en desuso", 								246.7055, 62.6305, 1003.6398, 0.00, 		6, 	(TAG_EDIFICIO | TAG_GRANDE | TAG_GIGANTE | TAG_POLICIA | TAG_SERVICIOS | TAG_HQ)},
/*99*/	{"Aeropuerto",						"Original GTA:SA. Sin uso BUG", 									-1861.7881, 71.4621, 1055.2064, 180.00, 	14, (TAG_EDIFICIO | TAG_GRANDE | TAG_SERVICIOS)},
/*100*/	{"Casa mediana 8",					"Dos pisos, cocina comedor y habitacion", 							-260.7771, 1456.7365, 1084.3867, 90.00, 	4, 	(TAG_CASA | TAG_MEDIANO | TAG_DOSPISOS)},
/*101*/	{"Casa mediana 9",					"Habitacion, comedor, cocina, living y baño", 						22.8962, 1403.4512, 1084.4446, 0.00, 		5, 	(TAG_CASA | TAG_MEDIANO)},
/*102*/	{"Casa lujosa 2",					"Dos pisos. 3 habitaciones, baño, living, comedor y cocina", 		140.3567, 1366.2723, 1083.8929, 0.00, 		5, 	(TAG_CASA | TAG_GRANDE | TAG_GIGANTE | TAG_DOSPISOS)},
/*103*/	{"Escuela de manejo 1",				"De bicis, pequeña", 												1494.4392, 1304.0074, 1093.2852, 0.00, 		3, 	(TAG_EDIFICIO | TAG_CHICO | TAG_SERVICIOS)},
/*104*/	{"Frente Aeropuerto",				"Fondo del viejo tutorial. BUG", 									-1862.9500, -22.8050, 1061.1462, 180.00, 	14, (TAG_EDIFICIO | TAG_GRANDE | TAG_SERVICIOS)},
/*105*/	{"Estadio Vice City",				"Oval con plataforma. No usar BUG", 								-1403.3889, 1246.2078, 1039.8937, 0.00, 	16, (TAG_EDIFICIO | TAG_GRANDE | TAG_GIGANTE | TAG_ESTADIO)},
/*106*/	{"Casa lujosa 3",					"Mini mansion, grande dos pisos muchas habitaciones", 				234.2164, 1063.9656, 1084.2476, 0.00, 		6, 	(TAG_CASA | TAG_GRANDE | TAG_GIGANTE | TAG_DOSPISOS)},
/*107*/	{"Casa chica 4",					"Casi monoambiente, con arcada y baño aparte", 						-68.8491, 1351.7454, 1080.2373, 0.00, 		6, 	(TAG_CASA | TAG_CHICO | TAG_MONOAMBIENTE)},
/*108*/	{"Tienda RC Zero",					"Original GTA:SA. Mediana y bien decorada. Apta ferreteria", 		-2240.6479, 137.1694, 1035.4323, 270.00, 	6, 	(TAG_NEGOCIO | TAG_MEDIANO | TAG_CHICO | TAG_TIENDA | TAG_FERRETERIA)},
/*109*/	{"Armeria chica 1",					"Chica sin campo de tiro. estilo de pueblo", 						296.8825, -112.0445, 1001.5281, 0.00, 		6, 	(TAG_NEGOCIO | TAG_CHICO | TAG_MEDIANO | TAG_AMMU)},
/*110*/	{"Armeria chica 2",					"Con campo de tiro, estilo unico Camo", 							316.4580, -169.3983, 999.6172, 0.00, 		6, 	(TAG_NEGOCIO | TAG_CHICO | TAG_MEDIANO | TAG_AMMU)},
/*111*/	{"Casa mediana 10",					"Dos pisos, horrible muy brillosa", 								-283.6807, 1471.1401, 1084.4115, 90.00, 	15, (TAG_CASA | TAG_MEDIANO | TAG_DOSPISOS)},
/*112*/	{"24/7 mediano 2",					"Rectancular clasico", 												-27.3908, -57.9239, 1003.5776, 0.00, 		6, 	(TAG_NEGOCIO | TAG_MEDIANO | TAG_TIENDA | TAG_247)},
/*113*/	{"Cafeteria Secret Valley",			"Chica y alargada, sin mucho detalle",								441.4216, -49.8946, 999.6884, 180.00, 		6, 	(TAG_NEGOCIO | TAG_CHICO | TAG_BAR | TAG_RESTO)},
/*114*/	{"Oficina Lujosa",					"Original GTA:SA. Detallado, BUG.", 								2189.4500, 1621.3069, 1043.4242, 0.00, 		2, 	(TAG_EDIFICIO | TAG_CHICO | TAG_OFICINAS | TAG_MONOAMBIENTE)},
/*115*/	{"Cabaret sucio",					"Mediano. Bizarro, con bar y habitaciones", 						759.4459, 1443.4492, 1102.7111, 180.00, 	6, 	(TAG_NEGOCIO | TAG_TIENDA | TAG_HOTEL | TAG_MEDIANO | TAG_BAR | TAG_RESTO)},
/*116*/	{"Casa mediana 11",					"Dos pisos, living, cocina/comedor y habitacion", 					2807.6035, -1173.9915, 1025.6133, 0.00, 	8, 	(TAG_CASA | TAG_MEDIANO | TAG_DOSPISOS)},
/*117*/	{"Cluckin Bell",					"Original GTA:SA. Mediano, estilo cafeteria.", 						364.8832, -11.4173, 1001.8441, 0.00, 		9, 	(TAG_NEGOCIO | TAG_BAR | TAG_RESTO | TAG_MEDIANO)},
/*118*/	{"Habitacion 4",					"De hotel, bien decorada con 2 camas", 								2218.0242, -1076.2656, 1050.5177, 90.00, 	1, 	(TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO | TAG_HOTEL)},
/*119*/	{"Pasillo de hotel",				"De calidad, con varias puertas y dos escaleras", 					2266.2942, 1647.5225, 1084.2479, 270.00, 	1, 	(TAG_EDIFICIO | TAG_HOTEL | TAG_CHICO)},
/*120*/	{"Casa chica 5",					"Dos ambientes, con living habitacion y baño",						2237.5469, -1081.5465, 1049.0406, 0.00, 	2, 	(TAG_CASA | TAG_CHICO | TAG_MONOAMBIENTE | TAG_HOTEL)},
/*121*/	{"Escuela de manejo 2",				"De vehiculos, con pequeño pasillo,", 								-2026.9684, -103.8296, 1035.1738, 180.00, 	3, 	(TAG_EDIFICIO | TAG_CHICO | TAG_SERVICIOS)},
/*122*/	{"Casa mediana 12",					"Dos habitaciones, living, cocina comedor y baño", 					2365.2725, -1135.3914, 1050.8687, 0.00, 	8, 	(TAG_CASA | TAG_MEDIANO)},
/*123*/	{"Avion Andromeda",					"Original GTA:SA. Oscuro y con caida libre", 						315.9605, 973.7593, 1961.5200, 0.00, 		9, 	(TAG_EDIFICIO | TAG_MEDIANO | TAG_GRANDE)},
/*124*/	{"Bar Green Bottles",				"Original GTA:SA. Pool, escenario y estilo antro", 					501.8402, -67.7361, 998.7622, 180.00, 		11, (TAG_NEGOCIO | TAG_BAR | TAG_RESTO | TAG_MEDIANO)},
/*125*/	{"Casa chica 6",					"Oscura, con living, cocina y baño", 								-42.5854, 1405.5811, 1084.4458, 0.00, 		8,	(TAG_CASA | TAG_CHICO | TAG_MONOAMBIENTE)},
/*126*/	{"Monoambiente 5",					"Con cocina y baño separado, luminoso", 							2282.9751, -1140.0856, 1050.9100, 0.00, 	11, (TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*127*/	{"Casa mediana 12",					"Dos pisos, 2 habitaciones, cocina, comedor, baño y living", 		83.1112, 1322.4015, 1083.8682, 0.00, 		9, 	(TAG_CASA | TAG_MEDIANO | TAG_DOSPISOS)},
/*128*/	{"Casa mediana 13",					"Living, cocina comedor, baño y una habitacion", 					260.8201, 1237.5092, 1084.2766, 0.00, 		9,	(TAG_CASA | TAG_MEDIANO)},
/*129*/	{"Casa mediana 14",					"Elegante, cocina comedor, living, baño y habitacion",				2270.3674, -1210.4238, 1047.5608, 90.00, 	10, (TAG_CASA | TAG_MEDIANO)},
/*130*/	{"Casa chica 7",					"Oscura. Living, cocina, baño, comedor y habitacion", 				327.8592, 1477.9086, 1084.4596, 0.00, 		15, (TAG_CASA | TAG_CHICO)},
/*131*/	{"Monoambiente 6",					"Acogedora. Solo cocina, living y comedor.", 						2313.8438, -1212.7344, 1049.5234, 0.00, 	6, 	(TAG_CASA | TAG_MONOAMBIENTE | TAG_CHICO)},
/*132*/	{"[M] Bar antro boliche",			"Estilo muy descuidado, chico con escenario y pista", 				1997.6639, 1990.9257, 1001.8121, 0.00, 		1, 	(TAG_MAPPING | TAG_NEGOCIO | TAG_BAR | TAG_RESTO | TAG_CHICO)},
/*133*/	{"[M] Banco Malos Aires",			"Zona de transacciones, boveda c/ sist. de robo", 					1506.2819, -1134.2861, 1015.4266, 90.00,	1, 	(TAG_MAPPING | TAG_BANCO | TAG_EDIFICIO | TAG_GRANDE | TAG_GIGANTE | TAG_DOSPISOS | TAG_HQ | TAG_SERVICIOS)},
/*134*/	{"[M] Carcel Shisu (pabellon)",		"Zona celdas y principal de la carcel", 							1986.0167, 1989.6952, 1986.0192, 270.00, 	1,	(TAG_MAPPING | TAG_EDIFICIO | TAG_POLICIA | TAG_GRANDE | TAG_GIGANTE | TAG_DOSPISOS | TAG_HQ)},
/*135*/	{"[M] Carcel Shisu (sala visitas)",	"Habitacion chica y supervisada para visitas", 						128.3750, 125.3149, 2334.8855, 90.00, 		1, 	(TAG_MAPPING | TAG_EDIFICIO | TAG_CHICO | TAG_POLICIA | TAG_HQ)},
/*136*/	{"[M] Carcel Shisu (mini hall)",	"Sala de recepcion, chica con dos puertas extra, estilo oficina",	2260.7395, 1887.3708, 2319.3945, 0.00,		1, 	(TAG_MAPPING | TAG_EDIFICIO | TAG_CHICO | TAG_POLICIA | TAG_OFICINAS)},
/*137*/	{"[M] Carcel Shisu (vestuario)",	"Vestuario y armeria, chica", 										1006.3281, 1001.9589, 2002.5231, 0.00, 		1, 	(TAG_MAPPING | TAG_EDIFICIO | TAG_POLICIA | TAG_CHICO | TAG_SERVICIOS)},
/*138*/	{"[M] Carcel Shisu (enfermeria)",	"Chica y sin detalle, con recibidor", 								2012.7852, 1005.9943, 2004.7351, 90.00, 	1, 	(TAG_MAPPING | TAG_HOSPITAL | TAG_POLICIA | TAG_SERVICIOS | TAG_CHICO | TAG_EDIFICIO)},
/*139*/	{"[M] Casa villera 1",				"Dos pisos, muy chica, sucia y desprolija, con baño.", 				349.5027, 1782.0234, 1057.7446, 180.00, 	10, (TAG_MAPPING | TAG_CASA | TAG_CHICO | TAG_MONOAMBIENTE)},
/*140*/	{"[M] Casa villera 2",				"Muy chica y desprolija, con baño y habitacion", 					761.7759, 2492.2051, 1024.2642, 180.00, 	10, (TAG_MAPPING | TAG_CASA | TAG_CHICO | TAG_MONOAMBIENTE)},
/*141*/	{"[M] Casino mediano",				"Circular, con baños y oficina separada", 							2804.2834, -1042.9402, 1009.6902, 180.00, 	10, (TAG_MAPPING | TAG_NEGOCIO | TAG_CASINO | TAG_MEDIANO | TAG_EDIFICIO)},
/*142*/	{"[M] Central CTR-MAN",				"Grande, con estudio de radio, television, oficina e imprenta", 	766.2367, -1400.7026, 1007.7681, 0.00, 		10, (TAG_MAPPING | TAG_EDIFICIO | TAG_HQ | TAG_GRANDE | TAG_SERVICIOS)},
/*143*/	{"[M] Casa chica Deluxe",			"Habitacion, baño, comedor, sala de estar y cocina", 				-511.3964, 2595.3516, 1006.5834, 180.00, 	10, (TAG_MAPPING | TAG_CASA | TAG_CHICO | TAG_MEDIANO)},
/*144*/	{"[M] Torre Bracone&Mercier",		"Pasillo con sistema de ascensor para 5 departamentos", 			1467.0236, -1351.9495, 50.5550, 180.00, 	0, 	(TAG_MAPPING | TAG_EDIFICIO | TAG_GRANDE | TAG_CASA)},
/*145*/	{"[M] Ferreteria 1",				"Chica y un poco desprolija", 										1891.2484, 1889.7656, 1014.5312, 90.00, 	10, (TAG_MAPPING | TAG_NEGOCIO | TAG_TIENDA | TAG_FERRETERIA)},
/*146*/	{"[M] Gendarmeria (principal)",		"Estilo policia, con sala de video y oficinas", 					-567.3411, -513.2225, 5544.5654, 270.00, 	10, (TAG_MAPPING | TAG_EDIFICIO | TAG_MEDIANO | TAG_GRANDE | TAG_POLICIA | TAG_OFICINAS | TAG_SERVICIOS | TAG_HQ)},
/*147*/	{"[M] Gendarmeria (barracones)",	"Sala de entretenimiento chica con pool sillones y demas", 			-543.5849, -515.6966, 4122.3296, 180.00, 	10, (TAG_MAPPING | TAG_EDIFICIO | TAG_CHICO | TAG_MEDIANO | TAG_OFICINAS | TAG_HQ)},
/*148*/	{"[M] Habitacion toque militar",	"Estilo hotel, leves detalles militares, con baño", 				-507.5090, -527.1630, 5199.2554, 0.00, 		10, (TAG_MAPPING | TAG_CASA | TAG_CHICO | TAG_MONOAMBIENTE | TAG_HOTEL | TAG_MUYCHICO)},
/*149*/	{"[M] Gendarmeria (comedor)",		"chico. Varias mesas con mostrador de servicio", 					-482.9428, -519.8381, 4217.6978, 90.00, 	10, (TAG_MAPPING | TAG_POLICIA | TAG_CHICO | TAG_RESTO | TAG_BAR | TAG_EDIFICIO | TAG_HQ)},
/*150*/	{"[M] Hospital (principal)",		"Oficina, sala de espera, internacion y revision", 					1165.4883, -1335.9547, 1019.6964, 90.00, 	10, (TAG_MAPPING | TAG_HOSPITAL | TAG_GRANDE | TAG_DOSPISOS | TAG_HQ | TAG_EDIFICIO)},
/*151*/	{"[M] Hospital (terapia intens.)",	"5 salas de operacion, sin sala de espera", 						1148.2305, -1317.9467, 1030.7037, 0.00, 	10, (TAG_MAPPING | TAG_HOSPITAL | TAG_EDIFICIO | TAG_CHICO | TAG_HQ)},
/*152*/	{"[M] HQ mediano (estilo china)",	"Gran sala con bar, mesas, billar y pequeño deposito", 				2946.3323, -1964.2566, 1006.7603, 180.00, 	10, (TAG_MAPPING | TAG_EDIFICIO | TAG_MEDIANO | TAG_HQ | TAG_OFICINAS)},
/*153*/	{"[M] HQ grande (legal/ilegal)",	"Dos pisos, deposito, cocina comedor habitacion, muy espacioso",	2949.5137, -836.2685, 1010.0037, 0.00, 		10, (TAG_MAPPING | TAG_EDIFICIO | TAG_CASA | TAG_GRANDE | TAG_GIGANTE | TAG_HQ | TAG_OFICINAS | TAG_DOSPISOS)},
/*154*/	{"[M] Oficina 1",					"Chica, discreta y prolija, un solo ambiente con sala de espera",	1696.9835, -1380.1969, 3261.0613, 90.00, 	10, (TAG_MAPPING | TAG_CHICO | TAG_EDIFICIO | TAG_OFICINAS | TAG_NEGOCIO | TAG_MONOAMBIENTE)},
/*155*/	{"[M] Pasillo de monoblock",		"Corto y de aspecto soso, con 8 puertas", 							2753.7297, -1936.4121, 1003.3789, 90.00, 	10, (TAG_MAPPING | TAG_HOTEL | TAG_EDIFICIO | TAG_CHICO)},
/*156*/	{"[M] Sala de entrenamiento PMA",	"Poligono de tiro, casa para practica de GEOF.(NO USAR)", 			1496.6442, -1708.7181, 1029.7400, 90.00, 	10, (TAG_MAPPING | TAG_EDIFICIO | TAG_GRANDE | TAG_POLICIA | TAG_HQ)},
/*157*/	{"[M] Restaurant mediano elegante",	"Zona de barra, decks y muchas mesas.", 							-246.5032, -2008.2397, 1011.0507, 180.00, 	10, (TAG_MAPPING | TAG_NEGOCIO | TAG_RESTO | TAG_BAR | TAG_MEDIANO)},
/*158*/	{"[M] Oficinas Taller mecanico",	"Zona de estudio, oficina, vestuario (Rawnker)", 					377.2941, 3220.4063, 2412.7524, 360.00, 0, (TAG_MAPPING | TAG_EDIFICIO | TAG_GRANDE | TAG_HQ | TAG_DOSPISOS | TAG_NEGOCIO | TAG_OFICINAS | TAG_SERVICIOS)},
/*159*/	{"[M] Bar mediano Vintage",			"Dos ambientes y baño. Dos barras, muchas mesas con estilo retro",	2236.1628, -1086.9434, 2049.0281, 180.00,	10,	(TAG_MAPPING | TAG_NEGOCIO | TAG_BAR | TAG_RESTO | TAG_MEDIANO | TAG_CHICO)},
/*160*/	{"[M] Oficina Inmobiliaria",		"Dos oficinas vidriadas, maqueta y sala de espera.",				-403.8600, 753.2800, 1012.5500, 0.00,		10,	(TAG_MAPPING | TAG_MEDIANO | TAG_NEGOCIO | TAG_EDIFICIO | TAG_OFICINAS | TAG_CHICO)},
/*161*/	{"[M] Comisaria Numero 2",			"Chica, con oficinas y celdas.",									240.3100, 171.0100, 1003.0200, 180.00,		3,	(TAG_MAPPING | TAG_MEDIANO | TAG_CHICO | TAG_EDIFICIO | TAG_HQ | TAG_POLICIA | TAG_SERVICIOS)},
/*162*/ {"[M] Shop electrónica",			"Chico / mediano, varios mostradores con productos, un solo piso",	-124.7500, -23.3000, 1005.8400, 0.00,		10, (TAG_MAPPING | TAG_NEGOCIO | TAG_TIENDA | TAG_CHICO | TAG_MEDIANO)},
/*163*/ {"[M] Shop 24-7 / panchería",		"Chico, almacen de barrio con mesitas para comer rápido",			2843.3600, -2878.0100, 1102.4500, 0.00,		10, (TAG_MAPPING | TAG_NEGOCIO | TAG_TIENDA | TAG_CHICO | TAG_247)},
/*164*/ {"[M] Gimnasio rústico",			"Chico / mediano, con ring de box y máquinas. Pared de ladrillo",	721.1200, 1474.8200, 3001.0800, 90.00,		10, (TAG_MAPPING | TAG_NEGOCIO | TAG_GYM)},
/*165*/ {"[M] Club de pelea con jaula",		"2 pisos: espectadores arriba; vestuarios y jaula de lucha abajo",	-14.5200, 100.5600, 1101.5200, 180.00,		10, (TAG_MAPPING | TAG_EDIFICIO | TAG_CHICO | TAG_MEDIANO | TAG_GYM | TAG_DOSPISOS)},
/*166*/ {"[M] Casa chica 8",				"1 piso, cocina y living comedor, baño y dormitorio",				-51.7900, -15.8500, 1006.3400, 0.00,		10, (TAG_MAPPING | TAG_CASA | TAG_CHICO)},
/*167*/ {"[M] Strip club 1",				"Chico / mediano, mesas, sillones y barra, con cuarto privado",		-730.7800, 1308.8000, 2230.9600, 0.00,		10, (TAG_MAPPING | TAG_NEGOCIO | TAG_CLUB)},
/*168*/ {"[M] Strip club 2",				"Chico, con pasarela y caño. Pequeña barra y sillones",				258.9500, 1196.1800, 2601.0800, 0.00,		10, (TAG_MAPPING | TAG_NEGOCIO | TAG_CLUB)},
/*169*/ {"[M] Depto / casa chica",			"Chico, paredes blancas, monoambiente. Cocina, comedor y cama",		-1147.7700, 1432.1600, 1401.5600, 270.00,	10, (TAG_MAPPING | TAG_CASA | TAG_CHICO | TAG_MONOAMBIENTE)},
/*170*/ {"[M] Bar café rústico",			"Chico, en desnivel. Madera y ladrillo. Con baños. Mesa de pool",	412.7700, 157.0600, 1026.6700, 270.00,		10, (TAG_MAPPING | TAG_NEGOCIO | TAG_BAR | TAG_RESTO | TAG_CHICO)},
/*171*/ {"[M] Armería ilegal",				"2 pisos sucia, con mostrador, campo de tiro, cuarto de gerencia",	504.8500, -2318.2500, 1512.7900, 180.00,	10, (TAG_MAPPING | TAG_NEGOCIO | TAG_TIENDA | TAG_AMMU | TAG_MEDIANO)},
/*172*/ {"[M] Bar de motoqueros",			"Chico / mediano, en madera y chapa. Muchos posters. Con baños",	2081.2100, 2345.3900, -89.1900, 90.00,		10, (TAG_MAPPING | TAG_NEGOCIO | TAG_BAR | TAG_RESTO | TAG_CHICO | TAG_MEDIANO)},
/*173*/ {"[M] Juzgado / Edificio variado",	"Grande, muchos usos. Salas y oficinas. Recepción. Con calabozo",	2442.9300, 727.0400, 1745.2400, 35.00,		10, (TAG_MAPPING | TAG_EDIFICIO | TAG_HQ | TAG_OFICINAS | TAG_GRANDE | TAG_GIGANTE | TAG_DOSPISOS)},
/*174*/ {"[M] Casa chica 9",				"Un piso, 3 ambientes. Living-cocina-comedor y 2 dormitorios",		2978.4711, 1061.4674, 1504.5638, 180.00,	10, (TAG_MAPPING | TAG_CASA | TAG_CHICO)},
/*175*/ {"[M] Shop artículos deportivos",	"Un piso, mediano. En tonos claros. Repisas y artículos.",			1351.5213, -1287.0570, 1499.1654, 0.0,		10, (TAG_MAPPING | TAG_NEGOCIO | TAG_MEDIANO)},
/*176*/ {"[M] Tienda estación de servicio",	"Mediana, colores estilo YPF con gondolas y comida", 				1365.4431, 1419.8779, 1412.7285, 270.0,		10,	(TAG_MAPPING | TAG_TIENDA | TAG_247 | TAG_NEGOCIO | TAG_MEDIANO | TAG_GRANDE)},
/*177*/ {"[M] Sala de interrogatorios",		"Dos habitaciones separadas por un vidrio. Equipos de grabación.",	-506.55, -287.95, 2223.07, 176.77,			10,	(TAG_MAPPING | TAG_POLICIA | TAG_MEDIANO)},
/*178*/ {"Casa a amueblar 1",				"Vacía",	2797.31348, 2801.14844, 3999.00244, -90.00000,		1,	(TAG_CASA)},
/*179*/ {"Casa a amueblar 2",				"Vacía",	2416.70109, 2803.84033, 3999.21997, 90.00000,		1,	(TAG_CASA)},
/*180*/ {"Casa a amueblar 3",				"Vacía",	2001.97168, 2806.98462, 4001.01990, 180.00000,		1,	(TAG_CASA)},
/*181*/ {"Casa a amueblar 4",				"Vacía",	1596.55774, 2799.34351, 3999.00305, -90.00000,		1,	(TAG_CASA)},
/*182*/ {"Casa a amueblar 5",				"Vacía",	1194.20642, 2798.25122, 3996.38293, 180.00000,		1,	(TAG_CASA)},
/*183*/ {"Casa a amueblar 6",				"Vacía",	802.91919, 2796.00293, 4000.61157, 90.00000,		1,	(TAG_CASA)},
/*184*/ {"Casa a amueblar 7",				"Vacía",	400.43738, 2796.00708, 3999.25854, 0.00000,			1,	(TAG_CASA)},
/*185*/ {"Casa a amueblar 8",				"Vacía",	-8.65311, 2804.30420, 3999.01416, 180.00000,		1,	(TAG_CASA)},
/*186*/ {"Casa a amueblar 9",				"Vacía",	-403.79720, 2791.51392, 3997.06812, 0.00000,		1,	(TAG_CASA)},
/*187*/ {"Casa a amueblar 10",				"Vacía",	-804.94043, 2801.65845, 3999.26685, -90.00000,		1,	(TAG_CASA)},
/*188*/ {"Casa a amueblar 11",				"Vacía",	-1196.98840, 2795.71362, 4001.00537, 0.00000,		1,	(TAG_CASA)},
/*189*/ {"Casa a amueblar 12",				"Vacía",	-1597.63013, 2794.15612, 3999.26135, 90.00000,		1,	(TAG_CASA)},
/*190*/ {"Casa a amueblar 13",				"Vacía",	-1996.99133, 2795.74878, 4001.00208, 0.00000,		1,	(TAG_CASA)},
/*191*/ {"Casa a amueblar 14",				"Vacía",	-2401.09058, 2791.42261, 3999.24402, 0.00000,		1,	(TAG_CASA)},
/*192*/ {"Casa a amueblar 15",				"Vacía",	-2799.99536, 2792.55151, 3999.21033, 0.00000,		1,	(TAG_CASA)},
/*193*/ {"Casa a amueblar 16",				"Vacía",	-2816.46338, 2393.35986, 3999.38098, 0.00000,		1,	(TAG_CASA)},
/*194*/ {"Casa a amueblar 17",				"Vacía",	-2394.86743, 2395.71240, 3999.20044, 0.00000,		1,	(TAG_CASA)},
/*195*/ {"Casa a amueblar 18",				"Vacía",	-2004.87695, 2402.55762, 4000.08655, -90.00000,		1,	(TAG_CASA)},
/*196*/ {"Casa a amueblar 19",				"Vacía",	-1603.26526, 2391.10425, 3994.50085, 0.00000,		1,	(TAG_CASA)},
/*197*/ {"Casa a amueblar 20",				"Vacía",	-1200.85065, 2390.41284, 3999.53149, 0.00000,		1,	(TAG_CASA)},
/*198*/ {"Casa a amueblar 21",				"Vacía",	-791.00293, 2395.56763, 3997.41370, 0.00000,		1,	(TAG_CASA)},
/*199*/ {"Casa a amueblar 22",				"Vacía",	-396.65610, 2407.27588, 3999.00525, 90.00000,		1,	(TAG_CASA)},
/*200*/ {"Casa a amueblar 23",				"Vacía",	4.72861, 2398.50757, 3999.00916, 90.00000,			1,	(TAG_CASA)},
/*201*/ {"Casa a amueblar 24",				"Vacía",	400.79004, 2400.63477, 3999.12988, 0.00000,			1,	(TAG_CASA)},
/*202*/ {"Casa a amueblar 25",				"Vacía",	800.27533, 2388.15479, 3997.79675, 0.00000,			1,	(TAG_CASA)},
/*203*/ {"Casa a amueblar 26",				"Vacía",	1199.84094, 2407.84351, 3999.75525, 0.00000,		1,	(TAG_CASA)},
/*204*/ {"Casa a amueblar 27",				"Vacía",	1608.94641, 2392.72900, 3994.50061, 90.00000,		1,	(TAG_CASA)},
/*205*/ {"Casa a amueblar 28",				"Vacía",	1990.27100, 2394.55103, 3999.25623, 0.00000,		1,	(TAG_CASA)},
/*206*/ {"Casa a amueblar 29",				"Vacía",	2412.08765, 2396.31006, 4001.00537, 90.00000,		1,	(TAG_CASA)},
/*207*/ {"Casa a amueblar 30",				"Vacía",	2799.99121, 2395.94629, 3999.75073, 180.00000,		1,	(TAG_CASA)},
/*208*/ {"Casa a amueblar 31",				"Vacía",	2796.45581, 2008.05957, 3999.75085, 180.00000,		1,	(TAG_CASA)},
/*209*/ {"Casa a amueblar 32",				"Vacía",	2400.28711, 2000.06641, 3999.00696, 90.00000,		1,	(TAG_CASA)},
/*210*/ {"Casa a amueblar 33",				"Vacía",	1997.31641, 1991.43701, 3997.05725, 0.00000,		1,	(TAG_CASA)},
/*211*/ {"Casa a amueblar 34",				"Vacía",	1602.95886, 1993.02295, 3999.42786, 0.00000,		1,	(TAG_CASA)},
/*212*/ {"Casa a amueblar 35",				"Vacía",	1211.91016, 2008.83105, 3997.53564, 90.00000,		1,	(TAG_CASA)},
/*213*/ {"Casa a amueblar 36",				"Vacía",	799.97113, 1996.45605, 3999.49866, 0.00000,			1,	(TAG_CASA)},
/*214*/ {"Casa a amueblar 37",				"Vacía",	394.95093, 1999.84863, 3998.99622, 0.00000,			1,	(TAG_CASA)},
/*215*/ {"Casa a amueblar 38",				"Vacía",	0.01006, 2007.98790, 3999.74805, 0.00000,			1,	(TAG_CASA)},
/*216*/ {"Casa a amueblar 39",				"Vacía",	-391.58560, 2007.45801, 3999.39465, 90.00000,		1,	(TAG_CASA)},
/*217*/ {"Casa a amueblar 40",				"Vacía",	-790.94299, 1996.78320, 3999.48547, 90.00000,		1,	(TAG_CASA)},
/*218*/ {"Casa a amueblar 41",				"Vacía",	-1197.32135, 1987.32812, 3996.70410, 0.00000,		1,	(TAG_CASA)},
/*219*/ {"Casa a amueblar 42",				"Vacía",	-1597.32135, 1987.32812, 3996.70410, 0.00000,		1,	(TAG_CASA)},
/*220*/ {"Casa a amueblar 43",				"Vacía",	-2012.31409, 1985.64404, 3996.41687, 0.00000,		1,	(TAG_CASA)},
/*221*/ {"Casa a amueblar 44",				"Vacía",	-2393.12109, 2002.40186, 3997.13550, 90.00000,		1,	(TAG_CASA)},
/*222*/ {"Casa a amueblar 45",				"Vacía",	-2789.81323, 1998.71155, 3999.21973, 90.00000,		1,	(TAG_CASA)},
/*223*/ {"Casa a amueblar 46",				"Vacía",	-2807.07056, 1592.90063, 3999.37305, -90.00000,		1,	(TAG_CASA)},
/*224*/ {"Casa a amueblar 47",				"Vacía",	-2400.35938, 1590.29032, 3998.93079, 0.00000,		1,	(TAG_CASA)},
/*225*/ {"Casa a amueblar 48",				"Vacía",	-2000.85474, 1595.90674, 3999.21472, 0.00000,		1,	(TAG_CASA)},
/*226*/ {"Casa a amueblar 49",				"Vacía",	-1612.41113, 1598.45068, 3999.88354, 90.00000,		1,	(TAG_CASA)},
/*227*/ {"[M] Hospital",					"Hospital con consultorio, quirófano y sala de emergencias.",		-2334.6067, 194.2228, 1546.9862, 180.0,		1,	(TAG_MAPPING | TAG_HOSPITAL | TAG_SERVICIOS | TAG_GRANDE | TAG_EDIFICIO)},
/*228*/ {"[M] Pasillo merca subterráneo",	"Pasillos turbios, con varios cuartos. Finaliza en un gimnasio.",	2778.3637, 2821.9885, 3004.7814, 0.00,		1,	(TAG_MAPPING | TAG_MEDIANO | TAG_GYM)},
/*229*/ {"[M] 24/7 de barrio",				"Negocio chico. Rejas por todos lados. (hvte)",						2799.55811, 2795.80469, 4801.50293, 0.00,	1,	(TAG_MAPPING | TAG_247 | TAG_TIENDA | TAG_CHICO)},
/*230*/ {"[M] Monoblock dos pisos",			"Edificio de monoblocks de dos pisos. Sucio. (hvte)",				2397.9487, 2803.6780, 1038.0315,    180.00,	1,	(TAG_MAPPING | TAG_MEDIANO | TAG_EDIFICIO)},
/*231*/ {"[M] Garaje mediano - Taller",		"Garaje mediano. Ideal para un taller mecanico. Sucio. (Sopa)",		-2796.0579, -2788.3127, 3997.87000, 90.0,	1,	(TAG_MAPPING | TAG_MEDIANO | TAG_GARAJE)},
/*232*/ {"[M] Garaje mediano - Casa",		"Garaje mediano. Ideal para una Casa. (Sopa)",						-2401.3054, -2800.1948, 3955.61380,	270.0,	1,	(TAG_MAPPING | TAG_MEDIANO | TAG_GARAJE)},
/*233*/ {"[M] Garaje - Estacionamiento",	"Garaje gigante. Garaje de LSPD. (Sopa)",							-2771.2954, -2396.3760, 3795.0703, 180.0,	1,	(TAG_MAPPING | TAG_GIGANTE | TAG_GARAJE)},
/*234*/ {"[M] Garaje - Estacionamiento",	"Garaje gigante. Garaje de SFPD. (Sopa)",							-2831.9932, -1975.1293, 3800.8359, 270.0,	1,	(TAG_MAPPING | TAG_GIGANTE | TAG_GARAJE)},
/*235*/ {"[M] Garaje - Estacionamiento",	"Garaje gigante. Garaje de LV. (Sopa)",								-2805.2390, -1597.0707, 3956.7061, 270.0,	1,	(TAG_MAPPING | TAG_GRANDE | TAG_GARAJE)},
/*236*/ {"[M] Comisaria Numero 15",			"Grande, con oficinas y celdas (PB). (Rawnker)",					-2783.4482, 3211.3586, 2412.7266, 93.0511,  3,	(TAG_MAPPING | TAG_GRANDE | TAG_EDIFICIO | TAG_HQ | TAG_POLICIA | TAG_SERVICIOS)},
/*237*/ {"[M] Estacionamiento comisaria",	"Garaje de policia grande. (Rawnker)",								2798.71, 3205.04, 2412.86 , 89.6868,		1,	(TAG_MAPPING | TAG_GRANDE | TAG_GARAJE | TAG_POLICIA)},
/*238*/ {"[M] Estación Retiro",				"Nuevo interior de la estación Retiro. (Rawnker)",					16.56, 3199.91, 2412.72, 266.42, 			3,	(TAG_MAPPING | TAG_GRANDE |TAG_EDIFICIO)},
/*239*/ {"Casa a amueblar 50",				"Vacía",															789.40 , 3198.91, 2401.08, 352.76,			3,	(TAG_CASA)},
/*240*/ {"[M] Garaje grande - Taller",		"Garaje grande. Ideal para un taller mecanico. (Rawnker)",			2002.03, 2288.49, 2694.49, 359.85,			3,	(TAG_MAPPING | TAG_GRANDE | TAG_GARAJE)},
/*241*/ {"[M] Garaje chico - Taller",		"Garaje chico. Ideal para un taller mecanico - Casa. (Rawnker)",    -2002.17, 2101.31, 2599.80, 273.5,			3,	(TAG_MAPPING | TAG_CHICO | TAG_GARAJE)},
/*242*/ {"[M] Hospital - Grande",			"Mapeo del hospital de Boedo (Rawnker)",							-265.42, 1076.35, 2812.72, 0.00,  			3,	(TAG_MAPPING | TAG_GRANDE | TAG_EDIFICIO | TAG_HQ | TAG_HOSPITAL | TAG_SERVICIOS)},
/*243*/ {"[M] Comisaria Numero 15",			"Mediano, celdas (Subsuelo). (Rawnker)",							-2401.56, 3233.73, 2412.72, 180.0, 			3,	(TAG_MAPPING | TAG_MEDIANO | TAG_EDIFICIO | TAG_HQ | TAG_POLICIA | TAG_SERVICIOS)},
/*244*/ {"[M] Comisaria Numero 15",			"Mediano, oficinas (PP). (Rawnker)",							    -2015.57, 3166.20, 2412.72, 00.0, 			3,	(TAG_MAPPING | TAG_MEDIANO | TAG_EDIFICIO | TAG_HQ | TAG_POLICIA | TAG_SERVICIOS)},
/*245*/ {"[M] ACEMA (Principal)",			"Grande - Oficinas. (Rawnker)",							   			-422.1846, 3197.7056, 2412.7266, 270.00, 	3,	(TAG_MAPPING | TAG_GRANDE | TAG_EDIFICIO | TAG_HQ)},
/*246*/ {"[M] ACEMA (Subinterior)",			"Oficinas (Rawnker)",							    				-792.6918, 3209.9937, 2412.7217, 90.00, 	3,	(TAG_MAPPING | TAG_MEDIANO | TAG_EDIFICIO | TAG_HQ) },
/*247*/ {"[M] Garage Torres Bracone",		"Garaje grande. (Rawnker)",							    			-1590.4995, 3193.8245, 2312.8086, 90.00, 	3,	(TAG_MAPPING | TAG_MEDIANO | TAG_GARAJE) },
/*248*/ {"[M] Pasillo Monoblock FA",		"Pasillo mediano. (Hvte)",							    			-0.7798, 2201.8010, 2001.0859, 270.00, 		3,	(TAG_MAPPING | TAG_MEDIANO | TAG_EDIFICIO | TAG_HQ) },
/*249*/ {"[M] Planta Baja barrio SOM",			"(Hvte)",							    						5.7757, 1601.0515, 1998.1029, 90.00, 		3,	(TAG_MAPPING | TAG_MEDIANO | TAG_EDIFICIO | TAG_HQ) },
/*250*/ {"[M] Planta Alta barrio SOM",			"(Hvte)",							    						-3.8016, 2004.2404, 2000.9276, 270.00, 		3,	(TAG_MAPPING | TAG_MEDIANO | TAG_EDIFICIO | TAG_HQ) },
/*251*/ {"[M] Pasillo barrio SOM",				"(Hvte)",							    						-0.1063, 1795.3208, 1997.8453, 90.00, 		3,	(TAG_MAPPING | TAG_MEDIANO | TAG_EDIFICIO | TAG_HQ) },
/*252*/ {"[M] Prisión Federal 2022",		"Grande, con muchas celdas (Rawnker)",							    1177.0994, 3203.8560, 2412.7266, 360.00, 	3,	(TAG_MAPPING | TAG_GRANDE | TAG_EDIFICIO | TAG_POLICIA) },
/*253*/ {"[M] Interior Destacamento GNA","Chico, oficina, con vestuario, cabinas. (Rawnker)",				2905.314697, 2101.516357, 803.742309, 0.0, 	3,	(TAG_MAPPING | TAG_CHICO | TAG_EDIFICIO | TAG_POLICIA | TAG_OFICINAS) }

};

static ainteriores_dlg_currentpage[MAX_PLAYERS][2];
static ainteriores_dlg_str[INT_MAX_DLG_LENGTH];
static e_INTERIOR_TAGS:ainteriores_selected_tags[MAX_PLAYERS];

IsValidServerInterior(id) {
	return (0 < id < sizeof(ServerInteriors));
}

GetServerInteriorInfo(interiorid, &Float:x, &Float:y, &Float:z, &Float:a, &int)
{
	if(!IsValidServerInterior(interiorid))
		return 0;

	x = ServerInteriors[interiorid][iX];
	y = ServerInteriors[interiorid][iY];
	z = ServerInteriors[interiorid][iZ];
	a = ServerInteriors[interiorid][iAngle];
	int = ServerInteriors[interiorid][iInt];

	return 1;
}

IsServerInteriorGarage(interiorid) {
	return (BitFlag_Get(ServerInteriors[interiorid][iTags], TAG_GARAJE));
}

CMD:ainteriores(playerid, params[])
{
	new mapid;

	if(!sscanf(params, "i", mapid))
	{
		if(!IsValidServerInterior(mapid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de mapeo inválida.");

		if(TeleportPlayerTo(playerid, ServerInteriors[mapid][iX], ServerInteriors[mapid][iY], ServerInteriors[mapid][iZ], ServerInteriors[mapid][iAngle], ServerInteriors[mapid][iInt], GetPlayerVirtualWorld(playerid))) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Te telepeaste al mapa ID %i: %s.", mapid, ServerInteriors[mapid][iName]);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes moverte tan rápido de mapa en mapa. Debes esperar a que carguen los objetos.");
		}
	} else {
		Dialog_Show(playerid, DLG_INTERIORS_MENU, DIALOG_STYLE_LIST, "Panel buscador de mapeos interiores disponibles", "Ver listado\nAplicar filtro al listado (TAG)", "Continuar", "Cerrar");
	}

	return 1;
}

Dialog:DLG_INTERIORS_MENU(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	switch(listitem)
	{
		case 0: {
			ShowPlayerInteriorsList(playerid, 1, ainteriores_selected_tags[playerid]);
		}
		case 1: {
			ShowPlayerInteriorTags(playerid);
		}
	}
	return 1;
}

ShowPlayerInteriorTags(playerid)
{
	new dlg_str[40 * sizeof(INTERIOR_TAGS_DATA)] = "TAG\tEstado\n";
	new line_str[40];

	for(new i = 0, size = sizeof(INTERIOR_TAGS_DATA); i < size; i++)
	{
		format(line_str, sizeof(line_str), "%s\t%s\n", INTERIOR_TAGS_DATA[i][it_name], (BitFlag_Get(ainteriores_selected_tags[playerid], INTERIOR_TAGS_DATA[i][it_flag])) ? ("{01DF01}ON{FFFFFF}") : ("{DF0101}OFF{FFFFFF}"));
		strcat(dlg_str, line_str);
	}
	Dialog_Show(playerid, DLG_INTERIORS_FLAGS, DIALOG_STYLE_TABLIST_HEADERS, "Activa o desactiva los flags a buscar", dlg_str, "Aceptar", "Volver");
}

Dialog:DLG_INTERIORS_FLAGS(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		Dialog_Show(playerid, DLG_INTERIORS_MENU, DIALOG_STYLE_LIST, "Panel buscador de interiores disponibles", "Ver listado\nAplicar filtro al listado (TAG)", "Continuar", "Cerrar");
		return 1;
	}

	BitFlag_Toggle(ainteriores_selected_tags[playerid], INTERIOR_TAGS_DATA[listitem][it_flag]);
	ShowPlayerInteriorTags(playerid);
	return 1;
}

ShowPlayerInteriorsList(playerid, from_id, e_INTERIOR_TAGS:tags)
{
	if(!IsValidServerInterior(from_id))
		return 0;

	new ainteriores_line_str[INT_MAX_DLG_LINE_LENGTH], si_amount = sizeof(ServerInteriors), id, count;

	ainteriores_dlg_str = "Nombre\tDescripción\n<<< Anterior\nSiguiente >>>";
	for(id = from_id; id < si_amount && count <= INT_MAX_DLG_LINES_TO_SHOW; id++)
	{
		if(!tags || BitFlag_Get(ServerInteriors[id][iTags], tags)) // Ojo, es si tiene alguno (OR), no necesariamente todos al mismo tiempo. Si no tuviese ninguno esto es 0
		{
			format(ainteriores_line_str, sizeof(ainteriores_line_str), "\n%i %s\t%s", id, ServerInteriors[id][iName], ServerInteriors[id][iDesc]);
			strcat(ainteriores_dlg_str, ainteriores_line_str, sizeof(ainteriores_dlg_str));
			count++;
		}
	}

	ainteriores_dlg_currentpage[playerid][0] = from_id;
	ainteriores_dlg_currentpage[playerid][1] = id;

	Dialog_Show(playerid, DLG_INTERIORS_LIST, DIALOG_STYLE_TABLIST_HEADERS, (tags) ? ("Interiores disponibles, filtrado {01DF01}ON") : ("Interiores disponibles, filtrado {DF0101}OFF"), ainteriores_dlg_str, "Ir", "Volver");
	return 1;
}

Dialog:DLG_INTERIORS_LIST(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		Dialog_Show(playerid, DLG_INTERIORS_MENU, DIALOG_STYLE_LIST, "Panel buscador de interiores disponibles", "Ver listado\nAplicar filtro al listado (TAG)", "Continuar", "Cerrar");
		return 1;
	}

	if(!sscanf(inputtext, "i ", listitem))
	{
		if(!IsValidServerInterior(listitem))
			return 1;

		TeleportPlayerTo(playerid, ServerInteriors[listitem][iX], ServerInteriors[listitem][iY], ServerInteriors[listitem][iZ], ServerInteriors[listitem][iAngle], ServerInteriors[listitem][iInt], GetPlayerVirtualWorld(playerid));
	}
	else
	{
		new option[16];

		if(!sscanf(inputtext, "s[16] ", option))
		{
			if(!strcmp(option, "<<<")) {
				if(IsValidServerInterior(ainteriores_dlg_currentpage[playerid][0] - INT_MAX_DLG_LINES_TO_SHOW - 1)) {
					ShowPlayerInteriorsList(playerid, ainteriores_dlg_currentpage[playerid][0] - INT_MAX_DLG_LINES_TO_SHOW - 1, ainteriores_selected_tags[playerid]);
				} else {
					ShowPlayerInteriorsList(playerid, 1, ainteriores_selected_tags[playerid]);
				}
			} else if(!strcmp(option, "Siguiente")) {
				if(IsValidServerInterior(ainteriores_dlg_currentpage[playerid][1])) {
					ShowPlayerInteriorsList(playerid, ainteriores_dlg_currentpage[playerid][1], ainteriores_selected_tags[playerid]);
				} else {
					ShowPlayerInteriorsList(playerid, ainteriores_dlg_currentpage[playerid][0], ainteriores_selected_tags[playerid]);
				}
			}
		}
	}

	return 1;
}