#if defined _marp_biz_user_included
	#endinput
#endif
#define _marp_biz_user_included

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