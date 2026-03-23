#if defined _marp_equipment_data_included
	#endinput
#endif
#define _marp_equipment_data_included

// Categorías de costo de insumos según el tipo de item
enum e_EQUIPMENT_CATEGORY {
	EQUIP_CAT_BASIC,        // Items básicos (radios, cámaras, etc.) - 0.3x
	EQUIP_CAT_PROTECTIVE,   // Equipamiento de protección (chalecos, cascos, máscaras) - 0.4x
	EQUIP_CAT_WEAPON_SMALL, // Armas pequeñas (pistolas, tasers) - 0.5x
	EQUIP_CAT_WEAPON_MED,   // Armas medianas (escopetas, MPs) - 0.7x
	EQUIP_CAT_WEAPON_LARGE, // Armas grandes (rifles, francotiradores) - 1.0x
	EQUIP_CAT_AMMO_SMALL,   // Municiones pequeñas - 0.35x
	EQUIP_CAT_AMMO_LARGE,   // Municiones grandes - 0.5x
	EQUIP_CAT_SPECIAL,      // Items especiales (granadas, flashbangs) - 0.6x
	EQUIP_CAT_MEDICAL,      // Suministros médicos - 0.35x
	EQUIP_CAT_TOOLS         // Herramientas (mazas, sierras) - 0.4x
}

// Obtener categoría según el ID del item
stock Equipment_GetItemCategory(itemid) 
{
	// Items básicos
	if(itemid == ITEM_ID_RADIO || itemid == ITEM_ID_CAMARA || itemid == ITEM_ID_NITESTICK)
		return EQUIP_CAT_BASIC;
	
	// Equipamiento de protección
	if(itemid == ITEM_ID_CHALECO_1 || itemid == ITEM_ID_CHALECO_2 || itemid == ITEM_ID_CHALECO_3 || 
	   itemid == ITEM_ID_CHALECO_4 || itemid == ITEM_ID_CHALECO_REFRACTARIO ||
	   itemid == ITEM_ID_CASCO_SWAT1 || itemid == ITEM_ID_MASCARA_GAS ||
	   itemid == ITEM_ID_CASCO_BOMBERO1 || itemid == ITEM_ID_CASCO_BOMBERO2)
		return EQUIP_CAT_PROTECTIVE;
	
	// Armas pequeñas
	if(itemid == ITEM_ID_BERETTA_PX4_STORM || itemid == ITEM_ID_BALLESTER_MOLINA_45 || 
	   itemid == ITEM_ID_COLT45 || itemid == ITEM_ID_GLOCK_19 || itemid == ITEM_ID_TAURUS_PT_92 ||
	   itemid == ITEM_ID_BERSA_BP9 || itemid == ITEM_ID_REVOLVER_ROSSI_38 || itemid == ITEM_ID_BERSA_TPR_45 ||
	   itemid == ITEM_ID_REVOLVER_SW_60 || itemid == ITEM_ID_TASER)
		return EQUIP_CAT_WEAPON_SMALL;
	
	// Armas medianas
	if(itemid == ITEM_ID_DEAGLE || itemid == ITEM_ID_MOSSBERG_500 || itemid == ITEM_ID_ESCOPETA_NO_LETAL ||
	   itemid == ITEM_ID_SHOTGUN || itemid == ITEM_ID_MP5 || itemid == ITEM_ID_UZI || 
	   itemid == ITEM_ID_TAURUS_SMT9)
		return EQUIP_CAT_WEAPON_MED;
	
	// Armas grandes
	if(itemid == ITEM_ID_M4 || itemid == ITEM_ID_AK47 || itemid == ITEM_ID_RIFLE || itemid == ITEM_ID_SNIPER)
		return EQUIP_CAT_WEAPON_LARGE;
	
	// Municiones pequeñas
	if(itemid == ITEM_ID_COLT_MAGAZINE || itemid == ITEM_ID_TAZER_CHARGE || 
	   itemid == ITEM_ID_UZI_MAGAZINE || itemid == ITEM_ID_LESSLETHAL_SHELL)
		return EQUIP_CAT_AMMO_SMALL;
	
	// Municiones grandes
	if(itemid == ITEM_ID_DEAGLE_MAGAZINE || itemid == ITEM_ID_SHOTGUN_SHELLS || 
	   itemid == ITEM_ID_MP5_MAGAZINE || itemid == ITEM_ID_M4_MAGAZINE || 
	   itemid == ITEM_ID_AK47_MAGAZINE || itemid == ITEM_ID_RIFLE_BULLETS)
		return EQUIP_CAT_AMMO_LARGE;
	
	// Items especiales
	if(itemid == ITEM_ID_TEARGAS || itemid == ITEM_ID_FLASHBANG || itemid == ITEM_ID_GRENADE)
		return EQUIP_CAT_SPECIAL;
	
	// Suministros médicos
	if(itemid == ITEM_ID_MEDIC_CASE)
		return EQUIP_CAT_MEDICAL;
	
	// Herramientas
	if(itemid == ITEM_ID_SLEDGEHAMMER || itemid == ITEM_ID_CHAINSAW || itemid == ITEM_ID_FIREEXTINGUISHER)
		return EQUIP_CAT_TOOLS;
	
	// Por defecto, categoría básica
	return EQUIP_CAT_BASIC;
}

// Obtener multiplicador de costo según categoría
stock Float:Equipment_GetCategoryMultiplier(e_EQUIPMENT_CATEGORY:category)
{
	switch(category) {
		case EQUIP_CAT_BASIC: return 0.3;
		case EQUIP_CAT_PROTECTIVE: return 0.4;
		case EQUIP_CAT_WEAPON_SMALL: return 0.5;
		case EQUIP_CAT_WEAPON_MED: return 0.7;
		case EQUIP_CAT_WEAPON_LARGE: return 1.0;
		case EQUIP_CAT_AMMO_SMALL: return 0.35;
		case EQUIP_CAT_AMMO_LARGE: return 0.5;
		case EQUIP_CAT_SPECIAL: return 0.6;
		case EQUIP_CAT_MEDICAL: return 0.35;
		case EQUIP_CAT_TOOLS: return 0.4;
	}
	return 0.4; // Por defecto
}

// Calcular costo en insumos para un item
stock Equipment_CalculateInputCost(itemid)
{
	new e_EQUIPMENT_CATEGORY:category = e_EQUIPMENT_CATEGORY:Equipment_GetItemCategory(itemid);
	new Float:multiplier = Equipment_GetCategoryMultiplier(category);
	new cost = floatround(multiplier * ItemModel_GetPrice(itemid) / ItemModel_GetPrice(ITEM_ID_MATERIALES), floatround_ceil);
	
	// Mínimo 1 insumo
	if(cost < 1) cost = 1;
	
	return cost;
}

static Equipment_FactionCallbackAddr[MAX_FACTIONS] = {
    -1, ...
};

Equipment_SetFactionCallback(factionid, callback[])
{
    if(!isnull(callback) && strlen(callback) < MAX_FUNC_NAME) 
    {
        Equipment_FactionCallbackAddr[factionid] = GetPublicAddressFromName(callback);
        return 1;
	}
    return 0;
}

Equipment_GetFactionCallback(factionid) {
   return Equipment_FactionCallbackAddr[factionid];
}

static enum e_EQUIP_DATA
{
    equipItem,
    equipRank
}

static const Equipment_Police[][e_EQUIP_DATA] = {
    {
        /*equipItem*/ ITEM_ID_NITESTICK,
        /*equipRank*/ 10
    },
    {
        /*equipItem*/ ITEM_ID_RADIO,
        /*equipRank*/ 10
    },
    {
        /*equipItem*/ ITEM_ID_CAMARA,
        /*equipRank*/ 10
    },
    {
        /*equipItem*/ ITEM_ID_CHALECO_4,
        /*equipRank*/ 10
    },
    {
        /*equipItem*/ ITEM_ID_COLT_MAGAZINE,
        /*equipRank*/ 10
    },
    {
        /*equipItem*/ ITEM_ID_DEAGLE_MAGAZINE,
        /*equipRank*/ 10
    },
    {
        /*equipItem*/ ITEM_ID_TAZER_CHARGE,
        /*equipRank*/ 10
    },
    {
        /*equipItem*/ ITEM_ID_SHOTGUN_SHELLS,
        /*equipRank*/ 10
    },
    {
        /*equipItem*/ ITEM_ID_LESSLETHAL_SHELL,
        /*equipRank*/ 10
    },
    {
        /*equipItem*/ ITEM_ID_MP5_MAGAZINE,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_M4_MAGAZINE,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_RIFLE_BULLETS,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_TEARGAS,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_FLASHBANG,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_CASCO_SWAT1,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_MASCARA_GAS,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_BERETTA_PX4_STORM,
        /*equipRank*/ 5

    },
    {
        /*equipItem*/ ITEM_ID_BALLESTER_MOLINA_45,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_TASER,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_MOSSBERG_500,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_ESCOPETA_NO_LETAL,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_MP5,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_M4,
        /*equipRank*/ 5
    },
    {
        /*equipItem*/ ITEM_ID_SNIPER,
        /*equipRank*/ 5
    }
};

static const Equipment_Fire[][e_EQUIP_DATA] = {
    {
        /*equipItem*/ ITEM_ID_RADIO,
        /*equipRank*/ 9
    },
    {
        /*equipItem*/ ITEM_ID_MEDIC_CASE,
        /*equipRank*/ 9
    },
    {
        /*equipItem*/ ITEM_ID_MASCARA_GAS,
        /*equipRank*/ 9
    },
    {
        /*equipItem*/ ITEM_ID_CASCO_BOMBERO1,
        /*equipRank*/ 9
    },
    {
        /*equipItem*/ ITEM_ID_CASCO_BOMBERO2,
        /*equipRank*/ 9
    },
    {
        /*equipItem*/ ITEM_ID_CHALECO_REFRACTARIO,
        /*equipRank*/ 9
    },
    {
        /*equipItem*/ ITEM_ID_SLEDGEHAMMER,
        /*equipRank*/ 9
    },
    {
        /*equipItem*/ ITEM_ID_CHAINSAW,
        /*equipRank*/ 9
    },
    {
        /*equipItem*/ ITEM_ID_FIREEXTINGUISHER,
        /*equipRank*/ 9
    }
};

forward Equipment_PoliceShow(playerid);
public Equipment_PoliceShow(playerid)
{
    if(!isPlayerCopOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio para usar este comando.");
    
	new title[64] = "[Equipamiento policial]";
    new line[64], string[sizeof(Equipment_Police) * ITEM_MODEL_MAX_NAME_LEN] = "Código\tDescripción\tInsumos\n";
    new inputs, itemid;

    for(new i = 0; i < sizeof(Equipment_Police); i++) 
    {
        if(PlayerInfo[playerid][pRank] < Equipment_Police[i][equipRank])
        {
            itemid = Equipment_Police[i][equipItem];
            inputs = Equipment_CalculateInputCost(itemid);

            format(line, sizeof(line), "%i\t%s\t%i\n", itemid, ItemModel_GetName(itemid), inputs);
            strcat(string, line, sizeof(string));
        }
    }

    Dialog_Open(playerid, "DLG_EQUIPMENT", DIALOG_STYLE_TABLIST_HEADERS, title, string, "Seleccionar", "Cerrar");
    return 1;
}

forward Equipment_GNAShow(playerid);
public Equipment_GNAShow(playerid)
{
    if(!isPlayerSideOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio para usar este comando.");
    
	new title[64] = "[Equipamiento Gendarmería]";
    new line[64], string[sizeof(Equipment_Police) * ITEM_MODEL_MAX_NAME_LEN] = "Código\tDescripción\tInsumos\n";
    new inputs, itemid;

    for(new i = 0; i < sizeof(Equipment_Police); i++) 
    {
        if(PlayerInfo[playerid][pRank] < Equipment_Police[i][equipRank])
        {
            itemid = Equipment_Police[i][equipItem];
            inputs = Equipment_CalculateInputCost(itemid);

            format(line, sizeof(line), "%i\t%s\t%i\n", itemid, ItemModel_GetName(itemid), inputs);
            strcat(string, line, sizeof(string));
        }
    }

    Dialog_Open(playerid, "DLG_EQUIPMENT", DIALOG_STYLE_TABLIST_HEADERS, title, string, "Seleccionar", "Cerrar");
    return 1;
}
forward Equipment_FireShow(playerid);
public Equipment_FireShow(playerid)
{
    if(!IsMedicOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio para usar este comando.");
    
	new title[64] = "[Equipamiento médico y de bomberos]";
    new line[64], string[sizeof(Equipment_Fire) * ITEM_MODEL_MAX_NAME_LEN] = "Código\tDescripción\tInsumos\n";
    new inputs, itemid;

    for(new i = 0; i < sizeof(Equipment_Fire); i++) 
    {
        if(PlayerInfo[playerid][pRank] < Equipment_Fire[i][equipRank])
        {
            itemid = Equipment_Fire[i][equipItem];
            inputs = Equipment_CalculateInputCost(itemid);

            format(line, sizeof(line), "%i\t%s\t%i\n", itemid, ItemModel_GetName(itemid), inputs);
            strcat(string, line, sizeof(string));
        }
    }

    Dialog_Open(playerid, "DLG_EQUIPMENT", DIALOG_STYLE_TABLIST_HEADERS, title, string, "Seleccionar", "Cerrar");
    return 1;
}

Dialog:DLG_EQUIPMENT(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

    new itemid;

    if(sscanf(inputtext, "i", itemid) || !ItemModel_IsValidId(itemid))
		return 1;
    if(GetHandItem(playerid, HAND_RIGHT) != 0 )
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No debes tener nada en tu mano derecha.");
    
    new inputs = Equipment_CalculateInputCost(itemid);
    if(FactionInfo[PlayerInfo[playerid][pFaction]][fMaterials] < inputs)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay insumos suficientes en el depósito.");

    SetHandItemAndParam(playerid, HAND_RIGHT, itemid, ItemModel_GetParamDefaultValue(itemid));
    Equipment_OnPlayerTake(playerid, inputs, ItemModel_GetName(itemid));
    PlayerActionMessage(playerid, 15.0, "toma su equipamiento de los casilleros.");
    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has tomado %s. Se han descontado %d insumos del depósito.", ItemModel_GetName(itemid), inputs);
    return 1;
}
