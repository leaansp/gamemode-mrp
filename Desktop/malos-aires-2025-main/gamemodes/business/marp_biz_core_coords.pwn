#if defined _marp_biz_core_coords_included
	#endinput
#endif
#define _marp_biz_core_coords_included

#include <YSI_Coding\y_hooks>

#define BIZ_OUT_PICKUP_STREAM_DIST (35.0)
#define BIZ_OUT_LABEL_STREAM_DIST (10.0)
#define BIZ_OUT_LABEL_DRAW_DIST (10.0)
#define BIZ_OUT_LABEL_COLOR COLOR_DLG_DEFAULT
#define BIZ_OUT_LABEL_COLOR_EMB COLOR_EMB_DLG_DEFAULT

#define BIZ_INS_PICKUP_STREAM_DIST (35.0)
#define BIZ_INS_LABEL_STREAM_DIST (10.0)
#define BIZ_INS_LABEL_DRAW_DIST (10.0)
#define BIZ_INS_LABEL_COLOR COLOR_DLG_DEFAULT

#define BIZ_BUYPOINT_STREAM_DIST (25.0)
#define BIZ_BUYPOINT_EXT_STREAM_DIST (10.0)
#define BIZ_BUYPOINT_LABEL_COLOR COLOR_DLG_DEFAULT

static BIZ_PLAYER_INTENDS_TO_BUY_ADDR;
static BIZ_PLAYER_ENTER_BUY_POINT_ADDR;
static BIZ_PLAYER_EXIT_BUY_POINT_ADDR;

static playerInBusinessId[MAX_PLAYERS];

hook OnGameModeInit()
{
	BIZ_PLAYER_INTENDS_TO_BUY_ADDR = GetPublicAddressFromName("Biz_OnPlayerIntendsToBuy");
	BIZ_PLAYER_ENTER_BUY_POINT_ADDR = GetPublicAddressFromName("Biz_OnPlayerEnterBuyingPoint");
	BIZ_PLAYER_EXIT_BUY_POINT_ADDR = GetPublicAddressFromName("Biz_OnPlayerExitBuyingPoint");
	return 1;
}

/*____________________________________________________________
   ____      __                              ___         _       __ 
  / __/___  / /_ ____ ___ _ ___  ____ ___   / _ \ ___   (_)___  / /_
 / _/ / _ \/ __// __// _ `// _ \/ __// -_) / ___// _ \ / // _ \/ __/
/___//_//_/\__//_/   \_,_//_//_/\__/ \__/ /_/    \___//_//_//_/\__/ 
                                                                    
____________________________________________________________*/

static Biz_DestroyOutsidePickup(bizid)
{
	if(Business[bizid][bOutsidePickup])
	{
		DestroyDynamicPickup(Business[bizid][bOutsidePickup]);
		Business[bizid][bOutsidePickup] = STREAMER_TAG_PICKUP:0;
	}
}

static Biz_DestroyOutsideLabel(bizid)
{
	if(Business[bizid][bOutsideLabel])
	{
		DestroyDynamic3DTextLabel(Business[bizid][bOutsideLabel]);
		Business[bizid][bOutsideLabel] = STREAMER_TAG_3D_TEXT_LABEL:0;
	}	
}

static Biz_ReloadOutsidePickup(bizid)
{
	Biz_DestroyOutsidePickup(bizid);
	Business[bizid][bOutsidePickup] = CreateDynamicPickup((Business[bizid][bOwnerSQLID] == -1) ? (1274) : (1239), 1, Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ], Business[bizid][bOutsideWorld], -1, -1, BIZ_OUT_PICKUP_STREAM_DIST);
	Streamer_SetExtraIdArray(STREAMER_TYPE_PICKUP, Business[bizid][bOutsidePickup], STREAMER_ARRAY_TYPE_BIZ, bizid);
}

static Biz_ReloadOutsideLabel(bizid)
{
	Biz_DestroyOutsideLabel(bizid);

	new string[256], line[128];

	strcat(string, Business[bizid][bName], sizeof(string));

	if(Business[bizid][bOwnerSQLID] == -1)
	{
		format(line, sizeof(line), "\n{31B404}¡Negocio a la venta!"BIZ_OUT_LABEL_COLOR_EMB"\nPrecio: $%i", Business[bizid][bPrice]);
		strcat(string, line, sizeof(string));
	}

	if(Business[bizid][bEntranceFee])
	{
		format(line, sizeof(line), "\nCosto de entrada: $%i", Business[bizid][bEntranceFee]);
		strcat(string, line, sizeof(string));
	}

	format(line, sizeof(line), "\nTipo: %s\n(~k~~GROUP_CONTROL_BWD~) Entrar", Biz_GetTypeName(Business[bizid][bType]));
	strcat(string, line, sizeof(string));

	Business[bizid][bOutsideLabel] = CreateDynamic3DTextLabel(string, BIZ_OUT_LABEL_COLOR, Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ] + 0.75, .drawdistance = BIZ_OUT_LABEL_DRAW_DIST, .testlos = 1, .worldid = Business[bizid][bOutsideWorld], .streamdistance = BIZ_OUT_LABEL_STREAM_DIST);
}

Biz_ReloadOutsidePoint(bizid)
{
	Biz_ReloadOutsidePickup(bizid);
	Biz_ReloadOutsideLabel(bizid);
}

Biz_SetOutsidePoint(bizid, Float:x, Float:y, Float:z, Float:angle, world, interior, bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	Business[bizid][bOutsideX] = x;
	Business[bizid][bOutsideY] = y;
	Business[bizid][bOutsideZ] = z;
	Business[bizid][bOutsideAngle] = angle;
	Business[bizid][bOutsideWorld] = world;
	Business[bizid][bOutsideInt] = interior;

	Biz_ReloadOutsidePoint(bizid);

	if(save) {
		Biz_SQLSaveOutsidePoint(bizid);
	}
	return 1;
}

Biz_DestroyOutsidePoint(bizid)
{
	Biz_DestroyOutsidePickup(bizid);
	Biz_DestroyOutsideLabel(bizid);

	Business[bizid][bOutsideX] = Business[bizid][bOutsideY] = Business[bizid][bOutsideZ] = 0.0;
	Business[bizid][bOutsideWorld] = Business[bizid][bOutsideInt] = 0;
}

Biz_GetOutsidePointInfo(bizid, string[], size = sizeof(string)) {
	format(string, size, "[X: %.2f - Y: %.2f - Z: %.2f - Int: %i - VWorld: %i]", Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ], Business[bizid][bOutsideInt], Business[bizid][bOutsideWorld]);
}

Biz_IsPlayerAtOutsideDoorId(playerid, bizid) {
	return (GetPlayerVirtualWorld(playerid) == Business[bizid][bOutsideWorld] && IsPlayerInRangeOfPoint(playerid, 0.8, Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ]));
}

stock Biz_IsPlayerAtOutDoorRangeId(playerid, bizid, Float:range) {
	return (GetPlayerVirtualWorld(playerid) == Business[bizid][bOutsideWorld] && IsPlayerInRangeOfPoint(playerid, range, Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ]));
}

Biz_IsPlayerAtOutsideDoorAny(playerid) {
	return (Biz_IsValidId(playerInBusinessId[playerid]) && Biz_IsPlayerAtOutsideDoorId(playerid, playerInBusinessId[playerid])) ? (playerInBusinessId[playerid]) : (0);
}

Biz_TpPlayerToOutsideDoorId(playerid, bizid)
{
	TeleportPlayerTo(playerid, Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ], Business[bizid][bOutsideAngle], Business[bizid][bOutsideInt], Business[bizid][bOutsideWorld]);
	Radio_StopIfOnType(playerid, RADIO_TYPE_BIZ);
	return 1;
}

Biz_GetOutDoorPos(bizid, &Float:x, &Float:y, &Float:z) {
	x = Business[bizid][bOutsideX], y = Business[bizid][bOutsideY], z = Business[bizid][bOutsideZ];
}

stock Biz_GetOutDoorWorld(bizid) {
	return Business[bizid][bOutsideWorld];
}

stock Float:Biz_GetOutDoorAngle(bizid) {
	return Business[bizid][bOutsideAngle];
}

/*____________________________________________________________
   ____       _  __    ___         _       __ 
  / __/__ __ (_)/ /_  / _ \ ___   (_)___  / /_
 / _/  \ \ // // __/ / ___// _ \ / // _ \/ __/
/___/ /_\_\/_/ \__/ /_/    \___//_//_//_/\__/ 

____________________________________________________________*/

static Biz_DestroyInsidePickup(bizid)
{
	if(Business[bizid][bInsidePickup])
	{
		DestroyDynamicPickup(Business[bizid][bInsidePickup]);
		Business[bizid][bInsidePickup] = STREAMER_TAG_PICKUP:0;
	}
}

static Biz_DestroyInsideLabel(bizid)
{
	if(Business[bizid][bInsideLabel])
	{
		DestroyDynamic3DTextLabel(Business[bizid][bInsideLabel]);
		Business[bizid][bInsideLabel] = STREAMER_TAG_3D_TEXT_LABEL:0;
	}	
}

static Biz_ReloadInsidePickup(bizid)
{
	Biz_DestroyInsidePickup(bizid);
	Business[bizid][bInsidePickup] = CreateDynamicPickup(19198, 1, Business[bizid][bInsideX], Business[bizid][bInsideY], Business[bizid][bInsideZ], Business[bizid][bInsideWorld], -1, -1, BIZ_INS_PICKUP_STREAM_DIST);
	Streamer_SetExtraIdArray(STREAMER_TYPE_PICKUP, Business[bizid][bInsidePickup], STREAMER_ARRAY_TYPE_BIZ, bizid);
}

static Biz_ReloadInsideLabel(bizid)
{
	Biz_DestroyInsideLabel(bizid);
	Business[bizid][bInsideLabel] = CreateDynamic3DTextLabel("(~k~~GROUP_CONTROL_BWD~) Salir", BIZ_INS_LABEL_COLOR, Business[bizid][bInsideX], Business[bizid][bInsideY], Business[bizid][bInsideZ] + 0.70, BIZ_INS_LABEL_DRAW_DIST, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Business[bizid][bInsideWorld], -1, -1, BIZ_INS_LABEL_STREAM_DIST);
}

Biz_ReloadInsidePoint(bizid)
{
	Biz_ReloadInsidePickup(bizid);
	Biz_ReloadInsideLabel(bizid);
}

Biz_SetInsidePoint(bizid, Float:x, Float:y, Float:z, Float:angle, world, interior, bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	Business[bizid][bInsideX] = x;
	Business[bizid][bInsideY] = y;
	Business[bizid][bInsideZ] = z;
	Business[bizid][bInsideAngle] = angle;
	Business[bizid][bInsideWorld] = world;
	Business[bizid][bInsideInt] = interior;

	Biz_ReloadInsidePoint(bizid);
	Biz_ReloadBuyingPoint(bizid);

	if(save) {
		Biz_SQLSaveInsidePoint(bizid);
	}
	return 1;
}

Biz_DestroyInsidePoint(bizid)
{
	Biz_DestroyInsidePickup(bizid);
	Biz_DestroyInsideLabel(bizid);

	Business[bizid][bInsideX] = Business[bizid][bInsideY] = Business[bizid][bInsideZ] = 0.0;
	Business[bizid][bInsideWorld] = Business[bizid][bInsideInt] = 0;
}

Biz_GetInsidePointInfo(bizid, string[], size = sizeof(string)) {
	format(string, size, "[X: %.2f - Y: %.2f - Z: %.2f - Int: %i - VWorld: %i]", Business[bizid][bInsideX], Business[bizid][bInsideY], Business[bizid][bInsideZ], Business[bizid][bInsideInt], Business[bizid][bInsideWorld]);
}

Biz_IsPlayerAtInsideDoorId(playerid, bizid) {
	return (GetPlayerVirtualWorld(playerid) == Business[bizid][bInsideWorld] && IsPlayerInRangeOfPoint(playerid, 0.8, Business[bizid][bInsideX], Business[bizid][bInsideY], Business[bizid][bInsideZ]));
}

stock Biz_IsPlayerAtInDoorRangeId(playerid, bizid, Float:range) {
	return (GetPlayerVirtualWorld(playerid) == Business[bizid][bInsideWorld] && IsPlayerInRangeOfPoint(playerid, range, Business[bizid][bInsideX], Business[bizid][bInsideY], Business[bizid][bInsideZ]));
}

stock Biz_IsPlayerAtInsideDoorAny(playerid) {
	return (Biz_IsValidId(playerInBusinessId[playerid]) && Biz_IsPlayerAtInsideDoorId(playerid, playerInBusinessId[playerid])) ? (playerInBusinessId[playerid]) : (0);
}

Biz_TpPlayerToInsideDoorId(playerid, bizid)
{
	TeleportPlayerTo(playerid, Business[bizid][bInsideX], Business[bizid][bInsideY], Business[bizid][bInsideZ], Business[bizid][bInsideAngle], Business[bizid][bInsideInt], Business[bizid][bInsideWorld]);
	Radio_Set(playerid, Business[bizid][bRadio], RADIO_TYPE_BIZ);
	return 1;
}

Biz_GetInDoorPos(bizid, &Float:x, &Float:y, &Float:z) {
	x = Business[bizid][bInsideX], y = Business[bizid][bInsideY], z = Business[bizid][bInsideZ];
}

Biz_GetInDoorWorld(bizid) {
	return Business[bizid][bInsideWorld];
}

Float:Biz_GetInDoorAngle(bizid) {
	return Business[bizid][bInsideAngle];
}

/*____________________________________________________________
   ___               _              ___         _       __ 
  / _ ) __ __ __ __ (_)___  ___ _  / _ \ ___   (_)___  / /_
 / _  |/ // // // // // _ \/ _ `/ / ___// _ \ / // _ \/ __/
/____/ \_,_/ \_, //_//_//_/\_, / /_/    \___//_//_//_/\__/ 
            /___/         /___/                            
____________________________________________________________*/

static Biz_DestroyBuyingPointButton(bizid)
{
	if(Business[bizid][bBuyingPointButton] != INVALID_BUTTON_ID)
	{
		Button_Destroy(Business[bizid][bBuyingPointButton]);
		Business[bizid][bBuyingPointButton] = INVALID_BUTTON_ID;
	}
}

static Biz_ReloadBuyingPointButton(bizid)
{
	Biz_DestroyBuyingPointButton(bizid);

	//TODO: usar method = BUTTON_METHOD_CHECKPOINT una vez pasados todos los checkpoint a dynamic
	if(Business[bizid][bInsideWorld]) {
		Business[bizid][bBuyingPointButton] = Button_Create(bizid, Business[bizid][bBuyingPointX], Business[bizid][bBuyingPointY], Business[bizid][bBuyingPointZ], .size = 0.7, .worldid = Business[bizid][bInsideWorld], .method = BUTTON_METHOD_AREA, .streamDistance = BIZ_BUYPOINT_STREAM_DIST, .labelText = "Caja", .labelColor = BIZ_BUYPOINT_LABEL_COLOR, .onEnterText = "(H) Ver items en venta", .onPressCallbackAddress = BIZ_PLAYER_INTENDS_TO_BUY_ADDR);
	} else {
		Business[bizid][bBuyingPointButton] = Button_Create(bizid, Business[bizid][bBuyingPointX], Business[bizid][bBuyingPointY], Business[bizid][bBuyingPointZ], .size = 0.7, .worldid = Business[bizid][bInsideWorld], .method = BUTTON_METHOD_AREA, .streamDistance = BIZ_BUYPOINT_EXT_STREAM_DIST, .labelText = "Caja", .labelColor = BIZ_BUYPOINT_LABEL_COLOR, .onEnterText = "(H) Ver items en venta", .onPressCallbackAddress = BIZ_PLAYER_INTENDS_TO_BUY_ADDR, .onEnterCallbackAddress = BIZ_PLAYER_ENTER_BUY_POINT_ADDR, .onExitCallbackAddress = BIZ_PLAYER_EXIT_BUY_POINT_ADDR);
	}
}

Biz_ReloadBuyingPoint(bizid) {
	Biz_ReloadBuyingPointButton(bizid);
}

Biz_SetBuyingPoint(bizid, Float:x, Float:y, Float:z, bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	Business[bizid][bBuyingPointX] = x;
	Business[bizid][bBuyingPointY] = y;
	Business[bizid][bBuyingPointZ] = z;

	Biz_ReloadBuyingPoint(bizid);

	if(save) {
		Biz_SQLSaveBuyingPoint(bizid);
	}
	return 1;
}

Biz_DestroyBuyingPoint(bizid)
{
	Biz_DestroyBuyingPointButton(bizid);
	Business[bizid][bBuyingPointX] = Business[bizid][bBuyingPointY] = Business[bizid][bBuyingPointZ] = 0.0;
}

Biz_GetBuyingPointInfo(bizid, string[], size = sizeof(string)) {
	format(string, size, "[X: %.2f - Y: %.2f - Z: %.2f - Int: %i - VWorld: %i]", Business[bizid][bBuyingPointX], Business[bizid][bBuyingPointY], Business[bizid][bBuyingPointZ], Business[bizid][bInsideInt], Business[bizid][bInsideWorld]);
}

Biz_GetBuyingPointPos(bizid, &Float:x, &Float:y, &Float:z) {
	x = Business[bizid][bBuyingPointX]; y = Business[bizid][bBuyingPointY]; z = Business[bizid][bBuyingPointZ];
}

Biz_IsPlayerOnBuyingPointId(playerid, bizid) {
	return Button_IsPlayerInId(playerid, Business[bizid][bBuyingPointButton]);
}

stock Biz_IsPlayerOnBuyingPointAny(playerid) {
	return (Biz_IsValidId(playerInBusinessId[playerid]) && Biz_IsPlayerOnBuyingPointId(playerid, playerInBusinessId[playerid])) ? (playerInBusinessId[playerid]) : (0);
}

forward Biz_OnPlayerEnterBuyingPoint(playerid, bizid);
public Biz_OnPlayerEnterBuyingPoint(playerid, bizid) {
	playerInBusinessId[playerid] = bizid;
	return 1;
}

forward Biz_OnPlayerExitBuyingPoint(playerid, bizid);
public Biz_OnPlayerExitBuyingPoint(playerid, bizid) {
	playerInBusinessId[playerid] = 0;
	return 1;
}

/*____________________________________________________________
	  _____                             
	 / ___/___   __ _   __ _  ___   ___ 
	/ /__ / _ \ /  ' \ /  ' \/ _ \ / _ |
	\___/ \___//_/_/_//_/_/_/\___//_//_/
____________________________________________________________*/

Biz_ReloadAllPoints(bizid)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	Biz_ReloadOutsidePoint(bizid);
	Biz_ReloadInsidePoint(bizid);
	Biz_ReloadBuyingPoint(bizid);
	return 1;
}

Biz_DestroyAllPoints(bizid, bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	Biz_DestroyOutsidePoint(bizid);
	Biz_DestroyInsidePoint(bizid);
	Biz_DestroyBuyingPoint(bizid);

	if(save) {
		SaveBusiness(bizid);
	}
	return 1;
}

Biz_IsPlayerAtAnyDoorId(playerid, bizid) {
	return (Biz_IsPlayerAtOutsideDoorId(playerid, bizid) || Biz_IsPlayerAtInsideDoorId(playerid, bizid));
}

Biz_IsPlayerAtAnyDoorRangeId(playerid, bizid, Float:range) {
	return (Biz_IsPlayerAtOutDoorRangeId(playerid, bizid, range) || Biz_IsPlayerAtInDoorRangeId(playerid, bizid, range));
}

Biz_IsPlayerAtAnyDoorAny(playerid) {
	return (Biz_IsValidId(playerInBusinessId[playerid]) && Biz_IsPlayerAtAnyDoorId(playerid, playerInBusinessId[playerid])) ? (playerInBusinessId[playerid]) : (0);
}

Biz_SyncBetweenPlayers(playerid, targetid) {
	playerInBusinessId[playerid] = playerInBusinessId[targetid];
}

Biz_OnPlayerEnterPickup(playerid, bizid) {
	playerInBusinessId[playerid] = bizid;
}

hook OnPlayerDisconnect(playerid, reason)
{
	playerInBusinessId[playerid] = 0;
	return 1;
}

Biz_GetPlayerLastId(playerid) {
	return (Biz_IsValidId(playerInBusinessId[playerid])) ? (playerInBusinessId[playerid]) : (0);
}

Biz_SetPlayerLastId(playerid, bizid) {
	playerInBusinessId[playerid] = bizid;
}

Biz_IsPlayerInsideId(playerid, bizid)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	if(Business[bizid][bInsideWorld]) {
		return (Business[bizid][bInsideWorld] == GetPlayerVirtualWorld(playerid) && Business[bizid][bInsideInt] == GetPlayerInterior(playerid));
	} else {
		return (Biz_IsPlayerAtInsideDoorId(playerid, bizid) || Biz_IsPlayerOnBuyingPointId(playerid, bizid));
	}
}

Biz_IsPlayerInsideAny(playerid) {
	return (Biz_IsPlayerInsideId(playerid, playerInBusinessId[playerid])) ? (playerInBusinessId[playerid]) : (0);
}

Biz_IsPlayerOutsideOrInsideId(playerid, bizid) {
	return (Biz_IsValidId(bizid) && (Biz_IsPlayerAtOutsideDoorId(playerid, bizid) || Biz_IsPlayerInsideId(playerid, bizid)));
}

Biz_IsPlayerOutsideOrInsideAny(playerid) {
	return (Biz_IsPlayerOutsideOrInsideId(playerid, playerInBusinessId[playerid])) ? (playerInBusinessId[playerid]) : (0);
}

hook LoadAccountDataEnded(playerid)
{
	if(BUSINESS_VW_OFFSET < PlayerInfo[playerid][pVirtualWorld] <= (BUSINESS_VW_OFFSET + MAX_BUSINESS)) {
		playerInBusinessId[playerid] = PlayerInfo[playerid][pVirtualWorld] - BUSINESS_VW_OFFSET;
	}
	return 1;
}