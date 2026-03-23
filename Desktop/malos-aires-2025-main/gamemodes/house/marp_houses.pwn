#if defined _marp_house_inc
	#endinput
#endif
#define _marp_house_inc

#include "house\marp_house_core.pwn"
#include "house\marp_house_core_coords.pwn"
#include "house\marp_house_admin.pwn"

#include <YSI_Coding\y_hooks>

static playerVisitingHouseId[MAX_PLAYERS];
static playerVisitingTimer[MAX_PLAYERS];

// Venta de casas
new bool:OfferingHouse[MAX_PLAYERS],
	HouseOfferPrice[MAX_PLAYERS],
	HouseOffer[MAX_PLAYERS],
	HouseOfferId[MAX_PLAYERS];

stock GetHouseLockerSpace(houseid)
{
	if(!House_IsValidId(houseid))
		return 0;

	new hprice = House[houseid][HousePrice];

	if(hprice < 100000) return 400;
	if(hprice < 200000) return 500;
	if(hprice < 300000) return 600;
	if(hprice < 400000) return 700;
	if(hprice < 500000) return 800;
	if(hprice < 600000) return 900;
	if(hprice < 700000) return 1000;
	if(hprice < 800000) return 1100;
	if(hprice < 900000) return 1200;
	if(hprice < 1000000) return 1300;
	if(hprice >= 1000000) return 1400;

	return 0;
}

LoadAllHouses()
{
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "House_OnAllDataLoad" @Format: "SELECT * FROM `houses` LIMIT %i;", MAX_HOUSES - 1);
	print("[INFO] Cargando casas...");
	return 1;
}

forward House_OnAllDataLoad();
public House_OnAllDataLoad()
{
	new rows = cache_num_rows();

	for(new row, houseid; row < rows; row++)
	{
		cache_get_value_name_int(row, "Id", houseid);

		cache_get_value_name_int(row, "Owned", House[houseid][Owned]);
		cache_get_value_name_int(row, "OwnerSQLID", House[houseid][OwnerSQLID]);
		cache_get_value_name(row, "OwnerName", House[houseid][OwnerName], MAX_PLAYER_NAME);

		cache_get_value_name_float(row, "OutsideX", House[houseid][OutsideX]);
		cache_get_value_name_float(row, "OutsideY", House[houseid][OutsideY]);
		cache_get_value_name_float(row, "OutsideZ", House[houseid][OutsideZ]);
		cache_get_value_name_float(row, "OutsideAngle", House[houseid][OutsideAngle]);
		cache_get_value_name_int(row, "OutsideInterior", House[houseid][OutsideInterior]);
		cache_get_value_name_int(row, "OutsideWorld", House[houseid][OutsideWorld]);

		cache_get_value_name_float(row, "InsideX", House[houseid][InsideX]);
		cache_get_value_name_float(row, "InsideY", House[houseid][InsideY]);
		cache_get_value_name_float(row, "InsideZ", House[houseid][InsideZ]);
		cache_get_value_name_float(row, "InsideAngle", House[houseid][InsideAngle]);
		cache_get_value_name_int(row, "InsideInterior", House[houseid][InsideInterior]);
		cache_get_value_name_int(row, "InsideWorld", House[houseid][InsideWorld]);

		cache_get_value_name_int(row, "HousePrice", House[houseid][HousePrice]);
		cache_get_value_name_int(row, "Locked", House[houseid][Locked]);

		cache_get_value_name_int(row, "TenantSQLID", House[houseid][TenantSQLID]);
		cache_get_value_name(row, "Tenant", House[houseid][Tenant], MAX_PLAYER_NAME);
		cache_get_value_name_int(row, "IncomeAccept", House[houseid][IncomeAccept]);
		cache_get_value_name_int(row, "Income", House[houseid][Income]);
		cache_get_value_name_int(row, "IncomePrice", House[houseid][IncomePrice]);
		cache_get_value_name_int(row, "IncomePriceAdd", House[houseid][IncomePriceAdd]);

		cache_get_value_name_int(row, "ContainerSQLID", House[houseid][ContainerSQLID]);

		House[houseid][Created] = 1;

		//===========================CARGA DE CONTENEDOR========================

		if(House[houseid][ContainerSQLID] > 0) {
		    House[houseid][ContainerID] = Container_Load(House[houseid][ContainerSQLID]);
		} else {
		    Container_Create(GetHouseLockerSpace(houseid), 1, House[houseid][ContainerID], House[houseid][ContainerSQLID]);
		}

		//======================================================================

		House_ReloadOutDoor(houseid);
		House_ReloadInDoor(houseid);

		CallLocalFunction("House_OnIdDataLoaded", "ii", houseid, row);
	}

	printf("[INFO] Carga de %i casas finalizada.", rows);
	CallLocalFunction("House_OnAllDataLoaded", "");
	return 1;
}

forward House_OnIdDataLoaded(houseid, cacherow);
public House_OnIdDataLoaded(houseid, cacherow) {
	return 1;
}

forward House_OnAllDataLoaded();
public House_OnAllDataLoaded() {
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	playerVisitingHouseId[playerid] = 0;
	if(playerVisitingTimer[playerid])
	{
		KillTimer(playerVisitingTimer[playerid]);
		playerVisitingTimer[playerid] = 0;
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(KEY_PRESSED_SINGLE(KEY_CTRL_BACK))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return 1;

		new houseid = House_GetPlayerLastId(playerid);

		if(!houseid)
			return 1;

		if(House_IsPlayerAtOutDoorId(playerid, houseid))
		{
			if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
			if(House[houseid][Locked] && !AdminDuty[playerid])
				return GameTextForPlayer(playerid, "~r~Cerrado!", 2000, 4);

			House_TpPlayerToInDoorId(playerid, houseid);
			return ~1;
		}
		else if(House_IsPlayerAtInDoorId(playerid, houseid))
		{
			if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
			if(House[houseid][Locked] && !AdminDuty[playerid])
				return GameTextForPlayer(playerid, "~r~Cerrado!", 2000, 4);

			House_TpPlayerToOutDoorId(playerid, houseid);
			return ~1;
		}
	}
	return 1;
}

SaveAllHouses()
{
	for(new id = 1; id < MAX_HOUSES; id++) {
		SaveHouse(id);
	}

    print("[INFO] Casas guardadas.");
	return 1;
}

SaveHouse(id)
{
    if(!House[id][Created])
		return 1;
	
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"UPDATE `houses` SET \
			`Owned`=%i,\
			`OwnerSQLID`=%i,\
			`OwnerName`='%s',\
			`OutsideX`=%f,\
			`OutsideY`=%f,\
			`OutsideZ`=%f,\
			`OutsideAngle`=%f,\
			`OutsideInterior`=%i,\
			`OutsideWorld`=%i,\
			`InsideX`=%f,\
			`InsideY`=%f,\
			`InsideZ`=%f,\
			`InsideAngle`=%f,\
			`InsideInterior`=%i,\
			`InsideWorld`=%i,\
			`HousePrice`=%i,\
			`Locked`=%i,\
			`TenantSQLID`=%i,\
			`Tenant`='%s',\
			`IncomeAccept`=%i,\
			`Income`=%i,\
			`IncomePrice`=%i,\
			`IncomePriceAdd`=%i,\
			`ContainerSQLID`=%i \
		WHERE \
			`Id`=%i;",
	    House[id][Owned],
	    House[id][OwnerSQLID],
	    House[id][OwnerName],
	    House[id][OutsideX],
	    House[id][OutsideY],
	    House[id][OutsideZ],
	    House[id][OutsideAngle],
	    House[id][OutsideInterior],
	    House[id][OutsideWorld],
		House[id][InsideX],
		House[id][InsideY],
		House[id][InsideZ],
		House[id][InsideAngle],
		House[id][InsideInterior],
		House[id][InsideWorld],
		House[id][HousePrice],
		House[id][Locked],
		House[id][TenantSQLID],
		House[id][Tenant],
		House[id][IncomeAccept],
		House[id][Income],
		House[id][IncomePrice],
		House[id][IncomePriceAdd],
		House[id][ContainerSQLID],
		id
	);
	mysql_tquery(MYSQL_HANDLE, query);

	House_ReloadOutDoor(id);
	House_ReloadInDoor(id);
	return 1;
}

CreateHouse(id)
{
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `houses` \
			(`Id`,\
			`OwnerName`,\
			`OutsideX`,\
			`OutsideY`,\
			`OutsideZ`,\
			`OutsideAngle`,\
			`OutsideInterior`,\
			`OutsideWorld`,\
			`InsideX`,\
			`InsideY`,\
			`InsideZ`,\
			`InsideInterior`,\
			`InsideWorld`,\
			`HousePrice`,\
			`Locked`) \
		VALUES \
			(%i,'%s',%f,%f,%f,%f,%i,%i,%f,%f,%f,%i,%i,%i,%i);",
		id,
		House[id][OwnerName],
		House[id][OutsideX],
		House[id][OutsideY],
		House[id][OutsideZ],
		House[id][OutsideAngle],
		House[id][OutsideInterior],
		House[id][OutsideWorld],
		House[id][InsideX],
		House[id][InsideY],
		House[id][InsideZ],
		House[id][InsideInterior],
		House[id][InsideWorld],
		House[id][HousePrice],
		House[id][Locked]
	);
	mysql_tquery(MYSQL_HANDLE, query);

	//=========================CREACION DE CONTENEDOR===========================
	
    Container_Create(GetHouseLockerSpace(id), 1, House[id][ContainerID], House[id][ContainerSQLID]);
    
	//==========================================================================
	
	House_ReloadOutDoor(id);
	House_ReloadInDoor(id);
	return 1;
}

DeleteHouse(id)
{
	Furn_DeleteAllHouse(id);
	Furn_ResetAccessHouse(id);

	House_DestroyOutDoor(id);
	House_DestroyInDoor(id);
	
	//==========================BORRADO DE CONTENEDOR===========================
	
	if(HouseHasContainer(id)) {
	    Container_Fully_Destroy(House[id][ContainerID], House[id][ContainerSQLID]);
	}

	// Remove plantations
	Plantation_OnHouseDeleted(id);

	KeyChain_DeleteAll(KEY_TYPE_HOUSE, id, .allowIfOwnerKey = true);

	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "DELETE FROM `houses` WHERE `Id`=%i;", id);
	House[id] = House[HOUSE_RESET_ID];
	return 1;
}
	
stock ResetHouseOffer(playerid)
{
    OfferingHouse[playerid] = false;
	HouseOfferPrice[playerid] = -1;
	HouseOffer[playerid] = INVALID_PLAYER_ID;
	HouseOfferId[playerid] = 0;
}

House_PrintPlayerAddress(playerid, forplayerid)
{
	if(House_IsValidId(PlayerInfo[playerid][pHouseKey]))
	{
		new address[48];
		House_GetAddress(PlayerInfo[playerid][pHouseKey], address, sizeof(address));
		SendFMessage(forplayerid, COLOR_WHITE, "Domicilio: %s.", address);
	} else {
		SendClientMessage(forplayerid, COLOR_WHITE, "Domicilio: No tiene");
	}
}

House_GetAddress(houseid, string[], size = sizeof(string))
{
	new houseloc[MAX_ZONE_NAME];
	GetCoords2DZone(House[houseid][OutsideX], House[houseid][OutsideY], houseloc, MAX_ZONE_NAME);
	format(string, size, "%s %i", houseloc, houseid);
}

//=============================COMANDOS DE CASA=================================

CMD:ayudacasa(playerid, params[])
{
	SendClientMessage(playerid, COLOR_INFO,"[CASA] "COLOR_EMB_GREY" /casacomprar - /casavender - /casavendera - /casaalquilar - /casadesalquilar - /casaradio - /casallave");
	SendClientMessage(playerid, COLOR_INFO,"[CASA] "COLOR_EMB_GREY" /casaenalquiler - /casasinalquiler - /casacontrato - /puerta - /armario - /casavisitar - /casadomicilio");
	SendClientMessage(playerid, COLOR_INFO,"[INFO] "COLOR_EMB_GREY" Si alguien alquila tu casa y quieres rescindirle el contrato utiliza '/casacontrato'");
	return 1;
}

CMD:casaradio(playerid, params[])
{
	new radio, houseid = House_IsPlayerInAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en una casa.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_HOUSE, houseid) && !AdminDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de esta casa.");

	if(!sscanf(params, "i", radio))
	{
		if(!Radio_IsValidId(radio))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar una radio válida, utiliza '/radios' para ver las radios disponibles.");

		foreach(new i : Player)
		{
			if(House_IsPlayerInId(i, houseid))
			{
				SendFMessage(i, COLOR_ACT1, "%s sintoniza una radio en el equipo de música de la casa.", GetPlayerCleanName(playerid));
				Radio_Set(i, radio, RADIO_TYPE_HOUSE);
			}
		}

		House[houseid][Radio] = radio;
	}
	else
	{
		if(!House[houseid][Radio])
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/casaradio [id]. Para apagarla utiliza nuevamente '/casaradio'.");

		foreach(new i : Player)
		{
			if(House_IsPlayerInId(i, houseid))
			{
				SendFMessage(i, COLOR_ACT1, "%s apaga la radio sintonizada en el equipo de música de la casa.", GetPlayerCleanName(playerid));
				Radio_StopIfOnType(i, RADIO_TYPE_HOUSE);
			}
		}

		House[houseid][Radio] = 0;
	}

	return 1;
}

CMD:casacomprar(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;

	new houseid = House_IsPlayerAtOutDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");
	if(!House_IsForSale(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Esta casa no está a la venta.");
	if(!KeyChain_GetFreeSlots(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes más espacio en tu llavero.");
	if(GetPlayerCash(playerid) < House[houseid][HousePrice])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes el dinero suficiente!");

	House[houseid][Owned] = 1;
	House[houseid][OwnerSQLID] = PlayerInfo[playerid][pID];
	strcopy(House[houseid][OwnerName], PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	SaveHouse(houseid);

	new address[48];
	House_GetAddress(houseid, address, sizeof(address));
	KeyChain_Add(playerid, KEY_TYPE_HOUSE, houseid, .label = address, .owner = true);
	PlayerInfo[playerid][pHouseKey] = houseid; // Setea el domicilio fiscal actual a la nueva casa -> más que nada pq el sistema de escenas está harcodeado a esta variable.

	GivePlayerCash(playerid, -House[houseid][HousePrice]);
	StartPlayerScene(playerid, 2, houseid);
	ServerLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/casacomprar", .playerid=playerid);
	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="/casacomprar", .playerid=playerid, .params=<"$%d", House[houseid][HousePrice]>);
	return 1;
}

CMD:casavender(playerid, params[])
{
	new houseid = House_IsPlayerAtOutDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");
	if(!House_IsPlayerOwner(playerid, houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueño de esta casa.");
	if(House_IsRented(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La casa tiene un inquilino.");

	new sellprice = House[houseid][HousePrice] / 3 * 2; // 66 % del valor original.

	House[houseid][Owned] = 0;
	House[houseid][OwnerSQLID] = 0;
	strcopy(House[houseid][OwnerName], "Ninguno", MAX_PLAYER_NAME);
	House[houseid][Locked] = 1;

	if(House[houseid][IncomePrice] != 0)
	{
		House[houseid][IncomePrice] = 0;
		House[houseid][IncomeAccept] = 0;
		House[houseid][IncomePriceAdd] = 0;
		House[houseid][Income] = 0;
	}

	KeyChain_DeleteAll(KEY_TYPE_HOUSE, houseid, .allowIfOwnerKey = true);
	Furn_ResetAccessHouse(houseid);
	GivePlayerCash(playerid, sellprice); 
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	SendFMessage(playerid, COLOR_WHITE, "¡Has vendido tu casa por $%d!", sellprice);
	PlayerActionMessage(playerid, 15.0 , "toma las llaves de su casa y se las entrega al agente inmobiliario.");
	SaveHouse(houseid);

	ServerLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/casavender", .playerid=playerid);
	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="/casavender", .playerid=playerid, .params=<"$%d", sellprice>);
	return 1;
}

CMD:casavendera(playerid, params[])
{
	new houseid = House_IsPlayerAtOutDoorAny(playerid), targetid, price;

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");
	if(!House_IsPlayerOwner(playerid, houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueño de esta casa.");
	if(House_IsRented(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La casa tiene un inquilino.");
	if(sscanf(params, "ui", targetid, price))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/casavendera [ID/Jugador] [Precio]");
	if(!IsPlayerLogged(targetid) || targetid == playerid || !IsPlayerInRangeOfPlayer(3.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido o el sujeto no está cerca tuyo.");
	if(price < 1 || price > 10000000)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El precio no puede ser menor a $1 ni mayor a $10,000,000.");
	if(OfferingHouse[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya te encuentras vendiendo una casa.");

	OfferingHouse[playerid] = true;
	HouseOfferPrice[targetid] = price;
	HouseOffer[targetid] = playerid;
	HouseOfferId[targetid] = houseid;
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Le ofreces las llaves y la escritura de tu casa a %s por $%d.", GetPlayerCleanName(targetid), price);
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te esta ofreciendo venderte su casa por $%d.", GetPlayerCleanName(playerid), price);
	SendClientMessage(targetid, COLOR_LIGHTBLUE, "Utiliza '/casaaceptar' para aceptar la oferta o '/casacancelar' para cancelar.");
	SetPVarInt(targetid, "CancelHouseTransfer", SetTimerEx("CancelHouseTransfer", 10000, false, "ii", targetid, 1));
	return 1;
}

CMD:casaaceptar(playerid, params[])
{
	new sellerid = HouseOffer[playerid],
	    price = HouseOfferPrice[playerid],
	    houseid = HouseOfferId[playerid];

	if(sellerid == INVALID_PLAYER_ID)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te está vendiendo una casa.");

	if(!IsPlayerLogged(sellerid) || !OfferingHouse[sellerid])
	{
	    KillTimer(GetPVarInt(playerid, "CancelHouseTransfer"));
	    CancelHouseTransfer(playerid, 2);
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error durante la venta, cancelando...");
	}

	if(!IsPlayerInRangeOfPlayer(3.0, playerid, sellerid))
 	   	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto no está cerca tuyo.");

	if(GetPlayerCash(playerid) < price)
	{
	    KillTimer(GetPVarInt(playerid, "CancelHouseTransfer"));
	    CancelHouseTransfer(playerid, 2);
	    SendClientMessage(sellerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene el dinero necesario, cancelando...");
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero suficiente, cancelando...");
	}

	if(!KeyChain_GetFreeSlots(playerid))
	{
	    KillTimer(GetPVarInt(playerid, "CancelHouseTransfer"));
	    CancelHouseTransfer(playerid, 2);
		SendClientMessage(sellerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene más espacio en su llavero, cancelando...");
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes más espacio en tu llavero, cancelando...");
	}

	if(!House_IsPlayerOwner(sellerid, houseid))
	{
	    KillTimer(GetPVarInt(playerid, "CancelHouseTransfer"));
	    CancelHouseTransfer(playerid, 2);
		SendClientMessage(sellerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres dueño de esta casa, cancelando...");
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no es el dueño de la casa, cancelando...");
	}

	House[houseid][Owned] = 1;
	House[houseid][OwnerSQLID] = PlayerInfo[playerid][pID];
	strcopy(House[houseid][OwnerName], PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	House[houseid][Locked] = 1;

	KeyChain_DeleteAll(KEY_TYPE_HOUSE, houseid, .allowIfOwnerKey = true);

	new address[48];
	House_GetAddress(houseid, address, sizeof(address));
	KeyChain_Add(playerid, KEY_TYPE_HOUSE, houseid, .label = address, .owner = true);

	Furn_ResetAccessHouse(houseid);
	SaveHouse(houseid);

	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	PlayerPlaySound(sellerid, 1052, 0.0, 0.0, 0.0);

	GivePlayerCash(playerid, -price);
	GivePlayerCash(sellerid, price);

    PlayerPlayerActionMessage(sellerid, playerid, 15.0 , "toma las llaves y la escritura de su casa y se las entrega a");
  	SendFMessage(playerid, COLOR_LIGHTBLUE, "¡Felicidades, has comprado la casa por $%d! Usa /ayudacasa para ver los comandos disponibles.", price);
  	SendFMessage(sellerid, COLOR_LIGHTBLUE, "¡Felicitaciones, has vendido tu casa por $%d!", price);
  	KillTimer(GetPVarInt(playerid, "CancelHouseTransfer"));
	CancelHouseTransfer(playerid, 2);

	ServerFormattedLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/casavendera", .playerid=sellerid, .targetid=playerid, .params=<"%i %d", playerid, price>);
	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="VENTA CASA", .playerid=sellerid, .targetid=playerid, .params=<"$%d", price>);
	return 1;
}

CMD:casacancelar(playerid, params[])
{
	if(HouseOffer[playerid] == INVALID_PLAYER_ID)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te está vendiendo una casa.");
    	
 	KillTimer(GetPVarInt(playerid, "CancelHouseTransfer"));
	CancelHouseTransfer(playerid, 0);
	return 1;
}

TIMER:CancelHouseTransfer(playerid, reason)
{
	if(reason == 1)
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "La venta ha sido cancelada ya que no has respondido en 10 segundos.");
		SendClientMessage(HouseOffer[playerid], COLOR_LIGHTBLUE, "La venta ha sido cancelada ya que el comprador no ha respondido en 10 segundos.");
	}
	else
		if(reason == 0)
		{
	    	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Has rechazado la oferta.");
			SendFMessage(HouseOffer[playerid], COLOR_LIGHTBLUE, "%s ha rechazado la oferta.", GetPlayerCleanName(playerid));
		}
		
 	ResetHouseOffer(HouseOffer[playerid]);
 	ResetHouseOffer(playerid);
	return 1;
}

CMD:casallave(playerid, params[])
{
	new houseid = House_IsPlayerAtAnyDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de una casa.");
	if(!House_IsPlayerOwner(playerid, houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueño de esta casa.");
	if(House_IsRented(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacer esto mientras la casa está alquilada.");

	new address[48];
	House_GetAddress(houseid, address, sizeof(address));

	if(KeyChain_Add(playerid, KEY_TYPE_HOUSE, houseid, .label = address, .owner = true)) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se ha añadido una llave de esta casa a tu llavero.");
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes más espacio en tu llavero o ya tienes una copia de la llave de esta casa.");
	}
	return 1;
}

CMD:puerta(playerid, params[])
{
	new houseid = House_IsPlayerAtAnyDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de una casa.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_HOUSE, houseid) && !AdminDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de esta casa.");

	House[houseid][Locked] = !House[houseid][Locked];
	new string[128];
	format(string, sizeof(string), "toma unas llaves y %s la puerta de la casa.", (House[houseid][Locked] ? ("cierra") : ("abre")));
	PlayerActionMessage(playerid, 15.0, string);
	return 1;
}

CMD:casadomicilio(playerid, params[])
{
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/casadomicilio [ID casa]");
	if(!House_IsValidId(houseid) || (!House_IsPlayerOwner(playerid, houseid) && !House_IsPlayerTenant(playerid, houseid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa inválida.");

	PlayerInfo[playerid][pHouseKey] = houseid;
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has configurado la propiedad ID %i como tu domicilio permanente.", houseid);
	return 1;
}

//========================COMANDOS DE ALQUILER DE CASAS=========================

CMD:casaalquilar(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;

	new houseid = House_IsPlayerAtOutDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");
	if(!House_IsForRent(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Esta casa no está en alquiler.");
	if(House_IsPlayerOwner(playerid, houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes alquilar tu propia casa!");
	if(!KeyChain_GetFreeSlots(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes más espacio en tu llavero.");
	if(GetPlayerCash(playerid) < House[houseid][IncomePrice])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes el dinero suficiente!");

	GivePlayerCash(playerid, -House[houseid][IncomePrice]);
	House_TpPlayerToInDoorId(playerid, houseid);

	KeyChain_DeleteAll(KEY_TYPE_HOUSE, houseid, .allowIfOwnerKey = true);

	new address[48];
	House_GetAddress(houseid, address, sizeof(address));
	KeyChain_Add(playerid, KEY_TYPE_HOUSE, houseid, .label = address, .owner = true);

	House[houseid][Income] = 1;
	House[houseid][TenantSQLID] = PlayerInfo[playerid][pID];
	strcopy(House[houseid][Tenant], PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	SaveHouse(houseid);

	SendClientMessage(playerid, COLOR_WHITE, "¡Felicidades, has alquilado esta propiedad! Para ver los comandos disponibles utiliza /ayudacasa.");
	PlayerActionMessage(playerid, 15.0, "le da monto de dinero al agente inmobiliario a cambio de un par de llaves.");
	return 1;
}

CMD:casadesalquilar(playerid, params[])
{
	new houseid = House_IsPlayerAtOutDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");
	if(!House_IsPlayerTenant(playerid, houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres un inquilino de esta casa.");

    if(!House_IsOwned(houseid)) {
	    House[houseid][IncomePrice] = House[houseid][HousePrice] / 100;
    }

	House[houseid][Locked] = 1;
	House[houseid][Income] = 0;
	House[houseid][TenantSQLID] = 0;
	strcopy(House[houseid][Tenant], "Ninguno", MAX_PLAYER_NAME);

	KeyChain_DeleteAll(KEY_TYPE_HOUSE, houseid, .allowIfOwnerKey = true);

	SaveHouse(houseid);

	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	SendClientMessage(playerid, COLOR_WHITE, "¡Has dejado de alquilar la casa!");
	PlayerActionMessage(playerid, 15.0 , "toma las llaves de su casa y se las entrega al agente inmobiliario.");
	return 1;
}

CMD:casaenalquiler(playerid, params[])
{
	new houseid = House_IsPlayerAtOutDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");
	if(!House_IsPlayerOwner(playerid, houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueño de esta casa.");
	if(House_IsRented(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La casa tiene un inquilino.");

	new price;

	if(sscanf(params, "i", price))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/casaenalquiler [Precio]");

	if(price < 1 || price > (House[houseid][HousePrice] / 100))
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El precio de alquiler debe estar en el rango [$1 - $%i].", House[houseid][HousePrice] / 100);
		return 1;
	}
	    
	House[houseid][IncomePrice] = price;
	House[houseid][IncomeAccept] = 1;
	House[houseid][TenantSQLID] = 0;
	strcopy(House[houseid][Tenant], "Ninguno", MAX_PLAYER_NAME);
	SaveHouse(houseid);

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Colocaste tu casa en alquiler por $%i. Si es alquilada perderás tu llave y armario hasta que termine el contrato.", price);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El pago del alquiler se realiza por cada payday del inquilino y lo recibirás al cobrar tu payday.");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Si por cierta razón en algún momento te quedas con la vivienda vacía y sin una llave, usa '/casallave' en la puerta.");
	return 1;
}

CMD:casasinalquiler(playerid, params[])
{
	new houseid = House_IsPlayerAtOutDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");
	if(!House_IsPlayerOwner(playerid, houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueño de esta casa.");
	if(House_IsRented(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La casa tiene un inquilino.");
		
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has sacado tu casa de alquiler, ya no se encuentra disponible para ser alquilada.");
	House[houseid][IncomePrice] = 0;
	House[houseid][IncomeAccept] = 0;
	House[houseid][TenantSQLID] = 0;
	strcopy(House[houseid][Tenant], "Ninguno", MAX_PLAYER_NAME);
	SaveHouse(houseid);
	return 1;
}

CMD:casacontrato(playerid, params[])
{
	new houseid = House_IsPlayerAtOutDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");
	if(!House_IsPlayerOwner(playerid, houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueño de esta casa.");
	if(!House_IsRented(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La casa no tiene un inquilino.");

	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El inquilino será informado de que has rescindido el contrato de alquiler y dentro de 5 paydays será desalojado.");
	House[houseid][Income] = 5;
	SaveHouse(houseid);
	return 1;
}

CMD:timbre(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;

	new houseid = House_IsPlayerAtOutDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");

	PlayerActionMessage(playerid, 15.0, "toca el timbre de la casa.");
	PlayerPlaySound(playerid, 6401, 0.0, 0.0, 0.0);

	foreach(new i : Player)
	{
		if(House_IsPlayerInId(i, houseid))
		{
			SendClientMessage(i, COLOR_DO1, "Suena el timbre de la casa, ¡alguien está en la puerta!");
			PlayerPlaySound(i, 6401, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

CMD:casavisitar(playerid, params[])
{
	if(!strcmp(params, "salir", true))
	{
		if(!playerVisitingHouseId[playerid])
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No estas visitando ninguna casa!");

		House_FinishVisit(playerid, true);
		return 1;
	}

	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;
	if(playerVisitingHouseId[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya estas visitando una casa!");

	new houseid = House_IsPlayerAtOutDoorAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de una casa.");
	if(!House_IsForSale(houseid) && !House_IsForRent(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Esta casa no está disponible para visitar!");

	new string[128];
	format(string, sizeof(string), "Un agente inmobiliario ingresa junto a %s en la casa ID %i y le da un tour guiado.", GetPlayerCleanName(playerid), houseid);
	PlayerDoMessage(playerid, 25.0, string);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tienes 60 segundos para visitar la propiedad. Puedes salir cuando quieras utilizando '/casavisitar salir'.");

	PlayerInfo[playerid][pDisabled] = DISABLE_VISITING;
	playerVisitingHouseId[playerid] = houseid;
	TeleportPlayerTo(playerid, House[houseid][InsideX], House[houseid][InsideY], House[houseid][InsideZ], House[houseid][InsideAngle], House[houseid][InsideInterior], House[houseid][InsideWorld], .syncPlayerOldPosData = true, .disableSyncOnExitSeconds = 75);
	playerVisitingTimer[playerid] = SetTimerEx("House_FinishVisit", 60000, false, "ib", playerid, false);
	return 1;
}

CALLBACK:House_FinishVisit(playerid, bool:forced)
{
	new houseid = playerVisitingHouseId[playerid];
	TeleportPlayerTo(playerid, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ], House[houseid][OutsideAngle], House[houseid][OutsideInterior], House[houseid][OutsideWorld], .syncPlayerNewPosData = true, .disableSyncOnExitSeconds = 0);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has salido de la casa que estabas visitando.");

	if(forced) {
		KillTimer(playerVisitingTimer[playerid]);
	}

	playerVisitingTimer[playerid] = 0;
	playerVisitingHouseId[playerid] = 0;
	PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
	return 1;
}
