#if defined _marp_afk_included
	#endinput
#endif
#define _marp_afk_included

#include <YSI_Coding\y_hooks>

#define AFK_TIME 300 // Segundos
#define AFK_VWORLD 100

static AFK_active[MAX_PLAYERS];
static AFK_returnWorld[MAX_PLAYERS];
static AFK_time[MAX_PLAYERS];
static Float:AFK_x[MAX_PLAYERS];
static Text:AFK_TD;

IsPlayerAFK(playerid) {
	return AFK_active[playerid];
}

AFK_GetReturnWorld(playerid) {
	return AFK_returnWorld[playerid];
}

hook OnPlayerGlobalUpdate(playerid)
{
	static Float:x;
	static Float:y;
	static Float:z;

	GetPlayerCameraPos(playerid, x, y, z);

	if(AFK_x[playerid] != x)
	{
		AFK_time[playerid] = 0;

		if(AFK_active[playerid])
		{
			AFK_active[playerid] = 0;
			SetPlayerVirtualWorld(playerid, AFK_returnWorld[playerid]);
			TextDrawHideForPlayer(playerid, AFK_TD);			
		}
	}
	else
	{
		if(!AFK_active[playerid] && (++AFK_time[playerid]) == AFK_TIME && PlayerInfo[playerid][pDisabled] != DISABLE_DYING)
		{
			AFK_active[playerid] = 1;
			AFK_returnWorld[playerid] = GetPlayerVirtualWorld(playerid);
			SetPlayerVirtualWorld(playerid, AFK_VWORLD);
			TextDrawShowForPlayer(playerid, AFK_TD);
		}
	}

	AFK_x[playerid] = x;
	return 1;
}

hook function OnPlayerResetStats(playerid)
{
	AFK_active[playerid] = 0;
	AFK_time[playerid] = 0;

	return continue(playerid);
}

hook OnGameModeInitEnded()
{
	AFK_TD = TextDrawCreate(320.000000, 205.000000, "modo ausente");
	TextDrawFont(AFK_TD, 3);
	TextDrawLetterSize(AFK_TD, 1.0, 4.0);
	TextDrawTextSize(AFK_TD, 10.0, 640.0);
	TextDrawSetOutline(AFK_TD, 1);
	TextDrawSetShadow(AFK_TD, 0);
	TextDrawAlignment(AFK_TD, 2);
	TextDrawColor(AFK_TD, 255);
	TextDrawBackgroundColor(AFK_TD, 0xFF0000FF);
	TextDrawBoxColor(AFK_TD, 170);
	TextDrawUseBox(AFK_TD, 1);
	return 1;
}