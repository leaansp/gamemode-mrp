#if defined _marp_hidden_name_included
	#endinput
#endif
#define _marp_hidden_name_included

#include <YSI_Coding\y_hooks>

static STREAMER_TAG_3D_TEXT_LABEL:HiddenName_label[MAX_PLAYERS];
static HiddenName_labelText[MAX_PLAYERS][MAX_PLAYER_NAME];
static HiddenName_uniqueId[MAX_PLAYERS];
static HiddenName_active[MAX_PLAYERS];

HiddenName_IsActive(playerid) {
	return HiddenName_active[playerid];
}

stock HiddenName_GetUniqueId(playerid) {
	return HiddenName_uniqueId[playerid];
}

HiddenName_On(playerid)
{
	if(HiddenName_active[playerid])
		return 0;

	if(!HiddenName_uniqueId[playerid])
	{
		HiddenName_uniqueId[playerid] = 1000 + random(9000);
		HiddenName_Log(playerid, HiddenName_uniqueId[playerid]);
	}

	format(HiddenName_labelText[playerid], MAX_PLAYER_NAME, "Oculto (%i)", HiddenName_uniqueId[playerid]);
	SetPlayerChatName(playerid, HiddenName_labelText[playerid]);
	HiddenName_label[playerid] = CreateDynamic3DTextLabel(HiddenName_labelText[playerid], COLOR_DEEPWHITE, 0.0, 0.0, 0.10, .drawdistance = 30.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 30.0);
 	HiddenName_active[playerid] = true;

	foreach(new i : Player)
	{
		if(!AdminDuty[i]) {
			ShowPlayerNameTagForPlayer(i, playerid, false);
		}
	}
 	return 1;
}

HiddenName_Off(playerid)
{
	if(!HiddenName_active[playerid])
		return 0;

	HiddenName_active[playerid] = false;
	SetPlayerChatName(playerid, GetPlayerCleanName(playerid));
	DestroyDynamic3DTextLabel(HiddenName_label[playerid]);
	HiddenName_label[playerid] = STREAMER_TAG_3D_TEXT_LABEL:0;

	foreach(new i : Player)
	{
		if(BitFlag_Get(p_toggle[i], FLAG_TOGGLE_NICKS)) {
			ShowPlayerNameTagForPlayer(i, playerid, true);
		}
	}
	return 1;
}

HiddenName_Log(playerid, hiddenid)
{
	new query[128];

	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `log_hidden_names` (`account_id`,`account_name`,`hidden_id`) VALUES (%i,'%s',%i)",
		PlayerInfo[playerid][pID],
		PlayerInfo[playerid][pName],
		hiddenid
	);

	mysql_tquery(MYSQL_HANDLE, query);
}

hook OnPlayerStreamIn(playerid, forplayerid)
{
	if(HiddenName_active[playerid] && !AdminDuty[forplayerid]) {
		ShowPlayerNameTagForPlayer(forplayerid, playerid, false);
	} else if(!BitFlag_Get(p_toggle[forplayerid], FLAG_TOGGLE_NICKS)) {
		ShowPlayerNameTagForPlayer(forplayerid, playerid, false);
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(HiddenName_active[playerid])
	{
		HiddenName_active[playerid] = false;
		SetPlayerChatName(playerid, GetPlayerCleanName(playerid));
		DestroyDynamic3DTextLabel(HiddenName_label[playerid]);
		HiddenName_label[playerid] = STREAMER_TAG_3D_TEXT_LABEL:0;
	}

	HiddenName_uniqueId[playerid] = 0;
	return 1;
}

CMD:averoculto(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new hiddenid;

	if(sscanf(params, "i", hiddenid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/averoculto [ID especial del jugador oculto]");

	foreach(new i : Player)
	{
		if(HiddenName_uniqueId[i] == hiddenid)
		{
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Jugador oculto con ID (%i) encontrado: %s (ID %i).", hiddenid, GetPlayerCleanName(i), i);
			return 1;
		}
	}

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT * FROM `log_hidden_names` WHERE `hidden_id`=%i LIMIT 30", hiddenid);
	mysql_tquery(MYSQL_HANDLE, query, "HiddenName_LoadLogs", "i", playerid);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No se ha encontrado un jugador oculto online con ID (%i), buscando en la base de datos...", hiddenid);
	return 1;
}

forward HiddenName_LoadLogs(playerid);
public HiddenName_LoadLogs(playerid)
{
	if(!IsPlayerLogged(playerid))
		return 0;

	new rows = cache_num_rows();

	if(!rows)
		return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No se han encontrado registros correspondientes a esa ID en la base de datos.");

	new name[MAX_PLAYER_NAME], date[32], accountid;

	for(new i; i < rows; i++)
	{
		cache_get_value_name_int(i, "account_id", accountid);
		cache_get_value_name(i, "log_date", date, sizeof(date));
		cache_get_value_name(i, "account_name", name, MAX_PLAYER_NAME);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Encontrado: %s (SQLID %i) - Fecha: %s.", name, accountid, date);
	}
	return 1;
}