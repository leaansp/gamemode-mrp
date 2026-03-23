#if defined _marp_speedo_included
	#endinput
#endif
#define _marp_speedo_included

#include <YSI_Coding\y_hooks>

static Speedo_timer[MAX_PLAYERS];

static PlayerText:Speedo_PTD_velocity[MAX_PLAYERS];
static PlayerText:Speedo_PTD_tankIcon[MAX_PLAYERS];
static PlayerBar:Speedo_PTD_currentFuelBar[MAX_PLAYERS];
static PlayerText:Speedo_PTD_main_one[MAX_PLAYERS];
static PlayerText:Speedo_PTD_main_two[MAX_PLAYERS];
static PlayerText:Speedo_PTD_main_three[MAX_PLAYERS];
static PlayerText:Speedo_PTD_main_four[MAX_PLAYERS];
static PlayerText:Speedo_PTD_damageIcon[MAX_PLAYERS];
static PlayerBar:Speedo_PTD_currentDamageBar[MAX_PLAYERS];

forward Speedo_Update(playerid);
public Speedo_Update(playerid) {
	static vehicleid;
	static string[16];

	if(!BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_HUD))
		return false;

	if(!(vehicleid = GetPlayerVehicleID(playerid)))
	{
		if(Speedo_timer[playerid])
		{
			HidePlayerSpeedo(playerid);
			KillTimer(Speedo_timer[playerid]);
			Speedo_timer[playerid] = 0;
		}
		return false;
	}

	format(string, sizeof(string), "%i", GetPlayerSpeed(playerid));
	PlayerTextDrawSetString(playerid, Speedo_PTD_velocity[playerid], string);

	SetPlayerProgressBarValue(playerid, Speedo_PTD_currentFuelBar[playerid], float(VehicleInfo[vehicleid][VehFuel]));
	ShowPlayerProgressBar(playerid, Speedo_PTD_currentFuelBar[playerid]);

	SetPlayerProgressBarValue(playerid, Speedo_PTD_currentDamageBar[playerid], (VehicleInfo[vehicleid][VehHP]));
	ShowPlayerProgressBar(playerid, Speedo_PTD_currentDamageBar[playerid]);
	return true;
}

HidePlayerSpeedo(playerid) {
	PlayerTextDrawHide(playerid, Speedo_PTD_velocity[playerid]);
	PlayerTextDrawHide(playerid, Speedo_PTD_tankIcon[playerid]);
	HidePlayerProgressBar(playerid, Speedo_PTD_currentFuelBar[playerid]);
	PlayerTextDrawHide(playerid, Speedo_PTD_main_one[playerid]);
	PlayerTextDrawHide(playerid, Speedo_PTD_main_two[playerid]);
	PlayerTextDrawHide(playerid, Speedo_PTD_main_three[playerid]);
	PlayerTextDrawHide(playerid, Speedo_PTD_main_four[playerid]);
	PlayerTextDrawHide(playerid, Speedo_PTD_damageIcon[playerid]);
	HidePlayerProgressBar(playerid, Speedo_PTD_currentDamageBar[playerid]);
}

ShowPlayerSpeedo(playerid) {
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_HUD))
	{
		Speedo_Update(playerid);

		PlayerTextDrawShow(playerid, Speedo_PTD_velocity[playerid]);
		PlayerTextDrawShow(playerid, Speedo_PTD_tankIcon[playerid]);
		ShowPlayerProgressBar(playerid, Speedo_PTD_currentFuelBar[playerid]);
		PlayerTextDrawShow(playerid, Speedo_PTD_main_one[playerid]);
		PlayerTextDrawShow(playerid, Speedo_PTD_main_two[playerid]);
		PlayerTextDrawShow(playerid, Speedo_PTD_main_three[playerid]);
		PlayerTextDrawShow(playerid, Speedo_PTD_main_four[playerid]);
		PlayerTextDrawShow(playerid, Speedo_PTD_damageIcon[playerid]);
		ShowPlayerProgressBar(playerid, Speedo_PTD_currentDamageBar[playerid]);
	}
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
	if(oldstate == PLAYER_STATE_DRIVER)
	{
		if(Speedo_timer[playerid])
		{
			HidePlayerSpeedo(playerid);
			KillTimer(Speedo_timer[playerid]);
			Speedo_timer[playerid] = 0;
		}
	}
	else if(newstate == PLAYER_STATE_DRIVER)
	{
		if(Veh_GetModelType(GetPlayerVehicleID(playerid)) != VTYPE_BMX)
		{
			if(Speedo_timer[playerid]) {
				KillTimer(Speedo_timer[playerid]);
			}

			ShowPlayerSpeedo(playerid);
			Speedo_timer[playerid] = SetTimerEx("Speedo_Update", 500, true, "i", playerid);
		}
	}
	return true;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(Speedo_timer[playerid])
	{
		KillTimer(Speedo_timer[playerid]);
		Speedo_timer[playerid] = 0;
	}
	return true;
}

hook OnPlayerSpawn(playerid) {
	if(Speedo_timer[playerid])
	{
		HidePlayerSpeedo(playerid);
		KillTimer(Speedo_timer[playerid]);
		Speedo_timer[playerid] = 0;
	}
	return true;
}

hook OnPlayerConnectDelayed(playerid) {
	Speedo_PTD_main_one[playerid] = CreatePlayerTextDraw(playerid, 634.000000, 484.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, Speedo_PTD_main_one[playerid], 5);
	PlayerTextDrawLetterSize(playerid, Speedo_PTD_main_one[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, Speedo_PTD_main_one[playerid], -163.000000, -130.000000);
	PlayerTextDrawSetOutline(playerid, Speedo_PTD_main_one[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Speedo_PTD_main_one[playerid], 0);
	PlayerTextDrawAlignment(playerid, Speedo_PTD_main_one[playerid], 1);
	PlayerTextDrawColor(playerid, Speedo_PTD_main_one[playerid], 50);
	PlayerTextDrawBackgroundColor(playerid, Speedo_PTD_main_one[playerid], 0);
	PlayerTextDrawBoxColor(playerid, Speedo_PTD_main_one[playerid], 0);
	PlayerTextDrawUseBox(playerid, Speedo_PTD_main_one[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Speedo_PTD_main_one[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Speedo_PTD_main_one[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, Speedo_PTD_main_one[playerid], 1625);
	PlayerTextDrawSetPreviewRot(playerid, Speedo_PTD_main_one[playerid], 0.000000, 90.000000, 0.000000, 2.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, Speedo_PTD_main_one[playerid], 1, 1);

	Speedo_PTD_main_two[playerid] = CreatePlayerTextDraw(playerid, 656.000000, 541.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, Speedo_PTD_main_two[playerid], 5);
	PlayerTextDrawLetterSize(playerid, Speedo_PTD_main_two[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, Speedo_PTD_main_two[playerid], -90.500000, -290.000000);
	PlayerTextDrawSetOutline(playerid, Speedo_PTD_main_two[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Speedo_PTD_main_two[playerid], 0);
	PlayerTextDrawAlignment(playerid, Speedo_PTD_main_two[playerid], 1);
	PlayerTextDrawColor(playerid, Speedo_PTD_main_two[playerid], 50);
	PlayerTextDrawBackgroundColor(playerid, Speedo_PTD_main_two[playerid], 0);
	PlayerTextDrawBoxColor(playerid, Speedo_PTD_main_two[playerid], 0);
	PlayerTextDrawUseBox(playerid, Speedo_PTD_main_two[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Speedo_PTD_main_two[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Speedo_PTD_main_two[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, Speedo_PTD_main_two[playerid], 1625);
	PlayerTextDrawSetPreviewRot(playerid, Speedo_PTD_main_two[playerid], 0.000000, 90.000000, 0.000000, 2.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, Speedo_PTD_main_two[playerid], 1, 1);

	Speedo_PTD_main_three[playerid] = CreatePlayerTextDraw(playerid, 634.000000, 461.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, Speedo_PTD_main_three[playerid], 5);
	PlayerTextDrawLetterSize(playerid, Speedo_PTD_main_three[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, Speedo_PTD_main_three[playerid], -163.000000, -130.000000);
	PlayerTextDrawSetOutline(playerid, Speedo_PTD_main_three[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Speedo_PTD_main_three[playerid], 0);
	PlayerTextDrawAlignment(playerid, Speedo_PTD_main_three[playerid], 1);
	PlayerTextDrawColor(playerid, Speedo_PTD_main_three[playerid], 50);
	PlayerTextDrawBackgroundColor(playerid, Speedo_PTD_main_three[playerid], 0);
	PlayerTextDrawBoxColor(playerid, Speedo_PTD_main_three[playerid], 0);
	PlayerTextDrawUseBox(playerid, Speedo_PTD_main_three[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Speedo_PTD_main_three[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Speedo_PTD_main_three[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, Speedo_PTD_main_three[playerid], 1625);
	PlayerTextDrawSetPreviewRot(playerid, Speedo_PTD_main_three[playerid], 0.000000, 90.000000, 0.000000, 2.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, Speedo_PTD_main_three[playerid], 1, 1);

	Speedo_PTD_velocity[playerid] = CreatePlayerTextDraw(playerid, 603.000000, 399.000000, "999");
	PlayerTextDrawFont(playerid, Speedo_PTD_velocity[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Speedo_PTD_velocity[playerid], 0.362500, 2.799998);
	PlayerTextDrawTextSize(playerid, Speedo_PTD_velocity[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, Speedo_PTD_velocity[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Speedo_PTD_velocity[playerid], 0);
	PlayerTextDrawAlignment(playerid, Speedo_PTD_velocity[playerid], 1);
	PlayerTextDrawColor(playerid, Speedo_PTD_velocity[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Speedo_PTD_velocity[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Speedo_PTD_velocity[playerid], 50);
	PlayerTextDrawUseBox(playerid, Speedo_PTD_velocity[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Speedo_PTD_velocity[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Speedo_PTD_velocity[playerid], 0);

	Speedo_PTD_main_four[playerid] = CreatePlayerTextDraw(playerid, 616.000000, 424.000000, "km/h");
	PlayerTextDrawFont(playerid, Speedo_PTD_main_four[playerid], 2);
	PlayerTextDrawLetterSize(playerid, Speedo_PTD_main_four[playerid], 0.150000, 1.100000);
	PlayerTextDrawTextSize(playerid, Speedo_PTD_main_four[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, Speedo_PTD_main_four[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Speedo_PTD_main_four[playerid], 0);
	PlayerTextDrawAlignment(playerid, Speedo_PTD_main_four[playerid], 1);
	PlayerTextDrawColor(playerid, Speedo_PTD_main_four[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Speedo_PTD_main_four[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Speedo_PTD_main_four[playerid], 50);
	PlayerTextDrawUseBox(playerid, Speedo_PTD_main_four[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Speedo_PTD_main_four[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Speedo_PTD_main_four[playerid], 0);

	Speedo_PTD_tankIcon[playerid] = CreatePlayerTextDraw(playerid, 536.000000, 400.000000, "HUD:radar_centre");
	PlayerTextDrawFont(playerid, Speedo_PTD_tankIcon[playerid], 4);
	PlayerTextDrawLetterSize(playerid, Speedo_PTD_tankIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, Speedo_PTD_tankIcon[playerid], 9.500000, 10.000000);
	PlayerTextDrawSetOutline(playerid, Speedo_PTD_tankIcon[playerid], 1);
	PlayerTextDrawSetShadow(playerid, Speedo_PTD_tankIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, Speedo_PTD_tankIcon[playerid], 1);
	PlayerTextDrawColor(playerid, Speedo_PTD_tankIcon[playerid], -664322817);
	PlayerTextDrawBackgroundColor(playerid, Speedo_PTD_tankIcon[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Speedo_PTD_tankIcon[playerid], 50);
	PlayerTextDrawUseBox(playerid, Speedo_PTD_tankIcon[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Speedo_PTD_tankIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Speedo_PTD_tankIcon[playerid], 0);

	Speedo_PTD_damageIcon[playerid] = CreatePlayerTextDraw(playerid, 536.000000, 423.000000, "HUD:radar_modgarage");
	PlayerTextDrawFont(playerid, Speedo_PTD_damageIcon[playerid], 4);
	PlayerTextDrawLetterSize(playerid, Speedo_PTD_damageIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, Speedo_PTD_damageIcon[playerid], 9.500000, 10.000000);
	PlayerTextDrawSetOutline(playerid, Speedo_PTD_damageIcon[playerid], 1);
	PlayerTextDrawSetShadow(playerid, Speedo_PTD_damageIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, Speedo_PTD_damageIcon[playerid], 1);
	PlayerTextDrawColor(playerid, Speedo_PTD_damageIcon[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Speedo_PTD_damageIcon[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Speedo_PTD_damageIcon[playerid], 50);
	PlayerTextDrawUseBox(playerid, Speedo_PTD_damageIcon[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Speedo_PTD_damageIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Speedo_PTD_damageIcon[playerid], 0);
	
	Speedo_PTD_currentFuelBar[playerid] = CreatePlayerProgressBar(playerid, 549.000000, 404.000000, 44.000000, 3.000000, -664322817, 100.000000, 0);

	Speedo_PTD_currentDamageBar[playerid] = CreatePlayerProgressBar(playerid, 549.000000, 426.000000, 44.000000, 3.500000, -567003905, 1000.000000, 0);
	return true;
}