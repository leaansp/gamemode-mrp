//==========================================================================================================//
// Como usar las funciones InterpolateCameraPos y InterpolateCameraLookAt 								    //
// InterpolateCameraPos mueve la posición de la camara desde los puntos x1 y1 z1 hasta los puntos x2 y2 z2. //
//	Lo hace en X cant de tiempo.																		    //
// InterpolateCameraLookAt apunta la camara desde los puntos x1 y1 z1 hacia los puntos x2 y2 z2.		    //
//	Lo hace en X cant de tiempo.																		    //
//																										    //
// Si primero se utiliza InterpolateCameraPos y luego InterpolateCameraLookAt, con la misma velocidad en    //
// ambos timers, entonces el movimiento de la camara va a ser acompañado por la otra funcion, que cambia    //
// durante el movimiento de la camara el punto hacia donde se enfoca.										//
//==========================================================================================================//

#if defined _marp_scenes_included
	#endinput
#endif
#define _marp_scenes_included

#include <YSI_Coding\y_hooks>

//=====================================[DEFINES]=====================================

#define TOTAL_NODES				28		//cantidad de nodos creados
#define TOTAL_ACTORS_NODES		9

#define MAX_ACTORS_PER_NODE		5

//[ESCENAS]
#define SCENE_BUY_BUSINESS		1
#define SCENE_BUY_HOUSE			2
#define SCENE_VEHICLE_GROTTI	3
#define SCENE_VEHICLE_JEFFERSON	4
#define SCENE_VEHICLE_PINAR		5
#define SCENE_VEHICLE_MOTO		6
#define SCENE_VEHICLE_AVION		7
#define SCENE_VEHICLE_NAUTICA	8
#define SCENE_VEHICLE_UTILIT	9
#define SCENE_TAKE_GARBJOB		10

//[TIPOS DE NODOS]
#define NODE_TYPE_INVALID 		-1
#define NODE_TYPE_JOB			1
#define NODE_TYPE_BUY_BIZ		2
#define NODE_TYPE_BUY_HOUSE		3
#define NODE_TYPE_BUY_VEHICLE	4
#define NODE_TYPE_TOGG_CONT		5
#define NODE_TYPE_JOB2			6

//===================================================================================

//====================================[FUNCIONES]====================================
forward ShowTDSceneSubsForPlayer(playerid); //muestra los textdraws necesarios para reproducir el nodo de la escena
forward HideTDSceneSubsForPlayer(playerid); //oculta los texdraws (no elimina)
forward KillSceneTimer(playerid); // elimina el timer que se usa para el sistema
forward StopPlayerScene(playerid, node); //finaliza la secuencia
forward CreatePlayerSceneTextDraws(playerid); //crea los textdraws necesarios para poder mostrar una escena
forward SetAndPlayPlayerNode(playerid, node, extraid);
//===================================================================================

//============================[VARIABLES INTERNAS]===================================
new PlayerText:BlackLayer_Down[MAX_PLAYERS],
	PlayerText:BlackLayer_Up[MAX_PLAYERS],
	PlayerText:Subtitle_Line1[MAX_PLAYERS],
	PlayerText:Subtitle_Line2[MAX_PLAYERS],
	PlayerText:Subtitle_Line3[MAX_PLAYERS],
	PlayerText:Subtitle_Line4[MAX_PLAYERS],
	PlayerText:Subtitle_Line5[MAX_PLAYERS],
	PlayerText:Button_StepCinematic[MAX_PLAYERS];

new scene_timer[MAX_PLAYERS]; //timer q controla la secuencia entre nodos y que finaliza la escena
new ActorsNodeID[MAX_PLAYERS][MAX_ACTORS_PER_NODE];
new ActualNode[MAX_PLAYERS] = 0;

enum e_scene_actor_node_info {									//sLinkToNode debe tener la ID del nodo en el cual deben ser creados los actores
	sLinkToNode, sAlib[32], sAname[32], sAnimloop,				//si un nodo tiene mas de un actor, deben colocarse seguidos inmediatamente unos de otros
	Float:sX, Float:sY, Float:sZ, Float:sAngle, sSkin, sVWorld
};
static const ActorNode[TOTAL_ACTORS_NODES][e_scene_actor_node_info] = {
	{0, "none", "none", 0, 0.00, 0.00, 0.0000, 0.00, 0, 0},
	{SCENE_VEHICLE_GROTTI, "MISC", "Idle_Chat_02", 1, 548.42, -1269.32, 17.3032, 308.00, 147, 0}, /*1*/
	{SCENE_VEHICLE_GROTTI, "MISC", "Idle_Chat_02", 1, 549.57, -1268.34, 17.3032, 128.00, 0, 0},
	{SCENE_VEHICLE_JEFFERSON, "MISC", "Idle_Chat_02", 1, 2125.91, -1134.32, 25.50, 172.43, 0, 0}, /*3*/
	{SCENE_VEHICLE_JEFFERSON, "MISC", "Idle_Chat_02", 1, 2125.89, -1136.87, 25.40, 355.73, 147, 0},
	{SCENE_VEHICLE_MOTO, "PED", "SEAT_idle", 1, 1298.58, -1874.28, 13.55, 95.03, 0, 0}, /*5*/
	{SCENE_VEHICLE_MOTO, "PED", "SEAT_idle", 1, 1297.26, -1874.74, 13.55, 251.05, 150, 0},
	{SCENE_VEHICLE_UTILIT, "PED", "SEAT_idle", 1, 2248.11, -2183.43, 13.57, 354.10, 0, 0}, /*7*/
	{SCENE_VEHICLE_UTILIT, "PED", "SEAT_idle", 1, 2247.93, -2181.81, 13.57, 176.74, 236, 0}
};

enum e_scene_node_info {
	sNodeID,			//se pone ordenado y en concordancia con la escena. Es referencial para el sistema
	sType,				//tipo de nodo (como es la escena, si de job, de negocio, etc)
	sTime,				//duracion del nodo
	sCameraCut,			//tipo de CameraCut para el nodo
	sInterior,			//interior donde se reproduce el nodo
	sVirtualWorld,		//mundo virtual
	sAudio,				//sonido que reproduce el nodo (si una escena tiene varios nodos, se pueden superponer)
	sActorInfo,			//si es 0, no hay actores, sino, referencia al primer actor (en el vector de actores) que se debe crear en el nodo
	sCantActors,		//cantidad de actores q tiene el nodo 
	Float:sCamPosFromX,
	Float:sCamPosFromY,
	Float:sCamPosFromZ,
	Float:sCamPosToX,
	Float:sCamPosToY,
	Float:sCamPosToZ,
	Float:sCamLookFromX,
	Float:sCamLookFromY,
	Float:sCamLookFromZ,
	Float:sCamLookToX,
	Float:sCamLookToY,
	Float:sCamLookToZ,
	strLine1[128],
	strLine2[128],
	strLine3[128],
	strLine4[128],
	strLine5[128],
	bool:haveNextNode	//si la escena tiene mas de un nodo, colocar en true. El ultimo nodo (o el unico) debe tener false para cortar la escena
};

//================================[I M P O R T A N T E]=============================//
// El siguiente static const guarda la informacion específica para reproducir cada  //
// nodo. Para crear una nueva 'escena' es muy importante almacenar los nodos de ma- //
// nera consecutiva (en caso de tener mas de un nodo) y en último, setear la bool   //
// haveNextNode en false, para indicarle al sistema que lo reproduce es el nodo fi- //
// nal. Es muy importante que si se agregan nuevos nodos, se modifique TOTAL_NODES  //
//==================================================================================//

static const ServerScene[TOTAL_NODES][e_scene_node_info] = {
	{
		0, NODE_TYPE_INVALID, 0, 0, 0, 0, 0, 0, 0,	// sNodeID, sType, sTime, sCameraCut, sInterior, sVirtualWorld, sAudio, sActorInfo, sCantActors
		0.00, 0.00, 0.00, 0.00, 0.00, 0.00,			// sCamPosFromX, sCamPosFromY, sCamPosFromZ, sCamPosToX, sCamPosToY, sCamPosToZ,
		0.00, 0.00, 0.00, 0.00, 0.00, 0.00,			// sCamLookFromX, sCamLookFromY, sCamLookFromZ, sCamLookToX, sCamLookToY, sCamLookToZ,
		"_",										// strLine1[128],
		"_",										// strLine2[128],
		"_",										// strLine3[128],
		"_",										// strLine4[128],
		"_",										// strLine5[128],
		false 										// haveNextNode
	},
	{	//COMPRA NEGOCIO
		1, NODE_TYPE_BUY_BIZ, 15000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		0.00, 0.00, 0.00, 0.00, 0.00, 10.00,
		0.00, 0.00, 0.00, 0.00, 0.00, 10.00, 
		"Felicidades, ahora eres el propietario de este negocio. A partir de este momento estaras a cargo de su administracion.",
		"Lo primero, debes elegir que quieres vender, y para toda la gestion necesaria deberas usar /negociogestionar. Podras",
		"pedir existencias, ajustar su precio de entrada y vender los productos que quieras. En cada dia de pago tendras que",
		"pagar una cantidad de dinero para mantener al negocio. Recuerda que siempre tendras a mano el comando /ayudanegocio",
		"para obtener en detalle todas las funcionalidades que tu negocio posee.",
		false
	},
	{	//COMPRA CASA
		2, NODE_TYPE_BUY_HOUSE, 15000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		0.00, 0.00, 0.00, 0.00, 0.00, 10.00,
		0.00, 0.00, 0.00, 0.00, 0.00, 10.00,
		"Felicidades, acabas de comprar esta propiedad. En ella podras guardar objetos con /arm. Tambien puedes generar",
		"ingresos alquilando tu propiedad a otro jugador. Puedes configurar una radio que prefieras para escuchar cada",
		"vez que estes en su interior. A partir de ahora en cada PayDay deberas pagar un minimo impuesto mientras seas",
		"el propietario. Para mayor infomacion con todos los comandos pertinentes a tu nueva casa, siempre puedes usar",
		"/ayudacasa y luego escribir el comando que te interese para su uso concreto.",
		false
	},
	{ //GROTTI
		3, NODE_TYPE_BUY_VEHICLE, 15000, CAMERA_MOVE, 0, 0, 176, 1, 2,
		548.20, -1259.95, 18.98, 547.40, -1259.83, 18.00,
		546.62, -1277.38, 17.28, 546.62, -1277.38, 16.28, 
		"iAcabas de comprar un coche! Ahora tu traslado por la ciudad va a ser infinitamente mas sencillo, siempre",
		"y cuando recargues combustible... En tu coche podras usar '/mal' para interactuar con el maletero, donde",
		"siempre podras guardar objetos, segun que tanta capacidad tenga disponible. Debes saber que puedes compartir",
		"las llaves de tu coche con quien quieras usando '/llavero' y ante cualquier duda, siempre puedes escribir",
		"'/veh' y '/ayuda' para obtener mayor informacion.",
		false
	},
	{ //JEFFERSON
		4, NODE_TYPE_BUY_VEHICLE, 15000, CAMERA_MOVE, 0, 0, 176, 3, 2,
		2122.23, -1128.01, 27.05, 2119.62, -1130.61, 27.05,
		2128.01, -1137.30, 26.66, 2128.01, -1137.30, 26.66,
		"iAcabas de comprar un coche! Ahora tu traslado por la ciudad va a ser infinitamente mas sencillo, siempre",
		"y cuando recargues combustible... En tu coche podras usar '/mal' para interactuar con el maletero, donde",
		"siempre podras guardar objetos, segun que tanta capacidad tenga disponible. Debes saber que puedes compartir",
		"las llaves de tu coche con quien quieras usando '/llavero' y ante cualquier duda, siempre puedes escribir",
		"'/veh' y '/ayuda' para obtener mayor informacion.",
		false
	},
	{ //PINAR
		5, NODE_TYPE_BUY_VEHICLE, 15000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		982.74, -1107.09, 25.06, 971.77, -1107.09, 25.06,
		976.73, -1101.77, 23.58, 976.73, -1101.77, 23.58,
		"iAcabas de comprar un coche! Ahora tu traslado por la ciudad va a ser infinitamente mas sencillo, siempre",
		"y cuando recargues combustible... En tu coche podras usar '/mal' para interactuar con el maletero, donde",
		"siempre podras guardar objetos, segun que tanta capacidad tenga disponible. Debes saber que puedes compartir",
		"las llaves de tu coche con quien quieras usando '/llavero' y ante cualquier duda, siempre puedes escribir",
		"'/veh' y '/ayuda' para obtener mayor informacion.",
		false
	},
	{ //CIUDAD MOTO
		6, NODE_TYPE_BUY_VEHICLE, 15000, CAMERA_MOVE, 0, 0, 176, 5, 2,
		1298.71, -1877.66, 14.42, 1300.36, -1874.26, 14.26,
		1296.16, -1870.17, 13.84, 1299.64, -1866.97, 13.11,
		"iAcabas de comprar una moto! Ahora tu traslado por la ciudad va a ser infinitamente mas sencillo, siempre",
		"y cuando recargues combustible... No olvides apurarte a comprar un casco en alguna tienda, ya que podrias",
		"tener problemas si te accidentas o si la policia te detiene sin tener uno. Debes saber que puedes compartir",
		"las llaves de tu moto con quien quieras usando '/llavero' y ante cualquier duda, siempre puedes escribir",
		"'/veh' y '/ayuda' para obtener mayor informacion.",
		false
	},
	{ //FREDDI AVIONES
		7, NODE_TYPE_BUY_VEHICLE, 15000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		1940.61, -2302.37, 20.01, 1938.56, -2335.44, 26.02,
		1903.13, -2315.69, 13.18, 1903.13, -2315.69, 13.18,
		"iAcabas de comprar un avion! Ahora podras sobrevolar todo el extenso territorio de nuestra provincia, siempre",
		"y cuando recargues combustible... En tu avion podras usar '/mal' para interactuar con el maletero, donde",
		"siempre podras guardar objetos, segun que tanta capacidad tenga disponible. Debes saber que puedes compartir",
		"las llaves de tu avion con quien quieras usando '/llavero' y ante cualquier duda, siempre puedes escribir",
		"'/veh' y '/ayuda' para obtener mayor informacion.",
		false
	},
	{ //NAUTICA GABOTT
		8, NODE_TYPE_BUY_VEHICLE, 15000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		2950.14, -2052.64, 2.86, 2953.59, -2054.05, 7.10,
		2937.79, -2064.40, 2.69, 2937.79, -2064.40, 2.09,
		"iAhora eres propietario de un vehiculo acuatico, felicidades!. Procura mantenerlo amarrado en la costa para",
		"usarlo cuando quieras. En tu nueva embarcacion podras usar '/mal' para interactuar con el maletero, donde",
		"siempre podras guardar objetos, segun que tanta capacidad tenga disponible. Debes saber que puedes compartir",
		"las llaves de tu nave con quien quieras usando '/llavero' y ante cualquier duda, siempre puedes escribir",
		"'/veh' y '/ayuda' para obtener mayor informacion.",
		false
	},
	{ //RS HAUL UTILITARIOS
		9, NODE_TYPE_BUY_VEHICLE, 15000, CAMERA_MOVE, 0, 0, 176, 7, 2,
		2250.30, -2183.47, 14.12, 2229.85, -2173.66, 15.24,
		2219.23, -2178.56, 14.04, 2219.23, -2178.56, 14.04,
		"iAcabas de comprar un utilitario! Este tipo de vehiculos tienen la ventaja de poseer generalmente maleteros",
		"mas grandes que los coches convencionales. Siempre podras usar '/mal' para interactuar con el maletero, donde",
		"siempre podras guardar objetos, segun que tanta capacidad tenga disponible. Debes saber que puedes compartir",
		"las llaves de tu coche con quien quieras usando '/llavero' y ante cualquier duda, siempre puedes escribir",
		"'/veh' y '/ayuda' para obtener mayor informacion.",
		false
	},
	{	// JOB MOTO DELIVERY
		10, NODE_TYPE_JOB, 15000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		1740.71, -1598.88, 16.38, 1748.24, -1586.82, 14.76,
		1747.70, -1572.48, 13.46, 1745.56, -1576.97, 14.19,
		"Has decidido transformarte en mensajero de Moto Delivery!. En este trabajo tu principal labor sera cumplir",
		"la incesante demanda de los alocados clientes, que desean recibir su envio en el menor tiempo posible. El",
		"reloj se transformara en tu peor enemigo y la empresa no te entrega siquiera un casco. Pero aun asi la paga",
		"es buena, y tendras oportunidad de ascender.",
		"_",
		true
	},
	{	// FIN JOB MOTO DELIVERY
		11, NODE_TYPE_JOB, 15000, CAMERA_MOVE, 0, 0, 0, 0, 0,
		1748.24, -1586.82, 14.76, 1744.02, -1570.55, 14.17,
		1745.56, -1576.97, 14.19, 1748.14, -1584.63, 14.85,
		"Cuantas mas entregas hagas, mas reputacion y antiguedad ganas. Eventualmente si no destruyes los vehiculos de",
		"trabajo, puedes ascender y tener acceso a motos mas rapidas, nada mal para la poca paciencia que tiene la",
		"clientela de esta empresa. No olvides que puedes usar '/ayuda' y '/verempleo' si tieens alguna duda y deseas",
		"obtener mas informacion sobre algun comando.",
		"_",
		false
	},
	{	// JOB TAXISTA
		12, NODE_TYPE_JOB, 10000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		1790.71, -1938.21, 15.40, 1790.71, -1906.21, 15.40, 
		1779.40, -1930.40, 14.70, 1779.40, -1900.40, 14.70,
		"Esta es la central de taxistas y su flota de vehiculos, donde a partir de ahora pasaras una buena parte",
		"de tu dia. Tu labor es sencilla, deberas tomar un vehiculo y salir a buscar viajes.",
		"Logicamente, cuantos mas viajes hagas, mas dinero ganaras, asi que esfuerzate.",
		"_",
		"_",
		true
	},
	{	// FIN JOB TAXISTA
		13, NODE_TYPE_JOB, 5000, CAMERA_MOVE, 0, 0, 0, 0, 0,
		1790.71, -1906.21, 15.40, 1825.03, -1882.34, 28.35,
		1779.40, -1900.40, 14.70, 1779.50, -1916.11, 15.47,
		"No olvides que puedes usar los comandos '/ayuda' y '/verempleo' para informacion mas detallada",
		"sobre tu empleo. iAhora a trabajar!",
		"_",
		"_",
		"_",
		false
	},
	{	//JOB GRANJERO
		14, NODE_TYPE_JOB, 12000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		-50.30, 119.20, 19.10, -10.30, 107.28, 19.10,
		-32.11, 58.17, 5.00, -58.45, 84.26, 6.16,
		"Felicidades, esta granja sera tu nuevo lugar de trabajo a partir de ahora. Tendras que acostumbrarte",
		"al paisaje campestre, los bichos y la brisa fresca del campo. Cada dia de trabajo tendras la posibilidad",
		"de cosechar una cierta cantidad de toneladas. Cuanto mas coseches, mas te pagaran al final del dia.",
		"Si haces las cosas bien, a tiempo y sin error, eventualmente podras recibir un ascenso.",
		"_",
		true
	},
	{	//FIN JOB GRANJERO
		15, NODE_TYPE_JOB, 5000, CAMERA_MOVE, 0, 0, 0, 0, 0,
		-10.30, 107.28, 19.10, -14.70, 102.01, 14.37,
		-58.45, 84.26, 6.16, -191.22, -61.12, 32.13,
		"Por ultimo, ten en cuenta que puedes usar los comandos '/ayuda' y '/verempleo' para informacion",
		"mas detallada sobre tu trabajo. Ahora sientate en la cosechadora y disfruta del aire puro!",
		"_",
		"_",
		"_",
		false
	},
	{	//JOB TRANSPORTISTA 
		16, NODE_TYPE_JOB, 15000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		2243.25, -2206.44, 26.10, 2214.57, -2234.88, 26.10,
		2221.77, -2227.93, 15.07, 2195.09, -2254.05, 15.07,
		"iFelicidades, estas a punto de convertirte en camionero!. Esta es la central donde se encuentra",
		"la flota de vehiculos disponibles para trabajar. Tu labor consiste en tomar los pedidos de todos",
		"los negocios de la ciudad y entregarlos en tiempo y forma. Podras entregar varios pedidos, pero",
		"debes cuidarte de no llegar tarde y de mantener el vehiculo tal como lo recibiste. Si te esfuerzas",
		"lo suficiente, podras ascender, usar mejores transportes y acceder a una mejor paga.",
		true
	},
	{	//FIN JOB TRANSPORTISTA
		17, NODE_TYPE_JOB, 10000, CAMERA_MOVE, 0, 0, 0, 0, 0,
		2214.57, -2234.88, 26.10, 2198.26, -2273.67, 27.58,
		2195.09, -2254.05, 15.07, 2198.32, -2219.29, 15.24,
		"Por ultimo, si tienes alguna duda puedes utilizar los comandos '/ayuda' y '/verempleo' para mas",
		"informacion en detalle sobre tu trabajo. Los comerciantes dependen de que cumplas tu trabajo,",
		"no los decepciones. iA trabajar!",
		"_",
		"_",
		false
	},
	{	// JOB BASURERO
		18, NODE_TYPE_JOB, 15000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		2424.00, -2080.00, 29.00, 2453.22, -2109.79, 20.62,
		2453.41, -2104.23, 17.64, 2460.95, -2081.71, 14.88,
		" ¡Felicidades, ahora eres recolector de basura! Este es tu nuevo lugar de trabajo, y desde aqui empezaras todos",
		"tus recorridos. Tendras que cumplir diferentes trayectos para dejar a la ciudad libre de basura. Para cada re-",
		"corrido tambien es importante que lo hagas en el tiempo estipulado, procurando devolver el camion en el mismo",
		"estado en el que lo tomaste si no quieres tener descuentos en tu salario. Puedes invitar a otro basurero para",
		"hacer juntos el trabajo. En caso de trabajar asi, uno sera el conductor y el otro el recolector.",
		true
	},
	{	// FIN JOB BASURERO
		19, NODE_TYPE_JOB, 11000, CAMERA_MOVE, 0, 0, 0, 0, 0,
		2453.22, -2109.79, 20.62, 2432.68, -2093.83, 15.13,
		2460.95, -2081.71, 14.88, 2435.95, -2081.71, 14.88, 
		"Por ultimo, tambien debes saber que podras ganar o perder reputacion en base a tu esfuerzo, asi que procura hacer",
		"las cosas bien para optimizar tus ganancias. Si trabajas todos los dias y tienes cumples los objetivos, podras",
		"ascender y tener un mejor salario base, ademas de cuantiosas bonificaciones. iAhora a trabajar!",
		"_",
		"_",
		false
	},
	{	//JOB DELINCUENTE
		20, NODE_TYPE_JOB2, 15000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		1972.81, -1786.56, 8.23, 1972.81, -1808.70, 8.23,
		1972.81, -1808.70, 8.23, 1975.53, -1807.81, 8.23,
		"Estas a punto de empezar tu carrera como delincuente. Empezaras siendo un ladronzuelo de poca monta, asi",
		"que no esperes llenarte de dinero en poco tiempo, la vida de ladron no es nada facil. Poco a poco iras",
		"ganando experiencia que se ira transformando en nuevas formas de ejercer tu... noble labor. Ten en cuenta",
		"que todas tus acciones podrian o no ponerte en jaque frente a la Policia, asi que no te arriesgues por",
		"un robo o hurto peligroso, ni te expongas mucho tiempo.",
		true
	},
	{	//FIN JOB DELINCUENTE
		21, NODE_TYPE_JOB2, 10000, CAMERA_MOVE, 0, 0, 0, 0, 0,
		1995.82, -1829.41, 14.10, 2025.51, -1831.27, 14.10,
		2036.88, -1832.76, 14.10, 2036.88, -1832.76, 14.10,
		"Quien sabe, quizas pases de ser un malviviente de estos barrios a convertirte en el proximo protagonista",
		"del mayor robo realizado al Banco de Malos Aires. Tu ambicion y perseverancia seran claves. Por ultimo",
		"ten en cuenta que puedes usar '/ayuda' para mayor informacion sobre los comandos disponibles.",
		"_",
		"_",
		false
	},
	{	//JOB COSECHADOR MATERIA PRIMA 
		22, NODE_TYPE_JOB, 11000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		-1097.90, -1115.78, 136.51, -1050.90, -1115.78, 136.51,
		-1118.55, -1072.16, 136.51, -1061.55, -1072.16, 136.51,
		"Acabas de convertirte en un empleado de esta... granja de felicidad. Tu labor consiste en hacer lo que",
		"tu jefe te dice: cosechar , empaquetar y depositar todas las toneladas del producto que puedas.",
		"Es una labor sencilla... con la insignificante condicion de que estas al margen de la ley.",
		"_",
		"_",
		true
	},
	{	//FIN JOB COSECHADOR MATERIA PRIMA  ----- 
		23, NODE_TYPE_JOB, 9000, CAMERA_MOVE, 0, 0, 0, 0, 0,
		-1050.90, -1115.78, 136.51, -1064.30, -1149.52, 136.6,
		-1061.55, -1072.16, 136.51, -1044.66, -1171.00, 133.14,
		"No olvides de usar '/ayuda' para mayor informacion acerca de tu nuevo trabajo y, si haces las cosas",
		"bien, quizas tu adorable jefecito se piense en pagarte un poco mas.",
		"_",
		"_",
		"_",
		false
	},
	{	//JOB NARCOTRAFICANTE
		24, NODE_TYPE_JOB2, 10000, CAMERA_MOVE, 0, 0, 176, 0, 0,
		1803.35, -2168.54, 38.80, 1745.35, -2168.54, 38.80,
		1781.40, -2100.25, 20.65, 1706.40, -2100.25, 20.65,
		"Estos barrios te necesitan, y seguramente los de estratos superiores tambien. Ahora empieza",
		"tu trayectoria como narcotraficante, y tu principal labor consiste en conseguir las mejores",
		"drogas y distribuirlas a lo largo y ancho de todo Malos Aires. Las drogas generan dependencia",
		"por lo que asegurate de que llegue a todos lados y asi lograras que no puedan parar de",
		"comprarte.",
		true
	}, 
	{	//FIN JOB NARCOTRAFICANTE
		25, NODE_TYPE_JOB2, 10000, CAMERA_MOVE, 0, 0, 0, 0, 0,
		1745.35, -2168.54, 38.80, 1690.35, -2168.54, 38.80,
		1706.40, -2100.25, 20.65, 1646.40, -2100.25, 20.65,
		"Antes de que comiences, no olvide revisar los comandos '/ayuda' y '/comenzar' para obtener",
		"informacion mas detallada sobre el desarrollo de este empleo. Ten cuidado de la policia y",
		"ibuena suerte!",
		"_",
		"_",
		false
	},
	{	//JOB ELECTRICISTA
		26, NODE_TYPE_JOB, 12000, CAMERA_CUT, 0, 0, 176, 0, 0,
		1635.57, -1884.18, 19.02, 1635.57, -1884.18, 19.02,
		1635.57, -1884.18, 19.02, 1635.57, -1884.18, 19.02,
		"Acabas de convertirte en electricista de la ciudad. Tu labor consiste en reparar los postes electricos",
		"que se encuentran distribuidos por toda la zona. Cada trabajo te asignara 8 postes aleatorios que deberas",
		"reparar antes de que se agote el tiempo. Recuerda tomar la caja de herramientas de la parte trasera de tu",
		"camioneta con ALT antes de empezar a reparar cada poste. Cuando termines, devuelve el vehiculo al punto",
		"inicial para cobrar tu paga. Utiliza '/ayuda' y '/electricistainfo' para mas informacion.",
		false
	},
	{
		27, NODE_TYPE_INVALID, 0, 0, 0, 0, 0, 0, 0,
		0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
		0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
		"_",
		"_",
		"_",
		"_",
		"_",
		false
	}
};

//=================================================================================//
//==========================  IMPLEMENTACION DE FUNCIONES  ========================//
//=================================================================================//


//=============================[FUNCIONES DE TEXTDRAWS]=============================
stock CreatePlayerSceneTextDraws(playerid)
{
	BlackLayer_Down[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 353.000000, "_");
	PlayerTextDrawFont(playerid, BlackLayer_Down[playerid], 1);
	PlayerTextDrawLetterSize(playerid, BlackLayer_Down[playerid], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, BlackLayer_Down[playerid], 300.000000, 640.000000);
	PlayerTextDrawSetOutline(playerid, BlackLayer_Down[playerid], 0);
	PlayerTextDrawSetShadow(playerid, BlackLayer_Down[playerid], 0);
	PlayerTextDrawAlignment(playerid, BlackLayer_Down[playerid], 2);
	PlayerTextDrawColor(playerid, BlackLayer_Down[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, BlackLayer_Down[playerid], 255);
	PlayerTextDrawBoxColor(playerid, BlackLayer_Down[playerid], 255);
	PlayerTextDrawUseBox(playerid, BlackLayer_Down[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BlackLayer_Down[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, BlackLayer_Down[playerid], 0);

	BlackLayer_Up[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 0.000000, "_");
	PlayerTextDrawFont(playerid, BlackLayer_Up[playerid], 1);
	PlayerTextDrawLetterSize(playerid, BlackLayer_Up[playerid], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, BlackLayer_Up[playerid], 300.000000, 640.000000);
	PlayerTextDrawSetOutline(playerid, BlackLayer_Up[playerid], 0);
	PlayerTextDrawSetShadow(playerid, BlackLayer_Up[playerid], 0);
	PlayerTextDrawAlignment(playerid, BlackLayer_Up[playerid], 2);
	PlayerTextDrawColor(playerid, BlackLayer_Up[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, BlackLayer_Up[playerid], 255);
	PlayerTextDrawBoxColor(playerid, BlackLayer_Up[playerid], 255);
	PlayerTextDrawUseBox(playerid, BlackLayer_Up[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BlackLayer_Up[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, BlackLayer_Up[playerid], 0);

	Subtitle_Line1[playerid] = CreatePlayerTextDraw(playerid, 6.000000, 360.000000, "_");
	PlayerTextDrawFont(playerid, Subtitle_Line1[playerid], 1);
	PlayerTextDrawLetterSize(playerid, Subtitle_Line1[playerid], 0.279166, 1.350000);
	PlayerTextDrawTextSize(playerid, Subtitle_Line1[playerid], 633.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, Subtitle_Line1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Subtitle_Line1[playerid], 1);
	PlayerTextDrawAlignment(playerid, Subtitle_Line1[playerid], 1);
	PlayerTextDrawColor(playerid, Subtitle_Line1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Subtitle_Line1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Subtitle_Line1[playerid], -16777216);
	PlayerTextDrawUseBox(playerid, Subtitle_Line1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Subtitle_Line1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Subtitle_Line1[playerid], 0);

	Subtitle_Line2[playerid] = CreatePlayerTextDraw(playerid, 6.000000, 375.000000, "_");
	PlayerTextDrawFont(playerid, Subtitle_Line2[playerid], 1);
	PlayerTextDrawLetterSize(playerid, Subtitle_Line2[playerid], 0.279166, 1.350000);
	PlayerTextDrawTextSize(playerid, Subtitle_Line2[playerid], 633.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, Subtitle_Line2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Subtitle_Line2[playerid], 1);
	PlayerTextDrawAlignment(playerid, Subtitle_Line2[playerid], 1);
	PlayerTextDrawColor(playerid, Subtitle_Line2[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Subtitle_Line2[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Subtitle_Line2[playerid], -16777216);
	PlayerTextDrawUseBox(playerid, Subtitle_Line2[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Subtitle_Line2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Subtitle_Line2[playerid], 0);

	Subtitle_Line3[playerid] = CreatePlayerTextDraw(playerid, 6.000000, 390.000000, "_");
	PlayerTextDrawFont(playerid, Subtitle_Line3[playerid], 1);
	PlayerTextDrawLetterSize(playerid, Subtitle_Line3[playerid], 0.279166, 1.350000);
	PlayerTextDrawTextSize(playerid, Subtitle_Line3[playerid], 633.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, Subtitle_Line3[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Subtitle_Line3[playerid], 1);
	PlayerTextDrawAlignment(playerid, Subtitle_Line3[playerid], 1);
	PlayerTextDrawColor(playerid, Subtitle_Line3[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Subtitle_Line3[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Subtitle_Line3[playerid], -16777166);
	PlayerTextDrawUseBox(playerid, Subtitle_Line3[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Subtitle_Line3[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Subtitle_Line3[playerid], 0);

	Subtitle_Line4[playerid] = CreatePlayerTextDraw(playerid, 6.000000, 405.000000, "_");
	PlayerTextDrawFont(playerid, Subtitle_Line4[playerid], 1);
	PlayerTextDrawLetterSize(playerid, Subtitle_Line4[playerid], 0.279166, 1.350000);
	PlayerTextDrawTextSize(playerid, Subtitle_Line4[playerid], 633.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, Subtitle_Line4[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Subtitle_Line4[playerid], 1);
	PlayerTextDrawAlignment(playerid, Subtitle_Line4[playerid], 1);
	PlayerTextDrawColor(playerid, Subtitle_Line4[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Subtitle_Line4[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Subtitle_Line4[playerid], -16777166);
	PlayerTextDrawUseBox(playerid, Subtitle_Line4[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Subtitle_Line4[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Subtitle_Line4[playerid], 0);

	Subtitle_Line5[playerid] = CreatePlayerTextDraw(playerid, 6.000000, 420.000000, "_");
	PlayerTextDrawFont(playerid, Subtitle_Line5[playerid], 1);
	PlayerTextDrawLetterSize(playerid, Subtitle_Line5[playerid], 0.279166, 1.350000);
	PlayerTextDrawTextSize(playerid, Subtitle_Line5[playerid], 633.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, Subtitle_Line5[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Subtitle_Line5[playerid], 1);
	PlayerTextDrawAlignment(playerid, Subtitle_Line5[playerid], 1);
	PlayerTextDrawColor(playerid, Subtitle_Line5[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Subtitle_Line5[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Subtitle_Line5[playerid], -16777166);
	PlayerTextDrawUseBox(playerid, Subtitle_Line5[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Subtitle_Line5[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Subtitle_Line5[playerid], 0);

	Button_StepCinematic[playerid] = CreatePlayerTextDraw(playerid, 61.000000, 334.000000, "Click para saltear...");
	PlayerTextDrawFont(playerid, Button_StepCinematic[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Button_StepCinematic[playerid], 0.258332, 1.649999);
	PlayerTextDrawTextSize(playerid, Button_StepCinematic[playerid], 19.000000, 118.500000);
	PlayerTextDrawSetOutline(playerid, Button_StepCinematic[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Button_StepCinematic[playerid], 0);
	PlayerTextDrawAlignment(playerid, Button_StepCinematic[playerid], 2);
	PlayerTextDrawColor(playerid, Button_StepCinematic[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Button_StepCinematic[playerid], 1296911871);
	PlayerTextDrawBoxColor(playerid, Button_StepCinematic[playerid], 255);
	PlayerTextDrawUseBox(playerid, Button_StepCinematic[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Button_StepCinematic[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Button_StepCinematic[playerid], 1);

}

stock DestroyPlayerScenesTextDraws(playerid)
{
	PlayerTextDrawDestroy(playerid, BlackLayer_Down[playerid]);
	PlayerTextDrawDestroy(playerid, BlackLayer_Up[playerid]);
	PlayerTextDrawDestroy(playerid, Subtitle_Line1[playerid]);
	PlayerTextDrawDestroy(playerid, Subtitle_Line2[playerid]);
	PlayerTextDrawDestroy(playerid, Subtitle_Line3[playerid]);
	PlayerTextDrawDestroy(playerid, Subtitle_Line4[playerid]);
	PlayerTextDrawDestroy(playerid, Subtitle_Line5[playerid]);
	PlayerTextDrawDestroy(playerid, Button_StepCinematic[playerid]);
	return 1;
}

stock ShowTDSceneBackgroundForPlayer(playerid)
{
	PlayerTextDrawShow(playerid, BlackLayer_Down[playerid]);
	PlayerTextDrawShow(playerid, BlackLayer_Up[playerid]);
	PlayerTextDrawShow(playerid, Button_StepCinematic[playerid]);
	SelectTextDraw(playerid, 0xFF0000FF);
}

stock HideTDSceneBackgroundForPlayer(playerid)
{
	PlayerTextDrawHide(playerid, BlackLayer_Down[playerid]);
	PlayerTextDrawHide(playerid, BlackLayer_Up[playerid]);
	PlayerTextDrawHide(playerid, Button_StepCinematic[playerid]);
}

stock ShowTDSceneSubsForPlayer(playerid)
{
	PlayerTextDrawShow(playerid, Subtitle_Line1[playerid]);
	PlayerTextDrawShow(playerid, Subtitle_Line2[playerid]);
	PlayerTextDrawShow(playerid, Subtitle_Line3[playerid]);
	PlayerTextDrawShow(playerid, Subtitle_Line4[playerid]);
	PlayerTextDrawShow(playerid, Subtitle_Line5[playerid]);	
}

stock HideTDSceneSubsForPlayer(playerid)
{	
	PlayerTextDrawHide(playerid, Subtitle_Line1[playerid]);
	PlayerTextDrawHide(playerid, Subtitle_Line2[playerid]);
	PlayerTextDrawHide(playerid, Subtitle_Line3[playerid]);
	PlayerTextDrawHide(playerid, Subtitle_Line4[playerid]);
	PlayerTextDrawHide(playerid, Subtitle_Line5[playerid]);	
}
//==================================================================================

//===============================[FUNCIONES DE NODOS]===============================

stock Node_PlayerSetSceneString(playerid, node)
{
	new string[128];
	format(string, sizeof(string), "%s", ServerScene[node][strLine1]);
	PlayerTextDrawSetString(playerid, Subtitle_Line1[playerid], string);
	format(string, sizeof(string), "%s", ServerScene[node][strLine2]);
	PlayerTextDrawSetString(playerid, Subtitle_Line2[playerid], string);
	format(string, sizeof(string), "%s", ServerScene[node][strLine3]);
	PlayerTextDrawSetString(playerid, Subtitle_Line3[playerid], string);
	format(string, sizeof(string), "%s", ServerScene[node][strLine4]);
	PlayerTextDrawSetString(playerid, Subtitle_Line4[playerid], string);
	format(string, sizeof(string), "%s", ServerScene[node][strLine5]);
	PlayerTextDrawSetString(playerid, Subtitle_Line5[playerid], string);
}

stock Node_GetType(node)
{
	return ServerScene[node][sType];
}

stock Node_GetInt(node)
{
	return ServerScene[node][sInterior];
}

stock Node_GetVW(node)
{
	return ServerScene[node][sVirtualWorld];
}

stock Node_PlayerSetEmptySubLines(playerid)
{
	PlayerTextDrawSetString(playerid, Subtitle_Line1[playerid], "_");
	PlayerTextDrawSetString(playerid, Subtitle_Line2[playerid], "_");
	PlayerTextDrawSetString(playerid, Subtitle_Line3[playerid], "_");
	PlayerTextDrawSetString(playerid, Subtitle_Line4[playerid], "_");
	PlayerTextDrawSetString(playerid, Subtitle_Line5[playerid], "_");
}

stock Node_PlayerSetSceneIntAndVW(playerid, node)
{
	SetPlayerInterior(playerid, ServerScene[node][sInterior]);
	SetPlayerVirtualWorld(playerid, ServerScene[node][sVirtualWorld]);
}

stock Node_PlayerSetInterpolateCam(playerid, node)
{
	InterpolateCameraPos(playerid, ServerScene[node][sCamPosFromX], ServerScene[node][sCamPosFromY], ServerScene[node][sCamPosFromZ],
		ServerScene[node][sCamPosToX], ServerScene[node][sCamPosToY], ServerScene[node][sCamPosToZ], ServerScene[node][sTime], ServerScene[node][sCameraCut]);
	InterpolateCameraLookAt(playerid, ServerScene[node][sCamLookFromX], ServerScene[node][sCamLookFromY], ServerScene[node][sCamLookFromZ],
		ServerScene[node][sCamLookToX], ServerScene[node][sCamLookToY], ServerScene[node][sCamLookToZ], ServerScene[node][sTime], ServerScene[node][sCameraCut]);
}

stock Node_GetCantActorsInThisNode(node)
{
	new cant = 1;
	new i = 0;
	while(ActorNode[node + i][haveNextActor] == true)
	{
		cant++;
		i++;
	}
	return cant;
}
stock Node_ResetActorVar(playerid)
{
	for(new i = 0; i < MAX_ACTORS_PER_NODE; i++)
	{
		ActorsNodeID[playerid][i] = INVALID_ACTOR_ID;
	}
}

stock Node_SaveActorID(playerid, actorid)
{
	for(new i = 0; i < MAX_ACTORS_PER_NODE; i++)
	{
		if(ActorsNodeID[playerid][i] == INVALID_ACTOR_ID)
		{
			ActorsNodeID[playerid][i] = actorid;
			return 1;
		}
	}
	return 0;
}

stock Node_DestroyActors(playerid)
{
	for(new i= 0; i < MAX_ACTORS_PER_NODE; i++)
	{
		if(ActorsNodeID[playerid][i] != INVALID_ACTOR_ID)
		{
			DestroyActor(ActorsNodeID[playerid][i]);
			ActorsNodeID[playerid][i] = INVALID_ACTOR_ID;
		}
	}
	return 1;
}

stock Node_CreateActor(playerid, node)
{
	new skin;
	if(ActorNode[node][sSkin] == 0) 		//Si el skin del actor en el nodo es 0, significa que //
		skin = PlayerInfo[playerid][pSkin];	//este actor va a representar al playerid en la escena//
	else
		skin = ActorNode[node][sSkin];

	new actorid = CreateActor(skin, ActorNode[node][sX], ActorNode[node][sY], ActorNode[node][sZ], ActorNode[node][sAngle]);
	if(actorid == INVALID_ACTOR_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Máximode actores en el servidor alcanzado (1000). Reportar a un scripter.");
	Node_SaveActorID(playerid, actorid);
	SetActorVirtualWorld(actorid, ActorNode[node][sVWorld]);
	SetActorHealth(actorid, 100.0);
	SetActorInvulnerable(actorid, 1);
	ApplyActorAnimation(actorid, ActorNode[node][sAlib], ActorNode[node][sAname], 4.1, ActorNode[node][sAnimloop], 1, 1, 0, 0);
	return 1;
}

stock bool:NodeNeedToggleSpect(node)
{
	new type = Node_GetType(node);
	if(type == NODE_TYPE_JOB2 || type == NODE_TYPE_BUY_HOUSE || type == NODE_TYPE_BUY_VEHICLE || type == NODE_TYPE_BUY_BIZ) //si el tipo de nodo es una cinematica predefinida (actualizar segun se agregan nuevos tipos)
		return true;
	else return false;
}

stock bool:NodeNeedToggleControllable(node)
{
	if(Node_GetType(node) == NODE_TYPE_TOGG_CONT)
		return true;
	else return false;
}

stock bool:NodeHaveActors(node)
{
	if(ServerScene[node][sActorInfo] != 0)
		return true;
	else return false;
}

//==================================================================================

//=============================[FUNCIONES DE PERSONAJES]============================

stock SavePlayerStatsForScene(playerid)
{
	GetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
	PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
	PlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
	PlayerInfo[playerid][pSkin] = GetPlayerSkin(playerid);
	SetPVarFloat(playerid, "tempHealth", GetPlayerHealthEx(playerid));
}

stock ReturnPlayerOriginalPos(playerid)
{
	SetCameraBehindPlayer(playerid);
	SetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
	SetPlayerInterior(playerid, PlayerInfo[playerid][pInterior]);
	SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVirtualWorld]);
	KillSceneTimer(playerid);
	ActualNode[playerid] = 0;
}

stock KillSceneTimer(playerid)
{
	KillTimer(scene_timer[playerid]);
}

//==================================================================================

//===========================[CORE DE FUNCIONES PUBLICAS]===========================

public StopPlayerScene(playerid, node)
{
	PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
	if(NodeHaveActors(node))
	{
		Node_DestroyActors(playerid);
		Node_ResetActorVar(playerid);
	}
	if(NodeNeedToggleControllable(node)) {
		TogglePlayerControllable(playerid, true);
	}
	if(NodeNeedToggleSpect(node)) {
		TogglePlayerSpectating(playerid, false);
	}
	HideTDSceneSubsForPlayer(playerid);
	DestroyPlayerScenesTextDraws(playerid);
	ReturnPlayerOriginalPos(playerid);
	CancelSelectTextDraw(playerid);
	return 1;
}

//Comienza la secuencia de nodos para reproducir una escena
StartPlayerScene(playerid, firstnode, extraid = 0)
{
	Node_ResetActorVar(playerid); //seteamos todo a -1 por las dudas
	if(NodeNeedToggleControllable(firstnode))
		TogglePlayerControllable(playerid, 0);
	if(NodeNeedToggleSpect(firstnode))
		TogglePlayerSpectating(playerid, true);

	SavePlayerStatsForScene(playerid);
	CreatePlayerSceneTextDraws(playerid);
	ShowTDSceneBackgroundForPlayer(playerid);
	ShowTDSceneSubsForPlayer(playerid);
	scene_timer[playerid] = SetTimerEx("SetAndPlayPlayerNode", 100, false, "iii", playerid, firstnode, extraid);
	return 1;
}

public SetAndPlayPlayerNode(playerid, node, extraid)
{
	ActualNode[playerid] = node;
	if(ServerScene[node][sAudio] != 0)
		PlayerPlaySound(playerid, ServerScene[node][sAudio], 0.0, 0.0, 0.0);
	if(NodeHaveActors(node))
	{
		Node_DestroyActors(playerid); //borramos si hay actores de nodos anteriores
		for(new i = 0; i < ServerScene[node][sCantActors]; i++)
		{
			Node_CreateActor(playerid, ServerScene[node][sActorInfo] + i);
		}
	}
	switch(Node_GetType(node))
	{
		case NODE_TYPE_JOB, NODE_TYPE_JOB2:
		{
			Node_PlayerSetEmptySubLines(playerid);
			Node_PlayerSetSceneString(playerid, node);
			Node_PlayerSetSceneIntAndVW(playerid, node);
			Node_PlayerSetInterpolateCam(playerid, node);

			if(ServerScene[node][haveNextNode] == true)
				scene_timer[playerid] = SetTimerEx("SetAndPlayPlayerNode", ServerScene[node][sTime] + 1000, false, "iii", playerid, node + 1, extraid);
			else
			{
				scene_timer[playerid] = SetTimerEx("StopPlayerScene", ServerScene[node][sTime] + 1000, false, "ii", playerid, node);
			}
		}
		case NODE_TYPE_BUY_BIZ:
		{	
			Node_PlayerSetEmptySubLines(playerid);
			Node_PlayerSetSceneString(playerid, node);
			new biz = extraid;
			new Float:x1, Float:y1,
				Float:x2, Float:y2,
				Float:x3, Float:y3;
			GetXYInFrontOfPoint(Business[biz][bOutsideX], Business[biz][bOutsideY], Business[biz][bOutsideAngle], x1, y1, 15.0);
			GetXYInFrontOfPoint(Business[biz][bOutsideX], Business[biz][bOutsideY], Business[biz][bOutsideAngle] + 90.0, x2, y2, 3.0);
			GetXYInFrontOfPoint(Business[biz][bOutsideX], Business[biz][bOutsideY], Business[biz][bOutsideAngle] + 270.0, x3, y3, 3.0);
			InterpolateCameraPos(playerid, x1, y1, Business[biz][bOutsideZ] + 5, x1, y1, Business[biz][bOutsideZ] + 4, ServerScene[node][sTime], ServerScene[node][sCameraCut]);
			InterpolateCameraLookAt(playerid, x2, y2, Business[biz][bOutsideZ] + 1, x3, y3, Business[biz][bOutsideZ] + 1, ServerScene[node][sTime], ServerScene[node][sCameraCut]);
			scene_timer[playerid] = SetTimerEx("StopPlayerScene", ServerScene[node][sTime], false, "ii", playerid, node);
		}
		case NODE_TYPE_BUY_HOUSE:
		{
			Node_PlayerSetEmptySubLines(playerid);
			Node_PlayerSetSceneString(playerid, node);
			new hid = extraid;
			new Float:x1, Float:y1,
				Float:x2, Float:y2,
				Float:x3, Float:y3;
			GetXYInFrontOfPoint(House[hid][OutsideX], House[hid][OutsideY], House[hid][OutsideAngle], x1, y1, 15.0);
			GetXYInFrontOfPoint(House[hid][OutsideX], House[hid][OutsideY], House[hid][OutsideAngle] + 90.0, x2, y2, 3.0);
			GetXYInFrontOfPoint(House[hid][OutsideX], House[hid][OutsideY], House[hid][OutsideAngle] + 270.0, x3, y3, 3.0);
			InterpolateCameraPos(playerid, x1, y1, House[hid][OutsideZ] + 5, x1, y1, House[hid][OutsideZ] + 4, ServerScene[node][sTime], ServerScene[node][sCameraCut]);
			InterpolateCameraLookAt(playerid, x2, y2, House[hid][OutsideZ] + 1, x3, y3, House[hid][OutsideZ] + 1, ServerScene[node][sTime], ServerScene[node][sCameraCut]);
			scene_timer[playerid] = SetTimerEx("StopPlayerScene", ServerScene[node][sTime], false, "ii", playerid, node);
		}
		case NODE_TYPE_BUY_VEHICLE:
		{
			Node_PlayerSetEmptySubLines(playerid);
			Node_PlayerSetSceneString(playerid, node);
			Node_PlayerSetSceneIntAndVW(playerid, node);
			Node_PlayerSetInterpolateCam(playerid, node);
			scene_timer[playerid] = SetTimerEx("StopPlayerScene", ServerScene[node][sTime] + 1000, false, "ii", playerid, node);
		
		}	
	}
	return 1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(!ActualNode[playerid])
		return 0;

	if(playertextid == Button_StepCinematic[playerid]) {
		StopPlayerScene(playerid, ActualNode[playerid]);
		return ~1;
	}
	return 0;
}

hook OnPlayerClickTD(playerid, Text:clickedid)
{
	if(!ActualNode[playerid])
		return 0;

	if(clickedid == Text:INVALID_TEXT_DRAW) {
		StopPlayerScene(playerid, ActualNode[playerid]);
	}
	return 0;
}

hook OnPlayerDisconnect(playerid, reason)
{
	Node_DestroyActors(playerid);
	KillSceneTimer(playerid);
	ActualNode[playerid] = 0;
	return 1;
}


//==================================================================================

//====================================[COMANDOS]====================================
 
CMD:scenetest(playerid,params[])
{
	new nodeID;

	if(sscanf(params, "i", nodeID))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/scenetest [ID del nodo]");
	if(nodeID > TOTAL_NODES)
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "ID de nodo inválida!");
	StartPlayerScene(playerid, nodeID);
	return 1;
}

CMD:scenetestoff(playerid, params[])
{
	DestroyPlayerScenesTextDraws(playerid);
	TogglePlayerSpectating(playerid, false);
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	SetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
	SetPlayerInterior(playerid, PlayerInfo[playerid][pInterior]);
	SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVirtualWorld]);
	KillSceneTimer(playerid);
	ActualNode[playerid] = 0;
	return 1;
}