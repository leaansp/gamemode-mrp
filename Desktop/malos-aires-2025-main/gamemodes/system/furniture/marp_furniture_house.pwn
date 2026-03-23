#if defined marp_furniture_house_inc
	#endinput
#endif
#define marp_furniture_house_inc

#include <YSI_Coding\y_hooks>

const FURN_MAX_HOUSE_AMOUNT = 300;

static FurnDataHouse[MAX_HOUSES][FURN_MAX_HOUSE_AMOUNT][e_FURN_INSTANCE_DATA];
static Iterator:FurnDataHouse[MAX_HOUSES]<FURN_MAX_HOUSE_AMOUNT>;
static FurnManagementAccessHouse[MAX_HOUSES];

hook OnGameModeInit()
{
	Iter_Init(FurnDataHouse);
	return 1;
}

Furn_HasManagementAccessHouse(playerid, houseid) {
	return (FurnManagementAccessHouse[houseid] == PlayerInfo[playerid][pID]);
}

Furn_EntryPointHouse(playerid, houseid)
{
	FurnHandlingData[playerid][fuHandlingType] = FURN_TYPE_HOUSE;
	FurnHandlingData[playerid][fuHandlingPropertyID] = houseid;		
	Furn_ShowMainMenu(playerid);
}

Furn_ShowMyHouse(playerid)
{
	if(FurnHandlingData[playerid][fuHandlingType] != FURN_TYPE_HOUSE)
		return 0;

	new houseid = FurnHandlingData[playerid][fuHandlingPropertyID];

	if(!House_IsValidId(houseid))
		return 0;
	if(!Iter_Count(FurnDataHouse[houseid]))
		return Furn_ShowMainMenu(playerid);

	new string[3500] = "ID Objeto\tNombre\n", line[64], totalPrice;

	foreach(new i : FurnDataHouse[houseid])
	{
		format(line, sizeof(line), "%i\t%s\n", FurnDataHouse[houseid][i][fuObjectID], FurnModelData[FurnDataHouse[houseid][i][fuFurnModelID]][fuName]);
		strcat(string, line, sizeof(string));
		totalPrice += FurnModelData[FurnDataHouse[houseid][i][fuFurnModelID]][fuPrice];
	}

	format(line, sizeof(line), "Mis muebles (%i). Valuación total: $%i.", Iter_Count(FurnDataHouse[houseid]), totalPrice);

	Dialog_Open(playerid, "DLG_FURN_CHOOSE_OBJECT", DIALOG_STYLE_TABLIST_HEADERS, line, string, "Continuar", "Volver");
	return 1;
}

Furn_SetAccessHouse(playerid, targetid)
{
	if(FurnHandlingData[playerid][fuHandlingType] != FURN_TYPE_HOUSE)
		return 0;

	new houseid = FurnHandlingData[playerid][fuHandlingPropertyID];

	if(!House_IsValidId(houseid))
		return 0;

	FurnManagementAccessHouse[houseid] = PlayerInfo[targetid][pID];

	if(playerid != targetid)
	{
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Le has dado permiso de gestión de muebles de tu casa a %s.", GetPlayerCleanName(targetid));
		SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El jugador %s te ha dado permiso para que gestiones los muebles de su casa.", GetPlayerCleanName(playerid));
	} else {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has quitado el acceso externo a la gestión de tus muebles."); 
	}

	Furn_ShowMainMenu(playerid);
	return 1;
}

Furn_CategoryMenuResponseHouse(playerid, furnmodelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new houseid = FurnHandlingData[playerid][fuHandlingPropertyID];
	
	if(!House_IsValidId(houseid))
		return 0;
	if(House_IsPlayerInAny(playerid) != houseid && !PlayerInfo[playerid][pAdmin])
		return 0;

	new slot = Iter_Free(FurnDataHouse[houseid]);

	if(slot == ITER_NONE)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Has alcanzado el máximode objetos permitidos.");
	if(GetPlayerCash(playerid) < FurnModelData[furnmodelid][fuPrice])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero suficiente.");

	FurnDataHouse[houseid][slot][fuFurnModelID] = furnmodelid;
	FurnDataHouse[houseid][slot][fuObjectSQLID] = 0;
	FurnDataHouse[houseid][slot][fuObjectID] = CreateDynamicObject(FurnModelData[furnmodelid][fuModelid], x, y, z, rx, ry, rz, .worldid = GetPlayerVirtualWorld(playerid), .streamdistance = FURN_DYN_OBJ_STREAM_DISTANCE, .drawdistance = FURN_DYN_OBJ_STREAM_DISTANCE);
	Furn_SetDynamicObjectArrayData(FurnDataHouse[houseid][slot][fuObjectID], DYN_OBJ_TYPE_FURN, FURN_TYPE_HOUSE, houseid, furnmodelid, slot);
	EditDynamicObject(playerid, FurnDataHouse[houseid][slot][fuObjectID]);
	GivePlayerCash(playerid, -FurnModelData[furnmodelid][fuPrice]);

	Iter_Add(FurnDataHouse[houseid], slot);

	Furn_SQLCreate(FURN_TYPE_HOUSE, houseid, slot, furnmodelid, FurnModelData[furnmodelid][fuModelid], x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), FURN_DYN_OBJ_STREAM_DISTANCE);

	FurnHandlingData[playerid][fuHandlingCase] = FURN_HANDLING_CASE_EDIT_PREVIEW;
	FurnHandlingData[playerid][fuHandlingObjectID] = FurnDataHouse[houseid][slot][fuObjectID];
	FurnHandlingData[playerid][fuHandlingFurnModelID] = furnmodelid;
	FurnHandlingData[playerid][fuHandlingSlot] = slot;

	Noti_Create(playerid, 5000, "Has comprado provisoriamente este mueble. Si no estás convencido, puedes devolverlo sin costo extra por única vez cancelando la edición (ESC)");
	return 1;
}

Furn_SetSqlIdHouse(houseid, slot, sqlid)
{
	if(!House_IsValidId(houseid))
		return Furn_SQLDelete(sqlid);
	if(!Iter_Contains(FurnDataHouse[houseid], slot))
		return Furn_SQLDelete(sqlid);

	FurnDataHouse[houseid][slot][fuObjectSQLID] = sqlid;
	return 1;
}

Furn_UpdatePosHouse(houseid, slot, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
	Furn_SQLSave(FurnDataHouse[houseid][slot][fuObjectSQLID], x, y, z, rx, ry, rz);
}

Furn_LoadHouse(houseid, furnsqlid, furnmodelid, objectmodelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, world, Float:streamdistance)
{
	if(!House_IsValidId(houseid))
		return 0;

	new slot = Iter_Free(FurnDataHouse[houseid]);

	if(slot == ITER_NONE)
		return 0;

	FurnDataHouse[houseid][slot][fuFurnModelID] = furnmodelid;
	FurnDataHouse[houseid][slot][fuObjectSQLID] = furnsqlid;
	FurnDataHouse[houseid][slot][fuObjectID] = CreateDynamicObject(objectmodelid, x, y, z, rx, ry, rz, .worldid = world, .streamdistance = streamdistance, .drawdistance = streamdistance);
	Furn_SetDynamicObjectArrayData(FurnDataHouse[houseid][slot][fuObjectID], DYN_OBJ_TYPE_FURN, FURN_TYPE_HOUSE, houseid, furnmodelid, slot);
	
	Iter_Add(FurnDataHouse[houseid], slot);
	return 1;
}

Furn_DeleteAllHouse(houseid)
{
	if(!House_IsValidId(houseid))
		return 0;

	foreach(new i : FurnDataHouse[houseid]) {
		DestroyDynamicObject(FurnDataHouse[houseid][i][fuObjectID]);
	}

	Iter_Clear(FurnDataHouse[houseid]);
	Furn_SQLDeleteAll(FURN_TYPE_HOUSE, houseid);
	return 1;
}

Furn_ResetAccessHouse(houseid)
{
	if(!House_IsValidId(houseid))
		return 0;

	foreach(new playerid : Player)
	{
		if(Furn_CheckHandling(playerid, FURN_TYPE_HOUSE, houseid)) {
			FurnHandlingData[playerid] = FurnHandlingData[FURN_HANDLING_DATA_RESET_ID];
		}
	}

	FurnManagementAccessHouse[houseid] = 0;
	return 1;
}

Furn_RefundHouse(playerid, objectid, houseid, furnmodelid, slot)
{
	if(!House_IsValidId(houseid))
		return 0;
	if(!Iter_Contains(FurnDataHouse[houseid], slot))
		return 0;
	if(FurnDataHouse[houseid][slot][fuObjectID] != objectid)
		return 0;
	if(FurnDataHouse[houseid][slot][fuFurnModelID] != furnmodelid)
		return 0;

	Noti_Create(playerid, 2500, "Has cancelado la compra de este mueble. Se te reintegra el dinero");
	DestroyDynamicObject(objectid);
	Furn_SQLDelete(FurnDataHouse[houseid][slot][fuObjectSQLID]);
	Iter_Remove(FurnDataHouse[houseid], slot);
	GivePlayerCash(playerid, FurnModelData[furnmodelid][fuPrice]);
	return 1;
}

Furn_ShowObjectMenuHouse(playerid, STREAMER_TAG_OBJECT:objectid, modelid, houseid, furnmodelid, slot)
{
	if(!Furn_CheckHandling(playerid, FURN_TYPE_HOUSE, houseid) && !PlayerInfo[playerid][pAdmin])
		return 0;
	if(!House_IsValidId(houseid))
		return 0;
	if(!Iter_Contains(FurnDataHouse[houseid], slot))
		return 0;
	if(FurnDataHouse[houseid][slot][fuObjectID] != objectid)
		return 0;
	if(FurnDataHouse[houseid][slot][fuFurnModelID] != furnmodelid)
		return 0;

	new string[512];

	format(string, sizeof(string),
		"ID de objeto\t%i\n\
		Modelo de objeto\t%i\n\
		Tipo de objeto\tMueble\n\
		Modelo de mueble\t%i\n\
		Nombre de mueble\t%s\n\
		Precio original\t$%i\n\
		ID de casa\t%i",
		objectid,
		modelid,
		furnmodelid,
		FurnModelData[furnmodelid][fuName],
		FurnModelData[furnmodelid][fuPrice],
		houseid
	);

	if(Furn_CheckHandling(playerid, FURN_TYPE_HOUSE, houseid))
	{
		FurnHandlingData[playerid][fuHandlingCase] = FURN_HANDLING_CASE_EDIT;
		FurnHandlingData[playerid][fuHandlingObjectID] = objectid;
		FurnHandlingData[playerid][fuHandlingFurnModelID] = furnmodelid;
		FurnHandlingData[playerid][fuHandlingSlot] = slot;

		new Float:rx, Float:ry, Float:rz;
		GetDynamicObjectRot(objectid, rx, ry, rz);

		format(string, sizeof(string),
			"%s\n\
			_________________\n \n\
			{EFEF00}<< Editar >>\n\
			_________________\n \n\
			{EFEF00}<< Fijar Z >>\tFija la rotación en Z (actual: %.2f)\n\
			_________________\n \n\
			{EFEF00}<< Clonar >>\tTe costará $%i\n\
			_________________\n \n\
			{FF0000}<< Vender >>\t{FFFFFF}Recibirás $%i",
			string,
			rz,
			FurnModelData[furnmodelid][fuPrice],
			floatround(FurnModelData[furnmodelid][fuPrice] * FURN_SELLING_PRICE_RATIO)
		);

		Dialog_Open(playerid, "DLG_FURN_EDIT_HOUSE", DIALOG_STYLE_TABLIST, "Objeto seleccionado", string, "Continuar", "Cerrar");
	} else {
		Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_TABLIST, "Objeto seleccionado", string, "Cerrar", "");
	}
	
	return 1;
}

Dialog:DLG_FURN_EDIT_HOUSE(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext))
		return 1;

	new houseid = FurnHandlingData[playerid][fuHandlingPropertyID],
		objectid = FurnHandlingData[playerid][fuHandlingObjectID],
		slot = FurnHandlingData[playerid][fuHandlingSlot],
		furnmodel = FurnHandlingData[playerid][fuHandlingFurnModelID];

	if(!IsValidDynamicObject(objectid))
		return 0;
	if(!Furn_CheckHandling(playerid, FURN_TYPE_HOUSE, houseid))
		return 0;
	if(!House_IsValidId(houseid))
		return 0;
	if(!Iter_Contains(FurnDataHouse[houseid], slot))
		return 0;
	if(FurnDataHouse[houseid][slot][fuObjectID] != objectid)
		return 0;
	if(FurnDataHouse[houseid][slot][fuFurnModelID] != furnmodel)
		return 0;

	if(!strcmp(inputtext, "<< Editar >>"))
	{
		new Float:x, Float:y, Float:z, Float:distance;
		GetPlayerPos(playerid, x, y, z);
		Streamer_GetDistanceToItem(x, y, z, STREAMER_TYPE_OBJECT, objectid, distance);

		if(distance > 20.0)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Te encuentras demasiado lejos del mueble que quieres editar.");

		EditDynamicObject(playerid, objectid);
		FurnHandlingData[playerid][fuHandlingCase] = FURN_HANDLING_CASE_EDIT;
	}
	else if(!strcmp(inputtext, "<< Vender >>"))
	{
		new string[128];
		format(string, sizeof(string), "Has vendido (%s) por $%i", FurnModelData[furnmodel][fuName], floatround(FurnModelData[furnmodel][fuPrice] * FURN_SELLING_PRICE_RATIO));
		Noti_Create(playerid, 2500, string);
		DestroyDynamicObject(objectid);
		Furn_SQLDelete(FurnDataHouse[houseid][slot][fuObjectSQLID]);
		Iter_Remove(FurnDataHouse[houseid], slot);
		GivePlayerCash(playerid, floatround(FurnModelData[furnmodel][fuPrice] * FURN_SELLING_PRICE_RATIO));	
	}
	else if(!strcmp(inputtext, "<< Fijar Z >>")) {
		Dialog_Open(playerid, "DLG_FURN_SET_ROT_HOUSE", DIALOG_STYLE_INPUT, "Objeto seleccionado", "Ingresa el valor para la rotación en Z (entre 0 y 360):", "Continuar", "Cerrar");
	}
	else if(!strcmp(inputtext, "<< Clonar >>"))
	{
		new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
		GetDynamicObjectPos(objectid, x, y, z);
		GetDynamicObjectRot(objectid, rx, ry, rz);
		Furn_CategoryMenuResponseHouse(playerid, furnmodel, x, y, z, rx, ry, rz);
	}
	return 1;
}

Dialog:DLG_FURN_SET_ROT_HOUSE(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	new Float:angle;

	if(sscanf(inputtext, "f", angle) || !(0.0 <= angle <= 360.0))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar un valor numérico entre 0 y 360.");

	new houseid = FurnHandlingData[playerid][fuHandlingPropertyID],
		objectid = FurnHandlingData[playerid][fuHandlingObjectID],
		slot = FurnHandlingData[playerid][fuHandlingSlot],
		furnmodel = FurnHandlingData[playerid][fuHandlingFurnModelID];

	if(!IsValidDynamicObject(objectid))
		return 0;
	if(!Furn_CheckHandling(playerid, FURN_TYPE_HOUSE, houseid))
		return 0;
	if(!House_IsValidId(houseid))
		return 0;
	if(!Iter_Contains(FurnDataHouse[houseid], slot))
		return 0;
	if(FurnDataHouse[houseid][slot][fuObjectID] != objectid)
		return 0;
	if(FurnDataHouse[houseid][slot][fuFurnModelID] != furnmodel)
		return 0;

	new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
	
	GetDynamicObjectPos(objectid, x, y, z);
	GetDynamicObjectRot(objectid, rx, ry, rz);
	SetDynamicObjectRot(objectid, rx, ry, angle);
	Furn_SQLSave(FurnDataHouse[houseid][slot][fuObjectSQLID], x, y, z, rx, ry, angle);
	Noti_Create(playerid, 2500, "Rotación Z configurada");
	return 1;
}
