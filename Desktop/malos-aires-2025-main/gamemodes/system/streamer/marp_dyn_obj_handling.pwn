#if defined marp_dyn_obj_handling_inc
	#endinput
#endif
#define marp_dyn_obj_handling_inc

enum e_DYN_OBJ_TYPE
{
	DYN_OBJ_TYPE_NONE,
	DYN_OBJ_TYPE_MAPRO,
	DYN_OBJ_TYPE_FURN,
	DYN_OBJ_TYPE_GRAFFITI,
};

static enum e_DYN_OBJ_EDITION_DATA
{
	STREAMER_TAG_OBJECT:e_DYN_OBJ_EDITION_ID,
	Float:e_DYN_OBJ_EDITION_X,
	Float:e_DYN_OBJ_EDITION_Y,
	Float:e_DYN_OBJ_EDITION_Z,
	Float:e_DYN_OBJ_EDITION_RX,
	Float:e_DYN_OBJ_EDITION_RY,
	Float:e_DYN_OBJ_EDITION_RZ
}

static DynObjEditionData[MAX_PLAYERS][e_DYN_OBJ_EDITION_DATA];

hook function EditDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid)
{
	if(!IsValidDynamicObject(objectid))
		return 0;

	DynObjEditionData[playerid][e_DYN_OBJ_EDITION_ID] = objectid;
	GetDynamicObjectPos(objectid, DynObjEditionData[playerid][e_DYN_OBJ_EDITION_X], DynObjEditionData[playerid][e_DYN_OBJ_EDITION_Y], DynObjEditionData[playerid][e_DYN_OBJ_EDITION_Z]);
	GetDynamicObjectRot(objectid, DynObjEditionData[playerid][e_DYN_OBJ_EDITION_RX], DynObjEditionData[playerid][e_DYN_OBJ_EDITION_RY], DynObjEditionData[playerid][e_DYN_OBJ_EDITION_RZ]);

	return continue(playerid, objectid);
}

RestoreDynamicObjectEditionPos(objectid, playerid)
{
	SetDynamicObjectPos(objectid, DynObjEditionData[playerid][e_DYN_OBJ_EDITION_X], DynObjEditionData[playerid][e_DYN_OBJ_EDITION_Y], DynObjEditionData[playerid][e_DYN_OBJ_EDITION_Z]);
	SetDynamicObjectRot(objectid, DynObjEditionData[playerid][e_DYN_OBJ_EDITION_RX], DynObjEditionData[playerid][e_DYN_OBJ_EDITION_RY], DynObjEditionData[playerid][e_DYN_OBJ_EDITION_RZ]);
}

IsValidObjectModel(modelid) {
	return (615 <= modelid <= 19999 || 321 <= modelid <= 373);
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_UPDATE || DynObjEditionData[playerid][e_DYN_OBJ_EDITION_ID] != objectid)
		return 1;

	if(response == EDIT_RESPONSE_CANCEL) {
		RestoreDynamicObjectEditionPos(objectid, playerid);
	}

	new dynObjectType[1] = {DYN_OBJ_TYPE_NONE};
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, dynObjectType, sizeof(dynObjectType));

	switch(dynObjectType[0])
	{
		case DYN_OBJ_TYPE_NONE: OnGenericDynamicObjectEdition(playerid, objectid, response, x, y, z, rx, ry, rz);
		case DYN_OBJ_TYPE_MAPRO: Mapro_OnDynamicObjectEdition(playerid, objectid, response, x, y, z, rx, ry, rz);
		case DYN_OBJ_TYPE_FURN: Furn_OnDynamicObjectEdition(playerid, objectid, response, x, y, z, rx, ry, rz);
		case DYN_OBJ_TYPE_GRAFFITI: GODOS(playerid, objectid, response, x, y, z, rx, ry, rz);
	}

	DynObjEditionData[playerid][e_DYN_OBJ_EDITION_ID] = 0;
	return 1;
}

public OnPlayerSelectDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, modelid, Float:x, Float:y, Float:z)
{
	CancelSelectTextDraw(playerid);

	new dynObjectType[1] = {DYN_OBJ_TYPE_NONE};
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, dynObjectType, sizeof(dynObjectType));

	switch(dynObjectType[0])
	{
		case DYN_OBJ_TYPE_NONE: OnGenericDynamicObjectSelection(playerid, objectid, modelid);
		case DYN_OBJ_TYPE_MAPRO: Mapro_OnDynamicObjectSelection(playerid, objectid, modelid);
		case DYN_OBJ_TYPE_FURN: Furn_OnDynamicObjectSelection(playerid, objectid, modelid);
		case DYN_OBJ_TYPE_GRAFFITI: Graffiti_OnObjSelect(playerid, objectid, modelid);
	}
	return 1;
}