#if defined _marp_garages_admin_inc
	#endinput
#endif
#define _marp_garages_admin_inc

// Función auxiliar para verificar acceso básico a Property Control
static stock HasBasicPropertyControlAccess(playerid)
{
	new level = AccountInfo[playerid][accAdminLevel];
	return (level == 4 || level == 5 || level == 8 || level == 9 || level == 12 || level == 13 || level == 16 || level == 17 || level == 19 || level == 20 || level == 21);
}

// Función auxiliar para verificar acceso avanzado a Property Control
static stock HasAdvPropCtrlAccess(playerid)
{
	new level = AccountInfo[playerid][accAdminLevel];
	return (level == 8 || level == 9 || level == 12 || level == 13 || level == 16 || level == 17 || level == 19 || level == 20 || level == 21);
}

// Función auxiliar para verificar acceso máximo a Property Control
static stock HasMaxPropertyControlAccess(playerid)
{
	new level = AccountInfo[playerid][accAdminLevel];
	return (level == 16 || level == 17 || level == 19 || level == 20 || level == 21);
}

CMD:agaraje(playerid, params[]) {
    return cmd_ag(playerid, params);
}

CMD:ag(playerid, params[]) 
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    SendClientMessage(playerid, COLOR_WHITE, "_____________________________________[ ADMINISTRACION DE GARAJES ]_____________________________________");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /aggetid - /agcrear - /agborrar - /agareaexterior - /agareainterior - /agpuntoexterior - /agpuntointerior");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /agtipo - /agextraid - /aginfo - /agcerrado - /agtele");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Seteando posiciones deberás estar mirando hacia la puerta para que el ángulo de salida sea el correcto.");
	SendClientMessage(playerid, COLOR_WHITE, "________________________________________________________________________________________________________");
    return 1;
}

CMD:aggetid(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid = Garage_IsInAnyArea(playerid);

    if(garageid) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"ID del garaje actual: %i.", garageid);
	} else {
		SendClientMessage(playerid, COLOR_WHITE, "No se ha encontrado ningún edificio en tu posición.");
	}
    return 1;
}

CMD:agcrear(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso máximo a Property Control
	if(!HasMaxPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new mapid, type, extraid, locked, Float:outsideX, Float:outsideY, Float:outsideZ, Float:outsideAng, outsideVW, outsideInt;
    if(sscanf(params, "iiii", mapid, type, extraid, locked))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agcrear [mapeo] [tipo] [id extra] [cerrado]");
    if(locked != 0 && locked != 1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El valor 'cerrado' no puede ser diferente a 1 o 0.");
    if(!Garage_IsValidType(type)) {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El valor 'tipo' invalido.");
        return 1;
    }
    
    GetPlayerPos(playerid, outsideX, outsideY, outsideZ);
	GetPlayerFacingAngle(playerid, outsideAng);
	outsideVW = GetPlayerVirtualWorld(playerid);
	outsideInt = GetPlayerInterior(playerid);

    new garageid = Garage_Create(type, extraid, outsideX, outsideY, outsideZ, outsideAng + 180, outsideVW, outsideInt, mapid, locked);
    if(!garageid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Imposible  crear el garaje. Se alcanzó el máximo de garajes o ocurrió algún problema.");
	
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Garaje ID: %i creado correctamente.", garageid);
    return 1;
}

CMD:agborrar(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso máximo a Property Control
	if(!HasMaxPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new garageid;

	if(sscanf(params, "i", garageid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agborrar [ID garaje]");
	if(!Garage_Delete(garageid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de garaje invalida.");
	
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Edificio ID: %i garaje correctamente.", garageid);
	return 1;
}

CMD:agareaexterior(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso máximo a Property Control
	if(!HasMaxPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid;
    if(sscanf(params, "i", garageid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agareaexterior [ID garaje]");
    if(!Garage_IsValidId(garageid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de garaje invalida.");

    new Float:areaX, Float:areaY, Float:areaZ;
    GetPlayerPos(playerid, areaX, areaY, areaZ);
    Garage_SetOutsideArea(garageid, areaX, areaY, areaZ);

    new str[128];
    Garage_GetOutsideAreaInfo(garageid, str, sizeof(str));
    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Area de entrada de garage Id: %i seteada en: %s", garageid, str);
    return 1;
}

CMD:agareainterior(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso máximo a Property Control
	if(!HasMaxPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid;
    if(sscanf(params, "i", garageid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agareainterior [ID garaje]");
    if(!Garage_IsValidId(garageid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de garaje invalida.");

    new Float:areaX, Float:areaY, Float:areaZ;
    GetPlayerPos(playerid, areaX, areaY, areaZ);
    Garage_SetInsideArea(garageid, areaX, areaY, areaZ);

    new str[128];
    Garage_GetInsideAreaInfo(garageid, str, sizeof(str));
    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Area de salida de garage Id: %i seteada en: %s", garageid, str);
    return 1;
}

CMD:agpuntoexterior(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso máximo a Property Control
	if(!HasMaxPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid;
    if(sscanf(params, "i", garageid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agpuntoexterior [ID garaje]");
    if(!Garage_IsValidId(garageid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de garaje invalida.");

    new Float:x, Float:y, Float:z, Float:angle, int, world;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
	world = GetPlayerVirtualWorld(playerid);
	int = GetPlayerInterior(playerid);

    Garage_SetOutsidePoint(garageid, x, y, z, angle + 180, world, int);
    Garage_SetOutsideArea(garageid, x, y, z);

    new str[128];
    Garage_GetOutsideAreaInfo(garageid, str, sizeof(str));
    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Area de entrada y punto de salida de garage Id: %i seteado en: %s", garageid, str);
    return 1;
}

CMD:agpuntointerior(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso máximo a Property Control
	if(!HasMaxPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid;
    if(sscanf(params, "i", garageid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agpuntointerior [ID garaje]");
    if(!Garage_IsValidId(garageid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de garaje invalida.");

    new Float:x, Float:y, Float:z, Float:angle, int, world;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
	world = GetPlayerVirtualWorld(playerid);
	int = GetPlayerInterior(playerid);

    Garage_SetInsidePoint(garageid, x, y, z, angle + 180, world, int);
    Garage_SetInsideArea(garageid, x, y, z);

    new str[128];
    Garage_GetOutsideAreaInfo(garageid, str, sizeof(str));
    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Area de salida y punto de entrada de garage Id: %i seteado en: %s", garageid, str);
    return 1;
}

CMD:agtipo(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso máximo a Property Control
	if(!HasMaxPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid, type;
    if(sscanf(params, "ii", garageid, type))
    {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agtipo [ID garaje] [tipo]");
        return Garage_PrintTypesFor(playerid);
    }

    if(!Garage_SetType(garageid, type))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de garaje inválida.");

    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Configurado tipo: %s al garaje ID: %i", Garage_GetTypeName(type), garageid);
    return 1;
}

CMD:agextraid(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso máximo a Property Control
	if(!HasMaxPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid, extraid;
    if(sscanf(params, "ii", garageid, extraid))
    {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agextraid [ID garaje] [extraid]");
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El parámetro 'extraid' debe ser una id en 'tipo'. Para garaje libre, colocar 'tipo = faccion y extraid = 0'");
    }

    switch(GarageInfo[garageid][gType])
    {
        case GARAGE_TYPE_HOUSE: {if(!House_IsValidId(extraid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de casa inválida.");}
        case GARAGE_TYPE_BUSINESS: {if(!Biz_IsValidId(extraid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de negocio inválida.");}
        case GARAGE_TYPE_FACTION: {if(!(0 <= extraid <= Faction_GetMaxAmount())) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de facción inválida.");}
        default: return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tipo de garaje inválido. Reportar a un scripter.");
    }

    if(!Garage_SetExtraId(garageid, extraid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de garaje inválida.");

    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Configurado extraid: %i al garaje ID: %i", extraid, garageid);
    return 1;
}

CMD:aginfo(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid;
    if(sscanf(params, "i", garageid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aginfo [ID garaje]");
    if(!Garage_PrintInfoForPlayer(playerid, garageid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de garaje inválida.");

    return 1;
}

CMD:agcerrado(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid, locked;
    if(sscanf(params, "ii", garageid, locked))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agcerrado [ID garaje] [cerrado]");
    if(locked != 0 && locked != 1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El valor 'cerrado' no puede ser diferente a 1 o 0.");
    if(!Garage_SetLocked(garageid, locked))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de garaje inválida.");

    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has %s"COLOR_EMB_GREY" el garaje ID %i.", (!locked) ? ("{33FF33}abierto") : ("{FF3333}cerrado"), garageid);
    return 1;
}

CMD:agtele(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropertyControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
    new garageid;
    if(sscanf(params, "i", garageid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agtele [ID garaje]");
    if(!Garage_IsValidId(garageid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de garaje inválida.");

    Garage_TpPlayerToOutsideId(playerid, garageid);    
    return 1;
}