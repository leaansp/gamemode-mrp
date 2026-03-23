#if defined _marp_garages_core_inc
	#endinput
#endif
#define _marp_garages_core_inc

/*__________________________________________________________________________________

                       __                          __        __        
   _____ __  __ _____ / /_ ___   ____ ___     ____/ /____ _ / /_ ____ _
  / ___// / / // ___// __// _ \ / __ `__ \   / __  // __ `// __// __ `/
 (__  )/ /_/ /(__  )/ /_ /  __// / / / / /  / /_/ // /_/ // /_ / /_/ / 
/____/ \__, //____/ \__/ \___//_/ /_/ /_/   \__,_/ \__,_/ \__/ \__,_/  
      /____/                                                           

___________________________________________________________________________________*/

#define MAX_GARAGES                 (MAX_HOUSES + MAX_BUSINESS)
#define GARAGE_VW_OFFSET            (20000)

#define GARAGE_TYPE_MAX_NAME_LEN    (64)

const GARAGE_INVALID_ID = 0;
const GARAGE_RESET_ID = 0;

enum
{
    GARAGE_TYPE_NONE,
    GARAGE_TYPE_HOUSE,
    GARAGE_TYPE_BUSINESS,
    GARAGE_TYPE_FACTION,

    /*LEAVE LAST*/ GARAGE_TYPE_AMOUNT
}

static GarageTypeName[GARAGE_TYPE_AMOUNT][GARAGE_TYPE_MAX_NAME_LEN] = {"-", "Casa", "Negocio", "Facción"};

enum e_GARAGE_DATA
{
    gType,
    gExtraId,
    gLocked,

    Float:gOutsideX,
    Float:gOutsideY,
    Float:gOutsideZ,
    Float:gOutsideAng,
    gOutsideInt,
    gOutsideVW,
    Float:gOutsideAreaX,
    Float:gOutsideAreaY,
    Float:gOutsideAreaZ,
    STREAMER_TAG_AREA:gOutsideArea,

    Float:gInsideX,
    Float:gInsideY,
    Float:gInsideZ,
    Float:gInsideAng,
    gInsideInt,
    gInsideVW,
    Float:gInsideAreaX,
    Float:gInsideAreaY,
    Float:gInsideAreaZ,
    STREAMER_TAG_AREA:gInsideArea
}

new GarageInfo[MAX_GARAGES][e_GARAGE_DATA] = {
    {
        /*gType*/ GARAGE_TYPE_NONE,
        /*gExtraId*/ 0,
        /*gLocked*/ 0,

        /*Float:gOutsideX*/ 0.0,
        /*Float:gOutsideY*/ 0.0,
        /*Float:gOutsideZ*/ 0.0,
        /*Float:gOutsideAng*/ 0.0,
        /*gOutsideInt*/ 0,
        /*gOutsideVW*/ 0,
        /*Float:gOutsideAreaX*/ 0.0,
        /*Float:gOutsideAreaY*/ 0.0,
        /*Float:gOutsideAreaZ*/ 0.0,
        /*STREAMER_TAG_AREA:gOutsideArea*/ STREAMER_TAG_AREA:0,

        /*Float:gInsideX*/ 0.0,
        /*Float:gInsideY*/ 0.0,
        /*Float:gInsideZ*/ 0.0,
        /*Float:gInsideAng*/ 0.0,
        /*gInsideInt*/ 0,
        /*gInsideVW*/ 0,
        /*Float:gInsideAreaX*/ 0.0,
        /*Float:gInsideAreaY*/ 0.0,
        /*Float:gInsideAreaZ*/ 0.0,
        /*STREAMER_TAG_AREA:gInsideArea*/ STREAMER_TAG_AREA:0
    }, ...     
};

new Iterator:GarageInfo<MAX_GARAGES>;

/*_____________________________________________________________________________________________________________

    ____                 __  _
   / __/_  ______  _____/ /_(_)___  ____  _____
  / /_/ / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
 / __/ /_/ / / / / /__/ /_/ / /_/ / / / (__  )
/_/  \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/


______________________________________________________________________________________________________________*/

Garage_Init() 
{
    Iter_Add(GarageInfo, GARAGE_INVALID_ID); // Init de id 0 para que no aparezca libre. 
}

Garage_IsValidId(garageid) {
    return ((garageid) ? (bool:Iter_Contains(GarageInfo, garageid)) : (false));
}

Garage_IsValidType(type) {
    return (GARAGE_TYPE_NONE < type < GARAGE_TYPE_AMOUNT);
}

Garage_Create(type, extraid, Float:outsideX, Float:outsideY, Float:outsideZ, Float:outsideAng, outsideVW, outsideInt, mapid, locked)
{
    new garageid = Iter_Free(GarageInfo);

	if(garageid == ITER_NONE)
	{
		printf("[ERROR] Alcanzado MAX_GARAGES (%i). Iter_Count: %i.", MAX_GARAGES, Iter_Count(GarageInfo));
		return GARAGE_INVALID_ID;
	}

    if(!IsValidServerInterior(mapid) || !IsServerInteriorGarage(mapid))
		return BUILDING_RESET_ID;

    GarageInfo[garageid][gType] = type;
    GarageInfo[garageid][gExtraId] = extraid;
    GarageInfo[garageid][gLocked] = locked;

    GarageInfo[garageid][gOutsideX] = outsideX;
    GarageInfo[garageid][gOutsideY] = outsideY;
    GarageInfo[garageid][gOutsideZ] = outsideZ;
    GarageInfo[garageid][gOutsideAng] = outsideAng;
    GarageInfo[garageid][gOutsideInt] = outsideInt;
    GarageInfo[garageid][gOutsideVW] = outsideVW;

    GarageInfo[garageid][gOutsideAreaX] = outsideX;
    GarageInfo[garageid][gOutsideAreaY] = outsideY;
    GarageInfo[garageid][gOutsideAreaZ] = outsideZ;

    GetServerInteriorInfo(mapid,  GarageInfo[garageid][gInsideX],  GarageInfo[garageid][gInsideY],  GarageInfo[garageid][gInsideZ],  GarageInfo[garageid][gInsideAng],  GarageInfo[garageid][gInsideInt]);
	GarageInfo[garageid][gInsideVW] = GARAGE_VW_OFFSET + garageid;

    GarageInfo[garageid][gInsideAreaX] = GarageInfo[garageid][gInsideX];
    GarageInfo[garageid][gInsideAreaY] = GarageInfo[garageid][gInsideY];
    GarageInfo[garageid][gInsideAreaZ] = GarageInfo[garageid][gInsideZ];

    Iter_Add(GarageInfo, garageid);
    Garage_ReloadAreas(garageid);
    Garage_SQLCreate(garageid);
    return garageid;
}

Garage_Delete(garageid)
{
	if(!Garage_IsValidId(garageid))
		return 0;
	
	Garage_DestroyAllPointsAreas(garageid, .save = false);
	Garage_SQLDelete(garageid);
	Iter_Remove(GarageInfo, garageid);
	GarageInfo[garageid] = GarageInfo[BUILDING_RESET_ID];
	return 1;
}

Garage_SetType(garageid, type) 
{
    if(!Garage_IsValidId(garageid))
		return 0;
    if(!Garage_IsValidType(type))
		return 0;

    GarageInfo[garageid][gType] = type;
    Garage_SQLSaveType(garageid);
    return 1;
}

stock Garage_GetType(garageid) {
    return GarageInfo[garageid][gType];
}

Garage_SetExtraId(garageid, extraid)
{
    if(!Garage_IsValidId(garageid))
		return 0;
    
    GarageInfo[garageid][gExtraId] = extraid;
    Garage_SQLSaveExtraId(garageid);
    return 1;
}

stock Garage_GetExtraId(garageid) {
    return GarageInfo[garageid][gExtraId];
}

Garage_OnEnter(playerid, garageid)
{
    switch(GarageInfo[garageid][gType])
    {
        case GARAGE_TYPE_BUSINESS: Biz_SetPlayerLastId(playerid, GarageInfo[garageid][gExtraId]);
        case GARAGE_TYPE_HOUSE: House_SetPlayerLastId(playerid, GarageInfo[garageid][gExtraId]);
    }
    return 1;
}

Garage_OnExit(playerid, garageid)
{
    switch(GarageInfo[garageid][gType])
    {
        case GARAGE_TYPE_BUSINESS: Biz_SetPlayerLastId(playerid, 0);
        case GARAGE_TYPE_HOUSE: House_SetPlayerLastId(playerid, 0);
    }
    return 1;
}

Garage_PrintTypesFor(playerid)
{
    new line[64], str[256] = "[INFO] "COLOR_EMB_GREY" Tipos disponibles: [";

    for (new i = 1; i < GARAGE_TYPE_AMOUNT; i++)
    {
        format(line, 64, "%i: %s - ", i, GarageTypeName[i]);
        strcat(str, line, 256);
    }

    strcat(str, "]", 256);
    SendClientMessage(playerid, COLOR_INFO, str);
    return 1;
}

Garage_GetTypeName(type) {
    return GarageTypeName[type];
}

Garage_PrintInfoForPlayer(playerid, garageid)
{
	if(!Garage_IsValidId(garageid))
		return 0;

	new string[128];

	SendFMessage(playerid, COLOR_WHITE, "________________________[Garaje ID %i]________________________", garageid);
	SendFMessage(playerid, COLOR_WHITE, "- Tipo: %i - ExtraId: %i - Puerta: %s", GarageInfo[garageid][gType], GarageInfo[garageid][gExtraId], (!GarageInfo[garageid][gLocked]) ? ("abierta") : ("cerrada"));
	
	Garage_GetOutsidePointInfo(garageid, string, sizeof(string));
	SendFMessage(playerid, COLOR_WHITE, "- Punto exterior %s", string);
    Garage_GetOutsideAreaInfo(garageid, string, sizeof(string));
	SendFMessage(playerid, COLOR_WHITE, "- Area exterior %s", string);
	Garage_GetInsidePointInfo(garageid, string, sizeof(string));
	SendFMessage(playerid, COLOR_WHITE, "- Punto interior %s", string);
    Garage_GetInsideAreaInfo(garageid, string, sizeof(string));
	SendFMessage(playerid, COLOR_WHITE, "- Area interior %s", string);
	return 1;
}

Garage_SetLocked(garageid, locked)
{
    if(!Garage_IsValidId(garageid))
		return 0;

    GarageInfo[garageid][gLocked] = locked;
    Garage_SQLSaveLocked(garageid);
    return 1;
}

stock Garage_IsLocked(garageid) {
    return GarageInfo[garageid][gLocked];
}

Garage_CanUse(playerid, garageid)
{
    if(AdminDuty[playerid])
        return 1;
    
    switch (GarageInfo[garageid][gType])
    {
        case GARAGE_TYPE_HOUSE: return KeyChain_Contains(playerid, KEY_TYPE_HOUSE, GarageInfo[garageid][gExtraId]);
        case GARAGE_TYPE_BUSINESS: return KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, GarageInfo[garageid][gExtraId]);
        case GARAGE_TYPE_FACTION: return (PlayerInfo[playerid][pFaction] == GarageInfo[garageid][gExtraId] && PlayerInfo[playerid][pFaction]);
    }

    return 0;
}