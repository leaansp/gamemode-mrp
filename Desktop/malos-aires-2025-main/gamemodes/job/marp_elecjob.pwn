#if defined _marp_elecjob_included
	#endinput
#endif
#define _marp_elecjob_included

//Revisar: No se toma la caja de herramientas, no sep one el pickup en la parte de atras de la camioneta, dice "debes usar el comando correcto para encender el vehiculo" al iniciar el trabajo

#include <YSI_Coding\y_hooks>
// Ensure common utility macros (SendFMessage, SendClientMessageEx, etc.) are available
#include "util/marp_util.pwn"

// forward del minijuego de cableado (archivo separado)
forward StartElecWiresMinigame(playerid, newcount);
forward StopElecWiresMinigame(playerid, bool:success);
forward ElecJob_AllowEnterVehicle(playerid, vehicleid);

// ============================================================================
// CONFIGURACIÓN GENERAL JOB ELECTRICISTA
// ============================================================================

// Usar el ID estándar de caja de herramientas del sistema
#if !defined ITEM_ID_TOOLBOX
	#define ITEM_ID_TOOLBOX ITEM_ID_CAJAHERRAMIENTAS
#endif

#define ELEC_MAX_PER_PAYDAY     (JobInfo[JOB_ELEC][jTimesToWork])
#define ELEC_BASE_SALARY        (JobInfo[JOB_ELEC][jBaseSalary])

#define ELEC_TRAVEL_TIME        (20)        // límite en minutos para completar el recorrido

// Pool de puntos unificado
#define ELEC_POINTS_POOL_SIZE   (18)         // Total de puntos disponibles
#define ELEC_POINTS_PER_JOB     (8)          // Puntos que se tomarán al azar por trabajo

// Distancia para considerar que está detrás de la camioneta
#define ELEC_TOOLBOX_DIST       (2.5)

// Radio del checkpoint en los postes
#define ELEC_CP_SIZE            (1.5)

// ============================================================================
// POOL UNIFICADO DE PUNTOS
// Cada punto: { X, Y, Z, AnguloReferencia }
// ============================================================================

static const Float:gElecPointsPool[ELEC_POINTS_POOL_SIZE][4] = {
    {1831.34, -1797.70, 13.54, 195.58},
    {1952.73, -1800.14, 13.54, 163.93},
    {2072.34, -1921.94, 13.54, 153.59},
    {2176.22, -1910.67, 13.50, 88.10},
    {2323.38, -1941.47, 13.58, 215.61},
    {2394.58, -1963.15, 13.54, 46.11},
    {2432.44, -1923.12, 13.54, 314.93},
    {2404.84, -1741.84, 13.54, 95.31},
    {2175.85, -1730.39, 13.53, 116.30},
    {1869.17, -1876.98, 13.47, 90.90},
    {1904.49, -1946.14, 13.54, 296.13},
    {1971.37, -2027.03, 13.54, 185.21},
    {1873.70, -2043.44, 13.54, 76.17},
    {1731.77, -2103.60, 13.54, 355.88},
    {1677.62, -2117.96, 13.54, 115.96},
    {2004.41, -2119.55, 13.54, 157.30},
    {2328.85, -2108.96, 13.55, 90.10},
    {2316.39, -1983.44, 13.55, 307.08}
};

// Helper para obtener un punto del pool
stock ElecJob_GetPoolPoint(idx, &Float:x, &Float:y, &Float:z, &Float:angle)
{
	if(idx < 0 || idx >= ELEC_POINTS_POOL_SIZE) return 0;
	x     = gElecPointsPool[idx][0];
	y     = gElecPointsPool[idx][1];
	z     = gElecPointsPool[idx][2];
	angle = gElecPointsPool[idx][3];
	return 1;
}

// ============================================================================
// VARIABLES RUNTIME
// ============================================================================

static bool:gElecWorking[MAX_PLAYERS];
static gElecSelectedPoints[MAX_PLAYERS][ELEC_POINTS_PER_JOB];  // Índices de los puntos seleccionados para este trabajo
static gElecCurrentPointIdx[MAX_PLAYERS];                       // Índice actual en el array de puntos seleccionados
static Float:gElecVehicleHp[MAX_PLAYERS];
static Float:gElecVehicleStartX[MAX_PLAYERS];                  // Posición inicial X del vehículo
static Float:gElecVehicleStartY[MAX_PLAYERS];                  // Posición inicial Y del vehículo
static Float:gElecVehicleStartZ[MAX_PLAYERS];                  // Posición inicial Z del vehículo
static bool:gElecHasToolbox[MAX_PLAYERS];
static gElecSavedSkin[MAX_PLAYERS];

#define ElecJob_IsWorking(%0)      (PlayerInfo[%0][pJob] == JOB_ELEC && gElecWorking[%0])
#define ElecJob_GetVehicle(%0)     jobVehicle[%0]

stock ElecJob_ResetVars(playerid)
{
	gElecWorking[playerid]           = false;
	gElecCurrentPointIdx[playerid]   = 0;
	jobVehicle[playerid]             = 0;
	gElecVehicleHp[playerid]         = 1000.0;
	gElecVehicleStartX[playerid]     = 0.0;
	gElecVehicleStartY[playerid]     = 0.0;
	gElecVehicleStartZ[playerid]     = 0.0;
	gElecHasToolbox[playerid]        = false;
	gElecSavedSkin[playerid]         = -1;
	
	// Limpiar array de puntos
	for(new i = 0; i < ELEC_POINTS_PER_JOB; i++)
		gElecSelectedPoints[playerid][i] = -1;
}

// Helper para seleccionar 8 puntos aleatorios del pool
stock ElecJob_SelectRandomPoints(playerid)
{
	new bool:used[ELEC_POINTS_POOL_SIZE];
	new count = 0;
	
	for(new i = 0; i < ELEC_POINTS_POOL_SIZE; i++) used[i] = false;
	
	while(count < ELEC_POINTS_PER_JOB)
	{
		new idx = random(ELEC_POINTS_POOL_SIZE);
		if(!used[idx])
		{
			used[idx] = true;
			gElecSelectedPoints[playerid][count] = idx;
			count++;
		}
	}
	
	return 1;
}

// ============================================================================
// INICIO DEL TRABAJO
// ============================================================================

stock ElecJob_StartWork(playerid)
{
	if(PlayerInfo[playerid][pJob] != JOB_ELEC)
	    return 1;

	if(gElecWorking[playerid])
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡Ya te encuentras trabajando!");

	if(PlayerInfo[playerid][pCantWork] >= ELEC_MAX_PER_PAYDAY)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya has alcanzado el máximo de trabajos posibles por este día de pago.");

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en el asiento del conductor de tu vehículo de trabajo.");

	new vehicleid = GetPlayerVehicleID(playerid);

	// Debes crear vehículos asignados al job electricista marcados con VehJob == JOB_ELEC
	if(Veh_GetSystemType(vehicleid) != VEH_JOB || Veh_GetJob(vehicleid) != JOB_ELEC)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar dentro de un vehículo de trabajo de electricista.");

	if(Job_IsVehicleWorking(vehicleid))
		return SendClientMessage(playerid, COLOR_YELLOW2, "Ese vehículo ya está siendo usado por otro empleado.");

	if(!Cronometro_Crear(playerid, ELEC_TRAVEL_TIME * 60, "ElecJob_TimeLimit"))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se pudo crear el cronómetro asociado al trabajo. Reportar a un administrador.");

	// Seleccionar 8 puntos aleatorios del pool
	ElecJob_SelectRandomPoints(playerid);

	// Obtener el primer punto de la selección
	new pointIdx = gElecSelectedPoints[playerid][0];
	new Float:x, Float:y, Float:z, Float:angle;
	if(!ElecJob_GetPoolPoint(pointIdx, x, y, z, angle))
	{
		Cronometro_Borrar(playerid);
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Punto inválido. Reportar a un administrador.");
	}

	SetPlayerCheckpoint(playerid, x, y, z, ELEC_CP_SIZE);

	// Guardar posición inicial del vehículo
	GetVehiclePos(vehicleid, gElecVehicleStartX[playerid], gElecVehicleStartY[playerid], gElecVehicleStartZ[playerid]);

	gElecWorking[playerid]       = true;
	gElecCurrentPointIdx[playerid] = 0;
	jobVehicle[playerid]         = vehicleid;
	gElecHasToolbox[playerid]    = false;
	GetVehicleHealth(vehicleid, gElecVehicleHp[playerid]);

	jobDuty[playerid] = true;
	UpdatePlayerJobLastWorked(playerid);

	// Guardar skin actual y aplicar skin de trabajo
	gElecSavedSkin[playerid] = GetPlayerSkin(playerid);
	SetPlayerSkin(playerid, 27);
	PlayerInfo[playerid][pJobSkin] = 27;

	SendClientMessage(playerid, COLOR_WHITE, "Has comenzado tu jornada como electricista.");
	SendClientMessage(playerid, COLOR_WHITE, "Conduce hasta el punto marcado, estaciona, baja de la camioneta y dirígete a la parte trasera.");
	SendClientMessage(playerid, COLOR_WHITE, "Presiona ALT para tomar la caja de herramientas, luego ve al poste y repáralo.");

	return 1;
}

// ============================================================================
// FIN / PAGO DEL TRABAJO
// ============================================================================

stock ElecJob_Pay(playerid)
{
	if(PlayerInfo[playerid][pJob] != JOB_ELEC)
		return 1;

	new vehicleid = jobVehicle[playerid];
	new Float:vhp;
	if(IsValidVehicle(vehicleid))
	{
		GetVehicleHealth(vehicleid, vhp);
	}
	else
	{
		// Si el vehículo ya no existe, asumimos daño medio
		vhp = gElecVehicleHp[playerid] - 400.0;
	}

	new Float:vhp_dmg = gElecVehicleHp[playerid] - vhp;
	if(vhp_dmg < 0.0) vhp_dmg = 0.0;

	new paycheck              = ELEC_BASE_SALARY;
	new dmg_pay_penalty       = 0;
	new rep_change            = 0;

	if(vhp_dmg > 40.0)
	{
		dmg_pay_penalty = floatround(vhp_dmg, floatround_ceil); // Descuento proporcional al daño
		rep_change      = -15;
	}
	else
	{
		rep_change      = 10;
	}

	paycheck -= dmg_pay_penalty;
	if(paycheck < 0) paycheck = 0;

	// Actualizamos info de empleo legal estándar
	PlayerJobInfo[playerid][pWorkingHours]++;
	PlayerJobInfo[playerid][pTotalEarnings] += paycheck;
	PlayerInfo[playerid][pPayCheck]        += paycheck;

	Job_GiveReputation(playerid, rep_change);
	Job_CheckReputationLimit(playerid);


	new elec_msg[256];
	format(elec_msg, sizeof(elec_msg), "Has finalizado tu trabajo de electricista y recibirás $%d en el próximo payday.", paycheck);
	SendClientMessage(playerid, COLOR_WHITE, elec_msg);

	format(elec_msg, sizeof(elec_msg), "[DETALLES] Salario base: $%d - Descuento por daños: {FF0000}- $%d{FFFFFF} - Cambio de reputación: %d",
		ELEC_BASE_SALARY,
		dmg_pay_penalty,
		rep_change
	);
	SendClientMessage(playerid, COLOR_WHITE, elec_msg);

	PlayerInfo[playerid][pCantWork]++;

	return 1;
}

stock ElecJob_FinishWork(playerid, bool:byPlayer = true)
{
	if(!ElecJob_IsWorking(playerid))
		return 1;

	if(byPlayer)
	{
		ElecJob_Pay(playerid);
	}
	else
	{
		// Cancelado por comando /terminar: respawnear vehículo inmediatamente
		new vehicleid = jobVehicle[playerid];
		if(IsValidVehicle(vehicleid))
		{
			SetVehicleToRespawn(vehicleid);
		}
		
		Job_GiveReputation(playerid, -20);
		Job_CheckReputationLimit(playerid);
		
		PlayerInfo[playerid][pCantWork]++;
		SendClientMessage(playerid, COLOR_WHITE, "Has abandonado tu jornada como electricista. Tu reputación laboral ha disminuido.");
	}

	jobDuty[playerid] = false;
	Cronometro_Borrar(playerid);
	DisablePlayerCheckpoint(playerid);

	// Limpiamos animaciones / items
	ClearAnimations(playerid);
	SetHandItemAndParam(playerid, HAND_RIGHT, 0, 0);

	// Asegurarse de cerrar minijuego si estaba activo
	CallLocalFunction("StopElecWiresMinigame", "ii", playerid, false);

	// Como fallback, asegurarse de que el jugador recupere control
	TogglePlayerControllable(playerid, true);

	new restoreSkin = (gElecSavedSkin[playerid] != -1) ? gElecSavedSkin[playerid] : PlayerInfo[playerid][pSkin];
	SetPlayerSkin(playerid, restoreSkin);
	PlayerInfo[playerid][pJobSkin] = 0;
	gElecSavedSkin[playerid] = -1;

	ElecJob_ResetVars(playerid);

	return 1;
}

// ============================================================================
// MANEJO DE CHECKPOINTS
// ============================================================================

forward ElecJob_FinishPoint(playerid);
public ElecJob_FinishPoint(playerid)
{
	if(!ElecJob_IsWorking(playerid))
		return 1;

	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);

	// NO quitar la caja de herramientas - el jugador debe guardarla manualmente con ALT
	// Esto evita que se pierda accidentalmente

	gElecCurrentPointIdx[playerid]++;

	if(gElecCurrentPointIdx[playerid] >= ELEC_POINTS_PER_JOB)
	{
		// Trabajo terminado: jugador debe guardar la caja y devolver vehículo
		SendClientMessage(playerid, COLOR_WHITE, "Has terminado todas las reparaciones de tu recorrido.");
		SendClientMessage(playerid, COLOR_WHITE, "Regresa a tu vehículo, GUARDA la caja de herramientas con ALT y dirígete al punto inicial.");
		
		// Marcar el punto inicial como destino
		SetPlayerCheckpoint(playerid, gElecVehicleStartX[playerid], gElecVehicleStartY[playerid], gElecVehicleStartZ[playerid], ELEC_CP_SIZE);
		
		return 1;
	}

	new pointIdx = gElecSelectedPoints[playerid][gElecCurrentPointIdx[playerid]];
	new Float:x, Float:y, Float:z, Float:angle;
	if(!ElecJob_GetPoolPoint(pointIdx, x, y, z, angle))
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Punto de ruta inválido. Reportar a un administrador.");
		ElecJob_FinishWork(playerid, false);
		return 1;
	}

	SetPlayerCheckpoint(playerid, x, y, z, ELEC_CP_SIZE);
	SendClientMessage(playerid, COLOR_WHITE, "Regresa a tu vehículo, guarda la caja de herramientas detrás con ALT y dirígete al próximo poste marcado.");

	return 1;
}

forward ElecJob_TimeLimit(playerid);
public ElecJob_TimeLimit(playerid)
{
	if(!ElecJob_IsWorking(playerid))
		return 1;

	SendClientMessage(playerid, COLOR_WHITE, "[TELEGRAMA DEL EMPLEADOR]: Has superado el tiempo límite para completar el recorrido. No cobrarás tu paga y tu reputación ha disminuido.");
	SendClientMessage(playerid, COLOR_WHITE, "Debes devolver el vehículo manualmente para completar el trabajo.");
	
	// Limpiar solo el trabajo sin respawnear el vehículo
	jobDuty[playerid] = false;
	Cronometro_Borrar(playerid);
	DisablePlayerCheckpoint(playerid);
	
	// Penalizar
	Job_GiveReputation(playerid, -20);
	Job_CheckReputationLimit(playerid);
	PlayerInfo[playerid][pCantWork]++;
	
	// Limpiar animaciones / items pero mantener el vehículo
	ClearAnimations(playerid);
	SetHandItemAndParam(playerid, HAND_RIGHT, 0, 0);

	new restoreSkin = (gElecSavedSkin[playerid] != -1) ? gElecSavedSkin[playerid] : PlayerInfo[playerid][pSkin];
	SetPlayerSkin(playerid, restoreSkin);
	PlayerInfo[playerid][pJobSkin] = 0;
	gElecSavedSkin[playerid] = -1;

	ElecJob_ResetVars(playerid);

	return 1;
}

// Hook de checkpoints
hook function OnPlayerEnterCPId(playerid, checkpointid)
{
	if(!ElecJob_IsWorking(playerid))
		return continue(playerid, checkpointid);

	// Comprobar si es el checkpoint inicial (devolución de vehículo)
	if(gElecCurrentPointIdx[playerid] >= ELEC_POINTS_PER_JOB)
	{
		// El jugador ha completado todos los puntos y ahora debe devolver el vehículo
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en el vehículo de trabajo para devolverlo.");
			new Float:x = gElecVehicleStartX[playerid], Float:y = gElecVehicleStartY[playerid], Float:z = gElecVehicleStartZ[playerid];
			SetPlayerCheckpoint(playerid, x, y, z, ELEC_CP_SIZE);
			return 1;
		}

		// Comprobar que guardó la caja de herramientas
		if(gElecHasToolbox[playerid])
		{
			SendClientMessage(playerid, COLOR_YELLOW2, "Primero debes guardar la caja de herramientas con ALT en la parte trasera del vehículo.");
			new Float:x = gElecVehicleStartX[playerid], Float:y = gElecVehicleStartY[playerid], Float:z = gElecVehicleStartZ[playerid];
			SetPlayerCheckpoint(playerid, x, y, z, ELEC_CP_SIZE);
			return 1;
		}

		// Vehículo devuelto: completar el trabajo y respawnear vehículo
		new vehicleid = jobVehicle[playerid];
		if(IsValidVehicle(vehicleid))
		{
			SetVehicleToRespawn(vehicleid);
		}
		
		SendClientMessage(playerid, COLOR_WHITE, "Has devuelto el vehículo. Gracias por tu trabajo.");
		ElecJob_FinishWork(playerid, true);
		return 1;
	}

	// Punto de trabajo normal
	new pointIdx = gElecSelectedPoints[playerid][gElecCurrentPointIdx[playerid]];
	new Float:x, Float:y, Float:z, Float:angle;
	if(!ElecJob_GetPoolPoint(pointIdx, x, y, z, angle))
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Punto de ruta inválido. Reportar a un administrador.");
		ElecJob_FinishWork(playerid, false);
		return 1;
	}

	// Si entra con vehículo, no cuenta
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
		SetTimerEx("ElecJob_SetDelayedCheckpoint", 1500, false, "iffff", playerid, x, y, z, ELEC_CP_SIZE);
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes bajar de la camioneta para trabajar en el poste.");
		return 1;
	}

	// Si no tiene caja de herramientas, no puede reparar
	if(!gElecHasToolbox[playerid])
	{
		SetTimerEx("ElecJob_SetDelayedCheckpoint", 1500, false, "iffff", playerid, x, y, z, ELEC_CP_SIZE);
		SendClientMessage(playerid, COLOR_YELLOW2, "Primero debes ir a la parte trasera de tu vehículo y tomar la caja de herramientas con ALT.");
		return 1;
	}

	// Iniciar minijuego de cableado en vez de animación fija
	PlayerActionMessage(playerid, 60.0, "repara el cableado del poste.");
	GameTextForPlayer(playerid, "~w~Resuelve el cableado para reparar el poste...", 5000, 4);

	// Dificultad variable: 60% = 4, 20% = 3 (fácil), 20% = 5 (difícil)
	new chance = random(100);
	new wires = 4;
	if (chance < 20) wires = 3;
	else if (chance >= 80) wires = 5;

	StartElecWiresMinigame(playerid, wires);

	return 1;
}

forward ElecJob_SetDelayedCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size);
public ElecJob_SetDelayedCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size)
{
	if(ElecJob_IsWorking(playerid))
	{
		SetPlayerCheckpoint(playerid, x, y, z, size);
	}
	return 1;
}

// ============================================================================
// TECLA ALT PARA TOMAR/GUARDAR CAJA DE HERRAMIENTAS (KEY_WALK)
// ============================================================================

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!ElecJob_IsWorking(playerid))
		return 1;

	// Presión de tecla ALT (KEY_WALK) una sola vez
	if((newkeys & KEY_WALK) && !(oldkeys & KEY_WALK))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return 1;

		new vehicleid = jobVehicle[playerid];
		if(!IsValidVehicle(vehicleid))
			return 1;

		// ========== GUARDAR TOOLBOX ==========
		if(gElecHasToolbox[playerid])
		{
			// Verificar que está detrás del vehículo
			new Float:x, Float:y, Float:z;
			GetXYZBehindVehicle(vehicleid, x, y, z, ELEC_TOOLBOX_DIST);

			if(!IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z))
			{
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar detrás de tu vehículo para guardar la caja de herramientas.");
				return 1;
			}

			// Guardar toolbox
			ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
			PlayerPlaySound(playerid, 1139, 0, 0, 0);
			
			SetTimerEx("ElecJob_PutToolbox", 700, false, "i", playerid);
			return 1;
		}

		// ========== TOMAR TOOLBOX ==========
		new Float:x, Float:y, Float:z;
		GetXYZBehindVehicle(vehicleid, x, y, z, ELEC_TOOLBOX_DIST);

		if(!IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z))
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar detrás de tu vehículo de trabajo para tomar la caja de herramientas.");
			return 1;
		}

		if(GetHandItem(playerid, HAND_RIGHT) != 0 || GetHandItem(playerid, HAND_LEFT) != 0)
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener las manos libres para tomar la caja de herramientas.");
			return 1;
		}

		// Animación y set de item
		ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		PlayerPlaySound(playerid, 1139, 0, 0, 0);
		SetTimerEx("ElecJob_GiveToolbox", 700, false, "i", playerid);

		return 1;
	}

	return 1;
}

forward ElecJob_GiveToolbox(playerid);
public ElecJob_GiveToolbox(playerid)
{
	if(!ElecJob_IsWorking(playerid))
		return 1;

	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;

	SetHandItemAndParam(playerid, HAND_RIGHT, ITEM_ID_TOOLBOX, 1);
	gElecHasToolbox[playerid] = true;
	SendClientMessage(playerid, COLOR_WHITE, "Has tomado la caja de herramientas. Dirígete al poste marcado en el mapa y repáralo.");

	return 1;
}

forward ElecJob_PutToolbox(playerid);
public ElecJob_PutToolbox(playerid)
{
	if(!ElecJob_IsWorking(playerid))
		return 1;

	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;

	SetHandItemAndParam(playerid, HAND_RIGHT, 0, 0);
	gElecHasToolbox[playerid] = false;
	SendClientMessage(playerid, COLOR_WHITE, "Has guardado la caja de herramientas en la camioneta.");

	return 1;
}

// Allow/deny entering vehicle while working: prevent entry if toolbox is held
public ElecJob_AllowEnterVehicle(playerid, vehicleid)
{
	if (!ElecJob_IsWorking(playerid)) return 1;
	if (!IsValidVehicle(vehicleid)) return 1;

	// If this is the player's job vehicle and they still hold the toolbox, deny entry
	if (vehicleid == jobVehicle[playerid] && gElecHasToolbox[playerid]) {
		SendClientMessage(playerid, COLOR_YELLOW2, "Primero debes guardar la caja de herramientas con ALT en la parte trasera del vehículo.");
		return 0;
	}

	return 1;
}

// ============================================================================
// DESCONEXIÓN / LIMPIEZA
// ============================================================================

hook OnPlayerDisconnect(playerid, reason)
{
	if(ElecJob_IsWorking(playerid))
	{
		new vehicleid = jobVehicle[playerid];
		if(IsValidVehicle(vehicleid))
		{
			SetVehicleToRespawn(vehicleid);
		}

		jobDuty[playerid] = false;
		Cronometro_Borrar(playerid);
		DisablePlayerCheckpoint(playerid);

		SetHandItemAndParam(playerid, HAND_RIGHT, 0, 0);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		PlayerInfo[playerid][pJobSkin] = 0;

		// Asegurarse de cerrar el minijuego si estaba activo (limpia UI y SelectTextDraw)
		CallLocalFunction("StopElecWiresMinigame", "ii", playerid, false);

		ElecJob_ResetVars(playerid);
	}
	return 1;
}

// ============================================================================
// COMANDO OPCIONAL /electricistainfo y /electricistacancelar
// ============================================================================

CMD:electricistainfo(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != JOB_ELEC)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el empleo de electricista.");

	new str[512];
    format(str, sizeof(str), "\n{00FF00}[Empleo de Electricista]{a9c4e4}\n\
    Cargo: %s\n\
    Trabajos realizados: %d\n\
    Ultimo dia de trabajo: %s\n\
    Ingresos totales: $%d\n\
    Imagen laboral: %s\n\
    Estado laboral: %s\n\n\
    {00FF00}[Dinámica del trabajo]{a9c4e4}\n\
    1) Usa /trabajar dentro de tu camioneta de trabajo.\n\
    2) Conduce hasta los puntos rojos en el mapa (8 ubicaciones aleatorias).\n\
    3) Estaciona cerca y baja de la camioneta.\n\
    4) Ve a la parte trasera del vehículo y presiona ALT para tomar la caja de herramientas.\n\
    5) Dirígete al poste, míralo y espera mientras lo reparas (~30 segundos).\n\
    6) Regresa a la camioneta, presiona ALT para guardar la caja de herramientas.\n\
    7) Repite con los 8 postes para completar tu jornada.\n\
    8) Al terminar, regresa a la posición inicial y estaciona el vehículo para cobrarlo.",
        GetJobChargeName(JOB_ELEC, PlayerJobInfo[playerid][pCharge]),
        PlayerJobInfo[playerid][pWorkingHours],
        PlayerJobInfo[playerid][pLastWorked],
        PlayerJobInfo[playerid][pTotalEarnings],
        GetJobReputationString(PlayerJobInfo[playerid][pReputation]),
        GetJobStateString(PlayerJobInfo[playerid][pState])
    );

	Dialog_Show(playerid, Job_Info, DIALOG_STYLE_MSGBOX, "EMPLEO DE ELECTRICISTA", str, "Cerrar", "");

	return 1;
}

CMD:electricistacancelar(playerid, params[])
{
	if(!ElecJob_IsWorking(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras trabajando como electricista.");

	ElecJob_FinishWork(playerid, false);
	return 1;
}
