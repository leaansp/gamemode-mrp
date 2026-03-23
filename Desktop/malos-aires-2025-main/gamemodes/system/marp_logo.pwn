#if defined _marp_logo_inc
	#endinput
#endif
#define _marp_logo_inc

#include <YSI_Coding\y_hooks>

static Text:PublicTD[1];

hook OnGameModeInitEnded()
{
	PublicTD[0] = TextDrawCreate(535.000000, -17.000000, "mdl-2001:MARP_LOGO");
	TextDrawFont(PublicTD[0], 4);
	TextDrawLetterSize(PublicTD[0], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[0], 104.500000, 72.000000);
	TextDrawSetOutline(PublicTD[0], 1);
	TextDrawSetShadow(PublicTD[0], 0);
	TextDrawAlignment(PublicTD[0], 1);
	TextDrawColor(PublicTD[0], -1);
	TextDrawBackgroundColor(PublicTD[0], 255);
	TextDrawBoxColor(PublicTD[0], 50);
	TextDrawUseBox(PublicTD[0], 1);
	TextDrawSetProportional(PublicTD[0], 1);
	TextDrawSetSelectable(PublicTD[0], 0);
}

hook LoginCamera_OnEnd(playerid)
{
	Logo_ShowForPlayer(playerid);
	return 1;
}

Logo_ShowForPlayer(playerid)
{
	TextDrawShowForPlayer(playerid, PublicTD[0]);
}

Logo_HideForPlayer(playerid)
{
	TextDrawHideForPlayer(playerid, PublicTD[0]);
}