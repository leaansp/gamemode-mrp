#if defined _marp_player_save_account_inc
	#endinput
#endif
#define _marp_player_save_account_inc

#include <YSI_Coding\y_hooks>

static playerSaveAccountTimer[MAX_PLAYERS];

hook LoginCamera_OnEnd(playerid)
{
	playerSaveAccountTimer[playerid] = SetTimerEx("SaveAccount", 1200000, true, "i", playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(playerSaveAccountTimer[playerid])
	{
		KillTimer(playerSaveAccountTimer[playerid]);
		playerSaveAccountTimer[playerid] = 0;
	}
	return 1;
}