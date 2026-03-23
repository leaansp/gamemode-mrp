#if defined _marp_warnings_included
	#endinput
#endif
#define _marp_warnings_included

static const MAX_LISTED_WARNINGS = 10;

CMD:daradvertencia(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 5)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	new targetid, reason[80], string[128];
	
	if(sscanf(params, "us[80]", targetid, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/daradvertencia [ID/Jugador] [razón] (MAX: 80 caracteres)");
    if(!IsPlayerConnected(targetid))// || targetid == playerid)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Jugador inválido.");
	
	PlayerInfo[targetid][pWarnings]++;

	new query[350];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `warnings` \
			(`pID`,`pName`,`Amount`,`Reason`,`Date`,`adminID`,`adminName`) \
		VALUES \
			(%i,'%s',1,'%e',CURRENT_TIMESTAMP,%i,'%s');",
		PlayerInfo[targetid][pID],
		PlayerInfo[targetid][pName],
		reason,
		PlayerInfo[playerid][pID],
		PlayerInfo[playerid][pName]
	);

    mysql_tquery(MYSQL_HANDLE, query);

    format(string, sizeof(string), "El administrador %s le ha dado una advertencia a %s. razón: %s.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), reason);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);

	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has sido advertido por %s, razón: %s.", GetPlayerCleanName(playerid), reason);
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"A las 5 advertencias serás baneado del servidor, ahora tienes %d.", PlayerInfo[targetid][pWarnings]);

    if(PlayerInfo[targetid][pWarnings] >= 5) {
		BanPlayer(targetid, INVALID_PLAYER_ID, "Acumulación de advertencias", 7 * (PlayerInfo[targetid][pWarnings] - 4)); 
	}
	return 1;
}

CMD:quitaradvertencia(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 5)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	new targetid, reason[80], string[128];

	if(sscanf(params, "us[80]", targetid, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/quitaradvertencia [ID/Jugador] [razón] (MAX: 80 caracteres)");
    if(!IsPlayerLogged(targetid)) // || targetid == playerid)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Jugador inválido.");
	if(PlayerInfo[targetid][pWarnings] <= 0)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador seleccionado no tiene ninguna advertencia para quitar.");
        
	format(string, sizeof(string), "El administrador %s le ha quitado una advertencia a %s. razón: %s.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), reason);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El administrador %s te quito una advertencia, razón: %s.", GetPlayerCleanName(playerid), reason);

	PlayerInfo[targetid][pWarnings]--;

	new query[350];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `warnings` \
			(`pID`,`pName`,`Amount`,`Reason`,`Date`,`adminID`,`adminName`) \
		VALUES \
			(%i,'%s',-1,'%e',CURRENT_TIMESTAMP,%i,'%s');",
		PlayerInfo[targetid][pID],
		PlayerInfo[targetid][pName],
		reason,
		PlayerInfo[playerid][pID],
		PlayerInfo[playerid][pName]
	);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

CMD:veradvertencias(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

    new targetid;
    
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/veradvertencias [ID/Jugador]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "Warnings_Show", "ii", targetid, playerid @Format: "SELECT * FROM `warnings` WHERE `pID`=%i LIMIT %i;", PlayerInfo[targetid][pID], MAX_LISTED_WARNINGS);
 	return 1;
}

forward Warnings_Show(ofplayerid, toplayerid);
public Warnings_Show(ofplayerid, toplayerid)
{
	new rows = cache_num_rows();

	if(rows)
	{
		SendFMessage(toplayerid, COLOR_WHITE, "___________________[Advertencias de %s]___________________", GetPlayerCleanName(ofplayerid));

		new date[64], reason[80], adminname[MAX_PLAYER_NAME], amount;

		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name_int(i, "Amount", amount);
			cache_get_value_name(i, "Date", date, sizeof(date));
			cache_get_value_name(i, "adminName", adminname, sizeof(adminname));
			cache_get_value_name(i, "Reason", reason, sizeof(reason));

			SendFMessage(toplayerid, COLOR_WHITE, "Cantidad: %i - Por: %s - Fecha: %s - razón: %s.", amount, adminname, date, reason);
		}

		SendFMessage(toplayerid, COLOR_WHITE, "Total de advertencias: %i.", PlayerInfo[ofplayerid][pWarnings]);
	} else {
		SendFMessage(toplayerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontraron advertencias para el personaje %s.", GetPlayerCleanName(ofplayerid));
	}
	return 1;
}


