#if defined _marp_gob_included
	#endinput
#endif
#define _marp_gob_included

#include <YSI_Coding\y_hooks>


CMD:liberar(playerid, params[]) 
{
    new targetID;
	
	if(PlayerInfo[playerid][pFaction] != FAC_GOB)
        return 1;
    if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/liberar [ID/Jugador]");
    if(PlayerInfo[playerid][pRank] > 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu rango no tiene acceso a ese comando.");
	if(PlayerInfo[targetID][pJailed] != JAIL_IC_PMA && PlayerInfo[targetID][pJailed] != JAIL_IC_PRISON && PlayerInfo[targetID][pJailed] != JAIL_IC_GOB)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto no tiene ninguna condena.");
    
	PlayerInfo[targetID][pJailed] = JAIL_NONE;
	PlayerInfo[targetID][pJailTime] = 0;
    SendClientMessage(targetID, COLOR_LIGHTYELLOW2,"{878EE7}[Prisión]{C8C8C8} por orden de un juez quedas en libertad.");
    TeleportPlayerTo(targetID, POS_POLICE_FREEDOM_X, POS_POLICE_FREEDOM_Y, POS_POLICE_FREEDOM_Z, 270.0, 3, Bld_GetInDoorInt(2));
	TogglePlayerControllable(targetID, true);
	return 1;
}

CMD:verpresos(playerid, params[])
{
	new count = 0;
	
	if(PlayerInfo[playerid][pFaction] != FAC_GOB)
		return 1;
	if(PlayerInfo[playerid][pRank] > 4)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu rango no tiene acceso a ese comando.");
		
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "====================[PRESOS]===================");
	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pJailed] == JAIL_IC_PMA || PlayerInfo[i][pJailed] == JAIL_IC_PRISON || PlayerInfo[i][pJailed] == JAIL_IC_GOB)
		{
			SendClientMessage(playerid, COLOR_WHITE, GetPlayerCleanName(i));
			count++;
		}
	}
	if(count == 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "No hay ninguna persona presa actualmente");
	}
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "===============================================");
	return 1;
}

CMD:ppreventiva(playerid, params[])
{
    new targetID, str[128], string[128], reason[128];

    if(PlayerInfo[playerid][pFaction] != FAC_GOB)
        return 1;
    if(PlayerInfo[playerid][pRank] > 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu rango no tiene acceso a ese comando.");
    if(sscanf(params, "us[128]", targetID, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/ppreventiva [ID/Jugador] [razón (cargos que se le acusan)]");
   	if(targetID == INVALID_PLAYER_ID || targetID == playerid)
   	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido.");
	if(PlayerInfo[targetID][pJailed] != JAIL_NONE)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto tiene actualmente una condena.");
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, POS_POLICE_ARREST2_X, POS_POLICE_ARREST2_Y, POS_POLICE_ARREST2_Z))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en el pabellón de la cárcel!");
	if(!IsPlayerInRangeOfPlayer(5.0, playerid, targetID))
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡El sujeto debe estar cerca tuyo!");

	PlayerInfo[targetID][pJailed] = JAIL_IC_GOB;
    SendFMessage(targetID, COLOR_LIGHTYELLOW2,"{878EE7}[prisión]{C8C8C8} fuiste ingresado en prisión preventiva por el Juez %s", GetPlayerCleanName(playerid));
    SendClientMessage(targetID, COLOR_LIGHTYELLOW2,"{878EE7}INFO:{C8C8C8} La prisión preventiva no tiene un tiempo definido, tu situación depende de la decisión de un juez en un futuro.");
    SendFMessage(playerid, COLOR_LIGHTYELLOW2,"{878EE7}[INFO]{C8C8C8} Pusiste a %s en prisión preventiva. razón: %s", GetPlayerCleanName(targetID), reason);
	format(string, sizeof(string), "[Dpto. de policía] %s fue puesto en prisión preventiva por el Juez %s.", GetPlayerCleanName(targetID), GetPlayerCleanName(playerid));
	SendFactionMessage(FAC_PMA, COLOR_PMA, string);
 	format(str, sizeof(str), "[PREVENTIVA] %s", reason);
	AntecedentesLog(playerid, targetID, str);
	return 1;
}


CMD:gob(playerid, params[])
{
	cmd_gobierno(playerid, params);
	return 1;
}

CMD:gobierno(playerid, params[])
{
	new string[256];
	
	if(sscanf(params, "s[256]", string))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/gob)ierno [texto]");
	if(Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_GOB_TYPE) || PlayerInfo[playerid][pRank] > 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes permiso para hablar por esta frecuencia.");

	foreach(new i : Player)
	{
	    if(BitFlag_Get(p_toggle[i], FLAG_TOGGLE_NEWS)) {
			SendClientMessageToAll(COLOR_INFO, "[INFO] "COLOR_EMB_GREY"============================[Cadena Nacional]===========================");
			if(PlayerInfo[playerid][pFaction] == FAC_HOSP)
			{
				format(string, sizeof(string), "SAME: %s", string);
			}
			else if(PlayerInfo[playerid][pFaction] == FAC_PMA)
			{
				format(string, sizeof(string), "Policía Federal: %s", string);
			}
			else if(PlayerInfo[playerid][pFaction] == FAC_SIDE)
			{
				format(string, sizeof(string), "Gendarmeria: %s", string);
			}
			else if(PlayerInfo[playerid][pFaction] == FAC_GOB)
			{
				format(string, sizeof(string), "Gobierno de Malos Aires: %s", string);
			}
			SendClientMessageToAll(COLOR_YELLOW2, string);
			format(string, sizeof(string), "%s %s", Faction_GetRankName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pRank]), GetPlayerCleanName(playerid));
			SendClientMessageToAll(COLOR_YELLOW2, string);
			SendClientMessageToAll(COLOR_INFO, "[INFO] "COLOR_EMB_GREY"======================================================================");
			return 1;

	    }
	}
	return 1;

	
}

CMD:verconectados(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] != FAC_GOB)
	    return 1;
	if(PlayerInfo[playerid][pRank] > 3)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu rango no tiene acceso a ese comando.");
	
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pFaction] == FAC_PMA) {
			SendFMessage(playerid, COLOR_WHITE, "[%s] * (%s) %s", FactionInfo[FAC_PMA][fName], Faction_GetRankName(FAC_PMA, PlayerInfo[i][pRank]), GetPlayerCleanName(i));
		} else if(PlayerInfo[i][pFaction] == FAC_HOSP) {
			SendFMessage(playerid, COLOR_WHITE, "[%s] * (%s) %s", FactionInfo[FAC_HOSP][fName], Faction_GetRankName(FAC_HOSP, PlayerInfo[i][pRank]), GetPlayerCleanName(i));
		} else if(PlayerInfo[i][pFaction] == FAC_MECH) {
			SendFMessage(playerid, COLOR_WHITE, "[%s] * (%s) %s", FactionInfo[FAC_MECH][fName], Faction_GetRankName(FAC_MECH, PlayerInfo[i][pRank]), GetPlayerCleanName(i));
		}
	}
	return 1;
}
