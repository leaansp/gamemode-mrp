#if defined _marp_descripcionyo_included
#endinput
#endif 
#define _marp_descripcionyo_included

// Variables para heridas (mantener compatibilidad con sistema de heridas)
new Text3D:descLabel[MAX_PLAYERS],
	bool:descActive[MAX_PLAYERS],
	bool:descWound[MAX_PLAYERS],
	ReplenishDescTimer[MAX_PLAYERS];

// Variables para sistema /mirar
new Text3D:lookingLabel[MAX_PLAYERS],
	bool:isLookingActive[MAX_PLAYERS],
	lookingTimer[MAX_PLAYERS];
	
stock ResetDescVariables(playerid)
{
    PlayerInfo[playerid][pDescription][0] = EOS;
    descActive[playerid] = false;
	descWound[playerid] = false;
	
	// Reset variables de /mirar
	if(isLookingActive[playerid])
	{
		DestroyDynamic3DTextLabel(lookingLabel[playerid]);
		isLookingActive[playerid] = false;
	}
	if(lookingTimer[playerid])
	{
		KillTimer(lookingTimer[playerid]);
		lookingTimer[playerid] = 0;
	}
}

stock bool:HasPlayerDesc(playerid)
{
	return (strlen(PlayerInfo[playerid][pDescription]) > 0);
}

stock ResetDescLabel(playerid)
{
	// Solo usado para heridas, mantener para compatibilidad
	if(descActive[playerid])
		DestroyDynamic3DTextLabel(descLabel[playerid]);
}

forward ReplenishDesc(playerid);
public ReplenishDesc(playerid)
{
	// Solo para sistema de heridas
	if(!descActive[playerid] && descWound[playerid])
	{
		// Lógica de heridas aquí si es necesario
		descActive[playerid] = true;
	}
	return 1;
}

stock HidePlayerDesc(playerid, time)
{
	// Solo para sistema de heridas
    DestroyDynamic3DTextLabel(descLabel[playerid]);
    descActive[playerid] = false;
    ReplenishDescTimer[playerid] = SetTimerEx("ReplenishDesc", time, false, "i", playerid);
}

// Timer para ocultar descripción después de /mirar
forward HideLookingDesc(playerid);
public HideLookingDesc(playerid)
{
	if(isLookingActive[playerid])
	{
		DestroyDynamic3DTextLabel(lookingLabel[playerid]);
		isLookingActive[playerid] = false;
	}
	lookingTimer[playerid] = 0;
	return 1;
}

CMD:descripcion(playerid, params[]) 
{ 
	new desc[70];
	    
	if(sscanf(params, "s[70]", desc))
	{
		if(strlen(PlayerInfo[playerid][pDescription]) > 0)
		{
			new str[180];
			format(str, sizeof(str), "Tu descripción actual: {FFD700}%s{FFFFFF}. Usa /descripcion [texto] para cambiarla o /borrardesc para eliminarla.", PlayerInfo[playerid][pDescription]);
			return SendClientMessage(playerid, COLOR_WHITE, str);
		}
		else
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/descripcion [texto] (hasta 65 caracteres)");
	}
	
	if(strlen(desc) > 65)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La descripción es demasiada larga, ingresa una más corta. (MAX 65 CARACTERES)");

	// Guardar en memoria (se guardará en BD con SaveAccount)
	format(PlayerInfo[playerid][pDescription], 70, "%s", desc);
	
	new str[180];
	format(str, sizeof(str), "Tu nueva descripción: {FFD700}%s{FFFFFF}. Se guardará automáticamente. Otros jugadores podrán verla con /mirardesc.", PlayerInfo[playerid][pDescription]);
	SendClientMessage(playerid, COLOR_WHITE, str);
	return 1;
}

CMD:borrardesc(playerid, params[])
{
	if(strlen(PlayerInfo[playerid][pDescription]) == 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes ninguna descripción activa.");

	PlayerInfo[playerid][pDescription][0] = EOS;
	
	SendClientMessage(playerid, COLOR_WHITE, "Has borrado tu descripción. Para escribir una nueva usa /descripcion [texto].");
	return 1;
}

CMD:mirardesc(playerid, params[])
{
	new targetid = INVALID_PLAYER_ID;
	new name[64];

	// Try numeric ID first
	if(sscanf(params, "u", targetid) == 0)
	{
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_YELLOW2, "Ese jugador no está conectado.");
	}
	else
	{
		// Try name lookup (exact, case-insensitive)
		if(sscanf(params, "s[64]", name) != 0)
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mirardesc [ID/Jugador]");

		// Search connected players for exact name match
		new pname[MAX_PLAYER_NAME];
		for(new i = 0; i < MAX_PLAYERS; i++) {
			if(!IsPlayerConnected(i)) continue;
			GetPlayerName(i, pname, sizeof(pname));
			// Fallback safe case-insensitive compare to avoid potential compiler issues
			new lpname[MAX_PLAYER_NAME], lname[64];
			strcopy(lpname, pname, sizeof(lpname));
			strcopy(lname, name, sizeof(lname));
			for(new k = 0; lpname[k] != '\0'; k++) lpname[k] = tolower(lpname[k]);
			for(new k2 = 0; lname[k2] != '\0'; k2++) lname[k2] = tolower(lname[k2]);
			if(strcmp(lpname, lname) == 0) { targetid = i; break; }
		}

		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_YELLOW2, "Ese jugador no está conectado.");
	}
	
	if(targetid == playerid)
	{
		if(strlen(PlayerInfo[playerid][pDescription]) > 0)
		{
			new str[140];
			format(str, sizeof(str), "Tu descripción: {FFD700}%s", PlayerInfo[playerid][pDescription]);
			return SendClientMessage(playerid, COLOR_WHITE, str);
		}
		else
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una descripción establecida. Usa /descripcion [texto] para crearla.");
	}
	
	// Verificar distancia (15 metros)
	if(!IsPlayerInRangeOfPlayer(playerid, targetid, 15))
		return SendClientMessage(playerid, COLOR_YELLOW2, "Ese jugador está muy lejos para mirarlo.");
	
	// Verificar mismo interior y virtual world
	if(GetPlayerInterior(playerid) != GetPlayerInterior(targetid) || GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes ver a ese jugador.");
	
	if(strlen(PlayerInfo[targetid][pDescription]) > 0)
	{
		// Si ya tiene un label activo, destruirlo y matar el timer
		if(isLookingActive[playerid])
		{
			DestroyDynamic3DTextLabel(lookingLabel[playerid]);
			if(lookingTimer[playerid])
			{
				KillTimer(lookingTimer[playerid]);
				lookingTimer[playerid] = 0;
			}
		}
		
		// Crear nuevo label 3D temporal sobre el jugador mirado
		lookingLabel[playerid] = CreateDynamic3DTextLabel(
			PlayerInfo[targetid][pDescription],
			COLOR_YO_DESC,
			0.0, 0.0, 0.3,
			15.0,
			targetid,
			INVALID_VEHICLE_ID,
			0,
			-1,
			-1,
			playerid,
			15.0
		);
		
		isLookingActive[playerid] = true;
		
		// Timer para ocultar después de 10 segundos
		lookingTimer[playerid] = SetTimerEx("HideLookingDesc", 10000, false, "i", playerid);
		
		new targetName[MAX_PLAYER_NAME], str[180];
		GetPlayerName(targetid, targetName, sizeof(targetName));
		format(str, sizeof(str), "* Miras a %s y ves: {FFD700}%s", targetName, PlayerInfo[targetid][pDescription]);
		SendClientMessage(playerid, COLOR_PURPLE, str);
		format(str, sizeof(str), "* %s te está mirando.", GetPlayerNameEx(playerid));
		SendClientMessage(targetid, COLOR_PURPLE, str);
	}
	else
	{
		SendClientMessage(playerid, COLOR_YELLOW2, "Ese jugador no tiene una descripción establecida.");
	}
	
	return 1;
}

// Comando legacy para compatibilidad
CMD:yo(playerid, params[]) 
{
	return cmd_descripcion(playerid, params);
}

CMD:yob(playerid, params[])
{
	return cmd_borrardesc(playerid, params);
}

CMD:yodebug(playerid, params[])
{
	new targetid, param;

	if(sscanf(params, "ui", targetid, param))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/yodebug [ID/Jugador] [descActive (0 = true - 1 = false)]");
	if(param != 0 && param != 1)
	    return 1;
		
	if(param == 0)
		descActive[targetid] = true;
	else {
		DestroyDynamic3DTextLabel(descLabel[targetid]);
		ResetDescVariables(playerid);
	}
	return 1;
}


