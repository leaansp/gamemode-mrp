#if defined _marp_delijob_included
	#endinput
#endif
#define _marp_delijob_included

#include <YSI_Coding\y_hooks>

#define JOB_DELI_STOREPLACE_X       1741.24
#define JOB_DELI_STOREPLACE_Y       -1562.16
#define JOB_DELI_STOREPLACE_Z       14.16

#define JOB_DELI_MAX_DELIVERYS (5)
//#define JOB_DELI_PAY_PER_WORK (260)
#define JOB_DELI_BONUS_PER_WORKED_TIMES (1 / JOB_DELI_MAX_DELIVERYS)
#define JOB_DELI_BONUS_PER_CHARGE (120 / JOB_DELI_MAX_DELIVERYS)

#define JOB_DELI_PAY_PER_WORK   (JobInfo[JOB_DELI][jBaseSalary])

enum DeliJob_RouteInfo {
	Float:djX,
	Float:djY,
	Float:djZ,
	djTime
}

static const DeliJob_Route[][DeliJob_RouteInfo] = {
	{1439.3058, -926.6467, 39.6477, 104},
	{1525.7418, -774.5235, 79.8811, 124},
	{1442.7665, -629.5516, 95.7186, 136},
	{1033.1843, -809.6239, 101.8516, 162},
	{836.9149, -893.5928, 68.7689, 150},
	{689.8444, -1053.7305, 50.1541, 185},
	{551.5204, -1197.1387, 44.5455, 174},
	{200.0531, -1385.0724, 48.699, 170},
	{248.4863, -1262.6874, 69.7666, 182},
	{345.8627, -1191.2847, 76.5199, 198},
	{474.1737, -1174.8789, 63.6685, 195},
	{908.5896, -684.1473, 116.1911, 195},
	{1003.3759, -644.3123, 121.4506, 214},
	{1110.1738, -964.7603, 42.7233, 124},
	{1275.7544, -1066.0847, 28.9254, 120},
	{1247.5719, -1100.8672, 26.6719, 110},
	{1334.9695, -1065.8662, 28.0768, 98},
	{1190.5178, -1025.3774, 32.5469, 131},
	{1092.9587, -1093.6184, 25.5307, 125},
	{573.27, -1573.0392, 16.1797, 140},
	{364.3013, -1599.1323, 31.9686, 129},
	{329.9218, -1514.5978, 35.8672, 151},
	{301.6986, -1609.2399, 33.1205, 155},
	{451.4945, -1479.3191, 30.8217, 153},
	{305.5432, -1771.6835, 4.5418, 164},
	{206.8645, -1770.6487, 4.3271, 182},
	{168.1399, -1770.7959, 4.4059, 161},
	{2232.5164, -1159.4286, 25.4431, 112},
	{2378.5925, -1197.8383, 26.9964, 114},
	{2579.2097, -1389.8606, 28.4168, 127},
	{2389.6272, -1547.0151, 23.6463, 105},
	{2312.2031, -1327.7529, 23.5887, 110},
	{2504.2839, -1054.7465, 68.7408, 142},
	{2259.4575, -1064.8844, 48.9365, 143},
	{2176.1047, -1000.3945, 62.5274, 117},
	{2201.229, -1110.3525, 24.9869, 113},
	{2141.3728, -1176.8253, 23.5552, 88},
	{1996.4288, -1281.7885, 23.542, 91},
	{1830.1071, -1174.8458, 23.3921, 72},
	{1728.4203, -1180.2593, 23.4062, 73},
	{1587.2603, -1319.1085, 17.1226, 73},
	{1449.281, -1342.771, 13.1087, 75},
	{1392.3855, -1386.319, 13.1181, 82},
	{1213.8494, -1858.2449, 13.1186, 96},
	{1026.4001, -1771.8937, 13.1244, 107},
	{912.9034, -1822.7805, 12.1036, 117},
	{662.1538, -1791.8245, 12.0412, 135},
	{540.7659, -1811.2538, 5.6326, 146},
	{385.5496, -1820.9386, 7.4038, 146},
	{365.1925, -1638.3317, 32.4608, 152},
	{374.1253, -1416.179, 33.8681, 168},
	{457.3859, -1376.1747, 23.2685, 155},
	{644.228, -1353.9694, 13.1185, 143},
	{724.9738, -1437.6512, 13.1042, 155},
	{841.2798, -1477.6545, 13.167, 130},
	{774.1593, -1511.3673, 13.1198, 127},
	{778.3951, -1572.3734, 13.1138, 125},
	{832.0608, -1599.7253, 13.1177, 121},
	{937.4967, -1562.4418, 13.1185, 109},
	{1160.823, -1584.2101, 13.1159, 96},
	{1485.0763, -1863.6694, 13.112, 94},
	{1630.5979, -1903.51, 13.1208, 70},
	{1846.7078, -1872.2468, 13.1423, 70},
	{1980.5719, -1997.6008, 13.1245, 91},
	{1907.6268, -2044.476, 13.1163, 107},
	{1856.65, -1991.0896, 13.1125, 105},
	{1804.1267, -2124.2188, 13.5138, 117},
	{1664.2416, -2115.5017, 13.107, 127},
	{2281.0366, -2364.7205, 13.1191, 144},
	{2269.7637, -1885.8168, 13.1157, 120},
	{2353.3743, -1990.4171, 13.1077, 146},
	{2435.7744, -1924.0054, 13.1136, 124},
	{2734.7529, -1926.1731, 13.112, 153},
	{2653.1238, -1990.8837, 13.3035, 174},
	{2508.8572, -2001.8585, 13.1167, 156},
	{2069.7893, -1903.7882, 13.072, 99},
	{2481.5491, -1756.4528, 13.1122, 117},
	{2518.9348, -1678.4635, 14.19, 117},
	{2263.8599, -1470.4756, 23.3661, 107},
	{2233.6533, -1457.7091, 23.5807, 113},
	{2677.06, -1995.16, 13.55, 152},
	{2691.27, -2412.82, 13.63, 182},
	{2483.96, -1956.53, 13.62, 102},
	{2204.2678, -1412.9717, 23.5416, 101}
};

stock DeliJob_GetVehicleCharge(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    
 	switch(modelid)
 	{
 	    case 462: return 1; //faggio
		case 581: return 3; //bf400
		case 461: return 5; //pcj600
	}
	return 1;
}

stock bool:DeliJob_IsPlayerWorkingSimple(playerid)
{
	if(PlayerInfo[playerid][pJob] == JOB_DELI && jobDuty[playerid])
		return true;
	return false;
}

DeliJob_StartWork(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid),
		destination = random(sizeof(DeliJob_Route)),
		area[MAX_ZONE_NAME];

	if(Veh_GetJob(vehicleid) != JOB_DELI)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en una moto de reparto!");
	if(DeliJob_GetVehicleCharge(vehicleid) > PlayerJobInfo[playerid][pCharge])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Tu cargo en la empresa no tiene acceso a ese modelo de moto!");
	if(PlayerInfo[playerid][pCarLic] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una licencia de conducir. No podrás trabajar sin ella.");
	if(PlayerInfo[playerid][pCantWork] >= JOB_DELI_MAX_DELIVERYS)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya has alcanzado el máximo de entregas posibles por este día de pago.");
	if(Job_IsVehicleWorking(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ese vehículo actualmente esta siendo usado para trabajar por otro empleado.");

	// Ajuste de tiempo según el modelo de vehículo (más tiempo para motos lentas como la Faggio)
	new modelid = GetVehicleModel(vehicleid);
	new Float:baseTime = DeliJob_Route[destination][djTime];
	new Float:timeFactor = 1.0;
	if(modelid == 462) // faggio
		timeFactor = 1.35; // 35% más tiempo
	else if(modelid == 581) // bf400
		timeFactor = 1.15; // 15% más tiempo (más rápido que faggio)
	else if(modelid == 461) // pcj600
		timeFactor = 1.0; // no change

	new finalTime = floatround(baseTime * timeFactor, floatround_ceil) + 7;
	if(!Cronometro_Crear(playerid, finalTime, "DeliJob_TravelTimeLimit"))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se pudo crear el cronometro asociado al trabajo. Reportar a un administrador.");
	    
	GetCoords2DZone(DeliJob_Route[destination][djX], DeliJob_Route[destination][djY], area, MAX_ZONE_NAME);
	SetPlayerCheckpoint(playerid, JOB_DELI_STOREPLACE_X, JOB_DELI_STOREPLACE_Y, JOB_DELI_STOREPLACE_Z, 2.0);
	PlayerActionMessage(playerid, 15.0, "ha encendido el motor del vehículo.");
	SendClientMessage(playerid, COLOR_WHITE, "¡Rápido! Vé al fondo y agarra el paquete para entregar. Luego tendrás que viajar a la velocidad de un rayo y entregarlo lo antes posible.");
	SendFMessage(playerid, COLOR_WHITE, "Tienes %d segundos para ir, entregar el paquete, y volver a la central. La entrega es en la zona de %s.", finalTime, area);
    SendClientMessage(playerid, COLOR_WHITE, "Recuerda también que si entregas la moto en peor estado de como la recibiste o si llegas tarde, tu imagen laboral disminuirá.");
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

forward DeliJob_NextCheckpoint(playerid, cp);
public DeliJob_NextCheckpoint(playerid, cp)
{
    TogglePlayerControllable(playerid, true);
    jobCheckpoint[playerid]++;
    if(cp == 1)
    {
        SendClientMessage(playerid, COLOR_WHITE, "¡Rápido! Entrega el paquete en la dirección indicada.");
        SetPlayerCheckpoint(playerid, DeliJob_Route[jobRoute[playerid]][djX], DeliJob_Route[jobRoute[playerid]][djY], DeliJob_Route[jobRoute[playerid]][djZ], 2.0);
    }
    else if(cp == 2)
    {
        new tip = random(20);
        if(tip > 0)
        {
            SendFMessage(playerid, COLOR_WHITE, "El cliente te ha dado $%d de propina.", tip);
            GivePlayerCash(playerid, tip);
        }
        GameTextForPlayer(playerid, "Vuelve a la central y estaciona la moto en su lugar", 1500, 4);
		SetPlayerCheckpoint(playerid, VehicleInfo[jobVehicle[playerid]][VehPosX], VehicleInfo[jobVehicle[playerid]][VehPosY], VehicleInfo[jobVehicle[playerid]][VehPosZ], 2.0);
    }
	return 1;
}

hook function OnPlayerEnterCPId(playerid, checkpointid)
{
	// Permitimos que el jugador recoja/continúe la tarea aunque esté a pie
	if(!DeliJob_IsPlayerWorkingSimple(playerid))
		return continue(playerid, checkpointid);

	new actualCP = jobCheckpoint[playerid];
	new vehicleid = jobVehicle[playerid];
	// seguridad: si por algún motivo no está seteada la vehicle en jobVehicle, intentamos obtener la actual
	if(vehicleid == 0)
		vehicleid = GetPlayerVehicleID(playerid);
	    
	if(actualCP == 0) // A cargar el paquete
	{
		GameTextForPlayer(playerid, "Guardando paquete...", 4000, 4);
		TogglePlayerControllable(playerid, false);
		SetTimerEx("DeliJob_NextCheckpoint", 4000, false, "ii", playerid, actualCP + 1);
	}
	else if(actualCP == 1) // Yendo a entregar
	{
	    GameTextForPlayer(playerid, "Entregando paquete...", 4000, 4);
	    TogglePlayerControllable(playerid, false);
	    SetTimerEx("DeliJob_NextCheckpoint", 4000, false, "ii", playerid, actualCP + 1);
	}
	else if(actualCP == 2) // Volviendo
	{
 		PlayerJobInfo[playerid][pWorkingHours]++;
		DeliJob_Payment(playerid, vehicleid);
		RemovePlayerFromVehicle(playerid);
  		SetEngine(vehicleid, 0);
		SetVehicleToRespawn(vehicleid);
	    jobDuty[playerid] = false;
	    jobVehicle[playerid] = 0;
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		PlayerActionMessage(playerid, 15.0, "estaciona la moto en su lugar.");
		Cronometro_Borrar(playerid);
	}
	else if(actualCP == 3) // Se le acabó el tiempo inicial y tiene que devolver la moto a la central en el tiempo secundario sin paga
	{
		jobDuty[playerid] = false;
		SetEngine(jobVehicle[playerid], 0);
		SetVehicleToRespawn(jobVehicle[playerid]);
	 	jobVehicle[playerid] = 0;
	 	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	 	Cronometro_Borrar(playerid);
	 	PlayerActionMessage(playerid, 15.0, "estaciona la moto en su lugar.");
	}
	else if(actualCP == 4) // Se le acabó el tiempo inicial y tiene que devolver la moto a la central en el tiempo secundario con paga a medias
	{
	    PlayerJobInfo[playerid][pWorkingHours]++;
		jobDuty[playerid] = false;
		SetEngine(jobVehicle[playerid], 0);
		SetVehicleToRespawn(jobVehicle[playerid]);
	 	jobVehicle[playerid] = 0;
	 	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	 	Cronometro_Borrar(playerid);
		PlayerInfo[playerid][pPayCheck] += JOB_DELI_PAY_PER_WORK / 2;
		SendFMessage(playerid, COLOR_WHITE, "[INFO]: Has devuelto la moto a la central, y recibes la mitad del pago base (%d) a fin del día, sin ningún tipo de bonus.", JOB_DELI_PAY_PER_WORK / 2);
	 	PlayerActionMessage(playerid, 15.0, "estaciona la moto en su lugar.");
	}
	return 1;
}

forward DeliJob_TravelTimeLimit(playerid);
public DeliJob_TravelTimeLimit(playerid)
{
	Job_GiveReputation(playerid, -6);
	
	// Le damos 1 minuto para que vuelva a la central y deje la moto
	if(!Cronometro_Crear(playerid, 60, "DeliJob_ReturnTimeLimit")) // Si falló la creación del cronometro
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se pudo crear el cronómetro asociado al trabajo. Reportar a un administrador.");
        jobDuty[playerid] = false;
		SetEngine(jobVehicle[playerid], 0);
		SetVehicleToRespawn(jobVehicle[playerid]);
	 	jobVehicle[playerid] = 0;
	 	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	}
	else // Se pudo crear el cronometro
	{
		if(jobCheckpoint[playerid] == 0 || jobCheckpoint[playerid] == 1) // No llegó ni a entregarlo a destino
		{
			SendClientMessage(playerid, COLOR_WHITE, "Te has pasado del tiempo límite: tu jefe se ha enojado y además no recibirás ninguna paga por fallar la entrega.");
            SendClientMessage(playerid, COLOR_WHITE, "Tienes un minuto para devolver la moto a la central. Si no lo haces, tu reputación empeorará aún más.");
			jobCheckpoint[playerid] = 3;
		}
		else if(jobCheckpoint[playerid] == 2) // Ya estaba volviendo para la central
		{
			SendClientMessage(playerid, COLOR_WHITE, "Te has pasado del tiempo límite: tu jefe se ha enojado y solo recibirás la mitad de la paga.");
	    	SendClientMessage(playerid, COLOR_WHITE, "Tienes un minuto para devolver la moto a la central. Si no lo haces, no tendrás paga alguna.");
            jobCheckpoint[playerid] = 4;
		}
	    DisablePlayerCheckpoint(playerid);
	    SetPlayerCheckpoint(playerid, VehicleInfo[jobVehicle[playerid]][VehPosX], VehicleInfo[jobVehicle[playerid]][VehPosY], VehicleInfo[jobVehicle[playerid]][VehPosZ], 2.0);
	}
	return 1;
}

forward DeliJob_ReturnTimeLimit(playerid);
public DeliJob_ReturnTimeLimit(playerid)
{
    jobDuty[playerid] = false;
	SetEngine(jobVehicle[playerid], 0);
	SetVehicleToRespawn(jobVehicle[playerid]);
 	jobVehicle[playerid] = 0;
 	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
 	Job_GiveReputation(playerid, -4);
 	SendClientMessage(playerid, COLOR_WHITE, "[INFO]: No has logrado devolver la moto a la central en el tiempo estipulado. Tu reputación baja unos puntos");
 	return 1;
}
 	
DeliJob_Payment(playerid, vehicleid)
{
	new paycheck, Float:vHealth, injuriesCost, seniorityBonus, chargeBonus;

    GetVehicleHealth(vehicleid, vHealth);
    if(vHealth + 30.0 < jobVehicleHealth[playerid])
    {
        Job_GiveReputation(playerid, -(floatround(jobVehicleHealth[playerid] - vHealth, floatround_ceil) / 10)); // La reputación que baja es proporcional al daño del vehículo (un décimo)
        injuriesCost = floatround(jobVehicleHealth[playerid] - vHealth, floatround_ceil) / 2; // Se le paga x$$$ menos correspondientes a la diferencia de vida en el vehículo / 2.
		SendClientMessage(playerid, COLOR_WHITE, "Tu jefe se enojó con vos ya que entregaste la moto en mal estado.");
	}
	else
	    Job_GiveReputation(playerid, 1);

	seniorityBonus = PlayerJobInfo[playerid][pWorkingHours] * JOB_DELI_BONUS_PER_WORKED_TIMES; // Extra por antiguedad
	chargeBonus = (PlayerJobInfo[playerid][pCharge] - 1) * JOB_DELI_BONUS_PER_CHARGE; // Extra por cargo

	paycheck = JOB_DELI_PAY_PER_WORK + seniorityBonus + chargeBonus - injuriesCost;
	PlayerInfo[playerid][pPayCheck] += paycheck;
	PlayerJobInfo[playerid][pTotalEarnings] += paycheck;

	SendFMessage(playerid, COLOR_WHITE, "¡Enhorabuena! has finalizado la entrega a tiempo y recibirás $%d adicionales en el próximo payday. Puedes hacer %d entrega/s más el día de hoy.", paycheck, JOB_DELI_MAX_DELIVERYS - PlayerInfo[playerid][pCantWork]);
	SendFMessage(playerid, COLOR_WHITE, "[Detalles]: Pago base por entrega: $%d - Bonus por antigüedad: $%d - Bonus por cargo: $%d - Descuento por roturas: ${FF0000}%d", JOB_DELI_PAY_PER_WORK, seniorityBonus, chargeBonus, injuriesCost);

	DeliJob_CheckPromotePlayer(playerid);
	Job_CheckReputationLimit(playerid);
}

DeliJob_CheckPromotePlayer(playerid)
{
	if(400 * PlayerJobInfo[playerid][pCharge] <= PlayerJobInfo[playerid][pWorkingHours] && PlayerJobInfo[playerid][pReputation] >= 0 && PlayerJobInfo[playerid][pCharge] < 5) // Minimo de X horas trabajadas (proporcional al siguiente puesto) y de una imágen laboral neutral.
	{
	    if(PlayerJobInfo[playerid][pWorkingHours] + PlayerJobInfo[playerid][pReputation] / 5 >= 500 * PlayerJobInfo[playerid][pCharge]) // Para ascender hay que llegar a una cantidad de puntos. Nuestro puntaje se suma entre la reputacion y la antiguedad.
	    {
	        PlayerJobInfo[playerid][pCharge]++;
	        SendFMessage(playerid, COLOR_WHITE, "¡Enhorabuena! has sido promovido a %s, lo que te garantiza una mejora en tu sueldo. ¡Buen trabajo! Sigue así.", GetJobChargeName(JOB_DELI, PlayerJobInfo[playerid][pCharge]));
		}
	}
}
