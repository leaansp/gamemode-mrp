#if defined _marp_item_type_batch_included
	#endinput
#endif
#define _marp_item_type_batch_included

#include <YSI_Coding\y_hooks>

static enum e_ITEM_BATCH_DATA {
	batchItemID,
	batchUnitItemID
};

static const ItemBatch_Data[][e_ITEM_BATCH_DATA] = {
	{ITEM_ID_NULL, ITEM_ID_NULL},
	{ITEM_ID_PACK_CERVEZA, ITEM_ID_CERVEZA},
	{ITEM_ID_CAJA_DE_PIZZA_1, ITEM_ID_PORCION_DE_PIZZA},
	{ITEM_ID_CAJA_DE_PIZZA_2, ITEM_ID_PORCION_DE_PIZZA},
	{ITEM_ID_PACK_MARIHUANA, ITEM_ID_PORRO},
	{ITEM_ID_PACK_COCAINA, ITEM_ID_COCAINA},
	{ITEM_ID_PACK_EXTASIS, ITEM_ID_EXTASIS},
	{ITEM_ID_PACK_LSD, ITEM_ID_LSD},
	{ITEM_ID_BOX_COLT_MAG, ITEM_ID_COLT_MAGAZINE},
	{ITEM_ID_BOX_DEAGLE_MAG, ITEM_ID_DEAGLE_MAGAZINE},
	{ITEM_ID_BOX_SHOTGUN_SHELL, ITEM_ID_SHOTGUN_SHELLS},
	{ITEM_ID_BOX_UZI_MAG, ITEM_ID_UZI_MAGAZINE},
	{ITEM_ID_BOX_MP5_MAG, ITEM_ID_MP5_MAGAZINE},
	{ITEM_ID_BOX_AK47_MAG, ITEM_ID_AK47_MAGAZINE},
	{ITEM_ID_BOX_M4_MAG, ITEM_ID_M4_MAGAZINE},
	{ITEM_ID_BOX_RIFLE_BULLETS, ITEM_ID_RIFLE_BULLETS}
};

ItemBatch_GetUnitItemId(dataid) {
	return ItemBatch_Data[dataid][batchUnitItemID];
}

ItemBatch_IsValidDataId(dataid) {
	return (0 < dataid < sizeof(ItemBatch_Data));
}

hook OnGameModeInitEnded()
{
	for(new i = 1, size = sizeof(ItemBatch_Data); i < size; i++) {
		ItemModel_SetExtraId(ItemBatch_Data[i][batchItemID], i);
	}

	printf("[INFO] Se han asociado los datos unitarios de %i items tipo lote.", sizeof(ItemBatch_Data) - 1);
	return 1;
}

hook function Item_OnUsed(playerid, hand, itemid, itemType)
{
	if(itemType != ITEM_BATCH)
		return continue(playerid, hand, itemid, itemType);

	new ItemBatch_dataId = ItemModel_GetExtraId(itemid);

	if(!ItemBatch_IsValidDataId(ItemBatch_dataId))
		return 0;
	
	if(!SetAnyHandItemAndParam(playerid, ItemBatch_GetUnitItemId(ItemBatch_dataId), ItemModel_GetParamDefaultValue(ItemBatch_GetUnitItemId(ItemBatch_dataId))))
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener una mano libre.");
		return 0;
	}

	if(GetHandParam(playerid, hand) - 1 > 0) {
		SetHandItemAndParam(playerid, hand, itemid, GetHandParam(playerid, hand) - 1);
	} else {
		SetHandItemAndParam(playerid, hand, 0, 0); // Borrado lógico y grafico
	}
	return 1;
}