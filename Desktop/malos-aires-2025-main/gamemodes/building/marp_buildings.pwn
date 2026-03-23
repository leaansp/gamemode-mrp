#if defined _marp_buildings_included
	#endinput
#endif
#define _marp_buildings_included

#include "building\marp_bld_core.pwn"
#include "building\marp_bld_core_db.pwn"
#include "building\marp_bld_core_coords.pwn"
#include "building\marp_bld_admin.pwn"

#include <YSI_Coding\y_hooks>

#define BLD_PMA                 34
#define BLD_HOSP                15
#define BLD_HOSP2               8
#define BLD_SIDE                26
#define BLD_MAN                 31

/*_____________________________________________________________________________________________________________

    __                   __        
   / /_   ____   ____   / /__ _____
  / __ \ / __ \ / __ \ / //_// ___/
 / / / // /_/ // /_/ // ,<  (__  ) 
/_/ /_/ \____/ \____//_/|_|/____/  
                                                                              
______________________________________________________________________________________________________________*/

hook LoadSystemData()
{
	Bld_Init();
	Bld_LoadAll();
	return 1;
}

hook SaveSystemData()
{
	Bld_SaveAll();
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(KEY_PRESSED_SINGLE(KEY_CTRL_BACK))
	{
		if(IsPlayerInAnyVehicle(playerid))
			return 1;

		new buildid = Bld_GetPlayerLastId(playerid);

		if(!Bld_IsValidId(buildid))
			return 1;

		if(Bld_IsPlayerAtOutsideDoorId(playerid, buildid))
		{
			if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
			if(BuildingInfo[buildid][blLocked] && !AdminDuty[playerid])
				return GameTextForPlayer(playerid, "~r~Cerrado!", 2000, 4);

			Bld_TpPlayerToInsideDoorId(playerid, buildid);
			return ~1;
		}
		else if(Bld_IsPlayerAtInsideDoorId(playerid, buildid))
		{
			if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
			if(BuildingInfo[buildid][blLocked] && !AdminDuty[playerid])
				return GameTextForPlayer(playerid, "~r~Cerrado!", 2000, 4);

			Bld_TpPlayerToOutsideDoorId(playerid, buildid);
			return ~1;
		}
	}
	return 1;
}

CMD:edificiopuerta(playerid, params[])
{
	new buildid = Bld_IsPlayerAtAnyDoorAny(playerid);

	if(!Bld_IsValidId(buildid))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "No te encuentras en la puerta de un edificio.");
	if((!Bld_GetFaction(buildid) && !AdminDuty[playerid]) || (Bld_GetFaction(buildid) != PlayerInfo[playerid][pFaction] && !AdminDuty[playerid]))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "¡No tienes la llave de este edificio!");

	Bld_SetLocked(buildid, !Bld_GetLocked(buildid));

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has %s"COLOR_EMB_GREY" el edificio.", (!Bld_GetLocked(buildid)) ? ("{33FF33}abierto") : ("{FF3333}cerrado"));
	return 1;
}