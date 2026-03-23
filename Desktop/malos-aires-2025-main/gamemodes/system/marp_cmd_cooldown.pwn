#if defined marp_cmd_cooldown_inc
	#endinput
#endif
#define marp_cmd_cooldown_inc

#include <YSI_Coding\y_hooks>

const COOLDOWN_CMD_RESET_ID = MAX_PLAYERS;

enum e_COOLDOWN_CMD_ID
{
	/*0*/ COOLDOWN_CMD_ID_ASALTAR,
	/*1*/ COOLDOWN_CMD_ID_HURTAR,
	/*2*/ COOLDOWN_CMD_ID_HURTARTIENDA,
	/*3*/ COOLDOWN_CMD_ID_ASALTARTIENDA,
	/*4*/ COOLDOWN_CMD_ID_HURTARCASA,
	/*5*/ COOLDOWN_CMD_ID_ASALTARCASA,
	/*6*/ COOLDOWN_CMD_ID_BARRETA,
	/*7*/ COOLDOWN_CMD_ID_FACA,
	/*8*/ COOLDOWN_CMD_ID_CHEF_KNIFE,
	/*7*/ COOLDOWN_CMD_ID_PUENTE,
	/*8*/ COOLDOWN_CMD_ID_DESARMAR,
	/*9*/ COOLDOWN_CMD_ID_TAXILLAMADASNPC,
	/*10*/ COOLDOWN_CMD_ID_ROBARCABLES,
	/*11*/COOLDOWN_CMD_ID_CARTERISTA,
	/*LEAVE LAST*/ COOLDOWN_CMDS_AMOUNT
}

static CooldownCMDData[MAX_PLAYERS + 1][COOLDOWN_CMDS_AMOUNT];

hook OnPlayerDisconnect(playerid, reason)
{
	CooldownCMDData[playerid] = CooldownCMDData[COOLDOWN_CMD_RESET_ID];
	return 1;
}

hook LoadAccountDataEnded(playerid)
{
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "CooldownCMD_OnDataLoad", "i", playerid @Format: "SELECT `cmdid`,`cooldown` FROM `cmd_cooldown` WHERE `pid`=%i;", PlayerInfo[playerid][pID]);
	return 1;
}

forward CooldownCMD_OnDataLoad(playerid);
public CooldownCMD_OnDataLoad(playerid)
{
	if(!IsPlayerLogged(playerid))
		return 0;

	new rows = cache_num_rows();

	for(new i, cmdid; i < rows; i++)
	{
		cache_get_value_index_int(i, 0, cmdid);
		cache_get_value_index_int(i, 1, CooldownCMDData[playerid][e_COOLDOWN_CMD_ID:cmdid]);
	}
	return 1;
}

CooldownCMD_Apply(playerid, e_COOLDOWN_CMD_ID:cmdid, seconds)
{
	CooldownCMDData[playerid][cmdid] = PlayerInfo[playerid][pTimePlayed] + seconds;

	if(seconds > 0) {
		mysql_f_tquery(MYSQL_HANDLE, 160, @Callback: "" @Format: "INSERT INTO `cmd_cooldown` (pid, cmdid, cooldown) VALUES (%i,%i,%i) ON DUPLICATE KEY UPDATE `cooldown`=VALUES(`cooldown`);", PlayerInfo[playerid][pID], cmdid, CooldownCMDData[playerid][cmdid]);
	} else {
		CooldownCMD_Reset(playerid, cmdid);
	}
}

CooldownCMD_Reset(playerid, e_COOLDOWN_CMD_ID:cmdid)
{
	if(CooldownCMDData[playerid][cmdid])
	{
		CooldownCMDData[playerid][cmdid] = 0;
		mysql_f_tquery(MYSQL_HANDLE, 90, @Callback: "" @Format: "DELETE FROM `cmd_cooldown` WHERE `pid`=%i AND `cmdid`=%i;", PlayerInfo[playerid][pID], cmdid);
	}
}

CooldownCMD_IsAllowed(playerid, e_COOLDOWN_CMD_ID:cmdid)
{
	if(PlayerInfo[playerid][pTimePlayed] < CooldownCMDData[playerid][cmdid])
		return 0;

	CooldownCMD_Reset(playerid, cmdid);
	return 1;
}

CooldownCMD_GetRemainingTime(playerid, e_COOLDOWN_CMD_ID:cmdid) {
	return (CooldownCMDData[playerid][cmdid] - PlayerInfo[playerid][pTimePlayed]);
}

CooldownCMD_Check(playerid, e_COOLDOWN_CMD_ID:cmdid)
{
	if(!CooldownCMD_IsAllowed(playerid, cmdid))
	{
		new cooldownCMDTime = CooldownCMD_GetRemainingTime(playerid, cmdid);

		if(cooldownCMDTime < 60) {
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar %i segundos para volver a realizar esta acción.", cooldownCMDTime);
		} else {
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar %i minutos para volver a realizar esta acción.", cooldownCMDTime / 60);
		}
		
		return 0;
	}

	return 1;
}