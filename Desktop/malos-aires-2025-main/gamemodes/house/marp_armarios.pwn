#if defined _marp_armarios_included
	#endinput
#endif
#define _marp_armarios_included

new LockerStatus[MAX_HOUSES];

Locker_SaveItem(houseid, playerid, hand)
{
	new itemid = GetHandItem(playerid, hand);

	if(!ItemModel_IsValidId(itemid))
		return 0;
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(!LockerStatus[houseid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El armario se encuentra cerrado con llave.");
	if(!ItemModel_HasTag(itemid, ITEM_TAG_SAVE))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo con este ítem.");
	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debes esperar un tiempo antes de volver a interactuar con otro item!");

	new itemparam = GetHandParam(playerid, hand);

	if(!Container_AddItemAndParam(House[houseid][ContainerID], itemid, GetHandParam(playerid, hand)))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay suficiente espacio libre en el armario / El ítem es demasiado chico para guardarse en un armario.");

	new str[128];
	format(str, sizeof(str), "Guarda un/a %s en el armario.", ItemModel_GetName(itemid));
	PlayerCmeMessage(playerid, 15.0, 5000, str);
	SetHandItemAndParam(playerid, hand, 0, 0);
	Item_ApplyHandlingCooldown(playerid);

	if(ItemModel_HasTag(itemid, ITEM_TAG_BOTH_HANDS)) {
		ApplyAnimationEx(playerid, "carry", "putdwn105", 20.0, 0, 0, 0, 0, 0, 1);
	}

	ServerFormattedLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/armario", .playerid=playerid, .params=<"guardar %d %s", itemparam, ItemModel_GetName(itemid)>);
	return 1;
}

CMD:armario(playerid, params[]) {
	return cmd_arm(playerid, params);
}

CMD:arm(playerid, params[])
{
	new houseid = House_IsPlayerInAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en una casa.");
	
	if(!strcmp(params, "usar", true))
	{
		if(!KeyChain_Contains(playerid, KEY_TYPE_HOUSE, houseid) && !AdminDuty[playerid])
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este armario.");
		if(Item_IsHandlingCooldownOn(playerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar un tiempo antes de volver a interactuar con el vehículo!");

		LockerStatus[houseid] = !LockerStatus[houseid];
		new string[128];
		format(string, sizeof(string), "Toma unas llaves y %s las puertas del armario.", (LockerStatus[houseid] ? ("abre") : ("cierra")));
		PlayerCmeMessage(playerid, 15.0, 5000, string);

		Item_ApplyHandlingCooldown(playerid);

		ServerFormattedLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/armario", .playerid=playerid, .params=<"(%s)", (LockerStatus[houseid]) ? ("abre") : ("cierra")>);
	}
	else if(!strcmp(params, "guardar", true)) {
		Locker_SaveItem(houseid, playerid, HAND_RIGHT);

	}
	else if(!strcmp(params, "guardari", true)) {
		Locker_SaveItem(houseid, playerid, HAND_LEFT);
	}
	else
	{
        SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/arm)ario [comando]. "COLOR_EMB_USAGE" [COMANDOS] "COLOR_EMB_GREY" usar (p/abrir o cerrar) - guardar/guardari");

		if(LockerStatus[houseid] == 0)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El armario se encuentra cerrado con llave.");
		if(!Container_Show(houseid, CONTAINER_TYPE_HOUSE, House[houseid][ContainerID], playerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error al mostrar el contenedor del armario. Reportar a un administador.");
	}

	return 1;
}

Dialog:Dlg_Show_House_Container(playerid, response, listitem, inputtext[])
{
	new houseid = Container_Selection[playerid][csOriginalId],
 		container_id = Container_Selection[playerid][csId];

	ResetContainerSelection(playerid);
	
   	if(response)
	{
        new itemid,
            itemparam,
			free_hand = SearchFreeHand(playerid);

		if(houseid != House_IsPlayerInAny(playerid))
    		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en la casa.");
		if(LockerStatus[houseid] == 0)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El armario se encuentra cerrado con llave.");
		if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
	  		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
		if(free_hand == -1)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes agarrar el item ya que tienes ambas manos ocupadas.");

		if(Container_TakeItem(container_id, listitem, itemid, itemparam))
		{
			SetHandItemAndParam(playerid, free_hand, itemid, itemparam); // Creación lógica y grafica en la mano.
            Item_ApplyHandlingCooldown(playerid);
            new str[128];
			format(str, sizeof(str), "Toma un/a %s del armario.", ItemModel_GetName(itemid));
			PlayerCmeMessage(playerid, 15.0, 5000, str);
			ServerFormattedLog(LOG_TYPE_ID_HOUSES, .id=houseid, .entry="/armario", .playerid=playerid, .params=<"tomar %d %s", itemparam, ItemModel_GetName(itemid)>);

			if(ItemModel_HasTag(itemid, ITEM_TAG_BOTH_HANDS)) {
				ApplyAnimationEx(playerid, "carry", "liftup105", 20.0, 0, 0, 0, 0, 0, 1);
			}

		} else {
	        SendClientMessage(playerid, COLOR_YELLOW2, "Armario vacio o el slot es inválido.");
		}
	}
	return 1;
}
