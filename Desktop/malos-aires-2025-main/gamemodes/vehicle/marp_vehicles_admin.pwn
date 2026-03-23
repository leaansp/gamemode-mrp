#if defined _marp_vehicles_admin_included
	#endinput
#endif
#define _marp_vehicles_admin_included

// Admin edit dialog IDs
#define DLG_AVEDIT_MENU      (2401)
#define DLG_AVEDIT_KM        (2402)
#define DLG_AVEDIT_STATE     (2403)

static AVEditVehicle[MAX_PLAYERS];

forward AV_BreakVehicleTimer(vehicleid);
forward AV_PincharTimer(vehicleid, bit);
public AV_BreakVehicleTimer(vehicleid)
{
	if(!Veh_IsValidId(vehicleid)) return 1;

	// Simular falla mecánica: apagar motor y bajar vida
	VehMechProblem[vehicleid] = 1;

	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);

	new Float:hp;
	GetVehicleHealth(vehicleid, hp);
	hp -= Float:180.0;
	if(hp < Float:300.0) hp = Float:300.0;
	SetVehicleHealth(vehicleid, hp);

	// Persistir estado de desgaste y notificar pasajeros (flujo normal)
	Admin_SaveWear(vehicleid);
	foreach(new p : Player)
	{
		if(IsPlayerInVehicle(p, vehicleid))
			SendClientMessage(p, COLOR_ACT1, "El motor empieza a fallar y se apaga. Necesitás pasar por un taller.");
	}

	return 1;
}

static Admin_SaveWear(vehicleid)
{
	if(!Veh_IsValidId(vehicleid)) return 0;
	new q[256];
	mysql_format(MYSQL_HANDLE, q, sizeof q,
		"UPDATE `vehicles` SET `VehTotalKm`=%f,`VehKmSinceService`=%f,`VehNextIssueAtKm`=%f,`VehMechProblem`=%i WHERE `VehSQLID`=%i LIMIT 1;",
		VehTotalKm[vehicleid],
		VehKmSinceService[vehicleid],
		VehNextIssueAtKm[vehicleid],
		VehMechProblem[vehicleid],
		VehicleInfo[vehicleid][VehSQLID]
	);
	mysql_tquery(MYSQL_HANDLE, q);
	return 1;
}

CMD:av(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "_____________________________________[ ADMINISTRACION DE VEHICULOS ]_____________________________________");
	SendClientMessage(playerid, COLOR_WHITE, "[COMANDOS] "COLOR_EMB_GREY" /avmotor - /avinfo - /avfix - /avfuel - /aventrar - /avtraer - /avrespawn - /avestacionar - /avhp");
	SendClientMessage(playerid, COLOR_WHITE, "[COMANDOS] "COLOR_EMB_GREY" /avpatente - /avrespawnall - /avfuelcars - /avfixcars - /avresetplates- /avcolor - /avnitro");
	SendClientMessage(playerid, COLOR_WHITE, "[COMANDOS] "COLOR_EMB_GREY" /avtipo - /avmodelo - /avfaccion - /avempleo - /avsirena - /avcrear - /avborrar - /avowner - /avgoto");
	SendClientMessage(playerid, COLOR_WHITE, "[COMANDOS] "COLOR_EMB_GREY" /avromper - /avpinchar - /avkm - /avestado - /avfixmodel - /avfixallmodels");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "_________________________________________________________________________________________________________");
	return 1;
}

CMD:avmotor(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new vehicleid;

	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");

	GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
 	
 	if(VehicleInfo[vehicleid][VehEngine] != 1)
 	{
		SetEngine(vehicleid, 1);
		SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i encendido correctamente.", vehicleid);
 	}
 	else
 	{
		SetEngine(vehicleid, 0);
		SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i apagado correctamente.", vehicleid);
	}
	return 1;
}

CMD:avinfo(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new Float:hp, id, string[512];

	if(sscanf(params, "i", id) && !(id = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avinfo [idvehiculo]");
	if(!Veh_IsValidId(id, true))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo inválida.");

	GetVehicleHealth(id, hp);

	new lastDriverName[MAX_PLAYER_NAME];

	Veh_GetLastDriverName(id, lastDriverName);

	format(string, sizeof(string),"\n\
		- Id: %i (SQLID: %i)\n\
		- Tipo: %i (%s)\n\
		- Tiempo de respawn sin conductor: %i segs\n\
		- Modelo: %s (%i)\n\
		- Colores: %i (%s####"COLOR_EMB_DLG_DEFAULT") - %i (%s####"COLOR_EMB_DLG_DEFAULT")\n\
		- Faccion: %i\n\
		- Empleo: %i\n\
		- dueño: %s (SQLID: %i)\n\
		- Patente: %s\n\
		- HP: %.2f - HP2: %.2f\n\
		- Gasolina: %i\n\
		- Cerrado: %i\n\
		- Sirena: %i\n\
		- Ultimo conductor: %s\n\
		- Container SQLID: %i\n\
		- Kilometros: %.2f\n",
		id, VehicleInfo[id][VehSQLID],
		VehicleInfo[id][VehType], Veh_GetSystemTypeName(VehicleInfo[id][VehType]),
		VehicleInfo[id][VehRespawnTime],
		Veh_GetModelName(VehicleInfo[id][VehModel]), VehicleInfo[id][VehModel],
		VehicleInfo[id][VehColor1], GetEmbeddedVehicleColor(VehicleInfo[id][VehColor1]), VehicleInfo[id][VehColor2], GetEmbeddedVehicleColor(VehicleInfo[id][VehColor2]),
		VehicleInfo[id][VehFaction],
		VehicleInfo[id][VehJob],
		VehicleInfo[id][VehOwnerName], VehicleInfo[id][VehOwnerSQLID],
		VehicleInfo[id][VehPlate],
		hp, VehicleInfo[id][VehHP],
		VehicleInfo[id][VehFuel],
		VehicleInfo[id][VehLocked],
		VehicleInfo[id][VehSiren],
		lastDriverName,
		VehicleInfo[id][VehContainerSQLID],
		VehTotalKm[id]
	);

	Dialog_Show(playerid, DLG_CMD_AVINFO, DIALOG_STYLE_MSGBOX, "Información de vehículo", string, "Cerrar", "");
	return 1;
}

CMD:aventrar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new vehicleid;

    if(sscanf(params, "i", vehicleid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aventrar [idvehiculo]");
	if(!Veh_IsValidId(vehicleid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo inválida.");
	
	// [FIX] Validación adicional: asegurar que el vehículo existe en el servidor
	if(!IsValidVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vehículo no existe en el servidor.");
	
	new seat = Veh_GetFreeSeat(vehicleid);

	if(seat == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Todos los asientos estan ocupados.");

	new Float:pos[4];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerFacingAngle(playerid, pos[3]);
	TeleportPlayerTo(playerid, pos[0], pos[1], pos[2], pos[3], Veh_GetInterior(vehicleid), GetVehicleVirtualWorld(vehicleid));
	
	if(!PutPlayerInVehicle(playerid, vehicleid, seat)) {
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se pudo entrar al vehículo. Intenta de nuevo.");
	}
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" Entraste correctamente al vehículo %i.", vehicleid);
	return 1;
}

CMD:avrespawn(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new vehicleid;

	if(sscanf(params, "i", vehicleid) && !(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avrespawn [idvehiculo]");
	if(!Veh_IsValidId(vehicleid, true))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo inválida.");

	Veh_Respawn(vehicleid);
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i respawneado correctamente.", vehicleid);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avrespawn", .playerid=playerid);
	return 1;
}

CMD:avrespawnall(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 6)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	for(new i = 1; i < MAX_VEH; i++)
	{
 		if(IsVehicleOccupied(i) == 0) {
 			Veh_Respawn(i);
		}
	}
	SendClientMessageToAll(COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Todos los vehículos desocupados han sido respawneados por un administrador.");
	return 1;
}

CMD:avtraer(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new vehicleid;

	if(sscanf(params, "i", vehicleid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avtraer [idvehiculo]");
	if(!Veh_IsValidId(vehicleid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo inválida.");
	if(Depo_IsVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este vehículo se encuentra en el deposito policial.");

	new Float:x, Float:y, Float:z, Float:angle, Float:dist, interior, vworld;

	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, x, y, z);
	dist = (x / 2.0) + 4.0;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
	GetXYInFrontOfPoint(x, y, angle, x, y, dist);
	interior = GetPlayerInterior(playerid);
	vworld = GetPlayerVirtualWorld(playerid);

	TeleportVehicleTo(vehicleid, x, y, z, angle, interior, vworld);
	
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i traído correctamente.", vehicleid);
	return 1;
}

CMD:avfix(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new vehicleid;

	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");

	RepairVehicle(vehicleid);
	VehicleInfo[vehicleid][VehHP] = 1000.0;
	// Resetear desgaste mecánico y reconfigurar umbral del sistema de desgaste
	VW_OnWorkshopRepair(vehicleid);
	Admin_SaveWear(vehicleid);

	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i reparado correctamente.", vehicleid);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avfix", .playerid=playerid);
	return 1;
}

CMD:avfuel(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new vehicleid;

	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"debes estar en un vehículo para utilizar este comando.");

	VehicleInfo[vehicleid][VehFuel] = 100;
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i llenado correctamente con combustible.", vehicleid);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avfuel", .playerid=playerid);
	return 1;
}

CMD:avfuelcars(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 6)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	for(new c = 0; c < MAX_VEH; c++) {
		VehicleInfo[c][VehFuel] = 100;
	}

	SendClientMessageToAll(COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Todos los vehículos han sido llenados con gasolina por un administrador.");
	ServerLog(LOG_TYPE_ID_VEHICLES, .entry="/avfuelcars", .playerid=playerid);
	return 1;
}

CMD:avfixcars(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 6)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	for(new c = 0; c < MAX_VEH; c++)
	{
		RepairVehicle(c);
		VehicleInfo[c][VehHP] = 1000.0;
		// Resetear desgaste mecánico y reconfigurar umbral del sistema de desgaste
		VW_OnWorkshopRepair(c);
		Admin_SaveWear(c);
	}

	SendClientMessageToAll(COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Todos los vehículos han sido reparados por un administrador.");
	ServerLog(LOG_TYPE_ID_VEHICLES, .entry="/avfixcars", .playerid=playerid);
	return 1;
}

CMD:avnitro(playerid, params[])
{
	new vehicleid;

	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");

	AddVehicleComponent(vehicleid, 1010);
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" Nitro temporal correctamente instalado en el vehículo %i.", vehicleid);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avnitro", .playerid=playerid);
	return 1;
}

CMD:avromper(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 10)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");

	new vehicleid;
	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");

	SendClientMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" El vehículo se romperá en 10 segundos.");
	SetTimerEx("AV_BreakVehicleTimer", 10000, false, "i", vehicleid);
	return 1;
}

CMD:avpinchar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 10)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");

	new vehicleid;
	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");

	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

	// Determinar qué rueda pinchar (no aplicar todavía)
	new bit = -1;
	if(tires & 0x0F) { // alguna ya pinchada: buscar una no pinchada
		for(new i = 0; i < 4; i++) {
			if(!(tires & (1 << i))) { bit = i; break; }
		}
	} else {
		// ninguna pinchada: seleccionar aleatoria
		bit = random(4);
	}

	if(bit == -1) return SendClientMessage(playerid, COLOR_WHITE, "Todas las ruedas ya están pinchadas.");

	// Schedule puncture in 10 seconds to simulate delay
	SendClientMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" La rueda se pinchara en 10 segundos.");
	SetTimerEx("AV_PincharTimer", 10000, false, "ii", vehicleid, bit);

	// Notify passengers that something happened (small warning)
	foreach(new p : Player)
	{
		if(IsPlayerInVehicle(p, vehicleid))
			SendClientMessage(p, COLOR_ACT1, "Escuchás un chirrido raro... algo parece fallar en una rueda.");
	}

	return 1;
}

	public AV_PincharTimer(vehicleid, bit)
	{
		if(!Veh_IsValidId(vehicleid)) return 1;

		new panels, doors, lights, tires;
		GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

		// If already punctured that wheel, try to find another one
		if(!(tires & (1 << bit))) {
			// apply puncture
			tires |= (1 << bit);
		} else {
			// find first non-punctured
			new found = -1;
			for(new i = 0; i < 4; i++) {
				if(!(tires & (1 << i))) { found = i; break; }
			}
			if(found == -1) return 1; // all punctured
			tires |= (1 << found);
		}

		UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
		// Mark state change in DB if needed via SaveVehicle (damage is stored in VehicleInfo)
		SaveVehicle(vehicleid);

		foreach(new p : Player)
		{
			if(IsPlayerInVehicle(p, vehicleid))
				SendClientMessage(p, COLOR_ACT1, "Escuchás un golpe seco… se te pinchó una rueda.");
		}
		return 1;
	}

CMD:avkm(playerid, params[])
{
	new vehicleid;
	new Float:tkm = 0.0, Float:skm = 0.0, Float:nkm = 0.0;

	// Normalize decimal comma to dot
	new len = strlen(params);
	for(new i = 0; i < len; i++) if(params[i] == ',') params[i] = '.';

	// Extract three whitespace-separated tokens first (robust to spacing)
	new tok1[32], tok2[32], tok3[32];
	if(sscanf(params, "s[32] s[32] s[32]", tok1, tok2, tok3) != 3)
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avkm <totalkm> <ult service> <siguiente umbral>");

	// Convert each token to float (accept float or int forms)
	new itmp = 0;
	if(sscanf(tok1, "f", tkm) != 1)
	{
		if(sscanf(tok1, "i", itmp) != 1)
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avkm <totalkm> <ult service> <siguiente umbral>");
		tkm = float(itmp);
	}
	if(sscanf(tok2, "f", skm) != 1)
	{
		if(sscanf(tok2, "i", itmp) != 1)
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avkm <totalkm> <ult service> <siguiente umbral>");
		skm = float(itmp);
	}
	if(sscanf(tok3, "f", nkm) != 1)
	{
		if(sscanf(tok3, "i", itmp) != 1)
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avkm <totalkm> <ult service> <siguiente umbral>");
		nkm = float(itmp);
	}

	vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid == 0 || GetPlayerVehicleSeat(playerid) != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser el conductor del vehículo para usar este comando.");

	if(!Veh_IsValidId(vehicleid, true))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo inválida.");

	if(tkm < Float:0.0) tkm = Float:0.0;
	if(skm < Float:0.0) skm = Float:0.0;
	if(skm > tkm) skm = tkm;
	if(nkm < VW_MIN_THRESHOLD_KM) nkm = VW_MIN_THRESHOLD_KM;

	VehTotalKm[vehicleid] = tkm;
	VehKmSinceService[vehicleid] = skm;
	VehNextIssueAtKm[vehicleid] = nkm;

	Admin_SaveWear(vehicleid);

	SendClientMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" KM actualizados.");
	return 1;
}

CMD:avestado(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 10)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");
	new vehicleid;
	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");

	AVEditVehicle[playerid] = vehicleid;
	ShowPlayerDialog(playerid, DLG_AVEDIT_STATE, DIALOG_STYLE_LIST, "Editar estado", "OK\nCON FALLA", "Seleccionar", "Cancelar");
	return 1;
}


Dialog:DLG_AVEDIT_STATE(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	new vehicleid = AVEditVehicle[playerid];
	if(!Veh_IsValidId(vehicleid)) return 1;

	switch(listitem)
	{
		case 0: VehMechProblem[vehicleid] = 0;
		case 1: VehMechProblem[vehicleid] = 1;
	}

	Admin_SaveWear(vehicleid);
	SendClientMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" Estado actualizado.");
	return 1;
}

CMD:avempleo(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new vehicleid, jobid;

	if(sscanf(params, "i", jobid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avempleo [idempleo]");
	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");
	if(jobid < 0 || jobid > 10)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de empleo inválida.");

	VehicleInfo[vehicleid][VehJob] = jobid;
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" El empleo del vehículo %i ha sido ajustado a %i.", vehicleid, jobid);
	SaveVehicle(vehicleid);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avempleo", .playerid=playerid, .params=params);
	return 1;
}

CMD:avfaccion(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new vehicleid, factionid;

	if(sscanf(params, "i", factionid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avfaccion [idfaccion]");
	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");
	if(factionid < 0 || factionid > 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de facción inválida.");

	VehicleInfo[vehicleid][VehFaction] = factionid;
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" La facción del vehículo %i ha sido ajustada a %i.", vehicleid, factionid);
	SaveVehicle(vehicleid);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avfaccion", .playerid=playerid, .params=params);
	return 1;
}

CMD:avcolor(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 6)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	new vehicleid, color1, color2;

	if(sscanf(params, "ii", color1, color2))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avcolor [color1] [color2]");
	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");
	if(!(0 <= color1 <= 255 && 0 <= color2 <= 255))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresa colores válidos: [0 - 255].");

	if(!Veh_SetColor(vehicleid, color1, color2))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"vehículo inválido.");

	PutPlayerInVehicle(playerid, vehicleid, 0);
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" El color del vehículo %i ha sido ajustado a %i-%i.", vehicleid, color1, color2);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avcolor", .playerid=playerid, .params=params);
	return 1;
}

CMD:avmodelo(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new vehicleid, modelid;

	if(sscanf(params, "ii", vehicleid, modelid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avmodelo [idvehiculo] [idmodelo]");
	if(!Veh_IsValidId(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo inválida.");
	if(!Veh_IsValidModel(modelid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de modelo incorrecta, debe estar en el rango de 400-611.");
	if(Veh_GetModelModelType(modelid) == VTYPE_TRAIN)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de modelo incorrecta, no es posible crear trenes.");

	if(!Veh_SetModel(vehicleid, modelid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"vehículo inválido.");
	
	PutPlayerInVehicle(playerid, vehicleid, 0);
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" El modelo del vehículo %i ha sido cambiado a %i.", vehicleid, modelid);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avmodelo", .playerid=playerid, .params=params);
	return 1;
}

CMD:avsirena(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 6)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	new vehicleid, siren;

	if(sscanf(params, "i", siren))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avsirena [1 o 0]");
	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");
	if(!(0 <= siren <= 1))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Usa 1 para instalar sirena o 0 para desinstalar.");

	if(!Veh_SetSiren(vehicleid, siren))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"vehículo inválido.");

	PutPlayerInVehicle(playerid, vehicleid, 0);
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" La sirena del vehículo %i ha sido cambiada a %i.", vehicleid, siren);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avsirena", .playerid=playerid, .params=params);
	return 1;
}

CMD:avtipo(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new vehicleid, type;

	if(sscanf(params, "i", type))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avtipo [ID tipo] (1: estático - 2: Personal - 3: facción - 4: Licencia - 5: Temporal - 6: Empleo - 7: Renta)");
	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");
	if(type < 1 || type > 7)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de tipo incorrecta.");

	if(!Veh_SetType(vehicleid, type))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"vehículo inválido o no se pueden poner más vehículos de renta.");

	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" El tipo del vehículo %i ha sido ajustado a %i.", vehicleid, type);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avtipo", .playerid=playerid, .params=params);
	return 1;
}

CMD:avestacionar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 10)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");

	new vehicleid, Float:x, Float:y, Float:z, Float:angle, vworld, interior;

	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid,  COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" Debes estar en un vehículo para utilizar este comando.");

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, angle);
	vworld = GetPlayerVirtualWorld(playerid);
	interior = GetPlayerInterior(playerid);

	if(!Veh_SetRespawnPoint(vehicleid, x, y, z, angle, vworld, interior))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"vehículo inválido.");

	PutPlayerInVehicle(playerid, vehicleid, 0);
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i estacionado correctamente.", vehicleid);
	ServerFormattedLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avestacionar", .playerid=playerid, .params=<"(x: %.2f y: %.2f z: %2.f)", x, y, z>);
	return 1;
}

CMD:avcrear(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new vehicleid, Float:x, Float:y, Float:z, Float:angle, modelid, color1, color2, respawn_secs, interior, vworld;

	if(sscanf(params, "iiii", modelid, color1, color2, respawn_secs))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avcrear [idmodelo] [color1] [color2] [respawn en segundos sin conductor] (para PERMANENTE use -1).");
	if(!Veh_IsValidModel(modelid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de modelo incorrecta, debe estar en el rango de [400 - 611].");
	if(!(0 <= color1 <= 255 && 0 <= color2 <= 255))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresa colores válidos: [0 - 255].");
	if(Veh_GetModelModelType(modelid) == VTYPE_TRAIN)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de modelo incorrecta, no es posible crear trenes.");

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	interior = GetPlayerInterior(playerid);
	vworld = GetPlayerVirtualWorld(playerid);

	if(!(vehicleid = Veh_Create(modelid, color1, color2, x, y, z, angle, interior, vworld, respawn_secs)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Límite de vehículos alcanzado.");

	PutPlayerInVehicle(playerid, vehicleid, 0);
	if(respawn_secs > 0)
	{
		SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i creado correctamente (luego de %i segundos sin un conductor será respawneado).", vehicleid, respawn_secs);
		SendClientMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" El vehículo fue creado como tipo temporal: al respawnear se borrará. Para evitarlo, cambia el tipo con /avtipo.");
	} else {
		SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i de tipo permanente creado correctamente. No posee tiempo de respawn sin conductor.", vehicleid);
	}
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avcrear", .playerid=playerid, .params=params);
	return 1;
}

CMD:avborrar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new vehicleid;

	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");

	if(Veh_Delete(vehicleid))
	{
		SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" vehículo %i borrado correctamente.", vehicleid);
		ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avborrar", .playerid=playerid);
	} else {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error en el borrado del vehículo %i.", vehicleid);
	}
	return 1;
}

CMD:avhp(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new vehicleid, vhp;

	if(sscanf(params, "ii", vehicleid, vhp))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avhp [idvehiculo] [hp]");
	if(!Veh_IsValidId(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehiculo incorrecta.");
	if(vhp < 250 || vhp > 10000)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo valores comprendidos en intervalo (250 - 10000).");

	SetVehicleHealth(vehicleid, float(vhp));
	// VehicleInfo[vehicleid][VehMaxHp] = float(vhp);
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" La vida del vehículo %i ha sido cambiada a %i.", vehicleid, vhp);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avhp", .playerid=playerid, .params=params);
	return 1;
}

CMD:avpatente(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new vehicleid, string[MAX_VEH_PLATE_LENGTH];
	
	if(sscanf(params, "is[10]", vehicleid, string))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avpatente [idvehiculo] [patente] (máx 10 char)");

	if(Veh_SetCustomPlate(vehicleid, string))
	{
		SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" La patente del vehículo %i ha sido cambiada a %s.", vehicleid, string);
		ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avpatente", .playerid=playerid, .params=params);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo o patente inválida.");
	}
	return 1;
}

CMD:avowner(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 10)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");

	new vehicleid, ownerid, ownername[MAX_PLAYER_NAME];
	    
	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");

	if(Veh_GetSystemType(vehicleid) == VEH_OWNED)
	{
		if(sscanf(params, "u", ownerid))
        	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avowner [ID/Jugador]");
		if(!IsPlayerLogged(ownerid))
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador no conectado.");
		if(!KeyChain_GetFreeSlots(ownerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene más espacio en su llavero.");

		KeyChain_DeleteAll(KEY_TYPE_VEHICLE, vehicleid, .allowIfOwnerKey = true);
		GetPlayerName(ownerid, VehicleInfo[vehicleid][VehOwnerName], MAX_PLAYER_NAME);
		VehicleInfo[vehicleid][VehOwnerSQLID] = PlayerInfo[ownerid][pID];
		KeyChain_Add(ownerid, KEY_TYPE_VEHICLE, vehicleid, .label = Veh_GetName(vehicleid), .owner = true);
		SaveVehicle(vehicleid);
		SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" Has borrado toda llave existente del vehículo y has hecho a %s dueño del %s (ID %d).", GetPlayerCleanName(ownerid), Veh_GetName(vehicleid), vehicleid);
		SendFMessage(ownerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" El administrador %s te ha hecho dueño del vehículo %i (%s).", GetPlayerCleanName(playerid), vehicleid, Veh_GetName(vehicleid));
		ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avowner", .playerid=playerid, .targetid=ownerid);
	}
	else if(Veh_GetSystemType(vehicleid) != VEH_NONE)
	{
    	if(sscanf(params, "s[24]", ownername))
        	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avowner [Nombre] (máx 24 caracteres)");

        Veh_SetOwnerName(vehicleid, ownername);
		SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" Has puesto al vehículo %i (%s) a nombre de %s.", vehicleid, Veh_GetName(vehicleid), ownername);
		ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avowner", .playerid=playerid, .params=ownername);
	}
	return 1;
}

CMD:avresetplates(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	Veh_SetAllRandomPlates();
	SendClientMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" Se han reseteado las patentes de todos los vehículos.");
	return 1;
}

CMD:avgoto(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new Float:x, Float:y, Float:z, Float:angle, vehicleid;

	if(sscanf(params, "i", vehicleid) && !(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avgoto [idvehiculo]");
	if(!Veh_IsValidId(vehicleid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo inválida.");
	
	GetVehiclePos(vehicleid, x, y, z); 
	GetVehicleZAngle(playerid, angle);
	x += 3.5 * floatsin(angle, degrees);
	y += 3.5 * floatcos(angle, degrees);

	TeleportPlayerTo(playerid, x, y, z, angle, Veh_GetInterior(vehicleid), GetVehicleVirtualWorld(vehicleid));
	SendFMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY" Teletransportado al vehiculo ID: %i.", vehicleid);
	return 1;
}

// Callback para verificar modelo desde BD
forward Veh_OnCheckModelFromDB(vehicleid);
public Veh_OnCheckModelFromDB(vehicleid)
{
	if(!cache_num_rows())
	{
		printf("[ERROR] No se encontró el vehículo slot %i en la base de datos.", vehicleid);
		return 0;
	}

	new db_model, db_sqlid;
	cache_get_value_name_int(0, "VehModel", db_model);
	cache_get_value_name_int(0, "VehSQLID", db_sqlid);

	new current_model = VehicleInfo[vehicleid][VehModel];
	
	if(db_model != current_model)
	{
		printf("[FIX] Vehículo slot %i (VehSQLID=%i): Modelo en BD=%i, Modelo en juego=%i. Corrigiendo...", 
			vehicleid, db_sqlid, db_model, current_model);
		
		// Corregir el modelo
		VehicleInfo[vehicleid][VehModel] = db_model;
		
		// Guardar posición actual
		new Float:x, Float:y, Float:z, Float:angle;
		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, angle);
		//d
		// Recrear vehículo con modelo correcto
		Veh_RecreateWithUpdatedParams(vehicleid);
		SetVehiclePos(vehicleid, x, y, z);
		SetVehicleZAngle(vehicleid, angle);
		
		// Notificar a jugadores cercanos
		new notify_str[144];
		foreach(new p : Player)
		{
			if(IsPlayerInRangeOfPoint(p, 50.0, x, y, z) && GetPlayerVirtualWorld(p) == VehicleInfo[vehicleid][VehVW])
			{
				format(notify_str, sizeof(notify_str), "[INFO] Vehículo ID %i corregido: %s (estaba mostrando %s)", 
					vehicleid, Veh_GetName(vehicleid), Veh_GetModelName(current_model));
				SendClientMessage(p, COLOR_YELLOW, notify_str);
			}
		}
		
		return 1;
	}
	else
	{
		printf("[OK] Vehículo slot %i (VehSQLID=%i): Modelo correcto (%i).", vehicleid, db_sqlid, db_model);
	}
	
	return 1;
}

CMD:avfixmodel(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new vehicleid;
	
	if(sscanf(params, "i", vehicleid))
	{
		if(!(vehicleid = GetPlayerVehicleID(playerid)))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avfixmodel [idvehiculo] o estar dentro del vehículo.");
	}
	
	if(!Veh_IsValidId(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo inválida.");
	
	if(VehicleInfo[vehicleid][VehSQLID] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este vehículo no tiene VehSQLID en la base de datos.");
	
	// Consultar el modelo real desde la BD
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"SELECT `VehSQLID`, `VehModel` FROM `vehicles` WHERE `VehSQLID`=%i LIMIT 1;", 
		VehicleInfo[vehicleid][VehSQLID]);
	mysql_tquery(MYSQL_HANDLE, query, "Veh_OnCheckModelFromDB", "i", vehicleid);
	
	new msg[128];
	format(msg, sizeof(msg), "[INFO] "COLOR_EMB_GREY"Verificando vehículo ID %i (VehSQLID=%i) en la base de datos...", 
		vehicleid, VehicleInfo[vehicleid][VehSQLID]);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/avfixmodel", .playerid=playerid);
	return 1;
}

CMD:avfixallmodels(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new count = 0, fixed = 0;
	
	SendClientMessage(playerid, COLOR_WHITE, "[INFO] "COLOR_EMB_GREY"Iniciando verificación de todos los vehículos...");
	
	for(new vehicleid = 1; vehicleid < MAX_VEH; vehicleid++)
	{
		if(!Veh_IsValidId(vehicleid) || VehicleInfo[vehicleid][VehSQLID] == 0)
			continue;
		
		count++;
		
		// Consultar modelo desde BD de forma síncrona (no ideal pero funcional para comando admin)
		new query[256];
		mysql_format(MYSQL_HANDLE, query, sizeof(query), 
			"SELECT `VehModel` FROM `vehicles` WHERE `VehSQLID`=%i LIMIT 1;", 
			VehicleInfo[vehicleid][VehSQLID]);
		
		new Cache:result = mysql_query(MYSQL_HANDLE, query);
		
		if(cache_num_rows() > 0)
		{
			new db_model;
			cache_get_value_name_int(0, "VehModel", db_model);
			
			if(db_model != VehicleInfo[vehicleid][VehModel])
			{
				// Modelo corrupto encontrado
				new Float:x, Float:y, Float:z, Float:angle;
				GetVehiclePos(vehicleid, x, y, z);
				GetVehicleZAngle(vehicleid, angle);
				
				VehicleInfo[vehicleid][VehModel] = db_model;
				Veh_RecreateWithUpdatedParams(vehicleid);
				SetVehiclePos(vehicleid, x, y, z);
				SetVehicleZAngle(vehicleid, angle);
				
				fixed++;
				printf("[FIX] Vehículo ID %i (VehSQLID=%i) corregido a modelo %i", 
					vehicleid, VehicleInfo[vehicleid][VehSQLID], db_model);
			}
		}
		
		cache_delete(result);
	}
	
	new result_msg[128], log_params[32];
	format(result_msg, sizeof(result_msg), "[INFO] "COLOR_EMB_GREY"Verificación completa: %i vehículos revisados, %i corregidos.", count, fixed);
	SendClientMessage(playerid, COLOR_WHITE, result_msg);
	printf("[AVFIXALLMODELS] %s: %i vehículos revisados, %i corregidos.", GetPlayerCleanName(playerid), count, fixed);
	
	format(log_params, sizeof(log_params), "%i corregidos", fixed);
	ServerLog(LOG_TYPE_ID_VEHICLES, .entry="/avfixallmodels", .playerid=playerid, .params=log_params);
	return 1;
}