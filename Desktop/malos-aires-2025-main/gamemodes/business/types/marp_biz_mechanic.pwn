#if defined _marp_biz_mechanic_included
	#endinput
#endif
#define _marp_biz_mechanic_included

#include <YSI_Coding\y_hooks>

#define MEC_MAX_PRICE 1000

enum
{
	MEC_OFFER_NONE,
	MEC_OFFER_TOW,
	MEC_OFFER_REPAIR,
	MEC_OFFER_TUNING,
	MEC_OFFER_UNTUNING,
	MEC_OFFER_KEY
}

static Mec_Offer[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
static Mec_OfferPrice[MAX_PLAYERS] = {0, ...};
static Mec_OfferParts[MAX_PLAYERS] = {0, ...};
static Mec_OfferType[MAX_PLAYERS] = {MEC_OFFER_NONE, ...};

/****************************************************************************************************************

    ____                 __  _                     ___                  ______               __
   / __/_  ______  _____/ /_(_)___  ____  _____   ( _ )     _________ _/ / / /_  ____ ______/ /_______
  / /_/ / / / __ \/ ___/ __/ / __ \/ __ \/ ___/  / __ \/|  / ___/ __ `/ / / __ \/ __ `/ ___/ //_/ ___/
 / __/ /_/ / / / / /__/ /_/ / /_/ / / / (__  )  / /_/  <  / /__/ /_/ / / / /_/ / /_/ / /__/ ,< (__  )
/_/  \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/   \____/\/  \___/\__,_/_/_/_.___/\__,_/\___/_/|_/____/


*****************************************************************************************************************/

hook OnPlayerDisconnect(playerid, reason)
{
	Mec_Offer[playerid] = INVALID_PLAYER_ID;
	Mec_OfferPrice[playerid] = 0;
	Mec_OfferParts[playerid] = 0;
	Mec_OfferType[playerid] = MEC_OFFER_NONE;
	return 1;
}

/*Mec_VehicleIsBehindVehicle(vehicleid, targetvehid, Float:tol = 1.0)
{
	new Float:distance, Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;

	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, x1, y1, z1);
	distance = (y1 / 2) + 0.5;
	GetXYZBehindVehicle(vehicleid, x1, y1, z1, distance);

	GetVehicleModelInfo(GetVehicleModel(targetvehid), VEHICLE_MODEL_INFO_SIZE, x2, y2, z2);
	distance = (y2 / 2) + 0.3;
	GetXYZInFrontVehicle(targetvehid, x2, y2, z2, distance);

	distance = GetDistance3D(x1, y1, z1, x2, y2, z2);
	return (distance <= tol);
}*/

Mec_CanTowVehicle(vehicleid) {
	return (Veh_GetModelType(vehicleid) == VTYPE_CAR || Veh_GetModelType(vehicleid) == VTYPE_HEAVY || Veh_GetModelType(vehicleid) == VTYPE_QUAD || Veh_GetModelType(vehicleid) == VTYPE_MONSTER);
}

stock Mec_GetMaterialRepairCost(vehicleid)
{
	new parts = 1, Float:vhp;

	GetVehicleHealth(vehicleid, vhp);

	if(vhp <= 750.0)
	{
		switch (GetVehicleModel(vehicleid)) 
		{
			case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: {
				parts = floatround(((750.0 - vhp) / 150), floatround_ceil);
			}
			default: {
				parts = floatround(((750.0 - vhp) / 75), floatround_ceil);
			}
		}
	}
	return parts;
}

forward Mec_RepairVehicle(playerid, mechanic, price, parts);
public Mec_RepairVehicle(playerid, mechanic, price, parts)
{
	new bizid = BizEmp_GetBizId(mechanic);
	new vehicleid = GetPlayerVehicleID(playerid), listitem = GetBizItemIndex(bizid, ITEM_ID_REPUESTOAUTO);
	new minamount =  parts * GetBizItemPrice(bizid, listitem);

	TogglePlayerControllable(playerid, true);

	RepairVehicle(vehicleid);
	VehicleInfo[vehicleid][VehHP] = 100;
	VW_OnWorkshopRepair(vehicleid);

	BusinessCatalog[bizid][listitem][bStock] -= parts;
	Biz_AddTill(bizid, minamount);
	Biz_UpdateSQLItemStock(bizid, listitem);

	SendFMessage(playerid, COLOR_YELLOW2, "Su vehículo ha sido reparado por %s (costo: $%d).", GetPlayerCleanName(mechanic), price);
	SendFMessage(mechanic, COLOR_YELLOW2, "Reparaste el vehículo de %s, $%d han sido añadidos a tu PayDay.", GetPlayerCleanName(playerid), price - minamount);

	if (GetPlayerCash(playerid) < price) {
		PlayerInfo[playerid][pBank] -= price;
	} else {
		GivePlayerCash(playerid, -price);
	}

	PlayerInfo[mechanic][pPayCheck] += price - minamount;
	return 1;
}

forward Mec_ChangeVehicleKey(playerid, mechanic, price, parts);
public Mec_ChangeVehicleKey(playerid, mechanic, price)
{
	new bizid = BizEmp_GetBizId(mechanic);
	new vehicleid = GetPlayerVehicleID(playerid);
	new bizmoney = floatround(price * 0.25, floatround_round);

	TogglePlayerControllable(playerid, true);

	Biz_AddTill(bizid, bizmoney);
	
	KeyChain_DeleteAll(KEY_TYPE_VEHICLE, vehicleid, .allowIfOwnerKey = false);

	SendFMessage(playerid, COLOR_YELLOW2, "La cerradura de su vehículo ha sido cambiada por %s (costo: $%d).", GetPlayerCleanName(mechanic), price);
	SendFMessage(mechanic, COLOR_YELLOW2, "Cambiaste la cerradura del vehículo de %s, $%d han sido añadidos a tu PayDay.", GetPlayerCleanName(playerid), price - bizmoney);

	if (GetPlayerCash(playerid) < price) {
		PlayerInfo[playerid][pBank] -= price;
	} else {
		GivePlayerCash(playerid, -price);
	}

	PlayerInfo[mechanic][pPayCheck] += price - bizmoney;
	return 1;
}

hook function OnPlayerCmdAccept(playerid, const subcmd[])
{
	if(!strcmp(subcmd, "remolque", true))
	{
		new offerid = Mec_Offer[playerid];
		new offertype = Mec_OfferType[playerid];
		Mec_Offer[playerid] = INVALID_PLAYER_ID;
		Mec_OfferType[playerid] = MEC_OFFER_NONE;

		if(offerid == INVALID_PLAYER_ID || offertype != MEC_OFFER_TOW)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció remolcar tu vehículo.");
		if(!IsPlayerLogged(offerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El mecánico que te ofreció remolcar tu vehículo se desconectó.");
		if(GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tenés que estar de pasajero en un vehículo.");
		new towvehid = GetPlayerVehicleID(offerid);
		new vehicleid = GetPlayerVehicleID(playerid);

		if(GetVehicleModel(towvehid) != 525 || GetPlayerState(offerid) != PLAYER_STATE_DRIVER)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El mecánico debe estar conduciendo una grúa.");

		AttachTrailerToVehicle(vehicleid, towvehid);		
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu vehículo fue remolcado, ya puedes bajarte si quieres, recuerda no entrar de conductor.");	
		SendClientMessage(offerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" Has remolcado un vehículo, para dejar de remolcarlo utiliza '/mecremolcar'.");	
		return 1;
	}

	if(!strcmp(subcmd, "reparacion", true))
	{
		new offerid = Mec_Offer[playerid];
		new price = Mec_OfferPrice[playerid];
		new parts = Mec_OfferParts[playerid];
		new offertype = Mec_OfferType[playerid];

		Mec_Offer[playerid] = INVALID_PLAYER_ID;
		Mec_OfferPrice[playerid] = 0;
		Mec_OfferParts[playerid] = 0;
		Mec_OfferType[playerid] = MEC_OFFER_NONE;

		if(offerid == INVALID_PLAYER_ID || offertype != MEC_OFFER_REPAIR)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció reparar tu vehículo.");
		if(!IsPlayerLogged(offerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El mecánico que te ofreció reparar tu vehículo se desconectó.");
		if(GetPlayerCash(playerid) <= price && PlayerInfo[playerid][pBank] <= price)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero suficiente.");

		new vehicleid = GetPlayerVehicleID(playerid);

		if(!vehicleid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo.");

		GameTextForPlayer(playerid, "El mecanico esta reparando su vehiculo...", 6000, 1);
		GameTextForPlayer(offerid, "Reparando vehiculo...", 6000, 1);
		TogglePlayerControllable(playerid, false);
		SetTimerEx("Mec_RepairVehicle", 6000, false, "iiii", playerid, offerid, price, parts);	
		return 1;
	}

	if(!strcmp(subcmd, "tuneo", true))
	{
		new offerid = Mec_Offer[playerid];
		new offertype = Mec_OfferType[playerid];

		if(offerid == INVALID_PLAYER_ID || offertype != MEC_OFFER_TUNING)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció tunear tu vehículo.");
		if(!IsPlayerLogged(offerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El mecánico que te ofreció tunear tu vehículo se desconectó.");
		if(TuningGUI_IsTuning(playerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya estás tuneando tu vehículo.");
		new vehicleid = GetPlayerVehicleID(playerid);

		if(!vehicleid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo.");
		TuningGUI_Open(playerid);
		return 1;
	}

	if(!strcmp(subcmd, "destuneo", true))
	{
		new offerid = Mec_Offer[playerid];
		new offertype = Mec_OfferType[playerid];

		if(offerid == INVALID_PLAYER_ID || offertype != MEC_OFFER_UNTUNING)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció destunear tu vehículo.");
		if(!IsPlayerLogged(offerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El mecánico que te ofreció destunear tu vehículo se desconectó.");

		new vehicleid = GetPlayerVehicleID(playerid);

		if(!vehicleid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo.");

		TuningGUI_ShowRemoveDialog(playerid);
		return 1;
	}

	if(!strcmp(subcmd, "cerradura", true))
	{
		new offerid = Mec_Offer[playerid];
		new price = Mec_OfferPrice[playerid];
		new offertype = Mec_OfferType[playerid];

		Mec_Offer[playerid] = INVALID_PLAYER_ID;
		Mec_OfferPrice[playerid] = 0;
		Mec_OfferParts[playerid] = 0;
		Mec_OfferType[playerid] = MEC_OFFER_NONE;

		if(offerid == INVALID_PLAYER_ID || offertype != MEC_OFFER_KEY)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció remolcar tu vehículo.");
		if(!IsPlayerLogged(offerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El mecánico que te ofreció reparar tu vehículo se desconectó.");
		if(GetPlayerCash(playerid) <= price && PlayerInfo[playerid][pBank] <= price)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero suficiente.");
		new vehicleid = GetPlayerVehicleID(playerid);

		if(!vehicleid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un vehículo.");
		GameTextForPlayer(playerid, "El mecanico esta cambiando la cerradura de tu vehiculo...", 6000, 1);
		GameTextForPlayer(offerid, "Cambiando cerradura vehiculo...", 6000, 1);
		TogglePlayerControllable(playerid, false);
		SetTimerEx("Mec_ChangeVehicleKey", 6000, false, "iiii", playerid, offerid, price);	
		return 1;
	}

	return continue(playerid, subcmd);
}

hook function OnPlayerCmdCancel(playerid, const subcmd[])
{
	if(!strcmp(subcmd, "remolque", true))
	{
		new offerid = Mec_Offer[playerid];
		new offertype = Mec_OfferType[playerid];

		if(offerid != INVALID_PLAYER_ID || offertype != MEC_OFFER_TOW)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció remolcar tu vehículo.");

		Mec_Offer[playerid] = INVALID_PLAYER_ID;
		Mec_OfferType[playerid] = MEC_OFFER_NONE;

		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cancelaste la oferta de remolque de tu vehículo.");	
		SendFMessage(offerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s ha cancelado la oferta de remolcar su vehículo.", GetPlayerCleanName(playerid));	
		return 1;
	}

	if(!strcmp(subcmd, "reparacion", true))
	{
		new offerid = Mec_Offer[playerid];
		new offertype = Mec_OfferType[playerid];
		
		if(offerid != INVALID_PLAYER_ID || offertype != MEC_OFFER_REPAIR)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció reparar tu vehículo.");

		Mec_Offer[playerid] = INVALID_PLAYER_ID;
		Mec_OfferPrice[playerid] = 0;
		Mec_OfferParts[playerid] = 0;
		Mec_OfferType[playerid] = MEC_OFFER_NONE;

		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cancelaste la oferta de reparación de tu vehículo.");	
		SendFMessage(offerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s ha cancelado la oferta de reparación su vehículo.", GetPlayerCleanName(playerid));
		return 1;
	}

	if(!strcmp(subcmd, "tuneo", true))
	{
		new offerid = Mec_Offer[playerid];
		new offertype = Mec_OfferType[playerid];
		
		if(offerid != INVALID_PLAYER_ID || offertype != MEC_OFFER_TUNING)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció tunear tu vehículo.");

		Mec_Offer[playerid] = INVALID_PLAYER_ID;
		Mec_OfferPrice[playerid] = 0;
		Mec_OfferParts[playerid] = 0;
		Mec_OfferType[playerid] = MEC_OFFER_NONE;

		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cancelaste la oferta de tuneo de tu vehículo.");	
		SendFMessage(offerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s ha cancelado la oferta de tueno su vehículo.", GetPlayerCleanName(playerid));
		return 1;
	}

	if(!strcmp(subcmd, "destuneo", true))
	{
		new offerid = Mec_Offer[playerid];
		new offertype = Mec_OfferType[playerid];
		
		if(offerid != INVALID_PLAYER_ID || offertype != MEC_OFFER_UNTUNING)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció destunear tu vehículo.");

		Mec_Offer[playerid] = INVALID_PLAYER_ID;
		Mec_OfferPrice[playerid] = 0;
		Mec_OfferParts[playerid] = 0;
		Mec_OfferType[playerid] = MEC_OFFER_NONE;

		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cancelaste la oferta de destuneo de tu vehículo.");	
		SendFMessage(offerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s ha cancelado la oferta de destueno su vehículo.", GetPlayerCleanName(playerid));
		return 1;
	}

	if(!strcmp(subcmd, "cerradura", true))
	{
		new offerid = Mec_Offer[playerid];
		new offertype = Mec_OfferType[playerid];
		
		if(offerid != INVALID_PLAYER_ID || offertype != MEC_OFFER_KEY)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te ofreció cambiar la cerradura de tu vehículo.");

		Mec_Offer[playerid] = INVALID_PLAYER_ID;
		Mec_OfferPrice[playerid] = 0;
		Mec_OfferParts[playerid] = 0;
		Mec_OfferType[playerid] = MEC_OFFER_NONE;

		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cancelaste la oferta de cambio de cerradura de tu vehículo.");	
		SendFMessage(offerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s ha cancelado la oferta de cambio de cerradura su vehículo.", GetPlayerCleanName(playerid));
		return 1;
	}

	return continue(playerid, subcmd);
}

Mec_GetBizTuningParts(playerid)
{
	new bizid = BizEmp_GetBizId(Mec_Offer[playerid]);
	new listitem = GetBizItemIndex(bizid, ITEM_ID_TUNING_PART);

	return GetBizItemStock(bizid, listitem);
}

Mec_GetPriceForTuning(playerid)
{
	new bizid = BizEmp_GetBizId(Mec_Offer[playerid]);
	new listitem = GetBizItemIndex(bizid, ITEM_ID_TUNING_PART);

	return 	floatround(GetBizItemPrice(bizid, listitem) * 1.10, floatround_round); // 10% mas de mano de obra por pieza.
}

Mec_PayTuning(playerid, price)
{
	new mechanic = Mec_Offer[playerid];
	new bizid = BizEmp_GetBizId(mechanic);
	new partprice = Mec_GetPriceForTuning(playerid);
	new parts = floatround(price / partprice, floatround_round);

	Mec_Offer[playerid] = INVALID_PLAYER_ID;
	Mec_OfferPrice[playerid] = 0;
	Mec_OfferParts[playerid] = 0;
	Mec_OfferType[playerid] = MEC_OFFER_NONE;

	new listitem = GetBizItemIndex(bizid, ITEM_ID_TUNING_PART);

	BusinessCatalog[bizid][listitem][bStock] -= parts;
	Biz_AddTill(bizid, floatround(price * 0.9, floatround_round));
	Biz_UpdateSQLItemStock(bizid, listitem);

	new pay = floatround(price * 0.1, floatround_round);

	SendFMessage(playerid, COLOR_YELLOW2, "Su vehículo ha sido tuneado por %s (costo: $%d).", GetPlayerCleanName(mechanic), price);
	SendFMessage(mechanic, COLOR_YELLOW2, "Tuneaste el vehículo de %s, $%d han sido añadidos a tu PayDay.", GetPlayerCleanName(playerid), pay);

	if (GetPlayerCash(playerid) < price) {
		PlayerInfo[playerid][pBank] -= price;
	} else {
		GivePlayerCash(playerid, -price);
	}

	PlayerInfo[mechanic][pPayCheck] += pay;

	TuningGUI_OnTuningPayed(playerid);
	return 1;
}

Mec_OnUnTuningFinish(playerid)
{
	Mec_Offer[playerid] = INVALID_PLAYER_ID;
	Mec_OfferPrice[playerid] = 0;
	Mec_OfferParts[playerid] = 0;
	Mec_OfferType[playerid] = MEC_OFFER_NONE;
	return 1;
}

/****************************************************************************************

                                                  __    
  _________  ____ ___  ____ ___  ____ _____  ____/ /____
 / ___/ __ \/ __ `__ \/ __ `__ \/ __ `/ __ \/ __  / ___/
/ /__/ /_/ / / / / / / / / / / / /_/ / / / / /_/ (__  ) 
\___/\____/_/ /_/ /_/_/ /_/ /_/\__,_/_/ /_/\__,_/____/  


****************************************************************************************/

CMD:mecremolcar(playerid, params[])
{
	if(!BizEmp_IsEmployeeOfType(playerid, BIZ_MECH))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes usar este comando.");

	new vehicleid = GetPlayerVehicleID(playerid);

	if(GetVehicleModel(vehicleid) != 525 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes que estar conduciendo una grúa.");
	if(IsTrailerAttachedToVehicle(vehicleid)) 
	{
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has dejado de remolcar un vehículo.");
		return DetachTrailerFromVehicle(vehicleid);
	}
		
	new targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mecremolcar [ID/Jugador]");
	if(!IsPlayerLogged(targetid) || playerid == targetid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(GetPlayerState(targetid) != PLAYER_STATE_PASSENGER)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El otro jugador debe estar de pasajero en un vehículo.");
	if(Mec_Offer[targetid] != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El otro jugador ya posee una oferta de otro mecánico.");
	if(!IsPlayerInRangeOfPlayer(4.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El otro jugador debe estar cerca tuyo.");

	new targetvehid = GetPlayerVehicleID(targetid);

	if(!Mec_CanTowVehicle(targetvehid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este vehículo no se puede remolcar.");

	Mec_Offer[targetid] = playerid;	
	Mec_OfferType[targetid] = MEC_OFFER_TOW;
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te ofreció remolcar tu vehículo. Utiliza '/aceptar remolque' para aceptarlo o '/cancelar remolque'.", GetPlayerCleanName(playerid));
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Has ofrecido remolcar el vehículo de %s.", GetPlayerCleanName(targetid));
	return 1;
}

CMD:mecreparar(playerid, params[])
{
	if(!BizEmp_IsEmployeeOfType(playerid, BIZ_MECH))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes usar este comando.");

	new targetid, price, vehicleid, bizid = BizEmp_GetBizId(playerid), listitem = GetBizItemIndex(bizid, ITEM_ID_REPUESTOAUTO);

	if(sscanf(params, "ui", targetid, price))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mecreparar [ID/Jugador] [Pecio]");
	if(!IsPlayerLogged(targetid) || playerid == targetid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(listitem == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay repuestos a la venta.");
	if(!GetBizItemStock(bizid, listitem))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay repuestos en stock.");
	if(Mec_Offer[targetid] != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El otro jugador ya posee una oferta de otro mecánico.");
	new Float:x, Float:y, Float:z;
	Biz_GetBuyingPointPos(bizid, x, y, z);
	if(!IsPlayerInRangeOfPoint(playerid, 50.0, x, y, z))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar cerca de la caja del negocio.");
	vehicleid = GetPlayerVehicleID(targetid);
	new parts = Mec_GetMaterialRepairCost(vehicleid);
	new minamount =  parts * GetBizItemPrice(bizid, listitem);

	if(GetBizItemStock(bizid, listitem) < parts)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay suficientes repuestos en stock.");
	
	if(!vehicleid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El otro jugador debe estar en un vehículo.");
	if(price < minamount || price > MEC_MAX_PRICE) 
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El precio debe ser entre $%i (El costo material) y $%i.", minamount, MEC_MAX_PRICE);
		return 1;
	}
	
	Mec_Offer[targetid] = playerid;
	Mec_OfferPrice[targetid] = price;
	Mec_OfferParts[targetid] = parts;
	Mec_OfferType[targetid] = MEC_OFFER_REPAIR;
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te ofreció reparar tu vehículo por $%i. Utiliza '/aceptar reparacion' para aceptarlo o '/cancelar reparacion'.", GetPlayerCleanName(playerid), price);
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Has ofrecido reparar el vehículo de %s.", GetPlayerCleanName(targetid));
	return 1;
}

CMD:mectunear(playerid, params[])
{
	if(!BizEmp_IsEmployeeOfType(playerid, BIZ_MECH))
		return SendClientMessage(playerid, COLOR_YELLOW2, " ¡No puedes usar este comando!");

	new targetid, vehicleid, bizid = BizEmp_GetBizId(playerid), listitem = GetBizItemIndex(bizid, ITEM_ID_TUNING_PART);

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mectunear [ID/Jugador]");
	if(!IsPlayerLogged(targetid) || playerid == targetid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(listitem == -1)
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡No hay piezas de tuneo a la venta!");
	if(!GetBizItemStock(bizid, listitem))
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡No hay piezas de tuneo en stock!");
	if(Mec_Offer[targetid] != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador ya posee una oferta de un mecánico.");
	if(TuningGUI_IsTuning(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador ya esta tuneando su vehículo.");

	new Float:x, Float:y, Float:z;
	Biz_GetBuyingPointPos(bizid, x, y, z);
	if(!IsPlayerInRangeOfPoint(playerid, 50.0, x, y, z))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar cerca de la caja del negocio.");

	vehicleid = GetPlayerVehicleID(targetid);
	
	if(!vehicleid)
		return SendClientMessage(playerid, COLOR_YELLOW2, " ¡El jugador debe estar en un vehículo!");
	
	Mec_Offer[targetid] = playerid;
	Mec_OfferParts[targetid] = 1;
	Mec_OfferType[targetid] = MEC_OFFER_TUNING;
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te ofreció tunear tu vehículo. Utiliza '/aceptar tuneo' para aceptarlo o '/cancelar tuneo'.", GetPlayerCleanName(playerid));
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Has ofrecido tunear el vehículo de %s.", GetPlayerCleanName(targetid));
	return 1;
}

CMD:mecdestunear(playerid, params[])
{
	if(!BizEmp_IsEmployeeOfType(playerid, BIZ_MECH))
		return SendClientMessage(playerid, COLOR_YELLOW2, " ¡No puedes usar este comando!");

	new targetid, vehicleid, bizid = BizEmp_GetBizId(playerid);

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mecdestunear [ID/Jugador]");
	if(!IsPlayerLogged(targetid) || playerid == targetid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(Mec_Offer[targetid] != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador ya posee una oferta de un mecánico.");

	new Float:x, Float:y, Float:z;
	Biz_GetBuyingPointPos(bizid, x, y, z);
	if(!IsPlayerInRangeOfPoint(playerid, 50.0, x, y, z))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar cerca de la caja del negocio.");

	vehicleid = GetPlayerVehicleID(targetid);
	
	if(!vehicleid)
		return SendClientMessage(playerid, COLOR_YELLOW2, " ¡El jugador debe estar en un vehículo!");
	
	Mec_Offer[targetid] = playerid;
	Mec_OfferParts[targetid] = 1;
	Mec_OfferType[targetid] = MEC_OFFER_UNTUNING;
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te ofreció destunear tu vehículo. Utiliza '/aceptar destuneo' para aceptarlo o '/cancelar destuneo'.", GetPlayerCleanName(playerid));
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Has ofrecido destunear el vehículo de %s.", GetPlayerCleanName(targetid));
	return 1;
}

CMD:meccerradura(playerid, params[])
{
	if(!BizEmp_IsEmployeeOfType(playerid, BIZ_MECH))
		return SendClientMessage(playerid, COLOR_YELLOW2, " ¡No puedes usar este comando!");

	new targetid, vehicleid, bizid = BizEmp_GetBizId(playerid), price;

	if(sscanf(params, "ui", targetid, price))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/meccerradura [ID/Jugador] [Precio]");
	if(!IsPlayerLogged(targetid) || playerid == targetid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(Mec_Offer[targetid] != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador ya posee una oferta de un mecánico.");

	new Float:x, Float:y, Float:z;
	Biz_GetBuyingPointPos(bizid, x, y, z);
	if(!IsPlayerInRangeOfPoint(playerid, 50.0, x, y, z))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar cerca de la caja del negocio.");

	vehicleid = GetPlayerVehicleID(targetid);
	
	if(!vehicleid)
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡El jugador debe estar en un vehículo!");
	
	if(!(0 <= price <= MEC_MAX_PRICE)) 
	{
		SendFMessage(playerid, COLOR_YELLOW2, "El precio debe ser entre $0 y $%i.", MEC_MAX_PRICE);
		return 1;
	}
	
	Mec_Offer[targetid] = playerid;
	Mec_OfferPrice[targetid] = price;
	Mec_OfferType[targetid] = MEC_OFFER_KEY;
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te ofreció cambiar la cerradura tu vehículo por $%i. Utiliza '/aceptar cerradura' para aceptarlo o '/cancelar cerradura'.", GetPlayerCleanName(playerid), price);
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Has ofrecido cambiar la cerradura el vehículo de %s.", GetPlayerCleanName(targetid));
	return 1;
}

CMD:mecguardar(playerid, params[])
{
	new bizid = Biz_IsPlayerOutsideOrInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");
	if(GetBusinessType(bizid) != BIZ_MECH)
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡El negocio debe ser un taller!");
	
	new repshand = SearchHandsForItem(playerid, ITEM_ID_REPUESTOAUTO);

	if(repshand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener repuestos de auto en una de tus manos.");

	new amount = GetHandParam(playerid, repshand);
	new listitem = GetBizItemIndex(bizid, ITEM_ID_REPUESTOAUTO);
	SetHandItemAndParam(playerid, repshand, 0, 0);

	BusinessCatalog[bizid][listitem][bStock] += amount;
	Biz_UpdateSQLItemStock(bizid, listitem);
	
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has guardado %i repuestos en el negocio.", amount);
	return 1;
}

CMD:mecayuda(playerid, params[])
{
	if(!BizEmp_IsEmployeeOfType(playerid, BIZ_MECH))
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡No puedes usar este comando!");

	SendClientMessage(playerid, COLOR_WHITE, "_____________________________________[ MECÁNICO ]______________________________________");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /mecremolcar - /mecreparar - /mectunear - /mecdestunear - /meccerradura");
	SendClientMessage(playerid, COLOR_WHITE, "_______________________________________________________________________________________");
	return 1;
}
