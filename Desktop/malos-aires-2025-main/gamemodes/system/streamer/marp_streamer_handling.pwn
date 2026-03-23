#if defined marp_streamer_handling_inc
	#endinput
#endif
#define marp_streamer_handling_inc

enum e_STREAMER_ARRAY
{
	e_STREAMER_ARRAY_TYPE:STREAMER_ARRAY_TYPE,
	STREAMER_ARRAY_DATA_ID
}

enum e_STREAMER_ARRAY_TYPE
{
	STREAMER_ARRAY_TYPE_NONE,
	STREAMER_ARRAY_TYPE_BUTTON,
	STREAMER_ARRAY_TYPE_BIZ,
	STREAMER_ARRAY_TYPE_BUILDING,
	STREAMER_ARRAY_TYPE_HOUSE,
	STREAMER_ARRAY_TYPE_VEH_TRUNK,
	STREAMER_ARRAY_TYPE_SPEAKER,
	STREAMER_ARRAY_TYPE_GATE,
	STREAMER_ARRAY_TYPE_GAS_STATION,
	STREAMER_ARRAY_TYPE_GARAGE
};

Streamer_SetExtraIdArray(type, STREAMER_ALL_TAGS:id, e_STREAMER_ARRAY_TYPE:arraytype, arraydataid)
{
	new arrayData[e_STREAMER_ARRAY];

	arrayData[STREAMER_ARRAY_TYPE] = arraytype;
	arrayData[STREAMER_ARRAY_DATA_ID] = arraydataid;

	Streamer_SetArrayData(type, id, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));
}

public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		return 1;

	new arrayData[e_STREAMER_ARRAY];

	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

	switch(arrayData[STREAMER_ARRAY_TYPE])
	{
		case STREAMER_ARRAY_TYPE_BUTTON: Button_OnPlayerEnter(playerid, Button:arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_VEH_TRUNK: VehTrunk_OnPlayerEnterArea(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_GATE: Gate_OnPlayerEnterArea(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_SPEAKER: Speaker_OnPlayerEnterArea(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_GAS_STATION: GasStation_OnPlayerEnterArea(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_GARAGE: Garage_OnPlayerEnterArea(playerid, areaid, arrayData[STREAMER_ARRAY_DATA_ID]);
	}

	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		return 1;
	
	new arrayData[e_STREAMER_ARRAY];

	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

	switch(arrayData[STREAMER_ARRAY_TYPE])
	{
		case STREAMER_ARRAY_TYPE_BUTTON: Button_OnPlayerLeave(playerid, Button:arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_VEH_TRUNK: VehTrunk_OnPlayerLeaveArea(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_GATE: Gate_OnPlayerLeaveArea(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_SPEAKER: Speaker_OnPlayerLeaveArea(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_GAS_STATION: GasStation_OnPlayerLeaveArea(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_GARAGE: Garage_OnPlayerLeaveArea(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		return 1;
		
	new arrayData[e_STREAMER_ARRAY];

	Streamer_GetArrayData(STREAMER_TYPE_CP, checkpointid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

	switch(arrayData[STREAMER_ARRAY_TYPE])
	{
		case STREAMER_ARRAY_TYPE_BUTTON: Button_OnPlayerEnter(playerid, Button:arrayData[STREAMER_ARRAY_DATA_ID]);
	}
	return 1;
}

public OnPlayerLeaveDynamicCP(playerid, STREAMER_TAG_CP:checkpointid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		return 1;

	new arrayData[e_STREAMER_ARRAY];

	Streamer_GetArrayData(STREAMER_TYPE_CP, checkpointid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

	switch(arrayData[STREAMER_ARRAY_TYPE])
	{
		case STREAMER_ARRAY_TYPE_BUTTON: Button_OnPlayerLeave(playerid, Button:arrayData[STREAMER_ARRAY_DATA_ID]);
	}
	return 1;
}

hook OnPlayerPickUpDynPickup(playerid, STREAMER_TAG_PICKUP:pickupid)
{
	new arrayData[e_STREAMER_ARRAY];

	Streamer_GetArrayData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_EXTRA_ID, arrayData, sizeof(arrayData));

	switch(arrayData[STREAMER_ARRAY_TYPE])
	{
		case STREAMER_ARRAY_TYPE_BIZ: Biz_OnPlayerEnterPickup(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_BUILDING: Bld_OnPlayerEnterPickup(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
		case STREAMER_ARRAY_TYPE_HOUSE: House_OnPlayerEnterPickup(playerid, arrayData[STREAMER_ARRAY_DATA_ID]);
	}
	return 1;
}