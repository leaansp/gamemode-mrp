#if defined _marp_gangzones_included
	#endinput
#endif
#define _marp_gangzones_included

#define MAX_GANGZONES           16

#define GANGZONE_CAPTURE_TIME   (600) // En segundos, 10 min. Lo que tienen que mantenerse dentro para capturarlo.
#define GANGZONE_CAPTURE_UPDATE (5) // En segundos, cada cuanto actualiza el sistema mientras están en guerra.
#define GANGZONE_REDISPUTE_TIME (18000) // En segundos, 8 horas. Tiempo hasta que un barrio pueda ser recapturado.
#define GANGZONE_HOLDING_TIME   (86400) // En segundos, 24 horas. Tiempo máximo que puede mantener una faccion el dominio.

//NEW
#define GANGZONE_MAFIA17			0
#define GANGZONE_VILLA_FIERRO		1
#define GANGZONE_FUERTE_UNION		2
#define GANGZONE_SEVILLE_CORTADA	3
#define GANGZONE_ALTE_BROWN			4
#define GANGZONE_GANTON				5
#define GANGZONE_VILLA_CORONA		6
#define GANGZONE_FTE_VILLA_CORONA	7
#define GANGZONE_LOS_PUENTES		8
#define GANGZONE_CLAYPOLE			9
#define GANGZONE_LAS_CANCHITAS		10
#define GANGZONE_GLEN_PARK			11
#define GANGZONE_NUNEZ				12
#define GANGZONE_LAS_COLINAS		13
#define GANGZONE_EAST_LS			14
#define GANGZONE_SOUTH_SKATE_PARK	15

enum GangZoneInfo {
	gzID,
	gzFaction,
	gzDisputed
};

new GangZone[MAX_GANGZONES][GangZoneInfo];
new GangZoneWarCountdownTimer[MAX_GANGZONES];
new GangZoneWarCountdown[MAX_GANGZONES];
new GangZoneWarEndTimer[MAX_GANGZONES];
new IsFactionTakingGangZone[MAX_FACTIONS];
new EndGangZoneHoldingFactionTimer[MAX_GANGZONES];

CMD:tomarbarrio(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], gangzonefaction, gangzone, cont1 = 0, cont2 = 0;

	if(!Faction_IsValidId(faction))
        return 1;
 	if(!Faction_HasTag(faction, FAC_TAG_ALLOW_GANGZONE))
	 	return 1;
	if(PlayerInfo[playerid][pRank] != 1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para iniciar la toma de un barrio debes ser el líder de la facción.");
	if(IsFactionTakingGangZone[faction] == 1)
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu facción ya está tomando un barrio en estos momentos.");
	gangzone = GetPlayerGangZone(playerid);
	if(gangzone == -1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás en ningún barrio de conflicto.");
	gangzonefaction = GangZone[gangzone][gzFaction];
	if(gangzonefaction == faction)
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Esta zona ya se encuentra bajo tu dominio.");
    if(GangZone[gangzone][gzDisputed] == 1)
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Este barrio ha estado en disputa hace poco tiempo, espera un tiempo para reclamarlo.");

	foreach(new i : Player)
	{
		if(gangzonefaction != 0 && PlayerInfo[i][pFaction] == gangzonefaction)
	    	cont1 ++;
		else
	        if(PlayerInfo[i][pFaction] == faction)
			{
	 		    if(GetPlayerGangZone(i) == gangzone)
	   				cont2 ++;
			}
	}
 	if(gangzonefaction != 0 && cont1 < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debe haber al menos dos integrantes conectados de la facción que domina este barrio.");
	if(cont2 < 4)
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Deben ser al menos cuatro personas de la facción para tomar un barrio.");

    foreach(new i : Player)
	{
	    if(PlayerInfo[i][pFaction] == faction)
	    {
	        SendFMessage(i, COLOR_INFO, "[DISPUTA] "COLOR_EMB_GREY" %s ha iniciado una toma de un barrio. Se marcará y titilará en el mapa hasta que termine.", GetPlayerCleanName(playerid));
			GangZoneFlashForPlayer(i, GangZone[gangzone][gzID], 0xFFFFFF77);
		} else
		    if(gangzonefaction != 0 && PlayerInfo[i][pFaction] == gangzonefaction)
 	    	{
		        SendClientMessage(i, COLOR_INFO, "[DISPUTA] "COLOR_EMB_GREY" Están tomando nuestro barrio. Se marcará y titilará en el mapa hasta que termine.");
				GangZoneFlashForPlayer(i, GangZone[gangzone][gzID], 0xFFFFFF77);
			}
	}
	GangZone[gangzone][gzDisputed] = 1;
	IsFactionTakingGangZone[faction] = 1;
	SetTimerEx("EnableGangZoneDispute", GANGZONE_REDISPUTE_TIME * 1000, false, "i", gangzone);
	GangZoneWarCountdownTimer[gangzone] = SetTimerEx("GangZoneWar", GANGZONE_CAPTURE_UPDATE * 1000, true, "ii", gangzone, faction);
	return 1;
}

forward EndGangZoneHoldingFaction(gangzone);
public EndGangZoneHoldingFaction(gangzone)
{
	GangZone[gangzone][gzFaction] = 0;
	foreach(new playerid : Player)
	{
		if(Faction_IsValidId(PlayerInfo[playerid][pFaction]) && Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_ALLOW_GANGZONE))
		{
			HideGangZonesToPlayer(playerid);
			ShowGangZonesToPlayer(playerid); // Para actualizarlo a color gris, es decir, a barrio sin dueño
		}
	}
	return 1;
}

forward EnableGangZoneDispute(gangzone);
public EnableGangZoneDispute(gangzone)
{
	GangZone[gangzone][gzDisputed] = 0;
	return 1;
}

forward GangZoneWar(gangzone, faction);
public GangZoneWar(gangzone, faction)
{
	new cont = 0;

	foreach(new playerid : Player)
	{
 		if(PlayerInfo[playerid][pFaction] == faction)
		{
	 		if(GetPlayerGangZone(playerid) == gangzone)
	 		{
				if(GetPlayerHealthEx(playerid) > 25.0) {
	   				cont ++;
				}
			}
		}
	}
 	if(cont < 2 && GangZoneWarEndTimer[gangzone] == 0)
 	{
 		SendFactionMessage(faction, COLOR_INFO, "[DISPUTA] "COLOR_EMB_GREY" Se necesita más gente dentro de la zona o perderán el barrio en 45 segundos.");
		GangZoneWarEndTimer[gangzone] = SetTimerEx("EndGangZoneWar", 45 * 1000, false, "iii", gangzone, faction, 2);
	} else
		if(cont >= 2 && GangZoneWarEndTimer[gangzone] != 0)
		{
 			SendFactionMessage(faction, COLOR_INFO, "[DISPUTA] "COLOR_EMB_GREY" ¡Bien! Seguimos con la toma del barrio.");
 			KillTimer(GangZoneWarEndTimer[gangzone]);
 			GangZoneWarEndTimer[gangzone] = 0;
		}

	GangZoneWarCountdown[gangzone] += 5;
	if(GangZoneWarCountdown[gangzone] >= GANGZONE_CAPTURE_TIME)
	{
	    if(cont >= 2)
	    	EndGangZoneWar(gangzone, faction, 1);
		else
	        EndGangZoneWar(gangzone, faction, 2);
	}
	return 1;
}

forward EndGangZoneWar(gangzone, faction, endingtype);
public EndGangZoneWar(gangzone, faction, endingtype)
{
	KillTimer(GangZoneWarCountdownTimer[gangzone]);
	KillTimer(GangZoneWarEndTimer[gangzone]);
	GangZoneWarCountdownTimer[gangzone] = 0;
	GangZoneWarCountdown[gangzone] = 0;
	GangZoneWarEndTimer[gangzone] = 0;
	IsFactionTakingGangZone[faction] = 0;
	new defenderfaction = GangZone[gangzone][gzFaction];
	switch(endingtype)
	{
	    case 1:
	    {
	        GangZone[gangzone][gzFaction] = faction;
			foreach(new playerid : Player)
			{
				if(defenderfaction != 0 && PlayerInfo[playerid][pFaction] == defenderfaction)
				{
			    	SendClientMessage(playerid, COLOR_INFO, "[DISPUTA] "COLOR_EMB_GREY" Hemos perdido el control del barrio.");
			    	GangZoneStopFlashForPlayer(playerid, GangZone[gangzone][gzID]);
			    	HideGangZonesToPlayer(playerid);
			    	ShowGangZonesToPlayer(playerid); // Para actualizarlo con el nuevo color de la nueva faccion
				}
				else
			        if(PlayerInfo[playerid][pFaction] == faction)
			        {
                        SendClientMessage(playerid, COLOR_INFO, "[DISPUTA] "COLOR_EMB_GREY" ¡Bien, el barrio es nuestro! Debemos mantenerlo bajo control y nos dará buen dinero.");
                        GangZoneStopFlashForPlayer(playerid, GangZone[gangzone][gzID]);
                        HideGangZonesToPlayer(playerid);
                        ShowGangZonesToPlayer(playerid); // Para actualizarlo con el nuevo color de la nueva faccion
                        if(EndGangZoneHoldingFactionTimer[gangzone] != 0)
                            KillTimer(EndGangZoneHoldingFactionTimer[gangzone]);
                       	SetTimerEx("EndGangZoneHoldingFaction", GANGZONE_HOLDING_TIME * 1000, false, "i", gangzone);
					}
			}
		}
		case 2:
	    {
			foreach(new playerid : Player)
			{
				if(defenderfaction != 0 && PlayerInfo[playerid][pFaction] == defenderfaction)
				{
			    	SendClientMessage(playerid, COLOR_INFO, "[DISPUTA] "COLOR_EMB_GREY" ¡Bien, hemos defendido el barrio con éxito y sigue siendo nuestro!");
                    GangZoneStopFlashForPlayer(playerid, GangZone[gangzone][gzID]);
                    if(EndGangZoneHoldingFactionTimer[gangzone] != 0)
                    	KillTimer(EndGangZoneHoldingFactionTimer[gangzone]);
                   	SetTimerEx("EndGangZoneHoldingFaction", GANGZONE_HOLDING_TIME * 1000, false, "i", gangzone);
				}
				else
			        if(PlayerInfo[playerid][pFaction] == faction)
			        {
                        SendClientMessage(playerid, COLOR_INFO, "[DISPUTA] "COLOR_EMB_GREY" La disputa se ha acabado, no hemos podido tomar el barrio.");
                        GangZoneStopFlashForPlayer(playerid, GangZone[gangzone][gzID]);
					}
			}
		}
	}
	return 1;
}

stock HideGangZonesToPlayer(playerid)
{
    for(new i = 0; i < MAX_GANGZONES; i++)
    {
        GangZoneHideForPlayer(playerid, GangZone[i][gzID]);
	}
	return 1;
}

stock ShowGangZonesToPlayer(playerid)
{
	for(new i = 0; i < MAX_GANGZONES; i++)
	{
		switch(GangZone[i][gzFaction])
		{
		    case 0: GangZoneShowForPlayer(playerid,  GangZone[i][gzID], 0x99999977);
			case 11: GangZoneShowForPlayer(playerid, GangZone[i][gzID], 0x0000FF77);
			case 12: GangZoneShowForPlayer(playerid, GangZone[i][gzID], 0x00FF0077);
			case 13: GangZoneShowForPlayer(playerid, GangZone[i][gzID], 0xFF000077);
			case 14: GangZoneShowForPlayer(playerid, GangZone[i][gzID], 0xFFFF0077);
			case 15: GangZoneShowForPlayer(playerid, GangZone[i][gzID], 0x00FFFF77);
			default: GangZoneShowForPlayer(playerid, GangZone[i][gzID], 0x99999977);
		}
	}
	return 1;
}

stock LoadGangZones()
{
	GangZone[GANGZONE_MAFIA17][gzID] = 			GangZoneCreate(1822.00, -1618.00, 2038.00, -1519.00);
	GangZone[GANGZONE_VILLA_FIERRO][gzID] = 	GangZoneCreate(1954.00, -1928.00, 2079.00, -1759.00);
	GangZone[GANGZONE_FUERTE_UNION][gzID] = 	GangZoneCreate(2416.00, -2035.00, 2553.00, -1821.00);
	GangZone[GANGZONE_SEVILLE_CORTADA][gzID] = 	GangZoneCreate(2621.00, -2039.00, 2817.00, -1883.00);
	GangZone[GANGZONE_ALTE_BROWN][gzID] = 		GangZoneCreate(2223.00, -1842.00, 2407.00, -1745.00);
	GangZone[GANGZONE_GANTON][gzID] = 			GangZoneCreate(2352.00, -1725.00, 2558.00, -1621.00);
	GangZone[GANGZONE_VILLA_CORONA][gzID] = 	GangZoneCreate(1562.75, -2184.25, 1811.75, -2076.25);
	GangZone[GANGZONE_FTE_VILLA_CORONA][gzID] = GangZoneCreate(1828.25, -2156.76, 1953.25, -1945.76);
	GangZone[GANGZONE_LOS_PUENTES][gzID] = 		GangZoneCreate(2049.23, -1738.73, 2203.23, -1553.73);
	GangZone[GANGZONE_CLAYPOLE][gzID] = 		GangZoneCreate(2203.24, -1964.76, 2405.24, -1862.76);
	GangZone[GANGZONE_LAS_CANCHITAS][gzID] = 	GangZoneCreate(2218.23, -1551.72, 2338.23, -1395.72);
	GangZone[GANGZONE_GLEN_PARK][gzID] = 		GangZoneCreate(1864.21, -1252.23, 2059.21, -1056.23);
	GangZone[GANGZONE_NUNEZ][gzID] = 			GangZoneCreate(1986.23, -1052.24, 2298.23, -944.24);
	GangZone[GANGZONE_LAS_COLINAS][gzID] = 		GangZoneCreate(2339.23, -1145.71, 2633.23, -935.71);
	GangZone[GANGZONE_EAST_LS][gzID] = 			GangZoneCreate(2378.19, -1432.71, 2521.19, -1261.71);
	GangZone[GANGZONE_SOUTH_SKATE_PARK][gzID] =	GangZoneCreate(2079.25, -1374.75, 2262.25, -1229.75);
	return 1;
}

stock GetPlayerGangZone(playerid)
{
	new Float:px, Float:py, Float:pz;

	if(GetPlayerVirtualWorld(playerid) != 0)
		return -1;

	GetPlayerPos(playerid, px, py, pz);

	if(1822.00 <= px <= 2038.00 && -1618.00 <= py <= -1519.00) return GANGZONE_MAFIA17;
	if(1954.00 <= px <= 2079.00 && -1928.00 <= py <= -1759.00) return GANGZONE_VILLA_FIERRO;
	if(2416.00 <= px <= 2553.00 && -2035.00 <= py <= -1821.00) return GANGZONE_FUERTE_UNION;
	if(2621.00 <= px <= 2817.00 && -2039.00 <= py <= -1883.00) return GANGZONE_SEVILLE_CORTADA;
	if(2223.00 <= px <= 2407.00 && -1842.00 <= py <= -1745.00) return GANGZONE_ALTE_BROWN;
	if(2352.00 <= px <= 2558.00 && -1725.00 <= py <= -1621.00) return GANGZONE_GANTON;
	if(1562.75 <= px <= 1811.75 && -2184.25 <= py <= -2076.25) return GANGZONE_VILLA_CORONA;
	if(1828.25 <= px <= 1953.25 && -2156.76 <= py <= -1945.76) return GANGZONE_FTE_VILLA_CORONA;
	if(2049.23 <= px <= 2203.23 && -1738.73 <= py <= -1553.73) return GANGZONE_LOS_PUENTES;
	if(2203.24 <= px <= 2405.24 && -1964.76 <= py <= -1862.76) return GANGZONE_CLAYPOLE;
	if(2218.23 <= px <= 2338.23 && -1551.72 <= py <= -1395.72) return GANGZONE_LAS_CANCHITAS;
	if(1864.21 <= px <= 2059.21 && -1252.23 <= py <= -1056.23) return GANGZONE_GLEN_PARK;
	if(1986.23 <= px <= 2298.23 && -1052.24 <= py <= -944.24) return GANGZONE_NUNEZ;
	if(2339.23 <= px <= 2633.23 && -1145.71 <= py <= -935.71) return GANGZONE_LAS_COLINAS;
	if(2378.19 <= px <= 2521.19 && -1432.71 <= py <= -1261.71) return GANGZONE_EAST_LS;
	if(2079.25 <= px <= 2262.25 && -1374.75 <= py <= -1229.75) return GANGZONE_SOUTH_SKATE_PARK;

	return -1;
}

stock GetGangZoneLiderIncome(playerid)
{
	new income = 0;
 	for(new i = 0; i < MAX_GANGZONES; i++)
	{
		if(GangZone[i][gzFaction] == PlayerInfo[playerid][pFaction])
		{
			income += 500;
		}
	}
	return income;
}

stock DestroyGangZones()
{
	GangZoneDestroy(GangZone[GANGZONE_MAFIA17][gzID]);
	GangZoneDestroy(GangZone[GANGZONE_VILLA_FIERRO][gzID]);
	GangZoneDestroy(GangZone[GANGZONE_FUERTE_UNION][gzID]);
	GangZoneDestroy(GangZone[GANGZONE_SEVILLE_CORTADA][gzID]);
	GangZoneDestroy(GangZone[GANGZONE_ALTE_BROWN][gzID]);
	GangZoneDestroy(GangZone[GANGZONE_GANTON][gzID]);
	GangZoneDestroy(GangZone[GANGZONE_VILLA_CORONA][gzID]);
 	GangZoneDestroy(GangZone[GANGZONE_FTE_VILLA_CORONA][gzID]);
 	GangZoneDestroy(GangZone[GANGZONE_LOS_PUENTES][gzID]);
 	GangZoneDestroy(GangZone[GANGZONE_CLAYPOLE][gzID]);
 	GangZoneDestroy(GangZone[GANGZONE_LAS_CANCHITAS][gzID]);
 	GangZoneDestroy(GangZone[GANGZONE_GLEN_PARK][gzID]);
 	GangZoneDestroy(GangZone[GANGZONE_NUNEZ][gzID]);
 	GangZoneDestroy(GangZone[GANGZONE_LAS_COLINAS][gzID]);
 	GangZoneDestroy(GangZone[GANGZONE_EAST_LS][gzID]);
 	GangZoneDestroy(GangZone[GANGZONE_SOUTH_SKATE_PARK][gzID]);
	return 1;
}
