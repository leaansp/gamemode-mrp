#if defined _marp_garages_inc
	#endinput
#endif
#define _marp_garages_inc

#include "garage\marp_garages_core.pwn"
#include "garage\marp_garages_core_coords.pwn"
#include "garage\marp_garages_core_db.pwn"
#include "garage\marp_garages_admin.pwn"

#include <YSI_Coding\y_hooks>

/*_____________________________________________________________________________________________________________

    __                   __        
   / /_   ____   ____   / /__ _____
  / __ \ / __ \ / __ \ / //_// ___/
 / / / // /_/ // /_/ // ,<  (__  ) 
/_/ /_/ \____/ \____//_/|_|/____/  
                                                                              
______________________________________________________________________________________________________________*/

hook LoadSystemData()
{
	Garage_Init();
	Garage_LoadAll();
	return 1;
}

hook SaveSystemData()
{
	Garage_SaveAll();
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(KEY_PRESSED_SINGLE(KEY_CTRL_BACK) || (KEY_PRESSED_SINGLE(KEY_CROUCH) && IsPlayerInAnyVehicle(playerid)))
	{
		new garageid = Garage_IsInAnyArea(playerid);

		if(!Garage_IsValidId(garageid))
			return 1;

		if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
		if(GarageInfo[garageid][gLocked] && !AdminDuty[playerid])
			return GameTextForPlayer(playerid, "~r~Cerrado!", 2000, 4);

		if(Garage_IsInOutsideAreaId(playerid, garageid))
		{
			if(!IsPlayerInAnyVehicle(playerid)) {
				Garage_TpPlayerToInsideId(playerid, garageid);
				Garage_OnEnter(playerid, garageid);
			} else {
				Garage_TpPlayerVehicleToInside(playerid, garageid);
				Garage_OnExit(playerid, garageid);
			}
			return ~1;
		}
		else if(Garage_IsInInsideAreaId(playerid, garageid))
		{
			if(!IsPlayerInAnyVehicle(playerid)) {
				Garage_TpPlayerToOutsideId(playerid, garageid);
				Garage_OnEnter(playerid, garageid);
			} else {
				Garage_TpPlayerVehicleToOutside(playerid, garageid);
				Garage_OnExit(playerid, garageid);
			}
			return ~1;
		}
	}
	return 1;
}

CMD:garajepuerta(playerid, params[])
{
	new garageid = Garage_IsInAnyArea(playerid);

	if(!Garage_IsValidId(garageid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en la entrada o salida de un garaje!");
	if(!Garage_CanUse(playerid, garageid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este garaje.");

	new lock = !Garage_IsLocked(garageid); 
	Garage_SetLocked(garageid, lock);

	new string[128];
	format(string, sizeof(string), "toma unas llaves y %s la puerta del garaje.", (lock ? ("cierra") : ("abre")));
	PlayerCmeMessage(playerid, 15.0, 5000, string);
	return 1;
}
