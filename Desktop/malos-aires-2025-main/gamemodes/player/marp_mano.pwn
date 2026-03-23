#if defined _marp_mano_included
	#endinput
#endif
#define _marp_mano_included

//==============================MODELADO DE MANO================================

//================================CONSTANTES====================================

// #define HAND_LEFT             	0
// #define HAND_RIGHT              1

//============================VARIABLES INTERNAS================================

enum SlotInfo {
	Item,
	Amount,
};

new HandInfo[MAX_PLAYERS][2][SlotInfo];
static bool:isCarrying[MAX_PLAYERS];

//=======================IMPLEMENTACIN DE FUNCIONES============================

stock GetHandItem(playerid, hand)
{
	return HandInfo[playerid][hand][Item];
}

stock GetHandParam(playerid, hand)
{
	return HandInfo[playerid][hand][Amount];
}

stock SetHandItemAndParam(playerid, hand, itemid, param)
{
	if(GetHandItem(playerid, hand) > 0) // Si quiere sobreescribir el slot teniendo algo dentro
	{
		DeleteHandItem(playerid, hand);
		HandInfo[playerid][hand][Item] = 0;
		HandInfo[playerid][hand][Amount] = 0;
	}
	if(itemid > 0)
	{
		HandInfo[playerid][hand][Item] = itemid;
		HandInfo[playerid][hand][Amount] = param;
		LoadHandItem(playerid, hand);
	}
}

stock SetAnyHandItemAndParam(playerid, itemid, param)
{
	if(GetHandItem(playerid, HAND_RIGHT) == 0) {
		SetHandItemAndParam(playerid, HAND_RIGHT, itemid, param);
	} else if(GetHandItem(playerid, HAND_LEFT) == 0) {
		SetHandItemAndParam(playerid, HAND_LEFT, itemid, param);
	} else {
		return 0; // No se pudo entregar el arma por tener las manos ocupadas
	}
	return 1; // Se pudo entregar el arma
}

stock SearchHandsForItem(playerid, itemid)
{
	if(HandInfo[playerid][HAND_RIGHT][Item] == itemid)
	    return HAND_RIGHT;
	else if(HandInfo[playerid][HAND_LEFT][Item] == itemid)
	    return HAND_LEFT;
	else
	    return -1;
}

stock SearchFreeHand(playerid)
{
	if(!isCarrying[playerid])
	{
		if(HandInfo[playerid][HAND_RIGHT][Item] == 0)
			return HAND_RIGHT;
		else if(HandInfo[playerid][HAND_LEFT][Item] == 0)
			return HAND_LEFT;
		else
			return -1;
	}

	return -1;
}

Hand_HideAllGraphicObjects(playerid)
{
	if(ItemModel_GetObjectModel(HandInfo[playerid][HAND_RIGHT][Item])) {
		RemovePlayerAttachedObject(playerid, ATTACH_INDEX_ID_HAND_RIGHT);
	}

	if(ItemModel_GetObjectModel(HandInfo[playerid][HAND_LEFT][Item])) {
		RemovePlayerAttachedObject(playerid, ATTACH_INDEX_ID_HAND_LEFT);
	}
}

Hand_AttachAllGraphicObjects(playerid)
{
	if(ItemModel_GetObjectModel(HandInfo[playerid][HAND_RIGHT][Item])) {
		ItemModel_AttachOnHand(playerid, HandInfo[playerid][HAND_RIGHT][Item], HAND_RIGHT);
	}

	if(ItemModel_GetObjectModel(HandInfo[playerid][HAND_LEFT][Item])) {
		ItemModel_AttachOnHand(playerid, HandInfo[playerid][HAND_LEFT][Item], HAND_LEFT);
	}
}

stock ResetHands(playerid)
{
	HandInfo[playerid][HAND_LEFT][Item] = 0;
	HandInfo[playerid][HAND_LEFT][Amount] = 0;
	HandInfo[playerid][HAND_RIGHT][Item] = 0;
	HandInfo[playerid][HAND_RIGHT][Amount] = 0;
	isCarrying[playerid] = false;
	return 1;
}

stock PrintHandsForPlayer(playerid, targetid)
{
	new rightitem = GetHandItem(playerid, HAND_RIGHT), leftitem = GetHandItem(playerid, HAND_LEFT);

	SendClientMessage(targetid, COLOR_WHITE, "_____________________[ EN MANO ]_____________________");

	if(rightitem > 0) {
		new param_display[32];
		Backpack_FormatParamDisplay(rightitem, GetHandParam(playerid, HAND_RIGHT), param_display, sizeof(param_display));
		SendFMessage(targetid, COLOR_INFO, "[Derecha] "COLOR_EMB_WHITE" %s - %s: %s", ItemModel_GetName(rightitem), ItemModel_GetParamName(rightitem), param_display);
	} else {
		SendClientMessage(targetid, COLOR_INFO, "[Derecha] "COLOR_EMB_WHITE" Nada");
	}

	if(leftitem > 0) {
		new param_display[32];
		Backpack_FormatParamDisplay(leftitem, GetHandParam(playerid, HAND_LEFT), param_display, sizeof(param_display));
		SendFMessage(targetid, COLOR_INFO, "[Izquierda] "COLOR_EMB_WHITE" %s - %s: %s", ItemModel_GetName(leftitem), ItemModel_GetParamName(leftitem), param_display);
	} else {
		SendClientMessage(targetid, COLOR_INFO, "[Izquierda] "COLOR_EMB_WHITE" Nada");
	}

	SendClientMessage(targetid, COLOR_WHITE, "_____________________________________________________");
	return 1;
}

//=================BORRADO DE ARMAS AL MORIR SI NO ES COPDUTY===================

ResetHandsWeapons(playerid)
{
	if(HandInfo[playerid][HAND_LEFT][Item] > 0 && ItemModel_GetType(HandInfo[playerid][HAND_LEFT][Item]) == ITEM_WEAPON)
        SetHandItemAndParam(playerid, HAND_LEFT, 0, 0);
	if(HandInfo[playerid][HAND_RIGHT][Item] > 0 && ItemModel_GetType(HandInfo[playerid][HAND_RIGHT][Item]) == ITEM_WEAPON)
		SetHandItemAndParam(playerid, HAND_RIGHT, 0, 0);
	return 1;
}

//=======DESTRUCTOR DE LOS CONTENEDORES EN MEMORIA ASOCIADOS A LAS MANOS========

DestroyPlayerHands(playerid)
{
    if(ItemModel_GetType(HandInfo[playerid][HAND_RIGHT][Item]) == ITEM_CONTAINER)
	{
	    Container_Destroy(HandInfo[playerid][HAND_RIGHT][Amount]);
	}
    if(ItemModel_GetType(HandInfo[playerid][HAND_LEFT][Item]) == ITEM_CONTAINER)
	{
	    Container_Destroy(HandInfo[playerid][HAND_LEFT][Amount]);
	}
	return 1;
}

stock IsPlayerCarryingObject(playerid) {
	return isCarrying[playerid];
}

stock SetPlayerCarrying(playerid, bool:carrying) {
	isCarrying[playerid] = carrying;
}

//==================================COMANDOS====================================

GiveItemFromPlayerToPlayer(playerid, playerhand, targetid)
{
 	new itemid = GetHandItem(playerid, playerhand),
	 	str[128],
		targetfreehand;

	if(itemid == 0)
 		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes ningn item en esa mano.");
    if(targetid == playerid || !IsPlayerInRangeOfPlayer(2.0, playerid, targetid))
	    return SendClientMessage(playerid, COLOR_YELLOW2, "Jugador invlido o se encuentra muy lejos!");
	if(Item_IsHandlingCooldownOn(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar un tiempo antes de volver a interactuar con otro tem!");
	if(!ItemModel_HasTag(itemid, ITEM_TAG_GIVE))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo con este tem.");

	targetfreehand = SearchFreeHand(targetid);
	if(targetfreehand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto tiene ambas manos ocupadas y no puede agarrar nada ms.");

	SetHandItemAndParam(targetid, targetfreehand, itemid, GetHandParam(playerid, playerhand));
	SetHandItemAndParam(playerid, playerhand, 0, 0);
	format(str, sizeof(str), "Le entrega un/a %s a", ItemModel_GetName(itemid));
	PlayerPlayerCmeMessage(playerid, targetid, 15.0, 4000, str);
	Item_ApplyHandlingCooldown(playerid);

	if(ItemModel_GetType(itemid) == ITEM_WEAPON) {
		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/dar", .playerid=playerid, .targetid=targetid, .params=<"%i %s", GetHandParam(targetid, playerhand), ItemModel_GetName(itemid)>);
	} else if(itemid == ITEM_ID_DINERO) {
		ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="/dar", .playerid=playerid, .params=<"$%i", GetHandParam(targetid, playerhand)>);
	}
	return 1;
}

CMD:dar(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/dar [ID/Jugador]");

	GiveItemFromPlayerToPlayer(playerid, HAND_RIGHT, targetid);

	if(ItemModel_GetType(GetHandItem(playerid, HAND_RIGHT)) == ITEM_WEAPON) {
		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/dar", .playerid=playerid, .targetid=targetid, .params=<"%i %s", GetHandParam(targetid, HAND_RIGHT), ItemModel_GetName(GetHandItem(targetid, HAND_RIGHT))>);
	}
	return 1;
}

CMD:dari(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/dari [ID/Jugador]");
		
	if(ItemModel_GetType(GetHandItem(playerid, HAND_LEFT)) == ITEM_WEAPON) {
		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/dari", .playerid=playerid, .targetid=targetid, .params=<"%i %s", GetHandParam(targetid, HAND_RIGHT), ItemModel_GetName(GetHandItem(targetid, HAND_RIGHT))>);
	}
	GiveItemFromPlayerToPlayer(playerid, HAND_LEFT, targetid);
	return 1;
}

static const KEY_CUSTOM_HAND_USE = KEY_SPRINT | KEY_LOOK_BEHIND;
static const KEY_CUSTOM_HAND_USE_I = KEY_WALK | KEY_LOOK_BEHIND;

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{

    // PRIORIDAD: recarga
    if (KEY_PRESSED_SINGLE(KEY_WALK))
    {
        TryStartReload(playerid);
    }
	if(KEY_PRESSED_MULTI(KEY_CUSTOM_HAND_USE))
	{
		cmd_mano(playerid, "usar");
		return ~1;
	}

	if(KEY_PRESSED_MULTI(KEY_CUSTOM_HAND_USE_I))
	{
		cmd_mano(playerid, "usari");
		return ~1;
	}

	return 1;
}

CMD:mc(playerid, params[]) {
	return cmd_mano(playerid, "cambiar");
}

CMD:usar(playerid, params[]) {
	return cmd_mano(playerid, "usar");
}

CMD:usari(playerid, params[]) {
	return cmd_mano(playerid, "usari");
}

CMD:tirar(playerid, params[]) {
	return cmd_mano(playerid, "tirar");
}

CMD:tirari(playerid, params[]) {
	return cmd_mano(playerid, "tirari");
}

CMD:agarrar(playerid, params[]) {
	return cmd_mano(playerid, "agarrar");
}

CMD:agarrari(playerid, params[]) {
	return cmd_mano(playerid, "agarrari");
}

CMD:agarraruno(playerid, params[]) {
	return cmd_mano(playerid, "agarraruno");
}

CMD:agarrarunoi(playerid, params[]) {
	return cmd_mano(playerid, "agarrarunoi");
}

CMD:separar(playerid, params[]) {
	new amount;
	if(sscanf(params, "i", amount))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/separar [cantidad]");
	
	new itemid = GetHandItem(playerid, HAND_RIGHT), itemamount = GetHandParam(playerid, HAND_RIGHT), leftfree = GetHandItem(playerid, HAND_LEFT);
				
	if(!itemid || leftfree)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debés tener un objeto en la mano derecha y la mano izquierda vacia.");
	if(!ItemModel_HasTag(itemid, ITEM_TAG_SPLIT))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacer eso con estos items.");
	if(amount <= 0 || amount >= itemamount)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad debe ser mayor a 0 y menor a la cantidad del item.");
	SetHandItemAndParam(playerid, HAND_LEFT, itemid, amount);
	SetHandItemAndParam(playerid, HAND_RIGHT, itemid, itemamount - amount);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has separado %i %s de %s.", amount, ItemModel_GetParamName(itemid), ItemModel_GetName(itemid));
	return true;
}

CMD:combinar(playerid) {
	new rightitem = GetHandItem(playerid, HAND_RIGHT), rightparam = GetHandParam(playerid, HAND_RIGHT), leftitem = GetHandItem(playerid, HAND_LEFT), leftparam = GetHandParam(playerid, HAND_LEFT);
	
	if(!rightitem || !leftitem || rightitem != leftitem)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para usar este comando debés tener el mismo tem en ambas manos.");
	if(!ItemModel_HasTag(rightitem, ITEM_TAG_COMBINE) || !ItemModel_HasTag(leftitem, ITEM_TAG_COMBINE))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacer eso con estos items.");
	if(rightparam + leftparam > 400)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad conjunta no puede superar 400.");
	if(ItemModel_GetType(rightitem) != ITEM_MAGAZINE)
	{
		SetHandItemAndParam(playerid, HAND_LEFT, 0, 0);
		SetHandItemAndParam(playerid, HAND_RIGHT, rightitem, rightparam + leftparam);
	}
	else 
	{
		new maxamount = ItemModel_GetParamDefaultValue(rightitem);
		if(rightparam + leftparam > maxamount)
		{
			SetHandItemAndParam(playerid, HAND_RIGHT, rightitem, maxamount);
			SetHandItemAndParam(playerid, HAND_LEFT, rightitem, rightparam + leftparam - maxamount);
		}
		else 
		{
			SetHandItemAndParam(playerid, HAND_LEFT, 0, 0);
			SetHandItemAndParam(playerid, HAND_RIGHT, rightitem, rightparam + leftparam);
		}
	}
		
	Item_ApplyHandlingCooldown(playerid);
	return true;
}


CMD:mano(playerid, params[])
{
	new command[32], amount;
	    
	if(sscanf(params, "s[32]I(0)", command, amount))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mano [comando]");
        SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" usar/i - tirar/i - agarrar/i - agarraruno/i - combinar - cambiar (o también /mc) - separar");
		PrintHandsForPlayer(playerid, playerid);
	} else if(Item_IsHandlingCooldownOn(playerid)) {
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar un tiempo antes de volver a interactuar con otro ítem!");
	} else {
		if(!strcmp(command, "cambiar", true)) {
		
		    new rightitem = GetHandItem(playerid, HAND_RIGHT),
		        rightparam = GetHandParam(playerid, HAND_RIGHT),
		        leftitem = GetHandItem(playerid, HAND_LEFT),
		        leftparam = GetHandParam(playerid, HAND_LEFT);
		        
			if(rightitem == ITEM_ID_TELEFONO_CELULAR)
	    		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo con el telefono celular.");

          	SetHandItemAndParam(playerid, HAND_RIGHT, leftitem, leftparam);
          	SetHandItemAndParam(playerid, HAND_LEFT, rightitem, rightparam);
          	Item_ApplyHandlingCooldown(playerid);
			SendClientMessage(playerid, COLOR_WHITE, "Has intercambiado de una mano a otra los tems que estabas sosteniendo.");

		} else if(!strcmp(command, "combinar", true)) {

		    new rightitem = GetHandItem(playerid, HAND_RIGHT),
		        rightparam = GetHandParam(playerid, HAND_RIGHT),
		        leftitem = GetHandItem(playerid, HAND_LEFT),
		        leftparam = GetHandParam(playerid, HAND_LEFT);

			if(!rightitem || !leftitem || rightitem != leftitem)
			    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para usar este comando debes tener el mismo tem en ambas manos.");
			if(!ItemModel_HasTag(rightitem, ITEM_TAG_COMBINE) || !ItemModel_HasTag(leftitem, ITEM_TAG_COMBINE))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacer eso con estos items.");
			if(rightparam + leftparam > 400)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad conjunta no puede superar 400.");

			if(ItemModel_GetType(rightitem) != ITEM_MAGAZINE)
			{
				SetHandItemAndParam(playerid, HAND_LEFT, 0, 0);
				SetHandItemAndParam(playerid, HAND_RIGHT, rightitem, rightparam + leftparam);
			}
			else 
			{
				new maxamount = ItemModel_GetParamDefaultValue(rightitem);

				if(rightparam + leftparam > maxamount)
				{
					SetHandItemAndParam(playerid, HAND_RIGHT, rightitem, maxamount);
					SetHandItemAndParam(playerid, HAND_LEFT, rightitem, rightparam + leftparam - maxamount);
				}
				else 
				{
					SetHandItemAndParam(playerid, HAND_LEFT, 0, 0);
					SetHandItemAndParam(playerid, HAND_RIGHT, rightitem, rightparam + leftparam);
				}
			}
				
			Item_ApplyHandlingCooldown(playerid);
		}
		else if(!strcmp(command, "tirar", true)) {
			DropObject(playerid, HAND_RIGHT);
		}
		else if(!strcmp(command, "tirari", true)) {
			DropObject(playerid, HAND_LEFT);
		}
		else if(!strcmp(command, "agarrar", true)) {
			TakeObject(playerid, HAND_RIGHT);
		}
		else if(!strcmp(command, "agarrari", true)) {
			TakeObject(playerid, HAND_LEFT);
		}
		else if(!strcmp(command, "usar", true)) {
			Item_Use(playerid, HAND_RIGHT);
		}
		else if(!strcmp(command, "usari", true)) {
			Item_Use(playerid, HAND_LEFT);
		}
		else if(!strcmp(command, "agarraruno", true)) {
			TakeOneObject(playerid, HAND_RIGHT);
		}
		else if(!strcmp(command, "agarrarunoi", true)) {
			TakeOneObject(playerid, HAND_LEFT);
		}
		else if(!strcmp(command, "separar", true)) {

			if(!amount)
				return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mano separar [cantidad]");
			
			new itemid = GetHandItem(playerid, HAND_RIGHT),
				itemamount = GetHandParam(playerid, HAND_RIGHT),
				leftfree = GetHandItem(playerid, HAND_LEFT);
				
			if(!itemid || leftfree)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un objeto en la mano derecha y la mano izquierda vacia.");
			if(!ItemModel_HasTag(itemid, ITEM_TAG_SPLIT))
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacer eso con estos items.");
			if(amount <= 0 || amount >= itemamount)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad debe ser mayor a 0 y menor a la cantidad del item.");

			SetHandItemAndParam(playerid, HAND_LEFT, itemid, amount);
			SetHandItemAndParam(playerid, HAND_RIGHT, itemid, itemamount - amount);
			SendFMessage(playerid, COLOR_WHITE, "Has separado %i %s de %s.", amount, ItemModel_GetParamName(itemid), ItemModel_GetName(itemid));
		}

	}
	return 1;
}

Dialog:Dlg_Show_Item_Container(playerid, response, listitem, inputtext[])
{
	new container_id = Container_Selection[playerid][csId];

	ResetContainerSelection(playerid);

	if(response)
	{
        new itemid,
            itemparam,
            str[128];

		if(Container_TakeItem(container_id, listitem, itemid, itemparam))
		{
			// Priorizar mano derecha, luego izquierda
			new free_hand = -1;
			if(GetHandItem(playerid, HAND_RIGHT) == 0) free_hand = HAND_RIGHT;
			else if(GetHandItem(playerid, HAND_LEFT) == 0) free_hand = HAND_LEFT;
			else return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes tomar el item ya que tienes ambas manos ocupadas.");

			SetHandItemAndParam(playerid, free_hand, itemid, itemparam); // Creación lógica y gráfica en la mano.
            Item_ApplyHandlingCooldown(playerid);
			format(str, sizeof(str), "toma un/a %s del contenedor.", ItemModel_GetName(itemid));
			PlayerActionMessage(playerid, 15.0, str);
		} else {
	        SendClientMessage(playerid, COLOR_YELLOW2, "Contenedor vacio o el slot es invlido.");
		}
	}
	return 1;
}

