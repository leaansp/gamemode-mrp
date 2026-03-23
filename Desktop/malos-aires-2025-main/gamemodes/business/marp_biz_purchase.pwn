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
		format(itemStr, sizeof(itemStr), "%s $%i", ItemModel_GetTextDrawNameString(BusinessCatalog[bizid][i][bItemid]), BusinessCatalog[bizid][i][bPrice]);
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
	Biz_UpdateSQLItemStock(bizid, listitem);
	SendFMessage(playerid, COLOR_WHITE, "¡Has comprado [%s - %s: %i] por $%i!", ItemModel_GetName(item), ItemModel_GetParamName(item), (item == ITEM_ID_TELEFONO_CELULAR) ? (PlayerInfo[playerid][pPhoneNumber]) : (GetHandParam(playerid, freehand)), purchasePrice);
	return 1;
}