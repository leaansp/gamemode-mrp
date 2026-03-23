#if defined _marp_traffic_included
	#endinput
#endif
#define _marp_traffic_included

#include <YSI_Coding\y_hooks>

static const TRAFFIC_INIT_TIME = 800;
static const TRAFFIC_INIT_DELAY = 500;
static const TRAFFIC_AUTO_END = 3600;

static enum e_TRAFFIC_TYPE
{
    TRAFFIC_TYPE_NULL,
	TRAFFIC_TYPE_DRUGS,
	TRAFFIC_TYPE_WEAPONS,
	TRAFFIC_TYPE_MAGAZINES
}

static enum e_TRAFFIC_STAGE
{
    TRAFFIC_STAGE_NONE,
	TRAFFIC_STAGE_STARTED,
	TRAFFIC_STAGE_PAY,
    TRAFFIC_STAGE_END
}

static enum e_TRAFFIC_INFO
{
    e_TRAFFIC_TYPE:trafType,
	trafPosIndex,
	trafActor,
    trafItemid,
    trafAmount,
    e_TRAFFIC_STAGE:trafStage,
    trafEndTimer
}

static enum e_TRAFFIC_F_POS
{
    Float:traffX,
    Float:traffY,
    Float:traffZ,
    Float:traffAng,
    bool:traffUsed
}

static enum e_TRAFFIC_S_POS
{
    Float:trafsX,
    Float:trafsY,
    Float:trafsZ
}

static const Traffic_FirstPos[][e_TRAFFIC_F_POS] = {
    {2781.59, -2534.81, 13.63, 267.43, false},
    {-698.77, -2138.55, 25.74, 25.95, false},
    {2163.39, -103.20, 2.75, 30.82, false},
    {2350.56, -647.93, 128.05, 256.19, false},
    {-435.82, -60.15, 58.87, 176.13, false},
    {-418.78, -1759.43, 6.21, 219.83, false}
};

const TRAFFIC_POS_AMOUNT = sizeof(Traffic_FirstPos);
const INVALID_TRAFFIC_POS_ID = -1;

static const Traffic_SecondPos[TRAFFIC_POS_AMOUNT][e_TRAFFIC_S_POS] = {
    {2789.24, -2535.83, 13.62},
    {-706.87, -2138.78, 25.92},
    {2129.37, -86.59, 2.39},
    {2363.27, -650.50, 127.88},
    {-441.38, -64.75, 59.03},
    {-417.33, -1752.67, 6.63}
};

static const Traffic_Skins[] = {
    21, 29, 46, 123, 195, 261, 298, 299
};

static const TRAFFIC_RESET_ID = MAX_FACTIONS;

static Traffic_Delay[MAX_FACTIONS][e_TRAFFIC_TYPE];
static Traffic_Data[MAX_FACTIONS + 1][e_TRAFFIC_INFO] = {
    {
        /*e_TRAFFIC_TYPE:trafType*/ TRAFFIC_TYPE_NULL, 
        /*trafPosIndex*/ INVALID_TRAFFIC_POS_ID,
        /*trafActor*/ INVALID_ACTOR_ID,
        /*trafItemid*/ ITEM_ID_NULL,
        /*trafAmount*/ 0,
        /*e_TRAFFIC_STAGE:trafStage*/ TRAFFIC_STAGE_NONE,
        /*trafEndTimer*/ 0
    }, ... 
};

static const Traffic_DrugsIds[] = {
    ITEM_ID_PACK_COCAINA, 
    ITEM_ID_PACK_EXTASIS, 
    ITEM_ID_PACK_LSD, 
    ITEM_ID_WEED_SEEDS
};

static const Traffic_MagazinesIds[] = {
    ITEM_ID_BOX_COLT_MAG,
    ITEM_ID_BOX_DEAGLE_MAG,
    ITEM_ID_BOX_SHOTGUN_SHELL,
    ITEM_ID_BOX_UZI_MAG,
    ITEM_ID_BOX_MP5_MAG,
    ITEM_ID_BOX_AK47_MAG,
    ITEM_ID_BOX_M4_MAG,
    ITEM_ID_BOX_RIFLE_BULLETS
};

static const Traffic_WeaponsIds[] = { 
    ITEM_ID_BERSA_BP9,
    ITEM_ID_TAURUS_PT_92,
    ITEM_ID_GLOCK_19,
    ITEM_ID_COLT45,
    ITEM_ID_SILENCED,
    ITEM_ID_REVOLVER_ROSSI_38,
    ITEM_ID_REVOLVER_SW_60,
    ITEM_ID_BERSA_TPR_45,
    ITEM_ID_DEAGLE,
    ITEM_ID_BATAAN_71,
    ITEM_ID_REMINGTON_870,
    ITEM_ID_SHOTGUN,
    ITEM_ID_SAWEDOFF,
    ITEM_ID_SAWEDOFF_TUMBERA,
    ITEM_ID_BERETTA_93R,
    ITEM_ID_UZI,
    ITEM_ID_STEYR_MPI_69,
    ITEM_ID_FMK_3,
    ITEM_ID_FAMAE_SAF,
    ITEM_ID_TAURUS_SMT9,
    ITEM_ID_HECKLER_KOCH_UMP9,
    ITEM_ID_MP5,
    ITEM_ID_INGRAM_MAC10,
    ITEM_ID_SKORPION_VZ68,
    ITEM_ID_TEC9,
    ITEM_ID_AK47,
    ITEM_ID_M4,
    ITEM_ID_RIFLE
};

static enum e_TRAFFIC_TYPE_DATA
{
    Float:typePerPlayer,
    Float:typePriceModifier,
    typeDelay,
    typeName[16]
}

static const Traffic_TypeData[e_TRAFFIC_TYPE][e_TRAFFIC_TYPE_DATA] = {
/*TRAFFIC_TYPE_NULL*/{
        /*Float:typePerPlayer*/ 0.0,
        /*Float:typePriceModifier*/ 0.0,
        /*typeDelay*/ 0,
        /*typeName[16]*/ ""
    },
/*TRAFFIC_TYPE_DRUGS*/{
        /*Float:typePerPlayer*/ 7.0,
        /*Float:typePriceModifier*/ 0.55,
        /*typeDelay*/ 60,
        /*typeName[16]*/ "drogas"
    },
/*TRAFFIC_TYPE_WEAPONS*/{
        /*Float:typePerPlayer*/ 0.25,
        /*Float:typePriceModifier*/ 1.3,
        /*typeDelay*/ 90,
        /*typeName[16]*/ "armas"
    },
/*TRAFFIC_TYPE_MAGAZINES*/{
        /*Float:typePerPlayer*/ 0.5,
        /*Float:typePriceModifier*/ 1.2,
        /*typeDelay*/ 60,
        /*typeName[16]*/ "cargadores"
    }
};

Traffic_GetFreePos()
{
    new freepos = INVALID_TRAFFIC_POS_ID;
    new randompos;

    for(new i = 0; i < TRAFFIC_POS_AMOUNT; i++)
    {
        randompos = random(TRAFFIC_POS_AMOUNT);
        if(!Traffic_FirstPos[randompos][traffUsed]) 
        {
            freepos = randompos;
            break;
        }
    }

    return freepos;
}

Traffic_ShowItems(playerid, e_TRAFFIC_TYPE:traffic_type)
{
    if(traffic_type == TRAFFIC_TYPE_NULL)
        return 1;
    
    new title[32] = "Trafico de ";
	new line[64], string[sizeof(Traffic_WeaponsIds) * ITEM_MODEL_MAX_NAME_LEN] = "C�digo\tObjeto\n";

    switch(traffic_type)
    {
        case TRAFFIC_TYPE_DRUGS: 
        {
            strcat(title, "drogas", sizeof(title));

            for(new i = 0; i < sizeof(Traffic_DrugsIds); i++)
            {
                format(line, sizeof(line), "%i\t%s\n", Traffic_DrugsIds[i], ItemModel_GetName(Traffic_DrugsIds[i]));
                strcat(string, line, sizeof(string));
            }
        }
        case TRAFFIC_TYPE_WEAPONS: 
        {
            strcat(title, "armas", sizeof(title));

            for(new i = 0; i < sizeof(Traffic_WeaponsIds); i++)
            {
                format(line, sizeof(line), "%i\t%s\n", Traffic_WeaponsIds[i], ItemModel_GetName(Traffic_WeaponsIds[i]));
                strcat(string, line, sizeof(string));
            }
        }
        case TRAFFIC_TYPE_MAGAZINES: 
        {
            strcat(title, "cargadores", sizeof(title));

            for(new i = 0; i < sizeof(Traffic_MagazinesIds); i++)
            {
                format(line, sizeof(line), "%i\t%s\n", Traffic_MagazinesIds[i], ItemModel_GetName(Traffic_MagazinesIds[i]));
                strcat(string, line, sizeof(string));
            }
        }
    }

    Traffic_Data[PlayerInfo[playerid][pFaction]][trafType] = traffic_type;
    Dialog_Open(playerid, "DLG_TRAFFIC_SELECT", DIALOG_STYLE_TABLIST_HEADERS, title, string, "Seleccionar", "Cerrar");

    return 1;
}

Dialog:DLG_TRAFFIC_SELECT(playerid, response, listitem, inputtext[])
{
    new factionid = PlayerInfo[playerid][pFaction];

	if(!response)
		return Traffic_Cancel(factionid, .onstart = true, .forced = false);

    new itemid;
    if(sscanf(inputtext, "i", itemid) || !ItemModel_IsValidId(itemid))
		return Traffic_Cancel(factionid, .onstart = true, .forced = false);

    new e_TRAFFIC_TYPE:traffictype = Traffic_Data[factionid][trafType];

    Traffic_Data[factionid][trafItemid] = itemid;
    Traffic_Data[factionid][trafAmount] = floatround(Traffic_TypeData[traffictype][typePerPlayer] * GetPlayerCount(), floatround_ceil);
    
    new line[64];
    format(line, sizeof(line), "Debe ser entre 1 y %i", Traffic_Data[factionid][trafAmount]);
    Dialog_Open(playerid, "DLG_TRAFFIC_AMOUNT", DIALOG_STYLE_INPUT, "Ingresa una cantidad:", line, "Ingresar", "Salir");

    return 1;
}

Dialog:DLG_TRAFFIC_AMOUNT(playerid, response, listitem, inputtext[])
{
    new factionid = PlayerInfo[playerid][pFaction];

    if(!response)
		return Traffic_Cancel(factionid, .onstart = true, .forced = false);

    new amount;
    if(sscanf(inputtext, "i", amount) || (amount < 1 || amount > Traffic_Data[factionid][trafAmount]))
    {
        new line[64];
        format(line, sizeof(line), "Debe ser entre 1 y %i", Traffic_Data[factionid][trafAmount]);
        Dialog_Open(playerid, "DLG_TRAFFIC_AMOUNT", DIALOG_STYLE_INPUT, "Ingresa una cantidad:", line, "Ingresar", "Salir");
        return 1;
    }

    Traffic_Data[factionid][trafAmount] = amount;

    new posindex = Traffic_GetFreePos();
    if(posindex == INVALID_TRAFFIC_POS_ID) {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se puede encontrar un lugar disponible para realizar un trafico.");
        return Traffic_Cancel(factionid, .onstart = true, .forced = false);
    }

    new str[128];
    format(str, sizeof(str), "[Al tel�fono] %s dice: Necesito un cargamento de %s, hoy.", GetPlayerChatName(playerid), ItemModel_GetName(Traffic_Data[factionid][trafItemid]));
    SendPlayerMessageInRange(15.0, playerid, str, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
    SendClientMessage(playerid, COLOR_YELLOW2, "[Voz al tel�fono] dice: Dame un rato, te aviso el lugar.");

    if(!Traffic_Create(PlayerInfo[playerid][pFaction], posindex)) {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ocurrio un error inesperado al crear el trafico.");
        return Traffic_Cancel(PlayerInfo[playerid][pFaction], .onstart = true, .forced = false);
    }
    
    return 1;
}

Traffic_Create(factionid, posindex)
{
    new e_TRAFFIC_TYPE:traffictype = Traffic_Data[factionid][trafType];

    if(traffictype == TRAFFIC_TYPE_NULL)
        return 0;

    Traffic_FirstPos[posindex][traffUsed] = true;
    Traffic_Data[factionid][trafPosIndex] = posindex;

    new traffic_interval = TRAFFIC_INIT_TIME + random(TRAFFIC_INIT_DELAY);
    SetTimerEx("Traffic_Start", traffic_interval*1000, false, "ii", factionid, posindex);

    new str[128];
    if(random(100 + 1) > 75) 
    {
        new trafficlocation[MAX_ZONE_NAME];

        GetCoords2DZone(Traffic_FirstPos[posindex][traffX], Traffic_FirstPos[posindex][traffY], trafficlocation, MAX_ZONE_NAME);
        format(str, sizeof(str), "[911] Se recibi� una denuncia an�nima sobre actividad sospechosa en la zona %s.", trafficlocation);
        SendFactionRadioMessage(FAC_PMA, COLOR_CENTRALRED, str);
        SendFactionRadioMessage(FAC_SIDE, COLOR_CENTRALRED, str);
    }

    format(str, sizeof(str), "[TRAFICO] "COLOR_EMB_GREY" La faccion %s inicio un trafico de %s.", FactionInfo[factionid][fName], Traffic_TypeData[traffictype][typeName]);
	AdministratorMessage(COLOR_ALERT, str, 2);
    return 1;
}

forward Traffic_Start(factionid, posindex);
public Traffic_Start(factionid, posindex)
{
    if(Traffic_Data[factionid][trafType] == TRAFFIC_TYPE_NULL)
        return 0;

    new traffic_location[MAX_ZONE_NAME], faction_str[128];
    GetCoords2DZone(Traffic_FirstPos[posindex][traffX], Traffic_FirstPos[posindex][traffY], traffic_location, MAX_ZONE_NAME);

    format(faction_str, sizeof(faction_str), "[Mensaje de texto] Nos vemos en %s ((Checkpoint)). Trae $%d", traffic_location, Traffic_GetPrice(factionid));
    foreach(new id : Player)
	{
        if(PlayerInfo[id][pFaction] == factionid && PlayerInfo[id][pRank] < 2) 
        {
            SetPlayerCheckpoint(id, Traffic_FirstPos[posindex][traffX], Traffic_FirstPos[posindex][traffY], Traffic_FirstPos[posindex][traffZ], 3.5);
            SendClientMessage(id, COLOR_YELLOW2,  faction_str);
        }
	}

    new skin = Traffic_Skins[random(sizeof(Traffic_Skins))];

    Traffic_Data[factionid][trafActor] = CreateActor(skin, Traffic_FirstPos[posindex][traffX], Traffic_FirstPos[posindex][traffY], Traffic_FirstPos[posindex][traffZ], Traffic_FirstPos[posindex][traffAng]);
    ApplyActorAnimation(Traffic_Data[factionid][trafActor], "DEALER", "DEALER_IDLE", 4.1, 1, 1, 1, 1, 0);

    Traffic_Data[factionid][trafStage] = TRAFFIC_STAGE_STARTED;
    Traffic_Data[factionid][trafEndTimer] = SetTimerEx("Traffic_Cancel", TRAFFIC_AUTO_END*1000, false, "ibb", factionid, false, true);
    return 1;
}

forward Traffic_Cancel(factionid, bool:onstart, bool:forced);
public Traffic_Cancel(factionid, bool:onstart, bool:forced)
{
    new e_TRAFFIC_TYPE:traffictype = Traffic_Data[factionid][trafType];

    if(!onstart) {
        Traffic_Delay[factionid][traffictype] = gettime() + Traffic_TypeData[traffictype][typeDelay] * 3600;
    }

    if(forced) 
    {
        foreach(new id : Player) 
        {
            if(PlayerInfo[id][pFaction] == factionid && PlayerInfo[id][pRank] < 2) {
                SendClientMessage(id, COLOR_YELLOW2, "[Mensaje de texto] Tardaste demasiado, me voy a la mierda.");
            }
        }
    }

    if(Traffic_Data[factionid][trafPosIndex] != INVALID_TRAFFIC_POS_ID)
        Traffic_FirstPos[Traffic_Data[factionid][trafPosIndex]][traffUsed] = false;

    if(Traffic_Data[factionid][trafActor] != INVALID_ACTOR_ID) 
    {
        DestroyActor(Traffic_Data[factionid][trafActor]);
        Traffic_Data[factionid][trafActor] = INVALID_ACTOR_ID;
    }

    if(Traffic_Data[factionid][trafEndTimer]) 
    {
        KillTimer(Traffic_Data[factionid][trafEndTimer]);
        Traffic_Data[factionid][trafEndTimer] = 0;
    }

    Traffic_Data[factionid] = Traffic_Data[TRAFFIC_RESET_ID];
    return 1;
}

Traffic_GetPrice(factionid) {
    return floatround(Traffic_TypeData[Traffic_Data[factionid][trafType]][typePriceModifier]*ItemModel_GetPrice(Traffic_Data[factionid][trafItemid])*Traffic_Data[factionid][trafAmount], floatround_round);
}

static bool:Traffic_EnterAnyCP[MAX_FACTIONS];

hook OnPlayerEnterCheckpoint(playerid)
{
    new factionid = PlayerInfo[playerid][pFaction];
    if(Traffic_Data[factionid][trafType] == TRAFFIC_TYPE_NULL || PlayerInfo[playerid][pRank] > 2)
        return 1;

    switch(Traffic_Data[factionid][trafStage])
    {
        case TRAFFIC_STAGE_STARTED: {
            if(!Traffic_EnterAnyCP[factionid])
            {
                PlayerDoMessage(playerid, 15.0, "NPC:  �Vamos a hacer negocios o qu�?  �Trajiste la plata?");
                Traffic_EnterAnyCP[factionid] = true;
            }
            SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Utiliza '/pagartrafico' para pagar.");
        }
        case TRAFFIC_STAGE_PAY: {
            if(!IsPlayerInAnyVehicle(playerid) || Veh_GetTrunkSpace(GetPlayerVehicleID(playerid)) == 0 || !Traffic_CheckTrunkSpace(factionid, GetPlayerVehicleID(playerid))) 
            {
                SetTimerEx("Traffic_RestartCheckPoint", 1005, false, "i", playerid);
                SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Debes estar en un veh�culo y que este tenga maletero con el espacio suficiente disponible.");
                return 1;
            }
            else 
            {
                PlayerDoMessage(playerid, 15.0, "NPC: Ah� est� todo, cargalo y tomatelas r�pido de ac�.");
                KillTimer(Traffic_Data[factionid][trafEndTimer]);
                Traffic_Data[factionid][trafStage] = TRAFFIC_STAGE_END;
                GameTextForPlayer(playerid, "Cargando los objetos en el maletero.", 30000, 3);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("Traffic_SaveItem", 30*1000, false, "ii", playerid, GetPlayerVehicleID(playerid));
            }
        }
    }

    return 1;
}

Traffic_CheckTrunkSpace(factionid, vehid) 
{
    new space = 1000000;

    switch(e_TRAFFIC_STAGE: Traffic_Data[factionid][trafType])
    {
        case TRAFFIC_TYPE_DRUGS: space = ItemModel_GetSpaceSize(Traffic_Data[factionid][trafItemid]);
        case TRAFFIC_TYPE_WEAPONS, TRAFFIC_TYPE_MAGAZINES: space = ItemModel_GetSpaceSize(Traffic_Data[factionid][trafItemid]) * Traffic_Data[factionid][trafAmount];
    }

    return (Container_GetFreeSpace(VehicleInfo[vehid][VehContainerID]) >= space);
}

forward Traffic_RestartCheckPoint(playerid);
public Traffic_RestartCheckPoint(playerid)
{
    new factionid = PlayerInfo[playerid][pFaction];
    new posindex = Traffic_Data[factionid][trafPosIndex];

    switch(e_TRAFFIC_STAGE:Traffic_Data[factionid][trafStage])
    {
        case TRAFFIC_STAGE_STARTED: SetPlayerCheckpoint(playerid, Traffic_FirstPos[posindex][traffX], Traffic_FirstPos[posindex][traffY], Traffic_FirstPos[posindex][traffZ], 3.5);
        case TRAFFIC_STAGE_PAY: SetPlayerCheckpoint(playerid, Traffic_SecondPos[posindex][trafsX], Traffic_SecondPos[posindex][trafsY], Traffic_SecondPos[posindex][trafsZ], 4.5);
    }

    return 1;
}

forward Traffic_SaveItem(playerid, vehicleid);
public Traffic_SaveItem(playerid, vehicleid)
{
    if(!Veh_IsValidId(vehicleid))
        return 0;
    
    new factionid = PlayerInfo[playerid][pFaction];

    switch(e_TRAFFIC_STAGE: Traffic_Data[factionid][trafType])
    {
        case TRAFFIC_TYPE_DRUGS: Container_AddItemAndParam(VehicleInfo[vehicleid][VehContainerID], Traffic_Data[factionid][trafItemid], Traffic_Data[factionid][trafAmount]);
        case TRAFFIC_TYPE_WEAPONS, TRAFFIC_TYPE_MAGAZINES: {

            for (new i = 0; i < Traffic_Data[factionid][trafAmount]; i++) {
                Container_AddItemAndParam(VehicleInfo[vehicleid][VehContainerID], Traffic_Data[factionid][trafItemid], ItemModel_GetParamDefaultValue(Traffic_Data[factionid][trafItemid]));
            }
        }
    }

    TogglePlayerControllable(playerid, true);
    Traffic_Cancel(factionid, .onstart = false, .forced = false);
    return 1;
}

hook LoadAccountDataEnded(playerid)
{
    new factionid = PlayerInfo[playerid][pFaction];
    new posindex = Traffic_Data[factionid][trafPosIndex];

    if(Traffic_Data[factionid][trafType] == TRAFFIC_TYPE_NULL || PlayerInfo[playerid][pRank] > 2)
        return 1;
    
    switch(Traffic_Data[factionid][trafStage])
    {
        case TRAFFIC_STAGE_STARTED: {
            SetPlayerCheckpoint(playerid, Traffic_FirstPos[posindex][traffX], Traffic_FirstPos[posindex][traffY], Traffic_FirstPos[posindex][traffZ], 3.5);
            SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu faccion se encuentra en un trafico de drogas, se te marcara el punto en el mapa. Debes llevar $%d.", Traffic_GetPrice(factionid));
        }
        case TRAFFIC_STAGE_PAY: {
            SetPlayerCheckpoint(playerid, Traffic_SecondPos[posindex][trafsX], Traffic_SecondPos[posindex][trafsY], Traffic_SecondPos[posindex][trafsZ], 4.5);
            SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu faccion se encuentra en un trafico de drogas. Debes colocar un veh�culo en el punto marcado en el mapa.");
        }
    }
    return 1;
}

CMD:traficar(playerid, params[])
{
    new factionid = PlayerInfo[playerid][pFaction], typestr[16];

    if(!Faction_IsValidId(factionid))
        return 1;
    if(PlayerInfo[playerid][pRank] > 2)
        return 1;
    if(Traffic_Data[factionid][trafType] != TRAFFIC_TYPE_NULL)
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, " �Tu faccion ya se encuentra en un trafico!");
    if(GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_TELEFONO_CELULAR && GetHandItem(playerid, HAND_LEFT) != ITEM_ID_TELEFONO_CELULAR)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �No tienes un tel�fono celular en tu mano!");
    
    if(sscanf(params, "s[16]", typestr))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/traficar [droga-armas-cargadores]");

    new e_TRAFFIC_TYPE:traffictype;

    if(!strcmp(typestr, "droga", true)) {
        if(!Faction_HasTag(factionid, FAC_TAG_DRUG_TRAFFIC))
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene acceso a este comando.");
        if(Traffic_Delay[factionid][TRAFFIC_TYPE_DRUGS] > gettime())
            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar 60 horas antes de poder usar de nuevo este comando.");

        traffictype = TRAFFIC_TYPE_DRUGS;
    }
    else if(!strcmp(typestr, "armas", true)) {
        if(!Faction_HasTag(factionid, FAC_TAG_WEAPON_TRAFFIC))
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene acceso a este comando.");
        if(Traffic_Delay[factionid][TRAFFIC_TYPE_WEAPONS] > gettime())
            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar 60 horas antes de poder usar de nuevo este comando.");
        
        traffictype = TRAFFIC_TYPE_WEAPONS;
    }
    else if(!strcmp(typestr, "cargadores", true)) {
        if(!Faction_HasTag(factionid, FAC_TAG_WEAPON_TRAFFIC))
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene acceso a este comando.");
        if(Traffic_Delay[factionid][TRAFFIC_TYPE_MAGAZINES] > gettime())
            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar 120 horas antes de poder usar de nuevo este comando.");

        traffictype = TRAFFIC_TYPE_MAGAZINES;
    }
    else {
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/traficar [droga-armas-cargadores]");
    }

    Traffic_ShowItems(playerid, traffictype);
    return 1;
}

CMD:pagartrafico(playerid, params[])
{
    new factionid = PlayerInfo[playerid][pFaction];
    if(Traffic_Data[factionid][trafType] == TRAFFIC_TYPE_NULL)
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, " �No estas traficando!");
    if(Traffic_Data[factionid][trafStage] != TRAFFIC_STAGE_STARTED)
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, " �No estas en la etapa de pago!");
    
    new playermoney = GetPlayerCash(playerid);
    new price = Traffic_GetPrice(factionid);

    if(playermoney < price) 
    {
        SetTimerEx("Traffic_RestartCheckPoint", 1005, false, "i", playerid);
        new str[64];
        format(str, sizeof(str), "NPC: Te falta plata, tenes que traer $%d.", price);
        PlayerDoMessage(playerid, 15.0, str);
        return 1;
    } 
    else 
    {
        PlayerDoMessage(playerid, 15.0, "NPC: Perfecto, pone el auto por ah� que cargamos las cosas.");
        GivePlayerCash(playerid, - price);
        Traffic_Data[factionid][trafStage] = TRAFFIC_STAGE_PAY;

        new posindex = Traffic_Data[factionid][trafPosIndex];

        foreach(new id : Player)
        {
            if(PlayerInfo[id][pFaction] == factionid && PlayerInfo[id][pRank] < 2) {
                SetPlayerCheckpoint(playerid, Traffic_SecondPos[posindex][trafsX], Traffic_SecondPos[posindex][trafsY], Traffic_SecondPos[posindex][trafsZ], 4.5);
            }
        }

        ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="PAGO TRAFICO", .playerid=playerid, .params=<"$%d", price>);
    }
    return 1;
}

CMD:atrafficdebug(playerid, params[])
{
    new factionid;

    if(sscanf(params, "i", factionid))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/atrafficdebug [id de faccion]");
    if(!Faction_IsValidId(factionid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de facci�n incorrecta.");
    
    new string[512], e_TRAFFIC_TYPE:traffictype = Traffic_Data[factionid][trafType];

    format(string, sizeof(string),"\n\
		- Tipo de trafico: %s\n\
		- Item: %s\n\
		- Cantidad: %i\n",
		Traffic_TypeData[traffictype][typeName],
		ItemModel_GetName(Traffic_Data[factionid][trafItemid]),
        Traffic_Data[factionid][trafAmount]
	);

	Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "[Debug trafico]", string, "Cerrar", "");
    return 1;
}
