#if defined _marp_player_jail_inc
	#endinput
#endif
#define _marp_player_jail_inc

hook OnPlayerGlobalUpdate(playerid)
{
	if(PlayerInfo[playerid][pJailed] == JAIL_NONE || PlayerInfo[playerid][pJailed] == JAIL_IC_GOB)
		return 0;

	if(PlayerInfo[playerid][pJailTime] != 0)
	{
		if(!IsPlayerAFK(playerid))
		{
			PlayerInfo[playerid][pJailTime]--;
			new string[128];

			if(PlayerInfo[playerid][pJailTime] < 60) {
				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~w~Tiempo restante: ~g~%i segundos.", PlayerInfo[playerid][pJailTime]);
			} else {
				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~w~Tiempo restante: ~g~%i minutos.", PlayerInfo[playerid][pJailTime] / 60);
			}

			GameTextForPlayer(playerid, string, 2000, 3);
		}
	}

	if(PlayerInfo[playerid][pJailTime] == 0)
	{
	    switch(PlayerInfo[playerid][pJailed])
		{
	        case JAIL_IC_PMA:
			{
				SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has finalizado tu condena y estás en libertad, puedes retirarte.");
				TeleportPlayerTo(playerid, POS_POLICE_FREEDOM_X, POS_POLICE_FREEDOM_Y, POS_POLICE_FREEDOM_Z, 270.0, 3, 1040, .forceLoadingTime = true);
  			}
  			case JAIL_IC_PMA_EAST:
			{
				SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has finalizado tu condena y estás en libertad, puedes retirarte.");
				TeleportPlayerTo(playerid, POS_POLICE_FREEDOM2_X, POS_POLICE_FREEDOM2_Y, POS_POLICE_FREEDOM2_Z, 270.0, 0, 0, .forceLoadingTime = true);
  			}
	        case JAIL_OOC:
			{
				SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Finalizaste tu sanción, tratá de mejorar tu comportamiento para evitar problemas.");
				SetPlayerHealthEx(playerid, 100.0);
				SetPlayerColor(playerid, 0xFFFFFF00);
				TeleportPlayerTo(playerid, 1543.1399, -1675.5385, 13.5559, 90.2279, 0, 0, .forceLoadingTime = false, .syncPlayerNewPosData = true, .disableSyncOnExitSeconds = 0);
	        }
	        case JAIL_IC_PRISON:
			{
				SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has finalizado tu condena y estás en libertad, puedes retirarte.");
				TeleportPlayerTo(playerid, POS_PRISON_FREEDOM_X, POS_PRISON_FREEDOM_Y, POS_PRISON_FREEDOM_Z, 285.0, 0, 0, .forceLoadingTime = true);
  			}
			case JAIL_IC_GEN:
			{
				SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has finalizado tu condena y estás en libertad, puedes retirarte.");
				TeleportPlayerTo(playerid, POS_GEN_FREEDOM_X, POS_GEN_FREEDOM_Y, POS_GEN_FREEDOM_Z, 112.0, 0, 0, .forceLoadingTime = true);
			}
		}

		PlayerInfo[playerid][pJailed] = JAIL_NONE;
	}

	return 1;
}