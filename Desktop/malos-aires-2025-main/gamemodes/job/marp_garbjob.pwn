#if defined _marp_jobgarb_included
	#endinput
#endif
#define _marp_jobgarb_included

#include <YSI_Coding\y_hooks>

#define JOB_GARB_MAX_PER_PAYDAY (3)
//#define GARB_BASE_SALARY        (1000)
#define GARB_BASE_SALARY   (JobInfo[JOB_GARB][jBaseSalary])
#define GARB_RANK_BONUS       	(100 / JOB_GARB_MAX_PER_PAYDAY)
#define GARB_SENIORITY_BONUS  	(1 / JOB_GARB_MAX_PER_PAYDAY)

#define JOB_GARB_TRAVEL_TIME	20 // Tiempo limite para terminar el recorrido, en minutos.

#define GARB_ROUTES_AMOUNT      3

#define GARB_ROUTE_SIZE         23

#define GARB_ROLE_BOTH          0
#define GARB_ROLE_DRIVER        1
#define GARB_ROLE_COLLECTOR     2

#define GARB_UNLOAD_X           2483.5029
#define GARB_UNLOAD_Y           -2106.6506
#define GARB_UNLOAD_Z           17.6315
#define GARB_UNLOAD_ANGLE       0

#define GARB_TAKE_X             2454.4373
#define GARB_TAKE_Y             -2107.1282
#define GARB_TAKE_Z             13.4674
#define GARB_TAKE_VW            0
#define GARB_TAKE_INT           0

#define GARB_STATE_NONE         0
#define GARB_STATE_ACTIVE       1
#define GARB_STATE_FIRED        2
#define GARB_STATE_QUITTED      3

#define GARB_REP_PENALTY        30 // Penalizacion en rep si se cancela o no se llega a tiempo
#define GARB_REP_COMPLETED		10 // Rep obtenida por entregar un trabajo

#define GARB_MAX_RANKS          5

#define GARB_PROMOTE_HOURS  	50 // Acumulativo por cada cargo
#define GARB_PROMOTE_REP    	500 // Acumulativo por cada cargo

#define GARB_FIRED_CALC_HOURS 	10  // Con hasta 10 horas trabajadas se realiza un calculo distinto para los despidos. Es para evitar que al empezar con una mala racha te despida. + de 10 horas ya aplica el calculo que utiliza el promedio de reputación ganada por trabajo.
#define GARB_FIRED_CALC_LIMIT  	-100 // Valor arbitrario usado para el calculo de despido dentro de las primeras 10 horas de trabajo. Si la reputacion alcanza a bajar hasta ese número, es despedido. Con -100, si se realizan los primeros 3/4 trabajos muy malos o se cancelan, se despide.

#define GARB_AVRG_REP_EXC       9.0 // Promedio de reputación obtenida por cada hora trabajada. Se utiliza para definir los strings a mostrar, y para el cálculo de despido
#define GARB_AVRG_REP_VGOOD     8.0
#define GARB_AVRG_REP_GOOD      7.0
#define GARB_AVRG_REP_NEUT      6.0
#define GARB_AVRG_REP_BAD       5.0
#define GARB_AVRG_REP_VBAD      4.0
#define GARB_AVRG_REP_FIRED     3.0

#define GARB_MSG_AMOUNT         1 // Numero de checkpoints en los cuales se va a informar si se está haciendo algo mal, para evitar flood en las demás paradas.

static const Float:j_garb_routes[GARB_ROUTES_AMOUNT][GARB_ROUTE_SIZE][4] = {
	{
		//recorrido sur
		{2331.8545, -1965.0039, 13.4562, 180.0},
		{2238.1299, -2045.9807, 13.4810, 315.0},
		{2207.5503, -2145.1775, 13.4749, 225.0},
		{2074.9993, -2102.3728, 13.4757, 180.0},
		{1900.1204, -2158.5566, 13.4768, 180.0},
		{1830.5618, -2071.2939, 13.4693, 90.0},
		{1969.3553, -2020.5752, 13.4557, 90.0},
		{1907.1594, -1925.0372, 13.4684, 180.0},
		{1828.9758, -1811.6189, 13.5043, 90.0},
		{1666.3481, -1724.6262, 13.4680, 180.0},
		{1562.1536, -1846.4064, 13.4748, 270.0},
		{1431.6094, -1864.7617, 13.4598, 180.0},
		{1199.8474, -1844.4851, 13.4913, 180.0},
		{1157.7164, -1697.8248, 13.8639, 90.0},
		{1060.4858, -1564.6882, 13.4890, 180.0},
		{1029.8259, -1685.8551, 13.4702, 270.0},
		{1089.8140, -1859.3690, 13.4819, 0.0},
		{1360.5540, -1875.5730, 13.4979, 338.0},
		{1522.3137, -1886.3962, 13.6368, 270.0},
		{1786.3708, -2173.8377, 13.4788, 0.0},
		{2121.8486, -2212.9954, 13.4809, 315.0},
		{2271.6326, -2057.9499, 13.4908, 135.0},
		{2234.7842, -1979.8428, 13.4743, 0.0}
	},
	{
	    //recorrido este
	    {2420.7927, -1749.2408, 13.4684, 90.0},
	    {2438.2061, -1525.1040, 23.9129, 90.0},
	    {2398.6005, -1398.1295, 23.9285, 90.0},
	    {2378.3928, -1309.3478, 23.9256, 90.0},
	    {2310.3362, -1228.6841, 23.9302, 90.0},
	    {2357.2349, -1161.5543, 27.4211, 0.0},
	    {2437.4160, -1190.8246, 36.2705, 0.0},
	    {2552.1858, -1191.5251, 60.8797, 0.0},
		{2703.0520, -1191.3312, 69.3480, 0.0},
		{2715.5037, -1436.9326, 30.3757, 270.0},
		{2851.0664, -1495.5804, 10.8398, 0.0},
		{2816.5820, -1636.7493, 10.8853, 270.0},
		{2817.3336, -1835.8069, 11.0204, 270.0},
		{2815.4369, -1976.2583, 11.0405, 270.0},
		{2721.8345, -2036.9697, 13.4744, 90.0},
		{2776.8108, -1931.5358, 13.4525, 90.0},
		{2649.8663, -1740.7475, 10.8240, 90.0},
		{2650.2553, -1462.4569, 30.3692, 90.0},
		{2519.2377, -1396.4189, 28.4375, 90.0},
		{2436.7292, -1248.9298, 23.7652, 180.0},
		{2334.7733, -1400.0727, 23.8619, 270.0},
		{2335.0767, -1545.9891, 23.9160, 270.0},
		{2335.3308, -1713.3245, 13.4791, 270.0}
	},
	{
	    //recorrido oeste
	    {2264.4556, -1744.7762, 13.4739, 180.0},
	    {2111.0342, -1744.8466, 13.4745, 180.0},
	    {1844.9091, -1744.7142, 13.4680, 180.0},
	    {1773.4175, -1599.3639, 13.4866, 163.0},
	    {1540.5861, -1584.3956, 13.4575, 180.0},
	    {1332.9111, -1520.2203, 13.4798, 55.0},
	    {1174.7184, -1387.5583, 13.4609, 180.0},
	    {940.1771, -1387.5974, 13.3371, 180.0},
	    {813.4580, -1312.1698, 13.4578, 180.0},
	    {643.8278, -1257.9711, 16.9548, 95.0},
	    {777.6740, -1062.8108, 24.6644, 12.0},
	    {921.7109, -1156.4493, 23.7463, 0.0},
	    {1329.8346, -1157.3145, 23.7598, 0.0},
	    {1489.6676, -1139.5941, 23.9831, 90.0},
	    {1509.0453, -1044.0610, 23.7284, 350.0},
	    {1692.3585, -1168.2639, 23.7493, 0.0},
	    {1731.7617, -1308.4481, 13.5049, 5.0},
	    {1839.0185, -1295.5061, 13.4705, 270.0},
	    {1829.5290, -1526.8621, 13.4593, 252.0},
	    {1933.7971, -1651.9954, 13.4707, 270.0},
	    {2030.3832, -1819.6574, 13.4612, 0.0},
	    {2155.7976, -1901.7020, 13.4606, 0.0},
	    {2284.2351, -1902.0316, 13.4974, 0.0}
    }
};

/*
j_garb_vec_id[MAX_PLAYERS]; //que contenga la id del vector dinamico con toda la info?

ejemplo:

j_garb_vec_id[playerid] = vector_create(); //o ambos podrian referenciar a la misma, usar la misma estructura de datos del trabajo que van a hacer para ambos
j_garb_vec_id[coworker] = vector_create();
vector_push_back(j_garb_vec_id[playerid], route);
vector_push_back(j_garb_vec__id[playerid], worker1_id);
vector_push_back(j_garb_vec_id[playerid], worker1_sqlid);
vector_push_back(j_garb_vec_id[playerid], worker2_id);
vector_push_back(j_garb_vec_id[playerid], worker2_sqlid);
vector_push_back(j_garb_vec_id[playerid], vehicle);
vector_push_back(j_garb_vec_id[playerid], checkpoint_count);
*/

/*
enum jg_winfo {
	jgWorking,
	jgRoute,
	jgCoworker,
	jgVehicle,
	Float:jgVehicleHp,
	jgVehicleObject,
	jgCheckpoint,
	jgRole,
	jgInvitation
};

new j_garb_w_info[MAX_PLAYERS][jg_winfo];
*/

new j_garb_working[MAX_PLAYERS],
 	j_garb_route[MAX_PLAYERS],
 	j_garb_coworker[MAX_PLAYERS],
 	j_garb_vehicle[MAX_PLAYERS],
 	Float:j_garb_vehicle_hp[MAX_PLAYERS],
 	j_garb_vehicle_object[MAX_PLAYERS],
	j_garb_checkpoint[MAX_PLAYERS],
	j_garb_role[MAX_PLAYERS],
	j_garb_invitation[MAX_PLAYERS],
	j_garb_cd_time[MAX_PLAYERS];

stock J_Garb_ResetVars(playerid)
{
	j_garb_working[playerid] = 0;
 	j_garb_route[playerid] = 0;
 	j_garb_coworker[playerid] = -1;
 	j_garb_vehicle[playerid] = 0;
	j_garb_vehicle_hp[playerid] = 1000.0;
	j_garb_vehicle_object[playerid] = INVALID_OBJECT_ID;
	j_garb_checkpoint[playerid] = 0;
	j_garb_role[playerid] = GARB_ROLE_BOTH;
    j_garb_invitation[playerid] = -1;
    j_garb_cd_time[playerid] = 0;
}

stock J_Garb_IsVehicleWorking(vehicleid)
{
 	foreach(new playerid : Player)
	{
	    if(j_garb_vehicle[playerid] == vehicleid)
	        return 1;
	}
	return 0;
}

#define J_Garb_IsPlayerWorking(%0)          (PlayerInfo[%0][pJob] == JOB_GARB && j_garb_working[%0])
#define J_Garb_GetRole(%0)                  j_garb_role[%0]
#define J_Garb_SetRole(%0,%1)               (j_garb_role[%0] = %1)
#define J_Garb_GetRoute(%0)                 j_garb_route[%0]
#define J_Garb_SetRoute(%0,%1)              (j_garb_route[%0] = %1)
#define J_Garb_GetVehicle(%0)              	j_garb_vehicle[%0]

JobGarb_GetWorkingVehicle(playerid) {
	return j_garb_vehicle[playerid];
}

#define J_Garb_SetVehicle(%0,%1)            (j_garb_vehicle[%0] = %1)
#define J_Garb_HasCoworker(%0)				(j_garb_coworker[%0] >= 0)
#define J_Garb_GetCoworker(%0)            	j_garb_coworker[%0]
#define J_Garb_SetCoworker(%0,%1)           (j_garb_coworker[%0] = %1)
#define J_Garb_GetCheckpoint(%0)            j_garb_checkpoint[%0]

enum jg_pinfo {
    jgWorkedHours,
	jgLastWorked[32],
	jgTotalProfits,
	jgRank,
	jgState,
	jgRep
};

new j_garb_p_info[MAX_PLAYERS][jg_pinfo];

stock J_Garb_ResetInfo(playerid)
{
	j_garb_p_info[playerid][jgWorkedHours] = 0;
	strcat(j_garb_p_info[playerid][jgLastWorked], "", 32);
	j_garb_p_info[playerid][jgTotalProfits] = 0;
	j_garb_p_info[playerid][jgRank] = 0;
	j_garb_p_info[playerid][jgState] = GARB_STATE_NONE;
	j_garb_p_info[playerid][jgRep] = 0;
}

CMD:basurerodebug(playerid, params[])
{
	new targetid;
	
	if(sscanf(params, "i", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/basurerodebug [ID]");

	if(targetid < 0 || targetid >= MAX_PLAYERS)
	    return SendClientMessage(playerid, COLOR_YELLOW2, "ID inválida.");
	    
	new str[128];
	
	format(str, sizeof(str), "Working: %d - Route: %d - Coworker: %d - Veh: %d - VehHp: %f - VehObject: %d - Checkpoint: %d - Role: %d - Invite: %d",
		j_garb_working[targetid],
	 	j_garb_route[targetid],
	 	j_garb_coworker[targetid],
	 	j_garb_vehicle[targetid],
		j_garb_vehicle_hp[targetid],
		j_garb_vehicle_object[targetid],
		j_garb_checkpoint[targetid],
		j_garb_role[targetid],
	    j_garb_invitation[targetid]
	);
	
	SendClientMessage(playerid, COLOR_WHITE, str);
	
	format(str, sizeof(str), "WorkedHours: %d - LastWorked: %s - TotalProfits: %d - Rank: %d - State: %d - Rep: %d",
		j_garb_p_info[targetid][jgWorkedHours],
		j_garb_p_info[targetid][jgLastWorked],
		j_garb_p_info[targetid][jgTotalProfits],
		j_garb_p_info[targetid][jgRank],
		j_garb_p_info[targetid][jgState],
		j_garb_p_info[targetid][jgRep]
	);
	
	SendClientMessage(playerid, COLOR_WHITE, str);

	return 1;
}

#define J_Garb_GetState(%0)                 j_garb_p_info[%0][jgState]
#define J_Garb_SetState(%0,%1)             	(j_garb_p_info[%0][jgState] = %1)
#define J_Garb_GetRep(%0)                   j_garb_p_info[%0][jgRep]
#define J_Garb_GetRank(%0)      	       	j_garb_p_info[%0][jgRank]
#define J_Garb_SetRank(%0,%1)            	(j_garb_p_info[%0][jgRank] = %1)
#define J_Garb_GetTotalProfits(%0)         	j_garb_p_info[%0][jgTotalProfits]
#define J_Garb_IncTotalProfits(%0,%1)       (j_garb_p_info[%0][jgTotalProfits] += %1)
#define J_Garb_GetWorkedHours(%0)          	j_garb_p_info[%0][jgWorkedHours]
#define J_Garb_IncWorkedHours(%0)           (j_garb_p_info[%0][jgWorkedHours]++)
#define J_Garb_GetLastWorked(%0)           	j_garb_p_info[%0][jgLastWorked]
#define J_Garb_UpdateLastWorked(%0)       	(j_garb_p_info[%0][jgLastWorked] = GetDateString())


stock J_Garb_GetRankName(rankid)
{
	new str[16];
	
	switch(rankid)
	{
		case 0: strcat(str, "Aprendiz", 16);
		case 1: strcat(str, "Recolector", 16);
		case 2: strcat(str, "Compactador", 16);
		case 3: strcat(str, "Chofer de camión", 16);
		case 4: strcat(str, "Supervisor", 16);
		default: strcat(str, "Error", 16);
	}
	
	return str;
}

stock J_Garb_GetRepString(playerid)
{
	new str[32];
	
	if(!j_garb_p_info[playerid][jgWorkedHours])
	{
	    if(j_garb_p_info[playerid][jgRep] < 0)
	    	strcat(str, "{FF5900}Mala{a9c4e4}", 32);
		else
	    	strcat(str, "{FFFF00}Es muy nuevo{a9c4e4}", 32);
    }
	else
	{
		new Float:average = float(j_garb_p_info[playerid][jgRep]) / float(j_garb_p_info[playerid][jgWorkedHours]);
		
		if(average >= GARB_AVRG_REP_EXC)
		{
		    strcat(str, "{00FF00}Excelente{a9c4e4}", 32);
      	}
		else if(average >= GARB_AVRG_REP_VGOOD)
		{
		    strcat(str, "{97D000}Muy buena{a9c4e4}", 32);
      	}
		else if(average >= GARB_AVRG_REP_GOOD)
		{
		    strcat(str, "{CFFF00}Buena{a9c4e4}", 32);
      	}
		else if(average >= GARB_AVRG_REP_NEUT)
		{
		    strcat(str, "{FFFF00}Neutral{a9c4e4}", 32);
      	}
		else if(average >= GARB_AVRG_REP_BAD)
		{
		    strcat(str, "{FFB900}Mala{a9c4e4}", 32);
      	}
		else if(average >= GARB_AVRG_REP_VBAD)
		{
		    strcat(str, "{FF5900}Muy mala{a9c4e4}", 32);
      	}
		else
		{
		    strcat(str, "{FF0000}Casi despedido{a9c4e4}", 32);
      	}
	}
	
	return str;
}

stock J_Garb_GiveRep(playerid, rep) {
	j_garb_p_info[playerid][jgRep] += rep;
}

stock J_Garb_CheckReputationLimit(playerid)
{
	if( (j_garb_p_info[playerid][jgWorkedHours] <= GARB_FIRED_CALC_HOURS && j_garb_p_info[playerid][jgRep] <= GARB_FIRED_CALC_LIMIT) || (j_garb_p_info[playerid][jgWorkedHours] > GARB_FIRED_CALC_HOURS && (float(j_garb_p_info[playerid][jgRep]) / float(j_garb_p_info[playerid][jgWorkedHours])) <= GARB_AVRG_REP_FIRED) )
	{
	    SendClientMessage(playerid, COLOR_WHITE, "{FF0000}=============================================================================================");
	    SendClientMessage(playerid, COLOR_WHITE, "[TELEGRAMA DEL EMPLEADOR]: Has sido {FF0000}despedido{FFFFFF} por tu pésima performance y reputación dentro de la empresa.");
	    SendClientMessage(playerid, COLOR_WHITE, "{FF0000}=============================================================================================");
	    J_Garb_SetState(playerid, GARB_STATE_FIRED);
		PlayerInfo[playerid][pJob] = 0;
		J_Garb_SaveData(playerid);
 	}
}

stock J_Garb_GetStateName(stateid)
{
	new str[16];

	switch(stateid)
	{
		case GARB_STATE_NONE: strcat(str, "Nunca trabajó", 16);
		case GARB_STATE_ACTIVE: strcat(str, "En actividad", 16);
		case GARB_STATE_FIRED: strcat(str, "Despedido", 16);
		case GARB_STATE_QUITTED: strcat(str, "Renunciaste", 16);
		default: strcat(str, "Error", 16);
    }
    
    return str;
}

J_Garb_LoadPickup()
{
	CreateDynamicPickup(1274, 1, GARB_TAKE_X, GARB_TAKE_Y, GARB_TAKE_Z, GARB_TAKE_VW);
    CreateDynamic3DTextLabel("{00FF00}[Empleo de basurero]{FFFFFF}\n/basureroinfo\n/basurerotomarempleo", COLOR_WHITE, GARB_TAKE_X, GARB_TAKE_Y, GARB_TAKE_Z + 0.75, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
}

CMD:basureroinfo(playerid, params[])
{
	if(GetPlayerJob(playerid) == JOB_GARB || IsPlayerInRangeOfPoint(playerid, 1.0, GARB_TAKE_X, GARB_TAKE_Y, GARB_TAKE_Z))
	{
 		if(J_Garb_GetState(playerid) == GARB_STATE_ACTIVE)
   		{
   		    new str[1280];
   		    
         	format(str, sizeof(str), "\n{00FF00}[Info]{a9c4e4}\nCargo: %s (%d)\nTrabajos realizados: %d\nUltimo día de trabajo: %s\nIngresos totales: $%d\nReputación: %s (%d)\nEstado laboral: %s\n\n\
			 	{00FF00}[Comandos disponibles]{a9c4e4}\n/basureroinfo /basurerotomarempleo /basurerorenunciar /basureroinvitar /basurerocomenzar /basurerocancelar\n\n\
				{00FF00}[Dinámica del trabajo]{a9c4e4}\nSube a un camión y usa /basurerocomenzar. Deberás ir por los puntos del mapa marcados en rojo, recoger a pie las bolsas de\nbasura de los contenedores, y luego arrojarlas al camión. Una vez terminado el recorrido, dirigete al basural, \
				sube la rampa\nen reversa, y ubica el camión próximo al borde, para poder descargar.\n\n{00FF00}[Tips]{a9c4e4}\nEn modo cooperativo (/basureroinvitar) un jugador hará de conductor y otro de recolector. No podrán cambiar las tareas.\n\
				El recolector puede viajar en la plataforma especial de la derecha, sin necesidad de subir como acompañante.\nPara recoger / arrojar las bolsas, debes tener ambas manos libres y mirar hacia el contenedor / cola del camión.\n\
				Si entregas el camión en mal estado, sufrirás una penalizacion de dinero y reputación. De ser así, quizás te convenga\npasar por el mecánico antes de descargar, si todavía te queda tiempo.",
			    J_Garb_GetRankName(J_Garb_GetRank(playerid)),
			    J_Garb_GetRank(playerid) + 1,
			    J_Garb_GetWorkedHours(playerid),
			    J_Garb_GetLastWorked(playerid),
			    J_Garb_GetTotalProfits(playerid),
				J_Garb_GetRepString(playerid),
			    J_Garb_GetRep(playerid),
		    	J_Garb_GetStateName(J_Garb_GetState(playerid))
			);

            Dialog_Show(playerid, J_Garb_Dlg_Info1, DIALOG_STYLE_MSGBOX, "EMPLEO DE BASURERO", str, "Cerrar", "");
		}
        else
        {
		    new str[280];

		    if(J_Garb_GetState(playerid) == GARB_STATE_NONE)
			{
				format(str, sizeof(str), "\nCargo en el que comienzas: %s\nSalario base: $%d\n\nEn esta empresa tendrás la oportunidad de escalar puestos y mejorar tus ganancias\nsi tienes un buen desempeño. Pero también ten en cuenta que podrás ser despedido si tu desempeño es malo.",
				    J_Garb_GetRankName(0),
					GARB_BASE_SALARY
				);
			}
			else
			{
				if(J_Garb_GetState(playerid) == GARB_STATE_FIRED)
				{
			    	strcat(str, "Has sido {FF0000}despedido{a9c4e4} por mal desempeño y no podrás tomar nuevamente el empleo.");
	            }
				else if(J_Garb_GetState(playerid) == GARB_STATE_QUITTED)
				{
			        strcat(str, "Renunciaste a este empleo. Si decides regresar conservarás tu antiguedad, pero\nperderás el cargo alcanzado.");
	            }

				format(str, sizeof(str), "\nCargo: %s (%d)\nTrabajos realizados: %d\nUltimo dÃ­a de trabajo: %s\nIngresos totales: $%d\nReputación: %s (%d)\nEstado laboral: %s\n\n%s",
				    J_Garb_GetRankName(J_Garb_GetRank(playerid)),
				    J_Garb_GetRank(playerid) + 1,
				    J_Garb_GetWorkedHours(playerid),
				    J_Garb_GetLastWorked(playerid),
				    J_Garb_GetTotalProfits(playerid),
				    J_Garb_GetRepString(playerid),
				    J_Garb_GetRep(playerid),
				    J_Garb_GetStateName(J_Garb_GetState(playerid)),
				    str
				);
	        }
	        
	        Dialog_Show(playerid, J_Garb_Dlg_Info2, DIALOG_STYLE_MSGBOX, "EMPLEO DE BASURERO", str, "Cerrar", "");
        }
    }
    
	return 1;
}

CMD:basurerorenunciar(playerid, params[])
{
	if(GetPlayerJob(playerid) != JOB_GARB)
		return 1;
	if(!Job_CanPlayerResign(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya has trabajado el día de hoy. Para poder tomar o renunciar a un empleo debes no haber efectuado ningún trabajo en el día.");
	if(J_Garb_IsPlayerWorking(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes hacerlo mientras estás trabajando!");
	if(!IsPlayerInRangeOfPoint(playerid, 1.0, GARB_TAKE_X, GARB_TAKE_Y, GARB_TAKE_Z))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en el lugar correcto, debes presentar la renuncia ante tu jefe, en tu lugar de trabajo.");

	J_Garb_SetState(playerid, GARB_STATE_QUITTED);
	PlayerInfo[playerid][pJob] = 0;
	SendClientMessage(playerid, COLOR_WHITE, "Has renunciado a tu empleo de basurero. Conservarás la antiguedad pero perderás el cargo si decides tomarlo nuevamente.");
	J_Garb_SaveData(playerid);

	return 1;
}

CMD:basurerocancelar(playerid, params[])
{
	if(!J_Garb_IsPlayerWorking(playerid))
		return 1;

    PlayerInfo[playerid][pCantWork]++;
    jobDuty[playerid] = false;

	if(J_Garb_HasCoworker(playerid))
	{
	    new coworkerid = J_Garb_GetCoworker(playerid);

	    if(IsValidObject(j_garb_vehicle_object[coworkerid]))
			DestroyObject(j_garb_vehicle_object[coworkerid]);
		if(J_Garb_GetRole(playerid) == GARB_ROLE_DRIVER)
			SetEngine(j_garb_vehicle[playerid], 0);
        j_garb_role[coworkerid] = GARB_ROLE_BOTH;
        j_garb_coworker[coworkerid] = -1;
        SendClientMessage(coworkerid, COLOR_WHITE, "[OOC]: Tu compañero de trabajo ha abandonado. Continúa tú solo con el trabajo de hoy.");

       	if(j_garb_checkpoint[coworkerid] < GARB_ROUTE_SIZE) // Todavía no habían terminado de recolectar
			SetPlayerCheckpoint(coworkerid, j_garb_routes[j_garb_route[coworkerid]][j_garb_checkpoint[coworkerid]][0], j_garb_routes[j_garb_route[coworkerid]][j_garb_checkpoint[coworkerid]][1], j_garb_routes[j_garb_route[coworkerid]][j_garb_checkpoint[coworkerid]][2], 1.0);
		else //Estaban yendo a descargar
		    SetPlayerCheckpoint(coworkerid, GARB_UNLOAD_X, GARB_UNLOAD_Y, GARB_UNLOAD_Z, 4.0);
    }
	else
    {
    	SetVehicleToRespawn(j_garb_vehicle[playerid]);
    }

	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	PlayerInfo[playerid][pJobSkin] = 0;
    Cronometro_Borrar(playerid);
	DisablePlayerCheckpoint(playerid);
	J_Garb_ResetVars(playerid);
	SendFMessage(playerid, COLOR_WHITE, "Has abandonado tu jornada de trabajo. Recibes una penalizacion de ({FF0000}- %d{FFFFFF}) en tu reputación.", GARB_REP_PENALTY);
	J_Garb_GiveRep(playerid, -GARB_REP_PENALTY);

	return 1;
}

CMD:basurerotomarempleo(playerid, params[])
{
    if(Faction_IsValidId(PlayerInfo[playerid][pFaction]) && Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_ALLOW_JOB))
    	return SendClientMessage(playerid,COLOR_ERROR,"[ERROR] "COLOR_EMB_GREY" ¡No puedes tomar este empleo perteneciendo a esta facción!");
    	
    if(GetPlayerJob(playerid) != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"!Ya tienes un empleo!");
		
	if(!IsPlayerInRangeOfPoint(playerid, 1.0, GARB_TAKE_X, GARB_TAKE_Y, GARB_TAKE_Z))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en el lugar correcto.");
		
	if(!Job_CanPlayerTake(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya has trabajado el día de hoy. Para poder tomar o renunciar a un empleo debes no haber efectuado ningún trabajo en el día.");

	if(J_Garb_GetState(playerid) == GARB_STATE_FIRED)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Has sido despedido por mal desempeño y no podrás tomar nuevamente el empleo.");

	if(J_Garb_GetState(playerid) == GARB_STATE_QUITTED)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Empleador: Ya que habías renunciado a este empleo, conservarás tu antiguedad, pero perderás el cargo alcanzado y empezarás de cero.");
		J_Garb_SetRank(playerid, 0);
	}
	else
	{
		SendFMessage(playerid, COLOR_WHITE, "Empleador: Bienvenido a nuestra empresa, %s. Empezarás como %s.  ¡Suerte y a trabajar!", GetPlayerCleanName(playerid), J_Garb_GetRankName(0));
	}

	PlayerInfo[playerid][pJob] = JOB_GARB;
	PlayerInfo[playerid][pJobTime] = JOB_WAITTIME;
	J_Garb_SetState(playerid, GARB_STATE_ACTIVE);
	J_Garb_UpdateLastWorked(playerid);
	J_Garb_SaveData(playerid);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" ¡Felicidades, ahora eres un basurero!. Para saber los comandos disponibles mira en /basureroinfo.");
	
	if(!PlayerInfo[playerid][pCarLic])
	    SendClientMessage(playerid, COLOR_WHITE, "Recuerda: hasta que no consigas licencia de manejo, solo podrás trabajar en cooperativo con otro jugador que si tenga y pueda conducir el camión.");

	return 1;
}

J_Garb_SaveData(playerid)
{
	new query[350];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `job_garb` \
			(`pID`,`WH`,`Rk`,`St`,`LW`,`TP`,`Rep`) \
		VALUES \
			(%i,%i,%i,%i,'%s',%i,%i) \
		ON DUPLICATE KEY UPDATE \
			WH=VALUES(WH),Rk=VALUES(Rk),St=VALUES(St),LW=VALUES(LW),TP=VALUES(TP),Rep=VALUES(Rep)",
		PlayerInfo[playerid][pID],
		J_Garb_GetWorkedHours(playerid),
		J_Garb_GetRank(playerid),
		J_Garb_GetState(playerid),
		J_Garb_GetLastWorked(playerid),
		J_Garb_GetTotalProfits(playerid),
		J_Garb_GetRep(playerid)
	);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}
	
J_Garb_LoadData(playerid)
{
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "OnJobGarbDataLoad", "i", playerid @Format: "SELECT * FROM `job_garb` WHERE `pID`=%i;", PlayerInfo[playerid][pID]);
	return 1;
}

forward OnJobGarbDataLoad(playerid);
public OnJobGarbDataLoad(playerid)
{
	if(cache_num_rows())
	{
		cache_get_value_name_int(0, "WH", j_garb_p_info[playerid][jgWorkedHours]);
		cache_get_value_name_int(0, "Rk", j_garb_p_info[playerid][jgRank]);
		cache_get_value_name_int(0, "St", j_garb_p_info[playerid][jgState]);
		cache_get_value_name_int(0, "Rep", j_garb_p_info[playerid][jgRep]);
		cache_get_value_name_int(0, "TP", j_garb_p_info[playerid][jgTotalProfits]);
		cache_get_value_name(0, "LW", j_garb_p_info[playerid][jgLastWorked], 32);
	}
	return 1;
}

J_Garb_SetJob(playerid, quitted = 0)
{
	if(quitted)
	{
	    J_Garb_SetState(playerid, GARB_STATE_QUITTED);
 		PlayerInfo[playerid][pJob] = 0;
	}
	else
	{
		PlayerInfo[playerid][pJob] = JOB_GARB;
		PlayerInfo[playerid][pJobTime] = JOB_WAITTIME;
  		J_Garb_SetState(playerid, GARB_STATE_ACTIVE);
		J_Garb_UpdateLastWorked(playerid);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" ¡Felicidades, ahora eres un basurero!. Para saber los comandos disponibles mira en /basureroinfo.");
	}
	
	J_Garb_SaveData(playerid);
}

J_Garb_OnPlayerDisconnect(playerid)
{
	if(J_Garb_IsPlayerWorking(playerid))
	{
        jobDuty[playerid] = false;
        
		if(J_Garb_HasCoworker(playerid))
		{
		    new coworkerid = J_Garb_GetCoworker(playerid);

		    if(IsValidObject(j_garb_vehicle_object[coworkerid]))
				DestroyObject(j_garb_vehicle_object[coworkerid]);

            j_garb_role[coworkerid] = GARB_ROLE_BOTH;
            j_garb_coworker[coworkerid] = -1;
            SendClientMessage(coworkerid, COLOR_WHITE, "[OOC]: Tu compañero de trabajo se ha desconectado. Continúa tú solo con el trabajo de hoy.");
            
           	if(j_garb_checkpoint[coworkerid] < GARB_ROUTE_SIZE) // Todavía no habían terminado de recolectar
				SetPlayerCheckpoint(coworkerid, j_garb_routes[j_garb_route[coworkerid]][j_garb_checkpoint[coworkerid]][0], j_garb_routes[j_garb_route[coworkerid]][j_garb_checkpoint[coworkerid]][1], j_garb_routes[j_garb_route[coworkerid]][j_garb_checkpoint[coworkerid]][2], 1.0);
			else //Estaban yendo a descargar
			    SetPlayerCheckpoint(coworkerid, GARB_UNLOAD_X, GARB_UNLOAD_Y, GARB_UNLOAD_Z, 4.0);
	    }
		else
        {
        	SetVehicleToRespawn(j_garb_vehicle[playerid]);
        }
    }
    
	J_Garb_ResetVars(playerid);
	J_Garb_ResetInfo(playerid);

	return 1;
}

CMD:basureroinvitar(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != JOB_GARB)
	    return 1;

	new targetid;
	
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/basureroinvitar [ID / Jugador]");	
	if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido.");
	if(!IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador se encuentra demasiado lejos.");
	if(PlayerInfo[targetid][pJob] != JOB_GARB)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene el empleo de basurero.");
	if(PlayerInfo[playerid][pCantWork] >= JOB_GARB_MAX_PER_PAYDAY || PlayerInfo[targetid][pCantWork] >= JOB_GARB_MAX_PER_PAYDAY)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Alguno de los dos ya ha trabajado lo suficiente en este día y debe esperar al Próximo día de pago.");
	if(j_garb_working[playerid] || j_garb_working[targetid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Alguno de los dos ya se encuentra trabajando!");
	if(!PlayerInfo[playerid][pCarLic] && !PlayerInfo[targetid][pCarLic])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Al menos uno de los dos debe tener una licencia de conducir.");
 	    
	new str[128];
	
	format(str, sizeof(str), "Has invitado a %s a realizar un trabajo cooperativo de basurero, espera su respuesta.", GetPlayerCleanName(targetid));
	SendClientMessage(playerid, COLOR_WHITE, str);
	
	format(str, sizeof(str), "%s (%d) te ha invitado a realizar un trabajo de basurero en modo cooperativo.", GetPlayerCleanName(playerid), playerid);
	Dialog_Show(targetid, Dlg_J_Garb_Invitation, DIALOG_STYLE_MSGBOX, "Invitación a trabajar", str, "Aceptar", "Rechazar");
	
	j_garb_invitation[playerid] = targetid;
	j_garb_invitation[targetid] = playerid;
	
	return 1;
}

Dialog:Dlg_J_Garb_Invitation(playerid, response, listitem, inputtext[])
{
	new inviteid = j_garb_invitation[playerid];

	if(inviteid == -1)
	    return 1;
		    
	if(response)
    {
        if(j_garb_invitation[inviteid] != playerid)
            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El personaje ya le ha ofrecido trabajar a otra persona.");

        SendClientMessage(inviteid, COLOR_WHITE, "Han aceptado tu invitación,  ¡a trabajar!");

		new driverid = playerid, //Asumo que playerid tiene licencia y asigno los roles de esta forma en un principio.
			collectorid = inviteid;
			
        // No tiene licencia, entonces el otro es el que tiene, y acomodo los roles de la forma correcta.

		// En este escenario playerid tiene licencia, pero se desconoce si el otro tiene. Luego, si la tiene, hay un 50% de probabilidad de que se inviertan los roles y le toque ser el conductor.
		
		if(!PlayerInfo[playerid][pCarLic] || (random(2) && PlayerInfo[inviteid][pCarLic]))
		{
		    driverid = inviteid;
		    collectorid = playerid;
		}

		j_garb_coworker[playerid] = inviteid;
		j_garb_coworker[inviteid] = playerid;
		j_garb_role[driverid] = GARB_ROLE_DRIVER;
		j_garb_role[collectorid] = GARB_ROLE_COLLECTOR;

		SendClientMessage(driverid, COLOR_WHITE, "Te ha tocado ser el conductor. Entra en un camión disponible y utiliza /basurerocomenzar.");
		SendClientMessage(collectorid, COLOR_WHITE, "Te ha tocado ser el recolector de bolsas. Súbete junto con el conductor al camión y comienza a trabajar.");
	}
	else
 	{
 	    SendClientMessage(playerid, COLOR_WHITE, "Has rechazado la invitación.");
	    SendClientMessage(inviteid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu invitación ha sido rechazada.");
 	}
	return 1;
}

CMD:basurerocomenzar(playerid, params[])
{
	if(GetPlayerJob(playerid) != JOB_GARB)
	    return 1;
	if(j_garb_working[playerid])
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Ya te encuentras trabajando!");
	if(PlayerInfo[playerid][pCantWork] >= JOB_GARB_MAX_PER_PAYDAY)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya has alcanzado el máximo de trabajos posibles por este día de pago.");	    
	if(J_Garb_GetRole(playerid) == GARB_ROLE_COLLECTOR)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el conductor, en esta ocasión te ha tocado ser el recolector de bolsas.");
	if(!PlayerInfo[playerid][pCarLic])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una licencia de conducir. No podrás conducir sin ella.");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en el asiento del conductor de un camión recolector.");
		
    new vehicleid = GetPlayerVehicleID(playerid);

	if(Veh_GetSystemType(vehicleid) != VEH_JOB || Veh_GetJob(vehicleid) != JOB_GARB || GetVehicleModel(vehicleid) != 408) // 408 = Camion Basurero - Trashmaster
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes ingresar a un camión recolector!");
   	if(J_Garb_IsVehicleWorking(vehicleid))
        return SendClientMessage(playerid, COLOR_YELLOW2, "Ese vehículo actualmente esta siendo usado por otros empleados, busca algún camión disponible.");
	if(!Cronometro_Crear(playerid, JOB_GARB_TRAVEL_TIME * 60, "J_Garb_TimeLimit"))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se pudo crear el cronómetro asociado al trabajo. Reportar a un administrador.");

	new route = random(GARB_ROUTES_AMOUNT);
	
	SetPlayerCheckpoint(playerid, j_garb_routes[route][0][0], j_garb_routes[route][0][1], j_garb_routes[route][0][2], 1.0);
	
	j_garb_working[playerid] = 1;
	j_garb_route[playerid] = route;
	j_garb_vehicle[playerid] = vehicleid;
	j_garb_checkpoint[playerid] = 0;
	GetVehicleHealth(vehicleid, j_garb_vehicle_hp[playerid]);
	jobDuty[playerid] = true;
	J_Garb_UpdateLastWorked(playerid);

	ClearAnimations(playerid);
	SetPlayerSkin(playerid, 16);
	PlayerInfo[playerid][pJobSkin] = 16;
	PutPlayerInVehicle(playerid, vehicleid, 0);
	
	SendClientMessage(playerid, COLOR_WHITE, "Completa el recorrido para dejar la ciudad libre de basura. Al finalizar serás recompensado por tu trabajo.");
 	SendClientMessage(playerid, COLOR_WHITE, "Para ver los comandos disponibles o información sobre la metodología general del trabajo, usa /basureroinfo.");

	if(J_Garb_HasCoworker(playerid))
	{
	    new coworkerid = J_Garb_GetCoworker(playerid);
	    
		SetPlayerSkin(coworkerid, 260); 
		PlayerInfo[playerid][pJobSkin] = 260;

	    SetPlayerCheckpoint(coworkerid, j_garb_routes[route][0][0], j_garb_routes[route][0][1], j_garb_routes[route][0][2], 1.0);
	
	    j_garb_working[coworkerid] = 1;
		j_garb_route[coworkerid] = route;
        j_garb_vehicle[coworkerid] = vehicleid;
		j_garb_checkpoint[coworkerid] = 0;
		j_garb_vehicle_hp[coworkerid] = j_garb_vehicle_hp[playerid];
		jobDuty[coworkerid] = true;
		J_Garb_UpdateLastWorked(coworkerid);
		
		SendClientMessage(coworkerid, COLOR_WHITE, "Completa el recorrido para dejar la ciudad libre de basura. Al finalizar serás recompensado por tu trabajo.");
		SendClientMessage(playerid, COLOR_WHITE, "Para ver los comandos disponibles o información sobre la metodología general del trabajo, usa /basureroinfo.");

		j_garb_vehicle_object[playerid] = CreateObject(2665, 0.0, 0.0, 2000.0, 0.0, 0.0, 0.0);
		SetObjectMaterial(j_garb_vehicle_object[playerid], 4, 16640, "a51", "airvent_gz", 0xFFD9FFD9);
		j_garb_vehicle_object[coworkerid] = j_garb_vehicle_object[playerid];
		AttachObjectToVehicle(j_garb_vehicle_object[playerid], vehicleid, -0.0100, -4.4900, -0.7200, 90.0, 0.0, 0.0);

		if(!Cronometro_Crear(coworkerid, JOB_GARB_TRAVEL_TIME * 60, "J_Garb_TimeLimit"))
	    	return SendClientMessage(coworkerid, COLOR_YELLOW2, "[SCRIPT ERROR]: No se pudo crear el cronómetro asociado al trabajo. Reportar a un administrador.");

	}
	return 1;
}

hook function OnPlayerEnterCPId(playerid, checkpointid)
{
    if(!J_Garb_IsPlayerWorking(playerid))
        return continue(playerid, checkpointid);

	if(j_garb_checkpoint[playerid] < GARB_ROUTE_SIZE)  // Todavía no termino de recolectar
	{
		if(J_Garb_GetRole(playerid) == GARB_ROLE_DRIVER)
	 	{
			SendClientMessage(playerid, COLOR_YELLOW2, "¡No eres el recolector de basura, en este momento tu tarea es conducir el camión!");
	 		return 1;
		}

		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
		    SetTimerEx("J_Garb_SetDelayedCheckpoint", 2000, false, "iffff", playerid, j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][0], j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][1], j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][2], 1.0);
		    SendClientMessage(playerid, COLOR_YELLOW2, "¡Debes estar a pie!");
		    return 1;
		}

		new Float:pangle;

		GetPlayerFacingAngle(playerid, pangle);

		if(!CheckIfAngleIsInRange(j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][3], pangle, 45.0)) //+- 45Â° de tolerancia
		{
		    SetTimerEx("J_Garb_SetDelayedCheckpoint", 2000, false, "iffff", playerid, j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][0], j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][1], j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][2], 1.0);
			if(J_Garb_GetCheckpoint(playerid) < GARB_MSG_AMOUNT)
		    {
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar mirando hacia el contenedor.");
            }
			PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0); // punch/error sound
			return 1;
		}

		if(GetHandItem(playerid, HAND_RIGHT) != 0 || GetHandItem(playerid, HAND_LEFT) != 0)
		{
		    SetTimerEx("J_Garb_SetDelayedCheckpoint", 2000, false, "iffff", playerid, j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][0], j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][1], j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][2], 1.0);
		    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes tener ambas manos vacías para recoger las bolsas de basura!");
		    return 1;
		}
		
		if(J_Garb_HasCoworker(playerid)) {
		    DisablePlayerCheckpoint(J_Garb_GetCoworker(playerid));
		}
		
		ApplyAnimationEx(playerid, "CASINO", "ROULETTE_WIN", 4.1, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		PlayerPlaySound(playerid, 1139, 0, 0, 0);

		SetTimerEx("J_Garb_SetDelayedGarbageBag", 1300, false, "ii", playerid, 1);

        if(J_Garb_GetCheckpoint(playerid) < GARB_MSG_AMOUNT)
        {
			SendClientMessage(playerid, COLOR_WHITE, "Arroja las bolsas de basura dentro del camion con la tecla ~k~~SNEAK_ABOUT~");
        }
	}
	else // Próximo paso: descargar
	{
	    if(J_Garb_GetRole(playerid) == GARB_ROLE_COLLECTOR)
		{
	    	SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo el conductor del camión puede realizar la maniobra de descarga de basura!");
	 		return 1;
		}
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || GetPlayerVehicleID(playerid) != J_Garb_GetVehicle(playerid))
		{
		    SetTimerEx("J_Garb_SetDelayedCheckpoint", 2000, false, "iffff", playerid, GARB_UNLOAD_X, GARB_UNLOAD_Y, GARB_UNLOAD_Z, 4.5);
		    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar como conductor del camión de basura!");
		    return 1;
		}

		new Float:vangle;
		
		GetVehicleZAngle(J_Garb_GetVehicle(playerid), vangle);

		if(!CheckIfAngleIsInRange(GARB_UNLOAD_ANGLE, vangle, 30.0)) //+- 30Â° de tolerancia
		{
		    SetTimerEx("J_Garb_SetDelayedCheckpoint", 2000, false, "iffff", playerid, GARB_UNLOAD_X, GARB_UNLOAD_Y, GARB_UNLOAD_Z, 4.5);
		    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡La cola del camión debe apuntar hacia el precipicio de la rampa!");
		    return 1;
		}
		
		if(J_Garb_HasCoworker(playerid)) {
		    DisablePlayerCheckpoint(J_Garb_GetCoworker(playerid));
		}
		
	    GameTextForPlayer(playerid, "Descargando la basura...", 5000, 4);
	    PlayerActionMessage(playerid, 15.0, "descarga las bolsas del camión en el basural.");
	    TogglePlayerControllable(playerid, false);
	    SetTimerEx("J_Garb_Unload", 5000, false, "i", playerid);

		foreach(new targetid : Player) {
		    PlayerPlaySound(targetid, 34601, GARB_UNLOAD_X, GARB_UNLOAD_Y, GARB_UNLOAD_Z);
		}
    }
	return 1;
}

forward J_Garb_Unload(playerid);
public J_Garb_Unload(playerid)
{
    if(!J_Garb_IsPlayerWorking(playerid))
        return 1;
        
	new Float:vhp;
	GetVehicleHealth(j_garb_vehicle[playerid], vhp);
	TogglePlayerControllable(playerid, true);
	J_Garb_IncWorkedHours(playerid);
	J_Garb_Pay(playerid, j_garb_vehicle_hp[playerid] - vhp); // El jugador al cual se le realiza el pago, y el daño en el hp del camión
	SetVehicleToRespawn(j_garb_vehicle[playerid]);
    PlayerInfo[playerid][pCantWork]++;
    jobDuty[playerid] = false;
	Cronometro_Borrar(playerid);
	
	if(J_Garb_HasCoworker(playerid))
	{
	    new coworkerid = J_Garb_GetCoworker(playerid);
	    
	    if(IsValidObject(j_garb_vehicle_object[coworkerid]))
			DestroyObject(j_garb_vehicle_object[coworkerid]);
	    
    	J_Garb_IncWorkedHours(coworkerid);
	    J_Garb_Pay(coworkerid, j_garb_vehicle_hp[coworkerid] - vhp);
	    PlayerInfo[coworkerid][pCantWork]++;
	    jobDuty[coworkerid] = false;
	    Cronometro_Borrar(coworkerid);
	    J_Garb_ResetVars(coworkerid);
	}
	
	J_Garb_ResetVars(playerid);

	return 1;
}

forward J_Garb_TimeLimit(playerid);
public J_Garb_TimeLimit(playerid)
{
    PlayerInfo[playerid][pCantWork]++;
    jobDuty[playerid] = false;
	SetVehicleToRespawn(j_garb_vehicle[playerid]);
	SendFMessage(playerid, COLOR_WHITE, "Te has pasado del tiempo Límite: tu jefe se ha enojado ({FF0000}- %d{FFFFFF} reputación) y no cobrará¡s tu paga.", GARB_REP_PENALTY);
 	J_Garb_GiveRep(playerid, -GARB_REP_PENALTY);
    DisablePlayerCheckpoint(playerid);
    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	PlayerInfo[playerid][pJobSkin] = 0;

	if(J_Garb_HasCoworker(playerid))
	{
	    new coworkerid = J_Garb_GetCoworker(playerid);
	    
    	if(IsValidObject(j_garb_vehicle_object[coworkerid]))
			DestroyObject(j_garb_vehicle_object[coworkerid]);
			
	    PlayerInfo[coworkerid][pCantWork]++;
	    jobDuty[coworkerid] = false;
		SendFMessage(coworkerid, COLOR_WHITE, "Te has pasado del tiempo Límite: tu jefe se ha enojado ({FF0000}- %d{FFFFFF} reputación) y no cobrará¡s tu paga.", GARB_REP_PENALTY);
		J_Garb_GiveRep(coworkerid, -GARB_REP_PENALTY);
		J_Garb_ResetVars(coworkerid);
		Cronometro_Borrar(coworkerid);
		DisablePlayerCheckpoint(coworkerid);
		SetPlayerSkin(coworkerid, PlayerInfo[coworkerid][pSkin]);
		PlayerInfo[coworkerid][pJobSkin] = 0;
	}

	J_Garb_ResetVars(playerid);

	return 1;
}

forward J_Garb_SetDelayedCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size);
public J_Garb_SetDelayedCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size)
{
	SetPlayerCheckpoint(playerid, x, y, z, size);
	return 1;
}

forward J_Garb_SetDelayedGarbageBag(playerid, giveitem);
public J_Garb_SetDelayedGarbageBag(playerid, giveitem)
{
	if(IsPlayerConnected(playerid))
	{
	    if(giveitem)
	    {
			SetHandItemAndParam(playerid, HAND_RIGHT, ITEM_ID_GARBAGE_BAG, 1);
			SetHandItemAndParam(playerid, HAND_LEFT, ITEM_ID_GARBAGE_BAG, 1);
		}
		else
		{
			SetHandItemAndParam(playerid, HAND_RIGHT, 0, 0);
			SetHandItemAndParam(playerid, HAND_LEFT, 0, 0);
		}
    }
	return 1;
}

J_Garb_OnPlayerPressKeyWalk(playerid)
{
	if(!J_Garb_IsPlayerWorking(playerid))
	    return 0;    
	if(J_Garb_GetRole(playerid) == GARB_ROLE_DRIVER)
	    return 0;    
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return 0;    
	if(GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_GARBAGE_BAG || GetHandItem(playerid, HAND_LEFT) != ITEM_ID_GARBAGE_BAG)
	    return 0;
	if((j_garb_cd_time[playerid] + 2) > gettime()) // Cooldown de 2 segundos para no spammear la tecla
		return 1;

	j_garb_cd_time[playerid] = gettime();

	if(J_Garb_HasCoworker(playerid))
	{
	    if(GetPlayerState(J_Garb_GetCoworker(playerid)) != PLAYER_STATE_DRIVER || GetPlayerVehicleID(J_Garb_GetCoworker(playerid)) != J_Garb_GetVehicle(playerid))
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El encargado de manejar el camión debe estar en el asiento del conductor para compactar la basura que recoges.");
			return 1;
		}
	}

	new Float:x, Float:y, Float:z, Float:vangle, Float:pangle;
	
	GetPlayerFacingAngle(playerid, pangle);
	GetVehicleZAngle(j_garb_vehicle[playerid], vangle);
	GetXYZBehindVehicle(j_garb_vehicle[playerid], x, y, z, 5.10); // Largo de TrashMaster: 10.70 mts

	if(!IsPlayerInRangeOfPoint(playerid, 1.5, x, y, z) || !CheckIfAngleIsInRange(vangle, pangle, 45.0)) // +- 45Â° de tolerancia
	{
		if(J_Garb_GetCheckpoint(playerid) < GARB_MSG_AMOUNT) {
	    	SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar detras del camión de basura con el cual comenzaste a trabajar, mirando hacia éste.");
        }
        PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0); // punch/error sound
		return 1;
	}
	
	ApplyAnimationEx(playerid, "RYDER", "VAN_THROW", 4.1, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	PlayerPlaySound(playerid, 1139, 0, 0, 0);
	SetTimerEx("J_Garb_SetDelayedGarbageBag", 600, false, "ii", playerid, 0);

	j_garb_checkpoint[playerid]++;

	if(j_garb_checkpoint[playerid] < GARB_ROUTE_SIZE) // Todavía no termino de recolectar
	{
		SetPlayerCheckpoint(playerid, j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][0], j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][1], j_garb_routes[j_garb_route[playerid]][j_garb_checkpoint[playerid]][2], 1.0);

		if(J_Garb_HasCoworker(playerid))
		{
		    new coworkerid = J_Garb_GetCoworker(playerid);
		    PlayerPlaySound(coworkerid, 1139, 0, 0, 0);
			j_garb_checkpoint[coworkerid]++;
			SetPlayerCheckpoint(coworkerid, j_garb_routes[j_garb_route[coworkerid]][j_garb_checkpoint[coworkerid]][0], j_garb_routes[j_garb_route[coworkerid]][j_garb_checkpoint[coworkerid]][1], j_garb_routes[j_garb_route[coworkerid]][j_garb_checkpoint[coworkerid]][2], 1.0);
		}
	}
	else // Próximo paso: descargar
	{
	    SetPlayerCheckpoint(playerid, GARB_UNLOAD_X, GARB_UNLOAD_Y, GARB_UNLOAD_Z, 2.0);

		if(J_Garb_HasCoworker(playerid))
		{
		    PlayerPlaySound(J_Garb_GetCoworker(playerid), 1139, 0, 0, 0);
			j_garb_checkpoint[J_Garb_GetCoworker(playerid)]++;
			SetPlayerCheckpoint(J_Garb_GetCoworker(playerid), GARB_UNLOAD_X, GARB_UNLOAD_Y, GARB_UNLOAD_Z, 2.0);
			SendClientMessage(playerid, COLOR_WHITE, "Ahora el conductor debe dirigirse a la zona de descarga de basura, subir el camión en reversa por la rampa, y acercar la cola al precipicio.");
			SendClientMessage(J_Garb_GetCoworker(playerid), COLOR_WHITE, "Ahora el conductor debe dirigirse a la zona de descarga de basura, subir el camión en reversa por la rampa, y acercar la cola al precipicio.");
		}
		else
		{
        	SendClientMessage(playerid, COLOR_WHITE, "Ahora dirígete a la zona de descarga de basura, sube el camión en reversa por la rampa, y acerca la cola al precipicio.");
        }
	}
	
	return 1;
}	

J_Garb_Pay(playerid, Float:vhp_dmg)
{
	new paycheck,
 		dmg_pay_penalty,
 		dmg_rep_penalty,
 		rank_bonus,
		seniority_bonus;

	if(vhp_dmg > 40.0)
	{
		dmg_rep_penalty = floatround(vhp_dmg / 10, floatround_ceil); // La reputación que baja es proporcional al daño del vehículo (un décimo)
		J_Garb_GiveRep(playerid, -dmg_rep_penalty);
		dmg_pay_penalty = floatround(vhp_dmg, floatround_ceil); // Descuenta lo mismo que perdió de hp el vehículo
	}
	else
	{
	    J_Garb_GiveRep(playerid, GARB_REP_COMPLETED);
	}

	rank_bonus = floatround(J_Garb_GetRank(playerid) * GARB_RANK_BONUS, floatround_ceil); // Extra por cargo
	seniority_bonus = floatround(J_Garb_GetWorkedHours(playerid) * GARB_SENIORITY_BONUS, floatround_ceil); 

	paycheck = GARB_BASE_SALARY + seniority_bonus + rank_bonus - dmg_pay_penalty;
	
	J_Garb_IncTotalProfits(playerid, paycheck);
	PlayerInfo[playerid][pPayCheck] += paycheck;
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);

	SendFMessage(playerid, COLOR_WHITE, " ¡Enhorabuena! has finalizado tu trabajo y recibirás $%d en el Próximo payday.", paycheck);
	SendFMessage(playerid, COLOR_WHITE, "[DETALLES] Salario base: $%d - Bonus por antiguedad: $%d - Extra por cargo: $%d - Descuento por daños: {FF0000}- $%d", GARB_BASE_SALARY, seniority_bonus, rank_bonus, dmg_pay_penalty);
	SendFMessage(playerid, COLOR_WHITE, "[REPUTACIÓN] Trabajo terminado: {00FF00}+ %d{FFFFFF} - Penalización por daños: {FF0000}- %d{FFFFFF} - Total de reputación: %d", GARB_REP_COMPLETED, dmg_rep_penalty, J_Garb_GetRep(playerid));

	if(J_Garb_GetRank(playerid) < (GARB_MAX_RANKS - 1)) // Si no llegó al rango máximo
	{
		if(J_Garb_GetWorkedHours(playerid) >= (GARB_PROMOTE_HOURS * (J_Garb_GetRank(playerid)+1)) && J_Garb_GetRep(playerid) >= (GARB_PROMOTE_REP * (J_Garb_GetRank(playerid)+1)))
		{
			J_Garb_SetRank(playerid, J_Garb_GetRank(playerid) + 1);
			SendFMessage(playerid, COLOR_YELLOW, " ¡Felicitaciones, tu esfuerzo ha sido recompensado! Fuiste ascendido a %s (%d). Ahora tendrás un bonus de $%d extras al salario base.", J_Garb_GetRankName(J_Garb_GetRank(playerid)), J_Garb_GetRank(playerid)+1, J_Garb_GetRank(playerid) * GARB_RANK_BONUS);
	    }
    }

    J_Garb_CheckReputationLimit(playerid);
}
