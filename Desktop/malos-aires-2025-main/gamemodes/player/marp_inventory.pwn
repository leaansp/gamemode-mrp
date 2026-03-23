#if defined _marp_inventory_included
	#endinput
#endif
#define _marp_inventory_included

#define CONTAINER_INV_SPACE   	25

PrintInvForPlayer(playerid, targetid) {
	if(!Container_Show(playerid, CONTAINER_TYPE_INV, PlayerInfo[playerid][pContainerID], targetid, 0))
		SendClientMessage(targetid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error al mostrar el contenedor del inventario. Reportar a un scripter.");
	return true;
}

static const KEY_CUSTOM_INV_SAVE   = KEY_SPRINT | KEY_YES; // Correr + Y -> guardar mano derecha
static const KEY_CUSTOM_MC         = KEY_WALK   | KEY_YES; // Alt + Y   -> intercambiar manos
static const KEY_CUSTOM_QUICK_DROP = KEY_SPRINT | KEY_NO;  // Correr + N -> tirar mano derecha
static const KEY_CUSTOM_INV_SAVE_I = KEY_WALK   | KEY_NO;  // Alt + N   -> guardar mano izquierda

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(KEY_PRESSED_MULTI(KEY_CUSTOM_INV_SAVE))
	{
		Inv_SaveItem(playerid, GetHandItem(playerid, HAND_RIGHT), HAND_RIGHT);
		return ~1;
	}

	if(KEY_PRESSED_MULTI(KEY_CUSTOM_MC))
	{
		cmd_mano(playerid, "cambiar");
		return ~1;
	}

	if(KEY_PRESSED_SINGLE(KEY_YES))
	{
		Container_Show(playerid, CONTAINER_TYPE_INV, PlayerInfo[playerid][pContainerID], playerid);
		return ~1;
	}

	// --- Combos con N ---
	if(KEY_PRESSED_MULTI(KEY_CUSTOM_QUICK_DROP))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			QuickDropObject(playerid, HAND_RIGHT, true);
		return ~1;
	}

	if(KEY_PRESSED_MULTI(KEY_CUSTOM_INV_SAVE_I))
	{
		// Alt + N: solo funciona a pie (KEY_WALK no registra en vehiculo)
		Inv_SaveItem(playerid, GetHandItem(playerid, HAND_LEFT), HAND_LEFT);
		return ~1;
	}

	if(KEY_PRESSED_SINGLE(KEY_NO))
	{
		if(SearchHandsForItem(playerid, ITEM_ID_TELEFONO_CELULAR) != -1) return true;
		if(IsPlayerInAnyVehicle(playerid))
		{
			cmd_cinturon(playerid, "");
			return ~1;
		}
		if(GetClosestObject(playerid) != -1)
		{
			if(GetHandItem(playerid, HAND_RIGHT) == 0)
				TakeObject(playerid, HAND_RIGHT);
			else if(GetHandItem(playerid, HAND_LEFT) == 0)
				TakeObject(playerid, HAND_LEFT);
			else
				cmd_guardar(playerid);
		}
		else
			cmd_guardar(playerid);
		return ~1;
	}

	return true;
}

Inv_SaveItem(playerid, itemid, hand) {
	if(!ItemModel_IsValidId(itemid))
		return false;
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(!ItemModel_HasTag(itemid, ITEM_TAG_INV))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ese item no se puede guardar en el inventario.");
	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Debés esperar un tiempo antes de volver a interactuar con otro item!");

	if(!Container_AddItemAndParam(PlayerInfo[playerid][pContainerID], itemid, GetHandParam(playerid, hand)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay suficiente espacio libre en tu inventario.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has guardado [%s - %s: %i] en tu inventario.", ItemModel_GetName(itemid), ItemModel_GetParamName(itemid), GetHandParam(playerid, hand));	
	
	if(ItemModel_GetType(itemid) == ITEM_WEAPON) {
		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/inv", .playerid=playerid, .params=<"guardar %i %s", GetHandParam(playerid, hand), ItemModel_GetName(itemid)>);
	}
	
	SetHandItemAndParam(playerid, hand, 0, 0);
	Item_ApplyHandlingCooldown(playerid);
	return true;
}

CMD:bol(playerid, params[]) {
	return cmd_inventario(playerid, params);
}

CMD:inv(playerid, params[]) {
	return cmd_inventario(playerid, params);
}

CMD:bolsillos(playerid, params[]) {
	return cmd_inventario(playerid, params);
}

CMD:inventario(playerid, params[]) {
	return Container_Show(playerid, CONTAINER_TYPE_INV, PlayerInfo[playerid][pContainerID], playerid);
}

CMD:guardar(playerid) {
	Inv_SaveItem(playerid, GetHandItem(playerid, HAND_RIGHT), HAND_RIGHT);
	return true;
}

CMD:guardari(playerid) {
	Inv_SaveItem(playerid, GetHandItem(playerid, HAND_LEFT), HAND_LEFT);
	return true;
}

CMD:sacar(playerid, params[]) 
{
	new slot, free_hand = SearchFreeHand(playerid);

	if(sscanf(params, "i", slot))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/sacar [slot]");
	if(free_hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes agarrar el item ya que tienes ambas manos ocupadas.");

	new itemid, param;

	if(Container_TakeItem(PlayerInfo[playerid][pContainerID], slot, itemid, param))
	{
		SetHandItemAndParam(playerid, free_hand, itemid, param); // Creación lógica y grafica en la mano.
		Item_ApplyHandlingCooldown(playerid);
		new str[128];
		format(str, sizeof(str), "Toma un/a %s de su inventario.", ItemModel_GetName(itemid));
		PlayerCmeMessage(playerid, 15.0, 5000, str);

		if(ItemModel_GetType(itemid) == ITEM_WEAPON)
			ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/inv", .playerid=playerid, .params=<"sacar %i %s", param, ItemModel_GetName(itemid)>);
	}
	else
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Slot vacio.");
	}

	return true;
}

DestroyPlayerInventory(playerid)
{
	if (PlayerInfo[playerid][pContainerSQLID] > 0 && PlayerInfo[playerid][pContainerID] != 0)
	{
		Container_Destroy(PlayerInfo[playerid][pContainerID]);
	}
	return 1;
}

Dialog:Dlg_Show_Inv_Container(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	new container_id = Container_Selection[playerid][csId];

	ResetContainerSelection(playerid);

	new itemid,
		itemparam,
		free_hand = SearchFreeHand(playerid),
		slot = listitem;

	if(!response) return 1;

	if(free_hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes agarrar el item ya que tienes ambas manos ocupadas.");

	if(Container_TakeItem(container_id, slot, itemid, itemparam))
	{
		SetHandItemAndParam(playerid, free_hand, itemid, itemparam); // Creación lógica y grafica en la mano.
		Item_ApplyHandlingCooldown(playerid);
		new str[128];
		format(str, sizeof(str), "saca un/a %s.", ItemModel_GetName(itemid));
		PlayerCmeMessage(playerid, 15.0, 5000, str);

		if(ItemModel_GetType(itemid) == ITEM_WEAPON)
			ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="container_take", .playerid=playerid, .params=<"sacar %i %s", itemparam, ItemModel_GetName(itemid)>);
	}
	else
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Slot vacio.");
	}

	return true;
}