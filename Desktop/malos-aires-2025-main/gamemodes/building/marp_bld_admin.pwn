#if defined _marp_bld_admin_included
	#endinput
#endif
#define _marp_bld_admin_included

// Funciones auxiliares para verificar acceso a Property Control
static stock HasBasicPropCtrlAccess(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	return (level == 4 || level == 5 || level == 8 || level == 9 || level == 12 || level == 13 || level == 16 || level == 17 || level == 19 || level == 20 || level == 21);
}

static stock HasAdvPropCtrlAccess(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	return (level == 8 || level == 9 || level == 12 || level == 13 || level == 16 || level == 17 || level == 19 || level == 20 || level == 21);
}

CMD:aedificios(playerid, params[]) {
    return cmd_ae(playerid, params);
}

CMD:ae(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	SendClientMessage(playerid, COLOR_WHITE, "_____________________________________[ ADMINISTRACION DE EDIFICIOS ]_____________________________________");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /aegetid - /aetele - /aeinfo - /aecrear - /aeborrar - /aepickup - /aefaccion - /aeentrada - /aesalida");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /aetextoentrada - /aetextosalida - /aecerrado");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Seteando posiciones deberías estar mirando hacia la puerta para que el ángulo de salida sea el correcto.");
	SendClientMessage(playerid, COLOR_WHITE, "_________________________________________________________________________________________________________");
	return 1;
}

CMD:aecrear(playerid, params[]) 
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new modelid, mapid, bool:locked, factionid, Float:outsideX, Float:outsideY, Float:outsideZ, Float:outsideAngle, outsideWorld, outsideInt, outsideText[BLD_MAX_TEXT_LENGTH] = "\0", insideText[BLD_MAX_TEXT_LENGTH] = "\0";  

	if(sscanf(params, "iiiis[64]S(" ")[64]", mapid, locked, modelid, factionid, outsideText, insideText))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aecrear [mapeo] [cerrado] [modelo pickup] [id faccion] [texto externo] [texto interno - opcional]");
	if(locked != bool:1 && locked != bool:0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El valor 'cerrado' no puede ser diferente a 1 o 0.");
	if(!IsValidServerInterior(mapid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de mapeo invalida.");
	if(Util_HasInvalidSQLCharacter(outsideText) || Util_HasInvalidSQLCharacter(insideText))
		return Util_PrintInvalidSQLCharacter(playerid);
	if(!(0 <= factionid <= Faction_GetMaxAmount())) {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La ID de facción debe ser una id de válida (Entre 0 y %i).", Faction_GetMaxAmount());
		return 1;
	}

	GetPlayerPos(playerid, outsideX, outsideY, outsideZ);
	GetPlayerFacingAngle(playerid,outsideAngle);
	outsideWorld = GetPlayerVirtualWorld(playerid);
	outsideInt = GetPlayerInterior(playerid);

	new buildid = Bld_Create(mapid, factionid, locked, outsideText, insideText, outsideX, outsideY, outsideZ, outsideAngle + 180, outsideWorld, outsideInt, modelid);
	if(!buildid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Imposible  crear el edificios. Se alcanzó el máximo de edificios o ocurrió algún problema.");
	
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Edificio ID: %i creado correctamente.", buildid);
	return 1;
}

CMD:aeborrar(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new buildid;

	if(sscanf(params, "i", buildid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aeborrar [ID edificio]");

	if(!Bld_Delete(buildid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de edificio invalida.");
	
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Edificio ID: %i borrado correctamente.", buildid);
	return 1;
}

CMD:aetele(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new buildid;

	if(sscanf(params, "i", buildid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aetele [ID edificio]");
	if(!Bld_IsValidId(buildid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de edificio inválida.");

	Bld_TpPlayerToOutsideDoorId(playerid, buildid);
	return 1;
}

CMD:aepickup(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new buildid, newpickup;

	if(sscanf(params, "ii", buildid, newpickup))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aepickup [ID edificio] [modelo pickup]");

	if(!Bld_SetPickupModel(buildid, newpickup))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de edificio inválida.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Pickup de edificio ID: %i cambiado correctamente.", buildid);
	return 1;
}

CMD:aeentrada(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new buildid;

	if(sscanf(params, "i", buildid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aeentrada [ID negocio] - Setea la entrada a tu posición. Debes estar mirando hacia la puerta de entrada.");

	new Float:x, Float:y, Float:z, Float:angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	if(Bld_SetOutsidePoint(buildid, x, y, z, angle + 180.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)))
	{
		new string[128];
		Bld_GetOutsidePointInfo(buildid, string, sizeof(string));
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado la entrada del edificio ID %i a: %s", buildid, string);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	}
	return 1;
}

CMD:aesalida(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new buildid;

	if(sscanf(params, "i", buildid))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aesalida [ID negocio] - Setea la salida a tu posición. Debes estar mirando hacia la puerta de salida.");
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"Usa este comando con cuidado, teniendo en cuenta lo que implica si cambias el interior o mundo virtual.");
		return 1;
	}

	new Float:x, Float:y, Float:z, Float:angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	if(Bld_SetInsidePoint(buildid, x, y, z, angle + 180.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)))
	{
		new string[128];
		Bld_GetInsidePointInfo(buildid, string, sizeof(string));
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado la salida del edificio ID %i a: %s", buildid, string);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de edificio inválida.");
	}
	return 1;
}

CMD:aegetid(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	
	new buildid = Bld_IsPlayerOutsideOrInsideAny(playerid);

	if(buildid) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"ID del edificio actual: %i.", buildid);
	} else {
		SendClientMessage(playerid, COLOR_WHITE, "No se ha encontrado ningún edificio en tu posición.");
	}
	return 1;
}

CMD:aetextoentrada(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new buildid, text[BLD_MAX_TEXT_LENGTH];

	if(sscanf(params, "is[64]", buildid, text)) {
		SendFMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY" /aetextoentrada [ID edificio] [texto] (m?x %i char)", BLD_MAX_TEXT_LENGTH);
		return 1;
	}
		
	if(Util_HasInvalidSQLCharacter(text))
		return Util_PrintInvalidSQLCharacter(playerid);

	if(!Bld_SetOutsideText(buildid, text))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de edificio inválida.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado el texto exterior del edificio ID %i a: %s", buildid, text);
	return 1;
}

CMD:aetextosalida(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new buildid, text[BLD_MAX_TEXT_LENGTH];

	if(sscanf(params, "is[64]", buildid, text)) {
		SendFMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY" /aetextosalida [ID edificio] [texto] (m?x %i char)", BLD_MAX_TEXT_LENGTH);
		return 1;
	}
		
	if(Util_HasInvalidSQLCharacter(text))
		return Util_PrintInvalidSQLCharacter(playerid);

	if(!Bld_SetInsideText(buildid, text))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de edificio inválida.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado el texto interior del edificio ID %i a: %s", buildid, text);
	return 1;
}

CMD:aecerrado(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new buildid, locked;

	if(sscanf(params, "ii", buildid, locked))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aecerrado [ID edificio] [1 = SI, 0 = NO]");
	if(!Bld_SetLocked(buildid, bool:locked))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de edificio o par?metro inválido.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has %s"COLOR_EMB_GREY" el edificio ID %i.", (!locked) ? ("{33FF33}abierto") : ("{FF3333}cerrado"), buildid);
	return 1;
}

CMD:aeinfo(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	
	new buildid;

	if(sscanf(params, "i", buildid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aeinfo [ID edificio]");

	if(!Bld_PrintInfoForPlayer(playerid, buildid)) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de edificio inválida.");
	}
	return 1;
}

CMD:aefaccion(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	
	new buildid, factionid;

	if(sscanf(params, "ii", buildid, factionid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aeinfo [ID edificio] [ID faccion]");
	if(!(0 <= factionid <= Faction_GetMaxAmount())) {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La ID de facción debe ser una id de válida (Entre 0 y %i).", Faction_GetMaxAmount());
		return 1;
	}
	if(!Bld_SetFaction(buildid, factionid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de edificio inválida.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado al edificio ID %i la facción: %i.", buildid, factionid);
	return 1;
}
