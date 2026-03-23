#if defined marp_furniture_common_inc
	#endinput
#endif
#define marp_furniture_common_inc

#include <YSI_Coding\y_hooks>

const Float:FURN_SELLING_PRICE_RATIO = 0.5;
const Float:FURN_DYN_OBJ_STREAM_DISTANCE = 100.0;

enum e_FURN_INSTANCE_DATA
{
	fuFurnModelID,
	fuObjectSQLID,
	fuObjectID
}

enum e_FURN_TYPE
{
	FURN_TYPE_NONE = 0,
	FURN_TYPE_HOUSE,
	FURN_TYPE_BIZ
}

static enum e_FURN_DYN_OBJ_ARRAY_DATA
{
	e_DYN_OBJ_TYPE:e_FURN_DYN_OBJ_TYPE,
	e_FURN_TYPE:e_FURN_DYN_OBJ_PROP_TYPE,
	e_FURN_DYN_OBJ_PROP_ID,
	e_FURN_DYN_OBJ_FURN_MODEL_ID,
	e_FURN_DYN_OBJ_SLOT
}

enum e_FURN_HANDLING_CASE
{
	FURN_HANDLING_CASE_EDIT = 1,
	FURN_HANDLING_CASE_EDIT_PREVIEW
}

enum e_FURN_HANDLING_DATA
{
	e_FURN_TYPE:fuHandlingType,
	fuHandlingPropertyID,
	e_FURN_HANDLING_CASE:fuHandlingCase,
	fuHandlingObjectID,
	fuHandlingFurnModelID,
	fuHandlingSlot
}

new FurnHandlingData[MAX_PLAYERS + 1][e_FURN_HANDLING_DATA];
const FURN_HANDLING_DATA_RESET_ID = MAX_PLAYERS;

Furn_CheckHandling(playerid, e_FURN_TYPE:type, propid) {
	return (FurnHandlingData[playerid][fuHandlingType] == type && FurnHandlingData[playerid][fuHandlingPropertyID] == propid);
}

hook OnPlayerDisconnect(playerid, reason)
{
	FurnHandlingData[playerid] = FurnHandlingData[FURN_HANDLING_DATA_RESET_ID];
	return 1;
}

Furn_SetDynamicObjectArrayData(STREAMER_TAG_OBJECT:objectid, e_DYN_OBJ_TYPE:type, e_FURN_TYPE:proptype, propid, furnmodelid, slot)
{
	new arrayData[e_FURN_DYN_OBJ_ARRAY_DATA];

	arrayData[e_FURN_DYN_OBJ_TYPE] = type;
	arrayData[e_FURN_DYN_OBJ_PROP_TYPE] = proptype;
	arrayData[e_FURN_DYN_OBJ_PROP_ID] = propid;
	arrayData[e_FURN_DYN_OBJ_FURN_MODEL_ID] = furnmodelid;
	arrayData[e_FURN_DYN_OBJ_SLOT] = slot;

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));	
}

CMD:muebles(playerid, params[])
{
	new houseid, bizid;

	if((houseid = House_IsPlayerInAny(playerid)) && (House_IsPlayerOwner(playerid, houseid) || Furn_HasManagementAccessHouse(playerid, houseid))) {
		Furn_EntryPointHouse(playerid, houseid);
	} else if((bizid = Biz_IsPlayerInsideAny(playerid)) && Business[bizid][bInsideWorld] && (Biz_IsPlayerOwner(playerid, bizid) || Furn_HasManagementAccessBiz(playerid, bizid))) {
		Furn_EntryPointBiz(playerid, bizid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en tu casa o negocio, o en una propiedad en la que estés habilitado para la gestión de muebles.");
	}

	return 1;
}

CMD:amuebles(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new houseid, bizid;

	if((houseid = House_IsPlayerOutOrInAny(playerid))) {
		Furn_EntryPointHouse(playerid, houseid);
	} else if((bizid = Biz_IsPlayerOutsideOrInsideAny(playerid))) {
		Furn_EntryPointBiz(playerid, bizid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en una casa o negocio.");
	}

	return 1;
}

Furn_ShowMainMenu(playerid)
{
	switch(FurnHandlingData[playerid][fuHandlingType])
	{
		case FURN_TYPE_HOUSE: Dialog_Open(playerid, "DLG_FURN_MAIN_MENU", DIALOG_STYLE_LIST, "Mi casa", "Comprar muebles\nMis muebles\nVer muebles cercanos\nModo selección de mueble\nDar acceso a gestión de muebles", "Continuar", "Cerrar");
		case FURN_TYPE_BIZ: Dialog_Open(playerid, "DLG_FURN_MAIN_MENU", DIALOG_STYLE_LIST, "Mi negocio", "Comprar muebles\nMis muebles\nVer muebles cercanos\nModo selección de mueble\nDar acceso a gestión de muebles", "Continuar", "Cerrar");
	}
	return 1;
}

Dialog:DLG_FURN_MAIN_MENU(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 0;

	switch(listitem)
	{
		case 0: FurnCateg_ShowAllMenu(playerid);
		case 1: Furn_ShowMyFurnituresMenu(playerid);
		case 2: Furn_ShowNearest(playerid);
		case 3: Furn_EnterSelectionMode(playerid);
		case 4: Furn_ShowAccessMenu(playerid);
	}

	return 1;
}

PMM_OnItemSelected:Furn_CategoryMenuResponse(playerid, listitem, extraid)
{
	PMM_Close(playerid);

	if(!FurnModel_IsValidId(extraid))
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El mueble seleccionado es inválido. Por favor reportar a la administración con el siguiente ID: %i.", extraid);
		return 1;
	}

	new Float:x, Float:y, Float:z, Float:rz;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, rz);
	GetXYInFrontOfPoint(x, y, rz, x, y, 2.0);

	switch(FurnHandlingData[playerid][fuHandlingType])
	{
		case FURN_TYPE_HOUSE: Furn_CategoryMenuResponseHouse(playerid, extraid, x, y, z, 0.0, 0.0, rz + 90.0);
		case FURN_TYPE_BIZ: Furn_CategoryMenuResponseBiz(playerid, extraid, x, y, z, 0.0, 0.0, rz + 90.0);
	}
	return 1;
}

Furn_ShowMyFurnituresMenu(playerid)
{
	switch(FurnHandlingData[playerid][fuHandlingType])
	{
		case FURN_TYPE_HOUSE: Furn_ShowMyHouse(playerid);
		case FURN_TYPE_BIZ: Furn_ShowMyBiz(playerid);
	}
}

Furn_ShowNearest(playerid)
{
	static furnShowNearCooldown;

	if(gettime() <= furnShowNearCooldown)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La búsqueda de objetos cercanos fue utilizada recientemente, espera un instante.");

	new Float:x, Float:y, Float:z, STREAMER_TAG_OBJECT:objects[20], amount;

	GetPlayerPos(playerid, x, y, z);
	amount = Streamer_GetNearbyItems(x, y, z, STREAMER_TYPE_OBJECT, objects, sizeof(objects), 15.0, .worldid = GetPlayerVirtualWorld(playerid));

	new count, line[64], string[1000] = "ID Objeto\tMueble\tDistancia\n";

	for(new i = 0, arrayData[e_FURN_DYN_OBJ_ARRAY_DATA], Float:distance; i < amount && i < sizeof(objects); i++, arrayData[e_FURN_DYN_OBJ_TYPE] = DYN_OBJ_TYPE_NONE)
	{
		Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objects[i], E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

		if(arrayData[e_FURN_DYN_OBJ_TYPE] == DYN_OBJ_TYPE_FURN && arrayData[e_FURN_DYN_OBJ_PROP_TYPE] == FurnHandlingData[playerid][fuHandlingType] && arrayData[e_FURN_DYN_OBJ_PROP_ID] == FurnHandlingData[playerid][fuHandlingPropertyID])
		{
			Streamer_GetDistanceToItem(x, y, z, STREAMER_TYPE_OBJECT, objects[i], distance);
			format(line, sizeof(line), "%i\t%s\t%.2fm\n", objects[i], FurnModelData[arrayData[e_FURN_DYN_OBJ_FURN_MODEL_ID]][fuName], distance);
			strcat(string, line, sizeof(string));
			count++;
		}
	}

	if(count) {
		Dialog_Open(playerid, "DLG_FURN_CHOOSE_OBJECT", DIALOG_STYLE_TABLIST_HEADERS, "Muebles cercanos", string, "Continuar", "Volver");
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontraron muebles cercanos.");
	}

	furnShowNearCooldown = gettime() + 2;
	return 1;
}

Dialog:DLG_FURN_CHOOSE_OBJECT(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Furn_ShowMainMenu(playerid);

	new objectid;

	if(sscanf(inputtext, "i", objectid) || !IsValidDynamicObject(objectid))
		return 1;

	Furn_OnDynamicObjectSelection(playerid, objectid, Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID));
	return 1;
}

Furn_EnterSelectionMode(playerid) {
	SetTimerEx("Furn_SelectObjectDeferred", 250, false, "i", playerid);
}

forward Furn_SelectObjectDeferred(playerid);
public Furn_SelectObjectDeferred(playerid)
{
	if(!IsPlayerLogged(playerid))
		return 0;

	SelectObject(playerid);
	Noti_Create(playerid, 2500, "Entraste en el modo de selección de mueble");
	return 1;
}

Furn_ShowAccessMenu(playerid)
{
	Dialog_Open(playerid, "DLG_FURN_GIVE_ACCESS", DIALOG_STYLE_INPUT, "Acceso a gestión de muebles", "Ingresa el ID o nombre del jugador al cual quieres darle acceso.\nEjemplo: '15' o 'Tomas_Murillo'\nNota: además de ti, solo una persona más podrá tener acceso simultáneamente.\n \nNo olvides quitar el acceso otorgado al finalizar la gestión. Para ello ingresa tu propia ID o nombre.", "Aceptar", "Volver");
	return 1;
}

Dialog:DLG_FURN_GIVE_ACCESS(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Furn_ShowMainMenu(playerid);

	new targetid;

    if(sscanf(inputtext, "u", targetid) || !IsPlayerLogged(targetid))
    {
    	SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID o jugador inválido.");
    	Furn_ShowAccessMenu(playerid);
    	return 1;
    }

	switch(FurnHandlingData[playerid][fuHandlingType])
	{
		case FURN_TYPE_HOUSE: Furn_SetAccessHouse(playerid, targetid);
		case FURN_TYPE_BIZ: Furn_SetAccessBiz(playerid, targetid);
	}

	return 1;
}

Furn_OnDynamicObjectSelection(playerid, STREAMER_TAG_OBJECT:objectid, modelid)
{
	new arrayData[e_FURN_DYN_OBJ_ARRAY_DATA];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

	switch(arrayData[e_FURN_DYN_OBJ_PROP_TYPE])
	{
		case FURN_TYPE_HOUSE: Furn_ShowObjectMenuHouse(playerid, objectid, modelid, .houseid = arrayData[e_FURN_DYN_OBJ_PROP_ID], .furnmodelid = arrayData[e_FURN_DYN_OBJ_FURN_MODEL_ID], .slot = arrayData[e_FURN_DYN_OBJ_SLOT]);
		case FURN_TYPE_BIZ: Furn_ShowObjectMenuBiz(playerid, objectid, modelid, .bizid = arrayData[e_FURN_DYN_OBJ_PROP_ID], .furnmodelid = arrayData[e_FURN_DYN_OBJ_FURN_MODEL_ID], .slot = arrayData[e_FURN_DYN_OBJ_SLOT]);
	}
}

Furn_OnDynamicObjectEdition(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_CANCEL && FurnHandlingData[playerid][fuHandlingCase] == FURN_HANDLING_CASE_EDIT_PREVIEW)
	{
		Furn_Refund(playerid, objectid);
		return 1;
	}
	else if(response == EDIT_RESPONSE_FINAL)
	{
		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);

		if(FurnHandlingData[playerid][fuHandlingCase] == FURN_HANDLING_CASE_EDIT_PREVIEW) {
			Noti_Create(playerid, 2500, "Has comprado definitivamente este mueble");
		}

		new arrayData[e_FURN_DYN_OBJ_ARRAY_DATA];
		Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

		switch(arrayData[e_FURN_DYN_OBJ_PROP_TYPE])
		{
			case FURN_TYPE_HOUSE: Furn_UpdatePosHouse(arrayData[e_FURN_DYN_OBJ_PROP_ID], arrayData[e_FURN_DYN_OBJ_SLOT], x, y, z, rx, ry, rz);
			case FURN_TYPE_BIZ: Furn_UpdatePosBiz(arrayData[e_FURN_DYN_OBJ_PROP_ID], arrayData[e_FURN_DYN_OBJ_SLOT], x, y, z, rx, ry, rz);
		}

		return 1;
	}
	return 1;
}

Furn_Refund(playerid, objectid)
{
	new arrayData[e_FURN_DYN_OBJ_ARRAY_DATA];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

	switch(arrayData[e_FURN_DYN_OBJ_PROP_TYPE])
	{
		case FURN_TYPE_HOUSE: Furn_RefundHouse(playerid, objectid, .houseid = arrayData[e_FURN_DYN_OBJ_PROP_ID], .furnmodelid = arrayData[e_FURN_DYN_OBJ_FURN_MODEL_ID], .slot = arrayData[e_FURN_DYN_OBJ_SLOT]);
		case FURN_TYPE_BIZ: Furn_RefundBiz(playerid, objectid, .bizid = arrayData[e_FURN_DYN_OBJ_PROP_ID], .furnmodelid = arrayData[e_FURN_DYN_OBJ_FURN_MODEL_ID], .slot = arrayData[e_FURN_DYN_OBJ_SLOT]);
	}
	return 1;
}

hook OnGameModeInitEnded()
{
	print("[INFO] Cargando muebles...");
	mysql_tquery(MYSQL_HANDLE, "SELECT * FROM `furn_object`;", "Furn_OnDataLoaded");
	return 1;
}

forward Furn_OnDataLoaded();
public Furn_OnDataLoaded()
{
	new rows = cache_num_rows();

	for(new i, furntype; i < rows; i++)
	{
		furntype = cache_name_int(i, "type");

		switch(furntype)
		{
			case FURN_TYPE_HOUSE: Furn_LoadHouse(cache_name_int(i, "extraid"), cache_name_int(i, "furnid"), cache_name_int(i, "furnmodelid"), cache_name_int(i, "modelid"), cache_name_float(i, "x"), cache_name_float(i, "y"), cache_name_float(i, "z"), cache_name_float(i, "rx"), cache_name_float(i, "ry"), cache_name_float(i, "rz"), cache_name_int(i, "world"), cache_name_float(i, "streamdistance"));
			case FURN_TYPE_BIZ: Furn_LoadBiz(cache_name_int(i, "extraid"), cache_name_int(i, "furnid"), cache_name_int(i, "furnmodelid"), cache_name_int(i, "modelid"), cache_name_float(i, "x"), cache_name_float(i, "y"), cache_name_float(i, "z"), cache_name_float(i, "rx"), cache_name_float(i, "ry"), cache_name_float(i, "rz"), cache_name_int(i, "world"), cache_name_float(i, "streamdistance"));
		}
	}

	printf("[INFO] Carga de %i muebles finalizada.", rows);
	return 1;
}

Furn_SQLCreate(furntype, propid, slot, furnmodelid, objectmodel, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, world, Float:streamdistance)
{
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `furn_object` (`type`,`extraid`,`furnmodelid`,`modelid`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`world`,`streamdistance`) VALUES (%i,%i,%i,%i,%f,%f,%f,%f,%f,%f,%i,%f);", furntype, propid, furnmodelid, objectmodel, x, y, z, rx, ry, rz, world, streamdistance);
	mysql_tquery(MYSQL_HANDLE, query, "Furn_SQLOnCreated", "iii", furntype, propid, slot);
}

forward Furn_SQLOnCreated(furntype, propid, slot);
public Furn_SQLOnCreated(furntype, propid, slot)
{
	new lastid = cache_insert_id();

	switch(furntype)
	{
		case FURN_TYPE_HOUSE: Furn_SetSqlIdHouse(propid, slot, lastid);
		case FURN_TYPE_BIZ: Furn_SetSqlIdBiz(propid, slot, lastid);
	}

	return 1;
}

Furn_SQLSave(furnsqlid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new query[150];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `furn_object` SET `x`=%f,`y`=%f,`z`=%f,`rx`=%f,`ry`=%f,`rz`=%f WHERE `furnid`=%i;", x, y, z, rx, ry, rz, furnsqlid);
	mysql_tquery(MYSQL_HANDLE, query);
}

Furn_SQLDelete(furnsqlid)
{
	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `furn_object` WHERE `furnid`=%i;", furnsqlid);
	mysql_tquery(MYSQL_HANDLE, query);
	return 0;
}

Furn_SQLDeleteAll(furntype, propid)
{
	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `furn_object` WHERE `type`=%i AND `extraid`=%i;", furntype, propid);
	mysql_tquery(MYSQL_HANDLE, query);
}

