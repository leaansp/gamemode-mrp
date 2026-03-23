#if defined _marp_buildings_coords_included
	#endinput
#endif
#define _marp_buildings_coords_included

#include <YSI_Coding\y_hooks>

#define BLD_OUT_PICKUP_STREAM_DIST (35.0)
#define BLD_OUT_LABEL_STREAM_DIST (10.0)
#define BLD_OUT_LABEL_DRAW_DIST (10.0)
#define BLD_OUT_LABEL_COLOR COLOR_DLG_DEFAULT
#define BLD_OUT_LABEL_COLOR_EMB COLOR_EMB_DLG_DEFAULT

#define BLD_INS_PICKUP_STREAM_DIST (35.0)
#define BLD_INS_LABEL_STREAM_DIST (10.0)
#define BLD_INS_LABEL_DRAW_DIST (10.0)
#define BLD_INS_LABEL_COLOR COLOR_DLG_DEFAULT
#define BLD_INS_LABEL_COLOR_EMB COLOR_EMB_DLG_DEFAULT

static playerInBuildingId[MAX_PLAYERS];

/*__________________________________________________________________________________________

              __                                            _       __
  ___  ____  / /__________ _____  ________     ____  ____  (_)___  / /_
 / _ \/ __ \/ __/ ___/ __ `/ __ \/ ___/ _ \   / __ \/ __ \/ / __ \/ __/
/  __/ / / / /_/ /  / /_/ / / / / /__/  __/  / /_/ / /_/ / / / / / /_
\___/_/ /_/\__/_/   \__,_/_/ /_/\___/\___/  / .___/\____/_/_/ /_/\__/
                                           /_/

____________________________________________________________________________________________*/

static Bld_DestroyOutsidePickup(buildid)
{
	if(BuildingInfo[buildid][blOutsidePickup])
	{
		DestroyDynamicPickup(BuildingInfo[buildid][blOutsidePickup]);
		BuildingInfo[buildid][blOutsidePickup] = STREAMER_TAG_PICKUP:0;
	}
}

static Bld_DestroyOutsideLabel(buildid)
{
	if(BuildingInfo[buildid][blOutsideLabel])
	{
		DestroyDynamic3DTextLabel(BuildingInfo[buildid][blOutsideLabel]);
		BuildingInfo[buildid][blOutsideLabel] = STREAMER_TAG_3D_TEXT_LABEL:0;
	}	
}

static Bld_ReloadOutsidePickup(buildid)
{
	Bld_DestroyOutsidePickup(buildid);
	BuildingInfo[buildid][blOutsidePickup] = CreateDynamicPickup(BuildingInfo[buildid][blOusidePickupModel], 1, BuildingInfo[buildid][blOutsideX], BuildingInfo[buildid][blOutsideY], BuildingInfo[buildid][blOutsideZ], BuildingInfo[buildid][blOutsideWorld], -1, -1, BLD_OUT_PICKUP_STREAM_DIST);
	Streamer_SetExtraIdArray(STREAMER_TYPE_PICKUP, BuildingInfo[buildid][blOutsidePickup], STREAMER_ARRAY_TYPE_BUILDING, buildid);
}

static Bld_ReloadOutsideLabel(buildid)
{
	Bld_DestroyOutsideLabel(buildid);

	new string[256];
	strcat(string, BuildingInfo[buildid][blOutsideText], sizeof(string));
	strcat(string, "\n(~k~~GROUP_CONTROL_BWD~) Entrar", sizeof(string));

	BuildingInfo[buildid][blOutsideLabel] = CreateDynamic3DTextLabel(string, BLD_OUT_LABEL_COLOR, BuildingInfo[buildid][blOutsideX], BuildingInfo[buildid][blOutsideY], BuildingInfo[buildid][blOutsideZ] + 0.75, .drawdistance = BLD_OUT_LABEL_DRAW_DIST, .testlos = 1, .worldid = BuildingInfo[buildid][blOutsideWorld], .streamdistance = BLD_OUT_LABEL_STREAM_DIST);
}

Bld_ReloadOutsidePoint(buildid)
{
	Bld_ReloadOutsidePickup(buildid);
	Bld_ReloadOutsideLabel(buildid);
}

Bld_SetOutsidePoint(buildid, Float:x, Float:y, Float:z, Float:angle, world, interior, bool:save = true)
{
	if(!Bld_IsValidId(buildid))
		return 0;

	BuildingInfo[buildid][blOutsideX] = x;
	BuildingInfo[buildid][blOutsideY] = y;
	BuildingInfo[buildid][blOutsideZ] = z;
	BuildingInfo[buildid][blOutsideAngle] = angle;
	BuildingInfo[buildid][blOutsideWorld] = world;
	BuildingInfo[buildid][blOutsideInt] = interior;

	Bld_ReloadOutsidePoint(buildid);

	if(save) {
		Bld_SQLSaveOutsidePoint(buildid);
	}
	return 1;
}

Bld_DestroyOutsidePoint(buildid)
{
	Bld_DestroyOutsidePickup(buildid);
	Bld_DestroyOutsideLabel(buildid);

	BuildingInfo[buildid][blOutsideX] = BuildingInfo[buildid][blOutsideY] = BuildingInfo[buildid][blOutsideZ] = 0.0;
	BuildingInfo[buildid][blOutsideWorld] = BuildingInfo[buildid][blOutsideInt] = 0;
}

Bld_GetOutsidePointInfo(buildid, string[], size = sizeof(string)) {
	format(string, size, "[X: %.2f - Y: %.2f - Z: %.2f - Int: %i - VWorld: %i]", BuildingInfo[buildid][blOutsideX], BuildingInfo[buildid][blOutsideY], BuildingInfo[buildid][blOutsideZ], BuildingInfo[buildid][blOutsideInt], BuildingInfo[buildid][blOutsideWorld]);
}

Bld_IsPlayerAtOutsideDoorId(playerid, buildid) {
	return (GetPlayerVirtualWorld(playerid) == BuildingInfo[buildid][blOutsideWorld] && IsPlayerInRangeOfPoint(playerid, 0.8, BuildingInfo[buildid][blOutsideX], BuildingInfo[buildid][blOutsideY], BuildingInfo[buildid][blOutsideZ]));
}

stock Bld_IsPlayerAtOutDoorRangeId(playerid, buildid, Float:range) {
	return (GetPlayerVirtualWorld(playerid) == BuildingInfo[buildid][blOutsideWorld] && IsPlayerInRangeOfPoint(playerid, range, BuildingInfo[buildid][blOutsideX], BuildingInfo[buildid][blOutsideY], BuildingInfo[buildid][blOutsideZ]));
}

stock Bld_IsPlayerAtOutsideDoorAny(playerid) {
	return (Bld_IsValidId(playerInBusinessId[playerid]) && Bld_IsPlayerAtOutsideDoorId(playerid, playerInBusinessId[playerid])) ? (playerInBusinessId[playerid]) : (0);
}

Bld_TpPlayerToOutsideDoorId(playerid, buildid)
{
	TeleportPlayerTo(playerid, BuildingInfo[buildid][blOutsideX], BuildingInfo[buildid][blOutsideY], BuildingInfo[buildid][blOutsideZ], BuildingInfo[buildid][blOutsideAngle], BuildingInfo[buildid][blOutsideInt], BuildingInfo[buildid][blOutsideWorld]);
	return 1;
}

stock Bld_GetOutDoorPos(buildid, &Float:x, &Float:y, &Float:z) {
	x = BuildingInfo[buildid][blOutsideX], y = BuildingInfo[buildid][blOutsideY], z = BuildingInfo[buildid][blOutsideZ];
}

stock Bld_GetOutDoorWorld(buildid) {
	return BuildingInfo[buildid][blOutsideWorld];
}

stock Float:Bld_GetOutDoorAngle(buildid) {
	return BuildingInfo[buildid][blOutsideAngle];
}

/*__________________________________________________________________________________________________

             _ __                 _       __
  ___  _  __(_) /_   ____  ____  (_)___  / /_
 / _ \| |/_/ / __/  / __ \/ __ \/ / __ \/ __/
/  __/>  </ / /_   / /_/ / /_/ / / / / / /_
\___/_/|_/_/\__/  / .___/\____/_/_/ /_/\__/
                 /_/

____________________________________________________________________________________________________*/

static Bld_DestroyInsidePickup(buildid)
{
	if(BuildingInfo[buildid][blInsidePickup])
	{
		DestroyDynamicPickup(BuildingInfo[buildid][blInsidePickup]);
		BuildingInfo[buildid][blInsidePickup] = STREAMER_TAG_PICKUP:0;
	}
}

static Bld_DestroyInsideLabel(buildid)
{
	if(BuildingInfo[buildid][blInsideLabel])
	{
		DestroyDynamic3DTextLabel(BuildingInfo[buildid][blInsideLabel]);
		BuildingInfo[buildid][blInsideLabel] = STREAMER_TAG_3D_TEXT_LABEL:0;
	}	
}

static Bld_ReloadInsidePickup(buildid)
{
	Bld_DestroyInsidePickup(buildid);
	BuildingInfo[buildid][blInsidePickup] = CreateDynamicPickup(19198, 1, BuildingInfo[buildid][blInsideX], BuildingInfo[buildid][blInsideY], BuildingInfo[buildid][blInsideZ], BuildingInfo[buildid][blInsideWorld], -1, -1, BLD_INS_PICKUP_STREAM_DIST);
	Streamer_SetExtraIdArray(STREAMER_TYPE_PICKUP, BuildingInfo[buildid][blInsidePickup], STREAMER_ARRAY_TYPE_BUILDING, buildid);
}

static Bld_ReloadInsideLabel(buildid)
{
	Bld_DestroyInsideLabel(buildid);

	new string[256];
	strcat(string, BuildingInfo[buildid][blInsideText], sizeof(string));
	strcat(string, "\n(~k~~GROUP_CONTROL_BWD~) Salir", sizeof(string));

	BuildingInfo[buildid][blInsideLabel] = CreateDynamic3DTextLabel(string, BLD_INS_LABEL_COLOR, BuildingInfo[buildid][blInsideX], BuildingInfo[buildid][blInsideY], BuildingInfo[buildid][blInsideZ] + 0.70, BLD_INS_LABEL_DRAW_DIST, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, BuildingInfo[buildid][blInsideWorld], -1, -1, BLD_INS_LABEL_STREAM_DIST);
}

Bld_ReloadInsidePoint(buildid)
{
	Bld_ReloadInsidePickup(buildid);
	Bld_ReloadInsideLabel(buildid);
}

Bld_SetInsidePoint(buildid, Float:x, Float:y, Float:z, Float:angle, world, interior, bool:save = true)
{
	if(!Bld_IsValidId(buildid))
		return 0;

	BuildingInfo[buildid][blInsideX] = x;
	BuildingInfo[buildid][blInsideY] = y;
	BuildingInfo[buildid][blInsideZ] = z;
	BuildingInfo[buildid][blInsideAngle] = angle;
	BuildingInfo[buildid][blInsideWorld] = world;
	BuildingInfo[buildid][blInsideInt] = interior;

	Bld_ReloadInsidePoint(buildid);

	if(save) {
		Bld_SQLSaveInsidePoint(buildid);
	}
	return 1;
}

Bld_DestroyInsidePoint(buildid)
{
	Bld_DestroyInsidePickup(buildid);
	Bld_DestroyInsideLabel(buildid);

	BuildingInfo[buildid][blInsideX] = BuildingInfo[buildid][blInsideY] = BuildingInfo[buildid][blInsideZ] = 0.0;
	BuildingInfo[buildid][blInsideWorld] = BuildingInfo[buildid][blInsideInt] = 0;
}

Bld_GetInsidePointInfo(buildid, string[], size = sizeof(string)) {
	format(string, size, "[X: %.2f - Y: %.2f - Z: %.2f - Int: %i - VWorld: %i]", BuildingInfo[buildid][blInsideX], BuildingInfo[buildid][blInsideY], BuildingInfo[buildid][blInsideZ], BuildingInfo[buildid][blInsideInt], BuildingInfo[buildid][blInsideWorld]);
}

Bld_IsPlayerAtInsideDoorId(playerid, buildid) {
	return (GetPlayerVirtualWorld(playerid) == BuildingInfo[buildid][blInsideWorld] && IsPlayerInRangeOfPoint(playerid, 0.8, BuildingInfo[buildid][blInsideX], BuildingInfo[buildid][blInsideY], BuildingInfo[buildid][blInsideZ]));
}

stock Bld_IsPlayerAtInDoorRangeId(playerid, buildid, Float:range) {
	return (GetPlayerVirtualWorld(playerid) == BuildingInfo[buildid][blInsideWorld] && IsPlayerInRangeOfPoint(playerid, range, BuildingInfo[buildid][blInsideX], BuildingInfo[buildid][blInsideY], BuildingInfo[buildid][blInsideZ]));
}

stock Bld_IsPlayerAtInsideDoorAny(playerid) {
	return (Bld_IsValidId(playerInBuildingId[playerid]) && Bld_IsPlayerAtInsideDoorId(playerid, playerInBuildingId[playerid])) ? (playerInBuildingId[playerid]) : (0);
}

Bld_TpPlayerToInsideDoorId(playerid, buildid)
{
	TeleportPlayerTo(playerid, BuildingInfo[buildid][blInsideX], BuildingInfo[buildid][blInsideY], BuildingInfo[buildid][blInsideZ], BuildingInfo[buildid][blInsideAngle], BuildingInfo[buildid][blInsideInt], BuildingInfo[buildid][blInsideWorld]);
	return 1;
}

stock Bld_GetInDoorPos(buildid, &Float:x, &Float:y, &Float:z) {
	x = BuildingInfo[buildid][blInsideX], y = BuildingInfo[buildid][blInsideY], z = BuildingInfo[buildid][blInsideZ];
}

stock Bld_GetInDoorWorld(buildid) {
	return BuildingInfo[buildid][blInsideWorld];
}

stock Bld_GetInDoorInt(buildid) {
	return BuildingInfo[buildid][blInsideInt];
}

stock Float:Bld_GetInDoorAngle(buildid) {
	return BuildingInfo[buildid][blInsideAngle];
}

/*__________________________________________________________________________________________________


  _________  ____ ___  ____ ___  ____  ____
 / ___/ __ \/ __ `__ \/ __ `__ \/ __ \/ __ \
/ /__/ /_/ / / / / / / / / / / / /_/ / / / /
\___/\____/_/ /_/ /_/_/ /_/ /_/\____/_/ /_/


____________________________________________________________________________________________________*/

Bld_ReloadAllPoints(buildid)
{
	if(!Bld_IsValidId(buildid))
		return 0;

	Bld_ReloadOutsidePoint(buildid);
	Bld_ReloadInsidePoint(buildid);
	return 1;
}

Bld_DestroyAllPoints(buildid, bool:save = true)
{
	if(!Bld_IsValidId(buildid))
		return 0;

	Bld_DestroyOutsidePoint(buildid);
	Bld_DestroyInsidePoint(buildid);

	if(save) {
		Bld_SQLSaveOutsidePoint(buildid);
		Bld_SQLSaveInsidePoint(buildid);
	}
	return 1;
}

stock Bld_IsPlayerAtAnyDoorId(playerid, buildid) {
	return (Bld_IsPlayerAtOutsideDoorId(playerid, buildid) || Bld_IsPlayerAtInsideDoorId(playerid, buildid));
}

stock Bld_IsPlayerAtAnyDoorRangeId(playerid, buildid, Float:range) {
	return (Bld_IsPlayerAtOutDoorRangeId(playerid, buildid, range) || Bld_IsPlayerAtInDoorRangeId(playerid, buildid, range));
}

stock Bld_IsPlayerAtAnyDoorAny(playerid) {
	return (Bld_IsValidId(playerInBuildingId[playerid]) && Bld_IsPlayerAtAnyDoorId(playerid, playerInBuildingId[playerid])) ? (playerInBuildingId[playerid]) : (0);
}

Bld_SyncBetweenPlayers(playerid, targetid) {
	playerInBuildingId[playerid] = playerInBuildingId[targetid];
}

Bld_OnPlayerEnterPickup(playerid, buildid) {
	playerInBuildingId[playerid] = buildid;
}

hook OnPlayerDisconnect(playerid, reason)
{
	playerInBuildingId[playerid] = 0;
	return 1;
}

Bld_GetPlayerLastId(playerid) {
	return (Bld_IsValidId(playerInBuildingId[playerid])) ? (playerInBuildingId[playerid]) : (0);
}

Bld_IsPlayerInsideId(playerid, buildid)
{
	if(!Bld_IsValidId(buildid))
		return 0;

	if(Business[buildid][bInsideWorld]) {
		return (Business[buildid][bInsideWorld] == GetPlayerVirtualWorld(playerid) && Business[buildid][bInsideInt] == GetPlayerInterior(playerid));
	} else {
		return (Bld_IsPlayerAtInsideDoorId(playerid, buildid));
	}
}

Bld_IsPlayerInsideAny(playerid) {
	return (Bld_IsPlayerInsideId(playerid, playerInBuildingId[playerid])) ? (playerInBuildingId[playerid]) : (0);
}

Bld_IsPlayerOutsideOrInsideId(playerid, buildid) {
	return (Bld_IsValidId(buildid) && (Bld_IsPlayerAtOutsideDoorId(playerid, buildid) || Bld_IsPlayerInsideId(playerid, buildid)));
}

Bld_IsPlayerOutsideOrInsideAny(playerid) {
	return (Bld_IsPlayerOutsideOrInsideId(playerid, playerInBuildingId[playerid])) ? (playerInBuildingId[playerid]) : (0);
}

hook LoadAccountDataEnded(playerid)
{
	if(BUILDING_VW_OFFSET < PlayerInfo[playerid][pVirtualWorld] <= (BUILDING_VW_OFFSET + MAX_BUILDINGS)) {
		playerInBuildingId[playerid] = PlayerInfo[playerid][pVirtualWorld] - BUILDING_VW_OFFSET;
	}
	return 1;
}