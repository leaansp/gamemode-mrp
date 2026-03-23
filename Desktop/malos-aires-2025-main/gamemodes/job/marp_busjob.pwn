#if defined _marp_busjob_included
	#endinput
#endif
#define _marp_busjob_included

#include <YSI_Coding\y_hooks>


//#define JOB_BUS_PAY_PER_WORK (500)  //Paga que le daremos al usuario por cada trabajo realizado.
#define JOB_BUS_PAY_PER_WORK    (JobInfo[JOB_BUS][jBaseSalary])
#define JOB_BUS_MAX_WORKS_PER_PAYDAY (4)    //Cantidad máxima de trabajos a realizar por Pago Diario.
#define JOB_BUS_BONUS_PER_WORKED_TIMES (1 / JOB_BUS_MAX_WORKS_PER_PAYDAY)   //Bonus por cantidad de trabajos realizados.
#define JOB_BUS_BONUS_PER_CHARGE (50 / JOB_BUS_MAX_WORKS_PER_PAYDAY)    //Cantidad de dinero que le daremos al usuario en el bonus.

#define JOB_BUS_TRAVEL_TIME	20  //Tiempo máximo para realizar el recorrido.

#define BUS_ROUTES_AMOUNT      4    //Cantidad de rutas disponibles.
#define BUS_ROUTE_SIZE         20   //Cantidad de checkpoints en las rutas.

static const Float:j_bus_routes[BUS_ROUTES_AMOUNT][BUS_ROUTE_SIZE][3] = {
	{
		//===========================RUTA SUR===========================//
		{2222.33, -2625.40, 13.38},
		{2686.05, -2452.74, 13.52},
		{2299.14, -2092.77, 13.33},
		{2697.15, -2051.70, 13.24},
		{2645.39, -1745.37, 10.72},
		{2235.97, -1729.62, 13.38},
		{1836.32, -1749.90, 13.38},
		{1550.20, -1729.98, 13.38},
		{1076.51, -1709.56, 13.38},
		{937.64, -1569.64, 13.38},
		{662.60, -1670.37, 13.87},
		{289.47, -1635.15, 33.15},
		{157.17, -1739.31, 4.86},
		{461.37, -1734.55, 9.82},
		{810.27, -1786.11, 13.49},
		{1275.43, -1854.53, 13.38},
		{1514.97, -1874.53, 13.38},
		{1946.43, -2168.63, 13.39},
		{2175.38, -2361.09, 13.37},
		{2222.14, -2569.75, 13.39}
	},
	{
	    //===========================RUTA ESTE===========================//
	    {2222.02, -2614.83, 13.40},
	    {2686.73, -2451.98, 13.51},
	    {2298.69, -2091.94, 13.32},
	    {2220.60, -1912.56, 13.34},
	    {2219.01, -1764.86, 13.35},
	    {2400.07, -1734.76, 13.38},
	    {2433.48, -1519.27, 23.83},
	    {2534.42, -1507.51, 23.83},
		{2573.48, -1270.22, 45.96},
		{2384.97, -1254.06, 23.82},
		{2227.57, -1381.85, 23.82},
		{2073.33, -1317.40, 23.82},
		{2072.34, -1154.47, 23.70},
		{1882.15, -1133.65, 23.86},
		{1844.20, -1444.75, 13.40},
		{1818.72, -1687.37, 13.38},
		{1942.47, -1935.12, 13.38},
		{1958.68, -2090.71, 13.39},
		{2184.89, -2155.27, 13.38},
		{2221.71, -2569.21, 13.39}
	},
	{
	    //===========================RUTA OESTE===========================//
	    {2313.75, -2352.29, 13.38},
	    {1975.84, -2107.29, 13.36},
	    {1824.06, -1881.49, 13.32},
	    {1853.63, -1481.34, 13.38},
	    {1623.25, -1438.36, 13.38},
	    {1378.17, -1398.44, 13.39},
	    {1083.51, -1398.74, 13.49},
	    {817.43, -1398.70, 13.46},
	    {439.20, -1448.80, 29.61},
	    {261.32, -1434.31, 13.55},
	    {600.33, -1228.74, 17.91},
	    {780.74, -1057.14, 24.57},
	    {927.76, -1150.39, 23.70},
	    {1328.30, -1151.34, 23.64},
	    {1298.51, -1536.69, 13.38},
	    {1054.91, -1569.94, 13.38},
	    {1044.14, -1881.20, 13.11},
	    {1305.44, -2467.19, 7.66},
	    {1471.62, -2362.29, 13.38},
	    {2221.96, -2558.05, 13.38}
    },
    {
	    //===========================RUTA NORTE===========================//
	    {2314.61, -2351.23, 13.38},
	    {1976.00, -2106.90, 13.36},
	    {2091.40, -1765.75, 13.39},
	    {2628.17, -1734.72, 10.99},
	    {2645.27, -1416.77, 30.28},
	    {2645.06, -1099.29, 69.14},
	    {2719.83, -1171.35, 69.26},
	    {2385.40, -1171.83, 27.77},
		{1691.87, -979.26, 37.71},
		{1174.86, -938.25, 42.80},
		{812.06, -1038.96, 24.99},
		{647.17, -1192.08, 18.05},
		{776.34, -1401.94, 13.36},
		{1032.50, -1402.02, 13.19},
		{1321.87, -1402.24, 13.32},
		{1426.74, -1713.42, 13.38},
		{1515.10, -1874.67, 13.38},
		{1945.71, -2169.60, 13.39},
		{2174.17, -2361.52, 13.37},
		{2221.84, -2558.05, 13.38}
	}
};

stock BusJob_GetVehicleCharge(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    
 	switch(modelid)
 	{
 	    case 431: return 0; //Bus
		case 437: return 3; //Coach
	}
	return 1;
}

BusJob_StartWork(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(Veh_GetJob(vehicleid) != JOB_BUS)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes iniciar tu jornada si no estás en un vehículo de la empresa.");
    if(BusJob_GetVehicleCharge(vehicleid) > PlayerJobInfo[playerid][pCharge])
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes utilizar esta unidad ya que tu cargo no te lo permite.");
    if(PlayerInfo[playerid][pCantWork] >= JOB_BUS_MAX_WORKS_PER_PAYDAY)
	    return SendClientMessage(playerid, COLOR_WHITE, "Inspector: Trabajaste mucho el día de hoy, sería bueno que te tomes un descanso.");
    if(Job_IsVehicleWorking(vehicleid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Otro chofer ya tomó esta unidad para iniciar una ruta, tendrás que buscar otra.");
    if(!Cronometro_Crear(playerid, JOB_BUS_TRAVEL_TIME * 60, "BusJob_TravelTimeLimit"))
	    return SendClientMessage(playerid, COLOR_DARKRED, "[SCRIPT ERROR]: No se pudo crear el cronometro asociado al trabajo. Reportar a un administrador.");
    

    SendClientMessage(playerid, COLOR_WHITE, "Inspector: ¡Bien, comencemos la ruta! Se te ha marcado en el GPS una serie de paradas en las cuales tendrás que detenerte.");
    SendClientMessage(playerid, COLOR_WHITE, "Inspector: Procura conducir con cuidado y preservá la vida de los pasajeros, respetá las leyes de tránsito y llegá a tiempo.");
    SendClientMessage(playerid, COLOR_WHITE, "Inspector: Tienes 20 minutos para completar la ruta. Si llegas demasiado tarde el jefe se enojará y no te pagará.");
    
    new destination = random(BUS_ROUTES_AMOUNT);
	ClearAnimations(playerid);
	SetPlayerSkin(playerid, 176);
	PlayerInfo[playerid][pJobSkin] = 176;
	PutPlayerInVehicle(playerid, vehicleid, 0);
    PlayerActionMessage(playerid, 15.0, "ha encendido el motor del vehículo.");
	SetPlayerCheckpoint(playerid, 2206.88, -2589.54, 13.55, 5.0);
    jobDuty[playerid] = true;
    SetEngine(vehicleid, 1);
    jobVehicle[playerid] = vehicleid;
    jobCheckpoint[playerid] = 0;
    jobRoute[playerid] = destination;
    GetVehicleHealth(vehicleid, jobVehicleHealth[playerid]);
    UpdatePlayerJobLastWorked(playerid);
    PlayerInfo[playerid][pCantWork]++;
    return 1;
}

J_Bus_OnPlayerDisconnect(playerid)
{
	if(jobDuty[playerid]==true)
	{
		jobDuty[playerid] = false;
		SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	}
	return 1;
}


BusJob_IsPlayerWorking(playerid, vehicleid)
{
	if(PlayerInfo[playerid][pJob] == JOB_BUS && jobDuty[playerid] && VehicleInfo[vehicleid][VehJob] == JOB_BUS)
	    return 1;
	return 0;
}

forward BusJob_NextCheckpoint(playerid, cp);
public BusJob_NextCheckpoint(playerid, cp)
{
    TogglePlayerControllable(playerid, true);
    jobCheckpoint[playerid]++;
	if(cp == 1)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][0][0], j_bus_routes[jobRoute[playerid]][0][1], j_bus_routes[jobRoute[playerid]][0][2], 5.0);
    }
	else if(cp == 2)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][1][0], j_bus_routes[jobRoute[playerid]][1][1], j_bus_routes[jobRoute[playerid]][1][2], 5.0);
    }
	else if(cp == 3)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][2][0], j_bus_routes[jobRoute[playerid]][2][1], j_bus_routes[jobRoute[playerid]][2][2], 5.0);
    }
	else if(cp == 4)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][3][0], j_bus_routes[jobRoute[playerid]][3][1], j_bus_routes[jobRoute[playerid]][3][2], 5.0);
    }
	else if(cp == 5)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][4][0], j_bus_routes[jobRoute[playerid]][4][1], j_bus_routes[jobRoute[playerid]][4][2], 5.0);
    }
	else if(cp == 6)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][5][0], j_bus_routes[jobRoute[playerid]][5][1], j_bus_routes[jobRoute[playerid]][5][2], 5.0);
    }
	else if(cp == 7)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][6][0], j_bus_routes[jobRoute[playerid]][6][1], j_bus_routes[jobRoute[playerid]][6][2], 5.0);
    }
	else if(cp == 8)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][7][0], j_bus_routes[jobRoute[playerid]][7][1], j_bus_routes[jobRoute[playerid]][7][2], 5.0);
    }
	else if(cp == 9)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][8][0], j_bus_routes[jobRoute[playerid]][8][1], j_bus_routes[jobRoute[playerid]][8][2], 5.0);
    }
	else if(cp == 10)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][9][0], j_bus_routes[jobRoute[playerid]][9][1], j_bus_routes[jobRoute[playerid]][9][2], 5.0);
    }
	else if(cp == 11)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][10][0], j_bus_routes[jobRoute[playerid]][10][1], j_bus_routes[jobRoute[playerid]][10][2], 5.0);
    }
	else if(cp == 12)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][11][0], j_bus_routes[jobRoute[playerid]][11][1], j_bus_routes[jobRoute[playerid]][11][2], 5.0);
    }
	else if(cp == 13)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][12][0], j_bus_routes[jobRoute[playerid]][12][1], j_bus_routes[jobRoute[playerid]][12][2], 5.0);
    }
	else if(cp == 14)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][13][0], j_bus_routes[jobRoute[playerid]][13][1], j_bus_routes[jobRoute[playerid]][13][2], 5.0);
    }
	else if(cp == 15)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][14][0], j_bus_routes[jobRoute[playerid]][14][1], j_bus_routes[jobRoute[playerid]][14][2], 5.0);
    }
	else if(cp == 16)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][15][0], j_bus_routes[jobRoute[playerid]][15][1], j_bus_routes[jobRoute[playerid]][15][2], 5.0);
    }
	else if(cp == 17)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][16][0], j_bus_routes[jobRoute[playerid]][16][1], j_bus_routes[jobRoute[playerid]][16][2], 5.0);
    }
	else if(cp == 18)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][17][0], j_bus_routes[jobRoute[playerid]][17][1], j_bus_routes[jobRoute[playerid]][17][2], 5.0);
    }
	else if(cp == 19)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Buen trabajo, dirigete a la siguiente parada.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][18][0], j_bus_routes[jobRoute[playerid]][18][1], j_bus_routes[jobRoute[playerid]][18][2], 5.0);
    }
    else if(cp == 20)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Bien, has finalizado la ruta. Lleva la unidad a la terminal.");
        SetPlayerCheckpoint(playerid, j_bus_routes[jobRoute[playerid]][19][0], j_bus_routes[jobRoute[playerid]][19][1], j_bus_routes[jobRoute[playerid]][19][2], 5.0);
    }
    else if(cp == 21)
    {
        SendClientMessage(playerid, COLOR_GREEN, "Estacioná la unidad en el mismo lugar del cual la tomaste.");
		SetPlayerCheckpoint(playerid, VehicleInfo[jobVehicle[playerid]][VehPosX], VehicleInfo[jobVehicle[playerid]][VehPosY], VehicleInfo[jobVehicle[playerid]][VehPosZ], 5.0);
    }
	return 1;
}


BusJob_PlayerDeath(playerid)
{
		jobDuty[playerid] = false;
		SetVehicleToRespawn(GetPlayerVehicleID(playerid));
		jobVehicle[playerid] = 0;
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
        SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Te descompensaste en medio de la ruta, fuiste asistido y otro chofer tomó el trabajo.");
		DisablePlayerCheckpoint(playerid);
		Cronometro_Borrar(playerid);
		return 1;
}

hook function OnPlayerEnterCPId(playerid, checkpointid)
{
	if(!IsPlayerInAnyVehicle(playerid))
		return continue(playerid, checkpointid);
	if(!BusJob_IsPlayerWorking(playerid, GetPlayerVehicleID(playerid)))
		return continue(playerid, checkpointid);

	new actualCP = jobCheckpoint[playerid],
	    vehicleid = GetPlayerVehicleID(playerid);
	    
	if(actualCP < 1) //Planilla.
	{
		GameTextForPlayer(playerid, "Tu inspector te esta entregando la planilla...", 5000, 4);
		TogglePlayerControllable(playerid, false);
		SetTimerEx("BusJob_NextCheckpoint", 5000, false, "ii", playerid, actualCP + 1);
	}
	else if(actualCP < 20) //Comienzo y transcurso de la ruta.
	{
		GameTextForPlayer(playerid, "Los pasajeros estan subiendo y bajando...", 5000, 4);
		TogglePlayerControllable(playerid, false);
		SetTimerEx("BusJob_NextCheckpoint", 5000, false, "ii", playerid, actualCP + 1);
	}
	else if(actualCP == 20) //Última parada y finalización del recorrido.
	{
	    GameTextForPlayer(playerid, "Los pasajeros estan bajando...", 5000, 4);
	    TogglePlayerControllable(playerid, false);
	    SetTimerEx("BusJob_NextCheckpoint", 5000, false, "ii", playerid, actualCP + 1);
	}
	else if(actualCP == 21) // Estacionando.
	{
 		PlayerJobInfo[playerid][pWorkingHours]++;
		BusJob_Payment(playerid, vehicleid);
		RemovePlayerFromVehicle(playerid);
  		SetEngine(vehicleid, 0);
		SetVehicleToRespawn(vehicleid);
	    jobDuty[playerid] = false;
	    jobVehicle[playerid] = 0;
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		PlayerActionMessage(playerid, 15.0, "apaga el motor del vehículo y coloca el freno.");
		Cronometro_Borrar(playerid);
	}
	return 1;
}

forward BusJob_TravelTimeLimit(playerid);
public BusJob_TravelTimeLimit(playerid)
{
	Job_GiveReputation(playerid, -6);
	
	//5 minutos para que devuelva la unidad a la terminal.
	if(!Cronometro_Crear(playerid, 300, "BusJob_ReturnTimeLimit")) // Si falló la creación del cronometro
	{
	    SendClientMessage(playerid, COLOR_DARKRED, "[SCRIPT ERROR]: No se pudo crear el cronómetro asociado al trabajo. Reportar a un administrador.");
        jobDuty[playerid] = false;
		SetEngine(jobVehicle[playerid], 0);
		SetVehicleToRespawn(jobVehicle[playerid]);
	 	jobVehicle[playerid] = 0;
	 	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	}
	else // Se pudo crear el cronometro
	{
		if(jobCheckpoint[playerid] < 20) // No llegó a terminar la ruta.
		{
			SendClientMessage(playerid, COLOR_WHITE, "Demoraste demasiado y otra unidad te reemplazará para continuar lo que queda del recorrido.");
            SendClientMessage(playerid, COLOR_WHITE, "Tienes cinco minutos para volver a la terminal, si no lo haces tu imagen laboral empeorará.");
			jobCheckpoint[playerid] = 20;
		}
		else if(jobCheckpoint[playerid] == 20) // Estaba en el último checkpoint.
		{
			SendClientMessage(playerid, COLOR_WHITE, "Estás llegando demasiado tarde a la terminal, apresúrate o no te pagarán.");
	    	SendClientMessage(playerid, COLOR_WHITE, "Tienes un minuto para entrar al playón y dejar la unidad en el lugar correspondiente.");
            jobCheckpoint[playerid] = 21;
		}
	    DisablePlayerCheckpoint(playerid);
	    SetPlayerCheckpoint(playerid, VehicleInfo[jobVehicle[playerid]][VehPosX], VehicleInfo[jobVehicle[playerid]][VehPosY], VehicleInfo[jobVehicle[playerid]][VehPosZ], 5.0);
	}
	return 1;
}

forward BusJob_ReturnTimeLimit(playerid);
public BusJob_ReturnTimeLimit(playerid)
{
    jobDuty[playerid] = false;
	SetEngine(jobVehicle[playerid], 0);
	SetVehicleToRespawn(jobVehicle[playerid]);
 	jobVehicle[playerid] = 0;
 	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
 	Job_GiveReputation(playerid, -4);
 	SendClientMessage(playerid, COLOR_WHITE, "Inspector: ¿A eso le llamas laburar? Dejá, otro empleado va a terminar el trabajo por vos.");
 	return 1;
}

BusJob_Payment(playerid, vehicleid)
{
	new paycheck, Float:vHealth, injuriesCost, seniorityBonus, chargeBonus;

    GetVehicleHealth(vehicleid, vHealth);
    if(vHealth + 30.0 < jobVehicleHealth[playerid])
    {
        Job_GiveReputation(playerid, -(floatround(jobVehicleHealth[playerid] - vHealth, floatround_ceil) / 10)); // La reputación que baja es proporcional al daño del vehículo (un décimo)
        injuriesCost = floatround(jobVehicleHealth[playerid] - vHealth, floatround_ceil) / 2; // Se le paga x$$$ menos correspondientes a la diferencia de vida en el vehículo / 2.
		SendClientMessage(playerid, COLOR_WHITE, "Inspector: En esta empresa no toleramos el daño en nuestras unidades, el jefe te lo descontará de tu sueldo.");
	}
	else
	    Job_GiveReputation(playerid, 1);

	seniorityBonus = PlayerJobInfo[playerid][pWorkingHours] * JOB_BUS_BONUS_PER_WORKED_TIMES; // Extra por antiguedad
	chargeBonus = (PlayerJobInfo[playerid][pCharge] - 1) * JOB_BUS_BONUS_PER_CHARGE; // Extra por cargo

	paycheck = JOB_BUS_PAY_PER_WORK + seniorityBonus + chargeBonus - injuriesCost;
	PlayerInfo[playerid][pPayCheck] += paycheck;
	PlayerJobInfo[playerid][pTotalEarnings] += paycheck;

	SendFMessage(playerid, COLOR_WHITE, "Terminaste el trabajo en tiempo y forma, por ende recibirás $%d adicionales en el próximo payday. Puedes hacer %d ruta/s más el día de hoy.", paycheck, JOB_BUS_MAX_WORKS_PER_PAYDAY - PlayerInfo[playerid][pCantWork]);
	SendFMessage(playerid, COLOR_WHITE, "[Detalles]: Pago base por entrega: $%d - Bonus por antigüedad: $%d - Bonus por cargo: $%d - Descuento por roturas: ${FF0000}%d", JOB_BUS_PAY_PER_WORK, seniorityBonus, chargeBonus, injuriesCost);

	BusJob_CheckPromotePlayer(playerid);
	Job_CheckReputationLimit(playerid);
}

BusJob_CheckPromotePlayer(playerid)
{
	if(250 * PlayerJobInfo[playerid][pCharge] <= PlayerJobInfo[playerid][pWorkingHours] && PlayerJobInfo[playerid][pReputation] >= 0 && PlayerJobInfo[playerid][pCharge] < 5) // Minimo de X horas trabajadas (proporcional al siguiente puesto) y de una imágen laboral neutral.
	{
	    if(PlayerJobInfo[playerid][pWorkingHours] + PlayerJobInfo[playerid][pReputation] / 5 >= 500 * PlayerJobInfo[playerid][pCharge]) // Para ascender hay que llegar a una cantidad de puntos. Nuestro puntaje se suma entre la reputacion y la antiguedad.
	    {
	        PlayerJobInfo[playerid][pCharge]++;
	        SendFMessage(playerid, COLOR_WHITE, "¡Felicitaciones! fuiste promovido a %s, lo que te garantiza una mejora en tu sueldo. ¡Buen trabajo! Seguí así.", GetJobChargeName(JOB_BUS, PlayerJobInfo[playerid][pCharge]));
		}
	}
}
