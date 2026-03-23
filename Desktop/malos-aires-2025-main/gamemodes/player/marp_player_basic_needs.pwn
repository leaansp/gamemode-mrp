#if defined _marp_player_basic_needs_inc
	#endinput
#endif
#define _marp_player_basic_needs_inc

#include <YSI_Coding\y_hooks>

#define BASIC_NEEDS_UPDATE_TIME 360 // En segundos
#define BASIC_NEEDS_UPDATE_LOSS	2 	// Cuanto pierde de comida y bebida por cada actualización de BASIC_NEEDS_UPDATE_TIME
#define BASIC_NEEDS_HP_LOSS 	3.0 // Vida que pierde en cada actualizacion si la sed o el hambre está en 0

#define BN_COLOR_FULL 		(0x74C133FF)
#define BN_COLOR_CAUTION 	(0xE6D333FF)
#define BN_COLOR_ALERT 		(0xF04A17FF)

static playerBasicNeedsTimer[MAX_PLAYERS];

static PlayerBar:PTD_foodBar[MAX_PLAYERS];
static PlayerBar:PTD_drinkBar[MAX_PLAYERS];
static PlayerText:PTD_foodIcon[MAX_PLAYERS];
static PlayerText:PTD_drinkIcon[MAX_PLAYERS];
static PlayerText:PTD_NeedsBackground[MAX_PLAYERS];

static DrinksTaken[MAX_PLAYERS];

hook LoginCamera_OnEnd(playerid) {
	BN_CreateTextdrawsForPlayer(playerid);
   	BN_UpdateFoodValues(playerid);
   	BN_UpdateDrinkValues(playerid);
   	BN_ShowForPlayer(playerid);

   	playerBasicNeedsTimer[playerid] = SetTimerEx("OnPlayerBasicNeedsUpdate", BASIC_NEEDS_UPDATE_TIME * 1000, true, "i", playerid);
	return true;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(playerBasicNeedsTimer[playerid])
	{
		KillTimer(playerBasicNeedsTimer[playerid]);
		playerBasicNeedsTimer[playerid] = 0;
	}
	return true;
}

BN_CreateTextdrawsForPlayer(playerid) {	
	PTD_NeedsBackground[playerid] = CreatePlayerTextDraw(playerid, 645.000000, 108.000000, "TextDraw");
	PTD_NeedsBackground[playerid] = CreatePlayerTextDraw(playerid, 645.000000, 107.000000, "TextDraw");
	PlayerTextDrawFont(playerid, PTD_NeedsBackground[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PTD_NeedsBackground[playerid], 0.637498, 1.599998);
	PlayerTextDrawTextSize(playerid, PTD_NeedsBackground[playerid], 535.500000, -6.500000);
	PlayerTextDrawSetOutline(playerid, PTD_NeedsBackground[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PTD_NeedsBackground[playerid], 0);
	PlayerTextDrawAlignment(playerid, PTD_NeedsBackground[playerid], 1);
	PlayerTextDrawColor(playerid, PTD_NeedsBackground[playerid], -256);
	PlayerTextDrawBackgroundColor(playerid, PTD_NeedsBackground[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_NeedsBackground[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_NeedsBackground[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PTD_NeedsBackground[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_NeedsBackground[playerid], 0);

	PTD_foodBar[playerid] = CreatePlayerProgressBar(playerid, 562.000000, 113.000000, 29.500000, 4.500000, -764862721, 100.000000, 0);
	PTD_drinkBar[playerid] = CreatePlayerProgressBar(playerid, 608.000000, 113.000000, 29.500000, 4.500000, 1687547391, 100.000000, 0);

	PTD_foodIcon[playerid] = CreatePlayerTextDraw(playerid, 544.000000, 108.000000, "HUD:radar_burgershot");
	PlayerTextDrawFont(playerid, PTD_foodIcon[playerid], 4);
	PlayerTextDrawLetterSize(playerid, PTD_foodIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PTD_foodIcon[playerid], 13.000000, 13.500000);
	PlayerTextDrawSetOutline(playerid, PTD_foodIcon[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PTD_foodIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, PTD_foodIcon[playerid], 1);
	PlayerTextDrawColor(playerid, PTD_foodIcon[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_foodIcon[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_foodIcon[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_foodIcon[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PTD_foodIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_foodIcon[playerid], 0);

	PTD_drinkIcon[playerid] = CreatePlayerTextDraw(playerid, 595.000000, 109.000000, "HUD:radar_datedrink");
	PlayerTextDrawFont(playerid, PTD_drinkIcon[playerid], 4);
	PlayerTextDrawLetterSize(playerid, PTD_drinkIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PTD_drinkIcon[playerid], 10.000000, 12.000000);
	PlayerTextDrawSetOutline(playerid, PTD_drinkIcon[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PTD_drinkIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, PTD_drinkIcon[playerid], 1);
	PlayerTextDrawColor(playerid, PTD_drinkIcon[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_drinkIcon[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_drinkIcon[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_drinkIcon[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PTD_drinkIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_drinkIcon[playerid], 0);
}

BN_ShowForPlayer(playerid) {
	ShowPlayerProgressBar(playerid, PTD_foodBar[playerid]);
	ShowPlayerProgressBar(playerid, PTD_drinkBar[playerid]);
	PlayerTextDrawShow(playerid, PTD_foodIcon[playerid]);
	PlayerTextDrawShow(playerid, PTD_drinkIcon[playerid]);
	PlayerTextDrawShow(playerid, PTD_NeedsBackground[playerid]);
}

BN_HideForPlayer(playerid) {
	HidePlayerProgressBar(playerid, PTD_foodBar[playerid]);
	HidePlayerProgressBar(playerid, PTD_drinkBar[playerid]);
	PlayerTextDrawHide(playerid, PTD_foodIcon[playerid]);
	PlayerTextDrawHide(playerid, PTD_drinkIcon[playerid]);
	PlayerTextDrawHide(playerid, PTD_NeedsBackground[playerid]);
}

BN_PlayerDrinkAlcohol(playerid, alcohol) {
	if(alcohol)
	{
		DrinksTaken[playerid] += alcohol;
		if(DrinksTaken[playerid] >= 100)
		{
			SetPlayerDrunkLevel(playerid, 15000); // a 50 fps, este valor disminuye a 50 unidades por segundo => 300 segundos
			SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has tomado demasiado y entras en estado de ebriedad");
			DrinksTaken[playerid] = 0;
		}
		if(GetPlayerDrunkLevel(playerid) >= 2000) {
			ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		}
	}
}

BN_PlayerEat(playerid, value) {
	if(value)
	{
		PlayerInfo[playerid][pHunger] += value;
		if(PlayerInfo[playerid][pHunger] > 100)
		{
			PlayerInfo[playerid][pHunger] = 100;
			SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Te encuentras satisfecho.");
		}
		BN_UpdateFoodValues(playerid);
	}
}

BN_PlayerDrink(playerid, value) {
	if(value)
	{
		PlayerInfo[playerid][pThirst] += value;
		if(PlayerInfo[playerid][pThirst] > 100)
		{
			PlayerInfo[playerid][pThirst] = 100;
			SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has saciado tu sed.");
		}
		BN_UpdateDrinkValues(playerid);
	}
}

BN_UpdateFoodValues(playerid) {
	SetPlayerProgressBarValue(playerid, PTD_foodBar[playerid], float(PlayerInfo[playerid][pHunger]));
}

BN_UpdateDrinkValues(playerid) {
	SetPlayerProgressBarValue(playerid, PTD_drinkBar[playerid], float(PlayerInfo[playerid][pThirst]));
}

BN_PlayerRefill(playerid) {
	PlayerInfo[playerid][pHunger] = 100;
    BN_UpdateFoodValues(playerid);
	PlayerInfo[playerid][pThirst] = 100;
    BN_UpdateDrinkValues(playerid);
}

forward OnPlayerBasicNeedsUpdate(playerid);
public OnPlayerBasicNeedsUpdate(playerid) {
    if(IsPlayerAFK(playerid) || PlayerInfo[playerid][pJailed] == JAIL_OOC || AdminDuty[playerid])
    	return false;

	if(PlayerInfo[playerid][pThirst] > 0)
	{
		PlayerInfo[playerid][pThirst] -= BASIC_NEEDS_UPDATE_LOSS;

		if(PlayerInfo[playerid][pThirst] < 0) {
			PlayerInfo[playerid][pThirst] = 0;
		}

		BN_UpdateDrinkValues(playerid);
	}
	else
	{
		if(PlayerInfo[playerid][pHealth] - BASIC_NEEDS_HP_LOSS <= 0) {
			PlayerInfo[playerid][pHealth] = 0;
		} else {
			PlayerInfo[playerid][pHealth] -= BASIC_NEEDS_HP_LOSS;
		}

		SendClientMessage(playerid, COLOR_RED, "Estas deshidratándote, bebe algo urgente o morirás de sed.");
	}

	if(PlayerInfo[playerid][pHunger] > 0)
	{
		PlayerInfo[playerid][pHunger] -= BASIC_NEEDS_UPDATE_LOSS;

		if(PlayerInfo[playerid][pHunger] < 0) {
			PlayerInfo[playerid][pHunger] = 0;
		}

		BN_UpdateFoodValues(playerid);
	}
	else
	{
		if(PlayerInfo[playerid][pHealth] - BASIC_NEEDS_HP_LOSS <= 0) {
			PlayerInfo[playerid][pHealth] = 0;
		} else {
			PlayerInfo[playerid][pHealth] -= BASIC_NEEDS_HP_LOSS;
		}

		SendClientMessage(playerid, COLOR_RED, "No has comido en mucho tiempo, come algo urgente o morirás de hambre.");
	}
	return true;
}