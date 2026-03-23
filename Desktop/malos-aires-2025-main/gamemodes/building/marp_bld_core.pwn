#if defined _marp_buildings_core_included
	#endinput
#endif
#define _marp_buildings_core_included

/*__________________________________________________________________________________

                       __                          __        __        
   _____ __  __ _____ / /_ ___   ____ ___     ____/ /____ _ / /_ ____ _
  / ___// / / // ___// __// _ \ / __ `__ \   / __  // __ `// __// __ `/
 (__  )/ /_/ /(__  )/ /_ /  __// / / / / /  / /_/ // /_/ // /_ / /_/ / 
/____/ \__, //____/ \__/ \___//_/ /_/ /_/   \__,_/ \__,_/ \__/ \__,_/  
      /____/                                                           

___________________________________________________________________________________*/

#define MAX_BUILDINGS               (100)
#define BUILDING_VW_OFFSET		    (1000)

#define BLD_MAX_TEXT_LENGTH    		(64)

const BUILDING_RESET_ID = 0;
const INVALID_BLD_ID = 0;

enum e_Bld_INFO 
{
	blFaction,
    bool:blLocked,
    blOutsideText[BLD_MAX_TEXT_LENGTH],
    blInsideText[BLD_MAX_TEXT_LENGTH],

    /* Outside Point */
	Float:blOutsideX,
	Float:blOutsideY,
	Float:blOutsideZ,
	Float:blOutsideAngle,
	blOutsideWorld,
	blOutsideInt,
	STREAMER_TAG_3D_TEXT_LABEL:blOutsideLabel,
	STREAMER_TAG_PICKUP:blOutsidePickup,

	/* Inside Point */
	Float:blInsideX,
	Float:blInsideY,
	Float:blInsideZ,
	Float:blInsideAngle,
	blInsideWorld,
	blInsideInt,
	STREAMER_TAG_3D_TEXT_LABEL:blInsideLabel,
	STREAMER_TAG_PICKUP:blInsidePickup,

    blOusidePickupModel
}

new BuildingInfo[MAX_BUILDINGS][e_Bld_INFO] = {
    {
		/*blFaction*/ 0,
        /*bool:blLocked*/ false,
        /*blOutsideText[BLD_MAX_TEXT_LENGTH]*/ "Entrada",
        /*blInsideText[BLD_MAX_TEXT_LENGTH]*/ "Salida",

        /*blOutsideX*/ 0.0,
		/*blOutsideY*/ 0.0,
		/*blOutsideZ*/ 0.0,
		/*blOutsideAngle*/ 0.0,
		/*blOutsideWorld*/ 0,
		/*blOutsideInt*/ 0,
		/*blOutsideLabel*/ STREAMER_TAG_3D_TEXT_LABEL:0,
		/*blOutsidePickup*/ STREAMER_TAG_PICKUP:0,

		/*blInsideX*/ 0.0,
		/*blInsideY*/ 0.0,
		/*blInsideZ*/ 0.0,
		/*blInsideAngle*/ 0.0,
		/*blInsideWorld*/ 0,
		/*blInsideInt*/ 0,
		/*blInsideLabel*/ STREAMER_TAG_3D_TEXT_LABEL:0,
		/*blInsidePickup*/ STREAMER_TAG_PICKUP:0,

        /*blOusidePickupModel*/ 0
    }, ...
};

new Iterator:BuildingInfo<MAX_BUILDINGS>;

/*_____________________________________________________________________________________________________________

    ____                 __  _
   / __/_  ______  _____/ /_(_)___  ____  _____
  / /_/ / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
 / __/ /_/ / / / / /__/ /_/ / /_/ / / / (__  )
/_/  \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/


______________________________________________________________________________________________________________*/

Bld_Init() {
    Iter_Add(BuildingInfo, BUILDING_RESET_ID); // Init de id 0 para que no aparezca libre. 
}

Bld_IsValidId(buildid) {
    return ((buildid) ? (bool:Iter_Contains(BuildingInfo, buildid)) : (false));
}

Bld_Create(mapid, factionid, bool:locked, const outsideText[], const insideText[], Float:outsideX, Float:outsideY, Float:outsideZ, Float:outsideAngle, outsideWorld, outsideInt, pickupModel)
{
	new buildid = Iter_Free(BuildingInfo);

	if(buildid == ITER_NONE)
	{
		printf("[ERROR] Alcanzado MAX_BUILDINGS (%i). Iter_Count: %i.", MAX_BUILDINGS, Iter_Count(BuildingInfo));
		return BUILDING_RESET_ID;
	}

	if(!IsValidServerInterior(mapid) || isnull(outsideText))
		return BUILDING_RESET_ID;

	BuildingInfo[buildid][blFaction] = factionid;
	BuildingInfo[buildid][blLocked] = locked;
	BuildingInfo[buildid][blOusidePickupModel] = pickupModel;

	strcopy(BuildingInfo[buildid][blOutsideText], outsideText, BLD_MAX_TEXT_LENGTH);
	strcopy(BuildingInfo[buildid][blInsideText], insideText, BLD_MAX_TEXT_LENGTH);

	GetServerInteriorInfo(mapid,  BuildingInfo[buildid][blInsideX],  BuildingInfo[buildid][blInsideY],  BuildingInfo[buildid][blInsideZ],  BuildingInfo[buildid][blInsideAngle],  BuildingInfo[buildid][blInsideInt]);
	BuildingInfo[buildid][blInsideWorld] = BUILDING_VW_OFFSET + buildid;

	BuildingInfo[buildid][blOutsideX] = outsideX;
	BuildingInfo[buildid][blOutsideY] = outsideY;
	BuildingInfo[buildid][blOutsideZ] = outsideZ;
	BuildingInfo[buildid][blOutsideAngle] = outsideAngle;
	BuildingInfo[buildid][blOutsideInt] = outsideInt;
	BuildingInfo[buildid][blOutsideWorld] = outsideWorld;

	Iter_Add(BuildingInfo, buildid);

	Bld_ReloadAllPoints(buildid);
	Bld_SQLCreate(buildid);
	return buildid;
}

Bld_Delete(buildid)
{
	if(!Bld_IsValidId(buildid))
		return 0;
	
	Bld_DestroyAllPoints(buildid, .save = false);
	Bld_SQLDelete(buildid);
	Iter_Remove(BuildingInfo, buildid);
	BuildingInfo[buildid] = BuildingInfo[BUILDING_RESET_ID];
	return 1;
}

Bld_SetPickupModel(buildid, newpickup)
{
	if(!Bld_IsValidId(buildid))
		return 0;
	
	BuildingInfo[buildid][blOusidePickupModel] = newpickup;
	Bld_SQLSavePickupModel(buildid);
	Bld_ReloadOutsidePoint(buildid);
	return 1;
}

Bld_SetOutsideText(buildid, const text[])
{
	if(!Bld_IsValidId(buildid))
		return 0;

	strcopy(BuildingInfo[buildid][blOutsideText], text, BLD_MAX_TEXT_LENGTH);

	Bld_SQLSaveOutsideText(buildid);
	Bld_ReloadOutsidePoint(buildid);
	return 1;
}

Bld_SetInsideText(buildid, const text[])
{
	if(!Bld_IsValidId(buildid))
		return 0;

	strcopy(BuildingInfo[buildid][blInsideText], text, BLD_MAX_TEXT_LENGTH);

	Bld_SQLSaveInsideText(buildid);
	Bld_ReloadInsidePoint(buildid);
	return 1;
}

Bld_SetLocked(buildid, locked)
{
	if(!Bld_IsValidId(buildid))
		return 0;
	if(locked < 0 || locked > 1)
		return 0;

	BuildingInfo[buildid][blLocked] = bool:locked;
	Bld_SQLSaveLocked(buildid);
	return 1;
}

Bld_PrintInfoForPlayer(playerid, buildid)
{
	if(!Bld_IsValidId(buildid))
		return 0;

	new string[128];

	SendFMessage(playerid, COLOR_WHITE, "________________________[Edificio ID %i]________________________", buildid);
	SendFMessage(playerid, COLOR_WHITE, "- Facción: %i - Pickup: %i - Puerta: %s", BuildingInfo[buildid][blFaction], BuildingInfo[buildid][blOusidePickupModel], (!BuildingInfo[buildid][blLocked]) ? ("abierta") : ("cerrada"));
	
	Bld_GetOutsidePointInfo(buildid, string, sizeof(string));
	SendFMessage(playerid, COLOR_WHITE, "- Entrada %s", string);
	Bld_GetInsidePointInfo(buildid, string, sizeof(string));
	SendFMessage(playerid, COLOR_WHITE, "- Salida %s", string);
	return 1;
}

Bld_SetFaction(buildid, factionid)
{
	if(!Bld_IsValidId(buildid))
		return 0;

	BuildingInfo[buildid][blFaction] = factionid;
	Bld_SQLSaveFaction(buildid);
	return 1;
}

Bld_GetOusideText(buildid, text[]) {
	strcopy(text, BuildingInfo[buildid][blOutsideText], BLD_MAX_TEXT_LENGTH);
}

Bld_GetFaction(buildid) {
	return BuildingInfo[buildid][blFaction];
}

Bld_GetLocked(buildid) {
	return BuildingInfo[buildid][blLocked];
}