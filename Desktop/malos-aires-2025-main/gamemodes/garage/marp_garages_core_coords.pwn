#if defined _marp_garages_core_coords_inc
	#endinput
#endif
#define _marp_garages_core_coords_inc

#include <YSI_Coding\y_hooks>

static const Float:GARAGE_AREA_RADIUS = 4.0;

static enum e_GARAGE_PLAYER_DATA
{
	e_GARAGE_PLAYER_ID,
	STREAMER_TAG_AREA:e_GARAGE_PLAYER_AREA_ID
} 

static GaragePlayerData[MAX_PLAYERS][e_GARAGE_PLAYER_DATA] = {{GARAGE_INVALID_ID, STREAMER_TAG_AREA:0}, ...};

/*__________________________________________________________________________________________

              __                                            _       __
  ___  ____  / /__________ _____  ________     ____  ____  (_)___  / /_
 / _ \/ __ \/ __/ ___/ __ `/ __ \/ ___/ _ \   / __ \/ __ \/ / __ \/ __/
/  __/ / / / /_/ /  / /_/ / / / / /__/  __/  / /_/ / /_/ / / / / / /_
\___/_/ /_/\__/_/   \__,_/_/ /_/\___/\___/  / .___/\____/_/_/ /_/\__/
                                           /_/

____________________________________________________________________________________________*/

static Garage_DestroyOutsideArea(garageid)
{
	if(GarageInfo[garageid][gOutsideArea])
	{
		DestroyDynamicPickup(GarageInfo[garageid][gOutsideArea]);
		GarageInfo[garageid][gOutsideArea] = STREAMER_TAG_AREA:0;
	}
}

Garage_ReloadOutsideArea(garageid)
{
	Garage_DestroyOutsideArea(garageid);
	GarageInfo[garageid][gOutsideArea] = CreateDynamicCylinder(GarageInfo[garageid][gOutsideAreaX], GarageInfo[garageid][gOutsideAreaY], GarageInfo[garageid][gOutsideAreaZ] - 1, GarageInfo[garageid][gOutsideAreaZ] + 2, GARAGE_AREA_RADIUS, GarageInfo[garageid][gOutsideVW], GarageInfo[garageid][gOutsideInt]);
	Streamer_SetExtraIdArray(STREAMER_TYPE_AREA, GarageInfo[garageid][gOutsideArea], STREAMER_ARRAY_TYPE_GARAGE, garageid);
}

Garage_SetOutsidePoint(garageid, Float:x, Float:y, Float:z, Float:angle, world, interior, bool:save = true)
{
	if(!Garage_IsValidId(garageid))
		return 0;

	GarageInfo[garageid][gOutsideX] = x;
	GarageInfo[garageid][gOutsideY] = y;
	GarageInfo[garageid][gOutsideZ] = z;
	GarageInfo[garageid][gOutsideAng] = angle;
	GarageInfo[garageid][gOutsideVW] = world;
	GarageInfo[garageid][gOutsideInt] = interior;

	if(save) {
		Garage_SQLSaveOutsidePoint(garageid);
	}
	return 1;
}

Garage_SetOutsideArea(garageid, Float:x, Float:y, Float:z, bool:save = true)
{
	if(!Garage_IsValidId(garageid))
		return 0;

	GarageInfo[garageid][gOutsideAreaX] = x;
	GarageInfo[garageid][gOutsideAreaY] = y;
	GarageInfo[garageid][gOutsideAreaZ] = z;

	Garage_ReloadOutsideArea(garageid);

	if(save) {
		Garage_SQLSaveOutsideArea(garageid);
	}
	return 1;
}

Garage_DestroyOutsidePointArea(garageid)
{
	Garage_DestroyOutsideArea(garageid);

	GarageInfo[garageid][gOutsideX] = GarageInfo[garageid][gOutsideY] = GarageInfo[garageid][gOutsideZ] = 0.0;
	GarageInfo[garageid][gOutsideVW] = GarageInfo[garageid][gOutsideInt] = 0;
	GarageInfo[garageid][gOutsideAreaX] = GarageInfo[garageid][gOutsideAreaY] = GarageInfo[garageid][gOutsideAreaZ] = 0.0;
}

Garage_GetOutsidePointInfo(garageid, string[], size = sizeof(string)) {
	format(string, size, "[X: %.2f - Y: %.2f - Z: %.2f - Int: %i - VWorld: %i]", GarageInfo[garageid][gOutsideX], GarageInfo[garageid][gOutsideY], GarageInfo[garageid][gOutsideZ], GarageInfo[garageid][gOutsideInt], GarageInfo[garageid][gOutsideVW]);
}

Garage_GetOutsideAreaInfo(garageid, string[], size = sizeof(string)) {
	format(string, size, "[X: %.2f - Y: %.2f - Z: %.2f - Int: %i - VWorld: %i]", GarageInfo[garageid][gOutsideAreaX], GarageInfo[garageid][gOutsideAreaY], GarageInfo[garageid][gOutsideAreaZ], GarageInfo[garageid][gOutsideInt], GarageInfo[garageid][gOutsideVW]);
}

Garage_TpPlayerToOutsideId(playerid, garageid)
{
	TeleportPlayerTo(playerid, GarageInfo[garageid][gOutsideX], GarageInfo[garageid][gOutsideY], GarageInfo[garageid][gOutsideZ], GarageInfo[garageid][gOutsideAng], GarageInfo[garageid][gOutsideInt], GarageInfo[garageid][gOutsideVW]);
	return 1;
}

Garage_TpPlayerVehicleToOutside(playerid, garageid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return 0;

	new vehicleid = GetPlayerVehicleID(playerid);
	TeleportVehicleTo(vehicleid, GarageInfo[garageid][gOutsideX], GarageInfo[garageid][gOutsideY], GarageInfo[garageid][gOutsideZ], GarageInfo[garageid][gOutsideAng], GarageInfo[garageid][gOutsideInt], GarageInfo[garageid][gOutsideVW]);
	return 1;
}

stock Garage_GetOutDoorPos(garageid, &Float:x, &Float:y, &Float:z) {
	x = GarageInfo[garageid][gOutsideX], y = GarageInfo[garageid][gOutsideY], z = GarageInfo[garageid][gOutsideZ];
}

stock Garage_GetOutDoorWorld(garageid) {
	return GarageInfo[garageid][gOutsideVM];
}

stock Float:Garage_GetOutDoorAngle(garageid) {
	return GarageInfo[garageid][gOutsideAng];
}

stock Garage_IsInAnyOutsideArea(playerid) {
	return (GaragePlayerData[playerid][e_GARAGE_PLAYER_ID] && GaragePlayerData[playerid][e_GARAGE_PLAYER_AREA_ID] == GarageInfo[GaragePlayerData[playerid][e_GARAGE_PLAYER_ID]][gOutsideArea]) ? (GaragePlayerData[playerid][e_GARAGE_PLAYER_ID]) : (0);
}

stock Garage_IsInOutsideAreaId(playerid, garageid) {
	return (GaragePlayerData[playerid][e_GARAGE_PLAYER_AREA_ID] == GarageInfo[garageid][gOutsideArea]) ? (GaragePlayerData[playerid][e_GARAGE_PLAYER_ID]) : (0);
}

/*__________________________________________________________________________________________________

             _ __                 _       __
  ___  _  __(_) /_   ____  ____  (_)___  / /_
 / _ \| |/_/ / __/  / __ \/ __ \/ / __ \/ __/
/  __/>  </ / /_   / /_/ / /_/ / / / / / /_
\___/_/|_/_/\__/  / .___/\____/_/_/ /_/\__/
                 /_/

____________________________________________________________________________________________________*/

static Garage_DestroyInsideArea(garageid)
{
	if(GarageInfo[garageid][gInsideArea])
	{
		DestroyDynamicPickup(GarageInfo[garageid][gInsideArea]);
		GarageInfo[garageid][gInsideArea] = STREAMER_TAG_AREA:0;
	}
}

Garage_ReloadInsideArea(garageid)
{
	Garage_DestroyInsideArea(garageid);
	GarageInfo[garageid][gInsideArea] = CreateDynamicCylinder(GarageInfo[garageid][gInsideAreaX], GarageInfo[garageid][gInsideAreaY], GarageInfo[garageid][gInsideAreaZ] - 1, GarageInfo[garageid][gInsideAreaZ] + 2, GARAGE_AREA_RADIUS, GarageInfo[garageid][gInsideVW], GarageInfo[garageid][gInsideInt]);
	Streamer_SetExtraIdArray(STREAMER_TYPE_AREA, GarageInfo[garageid][gInsideArea], STREAMER_ARRAY_TYPE_GARAGE, garageid);
}

Garage_SetInsidePoint(garageid, Float:x, Float:y, Float:z, Float:angle, world, interior, bool:save = true)
{
	if(!Garage_IsValidId(garageid))
		return 0;

	GarageInfo[garageid][gInsideX] = x;
	GarageInfo[garageid][gInsideY] = y;
	GarageInfo[garageid][gInsideZ] = z;
	GarageInfo[garageid][gInsideAng] = angle;
	GarageInfo[garageid][gInsideVW] = world;
	GarageInfo[garageid][gInsideInt] = interior;

	if(save) {
		Garage_SQLSaveInsidePoint(garageid);
	}
	return 1;
}

Garage_SetInsideArea(garageid, Float:x, Float:y, Float:z, bool:save = true)
{
	if(!Garage_IsValidId(garageid))
		return 0;

	GarageInfo[garageid][gInsideAreaX] = x;
	GarageInfo[garageid][gInsideAreaY] = y;
	GarageInfo[garageid][gInsideAreaZ] = z;

	Garage_ReloadInsideArea(garageid);

	if(save) {
		Garage_SQLSaveInsideArea(garageid);
	}
	return 1;
}

Garage_DestroyInsidePointArea(garageid)
{
	Garage_DestroyInsideArea(garageid);

	GarageInfo[garageid][gInsideX] = GarageInfo[garageid][gInsideY] = GarageInfo[garageid][gInsideZ] = 0.0;
	GarageInfo[garageid][gInsideVW] = GarageInfo[garageid][gInsideInt] = 0;
	GarageInfo[garageid][gInsideAreaX] = GarageInfo[garageid][gInsideAreaY] = GarageInfo[garageid][gInsideAreaZ] = 0.0;
}

Garage_GetInsidePointInfo(garageid, string[], size = sizeof(string)) {
	format(string, size, "[X: %.2f - Y: %.2f - Z: %.2f - Int: %i - VWorld: %i]", GarageInfo[garageid][gInsideX], GarageInfo[garageid][gInsideY], GarageInfo[garageid][gInsideZ], GarageInfo[garageid][gInsideInt], GarageInfo[garageid][gInsideVW]);
}

Garage_GetInsideAreaInfo(garageid, string[], size = sizeof(string)) {
	format(string, size, "[X: %.2f - Y: %.2f - Z: %.2f - Int: %i - VWorld: %i]", GarageInfo[garageid][gInsideAreaX], GarageInfo[garageid][gInsideAreaY], GarageInfo[garageid][gInsideAreaZ], GarageInfo[garageid][gInsideInt], GarageInfo[garageid][gInsideVW]);
}

Garage_TpPlayerToInsideId(playerid, garageid)
{
	TeleportPlayerTo(playerid, GarageInfo[garageid][gInsideX], GarageInfo[garageid][gInsideY], GarageInfo[garageid][gInsideZ], GarageInfo[garageid][gInsideAng], GarageInfo[garageid][gInsideInt], GarageInfo[garageid][gInsideVW]);
	return 1;
}

Garage_TpPlayerVehicleToInside(playerid, garageid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return 0;

	new vehicleid = GetPlayerVehicleID(playerid);
	TeleportVehicleTo(vehicleid, GarageInfo[garageid][gInsideX], GarageInfo[garageid][gInsideY], GarageInfo[garageid][gInsideZ], GarageInfo[garageid][gInsideAng], GarageInfo[garageid][gInsideInt], GarageInfo[garageid][gInsideVW]);
	return 1;
}

stock Garage_GetInDoorWorld(garageid) {
	return GarageInfo[garageid][gInsideVM];
}

stock Float:Garage_GetInDoorAngle(garageid) {
	return GarageInfo[garageid][gInsideAng];
}

stock Garage_IsInAnyInsideArea(playerid) {
	return (GaragePlayerData[playerid][e_GARAGE_PLAYER_ID] && GaragePlayerData[playerid][e_GARAGE_PLAYER_AREA_ID] == GarageInfo[GaragePlayerData[playerid][e_GARAGE_PLAYER_ID]][gInsideArea]) ? (GaragePlayerData[playerid][e_GARAGE_PLAYER_ID]) : (0);
}

stock Garage_IsInInsideAreaId(playerid, garageid) {
	return (GaragePlayerData[playerid][e_GARAGE_PLAYER_AREA_ID] == GarageInfo[garageid][gInsideArea]) ? (GaragePlayerData[playerid][e_GARAGE_PLAYER_ID]) : (0);
}

/*__________________________________________________________________________________________________


  _________  ____ ___  ____ ___  ____  ____
 / ___/ __ \/ __ `__ \/ __ `__ \/ __ \/ __ \
/ /__/ /_/ / / / / / / / / / / / /_/ / / / /
\___/\____/_/ /_/ /_/_/ /_/ /_/\____/_/ /_/


____________________________________________________________________________________________________*/

Garage_ReloadAreas(garageid)
{
	if(!Garage_IsValidId(garageid))
		return 0;

	Garage_ReloadOutsideArea(garageid);
	Garage_ReloadInsideArea(garageid);
	return 1;
}

Garage_DestroyAllPointsAreas(garageid, bool:save = true)
{
	if(!Garage_IsValidId(garageid))
		return 0;

	Garage_DestroyOutsidePointArea(garageid);
	Garage_DestroyInsidePointArea(garageid);

	if(save) {
		Garage_SQLSaveOutsidePoint(garageid);
		Garage_SQLSaveInsidePoint(garageid);
		Garage_SQLSaveOutsideArea(garageid);
		Garage_SQLSaveInsideArea(garageid);
	}
	return 1;
}

Garage_IsInAnyArea(playerid) {
	return GaragePlayerData[playerid][e_GARAGE_PLAYER_ID];
}

hook OnPlayerDisconnect(playerid, reason)
{
	GaragePlayerData[playerid][e_GARAGE_PLAYER_ID] = GARAGE_INVALID_ID;
	GaragePlayerData[playerid][e_GARAGE_PLAYER_AREA_ID] = STREAMER_TAG_AREA:0;
	return 1;
}

Garage_OnPlayerEnterArea(playerid, areaid, garageid)
{
	static notiCooldown[MAX_PLAYERS];

	if(gettime() >= notiCooldown[playerid])
	{
		new key[32], endtext[16], str[256] = "Estás en la puerta de un garaje. Utiliza ";

		if(!IsPlayerInAnyVehicle(playerid)) {
			strcopy(key, "'~k~~GROUP_CONTROL_BWD~' ", 32);
		} else {
			strcopy(key, "'~k~~VEHICLE_HORN~' ", 32);
		}

		if(GarageInfo[garageid][gOutsideArea] == areaid) {
			strcopy(endtext, "para entrar.", 16);
		} else {
			strcopy(endtext, "para salir.", 16);
		}

		strcat(str, key, 256);
		strcat(str, endtext, 256);

		Noti_Create(playerid, 3000, str);
		notiCooldown[playerid] = gettime() + 20;
	}

	GaragePlayerData[playerid][e_GARAGE_PLAYER_ID] = garageid;
	GaragePlayerData[playerid][e_GARAGE_PLAYER_AREA_ID] = areaid;
}

Garage_OnPlayerLeaveArea(playerid, garageid)
{
	if(garageid == GaragePlayerData[playerid][e_GARAGE_PLAYER_ID]) {
		GaragePlayerData[playerid][e_GARAGE_PLAYER_ID] = GARAGE_INVALID_ID;
		GaragePlayerData[playerid][e_GARAGE_PLAYER_AREA_ID] = STREAMER_TAG_AREA:0;
	}
}