#if defined _marp_back_inc
	#endinput
#endif
#define _marp_back_inc

enum
{
	CARRY_TYPE_NONE,
	CARRY_TYPE_BACK,
	CARRY_TYPE_CHEST,

	/* Lave last */
	CARRY_TYPE_AMOUNT
}

static const CARRY_TYPE_NAME[CARRY_TYPE_AMOUNT][8] = {
	"-",
	"espalda",
	"pecho"
};

enum e_BACK_INFO
{
	backCarryType,
	backItem,
	backAmount
}

new BackInfo[MAX_PLAYERS + 1][e_BACK_INFO] = {
	{
		/*backCarryType*/ CARRY_TYPE_NONE,
		/*backItem*/ ITEM_ID_NULL,
		/*backAmount*/ 0
	}, ...
};

stock Back_IsCarrying(playerid) {
	return (BackInfo[playerid][backCarryType]);
}

stock Back_ResetInfo(playerid) {
	BackInfo[playerid] = BackInfo[MAX_PLAYERS];
}

stock Back_GetItem(playerid) {
	return BackInfo[playerid][backItem];  
}

stock Back_GetParam(playerid) {
	return BackInfo[playerid][backAmount];  
}

stock Back_SetItemAndParam(playerid, carrytype, itemid, param)
{
	if(Back_GetItem(playerid) > ITEM_ID_NULL)
	{
		Back_DestroyContainer(playerid);
		Back_ResetInfo(playerid);

		Back_HideGraphicObject(playerid);
	}
	if(itemid > ITEM_ID_NULL)
	{
		BackInfo[playerid][backCarryType] = carrytype;
		BackInfo[playerid][backItem] = itemid;
		BackInfo[playerid][backAmount] = param;

		Back_ShowGraphicObject(playerid);
	}
}

stock Back_DestroyContainer(playerid) 
{
	if(ItemModel_GetType(BackInfo[playerid][backItem]) == ITEM_CONTAINER)
	{
	    Container_Destroy(BackInfo[playerid][backAmount]);
	}
	return 1;
}

stock Back_ShowGraphicObject(playerid)
{
	if(ItemModel_GetObjectModel(BackInfo[playerid][backItem]))
	{
		switch(BackInfo[playerid][backCarryType])
		{
			case CARRY_TYPE_BACK: 
			{
				switch(BackInfo[playerid][backItem])
				{
					case ITEM_ID_MOCHILAGRANDE:
						SetPlayerAttachedObject(playerid, ATTACH_INDEX_ID_BACK, ItemModel_GetObjectModel(BackInfo[playerid][backItem]), ATTACH_BONE_ID_SPINE, 0.000, 0.000, 0.000, 0.000, 86.999, 0.000);
					case ITEM_ID_MOCHILACHICA:
						SetPlayerAttachedObject(playerid, ATTACH_INDEX_ID_BACK, ItemModel_GetObjectModel(BackInfo[playerid][backItem]), ATTACH_BONE_ID_SPINE, -0.151, -0.063, -0.013, 0.000, 0.000, 0.000);
					case ITEM_ID_MOCHILAMEDIANA:
						SetPlayerAttachedObject(playerid, ATTACH_INDEX_ID_BACK, ItemModel_GetObjectModel(BackInfo[playerid][backItem]), ATTACH_BONE_ID_SPINE, 0.000, -0.127, -0.006, 0.000, 88.099, 0.000);
					default:
						SetPlayerAttachedObject(playerid, ATTACH_INDEX_ID_BACK, ItemModel_GetObjectModel(BackInfo[playerid][backItem]), ATTACH_BONE_ID_SPINE, 0.260, -0.121, -0.094, 2.30, 20.8, 180.0, 1.0, 1.0, 1.0);
				}
			}
			case CARRY_TYPE_CHEST: SetPlayerAttachedObject(playerid, ATTACH_INDEX_ID_BACK, ItemModel_GetObjectModel(BackInfo[playerid][backItem]), ATTACH_BONE_ID_SPINE, 0.067, 0.227, -0.176, 0.0, 47.8, 176.9, 1.0, 1.0, 1.0);
		}
	}
}

stock Back_HideGraphicObject(playerid) {
	RemovePlayerAttachedObject(playerid, ATTACH_INDEX_ID_BACK);
}

stock Back_ResetWeapon(playerid)
{
	if(BackInfo[playerid][backItem] > 0 && ItemModel_GetType(BackInfo[playerid][backItem]) == ITEM_WEAPON)
	{
		Back_HideGraphicObject(playerid);
		Back_ResetInfo(playerid);
	}
}

stock Back_SaveItemOn(playerid, playerhand, carrytype)
{
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(Item_IsHandlingCooldownOn(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes esperar un tiempo antes de volver a interactuar con otro item!");

	new itemid = GetHandItem(playerid, playerhand);

	if(Back_IsCarrying(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya tienes algo colgado en tu hombro.");
	if(itemid == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes nada en esa mano para guardar.");
	if(!ItemModel_HasTag(itemid, ITEM_TAG_BACK))
		return SendClientMessage(playerid, COLOR_YELLOW2, "Ese item no se puede colgar en el hombro.");
	
	new param_display[32];
	Backpack_FormatParamDisplay(itemid, GetHandParam(playerid, playerhand), param_display, sizeof(param_display));
	SendFMessage(playerid, COLOR_WHITE, "Has colgado [%s - %s: %s] en tu %s.", ItemModel_GetName(itemid), ItemModel_GetParamName(itemid), param_display, CARRY_TYPE_NAME[carrytype]);
	Back_SetItemAndParam(playerid, carrytype, itemid, GetHandParam(playerid, playerhand));
	SetHandItemAndParam(playerid, playerhand, 0, 0);
  	Item_ApplyHandlingCooldown(playerid);

	if(ItemModel_GetType(itemid) == ITEM_WEAPON) 
	{
		new entry[16]; 
		format(entry, sizeof(entry), "/%s", CARRY_TYPE_NAME[carrytype]);

		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry=entry, .playerid=playerid, .params=<"guardar %i %s", Back_GetParam(playerid), ItemModel_GetName(itemid)>);
	}

	return 1;
}

stock Back_TakeItemFrom(playerid, playerhand, carrytype)
{
	new itemid = Back_GetItem(playerid),
		itemparam = Back_GetParam(playerid),
		str[128];

	if(itemid <= 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes nada colgado en tu hombro.");
	if(carrytype != BackInfo[playerid][backCarryType]) 
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes ningun objeto colgado de tu %s", CARRY_TYPE_NAME[BackInfo[playerid][backCarryType]]);
		return 1;
	}
	if(GetHandItem(playerid, playerhand) != 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes tomar el item ya que tienes la mano ocupada.");

	format(str, sizeof(str), "Toma un/a %s de su %s.", ItemModel_GetName(itemid), CARRY_TYPE_NAME[BackInfo[playerid][backCarryType]]);
	PlayerCmeMessage(playerid, 15.0, 5000, str);

	Back_SetItemAndParam(playerid, 0, 0, 0);
	SetHandItemAndParam(playerid, playerhand, itemid, itemparam);

	if(ItemModel_GetType(itemid) == ITEM_WEAPON) 
	{
		new entry[16]; 
		format(entry, sizeof(entry), "/%s", CARRY_TYPE_NAME[carrytype]);

		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry=entry, .playerid=playerid, .params=<"tomar %i %s", itemparam, ItemModel_GetName(itemid)>);
	}
	
	return 1;
}

stock Back_PrintHandsForPlayer(playerid, targetid, carrytype = CARRY_TYPE_NONE)
{
	new itemid = Back_GetItem(playerid),
		slotname[8];

	if(carrytype)
	{
		Util_CapitalizeText(CARRY_TYPE_NAME[carrytype], slotname);
		SendFMessage(targetid, COLOR_WHITE, "_____________________[ EN %s ]_____________________", slotname);
	}
	else 
	{
		SendClientMessage(targetid, COLOR_WHITE, "_____________________[ EN ESPALDA O PECHO ]_____________________");
	}
	
	if(BackInfo[playerid][backCarryType] != carrytype && carrytype)
	{
		SendClientMessage(targetid, COLOR_WHITE, "Nada");
	} 
	else 
	{
		if(!itemid) {
			SendClientMessage(targetid, COLOR_WHITE, "Nada");
		} else {
			new param_display[32];
			Backpack_FormatParamDisplay(itemid, Back_GetParam(playerid), param_display, sizeof(param_display));
			SendFMessage(targetid, COLOR_WHITE, "%s - %s: %s", ItemModel_GetName(itemid), ItemModel_GetParamName(itemid), param_display);
		}
	}
}

CMD:espd(playerid, params[]) {
	return cmd_espalda(playerid, "d");
}

CMD:espi(playerid, params[]) {
	return cmd_espalda(playerid, "i");
}

CMD:esp(playerid, params[]) {
	return cmd_espalda(playerid, params);
}

CMD:espalda(playerid, params[])
{
	new cmd[32];

    if(sscanf(params, "s[32]", cmd))
	{
        SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/esp)alda [(d)erecha | (i)zquierda]");
		Back_PrintHandsForPlayer(playerid, playerid, CARRY_TYPE_BACK);
		return 1;
    }
    
	if(strcmp(cmd, "izquierda", true) == 0 || strcmp(cmd, "i", true) == 0)
	{
		if(Back_IsCarrying(playerid)) {
			Back_TakeItemFrom(playerid, HAND_LEFT, CARRY_TYPE_BACK);
		} else {
			Back_SaveItemOn(playerid, HAND_LEFT, CARRY_TYPE_BACK);
		}
    } else if(strcmp(cmd, "derecha", true) == 0 || strcmp(cmd, "d", true) == 0)
	{
		if(Back_IsCarrying(playerid)) {
			Back_TakeItemFrom(playerid, HAND_RIGHT, CARRY_TYPE_BACK);
		} else {
			Back_SaveItemOn(playerid, HAND_RIGHT, CARRY_TYPE_BACK);
		}
	}
	return 1;
}


CMD:pechod(playerid, params[]) {
	return cmd_pecho(playerid, "d");
}

CMD:pechoi(playerid, params[]) {
	return cmd_pecho(playerid, "i");
}

CMD:pecho(playerid, params[])
{
	new cmd[32];

    if(sscanf(params, "s[32]", cmd))
	{
        SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/pecho [(d)erecha | (i)zquierda]");
		Back_PrintHandsForPlayer(playerid, playerid, CARRY_TYPE_CHEST);
		return 1;
    }
    
	if(strcmp(cmd, "izquierda", true) == 0 || strcmp(cmd, "i", true) == 0)
	{
		if(Back_IsCarrying(playerid)) {
			Back_TakeItemFrom(playerid, HAND_LEFT, CARRY_TYPE_CHEST);
		} else {
			Back_SaveItemOn(playerid, HAND_LEFT, CARRY_TYPE_CHEST);
		}
    } else if(strcmp(cmd, "derecha", true) == 0 || strcmp(cmd, "d", true) == 0)
	{
		if(Back_IsCarrying(playerid)) {
			Back_TakeItemFrom(playerid, HAND_RIGHT, CARRY_TYPE_CHEST);
		} else {
			Back_SaveItemOn(playerid, HAND_RIGHT, CARRY_TYPE_CHEST);
		}
	}
	return 1;
}

