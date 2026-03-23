#if defined _marp_admin_spectate_included
	#endinput
#endif
#define _marp_admin_spectate_included

#include <YSI_Coding\y_hooks>

static PlayerSpectating[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
static PlayerSpectators[MAX_PLAYERS];
static PlayerSpectatingVeh[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};

stock Specteate_GetSpectatingPlayerID(playerid) {
	return PlayerSpectating[playerid];
}

stock Specteate_GetSpectatingVehID(playerid) {
	return PlayerSpectatingVeh[playerid];
}

CMD:asp(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new targetid;

	if(!strcmp(params, "salir", true))
	{
		if(!(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerSpectating[playerid] != INVALID_PLAYER_ID))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras especteando a nadie.");

		DecreaseSpectatorsCount(PlayerSpectating[playerid]);
		TogglePlayerSpectating(playerid, false);
	}
	else if(!sscanf(params, "u", targetid))
	{
		if(!IsPlayerLogged(targetid) || playerid == targetid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
		if(GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador está en modo espectador.");
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerSpectating[playerid] == INVALID_PLAYER_ID) // está en modo espectador por algun otro sistema y no por el de spectate de admin
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");

		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerSpectating[playerid] != INVALID_PLAYER_ID) { // Estaba especteando con el sistema a otro jugador
			DecreaseSpectatorsCount(PlayerSpectating[playerid]);
		}
		else
		{
			GetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
			PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
			PlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
			LastVeh[playerid] = GetPlayerVehicleID(playerid);
		}

		PlayerSpectators[targetid]++;
		PlayerSpectating[playerid] = targetid;
		SetPlayerInterior(playerid, GetPlayerInterior(targetid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
		Streamer_Update(playerid);

		// Ensure spectating mode is active after moving spectator to target interior/world
		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) {
			TogglePlayerSpectating(playerid, true);
		}

		if(IsPlayerInAnyVehicle(targetid)) {
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
		} else {
			PlayerSpectatePlayer(playerid, targetid);
		}
	}
	else {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/asp [ID/Jugador]. Usa '/asp salir' para dejar de spectear.");
	}
	return 1;
}

hook OnPlayerStreamOut(playerid, forplayerid)
{
	if(PlayerSpectating[forplayerid] == playerid)
	{
		if(GetPlayerInterior(forplayerid) != GetPlayerInterior(playerid)) {
			SetPlayerInterior(forplayerid, GetPlayerInterior(playerid));
			Streamer_Update(forplayerid);
		}

		if(GetPlayerVirtualWorld(forplayerid) != GetPlayerVirtualWorld(playerid)) {
			SetPlayerVirtualWorld(forplayerid, GetPlayerVirtualWorld(playerid));
			Streamer_Update(forplayerid);
		}

		PlayerSpectatePlayer(forplayerid, playerid);
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(PlayerSpectators[playerid])
	{
		foreach(new i : Player)
		{
			if(PlayerSpectating[i] == playerid && GetPlayerState(i) == PLAYER_STATE_SPECTATING)
			{
				if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
					PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
					PlayerSpectatingVeh[i] = GetPlayerVehicleID(playerid);
				} else {
					PlayerSpectatePlayer(i, playerid);
					PlayerSpectatingVeh[i] = INVALID_VEHICLE_ID;
				}
			}
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(PlayerSpectators[playerid])
	{
		foreach(new i : Player)
		{
			if(PlayerSpectating[i] == playerid && GetPlayerState(i) == PLAYER_STATE_SPECTATING)
			{
				TogglePlayerSpectating(i, false);
				SendClientMessage(i, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" El jugador al que estabas specteando se ha desconectado.");
			}
		}

		PlayerSpectators[playerid] = 0;
	}

	if(PlayerSpectating[playerid] != INVALID_PLAYER_ID)
	{
		DecreaseSpectatorsCount(PlayerSpectating[playerid]);
		PlayerSpectating[playerid] = INVALID_PLAYER_ID;
		PlayerSpectatingVeh[playerid] = INVALID_VEHICLE_ID;
	}
	return 1;
}

DecreaseSpectatorsCount(playerid)
{
	if((--PlayerSpectators[playerid]) < 0) {
		PlayerSpectators[playerid] = 0; // Solo podría quedar negativo en un improbable caso en el que el espectador crashee entre el cierre del modo espectador y el reporte de spawn de su cliente
	}
}

WasPlayerSpectating(playerid) {
	return (PlayerSpectating[playerid] != INVALID_PLAYER_ID);
}

ResetPlayerSpectate(playerid)
{
	PlayerSpectating[playerid] = INVALID_PLAYER_ID;
	PlayerSpectatingVeh[playerid] = INVALID_VEHICLE_ID;

	if(LastVeh[playerid] != 0)
	{
		new seat = Veh_GetFreeSeat(LastVeh[playerid]);

		if(seat != -1)
			return PutPlayerInVehicle(playerid, LastVeh[playerid], seat);
	}

	TeleportPlayerTo(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ], PlayerInfo[playerid][pA], PlayerInfo[playerid][pInterior], PlayerInfo[playerid][pVirtualWorld]);
	return 1;
}