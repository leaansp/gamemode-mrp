#if defined _marp_equipment_points_included
	#endinput
#endif
#define _marp_equipment_points_included

const EQUIP_POINTS_MAX_AMOUNT = 64;
const INVALID_EQUIP_POINT_ID = -1;

static EQUIP_USE_ADDR;
static EQUIP_ON_ENTER_ADDR;
static EQUIP_ON_LEAVE_ADDR;

static enum e_EQUIP_POINT_DATA
{
    epId,
    epBldId,
    epFaction,
    STREAMER_TAG_AREA:epPickup,
    Button:epButton,
    epModelId,
    Float:epX,
    Float:epY,
    Float:epZ,
    Float:epR,
    epVWorld
}

static EquipmentPointData[EQUIP_POINTS_MAX_AMOUNT + 1][e_EQUIP_POINT_DATA] = {
    {
        /*epId*/ -1,
        /*epBldId*/ -1,
        /*epFaction*/ 0,
        /*STREAMER_TAG_AREA:epPickup*/ INVALID_STREAMER_ID,
        /*STREAMER_TAG_AREA:epButton*/ INVALID_BUTTON_ID,
        /*epModelId*/ 1239,
        /*epX*/ 0.0,
        /*epY*/ 0.0,
        /*epZ*/ 0.0,
        /*epR*/ 2.0,
        /*epVWorld*/ 0
    }, ...
};

static Iterator:EquipmentPointData<EQUIP_POINTS_MAX_AMOUNT>;

static EquipmentPointPlayerData[MAX_PLAYERS] = {INVALID_EQUIP_POINT_ID, ...};

// Model mapping per faction (defaults)
stock EquipPoint_GetModelForFaction(factionid)
{
    switch(factionid)
    {
        case FAC_PMA: return 1242; // Police locker
        case FAC_SIDE: return 1242; // Gendarmería locker (same model)
        case FAC_HOSP: return 1239; // Medical locker
    }
    return 1239;
}

hook OnGameModeInit()
{
    EQUIP_USE_ADDR = GetPublicAddressFromName("EquipmentPnt_OnUse");
    EQUIP_ON_ENTER_ADDR = GetPublicAddressFromName("EquipmentPnt_OnPlayerEnter");
    EQUIP_ON_LEAVE_ADDR = GetPublicAddressFromName("EquipmentPnt_OnPlayerLeave");
	return 1;
}

EquipmentPoint_Create(Float:x, Float:y, Float:z, Float:r, vworld, factionid = 0, modelid = 0, bldid = -1)
{
    new equipid = Iter_Free(EquipmentPointData);

    if(equipid == ITER_NONE)
    {
		printf("[ERROR] Alcanzado EQUIP_POINTS_MAX_AMOUNT (%i). Iter_Count: %i.", EQUIP_POINTS_MAX_AMOUNT, Iter_Count(EquipmentPointData));
		return INVALID_EQUIP_POINT_ID;
	}

    if(modelid == 0) modelid = EquipPoint_GetModelForFaction(factionid);
    EquipmentPointData[equipid][epPickup] = CreateDynamicPickup(modelid, 1, x, y, z, .worldid = vworld);
    EquipmentPointData[equipid][epButton] = Button_Create(equipid, x, y, z + 1, .size = r, .worldid = vworld, .streamDistance = 4.0, .labelText = "Casillero", .onPressCallbackAddress = EQUIP_USE_ADDR, .onEnterCallbackAddress = EQUIP_ON_ENTER_ADDR, .onExitCallbackAddress = EQUIP_ON_LEAVE_ADDR);
    EquipmentPointData[equipid][epFaction] = factionid;
    EquipmentPointData[equipid][epModelId] = modelid;
    EquipmentPointData[equipid][epX] = x;
    EquipmentPointData[equipid][epY] = y;
    EquipmentPointData[equipid][epZ] = z;
    EquipmentPointData[equipid][epR] = r;
    EquipmentPointData[equipid][epVWorld] = vworld;
    EquipmentPointData[equipid][epBldId] = bldid;
    
    Iter_Add(EquipmentPointData, equipid);
    return equipid;
}

stock EquipmentPoint_Destroy(equipid)
{
    if(!Iter_Contains(EquipmentPointData, equipid))
		return 0;

    if(EquipmentPointData[equipid][epButton] != INVALID_BUTTON_ID) {
		Button_Destroy(EquipmentPointData[equipid][epButton]);
	}
    
    if(EquipmentPointData[equipid][epPickup]) {
        DestroyDynamicPickup(EquipmentPointData[equipid][epPickup]);
    }

    EquipmentPointData[equipid] = EquipmentPointData[EQUIP_POINTS_MAX_AMOUNT];
	Iter_Remove(EquipmentPointData, equipid);
    return 1;
}

// DB layer
static EquipmentPoint_TableInitialized;

stock EquipmentPoint_DBEnsureSchema()
{
    if(EquipmentPoint_TableInitialized) return 1;
    mysql_tquery(MYSQL_HANDLE, "CREATE TABLE IF NOT EXISTS `equipment_points` (\
        `id` INT AUTO_INCREMENT PRIMARY KEY,\
        `bldId` INT NOT NULL,\
        `factionId` INT NOT NULL,\
        `x` FLOAT NOT NULL, `y` FLOAT NOT NULL, `z` FLOAT NOT NULL,\
        `radius` FLOAT NOT NULL,\
        `vworld` INT NOT NULL,\
        `modelId` INT NOT NULL\
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");
    EquipmentPoint_TableInitialized = 1;
    return 1;
}

forward EquipmentPoint_DBLoadAll();
public EquipmentPoint_DBLoadAll()
{
    new rows = cache_num_rows();
    if(!rows) return 1;

    new id, bldId, factionId, vworld, modelId;
    new Float:x, Float:y, Float:z, Float:r;

    for(new i; i < rows; i++)
    {
        cache_get_value_name_int(i, "id", id);
        cache_get_value_name_int(i, "bldId", bldId);
        cache_get_value_name_int(i, "factionId", factionId);
        cache_get_value_name_float(i, "x", x);
        cache_get_value_name_float(i, "y", y);
        cache_get_value_name_float(i, "z", z);
        cache_get_value_name_float(i, "radius", r);
        cache_get_value_name_int(i, "vworld", vworld);
        cache_get_value_name_int(i, "modelId", modelId);

        new equipid = EquipmentPoint_Create(x, y, z, r, vworld, factionId, modelId, bldId);
        EquipmentPointData[equipid][epId] = id;
    }
    printf("[EQUIP] Cargados %d puntos de equipamiento desde DB", rows);
    return 1;
}

stock EquipmentPoint_DBLoad()
{
    EquipmentPoint_DBEnsureSchema();
    mysql_tquery(MYSQL_HANDLE, "SELECT * FROM `equipment_points`", "EquipmentPoint_DBLoadAll");
    return 1;
}

stock EquipmentPoint_DBInsert(equipid)
{
    EquipmentPoint_DBEnsureSchema();
    new q[256];
    mysql_format(MYSQL_HANDLE, q, sizeof q,
        "INSERT INTO `equipment_points` (`bldId`,`factionId`,`x`,`y`,`z`,`radius`,`vworld`,`modelId`) VALUES (%d,%d,%f,%f,%f,%f,%d,%d)",
        EquipmentPointData[equipid][epBldId],
        EquipmentPointData[equipid][epFaction],
        EquipmentPointData[equipid][epX],
        EquipmentPointData[equipid][epY],
        EquipmentPointData[equipid][epZ],
        EquipmentPointData[equipid][epR],
        EquipmentPointData[equipid][epVWorld],
        EquipmentPointData[equipid][epModelId]
    );
    mysql_tquery(MYSQL_HANDLE, q, "EquipmentPoint_OnInserted");
    return 1;
}

forward EquipmentPoint_OnInserted();
public EquipmentPoint_OnInserted()
{
    new id = cache_insert_id();
    if(id > 0)
    {
        // Associate last created runtime slot with id
        // Note: In a real system, we'd track mapping; here we just log.
        printf("[EQUIP] Inserted equipment point id=%d", id);
    }
    return 1;
}

stock EquipmentPoint_DBDeleteById(dbid)
{
    EquipmentPoint_DBEnsureSchema();
    new q[96];
    mysql_format(MYSQL_HANDLE, q, sizeof q, "DELETE FROM `equipment_points` WHERE `id`=%d", dbid);
    mysql_tquery(MYSQL_HANDLE, q);
    return 1;
}

forward EquipmentPnt_OnUse(playerid, equipid);
public EquipmentPnt_OnUse(playerid, equipid)
{
	if(!Faction_IsValidId(PlayerInfo[playerid][pFaction]))
        return 1;
	if(!Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_EQUIPMENT))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene acceso a este comando.");
	if(!EquipmentPoint_CanPlayerUse(playerid, equipid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un casillero de tu faccion.");
	if(GetHandItem(playerid, HAND_RIGHT))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No debes tener nada en tu mano derecha.");

	new callbackaddr = Equipment_GetFactionCallback(PlayerInfo[playerid][pFaction]);

	if(callbackaddr == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene asociada una funcion de equipamiento. Contacta con un scripter.");
	
	CallFunction(callbackaddr, playerid);
	return 1;
}

forward EquipmentPnt_OnPlayerEnter(playerid, equipmentid);
public EquipmentPnt_OnPlayerEnter(playerid, equipmentid)
{
    if(EquipmentPointData[equipmentid][epFaction] && EquipmentPointData[equipmentid][epFaction] == PlayerInfo[playerid][pFaction])
    {
        Noti_Create(playerid, 2000, "Usa '/equipar' ó la tecla (H)");
        EquipmentPointPlayerData[playerid] = equipmentid;
    }
}

forward EquipmentPnt_OnPlayerLeave(playerid, equipmentid);
public EquipmentPnt_OnPlayerLeave(playerid, equipmentid)
{
	if(equipmentid == EquipmentPointPlayerData[playerid]) {
		EquipmentPointPlayerData[playerid] = INVALID_EQUIP_POINT_ID;
	}
}

stock EquipmentPoint_IsPlayerAt(playerid) {
    return (EquipmentPointPlayerData[playerid] != INVALID_EQUIP_POINT_ID);
}

stock EquipmentPoint_CanPlayerUse(playerid, equipmentid) {
    return (equipmentid != INVALID_EQUIP_POINT_ID && EquipmentPointData[equipmentid][epFaction] && EquipmentPointData[equipmentid][epFaction] == PlayerInfo[playerid][pFaction]);
}

stock EquipmentPoint_GetId(playerid) {
    return EquipmentPointPlayerData[playerid];
}

// Admin commands to manage equipment points
CMD:addequip(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    new factionid, bldid, modelid, Float:r;
    if(sscanf(params, "iiif", factionid, bldid, modelid, r))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/addequip [factionId] [bldId] [modelId|0=auto] [radius]");

    new Float:x, Float:y, Float:z, world = GetPlayerVirtualWorld(playerid);
    GetPlayerPos(playerid, x, y, z);

    if(!Faction_IsValidId(factionid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Facción inválida.");

    new equipid = EquipmentPoint_Create(x, y, z, r, world, factionid, modelid, bldid);
    if(equipid == INVALID_EQUIP_POINT_ID)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se pudo crear el punto.");

    EquipmentPoint_DBInsert(equipid);
    SendClientMessage(playerid, COLOR_INFO, "[INFO] Punto de equipamiento creado y guardado.");
    return 1;
}

CMD:delequip(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    new dbid;
    if(sscanf(params, "i", dbid))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/delequip [dbId]");

    EquipmentPoint_DBDeleteById(dbid);
    SendClientMessage(playerid, COLOR_INFO, "[INFO] Punto de equipamiento eliminado (DB). Recarga para reflejar cambios.");
    return 1;
}

// List and teleport to equipment points (from runtime loaded data)
CMD:listequip(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    new list[1024], line[96];
    foreach(new id : EquipmentPointData)
    {
        format(line, sizeof line, "#%d	Bld:%d	Fac:%d	VW:%d\n",
            EquipmentPointData[id][epId],
            EquipmentPointData[id][epBldId],
            EquipmentPointData[id][epFaction],
            EquipmentPointData[id][epVWorld]
        );
        strcat(list, line);
    }
    if(!strlen(list)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay puntos cargados.");
    Dialog_Open(playerid, "DLG_EQUIP_LIST", DIALOG_STYLE_TABLIST, "Puntos de equipamiento", list, "TP", "Cerrar");
    return 1;
}

Dialog:DLG_EQUIP_LIST(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;
    new targetDbId;
    if(sscanf(inputtext, "i", targetDbId)) return 1;
    foreach(new id : EquipmentPointData)
    {
        if(EquipmentPointData[id][epId] == targetDbId)
        {
            new Float:x = EquipmentPointData[id][epX];
            new Float:y = EquipmentPointData[id][epY];
            new Float:z = EquipmentPointData[id][epZ];
            TeleportPlayerTo(playerid, x, y, z, 0.0, 0, EquipmentPointData[id][epVWorld]);
            SendClientMessage(playerid, COLOR_INFO, "[INFO] Teletransportado al punto de equipamiento.");
            break;
        }
    }
    return 1;
}