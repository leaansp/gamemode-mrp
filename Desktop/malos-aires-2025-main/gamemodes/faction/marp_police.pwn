new VehCallSign[MAX_VEHICLES];
new Text3D:TextCallSign[MAX_VEHICLES];

#if defined _marp_police_included
	#endinput
#endif
#define _marp_police_included

#include <YSI_Coding\y_hooks>

#define POS_POLICE_ARREST_X		1203.45
#define POS_POLICE_ARREST_Y		2806.32
#define POS_POLICE_ARREST_Z		816.85  

#define POS_POLICE_ARREST2_X	1204.22 
#define POS_POLICE_ARREST2_Y	3214.12
#define POS_POLICE_ARREST2_Z	2412.72 

#define POS_POLICE_ARREST3_X	1199.8953
#define POS_POLICE_ARREST3_Y	2816.8643
#define POS_POLICE_ARREST3_Z	816.8492

#define POS_GEN_ARREST_X	1585.79
#define POS_GEN_ARREST_Y	2201.15
#define POS_GEN_ARREST_Z	1204.73

#define POS_POLICE_FREEDOM_X	-2790.29
#define POS_POLICE_FREEDOM_Y	3220.57
#define POS_POLICE_FREEDOM_Z	2412.72

#define POS_POLICE_FREEDOM2_X	2337.62
#define POS_POLICE_FREEDOM2_Y	-1375.99
#define POS_POLICE_FREEDOM2_Z	24.00

#define POS_GEN_FREEDOM_X	-275.45
#define POS_GEN_FREEDOM_Y	-2186.42
#define POS_GEN_FREEDOM_Z	28.75

#define POS_PRISON_FREEDOM_X	2690.64 
#define POS_PRISON_FREEDOM_Y	-2405.15
#define POS_PRISON_FREEDOM_Z	13.53

#define POLICE_ALIAS_MIN_RANK 5

new TempAlias[MAX_PLAYERS][MAX_PLAYER_NAME];
new bool:HasTempAlias[MAX_PLAYERS];
new OriginalName[MAX_PLAYERS][MAX_PLAYER_NAME];

new //Licencia de armas
	wepLicOffer[MAX_PLAYERS],
	// Camaras
	bool:usingCamera[MAX_PLAYERS],
	// Multa
	TicketOffer[MAX_PLAYERS],
	TicketMoney[MAX_PLAYERS],
	// Revision
	ReviseOffer[MAX_PLAYERS],
	//Alcoholemia
	BlowingPipette[MAX_PLAYERS],
    OfferingPipette[MAX_PLAYERS],
    // Rastreo llamada
    lastPoliceCallNumber = 0,
	Float:lastPoliceCallPos[3],
	lastMedicCallNumber = 0,
	DOEM,
	Float:lastMedicCallPos[3];

forward ApplyTemporaryName(playerid, const newname[]);

CMD:multar(playerid, params[]) {
    new reason[64], cost, targetid;

  	if(PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_SIDE || PlayerInfo[playerid][pRank] == 10)
	  	return true;
	if(sscanf(params, "uds[64]", targetid, cost, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/multar [ID/Nombre] [costo] [razón]");
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio como oficial de policía!");
	if(!IsPlayerInRangeOfPlayer(3.0, playerid, targetid) || targetid == playerid)
		return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador o está muy lejos!");
	if(cost > 50000 || cost < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El costo no puede ser menor a $1 ni sobrepasar los $50.000!");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has multado a %s por $%d - razón: %s.", GetPlayerCleanName(targetid), cost, reason);
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s te ha multado por $%d - razón: %s.", GetPlayerCleanName(playerid), cost, reason);
	SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Escribe /aceptar multa, para pagar.");
	TicketOffer[targetid] = playerid;
	TicketMoney[targetid] = cost;
  	return true;
}

hook function OnPlayerCmdAccept(playerid, const subcmd[]) {
	if(!strcmp(subcmd, "multa", true))
	{
		if(TicketOffer[playerid] >= 999)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes ninguna multa!");
		if(!IsPlayerConnected(TicketOffer[playerid]))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El oficial que te multó se ha desconectado.");
		if(!IsPlayerInRangeOfPlayer(3.0, playerid, TicketOffer[playerid]))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar cerca del oficial que te ha multado!");

		new string[128];
		format(string, sizeof(string), "[INFO] {C8C8C8}%s ha aceptado tu multa. Espera a que elija una forma de pago.", GetPlayerCleanName(playerid));
		SendClientMessage(TicketOffer[playerid], COLOR_INFO, string);
		format(string, sizeof(string), "Aceptaste la multa de %s por %d.\nSeleciona la forma de pago:", GetPlayerCleanName(TicketOffer[playerid]), TicketMoney[playerid]);
		Dialog_Show(playerid, DLG_POLICE_FINE, DIALOG_STYLE_MSGBOX, "Te han multado", string, "Efectivo", "Tarjeta");
		return true;
	}

	if(!strcmp(subcmd, "revision", true))
	{
		new idToShow = ReviseOffer[playerid];
		
		if(idToShow == 999)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te quiere revisar.");
		if(!IsPlayerConnected(idToShow))
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto se ha desconectado.");
		if(!IsPlayerInRangeOfPlayer(2.0, idToShow, playerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto no está cerca tuyo.");
		
		PrintHandsForPlayer(playerid, idToShow);
		PrintInvForPlayer(playerid, idToShow);
		PrintToysForPlayer(playerid, idToShow);
		Back_PrintHandsForPlayer(playerid, idToShow);
		Holster_PrintForPlayer(playerid, idToShow);
		PlayerPlayerActionMessage(idToShow, playerid, 15.0, "ha revisado en busca de objetos a");
		ReviseOffer[playerid] = 999;
		return true;
	}

	if(!strcmp(subcmd, "licencia", true))
	{
		new offer = wepLicOffer[playerid];
	
		if(offer == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ha ofrecido una licencia de armas.");
		if(!IsPlayerConnected(offer)) {
			wepLicOffer[playerid] = INVALID_PLAYER_ID;
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador se ha desconectado.");
		}
		if(!IsPlayerInRangeOfPlayer(4.0, playerid, offer))
			return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador o está muy lejos!");
		if(GetPlayerCash(playerid) < PRICE_LIC_GUN) {
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No cuentas con el dinero suficiente ($%d).", PRICE_LIC_GUN);
			return true;
		}

		GivePlayerCash(playerid, -PRICE_LIC_GUN);
		PlayerInfo[playerid][pWepLic] = 1;
		Faction_GiveMoney(FAC_GOB, PRICE_LIC_GUN);
		wepLicOffer[playerid] = INVALID_PLAYER_ID;
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Felicidades! has conseguido una licencia de armas. Ahora puedes comprar un arma en cualquier armería.");
		SendFMessage(offer, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Le has dado una licencia de armas a %s por %d. El dinero se recaudará para el fondo de facción.", GetPlayerCleanName(playerid), PRICE_LIC_GUN);
		return true;
	}

	if(!strcmp(subcmd, "pipeta", true))
	{
		if(BlowingPipette[playerid] == 0)
			return SendClientMessage(playerid,COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ningún oficial te está ofreciendo una pipeta para soplar.");
		if(!IsPlayerInRangeOfPlayer(2.0, playerid, GetPVarInt(playerid, "OfertaPipeta")))
			return SendClientMessage(playerid,COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Estás demasiado lejos del oficial que te ofreció la pipeta.");
			
		BlowingPipette[playerid] = 0;
		PlayerCmeMessage(playerid, 15.0, 5000, "Toma la pipeta ofrecida por el oficial y comienza a soplarla");
		SetTimerEx("SoplandoPipeta", 6000, false, "i", playerid);
		TogglePlayerControllable(playerid, false);
		SetTimerEx("Unfreeze", 6000, false, "i", playerid);
		return true;
	}

	if(!strcmp(subcmd, "policia", true))
	{
		if(GetPVarInt(GetPVarInt(playerid, "reanimIssuer"), "isReanimating") == 1)
		{
			new officer = GetPVarInt(playerid, "reanimIssuer");
			if(officer == playerid)
			{
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes aceptarte tu propia reanimación.");
				SetPVarInt(officer, "isReanimating", 0);
				return true;
			}
			
			// Verificar que el oficial todavía tenga el botiquín
			new hand = SearchHandsForItem(officer, ITEM_ID_MEDIC_CASE);
			if(hand == -1 || GetHandParam(officer, hand) <= 0)
			{
				SendClientMessage(officer, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya no tienes el botiquín de primeros auxilios para realizar la reanimación!");
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El oficial ya no tiene su botiquín disponible!");
				SetPVarInt(officer, "isReanimating", 0);
				return true;
			}
			
			// Verificar nuevamente que NO haya médicos
			if(CountMedicsOnDuty() > 0)
			{
				SendClientMessage(officer, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Un médico ha entrado en servicio! No puedes continuar con la reanimación.");
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Un médico ha entrado en servicio! Debes llamar al hospital.");
				SetPVarInt(officer, "isReanimating", 0);
				SetPVarInt(officer, "reanimTarget", INVALID_PLAYER_ID);
				SetPVarInt(playerid, "reanimIssuer", INVALID_PLAYER_ID);
				return true;
			}
			
			// Iniciar proceso de reanimación con animación
			new reanimate_time = 8; // 8 segundos de reanimación
			
			SendFMessage(officer, COLOR_LIGHTGREEN, "Comenzando reanimación de emergencia (%ds)...", reanimate_time);
			SendFMessage(playerid, COLOR_LIGHTGREEN, "El oficial %s ha comenzado la reanimación (%ds)...", GetPlayerCleanName(officer), reanimate_time);
			
			// Aplicar animación y bloquear controles
			ApplyAnimationEx(officer, "MEDIC", "CPR", 4.1, 1, 0, 0, 0, reanimate_time * 1000, 1, false);
			ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, reanimate_time * 1000, 1, false);
			TogglePlayerControllable(officer, false);
			TogglePlayerControllable(playerid, false);
			
			// Cancelar timer de oferta y guardar timer de reanimación
			new offer_timer = GetPVarInt(officer, "reanimOfferTimerId");
			if(offer_timer != 0) {
				KillTimer(offer_timer);
				SetPVarInt(officer, "reanimOfferTimerId", 0);
			}
			
			new timerid = SetTimerEx("Police_FinishReanim", reanimate_time * 1000, false, "i", playerid);
			SetPVarInt(officer, "reanimTimerId", timerid);
			SendClientMessage(officer, COLOR_GREY, "[INFO] Presiona la tecla de disparo para cancelar.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ningún oficial te ha ofrecido reanimación!");
		}
		return true;
	}

	return continue(playerid, subcmd);
}

Dialog:DLG_POLICE_FINE(playerid, response, listitem, inputtext[]) {
	new str[128];

    if(TicketOffer[playerid] >= 999)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes ninguna multa!");
	if(!IsPlayerConnected(TicketOffer[playerid]))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El oficial que te multó se ha desconectado.");

    if(response)
    {
		if(GetPlayerCash(playerid) < TicketMoney[playerid])
		{
			SendClientMessage(TicketOffer[playerid], COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El sujeto decidió pagar en efectivo, pero no tiene el dinero suficiente.");
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes el dinero en efectivo suficiente!");
			return true;
		}

		format(str, sizeof(str), "{878EE7}[INFO]{C8C8C8} %s ha pagado tu multa con efectivo - costo: $%d.", GetPlayerCleanName(playerid), TicketMoney[playerid]);
		GivePlayerCash(playerid, -TicketMoney[playerid]);
	}
	else
	{
		if(PlayerInfo[playerid][pBank] < TicketMoney[playerid])
		{
			SendClientMessage(TicketOffer[playerid], COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El sujeto decidió pagar por transferencia bancaria, pero no tiene dinero suficiente en su cuenta.");
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes el dinero suficiente en tu cuenta bancaria!");
			return true;
		}

		PlayerInfo[playerid][pBank] -= TicketMoney[playerid];
		format(str, sizeof(str), "{878EE7}[INFO]{C8C8C8} %s ha pagado tu multa por transferencia bancaria - costo: $%d.", GetPlayerCleanName(playerid), TicketMoney[playerid]);
	}

    SendClientMessage(TicketOffer[playerid], COLOR_INFO, str);
	format(str, sizeof(str), "{878EE7}[INFO]{C8C8C8} Multa pagada - costo: $%d.", TicketMoney[playerid]);
	SendClientMessage(playerid, COLOR_INFO, str);
	Faction_GiveMoney(FAC_GOB, TicketMoney[playerid]);
	TicketOffer[playerid] = 999;
	TicketMoney[playerid] = 0;
	return true;
}

CMD:quitar(playerid, params[]) {
	new itemString[64],
		targetID;

  	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
	  	return true;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
	if(sscanf(params, "us[64]", targetID, itemString))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/quitar [ID/Nombre] [ítem]");
		return SendClientMessage(playerid, COLOR_USAGE, "[ítems] "COLOR_EMB_GREY"licconducir, licvuelo, licarmas.");
  	}
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");
	if(PlayerInfo[playerid][pFaction] == FAC_SIDE && PlayerInfo[playerid][pRank] > 7)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes revocar licencias con tu rango!");
	if(!IsPlayerInRangeOfPlayer(2.0, playerid, targetID))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El objetivo se encuentra demasiado lejos!");
	if(targetID == INVALID_PLAYER_ID)
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de jugador incorrecta.");
	if(targetID == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No te puedes revocar un ítem a tí mismo!");
		
	if(strcmp(itemString, "licconducir", true) == 0)
	{
		if(PlayerInfo[targetID][pCarLic] == 0)
  			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El sujeto no tiene una licencia de conducir!");
		PlayerPlayerActionMessage(playerid, targetID, 15.0, "le ha quitado la licencia de conducir a");
		PlayerInfo[targetID][pCarLic] = 0;
	}
	else if(strcmp(itemString, "licvuelo", true) == 0)
	{
 		if(PlayerInfo[targetID][pFlyLic] == 0)
   			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El sujeto no tiene una licencia de vuelo!");
		PlayerPlayerActionMessage(playerid, targetID, 10.0, "le ha quitado la licencia de vuelo a");
 		PlayerInfo[targetID][pFlyLic] = 0;
	}
	else if(strcmp(itemString, "licarmas", true) == 0)
	{
 		if(PlayerInfo[targetID][pWepLic] == 0)
    		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El sujeto no tiene una licencia de portación de armas!");
		PlayerPlayerActionMessage(playerid, targetID, 10.0, "le ha quitado la licencia de armas a");
		PlayerInfo[targetID][pWepLic] = 0;
	}
	else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Parámetro inválido.");
	}
	return true;
}

CMD:revisar(playerid, params[]) {
	new targetID;

	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/revisar [ID/Nombre]");
	if(!IsPlayerConnected(targetID) || targetID == INVALID_PLAYER_ID || targetID == playerid || !IsPlayerInRangeOfPlayer(2.0, playerid, targetID))
	    return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador o está muy lejos!");

	if(isPlayerCopOnDuty(playerid) || isPlayerSideOnDuty(playerid) || PlayerInfo[targetID][pDisabled] == DISABLE_DYING ||PlayerInfo[targetID][pDisabled] == DISABLE_DEATHBED)
	{
		PrintHandsForPlayer(targetID, playerid);
		PrintInvForPlayer(targetID, playerid);
	  	PrintToysForPlayer(targetID, playerid);
	  	Back_PrintHandsForPlayer(targetID, playerid);
		Holster_PrintForPlayer(targetID, playerid);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Dinero en mano: $%i.", GetPlayerCash(targetID));
		PlayerPlayerActionMessage(playerid, targetID, 15.0, "ha revisado en busca de objetos a");
	}
	else
    {
        SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Quieres revisar a %s en busca de objetos. Para evitar abusos, debés esperar su respuesta.", GetPlayerCleanName(targetID));
		SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s quiere revisarte en busca de objetos. Para evitar abusos, tienes que usar /aceptar revision.", GetPlayerCleanName(playerid));
		ReviseOffer[targetID] = playerid;
	}
	return true;
}

CMD:buscados(playerid) {
    new count = 0;

	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
		return true;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");

	SendClientMessage(playerid, COLOR_LIGHTGREEN, "-----------[Sospechosos buscados]-----------");
    foreach(new i : Player)	{
	    if(PlayerInfo[i][pWantedLevel] >= 1) {
	        SendFMessage(playerid, COLOR_WHITE, "[BUSCADOS] %s (ID:%d) -  nivel de búsqueda: %d.", GetPlayerCleanName(i), i, PlayerInfo[i][pWantedLevel]);
			count++;
		}
	}
	if(count == 0)
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay criminales buscados on-line.");
	SendClientMessage(playerid, COLOR_INFO, "------------------------------------------------");
	return true;
}

CMD:esposar(playerid, params[]) {
	new targetID;

 	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
 		return true;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/esposar [ID/Nombre]");
  	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
  		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");
	if(targetID == INVALID_PLAYER_ID)
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de jugador incorrecta.");
 	if(PlayerCuffed[targetID] == 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El objetivo ya se encuentra esposado!");
	if(!IsPlayerInRangeOfPlayer(1.0, playerid, targetID))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El objetivo se encuentra demasiado lejos!");
	if(targetID == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes esposarte a tí mismo!");

	SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Has sido esposado por %s!", GetPlayerCleanName(playerid));
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Has esposado a %s!", GetPlayerCleanName(targetID));
	PlayerPlayerActionMessage(playerid, targetID, 15.0, "ha esposado a");
	SetPlayerSpecialAction(targetID, SPECIAL_ACTION_CUFFED);
	SetPlayerAttachedObject(targetID, ATTACH_INDEX_ID_HANDCUFFS, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);
	PlayerCuffed[targetID] = 1;
	return true;
}

CMD:arrastrar(playerid, params[]) {
	new targetid, vehicleid, seat;

	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
		return true;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
	if(sscanf(params, "ui", targetid, seat))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/arrastrar [ID/Nombre] [1/2/3]");
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");
	if(seat < 1 || seat > 3)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo son validos los asientos 1, 2 y 3.");

	if(IsPlayerInAnyVehicle(playerid))
		vehicleid = GetPlayerVehicleID(playerid);
	else
 		vehicleid = GetClosestVehicle(playerid, 4.0);

	if(vehicleid == INVALID_VEHICLE_ID || targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Vehículo o jugador incorrecto.");
	if(VehicleInfo[vehicleid][VehFaction] != FAC_PMA && VehicleInfo[vehicleid][VehFaction] != FAC_SIDE)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vehículo no pertenece a tu facción.");
	if(!IsPlayerInRangeOfPlayer(2.5, playerid, targetid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador se encuentra demasiado lejos.");

 	PutPlayerInVehicle(targetid, vehicleid, seat);
	return true;
}

CMD:ariete(playerid, params[]) {
	new houseid;

	if(PlayerInfo[playerid][pFaction] != FAC_PMA)
		return true;
	if(PlayerInfo[playerid][pRank] < 1 || PlayerInfo[playerid][pRank] > 4)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo rangos 1 a 4 pueden usar el ariete.");
	if(CopDuty[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en servicio!");

	houseid = House_IsPlayerAtAnyDoorAny(playerid);

	if(houseid)
	{
		House[houseid][Locked] = 0;
		LockerStatus[houseid] = 1;
		PlayerActionMessage(playerid, 15.0, "toma el ariete y golpea la puerta hasta forzarla.");
		ApplyAnimationEx(playerid, "POLICE", "Door_Kick", 4.1, 0, 0, 0, 0, 0, 1);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Forzaste la puerta y el armario de esta casa.");
		ServerFormattedLog(LOG_TYPE_ID_ADMIN, .id=houseid, .entry="/ariete", .playerid=playerid, .params=<"Puerta+Armario Casa:%d", houseid>);
		return true;
	}

	houseid = House_IsPlayerInAny(playerid);

	if(houseid)
	{
		LockerStatus[houseid] = 1;
		PlayerActionMessage(playerid, 15.0, "toma el ariete y rompe el candado del armario.");
		ApplyAnimationEx(playerid, "POLICE", "Door_Kick", 4.1, 0, 0, 0, 0, 0, 1);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Forzaste el armario de esta casa.");
		ServerFormattedLog(LOG_TYPE_ID_ADMIN, .id=houseid, .entry="/ariete", .playerid=playerid, .params=<"Armario Casa:%d", houseid>);
		return true;
	}

	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en la puerta o dentro de una casa para usar el ariete.");
}

CMD:quitaresposas(playerid, params[]) {
	new targetID;

	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
		return true;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");
	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/quitaresposas [ID/Nombre]");
	if(targetID == INVALID_PLAYER_ID)
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de jugador incorrecta.");
	if(PlayerCuffed[targetID] == 0)
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El objetivo no está esposado!");
	if(!IsPlayerInRangeOfPlayer(1.0, playerid, targetID))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El objetivo se encuentra demasiado lejos!");
	if(targetID == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes quitarte las esposas a tí mismo!");

	SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡%s te ha quitado las esposas!", GetPlayerCleanName(playerid));
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Le has quitado las esposas a %s!", GetPlayerCleanName(targetID));
	PlayerPlayerActionMessage(playerid, targetID, 15.0, "le ha quitado las esposas a");
	SetPlayerSpecialAction(targetID, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(targetID, ATTACH_INDEX_ID_HANDCUFFS);
	PlayerCuffed[targetID] = 0;
	return true;
}

CMD:arrestar(playerid, params[]) {
	new	targetID,
		time,
		fine,
		string[256],
		reason[128];

	if(PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_SIDE || PlayerInfo[playerid][pRank] == 10)
		return true;
	if(sscanf(params, "uiis[128]", targetID, time, fine, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/arrestar [ID/Nombre] [tiempo] [multa (0=nada)] [razón]");
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");
	if(time < 1 || time > 700)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El tiempo no puede ser menor a 1 minuto ni mayor a 700!");
	if(fine < 0 || fine > 50000)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡La multa no puede ser negativa ni mayor a $50.000!");
	if(!IsPlayerInRangeOfPlayer(5.0, playerid, targetID))
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El sujeto debe estar cerca tuyo!");

	if(IsPlayerInRangeOfPoint(playerid, 25.0, POS_POLICE_ARREST2_X, POS_POLICE_ARREST2_Y, POS_POLICE_ARREST2_Z)) {
		PlayerInfo[targetID][pJailed] = JAIL_IC_PRISON;
	} else if(IsPlayerInRangeOfPoint(playerid, 15.0, POS_POLICE_ARREST_X, POS_POLICE_ARREST_Y, POS_POLICE_ARREST_Z)) {
		PlayerInfo[targetID][pJailed] = JAIL_IC_PMA;
	} else if(IsPlayerInRangeOfPoint(playerid, 25.0, POS_POLICE_ARREST3_X, POS_POLICE_ARREST3_Y, POS_POLICE_ARREST3_Z)) {
		PlayerInfo[targetID][pJailed] = JAIL_IC_PMA_EAST;
	} else if(IsPlayerInRangeOfPoint(playerid, 25.0, POS_GEN_ARREST_X, POS_GEN_ARREST_Y, POS_GEN_ARREST_Z)) {
		PlayerInfo[targetID][pJailed] = JAIL_IC_GEN;
	} else {
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar junto a las celdas!");
	}

	PlayerInfo[targetID][pJailTime] = time * 60;
	
	// Aplicar multa si es mayor a 0
	if(fine > 0)
	{
		new victimCash = GetPlayerCash(targetID);
		if(victimCash >= fine)
		{
			GivePlayerCash(targetID, -fine);
			SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se te ha cobrado una multa de $%d en efectivo.", fine);
		}
		else if(victimCash > 0)
		{
			new cashPaid = victimCash;
			new bankDebit = fine - victimCash;
			GivePlayerCash(targetID, -cashPaid);
			
			if(PlayerInfo[targetID][pBank] >= bankDebit)
			{
				PlayerInfo[targetID][pBank] -= bankDebit;
				SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se te ha cobrado una multa de $%d ($%d efectivo + $%d de tu cuenta).", fine, cashPaid, bankDebit);
			}
			else if(PlayerInfo[targetID][pBank] > 0)
			{
				new totalPaid = cashPaid + PlayerInfo[targetID][pBank];
				PlayerInfo[targetID][pBank] = 0;
				SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se te ha cobrado una multa parcial de $%d de $%d (fondos insuficientes).", totalPaid, fine);
			}
			else
			{
				SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se te ha cobrado una multa parcial de $%d de $%d (fondos insuficientes).", cashPaid, fine);
			}
		}
		else
		{
			if(PlayerInfo[targetID][pBank] >= fine)
			{
				PlayerInfo[targetID][pBank] -= fine;
				SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se te ha cobrado una multa de $%d de tu cuenta bancaria.", fine);
			}
			else if(PlayerInfo[targetID][pBank] > 0)
			{
				new totalPaid = PlayerInfo[targetID][pBank];
				PlayerInfo[targetID][pBank] = 0;
				SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se te ha cobrado una multa parcial de $%d de $%d (fondos insuficientes).", totalPaid, fine);
			}
			else
			{
				SendClientMessage(targetID, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes fondos para pagar la multa de $" #fine ".");
			}
		}
		
		Faction_GiveMoney(FAC_GOB, fine);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Arrestaste a %s durante %i minutos con una multa de $%d.", GetPlayerCleanName(targetID), time, fine);
	}
	else
	{
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Arrestaste a %s durante %i minutos.", GetPlayerCleanName(targetID), time);
	}
	
	SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Fuiste arrestado durante %i minutos bajo el cargo de %s.", time, reason);
	SendClientMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Al estar arrestado no pasará el tiempo para volver a trabajar hasta el proximo día de pago en libertad.");

	if(fine > 0)
		format(string, sizeof(string), "[CENTRAL] %s ha arrestado al criminal %s con multa de $%d. razón: %s", GetPlayerCleanName(playerid), GetPlayerCleanName(targetID), fine, reason);
	else
		format(string, sizeof(string), "[CENTRAL] %s ha arrestado al criminal %s. razón: %s", GetPlayerCleanName(playerid), GetPlayerCleanName(targetID), reason);
	
	SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_PMA, string);

	ResetPlayerWantedLevelEx(targetID);
	Faction_GiveMoney(FAC_GOB, PlayerInfo[targetID][pJailTime]);
	AntecedentesLog(playerid, targetID, reason);
	SaveFaction(FAC_GOB);
	return true;
}

CMD:central(playerid, params[]) {
	if(PlayerInfo[playerid][pFaction] != FAC_PMA || PlayerInfo[playerid][pRank] == 10)
		return true;

	new inputtext[128];

	if(sscanf(params, "s[128]", inputtext))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/central [texto]");

	new outputtext[160];
	format(outputtext, sizeof(outputtext), "[%i] [CENTRAL]: %s ", playerid, inputtext);
	SendFactionRadioMessage(FAC_PMA, COLOR_RADIO, outputtext);
	return true;
}

CMD:m(playerid, params[]) {
	return cmd_megafono(playerid, params);
}

CMD:megafono(playerid, params[]) {
	new text[256],
		factionID = PlayerInfo[playerid][pFaction];

	if(sscanf(params, "s[256]", text))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/(m)egáfono [texto]");
	if((factionID != FAC_PMA || CopDuty[playerid] != 1) && (factionID != FAC_SIDE || SIDEDuty[playerid] != 1))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes un megáfono o no te encuentras en servicio.");
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
	if(!IsPlayerInAnyVehicle(playerid) || VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != factionID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en un vehículo con megáfono!");
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes usar el megáfono, te encuentras silenciado.");

	format(text, sizeof(text), "[Megáfono] [ID: %d]:  ¡%s!", playerid, text);
	SendPlayerMessageInRange(60.0, playerid, text, COLOR_PMA, COLOR_PMA, COLOR_PMA, COLOR_PMA, COLOR_PMA);
	return true;
}

CMD:pservicio(playerid, params[]) {
	if(PlayerInfo[playerid][pFaction] != FAC_PMA || PlayerInfo[playerid][pRank] == 10)
		return true;

	new string[128];

	if(CopDuty[playerid] == 0)
	{
		CopDuty[playerid] = 1;
		format(string, sizeof(string), "[CENTRAL] %s inicia su día de servicio como oficial de policía.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_PMA, COLOR_PMA, string);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ahora te encuentras en servicio.");
	}
	else
	{
		format(string, sizeof(string), "[CENTRAL] %s termina su día de servicio como oficial de policía.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_PMA, COLOR_PMA, string);
		EndPlayerDuty(playerid);
	}
	return true;
}

CMD:premolcar(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);
	new targetVehicleid = GetClosestVehicle(playerid, 7.0);
	if(PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_SIDE)
		return true;
	if(targetVehicleid == INVALID_VEHICLE_ID)
	    return true;
	if(GetVehicleModel(vehicleid) != 525 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Tienes que estar conduciendo una grúa!");
	if(IsTrailerAttachedToVehicle(vehicleid)) 
	{
		return DetachTrailerFromVehicle(vehicleid);
	}
	AttachTrailerToVehicle(targetVehicleid, vehicleid);
	return true;
}

CMD:sosp(playerid, params[]) {
	return cmd_sospechoso(playerid, params);
}

CMD:sospechoso(playerid, params[]) {
	new string[128], reason[64], targetID;

  	if(PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_SIDE)
	  	return true;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_SIDE)
		return true;
	if(sscanf(params, "us[64]", targetID, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/(sosp)echoso [ID/Nombre] [crímen]");
	if(!IsPlayerLogged(targetID) || targetID == playerid)
   		return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador!");
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");

	SetPlayerWantedLevelEx(targetID, PlayerInfo[targetID][pWantedLevel] + 1);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has marcado a %s como sospechoso por: %s.", GetPlayerCleanName(targetID), reason);
	format(string, sizeof(string), "[CENTRAL] %s ha marcado a %s como sospechoso por: %s.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetID), reason);
	SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_PMA, string);
	PlayerInfo[targetID][pAccusedOf][0] = EOS;
	strcat(PlayerInfo[targetID][pAccusedOf], reason, 64);
	PlayerInfo[targetID][pAccusedBy] = GetPlayerCleanName(playerid);
	return true;
}

CMD:localizar(playerid,params[]) {
	static CopTraceCooldown[MAX_PLAYERS];

    new vehid;

	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
		return true;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
	if(sscanf(params, "i", vehid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/localizar [ID vehículo]");
   	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");
	if(PlayerInfo[playerid][pFaction] == FAC_PMA)
	{
		if(VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_PMA && GetPlayerVirtualWorld(playerid) != BUILDING_VW_OFFSET + BLD_PMA)
	 	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en la comisaría o dentro de una patrulla.");
	}
	if(gettime() < CopTraceCooldown[playerid])
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés esperar 20 segundos antes de usar nuevamente el comando.");
	if(!Veh_IsValidId(vehid) || VehicleInfo[vehid][VehFaction] != PlayerInfo[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo inválida o no disponible para rastreo (debe ser de tu facción).");

	new Float:x, Float:y, Float:z, string[128], area[MAX_ZONE_NAME];

	GetVehiclePos(vehid, x, y, z);
	GetCoords2DZone(x, y, area, MAX_ZONE_NAME);

	MapMarker_CreateForPlayer(playerid, x, y, z, COLOR_RED, .time = 120000);
	Noti_Create(playerid, .time = 3000, .text = "Localizas la ubicación precisa del móvil mediante rastreo satelital. Se marcará en tu GPS durante 2 minutos");

	format(string, sizeof(string),"[CENTRAL] %s ha rastreado el móvil %i en la zona de %s.", GetPlayerCleanName(playerid), vehid, area);
	SendFactionMessage((PlayerInfo[playerid][pFaction] == FAC_SIDE) ? (FAC_SIDE) : (FAC_PMA), COLOR_PMA, string);

	CopTraceCooldown[playerid] = gettime() + 20;
	return true;
}

CMD:pipeta(playerid,params[]) {
    new targetid;
	 
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA && PlayerInfo[playerid][pFaction] == FAC_SIDE)
		return true;
	if(sscanf(params, "u", targetid))
   		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/pipeta [ID/Nombre]");
    if(PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_SIDE)
		return true;
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");
	if(OfferingPipette[playerid] == 1)
	    return SendClientMessage(playerid,COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya has ofrecido una pipeta para que soplen.");
 	if(!IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡El sujeto debe estar cerca tuyo!");

	SendFMessage (playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Le diste una pipeta para que sople a %s, debés esperar que el sujeto responda.", GetPlayerCleanName(targetid));
    SendFMessage (targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s te dió una pipeta de alcoholemia para que soples. (Utiliza /aceptar pipeta)", GetPlayerCleanName(playerid));
	BlowingPipette[targetid] = 1;
	OfferingPipette[playerid] = 1;
    SetPVarInt(targetid, "OfertaPipeta", playerid);
	SetTimerEx("AceptarPipeta", 20000, false, "i", playerid);
	return true;
}

public AceptarPipeta(playerid) {
	OfferingPipette[playerid] = 0;
	return true;
}
	
public SoplandoPipeta(playerid) {
	if(GetPlayerDrunkLevel(playerid) > 0)
		PlayerDoMessage(playerid, 15.0, "La pipeta marca que se superó el Límite permitido de alcohol en la sangre.");
	else
		PlayerDoMessage(playerid, 15.0, "La pipeta indica que no hay alcohol en la sangre.");
	return true;
}

CMD:ref(playerid, params[]) {
	return cmd_refuerzos(playerid, params);
}

CMD:refuerzos(playerid, params[])
{
	new type;
	if(sscanf(params, "i", type))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/(ref)uerzos [GENDARMERíA = 1 , PMA = 2, HMA = 3, GNA & PMA = 4]");
	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_HOSP)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No perteneces a una facción legal.");
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0 && MedDuty[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en servicio.");
	if(type < 1 || type > 4)
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/(ref)uerzos [GENDARMERíA = 1, PMA = 2, HMA = 3, GNA & PMA = 4]");
	new fac_buf[128];
	switch(type)
	{
		case 1: if(PlayerInfo[playerid][pFaction] != FAC_SIDE) { SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No formas parte de %s.", FactionInfo[FAC_SIDE][fName]); return 1; }
		case 2: if(PlayerInfo[playerid][pFaction] != FAC_PMA) { SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No formas parte de %s.", FactionInfo[FAC_PMA][fName]); return 1; }
		case 3: if(PlayerInfo[playerid][pFaction] != FAC_HOSP) { SendFMessage(playerid, COLOR_INFO, "[INFO] {FFFF00}Recorda informar por radio (/d) antes de pedir refuerzo a %s.", FactionInfo[FAC_HOSP][fName]); }
		case 4: if(PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_SIDE) { format(fac_buf, 128, "[ERROR] "COLOR_EMB_GREY"Solo pueden usar este refuerzo: %s y %s.", FactionInfo[FAC_PMA][fName], FactionInfo[FAC_SIDE][fName]); return SendClientMessage(playerid, COLOR_ERROR, fac_buf); }
	}

	new Float:x, Float:y, Float:z, area[MAX_ZONE_NAME];
	GetPlayerPos(playerid, x, y ,z);
	GetCoords2DZone(x, y, area, MAX_ZONE_NAME);

	switch(type)
	{
		case 1:
		{
			foreach(new i : Player)
			{
				if(PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i])
				{
					SetPlayerMarkerForPlayer(i, playerid, COLOR_BACKUP);
					SendFMessage(i, COLOR_PMA, "[CENTRAL] %s requiere asistencia inmediata en la zona de %s, lo marcamos en azul en el mapa.", GetPlayerCleanName(playerid), area);
				}
			}
		}
		case 2:
		{
			foreach(new i : Player)
			{
				if(PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i])
				{
					SetPlayerMarkerForPlayer(i, playerid, COLOR_BACKUP);
					SendFMessage(i, COLOR_PMA, "[CENTRAL] %s requiere asistencia inmediata en la zona de %s, lo marcamos en azul en el mapa.", GetPlayerCleanName(playerid), area);
				}
			}
		}
		case 3:
		{
			foreach(new i : Player)
			{
				if(PlayerInfo[i][pFaction] == FAC_HOSP && MedDuty[i])
				{
					SetPlayerMarkerForPlayer(i, playerid, COLOR_BACKUP);
					SendFMessage(i, COLOR_PMA, "[CENTRAL] %s requiere asistencia inmediata en la zona de %s, lo marcamos en azul en el mapa.", GetPlayerCleanName(playerid), area);
				}
			}
		}
		case 4:
		{
			foreach(new i : Player)
			{
				if((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) || (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]))
				{
					SetPlayerMarkerForPlayer(i, playerid, COLOR_BACKUP);
					SendFMessage(i, COLOR_PMA, "[CENTRAL] %s requiere asistencia inmediata en la zona de %s, lo marcamos en azul en el mapa.", GetPlayerCleanName(playerid), area);
				}
			}
		}
	}
	new bool:iconAplica;
	foreach(new ii : Player)
	{
		iconAplica = false;
		switch(type)
		{
			case 1: if(PlayerInfo[ii][pFaction] == FAC_SIDE && SIDEDuty[ii]) iconAplica = true;
			case 2: if(PlayerInfo[ii][pFaction] == FAC_PMA && CopDuty[ii]) iconAplica = true;
			case 3: if(PlayerInfo[ii][pFaction] == FAC_HOSP && MedDuty[ii]) iconAplica = true;
			case 4: if((PlayerInfo[ii][pFaction] == FAC_PMA && CopDuty[ii]) || (PlayerInfo[ii][pFaction] == FAC_SIDE && SIDEDuty[ii])) iconAplica = true;
		}
		if(iconAplica) {
			SetPlayerMapIcon(ii, 50, x, y, z, 0, COLOR_BACKUP, MAPICON_GLOBAL);
			PlayerPlaySound(ii, 21000, 0.0, 0.0, 0.0);
		}
	}
	SetPlayerMapIcon(playerid, 50, x, y, z, 0, COLOR_BACKUP, MAPICON_GLOBAL);
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	g_RefuerzoActivo[playerid] = true;
	g_RefuerzoTipo[playerid] = type;
	g_RefuerzoReminderTick[playerid] = 0;
	if(g_RefuerzoTimer[playerid] != -1) KillTimer(g_RefuerzoTimer[playerid]);
	g_RefuerzoTimer[playerid] = SetTimerEx("RefuerzoUpdate", 500, true, "i", playerid);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Para cancelar la solicitud utiliza '/noref'");
	return true;
}

CMD:noref(playerid, params[]) {
	if(!g_RefuerzoActivo[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes una solicitud de refuerzos activa.");
	new bool:notificar;
	foreach(new i : Player)
	{
		notificar = false;
		switch(g_RefuerzoTipo[playerid])
		{
			case 1: if(PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]) notificar = true;
			case 2: if(PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) notificar = true;
			case 3: if(PlayerInfo[i][pFaction] == FAC_HOSP && MedDuty[i]) notificar = true;
			case 4: if((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) || (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i])) notificar = true;
		}
		if(notificar) {
			SendFMessage(i, COLOR_PMA, "[CENTRAL] %s ha cancelado la solicitud de refuerzos.", GetPlayerCleanName(playerid));
			SetPlayerMarkerForPlayer(i, playerid, 0xFFFFFF00);
			RemovePlayerMapIcon(i, 50);
		}
	}
	if(g_RefuerzoTimer[playerid] != -1) {
		KillTimer(g_RefuerzoTimer[playerid]);
		g_RefuerzoTimer[playerid] = -1;
	}
	g_RefuerzoActivo[playerid] = false;
	g_RefuerzoTipo[playerid] = 0;
	g_RefuerzoReminderTick[playerid] = 0;
	RemovePlayerMapIcon(playerid, 50);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Su solicitud de refuerzos ha sido eliminada.");
	return true;
}

CMD:vercargos(playerid, params[]) {
	new targetid;
	
	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
		return true;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/vercargos [ID/Nombre]");
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");
    if(targetid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador!");
	if(PlayerInfo[playerid][pFaction] == FAC_PMA) {
	 	if(VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_PMA && GetPlayerVirtualWorld(playerid) != BUILDING_VW_OFFSET + BLD_PMA)
	 	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en la comisaría o dentro de una patrulla.");
	} 
	else {
		if(PlayerInfo[playerid][pFaction] == FAC_SIDE) {
		 	if(VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_SIDE && Bld_GetPlayerLastId(playerid) != BLD_PMA)
		 	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en la central o dentro de algun móvil.");
		}
	}

	SendFMessage(playerid, COLOR_LIGHTGREEN, "==================[Cargos de %s]==================", GetPlayerCleanName(targetid));
	SendFMessage(playerid, COLOR_WHITE, "- Nivel de búsqueda: %d", PlayerInfo[targetid][pWantedLevel]);
	SendFMessage(playerid, COLOR_WHITE, "- Acusado de: %s", PlayerInfo[targetid][pAccusedOf]);
	SendFMessage(playerid, COLOR_WHITE, "- Acusado por: %s", PlayerInfo[targetid][pAccusedBy]);
	return true;
}

CMD:doem(playerid, params[]) {
	new string[128], toggle;

	if(PlayerInfo[playerid][pFaction] != FAC_PMA)
		return true;
	if(PlayerInfo[playerid][pRank] > 4 || !CopDuty[playerid])
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en servicio como policía y tener el rango suficiente.");
	if(sscanf(params, "i", toggle)) {
 		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/doem [0-1]");
   		switch(DOEM) {
			case 0: SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estado D.O.E.M: {D40000}desautorizado");
		    case 1: SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estado D.O.E.M: {00D41C}autorizado");
   		}
   		return true;
	}
	if(toggle < 0 || toggle > 1)
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/doem [0-1]");

	if(toggle == 1 && DOEM != 1) {
 		format(string, sizeof(string), "¡Atención a todas las unidades! el D.O.E.M ha sido autorizado por %s.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_PMA, COLOR_PMA, string);
        DOEM = 1;
	} else
		if(toggle == 0 && DOEM != 0) {
  			format(string, sizeof(string), "¡Atención a todas las unidades! el D.O.E.M ha sido desautorizado por %s.", GetPlayerCleanName(playerid));
			SendFactionMessage(FAC_PMA, COLOR_PMA, string);
	        DOEM = 0;
		}
	return true;
}

CMD:ult(playerid, params[]) {
	return cmd_ultimallamada(playerid, params);
}

CMD:ultimallamada(playerid, params[]) {
	new faction = PlayerInfo[playerid][pFaction];

	if(faction != FAC_PMA && faction != FAC_HOSP)
		return true;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return true;
	if(!CopDuty[playerid] && !MedDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en servicio como paramédico o policía.");

	if(faction == FAC_PMA)
	{
		if(lastPoliceCallNumber == 0)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La última llamada no ha podido ser registrada.");
		if(VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_PMA && Bld_GetPlayerLastId(playerid) != BLD_PMA)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en la comisaría o dentro de una patrulla.");

		MapMarker_CreateForPlayer(playerid, lastPoliceCallPos[0], lastPoliceCallPos[1], lastPoliceCallPos[2], .color = COLOR_RED, .time = 120000);
		Noti_Create(playerid, .time = 3000, .text = "Localizas la ubicación de la llamada mediante rastreo satelital. Se marcará en rojo en tu GPS durante 2 minutos");
		SendFMessage(playerid, COLOR_CENTRALRED, "[CENTRAL] El último llamado al 911 (policía) ha sido con el número %i.", lastPoliceCallNumber);
	}
	else if(faction == FAC_HOSP)
	{
		if(lastMedicCallNumber == 0)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La última llamada no ha podido ser registrada.");
		if(VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_HOSP && Bld_GetPlayerLastId(playerid) != BLD_HOSP && Bld_GetPlayerLastId(playerid) != BLD_HOSP2)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en el hospital o dentro de un vehículo de paramédico.");

		MapMarker_CreateForPlayer(playerid, lastMedicCallPos[0], lastMedicCallPos[1], lastMedicCallPos[2], .color = COLOR_RED, .time = 120000);
		Noti_Create(playerid, .time = 3000, .text = "Localizas la ubicación de la llamada mediante rastreo satelital. Se marcará en rojo en tu GPS durante 2 minutos");
		SendFMessage(playerid, COLOR_GREEN, "[CENTRAL] El último llamado al 911 (paramédicos) ha sido con el número %i.", lastMedicCallNumber);
	}

	return true;
}

stock EndPlayerDuty(playerid) {
	if(isPlayerCopOnDuty(playerid) || isPlayerSideOnDuty(playerid))
	{
		CopDuty[playerid] = 0;
		SIDEDuty[playerid] = 0;
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ya no te encuentras en servicio.");
	}
}

enum e_ProperoDlgTable {
	e_pdt_maxrank,
	e_pdt_skin,
	e_pdt_desc[32]
}

static const ProperoDlgTable[][e_ProperoDlgTable] = {
	{20, 3, "Civil\n"},
	{10, 20004, "Oficial Masculino (1)\n"},
	{10, 20005, "Oficial Masculino (2)\n"},
	{10, 20006, "Oficial Masculino (3)\n"},
	{10, 20003, "Oficial Masculino (4)\n"},
	{10, 20007, "Oficial Masculino (5)\n"},
	{10, 20009, "Oficial Motorizado(6)\n"},
	{10, 301, "Oficial Masculino (7)\n"},
	{10, 20008, "Oficial Femenino (1)\n"},
	{10, 307, "Oficial Femenino (2)\n"},
	{10, 167, "Unidad Canina (1)\n"},
	{10, 284, "GOMF (Antidisturbios)\n"},
	{6, 20085, "Agente DOEM\n"},
	{6, 20010, "DOEM Entrenamiento (DOEM)\n"},
	{4, 286, "División de Investigaciones\n"}
};

Dialog:DLG_PROPERO_CMD(playerid, response, listitem, inputtext[]) {
	if(!response)
		return false;
	if(PlayerInfo[playerid][pRank] > ProperoDlgTable[listitem][e_pdt_maxrank] || (DOEM != 1 && listitem == 13))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu rango no tiene acceso a esa vestimenta.");

	if(listitem == 0)
	{
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		PlayerInfo[playerid][pJobSkin] = 0;
		PlayerCmeMessage(playerid, 15.0, 4000, "Deja su uniforme y toma su vestimenta de civil de los casilleros.");
	}
	else
	{
		PlayerInfo[playerid][pJobSkin] = ProperoDlgTable[listitem][e_pdt_skin];
		SetPlayerSkin(playerid, ProperoDlgTable[listitem][e_pdt_skin]);
		PlayerCmeMessage(playerid, 15.0, 4000, "Toma su placa y uniforme de los casilleros.");
	}

	return true;
}

CMD:propero(playerid, params[]) {
	if(!isPlayerCopOnDuty(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en servicio para usar este comando.");
	
	new equipid = EquipmentPoint_GetId(playerid);   
	if(!EquipmentPoint_IsPlayerAt(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes usar este comando en cualquier lado. Debés estar en los casilleros.");
	if(!EquipmentPoint_CanPlayerUse(playerid, equipid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en un casillero de tu facción.");
	
	new propero_str[32 * sizeof(ProperoDlgTable)];

	for(new i = 0, size = sizeof(ProperoDlgTable); i < size; i++) {
		strcat(propero_str, ProperoDlgTable[i][e_pdt_desc]);
	}
	
	Dialog_Show(playerid, DLG_PROPERO_CMD, DIALOG_STYLE_LIST, "Selecciona la vestimenta a equipar:", propero_str, "Aceptar", "Cerrar");
	return true;
}

stock AntecedentesLog(playerid, targetid, const antecedentes[]) {
	new targetName[MAX_PLAYER_NAME] = "Ninguno", targetSQLID = 0;
	
	if(targetid != INVALID_PLAYER_ID)
	{
		strcopy(targetName, PlayerInfo[targetid][pName], MAX_PLAYER_NAME);
		targetSQLID = PlayerInfo[targetid][pID];
	}

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `log_antecedentes` \
			(`pID`,`pName`,`pIP`,`date`,`tID`,`pAntecedentes`,`tName`) \
		VALUES \
			(%i,'%e','%e',CURRENT_TIMESTAMP,%i,'%e','%e');",
		PlayerInfo[playerid][pID],
		PlayerInfo[playerid][pName],
		PlayerInfo[playerid][pIP],
		targetSQLID,
		antecedentes,
		targetName
	);
	mysql_tquery(MYSQL_HANDLE, query);
	return true;
}

CMD:verantecedentes(playerid, params[]) {
    new targetname[MAX_PLAYER_NAME];

    if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_GOB)
		return true;
	if(PlayerInfo[playerid][pFaction] == FAC_PMA && PlayerInfo[playerid][pRank] == 10)
	    return true;
    if(sscanf(params, "s[24]", targetname))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/verantecedentes [Nombre_Apellido]");
	
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnLogAntecedentesLoad", "is", playerid, targetname @Format: "SELECT * FROM `log_antecedentes` WHERE `tName`='%e' ORDER BY `date` DESC LIMIT 15;", targetname);
	return true;
}

forward OnLogAntecedentesLoad(playerid, const targetname[]);
public OnLogAntecedentesLoad(playerid, const targetname[]) {
	new rows = cache_num_rows();

	if(!rows)
		return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El usuario no posee ningún registro de antecedentes.");

	new result_text[256], result_date[24], result_name[24];

	SendFMessage(playerid, COLOR_LIGHTYELLOW2, "=========================[Registro de antecedentes de %s]=========================", targetname);

	for(new i; i < rows; i++)
	{
		cache_get_value_name(i, "pAntecedentes", result_text, sizeof(result_text));
		cache_get_value_name(i, "date", result_date, sizeof(result_date));
		cache_get_value_name(i, "pName", result_name, sizeof(result_name));

		SendFMessage(playerid, COLOR_WHITE, "[%s] %s, por: %s", result_date, result_text, result_name);
	}

	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "===============================================================================");
	return true;
}

CMD:darlicencia(playerid, params[]) {
	new targetid;
	
	if(PlayerInfo[playerid][pFaction] != FAC_PMA || PlayerInfo[playerid][pRank] != 1)
	    return true;
	if(sscanf(params, "d", targetid))
  		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/darlicencia [ID/Nombre]");
	if(Bld_GetPlayerLastId(playerid) != BLD_PMA)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en la comisaría.");
	if(!IsPlayerInRangeOfPlayer(4.0, playerid, targetid))
	    return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador o está muy lejos!");
	if(PlayerInfo[targetid][pLevel] < 5)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debe ser nivel 5 o superior!");
  	if(PlayerInfo[targetid][pWepLic] != 0)
  	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto ya cuenta con una licencia de armas.");
	if(GetPlayerCash(targetid) < PRICE_LIC_GUN)
	{
	    SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto no cuenta con el dinero suficiente ($%d).", PRICE_LIC_GUN);
	    return true;
	}

	wepLicOffer[targetid] = playerid;
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Le has ofrecido una licencia de armas a %s, espera su respuesta.", GetPlayerCleanName(targetid));
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s te ha ofrecido una licencia de armas por %d. Usa /aceptar licencia si la quieres.", GetPlayerCleanName(playerid), PRICE_LIC_GUN);
	return true;
}

CMD:camaras(playerid, params[]) {
	if(IsPlayerInRangeOfPoint(playerid, 2.0, -2812.18, 3211.53, 2412.73)) {
		Dialog_Show(playerid, DLG_CAMARAS_POLICIA, DIALOG_STYLE_LIST, "Camaras disponibles", "24-7 Unity\nTaller Mercury\nHospital Central\nConsecionarios Grotti\nCentral ACEMA\n24-7 Norte\n24-7 Casa Rosada\n24-7 Este\nBanco de Malos Aires\nCasa Rosada", "Abrir", "Cerrar");
	}
	return true;
}

Dialog:DLG_CAMARAS_POLICIA(playerid, response, listitem, inputtext[]) {
	if(!response)
		return true;

	TogglePlayerControllable(playerid, false);
    usingCamera[playerid] = true;
    SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Te encuentras mirando una cámara de seguridad. Para salir utiliza /salircam.");
	switch(listitem)
	{
		case 0: {
            SetPlayerCameraPos(playerid,1810.6332,-1881.8149,19.5813);
            SetPlayerCameraLookAt(playerid,1826.7717,-1855.4510,13.5781);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1808.0325, -1875.4358, 14.1098);
        }
        case 1: {
            SetPlayerCameraPos(playerid, 2484.62,-1492.18,33.92);
            SetPlayerCameraLookAt(playerid, 2521.91,-1543.21,29.62);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerPos(playerid, 2510.83, -1511.57, 22.00);
        }
        case 2: {
            SetPlayerCameraPos(playerid, 1176.9811,-1343.1915,19.4488);
            SetPlayerCameraLookAt(playerid, 1189.4771,-1324.0830,13.5669);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerPos(playerid, 1194.1521, -1325.6360, 9.3984);
        }
        case 3: {
            SetPlayerCameraPos(playerid,493.8351,-1271.0554,31.1417);
            SetPlayerCameraLookAt(playerid,536.0699,-1266.2397,16.5363);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 541.5012, -1257.4186, 10.5401);
        }
        case 4: {
            SetPlayerCameraPos(playerid,807.4939,-1307.5045,28.8984);
            SetPlayerCameraLookAt(playerid,783.412,-1327.025,13.254);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 778.0953, -1323.9830, 9.3906);
        }
        case 5: {
            SetPlayerCameraPos(playerid,1289.1920,-944.2938,59.1594);
            SetPlayerCameraLookAt(playerid,1316.086,-914.297,37.690);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1315.8170, -915.3012, 32.0215);
        }
        case 6: {
            SetPlayerCameraPos(playerid, 1354.3875,-1725.0841,23.1490);
            SetPlayerCameraLookAt(playerid, 1352.600,-1740.055,13.171);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1366.0573, -1754.3422, 14.0174);
        }
        case 7: {
            SetPlayerCameraPos(playerid,2352.8774,-1249.7654,36.8919);
            SetPlayerCameraLookAt(playerid, 2374.472,-1211.521,27.135);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 2348.5415, -1210.8560, 30.2480);
		}
		case 8: {
            SetPlayerCameraPos(playerid,1430.0485,-1151.9353,36.8923);
            SetPlayerCameraLookAt(playerid, 1465.9761,-1172.3713,23.8700);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1466.8362, -1172.6542, 15.9016);
		}
		case 9: {
            SetPlayerCameraPos(playerid,1542.1896,-1714.8029,28.7414);
            SetPlayerCameraLookAt(playerid, 1507.4358,-1736.1678,13.3828);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1512.8125, -1736.2164, 5.3828);
		}
	}
	return true;
}

CMD:salircam(playerid, params[]) {
	if(usingCamera[playerid] == false)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras mirando ninguna cámara.");

	TogglePlayerControllable(playerid, true);
	usingCamera[playerid] = false;

	TeleportPlayerTo(playerid, -2812.18, 3211.53, 2412.73, 0.0, 3, BUILDING_VW_OFFSET + BLD_PMA);
	SetCameraBehindPlayer(playerid);
	return true;
}

CMD:carcelcomer(playerid, params[]) {
	new string[128];
	
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1202.4960, 3166.8948, 2416.5854))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en el comedor de la cárcel!");
	if(PlayerInfo[playerid][pJailed] != JAIL_IC_PRISON && PlayerInfo[playerid][pJailed] != JAIL_IC_GOB)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes una condena en la cárcel!");
	if(PlayerInfo[playerid][pHunger] < 20 || PlayerInfo[playerid][pThirst] < 20)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Sólo puedes comer en los horarios asignados! (( Cuando tengas menos de 20 hambre o sed ))");

	format(string, sizeof(string), "El cocinero llena la bandeja de %s con la comida del día y unos cubiertos de plástico.", GetPlayerCleanName(playerid));
	PlayerDoMessage(playerid, 15.0, string);
	PlayerCmeMessage(playerid, 15.0, 4000, "Toma su bandeja con ambas manos.");
	BN_PlayerDrink(playerid, 75);
	BN_PlayerEat(playerid, 75);
	return true;
}

CMD:verpatente(playerid, params[]) {
	new vehicleid;
	
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA && PlayerInfo[playerid][pFaction] == FAC_SIDE)
		return true;
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");
    if(sscanf(params, "i", vehicleid))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/verpatente [vehid]");
    if(!Veh_IsValidId(vehicleid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de vehículo invalida.");
	if(PlayerInfo[playerid][pFaction] == FAC_PMA && PlayerInfo[playerid][pFaction] == FAC_SIDE) {
	 	if(VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_PMA && VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_SIDE && GetPlayerVirtualWorld(playerid) != BUILDING_VW_OFFSET + BLD_PMA && GetPlayerVirtualWorld(playerid) != BUILDING_VW_OFFSET + BLD_SIDE)
	 	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en la comisaría o dentro de una patrulla.");
	} 

	SendClientMessage(playerid, COLOR_PMA, "================[Registro Nacional de la Propiedad del Automotor]===============");
	SendFMessage(playerid, COLOR_WHITE, "vehículo ID: %d", vehicleid);
	SendFMessage(playerid, COLOR_WHITE, "Patente: %s", VehicleInfo[vehicleid][VehPlate]);
	SendFMessage(playerid, COLOR_WHITE, "Modelo: %s", Veh_GetName(vehicleid));
	SendFMessage(playerid, COLOR_WHITE, "Titular: %s", VehicleInfo[vehicleid][VehOwnerName]);
	SendClientMessage(playerid, COLOR_PMA, "=======================================================================");
	return true;
}

CMD:callsign(playerid, params[]) {
	new result[128], veh = GetPlayerVehicleID(playerid), string[256];
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar como conductor en un vehículo!");
	if(PlayerInfo[playerid][pLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés ser nivel 2 o superior!");
	if(PlayerInfo[playerid][pFaction] != VehicleInfo[veh][VehFaction])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No perteneces a esta facción!");
	if (sscanf(params, "s[128]", result)) 
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/callsign [texto]");
    
	if (!VehCallSign[veh]) {
        format(string, sizeof(string), "%s", result);
        TextCallSign[veh] = Create3DTextLabel(string, 0xFFFFFFFF, 0.0, 0.0, 0.0, 50.0, 0, true);
        Attach3DTextLabelToVehicle(TextCallSign[veh], veh, -0.7, -1.9, -0.3);
        VehCallSign[veh] = 1;
        SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Para eliminar el callsign utiliza el mismo comando.");
	}
	else {
		Delete3DTextLabel(TextCallSign[veh]);
        VehCallSign[veh] = 0;
	    SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has eliminado el callsign.");
	}
	return true;
}

CMD:avcallsign(playerid, params[]) {
    new result[128], veh = GetPlayerVehicleID(playerid), string[256];
	{
		if (sscanf(params, "s[128]", result)) return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/avcallsign [texto]");
        if (!VehCallSign[veh]) {
            format(string, sizeof(string), "%s", result);
            TextCallSign[veh] = Create3DTextLabel(string, 0xFFFFFFFF, 0.0, 0.0, 0.0, 50.0, 0, true);
			Attach3DTextLabelToVehicle(TextCallSign[veh], veh, -0.7, -1.9, -0.3);
            VehCallSign[veh] = 1;
            SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Para eliminar el callsign utiliza el mismo comando.");
		}
		else {
			Delete3DTextLabel(TextCallSign[veh]);
            VehCallSign[veh] = 0;
		    SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has eliminado el callsign.");
		}
	}
	return true;
}

CMD:computador(playerid, params[])
{
	new title[256];
	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No formas parte de una faccion gubernamental.");
    if(CopDuty[playerid] == 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio para utilizar este comando.");
    if (VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_PMA && VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_SIDE)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en una patrulla.");
	
	format(title, sizeof(title), "Inicio de sesión: %s", GetPlayerCleanName(playerid));
	Dialog_Show(playerid, DLG_CPolicial, DIALOG_STYLE_LIST, title, "Registro civil\nAutomotores\nPropiedades", "Siguiente", "Salir");
	return 1;
}

Dialog:DLG_CPolicial(playerid, response, listitem, inputtext[], params[])
{
	if(!response)
	    return 1;
	switch(listitem)
	{
		case 0:
		{
			Dialog_Show(playerid, DLG_CPRegistroCivil, DIALOG_STYLE_LIST, "Registro civil", "Busqueda de Datos\nBusqueda de Antecedentes\nBusqueda de Cargos\nPanel de Buscados", "Siguiente", "Volver");
		}
		case 1:
		{
			Dialog_Show(playerid, DLG_CPAutomotores, DIALOG_STYLE_LIST, "Automotores", "Busqueda de Patente\nBusqueda de Licencias\nLocalizar automovil", "Siguiente", "Volver");
		}
		case 2:
		{
			Dialog_Open(playerid, "DLG_CPROPIEDADES", DIALOG_STYLE_INPUT, "Busqueda de Propiedades", "Ingresa el domicilio(ID) del hogar a buscar.", "Ingresar", "Volver");
		}
	}
	return 1;
}

Dialog:DLG_CPRegistroCivil(playerid, response, listitem, inputtext[], params[])
{
	if (!response) return cmd_computador(playerid, params);
	switch(listitem)
	{
		case 0:
		{
			Dialog_Open(playerid, "DLG_CDATOS", DIALOG_STYLE_INPUT, "Busqueda de Datos", "Ingresa el Nombre_Apellido.", "Ingresar", "Salir");
		}
		case 1:
		{
			Dialog_Open(playerid, "DLG_ANTECEDENTES", DIALOG_STYLE_INPUT, "Busqueda de Antecedentes", "Ingresa el Nombre_Apellido.", "Ingresar", "Salir");
		}
		case 2:
		{
			Dialog_Open(playerid, "DLG_CCARGOS", DIALOG_STYLE_INPUT, "Busqueda de Cargos", "Ingresa el Nombre_Apellido.", "Ingresar", "Salir");
		}
		case 3:
		{
			new count = 0, gformat[256], dialog[3072] = "Criminal\tEdad\tGenero\tNivel de Búsqueda\n";
			foreach(new i : Player)	
			{
				if(PlayerInfo[i][pWantedLevel] >= 1) 
				{
					format(gformat, sizeof gformat, "%s\t%d\t%s\t%d\n", GetPlayerCleanName(i), PlayerInfo[i][pAge], (PlayerInfo[i][pSex]) ? ("Masculino") : ("Femenino"), PlayerInfo[i][pWantedLevel]);
					strcat(dialog, gformat);
					Dialog_Show(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, "Panel de Buscados", dialog, "Cerrar", "");
					count++;
				}
			}
			if(count == 0)
				Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Panel de Buscados", "No hay criminales buscados on-line.", "Cerrar", "");
		}
	}
	return 1;
}

Dialog:DLG_CPAutomotores(playerid, response, listitem, inputtext[], params[])
{
	if (!response) return cmd_computador(playerid, params);
	switch(listitem)
	{
		case 0:
		{
			Dialog_Open(playerid, "DLG_CPATENTES", DIALOG_STYLE_INPUT, "Busqueda de Patentes", "Ingresa la patente(ID) del vehículo.", "Ingresar", "Salir");
		}
		case 1:
		{
			Dialog_Open(playerid, "DLG_CLICENCIAS", DIALOG_STYLE_INPUT, "Busqueda de Licencias", "Ingresa el Nombre_Apellido.", "Ingresar", "Salir");
		}
		case 2:
		{
			Dialog_Open(playerid, "DLG_CLOCALIZAR", DIALOG_STYLE_INPUT, "Localizar vehiculo", "Ingresa la patente(ID) del vehículo a localizar.", "Ingresar", "Salir");
		}
	}
	return 1;
}

Dialog:DLG_ANTECEDENTES(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return true;
	if(!IsNameRoleplayValid(inputtext))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nombre inválido. Debe seguir el formato esperado para un roleplay. Ej: Roberto_Martinez (máximo 24 carácteres).");
	
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnAntecedentesComput", "is", playerid, inputtext @Format: "SELECT * FROM `log_antecedentes` WHERE `tName`='%e' ORDER BY `date` DESC LIMIT 15;", inputtext);
	return true;
}

forward OnAntecedentesComput(playerid, const inputtext[]);
public OnAntecedentesComput(playerid, const inputtext[]) {
	new rows = cache_num_rows();

	if(!rows)
		return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Antecedentes", "¡Error crítico de Sistema!\nEsta persona no posee antecedentes.", "Cerrar", "");

	new result_text[256], result_date[24], result_name[24], title[256], dialog[256] = "Antecedente\tOficial\tFecha\n", gformat[3072];

	for(new i; i < rows; i++)
	{
		cache_get_value_name(i, "pAntecedentes", result_text, sizeof(result_text));
		cache_get_value_name(i, "date", result_date, sizeof(result_date));
		cache_get_value_name(i, "pName", result_name, sizeof(result_name));

        format(gformat, sizeof gformat, "%s\t%s\t%s\n", result_text, result_name, result_date);
		strcat(dialog, gformat);
		format(title, sizeof title, "Antecedentes: %s", inputtext);
		Dialog_Show(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, title, dialog, "Cerrar", "");
	}
	return true;
}

Dialog:DLG_CDATOS(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return true;
	if(!IsNameRoleplayValid(inputtext))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nombre inválido. Debe seguir el formato esperado para un roleplay. Ej: Roberto_Martinez (máximo 24 carácteres).");
	
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnDatosComput", "is", playerid, inputtext @Format: "SELECT * FROM `accounts` WHERE `Name`='%e'", inputtext);
	return true;
}

forward OnDatosComput(playerid, const inputtext[]);
public OnDatosComput(playerid, const inputtext[]) {
	new rows = cache_num_rows(), string[256], dialog[256];

	if(!rows)
		return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Datos", "¡Error crítico de Sistema!\nEsta persona no existe en el registro civil.", "Cerrar", "");

	new result_age, result_sex, result_pn;

	for(new i; i < rows; i++)
	{
		cache_get_value_name_int(i, "Age", result_age);
		cache_get_value_name_int(i, "Sex", result_sex);
		cache_get_value_name_int(i, "PhoneNumber", result_pn);

        format(dialog, sizeof dialog, "Registro Nacional de las Personas\n");
		strcat(string, dialog);
		format(dialog, sizeof dialog, " \n");
		strcat(string, dialog);
        format(dialog, sizeof dialog, "Nombre completo: %s\n", inputtext);
		strcat(string, dialog);
		format(dialog, sizeof dialog, "Edad: %d\n", result_age);
		strcat(string, dialog);
		format(dialog, sizeof dialog, "Genero: %s\n", (result_sex) ? ("Masculino") : ("Femenino"));
		strcat(string, dialog);
		format(dialog, sizeof dialog, "Numero telefonico: %d\n", result_pn);
		strcat(string, dialog);
		Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Datos", string, "Cerrar", "");
	}
	return true;
}

Dialog:DLG_CCARGOS(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return true;
	if(!IsNameRoleplayValid(inputtext))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nombre inválido. Debe seguir el formato esperado para un roleplay. Ej: Roberto_Martinez (máximo 24 carácteres).");
	
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnCargosComput", "is", playerid, inputtext @Format: "SELECT * FROM `accounts` WHERE `Name`='%e'", inputtext);
	return true;
}

forward OnCargosComput(playerid, const inputtext[]);
public OnCargosComput(playerid, const inputtext[]) {
	new rows = cache_num_rows();

	if(!rows)
		return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Cargos", "¡Error crítico de Sistema!\nEsta persona no posee ningun cargo.", "Cerrar", "");

	new result_ofic[24], result_cargo[64], title[256], string[256] = "Cargo\tOficial\tNivel de Búsqueda\n", dialog[256], result_wanted;

	for(new i; i < rows; i++)
	{
		cache_get_value_name(i, "pAccusedOf", result_cargo, 64);
		cache_get_value_name(i, "pAccusedBy", result_ofic, 24);
		cache_get_value_name_int(i, "pWantedLevel", result_wanted);

        format(dialog, sizeof dialog, "%s\t%s\t%d\n", result_cargo, result_ofic, result_wanted);
		strcat(string, dialog);
		format(title, sizeof title, "Cargos: %s", inputtext);
		Dialog_Show(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Cerrar", "");
	}
	return true;
}

Dialog:DLG_CPATENTES(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return true;
	
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnPatentesComput", "is", playerid, inputtext @Format: "SELECT * FROM `vehicles` WHERE `VehSQLID`='%i'", inputtext);
	return true;
}

forward OnPatentesComput(playerid, const inputtext[]);
public OnPatentesComput(playerid, const inputtext[]) {
	new rows = cache_num_rows();

    if(strval(inputtext) < 1)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresaste un número/carácter inválido");
		return 1;
	}

	if(!rows)
		return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Patentes", "¡Error crítico de Sistema!\nEste vehiculo no se encontro en el registro nacional.", "Cerrar", "");

	new dialog[256], gformat[3072];
	new autoid = strval(inputtext);

    format(gformat, sizeof gformat, "Registro Nacional de la Propiedad del Automotor");
	strcat(dialog, gformat);
	format(gformat, sizeof gformat, " \n");
	strcat(dialog, gformat);
	format(gformat, sizeof gformat, "Titular: %s\n", VehicleInfo[autoid][VehOwnerName]);
	strcat(dialog, gformat);
	format(gformat, sizeof gformat, "Patente: %s\n", VehicleInfo[autoid][VehPlate]);
	strcat(dialog, gformat);
	format(gformat, sizeof gformat, "Modelo: %s\n",  Veh_GetName(autoid));
	strcat(dialog, gformat);
	format(gformat, sizeof gformat, "Vehiculo ID: %d\n", autoid);
	strcat(dialog, gformat);
	Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Patentes", dialog, "Cerrar", "");
	return true;
}

Dialog:DLG_CLICENCIAS(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return true;
	if(!IsNameRoleplayValid(inputtext))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nombre inválido. Debe seguir el formato esperado para un roleplay. Ej: Roberto_Martinez (máximo 24 carácteres).");
	
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnLicenciasComput", "is", playerid, inputtext @Format: "SELECT * FROM `accounts` WHERE `Name`='%e'", inputtext);
	return true;
}

forward OnLicenciasComput(playerid, const inputtext[]);
public OnLicenciasComput(playerid, const inputtext[]) {
	new rows = cache_num_rows(), string[256], dialog[256];

	if(!rows)
		return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Licencias", "¡Error crítico de Sistema!\nEsta persona no existe en el registro civil.", "Cerrar", "");

	new result_car, result_fly, result_wep, result_sex;

	for(new i; i < rows; i++)
	{
		cache_get_value_name_int(i, "CarLic", result_car);
		cache_get_value_name_int(i, "FlyLic", result_fly);
		cache_get_value_name_int(i, "WepLic", result_wep);
		cache_get_value_name_int(i, "Sex", result_sex);

        format(dialog, sizeof dialog, "Registro Nacional de la Propiedad del Automotor\n");
		strcat(string, dialog);
		format(dialog, sizeof dialog, " \n");
		strcat(string, dialog);
        format(dialog, sizeof dialog, "Nombre completo: %s\n", inputtext);
		strcat(string, dialog);
		format(dialog, sizeof dialog, "Genero: %s\n", (result_sex) ? ("Masculino") : ("Femenino"));
		strcat(string, dialog);
		format(dialog, sizeof dialog, "Licencia de Conducir: %s\n", (result_car) ? ("Si") : ("No"));
		strcat(string, dialog);
		format(dialog, sizeof dialog, "Licencia de Vuelo: %s\n", (result_fly) ? ("Si") : ("No"));
		strcat(string, dialog);
		format(dialog, sizeof dialog, "Licencia de Armas: %s\n", (result_wep) ? ("Si") : ("No"));
		strcat(string, dialog);
		Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Licencias", string, "Cerrar", "");
	}
	return true;
}

Dialog:DLG_CLOCALIZAR(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return true;
	
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnLocalizarComput", "is", playerid, inputtext @Format: "SELECT * FROM `vehicles` WHERE `VehSQLID`='%i'", inputtext);
	return true;
}

forward OnLocalizarComput(playerid, const inputtext[]);
public OnLocalizarComput(playerid, const inputtext[]) {
	new rows = cache_num_rows();

    if(strval(inputtext) < 1)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresaste un número/carácter inválido");
		return 1;
	}

	if(!rows)
		return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Localizar vehiculo", "¡Error crítico de Sistema!\nNo se ha podido localizar el vehiculo.", "Cerrar", "");

	new autoid = strval(inputtext), Float:x, Float:y, Float:z, string[128], area[MAX_ZONE_NAME];

	GetVehiclePos(autoid, x, y, z);
	GetCoords2DZone(x, y, area, MAX_ZONE_NAME);

	MapMarker_CreateForPlayer(playerid, x, y, z, COLOR_RED, .time = 120000);
	Noti_Create(playerid, .time = 3000, .text = "Localizas la ubicación precisa del móvil mediante rastreo satelital. Se marcará en tu GPS durante 2 minutos");

	format(string, sizeof(string),"[CENTRAL] %s ha rastreado el móvil %i en la zona de %s.", GetPlayerCleanName(playerid), autoid, area);
	SendFactionMessage((PlayerInfo[playerid][pFaction] == FAC_SIDE) ? (FAC_SIDE) : (FAC_PMA), COLOR_PMA, string);
	return true;
}

Dialog:DLG_CPROPIEDADES(playerid, response, listitem, inputtext[], params[])
{
	if (!response) return cmd_computador(playerid, params);
	
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnPropiedadesComput", "is", playerid, inputtext @Format: "SELECT * FROM `houses` WHERE `Id`='%i'", inputtext);
	return true;
}

forward OnPropiedadesComput(playerid, const inputtext[]);
public OnPropiedadesComput(playerid, const inputtext[])
{
	new string[256], dialog[3072];
	new rows = cache_num_rows();

    if(strval(inputtext) < 1)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresaste un número/carácter inválido");
		return 1;
	}

	if(!rows)
		return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Propiedades", "¡Error crítico de Sistema!\nNo se ha podido localizar el domicilio.", "Cerrar", "");
	
	new casaid = strval(inputtext);
	format(dialog, sizeof dialog, "Registro Nacional de Inmuebles\n");
	strcat(string, dialog);
	format(dialog, sizeof dialog, " \n");
	strcat(string, dialog);
	format(dialog, sizeof dialog, "Titular inmobiliario: %s\n", House[casaid][OwnerName]);
	strcat(string, dialog);
	format(dialog, sizeof dialog, "Costo de compra: $%d\n", House[casaid][HousePrice]);
	strcat(string, dialog);
	format(dialog, sizeof dialog, "Inquilino: %s\n", House[casaid][Tenant]);
	strcat(string, dialog);
	format(dialog, sizeof dialog, "Casa alquilada: %s\n", (House[casaid][Income]) ? ("Si") : ("No"));
	strcat(string, dialog);
	format(dialog, sizeof dialog, "Casa en alquiler: %s\n", (House[casaid][IncomeAccept]) ? ("Si") : ("No"));
	strcat(string, dialog);
	Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Busqueda de Propiedades", string, "Cerrar", "");
	return true;
}

CMD:ayudap(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != FAC_PMA)
		return 1;
	if(PlayerInfo[playerid][pRank] == 10 && PlayerInfo[playerid][pFaction] == FAC_PMA)
		return 1;
		
	SendClientMessage(playerid, COLOR_INFO, "[Policia Federal Argencholina]");
	SendClientMessage(playerid, COLOR_INFO, "[COMANDOS] "COLOR_EMB_GREY" Si te encuentras en la zona del deposito, podras usar /vehmal en cualquier vehículo.");
	SendClientMessage(playerid, COLOR_INFO, "[COMANDOS] "COLOR_EMB_GREY" /equipar /propero /pservicio /sosp (/r)adio (/m)egafono /arrestar /esposar /verpatente /reanim");
	SendClientMessage(playerid, COLOR_INFO, "[COMANDOS] "COLOR_EMB_GREY" /quitaresposas /revisar /camaras /quitar /multar /premolcar /arrastrar /central /d(epartamental) /callsign)");
 	SendClientMessage(playerid, COLOR_INFO, "[COMANDOS] "COLOR_EMB_GREY" /refuerzos (/ult)imallamada /vercargos /buscados /localizar /pipeta /deposito /verantecedentes /computador");
	if(PlayerInfo[playerid][pRank] <= 4)
        SendFMessage(playerid, COLOR_INFO, "[COMANDOS %s] "COLOR_EMB_GREY" /doem", Faction_GetRankName(FAC_PMA, 4));
	if(PlayerInfo[playerid][pRank] <= 3)
        SendFMessage(playerid, COLOR_INFO, "[COMANDOS %s] "COLOR_EMB_GREY" /verregistros /comprarinsumos /guardarinsumos /verinsumos /pautorizar", Faction_GetRankName(FAC_PMA, 3));
	return 1;
}

// ==================== TACLEAR (POLICIA) ====================
static gLastTackleTick[MAX_PLAYERS] = {0, ...};

forward Police_TackleRelease(targetid);
public Police_TackleRelease(targetid)
{
	if(IsPlayerConnected(targetid)) {
		TogglePlayerControllable(targetid, true);
	}
	return 1;
}

// Encuentra el objetivo más cercano válido para tacleo
stock Police_FindNearestTackleTarget(playerid, Float:radius)
{
	new best = INVALID_PLAYER_ID;
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	foreach(new i : Player)
	{
		if(i == playerid) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerState(i) != PLAYER_STATE_ONFOOT) continue;
		if(IsPlayerInAnyVehicle(i)) continue;
		if(GetPlayerWeapon(i) != 0) continue; // armado => no válido para tacleo suave
		if(GetPlayerInterior(playerid) != GetPlayerInterior(i)) continue;
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(i)) continue;

		new Float:ix, Float:iy, Float:iz;
		GetPlayerPos(i, ix, iy, iz);
		new Float:dx = ix - px, Float:dy = iy - py, Float:dz = iz - pz;
		new Float:dist = floatsqroot(dx*dx + dy*dy + dz*dz);
		if(dist <= radius)
		{
			radius = dist;
			best = i;
		}
	}
	return best;
}

stock bool:Police_CanTackle(playerid)
{
	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
		return false;
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
		return false;
	new now = GetTickCount();
	if(gLastTackleTick[playerid] && now - gLastTackleTick[playerid] < 5000)
		return false;
	return true;
}

stock Police_DoTackle(playerid, targetID)
{
	PlayerPlayerActionMessage(playerid, targetID, 15.0, "taclea a");
	ApplyAnimationEx(targetID, "PED", "FALL_front", 4.0, 0, 1, 1, 0, 700, 1);
	TogglePlayerControllable(targetID, false);
	SetTimerEx("Police_TackleRelease", 2000, false, "i", targetID);
	gLastTackleTick[playerid] = GetTickCount();
	return true;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	// Cancelar reanimación al presionar disparo
	if((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE))
	{
		if(GetPVarInt(playerid, "isReanimating") == 1 && GetPVarInt(playerid, "reanimTimerId") != 0)
		{
			Police_CancelReanim(playerid);
			return 1;
		}
	}
	
	// Activación por tecla: mantener sprint y presionar ataque secundario
	if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK))
	{
		if(!(newkeys & KEY_SPRINT)) return 1; // requiere estar sprintando
		if(!Police_CanTackle(playerid)) return 1;
		new target = Police_FindNearestTackleTarget(playerid, 2.5);
		if(target != INVALID_PLAYER_ID)
		{
			Police_DoTackle(playerid, target);
		}
	}
	return 1;
}

CMD:tacleo(playerid, params[])
{
	new targetID;

	// Solo PMA/Side en servicio
	if(PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_PMA)
		return true;
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio!");

	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/tacleo [ID/Nombre]");
	if(!IsPlayerConnected(targetID) || targetID == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido.");

	// Cooldown 5s
	new now = GetTickCount();
	if(gLastTackleTick[playerid] && now - gLastTackleTick[playerid] < 5000)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar antes de volver a taclear.");

	// Condiciones básicas
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || GetPlayerState(targetID) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ambos deben estar a pie.");
	if(IsPlayerInAnyVehicle(targetID))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El objetivo está dentro de un vehículo.");
	if(GetPlayerInterior(playerid) != GetPlayerInterior(targetID) || GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(targetID))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El objetivo no está en tu zona.");
	if(!IsPlayerInRangeOfPlayer(2.5, playerid, targetID))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Estás demasiado lejos para taclear.");

	// Objetivo desarmado (sin arma en mano)
	if(GetPlayerWeapon(targetID) != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El objetivo está armado: utiliza métodos alternativos.");

	// Ejecutar tacleo
	PlayerPlayerActionMessage(playerid, targetID, 15.0, "taclea a");
	ApplyAnimationEx(targetID, "PED", "FALL_front", 4.0, 0, 1, 1, 0, 700, 1);
	TogglePlayerControllable(targetID, false);
	SetTimerEx("Police_TackleRelease", 2000, false, "i", targetID);

	gLastTackleTick[playerid] = now;
	return true;
}
// /identidad [nombre] - cambiar alias temporal (no se guarda). /identidad volver para volver al nombre original.
CMD:identidad(playerid, params[])
{
	new string[MAX_PLAYER_NAME];
	new query[256];

	if(PlayerInfo[playerid][pFaction] != FAC_PMA) return 1;
	if(PlayerInfo[playerid][pRank] > POLICE_ALIAS_MIN_RANK)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el rango suficiente para usar este comando.");
	if(CopDuty[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio para usar este comando.");

	// Trim leading/trailing spaces (manual, avoids dependency on Trim signature)
	new start = 0, end = 0;
	for(new i = 0; params[i] != '\0'; i++) end = i;
	while(params[start] == ' ' || params[start] == '\t') start++;
	while(end >= start && (params[end] == ' ' || params[end] == '\t')) end--;
	if(start > 0 || end < (strlen(params) - 1)) {
		new tmp[MAX_PLAYER_NAME];
		new len = 0;
		for(new k = start; k <= end; k++) tmp[len++] = params[k];
		tmp[len] = '\0';
		strcopy(params, tmp, MAX_PLAYER_NAME);
	}
	if(!params[0])
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY "/identidad [nombre]|volver");

	if(!strcmp(params, "volver", true) || !strcmp(params, "revertir", true) || !strcmp(params, "off", true))
	{
		if(!HasTempAlias[playerid])
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una identidad temporal activa.");
		HasTempAlias[playerid] = false;
		// Restore internal stored name so core/playerlist shows original
		strcopy(PlayerInfo[playerid][pName], OriginalName[playerid], MAX_PLAYER_NAME);
		SetPlayerName(playerid, OriginalName[playerid]);
		SetPlayerChatName(playerid, OriginalName[playerid]);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has vuelto a tu identidad original.");
		KeyChain_UpdatePlayerName(playerid);
		return 1;
	}

	// Validate format: must be Nombre_Apellido (exactly one underscore, no spaces)
	new underscore_count = 0;
	new underscore_pos = -1;
	for(new i = 0; params[i] != '\0'; i++) {
		if(params[i] == '_') {
			underscore_count++;
			if(underscore_count == 1) underscore_pos = i;
		}
		if(params[i] == ' ') {
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El formato debe ser Nombre_Apellido (sin espacios). Usa '_' entre nombre y apellido.");
		}
	}

	if(underscore_count != 1 || underscore_pos <= 0 || params[underscore_pos + 1] == '\0') {
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El formato debe ser Nombre_Apellido (ej: Juan_Perez). Usa exactamente un guion bajo entre nombre y apellido.");
	}

	// Verificar si ya tiene una identidad temporal activa
	if(HasTempAlias[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya tienes una identidad temporal activa. Usa '/identidad volver' para revertir primero.");

	// Verificar si el nombre ya existe en la base de datos
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT Id FROM accounts WHERE Name='%e' LIMIT 1", params);
	new Cache:result = mysql_query(MYSQL_HANDLE, query);
	
	if(cache_num_rows() > 0)
	{
		cache_delete(result);
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya existe un personaje con ese nombre. Elige otro.");
		return 1;
	}
	cache_delete(result);

	format(string, sizeof(string), "%s", params);
	strcopy(OriginalName[playerid], PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	strcopy(TempAlias[playerid], string, MAX_PLAYER_NAME);
	HasTempAlias[playerid] = true;
	ApplyTemporaryName(playerid, TempAlias[playerid]);
	SendClientMessage(playerid, COLOR_INFO, "Identidad temporal activada. Usa '/identidad volver' para volver.");
	return 1;
}
// ---- BOTON DE PANICO ----

stock CancelarBP(playerid)
{
	if(!g_BPActivo[playerid]) return;
	foreach(new i : Player)
	{
		SetPlayerMarkerForPlayer(i, playerid, 0xFFFFFF00);
		RemovePlayerMapIcon(i, 51);
	}
	RemovePlayerMapIcon(playerid, 51);
	if(g_BPTimer[playerid] != -1) { KillTimer(g_BPTimer[playerid]); g_BPTimer[playerid] = -1; }
	if(g_BPSoundTimer[playerid] != -1) { KillTimer(g_BPSoundTimer[playerid]); g_BPSoundTimer[playerid] = -1; }
	g_BPActivo[playerid] = false;
	g_BPSoundStep[playerid] = 0;
	g_BPReminderTick[playerid] = 0;
}

stock ReaplicarBP(playerid)
{
	if(!g_BPActivo[playerid]) return;
	new Float:rx, Float:ry, Float:rz;
	GetPlayerPos(playerid, rx, ry, rz);
	foreach(new i : Player)
	{
		if((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) ||
		   (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]) ||
		   (PlayerInfo[i][pFaction] == FAC_HOSP && MedDuty[i]))
		{
			SetPlayerMarkerForPlayer(i, playerid, COLOR_BACKUP);
			SetPlayerMapIcon(i, 51, rx, ry, rz, 0, COLOR_RED,    MAPICON_GLOBAL);
		}
	}
	SetPlayerMapIcon(playerid, 51, rx, ry, rz, 0, COLOR_RED,    MAPICON_GLOBAL);
}

CMD:botonpanico(playerid, params[]) { return cmd_bp(playerid, params); }

CMD:bp(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_SIDE && PlayerInfo[playerid][pFaction] != FAC_HOSP)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No perteneces a una facción legal.");
	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0 && MedDuty[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés estar en servicio.");
	if(g_BPActivo[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya tenés el botón de pánico activo.");

	new Float:x, Float:y, Float:z, area[MAX_ZONE_NAME];
	GetPlayerPos(playerid, x, y, z);
	GetCoords2DZone(x, y, area, MAX_ZONE_NAME);

	foreach(new i : Player)
	{
		if(i == playerid) continue;
		if(!((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) ||
		     (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]) ||
		     (PlayerInfo[i][pFaction] == FAC_HOSP && MedDuty[i]))) continue;
		SetPlayerMarkerForPlayer(i, playerid, COLOR_RED);
		SetPlayerMapIcon(i, 51, x, y, z, 0, COLOR_RED,    MAPICON_GLOBAL);
		PlayerPlaySound(i, 21001, 0.0, 0.0, 0.0);
		SendFMessage(i, 0xFF0000FF, "[BOTÓN DE PÁNICO] {FFFF00}¡Un funcionario de %s ha accionado el botón de pánico!", FactionInfo[PlayerInfo[playerid][pFaction]][fName]);
		SendClientMessage(i, 0xFF0000FF, "[BOTÓN DE PÁNICO] {FFFF00}Se ha marcado por GPS la posición del funcionario.");
		SendFMessage(i, 0xFF0000FF, "[BOTÓN DE PÁNICO] {FFFF00}¡El funcionario está en una situación de extrema peligrosidad en %s!", area);
		SendClientMessage(i, 0xFF0000FF, "[BOTÓN DE PÁNICO] {FFFF00}¡Todo el aparato de seguridad se está movilizando hacia la zona ahora mismo! ¡Apúrate!");
		if(PlayerInfo[i][pFaction] == FAC_HOSP)
		{
			SendClientMessage(i, 0xFF0000FF, "[BOTÓN DE PÁNICO] ¡Recordá que si sos médic@, debés tomar precaución y esperar a la intervención policial!");
			SendClientMessage(i, 0xFF0000FF, "[BOTÓN DE PÁNICO] ¡Valorá la vida de tu personaje, sos personal de salud!");
		}
	}
	SetPlayerMapIcon(playerid, 51, x, y, z, 0, COLOR_RED,    MAPICON_GLOBAL);
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	SendClientMessage(playerid, 0xFF0000FF, "[BOTÓN DE PÁNICO] {FFFF00}¡HAS ACCIONADO EL BOTÓN DE PÁNICO!");
	SendClientMessage(playerid, 0xFF0000FF, "[BOTÓN DE PÁNICO] {FFFF00}¡Ponete a cubierto y espera a los refuerzos! ¡Acabas de movilizar a todo el aparato estatal!");

	g_BPActivo[playerid] = true;
	g_BPSoundStep[playerid] = 0;
	g_BPReminderTick[playerid] = 0;
	if(g_BPTimer[playerid] != -1) KillTimer(g_BPTimer[playerid]);
	g_BPTimer[playerid] = SetTimerEx("BPUpdate", 500, true, "i", playerid);
	if(g_BPSoundTimer[playerid] != -1) KillTimer(g_BPSoundTimer[playerid]);
	g_BPSoundTimer[playerid] = SetTimerEx("BPSoundSeq", 500, false, "i", playerid);
	return 1;
}

CMD:finalizarbotondepanico(playerid, params[]) { return cmd_finalizarbp(playerid, params); }

CMD:finalizarbp(playerid, params[])
{
	if(!g_BPActivo[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenés el botón de pánico activo.");
	foreach(new i : Player)
	{
		if((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) ||
		   (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]) ||
		   (PlayerInfo[i][pFaction] == FAC_HOSP && MedDuty[i]))
		{
			SendFMessage(i, 0xFF0000FF, "[BOTÓN DE PÁNICO] {FFFF00}%s ha finalizado el botón de pánico.", GetPlayerCleanName(playerid));
		}
	}
	CancelarBP(playerid);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has finalizado el botón de pánico.");
	return 1;
}

public BPUpdate(playerid)
{
	if(!IsPlayerConnected(playerid) || !g_BPActivo[playerid])
	{
		g_BPTimer[playerid] = -1;
		return;
	}
	new Float:rx, Float:ry, Float:rz;
	GetPlayerPos(playerid, rx, ry, rz);
	foreach(new i : Player)
	{
		if((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) ||
		   (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]) ||
		   (PlayerInfo[i][pFaction] == FAC_HOSP && MedDuty[i]))
		{
			SetPlayerMapIcon(i, 51, rx, ry, rz, 0, COLOR_RED,    MAPICON_GLOBAL);
		}
	}
	SetPlayerMapIcon(playerid, 51, rx, ry, rz, 0, COLOR_RED,    MAPICON_GLOBAL);
	g_BPReminderTick[playerid]++;
	if(g_BPReminderTick[playerid] >= 600)
	{
		g_BPReminderTick[playerid] = 0;
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Recordá que tenés el botón de pánico activo. Usa /finalizarbp para desactivarlo.");
	}
}

public BPSoundSeq(playerid)
{
	g_BPSoundTimer[playerid] = -1;
	if(!IsPlayerConnected(playerid) || !g_BPActivo[playerid]) return;
	g_BPSoundStep[playerid]++;
	foreach(new i : Player)
	{
		if(i == playerid) continue;
		if(!((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) ||
		     (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]) ||
		     (PlayerInfo[i][pFaction] == FAC_HOSP && MedDuty[i]))) continue;
		if(g_BPSoundStep[playerid] <= 5) PlayerPlaySound(i, 21001, 0.0, 0.0, 0.0);
		else if(g_BPSoundStep[playerid] == 6) PlayerPlaySound(i, 30600, 0.0, 0.0, 0.0);
		else PlayerPlaySound(i, 41603, 0.0, 0.0, 0.0);
	}
	if(g_BPSoundStep[playerid] < 6)
		g_BPSoundTimer[playerid] = SetTimerEx("BPSoundSeq", 500, false, "i", playerid);
	else if(g_BPSoundStep[playerid] == 6)
		g_BPSoundTimer[playerid] = SetTimerEx("BPSoundSeq", 10000, false, "i", playerid);
}

forward RefuerzoUpdate(playerid);
forward BPUpdate(playerid);
forward BPSoundSeq(playerid);

stock ReaplicarRefuerzo(playerid)
{
	if(!g_RefuerzoActivo[playerid]) return;
	new Float:rx, Float:ry, Float:rz;
	GetPlayerPos(playerid, rx, ry, rz);
	foreach(new i : Player)
	{
		new bool:aplica = false;
		switch(g_RefuerzoTipo[playerid])
		{
			case 1: if(PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]) aplica = true;
			case 2: if(PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) aplica = true;
			case 3: if(PlayerInfo[i][pFaction] == FAC_HOSP && MedDuty[i]) aplica = true;
			case 4: if((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) || (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i])) aplica = true;
		}
		if(aplica) {
			SetPlayerMarkerForPlayer(i, playerid, COLOR_BACKUP);
			SetPlayerMapIcon(i, 50, rx, ry, rz, 0, COLOR_BACKUP, MAPICON_GLOBAL);
		}
	}
}

stock CancelarRefuerzo(playerid)
{
	if(!g_RefuerzoActivo[playerid]) return;
	foreach(new i : Player)
	{
		SetPlayerMarkerForPlayer(i, playerid, 0xFFFFFF00);
		RemovePlayerMapIcon(i, 50);
	}
	if(g_RefuerzoTimer[playerid] != -1) {
		KillTimer(g_RefuerzoTimer[playerid]);
		g_RefuerzoTimer[playerid] = -1;
	}
	RemovePlayerMapIcon(playerid, 50);
	g_RefuerzoActivo[playerid] = false;
	g_RefuerzoTipo[playerid] = 0;
	g_RefuerzoReminderTick[playerid] = 0;
}

public RefuerzoUpdate(playerid)
{
	if(!IsPlayerConnected(playerid) || !g_RefuerzoActivo[playerid])
	{
		g_RefuerzoTimer[playerid] = -1;
		return;
	}
	new Float:rx, Float:ry, Float:rz;
	GetPlayerPos(playerid, rx, ry, rz);
	new bool:aplica;
	foreach(new i : Player)
	{
		aplica = false;
		switch(g_RefuerzoTipo[playerid])
		{
			case 1: if(PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]) aplica = true;
			case 2: if(PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) aplica = true;
			case 3: if(PlayerInfo[i][pFaction] == FAC_HOSP && MedDuty[i]) aplica = true;
			case 4: if((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) || (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i])) aplica = true;
		}
		if(aplica) SetPlayerMapIcon(i, 50, rx, ry, rz, 0, COLOR_BACKUP, MAPICON_GLOBAL);
	}
	SetPlayerMapIcon(playerid, 50, rx, ry, rz, 0, COLOR_BACKUP, MAPICON_GLOBAL);
	g_RefuerzoReminderTick[playerid]++;
	if(g_RefuerzoReminderTick[playerid] >= 600)
	{
		g_RefuerzoReminderTick[playerid] = 0;
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Recorda que tenes el /ref activo. Usa /noref para desactivarlo.");
	}
}

hook OnPlayerDisconnect(playerid, reason)
{
	CancelarRefuerzo(playerid);
	CancelarBP(playerid);
	if(HasTempAlias[playerid])
	{
		HasTempAlias[playerid] = false;
		strcopy(PlayerInfo[playerid][pName], OriginalName[playerid], MAX_PLAYER_NAME);
		SetPlayerName(playerid, OriginalName[playerid]);
		SetPlayerChatName(playerid, OriginalName[playerid]);
		KeyChain_UpdatePlayerName(playerid);
	}
	return 1;
}


public ApplyTemporaryName(playerid, const newname[])
{
	if(!IsPlayerConnected(playerid)) return 0;
	new dbg[128];
	printf(dbg);

	SetPlayerName(playerid, newname);
	SetPlayerChatName(playerid, newname);
	strcopy(PlayerInfo[playerid][pName], newname, MAX_PLAYER_NAME);
	KeyChain_UpdatePlayerName(playerid);

	SendFMessage(playerid, COLOR_INFO, "Se ha aplicado una identidad temporal: %s", newname);
	ServerLog(LOG_TYPE_ID_ADMIN, .entry="/identidad", .playerid=playerid, .targetid=playerid, .params=newname);
	return 1;
}

CMD:reanim(playerid, params[])
{
	new target;
	

	if(PlayerInfo[playerid][pFaction] != FAC_PMA && PlayerInfo[playerid][pFaction] != FAC_SIDE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo la policía puede usar este comando.");

	if(CopDuty[playerid] == 0 && SIDEDuty[playerid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés estar en servicio como oficial de policía!");
	

	new hand = SearchHandsForItem(playerid, ITEM_ID_MEDIC_CASE);
	if(hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Necesitas un botiquín de primeros auxilios en mano para reanimar!");
	
	new uses = GetHandParam(playerid, hand);
	if(uses <= 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Tu botiquín de primeros auxilios no tiene usos disponibles!");

	if(CountMedicsOnDuty() > 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes reanimar mientras haya médicos en servicio! Llama al hospital.");
	
	if(sscanf(params, "u", target))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/reanim [ID/Jugador]");
	
	if(GetPVarInt(playerid, "isReanimating") != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya estás reanimando a una persona: debes esperar para usar nuevamente el comando!");
	
	if(target == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido.");
	
	if(target == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes reanimarte a ti mismo.");
	
	if(!IsPlayerInRangeOfPlayer(2.0, playerid, target))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar cerca del herido!");
	
	if(PlayerInfo[target][pDisabled] == DISABLE_DEATHBED)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto se encuentra en su lecho de muerte y no hay nada que puedas hacer por él.");
	

	SendFMessage(target, COLOR_LIGHTBLUE, "El oficial %s te ofrece reanimación de emergencia (50%% HP). Escribe (/aceptar policia) para aceptar.", GetPlayerCleanName(playerid));
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Has ofrecido reanimación de emergencia a %s (50%% HP).", GetPlayerCleanName(target));
	SendClientMessage(target, COLOR_GREY, "[INFO] Este es un procedimiento de emergencia. Se recomienda acudir al hospital después.");
	
	SetPVarInt(playerid, "reanimTarget", target);
	SetPVarInt(playerid, "isReanimating", 1);
	SetPVarInt(target, "reanimIssuer", playerid);
	
	new offer_timer = SetTimerEx("Police_ReanimTimer", 15000, false, "i", playerid);
	SetPVarInt(playerid, "reanimOfferTimerId", offer_timer);
	
	return 1;
}

// Timer para cancelar oferta de reanimación
forward Police_ReanimTimer(playerid);
public Police_ReanimTimer(playerid)
{
	if(GetPVarInt(playerid, "isReanimating") == 1)
	{
		new target = GetPVarInt(playerid, "reanimTarget");
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La oferta de reanimación ha expirado.");
		if(IsPlayerConnected(target))
			SendClientMessage(target, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La oferta de reanimación ha expirado.");
		
		SetPVarInt(playerid, "isReanimating", 0);
		SetPVarInt(playerid, "reanimTarget", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "reanimOfferTimerId", 0);
		if(IsPlayerConnected(target))
			SetPVarInt(target, "reanimIssuer", INVALID_PLAYER_ID);
	}
	return 1;
}

// Finalizar reanimación policial
forward Police_FinishReanim(playerid);
public Police_FinishReanim(playerid)
{
	new officer = GetPVarInt(playerid, "reanimIssuer");
	if(officer == INVALID_PLAYER_ID) return 0;
	
	// Prohibir autoreanimación
	if(officer == playerid)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes reanimarte a ti mismo.");
		SetPVarInt(officer, "isReanimating", 0);
		SetPVarInt(officer, "reanimTarget", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "reanimIssuer", INVALID_PLAYER_ID);
		return 1;
	}
	
	// Limpiar timer ID
	SetPVarInt(officer, "reanimTimerId", 0);
	
	// Detener animación y desbloquear controles
	ClearAnimations(officer);
	TogglePlayerControllable(officer, true);
	
	if(PlayerInfo[playerid][pCrack]) {
		ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0, 1, false);
	} else {
		TogglePlayerControllable(playerid, true);
		ClearAnimations(playerid);
	}
	
	// Verificar que el oficial TODAVÍA tenga el botiquín
	new hand = SearchHandsForItem(officer, ITEM_ID_MEDIC_CASE);
	if(hand == -1 || GetHandParam(officer, hand) <= 0)
	{
		SendClientMessage(officer, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya no tienes el botiquín de primeros auxilios!");
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡La reanimación falló!");
		SetPVarInt(officer, "isReanimating", 0);
		SetPVarInt(officer, "reanimTarget", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "reanimIssuer", INVALID_PLAYER_ID);
		return 1;
	}
	
	// Aplicar reanimación al 50% HP (fijo, sin posibilidad de cambiar)
	SetPlayerHealthEx(playerid, 50.00);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "¡Has sido reanimado por un oficial de policía al 50% HP!");
	SendClientMessage(playerid, COLOR_GREY, "[INFO] Se recomienda acudir al hospital para atención médica completa.");
	SendClientMessage(officer, COLOR_LIGHTGREEN, "Has reanimado exitosamente al civil al 50% HP.");
	
	PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
	PlayerPlaySound(officer, 1150, 0.0, 0.0, 0.0);
	
	// Consumir un uso del botiquín médico
	new remaining_uses = GetHandParam(officer, hand) - 1;
	if(remaining_uses > 0)
	{
		SetHandItemAndParam(officer, hand, ITEM_ID_MEDIC_CASE, remaining_uses);
		SendFMessage(officer, COLOR_INFO, "[INFO] Has utilizado tu botiquín. Usos restantes: %d", remaining_uses);
	}
	else
	{
		SetHandItemAndParam(officer, hand, 0, 0);
		SendClientMessage(officer, COLOR_INFO, "[INFO] Has utilizado tu botiquín y se ha agotado.");
	}
	
	// Log del uso de reanimación policial
	new log_str[256];
	format(log_str, sizeof(log_str), "%s reanimó a %s (50%% HP - Sin médicos disponibles)", GetPlayerCleanName(officer), GetPlayerCleanName(playerid));
	ServerLog(LOG_TYPE_ID_ADMIN, .entry="REANIMACIÓN PD", .playerid=officer, .targetid=playerid, .params=log_str);
	
	// Limpiar vars
	SetPVarInt(officer, "isReanimating", 0);
	SetPVarInt(officer, "reanimTarget", INVALID_PLAYER_ID);
	SetPVarInt(playerid, "reanimIssuer", INVALID_PLAYER_ID);
	
	return 1;
}

// Cancelar reanimación policial
stock Police_CancelReanim(officerid)
{
	new target = GetPVarInt(officerid, "reanimTarget");
	if(target == INVALID_PLAYER_ID) return 0;
	
	new isReanimating = GetPVarInt(officerid, "isReanimating");
	new timerid = GetPVarInt(officerid, "reanimTimerId");
	if(isReanimating == 0 && timerid == 0) return 0;
	
	// Detener animación y timer
	ClearAnimations(officerid);
	if(timerid != 0) KillTimer(timerid);
	
	// Descongelar oficial
	TogglePlayerControllable(officerid, true);
	
	// Solo descongelar paciente si HP > 15
	if(IsPlayerConnected(target)) {
		new Float:target_hp;
		GetPlayerHealth(target, target_hp);
		if(target_hp > 15.0) {
			if(PlayerInfo[target][pCrack]) {
				ApplyAnimationEx(target, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0, 1, false);
			} else {
				ClearAnimations(target);
				TogglePlayerControllable(target, true);
			}
		} else {
			ApplyAnimationEx(target, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0, 1, false);
		}
	}
	
	// Notificar
	SendClientMessage(officerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Has cancelado el proceso de reanimación.");
	if(IsPlayerConnected(target)) SendFMessage(target, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"%s ha cancelado el proceso de reanimación.", GetPlayerCleanName(officerid));
	
	// Limpiar vars
	SetPVarInt(officerid, "isReanimating", 0);
	SetPVarInt(officerid, "reanimTarget", INVALID_PLAYER_ID);
	SetPVarInt(officerid, "reanimTimerId", 0);
	SetPVarInt(target, "reanimIssuer", INVALID_PLAYER_ID);
	
	return 1;
}