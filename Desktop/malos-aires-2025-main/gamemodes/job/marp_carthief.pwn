#if defined marp_carthief_inc
	#endinput
#endif
#define marp_carthief_inc

forward FactionMission_OnVehUnlocked(playerid, vehicleid);

#define POS_CAR_DEMOLITION_X 	2168.194335
#define POS_CAR_DEMOLITION_Y	-1982.010253
#define POS_CAR_DEMOLITION_Z 	13.5339

static const STOLEN_CAR_MISSING_TIME = 60; // En minutos, tiempo hasta que vuelva a aparecer una vez desarmado.

static const THIEF_BARRETA_COOLDOWN = 70; // En minutos
static const THIEF_BARRETA_DURATION = 20; // En segundos, duración del robo

static const THIEF_PUENTE_COOLDOWN = 70; // En minutos
static const THIEF_PUENTE_DURATION = 20; // En segundos, duración del robo

static const THIEF_DESARMAR_COOLDOWN = 85; // En minutos

static const THIEF_CAR_THEFT_LEVEL = 5; // Nivel de job al que corresponde

static gThiefCarPlayerTimer[MAX_PLAYERS];

ResetCarThiefCrime(playerid)
{
	if(gThiefCarPlayerTimer[playerid])
	{
		KillTimer(gThiefCarPlayerTimer[playerid]);
		gThiefCarPlayerTimer[playerid] = 0;
		TogglePlayerControllable(playerid, true);
	}
}

CMD:barreta(playerid, params[])
{
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_BARRETA))
		return 1;
	if(!JobThief_LevelCheck(playerid, .felonLevel = THIEF_CAR_THEFT_LEVEL))
		return 1;

	new vehicleid = GetClosestVehicle(playerid, 4.0),
   	    Float:pos[3],
	    location[MAX_ZONE_NAME];

	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE || gThiefCarPlayerTimer[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes hacerlo en este momento!");
	if(IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes forzar una cerradura estando arriba del vehiculo!");
	if(SearchHandsForItem(playerid, ITEM_ID_BARRETA) == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una barreta en alguna de tus manos.");
	if(vehicleid == INVALID_VEHICLE_ID)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estas cerca de ningún vehículo.");
	if(VehicleInfo[vehicleid][VehLocked] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Las puertas están abiertas.");
	if(KeyChain_Contains(playerid, KEY_TYPE_VEHICLE, vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes robar este vehículo!");

  	TogglePlayerControllable(playerid, false);
	PlayerInfo[playerid][pDisabled] = DISABLE_STEALING;
	PlayerCmeMessage(playerid, 15.0, 6000, "Toma una herramienta y comienza a realizar unas maniobras sobre la manija de la puerta del vehículo.");
    GameTextForPlayer(playerid, "Forzando cerradura, aguarda...", 20 * 1000, 4);
	gThiefCarPlayerTimer[playerid] = SetTimerEx("UsarBarreta", THIEF_BARRETA_DURATION * 1000, false, "ii", playerid, vehicleid);
    
    if(random(10) > 4)
    {
		SendClientMessage(playerid, COLOR_WHITE, "Un civil te vió forzando la cerradura y alertó a la policía. ¡Apúrate o te atraparán!");
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);
		foreach(new i : Player)
		{
		    if(isPlayerCopOnDuty(i))
		    {
                SendFMessage(i, COLOR_PMA, "[911] Robo de vehículo reportado en el barrio de %s, modelo %s. Lo marcamos en su GPS.", location, Veh_GetName(vehicleid));
                MapMarker_CreateForPlayer(i, pos[0], pos[1], pos[2], .color = COLOR_CENTRALRED, .time = 300000);
			}
		}
	}
	return 1;
}

forward UsarBarreta(playerid, vehicleid);
public UsarBarreta(playerid, vehicleid)
{
	gThiefCarPlayerTimer[playerid] = 0;
	TogglePlayerControllable(playerid, true);
	PlayerInfo[playerid][pDisabled] = DISABLE_NONE;

	new hand = SearchHandsForItem(playerid, ITEM_ID_BARRETA);

	if(hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una barreta en alguna de tus manos.");

	if(random(10) > 4)
	{
		if(GetHandParam(playerid, hand) == 1) {
			SetHandItemAndParam(playerid, hand, 0, 0);
		} else {
			SetHandItemAndParam(playerid, hand, ITEM_ID_BARRETA, GetHandParam(playerid, hand) - 1);
		}

		SendClientMessage(playerid, COLOR_WHITE, "La barreta cedió y se rompió.");

		// Dejar que el módulo de misiones gestione si el vehículo pertenece a una misión
		// (se maneja dentro de FactionMission_OnVehUnlocked)
	}
	else
	{
		VehicleInfo[vehicleid][VehLocked] = 0;
		CallLocalFunction("FactionMission_OnVehUnlocked", "ii", playerid, vehicleid);
		SendClientMessage(playerid, COLOR_WHITE, "Forzaste con éxito la cerradura.");
		JobThief_GiveLevelExp(playerid, THIEF_CAR_THEFT_LEVEL, 810);
		CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_BARRETA, .seconds = THIEF_BARRETA_COOLDOWN * 60);
		ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/barreta", .playerid=playerid);

		// Notificar al sistema de misiones si este vehicle es objetivo
		CallLocalFunction("FactionMission_OnVehUnlocked", "ii", playerid, vehicleid);
	}
	return 1;
}

CMD:puente(playerid, params[])
{
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_PUENTE))
		return 1;
	if(!JobThief_LevelCheck(playerid, .felonLevel = THIEF_CAR_THEFT_LEVEL))
		return 1;

	new vehicleid = GetPlayerVehicleID(playerid);

	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE || gThiefCarPlayerTimer[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes hacerlo en este momento!");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en el asiento de conductor de un vehículo!");
	GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	if(VehicleInfo[vehicleid][VehEngine] == 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El motor del vehículo ya se encuentra prendido.");
	if(KeyChain_Contains(playerid, KEY_TYPE_VEHICLE, vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes robar este vehículo!");

	TogglePlayerControllable(playerid, false);
	PlayerInfo[playerid][pDisabled] = DISABLE_STEALING;
	PlayerCmeMessage(playerid, 15.0, 6000, "Se inclina hacia abajo en el asiento del conductor y realiza unas maniobras.");
	GameTextForPlayer(playerid, "Desarmando tambor de arranque, aguarda...", 20 * 1000, 4);
	gThiefCarPlayerTimer[playerid] = SetTimerEx("PuenteMotor", THIEF_PUENTE_DURATION * 1000, false, "ii", playerid, vehicleid);
	return 1;
}

forward PuenteMotor(playerid, vehicleid);
public PuenteMotor(playerid, vehicleid)
{
	gThiefCarPlayerTimer[playerid] = 0;
	TogglePlayerControllable(playerid, true);
	PlayerInfo[playerid][pDisabled] = DISABLE_NONE;

	if(random(10) > 4)
	{
		SetEngine(vehicleid, 1);
		SendClientMessage(playerid, COLOR_WHITE, "¡Perfecto! Conectas los cables correctos y el motor enciende. ¡Huye de aquí!");
		JobThief_GiveLevelExp(playerid, THIEF_CAR_THEFT_LEVEL, 810);
		CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_PUENTE, .seconds = THIEF_PUENTE_COOLDOWN * 60);
		ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/puente", .playerid=playerid);
	} else {
		SendClientMessage(playerid, COLOR_WHITE, "Mala suerte, has fallado en tu intento por conectar los cables correctos.");
	}
	return 1;
}

CMD:desarmar(playerid, params[])
{
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_DESARMAR))
		return 1;
	if(!JobThief_LevelCheck(playerid, .felonLevel = THIEF_CAR_THEFT_LEVEL))
		return 1;

	new vehicleid = GetPlayerVehicleID(playerid),
		Float:vehiclehp,
		freehand,
		repuestos;

	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes hacerlo en este momento!");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en el asiento del conductor de un vehículo!");
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, POS_CAR_DEMOLITION_X, POS_CAR_DEMOLITION_Y, POS_CAR_DEMOLITION_Z))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes dirigirte al desarmadero con el vehículo robado.");
	if(VehicleInfo[vehicleid][VehType] != VEH_OWNED)
	    return SendClientMessage(playerid, COLOR_WHITE, "Comprador: Olvídalo, ese vehículo no me interesa. (OOC: Solo puedes desarmar vehículos particulares)");
	if(KeyChain_Contains(playerid, KEY_TYPE_VEHICLE, vehicleid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes desarmar un auto del cual tienes las llaves.");
	freehand = SearchFreeHand(playerid);
	if(freehand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes tus manos ocupadas y no puedes agarrar los repuestos.");

 	GetVehicleHealth(vehicleid, vehiclehp);
    repuestos = floatround(vehiclehp) / ItemModel_GetPrice(ITEM_ID_REPUESTOAUTO) * 4; // Entrega una cantidad de repuestos proporcional al buen estado (hp) del auto
    SetHandItemAndParam(playerid, freehand, ITEM_ID_REPUESTOAUTO, repuestos);
    HideStolenCar(vehicleid);
    PlayerActionMessage(playerid, 15.0, "le entrega el vehículo al empleado del compactador de basura para que lo desarme y demuela.");
    SendFMessage(playerid, COLOR_WHITE, "Comprador: Bien, aquí tienes %d piezas de repuesto que pude sacarle al auto.", repuestos);
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/desarmar", .playerid=playerid);
	CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_DESARMAR, .seconds = THIEF_DESARMAR_COOLDOWN * 60);
	return 1;
}

HideStolenCar(vehicleid)
{
	SetVehicleToRespawn(vehicleid); // Respawn para sacar a los jugadores del vehículo (no funciona loopear y sacar a los que esten en el vehículo)
    SetVehiclePos(vehicleid, 8888.0, 8888.0, 888.0); // Lo hacemos desaparecer un rato
    SetTimerEx("Veh_Respawn", STOLEN_CAR_MISSING_TIME * 60 * 1000, false, "i", vehicleid);
}