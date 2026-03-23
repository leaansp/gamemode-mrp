#if defined _marp_objects_included
	#endinput
#endif
#define _marp_objects_included

//=============================OBJECT SYSTEM====================================

#define MAX_SERVER_OBJECTS   	500
#define SERVER_OBJECT_LIFETIME  300 // En minutos
#define SERVER_OBJECT_UPD_TIME  10 // Cada diez minutos

//==============================DATA STORAGE====================================

enum ObjectsInfo {
	sItemID, //almacena la id de la tabla de objetos
	sAmount, //almacena la cantidad del objeto(parámetro para armas y etcétera)
	Float:sX, //coordenada X
	Float:sY, //coordenada Y
	Float:sZ, //coordenada Z
	sLastPlayerName[MAX_PLAYER_NAME], //Almacena el nombre del jugador que tiró el objeto ((futuro sist de investigación de huellas)
	sRealObject,
	sTimeLeft
};

new ServerObject[MAX_SERVER_OBJECTS][ObjectsInfo];

//==============================FUNCIONES=======================================

forward DropObject(playerid, playerhand); //Deposita un objeto en el suelo y devuelve 1. Si el jugador no esta de pie retorna 0, en caso de error retorna -1
forward TakeObject(playerid, playerhand); //Toma un objecto del suelo y devuelve 1. Si el jugador no pudo tomarlo retorna 0.
forward ResetObject(pos); //Resetea los valores del índice que se le indica.
forward ServerObjectsCleaningTimer(); // Limpia los objetos con mucho tiempo de vida
forward LookObject(playerid); // Permite al jugador examinar un objeto sin agarrarlo.
forward GetClosestObject(playerid); // Devuelve el index del objeto mas cercano. Retorna -1 si no hay un objeto cercano.

//=======================IMPLEMENTACIÓN DE FUNCIONES============================

public ServerObjectsCleaningTimer()
{
	for(new i = 0; i < MAX_SERVER_OBJECTS; i++)
	{
	    if(ServerObject[i][sItemID] > 0)
	    {
	        if(ServerObject[i][sTimeLeft] > 0)
	            ServerObject[i][sTimeLeft] -= SERVER_OBJECT_UPD_TIME;
			else
			    DestroyServerObject(i);
		}
	}
	return 1;
}

ServerObjects_OnServerShutDown()
{
	for(new i = 0; i < MAX_SERVER_OBJECTS; i++)
	{
	    if(ServerObject[i][sItemID] > 0)
	    {
	    	if(ItemModel_GetType(ServerObject[i][sItemID]) == ITEM_CONTAINER)
			{
				Container_Fully_Destroy(ServerObject[i][sAmount], Container_GetSQLID(ServerObject[i][sAmount]));
			}
		}
	}
	return 1;
}

stock DropObject(playerid, playerhand)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar a pie!");
	if(!GetHandItem(playerid, playerhand))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No ningún item para tirar en esa mano.");
	if(!ItemModel_HasTag(GetHandItem(playerid, playerhand), ITEM_TAG_THROW))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes tirar ese item.");

 	new j = -1;
	for(new i = 0; i < MAX_SERVER_OBJECTS; i++)
	{
		if(ServerObject[i][sItemID] == 0)
		{
			j = i;
			break;
		}
	}
	if(j == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ERROR] Se ha alcanzado el máximo de objetos permitidos, reportar a un administrador.");

	ServerObject[j][sItemID] = GetHandItem(playerid, playerhand);
	ServerObject[j][sAmount] = GetHandParam(playerid, playerhand);
	GetPlayerName(playerid, ServerObject[j][sLastPlayerName], MAX_PLAYER_NAME);
	GetPlayerPos(playerid, ServerObject[j][sX], ServerObject[j][sY], ServerObject[j][sZ]);
	ServerObject[j][sZ] -= 0.7;
	SetHandItemAndParam(playerid, playerhand, 0, 0);
	ServerObject[j][sRealObject] = CreateDynamicObject(ItemModel_GetObjectModel(ServerObject[j][sItemID]), ServerObject[j][sX], ServerObject[j][sY], ServerObject[j][sZ], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    ServerObject[j][sTimeLeft] = SERVER_OBJECT_LIFETIME;
	SendFMessage(playerid, COLOR_WHITE, "Has depositado un/a %s en el suelo.", ItemModel_GetName(ServerObject[j][sItemID]) );
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);

	if(ItemModel_GetType(ServerObject[j][sItemID]) == ITEM_WEAPON) {
		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/tirar", .playerid=playerid, .params=<"%i %s", ServerObject[j][sAmount], ItemModel_GetName(ServerObject[j][sItemID])>);
	} else if(ServerObject[j][sItemID] == ITEM_ID_DINERO) {
		ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="/tirar", .playerid=playerid, .params=<"$%i x: %.2f y: %.2f z: %.2f", ServerObject[j][sAmount], ServerObject[j][sX], ServerObject[j][sY], ServerObject[j][sZ]>);
	}
	return 1;
}

stock GetClosestObject(playerid)
{
	for(new i = 0; i < MAX_SERVER_OBJECTS; i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 1.4, ServerObject[i][sX], ServerObject[i][sY], ServerObject[i][sZ]))
	        return i;
	}
	return -1;
}

stock LookObject(playerid)
{
	new object = GetClosestObject(playerid);
	
	if(object == -1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ningún objeto cerca tuyo.");

	SendFMessage(playerid, COLOR_WHITE, "Examinas el objeto y ves un/a: %s - %s: %d", ItemModel_GetName(ServerObject[object][sItemID]), ItemModel_GetParamName(ServerObject[object][sItemID]), ServerObject[object][sAmount]);
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	return 1;
}

stock TakeObject(playerid, playerhand)
{
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡No puedes utilizar esto estando incapacitado/congelado!");
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_YELLOW2, "¡Debes estar a pie!");
	if(GetHandItem(playerid, playerhand) != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes agarrar nada ya que tienes un item en esa mano.");

	new object = GetClosestObject(playerid);
	if(object == -1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ningun objeto cerca tuyo.");

	SetHandItemAndParam(playerid, playerhand, ServerObject[object][sItemID], ServerObject[object][sAmount]);
	SendFMessage(playerid, COLOR_WHITE, "Has agarrado un/a %s del suelo.", ItemModel_GetName(ServerObject[object][sItemID]));
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.1, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);

	if(ItemModel_GetType(ServerObject[object][sItemID]) == ITEM_WEAPON) {
		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/agarrar", .playerid=playerid, .params=<"%i %s", ServerObject[object][sAmount], ItemModel_GetName(ServerObject[object][sItemID])>);
	} else if(ServerObject[object][sItemID] == ITEM_ID_DINERO) {
		ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="/agarrar", .playerid=playerid, .params=<"$%i x: %.2f y: %.2f z: %.2f", ServerObject[object][sAmount], ServerObject[object][sX], ServerObject[object][sY], ServerObject[object][sZ]>);
	}

	ResetObject(object);
	return 1;
}

stock TakeOneObject(playerid, playerhand)
{
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡No puedes utilizar esto estando incapacitado/congelado!");
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_YELLOW2, "¡Debes estar a pie!");
	if(GetHandItem(playerid, playerhand) != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes agarrar nada ya que tienes un item en esa mano.");

	new object = GetClosestObject(playerid);
	if(object == -1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ningun objeto cerca tuyo.");

	if(ItemModel_GetType(ServerObject[object][sItemID]) != ITEM_BATCH)
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡No puedes hacer esto con este objeto!");

	new ItemBatch_dataId = ItemModel_GetExtraId(ServerObject[object][sItemID]);

    if (!ItemBatch_IsValidDataId(ItemBatch_dataId))
        return 0;

    new unitItemId = ItemBatch_GetUnitItemId(ItemBatch_dataId);
	ServerObject[object][sAmount] -= 1;
	SetHandItemAndParam(playerid, playerhand, unitItemId, ItemModel_GetParamDefaultValue(unitItemId));
	SendFMessage(playerid, COLOR_WHITE, "Has agarrado un/a %s del suelo.", ItemModel_GetName(unitItemId));
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	if (ServerObject[object][sAmount] <= 0)
		ResetObject(object);
	
	return 1;
}

stock DestroyServerObject(pos)
{
	if(ItemModel_GetType(ServerObject[pos][sItemID]) == ITEM_CONTAINER)
	{
		Container_Fully_Destroy(ServerObject[pos][sAmount], Container_GetSQLID(ServerObject[pos][sAmount]));
	}
    ServerObject[pos][sItemID] = 0;
    ServerObject[pos][sAmount] = 0;
    ServerObject[pos][sX] = 0.0;
    ServerObject[pos][sY] = 0.0;
    ServerObject[pos][sZ] = 0.0;
    ServerObject[pos][sTimeLeft] = 0;
    strmid(ServerObject[pos][sLastPlayerName], "NULL", 0, strlen("NULL"), MAX_PLAYER_NAME);
	if(ServerObject[pos][sRealObject] > 0)
	{
		DestroyDynamicObject(ServerObject[pos][sRealObject]);
		ServerObject[pos][sRealObject] = 0;
	}
	return 1;
}
	
stock ResetObject(pos)
{
    ServerObject[pos][sItemID] = 0;
    ServerObject[pos][sAmount] = 0;
    ServerObject[pos][sX] = 0.0;
    ServerObject[pos][sY] = 0.0;
    ServerObject[pos][sZ] = 0.0;
    ServerObject[pos][sTimeLeft] = 0;
    strmid(ServerObject[pos][sLastPlayerName], "NULL", 0, strlen("NULL"), MAX_PLAYER_NAME);
	if(ServerObject[pos][sRealObject] > 0)
	{
		DestroyDynamicObject(ServerObject[pos][sRealObject]);
		ServerObject[pos][sRealObject] = 0;
	}
	return 1;
}

//================================COMANDOS======================================

CMD:examinar(playerid, params[])
{
    if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡No puedes utilizar esto estando incapacitado/congelado!");
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_YELLOW2, "¡Debes estar a pie!");
	    
	LookObject(playerid);
	return 1;
}

