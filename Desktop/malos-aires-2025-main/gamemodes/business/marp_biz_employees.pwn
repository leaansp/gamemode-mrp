#if defined _marp_biz_employees_included
	#endinput
#endif
#define _marp_biz_employees_included

#include <YSI_Coding\y_hooks>

static enum e_BIZ_EMP_INFO 
{
    e_BIZ_EMP_ID,
    e_BIZ_EMP_DUTY,
    e_BIZ_EMP_RANK_NAME[32],
    e_BIZ_EMP_RANK_LEVEL,
    e_BIZ_EMP_SALARY
};

static BizEmployeeInfo[MAX_PLAYERS][e_BIZ_EMP_INFO] = {{0, 0, "Empleado", 0, 0}, ...};
static BizEmployeeOffer[MAX_PLAYERS] = {0, ...};

hook LoadAccountDataEnded(playerid)
{
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "BizEmp_OnInfoLoaded", "i", playerid @Format: "SELECT `bizEmpId`,`bizEmpDuty`,`bizEmpRankName`,`bizEmpRankLevel`,`bizEmpSalary` FROM `biz_employees` WHERE `pID`=%i LIMIT 1;", PlayerInfo[playerid][pID]);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	BizEmployeeInfo[playerid][e_BIZ_EMP_ID] = 0;
	BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY] = 0;
	BizEmployeeOffer[playerid] = 0;
	return 1;
}

CALLBACK:BizEmp_OnInfoLoaded(playerid)
{
	if(!IsPlayerLogged(playerid))
		return 0;

	if(cache_num_rows()) // Si fue contratado en algúnnegocio.
	{
		cache_get_value_name_int(0, "bizEmpId", BizEmployeeInfo[playerid][e_BIZ_EMP_ID]);
		cache_get_value_name_int(0, "bizEmpDuty", BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY]);
		cache_get_value_name(0, "bizEmpRankName", BizEmployeeInfo[playerid][e_BIZ_EMP_RANK_NAME], 32);
		cache_get_value_name_int(0, "bizEmpRankLevel", BizEmployeeInfo[playerid][e_BIZ_EMP_RANK_LEVEL]);
		cache_get_value_name_int(0, "bizEmpSalary", BizEmployeeInfo[playerid][e_BIZ_EMP_SALARY]);
	}

	return 1;
}

CALLBACK:BizEmp_OnHireAccept(playerid, bizid)
{
	if(!IsPlayerLogged(playerid))
		return 0;

	BizEmployeeOffer[playerid] = 0;
	BizEmployeeInfo[playerid][e_BIZ_EMP_ID] = bizid;
	BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY] = 0;

	if(!cache_num_rows()) { // Si nunca fue contratado en algúnnegocio.
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "INSERT INTO `biz_employees` (`pID`,`bizEmpId`,`bizEmpDuty`,`bizEmpRankName`,`bizEmpRankLevel`,`bizEmpSalary`) VALUES (%i,%i,%i,'Empleado',0,0);", PlayerInfo[playerid][pID], BizEmployeeInfo[playerid][e_BIZ_EMP_ID], BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY]);
	} else {
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `biz_employees` SET `bizEmpId`=%i, `bizEmpDuty`=%i, `bizEmpRankName`='Empleado', `bizEmpRankLevel`=0 WHERE `pID`=%i;", BizEmployeeInfo[playerid][e_BIZ_EMP_ID], BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY], PlayerInfo[playerid][pID]);
	}

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Felicitaciones! ahora eres empleado del negocio: %s.", Biz_GetName(bizid));

	switch(GetBusinessType(bizid))
	{
		case BIZ_MECH: SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Utiliza '/mecayuda' para ver los comandos disponibles.");
	}

    foreach(new id : Player)
    {
        if(BizEmp_IsEmployee(id, bizid) && id != playerid)
            SendFMessage(id, COLOR_LIGHTBLUE, "[NEGOCIO] "COLOR_EMB_GREY" %s acepto el contrato de trabajo para el negocio %s.", GetPlayerCleanName(playerid), Biz_GetName(bizid));
    }

	return 1;
}

stock BizEmp_IsEmployee(playerid, bizid) {
	return (BizEmployeeInfo[playerid][e_BIZ_EMP_ID] == bizid || KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid));
}

stock BizEmp_IsEmployeeOfType(playerid, btype) {
	return (Business[BizEmployeeInfo[playerid][e_BIZ_EMP_ID]][bType] == btype);
}

stock BizEmp_IsOnDuty(playerid) {
	return BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY];
}

stock BizEmp_GetBizId(playerid) {
	return BizEmployeeInfo[playerid][e_BIZ_EMP_ID];
}

stock BizEmp_IsAnyMechanicOnDuty()
{
	foreach(new i : Player)
	{
		if(BizEmp_IsEmployeeOfType(i, BIZ_MECH) && BizEmp_IsOnDuty(i))
			return true;
	}
	return false;
}

CMD:negociocontratar(playerid, params[])
{
	new bizid = Biz_IsPlayerOutsideOrInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");
	new targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negociocontratar [ID/Jugador]");
	if(!IsPlayerLogged(targetid) || playerid == targetid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	BizEmployeeOffer[targetid] = bizid;
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te ofreció un contrato de empleado para el negocio: %s. Utiliza '/aceptar contrato' para aceptarlo.", GetPlayerCleanName(playerid), Biz_GetName(bizid));
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Has ofrecido un contrato a %s para el negocio %s.", GetPlayerCleanName(targetid), Biz_GetName(bizid));
	return 1;
}

CMD:negociodespedir(playerid, params[])
{
	new bizid = Biz_IsPlayerOutsideOrInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");
	new targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negociodespedir [ID/Jugador]");
	if(!IsPlayerLogged(targetid) || playerid == targetid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(BizEmployeeInfo[targetid][e_BIZ_EMP_ID] != bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este jugador no es empleado del negocio.");

	BizEmployeeInfo[targetid][e_BIZ_EMP_ID] = 0;
	BizEmployeeInfo[targetid][e_BIZ_EMP_DUTY] = 0;
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te ha despedido del negocio: %s.", GetPlayerCleanName(playerid), Biz_GetName(bizid));
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Has despedido a %s del negocio %s.", GetPlayerCleanName(targetid), Biz_GetName(bizid));
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `biz_employees` SET `bizEmpId`=%i, `bizEmpDuty`=%i WHERE `pID`=%i;", BizEmployeeInfo[targetid][e_BIZ_EMP_ID], BizEmployeeInfo[targetid][e_BIZ_EMP_DUTY], PlayerInfo[targetid][pID]);
	return 1;
}

hook function OnPlayerCmdAccept(playerid, const subcmd[])
{
	if(strcmp(subcmd, "contrato", true))
		return continue(playerid, subcmd);

	if(BizEmployeeOffer[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció un contrato.");
	if(BizEmployeeInfo[playerid][e_BIZ_EMP_ID] != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya eres empleado de un negocio.");

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "BizEmp_OnHireAccept", "ii", playerid, BizEmployeeOffer[playerid] @Format: "SELECT `bizEmpId`,`bizEmpDuty`,`bizEmpRankName`,`bizEmpRankLevel`,`bizEmpSalary` FROM `biz_employees` WHERE `pID`=%i LIMIT 1;", PlayerInfo[playerid][pID]);
	return 1;
}

CMD:negociorenunciar(playerid, params[])
{
	new bizid = Biz_IsPlayerOutsideOrInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en un negocio.");
	if(BizEmployeeInfo[playerid][e_BIZ_EMP_ID] != bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No eres empleado de este negocio!");

	BizEmployeeInfo[playerid][e_BIZ_EMP_ID] = 0;
	BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY] = 0;
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Has renunciado como empleado del negocio %s.", Biz_GetName(bizid));
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `biz_employees` SET `bizEmpId`=%i AND `bizEmpDuty`=%i WHERE `pID`=%i;", BizEmployeeInfo[playerid][e_BIZ_EMP_ID], BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY], PlayerInfo[playerid][pID]);
	return 1;
}

CMD:negociotrabajo(playerid, params[])
{
	new bizid = Biz_IsPlayerOutsideOrInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en un negocio.");
	if(!BizEmp_IsEmployee(playerid, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres empleado de este negocio.");

	// Toggle duty
	BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY] = !BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY];
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `biz_employees` SET `bizEmpDuty`=%i WHERE `pID`=%i;", BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY], PlayerInfo[playerid][pID]);

	new bool:onDuty = bool:BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY];
	SendFMessage(playerid, COLOR_INFO, "[NEGOCIO] "COLOR_EMB_GREY"Ahora estas %s en el negocio %s.", (onDuty) ? ("en servicio") : ("fuera de servicio"), Biz_GetName(bizid));

	// Notify all colleagues
	foreach(new id : Player)
	{
		if(id != playerid && BizEmp_IsEmployee(id, bizid))
			SendFMessage(id, COLOR_LIGHTBLUE, "[NEGOCIO] "COLOR_EMB_GREY"%s %s en el negocio %s.", GetPlayerCleanName(playerid), (onDuty) ? ("entro en servicio") : ("salio de servicio"), Biz_GetName(bizid));
	}
	return 1;
}
BizEmp_OnBizSell(bizid)
{
	foreach(new playerid : Player)
	{
		if(BizEmployeeInfo[playerid][e_BIZ_EMP_ID] == bizid)
		{
			BizEmployeeInfo[playerid][e_BIZ_EMP_ID] = 0;
			BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY] = 0;

			SendFMessage(playerid, COLOR_LIGHTBLUE, "Dejas de trabajar para el negocio %s ya que fue vendido.", Biz_GetName(bizid));
		}
	}

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `biz_employees` SET `bizEmpId`= 0 AND `bizEmpDuty`= 0 WHERE `bizEmpId`=%i;", bizid);
}
stock BizEmp_GetRankName(playerid)
{
	new rank[32];
	strcat(rank, BizEmployeeInfo[playerid][e_BIZ_EMP_RANK_NAME], 32);
	return rank;
}

CMD:negociodarrango(playerid, params[])
{
	new bizid = Biz_IsPlayerOutsideOrInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	new targetid, rankName[32];
	if(sscanf(params, "us[32]", targetid, rankName))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negociodarrango [ID/Jugador] [nombre del rango]");
	if(!IsPlayerLogged(targetid) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador invalido.");
	if(BizEmployeeInfo[targetid][e_BIZ_EMP_ID] != bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ese jugador no es empleado de tu negocio.");
	if(Util_HasInvalidSQLCharacter(rankName))
		return Util_PrintInvalidSQLCharacter(playerid);

	strcopy(BizEmployeeInfo[targetid][e_BIZ_EMP_RANK_NAME], rankName, 32);
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `biz_employees` SET `bizEmpRankName`='%e' WHERE `pID`=%i;", rankName, PlayerInfo[targetid][pID]);

	SendFMessage(playerid, COLOR_INFO, "[NEGOCIO] "COLOR_EMB_GREY"Le asignaste el rango '%s' a %s.", rankName, GetPlayerCleanName(targetid));
	SendFMessage(targetid, COLOR_INFO, "[NEGOCIO] "COLOR_EMB_GREY"Te asignaron el rango '%s' en el negocio %s.", rankName, Biz_GetName(bizid));
	return 1;
}

CMD:cn(playerid, params[])
{
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cn [mensaje]");

	// Determine which biz this player belongs to
	new bizid = BizEmp_GetBizId(playerid);
	if(!bizid)
	{
		for(new b = 1; b < MAX_BUSINESS; b++) {
			if(Biz_IsPlayerOwner(playerid, b)) { bizid = b; break; }
		}
	}

	if(!Biz_IsValidId(bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres empleado ni dueno de ningun negocio.");

	new msg[256];
	new rankStr[36];
	format(rankStr, sizeof(rankStr), "[%s]", (BizEmployeeInfo[playerid][e_BIZ_EMP_ID] == bizid) ? (BizEmp_GetRankName(playerid)) : ("Dueno"));
	format(msg, sizeof(msg), "{FFAA00}[NEGOCIO] %s{FFFFFF} %s: %s", rankStr, GetPlayerCleanName(playerid), params);

	foreach(new id : Player)
	{
		if(BizEmp_IsEmployee(id, bizid) || Biz_IsPlayerOwner(id, bizid))
			SendClientMessage(id, -1, msg);
	}
	return 1;
}

CMD:chatn(playerid, params[]) return cmd_cn(playerid, params);

CMD:negocioconectados(playerid, params[])
{
	new bizid = BizEmp_GetBizId(playerid);
	if(!bizid)
	{
		for(new b = 1; b < MAX_BUSINESS; b++) {
			if(Biz_IsPlayerOwner(playerid, b)) { bizid = b; break; }
		}
	}

	if(!Biz_IsValidId(bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No sos empleado ni dueño de ningún negocio.");

	new str[512], count;
	format(str, sizeof(str), "{FFAA00}--- Personal conectado: %s ---{FFFFFF}\n", Business[bizid][bName]);

	// Owner
	foreach(new id : Player)
	{
		if(Biz_IsPlayerOwner(id, bizid))
		{
			format(str, sizeof(str), "%s[Dueño] %s\n", str, GetPlayerCleanName(id));
			count++;
		}
	}

	// Employees
	foreach(new id : Player)
	{
		if(BizEmp_IsEmployee(id, bizid))
		{
			new dutyStr[10];
			if(BizEmployeeInfo[id][e_BIZ_EMP_DUTY]) dutyStr = " [ON]";
			else dutyStr = " [OFF]";
			format(str, sizeof(str), "%s[%s]%s %s\n", str, BizEmployeeInfo[id][e_BIZ_EMP_RANK_NAME], dutyStr, GetPlayerCleanName(id));
			count++;
		}
	}

	if(!count)
		strcat(str, "No hay personal conectado.", sizeof(str));

	Dialog_Open(playerid, "DLG_NegocioConectados", DIALOG_STYLE_MSGBOX, "Personal conectado", str, "Cerrar", "");
	return 1;
}

Dialog:DLG_NegocioConectados(playerid, response, listitem, inputtext[]) { return 1; }
