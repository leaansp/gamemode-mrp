#if defined _marp_biz_admin_included
	#endinput
#endif
#define _marp_biz_admin_included

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

CMD:an(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "_____________________________________[ ADMINISTRACION DE NEGOCIOS ]______________________________________");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /angetid - /antele - /aninfo - /annombre - /anhabilitado - /ancaja - /anvender - /anprecioentrada");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /ancrear - /anborrar - /anprecio - /antipo - /anmapeo - /anentrada - /ansalida - /anpuntocompra");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /anstock - /anitem - /anrandomstock - /anpuntoentrega");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Seteando posiciones deberás estar mirando hacia la puerta para que el ángulo de salida sea el correcto.");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "_________________________________________________________________________________________________________");
	return 1;
}

CMD:ancrear(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new name[BIZ_MAX_NAME_LENGTH], price, type, mapid;

	if(sscanf(params, "iiis["#BIZ_MAX_NAME_LENGTH"]", price, type, mapid, name))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/ancrear [precio] [tipo] [ID mapeo] [nombre] (hasta "#BIZ_MAX_NAME_LENGTH" caracteres).");
	if(Util_HasInvalidSQLCharacter(name))
		return Util_PrintInvalidSQLCharacter(playerid);

	new Float:x, Float:y, Float:z, Float:angle, bizid;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	if((bizid = Biz_Create(name, price, type, x, y, z, angle + 180.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), mapid))) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Negocio ID %i creado correctamente.", bizid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Límite de negocios alcanzado o algún parámetro es incorrecto.");
	}

	return 1;
}

CMD:anborrar(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid;

	if(sscanf(params, "i", bizid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anborrar [ID negocio]");

	if(Biz_Delete(bizid)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Negocio ID %i borrado correctamente.", bizid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	}
	return 1;
}

CMD:anentrada(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid;

	if(sscanf(params, "i", bizid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anentrada [ID negocio] - Setea la entrada a tu posición. Debes estar mirando hacia la puerta de entrada.");

	new Float:x, Float:y, Float:z, Float:angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	if(Biz_SetOutsidePoint(bizid, x, y, z, angle + 180.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)))
	{
		new string[128];
		Biz_GetOutsidePointInfo(bizid, string, sizeof(string));
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado la entrada del negocio ID %i a: %s", bizid, string);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	}
	return 1;
}

CMD:ansalida(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid;

	if(sscanf(params, "i", bizid))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/ansalida [ID negocio] - Setea la salida a tu posición. Debes estar mirando hacia la puerta de salida.");
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"Usa este comando con cuidado, teniendo en cuenta lo que implica si cambias el interior o mundo virtual.");
		return 1;
	}

	new Float:x, Float:y, Float:z, Float:angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	if(Biz_SetInsidePoint(bizid, x, y, z, angle + 180.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)))
	{
		new string[128];
		Biz_GetInsidePointInfo(bizid, string, sizeof(string));
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado la salida del negocio ID %i a: %s", bizid, string);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Recuerda re-configurar las demás entidades del interior del negocio, como el punto de compra, etc.");
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	}
	return 1;
}

CMD:anpuntocompra(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid;

	if(sscanf(params, "i", bizid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anpuntocompra [ID negocio]");
	if(!Biz_IsValidId(bizid) || Biz_GetPlayerLastId(playerid) != bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida o no fue el último negocio visitado.");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if(Biz_SetBuyingPoint(bizid, x, y, z))
	{
		new string[128];
		Biz_GetBuyingPointInfo(bizid, string, sizeof(string));
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Punto de compra del negocio ID %i seteado: %s.", bizid, string);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	}
	return 1;
}

CMD:anmapeo(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid, mapid;

	if(sscanf(params, "ii", bizid, mapid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anmapeo [ID negocio] [ID mapeo]");

	if(Biz_SetInsideMap(bizid, mapid))
	{
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El mapeo del negocio ID %i ha sido correctamente configurado al ID %i.", bizid, mapid);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Recuerda reconfigurar las demás entidades del interior del negocio, como el punto de compra, etc.");
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio o mapeo inválida.");
	}
	return 1;
}

CMD:ancaja(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid, money;

	if(sscanf(params, "ii", bizid, money))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/ancaja [ID negocio] [dinero]");

	if(Biz_SetTill(bizid, money)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Dinero en caja del negocio ID %i configurado correctamente. Caja actual: $%i.", bizid, Biz_GetTill(bizid));
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	}
	return 1;
}

CMD:annombre(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid, name[BIZ_MAX_NAME_LENGTH];

	if(sscanf(params, "is["#BIZ_MAX_NAME_LENGTH"]", bizid, name))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/annombre [ID negocio] [nombre] (hasta "#BIZ_MAX_NAME_LENGTH" caracteres).");
	if(Util_HasInvalidSQLCharacter(name))
		return Util_PrintInvalidSQLCharacter(playerid);

	if(Biz_SetName(bizid, name)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Nombre del negocio ID %i seteado con éxito a '%s'.", bizid, name);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	}
	return 1;
}

CMD:anprecio(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid, price;

	if(sscanf(params, "ii", bizid, price))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anprecio [ID negocio] [precio]");

	if(Biz_SetPrice(bizid, price)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado correctamente el precio del negocio ID %i en $%i.", bizid, price);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio o precio inválido.");
	}
	return 1;
}

CMD:anprecioentrada(playerid,params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid, price;

	if(sscanf(params, "ii", bizid, price))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anprecioentrada [ID negocio] [precio]");

	if(Biz_SetEntranceFee(bizid, price)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El precio de entrada del negocio ID %i ahora es de $%i.", bizid, price);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio o precio inválido.");
	}
	return 1;
}

CMD:anpuntoentrega(playerid, params[]) {
	new bizid;

	if(sscanf(params, "i", bizid))
		return SendClientMessage(playerid, COLOR_GREY, "USO: /anpuntoentrega [ID negocio]");

	if(Biz_SetDeliveryCP(playerid, bizid)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Punto de entrega del negocio ID %i configurado correctamente.", bizid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	}
	return true;
}

CMD:antipo(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid, type;

	if(sscanf(params, "ii", bizid, type))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/antipo [ID negocio] [tipo]");
		Biz_PrintTypesForPlayer(playerid);
		return 1;
	}

	if(Biz_SetType(bizid, type)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado correctamente el tipo del negocio ID %i en %i (%s).", bizid, type, Biz_GetTypeName(Business[bizid][bType]));
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio o tipo inválido.");
	}
	return 1;
}

CMD:angetid(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid = Biz_IsPlayerOutsideOrInsideAny(playerid);

	if(bizid) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"ID del negocio actual: %i.", bizid);
	} else {
		SendClientMessage(playerid, COLOR_WHITE, "No se ha encontrado ningún negocio en tu posición.");
	}
	return 1;
}

CMD:aninfo(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid;

	if(sscanf(params, "i", bizid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aninfo [ID negocio]");

	if(!Biz_PrintInfoForPlayer(playerid, bizid)) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	}
	return 1;
}

CMD:anvender(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	if(!HasAdvPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid;

	if(sscanf(params, "i", bizid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anvender [ID negocio]");

	if(Biz_Sell(bizid))
	{
		Biz_SetRandomItemsStock(bizid, 100000);

		new string[128];
		format(string, sizeof(string), "[ADMIN INFO] %s (ID %i - SQLID %i): venta forzada de negocio ID %i.", GetPlayerCleanName(playerid), playerid, PlayerInfo[playerid][pID], bizid);
		AdministratorMessage(COLOR_ADMINCMD, string, 2);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida o no tenía dueño.");
	}
	return 1;
}

CMD:antele(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid;

	if(sscanf(params, "i", bizid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/antele [ID negocio]");
	if(!Biz_IsValidId(bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");

	Biz_TpPlayerToOutsideDoorId(playerid, bizid);
	return 1;
}

CMD:anhabilitado(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Property Control
	if(!HasBasicPropCtrlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid, status;

	if(sscanf(params, "ii", bizid, status))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anhabilitado [ID negocio] [1 = SI, 0 = NO]");

	if(Biz_SetEnterable(bizid, status)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Negocio ID %i %s"COLOR_EMB_GREY" correctamente.", bizid, (Biz_IsEnterable(bizid)) ? ("{33FF33}habilitado") : ("{FF3333}deshabilitado"));
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio o parámetro inválido.");
	}
	return 1;
}
