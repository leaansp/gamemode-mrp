#if defined _marp_toy_inc
	#endinput
#endif
#define _marp_toy_inc

#include <YSI_Coding\y_hooks>

const TOY_MAX_AMOUNT = 5; // Slot 5 reservado para ATTACH_INDEX_ID_HOLSTER (funda de cadera)

enum e_TOY_UNLOAD_TYPE
{
	TOY_UNLOAD_TYPE_DISCONNECTION,
	TOY_UNLOAD_TYPE_REMOVAL
}

static enum e_TOY_DATA
{
	tItemId,
	tParam,
	Float:tPX,
	Float:tPY,
	Float:tPZ,
	Float:tRX,
	Float:tRY,
	Float:tRZ,
	Float:tSX,
	Float:tSY,
	Float:tSZ
}

static ToyData[MAX_PLAYERS][TOY_MAX_AMOUNT][e_TOY_DATA];
static Iterator:ToyData[MAX_PLAYERS]<TOY_MAX_AMOUNT>;
static ToyDataPlayerSpawned[MAX_PLAYERS];

hook OnGameModeInit()
{
	Iter_Init(ToyData);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	ToyDataPlayerSpawned[playerid] = 0;

	if(Iter_Count(ToyData[playerid]))
	{
		Toy_DisconnectionUnload(playerid);
		Iter_Clear(ToyData[playerid]);
	}
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	ToyDataPlayerSpawned[playerid] = 1;

	// Si todav�a no devolvi� la query de carga inicial, el iterador estar� vac�o y no efectuar� ninguna carga
	Toy_AttachAllGraphicObjects(playerid);
	return 1;
}

hook LoadAccountDataEnded(playerid)
{
	new query[180];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT `toyid`,`itemid`,`param`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`sx`,`sy`,`sz` FROM `toy` INNER JOIN `toy_pos` USING (`playerid`,`itemid`) WHERE `playerid`=%i;", PlayerInfo[playerid][pID]);
	mysql_tquery(MYSQL_HANDLE, query, "Toy_OnDataLoad", "i", playerid);
	return 1;
}

forward Toy_OnDataLoad(playerid);
public Toy_OnDataLoad(playerid)
{
	new rows = cache_num_rows();

	for(new i, toyid; i < rows; i++)
	{
		cache_get_value_index_int(i, 0, toyid);
		cache_get_value_index_int(i, 1, ToyData[playerid][toyid][tItemId]);
		cache_get_value_index_int(i, 2, ToyData[playerid][toyid][tParam]);
		cache_get_value_index_float(i, 3, ToyData[playerid][toyid][tPX]);
		cache_get_value_index_float(i, 4, ToyData[playerid][toyid][tPY]);
		cache_get_value_index_float(i, 5, ToyData[playerid][toyid][tPZ]);
		cache_get_value_index_float(i, 6, ToyData[playerid][toyid][tRX]);
		cache_get_value_index_float(i, 7, ToyData[playerid][toyid][tRY]);
		cache_get_value_index_float(i, 8, ToyData[playerid][toyid][tRZ]);
		cache_get_value_index_float(i, 9, ToyData[playerid][toyid][tSX]);
		cache_get_value_index_float(i, 10, ToyData[playerid][toyid][tSY]);
		cache_get_value_index_float(i, 11, ToyData[playerid][toyid][tSZ]);

		Iter_Add(ToyData[playerid], toyid);
		Toy_OnLoaded(playerid, ToyData[playerid][toyid][tItemId], ToyData[playerid][toyid][tParam]);

		// Si el cliente ya hizo el spawn inicial antes de la obtenci�n de las posiciones y no pudo cargar los toys, los cargamos ac�
		if(ToyDataPlayerSpawned[playerid]) {
			Toy_AttachGraphicObject(playerid, toyid, .useCachePos = true);
		}
	}

	return 1;
}

Toy_Add(playerid, itemid, param)
{
	new toyid = Iter_Free(ToyData[playerid]);

	if(toyid == INVALID_ITERATOR_SLOT || !ItemModel_IsValidId(itemid))
		return 0;
	if(!Toy_OnAddIntention(playerid, itemid, param))
		return 0;

	Iter_Add(ToyData[playerid], toyid);

	ToyData[playerid][toyid][tItemId] = itemid;
	ToyData[playerid][toyid][tParam] = param;

	Toy_OnLoaded(playerid, itemid, param);
	Toy_AttachGraphicObject(playerid, toyid, .useCachePos = false);

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `toy` (`playerid`,`toyid`,`itemid`,`param`) VALUES (%i,%i,%i,%i);", PlayerInfo[playerid][pID], toyid, itemid, param);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

Toy_OnAddIntention(playerid, itemid, param)
{
	#pragma unused param

	if(ItemToy_HasTag(ItemModel_GetExtraId(itemid), ITEM_TOY_TAG_GIVE_ARMOUR))
	{
		if(Toy_HasAnyWithItemToyTag(playerid, ITEM_TOY_TAG_GIVE_ARMOUR)) {
			return 0;
		}
	}
	return 1;
}

Toy_OnLoaded(playerid, itemid, param)
{
	if(ItemToy_HasTag(ItemModel_GetExtraId(itemid), ITEM_TOY_TAG_HIDE_NAME)) {
		HiddenName_On(playerid);
	}

	if(ItemToy_HasTag(ItemModel_GetExtraId(itemid), ITEM_TOY_TAG_GIVE_ARMOUR)) {
		SetPlayerArmourEx(playerid, float(param));
	}
	return 1;
}

Toy_Remove(playerid, toyid, &itemid, &param)
{
	if(!Iter_Contains(ToyData[playerid], toyid))
		return 0;
	// if(!Toy_OnRemoveIntention(playerid, ToyData[playerid][toyid][tItemId], ToyData[playerid][toyid][tParam]))
	// 	return 0;

	RemovePlayerAttachedObject(playerid, toyid);
	Iter_Remove(ToyData[playerid], toyid);

	Toy_OnUnloaded(playerid, ToyData[playerid][toyid][tItemId], ToyData[playerid][toyid][tParam], TOY_UNLOAD_TYPE_REMOVAL);

	itemid = ToyData[playerid][toyid][tItemId];
	param = ToyData[playerid][toyid][tParam];

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `toy` WHERE `playerid`=%i AND `toyid`=%i;", PlayerInfo[playerid][pID], toyid);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

// Toy_OnRemoveIntention(playerid, &itemid, &param)
// {
// 	#pragma unused playerid
// 	#pragma unused itemid
// 	#pragma unused param

// 	return 1;
// }

Toy_OnUnloaded(playerid, &itemid, &param, e_TOY_UNLOAD_TYPE:type, &bool:update = false)
{
	if(ItemToy_HasTag(ItemModel_GetExtraId(itemid), ITEM_TOY_TAG_HIDE_NAME))
	{
		if(type == TOY_UNLOAD_TYPE_REMOVAL && !Toy_HasAnyWithItemToyTag(playerid, ITEM_TOY_TAG_HIDE_NAME)) {
			HiddenName_Off(playerid);
		}
	}

	if(ItemToy_HasTag(ItemModel_GetExtraId(itemid), ITEM_TOY_TAG_GIVE_ARMOUR))
	{
		update = true;
		param = floatround(GetPlayerArmourEx(playerid), floatround_floor);
		SetPlayerArmourEx(playerid, 0.0);
	}

	return 1;
}

Toy_DisconnectionUnload(playerid)
{
	new bool:update;

	foreach(new toyid : ToyData[playerid])
	{
		update = false;
		Toy_OnUnloaded(playerid, ToyData[playerid][toyid][tItemId], ToyData[playerid][toyid][tParam], .type = TOY_UNLOAD_TYPE_DISCONNECTION, .update = update);	

		if(update)
		{
			new query[128];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `toy` SET `itemid`=%i,`param`=%i WHERE `playerid`=%i AND `toyid`=%i;", ToyData[playerid][toyid][tItemId], ToyData[playerid][toyid][tParam], PlayerInfo[playerid][pID], toyid);
			mysql_tquery(MYSQL_HANDLE, query);
		}
	}
}

stock Toy_SetItem(playerid, toyid, itemid, param)
{
	if(!Iter_Contains(ToyData[playerid], toyid))
		return 0;

	ToyData[playerid][toyid][tItemId] = itemid;
	ToyData[playerid][toyid][tParam] = param;

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `toy` SET `itemid`=%i,`param`=%i WHERE `playerid`=%i AND `toyid`=%i;", itemid, param, PlayerInfo[playerid][pID], toyid);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

stock Toy_GetItem(playerid, toyid, &itemid, &param)
{
	if(!Iter_Contains(ToyData[playerid], toyid))
		return 0;

	itemid = ToyData[playerid][toyid][tItemId];
	param = ToyData[playerid][toyid][tParam];
	return 1;
}

static Toy_AttachGraphicObject(playerid, toyid, bool:useCachePos)
{
	new itemid = ToyData[playerid][toyid][tItemId];
	
	if(ItemModel_GetObjectModel(itemid) <= 0)
		return 0;
	if(!ItemToy_IsValidDataId(ItemModel_GetExtraId(itemid)))
		return 0;

	if(useCachePos) {
		SetPlayerAttachedObject(playerid, toyid, ItemModel_GetObjectModel(itemid), ItemToy_GetAttachBone(ItemModel_GetExtraId(itemid)), ToyData[playerid][toyid][tPX], ToyData[playerid][toyid][tPY], ToyData[playerid][toyid][tPZ], ToyData[playerid][toyid][tRX], ToyData[playerid][toyid][tRY], ToyData[playerid][toyid][tRZ], ToyData[playerid][toyid][tSX], ToyData[playerid][toyid][tSY], ToyData[playerid][toyid][tSZ]);
	} else {
		Toy_AttachOnSavedPos(playerid, toyid, itemid);	
	}

	return 1;
}

Toy_AttachOnSavedPos(playerid, toyid, itemid)
{
	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT `x`,`y`,`z`,`rx`,`ry`,`rz`,`sx`,`sy`,`sz` FROM `toy_pos` WHERE `playerid`=%i AND `itemid`=%i;", PlayerInfo[playerid][pID], itemid);
	mysql_tquery(MYSQL_HANDLE, query, "Toy_OnSavedPosLoaded", "iii", playerid, toyid, itemid);
}

forward Toy_OnSavedPosLoaded(playerid, toyid, itemid);
public Toy_OnSavedPosLoaded(playerid, toyid, itemid)
{
	if(!IsPlayerLogged(playerid) || !Iter_Contains(ToyData[playerid], toyid))
		return 0;

	if(cache_num_rows())
	{
		cache_get_value_index_float(0, 0, ToyData[playerid][toyid][tPX]);
		cache_get_value_index_float(0, 1, ToyData[playerid][toyid][tPY]);
		cache_get_value_index_float(0, 2, ToyData[playerid][toyid][tPZ]);
		cache_get_value_index_float(0, 3, ToyData[playerid][toyid][tRX]);
		cache_get_value_index_float(0, 4, ToyData[playerid][toyid][tRY]);
		cache_get_value_index_float(0, 5, ToyData[playerid][toyid][tRZ]);
		cache_get_value_index_float(0, 6, ToyData[playerid][toyid][tSX]);
		cache_get_value_index_float(0, 7, ToyData[playerid][toyid][tSY]);
		cache_get_value_index_float(0, 8, ToyData[playerid][toyid][tSZ]);

		SetPlayerAttachedObject(playerid, toyid, ItemModel_GetObjectModel(itemid), ItemToy_GetAttachBone(ItemModel_GetExtraId(itemid)), ToyData[playerid][toyid][tPX], ToyData[playerid][toyid][tPY], ToyData[playerid][toyid][tPZ], ToyData[playerid][toyid][tRX], ToyData[playerid][toyid][tRY], ToyData[playerid][toyid][tRZ], ToyData[playerid][toyid][tSX], ToyData[playerid][toyid][tSY], ToyData[playerid][toyid][tSZ]);
	}
	else
	{
		ItemToy_GetAttachDefaultCoords(ItemModel_GetExtraId(itemid), ToyData[playerid][toyid][tPX], ToyData[playerid][toyid][tPY], ToyData[playerid][toyid][tPZ], ToyData[playerid][toyid][tRX], ToyData[playerid][toyid][tRY], ToyData[playerid][toyid][tRZ], ToyData[playerid][toyid][tSX], ToyData[playerid][toyid][tSY], ToyData[playerid][toyid][tSZ]);
		SetPlayerAttachedObject(playerid, toyid, ItemModel_GetObjectModel(itemid), ItemToy_GetAttachBone(ItemModel_GetExtraId(itemid)), ToyData[playerid][toyid][tPX], ToyData[playerid][toyid][tPY], ToyData[playerid][toyid][tPZ], ToyData[playerid][toyid][tRX], ToyData[playerid][toyid][tRY], ToyData[playerid][toyid][tRZ], ToyData[playerid][toyid][tSX], ToyData[playerid][toyid][tSY], ToyData[playerid][toyid][tSZ]);
		EditAttachedObject(playerid, toyid);

		new query[256];
		mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `toy_pos` (`playerid`,`itemid`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`sx`,`sy`,`sz`) VALUES (%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f);",
			PlayerInfo[playerid][pID],
			itemid,
			ToyData[playerid][toyid][tPX],
			ToyData[playerid][toyid][tPY],
			ToyData[playerid][toyid][tPZ],
			ToyData[playerid][toyid][tRX],
			ToyData[playerid][toyid][tRY],
			ToyData[playerid][toyid][tRZ],
			ToyData[playerid][toyid][tSX],
			ToyData[playerid][toyid][tSY],
			ToyData[playerid][toyid][tSZ]
		);
		mysql_tquery(MYSQL_HANDLE, query);
	}	
	return 1;
}

forward Holster_OnEditAttached(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);

hook OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(index == ATTACH_INDEX_ID_HOLSTER) return Holster_OnEditAttached(playerid, response, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
	if(!response)
		return 1;

	RemovePlayerAttachedObject(playerid, index);
	SetPlayerAttachedObject(playerid, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
	
	new toyid = index;

	if(!Iter_Contains(ToyData[playerid], toyid))
		return 0;

	ToyData[playerid][toyid][tPX] = fOffsetX;
	ToyData[playerid][toyid][tPY] = fOffsetY;
	ToyData[playerid][toyid][tPZ] = fOffsetZ;
	ToyData[playerid][toyid][tRX] = fRotX;
	ToyData[playerid][toyid][tRY] = fRotY;
	ToyData[playerid][toyid][tRZ] = fRotZ;
	ToyData[playerid][toyid][tSX] = fScaleX;
	ToyData[playerid][toyid][tSY] = fScaleY;
	ToyData[playerid][toyid][tSZ] = fScaleZ;

	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `toy_pos` SET `x`=%f,`y`=%f,`z`=%f,`rx`=%f,`ry`=%f,`rz`=%f,`sx`=%f,`sy`=%f,`sz`=%f WHERE `playerid`=%i AND `itemid`=%i;", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, PlayerInfo[playerid][pID], ToyData[playerid][toyid][tItemId]);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

stock Toy_HasAnyWithItemTag(playerid, e_ITEM_TAG:tag)
{
	foreach(new toyid : ToyData[playerid])
	{
		if(ItemModel_HasTag(ToyData[playerid][toyid][tItemId], tag))
			return 1;		
	}
	return 0;
}

stock Toy_HasAnyWithItemToyTag(playerid, e_ITEM_TOY_TAG:tag)
{
	foreach(new toyid : ToyData[playerid])
	{
		if(ItemToy_HasTag(ItemModel_GetExtraId(ToyData[playerid][toyid][tItemId]), tag))
			return 1;		
	}
	return 0;
}

stock Toy_HasItem(playerid, itemid)
{
	foreach(new toyid : ToyData[playerid])
	{
		if(ToyData[playerid][toyid][tItemId] == itemid)
			return 1;		
	}
	return 0;
}

PrintToysForPlayer(playerid, targetid)
{
	SendClientMessage(targetid, COLOR_WHITE, "______________________[ TOYS ]______________________");

	foreach(new toyid : ToyData[playerid]) {
		SendFMessage(targetid, COLOR_WHITE, "[%i] - %s", toyid, ItemModel_GetName(ToyData[playerid][toyid][tItemId]));
	}

	SendClientMessage(targetid, COLOR_WHITE, "____________________________________________________");
}

Toy_Edit(playerid, toyid)
{
	if(!Iter_Contains(ToyData[playerid], toyid))
		return 0;

	EditAttachedObject(playerid, toyid);
	return 1;
}

Toy_TakeItem(playerid, playerhand, toyid)
{
	if(GetHandItem(playerid, playerhand) != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo ya que tienes otro item en esa mano.");

	new itemid, param;

	if(!Toy_Remove(playerid, toyid, itemid, param))
		return SendClientMessage(playerid, COLOR_YELLOW2, "n�mero de toy inv�lido o no puedes quit�rtelo en este momento.");

	new str[128];
	format(str, sizeof(str), "Se quita %s.", ItemModel_GetName(itemid));
	PlayerCmeMessage(playerid, 15.0, 3500, str);
	SetHandItemAndParam(playerid, playerhand, itemid, param);
	return 1;
}

CMD:toy(playerid, params[])
{
	new subcmd[16], toyid;

	if(sscanf(params, "s[16]i", subcmd, toyid))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/toy [comando]");
		SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" sacar/sacari [nro toy] - editar [nro toy]");
		PrintToysForPlayer(playerid, playerid);
		return 1;
	}

	if(!strcmp(subcmd, "sacar", true)) {
		Toy_TakeItem(playerid, HAND_RIGHT, toyid);
	}
	else if(!strcmp(subcmd, "sacari", true)) {
		Toy_TakeItem(playerid, HAND_LEFT, toyid);
	}
	else if(!strcmp(subcmd, "editar", true))
	{
		if(!Toy_Edit(playerid, toyid))
			return SendClientMessage(playerid, COLOR_YELLOW2, "n�mero de toy inv�lido.");
	}
	return 1;
}

Toy_HideAllGraphicObjects(playerid)
{
	foreach(new toyid : ToyData[playerid]) {
		RemovePlayerAttachedObject(playerid, toyid);
	}
}

Toy_AttachAllGraphicObjects(playerid)
{
	foreach(new toyid : ToyData[playerid]) {
		Toy_AttachGraphicObject(playerid, toyid, .useCachePos = true);
	}
}
