#if defined _marp_tranjob_included
	#endinput
#endif
#define _marp_tranjob_included

#include <YSI_Coding\y_hooks>

//#define JOB_TRAN_PAY_PER_WORK (1200)
#define JOB_TRAN_PAY_PER_WORK    (JobInfo[JOB_TRAN][jBaseSalary])
#define JOB_TRAN_MAX_WORKS_PER_PAYDAY (4)
#define JOB_TRAN_BONUS_PER_WORKED_TIMES (1 / JOB_TRAN_MAX_WORKS_PER_PAYDAY)
#define JOB_TRAN_BONUS_PER_CHARGE (100 / JOB_TRAN_MAX_WORKS_PER_PAYDAY)

new Float:ORDER_FACT_POS[][3] = {
	//Puntos de fábricas de los items a la venta
	{-159.8319, -289.5581, 3.89},	//granja uno fab cerveza
	{65.0551, -288.1800, 1.5800},	//granja dos
	{1334.1057, 287.6548, 19.56},	//fabrica montgomery
	{1355.1854, 363.9382, 20.00},	//montgomery 2
	{-2089.72, -2242.97, 30.990},	//angel pine
	{420.0800, 219.8500, 15.35},	//fabrica norte mapping
	{464.4300, 259.2600, 15.35}	//fabrica norte 2 mapping
};

stock TranJob_ResetOrder(playerid)
{
	if(PO_GetOrderInfo(jobRoute[playerid], PO_INFO_STATE) == ORDER_STATE_INCOMING) //si no llego nisiquiera a dejar la entrega en el negocio
	 	PO_ChangeState(jobRoute[playerid], ORDER_STATE_FREE);
	else //si iba a devolver el camion o a llevar la mercaderia al deposito, lo borramos
		PO_DestroyOrder(jobRoute[playerid], 0);
	jobRoute[playerid] = 0;
}

stock TranJob_GetVehicleCharge(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);
	switch(modelid)
	{
	case 478, 499, 498:			return 1; //Rango 1(Aprendiz) Vehiculos: Walton, Benson, Boxville
	case 440, 459: 				return 2; //Rango 2(Chofer) Vehiculos: Rumpo, RC Van
	case 456, 414: 				return 3; //Rango 3(Chofer de camión) Vehiculos: Yankee, Mule
	case 514, 515, 578, 403: 	return 4; //Rango 4(Chofer de primera linea) Vehiculos: Tanker, Roadtrain, Linerunner, DFT-30
	case 482: 					return 5; //Rango 5(Encargado de logística) Vehiculos: Burrito
	default:					return 0;
	}
	return 0;
}

TranJob_GetTotalDistanceOfJob(playerid, id)
{
	new bizid = PO_GetOrderInfo(id, PO_INFO_BIZ_ID);
	new factoryid = PO_GetOrderInfo(id, PO_INFO_PICKUP_POS);
	new Float:bx = Business[bizid][bDelX], Float:by = Business[bizid][bDelY], Float:bz = Business[bizid][bDelZ];
	new Float:fx = ORDER_FACT_POS[factoryid][0], Float:fy = ORDER_FACT_POS[factoryid][1], Float:fz = ORDER_FACT_POS[factoryid][2];

	return floatround(GetPlayerDistanceFromPoint(playerid, fx, fy, fz) + GetDistance3D(fx, fy, fz, bx, by, bz) + GetPlayerDistanceFromPoint(playerid, bx, by, bz));
}

forward TranJob_TravelTimeLimit(playerid);
public TranJob_TravelTimeLimit(playerid)
{
    PlayerInfo[playerid][pCantWork]++;
    jobDuty[playerid] = false;
    SetEngine(jobVehicle[playerid], 0);
	SetVehicleToRespawn(jobVehicle[playerid]);
 	jobVehicle[playerid] = 0;
 	TranJob_ResetOrder(playerid);
	SendClientMessage(playerid, COLOR_WHITE, "Te has pasado del tiempo límite: tu jefe se ha enojado y además no recibirás ninguna paga el día de hoy.");
	Job_GiveReputation(playerid, -10);
	return 1;
}

stock TranJob_StartWork(playerid, order)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(Veh_GetSystemType(vehicleid) != VEH_JOB || Veh_GetJob(vehicleid) != JOB_TRAN)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes ingresar a un camión de transporte!");
	if(PlayerInfo[playerid][pCarLic] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una licencia de conducir. No podrás trabajar sin ella.");
   	if(Job_IsVehicleWorking(vehicleid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ese vehículo actualmente esta siendo usado para trabajar por otro empleado.");
	if(PlayerInfo[playerid][pCantWork] >= JOB_TRAN_MAX_WORKS_PER_PAYDAY)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya has alcanzado el máximo de entregas posibles por este día de pago.");
	if(TranJob_GetVehicleCharge(vehicleid) > PlayerJobInfo[playerid][pCharge])
	{
		new dif = TranJob_GetVehicleCharge(vehicleid) - PlayerJobInfo[playerid][pCharge];
		if(dif == 1)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu cargo actual no te permite usar este vehículo, debes ascender al menos un puesto mas.");
		else
		{
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu cargo actual no te permite usar este vehiculo, debes ascender al menos %d puestos más.", dif);
			return 1;
		}
	}

    jobRoute[playerid] = PO_OrderToVec(order); //en el job vamos a manipular el vector usando jobRoute para guardar su id
    new time = TranJob_GetTotalDistanceOfJob(playerid, jobRoute[playerid]) / 7;
	if(!Cronometro_Crear(playerid, time, "TranJob_TravelTimeLimit"))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se pudo crear el cronometro asociado al trabajo. Reportar a un administrador.");

	SetPlayerCheckpoint(playerid, ORDER_FACT_POS[PO_GetOrderInfo(jobRoute[playerid], PO_INFO_PICKUP_POS)][0], ORDER_FACT_POS[PO_GetOrderInfo(jobRoute[playerid], PO_INFO_PICKUP_POS)][1], ORDER_FACT_POS[PO_GetOrderInfo(jobRoute[playerid], PO_INFO_PICKUP_POS)][2], 5.0);
	PlayerActionMessage(playerid, 15.0, "ha encendido el motor del vehículo.");
	SendClientMessage(playerid, COLOR_WHITE, "Vé a buscar la mercadería en el camión. Luego tendrás que entregar el pedido en el negocio.");
    SendClientMessage(playerid, COLOR_WHITE, "Debes terminar el encargo en el tiempo indicado. Si llegas más tarde no se te pagará, y tu imagen laboral empeorará.");
    SendClientMessage(playerid, COLOR_WHITE, "Recuerda también que si entregas el camión en peor estado del que lo recibiste, tu imagen laboral disminuirá.");
	jobDuty[playerid] = true;
	GetVehicleHealth(vehicleid, jobVehicleHealth[playerid]);
	SetEngine(vehicleid, 1);
	jobVehicle[playerid] = vehicleid;
	jobCheckpoint[playerid] = 0;
	PO_ChangeState(jobRoute[playerid], ORDER_STATE_INCOMING);
	UpdatePlayerJobLastWorked(playerid);
	return 1;
}

forward TranJob_NextCheckpoint(playerid, cp);
public TranJob_NextCheckpoint(playerid, cp)
{
	TogglePlayerControllable(playerid, true);
	switch(cp)
	{
		case 0:
		{
			SetPlayerCheckpoint(playerid, ORDER_FACT_POS[PO_GetOrderInfo(jobRoute[playerid], PO_INFO_PICKUP_POS)][0], ORDER_FACT_POS[PO_GetOrderInfo(jobRoute[playerid], PO_INFO_PICKUP_POS)][1], ORDER_FACT_POS[PO_GetOrderInfo(jobRoute[playerid], PO_INFO_PICKUP_POS)][2], 5.0);
		}
		case 1: // llegó a la fabrica y tiene q entregar la mercaderia en el negocio
		{
			SendClientMessage(playerid, COLOR_WHITE, "Bien, ahora lleva el pedido al negocio indicado en el mapa.");
			SetPlayerCheckpoint(playerid, Business[PO_GetOrderInfo(jobRoute[playerid], PO_INFO_BIZ_ID)][bDelX], Business[PO_GetOrderInfo(jobRoute[playerid], PO_INFO_BIZ_ID)][bDelY], Business[PO_GetOrderInfo(jobRoute[playerid], PO_INFO_BIZ_ID)][bDelZ], 5.0);
		}
		case 2: //entregó la mercaderia en el negocio y tiene q devolver el camión
		{
			SendClientMessage(playerid, COLOR_WHITE, "Excelente, ahora ya puedes devolver el vehículo a la central");
			SetPlayerCheckpoint(playerid, VehicleInfo[jobVehicle[playerid]][VehPosX], VehicleInfo[jobVehicle[playerid]][VehPosY], VehicleInfo[jobVehicle[playerid]][VehPosZ], 5.0);
		}
		case 3: //no pudo entregar porque el negocio no podia pagar el encargo
		{
			SendClientMessage(playerid, COLOR_WHITE, "El negocio no pudo pagar la entrega... Debes dejar la mercaderia en un deposito.");
			SetPlayerCheckpoint(playerid, 2011.7183, -1282.1256, 23.9852, 5.0);
		}
	}
	return 1;
}

TranJob_IsPlayerWorking(playerid, vehicleid)
{
	if(PlayerInfo[playerid][pJob] == JOB_TRAN && jobDuty[playerid] && VehicleInfo[vehicleid][VehJob] == JOB_TRAN)
	    return 1;
	return 0;
}
	    
hook function OnPlayerEnterCPId(playerid, checkpointid)
{
	if(!IsPlayerInAnyVehicle(playerid) && PlayerInfo[playerid][pJob] == JOB_TRAN && jobDuty[playerid])
	{
		SetTimerEx("TranJob_NextCheckpoint", 5000, false, "ii", playerid, jobCheckpoint[playerid]); // Le vuelvo a poner el checkpoint al que no pudo entrar, pero despues de unos segundos.
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en el camión de transporte con el que empezaste a trabajar!");
		return 1;
	}
	if(PlayerInfo[playerid][pJob] == JOB_TRAN && jobDuty[playerid] && jobVehicle[playerid] != GetPlayerVehicleID(playerid))
	{
		SetTimerEx("TranJob_NextCheckpoint", 5000, false, "ii", playerid, jobCheckpoint[playerid]); // Le vuelvo a poner el checkpoint al que no pudo entrar, pero despues de unos segundos.
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar en el camión de transporte con el que empezaste a trabajar!");
		return 1;
	}

	if(!IsPlayerInAnyVehicle(playerid))
		return continue(playerid, checkpointid);
	if(!TranJob_IsPlayerWorking(playerid, GetPlayerVehicleID(playerid)))
		return continue(playerid, checkpointid);

	new actualCP = jobCheckpoint[playerid], vehicleid = GetPlayerVehicleID(playerid);	

	if(actualCP == 0)
	{
		//SETEAMOS UNA CAJA DE PRODUCTOS EN LA MANO DEL TIPO
		GameTextForPlayer(playerid, "Cargando mercaderia...", 8000, 4);
		TogglePlayerControllable(playerid, false);
		SetTimerEx("TranJob_NextCheckpoint", 8000, false, "ii", playerid, actualCP + 1);
		jobCheckpoint[playerid]++;
	}
	else if(actualCP == 1)
	{ 
		if(PO_SetOrderToBiz(jobRoute[playerid]))	//si entra es porq el negocio pudo pagar el pedido
		{
			GameTextForPlayer(playerid, "Descargando mercaderia...", 5000, 4);
	    	TogglePlayerControllable(playerid, false);
	    	SetTimerEx("TranJob_NextCheckpoint", 5000, false, "ii", playerid, actualCP + 1);
	    	jobCheckpoint[playerid]++;
		}
		else
		{ //el negocio no pudo pagar el pedido
			GameTextForPlayer(playerid, "Algo no anda bien...", 5000, 4);
	    	TogglePlayerControllable(playerid, false);
	    	SetTimerEx("TranJob_NextCheckpoint", 5000, false, "ii", playerid, actualCP + 2);
	    	jobCheckpoint[playerid] += 2;
		}
	    
	}
	else if(actualCP == 2)
	{
 		PlayerJobInfo[playerid][pWorkingHours]++;
		TranJob_Payment(playerid, vehicleid);
		RemovePlayerFromVehicle(playerid);
  		SetEngine(vehicleid, 0);
		SetVehicleToRespawn(vehicleid);
	    PlayerInfo[playerid][pCantWork]++;
	    jobDuty[playerid] = false;
	    jobVehicle[playerid] = 0;
	   	PO_DestroyOrder(jobRoute[playerid], 0);
	    jobRoute[playerid] = 0;
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		PlayerActionMessage(playerid, 15.0, "estaciona el camion de transporte en su lugar.");
		Cronometro_Borrar(playerid);
	}
	else if(actualCP == 3)
	{
		GameTextForPlayer(playerid, "Descargando mercaderia...", 5000, 4);
	    TogglePlayerControllable(playerid, false);
	    SetTimerEx("TranJob_NextCheckpoint", 5000, false, "ii", playerid, actualCP - 1);
	    jobCheckpoint[playerid]--;
	}
	return 1;
}

stock TranJob_Payment(playerid, vehicleid)
{
	new paycheck, Float:vHealth, injuriesCost, seniorityBonus, chargeBonus;
		
    GetVehicleHealth(vehicleid, vHealth);
    if(vHealth + 30.0 < jobVehicleHealth[playerid])
    {
        Job_GiveReputation(playerid, -(floatround(jobVehicleHealth[playerid] - vHealth, floatround_ceil) / 10)); // La reputación que baja es proporcional al daño del vehículo (un décimo)
        injuriesCost = floatround(jobVehicleHealth[playerid] - vHealth, floatround_ceil); // Se le paga x$$$ menos correspondientes a la diferencia de vida en el vehículo.
		SendClientMessage(playerid, COLOR_WHITE, "Tu jefe se enojó con vos ya que entregaste el vehículo en mal estado.");
	}
	else
		if(TranJob_GetVehicleCharge(vehicleid) == PlayerJobInfo[playerid][pCharge])
	    	Job_GiveReputation(playerid, 2);
	    else
	    	Job_GiveReputation(playerid, 1);

	seniorityBonus = PlayerJobInfo[playerid][pWorkingHours] * JOB_TRAN_BONUS_PER_WORKED_TIMES; // Extra por antiguedad
	chargeBonus = (PlayerJobInfo[playerid][pCharge] - 1) * JOB_TRAN_BONUS_PER_CHARGE; // Extra por cargo
	
	paycheck = JOB_TRAN_PAY_PER_WORK + seniorityBonus + chargeBonus - injuriesCost;
	PlayerInfo[playerid][pPayCheck] += paycheck;
	PlayerJobInfo[playerid][pTotalEarnings] += paycheck;
	
	SendFMessage(playerid, COLOR_WHITE, "¡Enhorabuena! has finalizado tu trabajo y recibirás $%d en el próximo payday.", paycheck);
	SendFMessage(playerid, COLOR_WHITE, "[Detalles]: Salario base: $%d - Bonus por antiguedad: $%d - Bonus por cargo: $%d - Descuento por roturas: ${FF0000}%d", JOB_TRAN_PAY_PER_WORK, seniorityBonus, chargeBonus, injuriesCost);

	TranJob_CheckPromotePlayer(playerid);
	Job_CheckReputationLimit(playerid);
}

TranJob_CheckPromotePlayer(playerid)
{
	if(100 * PlayerJobInfo[playerid][pCharge] <= PlayerJobInfo[playerid][pWorkingHours] && PlayerJobInfo[playerid][pReputation] >= 0 && PlayerJobInfo[playerid][pCharge] < 5) //50 horas por puesto, haciendo 2 entregas por hora. Minimo de encargos realizados (100 por puesto) y de una imágen laboral neutral.
	{
	    if(PlayerJobInfo[playerid][pWorkingHours] + PlayerJobInfo[playerid][pReputation] * 2 >= 500 * PlayerJobInfo[playerid][pCharge]) // Para ascender hay que llegar a una cantidad de puntos. Nuestro puntaje se suma entre la reputacion y la antiguedad.
	    {
	        PlayerJobInfo[playerid][pCharge]++;
	        SendFMessage(playerid, COLOR_WHITE, "¡Enhorabuena! has sido promovido a %s, lo que te garantiza una mejora en tu sueldo. ¡Buen trabajo! Sigue así.", GetJobChargeName(JOB_TRAN, PlayerJobInfo[playerid][pCharge]));
		}
	}
}
