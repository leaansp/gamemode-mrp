#if defined _marp_biz_employees_included
	#endinput
#endif
#define _marp_biz_employees_included

#include <YSI_Coding\y_hooks>

static enum e_BIZ_EMP_INFO 
{
    e_BIZ_EMP_ID,
    e_BIZ_EMP_DUTY    
};

static BizEmployeeInfo[MAX_PLAYERS][e_BIZ_EMP_INFO] = {{0, 0}, ...};
static BizEmployeeOffer[MAX_PLAYERS] = {0, ...};

hook LoadAccountDataEnded(playerid)
{
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "BizEmp_OnInfoLoaded", "i", playerid @Format: "SELECT `bizEmpId`,`bizEmpDuty` FROM `biz_employees` WHERE `pID`=%i LIMIT 1;", PlayerInfo[playerid][pID]);
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
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "INSERT INTO `biz_employees` (`pID`,`bizEmpId`, `bizEmpDuty`) VALUES (%i,%i,%i);", PlayerInfo[playerid][pID], BizEmployeeInfo[playerid][e_BIZ_EMP_ID], BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY]);
	} else {
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `biz_employees` SET `bizEmpId`=%i, `bizEmpDuty`=%i WHERE `pID`=%i;", BizEmployeeInfo[playerid][e_BIZ_EMP_ID], BizEmployeeInfo[playerid][e_BIZ_EMP_DUTY], PlayerInfo[playerid][pID]);
	}

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Felicitaciones! ahora eres empleado del negocio: %s.", Biz_GetName(bizid));

	switch(GetBusinessType(bizid))
	{
		case BIZ_MECH: SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Utiliza '/mecayuda' para ver los comandos disponibles.");
	}

    foreach(new id : Player)
    {
        if(KeyChain_Contains(id, KEY_TYPE_BUSINESS, bizid) && playerid != id)
            SendFMessage(playerid, COLOR_LIGHTBLUE, "[INFO] "COLOR_EMB_GREY" %s acepto el contrato de trabajo para el negocio %s.", GetPlayerCleanName(playerid), Biz_GetName(bizid));
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
	if(GetBusinessType(bizid) != BIZ_MECH)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes contratar empleados en este negocio!");

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
	if(GetBusinessType(bizid) != BIZ_MECH)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes despedir empleados en este negocio!");

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

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "BizEmp_OnHireAccept", "ii", playerid, BizEmployeeOffer[playerid] @Format: "SELECT `bizEmpId`,`bizEmpDuty` FROM `biz_employees` WHERE `pID`=%i LIMIT 1;", PlayerInfo[playerid][pID]);
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
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");
	if(GetBusinessType(bizid) != BIZ_MECH)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes hacerte empleado de este negocio!");
	if(BizEmployeeInfo[playerid][e_BIZ_EMP_ID] == bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya eres empleado de este negocio!");

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "BizEmp_OnHireAccept", "ii", playerid, bizid @Format: "SELECT `bizEmpId`,`bizEmpDuty` FROM `biz_employees` WHERE `pID`=%i LIMIT 1;", PlayerInfo[playerid][pID]);
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