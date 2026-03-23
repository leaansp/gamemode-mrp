/*#if defined _marp_gen_included
	#endinput
#endif
#define _marp_gen_included

//new SIDEGateTimer;
new STARS;

CMD:gropero(playerid, params[])
{
	new item;
	
    if(!isPlayerSideOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio para usar este comando.");
	new equipid = EquipmentPoint_GetId(playerid);   
	if(!EquipmentPoint_IsPlayerAt(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes usar este comando en cualquier lado. Debes estar en los casilleros.");
	if(!EquipmentPoint_CanPlayerUse(playerid, equipid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un casillero de tu faccion.");

	if(sscanf(params, "i", item))
	{
	    SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/gropero [0-4] (Para elegir tu ropa original usa 0)");
	    SendClientMessage(playerid, COLOR_GREY, "===== ROPERO DE GENDARMERíA =====");
	    SendClientMessage(playerid, COLOR_GREY, "0 - Ropa normal");
	    SendClientMessage(playerid, COLOR_GREY, "1 - Uniforme de Recluta / Gendarme");
	    SendClientMessage(playerid, COLOR_GREY, "2 - Uniforme de Cabo");
	    SendClientMessage(playerid, COLOR_GREY, "3 - Uniforme de Comandante Segundo");
	    SendClientMessage(playerid, COLOR_GREY, "4 - Equipo de asalto");
	    SendClientMessage(playerid, COLOR_GREY, "5 - Comandante General");
		SendClientMessage(playerid, COLOR_GREY, "=================================");
		return 1;
	}
	if(item < 0 || item > 5)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Elige una opción válida.");
	    
	switch(item)
	{
        case 0: SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		case 1: SetPlayerSkin(playerid, 311);
		case 2: if(PlayerInfo[playerid][pRank] < 9) SetPlayerSkin(playerid, 287);
		case 3: if(PlayerInfo[playerid][pRank] < 4) SetPlayerSkin(playerid, 310);
		case 4:
		{
		    if(STARS && PlayerInfo[playerid][pRank] < 9)
				SetPlayerSkin(playerid, 285);
			else
			    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes permitido retirar equipo de asalto en este momento!");
		}
		case 5: if(PlayerInfo[playerid][pRank] == 1) SetPlayerSkin(playerid, 61);
	}

	if(item > 0) {
		PlayerInfo[playerid][pJobSkin] = GetPlayerSkin(playerid); 
	} else {
		PlayerInfo[playerid][pJobSkin] = 0;
	}

    PlayerActionMessage(playerid, 15.0, "toma ropa del casillero y se la viste.");
	return 1;
}

CMD:gcomer(playerid, params[])
{
	new string[128];

	if(PlayerInfo[playerid][pFaction] != FAC_SIDE)
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, " ¡No perteneces a la gendarmería!");
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, -492.45, -515.54, 4217.67))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en el comedor de la gendarmería!");
	if(PlayerInfo[playerid][pHunger] > 20 && PlayerInfo[playerid][pThirst] > 20)
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" ¡Sólo puedes comer en los horarios asignados! (( Cuando tengas menos de 20 hambre/sed ))");

	format(string, sizeof(string), "El cocinero llena la bandeja de %s con la comida del día y unos cubiertos.", GetPlayerCleanName(playerid));
	PlayerDoMessage(playerid, 15.0, string);
	PlayerActionMessage(playerid, 15.0, "toma su bandeja con ambas manos.");
	BN_PlayerDrink(playerid, 100);
	BN_PlayerEat(playerid, 100);
	return 1;
}

CMD:gservicio(playerid, params[])
{
	new string[128];

    if(PlayerInfo[playerid][pFaction] != FAC_SIDE)
		return 1;
	    
	if(SIDEDuty[playerid] == 0)
	{

		SIDEDuty[playerid] = 1;
		format(string, sizeof(string), "[GENDARMERÍA] %s se encuentra ahora en servicio.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_SIDE, COLOR_PMA, string);
	}
	else
	{
		EndPlayerDuty(playerid);
		format(string, sizeof(string), "[GENDARMERÍA] %s se ha retirado de servicio.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_SIDE, COLOR_PMA, string);
		Item_ApplyHandlingCooldown(playerid);
	}
	return 1;
}

CMD:alacran(playerid, params[])
{
	new toggle,
	    string[128];

    if(PlayerInfo[playerid][pFaction] != FAC_SIDE)
		return 1;
    if(PlayerInfo[playerid][pRank] != 1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el rango suficiente.");
    if(SIDEDuty[playerid] != 1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio.");
    if(sscanf(params, "i", toggle))
	{
	    SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/alacran [0-1]");
	    switch(STARS)
		{
	        case 0: SendClientMessage(playerid, COLOR_WHITE, "Estado ALACRAN: {D40000}desautorizado");
	        case 1: SendClientMessage(playerid, COLOR_WHITE, "Estado ALACRAN: {00D41C}autorizado");
	    }
	}
	else if(toggle == 1 && STARS != 1)
	{
	    format(string, sizeof(string), "[GENDARMERíA]  ¡Atención! el equipo de asalto ha sido autorizado por %s.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_SIDE, COLOR_PMA, string);
        STARS = 1;
	}
	else if(toggle == 0 && STARS != 0)
	{
	    format(string, sizeof(string), "[GENDARMERíA]  ¡Atención! el equipo de asalto ha sido desautorizado por %s.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_SIDE, COLOR_PMA, string);
        STARS = 0;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/alacran [0-1]");
	    switch(STARS)
		{
	        case 0: SendClientMessage(playerid, COLOR_WHITE, "Estado ALACRAN: {D40000}desautorizado");
	        case 1: SendClientMessage(playerid, COLOR_WHITE, "Estado ALACRAN: {00D41C}autorizado");
	    }
	}
	return 1;
}


CMD:porton(playerid, params[]) {
    if(PlayerInfo[playerid][pFaction] != FAC_SIDE) return 1;

	if(IsPlayerInRangeOfPoint(playerid, 15.0, 1286.0300, -1652.1801, 14.3000)) {
		if(SIDEGate[0] <= 0) {
		    SIDEGate[0] = 1;
			MoveObject(SIDEGate[1], 1286.31, -1654.82, 22.28, 1, 0.00, 0.00, 0.00);
			MoveObject(SIDEGate[2], 1286.30, -1645.22, 25.77, 1, 0.00, 0.00, 0.00);
			MoveObject(SIDEGate[3], 1286.32, -1645.22, 22.28, 1, 0.00, 0.00, 0.00);
			MoveObject(SIDEGate[4], 1286.28, -1654.82, 25.75, 1, 0.00, 0.00, 0.00);
			MoveObject(SIDEGate[5], 1286.30, -1654.10, 25.87, 1, 180.00, 0.00, 90.00);
			MoveObject(SIDEGate[6], 1286.30, -1642.65, 25.87, 1, 180.00, 0.00, 90.00);
			SIDEGateTimer = SetTimer("CloseSIDEGate", 1000 * 60 * 5, false);
		} else {
		    SIDEGate[0] = 0;
			MoveObject(SIDEGate[1], 1286.31, -1654.82, 14.28, 1, 0.00, 0.00, 0.00);
			MoveObject(SIDEGate[2], 1286.30, -1645.22, 17.77, 1, 0.00, 0.00, 0.00);
			MoveObject(SIDEGate[3], 1286.32, -1645.22, 14.28, 1, 0.00, 0.00, 0.00);
			MoveObject(SIDEGate[4], 1286.28, -1654.82, 17.75, 1, 0.00, 0.00, 0.00);
			MoveObject(SIDEGate[5], 1286.30, -1654.10, 17.87, 1, 180.00, 0.00, 90.00);
			MoveObject(SIDEGate[6], 1286.30, -1642.65, 17.87, 1, 180.00, 0.00, 90.00);
			KillTimer(SIDEGateTimer);
		}
		PlayerActionMessage(playerid, 15.0, "toma el mando a distancia del portón y presiona un botón.");
	}
	return 1;
}*/

// GNA 1.2.7

#if defined _marp_gen_included
	#endinput
#endif
#define _marp_gen_included

//new SIDEGateTimer;
new STARS;

enum e_GroperoDlgTable {
	e_gdt_maxrank,
	e_gdt_skin,
	e_gdt_desc[36]
}

static const GroperoDlgTable[][e_GroperoDlgTable] = {
	{20, 3, "Civil\n"},
	{10, 282, "Oficial Masculino (1)\n"},
	{10, 283, "Oficial Masculino (2)\n"},
	{10, 288, "Oficial Masculino (3)\n"},
	{10, 302, "Oficial Masculino (4)\n"},
	{10, 310, "Oficial Masculino (5)\n"},
	{10, 311, "Oficial Masculino (6)\n"},
	{10, 309, "Oficial Femenino\n"},
	{10, 167, "Unidad Canina (1)\n"},
	{10, 284, "GOMF (Antidisturbios)\n"},
	{6, 287, "Operaciones Especiales (Alacrán)\n"},
	{4, 286, "División de Investigaciones\n"}
};

Dialog:DLG_GROPERO_CMD(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 0;
	if(PlayerInfo[playerid][pRank] > GroperoDlgTable[listitem][e_gdt_maxrank] || (DOEM != 1 && listitem == 13))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu rango no tiene acceso a esa vestimenta.");

	if(listitem == 0)
	{
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		PlayerInfo[playerid][pJobSkin] = 0;
		PlayerCmeMessage(playerid, 15.0, 4000, "Deja su uniforme y toma su vestimenta de civil de los casilleros.");
	}
	else
	{
		PlayerInfo[playerid][pJobSkin] = GroperoDlgTable[listitem][e_gdt_skin];
		SetPlayerSkin(playerid, GroperoDlgTable[listitem][e_gdt_skin]);
		PlayerCmeMessage(playerid, 15.0, 4000, "Toma su placa y uniforme de los casilleros.");
	}

	return 1;
}

CMD:gropero(playerid, params[])
{
	if(!isPlayerSideOnDuty(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio para usar este comando.");
	
	new equipid = EquipmentPoint_GetId(playerid);   
	if(!EquipmentPoint_IsPlayerAt(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes usar este comando en cualquier lado. Debes estar en los casilleros.");
	if(!EquipmentPoint_CanPlayerUse(playerid, equipid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un casillero de tu faccion.");
	
	new gropero_str[32 * sizeof(GroperoDlgTable)];

	for(new i = 0, size = sizeof(GroperoDlgTable); i < size; i++) {
		strcat(gropero_str, GroperoDlgTable[i][e_gdt_desc]);
	}
	
	Dialog_Show(playerid, DLG_GROPERO_CMD, DIALOG_STYLE_LIST, "Selecciona la vestimenta a equipar:", gropero_str, "Aceptar", "Cerrar");
	return 1;
}

CMD:gservicio(playerid, params[])
{
	new string[128];

    if(PlayerInfo[playerid][pFaction] != FAC_SIDE)
		return 1;
	    
	if(SIDEDuty[playerid] == 0)
	{
		SIDEDuty[playerid] = 1;
		format(string, sizeof(string), "[CENTRAL] %s inicia su día de servicio como oficial de policía.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_SIDE, COLOR_PMA, string);
		SendClientMessage(playerid, COLOR_WHITE, "Ahora te encuentras en servicio.");
	}
	else
	{
		format(string, sizeof(string), "[CENTRAL] %s termina su día de servicio como oficial de policía.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_SIDE, COLOR_PMA, string);
		EndPlayerDuty(playerid);
	}
	return 1;
}

CMD:alacran(playerid, params[])
{
	new toggle,
	    string[128];

    if(PlayerInfo[playerid][pFaction] != FAC_SIDE)
		return 1;
    if(PlayerInfo[playerid][pRank] != 1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el rango suficiente.");
    if(SIDEDuty[playerid] != 1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio.");
    if(sscanf(params, "i", toggle))
	{
	    SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/alacran [0-1]");
	    switch(STARS)
		{
	        case 0: SendClientMessage(playerid, COLOR_WHITE, "Estado ALACRAN: {D40000}desautorizado");
	        case 1: SendClientMessage(playerid, COLOR_WHITE, "Estado ALACRAN: {00D41C}autorizado");
	    }
	}
	else if(toggle == 1 && STARS != 1)
	{
	    format(string, sizeof(string), "[GENDARMERíA]  ¡Atención! el equipo de asalto ha sido autorizado por %s.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_SIDE, COLOR_PMA, string);
        STARS = 1;
	}
	else if(toggle == 0 && STARS != 0)
	{
	    format(string, sizeof(string), "[GENDARMERíA]  ¡Atención! el equipo de asalto ha sido desautorizado por %s.", GetPlayerCleanName(playerid));
		SendFactionMessage(FAC_SIDE, COLOR_PMA, string);
        STARS = 0;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/alacran [0-1]");
	    switch(STARS)
		{
	        case 0: SendClientMessage(playerid, COLOR_WHITE, "Estado ALACRAN: {D40000}desautorizado");
	        case 1: SendClientMessage(playerid, COLOR_WHITE, "Estado ALACRAN: {00D41C}autorizado");
	    }
	}
	return 1;
}

CMD:gcentral(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != FAC_SIDE || PlayerInfo[playerid][pRank] == 10)
		return 1;

	new inputtext[128];

	if(sscanf(params, "s[128]", inputtext))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/gcentral [texto]");

	new outputtext[160];
	format(outputtext, sizeof(outputtext), "[%i] [CENTRAL]: %s ", playerid, inputtext);
	SendFactionRadioMessage(FAC_SIDE, COLOR_RADIO, outputtext);
	return 1;
}
