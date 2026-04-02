#if defined _marp_vehicles_core_included
	#endinput
#endif
#define _marp_vehicles_core_included

// vehicle core

#define	VEH_NONE				0	// Ninguno, no spawnea.
#define	VEH_STATIC				1	// Estaticos, como los CREATED pero se estacionan y no desaparecen. Para diversos usos.
#define	VEH_OWNED				2	// Personal.
#define	VEH_FACTION				3	// facción.
#define	VEH_SCHOOL				4	// Escuela de manejo.
#define	VEH_CREATED				5	// Creado por un administrador, desaparece a los 15 minutos.
#define	VEH_JOB					6	// Empleo.
#define	VEH_RENT                7

#define VTYPE_CAR 				1
#define VTYPE_HEAVY 			2
#define VTYPE_MONSTER 			3
#define VTYPE_BIKE				4
#define VTYPE_QUAD 				5
#define VTYPE_BMX 				6
#define VTYPE_HELI 				7
#define VTYPE_PLANE 			8
#define VTYPE_SEA 				9
#define VTYPE_TRAILER 			10
#define VTYPE_TRAIN 			11
#define VTYPE_BOAT 				VTYPE_SEA
#define VTYPE_BICYCLE 			VTYPE_BMX

#define MAX_VEH                 1001
#define MAX_RENTCAR             30
#define MAX_VEH_PLATE_LENGTH	10


enum Cars {
	VehSQLID,
	VehModel,
	Float:VehPosX,
	Float:VehPosY,
	Float:VehPosZ,
	Float:VehAngle,
	VehParkInt,
	VehParkVW,
	VehInt,
	VehVW,
	VehColor1,
	VehColor2,
	VehPaintjob,
	VehFaction,
	VehJob,
	VehType,
	VehRespawnTime,
	VehOwnerSQLID,
	VehFuel,
	VehEngine,
	VehLights,
	VehAlarm,
	VehLocked,
	VehBonnet,
	VehBoot,
	VehSiren,
	VehObjective,
 	Float:VehHP,
 	VehPlate[MAX_VEH_PLATE_LENGTH],
 	VehDamage1,
 	VehDamage2,
 	VehDamage3,
 	VehDamage4,
	VehOwnerName[MAX_PLAYER_NAME],
	VehCompSlot[14],
	VehRadio,


	VehContainerSQLID,
	VehContainerID,
	STREAMER_TAG_AREA:VehTrunkArea
};

new VehicleInfo[MAX_VEH][Cars];

// Veh-km storage used by vehicle wear system
new Float:VehTotalKm[MAX_VEH];
new Float:VehKmSinceService[MAX_VEH];
new Float:VehNextIssueAtKm[MAX_VEH];
new VehMechProblem[MAX_VEH];

// Fallback define in case wear module isn't included yet.
#if !defined VW_MIN_THRESHOLD_KM
#define VW_MIN_THRESHOLD_KM (200.0)
#endif

enum RCars {
	rVehicleID,
	rRented,
	rTime,
	rOwnerSQLID,
};

new RentCarInfo[MAX_RENTCAR][RCars];


new vlocked;

Veh_IsValidId(vehicleid, bool:ignore_deleted = false) {
	return (1 <= vehicleid < MAX_VEH && IsValidVehicle(vehicleid) && (ignore_deleted || VehicleInfo[vehicleid][VehType] != VEH_NONE));
}

Veh_IsValidModel(modelid) {
	return (400 <= modelid <= 611);
}

Veh_HasContainer(vehicleid) {
	return (VehicleInfo[vehicleid][VehContainerSQLID] > 0 && VehicleInfo[vehicleid][VehContainerID] > 0);
}

Veh_ConsumesFuel(vehicleid)
{
	new model_type = Veh_GetModelType(vehicleid);

	return ((VehicleInfo[vehicleid][VehType] == VEH_OWNED || VehicleInfo[vehicleid][VehType] == VEH_FACTION || VehicleInfo[vehicleid][VehType] == VEH_RENT) &&
			(model_type != VTYPE_HELI && model_type != VTYPE_BMX && model_type != VTYPE_PLANE && model_type != VTYPE_SEA));
}

Veh_GetSystemType(vehicleid) {
	return VehicleInfo[vehicleid][VehType];
}

Veh_GetSystemTypeName(type)
{
    new name[32];
    
    switch(type)
	{
        case 0: strcat(name, "borrado", 32);
		case 1: strcat(name, "estático", 32);
		case 2: strcat(name, "personal", 32);
		case 3: strcat(name, "faccion", 32);
		case 4: strcat(name, "escuela", 32);
		case 5: strcat(name, "temporal", 32);
		case 6: strcat(name, "empleo", 32);
		case 7: strcat(name, "renta", 32);
		default: strcat(name, "¡REPORTAR-BUG!", 32);
    }
    return name;
}

Veh_GetJob(vehicleid) {
	return VehicleInfo[vehicleid][VehJob];
}

Veh_IsPlayerOwner(vehicleid, playerid)
{
	if(!Veh_IsValidId(vehicleid))
		return 0;

	return (VehicleInfo[vehicleid][VehOwnerSQLID] == PlayerInfo[playerid][pID]);
}

SetEngine(vehicleid, status)
{
	GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	VehicleInfo[vehicleid][VehEngine] = status;
	SetVehicleParamsEx(vehicleid, status, VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], 0, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	if(status == 0) {
		// Guardar kilometraje/estado si quedó pendiente
		VW_SaveIfDirty(vehicleid);
	}
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid) {
	return 1;
}

forward Veh_Respawn(vehicleid);
public Veh_Respawn(vehicleid)
{
	SetVehicleToRespawn(vehicleid);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	switch(VehicleInfo[vehicleid][VehType])
	{
		case VEH_NONE: {
			SetVehiclePos(vehicleid, 9999.0, 9999.0, 0.0);
		}
		case VEH_CREATED: {
			return Veh_Delete(vehicleid);
		}
		case VEH_OWNED:
		{
			Veh_UpdateTuning(vehicleid);
			UpdateVehicleDamageStatus(vehicleid, VehicleInfo[vehicleid][VehDamage1], VehicleInfo[vehicleid][VehDamage2], VehicleInfo[vehicleid][VehDamage3], VehicleInfo[vehicleid][VehDamage4]);
		}
		case VEH_FACTION: {
			UpdateVehicleDamageStatus(vehicleid, VehicleInfo[vehicleid][VehDamage1], VehicleInfo[vehicleid][VehDamage2], VehicleInfo[vehicleid][VehDamage3], VehicleInfo[vehicleid][VehDamage4]);
		}
		default: {
			VehicleInfo[vehicleid][VehHP] = 1000.0;
			//SetVehiclePos(vehicleid, VehicleInfo[vehicleid][VehPosX], VehicleInfo[vehicleid][VehPosY], VehicleInfo[vehicleid][VehPosZ]);
		}
	}

	VehicleInfo[vehicleid][VehBonnet] = 0; // le cerramos el capot
	VehicleInfo[vehicleid][VehBoot] = 0; // Le cerramos el maletero
	VehicleInfo[vehicleid][VehRadio] = 0; // Le apagamos la radio

	Veh_SetInteriorAndVWorld(vehicleid, VehicleInfo[vehicleid][VehParkInt], VehicleInfo[vehicleid][VehParkVW], .updateinfo = true, .reload = true);

	SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, VehicleInfo[vehicleid][VehObjective]);
	SetVehicleHealth(vehicleid, VehicleInfo[vehicleid][VehHP]);
	return 1;
}

LoadAllVehicles()
{
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "Veh_OnAllDataLoad" @Format: "SELECT * FROM `vehicles` LIMIT %i;", MAX_VEH - 1);
	print("[INFO] Cargando vehiculos...");
	return 1;
}

forward Veh_OnAllDataLoad();
public Veh_OnAllDataLoad()
{
	new rows = cache_num_rows();

	for(new row, vehid; row < rows; row++)
	{
		cache_get_value_name_int(row, "VehSQLID", vehid);

		cache_get_value_name_int(row, "VehSQLID", VehicleInfo[vehid][VehSQLID]);
		cache_get_value_name_int(row, "VehModel", VehicleInfo[vehid][VehModel]);
		cache_get_value_name_int(row, "VehColor1", VehicleInfo[vehid][VehColor1]);
		cache_get_value_name_int(row, "VehColor2", VehicleInfo[vehid][VehColor2]);
		cache_get_value_name_int(row, "VehPaintjob", VehicleInfo[vehid][VehPaintjob]);
		cache_get_value_name_int(row, "VehFaction", VehicleInfo[vehid][VehFaction]);
		cache_get_value_name_int(row, "VehJob", VehicleInfo[vehid][VehJob]);
		cache_get_value_name_int(row, "VehDamage1", VehicleInfo[vehid][VehDamage1]);
		cache_get_value_name_int(row, "VehDamage2", VehicleInfo[vehid][VehDamage2]);
		cache_get_value_name_int(row, "VehDamage3", VehicleInfo[vehid][VehDamage3]);
		cache_get_value_name_int(row, "VehDamage4", VehicleInfo[vehid][VehDamage4]);
		cache_get_value_name_int(row, "VehFuel", VehicleInfo[vehid][VehFuel]);
		cache_get_value_name_int(row, "VehType", VehicleInfo[vehid][VehType]);
		cache_get_value_name_int(row, "VehRespawnTime", VehicleInfo[vehid][VehRespawnTime]);
		cache_get_value_name_int(row, "VehOwnerID", VehicleInfo[vehid][VehOwnerSQLID]);
		cache_get_value_name_int(row, "VehLocked", VehicleInfo[vehid][VehLocked]);
		cache_get_value_name_int(row, "VehSiren", VehicleInfo[vehid][VehSiren]);

		cache_get_value_name_int(row, "VehInt", VehicleInfo[vehid][VehParkInt]);
		cache_get_value_name_int(row, "VehVW", VehicleInfo[vehid][VehParkVW]);
		cache_get_value_name_int(row, "VehInt", VehicleInfo[vehid][VehInt]);
		cache_get_value_name_int(row, "VehVW", VehicleInfo[vehid][VehVW]);

		cache_get_value_name_float(row, "VehPosX", VehicleInfo[vehid][VehPosX]);
		cache_get_value_name_float(row, "VehPosY", VehicleInfo[vehid][VehPosY]);
		cache_get_value_name_float(row, "VehPosZ", VehicleInfo[vehid][VehPosZ]);
		cache_get_value_name_float(row, "VehAngle", VehicleInfo[vehid][VehAngle]);
		cache_get_value_name_float(row, "VehHP", VehicleInfo[vehid][VehHP]);

		cache_get_value_name(row, "VehPlate", VehicleInfo[vehid][VehPlate], MAX_VEH_PLATE_LENGTH);
		cache_get_value_name(row, "VehOwnerName", VehicleInfo[vehid][VehOwnerName], MAX_PLAYER_NAME);
		
		if(VehicleInfo[vehid][VehType] == VEH_OWNED)
		{
			cache_get_value_name_int(row, "VehCompSlot0", VehicleInfo[vehid][VehCompSlot][0]);
			cache_get_value_name_int(row, "VehCompSlot1", VehicleInfo[vehid][VehCompSlot][1]);
			cache_get_value_name_int(row, "VehCompSlot2", VehicleInfo[vehid][VehCompSlot][2]);
			cache_get_value_name_int(row, "VehCompSlot3", VehicleInfo[vehid][VehCompSlot][3]);
			cache_get_value_name_int(row, "VehCompSlot4", VehicleInfo[vehid][VehCompSlot][4]);
			cache_get_value_name_int(row, "VehCompSlot5", VehicleInfo[vehid][VehCompSlot][5]);
			cache_get_value_name_int(row, "VehCompSlot6", VehicleInfo[vehid][VehCompSlot][6]);
			cache_get_value_name_int(row, "VehCompSlot7", VehicleInfo[vehid][VehCompSlot][7]);
			cache_get_value_name_int(row, "VehCompSlot8", VehicleInfo[vehid][VehCompSlot][8]);
			cache_get_value_name_int(row, "VehCompSlot9", VehicleInfo[vehid][VehCompSlot][9]);
			cache_get_value_name_int(row, "VehCompSlot10", VehicleInfo[vehid][VehCompSlot][10]);
			cache_get_value_name_int(row, "VehCompSlot11", VehicleInfo[vehid][VehCompSlot][11]);
			cache_get_value_name_int(row, "VehCompSlot12", VehicleInfo[vehid][VehCompSlot][12]);
			cache_get_value_name_int(row, "VehCompSlot13", VehicleInfo[vehid][VehCompSlot][13]);
		}
	

		cache_get_value_name_int(row, "VehContainerSQLID", VehicleInfo[vehid][VehContainerSQLID]);

		// Vehículo: campos añadidos por el sistema de desgaste de vehículos (VW)
		cache_get_value_name_float(row, "VehTotalKm", VehTotalKm[vehid]);
		cache_get_value_name_float(row, "VehKmSinceService", VehKmSinceService[vehid]);
		cache_get_value_name_float(row, "VehNextIssueAtKm", VehNextIssueAtKm[vehid]);
		cache_get_value_name_int(row, "VehMechProblem", VehMechProblem[vehid]);

		if(VehNextIssueAtKm[vehid] < VW_MIN_THRESHOLD_KM) VehNextIssueAtKm[vehid] = VW_MIN_THRESHOLD_KM;
		Veh_RecreateWithUpdatedParams(vehid);

		SetVehicleNumberPlate(vehid, VehicleInfo[vehid][VehPlate]);
		SetVehicleToRespawn(vehid);

		VehTrunk_Load(vehid);

		if(VehicleInfo[vehid][VehType] == VEH_RENT)
		{
			VehicleInfo[vehid][VehLocked] = 0;

			for(new i = 1; i < MAX_RENTCAR; i++)
			{
				if(RentCarInfo[i][rVehicleID] < 1)
				{
					RentCarInfo[i][rVehicleID] = vehid;
					RentCarInfo[i][rOwnerSQLID] = 0;
					RentCarInfo[i][rTime] = 0;
					RentCarInfo[i][rRented] = 0;
					break;
				}
			}
		}

		CallLocalFunction("Veh_OnIdDataLoaded", "ii", vehid, row);
	}

	printf("[INFO] Carga de %i vehiculos finalizada.", rows);
	
	CallLocalFunction("Veh_OnAllDataLoaded", "");
	return 1;
}

forward Veh_OnIdDataLoaded(vehid, cacherow);
public Veh_OnIdDataLoaded(vehid, cacherow) {
	return 1;
}

forward Veh_OnAllDataLoaded();
public Veh_OnAllDataLoaded() {
	return 1;
}

forward Veh_OnInsertCallback(vehicleid);
public Veh_OnInsertCallback(vehicleid)
{
	// Asignar el VehSQLID autogenerado por MySQL al vehículo recién creado
	VehicleInfo[vehicleid][VehSQLID] = vehicleid;
	printf("[VEHICLE] Vehículo ID %i insertado en la base de datos con VehSQLID=%i", vehicleid, vehicleid);
	return 1;
}

SaveAllVehicles()
{
	for(new id = 1; id < MAX_VEH; id++) {
		SaveVehicle(id);
	}

	printf("[INFO] Vehiculos guardados.");
	return 1;
}

SaveVehicle(ID) {
	if(VehicleInfo[ID][VehType] == VEH_CREATED)
		return false;

	new query[1200];

	GetVehicleDamageStatus(ID, VehicleInfo[ID][VehDamage1], VehicleInfo[ID][VehDamage2], VehicleInfo[ID][VehDamage3], VehicleInfo[ID][VehDamage4]);
	GetVehicleHealth(ID, VehicleInfo[ID][VehHP]);
	GetVehicleParamsEx(ID, VehicleInfo[ID][VehEngine], VehicleInfo[ID][VehLights], VehicleInfo[ID][VehAlarm], vlocked, VehicleInfo[ID][VehBonnet], VehicleInfo[ID][VehBoot], VehicleInfo[ID][VehObjective]);

	// Vehículo nuevo: sin VehSQLID en DB, insertamos con el mismo ID de slot
	if(VehicleInfo[ID][VehSQLID] == 0)
	{
		VehicleInfo[ID][VehSQLID] = ID;
		mysql_format(MYSQL_HANDLE, query, sizeof(query), \
			"INSERT INTO `vehicles` (\
			`VehSQLID`,`VehModel`,`VehPosX`,`VehPosY`,`VehPosZ`,`VehAngle`,`VehInt`,`VehVW`,\
			`VehColor1`,`VehColor2`,`VehPaintjob`,`VehFaction`,`VehJob`,\
			`VehDamage1`,`VehDamage2`,`VehDamage3`,`VehDamage4`,\
			`VehType`,`VehRespawnTime`,`VehOwnerID`,`VehLocked`,`VehSiren`,\
			`VehFuel`,`VehHP`,`VehPlate`,`VehOwnerName`,\
			`VehCompSlot0`,`VehCompSlot1`,`VehCompSlot2`,`VehCompSlot3`,`VehCompSlot4`,`VehCompSlot5`,`VehCompSlot6`,\
			`VehCompSlot7`,`VehCompSlot8`,`VehCompSlot9`,`VehCompSlot10`,`VehCompSlot11`,`VehCompSlot12`,`VehCompSlot13`,\
			`VehContainerSQLID`)\
			VALUES (\
			%i,%i,%f,%f,%f,%f,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%f,'%e','%e',\
			%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i);",
			VehicleInfo[ID][VehSQLID],
			VehicleInfo[ID][VehModel],
			VehicleInfo[ID][VehPosX],
			VehicleInfo[ID][VehPosY],
			VehicleInfo[ID][VehPosZ],
			VehicleInfo[ID][VehAngle],
			VehicleInfo[ID][VehParkInt],
			VehicleInfo[ID][VehParkVW],
			VehicleInfo[ID][VehColor1],
			VehicleInfo[ID][VehColor2],
			VehicleInfo[ID][VehPaintjob],
			VehicleInfo[ID][VehFaction],
			VehicleInfo[ID][VehJob],
			VehicleInfo[ID][VehDamage1],
			VehicleInfo[ID][VehDamage2],
			VehicleInfo[ID][VehDamage3],
			VehicleInfo[ID][VehDamage4],
			VehicleInfo[ID][VehType],
			VehicleInfo[ID][VehRespawnTime],
			VehicleInfo[ID][VehOwnerSQLID],
			VehicleInfo[ID][VehLocked],
			VehicleInfo[ID][VehSiren],
			VehicleInfo[ID][VehFuel],
			VehicleInfo[ID][VehHP],
			VehicleInfo[ID][VehPlate],
			VehicleInfo[ID][VehOwnerName],
			VehicleInfo[ID][VehCompSlot][0],
			VehicleInfo[ID][VehCompSlot][1],
			VehicleInfo[ID][VehCompSlot][2],
			VehicleInfo[ID][VehCompSlot][3],
			VehicleInfo[ID][VehCompSlot][4],
			VehicleInfo[ID][VehCompSlot][5],
			VehicleInfo[ID][VehCompSlot][6],
			VehicleInfo[ID][VehCompSlot][7],
			VehicleInfo[ID][VehCompSlot][8],
			VehicleInfo[ID][VehCompSlot][9],
			VehicleInfo[ID][VehCompSlot][10],
			VehicleInfo[ID][VehCompSlot][11],
			VehicleInfo[ID][VehCompSlot][12],
			VehicleInfo[ID][VehCompSlot][13],
			VehicleInfo[ID][VehContainerSQLID]
		);
		mysql_tquery(MYSQL_HANDLE, query);
		return true;
	}

	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"UPDATE `vehicles` SET \
			`VehModel`=%i,\
			`VehPosX`=%f,\
			`VehPosY`=%f,\
			`VehPosZ`=%f,\
			`VehAngle`=%f,\
			`VehInt`=%i,\
			`VehVW`=%i,\
			`VehColor1`=%i,\
			`VehColor2`=%i,\
			`VehPaintjob`=%i,\
			`VehFaction`=%i,\
			`VehJob`=%i,\
			`VehDamage1`=%i,\
			`VehDamage2`=%i,\
			`VehDamage3`=%i,\
			`VehDamage4`=%i,\
			`VehType`=%i,\
			`VehRespawnTime`=%i,\
			`VehOwnerID`=%i,\
			`VehLocked`=%i,\
			`VehSiren`=%i,\
			`VehFuel`=%i,\
			`VehHP`=%f,\
			`VehPlate`='%e',\
			`VehOwnerName`='%e',\
			`VehCompSlot0`=%i,\
			`VehCompSlot1`=%i,\
			`VehCompSlot2`=%i,\
			`VehCompSlot3`=%i,\
			`VehCompSlot4`=%i,\
			`VehCompSlot5`=%i,\
			`VehCompSlot6`=%i,\
			`VehCompSlot7`=%i,\
			`VehCompSlot8`=%i,\
			`VehCompSlot9`=%i,\
			`VehCompSlot10`=%i,\
			`VehCompSlot11`=%i,\
			`VehCompSlot12`=%i,\
			`VehCompSlot13`=%i,\
			`VehContainerSQLID`=%i \
		WHERE \
			`VehSQLID`=%i;",
		VehicleInfo[ID][VehModel],
		VehicleInfo[ID][VehPosX],
		VehicleInfo[ID][VehPosY],
		VehicleInfo[ID][VehPosZ],
		VehicleInfo[ID][VehAngle],
		VehicleInfo[ID][VehParkInt],
		VehicleInfo[ID][VehParkVW],
		VehicleInfo[ID][VehColor1],
		VehicleInfo[ID][VehColor2],
		VehicleInfo[ID][VehPaintjob],
		VehicleInfo[ID][VehFaction],
		VehicleInfo[ID][VehJob],
		VehicleInfo[ID][VehDamage1],
		VehicleInfo[ID][VehDamage2],
		VehicleInfo[ID][VehDamage3],
		VehicleInfo[ID][VehDamage4],
		VehicleInfo[ID][VehType],
		VehicleInfo[ID][VehRespawnTime],
		VehicleInfo[ID][VehOwnerSQLID],
		VehicleInfo[ID][VehLocked],
		VehicleInfo[ID][VehSiren],
		VehicleInfo[ID][VehFuel],
		VehicleInfo[ID][VehHP],
		VehicleInfo[ID][VehPlate],
		VehicleInfo[ID][VehOwnerName],
		VehicleInfo[ID][VehCompSlot][0],
		VehicleInfo[ID][VehCompSlot][1],
		VehicleInfo[ID][VehCompSlot][2],
		VehicleInfo[ID][VehCompSlot][3],
		VehicleInfo[ID][VehCompSlot][4],
		VehicleInfo[ID][VehCompSlot][5],
		VehicleInfo[ID][VehCompSlot][6],
		VehicleInfo[ID][VehCompSlot][7],
		VehicleInfo[ID][VehCompSlot][8],
		VehicleInfo[ID][VehCompSlot][9],
		VehicleInfo[ID][VehCompSlot][10],
		VehicleInfo[ID][VehCompSlot][11],
		VehicleInfo[ID][VehCompSlot][12],
		VehicleInfo[ID][VehCompSlot][13],
		VehicleInfo[ID][VehContainerSQLID],
		VehicleInfo[ID][VehSQLID]
	);
	mysql_tquery(MYSQL_HANDLE, query);
	return true;
}

/*SaveVehicle(id)
{
	if(VehicleInfo[id][VehType] == VEH_CREATED)
		return 0;

	new query[1500];

	GetVehicleDamageStatus(id, VehicleInfo[id][VehDamage1], VehicleInfo[id][VehDamage2], VehicleInfo[id][VehDamage3], VehicleInfo[id][VehDamage4]);
	GetVehicleHealth(id, VehicleInfo[id][VehHP]);
	GetVehicleParamsEx(id, VehicleInfo[id][VehEngine], VehicleInfo[id][VehLights], VehicleInfo[id][VehAlarm], vlocked, VehicleInfo[id][VehBonnet], VehicleInfo[id][VehBoot], VehicleInfo[id][VehObjective]);

	// Si VehSQLID es 0, es un vehículo nuevo que necesita un INSERT
	if(VehicleInfo[id][VehSQLID] == 0)
	{
		mysql_format(MYSQL_HANDLE, query, sizeof(query), \
			"INSERT INTO `vehicles` \
				(`VehSQLID`, `VehModel`, `VehPosX`, `VehPosY`, `VehPosZ`, `VehAngle`, `VehInt`, `VehVW`, \
				`VehColor1`, `VehColor2`, `VehPaintjob`, `VehFaction`, `VehJob`, `VehDamage1`, `VehDamage2`, \
				`VehDamage3`, `VehDamage4`, `VehType`, `VehRespawnTime`, `VehOwnerID`, `VehLocked`, `VehSiren`, \
				`VehFuel`, `VehHP`, `VehPlate`, `VehOwnerName`, `VehCompSlot0`, `VehCompSlot1`, `VehCompSlot2`, \
				`VehCompSlot3`, `VehCompSlot4`, `VehCompSlot5`, `VehCompSlot6`, `VehCompSlot7`, `VehCompSlot8`, \
				`VehCompSlot9`, `VehCompSlot10`, `VehCompSlot11`, `VehCompSlot12`, `VehCompSlot13`, `VehContainerSQLID`) \
			VALUES \
				(%i, %i, %f, %f, %f, %f, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %f, '%e', '%s', \
				%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i);",
			id,
			VehicleInfo[id][VehModel],
			VehicleInfo[id][VehPosX],
			VehicleInfo[id][VehPosY],
			VehicleInfo[id][VehPosZ],
			VehicleInfo[id][VehAngle],
			VehicleInfo[id][VehParkInt],
			VehicleInfo[id][VehParkVW],
			VehicleInfo[id][VehColor1],
			VehicleInfo[id][VehColor2],
			VehicleInfo[id][VehPaintjob],
			VehicleInfo[id][VehFaction],
			VehicleInfo[id][VehJob],
			VehicleInfo[id][VehDamage1],
			VehicleInfo[id][VehDamage2],
			VehicleInfo[id][VehDamage3],
			VehicleInfo[id][VehDamage4],
			VehicleInfo[id][VehType],
			VehicleInfo[id][VehRespawnTime],
			VehicleInfo[id][VehOwnerSQLID],
			VehicleInfo[id][VehLocked],
			VehicleInfo[id][VehSiren],
			VehicleInfo[id][VehFuel],
			VehicleInfo[id][VehHP],
			VehicleInfo[id][VehPlate],
			VehicleInfo[id][VehOwnerName],
			VehicleInfo[id][VehCompSlot][0],
			VehicleInfo[id][VehCompSlot][1],
			VehicleInfo[id][VehCompSlot][2],
			VehicleInfo[id][VehCompSlot][3],
			VehicleInfo[id][VehCompSlot][4],
			VehicleInfo[id][VehCompSlot][5],
			VehicleInfo[id][VehCompSlot][6],
			VehicleInfo[id][VehCompSlot][7],
			VehicleInfo[id][VehCompSlot][8],
			VehicleInfo[id][VehCompSlot][9],
			VehicleInfo[id][VehCompSlot][10],
			VehicleInfo[id][VehCompSlot][11],
			VehicleInfo[id][VehCompSlot][12],
			VehicleInfo[id][VehCompSlot][13],
			VehicleInfo[id][VehContainerSQLID]
		);
		mysql_tquery(MYSQL_HANDLE, query, "Veh_OnInsertCallback", "i", id);
		return 1;
	}

	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"UPDATE `vehicles` SET \
			`VehModel`=%i,\
			`VehPosX`=%f,\
			`VehPosY`=%f,\
			`VehPosZ`=%f,\
			`VehAngle`=%f,\
			`VehInt`=%i,\
			`VehVW`=%i,\
			`VehColor1`=%i,\
			`VehColor2`=%i,\
			`VehPaintjob`=%i,\
			`VehFaction`=%i,\
			`VehJob`=%i,\
			`VehDamage1`=%i,\
			`VehDamage2`=%i,\
			`VehDamage3`=%i,\
			`VehDamage4`=%i,\
			`VehType`=%i,\
			`VehRespawnTime`=%i,\
			`VehOwnerID`=%i,\
			`VehLocked`=%i,\
			`VehSiren`=%i,\
			`VehFuel`=%i,\
			`VehHP`=%f,\
			`VehPlate`='%e',\
			`VehOwnerName`='%s',\
			`VehCompSlot0`=%i,\
			`VehCompSlot1`=%i,\
			`VehCompSlot2`=%i,\
			`VehCompSlot3`=%i,\
			`VehCompSlot4`=%i,\
			`VehCompSlot5`=%i,\
			`VehCompSlot6`=%i,\
			`VehCompSlot7`=%i,\
			`VehCompSlot8`=%i,\
			`VehCompSlot9`=%i,\
			`VehCompSlot10`=%i,\
			`VehCompSlot11`=%i,\
			`VehCompSlot12`=%i,\
			`VehCompSlot13`=%i,\
			`VehContainerSQLID`=%i \
		WHERE \
			`VehSQLID`=%i;",
		VehicleInfo[id][VehModel],
		VehicleInfo[id][VehPosX],
		VehicleInfo[id][VehPosY],
		VehicleInfo[id][VehPosZ],
		VehicleInfo[id][VehAngle],
		VehicleInfo[id][VehParkInt],
		VehicleInfo[id][VehParkVW],
		VehicleInfo[id][VehColor1],
		VehicleInfo[id][VehColor2],
		VehicleInfo[id][VehPaintjob],
		VehicleInfo[id][VehFaction],
		VehicleInfo[id][VehJob],
		VehicleInfo[id][VehDamage1],
		VehicleInfo[id][VehDamage2],
		VehicleInfo[id][VehDamage3],
		VehicleInfo[id][VehDamage4],
		VehicleInfo[id][VehType],
		VehicleInfo[id][VehRespawnTime],
		VehicleInfo[id][VehOwnerSQLID],
		VehicleInfo[id][VehLocked],
		VehicleInfo[id][VehSiren],
		VehicleInfo[id][VehFuel],
		VehicleInfo[id][VehHP],
		VehicleInfo[id][VehPlate],
		VehicleInfo[id][VehOwnerName],
		VehicleInfo[id][VehCompSlot][0],
		VehicleInfo[id][VehCompSlot][1],
		VehicleInfo[id][VehCompSlot][2],
		VehicleInfo[id][VehCompSlot][3],
		VehicleInfo[id][VehCompSlot][4],
		VehicleInfo[id][VehCompSlot][5],
		VehicleInfo[id][VehCompSlot][6],
		VehicleInfo[id][VehCompSlot][7],
		VehicleInfo[id][VehCompSlot][8],
		VehicleInfo[id][VehCompSlot][9],
		VehicleInfo[id][VehCompSlot][10],
		VehicleInfo[id][VehCompSlot][11],
		VehicleInfo[id][VehCompSlot][12],
		VehicleInfo[id][VehCompSlot][13],
		VehicleInfo[id][VehContainerSQLID],
		VehicleInfo[id][VehSQLID]
	);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}*/

Veh_SetCustomPlate(vehicleid, const string[])
{
	if(!Veh_IsValidId(vehicleid) || isnull(string))
		return 0;

	strcopy(VehicleInfo[vehicleid][VehPlate], string, MAX_VEH_PLATE_LENGTH);
	SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][VehPlate]);
	return 1;
}

// Buscar vehículo por VehSQLID (útil si algún sistema usa SQLID en lugar de slot)
stock Veh_GetSlotFromSQLID(sqlid)
{
	for(new i = 1; i < MAX_VEH; i++)
	{
		if(VehicleInfo[i][VehType] != VEH_NONE && VehicleInfo[i][VehSQLID] == sqlid)
			return i;
	}
	return 0;
}


Veh_SetRandomPlate(vehicleid)
{
	// [FIX] Validar solo que la ID existe, no que el vehículo esté creado en el servidor
	if(!(1 <= vehicleid < MAX_VEH))
		return 0;

	format(VehicleInfo[vehicleid][VehPlate], MAX_VEH_PLATE_LENGTH, "%c%c %i%i%i %c%c", 65 + random(26), 65 + random(26), random(10), random(10), random(10), 65 + random(26), 65 + random(26));
	if(IsValidVehicle(vehicleid)) {
		SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][VehPlate]);
	}
	return 1;
}

Veh_SetAllRandomPlates() {
	for(new vehicleid = 1; vehicleid < MAX_VEH; vehicleid++) {
		if(Veh_GetSystemType(vehicleid) != VEH_NONE) {
			Veh_SetRandomPlate(vehicleid);
		}
	}
}

IsVehicleOccupied(vehicleid)
{
	foreach(new i : Player) {
		if(IsPlayerInVehicle(i, vehicleid)) 
			return 1;
	}
	return 0;
}

stock Veh_Create(modelid, color1, color2, Float:x, Float:y, Float:z, Float:angle, interior, vworld, respawn_secs) {
	new vehicleid = 0;

	for(new i = 1; i < MAX_VEH && !vehicleid; i++) {
		if(VehicleInfo[i][VehType] == VEH_NONE) {
			vehicleid = i;

			VehicleInfo[vehicleid][VehType] = (respawn_secs > 0) ? (VEH_CREATED) : (VEH_STATIC);
			VehicleInfo[vehicleid][VehRespawnTime] = (respawn_secs > 0) ? (respawn_secs) : (-1);
			VehicleInfo[vehicleid][VehModel] = modelid;
			VehicleInfo[vehicleid][VehLocked] = 0;
			SetEngine(vehicleid, 0);
			VehicleInfo[vehicleid][VehColor1] = color1;
			VehicleInfo[vehicleid][VehColor2] = color2;
			Veh_SetInteriorAndVWorld(vehicleid, interior, vworld, .reload = false);
			Veh_SetParkingPoint(vehicleid, x, y, z, angle, interior, vworld);
			Veh_SetRandomPlate(vehicleid);
			VehicleInfo[vehicleid][VehFuel] = 100;

			Veh_RecreateWithUpdatedParams(vehicleid);

			VehTrunk_Create(vehicleid);

			SaveVehicle(vehicleid);
		}
	}

	return vehicleid;
}

Veh_Delete(vehicleid) {
	Veh_RemoveCurrentType(vehicleid);

	VehicleInfo[vehicleid][VehType] = VEH_NONE;
	VehicleInfo[vehicleid][VehRespawnTime] = -1;
	VehicleInfo[vehicleid][VehModel] = 500;
	VehicleInfo[vehicleid][VehPosX] = 9999.0;
	VehicleInfo[vehicleid][VehPosY] = 9999.0;
	VehicleInfo[vehicleid][VehPosZ] = 9999.0;
	VehicleInfo[vehicleid][VehAngle] = 0.0;
	VehicleInfo[vehicleid][VehParkInt] = 0;
	VehicleInfo[vehicleid][VehParkVW] = 0;
	VehicleInfo[vehicleid][VehInt] = 0;
	VehicleInfo[vehicleid][VehVW] = 0;
	VehicleInfo[vehicleid][VehColor1] = 0;
	VehicleInfo[vehicleid][VehColor2] = 0;
	VehicleInfo[vehicleid][VehPaintjob]	= 3;
	VehicleInfo[vehicleid][VehFaction] = 0;
	VehicleInfo[vehicleid][VehJob] = 0;
	VehicleInfo[vehicleid][VehDamage1] = 0;
	VehicleInfo[vehicleid][VehDamage2] = 0;
	VehicleInfo[vehicleid][VehDamage3] = 0;
	VehicleInfo[vehicleid][VehDamage4] = 0;
	VehicleInfo[vehicleid][VehOwnerSQLID] = 0;
	VehicleInfo[vehicleid][VehLocked] = 0;
	VehicleInfo[vehicleid][VehEngine] = 0;
	VehicleInfo[vehicleid][VehBonnet] = 0;
	VehicleInfo[vehicleid][VehBoot] = 0;
	VehicleInfo[vehicleid][VehSiren] = 0;
	VehicleInfo[vehicleid][VehLights] = 0;
	VehicleInfo[vehicleid][VehFuel] = 100;
	VehicleInfo[vehicleid][VehHP] = 1000.0;
	VehicleInfo[vehicleid][VehPlate] = "XXXXXXXXX";
	strcopy(VehicleInfo[vehicleid][VehOwnerName], "XXXXXXXXXX", MAX_PLAYER_NAME);
	VehicleInfo[vehicleid][VehRadio] = 0;

	for(new i = 0; i < 14; i++)	{
		VehicleInfo[vehicleid][VehCompSlot][i] = 0;
	}

	VehTrunk_Delete(vehicleid);
	Veh_RecreateWithUpdatedParams(vehicleid);

	VehicleInfo[vehicleid][VehContainerSQLID] = 0;

    SetEngine(vehicleid, 0);
	SaveVehicle(vehicleid);
	return true;
}

Veh_RemoveCurrentType(vehicleid) {
	if(VehicleInfo[vehicleid][VehType] == VEH_RENT)
	{
		for(new i = 1; i < MAX_RENTCAR; i++)
		{
			if(RentCarInfo[i][rVehicleID] == vehicleid)
			{
				RentCarInfo[i][rVehicleID] = 0;
				RentCarInfo[i][rOwnerSQLID] = 0;
				RentCarInfo[i][rTime] = 0;
				RentCarInfo[i][rRented] = 0;
				break;
			}
		}
	}
	else if(VehicleInfo[vehicleid][VehType] == VEH_OWNED)
	{
		KeyChain_DeleteAll(KEY_TYPE_VEHICLE, vehicleid, .allowIfOwnerKey = true);
		VehicleInfo[vehicleid][VehOwnerSQLID] = 0;
		strcopy(VehicleInfo[vehicleid][VehOwnerName], "XXXXXXXXXX", MAX_PLAYER_NAME);
	}
}



Veh_SetRespawnPoint(vehicleid, Float:x, Float:y, Float:z, Float:angle, vworld, interior)
{
	if(VehicleInfo[vehicleid][VehType] == VEH_NONE)
		return 0;

	GetVehicleDamageStatus(vehicleid, VehicleInfo[vehicleid][VehDamage1], VehicleInfo[vehicleid][VehDamage2], VehicleInfo[vehicleid][VehDamage3], VehicleInfo[vehicleid][VehDamage4]);
	GetVehicleHealth(vehicleid, VehicleInfo[vehicleid][VehHP]);
	Veh_SetParkingPoint(vehicleid, x, y, z, angle, interior, vworld);
	Veh_SetInteriorAndVWorld(vehicleid, interior, vworld);
	Veh_RecreateWithUpdatedParams(vehicleid);
	UpdateVehicleDamageStatus(vehicleid, VehicleInfo[vehicleid][VehDamage1], VehicleInfo[vehicleid][VehDamage2], VehicleInfo[vehicleid][VehDamage3], VehicleInfo[vehicleid][VehDamage4]);
	SetVehicleHealth(vehicleid, VehicleInfo[vehicleid][VehHP]);
	SaveVehicle(vehicleid);
	return 1;
}

Veh_SetModel(vehicleid, modelid)
{
	if(VehicleInfo[vehicleid][VehType] == VEH_NONE)
		return 0;

	new Float:x, Float:y, Float:z, Float:angle;

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, angle);

	Veh_ResetTuning(vehicleid);
	VehicleInfo[vehicleid][VehModel] = modelid;
	Veh_RecreateWithUpdatedParams(vehicleid);

	VehTrunk_Delete(vehicleid);
	VehTrunk_Create(vehicleid);

	SetVehiclePos(vehicleid, x, y, z);
	SetVehicleZAngle(vehicleid, angle);

	SaveVehicle(vehicleid);
	return 1;
}

Veh_SetType(vehicleid, type)
{
	if(VehicleInfo[vehicleid][VehType] == VEH_NONE)
		return 0;

	Veh_RemoveCurrentType(vehicleid);

	if(type == VEH_RENT)
	{
		new available = -1;
		for(new i = 1; i < MAX_RENTCAR; i++)
		{
			if(RentCarInfo[i][rVehicleID] < 1)
			{
				RentCarInfo[i][rVehicleID] = vehicleid;
				RentCarInfo[i][rOwnerSQLID] = 0;
				RentCarInfo[i][rTime] = 0;
				RentCarInfo[i][rRented] = 0;
				available = i;
				break;
			}
		}
		if(available == -1) {
			return 0;
		}
	}

	VehicleInfo[vehicleid][VehType] = type;
	SaveVehicle(vehicleid);
	return 1;
}

Veh_SetColor(vehicleid, color1, color2)
{
	if(VehicleInfo[vehicleid][VehType] == VEH_NONE)
		return 0;

	new Float:x, Float:y, Float:z, Float:angle;

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, angle);

	VehicleInfo[vehicleid][VehColor1] = color1;
	VehicleInfo[vehicleid][VehColor2] = color2;

	Veh_RecreateWithUpdatedParams(vehicleid);

	SetVehiclePos(vehicleid, x, y, z);
	SetVehicleZAngle(vehicleid, angle);

	SaveVehicle(vehicleid);
	return 1;
}

Veh_SetSiren(vehicleid, siren)
{
	if(VehicleInfo[vehicleid][VehType] == VEH_NONE)
		return 0;

	new Float:x, Float:y, Float:z, Float:angle;

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, angle);

	VehicleInfo[vehicleid][VehSiren] = siren;
	Veh_RecreateWithUpdatedParams(vehicleid);

	SetVehiclePos(vehicleid, x, y, z);
	SetVehicleZAngle(vehicleid, angle);

	SaveVehicle(vehicleid);
	return 1;
}

Veh_RecreateWithUpdatedParams(vehicleid)
{
	DestroyVehicle(vehicleid);
	CreateVehicle(VehicleInfo[vehicleid][VehModel], VehicleInfo[vehicleid][VehPosX], VehicleInfo[vehicleid][VehPosY], VehicleInfo[vehicleid][VehPosZ], VehicleInfo[vehicleid][VehAngle], VehicleInfo[vehicleid][VehColor1], VehicleInfo[vehicleid][VehColor2], VehicleInfo[vehicleid][VehRespawnTime], bool:VehicleInfo[vehicleid][VehSiren]);
	SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][VehPlate]);
	SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, VehicleInfo[vehicleid][VehObjective]);
	GetVehicleParamsEx(vehicleid, VehicleInfo[vehicleid][VehEngine], VehicleInfo[vehicleid][VehLights], VehicleInfo[vehicleid][VehAlarm], vlocked, VehicleInfo[vehicleid][VehBonnet], VehicleInfo[vehicleid][VehBoot], VehicleInfo[vehicleid][VehObjective]);
	Veh_UpdateTuning(vehicleid);

	Veh_SetInteriorAndVWorld(vehicleid, VehicleInfo[vehicleid][VehParkInt], VehicleInfo[vehicleid][VehParkVW], .updateinfo = true, .reload = true);
	VehTrunk_Reload(vehicleid);
	return 1;
}

static Veh_SetParkingPoint(vehicleid, Float:x, Float:y, Float:z, Float:angle, interior, vworld)
{
	VehicleInfo[vehicleid][VehPosX] = x;
	VehicleInfo[vehicleid][VehPosY] = y;
	VehicleInfo[vehicleid][VehPosZ] = z;
	VehicleInfo[vehicleid][VehAngle] = angle;
	VehicleInfo[vehicleid][VehParkInt] = interior;
	VehicleInfo[vehicleid][VehParkVW] = vworld;
}

static Veh_ResetTuning(vehicleid)
{
	for(new i = 0; i < 14; i++) {
		VehicleInfo[vehicleid][VehCompSlot][i] = 0;
	}
	VehicleInfo[vehicleid][VehPaintjob] = 3;
}

static Veh_UpdateTuning(vehicleid)
{
	for(new i = 0; i < 14; i++)
	{
		if(VehicleInfo[vehicleid][VehCompSlot][i] != 0) {
			AddVehicleComponent(vehicleid, VehicleInfo[vehicleid][VehCompSlot][i]);
		}
	}
	ChangeVehiclePaintjob(vehicleid, VehicleInfo[vehicleid][VehPaintjob]);
	ChangeVehicleColor(vehicleid, VehicleInfo[vehicleid][VehColor1], VehicleInfo[vehicleid][VehColor2]);
}

Veh_SaveTuning(vehicleid, color1 = -1, color2 = -1, paintjob = 3)
{
	for (new slot = 0; slot < 14; slot++)
	{
		if(GetVehicleComponentInSlot(vehicleid, slot) != 0) {
			VehicleInfo[vehicleid][VehCompSlot][slot] = GetVehicleComponentInSlot(vehicleid, slot);
		}
	}
	
	if(color1 != -1) {
		VehicleInfo[vehicleid][VehColor1] = color1;
	}

	if(color2 != -1) {
		VehicleInfo[vehicleid][VehColor2] = color2;
	}

	if(0 <= paintjob <= 2) {
		VehicleInfo[vehicleid][VehPaintjob] = paintjob;
	}

	return 1;
}

stock Veh_OnTuningSaved(vehicleid) {
	return 1;
}

Veh_GetFreeSeat(vehicleid)
{
	new maxSeats = Veh_GetMaxSeats(vehicleid), 
		bool:usedSeats[10];

	foreach(new playerid : Player)
    {
		if(!IsPlayerInVehicle(playerid, vehicleid))
			continue;

		usedSeats[GetPlayerVehicleSeat(playerid)] = true;
	}

	for(new i = 0; i < maxSeats; i++) {
		if(!usedSeats[i]) {
			return i;
		}
	}
	return -1;
}

Veh_SetOwnerName(vehicleid, const name[])
{
	if(VehicleInfo[vehicleid][VehType] == VEH_NONE)
		return 0;

	strcopy(VehicleInfo[vehicleid][VehOwnerName], name, MAX_PLAYER_NAME);
	SaveVehicle(vehicleid);
	return 1;
}

Veh_OnPlayerCharacterKill(vehicleid, playerid, notifyid)
{
	if(!Veh_IsPlayerOwner(vehicleid, playerid))
		return 0;

	GivePlayerCash(playerid, Veh_GetPrice(vehicleid) / 2); // 50% del valor original.
	ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="Vendido por CK", .playerid=playerid);
	SendFMessage(notifyid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" Vendido el vehículo %s ID %i.", Veh_GetName(vehicleid), vehicleid);
	Veh_Delete(vehicleid);
	return 1;
}

hook KeyChain_OnInit()
{
	KeyChain_SetKeyTypeData(
		.type = KEY_TYPE_VEHICLE,
		.typeName = "vehículo",
		.logType = LOG_TYPE_ID_VEHICLES,
		.onPaydayAddr = GetPublicAddressFromName("Veh_OnPlayerPayday"),
		.onNameChangeAddr = GetPublicAddressFromName("Veh_OnPlayerNameChange"),
		.onCopyCheckAddr = 0
	);
	return 1;
}

forward Veh_OnPlayerNameChange(vehicleid, playerid, const name[]);
public Veh_OnPlayerNameChange(vehicleid, playerid, const name[]) {
	return Veh_SetOwnerName(vehicleid, name);
}

forward Veh_OnPlayerPayday(vehicleid, playerid, &income, &tax);
public Veh_OnPlayerPayday(vehicleid, playerid, &income, &tax)
{
	if(!Veh_IsPlayerOwner(vehicleid, playerid))
		return 0;

	tax += floatround(Veh_GetPrice(vehicleid) * Server_VehTaxPercent, floatround_ceil);
	return 1;
}

Veh_SetInteriorAndVWorld(vehicleid, interior, vworld, bool:updateinfo = true, bool:reload = true)
{
	if(updateinfo)
	{
		VehicleInfo[vehicleid][VehInt] = interior;
		VehicleInfo[vehicleid][VehVW] = vworld;
	}	

	LinkVehicleToInterior(vehicleid, interior);
	SetVehicleVirtualWorld(vehicleid, vworld);

	if(reload) {
		VehTrunk_Reload(vehicleid);
	}	
}

stock Veh_GetInterior(vehicleid) {
	return VehicleInfo[vehicleid][VehInt];
}