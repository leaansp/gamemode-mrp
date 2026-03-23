#if defined marp_mapro_inc
	#endinput
#endif
#define marp_mapro_inc

/*
	                                                _           __ 
	   ____ ___  ____ _____     ____  _________    (_)__  _____/ /_
	  / __ `__ \/ __ `/ __ \   / __ \/ ___/ __ \  / / _ \/ ___/ __/
	 / / / / / / /_/ / /_/ /  / /_/ / /  / /_/ / / /  __/ /__/ /_  
	/_/ /_/ /_/\__,_/ .___/  / .___/_/   \____/_/ /\___/\___/\__/  
	               /_/      /_/              /___/                 

*/

#include <YSI_Coding\y_hooks>

static enum e_MAPRO_DYN_OBJ_ARRAY_DATA
{
	e_DYN_OBJ_TYPE:e_MAPRO_DYN_OBJ_TYPE,
	e_MAPRO_DYN_OBJ_MAPRO_ID,
	e_MAPRO_DYN_OBJ_SLOT
}

Mapro_SetDynamicObjectArrayData(STREAMER_TAG_OBJECT:objectid, e_DYN_OBJ_TYPE:type, maproid, slot)
{
	new arrayData[e_MAPRO_DYN_OBJ_ARRAY_DATA];

	arrayData[e_MAPRO_DYN_OBJ_TYPE] = type;
	arrayData[e_MAPRO_DYN_OBJ_MAPRO_ID] = maproid;
	arrayData[e_MAPRO_DYN_OBJ_SLOT] = slot;

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));	
}

#define MAPRO_MAX_NAME_LENGTH 64
#define MAPRO_MAX_DESC_LENGTH 128
#define MAPRO_MAX_OBJECTS_AMOUNT 128

const MAPRO_MAX_AMOUNT = 128;
const MAPRO_RESET_ID = MAPRO_MAX_AMOUNT;
const MAPRO_MAX_PLAYERS_ALLOWED = 5;
const MAPRO_MAX_MODELS_ALLOWED = 15;
const INVALID_MAPRO_ID = -1;
const INVALID_MAPRO_SLOT_ID = -1;

static MaproGlobalAccessLevel = 20;

static enum e_MAPRO_DATA
{
	mpName[MAPRO_MAX_NAME_LENGTH],
	mpDescription[MAPRO_MAX_DESC_LENGTH],
	mpStatus,
	mpFaction,
	mpRank,
	mpObjectLimit,
	mpModelFilter,
	mpModelAllowed[MAPRO_MAX_MODELS_ALLOWED],
	mpOwnerSQLID,
	mpOwnerName[MAX_PLAYER_NAME],
	mpPlayerSQLIDAllowed[MAPRO_MAX_PLAYERS_ALLOWED],
	mpPlayerNameAllowed[MAPRO_MAX_PLAYERS_ALLOWED * MAX_PLAYER_NAME]
}

static MaproData[MAPRO_MAX_AMOUNT + 1][e_MAPRO_DATA];
static Iterator:MaproData<MAPRO_MAX_AMOUNT>;

static enum e_MAPRO_OBJECT_DATA
{
	mpObjectSQLID,
	mpObjectID
}

static MaproObject[MAPRO_MAX_AMOUNT][MAPRO_MAX_OBJECTS_AMOUNT][e_MAPRO_OBJECT_DATA];
static Iterator:MaproObject[MAPRO_MAX_AMOUNT]<MAPRO_MAX_OBJECTS_AMOUNT>;

static enum
{
	MAPRO_ACCESS_LEVEL_NONE = 1,
	MAPRO_ACCESS_LEVEL_VIEWER,
	MAPRO_ACCESS_LEVEL_MAPPER,
	MAPRO_ACCESS_LEVEL_MANAGER,
	MAPRO_ACCESS_LEVEL_OWNER
}

static enum e_MAPRO_HANDLING_DATA
{
	e_MAPRO_HANDLING_ID,
	e_MAPRO_HANDLING_OBJECT_ID,
	e_MAPRO_HANDLING_OPTION
}

static MaproHandlingData[MAX_PLAYERS + 1][e_MAPRO_HANDLING_DATA] = {{INVALID_MAPRO_ID, INVALID_STREAMER_ID, 0}, ...};
const MAPRO_HANDLING_RESET_ID = MAX_PLAYERS;

hook OnPlayerDisconnect(playerid, reason)
{
	Mapro_ResetHandlingData(playerid);
	return 1;
}

Mapro_ResetHandlingData(playerid)
{
	MaproHandlingData[playerid] = MaproHandlingData[MAPRO_HANDLING_RESET_ID];
	return 0;
}

Mapro_ParseModelAllowed(maproid, const buffer[])
{
	for(new j = 0, s = 0; j < MAPRO_MAX_MODELS_ALLOWED; j++)
	{
		if(sscanf(buffer[s], "p<,>i", MaproData[maproid][mpModelAllowed][j]))
			break;
		if(!(s = strfind(buffer, ",", false, s) + 1))
			break;
	}
}

Mapro_ParsePlayerSQLIDAllowed(maproid, const buffer[])
{
	for(new j = 0, s = 0; j < MAPRO_MAX_PLAYERS_ALLOWED; j++)
	{
		if(sscanf(buffer[s], "p<,>i", MaproData[maproid][mpPlayerSQLIDAllowed][j]))
			break;
		if(!(s = strfind(buffer, ",", false, s) + 1))
			break;
	}
}

Mapro_ParsePlayerNameAllowed(maproid, const buffer[])
{
	for(new j = 0, s = 0; j < MAPRO_MAX_PLAYERS_ALLOWED; j++)
	{
		if(sscanf(buffer[s], "p<,>s[24] ", MaproData[maproid][mpPlayerNameAllowed][j * MAX_PLAYER_NAME]))
			break;
		if(!(s = strfind(buffer, ",", false, s) + 1))
			break;
	}
}

hook OnGameModeInit()
{
	Iter_Init(MaproObject);
	return 1;
}

hook OnGameModeInitEnded()
{
	print("[INFO] Cargando proyectos de mapeo...");

	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT * FROM `mapro` LIMIT %i;", MAPRO_MAX_AMOUNT);
	mysql_tquery(MYSQL_HANDLE, query, "Mapro_OnDataLoad");
	return 1;
}

forward Mapro_OnDataLoad();
public Mapro_OnDataLoad()
{
	new rows = cache_num_rows();

	for(new i = 0, buffer[256], maproid; i < rows; i++)
	{
		maproid = Iter_Add(MaproData, cache_name_int(i, "maproid"));

		if(maproid == INVALID_ITERATOR_SLOT)
		{
			printf("[ERROR] Imposible cargar mapro ID %i, la ID ya se encuentra tomada. Iter_Count: %i.", cache_name_int(i, "maproid"), Iter_Count(MaproData));
			continue;
		}

		cache_get_value_name(i, "name", MaproData[maproid][mpName], MAPRO_MAX_NAME_LENGTH);
		cache_get_value_name(i, "description", MaproData[maproid][mpDescription], MAPRO_MAX_DESC_LENGTH);
		cache_get_value_name_int(i, "status", MaproData[maproid][mpStatus]);
		cache_get_value_name_int(i, "faction", MaproData[maproid][mpFaction]);
		cache_get_value_name_int(i, "rank", MaproData[maproid][mpRank]);
		cache_get_value_name_int(i, "object_limit", MaproData[maproid][mpObjectLimit]);
		cache_get_value_name_int(i, "model_filter", MaproData[maproid][mpModelFilter]);
		cache_get_value_name_int(i, "ownerid", MaproData[maproid][mpOwnerSQLID]);
		cache_get_value_name(i, "ownername", MaproData[maproid][mpOwnerName], MAX_PLAYER_NAME);

		cache_get_value_name(i, "model_allowed", buffer, sizeof(buffer));
		Mapro_ParseModelAllowed(maproid, buffer);
		
		cache_get_value_name(i, "playerid_allowed", buffer, sizeof(buffer));
		Mapro_ParsePlayerSQLIDAllowed(maproid, buffer);

		cache_get_value_name(i, "playername_allowed", buffer, sizeof(buffer));
		Mapro_ParsePlayerNameAllowed(maproid, buffer);
	}

	foreach(new maproid : MaproData)
	{
		if(MaproData[maproid][mpStatus]) {
			Mapro_LoadObjects(maproid);
		}
	}

	printf("[INFO] Carga de %i proyectos de mapeo finalizada.", rows);
	return 1;
}

CMD:maprocrear(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 10)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");

	new name[MAPRO_MAX_NAME_LENGTH];

	if(sscanf(params, "s["#MAPRO_MAX_NAME_LENGTH"]", name))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/maprocrear [nombre] (hasta "#MAPRO_MAX_NAME_LENGTH" caracteres).");

	new maproid = Mapro_Create(name, playerid);

	if(maproid != INVALID_MAPRO_ID)
	{
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Nuevo proyecto '%s' (ID %i) creado exitosamente. Utiliza '/mapro %i' para configurarlo.", name, maproid, maproid);
		new string[128];
		format(string, sizeof(string), "[MAPRO] %s ha creado el proyecto '%s' (ID %i).", GetPlayerCleanName(playerid), name, maproid);
		AdministratorMessage(COLOR_ADMINCMD, string, 2);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Alcanzado el Límite máximode proyectos o el nombre es inválido.");
	}
	return 1;
}

CMD:maproacceso(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 10)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");

	new level;

	if(sscanf(params, "i", level))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/maproacceso [nivel]");
	if(level < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El acceso ilimitado a proyectos y edición de objetos base solo se admite para administradores nivel 2 o mayor.");

	MaproGlobalAccessLevel = level;
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Acceso ilimitado configurado para administradores nivel %i o mayor.", level);
	return 1;
}

CMD:mapro(playerid, params[])
{
	new maproid;

	if(sscanf(params, "i", maproid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mapro [ID Proyecto]");
	if(!Mapro_ShowForPlayer(maproid, playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de proyecto inválida o no estás autorizado para acceder a ese proyecto.");
	
	return 1;
}

CMD:maprolistar(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 8)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");

	return Mapro_ShowAllForPlayer(playerid);
}

CMD:maproa(playerid, params[])
{
	new maproid, objectModel;

	if(sscanf(params, "ii", maproid, objectModel))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/maproa [ID proyecto] [modelo de objeto]");
	if(Mapro_GetPlayerAccessLevel(maproid, playerid) < MAPRO_ACCESS_LEVEL_MAPPER)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID inválida o no estás autorizado para operar sobre es proyecto.");
	if(Mapro_IsForbiddenModelid(objectModel))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este objeto no puede ser utilizado.");

	new Float:x, Float:y, Float:z, Float:a;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	GetXYInFrontOfPoint(x, y, a, x, y, 2.0);

	new objectid = Mapro_AddObject(maproid, objectModel, x, y, z, a, GetPlayerVirtualWorld(playerid));

	if(objectid)
	{
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Creado nuevo objeto ID %i, de modelo %i, en el proyecto ID %i.", objectid, objectModel, maproid);
		Mapro_OpenEditionForPlayer(maproid, objectid, playerid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de proyecto o modelo de objeto inválido, no hay más espacio en el proyecto, o está oculto.");
	}
	return 1;
}

Mapro_OpenEditionForPlayer(maproid, objectid, playerid)
{
	MaproHandlingData[playerid][e_MAPRO_HANDLING_ID] = maproid;
	MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID] = objectid;
	EditDynamicObject(playerid, objectid);
}

Mapro_Create(const maproName[MAPRO_MAX_NAME_LENGTH], playerid = INVALID_PLAYER_ID)
{
	if(isnull(maproName))
		return INVALID_MAPRO_ID;

	new maproid = Iter_Free(MaproData);

	if(maproid == ITER_NONE)
	{
		printf("[ERROR] Alcanzado MAPRO_MAX_AMOUNT (%i). Iter_Count: %i.", MAPRO_MAX_AMOUNT, Iter_Count(MaproData));
		return INVALID_MAPRO_ID;
	}

	MaproData[maproid][mpName][0] = EOS;
	strcat(MaproData[maproid][mpName], maproName, MAPRO_MAX_NAME_LENGTH);

	MaproData[maproid][mpStatus] = 1;
	MaproData[maproid][mpFaction] = 0;
	MaproData[maproid][mpRank] = 0;
	MaproData[maproid][mpObjectLimit] = 0;
	MaproData[maproid][mpModelFilter] = 0;

	for(new i = 0; i < MAPRO_MAX_MODELS_ALLOWED; i++) {
		MaproData[maproid][mpModelAllowed][i] = 0;
	}

	MaproData[maproid][mpOwnerSQLID] = 0;
	MaproData[maproid][mpOwnerName][0] = EOS;

	if(playerid != INVALID_PLAYER_ID)
	{
		MaproData[maproid][mpOwnerSQLID] = PlayerInfo[playerid][pID];
		GetPlayerName(playerid, MaproData[maproid][mpOwnerName], MAX_PLAYER_NAME);
	}

	for(new i = 0; i < MAPRO_MAX_PLAYERS_ALLOWED; i++)
	{
		MaproData[maproid][mpPlayerSQLIDAllowed][i] = 0;
		MaproData[maproid][mpPlayerNameAllowed][i * MAX_PLAYER_NAME] = EOS;
	}

	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `mapro` (`maproid`,`name`,`ownerid`,`ownername`) VALUES (%i,'%e',%i,'%s');", maproid, MaproData[maproid][mpName], MaproData[maproid][mpOwnerSQLID], MaproData[maproid][mpOwnerName]);
	mysql_tquery(MYSQL_HANDLE, query);

	Iter_Add(MaproData, maproid);
	return maproid;
}

Mapro_GetPlayerAccessLevel(maproid, playerid)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(!IsPlayerLogged(playerid))
		return 0;

	if(PlayerInfo[playerid][pID] == MaproData[maproid][mpOwnerSQLID])
		return MAPRO_ACCESS_LEVEL_OWNER;
	if(PlayerInfo[playerid][pAdmin] >= MaproGlobalAccessLevel)
		return MAPRO_ACCESS_LEVEL_OWNER;

	if(MaproData[maproid][mpFaction] && PlayerInfo[playerid][pFaction] == MaproData[maproid][mpFaction])
	{
		if(PlayerInfo[playerid][pRank] == 1) {
			return MAPRO_ACCESS_LEVEL_MANAGER;
		} else if(PlayerInfo[playerid][pRank] <= MaproData[maproid][mpRank]) {
			return MAPRO_ACCESS_LEVEL_MAPPER;
		}
	}

	for(new i = 0; i < MAPRO_MAX_PLAYERS_ALLOWED; i++)
	{
		if(MaproData[maproid][mpPlayerSQLIDAllowed][i] == PlayerInfo[playerid][pID]) {
			return MAPRO_ACCESS_LEVEL_MAPPER;
		}
	}

	if(PlayerInfo[playerid][pAdmin])
		return MAPRO_ACCESS_LEVEL_VIEWER;

	return MAPRO_ACCESS_LEVEL_NONE;
}

Mapro_Destroy(maproid)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;

	foreach(new slot : MaproObject[maproid]) {
		DestroyDynamicObject(MaproObject[maproid][slot][mpObjectID]);
	}

	foreach(new playerid : Player)
	{
		if(MaproHandlingData[playerid][e_MAPRO_HANDLING_ID] == maproid) {
			Mapro_ResetHandlingData(playerid);
		}
	}

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `mapro_object` WHERE `maproid`=%i;", maproid);
	mysql_tquery(MYSQL_HANDLE, query);

	mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `mapro` WHERE `maproid`=%i;", maproid);
	mysql_tquery(MYSQL_HANDLE, query);

	MaproData[maproid] = MaproData[MAPRO_RESET_ID];
	Iter_Clear(MaproObject[maproid]);
	Iter_Remove(MaproData, maproid);
	return 1;
}

Mapro_IsObjectModelAllowed(maproid, modelid)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(!MaproData[maproid][mpModelFilter])
		return 1;

	for(new i = 0; i < MAPRO_MAX_MODELS_ALLOWED; i++)
	{
		if(MaproData[maproid][mpModelAllowed][i] == modelid)
			return 1;
	}

	return 0;
}

Mapro_AddOrRemoveMapperPlayer(maproid, playerid = INVALID_PLAYER_ID, const name[MAX_PLAYER_NAME])
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;

	new free = -1;

	for(new i = 0; i < MAPRO_MAX_PLAYERS_ALLOWED; i++)
	{
		if(!MaproData[maproid][mpPlayerSQLIDAllowed][i]) {
			free = (free == -1) ? (i) : (free);
		}
		else if((playerid != INVALID_PLAYER_ID && MaproData[maproid][mpPlayerSQLIDAllowed][i] == PlayerInfo[playerid][pID]) ||
			(playerid == INVALID_PLAYER_ID && !strcmp(MaproData[maproid][mpPlayerNameAllowed][i * MAX_PLAYER_NAME], name)))
		{
			MaproData[maproid][mpPlayerSQLIDAllowed][i] = 0;
			MaproData[maproid][mpPlayerNameAllowed][i * MAX_PLAYER_NAME] = EOS;
			Mapro_SaveAllowedPlayers(maproid);
			return 1;
		}
	}

	if(free != -1 && IsPlayerLogged(playerid))
	{
		MaproData[maproid][mpPlayerSQLIDAllowed][free] = PlayerInfo[playerid][pID];
		GetPlayerName(playerid, MaproData[maproid][mpPlayerNameAllowed][free * MAX_PLAYER_NAME], MAX_PLAYER_NAME);
		Mapro_SaveAllowedPlayers(maproid);
		return 1;	
	}

	return 0;
}

Mapro_AddObject(maproid, modelid, Float:x, Float:y, Float:z, Float:rz, world, Float:streamdistance = STREAMER_OBJECT_SD)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(Iter_Count(MaproObject[maproid]) == MaproData[maproid][mpObjectLimit])
		return 0;
	if(!IsValidObjectModel(modelid))
		return 0;
	if(!MaproData[maproid][mpStatus])
		return 0;
	if(!Mapro_IsObjectModelAllowed(maproid, modelid))
		return 0;

	new slot = Iter_Free(MaproObject[maproid]);

	if(slot == ITER_NONE)
		return 0;

	MaproObject[maproid][slot][mpObjectID] = CreateDynamicObject(modelid, x, y, z, 0.0, 0.0, rz, .worldid = world, .streamdistance = streamdistance, .drawdistance = streamdistance);
	Mapro_SetDynamicObjectArrayData(MaproObject[maproid][slot][mpObjectID], DYN_OBJ_TYPE_MAPRO, maproid, slot);

	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `mapro_object` (`maproid`,`modelid`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`world`,`streamdistance`) VALUES (%i,%i,%f,%f,%f,%f,%f,%f,%i,%f);", maproid, modelid, x, y, z, 0.0, 0.0, rz, world, streamdistance);
	mysql_tquery(MYSQL_HANDLE, query, "MaproSQL_OnObjectAdded", "iii", maproid, slot, MaproObject[maproid][slot][mpObjectID]);

	Iter_Add(MaproObject[maproid], slot);
	return MaproObject[maproid][slot][mpObjectID];
}

forward MaproSQL_OnObjectAdded(maproid, slot, objectid);
public MaproSQL_OnObjectAdded(maproid, slot, objectid)
{
	new lastid = cache_insert_id();

	if(!Iter_Contains(MaproData, maproid) || !Iter_Contains(MaproObject[maproid], slot) || MaproObject[maproid][slot][mpObjectID] != objectid)
	{
		new query[64];
		mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `mapro_object` WHERE `objectid`=%i;", lastid);
		mysql_tquery(MYSQL_HANDLE, query);
	} else {
		MaproObject[maproid][slot][mpObjectSQLID] = lastid;
	}
	return 1;
}

Mapro_RemoveObject(playerid, objectid)
{
	new arrayData[e_MAPRO_DYN_OBJ_ARRAY_DATA] = {DYN_OBJ_TYPE_NONE, INVALID_MAPRO_ID, INVALID_MAPRO_SLOT_ID};

	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

	if(arrayData[e_MAPRO_DYN_OBJ_TYPE] != DYN_OBJ_TYPE_MAPRO)
		return 0;

	new maproid = arrayData[e_MAPRO_DYN_OBJ_MAPRO_ID];

	if(!Iter_Contains(MaproData, maproid) || maproid != MaproHandlingData[playerid][e_MAPRO_HANDLING_ID])
		return 0;

	new slot = arrayData[e_MAPRO_DYN_OBJ_SLOT];

	if(!Iter_Contains(MaproObject[maproid], slot) || MaproObject[maproid][slot][mpObjectID] != objectid || objectid != MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID])
		return 0;

	DestroyDynamicObject(objectid);

	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `mapro_object` WHERE `objectid`=%i;", MaproObject[maproid][slot][mpObjectSQLID]);
	mysql_tquery(MYSQL_HANDLE, query);

	Iter_Remove(MaproObject[maproid], slot);
	return 1;
}

CMD:maproe(playerid, params[])
{
	static maproeCooldown;

	new maproid;

	if(sscanf(params, "i", maproid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/maproe [ID proyecto]");
	if(gettime() <= maproeCooldown)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El comando fue utilizado recientemente, espera un instante.");
	if(Mapro_GetPlayerAccessLevel(maproid, playerid) < MAPRO_ACCESS_LEVEL_MAPPER)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID inválida o no estás autorizado para operar sobre ese proyecto.");

	new Float:x, Float:y, Float:z, STREAMER_TAG_OBJECT:objects[30], amount;

	GetPlayerPos(playerid, x, y, z);
	amount = Streamer_GetNearbyItems(x, y, z, STREAMER_TYPE_OBJECT, objects, sizeof(objects), 20.0, .worldid = GetPlayerVirtualWorld(playerid));

	new count, line[64], string[1000] = "ID Objeto\tID Modelo\tDistancia\n";

	for(new i = 0, arrayData[e_MAPRO_DYN_OBJ_ARRAY_DATA], Float:distance; i < amount && i < sizeof(objects); i++, arrayData[e_MAPRO_DYN_OBJ_TYPE] = DYN_OBJ_TYPE_NONE)
	{
		Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objects[i], E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

		if(arrayData[e_MAPRO_DYN_OBJ_TYPE] == DYN_OBJ_TYPE_MAPRO && arrayData[e_MAPRO_DYN_OBJ_MAPRO_ID] == maproid)
		{
			Streamer_GetDistanceToItem(x, y, z, STREAMER_TYPE_OBJECT, objects[i], distance);
			format(line, sizeof(line), "%i\t%i\t%.2fm\n", objects[i], Streamer_GetIntData(STREAMER_TYPE_OBJECT, objects[i], E_STREAMER_MODEL_ID), distance);
			strcat(string, line, sizeof(string));
			count++;
		}
	}

	if(count) {
		Dialog_Open(playerid, "DLG_MAPRO_CHOOSE_OBJECT", DIALOG_STYLE_TABLIST_HEADERS, "Objetos cercanos", string, "Editar", "Cerrar");
	} else {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontraron objetos cercanos del proyecto ID %i.", maproid);
	}

	maproeCooldown = gettime() + 2;
	return 1;
}

Dialog:DLG_MAPRO_CHOOSE_OBJECT(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	new objectid;

	if(sscanf(inputtext, "i", objectid) || !IsValidDynamicObject(objectid))
		return 1;

	new arrayData[e_MAPRO_DYN_OBJ_ARRAY_DATA];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));
	Mapro_ShowObjectMenu(arrayData[e_MAPRO_DYN_OBJ_MAPRO_ID], objectid, Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID), arrayData[e_MAPRO_DYN_OBJ_SLOT], playerid);
	return 1;
}

CMD:mapros(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
	{
		new maproid;

		if(sscanf(params, "i", maproid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mapros [ID proyecto]");
		if(Mapro_GetPlayerAccessLevel(maproid, playerid) < MAPRO_ACCESS_LEVEL_MAPPER)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás autorizado para operar sobre este proyecto.");
	}

	SelectObject(playerid);
	Noti_Create(playerid, 2500, "Entraste en el modo de selección de objeto");
	return 1;
}

OnGenericDynamicObjectSelection(playerid, STREAMER_TAG_OBJECT:objectid, modelid) {
	ShowObjectMenu(objectid, modelid, playerid);
}

ShowObjectMenu(STREAMER_TAG_OBJECT:objectid, modelid, playerid)
{
	if(PlayerInfo[playerid][pAdmin] < MaproGlobalAccessLevel || !AdminDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás autorizado para operar sobre este objeto.");

	new string[200];
	format(string, sizeof(string), "ID de objeto\t%i\nModelo\t%i\nTipo de objeto\t{FF3500}Base del servidor\n______________\n \n{EFEF00}<< Editar >>\n______________\n \n{FF0000}<< Borrar >>", objectid, modelid);
	Dialog_Open(playerid, "DLG_SHOW_OBJECT", DIALOG_STYLE_TABLIST, "Objeto seleccionado", string, "Aceptar", "Cerrar");
	MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID] = objectid;
	return 1;
}

Dialog:DLG_SHOW_OBJECT(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext) || !IsValidDynamicObject(MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID]))
		return Mapro_ResetHandlingData(playerid);

	if(!strcmp(inputtext, "<< Editar >>")) {
		Dialog_Open(playerid, "DLG_SHOW_OBJECT_CONFIRM", DIALOG_STYLE_INPUT, "confirmación de edición", " ¿estás seguro que deseas editar este objeto? Escribe 'EDITAR'.\nTen en cuenta que este es un objeto base creado por el servidor.", "Confirmar", "Cerrar");
	} else if(!strcmp(inputtext, "<< Borrar >>")) {
		Dialog_Open(playerid, "DLG_SHOW_OBJECT_CONFIRM", DIALOG_STYLE_INPUT, "confirmación de borrado", " ¿estás seguro que deseas borrar este objeto? Escribe 'BORRAR'.\n{FF3500}Ten en cuenta que este es un objeto base creado por el servidor.\nSi es utilizado por otro sistema, borrarlo podría significar inconsistencias o errores.", "Confirmar", "Cerrar");
	}
	return 1;
}

Dialog:DLG_SHOW_OBJECT_CONFIRM(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext) || !IsValidDynamicObject(MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID]))
		return Mapro_ResetHandlingData(playerid);

	if(!strcmp(inputtext, "EDITAR")) {
		Mapro_OpenEditionForPlayer(INVALID_MAPRO_ID, MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID], playerid);
	} else if(!strcmp(inputtext, "BORRAR")) {
		DestroyDynamicObject(MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID]);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Opción ingresada inválida.");
	}

	return Mapro_ResetHandlingData(playerid);
}

Mapro_OnDynamicObjectSelection(playerid, STREAMER_TAG_OBJECT:objectid, modelid)
{
	new arrayData[e_MAPRO_DYN_OBJ_ARRAY_DATA];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));
	Mapro_ShowObjectMenu(arrayData[e_MAPRO_DYN_OBJ_MAPRO_ID], objectid, modelid, arrayData[e_MAPRO_DYN_OBJ_SLOT], playerid);
}

Mapro_ShowObjectMenu(maproid, STREAMER_TAG_OBJECT:objectid, modelid, slot, playerid)
{
	if(!Iter_Contains(MaproData, maproid))
		return Mapro_ResetHandlingData(playerid);
	if(!Iter_Contains(MaproObject[maproid], slot))
		return Mapro_ResetHandlingData(playerid);
	if(MaproObject[maproid][slot][mpObjectID] != objectid)
		return Mapro_ResetHandlingData(playerid);
	if(Mapro_GetPlayerAccessLevel(maproid, playerid) < MAPRO_ACCESS_LEVEL_MAPPER)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás autorizado para operar sobre este objeto.");
		return Mapro_ResetHandlingData(playerid);
	}

	MaproHandlingData[playerid][e_MAPRO_HANDLING_ID] = maproid;
	MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID] = objectid;

	new string[256];

	format(string, sizeof(string),
			"ID de objeto\t%i\n\
			Modelo de objeto\t%i\n\
			Tipo de objeto\tProyecto\n\
			Proyecto asociado\t%s (ID %i)\n",
			objectid,
			modelid,
			MaproData[maproid][mpName],
			maproid
	);

	strcat(string, "_________________\n \n{EFEF00}<< Editar >>\n_________________\n \n{FF0000}<< Borrar >>", sizeof(string));
	Dialog_Open(playerid, "DLG_MAPRO_EDIT_OBJECT", DIALOG_STYLE_TABLIST, "Objeto seleccionado", string, "Aceptar", "Cerrar");
	return 1;
}

Dialog:DLG_MAPRO_EDIT_OBJECT(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext) || !IsValidDynamicObject(MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID]))
		return Mapro_ResetHandlingData(playerid);

	if(!strcmp(inputtext, "<< Editar >>")) {
		Mapro_OpenEditionForPlayer(MaproHandlingData[playerid][e_MAPRO_HANDLING_ID], MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID], playerid);
	}
	else if(!strcmp(inputtext, "<< Borrar >>"))
	{
		Mapro_RemoveObject(playerid, MaproHandlingData[playerid][e_MAPRO_HANDLING_OBJECT_ID]);
		Mapro_ResetHandlingData(playerid);
	}

	return 1;
}

OnGenericDynamicObjectEdition(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	Mapro_ResetHandlingData(playerid);

	if(response == EDIT_RESPONSE_FINAL)
	{
		if(PlayerInfo[playerid][pAdmin] < MaproGlobalAccessLevel)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás autorizado para operar sobre este objeto.");

		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);
	}
	return 1;
}

Mapro_OnDynamicObjectEdition(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
		new arrayData[e_MAPRO_DYN_OBJ_ARRAY_DATA] = {DYN_OBJ_TYPE_NONE, INVALID_MAPRO_ID, INVALID_MAPRO_SLOT_ID};

		Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

		if(arrayData[e_MAPRO_DYN_OBJ_TYPE] != DYN_OBJ_TYPE_MAPRO)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error asociado a los datos del objeto. Por favor reportar a la administración.");

		new maproid = arrayData[e_MAPRO_DYN_OBJ_MAPRO_ID];

		if(!Iter_Contains(MaproData, maproid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error asociado a los datos del objeto. Por favor reportar a la administración.");
		if(maproid != MaproHandlingData[playerid][e_MAPRO_HANDLING_ID])
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error asociado a los datos del objeto. Por favor reportar a la administración.");

		new slot = arrayData[e_MAPRO_DYN_OBJ_SLOT];

		if(!Iter_Contains(MaproObject[maproid], slot))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error asociado a los datos del objeto. Por favor reportar a la administración.");
		if(MaproObject[maproid][slot][mpObjectID] != objectid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error asociado a los datos del objeto. Por favor reportar a la administración.");

		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);

		new query[256];
		mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `mapro_object` SET `x`=%f,`y`=%f,`z`=%f,`rx`=%f,`ry`=%f,`rz`=%f WHERE `objectid`=%i;", x, y, z, rx, ry, rz, MaproObject[maproid][slot][mpObjectSQLID]);
		mysql_tquery(MYSQL_HANDLE, query);
	}

	Mapro_ResetHandlingData(playerid);
	return 1;
}

Mapro_ShowAllForPlayer(playerid)
{
	if(!Iter_Count(MaproData))
		return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay proyectos de mapeo creados en el servidor.");

	new line[128], string[3400] = "[ID]\tNombre\tEstado\n";

	foreach(new maproid : MaproData)
	{
		format(line, sizeof(line), "[%i]\t%s\t%s\n", maproid, MaproData[maproid][mpName], (MaproData[maproid][mpStatus]) ? ("{00FF00}ON") : ("{FF0000}OFF"));
		strcat(string, line, sizeof(string));
	}

	format(line, sizeof(line), "Se han encontrado %i proyectos de mapeo", Iter_Count(MaproData));
	Dialog_Open(playerid, "DLG_MAPRO_SHOW_ALL", DIALOG_STYLE_TABLIST_HEADERS, line, string, "Aceptar", "Cerrar");
	return 1;
}

Dialog:DLG_MAPRO_SHOW_ALL(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	new maproid = INVALID_MAPRO_ID;

	if(sscanf(inputtext, "p<]>'['i", maproid))
		return 1;
	if(!Mapro_ShowForPlayer(maproid, playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de proyecto inválida o no estás autorizado para ver este proyecto.");
	
	return 1;
}

Mapro_ShowForPlayer(maproid, playerid)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;

	new accessLevel = Mapro_GetPlayerAccessLevel(maproid, playerid);

	if(accessLevel < MAPRO_ACCESS_LEVEL_VIEWER)
		return 0;

	new line[128], string[1024] = "[#]\tCampo\tValor\n";

	format(line, sizeof(line), " \tNombre (ID)\t%s (ID %i)\n", MaproData[maproid][mpName], maproid);
	strcat(string, line, sizeof(string));

	if(strlen(MaproData[maproid][mpDescription]) < 68)
	{
		format(line, sizeof(line), "[1]\tDescripción\t%s\n", MaproData[maproid][mpDescription]);
		strcat(string, line, sizeof(string));
	}
	else
	{
		line = "[1]\tDescripción\t";
		strcat(line, MaproData[maproid][mpDescription], 81);
		strcat(line, "...\n", sizeof(line));
		strcat(string, line, sizeof(string));
		format(line, sizeof(line), " \t \t...%s\n", MaproData[maproid][mpDescription][64]);
		strcat(string, line, sizeof(string));
	}

	format(line, sizeof(line), "[2]\tEstado\t%s\n", (MaproData[maproid][mpStatus]) ? ("{00FF00}Activo") : ("{FF0000}Oculto"));
	strcat(string, line, sizeof(string));

	format(line, sizeof(line), "[3]\tfacción\tID %i (%s)\n", MaproData[maproid][mpFaction], FactionInfo[MaproData[maproid][mpFaction]][fName]);
	strcat(string, line, sizeof(string));

	format(line, sizeof(line), "[4]\tRango mínimo\t%i\n", MaproData[maproid][mpRank]);
	strcat(string, line, sizeof(string));		

	format(line, sizeof(line), " \tCreador del proyecto\t%s\n", MaproData[maproid][mpOwnerName]);
	strcat(string, line, sizeof(string));

	format(line, sizeof(line), "[5]\tLímite máximode objetos\t%i\n", MaproData[maproid][mpObjectLimit]);
	strcat(string, line, sizeof(string));

	format(line, sizeof(line), "[6]\tFiltro por modelo de objeto\t%s\n", (MaproData[maproid][mpModelFilter]) ? ("{00FF00}ON") : ("{FF0000}OFF"));
	strcat(string, line, sizeof(string));

	if(MaproData[maproid][mpModelFilter])
	{
		line = "[7]\tModelos de objeto habilitados\t";
		for(new i = 0; i < MAPRO_MAX_MODELS_ALLOWED; i++)
		{
			if(MaproData[maproid][mpModelAllowed][i]) {
				format(line, sizeof(line), "%s(%i) ", line, MaproData[maproid][mpModelAllowed][i]);
			}
		}
		strcat(line, "\n", sizeof(line));
		strcat(string, line, sizeof(string));		
	}

	line = "[8]\tJugadores habilitados\t";
	for(new i = 0; i < MAPRO_MAX_PLAYERS_ALLOWED; i++)
	{
		if(MaproData[maproid][mpPlayerSQLIDAllowed][i]) {
			format(line, sizeof(line), "%s(%s) ", line, MaproData[maproid][mpPlayerNameAllowed][i * MAX_PLAYER_NAME]);
		}
	}
	strcat(line, "\n", sizeof(line));
	strcat(string, line, sizeof(string));

	format(line, sizeof(line), " \tCantidad de objetos creados\t%i\n", Iter_Count(MaproObject[maproid]));
	strcat(string, line, sizeof(string));

	if(accessLevel >= MAPRO_ACCESS_LEVEL_MANAGER) {
		strcat(string, " \n \t{EFEF00}Haz click en la opción a configurar\n", sizeof(string));
	}

	if(accessLevel >= MAPRO_ACCESS_LEVEL_OWNER) {
		strcat(string, " \n[9]\t{FF0000}<< Borrar proyecto >>", sizeof(string));
	}

	Dialog_Open(playerid, "DLG_MAPRO_SHOW", DIALOG_STYLE_TABLIST_HEADERS, "Proyecto de mapeo", string, "Aceptar", "Cerrar");
	MaproHandlingData[playerid][e_MAPRO_HANDLING_ID] = maproid;
	return 1;
}

static enum e_MAPRO_OPTION
{
	MAPRO_OPTION_DESC = 1,
	MAPRO_OPTION_STATUS,
	MAPRO_OPTION_FACTION,
	MAPRO_OPTION_RANK,
	MAPRO_OPTION_MAX_OBJ,
	MAPRO_OPTION_FILTER_OBJ,
	MAPRO_OPTION_ALLOWED_OBJ,
	MAPRO_OPTION_ALLOWED_PLAYERS,
	MAPRO_OPTION_DELETE
}

static const MAPRO_OPTION_LEVEL[] = {
	cellmax,
	MAPRO_ACCESS_LEVEL_MANAGER,
	MAPRO_ACCESS_LEVEL_MANAGER,
	MAPRO_ACCESS_LEVEL_OWNER,
	MAPRO_ACCESS_LEVEL_MANAGER,
	MAPRO_ACCESS_LEVEL_MANAGER,
	MAPRO_ACCESS_LEVEL_OWNER,
	MAPRO_ACCESS_LEVEL_OWNER,
	MAPRO_ACCESS_LEVEL_MANAGER,
	MAPRO_ACCESS_LEVEL_OWNER
};

Dialog:DLG_MAPRO_SHOW(playerid, response, listitem, inputtext[])
{
	new maproid = MaproHandlingData[playerid][e_MAPRO_HANDLING_ID];

	if(!response || !Iter_Contains(MaproData, maproid))
		return Mapro_ResetHandlingData(playerid);

	new option;

	if(sscanf(inputtext, "p<]>'['i", option) || !(0 < option < _:e_MAPRO_OPTION))
		return Mapro_ShowForPlayer(maproid, playerid);

	new accessLevel = Mapro_GetPlayerAccessLevel(maproid, playerid);

	if(accessLevel < MAPRO_ACCESS_LEVEL_MANAGER)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás autorizado para editar este proyecto.");
		return Mapro_ShowForPlayer(maproid, playerid);
	}

	if(accessLevel < MAPRO_OPTION_LEVEL[option])
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás autorizado para editar este campo.");
		return Mapro_ShowForPlayer(maproid, playerid);
	}

	switch(option)
	{
		case MAPRO_OPTION_DESC: Dialog_Open(playerid, "DLG_MAPRO_OPTION_EDIT", DIALOG_STYLE_INPUT, "Descripción", "Escribe la Descripción del proyecto.", "Aceptar", "Cancelar");
		case MAPRO_OPTION_STATUS: Dialog_Open(playerid, "DLG_MAPRO_OPTION_EDIT", DIALOG_STYLE_INPUT, "Cambiar estado", "Escriba el estado que desea configurar.\nUse 'ACTIVO' u 'OCULTO'.\n{FF0000}Ten en cuenta que ocultar un proyecto implica quitar sus objetos del mundo.", "Aceptar", "Cancelar");
		case MAPRO_OPTION_FACTION: Dialog_Open(playerid, "DLG_MAPRO_OPTION_EDIT", DIALOG_STYLE_INPUT, "Cambiar facción", "Ingrese la ID de facción.\nSetear 0 invalida el uso faccionario.", "Aceptar", "Cancelar");
		case MAPRO_OPTION_RANK: Dialog_Open(playerid, "DLG_MAPRO_OPTION_EDIT", DIALOG_STYLE_INPUT, "Rango mínimo", "Ingrese el rango mínimo a partir del cual se podrá alterar el proyecto.", "Aceptar", "Cancelar");
		case MAPRO_OPTION_MAX_OBJ: Dialog_Open(playerid, "DLG_MAPRO_OPTION_EDIT", DIALOG_STYLE_INPUT, "Límite de objetos", "Ingrese el nuevo valor.\nMín: cantidad actual de objetos o 1.\nMáx: "#MAPRO_MAX_OBJECTS_AMOUNT"", "Aceptar", "Cancelar");
		case MAPRO_OPTION_FILTER_OBJ: Dialog_Open(playerid, "DLG_MAPRO_OPTION_EDIT", DIALOG_STYLE_INPUT, "Cambiar filtro de modelos de objeto", "Se cambiará el estado del filtro actual al estado opuesto. Escriba 'OK' para confirmar.", "Aceptar", "Cancelar");
		case MAPRO_OPTION_ALLOWED_OBJ: Dialog_Open(playerid, "DLG_MAPRO_OPTION_EDIT", DIALOG_STYLE_INPUT, "Modelos de objeto habilitados", "Ingrese el ID del modelo de objeto a agregar/quitar.", "Aceptar", "Cancelar");
		case MAPRO_OPTION_ALLOWED_PLAYERS: Dialog_Open(playerid, "DLG_MAPRO_OPTION_EDIT", DIALOG_STYLE_INPUT, "Permisos a jugadores", "Ingrese el nombre completo (con '_') del jugador a agregar/quitar.", "Aceptar", "Cancelar");
		case MAPRO_OPTION_DELETE: Dialog_Open(playerid, "DLG_MAPRO_OPTION_EDIT", DIALOG_STYLE_INPUT, "Borrar proyecto", " ¿está seguro de borrar el proyecto?\nEscriba 'BORRAR'.", "Aceptar", "Cancelar");
	}

	MaproHandlingData[playerid][e_MAPRO_HANDLING_OPTION] = option;
	return 1;
}

Dialog:DLG_MAPRO_OPTION_EDIT(playerid, response, listitem, inputtext[])
{
	new maproid = MaproHandlingData[playerid][e_MAPRO_HANDLING_ID];

	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(!response || isnull(inputtext))
		return Mapro_ShowForPlayer(maproid, playerid);

	switch(MaproHandlingData[playerid][e_MAPRO_HANDLING_OPTION])
	{
		case MAPRO_OPTION_DESC: {
			Mapro_SetDescription(maproid, inputtext);
		}
		case MAPRO_OPTION_STATUS:
		{
			if(!strcmp(inputtext, "ACTIVO", true)) {
				Mapro_SetStatus(maproid, .status = 1);
			} else if(!strcmp(inputtext, "OCULTO", true)) {
				Mapro_SetStatus(maproid, .status = 0);
			} else {
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Opción ingresada inválida.");
			}
		}
		case MAPRO_OPTION_FACTION:
		{
			new factionid;

			if(sscanf(inputtext, "i", factionid) || !Mapro_SetFaction(maproid, factionid)) {
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"facción inválida.");
			}
		}
		case MAPRO_OPTION_RANK:
		{
			new rank;

			if(sscanf(inputtext, "i", rank) || !Mapro_SetRank(maproid, rank)) {
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Rango inválido.");
			}
		}
		case MAPRO_OPTION_MAX_OBJ:
		{
			new limit;

			if(sscanf(inputtext, "i", limit) || !Mapro_SetObjectLimit(maproid, limit)) {
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Límite inválido o el proyecto está oculto.");
			}
		}
		case MAPRO_OPTION_FILTER_OBJ: {
			Mapro_ToggleModelFilter(maproid);
		}
		case MAPRO_OPTION_ALLOWED_OBJ:
		{
			new modelid;

			if(sscanf(inputtext, "i", modelid) || (!Mapro_RemoveModelAllowed(maproid, modelid) && !Mapro_AddModelAllowed(maproid, modelid))) {
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de modelo inválida o se alcanzó el Límite de modelos habilitados.");
			}
		}
		case MAPRO_OPTION_ALLOWED_PLAYERS:
		{
			new targetid = INVALID_PLAYER_ID, name[MAX_PLAYER_NAME] = "_";

			if((sscanf(inputtext, "u", targetid) && sscanf(inputtext, "s[24]", name)) || !Mapro_AddOrRemoveMapperPlayer(maproid, targetid, name)) {
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nombre de jugador inválido o ya tiene permiso.");
			} else if(targetid != INVALID_PLAYER_ID) {
				SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s te otorgó o quitó acceso al proyecto de mapeo '%s'.", GetPlayerCleanName(playerid), MaproData[maproid][mpName]); 
			}
		}
		case MAPRO_OPTION_DELETE:
		{
			if(!strcmp(inputtext, "BORRAR", true))
			{
				if(Mapro_Destroy(maproid))
				{
					SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has borrado el proyecto correctamente.");
					new string[128];
					format(string, sizeof(string), "[MAPRO] %s ha borrado el proyecto ID %i correctamente.", GetPlayerCleanName(playerid), maproid);
					AdministratorMessage(COLOR_ADMINCMD, string, 2);
					return Mapro_ResetHandlingData(playerid);
				}
			} else {
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Opción ingresada inválida.");
			}
		}
		default: {
			return Mapro_ResetHandlingData(playerid);
		}
	}

	Mapro_ShowForPlayer(maproid, playerid);
	return 1;
}

static Mapro_SetObjectLimit(maproid, limit)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(!(Iter_Count(MaproObject[maproid]) <= limit <= MAPRO_MAX_OBJECTS_AMOUNT))
		return 0;
	if(!MaproData[maproid][mpStatus])
		return 0;

	MaproData[maproid][mpObjectLimit] = limit;

	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `mapro` SET `object_limit`=%i WHERE `maproid`=%i;", limit, maproid);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

static Mapro_SetFaction(maproid, factionid)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(factionid && !Faction_IsValidId(factionid))
		return 0;

	MaproData[maproid][mpFaction] = factionid;

	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `mapro` SET `faction`=%i WHERE `maproid`=%i;", factionid, maproid);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

static Mapro_SetRank(maproid, rank)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(!Faction_IsValidRank(rank))
		return 0;

	MaproData[maproid][mpRank] = rank;

	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `mapro` SET `rank`=%i WHERE `maproid`=%i;", rank, maproid);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

static Mapro_ToggleModelFilter(maproid)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;

	MaproData[maproid][mpModelFilter] = !MaproData[maproid][mpModelFilter];

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `mapro` SET `model_filter`=%i WHERE `maproid`=%i;", MaproData[maproid][mpModelFilter], maproid);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

static Mapro_AddModelAllowed(maproid, modelid)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(!IsValidObjectModel(modelid))
		return 0;

	for(new i = 0; i < MAPRO_MAX_MODELS_ALLOWED; i++)
	{
		if(!MaproData[maproid][mpModelAllowed][i])
		{
			MaproData[maproid][mpModelAllowed][i] = modelid;
			Mapro_SaveAllowedModels(maproid);
			return 1;
		}
	}
	return 0;
}

static Mapro_RemoveModelAllowed(maproid, modelid)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(!IsValidObjectModel(modelid))
		return 0;

	for(new i = 0; i < MAPRO_MAX_MODELS_ALLOWED; i++)
	{
		if(MaproData[maproid][mpModelAllowed][i] == modelid)
		{
			MaproData[maproid][mpModelAllowed][i] = 0;
			Mapro_SaveAllowedModels(maproid);
			return 1;
		}
	}
	return 0;
}

static Mapro_SetDescription(maproid, const description[])
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;

	MaproData[maproid][mpDescription][0] = EOS;
	strcat(MaproData[maproid][mpDescription], description, MAPRO_MAX_DESC_LENGTH);

	new query[300];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `mapro` SET `description`='%e' WHERE `maproid`=%i;", description, maproid);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

static Mapro_SetStatus(maproid, status)
{
	static MaproToggleStatusCooldown[MAPRO_MAX_AMOUNT];

	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(MaproData[maproid][mpStatus] == status)
		return 0;
	if(gettime() <= MaproToggleStatusCooldown[maproid] + 30)
		return 0;

	if(!status)
	{
		foreach(new slot : MaproObject[maproid]) {
			DestroyDynamicObject(MaproObject[maproid][slot][mpObjectID]);
		}

		Iter_Clear(MaproObject[maproid]);
		MaproData[maproid][mpStatus] = 0;
	}
	else
	{
		MaproData[maproid][mpStatus] = 1;
		Mapro_LoadObjects(maproid);
	}

	MaproToggleStatusCooldown[maproid] = gettime();

	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `mapro` SET `status`=%i WHERE `maproid`=%i;", MaproData[maproid][mpStatus], maproid);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

static Mapro_SaveAllowedPlayers(maproid)
{
	new id_str[64], name_str[256];

	for(new i = 0; i < MAPRO_MAX_PLAYERS_ALLOWED; i++)
	{
		if(MaproData[maproid][mpPlayerSQLIDAllowed][i])
		{
			format(id_str, sizeof(id_str), "%s%i,", id_str, MaproData[maproid][mpPlayerSQLIDAllowed][i]);
			format(name_str, sizeof(name_str), "%s%s,", name_str, MaproData[maproid][mpPlayerNameAllowed][i * MAX_PLAYER_NAME]);
		}
	}

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `mapro` SET `playerid_allowed`='%s',`playername_allowed`='%s' WHERE `maproid`=%i;", id_str, name_str, maproid);
	mysql_tquery(MYSQL_HANDLE, query);
}

static Mapro_SaveAllowedModels(maproid)
{
	new model_str[256];

	for(new i = 0; i < MAPRO_MAX_MODELS_ALLOWED; i++)
	{
		if(MaproData[maproid][mpModelAllowed][i]) {
			format(model_str, sizeof(model_str), "%s%i,", model_str, MaproData[maproid][mpModelAllowed][i]);
		}
	}

	new query[320];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `mapro` SET `model_allowed`='%s' WHERE `maproid`=%i;", model_str, maproid);
	mysql_tquery(MYSQL_HANDLE, query);
}

Mapro_LoadObjects(maproid)
{
	new query[180];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT `objectid`,`modelid`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`world`,`streamdistance` FROM `mapro_object` WHERE `maproid`=%i LIMIT %i;", maproid, MAPRO_MAX_OBJECTS_AMOUNT);
	mysql_tquery(MYSQL_HANDLE, query, "Mapro_OnObjectsLoad", "i", maproid);
}

forward Mapro_OnObjectsLoad(maproid);
public Mapro_OnObjectsLoad(maproid)
{
	if(!Iter_Contains(MaproData, maproid))
		return 0;
	if(!MaproData[maproid][mpStatus])
		return 0;

	new rows = cache_num_rows(), modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, world, Float:streamdistance;

	for(new i, slot; i < rows; i++)
	{
		slot = Iter_Alloc(MaproObject[maproid]);

		if(slot == INVALID_ITERATOR_SLOT)
			return printf("[ERROR] Imposible asignar un nuevo slot en mapro ID %i durante la carga de objetos. Iter_Count: %i.", maproid, Iter_Count(MaproObject[maproid]));

		cache_get_value_index_int(i, 0, MaproObject[maproid][slot][mpObjectSQLID]);
		cache_get_value_index_int(i, 1, modelid);
		cache_get_value_index_float(i, 2, x);
		cache_get_value_index_float(i, 3, y);
		cache_get_value_index_float(i, 4, z);
		cache_get_value_index_float(i, 5, rx);
		cache_get_value_index_float(i, 6, ry);
		cache_get_value_index_float(i, 7, rz);
		cache_get_value_index_int(i, 8, world);
		cache_get_value_index_float(i, 9, streamdistance);

		MaproObject[maproid][slot][mpObjectID] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, .worldid = world, .streamdistance = streamdistance, .drawdistance = streamdistance);
		Mapro_SetDynamicObjectArrayData(MaproObject[maproid][slot][mpObjectID], DYN_OBJ_TYPE_MAPRO, maproid, slot);
	}
	return 1;
}

Mapro_IsForbiddenModelid(modelid) {
	return (modelid == 1529 || modelid == 1490 || modelid == 1524 || modelid == 1530 || modelid == 1531 || modelid == 1528 || modelid == 1527 || modelid == 1526 || modelid == 1525);
}