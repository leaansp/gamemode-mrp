#if defined _marp_houses_admin_inc
	#endinput
#endif
#define _marp_houses_admin_inc

// Función auxiliar para verificar acceso básico a Property Control
static stock HasBasicPropCtrlAccess(playerid)
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

CMD:acasa(playerid, params[]) {
    return cmd_ac(playerid, params);
}

CMD:ac(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	SendClientMessage(playerid, COLOR_WHITE, "_______________________________________[ ADMINISTRACION DE CASAS ]_______________________________________");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /actele - /acinfo - /acalquilar - /acnoalquilar");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /accrear /acborrar /acentrada /acsalida /acinterior /acprecio /acvender");
	SendClientMessage(playerid, COLOR_INFO,  "[INFO] "COLOR_EMB_GREY" Seteando posiciones deberás estar mirando hacia la puerta para que el ángulo de salida sea el correcto.");
	SendClientMessage(playerid, COLOR_WHITE, "_________________________________________________________________________________________________________");
	return 1;
}

CMD:acinterior(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid, interiorID;

	if(sscanf(params, "ii", houseid, interiorID))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acinterior [ID casa] [Interior ID]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");

	GetServerInteriorInfo(interiorID, House[houseid][InsideX], House[houseid][InsideY], House[houseid][InsideZ], House[houseid][InsideAngle], House[houseid][InsideInterior]);
	SaveHouse(houseid);

	ServerLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/acinterior", .playerid=playerid, .params=params);
	return 1;
}

CMD:acprecio(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid, price;

	if(sscanf(params, "ii", houseid, price))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acprecio [ID casa] [Precio]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");
	if(price < 1 || price > 10000000)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Elige un precio entre $1 y $10.000.000.");

	House[houseid][HousePrice] = price;
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El precio de la casa ID %i ha sido ajustado a $%i.", houseid, price);

	//=========================VACIADO DE CONTENEDOR============================

	if(HouseHasContainer(houseid))
	{
		Container_Empty(House[houseid][ContainerID]);
		Container_SetTotalSpace(House[houseid][ContainerID], GetHouseLockerSpace(houseid));
	}

	SaveHouse(houseid);
	ServerLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/acprecio", .playerid=playerid, .params=params);
	return 1;
}

CMD:acvender(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acvender [ID casa]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");

	KeyChain_DeleteAll(KEY_TYPE_HOUSE, houseid, .allowIfOwnerKey = true);

	House[houseid][Owned] = 0;
	House[houseid][OwnerSQLID] = 0;
	strcopy(House[houseid][OwnerName], "Ninguno", MAX_PLAYER_NAME);
	House[houseid][Locked] = 1;
	House[houseid][Radio] = 0;
	House[houseid][IncomePrice] = 0;
	House[houseid][IncomePriceAdd] = 0;
	House[houseid][IncomeAccept] = 0;
	House[houseid][Income] = 0;
	House[houseid][TenantSQLID] = 0;
	strcopy(House[houseid][Tenant], "Ninguno", MAX_PLAYER_NAME);

	//=========================VACIADO DE CONTENEDOR============================

	if(HouseHasContainer(houseid)) {
		Container_Empty(House[houseid][ContainerID]);
	}

	//==========================================================================

	SaveHouse(houseid);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La casa ID %i ha sido vendida.", houseid);

	ServerLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/acvender", .playerid=playerid);
	return 1;
}

CMD:accrear(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new price, Float:angle,	interiorID;

	if(sscanf(params, "ii", price, interiorID))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/accrear [Precio de la casa] [Interior ID]");
	if(price < 1 || price > 10000000)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Elige un precio de $1 a $10.000.000.");

	for(new i = 1; i < MAX_HOUSES; i++)
	{
		if(House[i][Created] == 0)
		{
			House[i][Created] = 1;
			GetPlayerFacingAngle(playerid, angle);
			GetPlayerPos(playerid, House[i][OutsideX], House[i][OutsideY], House[i][OutsideZ]);
			House[i][OutsideAngle] = angle + 180;
			House[i][OutsideInterior] = GetPlayerInterior(playerid);
			House[i][OutsideWorld] = GetPlayerVirtualWorld(playerid);
			GetServerInteriorInfo(interiorID, House[i][InsideX], House[i][InsideY], House[i][InsideZ], House[i][InsideAngle], House[i][InsideInterior]);
			House[i][InsideWorld] = HOUSE_VW_OFFSET + i;
			House[i][HousePrice] = price;
			House[i][Locked] = 1;
			strcopy(House[i][OwnerName], "Ninguno", MAX_PLAYER_NAME);
			CreateHouse(i);
			SaveHouse(i);
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has creado la casa ID %i.", i);

			ServerLog(LOG_TYPE_ID_HOUSES, .id=i, .entry="/accrear", .playerid=playerid, .params=params);
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La casa no pudo ser creada porque se ha alcanzado el mï¿½ximo de casas en el servidor.");
	return 1;
}

CMD:acborrar(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acborrar [ID casa]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");

	DeleteHouse(houseid);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La casa ID %i ha sido borrada.", houseid);
	ServerLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/acborrar", .playerid=playerid);
	return 1;
}

CMD:acentrada(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acentrada [ID casa]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");

	GetPlayerFacingAngle(playerid, House[houseid][OutsideAngle]);
	House[houseid][OutsideAngle] += 180.0;
	GetPlayerPos(playerid, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ]);
	House[houseid][OutsideInterior] = GetPlayerInterior(playerid);
	House[houseid][OutsideWorld] = GetPlayerVirtualWorld(playerid);
	SaveHouse(houseid);

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La entrada de la casa ID %i ha sido cambiada a tu posiciï¿½n, interior y mundo virtual.", houseid);
	return 1;
}

CMD:acsalida(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acsalida [ID casa]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");

	GetPlayerFacingAngle(playerid, House[houseid][InsideAngle]);
	House[houseid][InsideAngle] += 180.0;
	GetPlayerPos(playerid, House[houseid][InsideX], House[houseid][InsideY], House[houseid][InsideZ]);
	House[houseid][InsideInterior] = GetPlayerInterior(playerid);
	SaveHouse(houseid);

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La salida de la casa ID %i ha sido cambiada a tu posiciï¿½n y a tu interior.", houseid);
	return 1;
}

CMD:acinfo(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acinfo [ID casa]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");

	SendFMessage(playerid, COLOR_WHITE, "=======================[ CASA ID %i ]=======================", houseid);
	SendFMessage(playerid, COLOR_WHITE, "- Tiene dueï¿½o: %i", House[houseid][Owned]);
	SendFMessage(playerid, COLOR_WHITE, "- Dueï¿½o SQLID: %i", House[houseid][OwnerSQLID]);
	SendFMessage(playerid, COLOR_WHITE, "- Dueï¿½o: %s", House[houseid][OwnerName]);
	SendFMessage(playerid, COLOR_WHITE, "- Costo de compra: $%i", House[houseid][HousePrice]);
	SendFMessage(playerid, COLOR_WHITE, "- Cerrada: %i", House[houseid][Locked]);
	SendFMessage(playerid, COLOR_WHITE, "- Inquilino: %s (SQLID %i)", House[houseid][Tenant], House[houseid][TenantSQLID]);
	SendFMessage(playerid, COLOR_WHITE, "- Casa alquilada: %i", House[houseid][Income]);
	SendFMessage(playerid, COLOR_WHITE, "- Casa en alquiler: %i", House[houseid][IncomeAccept]);
	SendFMessage(playerid, COLOR_WHITE, "- Costo de alquiler: $%i", House[houseid][IncomePrice]);
	SendFMessage(playerid, COLOR_WHITE, "- Ganancias: $%i", House[houseid][IncomePriceAdd]);
	return 1;
}

CMD:actele(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/actele [ID casa]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");

	House_TpPlayerToOutDoorId(playerid, houseid);
	return 1;
}

CMD:acalquilar(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acalquilar [ID casa]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");
	if(House_IsRented(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La casa tiene un inquilino.");
	
	House[houseid][IncomePrice] = House[houseid][HousePrice] / 100;
	House[houseid][IncomeAccept] = 1;
	House[houseid][Income] = 0;
	House[houseid][TenantSQLID] = 0;
	strcopy(House[houseid][Tenant], "Ninguno", MAX_PLAYER_NAME);
	SaveHouse(houseid);

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El precio de alquiler de la casa ID %i ha sido ajustado a $%i.", houseid, House[houseid][IncomePrice]);
	return 1;
}

CMD:acnoalquilar(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acnoalquilar [ID casa]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa invï¿½lida.");

	KeyChain_DeleteAll(KEY_TYPE_HOUSE, houseid, .allowIfOwnerKey = true);

	House[houseid][IncomePrice] = 0;
	House[houseid][IncomeAccept] = 0;
	House[houseid][IncomePriceAdd] = 0;
	House[houseid][Income] = 0;
	House[houseid][TenantSQLID] = 0;
	strcopy(House[houseid][Tenant], "Ninguno", MAX_PLAYER_NAME);
	SaveHouse(houseid);

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La casa %i ya no estï¿½ disponible para ser rentada.", houseid);
	return 1;
}
