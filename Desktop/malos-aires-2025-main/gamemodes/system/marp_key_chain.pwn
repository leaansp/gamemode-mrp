#if defined _marp_key_chain_inc
	#endinput
#endif
#define _marp_key_chain_inc

#include <YSI_Coding\y_hooks>

#define KEY_CHAIN_MAX_KEY_AMOUNT 12
#define KEY_MAX_LABEL_LEN 32
#define KEY_TYPE_MAX_NAME_LEN 16

enum
{
	/*0*/ KEY_TYPE_NONE,
	/*1*/ KEY_TYPE_VEHICLE,
	/*2*/ KEY_TYPE_BUSINESS,
	/*3*/ KEY_TYPE_HOUSE,

	/*LEAVE LAST*/ 	KEY_TYPES_AMOUNT
}

static enum e_KEY_TYPE_DATA
{
	e_KEY_TYPE_ADDR_PAYDAY,
	e_KEY_TYPE_ADDR_NAME_CHANGE,
	e_KEY_TYPE_ADDR_COPY_CHECK,
	e_LOG_TYPE_ID:e_KEY_TYPE_LOG_TYPE_ID,
	e_KEY_TYPE_NAME[KEY_TYPE_MAX_NAME_LEN]
}

static KeyTypeData[KEY_TYPES_AMOUNT][e_KEY_TYPE_DATA] = {{0, 0, 0, LOG_TYPE_ID_NONE, "-"}, ...};

static enum e_KEY_DATA
{
	e_KEY_SQLID,
	e_KEY_TYPE,
	e_KEY_EXTRA_ID,
	e_KEY_IS_OWNER,
	e_KEY_LABEL[KEY_MAX_LABEL_LEN]
}

static KeyChainData[MAX_PLAYERS][KEY_CHAIN_MAX_KEY_AMOUNT][e_KEY_DATA];
static Iterator:KeyChainData[MAX_PLAYERS]<KEY_CHAIN_MAX_KEY_AMOUNT>;

hook OnGameModeInit()
{
	Iter_Init(KeyChainData);
	CallLocalFunction("KeyChain_OnInit", "");
	return 1;
}

forward KeyChain_OnInit();
public KeyChain_OnInit() {
	return 1;
}

KeyChain_SetKeyTypeData(type, const typeName[] = "-", e_LOG_TYPE_ID:logType = LOG_TYPE_ID_NONE, onPaydayAddr = 0, onNameChangeAddr = 0, onCopyCheckAddr = 0)
{
	if(!(0 < type < KEY_TYPES_AMOUNT))
		return printf("Error al configurar los datos del tipo de llave %i. Tipo inválido.", type);

	strcopy(KeyTypeData[type][e_KEY_TYPE_NAME], typeName, KEY_TYPE_MAX_NAME_LEN);
	KeyTypeData[type][e_KEY_TYPE_LOG_TYPE_ID] = logType;
	KeyTypeData[type][e_KEY_TYPE_ADDR_PAYDAY] = onPaydayAddr;
	KeyTypeData[type][e_KEY_TYPE_ADDR_NAME_CHANGE] = onNameChangeAddr;
	KeyTypeData[type][e_KEY_TYPE_ADDR_COPY_CHECK] = onCopyCheckAddr;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	Iter_Clear(KeyChainData[playerid]);
	return 1;
}

hook OnPlayerCharSwitch(playerid)
{
	Iter_Clear(KeyChainData[playerid]);
	return 1;
}

hook LoadAccountDataEnded(playerid)
{
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "KeyChain_OnKeysLoaded", "i", playerid @Format: "SELECT `keyid`,`type`,`extraid`,`owner`,`label` FROM `player_key` WHERE `playerid`=%i LIMIT %i;", PlayerInfo[playerid][pID], KEY_CHAIN_MAX_KEY_AMOUNT);
	return 1;
}

forward KeyChain_OnKeysLoaded(playerid);
public KeyChain_OnKeysLoaded(playerid)
{
	if(!IsPlayerLogged(playerid))
		return 0;

	new rows = cache_num_rows();

	for(new i; i < rows; i++)
	{
		cache_get_value_index_int(i, 0, KeyChainData[playerid][i][e_KEY_SQLID]);
		cache_get_value_index_int(i, 1, KeyChainData[playerid][i][e_KEY_TYPE]);
		cache_get_value_index_int(i, 2, KeyChainData[playerid][i][e_KEY_EXTRA_ID]);
		cache_get_value_index_int(i, 3, KeyChainData[playerid][i][e_KEY_IS_OWNER]);
		cache_get_value_index(i, 4, KeyChainData[playerid][i][e_KEY_LABEL], KEY_MAX_LABEL_LEN);

		Iter_Add(KeyChainData[playerid], i);
	}
	return 1;
}

KeyChain_IsValidKey(playerid, key) {
	return Iter_Contains(KeyChainData[playerid], key);
}

KeyChain_Add(playerid, type, extraid, const label[], bool:owner)
{
	new key = Iter_Free(KeyChainData[playerid]);

	if(key == INVALID_ITERATOR_SLOT)
		return 0;
	if(KeyChain_Contains(playerid, type, extraid))
		return 0;

	KeyChainData[playerid][key][e_KEY_SQLID] = 0;
	KeyChainData[playerid][key][e_KEY_TYPE] = type;
	KeyChainData[playerid][key][e_KEY_EXTRA_ID] = extraid;
	KeyChainData[playerid][key][e_KEY_IS_OWNER] = owner;
	strcopy(KeyChainData[playerid][key][e_KEY_LABEL], label, KEY_MAX_LABEL_LEN);

	mysql_f_tquery(MYSQL_HANDLE, 200, @Callback: "KeyChain_OnKeyInserted", "ii", playerid, key @Format: "INSERT INTO `player_key` (`playerid`,`type`,`extraid`,`owner`,`label`) VALUES (%i,%i,%i,%i,'%e');", PlayerInfo[playerid][pID], type, extraid, owner, KeyChainData[playerid][key][e_KEY_LABEL]);
	Iter_Add(KeyChainData[playerid], key);
	return 1;
}

forward KeyChain_OnKeyInserted(playerid, key);
public KeyChain_OnKeyInserted(playerid, key)
{
	if(!IsPlayerLogged(playerid))
		return 0;

	KeyChainData[playerid][key][e_KEY_SQLID] = cache_insert_id();
	return 1;
}

KeyChain_UpdateLabel(playerid, key, const label[])
{
	if(!Iter_Contains(KeyChainData[playerid], key))
		return 0;

	strcopy(KeyChainData[playerid][key][e_KEY_LABEL], label, KEY_MAX_LABEL_LEN);
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `player_key` SET `label`='%e' WHERE `keyid`=%i;", KeyChainData[playerid][key][e_KEY_LABEL], KeyChainData[playerid][key][e_KEY_SQLID]);
	return 1;
}

KeyChain_DeleteKeySqlid(keysqlid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "DELETE FROM `player_key` WHERE `keyid`=%i;", keysqlid);
}

KeyChain_DeleteAllPlayerKeys(playerid)
{
	Iter_Clear(KeyChainData[playerid]);
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "DELETE FROM `player_key` WHERE `playerid`=%i;", PlayerInfo[playerid][pID]);
}

KeyChain_Remove(playerid, type, extraid, bool:allowIfOwnerKey, bool:save = true)
{
	foreach(new key : KeyChainData[playerid])
	{
		if(KeyChainData[playerid][key][e_KEY_TYPE] == type && KeyChainData[playerid][key][e_KEY_EXTRA_ID] == extraid && (allowIfOwnerKey || !KeyChainData[playerid][key][e_KEY_IS_OWNER]))
		{
			if(save) {
				KeyChain_DeleteKeySqlid(KeyChainData[playerid][key][e_KEY_SQLID]);
			}

			Iter_Remove(KeyChainData[playerid], key); // No hace falta usar Iter_SafeRemove porque cortamos el recorrido
			return 1;
		}
	}
	return 0;
}

KeyChain_RemoveByKey(playerid, key, bool:allowIfOwnerKey, bool:save = true)
{
	if(!Iter_Contains(KeyChainData[playerid], key))
		return 0;
	if(!allowIfOwnerKey && KeyChainData[playerid][key][e_KEY_IS_OWNER])
		return 0;

	if(save) {
		KeyChain_DeleteKeySqlid(KeyChainData[playerid][key][e_KEY_SQLID]);
	}

	Iter_Remove(KeyChainData[playerid], key);
	return 1;
}

KeyChain_DeleteAll(type, extraid, bool:allowIfOwnerKey)
{
	foreach(new playerid : Player) {
		KeyChain_Remove(playerid, type, extraid, .allowIfOwnerKey = allowIfOwnerKey, .save = false);
	}

	if(allowIfOwnerKey) {
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "DELETE FROM `player_key` WHERE `type`=%i AND `extraid`=%i;", type, extraid);
	} else {
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "DELETE FROM `player_key` WHERE `type`=%i AND `extraid`=%i AND `owner`=0;", type, extraid);
	}
}

KeyChain_Contains(playerid, type, extraid)
{
	foreach(new key : KeyChainData[playerid])
	{
		if(KeyChainData[playerid][key][e_KEY_TYPE] == type && KeyChainData[playerid][key][e_KEY_EXTRA_ID] == extraid)
			return 1;
	}
	return 0;
}

KeyChain_IsOwnerKey(playerid, key)
{
	if(!Iter_Contains(KeyChainData[playerid], key))
		return 0;

	return KeyChainData[playerid][key][e_KEY_IS_OWNER];
}

KeyChain_GetFreeSlots(playerid) {
	return (KEY_CHAIN_MAX_KEY_AMOUNT - Iter_Count(KeyChainData[playerid]));
}

KeyChain_GetOccupiedSlots(playerid) {
	return Iter_Count(KeyChainData[playerid]);
}

KeyChain_UpdatePlayerName(playerid)
{
	foreach(new key : KeyChainData[playerid])
	{
		if(KeyChainData[playerid][key][e_KEY_IS_OWNER])
		{
			if(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_ADDR_NAME_CHANGE]) {
				CallFunction(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_ADDR_NAME_CHANGE], KeyChainData[playerid][key][e_KEY_EXTRA_ID], playerid, ref(PlayerInfo[playerid][pName]));
			}
		}
	}
}

KeyChain_OnPlayerPayday(playerid, &income, &tax)
{
	// No usamos foreach porque muchos subprocesos borran llaves y eso invalidaría el iterador

	for(new key; key < KEY_CHAIN_MAX_KEY_AMOUNT; key++)
	{
		if(!Iter_Contains(KeyChainData[playerid], key))
			continue;

		if(KeyChainData[playerid][key][e_KEY_IS_OWNER])
		{
			if(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_ADDR_PAYDAY]) {
				CallFunction(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_ADDR_PAYDAY], KeyChainData[playerid][key][e_KEY_EXTRA_ID], playerid, ref(income), ref(tax));
			}
		}
	}
}

KeyChain_OnPlayerCharacterKill(playerid, notifyid)
{
	// No usamos foreach porque muchos subprocesos borran llaves y eso invalidaría el iterador

	for(new key; key < KEY_CHAIN_MAX_KEY_AMOUNT; key++)
	{
		if(!Iter_Contains(KeyChainData[playerid], key))
			continue;

		if(KeyChainData[playerid][key][e_KEY_IS_OWNER])
		{
			switch(KeyChainData[playerid][key][e_KEY_TYPE])
			{
				case KEY_TYPE_VEHICLE: Veh_OnPlayerCharacterKill(KeyChainData[playerid][key][e_KEY_EXTRA_ID], playerid, notifyid);
				case KEY_TYPE_BUSINESS: Biz_OnPlayerCharacterKill(KeyChainData[playerid][key][e_KEY_EXTRA_ID], playerid, notifyid);
				case KEY_TYPE_HOUSE: House_OnPlayerCharacterKill(KeyChainData[playerid][key][e_KEY_EXTRA_ID], playerid, notifyid);
			}
		}
	}

	KeyChain_DeleteAllPlayerKeys(playerid);
}

KeyChain_Show(playerid, toplayerid)
{
	new title[64], count = Iter_Count(KeyChainData[playerid]);
	format(title, sizeof(title), "[Llavero] %s (%i / %i)", GetPlayerCleanName(playerid), count, KEY_CHAIN_MAX_KEY_AMOUNT);

	if(count)
	{
		new line[64], string[KEY_CHAIN_MAX_KEY_AMOUNT * (KEY_MAX_LABEL_LEN + KEY_TYPE_MAX_NAME_LEN + 16)] = "[#]\tEtiqueta\tTipo (ID)\n";

		foreach(new key : KeyChainData[playerid])
		{
			format(line, sizeof(line), "[%i]\t%s\t%s (%i)\n", key, KeyChainData[playerid][key][e_KEY_LABEL], KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_NAME], KeyChainData[playerid][key][e_KEY_EXTRA_ID]);
			strcat(string, line, sizeof(string));
		}

		Dialog_Open(toplayerid, "DLG_KEY_CHAIN_SHOW", DIALOG_STYLE_TABLIST_HEADERS, title, string, "Cerrar", "");
	} else {
		Dialog_Open(toplayerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, title, "Vacío", "Cerrar", "");
	}
}

CMD:llavero(playerid, params[])
{
	new subcmd[16], key;

	if(!sscanf(params, "s[16]i", subcmd, key))
	{
		if(!strcmp(subcmd, "dar"))
		{
			new targetid;

			if(sscanf(params, "s[16]ii", subcmd, key, targetid))
				return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/llavero dar [llave] [ID/Jugador]");
			if(!KeyChain_IsValidKey(playerid, key))
				return SendClientMessage(playerid, COLOR_YELLOW2, "número de llave inválido.");
			if(!IsPlayerLogged(targetid))
				return SendClientMessage(playerid, COLOR_YELLOW2, "ID/Jugador inválido.");
			if(!IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador se encuentra demasiado lejos.");
			if(KeyChain_IsOwnerKey(playerid, key))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes dar una llave original si eres el dueño. Usa '/llavero darcopia'.");

			if(!KeyChain_Add(targetid, KeyChainData[playerid][key][e_KEY_TYPE], KeyChainData[playerid][key][e_KEY_EXTRA_ID], KeyChainData[playerid][key][e_KEY_LABEL], .owner = false))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene más espacio en su llavero o ya posee esa llave.");

			KeyChain_RemoveByKey(playerid, key, .allowIfOwnerKey = false);
			PlayerPlayerCmeMessage(playerid, targetid, 15.0, 4000, "Le entrega una llave a");
			SendFMessage(targetid, COLOR_LIGHTYELLOW2, " ¡%s te ha entregado una llave de '%s'! Puedes cambiar su etiqueta usando '/llavero etiqueta'.", GetPlayerChatName(playerid), KeyChainData[playerid][key][e_KEY_LABEL]);
			SendFMessage(playerid, COLOR_WHITE, "Le has dado una llave de '%s' a %s.", KeyChainData[playerid][key][e_KEY_LABEL], GetPlayerChatName(targetid));

			if(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_LOG_TYPE_ID] != LOG_TYPE_ID_NONE) {
				ServerLog(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_LOG_TYPE_ID], .id = KeyChainData[playerid][key][e_KEY_EXTRA_ID], .entry = "/llavero dar", .playerid = playerid, .targetid = targetid);
			}
		}
		else if(!strcmp(subcmd, "darcopia"))
		{
			new targetid;

			if(sscanf(params, "s[16]ii", subcmd, key, targetid))
				return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/llavero darcopia [llave] [ID/Jugador]");
			if(!KeyChain_IsValidKey(playerid, key))
				return SendClientMessage(playerid, COLOR_YELLOW2, "número de llave inválido.");
			if(!IsPlayerLogged(targetid))
				return SendClientMessage(playerid, COLOR_YELLOW2, "ID/Jugador inválido.");
			if(!IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador se encuentra demasiado lejos.");
			if(!KeyChain_IsOwnerKey(playerid, key))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes dar una copia de una llave si no eres el dueño. Usa '/llavero dar'.");

			if(!KeyChain_Add(targetid, KeyChainData[playerid][key][e_KEY_TYPE], KeyChainData[playerid][key][e_KEY_EXTRA_ID], KeyChainData[playerid][key][e_KEY_LABEL], .owner = false))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene más espacio en su llavero o ya posee esa llave.");

			PlayerPlayerCmeMessage(playerid, targetid, 15.0, 4000, "Le entrega una llave a");
			SendFMessage(targetid, COLOR_LIGHTYELLOW2, " ¡%s te ha entregado una llave de '%s'! Puedes cambiar su etiqueta usando '/llavero etiqueta'.", GetPlayerChatName(playerid), KeyChainData[playerid][key][e_KEY_LABEL]);
			SendFMessage(playerid, COLOR_WHITE, "Le has dado una llave de '%s' a %s.", KeyChainData[playerid][key][e_KEY_LABEL], GetPlayerChatName(targetid));

			if(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_LOG_TYPE_ID] != LOG_TYPE_ID_NONE) {
				ServerLog(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_LOG_TYPE_ID], .id = KeyChainData[playerid][key][e_KEY_EXTRA_ID], .entry = "/llavero darcopia", .playerid = playerid, .targetid = targetid);
			}
		}
		else if(!strcmp(subcmd, "desechar"))
		{
			if(!KeyChain_RemoveByKey(playerid, key, .allowIfOwnerKey = false))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"número de llave inválido o no puedes desechar una llave de un bien para el cual eres el dueño.");

			SendFMessage(playerid, COLOR_WHITE, "Has desechado la llave %i de tu llavero.", key);

			if(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_LOG_TYPE_ID] != LOG_TYPE_ID_NONE) {
				ServerLog(KeyTypeData[KeyChainData[playerid][key][e_KEY_TYPE]][e_KEY_TYPE_LOG_TYPE_ID], .id = KeyChainData[playerid][key][e_KEY_EXTRA_ID], .entry = "/llavero desechar", .playerid = playerid);
			}
		}
		else if(!strcmp(subcmd, "etiqueta"))
		{
			new label[128];

			if(sscanf(params, "s[16]is[128]", subcmd, key, label))
				return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/llavero etiqueta [llave] [etiqueta] (máx "#KEY_MAX_LABEL_LEN" char)");
			if(Util_HasInvalidSQLCharacter(label))
				return Util_PrintInvalidSQLCharacter(playerid);

			if(!KeyChain_UpdateLabel(playerid, key, label))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"número de llave inválido.");

			SendFMessage(playerid, COLOR_WHITE, "Has cambiado la etiqueta de la llave %i a '%s'.", key, KeyChainData[playerid][key][e_KEY_LABEL]);
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/llavero [comando]. Usa '/llavero ayuda' para ver los comandos disponibles.");

		if(isnull(params)) {
			KeyChain_Show(playerid, .toplayerid = playerid);
		} else {
			SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" desechar [llave] - dar [llave] [ID/Jugador] - darcopia [llave] [ID/Jugador] - etiqueta [llave] [etiqueta] (máx "#KEY_MAX_LABEL_LEN" char)");
		}
	}

	return 1;
}
