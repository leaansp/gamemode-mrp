#if defined _marp_login_camera_included
	#endinput
#endif
#define _marp_login_camera_included

#include <YSI_Coding\y_hooks>

static LoginCamera_timer[MAX_PLAYERS];

forward LoginCamera_Start(playerid, delay_init, delay_movement);
public LoginCamera_Start(playerid, delay_init, delay_movement)
{
	if(delay_init > 0)
	{
		LoginCamera_timer[playerid] = SetTimerEx("LoginCamera_Start", delay_init, false, "iii", playerid, 0, delay_movement);
		return 1;
	}

	if(PlayerInfo[playerid][pInterior] || PlayerInfo[playerid][pVirtualWorld] || PlayerInfo[playerid][pHospitalized] >= 1)
	{
		LoginCamera_timer[playerid] = SetTimerEx("LoginCamera_OnEnd", 4000, false, "i", playerid);
		return 1;
	}

	new Float:ini_px, Float:ini_py;

	GetXYBehindPoint(PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pA], ini_px, ini_py, 10.0);

	SetPlayerCameraPos(playerid, ini_px, ini_py, PlayerInfo[playerid][pZ] + 200.0);
	SetPlayerCameraLookAt(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ] + 0.604925, CAMERA_CUT);

	TogglePlayerControllable(playerid, false);

	LoginCamera_timer[playerid] = SetTimerEx("LoginCamera_StartMovement", delay_movement, false, "iff", playerid, ini_px, ini_py);
	return 1;
}

forward LoginCamera_StartMovement(playerid, Float:ini_px, Float:ini_py);
public LoginCamera_StartMovement(playerid, Float:ini_px, Float:ini_py)
{
	new Float:end_px, Float:end_py;

	GetXYBehindPoint(PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pA], end_px, end_py, 3.495635);

	InterpolateCameraPos(playerid, ini_px, ini_py, PlayerInfo[playerid][pZ] + 200.0, end_px, end_py, PlayerInfo[playerid][pZ] + 0.774925, 4000, CAMERA_MOVE);
	InterpolateCameraLookAt(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ] + 0.604925, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ] + 0.604925, 4000, CAMERA_MOVE);
	
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

	LoginCamera_timer[playerid] = SetTimerEx("LoginCamera_OnEnd", 4050 , false, "i", playerid);
	return 1;
}

forward LoginCamera_OnEnd(playerid);
public LoginCamera_OnEnd(playerid)
{
	if (PlayerInfo[playerid][pHospitalized] == 0)
	{
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, true);
	}
	
	LoginCamera_timer[playerid] = 0;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(LoginCamera_timer[playerid])
	{
		KillTimer(LoginCamera_timer[playerid]);
		LoginCamera_timer[playerid] = 0;
	}
	return 1;
}