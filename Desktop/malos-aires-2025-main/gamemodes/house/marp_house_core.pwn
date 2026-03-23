#if defined _marp_house_core_inc
	#endinput
#endif
#define _marp_house_core_inc

#define MAX_HOUSES 400
#define HOUSE_VW_OFFSET 15000

const HOUSE_RESET_ID = MAX_HOUSES;

enum e_HOUSE_DATA
{
	Created,
	Owned,
	OwnerSQLID,
	OwnerName[MAX_PLAYER_NAME],
	HousePrice,
	Locked,
	Radio,

	Float:OutsideX,
	Float:OutsideY,
	Float:OutsideZ,
	Float:OutsideAngle,
	OutsideInterior,
	OutsideWorld,
	STREAMER_TAG_3D_TEXT_LABEL:hOutsideLabel,
	STREAMER_TAG_PICKUP:hOutsidePickup,

	Float:InsideX,
	Float:InsideY,
	Float:InsideZ,
	Float:InsideAngle,
	InsideInterior,
	InsideWorld,
	STREAMER_TAG_3D_TEXT_LABEL:hInsideLabel,
	STREAMER_TAG_PICKUP:hInsidePickup,

	TenantSQLID,
	Tenant[MAX_PLAYER_NAME],
	IncomeAccept,
	Income,
	IncomePrice,
	IncomePriceAdd,

	ContainerSQLID,
	ContainerID
};

new House[MAX_HOUSES + 1][e_HOUSE_DATA] =
{
	{
		/*Created*/ 0,
		/*Owned*/ 0,
		/*OwnerSQLID*/ 0,
		/*OwnerName[MAX_PLAYER_NAME]*/ "Ninguno",
		/*HousePrice*/ 0,
		/*Locked*/ 0,
		/*Radio*/ 0,

		/*Float:OutsideX*/ 0.0,
		/*Float:OutsideY*/ 0.0,
		/*Float:OutsideZ*/ 0.0,
		/*Float:OutsideAngle*/ 0.0,
		/*OutsideInterior*/ 0,
		/*OutsideWorld*/ 0,
		/*STREAMER_TAG_3D_TEXT_LABEL:hOutsideLabel*/ STREAMER_TAG_3D_TEXT_LABEL:0,
		/*STREAMER_TAG_PICKUP:hOutsidePickup*/ STREAMER_TAG_PICKUP:0,

		/*Float:InsideX*/ 0.0,
		/*Float:InsideY*/ 0.0,
		/*Float:InsideZ*/ 0.0,
		/*Float:InsideAngle*/ 0.0,
		/*InsideInterior*/ 0,
		/*InsideWorld*/ 0,
		/*STREAMER_TAG_3D_TEXT_LABEL:hInsideLabel*/ STREAMER_TAG_3D_TEXT_LABEL:0,
		/*STREAMER_TAG_PICKUP:hInsidePickup*/ STREAMER_TAG_PICKUP:0,

		/*TenantSQLID*/ 0,
		/*Tenant[MAX_PLAYER_NAME]*/ "Ninguno",
		/*IncomeAccept*/ 0,
		/*Income*/ 0,
		/*IncomePrice*/ 0,
		/*IncomePriceAdd*/ 0,

		/*ContainerSQLID*/ 0,
		/*ContainerID*/ 0
	}, ...
};

House_IsValidId(houseid) {
	return (0 < houseid < MAX_HOUSES && House[houseid][Created]);
}

House_IsPlayerOwner(playerid, houseid)
{
	if(!House_IsValidId(houseid))
		return 0;

	return (House[houseid][OwnerSQLID] == PlayerInfo[playerid][pID]);
}

House_IsPlayerTenant(playerid, houseid)
{
	if(!House_IsValidId(houseid))
		return 0;

	return (House[houseid][TenantSQLID] == PlayerInfo[playerid][pID]);
}

House_GetPrice(houseid) {
	return House[houseid][HousePrice];
}

House_OnPlayerCharacterKill(houseid, playerid, notifyid)
{
	if(House_IsPlayerOwner(playerid, houseid))
	{
		SendFMessage(notifyid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" Vendida la casa ID %i.", houseid);
		GivePlayerCash(playerid, House[houseid][HousePrice] / 3 * 2); // 66 % del valor original.

		KeyChain_DeleteAll(KEY_TYPE_HOUSE, houseid, .allowIfOwnerKey = true);

		House[houseid][Owned] = 0;
		House[houseid][OwnerSQLID] = 0;
		strcopy(House[houseid][OwnerName], "Ninguno", MAX_PLAYER_NAME);
		House[houseid][Locked] = 1;
		House[houseid][Radio] = 0;
		House[houseid][IncomePrice] = 0;
		House[houseid][IncomePriceAdd] = 0;
		House[houseid][IncomeAccept] = 0;
		House[houseid][Income] = 0;
		House[houseid][TenantSQLID] = 0;
		strcopy(House[houseid][Tenant], "Ninguno", MAX_PLAYER_NAME);

		if(HouseHasContainer(houseid)) {
			Container_Empty(House[houseid][ContainerID]);
		}

		SaveHouse(houseid);
		ServerLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="Vendido por CK", .playerid=playerid);\
	}
	else if(House_IsPlayerTenant(playerid, houseid))
	{
		KeyChain_DeleteAll(KEY_TYPE_HOUSE, houseid, .allowIfOwnerKey = true);

		if(!House[houseid][Owned]) {
			House[houseid][IncomePrice] = House[houseid][HousePrice] / 100;
		}
		House[houseid][Locked] = 1;
		House[houseid][Income] = 0;
		House[houseid][TenantSQLID] = 0;
		strcopy(House[houseid][Tenant], "Ninguno", MAX_PLAYER_NAME);
		SaveHouse(houseid);
		SendFMessage(notifyid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" Desalquilada la casa ID %i.", houseid);
	}
	return 1;
}

hook KeyChain_OnInit()
{
	KeyChain_SetKeyTypeData(
		.type = KEY_TYPE_HOUSE,
		.typeName = "Casa",
		.logType = LOG_TYPE_ID_HOUSES,
		.onPaydayAddr = GetPublicAddressFromName("House_OnPlayerPayday"),
		.onNameChangeAddr = GetPublicAddressFromName("House_OnPlayerNameChange"),
		.onCopyCheckAddr = 0
	);
	return 1;
}

forward House_OnPlayerNameChange(houseid, playerid, const name[]);
public House_OnPlayerNameChange(houseid, playerid, const name[])
{
	if(House_IsPlayerOwner(playerid, houseid)) {
		House_SetOwnerName(houseid, name);
	} else if(House_IsPlayerTenant(playerid, houseid)) {
		House_SetTenantName(houseid, name);
	}
	return 1;
}

forward House_OnPlayerPayday(houseid, playerid, &income, &tax);
public House_OnPlayerPayday(houseid, playerid, &income, &tax)
{
	if(House_IsPlayerOwner(playerid, houseid))
	{
		if(House[houseid][IncomePriceAdd] > 0)
		{
			income += House[houseid][IncomePriceAdd];
			House[houseid][IncomePriceAdd] = 0;
			SaveHouse(houseid);
		}

		tax += floatround(House_GetPrice(houseid) * 0.0018, floatround_ceil);
	}
	else if(House_IsPlayerTenant(playerid, houseid))
	{
		income -= House[houseid][IncomePrice];

		if(House[houseid][Owned]) {
			House[houseid][IncomePriceAdd] += House[houseid][IncomePrice];
		}

		tax += floatround(House_GetPrice(houseid) * 0.0018, floatround_ceil);

		House_RentalExpiration(houseid, playerid);
	}
}

House_RentalExpiration(houseid, playerid)
{
	if(House[houseid][Income] >= 2)
	{
		if(House[houseid][Income] == 2)
		{
			SendClientMessage(playerid, COLOR_WHITE, "Te han desalojado de tu vivienda como se te informo que pasaría, todo lo que hayas dejado dentro dalo por perdido.");
			House[houseid][Locked] = 1;
			House[houseid][Income] = 0;
			House[houseid][IncomeAccept] = 0;
			House[houseid][TenantSQLID] = 0;
			strcopy(House[houseid][Tenant], "Ninguno", MAX_PLAYER_NAME);
			SaveHouse(houseid);
			KeyChain_DeleteAll(KEY_TYPE_HOUSE, houseid, .allowIfOwnerKey = true);
		}
		else if(House[houseid][Income] == 3)
		{
			SendClientMessage(playerid, COLOR_WHITE, "En el Próximo payday rescinde el contrato de la vivienda en la cual vives, retira tus cosas antes o te desalojarán y las perderás.");
			House[houseid][Income] = 2;
			SaveHouse(houseid);
		}
		else if(House[houseid][Income] == 4)
		{
			SendClientMessage(playerid, COLOR_WHITE, "Te quedan 2 paydays antes de que rescinda el contrato de la vivienda en la cual vives, retira tus cosas antes o te desalojarán y las perderás.");
			House[houseid][Income] = 3;
			SaveHouse(houseid);
		}
		else if(House[houseid][Income] == 5)
		{
			SendClientMessage(playerid,COLOR_LIGHTGREEN,"SMS de Inmobiliaria: Señor, le queremos informar que el dueño de la vivienda la cual usted alquila ha decidido...");
			SendClientMessage(playerid,COLOR_LIGHTGREEN,"SMS de Inmobiliaria: ...rescindirle el contrato, tiene 3 dias (paydays) para retirar sus pertenencias.");
			House[houseid][Income] = 4;
			SaveHouse(houseid);
		}
	}
}

House_SetOwnerName(houseid, const name[])
{
	if(!House_IsValidId(houseid))
		return 0;

	strcopy(House[houseid][OwnerName], name, MAX_PLAYER_NAME);
	SaveHouse(houseid);
	return 1;
}

House_SetTenantName(houseid, const name[])
{
	if(!House_IsValidId(houseid))
		return 0;

	strcopy(House[houseid][Tenant], name, MAX_PLAYER_NAME);
	SaveHouse(houseid);
	return 1;
}

HouseHasContainer(houseid) {
	return (House[houseid][ContainerSQLID] > 0 && House[houseid][ContainerID] > 0);
}

House_IsLocked(houseid) {
	return House[houseid][Locked];
}
House_IsOwned(houseid) {
	return (House[houseid][Owned] && House[houseid][OwnerSQLID]);
}

House_IsRented(houseid) {
	return (House[houseid][Income] && House[houseid][TenantSQLID]);
}

House_IsForSale(houseid) {
	return (!House[houseid][Owned] && !House[houseid][OwnerSQLID] && House[houseid][HousePrice] > 0 && !House[houseid][IncomeAccept] && !House[houseid][IncomePrice] && !House_IsRented(houseid));
}

House_IsForRent(houseid) {
	return (House[houseid][IncomeAccept] && House[houseid][IncomePrice] > 0 && !House_IsRented(houseid));
}