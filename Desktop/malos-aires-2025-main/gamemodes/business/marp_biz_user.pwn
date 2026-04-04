#if defined _marp_biz_user_included
	#endinput
#endif
#define _marp_biz_user_included

new BizLastAnnounce[MAX_BUSINESS];  // GetTickCount of last opening announcement
new BizPromo[MAX_BUSINESS];         // Discount % (0 = no promo)
new BizPromoExpiry[MAX_BUSINESS];   // GetTickCount when promo expires
new BizPromoLastUsed[MAX_BUSINESS]; // GetTickCount of last promo activation

CMD:negocionombre(playerid, params[])
{
	new bizid = Biz_IsPlayerOutsideOrInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en un negocio.");
	if(!Biz_IsPlayerOwner(playerid, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueño de este negocio.");

	new name[128];

	if(sscanf(params, "s[128]", name))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negocionombre [nombre] (hasta "#BIZ_MAX_NAME_LENGTH" caracteres).");
	if(Util_HasInvalidSQLCharacter(name))
		return Util_PrintInvalidSQLCharacter(playerid);

	if(Biz_SetName(bizid, name)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Nombre del negocio configurado con éxito a '%s'.", name);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida, reportar a la administración.");
	}
	return 1;
}

CMD:negociocaja(playerid, params[])
{
	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	new amount, subcmd[24];

	if(sscanf(params, "s[24]i", subcmd, amount))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negociocaja [retirar / depositar] [dinero]");
	if(!(1 <= amount <= 1000000))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad de dinero debe estar comprendida entre $1 y $1.000.000.");

	if(!strcmp(subcmd, "retirar", true))
	{
		if(amount > Biz_GetTill(bizid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes esa cantidad de dinero en la caja!");

		GivePlayerCash(playerid, amount);
		Biz_AddTill(bizid, -amount);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has retirado $%i de la caja registradora. Dinero restante: $%i.", amount, Biz_GetTill(bizid));
		PlayerActionMessage(playerid, 15.0, "abre la caja registradora y retira algo de dinero.");

		ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="RETIRA NEGOCIO", .playerid=playerid, .params=<"$%d", amount>);
	}
	else if(!strcmp(subcmd, "depositar", true))
	{
		if(GetPlayerCash(playerid) < amount)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes esa cantidad de dinero!");
		if(Biz_GetTill(bizid) + amount > 1000000)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡La cantidad ingresada no cabe en la caja! (el máximoposible en caja es de $1.000.000).");

		GivePlayerCash(playerid, -amount);
		Biz_AddTill(bizid, amount);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has depositado $%i en la caja registradora. Nuevo total: $%i.", amount, Biz_GetTill(bizid));
		PlayerActionMessage(playerid, 15.0, "abre la caja registradora y guarda algo de dinero.");

		ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="DEPOSITO NEGOCIO", .playerid=playerid, .params=<"$%d", amount>);
	}
	else {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negociocaja [retirar / depositar] [dinero]");
	}
	return 1;
}

CMD:negocioradio(playerid,params[])
{
	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid) && !AdminDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	new radio;

	if(!sscanf(params, "i", radio))
	{
		if(!Radio_IsValidId(radio))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar una radio válida, utiliza '/radios' para ver las radios disponibles.");

		Biz_SetRadio(bizid, radio);
		Radio_Set(playerid, radio, RADIO_TYPE_BIZ);
	}
	else
	{
		if(!Business[bizid][bRadio])
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negocioradio [id]. Para apagarla utiliza nuevamente '/negocioradio'.");

		Biz_SetRadio(bizid, 0);
		Radio_StopIfOnType(playerid, RADIO_TYPE_BIZ);
	}
	return 1;
}

CMD:negociollave(playerid, params[])
{
	new bizid = Biz_IsPlayerAtAnyDoorAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid) && !AdminDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	Biz_ToggleLock(bizid);
	PlayerActionMessage(playerid, 15.0, "toma unas llaves de su bolsillo y las introduce en la cerradura de la puerta del negocio.");
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El negocio ahora se encuentra %s"COLOR_EMB_GREY".", (Biz_IsLocked(bizid)) ? ("{FF3333}cerrado") : ("{33FF33}abierto"));

	if(!Biz_IsLocked(bizid)) // just opened
	{
		new tick = GetTickCount();
		if(BizLastAnnounce[bizid] == 0 || (tick - BizLastAnnounce[bizid]) > 5 * 60 * 1000)
		{
			BizLastAnnounce[bizid] = tick;
			new annStr[256];
			format(annStr, sizeof(annStr), "{FFAA00}[ANUNCIO]{FFFFFF} %s ha abierto sus puertas. Para mas informacion, usa /prop %i.", Business[bizid][bName], bizid);
			SendClientMessageToAll(-1, annStr);
		}
	}
	return 1;
}

CMD:negociocomprar(playerid, params[])
{
	new bizid = Biz_IsPlayerAtOutsideDoorAny(playerid);

	if(!bizid)
		return 1;
	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar a pie.");
	if(Business[bizid][bOwnerSQLID] != -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este negocio no está a la venta.");
	if(!Biz_IsValidPrice(bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El negocio se encuentra deshabilitado.");
	if(GetPlayerCash(playerid) < Biz_GetPrice(bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes el dinero suficiente!");

	if(!Biz_SetOwner(bizid, playerid, .save = false))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida o no tienes más espacio en tu llavero.");
	
	Biz_ResetItemsStock(bizid);
	Biz_SetTill(bizid, 0, .save = false);
	SaveBusiness(bizid);

	GivePlayerCash(playerid, -Biz_GetPrice(bizid));
	StartPlayerScene(playerid, 1, bizid);

	new string[128];
	format(string, sizeof(string), "[ADMIN INFO] %s (ID %i - SQLID %i): compra de negocio ID %i.", GetPlayerCleanName(playerid), playerid, PlayerInfo[playerid][pID], bizid);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="COMPRA NEGOCIO", .playerid=playerid, .params=<"$%i (ID %i)", Biz_GetPrice(bizid), bizid>);
	return 1;
}

CMD:negociovender(playerid,params[])
{
	new bizid = Biz_IsPlayerAtOutsideDoorAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de un negocio.");
	if(!Biz_IsPlayerOwner(playerid, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueño de este negocio.");

	if(!Biz_Sell(bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida o no tenía dueño.");

	Biz_SetRandomItemsStock(bizid, 100000);

	GivePlayerCash(playerid, floatround(Biz_GetPrice(bizid) * 0.7));
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	PlayerActionMessage(playerid, 15.0, "rompe el contrato, y le da las llaves del negocio al agente inmobiliario.");
	SendFMessage(playerid, COLOR_LIGHTBLUE, "¡Has vendido tu negocio por $%i!", floatround(Biz_GetPrice(bizid) * 0.7));

	new string[128];
	format(string, sizeof(string), "[ADMIN INFO] %s (ID %i - SQLID %i): venta común de negocio ID %i.", GetPlayerCleanName(playerid), playerid, PlayerInfo[playerid][pID], bizid);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="VENTA NEGOCIO", .playerid=playerid, .params=<"$%i (ID %i)", floatround(Biz_GetPrice(bizid) * 0.7), bizid>);
	return 1;
}
//==============================================================================
// NUEVOS COMANDOS
//==============================================================================

CMD:prop(playerid, params[])
{
	new bizid;

	if(sscanf(params, "i", bizid))
	{
		// Find nearest business
		new Float:minDist = 999999.0;
		for(new i = 1; i < MAX_BUSINESS; i++)
		{
			if(!Biz_IsValidId(i)) continue;
			new Float:d = GetPlayerDistanceFromPoint(playerid, Business[i][bOutsideX], Business[i][bOutsideY], Business[i][bOutsideZ]);
			if(d < minDist) { minDist = d; bizid = i; }
		}
		if(!bizid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay negocios cargados.");
	}

	if(!Biz_IsValidId(bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio invalido.");

	// Build info string
	new info[512], ratingStr[40], promoStr[48];

	new bool:hasPromo = (BizPromo[bizid] > 0 && GetTickCount() < BizPromoExpiry[bizid]);
	if(hasPromo)
		format(promoStr, sizeof(promoStr), "\n{FF6600}PROMO ACTIVA: -%i porciento descuento!{FFFFFF}", BizPromo[bizid]);

	BizReview_GetStars(bizid, ratingStr, sizeof(ratingStr));

	new desc[160];
	if(strlen(Business[bizid][bDescription]) > 0)
		format(desc, sizeof(desc), "\nDescripción: %s", Business[bizid][bDescription]);

	format(info, sizeof(info), "Tipo: %s%s\nReseñas: %s%s",
		Biz_GetTypeName(Business[bizid][bType]),
		desc,
		ratingStr,
		(hasPromo) ? (promoStr) : (""));

	SetPlayerCheckpoint(playerid, Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ], 3.0);
	SetPVarInt(playerid, "PropCheckBizId", bizid);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El negocio se ha marcado en el mapa.");

	Dialog_Open(playerid, "DLG_PropInfo", DIALOG_STYLE_MSGBOX, Business[bizid][bName], info, "Cerrar", "");
	return 1;
}

Dialog:DLG_PropInfo(playerid, response, listitem, inputtext[]) {
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarInt(playerid, "PropCheckBizId") > 0) {
		SetPVarInt(playerid, "PropCheckBizId", 0);
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}

CMD:emisora(playerid, params[]) return cmd_negocioradio(playerid, params);

CMD:negociodescripcion(playerid, params[])
{
	new bizid = Biz_IsPlayerOutsideOrInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en un negocio.");
	if(!Biz_IsPlayerOwner(playerid, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueno de este negocio.");

	new desc[128];
	if(sscanf(params, "s[128]", desc))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negociodescripcion [descripcion del negocio]");
	if(Util_HasInvalidSQLCharacter(desc))
		return Util_PrintInvalidSQLCharacter(playerid);

	strcopy(Business[bizid][bDescription], desc, 128);
	Biz_SQLSaveDescription(bizid);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Descripcion del negocio actualizada.");
	return 1;
}

CMD:negociopromo(playerid, params[])
{
	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encontrás dentro de un negocio.");
	if(!Biz_IsPlayerOwner(playerid, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No sos el dueño de este negocio.");

	// Block if promo already active
	if(BizPromo[bizid] > 0 && GetTickCount() < BizPromoExpiry[bizid])
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya hay una promo activa. Usá /cancelarpromo para cancelarla (costo: $5000 de la caja).");
		return 1;
	}

	// Cooldown check: 5 minutes between promos
	if(BizPromoLastUsed[bizid] > 0 && GetTickCount() - BizPromoLastUsed[bizid] < 300000)
	{
		new remaining = (300000 - (GetTickCount() - BizPromoLastUsed[bizid])) / 1000;
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés esperar %i segundos antes de iniciar otra promo.", remaining);
		return 1;
	}

	new discount, duration;
	if(sscanf(params, "iI(60)i", discount, duration))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negociopromo [descuento%] [duracion_minutos - default 60]");
	if(!(1 <= discount <= 80))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El descuento debe estar entre 1% y 80%.");
	if(!(1 <= duration <= 240))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La duración debe estar entre 1 y 240 minutos.");

	BizPromo[bizid] = discount;
	BizPromoExpiry[bizid] = GetTickCount() + duration * 60 * 1000;
	BizPromoLastUsed[bizid] = GetTickCount();

	new annStr[256];
	format(annStr, sizeof(annStr), "{FFAA00}[ANUNCIO]{FFFFFF} %s tiene una promo de %i porciento de descuento por %i minutos. ¡Apurate!", Business[bizid][bName], discount, duration);
	SendClientMessageToAll(-1, annStr);
	new infoMsg[96];
	format(infoMsg, sizeof(infoMsg), "[INFO] "COLOR_EMB_GREY"Promo activada: %i porciento off por %i minutos.", discount, duration);
	SendClientMessage(playerid, COLOR_INFO, infoMsg);
	return 1;
}

CMD:cancelarpromo(playerid, params[])
{
	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encontrás dentro de un negocio.");
	if(!Biz_IsPlayerOwner(playerid, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No sos el dueño de este negocio.");
	if(!(BizPromo[bizid] > 0 && GetTickCount() < BizPromoExpiry[bizid]))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ninguna promo activa en este negocio.");

	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cancelar una promo tiene un costo de $5000 descontado de la caja del negocio.");
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La caja actual del negocio tiene $%i. Usá /pagarpenalizacion para confirmar.", Business[bizid][bTill]);
	return 1;
}

CMD:pagarpenalizacion(playerid, params[])
{
	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encontrás dentro de un negocio.");
	if(!Biz_IsPlayerOwner(playerid, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No sos el dueño de este negocio.");
	if(!(BizPromo[bizid] > 0 && GetTickCount() < BizPromoExpiry[bizid]))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ninguna promo activa para cancelar.");
	if(Business[bizid][bTill] < 5000)
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La caja no tiene fondos suficientes. Necesitás al menos $5000 (actual: $%i).", Business[bizid][bTill]);
		return 1;
	}

	Biz_AddTill(bizid, -5000);
	BizPromo[bizid] = 0;
	BizPromoExpiry[bizid] = 0;

	new annStr[192];
	format(annStr, sizeof(annStr), "{FFAA00}[ANUNCIO]{FFFFFF} La promo de %s ha sido cancelada.", Business[bizid][bName]);
	SendClientMessageToAll(-1, annStr);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Promo cancelada. Se descontaron $5000 de la caja.");
	return 1;
}
