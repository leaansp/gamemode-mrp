#if defined _marp_jobs_included
	#endinput
#endif
#define _marp_jobs_included


//====[EMPLEOS]=================================================================

#define JOB_DELI	            1
#define JOB_TAXI             	2 	
#define JOB_FARM             	3 	
#define JOB_TRAN                4     
#define JOB_GARB                5       
#define JOB_FELON               6
#define JOB_DRUGF          		7
#define JOB_BUS					8
#define JOB_ELEC 			 	9

#define JOB_STATE_NONE          0
#define JOB_STATE_ACTIVE        1
#define JOB_STATE_FIRED         2
#define JOB_STATE_RESIGNED      3
#define JOB_STATE_FIRED_MISSING 4

#define JOB_TYPE_NONE           0
#define JOB_TYPE_LEGAL        	1
#define JOB_TYPE_ILLEGAL        2

#define JOB_WAITTIME			1



#define UpdatePlayerJobLastWorked(%0)       PlayerJobInfo[%0][pLastWorked] = GetDateString()

//===============================DATA STORAGE===================================

enum e_job_info {
	jName[32],
	jType,
	jBaseSalary,
	jTimesToWork,
	jSkin,
	jRpPoints,
	Float:jTakeX,
	Float:jTakeY,
	Float:jTakeZ,
	jTakeW,
	jTakeI,
	jTable[24],
	jCharge1[64],
	jCharge2[64],
	jCharge3[64],
	jCharge4[64],
	jCharge5[64]
};



new JobInfo[][e_job_info] = {

/*0*/	{"NONE", 0,	0, 0, 0, 0, 0.0, 0.0, 0.0, 0, 0, "NONE", "NONE", "NONE", "NONE", "NONE", "NONE"},
/*1*/   {"Moto Delivery", JOB_TYPE_LEGAL, 260, 10, 0, 0, 1739.45, -1583.3, 14.15, 0, 0, "job_deli", "Aprendiz", "Cadete", "Mensajero", "Mensajero experimentado", "Supervisor"},
/*2*/   {"Taxista", JOB_TYPE_LEGAL, 100, 0, 0, 0, 1813.68, -1896.36, 13.5781, 0, 0, "job_taxi", "Chofer", "Chofer", "Chofer", "Chofer", "Chofer"},
/*3*/   {"Granjero", JOB_TYPE_LEGAL, 20 * 65, 8, 0, 0, -31.0715, 54.5695, 3.1172, 0, 0, "job_farm", "Aprendiz", "Ayudante de maquinas", "Chofer de maquina", "Evaluador de cosecha", "Supervisor"},
/*4*/   {"Transportista", JOB_TYPE_LEGAL, 1200, 8, 0, 0, 2229.23, -2208.34, 13.5469, 0, 0, "job_tran", "Aprendiz", "Chofer", "Chofer de camión", "Chofer de primera linea", "Encargado de logística"}, // ==[ TRANJOB ]==
/*5*/	{"Basurero", JOB_TYPE_LEGAL, 1000, 8, 236, 0, 2454.4373, -2107.1282, 13.4674, 0, 0, "NONE", "NONE", "NONE", "NONE", "NONE", "NONE"},
/*6*/   {"Delincuente", JOB_TYPE_ILLEGAL, 0, 0, 0, 0, 2614.12, -1393.15, 34.8954, 0, 0, "NONE", "NONE", "NONE", "NONE", "NONE", "NONE"},
/*7 - NO EXISTE MÁS IN GAME*/   {"Cosechador de Materia Prima", JOB_TYPE_ILLEGAL, 30 * 65, 3, 0, 0, -1060.79, -1205.49, 129.322, 0, 0, "NONE", "NONE", "NONE", "NONE", "NONE", "NONE"},
/*8*/	{"Colectivero", JOB_TYPE_LEGAL,	500, 8, 0, 0, 2207.93, -2621.40, 14.58, 0, 0, "job_bus", "Chofer Aprendiz", "Chofer iniciado", "Chofer Experimentado", "Chofer Destacado", "Inspector"},
/*9*/	{"Electricista", JOB_TYPE_LEGAL, 900, 8, 0, 0, 1626.97, -1863.49, 13.53, 0, 0, "job_elec", "Aprendiz", "Oficial", "Técnico", "Técnico Senior", "Supervisor"}

};

enum pPlayerJob {
	pWorkingHours, // Cantidad de horas efectivas que trabajó (antiguedad)
	pLastWorked[32], // Ultimo día que trabajó
	pTotalEarnings,
	pCharge, // El cargo que ocupa (número)
	pState, // Estado laboral (despedido, renunció, activo, etc)
	pReputation // Imagen laboral: suma o resta puntos dependiendo de las cosas que pasan
};

new PlayerJobInfo[MAX_PLAYERS][pPlayerJob];

//Variables generales:

new bool:jobDuty[MAX_PLAYERS],
	CollectedProds[MAX_PLAYERS],
    LastCP[MAX_PLAYERS];
    
new Float:jobVehicleHealth[MAX_PLAYERS],
    jobVehicle[MAX_PLAYERS],
    jobCheckpoint[MAX_PLAYERS],
    jobRoute[MAX_PLAYERS];

Job_IsVehicleWorking(vehicleid)
{
	foreach(new playerid : Player)
	{
	    if(jobVehicle[playerid] == vehicleid) {
	        return 1;
	    }
	}
	return 0;
}

Job_GetWorkingVehicle(playerid)
{
	if(PlayerInfo[playerid][pJob] == JOB_GARB)
		return JobGarb_GetWorkingVehicle(playerid);
	else
		return jobVehicle[playerid];
}

stock Job_WorkingPlayerDisconnect(playerid)
{
	if(jobDuty[playerid] && PlayerInfo[playerid][pJob] == JOB_TRAN)
		TranJob_ResetOrder(playerid); // ==[ TRANJOB ]==
	if(jobDuty[playerid] && jobVehicle[playerid])
	{
 		jobDuty[playerid] = false;
	    SetEngine(jobVehicle[playerid], 0);
	    SetVehicleToRespawn(jobVehicle[playerid]);
	    jobVehicle[playerid] = 0;
	}
}

stock GetPlayerJobDuty(playerid)
{
	if(jobDuty[playerid])
		return 1;
	else return 0;
}

//==============================================================================

stock GetJobChargeName(job, charge)
{
	new str[64];
	
	switch(charge)
	{
		case 1: format(str, sizeof(str), "%s", JobInfo[job][jCharge1]);
		case 2: format(str, sizeof(str), "%s", JobInfo[job][jCharge2]);
		case 3: format(str, sizeof(str), "%s", JobInfo[job][jCharge3]);
		case 4: format(str, sizeof(str), "%s", JobInfo[job][jCharge4]);
		case 5: format(str, sizeof(str), "%s", JobInfo[job][jCharge5]);
	}
	return str;
}

GetJobType(job) {
	return JobInfo[job][jType];
}

GetJobBaseSalary(job) {
	return JobInfo[job][jBaseSalary];
}

Job_GetTimesToWork(job) {
	return JobInfo[job][jTimesToWork];
}

Job_GetRpPointsNeeded(job) {
	return JobInfo[job][jRpPoints];
}

Jobs_LoadPickups()
{
	new jsize = sizeof(JobInfo),
	    string[128];
	
	for(new i = 1; i < jsize; i++)
	{
		if(i != JOB_GARB)
		{
			CreateDynamicPickup(1274, 1, JobInfo[i][jTakeX], JobInfo[i][jTakeY], JobInfo[i][jTakeZ], JobInfo[i][jTakeW]);

			format(string, sizeof(string), "Escribe /tomarempleo para tomar el empleo de %s\nUsa /consultarempleo para más información.", JobInfo[i][jName]);
			CreateDynamic3DTextLabel(string, COLOR_WHITE, JobInfo[i][jTakeX], JobInfo[i][jTakeY], JobInfo[i][jTakeZ] + 0.75, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 100.0);
		}
	}

	J_Garb_LoadPickup();
}

//==============================================================================

ResetJobVariables(playerid)
{
    ResetThiefVariables(playerid);
    
	PlayerJobInfo[playerid][pWorkingHours] = 0;
	strcat(PlayerJobInfo[playerid][pLastWorked], "", 32);
	PlayerJobInfo[playerid][pTotalEarnings] = 0;
	PlayerJobInfo[playerid][pCharge] = 0;
	PlayerJobInfo[playerid][pState] = 0;
	PlayerJobInfo[playerid][pReputation] = 0;
}

//==============================================================================

CMD:trabajar(playerid,params[])
{
	new job = PlayerInfo[playerid][pJob];
	
	if(job == 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes ningún empleo!");
	if(jobDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya te encuentras trabajando!");

	switch(job)
	{
		case JOB_FARM:
	    {
	    	FarmJob_StartWork(playerid);
	    }
		case JOB_DRUGF:
		{
			DrugfJob_StartWork(playerid);
	    }
		case JOB_TRAN:
		{
			if(IsPlayerInAnyVehicle(playerid) && VehicleInfo[GetPlayerVehicleID(playerid)][VehJob] == JOB_TRAN) {
				BizOrder_ShowList(playerid, .allowInteraction = true, .filterBiz = 0, .onResponse = "Dlg_Show_Orders");
			} else {
				return SendClientMessage(playerid, COLOR_WHITE, "Debes estar dentro de tu vehiculo de trabajo.");
			}
	    }
		case JOB_BUS:
		{
			BusJob_StartWork(playerid);
		}
	    case JOB_DELI:
	    {
	        DeliJob_StartWork(playerid);
		}
		case JOB_ELEC:
		{
			ElecJob_StartWork(playerid);
		}
		default:
			return 1;
	}

	if(JobInfo[job][jSkin] > 0) {
		SetPlayerSkin(playerid, JobInfo[job][jSkin]);
	}
	return 1;
}

//==============================================================================

CMD:terminar(playerid,params[])
{
    if(PlayerInfo[playerid][pJob] == 0)
		return 1;
    if(!jobDuty[playerid])
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No te encuentras trabajando!");

	switch(PlayerInfo[playerid][pJob])
	{
	    case JOB_FARM:
		{
			return FarmJob_FinishWork(playerid);
		}
		case JOB_DRUGF:
		{
			return DrugfJob_FinishWork(playerid);
		}
		case JOB_ELEC:
		{
			return ElecJob_FinishWork(playerid, false);
		}
		default:
			return 1;
	}
	
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		
    jobDuty[playerid] = false;
	return 1;
}

//==============================================================================

CMD:tomarempleo(playerid,params[])
{
    if(Faction_IsValidId(PlayerInfo[playerid][pFaction]) && !Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_ALLOW_JOB))
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes tomar este empleo perteneciendo a esta facción!");
    if(PlayerInfo[playerid][pJob] != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya tienes un empleo!");
	if(!Job_CanPlayerTake(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya has trabajado el día de hoy. Para poder tomar o renunciar a un empleo debes no haber efectuado ningún trabajo en el día.");

	for(new job = 1; job < sizeof(JobInfo); job++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.0, JobInfo[job][jTakeX], JobInfo[job][jTakeY], JobInfo[job][jTakeZ]))
		{
		    if(PlayerInfo[playerid][pRolePoints] < Job_GetRpPointsNeeded(job))
		        return SendClientMessage(playerid, COLOR_WHITE, "[OOC]: No tienes suficientes puntos de rol para tomar este trabajo.");
		    if((job == JOB_TAXI || job == JOB_TRAN || job == JOB_GARB || job == JOB_DELI || job == JOB_BUS) && PlayerInfo[playerid][pCarLic] == 0 )
		        return SendClientMessage(playerid, COLOR_WHITE, "No puedo emplearte si no tienes licencia de manejo, hasta luego.");
			if(job == JOB_DRUGF && PlayerInfo[playerid][pLevel] < 3) // para coshechar droga minimo nivel 3
				return SendClientMessage(playerid, COLOR_WHITE, "Granjero: buscamos gente con experiencia, no aceptamos novatos. ¡Sal de aquí! (OOC: Requiere nivel 3)"); // Si es uno nuevo en el servidor o multicuenta

			SetPlayerJob(playerid, job);
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes tomar un empleo en cualquier lugar!");
	return 1;
}

//==============================================================================

CMD:dejarempleo(playerid,params[])
{
	new job = PlayerInfo[playerid][pJob];

	if(GetPlayerJob(playerid) == JOB_GARB)
		return 1;	
    if(job == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes ningún empleo.");
	if(!Job_CanPlayerResign(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya has trabajado el día de hoy. Para poder tomar o renunciar a un empleo debes no haber efectuado ningún trabajo en el día.");
  	if(jobDuty[playerid])
	  	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes hacerlo mientras estás trabajando!");
    if(!IsPlayerInRangeOfPoint(playerid, 1.0, JobInfo[job][jTakeX],JobInfo[job][jTakeY],JobInfo[job][jTakeZ]))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes presentar tu renuncia a tu jefe, en tu lugar de trabajo.");

	SavePlayerJobData(playerid, 1, 1); // Guardamos el viejo
	ResetJobVariables(playerid); // Reseteamos todo a cero
	SetPlayerJob(playerid, 0); // Seteamos job nulo
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Has dejado tu empleo de %s!", JobInfo[job][jName]);
	return 1;
}

//==============================================================================

LoadPlayerJobData(playerid)
{
	J_Garb_LoadData(playerid);

	if(PlayerInfo[playerid][pJob])
	{
		if(GetPlayerJob(playerid) == JOB_GARB) {
	        return 1;
		} else if(PlayerInfo[playerid][pJob] == JOB_FELON) {
     		LoadThiefJobData(playerid);
		} else if(GetJobType(PlayerInfo[playerid][pJob]) == JOB_TYPE_LEGAL) {
			mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "OnLegalJobDataLoad", "i", playerid @Format: "SELECT * FROM `%s` WHERE `pID`=%i;", JobInfo[PlayerInfo[playerid][pJob]][jTable], PlayerInfo[playerid][pID]);
		}
	}
	return 1;
}

//==============================================================================

forward OnLegalJobDataLoad(playerid);
public OnLegalJobDataLoad(playerid)
{
	if(cache_num_rows())
	{
		cache_get_value_name_int(0, "pWorkingHours", PlayerJobInfo[playerid][pWorkingHours]);
		cache_get_value_name_int(0, "pCharge", PlayerJobInfo[playerid][pCharge]);
		cache_get_value_name_int(0, "pState", PlayerJobInfo[playerid][pState]);
		cache_get_value_name_int(0, "pReputation", PlayerJobInfo[playerid][pReputation]);
		cache_get_value_name_int(0, "pTotalEarnings", PlayerJobInfo[playerid][pTotalEarnings]);
		cache_get_value_name(0, "pLastWorked", PlayerJobInfo[playerid][pLastWorked], 32);


		if(PlayerJobInfo[playerid][pState] == JOB_STATE_FIRED_MISSING)
		{
		    PlayerInfo[playerid][pJob] = 0;
			SendClientMessage(playerid, COLOR_WHITE, "[INFO]: Te han despedido de tu trabajo por faltar demasiado tiempo seguido.");
		}
	}
	else
	{
	    SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error al cargar la información del empleo ID %d desde la base de datos. Reportar a un administrador.", PlayerInfo[playerid][pJob]);
        PlayerInfo[playerid][pJob] = 0;
	}
	return 1;
}

//==============================================================================

SavePlayerJobData(playerid, resigned=0, leftjob=0)
{
	if(PlayerInfo[playerid][pJob])
	{
		if(GetPlayerJob(playerid) == JOB_GARB)
			J_Garb_SaveData(playerid);
		else if(PlayerInfo[playerid][pJob] == JOB_FELON)
	    {
			SaveThiefJobData(playerid);
		}
		else if(GetJobType(PlayerInfo[playerid][pJob]) == JOB_TYPE_LEGAL)
		{
		    if(resigned)
		    	PlayerJobInfo[playerid][pState] = JOB_STATE_RESIGNED;
			if(leftjob)
			    PlayerJobInfo[playerid][pWorkingHours] = 0;

			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), \
				"UPDATE `%s` SET \
					`pWorkingHours`=%i,\
					`pCharge`=%i,\
					`pState`=%i,\
					`pLastWorked`='%s',\
					`pTotalEarnings`=%i,\
					`pReputation`=%i \
				WHERE \
					`pID`=%i;",
				JobInfo[PlayerInfo[playerid][pJob]][jTable],
				PlayerJobInfo[playerid][pWorkingHours],
				PlayerJobInfo[playerid][pCharge],
				PlayerJobInfo[playerid][pState],
				PlayerJobInfo[playerid][pLastWorked],
				PlayerJobInfo[playerid][pTotalEarnings],
				PlayerJobInfo[playerid][pReputation],
				PlayerInfo[playerid][pID]
			);

			mysql_tquery(MYSQL_HANDLE, query);
		}
	}
}

//==============================================================================

SetPlayerJob(playerid, job, admincmd=0)
{
	if(job == JOB_GARB) {
		J_Garb_SetJob(playerid);
	} else if(job == JOB_FELON) {
		SetThiefJobForPlayer(playerid);
	} else if(GetJobType(job) == JOB_TYPE_LEGAL) {
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnLegalJobDataCheck", "iii", playerid, job, admincmd @Format: "SELECT * FROM `%s` WHERE `pID`=%i;", JobInfo[job][jTable], PlayerInfo[playerid][pID]);
	}
	else if(job == 0)
	{
		if(GetPlayerJob(playerid) == JOB_GARB) { // Si el anterior es garb
			J_Garb_SetJob(playerid, 1);
		}

		PlayerInfo[playerid][pJob] = 0;
	}
	else
	{
		PlayerInfo[playerid][pJobTime] = JOB_WAITTIME;
		PlayerInfo[playerid][pJob] = job;
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Felicidades!, ahora eres un %s, para ver los comandos disponibles, escribe /ayuda.", JobInfo[job][jName]);
	}

	if(job != 0 && admincmd == 0) {
		StartPlayerScene(playerid, (2 * job) + 8);
	}
	return 1;
}

//==============================================================================

CMD:setjob(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 6)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	new string[128], job, targetid;

	if(sscanf(params, "ui", targetid, job))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setjob [ID/Jugador] [ID empleo]");
	if(!IsPlayerConnected(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido.");
	if(job < 0 || job >= sizeof(JobInfo))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Empleo inválido.");

	SavePlayerJobData(targetid, 1); // Guardamos el viejo
	ResetJobVariables(targetid); // Reseteamos todo a cero
	SetPlayerJob(targetid, job, 1); // Seteamos el nuevo

	SendFMessage(targetid, COLOR_LIGHTYELLOW2, "{878EE7}[INFO]:{C8C8C8} %s te ha seteado el empleo a %d (%s).", GetPlayerCleanName(playerid), job, JobInfo[job][jName]);
	if(PlayerInfo[targetid][pRolePoints] < Job_GetRpPointsNeeded(job)) 
	{
	    SendFMessage(playerid, COLOR_RED, "[RECORDATORIO]: %s no cumplía con los puntos de rol necesarios para el empleo (%d).", GetPlayerCleanName(targetid), Job_GetRpPointsNeeded(job));
	}
	format(string, sizeof(string), "[Staff]: %s ha seteado el empleo de %s a %d (%s).", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), job, JobInfo[job][jName]);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);

	return 1;
}

//==============================================================================

forward OnLegalJobDataCheck(playerid, job, admincmd);
public OnLegalJobDataCheck(playerid, job, admincmd)
{
	if(cache_num_rows()) // Alguna vez tuvo el job.
	{
		cache_get_value_name_int(0, "pState", PlayerJobInfo[playerid][pState]);

		if(PlayerJobInfo[playerid][pState] == JOB_STATE_FIRED && !admincmd) { // Fue despedido y fue mediante /tomarempleo y no mediante /setjob
			SendFMessage(playerid, COLOR_WHITE, "Empleador: Fuiste despedido de este lugar por mal desempeño, %s, y no te queremos devuelta.", GetPlayerCleanName(playerid));
		} else if(PlayerJobInfo[playerid][pState] == JOB_STATE_FIRED_MISSING && !admincmd) {
			SendFMessage(playerid, COLOR_WHITE, "Empleador: Fuiste despedido de este lugar por faltar demasiado tiempo al trabajo, %s, y no te queremos devuelta.", GetPlayerCleanName(playerid));
		}
		else
		{
			PlayerJobInfo[playerid][pState] = JOB_STATE_ACTIVE;
			cache_get_value_name_int(0, "pWorkingHours", PlayerJobInfo[playerid][pWorkingHours]);
			cache_get_value_name_int(0, "pCharge", PlayerJobInfo[playerid][pCharge]);
			cache_get_value_name_int(0, "pReputation", PlayerJobInfo[playerid][pReputation]);
			cache_get_value_name_int(0, "pTotalEarnings", PlayerJobInfo[playerid][pTotalEarnings]);
			
			// Si el cargo está en 0 (porque renunció), establecerlo al cargo inicial
			if(PlayerJobInfo[playerid][pCharge] == 0)
				PlayerJobInfo[playerid][pCharge] = 1;
			
			UpdatePlayerJobLastWorked(playerid);

			PlayerInfo[playerid][pJob] = job;
			PlayerInfo[playerid][pJobTime] = JOB_WAITTIME;
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Felicidades, ahora eres un %s!. Para saber los comandos disponibles mira en /ayuda, seccion [Empleo].", JobInfo[job][jName]);

			if(!admincmd)
			{
				SendFMessage(playerid, COLOR_WHITE, "Empleador: %s, ¿sos vos?. Es bueno que hayas vuelto. Esperemos que esta vez no renuncies.", GetPlayerCleanName(playerid));
				SendClientMessage(playerid, COLOR_WHITE, "Recuerda que, ya que habías renunciado, perdiste toda antiguedad acumulada en el trabajo.");
			}
		}
	}
	else // Nunca lo tuvo
	{
		PlayerJobInfo[playerid][pWorkingHours] = 0;
		PlayerJobInfo[playerid][pCharge] = 1;
		PlayerJobInfo[playerid][pState] = JOB_STATE_ACTIVE;
		PlayerJobInfo[playerid][pReputation] = 0;
		UpdatePlayerJobLastWorked(playerid);
		PlayerInfo[playerid][pJob] = job;
		PlayerInfo[playerid][pJobTime] = JOB_WAITTIME;
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Felicidades, ahora eres un %s!. Para saber los comandos disponibles mira en /ayuda, seccion [Empleo].", JobInfo[job][jName]);

		if(!admincmd) {
			SendFMessage(playerid, COLOR_WHITE, "Empleador: Bienvenido a nuestra empresa, %s. Empezarás como %s. ¡Suerte y a trabajar!", GetPlayerCleanName(playerid), GetJobChargeName(job, PlayerJobInfo[playerid][pCharge]));
		}

		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "INSERT INTO `%s` (`pID`,`pLastWorked`) VALUES (%i,'%s');", JobInfo[job][jTable], PlayerInfo[playerid][pID], PlayerJobInfo[playerid][pLastWorked]);
	}
	return 1;
}

//==============================================================================

CMD:verempleo(playerid, params[])
{
	if(GetPlayerJob(playerid) == JOB_GARB)
		return 1;

	if(GetJobType(PlayerInfo[playerid][pJob]) == JOB_TYPE_LEGAL)
	{
	    new content[300];

		format(content, sizeof(content), "Empleo: %s\nCargo: %s\nTrabajos realizados: %d\nUltimo día de trabajo: %s\nIngresos totales: $%d\nImagen laboral: %s\nEstado laboral: %s",
		    JobInfo[PlayerInfo[playerid][pJob]][jName],
		    GetJobChargeName(PlayerInfo[playerid][pJob], PlayerJobInfo[playerid][pCharge]),
		    PlayerJobInfo[playerid][pWorkingHours],
		    PlayerJobInfo[playerid][pLastWorked],
		    PlayerJobInfo[playerid][pTotalEarnings],
			GetJobReputationString(PlayerJobInfo[playerid][pReputation]),
   			GetJobStateString(PlayerJobInfo[playerid][pState])
		);
		
        Dialog_Show(playerid, Job_Info, DIALOG_STYLE_MSGBOX, "Información de tu empleo", content, "Cerrar", "");
	}
	return 1;
}

//==============================================================================

stock GetJobReputationString(reputation)
{
	new str[64];

    if(reputation > 300)
        format(str, sizeof(str), "{00FF00}Excelente{a9c4e4}"); // Verde claro
    else if(reputation > 200)
    	format(str, sizeof(str), "{97D000}Muy buena{a9c4e4}"); // Verde turbio
    else if(reputation > 100)
    	format(str, sizeof(str), "{CFFF00}Buena{a9c4e4}"); // Verde amarillo
    else if(reputation >= 0)
    	format(str, sizeof(str), "{FFFF00}Neutral{a9c4e4}"); // Amarillo
    else if(reputation > -70)
    	format(str, sizeof(str), "{FFB900}Mala{a9c4e4}"); // Naranja claro
    else if(reputation > -140)
    	format(str, sizeof(str), "{FF5900}Muy mala{a9c4e4}"); // Naranja rojizo
    else
    	format(str, sizeof(str), "{FF0000}Horrible{a9c4e4}"); // Rojo

	return str;
}

//==============================================================================

stock GetJobStateString(status)
{
	new str[64];

	if(status == JOB_STATE_ACTIVE)
	    format(str, sizeof(str), "{00FF00}En actividad{a9c4e4}"); // Verde
	else if(status == JOB_STATE_FIRED)
	    format(str, sizeof(str), "{FF0000}Despedido - Mal desempeño{a9c4e4}"); // Rojo
	else if(status == JOB_STATE_FIRED_MISSING)
	    format(str, sizeof(str), "{FF0000}Despedido - No asiste a trabajar{a9c4e4}"); // Rojo
	else if(status == JOB_STATE_RESIGNED)
        format(str, sizeof(str), "{FFFF00}Renunció{a9c4e4}"); // Amarillo
	else if(status == JOB_STATE_NONE)
        format(str, sizeof(str), "{868282}Nunca trabajó{a9c4e4}"); // Gris

	return str;
}

//==============================================================================

CMD:consultarempleo(playerid, params[])
{
	new bool:foundPickup = false;
	
	for(new job = 1; job < sizeof(JobInfo); job++)
	{
	    if(GetJobType(job) == JOB_TYPE_LEGAL)
	    {
			if(IsPlayerInRangeOfPoint(playerid, 1.0, JobInfo[job][jTakeX], JobInfo[job][jTakeY], JobInfo[job][jTakeZ]))
			{
				foundPickup = true;
			    if(job == PlayerInfo[playerid][pJob])
			        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Actualmente tienes este empleo, utiliza /verempleo.");

			    mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnPlayerInvestJob", "ii", playerid, job @Format: "SELECT * FROM `%s` WHERE `pID`=%i;", JobInfo[job][jTable], PlayerInfo[playerid][pID]);
				return 1;
			}
		}
	}
	
	if(!foundPickup)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar sobre un pickup de empleo para utilizar este comando.");
	
	return 1;
}

//==============================================================================

forward OnPlayerInvestJob(playerid, job);
public OnPlayerInvestJob(playerid, job)
{
	new stateResult,
		workingHoursResult,
		chargeResult,
		reputationResult,
		totalEarningsResult,
		lastWorkedResult[32],
		content[400],
		auxInformation[200];

	if(cache_num_rows()) // Alguna vez tuvo el job.
	{
		cache_get_value_name_int(0, "pState", stateResult);
		cache_get_value_name_int(0, "pWorkingHours", workingHoursResult);
		cache_get_value_name_int(0, "pCharge", chargeResult);
		cache_get_value_name_int(0, "pReputation", reputationResult);
		cache_get_value_name_int(0, "pTotalEarnings", totalEarningsResult);
		cache_get_value_name(0, "pLastWorked", lastWorkedResult, 32);

		switch(stateResult)
		{
		    case JOB_STATE_FIRED: {
		        strcat(auxInformation, "Has sido despedido de este lugar por mal desempeño y no podrás tomar nuevamente el trabajo.", sizeof(auxInformation));
		    }
			case JOB_STATE_FIRED_MISSING: {
			    strcat(auxInformation, "Has sido despedido de este lugar por faltar al trabajo y no podrás tomarlo nuevamente.", sizeof(auxInformation));
			}
			case JOB_STATE_RESIGNED: {
				strcat(auxInformation, "Como habías renunciado, volverás a entrar con tu último cargo pero perderás toda antiguedad acumulada.", sizeof(auxInformation));
			}
		}

		format(content, sizeof(content), "Empleo: %s\nCargo: %s\nTrabajos realizados: %d\nUltimo día de trabajo: %s\nIngresos totales: $%d\nImagen laboral: %s\nEstado laboral: %s\n\n%s",
		    JobInfo[job][jName],
		    GetJobChargeName(job, chargeResult),
		    workingHoursResult,
		    lastWorkedResult,
		    totalEarningsResult,
			GetJobReputationString(reputationResult),
   			GetJobStateString(stateResult),
	  		auxInformation
		);
	}
	else // Nunca lo tuvo
	{
	    format(auxInformation, sizeof(auxInformation), "En esta empresa tendrás la oportunidad de escalar puestos y mejorar tus ganancias\nsi tienes un buen desempeño. Pero también ten en cuenta que te pueden echar si tu desempeño es malo.");
		format(content, sizeof(content), "Empleo: %s\nCargo en el que comienzas: %s\nGanancias iniciales por trabajo: $%d\nTrabajos disponibles por día: %i\n\n%s",
		    JobInfo[job][jName],
		    GetJobChargeName(job, 1),
		    GetJobBaseSalary(job),
		    Job_GetTimesToWork(job),
	  		auxInformation
		);
	}
	Dialog_Show(playerid, Job_Info_Invest, DIALOG_STYLE_MSGBOX, "Información del empleo", content, "Cerrar", "");
	return 1;
}

//==============================================================================

Job_GiveReputation(playerid, reputation) {
    PlayerJobInfo[playerid][pReputation] += reputation;
}

Job_CheckReputationLimit(playerid)
{
	if(PlayerJobInfo[playerid][pReputation] < -210)
	{
		SendFMessage(playerid, COLOR_LIGHTYELLOW2, "Has sido despedido de tu empleo '%s' por mal desempeño en tus tareas laborales.", JobInfo[PlayerInfo[playerid][pJob]][jName]);
		PlayerJobInfo[playerid][pState] = JOB_STATE_FIRED;
		SavePlayerJobData(playerid);
		ResetJobVariables(playerid);
		SetPlayerJob(playerid, 0);
	}
}

Job_CanPlayerTake(playerid) {
	return (PlayerInfo[playerid][pCantWork] < 1 && !PlayerInfo[playerid][pJobTime]);
}

Job_CanPlayerResign(playerid) {
	return (PlayerInfo[playerid][pCantWork] < 1 && !PlayerInfo[playerid][pJobTime]);
}
