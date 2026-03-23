#if defined _marp_marp_plantation_included
	#endinput
#endif
#define _marp_marp_plantation_included

#include <YSI_Coding\y_hooks>

#define MAX_HOUSE_PLANTS						(3)

#define PLANTATION_UPDATE_TIME					(10) // Minutos lapsos de 10 minutos para que la gente plante.

#define PLANTATION_PRODUCT_BASE_AMOUNT			(25) // La media estándar a obtener, teniendo una cantidad menor o igual a PLANTATION_BASE_PLANT_AMOUNT de plantas distribuidas.
#define PLANTATION_PRODUCT_MIN_MAX_RANGE		(5) // El rango aleatorio +- sobre PLANTATION_PRODUCT_BASE_AMOUNT que podrá otorgar la planta.
#define PLANTATION_PRODUCT_MIN_AMOUNT			(7) // Lo mínimo que va a dar la planta, aunque tenga 100 plantas distribuidas.
#define PLANTATION_BASE_PLANT_AMOUNT			(4) // Cantidad de plantas distribuidas totales a partir de la cual el rendimiento empieza a caer rápidamente como una gaussiana de varianza PLANTATION_BASE_PLANT_VARIANCE.
#define PLANTATION_BASE_PLANT_VARIANCE			(10)

#define PLANTATION_POT_MODEL					(742)
#define PLANTATION_PLANT_MODEL					(19473)

#define PLANTATION_SOWED_DURATION				(90)
#define PLANTATION_GROWTH_DURATION				(540)
#define PLANTATION_HARVABLE_DURATION			(690)
#define PLANTATION_DYING_DURATION				(780)

#define PLANTATION_TIME_TO_FERTILIZE			(60)

#define PLANTATION_CREATE						1
#define PLANTATION_UPDATE						2
#define PLANTATION_REMOVE						3

static enum e_PLANTATION_DATA {
	plantationActive,
	STREAMER_TAG_OBJECT:plantationPotObjectID,
	STREAMER_TAG_OBJECT:plantationWeedObjectID,
	Float:plantationXpos,
	Float:plantationYpos,
	Float:plantationZpos,
	plantationStage,
	plantationTime,
	plantationFertTime,
	plantationAllowRemove,
	plantationPlayerID
};

static enum {
	PLANTATION_STAGE_NULL,
	PLANTATION_STAGE_SOWED,
	PLANTATION_STAGE_GROWTH,
	PLANTATION_STAGE_HARVABLE,
	PLANTATION_STAGE_DYING,
	PLANTATION_STAGE_AMOUNT
};

static const PlantStageDescription[PLANTATION_STAGE_AMOUNT][32] = {
	{"No hay ninguna planta."},
	{"{66C974}Planta sembrada."},
	{"{3FB350}Planta creciendo."},
	{"{287233}Planta florecida."},
	{"{FFDA7B}Planta secandose."}
};

static Plantation_Info[MAX_HOUSES][MAX_HOUSE_PLANTS][e_PLANTATION_DATA];
static Plantation_TimerID;
static Plantation_SaveTimerID;

static const Plantation_InfoReset[e_PLANTATION_DATA] = {
	/*plantationActive*/ 0,
	/*STREAMER_TAG_OBJECT:plantationPotObjectID*/ STREAMER_TAG_OBJECT:0,
	/*STREAMER_TAG_OBJECT:plantationWeedObjectID*/ STREAMER_TAG_OBJECT:0,
	/*Float:plantationXpos*/ 0.0,
	/*Float:plantationYpos*/ 0.0,
	/*Float:plantationZpos*/ 0.0,
	/*plantationStage*/ PLANTATION_STAGE_NULL,
	/*plantationTime*/ 0,
	/*plantationFertTime*/ 0,
	/*plantationAllowRemove*/ 1,
	/*plantationPlayerID*/ 0
};

hook OnGameModeInitEnded()
{
	for(new houseid = 1; houseid < MAX_HOUSES; houseid++) {
		for(new plantid = 0; plantid < MAX_HOUSE_PLANTS; plantid++) {
			Plantation_Info[houseid][plantid] = Plantation_InfoReset;
		}
	}

	Plantation_LoadAll();

	Plantation_TimerID = SetTimer("Plantation_UpdateAllTimer", PLANTATION_UPDATE_TIME * 60 * 1000, true);
	Plantation_SaveTimerID = SetTimer("Plantation_UpdateSQLTimer", 20 * PLANTATION_UPDATE_TIME * 60 * 1000, true);
	return 1;
}

hook OnGameModeExit()
{
	KillTimer(Plantation_TimerID);
	KillTimer(Plantation_SaveTimerID);
	Plantation_SaveAll();
	return 1;
}

Plantation_LoadAll() // Corregir a un esquema de una sola query
{
	for(new houseid = 1; houseid < MAX_HOUSES; houseid++) {
		mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "Plantation_Load", "i", houseid @Format: "SELECT * FROM `plantation_info` WHERE `houseid`=%i;", houseid);
	}

	print("[INFO] PLANTACIONES CARGADAS.");
	return 1;
}

Plantation_SaveAll()
{
	for(new id = 1; id < MAX_HOUSES; id++) {
		for(new plantid = 0; plantid < MAX_HOUSE_PLANTS; plantid++) {
			Plantation_DataUpdate(id, plantid, PLANTATION_UPDATE);
		}
	}

	print("[INFO] PLANTACIONES GUARDADAS.");
	return 1;
}

Plantation_DataUpdate(houseid, plantationid, option)
{
	if(plantationid > MAX_HOUSE_PLANTS)
		return 0;

	new query[300];

	if(option == PLANTATION_CREATE)
	{
		mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO plantation_info (houseid, plantationid, plantationXpos, plantationYpos, plantationZpos, plantationStage, plantationTime, plantationPlayerID) VALUES (%i, %i, %f, %f, %f, %i, %i, %i);",
			houseid,
			plantationid,
			Plantation_Info[houseid][plantationid][plantationXpos],
			Plantation_Info[houseid][plantationid][plantationYpos],
			Plantation_Info[houseid][plantationid][plantationZpos],
			Plantation_Info[houseid][plantationid][plantationStage],
			Plantation_Info[houseid][plantationid][plantationTime],
			Plantation_Info[houseid][plantationid][plantationPlayerID]
		);

	}
	else if(option == PLANTATION_UPDATE)
	{
		mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE plantation_info SET plantationStage=%i, plantationTime=%i, plantationPlayerID=%i WHERE houseid=%i AND plantationid=%i;",
			Plantation_Info[houseid][plantationid][plantationStage],
			Plantation_Info[houseid][plantationid][plantationTime],
			Plantation_Info[houseid][plantationid][plantationPlayerID],
			houseid,
			plantationid
		);
	}
	else if(option == PLANTATION_REMOVE)
	{
		mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `plantation_info` WHERE `houseid`=%i AND `plantationid`=%i", 
			houseid,
			plantationid
		);
	}
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

forward Plantation_Load(houseid);
public Plantation_Load(houseid)
{
	new rows = cache_num_rows();

	if(!rows)
		return 0;

	for(new i = 0, plantationid; i < rows; i++)
	{
		cache_get_value_name_int(i, "plantationid", plantationid);

		cache_get_value_name_float(i, "plantationXpos", Plantation_Info[houseid][plantationid][plantationXpos]);
		cache_get_value_name_float(i, "plantationYpos", Plantation_Info[houseid][plantationid][plantationYpos]);
		cache_get_value_name_float(i, "plantationZpos", Plantation_Info[houseid][plantationid][plantationZpos]);
		cache_get_value_name_int(i, "plantationStage", Plantation_Info[houseid][plantationid][plantationStage]);
		cache_get_value_name_int(i, "plantationTime", Plantation_Info[houseid][plantationid][plantationTime]);
		cache_get_value_name_int(i, "plantationPlayerID", Plantation_Info[houseid][plantationid][plantationPlayerID]);

		Plantation_Info[houseid][plantationid][plantationPotObjectID] = CreateDynamicObject(PLANTATION_POT_MODEL, 
																	Plantation_Info[houseid][plantationid][plantationXpos], 
																	Plantation_Info[houseid][plantationid][plantationYpos], 
																	Plantation_Info[houseid][plantationid][plantationZpos] - 1.4, 0.0, 0.0, 0.0, 
																	House_GetInDoorWorld(houseid)
																);

					
		Plantation_Info[houseid][plantationid][plantationActive] = 1;
		if(Plantation_Info[houseid][plantationid][plantationStage] > PLANTATION_STAGE_SOWED) { // Comprobamos si tenemos que crear el objeto de la planta.
			Plantation_Info[houseid][plantationid][plantationWeedObjectID] = CreateDynamicObject(PLANTATION_PLANT_MODEL, 
																				Plantation_Info[houseid][plantationid][plantationXpos], 
																				Plantation_Info[houseid][plantationid][plantationYpos], 
																				Plantation_Info[houseid][plantationid][plantationZpos] - 0.4 + 0.4*Plantation_Info[houseid][plantationid][plantationStage],
																				0.0, 180.0, 0.0, 
																				House_GetInDoorWorld(houseid)
																			);
			Plantation_Info[houseid][plantationid][plantationTime] -= 10;
			Plantation_UpdatePlant(houseid, plantationid);
		}
	}
	return 1;
}

Plantation_OnHouseDeleted(houseid)
{
	new query[64];

	format(query, sizeof(query), "DELETE FROM `plantation_info` WHERE `houseid` = %d", houseid);
	mysql_tquery(MYSQL_HANDLE, query);

	for (new id = 0; id < MAX_HOUSE_PLANTS; id++) {
		Plantation_Reset(houseid, id);
	}

	return 1;
}

Plantation_GetClosest(playerid, houseid)
{
	for(new plantid = 0; plantid < MAX_HOUSE_PLANTS; plantid++) {
		if(IsPlayerInRangeOfPoint(playerid, 1.4, Plantation_Info[houseid][plantid][plantationXpos], Plantation_Info[houseid][plantid][plantationYpos], Plantation_Info[houseid][plantid][plantationZpos])) {
			return plantid;
		}
	}
	return -1;
}

Plantation_AddPot(playerid, houseid)
{
	new plantid = MAX_HOUSE_PLANTS;
	for(new i = 0; i < MAX_HOUSE_PLANTS; i++) {
		if(!Plantation_Info[houseid][i][plantationActive]) {
			plantid = i;
			break;
		}
	}

	if(plantid == MAX_HOUSE_PLANTS)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes poner mas plantas en esta casa!");
	
	new pot_hand = SearchHandsForItem(playerid, ITEM_ID_POT);

	if(pot_hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener una maceta en alguna de tus manos.");

	new Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);

	if(GetHandParam(playerid, pot_hand) - 1 > 0) {
		SetHandItemAndParam(playerid, pot_hand, ITEM_ID_POT, GetHandParam(playerid, pot_hand) - 1);
	} else {
		SetHandItemAndParam(playerid, pot_hand, 0, 0); // Borrado lógico y grafico
	}

	PlayerCmeMessage(playerid, 15.0, 4000, "Coloca una maceta en el suelo.");
	Plantation_Info[houseid][plantid][plantationXpos] = x; 
	Plantation_Info[houseid][plantid][plantationYpos] = y;
	Plantation_Info[houseid][plantid][plantationZpos] = z;
	Plantation_Info[houseid][plantid][plantationActive] = 1;
	Plantation_Info[houseid][plantid][plantationPotObjectID] = CreateDynamicObject(PLANTATION_POT_MODEL, x, y, z - 1.4, 0.0, 0.0, 0.0, House_GetInDoorWorld(houseid));
	Plantation_Info[houseid][plantid][plantationPlayerID] = PlayerInfo[playerid][pID];
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	Plantation_DataUpdate(houseid, plantid, PLANTATION_CREATE);
	return 1;
}

Plantation_RemovePot(playerid, houseid)
{
	new plantationid = Plantation_GetClosest(playerid, houseid);
	if(plantationid == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar cerca de una maceta!");
	if(Plantation_Info[houseid][plantationid][plantationWeedObjectID])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No podes sacar esta maceta mientras tenga una planta!");
	if(!Plantation_Info[houseid][plantationid][plantationAllowRemove])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya estan interactuando con esta planta o maceta.");
	
	new hand = SearchFreeHand(playerid);

	if(hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes tener al menos una mano vacia!");

	PlayerCmeMessage(playerid, 15.0, 4000, "Quita una maceta del suelo.");
	SetHandItemAndParam(playerid, hand, ITEM_ID_POT, 1);
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	Plantation_Reset(houseid, plantationid);
	Plantation_DataUpdate(houseid, plantationid, PLANTATION_REMOVE);
	return 1;
}

Plantation_Plant(playerid, houseid)
{
	new plantationid = Plantation_GetClosest(playerid, houseid);
	if(plantationid == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar cerca de una maceta!");
	if(Plantation_Info[houseid][plantationid][plantationStage] != PLANTATION_STAGE_NULL)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya hay una planta en esta maceta!"); 
	if(!Plantation_Info[houseid][plantationid][plantationAllowRemove])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya estan interactuando con esta planta o maceta.");

	new seed_hand = SearchHandsForItem(playerid, ITEM_ID_WEED_SEEDS);

	if(seed_hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un paquete de semillas en una de tus manos.");
	if(GetHandParam(playerid, seed_hand) < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes semillas suficientes.");

	if(GetHandParam(playerid, seed_hand) - 2 > 0) {
		SetHandItemAndParam(playerid, seed_hand, ITEM_ID_WEED_SEEDS, GetHandParam(playerid, seed_hand) - 2);
	} else {
		SetHandItemAndParam(playerid, seed_hand, 0, 0); // Borrado lógico y grafico
	}

	PlayerCmeMessage(playerid, 15.0, 5000, "Pone unas semillas en la maceta y las tapa con tierra.");
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	Plantation_Info[houseid][plantationid][plantationStage] = PLANTATION_STAGE_SOWED;
	Plantation_Info[houseid][plantationid][plantationTime] = 0;
	Plantation_Info[houseid][plantationid][plantationPlayerID] = PlayerInfo[playerid][pID];
	Plantation_DataUpdate(houseid, plantationid, PLANTATION_UPDATE);
	return 1;
}

Plantation_RemovePlant(playerid, houseid, bool:hervast)
{
	new plantationid = Plantation_GetClosest(playerid, houseid);
	if(plantationid == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar cerca de una maceta!");
	if(Plantation_Info[houseid][plantationid][plantationStage] == PLANTATION_STAGE_NULL)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No hay una planta en esta maceta!");
	if(hervast && Plantation_Info[houseid][plantationid][plantationStage] != PLANTATION_STAGE_HARVABLE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes cosechar la planta ahora.");
	if(!Plantation_Info[houseid][plantationid][plantationAllowRemove])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya estan interactuando con esta planta o maceta.");
	if(SearchFreeHand(playerid) == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes tener al menos una mano vacia!");

	TogglePlayerControllable(playerid, false);
	ApplyAnimationEx(playerid, "COP_AMBIENT", "Copbrowse_nod", 4.1, 1, 0, 0, 0, 0, 1, .autofinish = false, .finishAnimId = 2);
	Plantation_Info[houseid][plantationid][plantationAllowRemove] = 0;

	new query[150];
	format(query, sizeof(query), "SELECT COUNT(*) FROM `plantation_info` WHERE `plantationPlayerID`=%i OR `plantationPlayerID`=%i;", PlayerInfo[playerid][pID], Plantation_Info[houseid][plantationid][plantationPlayerID]);
	mysql_tquery(MYSQL_HANDLE, query, "Plantation_OnPlayerCountEnded", "iiiii", playerid, PlayerInfo[playerid][pID], houseid, plantationid, _:hervast);
	return 1;
}

forward Plantation_OnPlayerCountEnded(playerid, playersqlid, houseid, plantationid, hervast);
public Plantation_OnPlayerCountEnded(playerid, playersqlid, houseid, plantationid, hervast)
{
	SetTimerEx("Plantation_RemovePlantEnd", 15 * 1000, false, "iiiibi", playerid, playersqlid, houseid, plantationid, bool:hervast, (cache_num_rows()) ? (cache_index_int(0, 0)) : (0));
	return 1;
}

forward Plantation_RemovePlantEnd(playerid, playersqlid, houseid, plantationid, bool:hervast, playerPlantCount);
public Plantation_RemovePlantEnd(playerid, playersqlid, houseid, plantationid, bool:hervast, playerPlantCount)
{
	Plantation_Info[houseid][plantationid][plantationAllowRemove] = 1;

	if(!IsPlayerLogged(playerid) || PlayerInfo[playerid][pID] != playersqlid)
		return 0;

	TogglePlayerControllable(playerid, true);
	EndAnim(playerid);
	new freehand = SearchFreeHand(playerid);

	if(freehand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes tener al menos una mano vacia!");

	if(Plantation_Info[houseid][plantationid][plantationWeedObjectID])
	{
		DestroyDynamicObject(Plantation_Info[houseid][plantationid][plantationWeedObjectID]);
		Plantation_Info[houseid][plantationid][plantationWeedObjectID] = STREAMER_TAG_OBJECT:0;
	}

	Plantation_Info[houseid][plantationid][plantationStage] = PLANTATION_STAGE_NULL;
	Plantation_Info[houseid][plantationid][plantationTime] = 0;
	Plantation_DataUpdate(houseid, plantationid, PLANTATION_UPDATE);

	if(hervast) {
		new weedcant = Plantation_CalculateWeedAmount(playerPlantCount);
		PlayerCmeMessage(playerid, 15.0, 5000, "Corta las flores de su planta y las empaqueta, luego la arranca.");
		SetHandItemAndParam(playerid, freehand, ITEM_ID_PACK_MARIHUANA, weedcant);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"obtuviste %i gramos de la planta.", weedcant);
		return 1;
	} else {
		PlayerCmeMessage(playerid, 15.0, 4000, "Arranca la planta y la mete en una bolsa.");
		SetHandItemAndParam(playerid, freehand, ITEM_ID_GARBAGE_BAG, 1);
	}
	return 1;
}

Plantation_CalculateWeedAmount(plantCount)
{
	new amount, baseamount;
	baseamount = (plantCount <= PLANTATION_BASE_PLANT_AMOUNT) ? (PLANTATION_PRODUCT_BASE_AMOUNT) : (floatround((PLANTATION_PRODUCT_BASE_AMOUNT + PLANTATION_PRODUCT_MIN_MAX_RANGE) * floatpower(2.718281828459045235360, -floatpower(plantCount - PLANTATION_BASE_PLANT_AMOUNT, 2) / (2 * PLANTATION_BASE_PLANT_VARIANCE))) - PLANTATION_PRODUCT_MIN_MAX_RANGE); // Gaussiana, pico de PLANTATION_PRODUCT_BASE_AMOUNT, media de PLANTATION_BASE_PLANT_AMOUNT plantas, varianza PLANTATION_BASE_PLANT_VARIANCE
	amount = baseamount + PLANTATION_PRODUCT_MIN_MAX_RANGE - random(PLANTATION_PRODUCT_MIN_MAX_RANGE * 2);
	return (amount >= PLANTATION_PRODUCT_MIN_AMOUNT) ? (amount) : (PLANTATION_PRODUCT_MIN_AMOUNT);
}

Plantation_UpdatePlant(houseid, plantationid)
{
	if(Plantation_Info[houseid][plantationid][plantationStage] == PLANTATION_STAGE_NULL)
	{
		if(Plantation_Info[houseid][plantationid][plantationWeedObjectID])
		{
			DestroyDynamicObject(Plantation_Info[houseid][plantationid][plantationWeedObjectID]);
			Plantation_Info[houseid][plantationid][plantationWeedObjectID] = STREAMER_TAG_OBJECT:0;
		}
		return 0;
	}

	Plantation_Info[houseid][plantationid][plantationTime] += PLANTATION_UPDATE_TIME;
	Plantation_Info[houseid][plantationid][plantationStage] = (Plantation_Info[houseid][plantationid][plantationTime] < PLANTATION_SOWED_DURATION) ? (PLANTATION_STAGE_SOWED) : (
																(Plantation_Info[houseid][plantationid][plantationTime] < PLANTATION_GROWTH_DURATION) ? (PLANTATION_STAGE_GROWTH) : (
																(Plantation_Info[houseid][plantationid][plantationTime] < PLANTATION_HARVABLE_DURATION) ? (PLANTATION_STAGE_HARVABLE) : (
																(Plantation_Info[houseid][plantationid][plantationTime] < PLANTATION_DYING_DURATION) ? (PLANTATION_STAGE_DYING) : 
																(PLANTATION_STAGE_NULL))));

	if(Plantation_Info[houseid][plantationid][plantationFertTime] >= PLANTATION_UPDATE_TIME) {
		Plantation_Info[houseid][plantationid][plantationFertTime] -= PLANTATION_UPDATE_TIME;
	}

	if(Plantation_Info[houseid][plantationid][plantationStage] == PLANTATION_STAGE_SOWED || Plantation_Info[houseid][plantationid][plantationStage] == PLANTATION_STAGE_HARVABLE)
		return 1;
	else {
		if(!Plantation_Info[houseid][plantationid][plantationWeedObjectID]) {
			Plantation_Info[houseid][plantationid][plantationWeedObjectID] = CreateDynamicObject(PLANTATION_PLANT_MODEL, 
																			Plantation_Info[houseid][plantationid][plantationXpos], 
																			Plantation_Info[houseid][plantationid][plantationYpos], 
																			Plantation_Info[houseid][plantationid][plantationZpos] - 0.4, 
																			0.0, 180.0, 0.0, 
																			House_GetInDoorWorld(houseid)
																		);
		}
		else {
			if(Plantation_Info[houseid][plantationid][plantationStage] == PLANTATION_STAGE_DYING || Plantation_Info[houseid][plantationid][plantationStage] == PLANTATION_STAGE_NULL) {
				MoveDynamicObject(Plantation_Info[houseid][plantationid][plantationWeedObjectID], 
								Plantation_Info[houseid][plantationid][plantationXpos], 
								Plantation_Info[houseid][plantationid][plantationYpos], 
								Plantation_Info[houseid][plantationid][plantationZpos] + 0.8 - 0.00022*Plantation_Info[houseid][plantationid][plantationTime], 
								0.015, 0.0, 180.0, 0.0);
			}
			else {
				MoveDynamicObject(Plantation_Info[houseid][plantationid][plantationWeedObjectID], 
								Plantation_Info[houseid][plantationid][plantationXpos], 
								Plantation_Info[houseid][plantationid][plantationYpos], 
								Plantation_Info[houseid][plantationid][plantationZpos] - 0.4 + 0.0022*Plantation_Info[houseid][plantationid][plantationTime], 
								0.015, 0.0, 180.0, 0.0);
			}
		}
	}
	return 1;
}

forward Plantation_UpdateAllTimer(); // Corregir a un esquema de updateo repetitivo por planta
public Plantation_UpdateAllTimer()
{
	for(new id = 1; id < MAX_HOUSES; id++) {
		for(new plantid = 0; plantid < MAX_HOUSE_PLANTS; plantid++) {
			Plantation_UpdatePlant(id, plantid);
		}
	}
	return 1;
}

forward Plantation_UpdateSQLTimer(); // Corregir a un esquema de guardado a demanda, en cada cambio.
public Plantation_UpdateSQLTimer()
{
	for(new id = 1; id < MAX_HOUSES; id++) {
		for(new plantid = 0; plantid < MAX_HOUSE_PLANTS; plantid++) {
			if(Plantation_Info[id][plantid][plantationStage] > PLANTATION_STAGE_NULL) {
				Plantation_DataUpdate(id, plantid, PLANTATION_UPDATE);
			}
		}
	}
	return 1;
}

Plantation_PrintStage(playerid, houseid) 
{
	new plantationid = Plantation_GetClosest(playerid, houseid);
	if(plantationid == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar cerca de una maceta!");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s", PlantStageDescription[Plantation_Info[houseid][plantationid][plantationStage]]);
	return 1;
}

Plantation_Fertilize(playerid, houseid) 
{
	new plantationid = Plantation_GetClosest(playerid, houseid);
	if(plantationid == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar cerca de una maceta!");
	if(Plantation_Info[houseid][plantationid][plantationFertTime] != 0) 
		return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Debes esperar mas tiempo para fertilizar!");
	new fertilizer_hand = SearchHandsForItem(playerid, ITEM_ID_FERTILIZER);
	if(fertilizer_hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener algo de fertilizante en alguna de tus manos.");
	
	if(GetHandParam(playerid, fertilizer_hand) - 100 > 0) {
		SetHandItemAndParam(playerid, fertilizer_hand, ITEM_ID_FERTILIZER, GetHandParam(playerid, fertilizer_hand) - 150);
	} else {
		SetHandItemAndParam(playerid, fertilizer_hand, 0, 0); // Borrado lógico y grafico
	}
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	PlayerCmeMessage(playerid, 15.0, 4000, "Agrega fertilizante a la tierra.");
	Plantation_Info[houseid][plantationid][plantationTime] += 120; // Aumentamos el tiempo en 1 hora.
	Plantation_Info[houseid][plantationid][plantationFertTime] = PLANTATION_TIME_TO_FERTILIZE;
	return 1;
}

Plantation_Reset(houseid, plantationid)
{
	if(Plantation_Info[houseid][plantationid][plantationPotObjectID]) {
		DestroyDynamicObject(Plantation_Info[houseid][plantationid][plantationPotObjectID]);
	}
	if(Plantation_Info[houseid][plantationid][plantationWeedObjectID]) {
		DestroyDynamicObject(Plantation_Info[houseid][plantationid][plantationWeedObjectID]);
	}

	Plantation_Info[houseid][plantationid] = Plantation_InfoReset;
	return 1;
}

Plantation_GetTimeLeft(houseid, plantationid) //Para medir el tiempo restante de la planta
{
    new stage = Plantation_Info[houseid][plantationid][plantationStage];
    new elapsed = Plantation_Info[houseid][plantationid][plantationTime];
    new target = 0;

    switch(stage)
    {
        case PLANTATION_STAGE_SOWED:       target = PLANTATION_SOWED_DURATION;
        case PLANTATION_STAGE_GROWTH:      target = PLANTATION_GROWTH_DURATION;
        case PLANTATION_STAGE_HARVABLE:    target = PLANTATION_HARVABLE_DURATION;
        case PLANTATION_STAGE_DYING:       target = PLANTATION_DYING_DURATION;
        default: return -1; // si no hay planta
    }

    return (elapsed < target) ? (target - elapsed) : 0;
}

CMD:tiempoplantacion(playerid, params[])
{
    new houseid = House_IsPlayerInAny(playerid); // <<--- ahora sí definimos houseid
    if(!houseid)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en una casa.");

    new plantationid = Plantation_GetClosest(playerid, houseid);
    if(plantationid == -1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes estar cerca de una maceta!");
    
    new timeLeft = Plantation_GetTimeLeft(houseid, plantationid);
    if(timeLeft == -1)
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay ninguna planta en esta maceta.");

    new horas = timeLeft / 60;
    new minutos = timeLeft % 60;

    if(horas > 0)
    {
        SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Faltan aproximadamente %d horas y %d minutos para la siguiente etapa.", horas, minutos);
    }
    else if(Plantation_Info[houseid][plantationid][plantationStage] == PLANTATION_STAGE_HARVABLE)
    {
        SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"En pocos minutos la planta ya estará lista.");
    }
    else if(Plantation_Info[houseid][plantationid][plantationStage] == PLANTATION_STAGE_DYING)
    {
        SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"En pocos minutos la planta se secará y perderás la cosecha.");
    }

    return 1;
}
CMD:plantacion(playerid, params[])
{
	new command[32], houseid = House_IsPlayerInAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en una casa.");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(PlayerInfo[playerid][pLevel] < 3)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser al menos nivel 3 para usar este sistema.");

	if(sscanf(params, "s[32]", command))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/plantacion [comando]");
        SendClientMessage(playerid, COLOR_USAGE, "[Comandos] "COLOR_EMB_GREY" ver - ponermaceta - quitarmaceta - sembrar - cosechar - arrancar - fertilizar - /tiempoplantacion");
	} else {
		if(strcmp(command, "ver", true) == 0)
		{
			Plantation_PrintStage(playerid, houseid);
		}
		else if(strcmp(command, "ponermaceta", true) == 0) 
		{
			Plantation_AddPot(playerid, houseid);
		}
		else if(strcmp(command, "quitarmaceta", true) == 0)
		{
			Plantation_RemovePot(playerid, houseid);
		}
		else if(strcmp(command, "sembrar", true) == 0)
		{
			Plantation_Plant(playerid, houseid);
		}
		else if(strcmp(command, "cosechar", true) == 0)
		{
			Plantation_RemovePlant(playerid, houseid, .hervast = true);
		}
		else if(strcmp(command, "arrancar", true) == 0)
		{
			if(KeyChain_Contains(playerid, KEY_TYPE_HOUSE, houseid) || CopDuty[playerid] || AdminDuty[playerid]) {
				Plantation_RemovePlant(playerid, houseid, .hervast = false);
			} else {
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Esta casa no te pertenece o no tienes las llaves!");
			}
		}
		else if(strcmp(command, "fertilizar", true) == 0)
		{
			Plantation_Fertilize(playerid, houseid);
		}
	}
	return 1;
}

CMD:aplantationdebug(playerid, params[])
{
	new houseid;

	if(sscanf(params, "i", houseid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aplantationdebug [houseid]");
	if(!House_IsValidId(houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de casa inválida.");
	
	SendFMessage(playerid, COLOR_WHITE, "Plantaciones de la casa ID: %i.", houseid);
	for(new i = 0; i < MAX_HOUSE_PLANTS; i++)
	{
		new HasPot = IsValidDynamicObject(Plantation_Info[houseid][i][plantationPotObjectID]); 
		new HasPlant = IsValidDynamicObject(Plantation_Info[houseid][i][plantationWeedObjectID]); 
		SendFMessage(playerid, COLOR_WHITE, "ID de plantacion: %i - Tiene maceta: %s - Tiene planta: %s - Etapa: %i - Tiempo: %i", i, (HasPot) ? ("Si") : ("No"), (HasPlant) ? ("Si") : ("No"), Plantation_Info[houseid][i][plantationStage], Plantation_Info[houseid][i][plantationTime]);
	}
	return 1;
}