#if defined _marp_entry_and_exit_included
	#endinput
#endif
#define _marp_entry_and_exit_included

#include <YSI_Coding\y_hooks>

static pLoadingMapTimer[MAX_PLAYERS];
new pAllowPosDataSyncTime[MAX_PLAYERS];

PlayerPos_GetExteriorPos(playerid, &Float:x, &Float:y, &Float:z)
{
	new id;

	if((id = House_IsPlayerInAny(playerid))) {
		House_GetOutDoorPos(id, x, y, z);
	} else if((id = Biz_IsPlayerInsideAny(playerid))) {
		Biz_GetOutDoorPos(id, x, y, z);
	} else if((id = Bld_IsPlayerInsideAny(playerid))) {
		Bld_GetOutDoorPos(id, x, y, z);
	} else {
		GetPlayerPos(playerid, x, y, z);
	}
}

SyncPlayerEntitiesToPlayer(playerid, targetid)
{
	House_SyncBetweenPlayers(playerid, targetid);
	Biz_SyncBetweenPlayers(playerid, targetid);
	Bld_SyncBetweenPlayers(playerid, targetid);
}

TeleportPlayerToPlayer(playerid, targetid)
{
	new Float:x, Float:y, Float:z, Float:a;

	GetPlayerPos(targetid, x, y, z);
	GetPlayerFacingAngle(targetid, a);
	GetXYInFrontOfPoint(x, y, a, x, y, 1.25);

	if(TeleportPlayerTo(playerid, x, y, z, a + 180.0, GetPlayerInterior(targetid), GetPlayerVirtualWorld(targetid)))
	{
		SyncPlayerEntitiesToPlayer(playerid, targetid);
		return 1;
	} else {
		return 0;
	}
}

PlayerPos_SyncCurrentData(playerid, disableSyncOnExitSeconds = -1)
{
	GetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
	GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pA]);
	PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
	PlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);

	if(disableSyncOnExitSeconds >= 0) {
		pAllowPosDataSyncTime[playerid] = gettime() + disableSyncOnExitSeconds;
	}
}

PlayerPos_SyncCustomData(playerid, Float:x, Float:y, Float:z, Float:a, world, interior, disableSyncOnExitSeconds = -1)
{
	PlayerInfo[playerid][pX] = x;
	PlayerInfo[playerid][pY] = y;
	PlayerInfo[playerid][pZ] = z;
	PlayerInfo[playerid][pA] = a;
	PlayerInfo[playerid][pVirtualWorld] = world;
	PlayerInfo[playerid][pInterior] = interior;

	if(disableSyncOnExitSeconds >= 0) {
		pAllowPosDataSyncTime[playerid] = gettime() + disableSyncOnExitSeconds;
	}
}

TeleportPlayerTo(playerid, Float:x, Float:y, Float:z, Float:a, interior, world, forceLoadingTime = 0, bool:syncPlayerOldPosData = false, bool:syncPlayerNewPosData = false, disableSyncOnExitSeconds = -1)
{
	if(pLoadingMapTimer[playerid]) // Prevents teleport spam from/into interiors
		return 0;

	if(forceLoadingTime || interior || world)
	{
		TogglePlayerControllable(playerid, false);
		GameTextForPlayer(playerid, "Cargando mapa", 2500, 6);
		// Aumentado a 2500ms para permitir que el mapeo cargue completamente antes de descongelar
		pLoadingMapTimer[playerid] = SetTimerEx("OnPlayerLoadInteriorMap", 2500, false, "if", playerid, PlayerInfo[playerid][pHealth]);
	}

	if(syncPlayerOldPosData) {
		PlayerPos_SyncCurrentData(playerid, disableSyncOnExitSeconds);
	} else if(syncPlayerNewPosData) {
		PlayerPos_SyncCustomData(playerid, x, y, z, a, world, interior, disableSyncOnExitSeconds);
	}

	// Notificar al anticheat para evitar falsos positivos
	AC_NotifyTeleportPlayer(playerid);

	SetPlayerPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, a);
	SetPlayerInterior(playerid, interior);
	SetPlayerVirtualWorld(playerid, world);
	return 1;
}

TeleportVehicleTo(vehicleid, Float:x, Float:y, Float:z, Float:a, interior, world)
{
	new max_seats = Veh_GetMaxSeats(vehicleid), 
		seats_playerid[10] = {INVALID_PLAYER_ID, ...};

	foreach(new playerid : Player)
    {
		if(!IsPlayerInVehicle(playerid, vehicleid))
			continue;

		seats_playerid[GetPlayerVehicleSeat(playerid)] = playerid;
	}

	SetVehiclePos(vehicleid, x, y, z);
	SetVehicleZAngle(vehicleid, a);

	Veh_SetInteriorAndVWorld(vehicleid, interior, world);

	for(new i = 0; i < max_seats; i++) 
	{
		if(seats_playerid[i] != INVALID_PLAYER_ID) 
		{
			// Notificar al anticheat para evitar falsos positivos
			AC_NotifyTeleportVehicle(seats_playerid[i]);
			TeleportPlayerTo(seats_playerid[i], x, y, z, a, interior, world);
			PutPlayerInVehicle(seats_playerid[i], vehicleid, i);
		}
	}

	return 1;
}


forward OnPlayerLoadInteriorMap(playerid, Float:health);
public OnPlayerLoadInteriorMap(playerid, Float:health)
{
	TogglePlayerControllable(playerid, true);
	SetPlayerHealthEx(playerid, health);
	pLoadingMapTimer[playerid] = 0;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(pLoadingMapTimer[playerid])
	{
		KillTimer(pLoadingMapTimer[playerid]);
		pLoadingMapTimer[playerid] = 0;
	}
	return 1;
}