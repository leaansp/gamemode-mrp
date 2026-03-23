#if defined _marp_rolepoints_included
	#endinput
#endif
#define _marp_rolepoints_included

#define MAX_LISTED_ROLEPOINTS 		10

CMD:darpuntoderol(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new targetid, reason[80], string[128];
	
	if(sscanf(params, "us[80]", targetid, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/darpuntoderol [ID/Jugador] [Razón] (MAX: 80 caracteres)");
	if(!IsPlayerLogged(targetid) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
		
	format(string, sizeof(string), "El administrador %s le ha dado un punto de rol a %s. Razón: %s.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), reason);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	SendFMessage(targetid, COLOR_LIGHTYELLOW2, "El administrador %s te ha otorgado un punto de rol. Razón: %s.", GetPlayerCleanName(playerid), reason);
	
	PlayerInfo[targetid][pRolePoints]++;

	new query[350];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `role_points` \
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
	return 1;
}

CMD:quitarpuntoderol(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 6)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	new targetid, reason[80], string[128];

	if(sscanf(params, "us[80]", targetid, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/quitarpuntoderol [ID/Jugador] [Razón] (MAX: 80 caracteres)");
	if(!IsPlayerLogged(targetid) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(PlayerInfo[targetid][pRolePoints] <= 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador seleccionado no tiene ningún punto de rol para quitar.");

	format(string, sizeof(string), "El administrador %s le ha quitado un punto de rol a %s. Razón: %s.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), reason);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	SendFMessage(targetid, COLOR_LIGHTYELLOW2, "El administrador %s te ha quitado un punto de rol. Razón: %s.", GetPlayerCleanName(playerid), reason);

	PlayerInfo[targetid][pRolePoints]--;

	new query[350];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `role_points` \
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

CMD:verpuntosderol(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

    new targetid;
    
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/verpuntosderol [ID/Jugador]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "ShowRolePoints", "ii", targetid, playerid @Format: "SELECT * FROM `role_points` WHERE `pID`=%i LIMIT %i;", PlayerInfo[targetid][pID], MAX_LISTED_ROLEPOINTS);
 	return 1;
}

forward ShowRolePoints(ofplayerid, toplayerid);
public ShowRolePoints(ofplayerid, toplayerid)
{
	new rows = cache_num_rows();

	if(rows)
	{
		SendFMessage(toplayerid, COLOR_LIGHTYELLOW2, "==========[Ultimos %d punto/s de rol otorgados y quitados a %s]==========", rows, GetPlayerCleanName(ofplayerid));

		new amount, date[32], adminName[MAX_PLAYER_NAME], reason[80];

		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "Amount", amount);
			cache_get_value_name(i, "Date", date, sizeof(date));
			cache_get_value_name(i, "adminName", adminName, sizeof(adminName));
			cache_get_value_name(i, "Reason", reason, sizeof(reason));

			SendFMessage(toplayerid, COLOR_WHITE, "Cantidad: %i - Por: %s - Fecha: %s - Razón: %s.", amount, adminName, date, reason);
		}
	} else {
		SendFMessage(toplayerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontraron puntos de rol para el personaje %s.", GetPlayerCleanName(ofplayerid));
	}
	return 1;
}


