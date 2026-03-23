#if defined _marp_house_core_coords
	#endinput
#endif
#define _marp_house_core_coords

#include <YSI_Coding\y_hooks>

#define HOUSE_OUT_PICKUP_STREAM_DIST (30.0)
#define HOUSE_OUT_PICKUP_STREAM_DIST_OW (15.0)
#define HOUSE_OUT_LABEL_STREAM_DIST (10.0)
#define HOUSE_OUT_LABEL_DRAW_DIST (10.0)
#define HOUSE_OUT_LABEL_COLOR COLOR_DEEPWHITE
#define HOUSE_OUT_LABEL_COLOR_EMB COLOR_EMB_DEEPWHITE

#define HOUSE_IN_PICKUP_STREAM_DIST (30.0)
#define HOUSE_IN_LABEL_STREAM_DIST (10.0)
#define HOUSE_IN_LABEL_DRAW_DIST (10.0)
#define HOUSE_IN_LABEL_COLOR COLOR_DEEPWHITE

static playerInHouseId[MAX_PLAYERS];

/*____________________________________________________________
	  ____         __    ___                 
	 / __ \ __ __ / /_  / _ \ ___  ___   ____
	/ /_/ // // // __/ / // // _ \/ _ \ / __/
	\____/ \_,_/ \__/ /____/ \___/\___//_/   
____________________________________________________________*/

House_DestroyOutPickup(houseid)
{
	if(House[houseid][hOutsidePickup])
	{
		DestroyDynamicPickup(House[houseid][hOutsidePickup]);
		House[houseid][hOutsidePickup] = STREAMER_TAG_PICKUP:0;
	}
}

House_DestroyOutLabel(houseid)
{
	if(House[houseid][hOutsideLabel])
	{
		DestroyDynamic3DTextLabel(House[houseid][hOutsideLabel]);
		House[houseid][hOutsideLabel] = STREAMER_TAG_3D_TEXT_LABEL:0;
	}
}

House_ReloadOutDoor(houseid)
{
	House_DestroyOutPickup(houseid);
	House_DestroyOutLabel(houseid);

	new string[256], address[48];
	House_GetAddress(houseid, address, sizeof(address));

	if(House_IsForSale(houseid))
	{
		format(string, sizeof(string), "{04C400}Casa en venta\n"HOUSE_OUT_LABEL_COLOR_EMB"Utiliza /casacomprar - /casavisitar\n%s\nPrecio: $%i", address, House[houseid][HousePrice]);
		House[houseid][hOutsidePickup] = CreateDynamicPickup(1273, 1, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ], House[houseid][OutsideWorld], .streamdistance = HOUSE_OUT_PICKUP_STREAM_DIST);
	}
	else if(House_IsForRent(houseid))
	{
		format(string, sizeof(string), "{FFF036}Casa en alquiler\n"HOUSE_OUT_LABEL_COLOR_EMB"Utiliza /casaalquilar - /casavisitar\n%s\nPrecio: $%i", address, House[houseid][IncomePrice]);
		House[houseid][hOutsidePickup] = CreateDynamicPickup(19524, 1, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ], House[houseid][OutsideWorld], .streamdistance = HOUSE_OUT_PICKUP_STREAM_DIST);
	}
	else
	{
		format(string, sizeof(string), " \n%s\n(~k~~GROUP_CONTROL_BWD~) Entrar", address);
		House[houseid][hOutsidePickup] = CreateDynamicPickup(1272, 1, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ], House[houseid][OutsideWorld], .streamdistance = HOUSE_OUT_PICKUP_STREAM_DIST_OW);
	}

	Streamer_SetExtraIdArray(STREAMER_TYPE_PICKUP, House[houseid][hOutsidePickup], STREAMER_ARRAY_TYPE_HOUSE, houseid);
	House[houseid][hOutsideLabel] = CreateDynamic3DTextLabel(string, HOUSE_OUT_LABEL_COLOR, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ] + 0.75, .drawdistance = HOUSE_OUT_LABEL_DRAW_DIST, .testlos = 1, .worldid = House[houseid][OutsideWorld], .streamdistance = HOUSE_OUT_LABEL_STREAM_DIST);
}

House_DestroyOutDoor(houseid)
{
	House_DestroyOutPickup(houseid);
	House_DestroyOutLabel(houseid);

	House[houseid][OutsideX] = House[houseid][OutsideY] = House[houseid][OutsideZ] = 0.0;
	House[houseid][OutsideWorld] = House[houseid][OutsideInterior] = 0;
}

stock House_IsPlayerAtOutDoorId(playerid, houseid) {
	return (GetPlayerVirtualWorld(playerid) == House[houseid][OutsideWorld] && IsPlayerInRangeOfPoint(playerid, 0.8, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ]));
}

stock House_IsPlayerAtOutDoorRangeId(playerid, houseid, Float:range) {
	return (GetPlayerVirtualWorld(playerid) == House[houseid][OutsideWorld] && IsPlayerInRangeOfPoint(playerid, range, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ]));
}

stock House_IsPlayerAtOutDoorAny(playerid) {
	return (House_IsValidId(playerInHouseId[playerid]) && House_IsPlayerAtOutDoorId(playerid, playerInHouseId[playerid])) ? (playerInHouseId[playerid]) : (0);
}

stock House_TpPlayerToOutDoorId(playerid, houseid)
{
	TeleportPlayerTo(playerid, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ], House[houseid][OutsideAngle], House[houseid][OutsideInterior], House[houseid][OutsideWorld]);
	Radio_StopIfOnType(playerid, RADIO_TYPE_HOUSE);
	return 1;
}

stock House_GetOutDoorPos(houseid, &Float:x, &Float:y, &Float:z) {
	x = House[houseid][OutsideX], y = House[houseid][OutsideY], z = House[houseid][OutsideZ];
}

/*____________________________________________________________
	   ____        ___                 
	  /  _/___    / _ \ ___  ___   ____
	 _/ / / _ \  / // // _ \/ _ \ / __/
	/___//_//_/ /____/ \___/\___//_/   	                                   
____________________________________________________________*/

House_DestroyInPickup(houseid)
{
	if(House[houseid][hInsidePickup])
	{
		DestroyDynamicPickup(House[houseid][hInsidePickup]);
		House[houseid][hInsidePickup] = STREAMER_TAG_PICKUP:0;
	}
}

House_DestroyInLabel(houseid)
{
	if(House[houseid][hInsideLabel])
	{
		DestroyDynamic3DTextLabel(House[houseid][hInsideLabel]);
		House[houseid][hInsideLabel] = STREAMER_TAG_3D_TEXT_LABEL:0;
	}
}

House_ReloadInDoor(houseid)
{
	House_DestroyInPickup(houseid);
	House_DestroyInLabel(houseid);

	House[houseid][hInsidePickup] = CreateDynamicPickup(19198, 1, House[houseid][InsideX], House[houseid][InsideY], House[houseid][InsideZ], House[houseid][InsideWorld], .streamdistance = HOUSE_IN_PICKUP_STREAM_DIST);
	Streamer_SetExtraIdArray(STREAMER_TYPE_PICKUP, House[houseid][hInsidePickup], STREAMER_ARRAY_TYPE_HOUSE, houseid);
	House[houseid][hInsideLabel] = CreateDynamic3DTextLabel("(~k~~GROUP_CONTROL_BWD~) Salir", HOUSE_IN_LABEL_COLOR, House[houseid][InsideX], House[houseid][InsideY], House[houseid][InsideZ] + 0.70, .drawdistance = HOUSE_IN_LABEL_DRAW_DIST, .testlos = 1, .worldid = House[houseid][InsideWorld], .streamdistance = HOUSE_IN_LABEL_STREAM_DIST);
}

House_DestroyInDoor(houseid)
{
	House_DestroyInPickup(houseid);
	House_DestroyInLabel(houseid);

	House[houseid][InsideX] = House[houseid][InsideY] = House[houseid][InsideZ] = 0.0;
	House[houseid][InsideWorld] = House[houseid][InsideInterior] = 0;
}

stock House_IsPlayerAtInDoorId(playerid, houseid) {
	return (GetPlayerVirtualWorld(playerid) == House[houseid][InsideWorld] && IsPlayerInRangeOfPoint(playerid, 0.8, House[houseid][InsideX], House[houseid][InsideY], House[houseid][InsideZ]));
}

stock House_IsPlayerAtInDoorRangeId(playerid, houseid, Float:range) {
	return (GetPlayerVirtualWorld(playerid) == House[houseid][InsideWorld] && IsPlayerInRangeOfPoint(playerid, range, House[houseid][InsideX], House[houseid][InsideY], House[houseid][InsideZ]));
}

stock House_IsPlayerAtInDoorAny(playerid) {
	return (House_IsValidId(playerInHouseId[playerid]) && House_IsPlayerAtInDoorId(playerid, playerInHouseId[playerid])) ? (playerInHouseId[playerid]) : (0);
}

stock House_TpPlayerToInDoorId(playerid, houseid)
{
	TeleportPlayerTo(playerid, House[houseid][InsideX], House[houseid][InsideY], House[houseid][InsideZ], House[houseid][InsideAngle], House[houseid][InsideInterior], House[houseid][InsideWorld]);
	Radio_Set(playerid, House[houseid][Radio], RADIO_TYPE_HOUSE);
	return 1;
}

House_GetInDoorPos(houseid, &Float:x, &Float:y, &Float:z) {
	x = House[houseid][InsideX], y = House[houseid][InsideY], z = House[houseid][InsideZ];
}

House_GetInDoorWorld(houseid) {
	return House[houseid][InsideWorld];
}

Float:House_GetInDoorAngle(houseid) {
	return House[houseid][InsideAngle];
}

/*____________________________________________________________
	   ____                 __   _                
	  / __/__ __ ___  ____ / /_ (_)___   ___   ___
	 / _/ / // // _ \/ __// __// // _ \ / _ \ (_-<
	/_/   \_,_//_//_/\__/ \__//_/ \___//_//_//___/                                            
____________________________________________________________*/

House_OnPlayerEnterPickup(playerid, houseid) {
	playerInHouseId[playerid] = houseid;
}

House_SyncBetweenPlayers(playerid, targetid) {
	playerInHouseId[playerid] = playerInHouseId[targetid];
}

hook LoadAccountDataEnded(playerid) // Carga playerInHouseId si el jugador desconecto en una casa.
{
	// Apartir del HOUSE_VW_OFFSET+1 son los vw de casas.
	if(HOUSE_VW_OFFSET < PlayerInfo[playerid][pVirtualWorld] <= (HOUSE_VW_OFFSET + MAX_HOUSES)) {
		playerInHouseId[playerid] = PlayerInfo[playerid][pVirtualWorld] - HOUSE_VW_OFFSET;
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	playerInHouseId[playerid] = 0;
	return 1;
}

stock House_GetPlayerLastId(playerid) {
	return (House_IsValidId(playerInHouseId[playerid])) ? (playerInHouseId[playerid]) : (0);
}

stock House_IsPlayerAtAnyDoorId(playerid, houseid) {
	return (House_IsPlayerAtOutDoorId(playerid, houseid) || House_IsPlayerAtInDoorId(playerid, houseid));
}

stock House_IsPlayerAtAnyDoorRangeId(playerid, houseid, Float:range) {
	return (House_IsPlayerAtOutDoorRangeId(playerid, houseid, range) || House_IsPlayerAtInDoorRangeId(playerid, houseid, range));
}

stock House_IsPlayerAtAnyDoorAny(playerid) {
	return (House_IsValidId(playerInHouseId[playerid]) && House_IsPlayerAtAnyDoorId(playerid, playerInHouseId[playerid])) ? (playerInHouseId[playerid]) : (0);
}

stock House_IsPlayerInId(playerid, houseid) {
	return (House_IsValidId(houseid) && GetPlayerVirtualWorld(playerid) == House[houseid][InsideWorld] && GetPlayerInterior(playerid) == House[houseid][InsideInterior]);
}

stock House_IsPlayerInAny(playerid) {
	return (House_IsPlayerInId(playerid, playerInHouseId[playerid])) ? (playerInHouseId[playerid]) : (0);
}

stock House_IsPlayerOutOrInId(playerid, houseid) {
	return (House_IsValidId(houseid) && (House_IsPlayerAtOutDoorId(playerid, houseid) || House_IsPlayerInId(playerid, houseid)));
}

stock House_IsPlayerOutOrInAny(playerid) {
	return (House_IsPlayerOutOrInId(playerid, playerInHouseId[playerid])) ? (playerInHouseId[playerid]) : (0);
}

House_SetPlayerLastId(playerid, houseid) {
	playerInHouseId[playerid] = houseid;
}