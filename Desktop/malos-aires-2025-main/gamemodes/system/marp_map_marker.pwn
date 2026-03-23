#if defined marp_map_marker_inc
	#endinput
#endif
#define marp_map_marker_inc

#include <YSI_Coding\y_hooks>

/*
	System will use map icon id's in range [MAP_MARKER_ICON_ID_START - 99]
*/

const MAP_MARKER_MAX_AMOUNT = 20;
const MAP_MARKER_ICON_ID_START = 100 - MAP_MARKER_MAX_AMOUNT;

static MapMarkerTimer[MAX_PLAYERS][MAP_MARKER_MAX_AMOUNT];
static Iterator:MapMarkerData[MAX_PLAYERS]<MAP_MARKER_MAX_AMOUNT>;

hook OnGameModeInitEnded()
{
	Iter_Init(MapMarkerData);
	return 1;
}

MapMarker_CreateForPlayer(playerid, Float:x, Float:y, Float:z, color, time)
{
	new slot = Iter_Alloc(MapMarkerData[playerid]);

	if(slot == ITER_NONE)
		return 0;

	SetPlayerMapIcon(playerid, slot + MAP_MARKER_ICON_ID_START, x, y, z, 0, color, MAPICON_GLOBAL);
	
	if(time > 0) {
		MapMarkerTimer[playerid][slot] = SetTimerEx("MapMarker_DeleteForPlayer", time, false, "ii", playerid, slot);
	}
	return 1;
}

forward MapMarker_DeleteForPlayer(playerid, slot);
public MapMarker_DeleteForPlayer(playerid, slot)
{
	MapMarkerTimer[playerid][slot] = 0;
	RemovePlayerMapIcon(playerid, slot + MAP_MARKER_ICON_ID_START);
	Iter_Remove(MapMarkerData[playerid], slot);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(!Iter_Count(MapMarkerData[playerid]))
		return 1;

	foreach(new slot : MapMarkerData[playerid])
	{
		if(MapMarkerTimer[playerid][slot])
		{
			KillTimer(MapMarkerTimer[playerid][slot]);
			MapMarkerTimer[playerid][slot] = 0;
		}
	}
	Iter_Clear(MapMarkerData[playerid]);
	return 1;
}