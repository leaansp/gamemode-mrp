#if defined _marp_vehicles_included
	#endinput
#endif
#define _marp_vehicles_included

#include "vehicle/marp_vehicles_core.pwn"
#include "vehicle/marp_vehicles_trunk.pwn"
#include "vehicle/marp_vehicles_data.pwn"
#include "vehicle/marp_vehicles_admin.pwn"

#include <YSI_Coding\y_hooks>

#define PRICE_GPS   			1000

forward ClearPlayerDrunk(playerid);

//Cinturón de seguridad
new bool:SeatBelt[MAX_PLAYERS];

// Crash system: if vehicle loses a big chunk of HP in one tick, consider a collision
#define CRASH_HP_DROP_THRESHOLD 125.0
#define CRASH_EJECT_HEALTH 15.0
#define CRASH_SEATBELT_DAMAGE 10.0
#define CRASH_COOLDOWN_MS 3000

new Float:PrevVehicleHP[MAX_VEH]; // Previous vehicle health
new VehicleLastCrashTick[MAX_VEH];

// Cinturón: visual deshabilitado (sólo toggle lógico)
//========================[VEHICLE GLOBAL VARIABLES]============================

new LastVeh[MAX_PLAYERS],
	bool:OfferingVehicle[MAX_PLAYERS],
	VehicleOfferPrice[MAX_PLAYERS],
	VehicleOffer[MAX_PLAYERS],
	VehicleOfferID[MAX_PLAYERS],
	bool:startingEngine[MAX_PLAYERS];

static Veh_lastDriver[MAX_VEHICLES][MAX_PLAYER_NAME] = {{"Ninguno"}, ...};

Veh_GetLastDriverName(vehicleid, driverName[MAX_PLAYER_NAME]) {
	strcopy(driverName, Veh_lastDriver[vehicleid], MAX_PLAYER_NAME);
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new	vehicleModelType, vehicleid = GetPlayerVehicleID(playerid);

 	if(newstate == PLAYER_STATE_PASSENGER || newstate == PLAYER_STATE_DRIVER)
 	{
		LastVeh[playerid] = vehicleid;
		vehicleModelType = Veh_GetModelType(vehicleid);

		if(newstate == PLAYER_STATE_DRIVER) {
			strcopy(Veh_lastDriver[vehicleid], PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
		}
	}
	        
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
		Radio_StopIfOnType(playerid, RADIO_TYPE_VEH);

		if(newstate == PLAYER_STATE_ONFOOT)
		{
			if(SeatBelt[playerid])
			{
				PlayerActionMessage(playerid, 15.0, "se desabrocha el cinturón de seguridad.");
				SeatBelt[playerid] = false;
			}
		}
	}
	
	if(newstate == PLAYER_STATE_PASSENGER && oldstate == PLAYER_STATE_ONFOOT)
	{
		if(PlayerInfo[playerid][pCrack])
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacer esto.");
			RemovePlayerFromVehicle(playerid);
		}

		if(VehicleInfo[vehicleid][VehType] == VEH_OWNED && VehicleInfo[vehicleid][VehLocked] == 1 && !AdminDuty[playerid])
		{
		    if(vehicleModelType == VTYPE_BMX || vehicleModelType == VTYPE_BIKE || vehicleModelType == VTYPE_QUAD)
		    	return 1;
		    	
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vehículo está cerrado.");
			RemovePlayerFromVehicle(playerid);
		}

		Radio_Set(playerid, VehicleInfo[vehicleid][VehRadio], RADIO_TYPE_VEH);
	}
	
	if(newstate == PLAYER_STATE_DRIVER && oldstate == PLAYER_STATE_ONFOOT)
	{
		Radio_Set(playerid, VehicleInfo[vehicleid][VehRadio], RADIO_TYPE_VEH);

        if(VehicleInfo[vehicleid][VehType] == VEH_OWNED)
		{
			if(!AdminDuty[playerid])
			{
				if(vehicleModelType == VTYPE_BMX && VehicleInfo[vehicleid][VehOwnerSQLID] != PlayerInfo[playerid][pID])
				{
					new Float:pos[3];
					SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Esta bicicleta no te pertenece!");
					RemovePlayerFromVehicle(playerid);
					GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					SetPlayerPos(playerid, pos[0], pos[1], pos[2] + 1);
				}
				else if(VehicleInfo[vehicleid][VehLocked] == 1)
				{
					if(vehicleModelType == VTYPE_BMX || vehicleModelType == VTYPE_BIKE || vehicleModelType == VTYPE_QUAD)
						return 1;

					SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vehículo está cerrado.");
					RemovePlayerFromVehicle(playerid);
				}
			}
		}
		else if(VehicleInfo[vehicleid][VehType] == VEH_RENT)
		{
			// Validar si es una bicicleta alquilada - solo puede manejarla quien la alquiló
			new bool:isBicycleRent = (vehicleModelType == VTYPE_BMX);
			new bool:playerCanDriveBicycle = false;
			new bool:isBicycleAlreadyRented = false;
			new bool:isBicycleAvailableForRent = false;
			
			if(isBicycleRent && !AdminDuty[playerid])
			{
				// Verificar el estado de la bicicleta en el sistema de renta
				for(new i = 1; i < MAX_RENTCAR; i++)
				{
					if(RentCarInfo[i][rVehicleID] == vehicleid)
					{
						if(RentCarInfo[i][rRented] == 1)
						{
							// Está alquilada
							isBicycleAlreadyRented = true;
							if(RentCarInfo[i][rOwnerSQLID] == PlayerInfo[playerid][pID])
							{
								playerCanDriveBicycle = true;
							}
						}
						else if(RentCarInfo[i][rRented] == 0)
						{
							// Está disponible para alquilar
							isBicycleAvailableForRent = true;
						}
						break;
					}
				}
				
				// Si está alquilada y no es del jugador, no puede conducir
				if(isBicycleAlreadyRented && !playerCanDriveBicycle)
				{
					SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Esta bicicleta alquilada no te pertenece!.");
					return 1;
				}
				
				// Si está disponible para alquilar, no puede conducirla sin alquilarla primero
				if(isBicycleAvailableForRent)
				{
					SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes alquilar esta bicicleta antes de conducirla!.");
					// Mostrar el diálogo de alquiler
					for(new i = 1; i < MAX_RENTCAR; i++)
					{
						if(RentCarInfo[i][rVehicleID] == vehicleid && RentCarInfo[i][rRented] == 0)
						{
							SendClientMessage(playerid, COLOR_WHITE, "======================[Vehículo en Alquiler]======================");
							SendFMessage(playerid, COLOR_WHITE, "Modelo: %s.", Veh_GetName(vehicleid));
							new price = Veh_GetPrice(vehicleid) / 200;
							if(price < 100)
								price = 100; // Seteamos un mínimo de precio
							SendFMessage(playerid, COLOR_WHITE, "Costo de renta por hora: $%d.", price);
							if(Veh_GetTrunkSpace(vehicleid) > 0)
								SendFMessage(playerid, COLOR_WHITE, "Maletero: %du.", Veh_GetTrunkSpace(vehicleid));
							else
							    SendClientMessage(playerid, COLOR_WHITE, "Maletero: No.");
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "(( Para rentar éste vehículo utiliza '/rentar [tiempo] (en horas)'. ))");
							SendClientMessage(playerid, COLOR_WHITE, "=============================================================");
							break;
						}
					}
					return 1;
				}
			}
			
			// Mostrar información de alquiler si está disponible
			for(new i = 1; i < MAX_RENTCAR; i++)
			{
		 		if(RentCarInfo[i][rVehicleID] == vehicleid && RentCarInfo[i][rRented] == 0)
		 		{
					SendClientMessage(playerid, COLOR_WHITE, "======================[Vehículo en Alquiler]======================");
					SendFMessage(playerid, COLOR_WHITE, "Modelo: %s.", Veh_GetName(vehicleid));
					new price = Veh_GetPrice(vehicleid) / 200;
					if(price < 100)
						price = 100; // Seteamos un mínimo de precio
					SendFMessage(playerid, COLOR_WHITE, "Costo de renta por hora: $%d.", price);
					if(Veh_GetTrunkSpace(vehicleid) > 0)
						SendFMessage(playerid, COLOR_WHITE, "Maletero: %du.", Veh_GetTrunkSpace(vehicleid));
					else
					    SendClientMessage(playerid, COLOR_WHITE, "Maletero: No.");
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "(( Para rentar éste vehículo utiliza '/rentar [tiempo] (en horas)'. ))");
					SendClientMessage(playerid, COLOR_WHITE, "=============================================================");
					break;
				}
			}
		}
		if(Veh_GetModelType(vehicleid) == VTYPE_PLANE || Veh_GetModelType(vehicleid) == VTYPE_HELI)
		{
	  		if(PlayerInfo[playerid][pFlyLic] == 0)
			  {
				if(!AdminDuty[playerid])
				{
				    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes licencia de vuelo!");
	   				RemovePlayerFromVehicle(playerid);
				}
			}
	   	}
	}

	// Si es una bicicleta (o similar) y está desbloqueada, activar estado de "motor"
	// para que otras comprobaciones que dependen de VehEngine permitan conducirla.
	if ((vehicleModelType == VTYPE_BMX)
		&& VehicleInfo[vehicleid][VehLocked] == 0)
	{
		SetEngine(vehicleid, 1);
	}
	return 1;
}


	HandleVehicleCrash(vehicleid, Float:damageDelta)
	{
		new curTick = GetTickCount();
		if(curTick - VehicleLastCrashTick[vehicleid] < CRASH_COOLDOWN_MS) return 0; // debounce
		VehicleLastCrashTick[vehicleid] = curTick;

		new Float:x, Float:y, Float:z;
		new Float:angle;
		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, angle);

		
		new Float:frontDist = 2.0;

		
		new Float:severity = damageDelta / CRASH_HP_DROP_THRESHOLD;

		for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
		{
			if(!IsPlayerConnected(playerid)) continue;
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER) continue;
			if(GetPlayerVehicleID(playerid) != vehicleid) continue;

			if(!SeatBelt[playerid])
			{
				RemovePlayerFromVehicle(playerid);
				new Float:nx = x + (frontDist * floatsin(angle, degrees));
				new Float:ny = y + (frontDist * floatcos(angle, degrees));
				new Float:nz = z + 0.5 + (0.15 * severity);
				if(nz - z > 1.0) nz = z + 1.0; 
				SetPlayerPos(playerid, nx, ny, nz);
				SetPlayerHealthEx(playerid, CRASH_EJECT_HEALTH);
				PlayerActionMessage(playerid, 15.0, "sale despedido por el parabrisas y queda herido sobre el capot.");
				ApplyAnimationEx(playerid, "CRACK", "CRCKIDLE2", 4.1, 0, 0, 0, 1, 0, 1, false);
			}
			else
			{
	
				new Float:curhp = GetPlayerHealthEx(playerid);
				new Float:newhp = curhp - (CRASH_SEATBELT_DAMAGE * (1.0 + severity));
				if(newhp < 1.0) newhp = 1.0; 
				SetPlayerHealthEx(playerid, newhp);
				PlayerActionMessage(playerid, 10.0, "recibe un fuerte impacto pero su cinturón lo mantiene en su lugar.");
				SetPlayerDrunkLevel(playerid, 10000);
				SetTimerEx("ClearPlayerDrunk", 10000, false, "i", playerid);
			}
		}
		return 1;
	}

public ClearPlayerDrunk(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	SetPlayerDrunkLevel(playerid, 0);
	return 1;
}

forward VehicleFuelTimer();
public VehicleFuelTimer()
{
	static Float:x, Float:y, Float:z, string[128];

	for(new vehicleid = 1; vehicleid < MAX_VEH; vehicleid++)
	{
		if(VehicleInfo[vehicleid][VehType] != VEH_NONE)
		{
			GetVehicleDamageStatus(vehicleid, VehicleInfo[vehicleid][VehDamage1], VehicleInfo[vehicleid][VehDamage2], VehicleInfo[vehicleid][VehDamage3], VehicleInfo[vehicleid][VehDamage4]);

			if(VehicleInfo[vehicleid][VehEngine])
			{
				if(Veh_ConsumesFuel(vehicleid))
				{
					if(VehicleInfo[vehicleid][VehFuel] > 0) {
						VehicleInfo[vehicleid][VehFuel]--;
					} else {
						SetEngine(vehicleid, 0);
						GetVehiclePos(vehicleid, x, y, z);
						format(string, sizeof(string), "* El motor del vehículo comienza a ahogarse y luego de unos instantes se apaga (( %s ))", Veh_GetName(vehicleid));
						SendMessageInRange(15.0, x, y, z, GetVehicleVirtualWorld(vehicleid), string, COLOR_DO1, COLOR_DO2, COLOR_DO3, COLOR_DO4, COLOR_DO5);
					}
				} else {
					VehicleInfo[vehicleid][VehFuel] = 100;
				}
			}
		}
	}
	return 1;
}

forward VehicleDamageTimer();
forward HandleVehicleCrash(vehicleid, Float:damageDelta);
public VehicleDamageTimer()
{
	static Float:x, Float:y, Float:z, Float:angle, string[128];

	for(new vehicleid = 1; vehicleid < MAX_VEH; vehicleid++)
	{
		if(VehicleInfo[vehicleid][VehType] != VEH_NONE)
		{
			GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]); // TODO: idem vida pero con inicio de motor
			GetVehicleHealth(vehicleid, VehicleInfo[vehicleid][VehHP]); // TODO: si la salud es mayor a la actualizacion anterior, chequear si hubo una reparacion legal ingame en el segundo anterior ( o X segs anteriores, por si hubiese retrasos/lag)

			// Detect sudden health drops -> possible crash
			new Float:prev = PrevVehicleHP[vehicleid];
			new Float:curr = VehicleInfo[vehicleid][VehHP];
			new Float:delta = prev - curr;
			new modeltype = Veh_GetModelType(vehicleid);
			
			// Excluir motos, bicicletas y quads de la detección de choques
			new bool:isExcludedType = (modeltype == VTYPE_BMX || modeltype == VTYPE_BIKE || modeltype == VTYPE_QUAD);
			
			if(prev <= 0.0) PrevVehicleHP[vehicleid] = curr; // initialize
			else if(delta >= CRASH_HP_DROP_THRESHOLD && !isExcludedType)
			{
				HandleVehicleCrash(vehicleid, delta);
				PrevVehicleHP[vehicleid] = curr;
			}
			else
			{
				PrevVehicleHP[vehicleid] = curr;
			}

			if(VehicleInfo[vehicleid][VehEngine] && VehicleInfo[vehicleid][VehHP] < 500.0)
			{
				SetEngine(vehicleid, 0);
				GetVehiclePos(vehicleid, x, y, z);
				format(string, sizeof(string), "* El motor del vehículo está muy deteriorado, por lo que luego de unos instantes se apaga (( %s ))", Veh_GetName(vehicleid));
				SendMessageInRange(15.0, x, y, z, GetVehicleVirtualWorld(vehicleid), string, COLOR_DO1, COLOR_DO2, COLOR_DO3, COLOR_DO4, COLOR_DO5);
			}

			if(VehicleInfo[vehicleid][VehHP] < 400.0)
			{
				SetVehicleHealth(vehicleid, 400.0);
				GetVehicleZAngle(vehicleid, angle);
				SetVehicleZAngle(vehicleid, angle + 0.1); //con esto el vehiculo si esta dado vuelta, vuelve a ponerse como debe.
			}
		}
	}
	return 1;
}

CMD:vehrastrear(playerid, params[])
{
	new vehicleid, Float: X, Float: Y, Float: Z;

	if(sscanf(params, "i", vehicleid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/vehrastrear [ID vehículo]");
    if(!Veh_IsPlayerOwner(vehicleid, playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vehículo no te pertenece.");
    if(PlayerInfo[playerid][pPhoneNumber] == 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Requieres de un telefono para poder rastrear el vehículo!");
	if(GetPlayerCash(playerid) < PRICE_GPS)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes dinero suficiente para rastrear el vehículo ($"#PRICE_GPS").");
	if(Depo_IsVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu vehículo fue incautado, debes dirigirte a la comisaria para retirarlo.");

	new color = RandomRGBAColor();

	GivePlayerCash(playerid, -PRICE_GPS);
	GetVehiclePos(vehicleid, X, Y, Z);
	MapMarker_CreateForPlayer(playerid, X, Y, Z, .color = color, .time = 120000);
	Noti_Create(playerid, .time = 3000, .text = "Se marco la localización de tu vehículo, esta durara 2 minutos", .backgroundColor = color);
	return 1;
}

forward StartEngineTimer(playerid, vehicleid);
public StartEngineTimer(playerid, vehicleid)
{
    new vehid = GetPlayerVehicleID(playerid);
	if(vehid == vehicleid && VehicleInfo[vehicleid][VehEngine] != 1)
	{
		new modeltype = Veh_GetModelType(vehicleid);
		if(modeltype == VTYPE_BMX || modeltype == VTYPE_BIKE || modeltype == VTYPE_QUAD)
		{
			SetEngine(vehicleid, 1);
		}
		else
		{
			SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has encendido el motor del vehículo.");
			SetEngine(vehicleid, 1);
		}
	}
	startingEngine[playerid] = false;
}

Veh_CanPlayerInteract(vehicleid, playerid)
{
	new type = Veh_GetSystemType(vehicleid);

	return (AdminDuty[playerid] ||
			(type == VEH_FACTION && PlayerInfo[playerid][pFaction] == VehicleInfo[vehicleid][VehFaction]) ||
			(type == VEH_OWNED && KeyChain_Contains(playerid, KEY_TYPE_VEHICLE, vehicleid)) ||
			(type == VEH_JOB && VehicleInfo[vehicleid][VehJob] && PlayerInfo[playerid][pJob] == VehicleInfo[vehicleid][VehJob]) ||
			(type == VEH_RENT && PlayerInfo[playerid][pRentCarID] == vehicleid) ||
			(type == VEH_SCHOOL && GetPlayerLicenseTakingVehicleid(playerid) == vehicleid));
}

CMD:motor(playerid, params[])
{
	new vehicleid;

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar como conductor de un vehículo para utilizar este comando.");
	if(startingEngine[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Te encuentras encendiendo el motor, espera...");

	new modeltype = Veh_GetModelType(vehicleid);
	if(!Veh_CanPlayerInteract(vehicleid, playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes las llaves de este vehículo!");
	if(IsRefilling(playerid))
		return  SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No podes prender el motor mientras estas cargando combustible!");
	if(Veh_GetSystemType(vehicleid) == VEH_JOB && !(PlayerInfo[playerid][pJob] == VehicleInfo[vehicleid][VehJob] && GetPlayerJobDuty(playerid) && Job_GetWorkingVehicle(playerid) == vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para encender este vehículo debes utilizar el comando adecuado.");

	GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	if(!(modeltype == VTYPE_BMX || modeltype == VTYPE_BIKE || modeltype == VTYPE_QUAD) && VehicleInfo[vehicleid][VehHP] < 500.0)
 	{
		PlayerActionMessage(playerid, 15.0, "intenta encender el motor del vehículo pero se encuentra dañado.");
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vehículo se encuentra averiado.");
		return 1;
	}
	if(modeltype == VTYPE_BMX)
	{
		if(VehicleInfo[vehicleid][VehEngine] != 1)
		{
			startingEngine[playerid] = true;
			SetTimerEx("StartEngineTimer", 500, false, "ii", playerid, vehicleid);
			PlayerActionMessage(playerid, 15.0, "comienza a pedalear.");
		}
		else
		{
			PlayerActionMessage(playerid, 15.0, "deja de pedalear.");
			SetEngine(vehicleid, 0);
		}
	}
	else
	{
		if(VehicleInfo[vehicleid][VehFuel] < 1)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vehículo no tiene combustible.");

		if(VehicleInfo[vehicleid][VehEngine] != 1)
		{
			startingEngine[playerid] = true;
			SetTimerEx("StartEngineTimer", 2000, false, "ii", playerid, vehicleid);
			PlayerActionMessage(playerid, 15.0, "gira la llave y le da arranque al vehículo.");
			GameTextForPlayer(playerid, "~r~Encendiendo motor", 2000, 4);
		} else
		{
			PlayerActionMessage(playerid, 15.0, "apaga el motor del vehículo.");
			SetEngine(vehicleid, 0);
		}
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(KEY_PRESSED_SINGLE(KEY_SUBMISSION) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		cmd_motor(playerid, "");
	    return ~1;
    }
    return 1;
}


CMD:ventanilla(playerid, params[]) {
	return cmd_vent(playerid, params);
}

CMD:vent(playerid, params[])
{
	new vehicleid, vehSeat = GetPlayerVehicleSeat(playerid), winState[4];

	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo para utilizar este comando.");
	if(Veh_GetModelType(vehicleid) != VTYPE_CAR)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" Este vehículo no tiene ventanillas.");
	if(vehSeat < 0 || vehSeat > 3)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu lugar en el vehículo no tiene ventanilla.");
	    
	GetVehicleParamsCarWindows(vehicleid, winState[0], winState[1], winState[2], winState[3]);
    if(winState[vehSeat] == 0)
    {
        winState[vehSeat] = 1;
        PlayerActionMessage(playerid, 15.0, "cierra la ventanilla de su lado del vehículo.");
	}
	else
	{
	    winState[vehSeat] = 0;
		PlayerActionMessage(playerid, 15.0, "abre la ventanilla de su lado del vehículo.");
	}
	SetVehicleParamsCarWindows(vehicleid, winState[0], winState[1], winState[2], winState[3]);
	return 1;
}

//==========================COMANDOS DE VEHICULOS===============================

CMD:veh(playerid, params[]) {
	return cmd_vehiculo(playerid, params);
}

CMD:vehiculo(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "===========================[ COMANDOS DE VEHÍCULOS ]===========================");
	SendClientMessage(playerid, COLOR_INFO, "[COMANDOS] "COLOR_EMB_GREY" /vehvender - /vehvendera - /vehestacionar - /vehpuertas - /motor (o presiona ~k~~TOGGLE_SUBMISSIONS~)");
	SendClientMessage(playerid, COLOR_INFO, "[COMANDOS] "COLOR_EMB_GREY" /vehluces - /vehmal - (/mal)etero - /vehcapot - (/vent)anilla - (/cin)turon - (/vercint)uron - /vehradio");
	SendClientMessage(playerid, COLOR_INFO, "[COMANDOS] "COLOR_EMB_GREY" /llavero - /vehrastrear - /sacar - /carrerayuda ");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "===============================================================================");
	return 1;
}

CMD:vehvender(playerid, params[])
{
	new vehicleid, dealership = GetNearestDealership(playerid, 25.0);

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar como conductor de un vehículo para utilizar este comando.");
    if(!Veh_IsPlayerOwner(vehicleid, playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No podés vender un vehículo que no te pertenece!");
    if(dealership == -1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar cerca de una concesionaria para vender el vehículo.");

    new string[128];
    format(string, sizeof(string), "Empleado: te pagará $%i por ese %s.\n \n!estás seguro de que quieres vender el vehículo?", Veh_GetPrice(vehicleid) / 2, Veh_GetName(vehicleid));
    Dialog_Open(playerid, "DLG_CAR_SALE", DIALOG_STYLE_MSGBOX, "Venta de vehículo", string, "{01DF01}Vender", "{DF0101}Cancelar");
    return 1;
}

Dialog:DLG_CAR_SALE(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	new vehicleid = GetPlayerVehicleID(playerid), price = Veh_GetPrice(vehicleid);

	if(!(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en un vehículo.");
	if(GetNearestDealership(playerid, 25.0) == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar cerca de una concesionaria para vender el vehículo.");
	if(!Veh_IsPlayerOwner(vehicleid, playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes vender un vehículo que no te pertenece!");

	GivePlayerCash(playerid, price / 2);
	Veh_Delete(vehicleid);
	SendFMessage(playerid, COLOR_WHITE, "Empleado: has vendido tu vehículo por $%i, que tengas un buen día.", price / 2);
	
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/vehvender", .playerid=playerid);
	PlayerPlaySound(playerid, 5201, 0.0, 0.0, 0.0);

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .id=vehicleid, .entry="VENTA VEHICULO", .playerid=playerid, .params=<"$%d", price / 2>);
	return 1;
}

CMD:vehvendera(playerid, params[])
{
	new targetid, vehicleid, price;

	if(sscanf(params, "uii", targetid, vehicleid, price))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/vehvendera [ID/Jugador] [IDvehículo] [dinero]");
	if(OfferingVehicle[playerid])
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya estás vendiendo un vehículo.");
	if(!Veh_IsValidId(vehicleid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La ID del vehículo es inválida.");
	if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID || targetid == playerid)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de jugador inválida.");
	if(price < 1 || price > 5000000)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El precio no puede ser menor a $1 ni mayor a $5,000,000.");
	if(VehicleInfo[vehicleid][VehType] != VEH_OWNED)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este vehículo no puede ser vendido.");
	if(!Veh_IsPlayerOwner(vehicleid, playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este vehículo no te pertenece.");
	if(!IsPlayerInRangeOfPlayer(4.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La persona se encuentra demasiado lejos.");

	OfferingVehicle[playerid] = true;
 	VehicleOfferPrice[targetid] = price;
	VehicleOffer[targetid] = playerid;
	VehicleOfferID[targetid] = vehicleid;
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Le has ofrecido las llaves de un %s a %s por $%d.", Veh_GetName(vehicleid), GetPlayerCleanName(targetid), price);
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te ha ofrecido un %s por $%d.", GetPlayerCleanName(playerid), Veh_GetName(vehicleid), price);
	SendClientMessage(targetid, COLOR_LIGHTBLUE, "Utiliza '/aceptar vehiculo' para aceptar la oferta o '/cancelar vehiculo' para cancelar.");
    SetPVarInt(targetid, "CancelVehicleTransfer", SetTimerEx("CancelVehicleTransfer", 30 * 1000, 0, "ii", targetid, 1));
	return 1;
}

TIMER:CancelVehicleTransfer(playerid, timer) {
	if(timer == 1) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La venta ha sido cancelada ya que no has respondido en 30 segundos.");
		SendClientMessage(VehicleOffer[playerid], COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La venta ha sido cancelada ya que el comprador no ha respondido en 30 segundos.");
	} else if(timer == 0) {
    	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has rechazado la oferta.");
		SendFMessage(VehicleOffer[playerid], COLOR_LIGHTBLUE, "%s ha rechazado la oferta.", GetPlayerCleanName(playerid));
	}
	OfferingVehicle[VehicleOffer[playerid]] = false;
	VehicleOfferPrice[playerid] = -1;
	VehicleOffer[playerid] = INVALID_PLAYER_ID;
	VehicleOfferID[playerid] = -1;
	return 1;
}

hook function OnPlayerCmdAccept(playerid, const subcmd[])
{
	if(strcmp(subcmd, "vehiculo", true))
		return continue(playerid, subcmd);

	if(VehicleOffer[playerid] == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ha ofrecido ningún vehículo.");
	if(!IsPlayerInRangeOfPlayer(4.0, playerid, VehicleOffer[playerid]))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La persona se encuentra demasiado lejos.");
	if(!IsPlayerConnected(VehicleOffer[playerid])) {
		KillTimer(GetPVarInt(playerid, "CancelVehicleTransfer"));
		CancelVehicleTransfer(playerid, 0);
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vendedor se ha desconectado, cancelando la operación.");
	}
	// Comprobamos que la ID del vehículo sea válida y que el jugador no se haya desconectado.
	if(VehicleOfferID[playerid] <= 0 || !OfferingVehicle[VehicleOffer[playerid]]) {
		KillTimer(GetPVarInt(playerid, "CancelVehicleTransfer"));
	    CancelVehicleTransfer(playerid, 0);
	    SendClientMessage(VehicleOffer[playerid], COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debido a un error con la ID del vehículo, la venta ha sido cancelada.");
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error con la ID del vehículo, cancelando...");
	}
	if(GetPlayerCash(playerid) < VehicleOfferPrice[playerid]) {
	    KillTimer(GetPVarInt(playerid, "CancelVehicleTransfer"));
	    CancelVehicleTransfer(playerid, 0);
	    SendClientMessage(VehicleOffer[playerid], COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene el dinero necesario, cancelando...");
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero suficiente, cancelando...");
	}

	if(KeyChain_GetFreeSlots(playerid) > 0)
	{
		VehicleInfo[VehicleOfferID[playerid]][VehOwnerSQLID] = PlayerInfo[playerid][pID];
		GetPlayerName(playerid, VehicleInfo[VehicleOfferID[playerid]][VehOwnerName], 24);
		GivePlayerCash(playerid, -VehicleOfferPrice[playerid]);
		GivePlayerCash(VehicleOffer[playerid], VehicleOfferPrice[playerid]);

		KeyChain_DeleteAll(KEY_TYPE_VEHICLE, VehicleOfferID[playerid], .allowIfOwnerKey = true);
		KeyChain_Add(playerid, KEY_TYPE_VEHICLE, VehicleOfferID[playerid], .label = Veh_GetName(VehicleOfferID[playerid]), .owner = true);
		
		PlayerPlayerActionMessage(VehicleOffer[playerid], playerid, 10.0, "recibe una suma de dinero y le entrega unas llaves a");
	    SendFMessage(playerid, COLOR_LIGHTBLUE, " ¡Felicidades, has comprado el %s por $%d!", Veh_GetName(VehicleOfferID[playerid]), VehicleOfferPrice[playerid]);
	    SendFMessage(VehicleOffer[playerid], COLOR_LIGHTBLUE, " ¡Felicitaciones, has vendido el %s por $%d!", Veh_GetName(VehicleOfferID[playerid]), VehicleOfferPrice[playerid]);
	    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
	    SaveVehicle(VehicleOfferID[playerid]);

		ServerFormattedLog(LOG_TYPE_ID_VEHICLES, .id=VehicleOfferID[playerid], .entry="/vehvendera", .playerid=VehicleOffer[playerid], .targetid =playerid , .params=<"%d %d %d", playerid, VehicleOfferID[playerid], VehicleOfferPrice[playerid]>);
		ServerFormattedLog(LOG_TYPE_ID_MONEY, .id=VehicleOfferID[playerid], .entry="VENTA VEHICULO", .playerid=VehicleOffer[playerid], .targetid =playerid, .params=<"$%d", VehicleOfferPrice[playerid]>);
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "No puedes tener más llaves en tu llavero, cancelando...");
	    SendClientMessage(VehicleOffer[playerid], COLOR_LIGHTBLUE, "El jugador no puede tener más llaves en su llavero, cancelando...");
	}
	KillTimer(GetPVarInt(playerid, "CancelVehicleTransfer"));
	CancelVehicleTransfer(playerid, 2);
	return 1;
}

hook function OnPlayerCmdCancel(playerid, const subcmd[])
{
	if(strcmp(subcmd, "vehiculo", true))
		return continue(playerid, subcmd);

	if(VehicleOffer[playerid] == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ha ofrecido un vehículo.");

	KillTimer(GetPVarInt(playerid, "CancelVehicleTransfer"));
	CancelVehicleTransfer(playerid, 0);
	return 1;
}

CMD:vehestacionar(playerid, params[])
{
	new vehicleid;

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar como conductor de un vehículo para utilizar este comando.");
	if(GetPlayerSpeed(playerid) > 4) // Permite estacionar botes
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes estacionar el vehículo en movimiento!");
	if(!KeyChain_Contains(playerid, KEY_TYPE_VEHICLE, vehicleid) &&
		(PlayerInfo[playerid][pFaction] != VehicleInfo[vehicleid][VehFaction] || PlayerInfo[playerid][pRank] != 1) )
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Este vehículo no te pertenece!");

	new Float:health, Float:x, Float:y, Float:z, Float:angle, vworld, interior;

	GetVehicleHealth(vehicleid, health);
	if(health < 500.0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes estacionar un vehículo en este estado! Debe estar en mejores condiciones.");

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, angle);
	vworld = GetPlayerVirtualWorld(playerid);
	interior = GetPlayerInterior(playerid);

	Veh_SetRespawnPoint(vehicleid, x, y, z, angle, vworld, interior);

	PutPlayerInVehicle(playerid, vehicleid, 0);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"vehículo estacionado correctamente.");
	ServerFormattedLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/vehestacionar", .playerid=playerid, .params=<"(x: %.2f y: %.2f z: %.2f)", x, y, z>);
	return 1;
}

CMD:vehpuertas(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid) {
		vehicleid = GetClosestVehicle(playerid, 7.0);
	}

	if(vehicleid == INVALID_VEHICLE_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No hay ningún vehículo cerca tuyo!");
	if(Veh_GetModelType(vehicleid) == VTYPE_BMX || Veh_GetModelType(vehicleid) == VTYPE_BIKE || Veh_GetModelType(vehicleid) == VTYPE_QUAD)
	   	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este vehículo no tiene puertas.");
	if(!Veh_CanPlayerInteract(vehicleid, playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes las llaves de este vehículo!");

	GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	if(VehicleInfo[vehicleid][VehLocked] != 1)
	{
		PlayerActionMessage(playerid,15.0, "ha asegurado las puertas del vehículo.");
		VehicleInfo[vehicleid][VehLocked] = 1;
	}
	else
	{
		PlayerActionMessage(playerid,15.0, "ha destrabado las puertas del vehículo.");
		VehicleInfo[vehicleid][VehLocked] = 0;
	}
	return 1;
}

CMD:vehluces(playerid, params[])
{
	new vehicleid;

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !(vehicleid = GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar como conductor de un vehículo para utilizar este comando.");

	GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	if(VehicleInfo[vehicleid][VehLights] != 1)
	{
		VehicleInfo[vehicleid][VehLights] = 1;
	}
	else
	{
	    VehicleInfo[vehicleid][VehLights] = 0;
	}
	SetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	return 1;
}

CMD:vehmal(playerid, params[])
{
	new vehicleid;

	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar a pie y detrás de un maletero.");
	if(!(vehicleid = VehTrunk_GetNearestForPlayer(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras detrás de un vehículo con maletero.");
	if(Veh_GetTrunkSpace(vehicleid) == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Este vehículo no tiene maletero!");
	if(!Veh_CanPlayerInteract(vehicleid, playerid) && !Depo_CanOpenTrunk(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes las llaves de este vehículo!");
	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar un tiempo antes de volver a interactuar con el vehículo!");

	// TODO: Nada actualiza el estado de VehicleInfo[vehicleid][VehBoot] excepto vehmal para evitar que el cliente pueda enviar un auto con param abierto y eso actualice el valor del server. Con eso solo ya deberia andar
	GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	if(VehicleInfo[vehicleid][VehBoot] != 1)
    {
		PlayerCmeMessage(playerid, 15.0, 5000, "Abre el maletero del vehículo.");
		VehicleInfo[vehicleid][VehBoot] = 1;
	}
	else
	{
		PlayerCmeMessage(playerid, 15.0, 5000, "Cierra el maletero del vehículo.");
		VehicleInfo[vehicleid][VehBoot] = 0;
	}

	// To prevent spaming
	Item_ApplyHandlingCooldown(playerid);

	SetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	ServerFormattedLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/vehmal", .playerid=playerid, .params=<"(%s)", (VehicleInfo[vehicleid][VehBoot]) ? ("abre") : ("cierra")>);
	return 1;
}

CMD:vehcapot(playerid, params[])
{
	new vehicleid;

 	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	 	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Baja del vehículo, debes estar a pie.");
	if((vehicleid = GetClosestVehicle(playerid, 5.0)) == INVALID_VEHICLE_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No hay ningún vehículo cerca tuyo!");
	if(Veh_GetModelType(vehicleid) != VTYPE_CAR)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Este vehículo no tiene capot!");
	if(!Veh_CanPlayerInteract(vehicleid, playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes las llaves de este vehículo!");

	GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	if(VehicleInfo[vehicleid][VehBonnet] != 1)
    {
   		PlayerActionMessage(playerid, 15.0, "ha abierto el capot del vehículo.");
		VehicleInfo[vehicleid][VehBonnet] = 1;
	}
	else
	{
		PlayerActionMessage(playerid, 15.0, "ha cerrado el capot del vehículo.");
		VehicleInfo[vehicleid][VehBonnet] = 0;
	}
	SetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	return 1;
}

CMD:vehradio(playerid, params[])
{
	new radio, vehicleid = GetPlayerVehicleID(playerid), veh_type = Veh_GetModelType(vehicleid);

	if(!IsPlayerInAnyVehicle(playerid) || (veh_type != VTYPE_CAR && veh_type != VTYPE_HELI && veh_type != VTYPE_PLANE && veh_type != VTYPE_HEAVY))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en un auto!");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerVehicleSeat(playerid) != 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en los asientos delanteros!");

	if(!sscanf(params, "i", radio))
	{
		if(!Radio_IsValidId(radio))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar una radio válida, utiliza '/radios' para ver las radios disponibles.");

		foreach(new i : Player)
		{
			if(IsPlayerInVehicle(i, vehicleid))
			{
				SendFMessage(i, COLOR_ACT1, "%s sintoniza una radio en el estéreo del auto.", GetPlayerCleanName(playerid));
				Radio_Set(i, radio, RADIO_TYPE_VEH);
			}
		}

		VehicleInfo[vehicleid][VehRadio] = radio;
	}
	else
	{
		if(!VehicleInfo[vehicleid][VehRadio])
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/vehradio [id]. Para apagarla utiliza nuevamente '/vehradio'.");

		foreach(new i : Player)
		{
			if(IsPlayerInVehicle(i, vehicleid))
			{
				SendFMessage(i, COLOR_ACT1, "%s apaga la radio sintonizada en el estéreo del auto.", GetPlayerCleanName(playerid));
				if(Radio_IsOnType(i, RADIO_TYPE_VEH)) {
					Radio_Stop(i);
				}
			}
		}

		VehicleInfo[vehicleid][VehRadio] = 0;
	}
	return 1;
}

//==================================CINTURON====================================

CMD:cint(playerid, params[]) {
	return cmd_cinturon(playerid, params);
}

CMD:cinturon(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid),
		vType = Veh_GetModelType(vehicleid);
	if(!IsPlayerInAnyVehicle(playerid) || (vType != VTYPE_CAR && vType != VTYPE_HEAVY && vType != VTYPE_MONSTER))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en un auto!");
	if(SeatBelt[playerid])
	{
		PlayerActionMessage(playerid, 15.0, "se desabrocha el cinturón de seguridad.");
		SeatBelt[playerid] = false;
	}
	else
	{
		PlayerActionMessage(playerid, 15.0, "se abrocha el cinturón de seguridad.");
		SeatBelt[playerid] = true;
	}
	return 1;
}

CMD:vercint(playerid,params[]) {
	return cmd_vercinturon(playerid, params);
}

CMD:vercinturon(playerid, params[])
{
	new targetid;
	
	if(sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/vercinturon [ID/Jugador]");
	if(!IsPlayerLogged(targetid))
 	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido.");
	if(!IsPlayerInRangeOfPlayer(5.0, playerid, targetid) && !AdminDuty[playerid])
  	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no está cerca tuyo.");

    new vehicleid = GetPlayerVehicleID(targetid), vType = Veh_GetModelType(vehicleid);

	if(!IsPlayerInAnyVehicle(targetid) || (vType != VTYPE_CAR && vType != VTYPE_HEAVY && vType != VTYPE_MONSTER))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡El jugador no esta en un vehículo / el vehículo no posee cinturón!");

	if(SeatBelt[targetid])
		SendFMessage(playerid, COLOR_WHITE, "El cinturón de %s se encuentra abrochado.", GetPlayerCleanName(targetid));
	else
	    SendFMessage(playerid, COLOR_WHITE, "El cinturón de %s se encuentra desabrochado.", GetPlayerCleanName(targetid));
	return 1;
}

CMD:vreparar(playerid, params[])
{
    static repararvehcooldown;

    new vehicleid, hand_cajah = SearchHandsForItem(playerid, ITEM_ID_CAJAHERRAMIENTAS);

    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Baja del vehículo, debés estar a pie.");
    if ((vehicleid = GetClosestVehicle(playerid, 5.0)) == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ningún vehículo cerca tuyo.");
    if (Veh_GetModelType(vehicleid) != VTYPE_CAR)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este vehículo no tiene capot.");
    if (VehicleInfo[vehicleid][VehBonnet] == 0)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El capot del vehículo esta cerrado. Ponte en frente y utiliza /vehcapot.");
    if (VehicleInfo[vehicleid][VehHP] > 450.0)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este vehículo no necesita ser reparado. Tiene mas de 450HP (/dl)");
    if (hand_cajah == -1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés tener una caja de herramientas en alguna mano.");
    if (gettime() < repararvehcooldown)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés esperar 20 minutos para volver a usar este comando.");

    //SetVehicleHealth(vehicleid, 400.0);
    VehicleInfo[vehicleid][VehHP] = 550.0;
    TogglePlayerControllable(playerid, false);
    PlayerInfo[playerid][pDisabled] = DISABLE_FREEZE; // Para no descongelarse con /noanim.
    SetTimerEx("Unfreeze", 15 * 1000, false, "i", playerid);
    Noti_Create(playerid, 15000, "Reparando motor..");
    ApplyAnimationEx(playerid, "INT_SHOP", "SHOP_LOOKA", 4.0, 1, 0, 0, 0, 0, 1, false, .finishAnimId = 1);
    SetTimerEx("RepararVeh", 15 * 1000, false, "i", playerid);
    repararvehcooldown = gettime() + 1200;

    if (GetHandParam(playerid, hand_cajah) == 1)
        SetHandItemAndParam(playerid, hand_cajah, 0, 0);
    else
        SetHandItemAndParam(playerid, hand_cajah, ITEM_ID_CAJAHERRAMIENTAS, GetHandParam(playerid, hand_cajah) - 1);

    return true;
}