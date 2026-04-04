#if defined _marp_biz_purchase_included
	#endinput
#endif
#define _marp_biz_purchase_included

#include <YSI_Coding\y_hooks>

forward Biz_OnPlayerIntendsToBuy(playerid, bizid);
public Biz_OnPlayerIntendsToBuy(playerid, bizid)
{
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");

	if(GetBusinessType(bizid) == BIZ_CLOT || GetBusinessType(bizid) == BIZ_CLOT2)
	{
		Biz_OnPlayerBuyCloth(playerid, bizid);
		return 0;
	}
	else if(GetBusinessType(bizid) == BIZ_AMMU && !PlayerInfo[playerid][pWepLic])
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"[Vendedor]: No puedes comprar aquí sin una licencia de portación de armas.");
		return 0;
	}

	Biz_ShowItemShopMenu(playerid, bizid);
	return 1;
}

Biz_ShowItemShopMenu(playerid, bizid)
{
	if(!BusinessCatalog[bizid][0][bItemid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El negocio no tiene ningún producto a la venta");

	new List:list = PMM_NewItemList();

	for(new i = 0, itemStr[PMM_MAX_DESC_LENGTH]; i < MAX_BIZ_LISTITEM && BusinessCatalog[bizid][i][bItemid]; i++)
	{
		new dispPrice = BusinessCatalog[bizid][i][bPrice];
		new promoActive = (BizPromo[bizid] > 0 && GetTickCount() < BizPromoExpiry[bizid]);
		if(promoActive) dispPrice = dispPrice - (dispPrice * BizPromo[bizid] / 100);
		format(itemStr, sizeof(itemStr), "%s $%i%s", ItemModel_GetTextDrawNameString(BusinessCatalog[bizid][i][bItemid]), dispPrice, promoActive ? " [PROMO]" : "");
		PMM_AddItem(list, ItemModel_GetObjectModel(BusinessCatalog[bizid][i][bItemid]), itemStr);
	}

	PMM_Show(playerid, Biz_ShopMenu, .itemList = list, .title = Business[bizid][bName], .deleteMenuDataWhenClosed = true);
	return 1;
}

PMM_OnItemSelected:Biz_ShopMenu(playerid, listitem, extraid)
{
	PMM_Close(playerid);

	new bizid = Biz_IsPlayerInsideAny(playerid);
	new item = BusinessCatalog[bizid][listitem][bItemid];
	new amount = 1;

	if(!item || !bizid)
		return 1;
	if(!GetBizItemStock(bizid, listitem)) {
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"[Vendedor]: No hay más stock de este producto, lo siento.");
	}
	if(GetBizItemStock(bizid, listitem) < amount)
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"[Vendedor]: Lo siento, no tenemos esa cantidad. Disponemos de %i unidades en stock para la venta.", GetBizItemStock(bizid, listitem));
		return 1;
	}

	new purchasePrice = GetBizItemPrice(bizid, listitem) * amount;
	if(BizPromo[bizid] > 0 && GetTickCount() < BizPromoExpiry[bizid])
		purchasePrice = purchasePrice - (purchasePrice * BizPromo[bizid] / 100);

	if(GetPlayerCash(playerid) < purchasePrice)
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"[Vendedor]: ¡No tienes el dinero suficiente (%i)!", purchasePrice);
		return 1;
	}

    new freehand = SearchFreeHand(playerid);
	if(freehand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes como agarrar el item ya que tienes ambas manos ocupadas.");

	if(item == ITEM_ID_TELEFONO_CELULAR)
	{
		if(SearchHandsForItem(playerid, ITEM_ID_TELEFONO_CELULAR) != -1)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para comprar un teléfono nuevo primero debes guardar el que tienes en la mano. [Nota]: Su número y contactos serán reseteados.");

		Phone_DeletePhoneForPlayer(playerid);
		PlayerInfo[playerid][pPhoneNumber] = Phone_NewRandomNumber();
		Phone_id[playerid] = Phone_Create(PlayerInfo[playerid][pPhoneNumber], playerid);
	} else {
		SetHandItemAndParam(playerid, freehand, item, (amount == 1) ? (ItemModel_GetParamDefaultValue(item)) : (amount)); // Si no se setió cantidad (no es biz = AMMU), se setea el parametro inicial default
	}

	GivePlayerCash(playerid, -purchasePrice);
	BusinessCatalog[bizid][listitem][bStock] -= amount;
	Biz_AddTill(bizid, purchasePrice);
	BizClientCount[bizid]++;
	BizBonus_CheckThresholds(bizid);
	Biz_UpdateSQLItemStock(bizid, listitem);
	SendFMessage(playerid, COLOR_WHITE, "¡Has comprado [%s - %s: %i] por $%i!", ItemModel_GetName(item), ItemModel_GetParamName(item), (item == ITEM_ID_TELEFONO_CELULAR) ? (PlayerInfo[playerid][pPhoneNumber]) : (GetHandParam(playerid, freehand)), purchasePrice);

	// Tip dialog if employee offered the product
	if(BizOfferEmployee[playerid] != INVALID_PLAYER_ID)
	{
		Dialog_Open(playerid, "DLG_BizTip", DIALOG_STYLE_INPUT, "Propina", "iQueres dejarle propina al empleado?\nIngresa el monto (0 o cancelar para no dar):", "Enviar", "No");
	}
	else
	{
		BizOfferEmployee[playerid] = INVALID_PLAYER_ID;
	}
	return 1;
}

Dialog:DLG_BizTip(playerid, response, listitem, inputtext[])
{
	new empleadoid = BizOfferEmployee[playerid];
	BizOfferEmployee[playerid] = INVALID_PLAYER_ID;

	if(!response) return 1;

	new amount = strval(inputtext);

	if(amount <= 0) return 1;

	if(GetPlayerCash(playerid) < amount)
	{
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Intentaste darle propina, pero no tenias un peso. Quedaste un poco mal. El empleado se dio cuenta.");
		if(IsPlayerConnected(empleadoid))
		{
			SendClientMessage(empleadoid, COLOR_LIGHTBLUE, "[NEGOCIO] "COLOR_EMB_GREY"El cliente te trato de dar propina, pero parece que amago. Evidentemente, quedo como un boludo.");
			SendClientMessage(empleadoid, COLOR_LIGHTBLUE, "[NEGOCIO] "COLOR_EMB_GREY"Como reaccionas ante esto?");
		}
		return 1;
	}

	GivePlayerCash(playerid, -amount);
	if(IsPlayerConnected(empleadoid))
		GivePlayerCash(empleadoid, amount);

	SendFMessage(playerid, COLOR_INFO, "[NEGOCIO] "COLOR_EMB_GREY"Le dejaste $%i de propina a %s.", amount, IsPlayerConnected(empleadoid) ? GetPlayerCleanName(empleadoid) : "el empleado");
	if(IsPlayerConnected(empleadoid))
		SendFMessage(empleadoid, COLOR_INFO, "[NEGOCIO] "COLOR_EMB_GREY"%s te dejo $%i de propina!", GetPlayerCleanName(playerid), amount);
	return 1;
}