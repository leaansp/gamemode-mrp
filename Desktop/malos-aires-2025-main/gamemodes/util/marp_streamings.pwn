#if defined _marp_streamings_included
	#endinput
#endif
#define _marp_streamings_included

#include <YSI_Coding\y_hooks>

hook LoadSystemData()
{
	Radio_Init();
	Radio_LoadAll();
	return 1;
}

hook SaveSystemData()
{
	Radio_SaveAll();
	return 1;
}

#define MAX_SERVER_RADIOS		64

#define RADIO_TYPE_NONE         0
#define RADIO_TYPE_VEH          1
#define RADIO_TYPE_SPEAKER      2
#define RADIO_TYPE_HOUSE        3
#define RADIO_TYPE_BIZ          4
#define RADIO_TYPE_BLD          5

const RADIO_INVALID_ID = 0;
const RADIO_RESET_ID = 0;

const RADIO_NAME_MAX_LEN = 64; 
const RADIO_STREAM_MAX_LEN = 128; 

new Radio_DlgInfoStr[4096];

enum e_RADIO_DATA
{
	radioName[RADIO_NAME_MAX_LEN],
	radioStream[RADIO_STREAM_MAX_LEN]
}

static ServerRadios[MAX_SERVER_RADIOS][e_RADIO_DATA] = {
	{
		/*radioName[RADIO_NAME_MAX_LEN]*/ "NONE",
		/*radioStream[RADIO_STREAM_MAX_LEN]*/ ""
	}, ...
};

static Iterator:ServerRadios<MAX_SERVER_RADIOS>;

enum e_streaming {
	e_id,
	e_type,
};

new player_streaming[MAX_PLAYERS][e_streaming];

Radio_Init() {
	Iter_Add(ServerRadios, RADIO_INVALID_ID); // Init de id 0 para que no aparezca libre. 
}

Radio_IsValidId(radioid) {
	return ((radioid) ? (bool:Iter_Contains(ServerRadios, radioid)) : (false));
}

Radio_Add(const name[], const stream[])
{
	new radioid = Iter_Free(ServerRadios);

	if (radioid == ITER_NONE)
	{
		printf("[ERROR] Alcanzado MAX_SERVER_RADIOS (%i). Iter_Count: %i.", MAX_SERVER_RADIOS, Iter_Count(ServerRadios));
		return RADIO_INVALID_ID;
	}

	strcopy(ServerRadios[radioid][radioName], name, RADIO_NAME_MAX_LEN);
	strcopy(ServerRadios[radioid][radioStream], stream, RADIO_STREAM_MAX_LEN);

	Radio_SQLCreate(radioid);
	Iter_Add(ServerRadios, radioid);
	return radioid;
}

Radio_Delete(radioid)
{
	if (!Radio_IsValidId(radioid))
		return 0;

	Iter_Remove(ServerRadios, radioid);
	Radio_SQLDelete(radioid);
	ServerRadios[radioid] = ServerRadios[RADIO_RESET_ID];
	return 1;
}

stock Radio_GetId(playerid) {
	return player_streaming[playerid][e_id];
}
	
stock Radio_GetType(playerid) {
	return player_streaming[playerid][e_type];
}

Radio_IsOn(playerid) {
	return (player_streaming[playerid][e_id] && player_streaming[playerid][e_type]);
}

Radio_IsOnType(playerid, type) {
	return (player_streaming[playerid][e_id] && player_streaming[playerid][e_type] == type);
}

Radio_SetName(id, const name[])
{
	if(!Radio_IsValidId(id))
		return 0;

	strcopy(ServerRadios[id][radioName], name, RADIO_NAME_MAX_LEN);
	Radio_SQLSaveName(id);
	return 1;
}

Radio_SetStream(id, const stream[])
{
	if(!Radio_IsValidId(id))
		return 0;

	strcopy(ServerRadios[id][radioStream], stream, RADIO_STREAM_MAX_LEN);
	Radio_SQLSaveStream(id);
	return 1;
}

Radio_Set(playerid, id, type)
{
	if(!Radio_IsValidId(id))
		return 0;

	player_streaming[playerid][e_id] = id;
	player_streaming[playerid][e_type] = type;
	PlayAudioStreamForPlayer(playerid, ServerRadios[id][radioStream]);
	return 1;
}

Radio_SetEx(playerid, id, type, Float:x, Float:y, Float:z, Float:radius)
{
	if(!Radio_IsValidId(id))
		return 0;

	player_streaming[playerid][e_id] = id;
	player_streaming[playerid][e_type] = type;
	PlayAudioStreamForPlayer(playerid, ServerRadios[id][radioStream], x, y, z, radius, 1);
	return 1;
}

Radio_Stop(playerid)
{
	Radio_Reset(playerid);
    StopAudioStreamForPlayer(playerid);
}

Radio_StopIfOnType(playerid, type)
{
	if(Radio_IsOnType(playerid, type)) {
		Radio_Stop(playerid);
	}
}

Radio_Reset(playerid)
{
	player_streaming[playerid][e_id] = 0;
	player_streaming[playerid][e_type] = 0;
}

Radio_ShowMenu(playerid)
{
	// Inicia con la radio 0, por lo cual el count es 1.
	if (!(Iter_Count(ServerRadios) - 1))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "No hay radios configuradas.");

	Radio_DlgInfoStr[0] = '\0';
	strcat(Radio_DlgInfoStr, "[ID]\tRadio\n", sizeof(Radio_DlgInfoStr));
	new radioStr[128];

	foreach (new radio : ServerRadios)
	{
		if (radio) // Ignoramos la id 0
		{
			format(radioStr, sizeof(radioStr), "%d\t%s\n", radio, ServerRadios[radio][radioName]);
			strcat(Radio_DlgInfoStr, radioStr, sizeof(Radio_DlgInfoStr));
		}
	}

	Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_TABLIST_HEADERS, "Lista de radios", Radio_DlgInfoStr, "Cerrar", "");
	return 1;
}

CMD:aradiosadd(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new stream[RADIO_STREAM_MAX_LEN];

	if(sscanf(params, "s[128]", stream))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aradiosadd [stream]");
	
	new radio = Radio_Add("Nueva Radio", stream);

	if(!radio)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Imposible agregar la radio. Se alcanzó el máximo de radios o ocurrió algún problema.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Agregada la radio %i correctamente. Utiliza '/aradiosetname' para cambiarle el nombre.", radio);
	return 1;
}

CMD:aradiossetname(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new radioid, name[RADIO_NAME_MAX_LEN];

	if(sscanf(params, "is[64]", radioid, name))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aradiossetname [radio id] [nombre]");
	if(!Radio_IsValidId(radioid)) 
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La id de radio es invalida.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cambiado el nombre de la radio %i de '%s' a '%s' correctamente.", radioid, ServerRadios[radioid][radioName], name);
	Radio_SetName(radioid, name);
	return 1;
}

CMD:aradiossetstream(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new radioid, stream[RADIO_STREAM_MAX_LEN];

	if(sscanf(params, "is[128]", radioid, stream))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aradiossetstream [radio id] [stream]");
	if(!Radio_IsValidId(radioid)) 
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La id de radio es invalida.");
	
	Radio_SetStream(radioid, stream);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cambiado el stream de la radio %i correctamente.", radioid);
	return 1;
}

CMD:aradiosdelete(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new radioid;

	if(sscanf(params, "i", radioid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aradiosdelete [radio id]");
	if(!Radio_IsValidId(radioid)) 
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La id de radio es invalida.");

	Radio_Delete(radioid);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Radio %i eliminada correctamente.", radioid);
	return 1;
}

CMD:radios(playerid, params[])
{
	Radio_ShowMenu(playerid);
	return 1;
}

/*
Database
*/

Radio_LoadAll()
{
    mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "Radio_OnDataLoadAll" @Format: "SELECT * FROM `radios` LIMIT %i;", MAX_SERVER_RADIOS -1);
	print("[INFO] Cargando radios...");
	return 1;
}

CALLBACK:Radio_OnDataLoadAll()
{
	new rows = cache_num_rows();

	for(new row, radioid; row < rows; row++)
	{
        cache_get_value_name_int(row, "radioId", radioid);

        cache_get_value_name(row, "radioName", ServerRadios[radioid][radioName], RADIO_NAME_MAX_LEN);
        cache_get_value_name(row, "radioStream", ServerRadios[radioid][radioStream], RADIO_STREAM_MAX_LEN);

		Iter_Add(ServerRadios, radioid);
	}

	printf("[INFO] Carga de %i radios finalizada.", rows);
	return 1;
}

Radio_SQLDelete(radioid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "DELETE FROM `radios` WHERE `radioId`=%i;", radioid);
}

Radio_SQLCreate(radioid) 
{
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `radios` \
			(`radioId`,\
			`radioName`,\
			`radioStream`)\
		VALUES \
			(%i,'%e','%e');",
		radioid,
		ServerRadios[radioid][radioName],
        ServerRadios[radioid][radioStream]
	);
	mysql_tquery(MYSQL_HANDLE, query);
}

Radio_SQLSaveName(radioid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `radios` SET `radioName`='%e' WHERE `radioId`=%i;", ServerRadios[radioid][radioName], radioid);
}

Radio_SQLSaveStream(radioid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `radios` SET `radioStream`='%e' WHERE `radioId`=%i;", ServerRadios[radioid][radioStream], radioid);
}

Radio_SQLSave(radioid) 
{
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"UPDATE `radios` SET\
			`radioName`='%e',\
			`radioStream`='%e'\
		WHERE \
			`radioId`=%i;",
		ServerRadios[radioid][radioName],
        ServerRadios[radioid][radioStream],
		radioid
	);
	mysql_tquery(MYSQL_HANDLE, query);
}

Radio_SaveAll()
{
	new radiosamount;
	foreach (new radio : ServerRadios)
	{
		Radio_SQLSave(radio);
		radiosamount++;
	}

	printf("[INFO] %i radios guardadas.", radiosamount);
	return 1;
}