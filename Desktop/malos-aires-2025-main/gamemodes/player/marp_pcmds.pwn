#if defined _marp_pcmds_included
	#endinput
#endif
#define _marp_pcmds_included

#include <YSI_Coding\y_hooks>

/******************************************************************************************/

enum e_FightingStylesDlgTable {
	e_fst_id,
	e_fst_name[10]
}

static const FightingStylesDlgTable[][e_FightingStylesDlgTable] = {
	{FIGHT_STYLE_NORMAL, "Normal\n"},
	{FIGHT_STYLE_BOXING, "Boxeo\n"},
	{FIGHT_STYLE_KUNGFU, "Kung Fu"}
};

static AutoFixCooldown[MAX_PLAYERS];

hook function OnPlayerResetStats(playerid)
{
	AutoFixCooldown[playerid] = 0;
	return continue(playerid);
}

CMD:aprender(playerid,params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 766.3723, 13.8237, 1000.7015))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en el gimnasio con el instructor.");

	new str_title[40], str_body[10 * sizeof(FightingStylesDlgTable)];

	format(str_title, sizeof(str_title), "Elige un estilo. Costo: $%i.", PRICE_FIGHTSTYLE);
	for(new i = 0, size = sizeof(FightingStylesDlgTable); i < size; i++) {
		strcat(str_body, FightingStylesDlgTable[i][e_fst_name]);
	}
	
	Dialog_Show(playerid, DLG_LEARN_FIGHTSTYLE , DIALOG_STYLE_LIST, str_title, str_body, "Aprender", "Cancelar");
	return 1;
}

Dialog:DLG_LEARN_FIGHTSTYLE(playerid, response, listitem, inputtext[])
{
	if(response) 
	{
		if(GetPlayerCash(playerid) < PRICE_FIGHTSTYLE) {
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero suficiente, necesitas $%i para pagar al instructor.", PRICE_FIGHTSTYLE);
			return 1;
		}

		SetPlayerFightingStyle(playerid, FightingStylesDlgTable[listitem][e_fst_id]);
		PlayerInfo[playerid][pFightStyle] = FightingStylesDlgTable[listitem][e_fst_id];
		GivePlayerCash(playerid, -PRICE_FIGHTSTYLE);
		SendFMessage(playerid, COLOR_WHITE, " ¡Felicitaciones! Has aprendido un nuevo estilo de pelea: %s.", FightingStylesDlgTable[listitem][e_fst_name]);
	}
	return 1;
}

/******************************************************************************************/

CMD:sacarveh(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid),
		target;

	if(sscanf(params, "u", target))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/sacarveh [ID/Jugador]");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser el conductor del vehículo.");
	if(vehicleid != GetPlayerVehicleID(target) || target == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Jugador inválido o no se encuentra en tu vehículo.");

	RemovePlayerFromVehicle(target);        		
	SendFMessage(playerid, COLOR_WHITE, "Has sacado a %s del vehículo.", GetPlayerCleanName(target));
	SendFMessage(target, COLOR_WHITE, "%s te ha sacado del vehículo.", GetPlayerCleanName(playerid));
	return 1;
}

/******************************************************************************************/

CMD:reglas(playerid, params[]) {
	Dialog_Show(playerid,DLG_RULES,DIALOG_STYLE_LIST,"Terminos RP","DeathMatch\nPowerGaming\nCarJacking\nMetaGaming\nRevengeKill\nBunnyHop\nVehicleKill\nZigZag\nHeliKill\nDriveBy\nOOC\nIC\n/ME\n/DO","Seleccionar","Cancelar");
	return 1;
}



Dialog:DLG_RULES(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	switch(listitem)
    {
        case 0: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - DM","DeathMatch:\nMatar a un jugador sin razon, sin motivo de rol.\nPegarle a alguien porque si.\nSi haces DM serás sancionado por un administrador.","Aceptar","Cancelar");
        case 1: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - PG","PowerGaming:\nHacer cosas que en la vida real no puedes hacer.\nEl PG es sancionado.","Aceptar","Cancelar");
        case 2: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - CJ","CarJacking:\nRobar un auto sin un rol previo.\nSubirse al auto de otro sin rolear el intento de robo.\n Si haces CJ serás sancionado por un administrador.","Aceptar","Cancelar");
        case 3: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - MG","MetaGaming:\nUsar informacion OOC dentro del rol (IC).\nEjemplo: Preguntar a un user donde esta por /w.\nLlamar a alguien por su nombre cuando IC no lo conocemos.\n El MG es sancionado.","Aceptar","Cancelar");
        case 4: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - RK","RevengeKill:\nVengarte de que te mataron matando al usuario que te mato.\nEsto no esta permitido ya que cuando mueres\npierdes la memoria.","Aceptar","Cancelar");
        case 5: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - BH","BunnyHop:\nSaltar abusivamente con el personaje o con la bicicleta.\nEsto no esta permitido y seras sancionado si lo haces.","Aceptar","Cancelar");
        case 6: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - VK","VehicleKill:\n Usar el auto para atropellar a un sujeto repetitivas veces hasta dejarlo desangrado o para matarlo.\nEsto no esta permitido y seras sancionado si lo haces.","Aceptar","Cancelar");
        case 7: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - ZZ","ZigZag:\nMoverte de un lado al otro para esquivar las balas.\nEs considerado PowerGaming.\nSeras sancionado si lo haces.","Aceptar","Cancelar");
        case 8: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - HK","HeliKill:\nUsar las haspas del helicoptero para matar a alguien.\nSi lo haces seras sancionado.","Aceptar","Cancelar");
        case 9: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - DB","DriveBy:\nDisparar estando como conductor de un auto o una moto.\nSi lo haces seras sancionado.","Aceptar","Cancelar");
        case 10: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - OOC","OutOfCharacter:\nSignifica afuera del personaje, cosas que no tienen nada que ver\ncon el rol de Malos Aires y de tu personaje.","Aceptar","Cancelar");
        case 11: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Terminos de RP - IC","InCharacter:\nSignifica dentro del personaje, cosas que tienen que ver con el rol de\nMalos Aires y el de tu personaje.","Aceptar","Cancelar");
        case 12: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Comandos - /ME","/ME:\nPara describir acciones de tu personaje. Por ejemplo:\n/me se rasca la cabeza.\n/me saca unos auriculares de su bolsillo.","Aceptar","Cancelar");
        case 13: Dialog_Show(playerid, DLG_RULESMSG, DIALOG_STYLE_MSGBOX, "Comandos - /DO","/DO:\nPara describir acciones del ambiente, en tercera persona. Por ejemplo:\n/do Se escucha a un gallo cacarear.\n/do Hay una mancha de sangre en el piso.","Aceptar","Cancelar");
	}

	return 1;
}

/******************************************************************************************/

new smoking[MAX_PLAYERS];

CMD:fumar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Solo puedes utilizarlo estando parado.");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
	if(smoking[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya estás fumando, utiliza /apagarcigarro para terminar.");
 	if(PlayerCuffed[playerid] == 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes fumar estando esposado.");

	new hand_cig = SearchHandsForItem(playerid, ITEM_ID_CIGARRILLOS),
	    hand_lig = SearchHandsForItem(playerid, ITEM_ID_ENCENDEDOR);

	if(hand_cig == -1 || hand_lig == -1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener en una mano un encendedor y en la otra los cigarrillos.");

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	PlayerActionMessage(playerid, 15.0, "saca un encendedor y un cigarrillo, lo enciende y comienza a fumar.");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Usa /apagarcigarro cuando quieras terminarlo.");
	smoking[playerid] = 1;
	
	if(GetHandParam(playerid, hand_cig) == 1)
	{
	    SetHandItemAndParam(playerid, hand_cig, 0, 0);
	    SendClientMessage(playerid, COLOR_WHITE, "Ese fue el último cigarrillo del paquete: se te han acabado.");
	}
	else
		SetHandItemAndParam(playerid, hand_cig, ITEM_ID_CIGARRILLOS, GetHandParam(playerid, hand_cig) - 1);

	if(GetHandParam(playerid, hand_lig) == 1)
	{
	    SetHandItemAndParam(playerid, hand_lig, 0, 0);
	    SendClientMessage(playerid, COLOR_WHITE, "El encendedor se ha quedado sin gas y ya no sirve.");
	}
	else
		SetHandItemAndParam(playerid, hand_lig, ITEM_ID_ENCENDEDOR, GetHandParam(playerid, hand_lig) - 1);
		
	return 1;
}

CMD:apagarcigarro(playerid, params[])
{
	if(!smoking[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar fumando...");

	if(PlayerInfo[playerid][pDisabled] == DISABLE_NONE && GetPlayerState(playerid) == 1)
	{
		if(GetPlayerInterior(playerid) > 0)
		{
		    PlayerActionMessage(playerid, 15.0, "apaga el cigarrillo y lo arroja al cenicero.");
		}
		else
		{
	 		PlayerActionMessage(playerid, 15.0, "apaga el cigarrillo y lo arroja al suelo.");
		}
		smoking[playerid] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	else
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
	}
	return 1;
}

CMD:id(playerid, params[]) {
	new search[24];

	if(sscanf(params, "s[24]", search))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/ID [ID/Nombre]");

	// Verificar si el parámetro es un número (ID)
	new tid = strval(search);
	if(tid != 0 || search[0] == '0') {
		// Búsqueda por ID específica
		if(!IsPlayerConnected(tid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no está conectado o la ID es inválida.");
		
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Nombre: %s (ID: %d).", GetPlayerCleanName(tid), tid);
		return 1;
	}

	// Búsqueda por nombre (parcial o completo)
	new matches = 0;
	
	foreach(new i : Player) {
		if(!IsPlayerConnected(i))
			continue;
			
		new playerName[MAX_PLAYER_NAME];
		GetPlayerName(i, playerName, sizeof(playerName));
		
		// Convertir ambos nombres a minúsculas para comparación case-insensitive
		new searchLower[24], nameLower[MAX_PLAYER_NAME];
		format(searchLower, sizeof(searchLower), "%s", search);
		format(nameLower, sizeof(nameLower), "%s", playerName);
		
		for(new j = 0; j < strlen(searchLower); j++) {
			if('A' <= searchLower[j] <= 'Z')
				searchLower[j] = searchLower[j] - ('A' - 'a');
		}
		for(new j = 0; j < strlen(nameLower); j++) {
			if('A' <= nameLower[j] <= 'Z')
				nameLower[j] = nameLower[j] - ('A' - 'a');
		}
		
		// Verificar si el nombre contiene la búsqueda
		if(strfind(nameLower, searchLower, true) != -1) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Nombre: %s (ID: %d)", GetPlayerCleanName(i), i);
			matches++;
		}
	}
	
	if(matches == 0) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontraron jugadores que coincidan con la búsqueda.");
	} else {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se encontraron %d resultado(s).", matches);
	}
	
	return 1;
}

CMD:changepass(playerid, params[]) 
{
	new passw[32];

	if(sscanf(params, "s[32]", passw) || !(8 <= strlen(passw) <= 16))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/changepass [nueva contraseña] (entre 8 y 16 carácteres).");
	if(Util_HasInvalidSQLCharacter(passw))
		return Util_PrintInvalidSQLCharacter(playerid);
		
	// If player has a master account, update it; otherwise update the character's account.
	new masterId = PlayerInfo[playerid][pMasterAccountId];
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `master_accounts` SET `password_hash`=MD5('%e') WHERE `id`=%i;", passw, masterId);
	SendClientMessage(playerid, COLOR_INFO, "[INFO]" COLOR_EMB_GREY" Has cambiado tu contraseña correctamente.");
	return 1;
}

CMD:mostrardoc(playerid, params[])
{
	new targetid;

    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mostrardoc [ID/Jugador]");
    if(!IsPlayerLogged(targetid) || !IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
        return SendClientMessage(playerid, COLOR_YELLOW2, "ID/Jugador inválido o demasiado lejos.");

	SendClientMessage(targetid, COLOR_WHITE, "______________________[ DOCUMENTO DE IDENTIDAD ]______________________");
 	SendFMessage(targetid, COLOR_WHITE, "Nombre: %s - Sexo: %s - Edad: %i", GetPlayerCleanName(playerid), (PlayerInfo[playerid][pSex]) ? ("Masculino") : ("Femenino"), PlayerInfo[playerid][pAge]);
	House_PrintPlayerAddress(playerid, targetid);
	SendClientMessage(targetid, COLOR_WHITE, "______________________________________________________________________");
	PlayerPlayerActionMessage(playerid, targetid, 15.0, "toma su documento del bolsillo y se lo muestra a");
	return 1;
}

CMD:conectados(playerid) {
	new FAC_POLICE_MEMBERS, FAC_SIDE_MEMBERS, FAC_HOSP_MEMBERS;
	
	foreach(new i : Player) {
		if(!IsPlayerLogged(i))
			continue;

		if(PlayerInfo[i][pFaction] == FAC_PMA) {
			FAC_POLICE_MEMBERS++;
		} else if(PlayerInfo[i][pFaction] == FAC_SIDE) {
			FAC_SIDE_MEMBERS++;
		} else if(PlayerInfo[i][pFaction] == FAC_HOSP) {
			FAC_HOSP_MEMBERS++;
		}
	}
	
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"[MIEMBROS] Policías: %i | Gendarmes: %i | Médicos: %i", FAC_POLICE_MEMBERS, FAC_SIDE_MEMBERS,FAC_HOSP_MEMBERS);

	return true;
}

CMD:mostrarced(playerid, params[])
{
	new targetid, vehicleid;

    if(sscanf(params, "ui", targetid, vehicleid))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mostrarced [ID/Jugador] [ID vehículo]");
    if(!IsPlayerLogged(targetid) || !IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
        return SendClientMessage(playerid, COLOR_YELLOW2, "Jugador inválido o demasiado lejos.");
	if(!Veh_IsValidId(vehicleid))
        return SendClientMessage(playerid, COLOR_YELLOW2, "vehículo inválido.");

	if(Veh_IsPlayerOwner(vehicleid, playerid))
	{
		SendClientMessage(targetid, COLOR_LIGHTGREEN, "================[Cédula Verde de Identificación del Automotor]===============");
		SendFMessage(targetid, COLOR_WHITE, "vehículo ID: %d", vehicleid);
	    SendFMessage(targetid, COLOR_WHITE, "Patente %s", VehicleInfo[vehicleid][VehPlate]);
	    SendFMessage(targetid, COLOR_WHITE, "Modelo %s", Veh_GetName(vehicleid));
	    SendFMessage(targetid, COLOR_WHITE, "Titular: %s", VehicleInfo[vehicleid][VehOwnerName]);
	    SendClientMessage(targetid, COLOR_WHITE, "Expedido por: Registro Nacional de la Propiedad del Automotor");
	    SendClientMessage(targetid, COLOR_LIGHTGREEN, "====================================================================");
	    PlayerPlayerActionMessage(playerid, targetid, 15.0, "toma una cédula verde del bolsillo y se la muestra a");
    }
    else if(KeyChain_Contains(playerid, KEY_TYPE_VEHICLE, vehicleid) ||
	    (VehicleInfo[vehicleid][VehType] == VEH_FACTION && PlayerInfo[playerid][pFaction] == VehicleInfo[vehicleid][VehFaction]) ||
	    (VehicleInfo[vehicleid][VehType] == VEH_RENT && PlayerInfo[playerid][pRentCarID] == vehicleid) )
	{
		SendClientMessage(targetid, COLOR_LIGHTBLUE, "================[Cédula Azul de Identificación del Automotor]===============");
        SendFMessage(targetid, COLOR_WHITE, "Nombre: %s", GetPlayerCleanName(playerid));
		SendFMessage(targetid, COLOR_WHITE, "vehículo ID: %d", vehicleid);
	    SendFMessage(targetid, COLOR_WHITE, "Patente %s", VehicleInfo[vehicleid][VehPlate]);
	    SendFMessage(targetid, COLOR_WHITE, "Modelo %s", Veh_GetName(vehicleid));
	    SendFMessage(targetid, COLOR_WHITE, "Titular: %s", VehicleInfo[vehicleid][VehOwnerName]);
	    SendClientMessage(targetid, COLOR_WHITE, "Expedido por: Registro Nacional de la Propiedad del Automotor");
	    SendClientMessage(targetid, COLOR_LIGHTBLUE, "===================================================================");
	    PlayerPlayerActionMessage(playerid, targetid, 15.0, "toma una cédula azul del bolsillo y se la muestra a");
    }
    else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes ninguna cédula de ese vehículo.");
    }
	return 1;
}

CMD:mostrarlic(playerid, params[])
{
	new targetid, lic[20];

    if(sscanf(params, "s[20]u", lic, targetid))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mostrarlic [Licencia] [ID/Jugador]. Licencias: conducir - vuelo - armas.");
    if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, COLOR_YELLOW2, "Jugador inválido.");
	if(!IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador se encuentra demasiado lejos.");

    if(strcmp(lic, "conducir", true) == 0)
    {
        if(!PlayerInfo[playerid][pCarLic])
            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una licencia de conducir.");
    	SendClientMessage(targetid, COLOR_LIGHTGREEN, "=======================[Licencia de Conducir]======================");
        SendFMessage(targetid, COLOR_WHITE, "Nombre: %s", GetPlayerCleanName(playerid));
       	SendFMessage(targetid, COLOR_WHITE, "Edad: %d", PlayerInfo[playerid][pAge]);
       	SendClientMessage(targetid, COLOR_WHITE, "Categoría: Original");
       	SendClientMessage(targetid, COLOR_WHITE, "Expedido por: Ministerio del Interior");
       	SendClientMessage(targetid, COLOR_LIGHTGREEN, "===============================================================");
       	PlayerPlayerActionMessage(playerid, targetid, 15.0, "toma su licencia de conducir del bolsillo y se la muestra a");
 	} 
	else if(strcmp(lic, "vuelo", true) == 0)
	{
		if(!PlayerInfo[playerid][pFlyLic])
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una licencia de vuelo.");
		SendClientMessage(targetid, COLOR_LIGHTGREEN, "========================[Licencia de Vuelo]========================");
		SendFMessage(targetid, COLOR_WHITE, "Nombre: %s", GetPlayerCleanName(playerid));
		SendFMessage(targetid, COLOR_WHITE, "Edad: %d", PlayerInfo[playerid][pAge]);
		SendClientMessage(targetid, COLOR_WHITE, "Expedido por: Dirección Nacional de Aeronáutica Civíl");
		SendClientMessage(targetid, COLOR_LIGHTGREEN, "===============================================================");
		PlayerPlayerActionMessage(playerid, targetid, 15.0, "toma su licencia de vuelo del bolsillo y se la muestra a");
	} 
	else if(strcmp(lic, "armas", true) == 0)
	{
		if(!PlayerInfo[playerid][pWepLic])
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una licencia de portación de armas.");
		SendClientMessage(targetid, COLOR_LIGHTGREEN, "==================[Licencia de portación de Armas]===================");
		SendFMessage(targetid, COLOR_WHITE, "Nombre: %s", GetPlayerCleanName(playerid));
		SendFMessage(targetid, COLOR_WHITE, "Edad: %d", PlayerInfo[playerid][pAge]);
		SendClientMessage(targetid, COLOR_WHITE, "Habilita: Pistola 9mm - Pistola Desert Eagle - Escopeta - Rifle de Caza");
		SendClientMessage(targetid, COLOR_WHITE, "Expedido por: Ministerio de Seguridad Pública");
		SendClientMessage(targetid, COLOR_LIGHTGREEN, "===============================================================");
		PlayerPlayerActionMessage(playerid, targetid, 15.0, "toma su licencia de portación de armas del bolsillo y se la muestra a");
	} else
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mostrarlic [Licencia] [ID/Jugador]. Licencias: conducir - vuelo - armas.");
	return 1;
}

/******************************************************************************************/


CMD:moneda(playerid, params[])
{
	new coin = random(2), str[128];

    if(GetPlayerCash(playerid) < 1)
        return SendClientMessage (playerid, COLOR_YELLOW2, " ¿como pretendes tirar una moneda si no tienes dinero?");

	if(!coin) {
		format(str, sizeof(str), "[Moneda] %s tiró una moneda y salió cruz.", GetPlayerChatName(playerid));
	} else {
		format(str, sizeof(str), "[Moneda] %s tiró una moneda y salió cara.", GetPlayerChatName(playerid));
	}
	SendPlayerMessageInRange(10.0, playerid, str, COLOR_DO1, COLOR_DO2, COLOR_DO3, COLOR_DO4, COLOR_DO5);
	return 1;
}

CMD:dado(playerid, params[])
{
	new dice = random(6) + 1, str[128];

    format(str, sizeof(str), "[Dado] %s lanzó un dado y salió el %i.", GetPlayerChatName(playerid), dice);
    SendPlayerMessageInRange(10.0, playerid, str, COLOR_DO1, COLOR_DO2, COLOR_DO3, COLOR_DO4, COLOR_DO5);
    return 1;
}

CMD:desbug(playerid, params[])
{
	if(PlayerInfo[playerid][pJailed] != JAIL_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes utilizar este comando ahora.");
	if(!GetPlayerVirtualWorld(playerid) && !GetPlayerInterior(playerid))
		 return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu virtual world e interior son correctos.");

	if(gettime() < AutoFixCooldown[playerid]) {
		
		new cooldownTime = AutoFixCooldown[playerid] - gettime();

		if(cooldownTime < 60) {
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar %i segundos para poder volver a usar este comando.", cooldownTime);
		} else {
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar %i minutos para poder volver a usar este comando.", cooldownTime / 60);
		}
		return 1;
	}

	new id, str[128];
	format(str, sizeof(str), "[INFO] "COLOR_EMB_GREY" Fuiste teletransportado a la salida del interior en el que te encuentras.");	

	if((id = House_IsPlayerInAny(playerid))) {
		TeleportPlayerTo(playerid, House[id][InsideX], House[id][InsideY], House[id][InsideZ], House[id][InsideAngle], House[id][InsideInterior], House[id][InsideWorld]);
	} else if((id = Biz_IsPlayerInsideAny(playerid))) {
		Biz_TpPlayerToInsideDoorId(playerid, id);
	} else if((id = Bld_IsPlayerInsideAny(playerid))) {
		Bld_TpPlayerToInsideDoorId(playerid, id);
	} else { 
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		format(str, sizeof(str), "[INFO] "COLOR_EMB_GREY" Interior y virtualworld corregidos.");
	}

	SendClientMessage (playerid, COLOR_INFO, str);
	format(str, sizeof(str), "[STAFF] El usuario %s (ID: %i) ha utilizado '/desbug'.", GetPlayerCleanName(playerid), playerid);
	AdministratorMessage(COLOR_ADMINCMD, str, 2);
	format(str, sizeof(str), "[INFO] "COLOR_EMB_GREY" El usuario %s (ID: %i) ha utilizado '/desbug'.", GetPlayerCleanName(playerid), playerid);
	SendPlayerMessageInRange(20, playerid, str, COLOR_INFO, COLOR_INFO, COLOR_INFO, COLOR_INFO, COLOR_INFO);
	AutoFixCooldown[playerid] = gettime() + 5 * 60;
	return 1;
}

