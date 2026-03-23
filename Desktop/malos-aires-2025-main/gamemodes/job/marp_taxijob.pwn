#if defined _marp_taxijob_included
	#endinput
#endif
#define _marp_taxijob_included

#include <YSI_Coding\y_hooks>

#define JOB_TAXI_MAX_NPC_CALLS_PER_PAYDAY (4)
#define Taxi_Tariff (JobInfo[JOB_TAXI][jBaseSalary])

const TAXI_CALLS_MAX_AMOUNT = 24;
const TAXI_CALL_RESET_ID = TAXI_CALLS_MAX_AMOUNT;
const INVALID_TAXI_CALL_ID = -1;
const TAXI_CALL_CREATE_TIME = 4; // Minutes
const TAXI_CALL_MAX_TEXT_LEN = 128;

static PHONE_HANDLE:JobTaxi_phoneId;

static enum e_JOB_TAXI_CALL_TYPES
{
	TAXI_NONE_CALL,
	TAXI_PLAYER_CALL,
	TAXI_ACTOR_CALL
}

static enum e_JOB_TAXI_CALL_INFO
{
	callTaken,
	Float:callPos[3],
	e_JOB_TAXI_CALL_TYPES:callType,
	callActor,
	callClientid,
	callClientSQLID,
	callText[TAXI_CALL_MAX_TEXT_LEN],
	callCreateTime
};

static TaxiCallsData[TAXI_CALLS_MAX_AMOUNT + 1][e_JOB_TAXI_CALL_INFO] = {
	{
		/*callTaken*/ 0,
		/*Float:callPos[3]*/ {0.0, 0.0, 0.0},
		/*e_JOB_TAXI_CALL_TYPES:callType*/ TAXI_NONE_CALL,
		/*callActor*/ INVALID_ACTOR_ID,
		/*callClientid*/ INVALID_PLAYER_ID,
		/*callClientSQLID*/ 0,
		/*callText[TAXI_CALL_MAX_TEXT_LEN]*/ "",
		/*callCreateTime*/ 0,
	}, ...
};

static Iterator:TaxiCallsData<TAXI_CALLS_MAX_AMOUNT>;

const JOB_TAXI_RESET_ID = MAX_PLAYERS;

static enum e_JOB_TAXI_DATA
{
	e_JOB_TAXI_ON_CALL,
	e_JOB_TAXI_CP_COUNT,
	e_JOB_TAXI_PAYMENT,
	e_JOB_TAXI_DRIVER_ID,
	e_JOB_TAXI_PLAYER_CALL_ID,
	e_JOB_TAXI_FARE
}

static JobTaxiData[MAX_PLAYERS + 1][e_JOB_TAXI_DATA] =
{
	{
		/*e_JOB_TAXI_ON_CALL*/ INVALID_TAXI_CALL_ID,
		/*e_JOB_TAXI_CP_COUNT*/ 0,
		/*e_JOB_TAXI_PAYMENT*/ 0,
		/*e_JOB_TAXI_DRIVER_ID*/ INVALID_PLAYER_ID,
		/*e_JOB_TAXI_PLAYER_CALL_ID*/ INVALID_TAXI_CALL_ID,
		/*e_JOB_TAXI_FARE*/ 0
	}, ...
};


// ACTOR CALLS

static enum e_JOB_TAXI_ACTOR_POS {
	Float:taxiActorX,
	Float:taxiActorY,
	Float:taxiActorZ,
	Float:taxiActorA
};

static JobTaxi_ActorPos[][e_JOB_TAXI_ACTOR_POS] = {
	{1189.58, -1362.68, 13.55, 270.0},
	{1141.19, -1411.46, 13.65, 360.0},
	{820.29, -1333.38, 13.54, 356.76},
	{671.42, -1286.61, 13.63, 90.0},
	{547.30, -1515.34, 14.59, 87.57},
	{375.63, -1827.63, 7.83, 90.0},
	{1598.31, -1321.01, 17.47, 270.0},
	{1993.28, -1439.62, 13.73, 90.0},
	{2265.12, -1340.90, 23.98, 270.0},
	{2238.62, -1144.80, 25.79, 346.77},
	{1794.12, -1860.40, 13.57, 358.39},
	{1597.74, -2324.85, 13.54, 0.0},
	{2005.73, -1266.81, 23.98, 360.0},
	{2426.41, -1250.28, 23.84, 180.0},
	{2648.64, -1384.75, 30.44, 90.0},
	{2536.78, -1509.93, 23.99, 0.0},
	{2368.25, -1754.96, 13.54, 0.0},
	{2262.82, -1755.18, 13.54, 0.0},
	{2706.90, -1881.78, 11.05, 158.15},
	{2648.46, -1672.04, 10.80, 90.0},
	{2775.69, -1944.59, 13.54, 90.0},
	{2667.16, -1998.36, 13.55, 180.0},
	{2555.24, -2392.88, 13.64, 316.64},
	{2214.63, -2173.55, 13.54, 135.0},
	{1631.52, -2248.02, 13.50, 180.0},
	{1281.24, -2050.70, 59.06, 180.0},
	{1423.40, -1712.19, 13.54, 270.0},
	{1538.28, -1668.58, 13.54, 90.0},
	{1817.60, -1575.17, 13.54, 263.41},
	{1826.93, -1664.80, 13.54, 90.0},
	{1563.51, -1878.20, 13.54, 360.0},
	{1319.27, -1389.59, 13.54, 180.0},
	{1036.73, -1134.67, 23.82, 180.0},
	{956.94, -1097.06, 23.71, 270.0},
	{651.73, -1756.29, 13.47, 351.44},
	{869.33, -1412.09, 13.16, 0.0},
	{990.82, -1314.02, 13.54, 180.0},
	{1460.65, -1354.54, 13.54, 90.0},
	{1709.10, -1338.30, 13.54, 270.0},
	{1841.26, -1388.26, 13.56, 270.0},
	{1475.14, -1166.80, 24.09, 0.0},
	{708.49, -479.35, 16.33, 180.0},
	{1043.32, -1612.4, 13.54, 90.0}
};

static Float:JobTaxi_ActorEndPos[][3] = {
	{2232.59, -2203.54,13.32},
	{1452.33, -1376.79, 13.58},
	{1717.06, -1370.11, 13.38},
	{1711.23, -2251.28, 13.38},
	{2671.89, -1660.13, 10.7},
	{1102.32, -1408.68, 13.45},
	{1208.74, -1320.47, 13.39},
	{960.22, -1117.88, 23.68},
	{800.30, -1350.26, 13.38},
	{527.42, -1512.67, 14.40},
	{405.47, -1775.35, 5.29},
	{808.03, -1740.53, 13.38},
	{1169.58, -1709.29, 13.65},
	{1427.09, -1699.81, 13.38},
	{1712.13, -1729.65, 13.38},
	{2251.73, -1303.42, 23.84},
	{2233.57, -1139.97, 25.62},
	{2065.14, -1284.36, 23.82},
	{2411.82, -1254.29, 23.82},
	{2490.04, -1507.00, 23.82},
	{2297.73, -1750.60, 13.58},
	{2411.23, -1795.32, 13.38},
	{2662.98, -1856.21, 10.88},
	{2767.54, -1944.02, 13.33},
	{2711.82, -2020.17, 13.32},
	{2573.62, -2406.26, 13.46},
	{1695.06, -2321.63, 13.38},
	{1251.14, -2052.97, 59.68},
	{1282.37, -1854.92, 13.39},
	{1535.78, -1675.75, 13.38},
	{1781.81, -1611.34, 13.35},
	{1819.58, -1695.44, 13.38},
	{1753.35, -1852.59, 13.41},
	{1575.80, -1874.89, 13.38},
	{1307.48, -1393.15, 13.27},
	{1000.32, -1138.04, 23.69},
	{662.96, -1295.87, 13.46},
	{562.86, -1244.51, 17.13},
	{820.81, -1786.47, 13.71},
	{914.83, -1514.96, 13.37},
	{1844.09, -1339.33, 13.39},
	{1442.16, -1157.85, 23.65},
	{639.06, -574.55, 16.18},
	{666.49, -482.74, 16.18},
	{1147.16, -1627.28, 13.78}
};

static JobTaxi_ActorSkins[] = {
	1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 17, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33,
	34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 46, 47, 48, 49, 53, 54, 55, 56, 57, 58, 59, 60, 65, 66, 67, 68, 69, 
	72, 73, 76, 88, 89, 90, 91, 93, 94, 95, 96, 98, 100, 101, 111, 112, 113, 117, 118, 119, 120, 121, 122, 123,
	124, 125, 126, 127, 141, 142, 143, 147, 148, 150, 151, 156, 163, 164, 165, 166, 169, 170, 171, 172, 167, 177,
	179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 190, 191, 192, 193, 194, 195, 206, 208, 210, 211, 215, 216, 
	217, 218, 219, 221, 222, 223, 224, 225, 226, 227, 228, 229, 231, 232, 233, 234, 235, 236, 240, 242, 247, 248, 
	249, 250, 254, 258, 259, 261, 262, 263, 272, 273, 290, 291, 292, 294, 295, 296, 297, 298, 299, 303, 304, 305     
};

hook OnGameModeInitEnded()
{
	JobTaxi_phoneId = Phone_Create(444, INVALID_PLAYER_ID);
	SetTimer("JobTaxi_CreateNewCalls", TAXI_CALL_CREATE_TIME * 60 * 1000, true);
	for (new i = 0; i <= TAXI_CALLS_MAX_AMOUNT; i++)
	{
		TaxiCallsData[i][callType] = TAXI_NONE_CALL;
		TaxiCallsData[i][callActor] = INVALID_ACTOR_ID;
		TaxiCallsData[i][callClientid] = INVALID_PLAYER_ID;
		TaxiCallsData[i][callText][0] = '\0';
	}
	return 1;

}

forward JobTaxi_CreateNewCalls();
public JobTaxi_CreateNewCalls() 
{
	for(new id = 0; id < TAXI_CALLS_MAX_AMOUNT; id++)
	{
		if(TaxiCallsData[id][callCreateTime] < gettime() && !TaxiCallsData[id][callTaken] && TaxiCallsData[id][callType] != TAXI_NONE_CALL)
			JobTaxi_DeleteCall(id);
	}

	if(JobTaxi_CountTaxis())
		JobTaxi_CreateCall(TAXI_ACTOR_CALL);

	return 1;
}

hook OnGameModeExit()
{
	Phone_Delete(JobTaxi_phoneId);
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	if(JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] == INVALID_TAXI_CALL_ID && JobTaxiData[playerid][e_JOB_TAXI_PLAYER_CALL_ID] != INVALID_TAXI_CALL_ID) 
	{
		JobTaxi_DeleteCall(JobTaxiData[playerid][e_JOB_TAXI_PLAYER_CALL_ID]);

		if(JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID] != INVALID_PLAYER_ID)
		{
			JobTaxiData[JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID]][e_JOB_TAXI_ON_CALL] = INVALID_TAXI_CALL_ID;
			SendClientMessage(JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID], COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La llamada fue cancelada. (OOC: el jugador se desconectó).");
		}
	} 
	else 
	{
		JobTaxi_DeleteCall(JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]);
	}
	
	JobTaxiData[playerid] = JobTaxiData[JOB_TAXI_RESET_ID];
	return 1;
}

JobTaxi_CountTaxis() 
{
	new count;
	foreach(new i : Player) {
		if(PlayerInfo[i][pJob] == JOB_TAXI && jobDuty[i]) {
			count++;
		}
	}	
	return count;
}

JobTaxi_CountFreeTaxis() 
{
	new count;
	foreach(new i : Player) {
		if(PlayerInfo[i][pJob] == JOB_TAXI && jobDuty[i] && JobTaxiData[i][e_JOB_TAXI_ON_CALL] == INVALID_TAXI_CALL_ID) {
			count++;
		}
	}	
	return count;
}

JobTaxi_CreateCall(e_JOB_TAXI_CALL_TYPES:calltype, clientid = INVALID_PLAYER_ID, text[128] = "")
{
    new callid = Iter_Free(TaxiCallsData);

	if(callid == ITER_NONE)
	{
		printf("[ERROR] Alcanzado TAXI_CALL_MAX_AMOUNT (%i). Iter_Count: %i.", TAXI_CALLS_MAX_AMOUNT, Iter_Count(TaxiCallsData));
		return INVALID_TAXI_CALL_ID;
	}
	if(calltype == TAXI_NONE_CALL) 
	{
		print("[ERROR] TAXI CALL SCRIPT - SE INTENTO REGISTRAR UNA LLAMADA DE TIPO: TAXI_NONE_CALL");
		return INVALID_TAXI_CALL_ID;
	}
	if(calltype == TAXI_PLAYER_CALL && clientid == INVALID_PLAYER_ID) 
	{
		print("[ERROR] TAXI CALL SCRIPT - SE INTENTO REGISTRAR UNA LLAMADA DE JUGADOR SIN: clientid");
		return INVALID_TAXI_CALL_ID;
	}

	new str[256];

	if(calltype == TAXI_ACTOR_CALL) 
	{
		new actorsgroup = random(sizeof(JobTaxi_ActorPos));
	
		TaxiCallsData[callid][callPos][0] = JobTaxi_ActorPos[actorsgroup][taxiActorX];
		TaxiCallsData[callid][callPos][1] = JobTaxi_ActorPos[actorsgroup][taxiActorY];
		TaxiCallsData[callid][callPos][2] = JobTaxi_ActorPos[actorsgroup][taxiActorZ];

		new area[MAX_ZONE_NAME];
		GetCoords2DZone(JobTaxi_ActorPos[actorsgroup][taxiActorX], JobTaxi_ActorPos[actorsgroup][taxiActorY], area, MAX_ZONE_NAME);
		format(str, sizeof(str), "[RADIO TAXI] Nueva llamada: Hola, necesitamos un taxi en %s", area);
		format(text, sizeof(text), "Hola, necesitamos un taxi en %s", area);

		new actor_skin = JobTaxi_ActorSkins[random(sizeof(JobTaxi_ActorSkins))];
		TaxiCallsData[callid][callActor] = CreateActor(actor_skin, JobTaxi_ActorPos[actorsgroup][taxiActorX], JobTaxi_ActorPos[actorsgroup][taxiActorY], JobTaxi_ActorPos[actorsgroup][taxiActorZ], JobTaxi_ActorPos[actorsgroup][taxiActorA]);
	} 
	else 
	{
		format(str, sizeof(str), "[RADIO TAXI] Nuevo SMS del %i: %s", PlayerInfo[clientid][pPhoneNumber], text);

		TaxiCallsData[callid][callClientid] = clientid;
		TaxiCallsData[callid][callClientSQLID] = getPlayerMysqlId(clientid);
		GetPlayerPos(clientid, TaxiCallsData[callid][callPos][0], TaxiCallsData[callid][callPos][1], TaxiCallsData[callid][callPos][2]);
	}

	foreach(new i : Player)
	{
		if(PlayerInfo[i][pJob] == JOB_TAXI && jobDuty[i])
		{
			SendClientMessage(i, COLOR_GREEN, str);
			SendClientMessage(i, COLOR_WHITE, "Use '/taxiverllamadas' para aceptar el llamado.");
		}
	}

	TaxiCallsData[callid][callType] = calltype;
	TaxiCallsData[callid][callCreateTime] = gettime() + (60 * 60);
	strcopy(TaxiCallsData[callid][callText], text, TAXI_CALL_MAX_TEXT_LEN);

    Iter_Add(TaxiCallsData, callid);
    return callid;
}

JobTaxi_DeleteCall(callid)
{
	if(!Iter_Contains(TaxiCallsData, callid))
		return 0;
    
	if(TaxiCallsData[callid][callActor] != INVALID_ACTOR_ID) 
	{
		DestroyActor(TaxiCallsData[callid][callActor]);
		TaxiCallsData[callid][callActor] = INVALID_ACTOR_ID;
	}

	TaxiCallsData[callid] = TaxiCallsData[TAXI_CALL_RESET_ID];
	Iter_Remove(TaxiCallsData, callid);
	return 1;
}

hook function OnSMSReceived(PHONE_HANDLE:phone, from_number)
{
	if(phone == JobTaxi_phoneId)
	{	
		new taxiAvailable, str[128];

		if(JobTaxi_CountFreeTaxis())
			taxiAvailable = 1;

		PhoneSMS_GetFirst(PHONE_HANDLE:phone, from_number, str);

		new clientid = Phone_GetPlayerid(Phone_GetNumberHandle(from_number));

		if(!strcmp(str, "Cancelar taxi", true))
		{
			JobTaxi_DeleteCall(JobTaxiData[clientid][e_JOB_TAXI_PLAYER_CALL_ID]);
			JobTaxiData[clientid][e_JOB_TAXI_PLAYER_CALL_ID] = INVALID_TAXI_CALL_ID;

			if(JobTaxiData[clientid][e_JOB_TAXI_DRIVER_ID] != INVALID_PLAYER_ID)
			{
				JobTaxiData[JobTaxiData[clientid][e_JOB_TAXI_DRIVER_ID]][e_JOB_TAXI_ON_CALL] = INVALID_TAXI_CALL_ID;
				SendFMessage(JobTaxiData[clientid][e_JOB_TAXI_DRIVER_ID], COLOR_WHITE, "%s cancelo la llamada. (OOC: Si consideras que abuso del sistema, toma una SS de este mensaje y reporta.)", GetPlayerCleanName(clientid));
				JobTaxiData[clientid][e_JOB_TAXI_DRIVER_ID] = INVALID_PLAYER_ID;
			}

			PhoneSMS_Send(phone, from_number, "Gracias por comunicarte con Radio Taxi. Su llamada fue cancelada exitosamente.");
			return continue(_:phone, from_number);
		}

		if(JobTaxiData[clientid][e_JOB_TAXI_PLAYER_CALL_ID] != INVALID_TAXI_CALL_ID) {
			PhoneSMS_Send(phone, from_number, "Gracias por comunicarte con Radio Taxi. Usted ya posee una llamada pendiente.");
			return continue(_:phone, from_number);
		}

		if(!taxiAvailable) {
			PhoneSMS_Send(phone, from_number, "Gracias por comunicarte con Radio Taxi. Desafortunadamente no hay vehículos disponibles en este momento, intenta más tarde.");
		}
		else
		{	
			new callid = JobTaxi_CreateCall(TAXI_PLAYER_CALL, .clientid = clientid, .text = str);	

			if(callid == INVALID_TAXI_CALL_ID) {
				PhoneSMS_Send(phone, from_number, "Gracias por comunicarte con Radio Taxi. Desafortunadamente no hay vehículos disponibles en este momento, intenta más tarde.");
			} else {
				JobTaxiData[clientid][e_JOB_TAXI_PLAYER_CALL_ID] = callid;
				SendClientMessage(clientid, COLOR_WHITE, "Puedes cancelar el taxi en cualquier momento enviando un mensaje al 444 diciendo 'Cancelar taxi'.");
				PhoneSMS_Send(phone, from_number, "Gracias por comunicarte con Radio Taxi. El mensaje fue recibido por un taxista, aguarda a que acepten tu solicitud.");	
			}
		}
	}
	
	return continue(_:phone, from_number);
}

JobTaxi_ShowCallsForPlayer(playerid)
{
	if(!Iter_Count(TaxiCallsData))
		return SendClientMessage(playerid, COLOR_WHITE, "No hay llamadas pendientes.");

	new line[128], string[3400] = "[N° Llamada]\tMensaje\t \n", count;

	foreach(new callid : TaxiCallsData)
	{
		if(!TaxiCallsData[callid][callTaken]) 
		{
			format(line, sizeof(line), "[%i]\t%s\t%s\n", callid, TaxiCallsData[callid][callText], (TaxiCallsData[callid][callType] == TAXI_PLAYER_CALL) ? ("((Jugador))") : ("((NPC))"));
			strcat(string, line, sizeof(string));
			count++;
		}
	}

	if(!count)
		return SendClientMessage(playerid, COLOR_WHITE, "No hay llamadas pendientes.");

	Dialog_Open(playerid, "DLG_TAXI_SHOW_CALLS", DIALOG_STYLE_TABLIST_HEADERS, "Central de Radio Taxis", string, "Tomar", "Cerrar");
	return 1;
}

Dialog:DLG_TAXI_SHOW_CALLS(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;
	if(PlayerInfo[playerid][pCantWork] >= JOB_TAXI_MAX_NPC_CALLS_PER_PAYDAY)
    	return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ya alcanzaste el límite de 4 llamados NPC por hora de pago.");

	new callid = INVALID_TAXI_CALL_ID;

	if(sscanf(inputtext, "p<]>'['i", callid) || !Iter_Contains(TaxiCallsData, callid))
		return 1;
	if(TaxiCallsData[callid][callTaken])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Esta llamada ya fue respondida por otro taxista.");


	if(TaxiCallsData[callid][callType] == TAXI_PLAYER_CALL) 
	{
		new clientid = TaxiCallsData[callid][callClientid];
		
		if(!(IsPlayerLogged(clientid) && getPlayerMysqlId(clientid) == TaxiCallsData[callid][callClientSQLID]))
			return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El cliente ha cancelado el llamado (OOC: el jugador se desconectó).");

		Noti_Create(playerid, 6000, "Has atendido una llamada, dirígete al punto rojo en el mapa.");
		MapMarker_CreateForPlayer(playerid, TaxiCallsData[callid][callPos][0], TaxiCallsData[callid][callPos][1], TaxiCallsData[callid][callPos][2], .color = COLOR_RED, .time = 150000);
		PhoneSMS_Send(JobTaxi_phoneId, PlayerInfo[clientid][pPhoneNumber], "Un taxista está en camino hacia tu ubicación, aguarda ahí.");
		SendClientMessage(playerid, COLOR_WHITE, "Utiliza '/taximetro [Id/Jugador]' para cobrar al finalizar el viaje ó '/taxicancelar' para cancelar el viaje.");
		JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] = callid;
		JobTaxiData[clientid][e_JOB_TAXI_DRIVER_ID] = playerid;
		return 1;
	}
	else 
	{
		// Cooldown only for NPC calls
		if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_TAXILLAMADASNPC))
			return 1;

		Noti_Create(playerid, 6000, "Has atendido una llamada, dirígete al punto rojo en el mapa. Puedes utilizar '/taxicancelar' para cancelar el viaje.");
		SetPlayerCheckpoint(playerid, TaxiCallsData[callid][callPos][0], TaxiCallsData[callid][callPos][1], TaxiCallsData[callid][callPos][2], 5.0);
		TaxiCallsData[callid][callTaken] = 1;
		PlayerInfo[playerid][pCantWork]++;
	}

	JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] = callid;
	
	if(JobTaxi_CountFreeTaxis())
		JobTaxi_CreateCall(TAXI_ACTOR_CALL);

	CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_TAXILLAMADASNPC, .seconds = TAXI_CALL_CREATE_TIME * 60);
	return 1;
}

hook function OnPlayerEnterCPId(playerid, checkpointid)
{ 
	if(JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] != INVALID_TAXI_CALL_ID && PlayerInfo[playerid][pJob] == JOB_TAXI && jobDuty[playerid]) 
	{
		if(TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callType] == TAXI_ACTOR_CALL)
		{
			if(JobTaxiData[playerid][e_JOB_TAXI_CP_COUNT])
			{
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);

				new Float:distance = GetDistance2D(TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callPos][0], TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callPos][1], x, y);

				PlayerCmeMessage(playerid, 15.0, 5000, "Para el taxímetro y le indica el monto a su cliente.");

				new str[128];
				format(str, sizeof(str), "El cliente toma dinero de su billetera y paga a %s.", GetPlayerCleanName(playerid));
				PlayerDoMessage(playerid, 15.0, str);

				new tip = (PlayerJobInfo[playerid][pCharge] - 1) * 50;
				new payment = floatround(distance * (25 + random(51)) / 100 * 0.9, floatround_ceil) + tip;
				GivePlayerCash(playerid, payment);
				JobTaxi_DeleteCall(JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]);
				JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] = INVALID_TAXI_CALL_ID;

				GameTextForPlayer(playerid, "~w~Espera a que el cliente baje", 3500, 4);
			} 
			else 
			{
				if(jobVehicle[playerid] != GetPlayerVehicleID(playerid)) 
				{
					SetTimerEx("JobTaxi_ResetCheckPoint", 3500, false, "i", playerid);
					return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en el taxi con el que empezaste a trabajar!");
				}

				GameTextForPlayer(playerid, "~w~Espera a que el cliente suba.", 3500, 4);
			}

			TogglePlayerControllable(playerid, false);
			PlayerInfo[playerid][pDisabled] = DISABLE_FREEZE;
			SetTimerEx("JobTaxi_UpdateNPCCall", 3500, false, "i", playerid);
		}
	}
	
	return continue(playerid, checkpointid);
}

forward JobTaxi_ResetCheckPoint(playerid); 
public JobTaxi_ResetCheckPoint(playerid)
{
	if(JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] != INVALID_TAXI_CALL_ID) {
		SetPlayerCheckpoint(playerid, TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callPos][0], TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callPos][1], TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callPos][2], 5.0);
	}
	return 1;
}

forward JobTaxi_UpdateNPCCall(playerid); 
public JobTaxi_UpdateNPCCall(playerid)
{
	if(!JobTaxiData[playerid][e_JOB_TAXI_CP_COUNT])
	{
		JobTaxiData[playerid][e_JOB_TAXI_CP_COUNT]++;

		new Float:distance, count, endpoint;
		while(distance < 200.0 || count < sizeof(JobTaxi_ActorEndPos))
		{
			endpoint = random(sizeof(JobTaxi_ActorEndPos));
			distance = GetDistance2D(TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callPos][0], TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callPos][1], JobTaxi_ActorEndPos[endpoint][0], JobTaxi_ActorEndPos[endpoint][1]);
			count++;
		}

		new area[MAX_ZONE_NAME], str[128];
		GetCoords2DZone(JobTaxi_ActorEndPos[endpoint][0], JobTaxi_ActorEndPos[endpoint][1], area, MAX_ZONE_NAME);
		format(str, sizeof(str), "El ciente dice: Vamos hasta %s.", area);
		SetPlayerCheckpoint(playerid, JobTaxi_ActorEndPos[endpoint][0], JobTaxi_ActorEndPos[endpoint][1], JobTaxi_ActorEndPos[endpoint][2], 5.0);
		PlayerDoMessage(playerid, 15.0, str);
		PlayerCmeMessage(playerid, 15.0, 5000, "Inicia el taximetro.");

		if(TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callActor] != INVALID_ACTOR_ID)
		{
			DestroyActor(TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callActor]);
			TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callActor] = INVALID_ACTOR_ID;
		}
	}
	else 
	{
		JobTaxiData[playerid][e_JOB_TAXI_CP_COUNT] = 0;
		Job_GiveReputation(playerid, 1);
	}

	TogglePlayerControllable(playerid, true);
	PlayerInfo[playerid][pDisabled] = DISABLE_NONE;	
	return 1;
}

hook cmd_trabajar(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != JOB_TAXI)
		return 1;
	if(Veh_GetJob(GetPlayerVehicleID(playerid)) != JOB_TAXI)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en tu taxi!");
	if(PlayerInfo[playerid][pCarLic] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una licencia de conducir. No podrás trabajar sin ella.");
	if(jobDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya te encuentras trabajando. Utiliza '/terminar' para dejar de trabajar.");
	
	new str[128];
	format(str, sizeof(str), "Anuncio: un taxista se encuentra en servicio (Tarifa por km: $%i). Puedes comunicarte vía SMS al 444.", Taxi_Tariff);
	SendClientMessageToAll(COLOR_LIGHTGREEN, str);
	SendClientMessage(playerid, COLOR_WHITE, "Ahora recibirás los llamados de los clientes. Cuando quieras dejar de trabajar, utiliza nuevamente /trabajar.");
	jobDuty[playerid] = true;
	jobVehicle[playerid] = GetPlayerVehicleID(playerid);
	JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] = INVALID_TAXI_CALL_ID;
	JobTaxiData[playerid][e_JOB_TAXI_FARE] = Taxi_Tariff;

	return ~1;
}

hook cmd_terminar(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != JOB_TAXI)
		return 1;
	if(Veh_GetJob(GetPlayerVehicleID(playerid)) != JOB_TAXI)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en tu taxi!");
	if (JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] != INVALID_TAXI_CALL_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Te encuentras atendiendo un pedido no puedes dejar de trabajar ahora.");
	if(!jobDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras trabajando.");
	
	jobDuty[playerid] = false;
	SendClientMessage(playerid, COLOR_WHITE, "Dejas de trabajar. No recibirás alertas de llamados. Utiliza '/terminar ' cuando desees reanudar.");
	SetEngine(GetPlayerVehicleID(playerid), 0);
	JobTaxiData[playerid][e_JOB_TAXI_FARE] = 0;
	JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] = INVALID_TAXI_CALL_ID;
	
	return ~1;
}

CMD:taxiverllamadas(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != JOB_TAXI)
		return 1;
	if(!jobDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para aceptar cualquier llamado debes estar en servicio (/trabajar).");	
	if(JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] != INVALID_TAXI_CALL_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Te encuentras en una llamada en curso, termina de atender al cliente actual.");
	if(jobVehicle[playerid] != GetPlayerVehicleID(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en el taxi con el que empezaste a trabajar!");

	JobTaxi_ShowCallsForPlayer(playerid);
	return 1;
}

CMD:taxicancelar(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != JOB_TAXI)
		return 1;
	if(!jobDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para cancelar cualquier llamado debes estar en servicio (/trabajar).");	
	if(JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] == INVALID_TAXI_CALL_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en una llamada en curso.");
	if(jobVehicle[playerid] != GetPlayerVehicleID(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en el taxi con el que empezaste a trabajar!");

	new callid = JobTaxiData[playerid][e_JOB_TAXI_ON_CALL];

	switch (TaxiCallsData[callid][callType])
	{
		case TAXI_ACTOR_CALL: CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_TAXILLAMADASNPC, .seconds = TAXI_CALL_CREATE_TIME * 30);
		case TAXI_PLAYER_CALL: PhoneSMS_Send(JobTaxi_phoneId, PlayerInfo[TaxiCallsData[callid][callClientid]][pPhoneNumber], "El taxista cancelo el viaje.");
	}

	JobTaxi_DeleteCall(callid);
	JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] = INVALID_TAXI_CALL_ID;

	SendClientMessage(playerid, COLOR_WHITE, "Has cancelado la llamada que habias tomado.");
	return 1;
}

CMD:allamadataxicrear(playerid, params[]) 
{
	new callid = JobTaxi_CreateCall(TAXI_ACTOR_CALL);

	if(callid != INVALID_TAXI_CALL_ID) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Llamada de taxi NPC ID %i creada correctamente.", callid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Imposible crear la llamada de taxi, se alcanzó el número máximo.");
	}
	return 1;
}

CMD:taximetro(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pJob] != JOB_TAXI)
		return 1;
	if(!jobDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para aceptar cualquier llamado debes estar en servicio (/trabajar).");	
	if(JobTaxiData[playerid][e_JOB_TAXI_ON_CALL] == INVALID_TAXI_CALL_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes encontrarte en una llamada para poder utilizar el taxímetro.");
	if(sscanf(params, "u", targetid))
	   	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/taximetro  [ID/Jugador]");
	if(!IsPlayerConnected(targetid) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido.");
 	if(!IsPlayerInRangeOfPlayer(4.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto se encuentra muy lejos.");
	if(TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callClientid] != targetid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes cobrarle a esta persona.");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	new Float:distance = GetDistance2D(TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callPos][0], TaxiCallsData[JobTaxiData[playerid][e_JOB_TAXI_ON_CALL]][callPos][1], x, y);

	new payment = floatround(distance * JobTaxiData[playerid][e_JOB_TAXI_FARE] / 1000, floatround_ceil);
	
	if(GetPlayerCash(targetid) < payment)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"((OOC: Esta persona no tiene dinero suficiente como para pagarte)).");

	SendFMessage(playerid, COLOR_LIGHTBLUE, "Ofreciste el pago del taxi a %s por $%i. La oferta termina en 10 segs.", GetPlayerCleanName(targetid), payment);
 	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s quiere cobrarte %i por el viaje. Para aceptar usa /aceptar taximetro. La oferta termina en 10 segs.", GetPlayerCleanName(playerid), payment);
	JobTaxiData[targetid][e_JOB_TAXI_DRIVER_ID] = playerid;
	JobTaxiData[targetid][e_JOB_TAXI_PAYMENT] = payment;
	SetTimerEx("CancelTaximetroOffer", 10000, false, "i", targetid);
	return 1;
}

forward CancelTaximetroOffer(playerid);
public CancelTaximetroOffer(playerid)
{
	JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID] = INVALID_PLAYER_ID;
	JobTaxiData[playerid][e_JOB_TAXI_PAYMENT] = 0;
	return 1;
}

hook function OnPlayerCmdAccept(playerid, const subcmd[])
{
	if(!strcmp(subcmd, "taximetro", true))
	{
		if(JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID] == INVALID_PLAYER_ID)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes tarifa pendiente!");
		if(!IsPlayerConnected(JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID]))
			return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El taxista se ha desconectado.");
		if(!IsPlayerInRangeOfPlayer(3.0, playerid, JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID]))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar cerca del taxista!");

		GivePlayerCash(playerid, -JobTaxiData[playerid][e_JOB_TAXI_PAYMENT]);
		GivePlayerCash(JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID], JobTaxiData[playerid][e_JOB_TAXI_PAYMENT]);
		SendFMessage(playerid, COLOR_WHITE, "Has pagado $%i a %s.", JobTaxiData[playerid][e_JOB_TAXI_PAYMENT], GetPlayerCleanName(JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID]));
		SendFMessage(JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID], COLOR_WHITE, "%s te ha pagado $%i.", GetPlayerCleanName(playerid), JobTaxiData[playerid][e_JOB_TAXI_PAYMENT]);
		
		JobTaxi_DeleteCall(JobTaxiData[JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID]][e_JOB_TAXI_ON_CALL]);
		JobTaxiData[JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID]][e_JOB_TAXI_ON_CALL] = INVALID_TAXI_CALL_ID;
		
		JobTaxiData[playerid][e_JOB_TAXI_DRIVER_ID] = INVALID_PLAYER_ID;
		JobTaxiData[playerid][e_JOB_TAXI_PAYMENT] = 0;
		JobTaxiData[playerid][e_JOB_TAXI_PLAYER_CALL_ID] = INVALID_TAXI_CALL_ID;
		return 1;
	}
	return continue(playerid, subcmd);
}