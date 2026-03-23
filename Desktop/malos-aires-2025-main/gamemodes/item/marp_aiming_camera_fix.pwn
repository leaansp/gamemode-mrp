#if defined marp_aiming_camera_fix_inc
	#endinput
#endif
#define marp_aiming_camera_fix_inc

#include <YSI_Coding\y_hooks>

static bool:gAimingCameraFixActive[MAX_PLAYERS];
static gAimingCameraFixTimer[MAX_PLAYERS];

hook OnPlayerDisconnect(playerid, reason)
{
	gAimingCameraFixActive[playerid] = false;
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(KEY_PRESSED_SINGLE(KEY_HANDBRAKE))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (GetHandItem(playerid, HAND_RIGHT) == ITEM_ID_SNIPER || GetHandItem(playerid, HAND_RIGHT) == ITEM_ID_CAMARA))
		{
			if(!gAimingCameraFixTimer[playerid]) {
				gAimingCameraFixTimer[playerid] = SetTimerEx("FixAimingCamera", 80, false, "i", playerid);
			}
		}
	}
	else if(KEY_RELEASED_SINGLE(KEY_HANDBRAKE))
	{
		if(gAimingCameraFixTimer[playerid])
		{
			KillTimer(gAimingCameraFixTimer[playerid]);
			gAimingCameraFixTimer[playerid] = 0;
		}
		else if(gAimingCameraFixActive[playerid])
		{
			gAimingCameraFixActive[playerid] = false;

			Toy_AttachAllGraphicObjects(playerid);
			Hand_AttachAllGraphicObjects(playerid);
			Back_ShowGraphicObject(playerid);
		}
	}
	return 1;
}

forward FixAimingCamera(playerid);
public FixAimingCamera(playerid)
{
	gAimingCameraFixTimer[playerid] = 0;

	if(!IsPlayerLogged(playerid))
		return 0;

	if(GetPlayerCameraMode(playerid) == 7 || GetPlayerCameraMode(playerid) == 46)
	{
		gAimingCameraFixActive[playerid] = true;

		Toy_HideAllGraphicObjects(playerid);
		Hand_HideAllGraphicObjects(playerid);
		Back_HideGraphicObject(playerid);
	}

	return 1;
}