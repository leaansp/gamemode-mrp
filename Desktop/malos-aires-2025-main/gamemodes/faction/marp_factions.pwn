#if defined _marp_factions_included
	#endinput
#endif
#define _marp_factions_included

#include "faction\marp_factions_core.pwn"
#include "faction\marp_factions_core_db.pwn"
#include "faction\marp_factions_admin.pwn"

#include <YSI_Coding\y_hooks>

new MedDuty[MAX_PLAYERS],
	CopDuty[MAX_PLAYERS],
	SIDEDuty[MAX_PLAYERS],
	PlayerCuffed[MAX_PLAYERS];

new FactionChannel[MAX_FACTIONS];
new FactionRequest[MAX_PLAYERS];

SendFactionMessage(factionid, color, const message[])
{
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pFaction] == factionid) {
			SendClientMessage(i, color, message);
		}
	}
}

SendFactionRadioMessage(factionid, color, const message[])
{
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pFaction] == factionid && BitFlag_Get(p_toggle[i], FLAG_TOGGLE_RADIO) && PlayerHasRadio(i)) {
			SendClientMessage(i, color, message);
		}
	}
}

stock isPlayerCopOnDuty(playerid)
{
	if(PlayerInfo[playerid][pFaction] == FAC_PMA && CopDuty[playerid])
	    return true;
	if(PlayerInfo[playerid][pFaction] == FAC_SIDE && SIDEDuty[playerid])
	    return true;
	return false;
}

stock isPlayerSideOnDuty(playerid)
{
	if(PlayerInfo[playerid][pFaction] == FAC_SIDE && SIDEDuty[playerid])
	    return true;
	else
		return false;
}

forward CountCopsOnDuty();
public CountCopsOnDuty()
{
	new aux = 0;
 	foreach(new i : Player)
 	{
        if(isPlayerCopOnDuty(i))
    	    aux ++;
 	}
 	return aux;
}

CMD:fdepositar(playerid,params[])
{
	new string[128], amount;
	
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, POS_BANK_X, POS_BANK_Y, POS_BANK_Z) && !IsAtATM(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?Debes estar en un banco o cajero autom?tico!");
    if(!PlayerInfo[playerid][pFaction])
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?No perteneces a una facci?n!");
 	if(sscanf(params, "d", amount))
  		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/fdepositar [cantidad]");
 	if(GetPlayerCash(playerid) < amount || amount < 1)
 	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?Cantidad de dinero inv?lida!");
 	    
	GivePlayerCash(playerid, -amount);
	Faction_GiveMoney(PlayerInfo[playerid][pFaction], amount);
	format(string, sizeof(string), "Has depositado $%d en la cuenta compartida, nuevo balance: $%d.", amount, Faction_GetBank(PlayerInfo[playerid][pFaction]));
	SendClientMessage(playerid, COLOR_WHITE, string);

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="DEPOSITO FAC", .playerid=playerid, .params=<"$%d - Faccion: %s", amount, FactionInfo[PlayerInfo[playerid][pFaction]][fName]>);
 	PlayerActionMessage(playerid, 15.0, "toma una suma de dinero y la deposita en su cuenta.");
    return 1;
}

CMD:fretirar(playerid,params[])
{
	new string[128], amount;

	if(!IsPlayerInRangeOfPoint(playerid, 5.0, POS_BANK_X, POS_BANK_Y, POS_BANK_Z) && !IsAtATM(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?Debes estar en un banco o cajero autom?tico!");
 	if(!PlayerInfo[playerid][pFaction])
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?No perteneces a una facci?n!");
 	if(sscanf(params, "d", amount))
  		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/fretirar [cantidad]");
    if(PlayerInfo[playerid][pRank] != 1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?No tienes el rango suficiente!");
 	if(Faction_GetBank(PlayerInfo[playerid][pFaction]) < amount || amount < 1)
 	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?Cantidad de dinero inv?lida!");
 	    
	GivePlayerCash(playerid, amount);
	Faction_GiveMoney(PlayerInfo[playerid][pFaction], -amount);
	format(string, sizeof(string), "Has retirado $%d de la cuenta compartida, nuevo balance: $%d.", amount, Faction_GetBank(PlayerInfo[playerid][pFaction]));
	SendClientMessage(playerid, COLOR_WHITE, string);
    PlayerActionMessage(playerid, 15.0, "retira una suma de dinero de su cuenta.");

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="RETIRO FAC", .playerid=playerid, .params=<"$%d - Faccion: %s", amount, FactionInfo[PlayerInfo[playerid][pFaction]][fName]>);
    return 1;
}

CMD:fverbalance(playerid,params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, POS_BANK_X, POS_BANK_Y, POS_BANK_Z) && !IsAtATM(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?Debes estar en un banco o cajero autom?tico!");
    if(!PlayerInfo[playerid][pFaction])
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?No perteneces a una facci?n!");
    if(PlayerInfo[playerid][pRank] != 1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?No tienes el rango suficiente!");

	SendFMessage(playerid, COLOR_WHITE, "El balance actual de la cuenta compartida es de $%d.", Faction_GetBank(PlayerInfo[playerid][pFaction]));
	PlayerActionMessage(playerid, 15.0, "recibe un papel con el estado de su cuenta bancaria.");
    return 1;
}

stock PrintFactionCmdUsage(playerid)
{
	SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/fac)cion [comando]");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" abandonar - conectados");
	if(PlayerInfo[playerid][pRank] == 1) {
		SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" vehiculos - cerrarf - invitar - expulsar - rango - /fretirar - /fdepositar - /fverbalance");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Como lider puedes estacionar los vehiculos de la faccion con '/vehestacionar'.");
	}
	return 1;
}

CMD:fac(playerid, params[]) {
	return cmd_faccion(playerid, params);
}

CMD:faccion(playerid, params[])
{
	new subcmd[16], targetid, rank, factionid = PlayerInfo[playerid][pFaction];
	
	if(factionid <= 0)
		return 1;
	if(sscanf(params, "s[16] ", subcmd))
		return PrintFactionCmdUsage(playerid);

	if(!strcmp(subcmd, "abandonar", true))
	{
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has abandonado tu facci?n.");
		Faction_SetPlayer(playerid, 0, 0);
	}
	else if(!strcmp(subcmd, "conectados", true))
	{
	    SendFMessage(playerid, COLOR_LIGHTYELLOW2, "Miembros conectados [%s]", FactionInfo[factionid][fName]);
	    foreach(new i : Player) 
	    {
	        if(PlayerInfo[i][pFaction] == factionid) {
				SendFMessage(playerid, COLOR_WHITE, "* (%s) %s", Faction_GetRankName(factionid, PlayerInfo[i][pRank]), GetPlayerCleanName(i));
	        }
	    }
	}
	else if(!strcmp(subcmd, "vehiculos", true))
	{
		if(PlayerInfo[playerid][pRank] != 1)
			return 1;
		
		Faction_ShowVehicles(PlayerInfo[playerid][pFaction], playerid);
		
	}
	else if(!strcmp(subcmd, "cerrarf", true))
	{
		if(PlayerInfo[playerid][pRank] != 1)
			return 1;

		if(FactionChannel[factionid])
		{
			FactionChannel[factionid] = 0;
			SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Abriste el canal /f de la facci?n. Ahora todos los miembros podr?n utilizarlo.");
			SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, "[Facci?n] El canal /f fue abierto por el l?der.");
		}
		else
		{
			FactionChannel[factionid] = 1;
			SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cerraste el canal /f de la facci?n. ?nicamente el l?der podr? utilizarlo.");
			SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, "[Facci?n] El canal /f fue cerrado por el l?der.");
		}
	}
	else if(!strcmp(subcmd, "invitar", true))
	{
		if(PlayerInfo[playerid][pRank] != 1)
			return 1;
		if(sscanf(params, "s[16]u", subcmd, targetid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/fac invitar [ID/Jugador]");
		if(!IsPlayerLogged(targetid) || playerid == targetid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inv?lido.");
		if(PlayerInfo[targetid][pFaction] != 0)
		    return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "El jugador ya tiene una facci?n.");
        if(FactionInfo[factionid][fJoinRank] == 0)
            return SendClientMessage(playerid, COLOR_ERROR,"[ERROR] "COLOR_EMB_GREY" Rango de ingreso mal configurado. Contacte con un administrador.");

		FactionRequest[targetid] = factionid;
		SendFMessage(targetid, COLOR_LIGHTBLUE, "Has sido invitado a la facci?n %s por %s. (/aceptar faccion - para ingresar).",FactionInfo[factionid][fName],GetPlayerCleanName(playerid));
		SendFMessage(playerid, COLOR_LIGHTBLUE, "Has invitado a %s a la facci?n %s.", GetPlayerCleanName(targetid),FactionInfo[factionid][fName]);
		return 1;
	}
	else if(!strcmp(subcmd, "expulsar", true))
	{
		if(PlayerInfo[playerid][pRank] != 1)
			return 1;
		if(sscanf(params, "s[16]u", subcmd, targetid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/fac expulsar [ID/Jugador]");
		if(!IsPlayerLogged(targetid) || playerid == targetid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inv?lido.");
		if(PlayerInfo[targetid][pFaction] != factionid)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "El jugador no pertenece a tu facci?n.");

		Faction_SetPlayer(targetid, 0, 0);
		SendFMessage(targetid, COLOR_LIGHTBLUE, "Has sido expulsado de la facci?n %s por %s.", FactionInfo[factionid][fName], GetPlayerCleanName(playerid));
		SendFMessage(playerid, COLOR_LIGHTBLUE, "Has expulsado a %s de la facci?n %s.", GetPlayerCleanName(targetid), FactionInfo[factionid][fName]);
		return 1;
	}
	else if(!strcmp(subcmd, "rango", true))
	{
		if(PlayerInfo[playerid][pRank] != 1)
			return 1;
		if(sscanf(params, "s[16]ui", subcmd, targetid, rank))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/fac rango [ID/Jugador] [nro rango]");
		if(!IsPlayerLogged(targetid) || playerid == targetid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inv?lido.");
		if(PlayerInfo[targetid][pFaction] != factionid)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "El jugador no pertenece a tu facci?n.");
		if(rank < 2 || rank > FactionInfo[factionid][fRankAmount]) {
			SendFMessage(playerid, COLOR_LIGHTYELLOW2, "El rango no debe ser menor a 2 o mayor que %d.", FactionInfo[factionid][fRankAmount]);
			return 1;
		}
		
		Faction_SetPlayer(targetid, factionid, rank);
		SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"tu rango ha sido cambiado por %s, ahora eres %s.", GetPlayerCleanName(playerid), Faction_GetRankName(factionid, rank));
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"le has cambiado el rango de %s a %s.", GetPlayerCleanName(targetid), Faction_GetRankName(factionid, rank));
		new string[128];
		format(string, sizeof(string), "[Facci?n] %s es ahora %s.", GetPlayerCleanName(targetid), Faction_GetRankName(factionid, rank));
		SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, string);
		return 1;
	} else {
		PrintFactionCmdUsage(playerid);
	}
	return 1;
}

hook function OnPlayerCmdAccept(playerid, const subcmd[])
{
	if(strcmp(subcmd, "faccion", true))
		return continue(playerid, subcmd);

	new factionid = FactionRequest[playerid], string[128];

	if(factionid == 0)
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"Nadie te ha invitado a una facci?n.");
	if(PlayerInfo[playerid][pFaction] != 0)
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"?Ya te encuentras en una facci?n!");

	format(string, sizeof(string), "[Facci?n] %s ha ingresado a la facci?n.",GetPlayerCleanName(playerid));
	SendFactionMessage(factionid, COLOR_FACTIONCHAT, string);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"?Felicitaciones! ahora eres miembro de la facci?n: %s.", Faction_GetName(factionid));
	Faction_SetPlayer(playerid, factionid, FactionInfo[factionid][fJoinRank]);
	FactionRequest[playerid] = 0;
	return 1;
}

CMD:f(playerid, params[])
{
	new text[256],
		faction = PlayerInfo[playerid][pFaction],
		rank = PlayerInfo[playerid][pRank];

	if(sscanf(params, "s[256]", text))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/f [texto]");
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "?Te encuentras silenciado!");
	if(FactionChannel[faction] == 1 && rank != 1)
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "El canal /f de tu facci?n se encuentra cerrado por el l?der.");
	if(PlayerInfo[playerid][pFaction] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No perteneces a ninguna facci?n.");
	if(!BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_FAC))
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tienes desactivado el chat OOC de la facci?n.");

	format(text, sizeof(text), "(( [%s] %s %s (ID %d): %s ))", FactionInfo[faction][fName], Faction_GetRankName(faction, rank), GetPlayerCleanName(playerid), playerid, text);
	foreach(new i : Player)
	{
 		if(PlayerInfo[i][pFaction] == faction && BitFlag_Get(p_toggle[i], FLAG_TOGGLE_FAC))
 		{
   			SendClientMessage(i, COLOR_FACTIONCHAT, text);
		}
		else if(IsAdminFactionEnabled(i))
		{
			SendClientMessage(i, COLOR_ADMINREAD, text);
		}
	}
	return 1;
}

PlayerHasRadio(playerid)
{
	if(isPlayerCopOnDuty(playerid) || isPlayerSideOnDuty(playerid)) {
		if (SearchHandsForItem(playerid, ITEM_ID_RADIO) == -1 && Container_SearchItem(PlayerInfo[playerid][pContainerID], ITEM_ID_RADIO) == -1 && Container_SearchItem(PlayerInfo[playerid][pBeltID], ITEM_ID_RADIO) == -1)
			return 0;
	} else {
		if (SearchHandsForItem(playerid, ITEM_ID_RADIO) == -1 && Container_SearchItem(PlayerInfo[playerid][pContainerID], ITEM_ID_RADIO) == -1)
			return 0;
	}

	return 1;
}

CMD:radio(playerid, params[]) {
	return cmd_r(playerid, params);
}

CMD:r(playerid, params[])
{
	new text[256],
	    string[256],
		factionID = PlayerInfo[playerid][pFaction];

	if(factionID == 0 || (PlayerInfo[playerid][pFaction] == FAC_PMA && PlayerInfo[playerid][pRank] == 10))
	    return 1;
	if(IsPlayerCracked(playerid))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "?No puedes hacerlo en este momento!");
	if(sscanf(params, "s[256]", text))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/r)adio [mensaje]");
	if(!PlayerHasRadio(playerid))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Debes tener una radio en alguna mano o en el inventario.");
	if(!BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_RADIO))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Tienes tu radio apagada.");
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "?no puedes usar la radio, te encuentras silenciado!");

	PlayerCmeMessage(playerid, 15.0, 4000, "Toma una radio de su bolsillo y habla por ella.");
	format(string, sizeof(string), "%s dice por radio: %s", GetPlayerChatName(playerid), text);
	SendPlayerMessageInRange(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, 0);
	if(GetPlayerState(playerid)!=PLAYER_STATE_ONFOOT && (PlayerInfo[playerid][pFaction]) == FAC_PMA)
		format(string, sizeof(string), "[M%d] [%d] [RADIO]: %s", GetPlayerVehicleID(playerid), playerid, text);
	else
	format(string, sizeof(string), "[%d] [RADIO]: %s", playerid, text);
	
	
	SendFactionRadioMessage(factionID, COLOR_RADIO, string);
	return 1;
}

CMD:d(playerid, params[]) {
	return cmd_departamento(playerid, params);
}

CMD:departamento(playerid, params[])
{
	new text[256],
		string[256],
		faction_id = PlayerInfo[playerid][pFaction];

	if(faction_id == 0 || (PlayerInfo[playerid][pFaction] == FAC_PMA && PlayerInfo[playerid][pRank] == 10))
	    return 1;
	if(IsPlayerCracked(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?No puedes hacerlo en este momento!");
	if(!Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_GOB_TYPE))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes permiso para hablar por esta frecuencia.");
	if(sscanf(params, "s[256]", text))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/d)epartamento [texto]");
	if(!PlayerHasRadio(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener una radio en alguna mano o en el inventario.");
	if(!BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_RADIO))
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tienes tu radio apagada.");
    if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, COLOR_YELLOW, "{FF4600}[Error]{C8C8C8} no puedes usar la radio, te encuentras silenciado.");

	PlayerCmeMessage(playerid, 15.0, 4000, "Toma una radio de su bolsillo y habla por ella.");
	format(string, sizeof(string), "%s dice por radio: %s", GetPlayerChatName(playerid), text);
	SendPlayerMessageInRange(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, 0);	
	format(string, sizeof(string), "[INTERDEPARTAMENTAL | %s] [%d]: %s", FactionInfo[faction_id][fName], playerid, text);
 	foreach(new i : Player)
 	{
		if(Faction_HasTag(PlayerInfo[i][pFaction], FAC_TAG_GOB_TYPE) && BitFlag_Get(p_toggle[i], FLAG_TOGGLE_RADIO))
		{
			if(PlayerHasRadio(i))
			{
				if((PlayerInfo[i][pFaction] == FAC_PMA && PlayerInfo[i][pRank] < 9) || PlayerInfo[i][pFaction] != FAC_PMA)
					SendClientMessage(i, COLOR_RADIOD, string);
			}
		}
  	}
	return 1;
}