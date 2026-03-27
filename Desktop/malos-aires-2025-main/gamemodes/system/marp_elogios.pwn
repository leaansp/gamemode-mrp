#if defined _marp_elogios_included
	endinput
#endif
#define _marp_elogios_included

#include <YSI_Coding\y_hooks>

#define DLG_MISELOGIOS              9610
#define DLG_CONFIG_ELOGIOS           9611

// Almacena temporalmente el target y motivo mientras espera el callback de DB
new gElogiarTarget[MAX_PLAYERS];
new gElogiarMotivo[MAX_PLAYERS][80];

CMD:elogiar(playerid, params[])
{
	if(ServerInfo[sElogiosPorPDR] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sistema de elogios esta desactivado.");

	new targetid, motivo[80];

	if(sscanf(params, "us[80]", targetid, motivo))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/elogiar [ID/Jugador] [Motivo] (MAX: 80 caracteres)");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador invalido.");

	if(targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No podes elogiarte a vos mismo.");


	// Guardar target y motivo para el callback
	gElogiarTarget[playerid] = targetid;
	strcat(gElogiarMotivo[playerid], motivo, 80);

	// Verificar cuantos elogios dio hoy
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "ElogiarCallback", "i", playerid @Format: "SELECT COUNT(*) as `total` FROM `elogios` WHERE `donante_id`=%i AND `fecha` >= NOW() - INTERVAL 24 HOUR;", PlayerInfo[playerid][pMasterAccountId]);
	return 1;
}

forward ElogiarCallback(playerid);
public ElogiarCallback(playerid)
{
	new total;
	cache_get_value_name_int(0, "total", total);

	if(total >= 3)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya diste 3 elogios hoy. Podrás dar más en 24 horas.");
		gElogiarMotivo[playerid][0] = EOS;
		return 1;
	}

	new targetid = gElogiarTarget[playerid];
	new motivo[80];
	strcat(motivo, gElogiarMotivo[playerid], 80);
	gElogiarMotivo[playerid][0] = EOS;

	if(!IsPlayerLogged(targetid))
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador se desconectó antes de recibir el elogio.");
		gElogiarMotivo[playerid][0] = EOS;
		return 1;
	}

	// Sumar elogio al receptor
	PlayerInfo[targetid][pElogios]++;
	PlayerInfo[targetid][pElogiosPendientes]++;

	// Guardar en tabla elogios
	new query[300];
	mysql_format(MYSQL_HANDLE, query, sizeof(query),
		"INSERT INTO `elogios` (`receptor_id`, `donante_id`, `motivo`) VALUES (%i, %i, '%e');",
		PlayerInfo[targetid][pID],
		PlayerInfo[playerid][pMasterAccountId],
		motivo
	);
	mysql_tquery(MYSQL_HANDLE, query);

	// Mensaje al receptor
	PlayerPlaySound(targetid, 1139, 0.0, 0.0, 0.0);
	SendClientMessage(targetid, COLOR_WHITE, "{878EE7}[INFO]{66BB6A} ¡Felicitaciones! Has recibido un elogio.");
	SendFMessage(targetid, COLOR_WHITE, "{878EE7}[INFO]{66BB6A} Motivo: %s", motivo);
	SendFMessage(targetid, COLOR_WHITE, "{878EE7}[INFO]{66BB6A} Ahora tenés %d elogio(s). ¡Seguí así!", PlayerInfo[targetid][pElogios]);
	SendClientMessage(targetid, COLOR_WHITE, "{878EE7}[INFO]{C8C8C8} Usa /elogiar para reconocer el buen rol de otro jugador.");
	SendFMessage(targetid, COLOR_WHITE, "{878EE7}[INFO]{C8C8C8} 1 Punto de Rol equivale a %d elogios.", ServerInfo[sElogiosPorPDR]);

	// Verificar conversion a PDR
	if(ServerInfo[sElogiosPorPDR] > 0 && PlayerInfo[targetid][pElogiosPendientes] >= ServerInfo[sElogiosPorPDR])
	{
		PlayerInfo[targetid][pRolePoints]++;
		PlayerInfo[targetid][pElogiosPendientes] -= ServerInfo[sElogiosPorPDR];

		// Guardar en role_points igual que un PDR manual
		new pdrQuery[350];
		mysql_format(MYSQL_HANDLE, pdrQuery, sizeof(pdrQuery),
			"INSERT INTO `role_points` (`pID`,`pName`,`Amount`,`Reason`,`Date`,`adminID`,`adminName`) VALUES (%i,'%s',1,'Conversion automatica de elogios',CURRENT_TIMESTAMP,0,'Sistema');",
			PlayerInfo[targetid][pID],
			PlayerInfo[targetid][pName]
		);
		mysql_tquery(MYSQL_HANDLE, pdrQuery);

		// Mensaje de PDR en amarillo
		PlayerPlaySound(targetid, 6401, 0.0, 0.0, 0.0);
		SendClientMessage(targetid, COLOR_LIGHTYELLOW2, "* * * * * * * * * * * * * * * * * * * *");
		SendClientMessage(targetid, COLOR_LIGHTYELLOW2, "  Tus elogios te han otorgado un Punto de Rol.");
		SendFMessage(targetid, COLOR_LIGHTYELLOW2, "  Total de Puntos de Rol: %d", PlayerInfo[targetid][pRolePoints]);
		SendClientMessage(targetid, COLOR_LIGHTYELLOW2, "* * * * * * * * * * * * * * * * * * * *");
	}

	// Guardar stats del receptor en DB inmediatamente
	new saveQuery[256];
	mysql_format(MYSQL_HANDLE, saveQuery, sizeof(saveQuery),
		"UPDATE `accounts` SET `pElogios`=%i,`pElogiosPendientes`=%i,`pRolePoints`=%i WHERE `pID`=%i;",
		PlayerInfo[targetid][pElogios],
		PlayerInfo[targetid][pElogiosPendientes],
		PlayerInfo[targetid][pRolePoints],
		PlayerInfo[targetid][pID]
	);
	mysql_tquery(MYSQL_HANDLE, saveQuery);

	// Mensaje al donante
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Le diste un elogio a %s. (%d/3 hoy)", GetPlayerCleanName(targetid), total + 1);

	return 1;
}

CMD:miselogios(playerid, params[])
{
	if(!IsPlayerLogged(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar logueado.");

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "MisElogiosCallback", "iii", playerid, PlayerInfo[playerid][pElogios], PlayerInfo[playerid][pElogiosPendientes] @Format: "SELECT `motivo` FROM `elogios` WHERE `receptor_id`=%i ORDER BY `id` DESC LIMIT 10;", PlayerInfo[playerid][pID]);
	return 1;
}

forward MisElogiosCallback(playerid, totalElogios, pendientes);
public MisElogiosCallback(playerid, totalElogios, pendientes)
{
	new rows = cache_num_rows();
	new dialog[1024];

	format(dialog, sizeof(dialog), "{878EE7}Elogios historicos recibidos: {66BB6A}%d\n{878EE7}Pendientes para el proximo PDR: {66BB6A}%d{C8C8C8}/{66BB6A}%d\n\n", totalElogios, pendientes, ServerInfo[sElogiosPorPDR]);

	if(rows == 0)
	{
		strcat(dialog, "{C8C8C8}Todavía no recibiste ningún elogio.\n", sizeof(dialog));
	}
	else
	{
		strcat(dialog, "{878EE7}Ultimos elogios recibidos:\n", sizeof(dialog));
		new motivo[80], line[100];
		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name(i, "motivo", motivo, sizeof(motivo));
			format(line, sizeof(line), "{C8C8C8}  - %s\n", motivo);
			strcat(dialog, line, sizeof(dialog));
		}
	}

	ShowPlayerDialog(playerid, DLG_MISELOGIOS, DIALOG_STYLE_MSGBOX, "Mis elogios", dialog, "Cerrar", "");
	return 1;
}


CMD:resetearelogios(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 15)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes permiso para usar este comando.");

	// Borra todos los elogios dados en las ultimas 24h (resetea el cooldown de todos)
	mysql_tquery(MYSQL_HANDLE, "DELETE FROM `elogios` WHERE `fecha` >= NOW() - INTERVAL 24 HOUR;");

	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Elogios de las ultimas 24 horas eliminados. El cooldown fue reseteado.");
	return 1;
}
CMD:testearelogi(playerid, params[])
{
	if(ServerInfo[sElogiosPorPDR] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sistema de elogios esta desactivado.");

	if(AccountInfo[playerid][accAdminLevel] < 15)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes permiso para usar este comando.");

	new targetid, cantidad;
	if(sscanf(params, "ui", targetid, cantidad))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/testearelogi [ID] [Cantidad]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador invalido.");

	PlayerInfo[targetid][pElogios] += cantidad;
	PlayerInfo[targetid][pElogiosPendientes] += cantidad;

	// Convertir a PDR si corresponde (puede ser mas de uno)
	new pdrsGanados = 0;
	while(ServerInfo[sElogiosPorPDR] > 0 && PlayerInfo[targetid][pElogiosPendientes] >= ServerInfo[sElogiosPorPDR])
	{
		PlayerInfo[targetid][pRolePoints]++;
		PlayerInfo[targetid][pElogiosPendientes] -= ServerInfo[sElogiosPorPDR];
		pdrsGanados++;

		new pdrQuery[350];
		mysql_format(MYSQL_HANDLE, pdrQuery, sizeof(pdrQuery),
			"INSERT INTO `role_points` (`pID`,`pName`,`Amount`,`Reason`,`Date`,`adminID`,`adminName`) VALUES (%i,'%s',%i,'Conversion automatica de elogios',CURRENT_TIMESTAMP,0,'Sistema');",
			PlayerInfo[targetid][pID],
			PlayerInfo[targetid][pName],
			1
		);
		mysql_tquery(MYSQL_HANDLE, pdrQuery);
	}

	// Guardar en DB
	new elogioInsert[300];
	mysql_format(MYSQL_HANDLE, elogioInsert, sizeof(elogioInsert),
		"INSERT INTO `elogios` (`receptor_id`, `donante_id`, `motivo`) VALUES (%i, 0, 'TEST (x%i)');",
		PlayerInfo[targetid][pID],
		cantidad
	);
	mysql_tquery(MYSQL_HANDLE, elogioInsert);

	new accountSave[256];
	mysql_format(MYSQL_HANDLE, accountSave, sizeof(accountSave),
		"UPDATE `accounts` SET `pElogios`=%i,`pElogiosPendientes`=%i,`pRolePoints`=%i WHERE `pID`=%i;",
		PlayerInfo[targetid][pElogios],
		PlayerInfo[targetid][pElogiosPendientes],
		PlayerInfo[targetid][pRolePoints],
		PlayerInfo[targetid][pID]
	);
	mysql_tquery(MYSQL_HANDLE, accountSave);

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Inyectaste %d elogios a %s.", cantidad, GetPlayerCleanName(targetid));
	if(pdrsGanados > 0)
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se convirtieron en %d PDR.", pdrsGanados);

	if(targetid != playerid)
	{
		SendClientMessage(targetid, COLOR_LIGHTYELLOW2, "* * * * * * * * * * * * * * * * * * * *");
		SendFMessage(targetid, COLOR_LIGHTYELLOW2, "  Recibiste %d elogios de prueba de un admin.", cantidad);
		if(pdrsGanados > 0)
			SendFMessage(targetid, COLOR_LIGHTYELLOW2, "  Se convirtieron en %d PDR. Total: %d", pdrsGanados, PlayerInfo[targetid][pRolePoints]);
		SendClientMessage(targetid, COLOR_LIGHTYELLOW2, "* * * * * * * * * * * * * * * * * * * *");
	}
	return 1;
}

CMD:configuracionelogios(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 15)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes permiso para usar este comando.");

	SendClientMessage(playerid, COLOR_ERROR, "[INFO] Recorda que solo podes modificar los elogios si tenes la autorizacion pertinente.");
	SendClientMessage(playerid, COLOR_ERROR, "[INFO] Asegurate que haya consenso colectivo antes de modificar los elogios; este cambio podria modificar la dinamica de juego de los usuarios.");

	ShowPlayerDialog(playerid, DLG_CONFIG_ELOGIOS, DIALOG_STYLE_LIST,
		"Configuracion de elogios",
		"35 elogios = 1 PDR\n60 elogios = 1 PDR\n90 elogios = 1 PDR\n120 elogios = 1 PDR\n150 elogios = 1 PDR\n200 elogios = 1 PDR\nDesactivar sistema de elogios",
		"Seleccionar", "Cancelar");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DLG_MISELOGIOS) return 1;

	if(dialogid == DLG_CONFIG_ELOGIOS)
	{
		if(!response) return 1;

		new valores[] = {35, 60, 90, 120, 150, 200, 0};
		new nuevoValor = valores[listitem];
		ServerInfo[sElogiosPorPDR] = nuevoValor;

		new query[128];
		mysql_format(MYSQL_HANDLE, query, sizeof(query),
			"UPDATE `server` SET `sElogiosPorPDR`=%i WHERE `ID`=1;", nuevoValor);
		mysql_tquery(MYSQL_HANDLE, query);

		if(nuevoValor == 0)
			SendClientMessage(playerid, COLOR_ERROR, "[ADMIN] Sistema de elogios DESACTIVADO.");
		else
			SendFMessage(playerid, COLOR_WHITE, "{878EE7}[ADMIN]{C8C8C8} Configuracion actualizada: %d elogios = 1 PDR.", nuevoValor);
		return 1;
	}

	return 0;
}
