#if defined _marp_money_bars_included
	#endinput
#endif
#define _marp_money_bars_included

#include <YSI_Coding\y_hooks>

static PlayerText:MoneyBars_PTD_changeBar[MAX_PLAYERS][3];
static MoneyBars_showingBars[MAX_PLAYERS][3];
static MoneyBars_changeBarMoney[MAX_PLAYERS][3];
static MoneyBars_timer[MAX_PLAYERS];

MoneyBars_NewChange(playerid, money)
{
	// Determino en cual textdraw lo voy a mostrar
	if(!MoneyBars_showingBars[playerid][0]) {
		MoneyBars_UpdateBar(playerid, 0, money);
	}
	else if(!MoneyBars_showingBars[playerid][1]) {
		MoneyBars_UpdateBar(playerid, 1, money);
	}
	else if(!MoneyBars_showingBars[playerid][2]) {
		MoneyBars_UpdateBar(playerid, 2, money);
	}
	else {
		MoneyBars_HideBar(playerid, 0);
		MoneyBars_UpdateBar(playerid, 2, money);
	}
}

static MoneyBars_UpdateBar(playerid, bar, money)
{
	static str[22];

	if(money < 0) {
		format(str, sizeof(str), "~r~-$%i", -money);
	}
	else {
		format(str, sizeof(str), "~g~+$%i", money);
	}

	PlayerTextDrawSetString(playerid, MoneyBars_PTD_changeBar[playerid][bar], str);
	PlayerTextDrawShow(playerid, MoneyBars_PTD_changeBar[playerid][bar]);
	MoneyBars_showingBars[playerid][bar] = 1;
	MoneyBars_changeBarMoney[playerid][bar] = money;

	if(bar == 0)
	{
		if(MoneyBars_timer[playerid]) {
			KillTimer(MoneyBars_timer[playerid]);
		}
		MoneyBars_timer[playerid] = SetTimerEx("MoneyBars_HideTop", 2500, false, "i", playerid);
	}
}

forward MoneyBars_HideTop(playerid);
public MoneyBars_HideTop(playerid)
{
	MoneyBars_timer[playerid] = 0;
	MoneyBars_HideBar(playerid, 0);
	return 1;
}

static MoneyBars_HideBar(playerid, bar)
{
	PlayerTextDrawHide(playerid, MoneyBars_PTD_changeBar[playerid][bar]);
	MoneyBars_showingBars[playerid][bar] = 0;

	if((++bar) < 3)
	{
		if(MoneyBars_showingBars[playerid][bar])
		{
			MoneyBars_UpdateBar(playerid, bar-1, MoneyBars_changeBarMoney[playerid][bar]);
			MoneyBars_HideBar(playerid, bar);
		}
	}
}

hook LoadAccountDataEnded(playerid)
{
	new PlayerText:ptd;

	ptd = CreatePlayerTextDraw(playerid, 608.000000, 99.000000, "_");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.550, 2.200);
	PlayerTextDrawTextSize(playerid, ptd, 5.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, ptd, 2);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 3);
	MoneyBars_PTD_changeBar[playerid][0] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 608.000000, 122.000000, "_");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.550, 2.200);
	PlayerTextDrawTextSize(playerid, ptd, 5.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, ptd, 2);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 3);
	MoneyBars_PTD_changeBar[playerid][1] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 608.000000, 145.000000, "_");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.550, 2.200);
	PlayerTextDrawTextSize(playerid, ptd, 5.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, ptd, 2);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 3);
	MoneyBars_PTD_changeBar[playerid][2] = ptd;

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(MoneyBars_timer[playerid])
	{
		KillTimer(MoneyBars_timer[playerid]);
		MoneyBars_timer[playerid] = 0;
	}
	MoneyBars_showingBars[playerid] = {0,0,0};
	return 1;
}
