#if defined _marp_duty_belt_included
	#endinput
#endif
#define _marp_duty_belt_included

#define CONTAINER_BELT_SPACE   	32

stock PrintBeltForPlayer(playerid, targetid)
{
	if(!Container_Show(playerid, CONTAINER_TYPE_BELT, PlayerInfo[playerid][pBeltID], targetid, 0)) {
		SendClientMessage(targetid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error al mostrar el contenedor del cinturón. Reportar a un scripter.");
		return 0;
	}
	return 1;
}

Belt_SaveItem(playerid, itemid, hand)
{
	if(!ItemModel_IsValidId(itemid))
		return 0;
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(!ItemModel_HasTag(itemid, ITEM_TAG_INV))
		return SendClientMessage(playerid, COLOR_YELLOW2, "Ese item no se puede guardar en el cinturón.");
	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes esperar un tiempo antes de volver a interactuar con otro item!");

	if(!Container_AddItemAndParam(PlayerInfo[playerid][pBeltID], itemid, GetHandParam(playerid, hand)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay suficiente espacio libre en tu cinturón.");

	SendFMessage(playerid, COLOR_WHITE, "Has guardado [%s - %s: %i] en tu cinturón.", ItemModel_GetName(itemid), ItemModel_GetParamName(itemid), GetHandParam(playerid, hand));	
	
	if(ItemModel_GetType(itemid) == ITEM_WEAPON)
		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/pcint", .playerid=playerid, .params=<"guardar %i %s",  GetHandParam(playerid, hand), ItemModel_GetName(itemid)>);
	
	SetHandItemAndParam(playerid, hand, 0, 0);
	Item_ApplyHandlingCooldown(playerid);
	return 1;
}

CMD:pcint(playerid, params[]) {
	return cmd_pcinturon(playerid, params);
}

CMD:pcinturon(playerid, params[])
{
	new subcmd[24];

    if(!isPlayerCopOnDuty(playerid) && !isPlayerSideOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio como policía o gendarme.");

    if(sscanf(params, "s[24]", subcmd))
	{
        SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/pcint)uron [comando] (guardar - guardari)");

		if(!Container_Show(playerid, CONTAINER_TYPE_BELT, PlayerInfo[playerid][pBeltID], playerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error al mostrar el contenedor del cinturón. Reportar a un administador.");
    }
	else
	{
		if(strcmp(subcmd, "guardar", true) == 0) {
			Belt_SaveItem(playerid, GetHandItem(playerid, HAND_RIGHT), HAND_RIGHT);
	    }
		else if(strcmp(subcmd, "guardari", true) == 0) {
			Belt_SaveItem(playerid, GetHandItem(playerid, HAND_LEFT), HAND_LEFT);
	    }
		else {
		    SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/pcint)uron [comando] (guardar - guardari)");
		}
	}
	return 1;
}

DestroyPlayerDutyBelt(playerid)
{
	if(PlayerInfo[playerid][pBeltSQLID] > 0 && PlayerInfo[playerid][pBeltID] > 0)
	{
		Container_Destroy(PlayerInfo[playerid][pBeltID]);
	}
	return 1;
}

Dialog:Dlg_Show_Belt_Container(playerid, response, listitem, inputtext[])
{
	new container_id = Container_Selection[playerid][csId];

	ResetContainerSelection(playerid);

	if(response)
	{
        new itemid,
            itemparam,
            free_hand = SearchFreeHand(playerid);

		if(free_hand == -1)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes agarrar el item ya que tienes ambas manos ocupadas.");

		if(Container_TakeItem(container_id, listitem, itemid, itemparam))
		{
			SetHandItemAndParam(playerid, free_hand, itemid, itemparam); // Creación lógica y grafica en la mano.
            Item_ApplyHandlingCooldown(playerid);
            new str[128];
			format(str, sizeof(str), "Toma un/a %s de su cinturón.", ItemModel_GetName(itemid));
			PlayerCmeMessage(playerid, 15.0, 5000, str);

			if(ItemModel_GetType(itemid) == ITEM_WEAPON)
				ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/pcint", .playerid=playerid, .params=<"sacar %i %s", itemparam, ItemModel_GetName(itemid)>);
		}
		else
		{
	        SendClientMessage(playerid, COLOR_YELLOW2, "cinturón vacio o el slot es inválido.");
		}
	}
	return 1;
}
