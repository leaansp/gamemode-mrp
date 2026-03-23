#if defined _marp_gas_station_included
	#endinput
#endif
#define _marp_gas_station_included

#include <YSI_Coding\y_hooks>

#define PRICE_FULLTANK          300

const GAS_STATION_MAX_AMOUNT = 24;
const GAS_STATION_RESET_ID = GAS_STATION_MAX_AMOUNT;
const INVALID_GAS_STATION_ID = -1;

static enum 
{
	GAS_REFILL_TYPE_CAR_STATION,
	GAS_REFILL_TYPE_CAR_CAN,
	GAS_REFILL_TYPE_CAN,

	GAS_REFILL_TYPE_AMOUNT
}

static enum e_GAS_STATION_DATA
{
	gsFaction,
	STREAMER_TAG_AREA:gsArea
}

static GasStationData[GAS_STATION_MAX_AMOUNT + 1][e_GAS_STATION_DATA] = {
	{
		/*gsFaction*/ 0,
        /*STREAMER_TAG_AREA:gsArea*/ INVALID_STREAMER_ID
	}, ...
};

static Iterator:GasStationData<GAS_STATION_MAX_AMOUNT>;

static GasStationPlayerData[MAX_PLAYERS] = {INVALID_GAS_STATION_ID, ...};

static GasRefillingTimer[MAX_PLAYERS] = {0, ...};

GasStation_Create(Float:x1, Float:y1, Float:x2, Float:y2, Float:x3, Float:y3, Float:x4, Float:y4, Float:z, factionid = 0)
{
    new gasid = Iter_Free(GasStationData);

	if(gasid == ITER_NONE)
	{
		printf("[ERROR] Alcanzado GasStation_MAX_AMOUNT (%i). Iter_Count: %i.", GAS_STATION_MAX_AMOUNT, Iter_Count(GasStationData));
		return INVALID_GAS_STATION_ID;
	}

	new Float:pos[8];

	pos[0] = x1; pos[1] = y1; pos[2] = x2; pos[3] = y2; pos[4] = x3; pos[5] = y3; pos[6] = x4; pos[7] = y4;
    GasStationData[gasid][gsArea] = CreateDynamicPolygon(pos, .minz = z - 2.0, .maxz = z + 2.5, .maxpoints = sizeof(pos));
    Streamer_SetExtraIdArray(STREAMER_TYPE_AREA, GasStationData[gasid][gsArea], STREAMER_ARRAY_TYPE_GAS_STATION, gasid);

    GasStationData[gasid][gsFaction] = factionid;

    Iter_Add(GasStationData, gasid);
    return gasid;
}

GasStation_Destroy(gasid) 
{
    if(!Iter_Contains(GasStationData, gasid))
		return 0;
    
    if(GasStationData[gasid][gsArea])
	{
		if(IsAnyPlayerInDynamicArea(GasStationData[gasid][gsArea]))
		{
			foreach(new playerid : Player)
			{
				if(gasid == GasStationPlayerData[playerid]) {
					GasStationPlayerData[playerid] = INVALID_GAS_STATION_ID;
				}
			}
		}

		DestroyDynamicArea(GasStationData[gasid][gsArea]);
	}
    
    GasStationData[gasid] = GasStationData[GAS_STATION_RESET_ID];
	Iter_Remove(GasStationData, gasid);
    return 1;
}

GasStation_OnPlayerEnterArea(playerid, gasstationid)
{
	static notiCooldown[MAX_PLAYERS];

	if(gettime() >= notiCooldown[playerid])
	{
		Noti_Create(playerid, 3000, "Usa /llenar para cargar nafta en tu vehículo o bidón");
		notiCooldown[playerid] = gettime() + 20;
	}

	GasStationPlayerData[playerid] = gasstationid;
}

GasStation_OnPlayerLeaveArea(playerid, gasstationid)
{
	if(gasstationid == GasStationPlayerData[playerid]) {
		GasStationPlayerData[playerid] = INVALID_GAS_STATION_ID;
	}
}

GasStation_CanPlayerUse(playerid, gasid) {
	return (!GasStationData[gasid][gsFaction] || GasStationData[gasid][gsFaction] == PlayerInfo[playerid][pFaction]);
}

IsRefilling(playerid) {
	return (GasRefillingTimer[playerid]);
}

CMD:aestacionservicio(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new subcmd[32];

	if(sscanf(params, "s[32] ", subcmd))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aestacionservicio [ayuda - crear - borrar]");
	
	if(!strcmp(subcmd, "crear", true))
	{
		new Float:x1, Float:y1,
			Float:x2, Float:y2,
			Float:x3, Float:y3,
			Float:x4, Float:y4,
			Float:z,
			factionid;

		if(sscanf(params, "s[32] p<,>fffffffffi", subcmd, x1, y1, x2, y2, x3, y3, x4, y4, z, factionid))
		{
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aestacionservicio crear [x1,y1,x2,y2,x3,y3,x4,y4,z,factionid]");
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"Utiliza '/aestacionservicio ayuda' para mayor información.");
			return 1;
		}

		new gasid = GasStation_Create(x1, y1, x2, y2, x3, y3, x4, y4, z, factionid);

		if(gasid != INVALID_GAS_STATION_ID) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estacion de servicio ID %i creada correctamente.", gasid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Imposible crear la estacion de servicio, se alcanzó el máximoen el servidor.");
		}

		return 1;
	}
	else if(!strcmp(subcmd, "borrar", true))
	{
		new gasid;

		if(sscanf(params, "s[32] i", subcmd, gasid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aestacionservicio borrar [id estacion]");

		if(GasStation_Destroy(gasid)) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estacion de servicio ID %i borrada correctamente.", gasid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de estacion de servicio inválida.");
		}

		return 1;
	}
	else if(!strcmp(subcmd, "ayuda", true))
	{
		Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "[AYUDA] Creación de reja",
					"[CREACION]\n \n\
					Uso: '/aestacionservicio crear [x1,y1,x2,y2,x3,y3,x4,y4,z,factionid]'.\n \n\
					(x1,y1,x2,y2,x3,y3,x4,y4,z)\tTipo: float\tEj: -956.35\tDetalle: esquinas del cuadrado donde se creara la estacion de servicio, z es la altura base.\n\
					(factionid)\t Tipo: entero\tEj: 1, 3\tDetalle: faccion la cual podra usar la estacion de servicio. (0 indica que cualquier usuario)\n\
					Ejemplo de uso: '/aestacionservicio crear 1573.8691, -1623.1239, 1573.6421, -1627.4196, 1565.9718, -1627.1779, 1565.7841, -1623.0706, 13.3, 1'.\n\
					Cada par (x,y) representa una de las esquinas del cuadrado o rectangulo. (Por par refierase a los que tiene el mismo número)\n \n\
					[BORRADO]\n \n\
					Uso: '/aestacionservicio borrar [idestacion]'.\n \n\
					(idestacion)\tTipo: entero\tEj: 3, 27\tDetalle: ID de la estacion de servicio a borrar.",
					"Cerrar", "");
	}
	else {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aestacionservicio [ayuda - crear - borrar]");
	}

	return 1;
}

PlayerAndVehicleAreGov(playerid, vehicleid)
{
	if((Veh_GetSystemType(vehicleid) == VEH_FACTION && PlayerInfo[playerid][pFaction] == VehicleInfo[vehicleid][VehFaction]) && Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_GOB_TYPE))
		return 1;
	return 0;
}

CMD:bidon(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "[INFO] Para llenar el bidón deberás estar a pie en una estación de servicio y escribir '/llenar'. Para usarlo tendrás que..");
	SendClientMessage(playerid, COLOR_WHITE, "situarte junto al tanque del vehículo y escribir '/usarbidon'. El estado del bidón lo puedes ver usando '/mano'.");
	return 1;
}

CMD:llenar(playerid, params[])
{
	new gasid = GasStationPlayerData[playerid], vehicleid = 0, type;

	if(gasid == INVALID_GAS_STATION_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en una estacion de servicio.");
	if(!GasStation_CanPlayerUse(playerid, gasid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No pueden atenderte en esta estacion de servicio.");
	if(GetPlayerCash(playerid) < (PRICE_FULLTANK / 100)) // Lo mínimo para llenar
	   	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Vuelve cuando tengas el dinero suficiente.");
	if(GasRefillingTimer[playerid])
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ya te encuentras cargando nafta.");
	
    if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar como conductor del vehículo.");

		vehicleid = GetPlayerVehicleID(playerid);
		if(VehicleInfo[vehicleid][VehEngine])
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El motor debe estar apagado.");

		if(VehicleInfo[vehicleid][VehFuel] > 99)
  			return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El tanque se encuentra lleno.");
		
		type = GAS_REFILL_TYPE_CAR_STATION;

        PlayerCmeMessage(playerid, 15.0, 5000, "Le indica al empleado el tipo de nafta, precio a llenar y le entrega el dinero.");
   		PlayerDoMessage(playerid, 15.0, "El empleado toma una manguera del surtidor y comienza a llenar el vehiculo.");
	} 
	else 
	{ 
		new hand = SearchHandsForItem(playerid, ITEM_ID_BIDON);
		if(hand == -1)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un bidón con algo de combustible en alguna de tus manos.");
		if(GetHandParam(playerid, hand) > 19)
			return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Este bidón esta lleno.");
		
		type = GAS_REFILL_TYPE_CAN;
		PlayerCmeMessage(playerid, 15.0, 5000, "Comienza a cargar nafta en el bidón de combustible.");
	}
	
 	TogglePlayerControllable(playerid, false);
	PlayerInfo[playerid][pDisabled] = DISABLE_FREEZE;
	GameTextForPlayer(playerid, "~w~Cargando nafta", 6000, 4);
	GasRefillingTimer[playerid] =  SetTimerEx("FillFuel", 6000, false, "iii", playerid, type, vehicleid);
	return 1;
}

CMD:usarbidon(playerid, params[])
{
	new vehicleid = GetClosestVehicle(playerid, 4.0);

	if(IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar fuera del vehículo.");
	if(vehicleid == INVALID_VEHICLE_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ningún vehículo cerca tuyo.");

	new hand = SearchHandsForItem(playerid, ITEM_ID_BIDON);
	if(hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un bidón con algo de combustible en alguna de tus manos.");

	new gasamount = GetHandParam(playerid, hand);
	if(gasamount == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El bidón con el cual tratas de cargar esta vacío.");
	
	GasRefillingTimer[playerid] = SetTimerEx("FillFuel", 6000, false, "iii", playerid, GAS_REFILL_TYPE_CAR_CAN, vehicleid);
	PlayerCmeMessage(playerid, 15.0, 5000, "Abre la tapa del tanque y comienza a vaciar el bidón dentro.");
	TogglePlayerControllable(playerid, false);
	PlayerInfo[playerid][pDisabled] = DISABLE_FREEZE;
	return 1;
}

forward FillFuel(playerid, type, vehicleid);
public FillFuel(playerid, type, vehicleid)
{
	if(!IsPlayerLogged(playerid))
    	return 0;

	new refilamount = 100 - VehicleInfo[vehicleid][VehFuel], cash = GetPlayerCash(playerid), price = PRICE_FULLTANK / 100 * refilamount;

	if(type == GAS_REFILL_TYPE_CAR_STATION) 
	{
		if(!PlayerAndVehicleAreGov(playerid, vehicleid) && cash < price) {
			refilamount = cash * 100 / PRICE_FULLTANK;
			price = PRICE_FULLTANK / 100 * refilamount;
		}

		VehicleInfo[vehicleid][VehFuel]+=refilamount;
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El tanque de su vehículo ha sido cargado al %d por ciento por $%d.", VehicleInfo[vehicleid][VehFuel], price);
	} 
	else if(type == GAS_REFILL_TYPE_CAR_CAN)
	{
		new hand = SearchHandsForItem(playerid, ITEM_ID_BIDON);
		if(hand == -1)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontro un bidón en tus manos.");

		new gasamount = GetHandParam(playerid, hand);
		new car_newfuel = gasamount;
		new can_newfuel = 0;

		if(refilamount < gasamount) {
			car_newfuel = refilamount;
			can_newfuel = refilamount;
		}

		VehicleInfo[vehicleid][VehFuel] += car_newfuel;
		SetHandItemAndParam(playerid, hand, ITEM_ID_BIDON, can_newfuel);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has cargado un %i por ciento del tanque de tu vehículo. A tu bidón le queda %i por ciento.", car_newfuel, can_newfuel);
		PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
		TogglePlayerControllable(playerid, true);
		GasRefillingTimer[playerid] = 0;
		PlayerInfo[playerid][pDisabled] = DISABLE_NONE;	
		return 1;
	}
	else if(type == GAS_REFILL_TYPE_CAN)
	{
		new hand = SearchHandsForItem(playerid, ITEM_ID_BIDON);
		if(hand == -1)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontro un bidón en tus manos.");

		refilamount =  20 - GetHandParam(playerid, hand);
		price = PRICE_FULLTANK / 100 * refilamount;

		if(cash < price) {
			refilamount = cash * 100 / PRICE_FULLTANK;
			price = PRICE_FULLTANK / 100 * refilamount;
		}

		SetHandItemAndParam(playerid, hand, ITEM_ID_BIDON, refilamount);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has cargado tu bidón al %d por ciento por $%d.", refilamount, price);
	}

	// Si el vehiculo pertenece a la faccion se descuenta del fondo faccionario.
	if(PlayerAndVehicleAreGov(playerid, vehicleid)) {
		Faction_GiveMoney(PlayerInfo[playerid][pFaction], -price);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El dinero se descontara del fondo de tu faccion.");
	} else {
		GivePlayerCash(playerid, -price);
	}

	PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
	TogglePlayerControllable(playerid, true);
	PlayerInfo[playerid][pDisabled] = DISABLE_NONE;	

	GasRefillingTimer[playerid] = 0;
	return 1;
}


hook OnPlayerDisconnect(playerid)
{
	if(GasRefillingTimer[playerid]) 
	{
		KillTimer(GasRefillingTimer[playerid]);
		GasRefillingTimer[playerid] = 0;
	}
	return 1;
}