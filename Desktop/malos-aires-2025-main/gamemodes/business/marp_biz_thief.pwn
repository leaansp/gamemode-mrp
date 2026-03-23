#if defined marp_biz_thief_inc
	#endinput
#endif
#define marp_biz_thief_inc

Biz_ShowThiefMenu(playerid, bizid)
{
    if(GetBusinessType(bizid) == BIZ_AMMU || GetBusinessType(bizid) == BIZ_CLOT || GetBusinessType(bizid) == BIZ_CLOT2)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No pudes hurtar en una tienda de ropa o en una armeria.");
	if(!BusinessCatalog[bizid][0][bItemid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El negocio no tiene ningún producto a la venta");

	new List:list = PMM_NewItemList();

	for(new i = 0, itemStr[PMM_MAX_DESC_LENGTH]; i < MAX_BIZ_LISTITEM && BusinessCatalog[bizid][i][bItemid]; i++)
	{
		format(itemStr, sizeof(itemStr), "%s $%i", ItemModel_GetTextDrawNameString(BusinessCatalog[bizid][i][bItemid]), BusinessCatalog[bizid][i][bPrice]);
		PMM_AddItem(list, ItemModel_GetObjectModel(BusinessCatalog[bizid][i][bItemid]), itemStr, BusinessCatalog[bizid][i][bItemid]);
	}

	PMM_Show(playerid, Biz_ThiefMenu, .itemList = list, .title = "Selecciona el producto a hurtar", .deleteMenuDataWhenClosed = true);
	return 1;
}

PMM_OnItemSelected:Biz_ThiefMenu(playerid, listitem, extraid)
{
	new bizid = Biz_IsPlayerInsideAny(playerid);
	// `extraid` contains the actual itemid we passed when creating the menu; prefer it
	new item = (extraid) ? extraid : BusinessCatalog[bizid][listitem][bItemid];

	if(!item || !bizid)
	{
		PMM_Close(playerid);
		return 0;
	}

	PMM_Close(playerid);

	if(GetBizItemStock(bizid, listitem) == 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No encuentras ningun producto.");
    if(item == ITEM_ID_TELEFONO_CELULAR)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No podes hurtar un telefono celular.");

    new freehand = SearchFreeHand(playerid);
	if(freehand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes como agarrar el item ya que tienes ambas manos ocupadas.");

    SendFMessage(playerid, COLOR_WHITE, "Comienzas a hurtar un/a %s. (( Recuerda rolearlo ))", ItemModel_GetName(item));

	thief_stealing[playerid] = 1;
	thief_timer_police_call[playerid] = (random(4)) ? (1 + random(25)) : (0); // 25 % de que no llame. Si llama lo hace dentro de los últimos (1+X) segundos
	thief_timer_secs[playerid] = THIEF_SHOP_THEFT_DURATION;
	thief_type[playerid] = THIEF_SHOP_THEFT;
	thief_target[playerid] = bizid;
	thief_listitem[playerid] = listitem;
	thief_selected_itemid[playerid] = item;
	thief_timer[playerid] = SetTimerEx("Thief_Countdown", 1000, true, "i", playerid);
	PlayerInfo[playerid][pDisabled] = DISABLE_STEALING;
	new cooldown = floatround(THIEF_SHOP_THEFT_SECS_PER_PRICE * float(ItemModel_GetPrice(item)), floatround_ceil);
	// Calcular segundos efectivos respetando el mínimo y aplicando un tope de 1 hora (3600s)
	new secs = (cooldown < THIEF_SHOP_THEFT_MIN_COOLDOWN * 60) ? (THIEF_SHOP_THEFT_MIN_COOLDOWN * 60) : cooldown;
	if(secs > 60 * 60) secs = 60 * 60; // tope máximo: 1 hora
	CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_HURTARTIENDA, .seconds = secs);
    return 1;
}