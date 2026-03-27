#if defined _marp_player_update_included
	#endinput
#endif
#define _marp_player_update_included

#include <YSI_Coding\y_hooks>

static playerGlobalUpdateTimer[MAX_PLAYERS];

hook LoginCamera_OnEnd(playerid)
{
	playerGlobalUpdateTimer[playerid] = SetTimerEx("OnPlayerGlobalUpdate", 997, true, "i", playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(playerGlobalUpdateTimer[playerid])
	{
		KillTimer(playerGlobalUpdateTimer[playerid]);
		playerGlobalUpdateTimer[playerid] = 0;
	}
	return 1;
}

forward OnPlayerGlobalUpdate(playerid);
public OnPlayerGlobalUpdate(playerid)
{
	if(!IsPlayerAFK(playerid) && PlayerInfo[playerid][pJailed] != JAIL_OOC) // Si no está AFK ni en Jail OOC
	{
		if((++PlayerInfo[playerid][pPayTime]) >= 3600)
		{
			PlayerInfo[playerid][pPayTime] = 0;
			Payday(playerid);
		}
		
		PlayerInfo[playerid][pTimePlayed]++;
		
		if(PlayerInfo[playerid][pMuteB] > 0)
		    PlayerInfo[playerid][pMuteB]--;
		if(PlayerInfo[playerid][pMuteTW] > 0)
		    PlayerInfo[playerid][pMuteTW]--;
	}

	if(PlayerInfo[playerid][pHospitalized] >= 2)
	{
	    PlayerInfo[playerid][pHospitalized]++;
	    
	    SetPlayerHealthEx(playerid, PlayerInfo[playerid][pHealth] + HP_GAIN);

	    if(PlayerInfo[playerid][pHealth] >= 100)
	    {
	        switch(GetPVarInt(playerid, "hosp"))
	        {
	       	 	case 1: {
	                PlayerInfo[playerid][pX] = 1178.9762;
					PlayerInfo[playerid][pY] = -1323.5491;
					PlayerInfo[playerid][pZ] = 14.1466;
					PlayerInfo[playerid][pA] = 270.0892;
	            }
	            case 2: {
	                PlayerInfo[playerid][pX] = 2001.6489;
					PlayerInfo[playerid][pY] = -1446.1147;
					PlayerInfo[playerid][pZ] = 13.5611;
					PlayerInfo[playerid][pA] = 137.1013;
	            }
	        }
	        
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Has sido dado de alta. Te cobraron $%d por tu tratamiento. Lo que te quede a pagar se descontará de tu cuenta bancaria.", PRICE_TREATMENT);
	        if(GetPlayerCash(playerid) > PRICE_TREATMENT)
				GivePlayerCash(playerid, -PRICE_TREATMENT);
			else
				if(GetPlayerCash(playerid) > 0)
				{
					PlayerInfo[playerid][pBank] -= PRICE_TREATMENT - GetPlayerCash(playerid);
				    ResetPlayerCash(playerid);
				} else
				    PlayerInfo[playerid][pBank] -= PRICE_TREATMENT;

			Faction_GiveMoney(FAC_HOSP, PRICE_TREATMENT / 8);
			
			BN_PlayerRefill(playerid);
	        DeletePVar(playerid, "hosp");
			SetPlayerHealthEx(playerid, 100.0);
	        PlayerInfo[playerid][pHospitalized] = 0;
			PlayerInfo[playerid][pVirtualWorld] = 0;
			PlayerInfo[playerid][pInterior] = 0;
	        SpawnPlayer(playerid);
		}
	}

	return 1;
}

