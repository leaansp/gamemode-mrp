#if defined _marp_item_type_drug_included
    #endinput
#endif
#define _marp_item_type_drug_included

#include <YSI_Coding\y_hooks>

enum {
	DRUG_ID_NONE,
	DRUG_ID_MARIJUANA,
	DRUG_ID_COCAINE,
	DRUG_ID_ECSTASY,
	DRUG_ID_LSD,
	DRUG_IDS_AMOUNT
};

static enum e_ITEM_DRUG_DATA {
    drugItemID,
	drugID,
	drugWeather,
	drugDuration // minutos.
};

static const ItemDrug_Data[][e_ITEM_DRUG_DATA] = {
    {ITEM_ID_NULL, DRUG_ID_NONE, -1, 0},
    {ITEM_ID_PORRO, DRUG_ID_MARIJUANA, -1, 5},
	{ITEM_ID_COCAINA, DRUG_ID_COCAINE, 126, 10},
	{ITEM_ID_EXTASIS, DRUG_ID_ECSTASY, 18, 12},
	{ITEM_ID_LSD, DRUG_ID_LSD, 211, 15}
};

ItemDrug_IsValidDataId(dataid) {
	return (0 < dataid < sizeof(ItemDrug_Data));
}

ItemDrug_GetDrugID(dataid) {
	return ItemDrug_Data[dataid][drugID];
}

ItemDrug_GetWeather(dataid) {
	return ItemDrug_Data[dataid][drugWeather];
}

ItemDrug_GetEffectDuration(dataid) {
	return ItemDrug_Data[dataid][drugDuration];
}

hook OnGameModeInitEnded()
{
	for(new i = 1, size = sizeof(ItemDrug_Data); i < size; i++) {
		ItemModel_SetExtraId(ItemDrug_Data[i][drugItemID], i);
	}

	printf("[INFO] Se han asociado los datos unitarios de %i items tipo droga.", sizeof(ItemDrug_Data) - 1);
	return 1;
}

hook function Item_OnUsed(playerid, hand, itemid, itemType)
{


	if(itemType != ITEM_DRUG)
		return continue(playerid, hand, itemid, itemType);



	new ItemDrug_dataId = ItemModel_GetExtraId(itemid);

	if(!ItemDrug_IsValidDataId(ItemDrug_dataId))
		return 0;

	new str[128];
	format(str, sizeof(str), "Consume un poco de su %s", ItemModel_GetName(itemid));
	PlayerCmeMessage(playerid, 15.0, 4000, str);
	new drugid   = ItemDrug_GetDrugID(ItemDrug_dataId);

	switch(drugid)
	{
		case DRUG_ID_MARIJUANA: SendClientMessage(playerid, COLOR_YELLOW2, "[EFECTO] Te relajás... la marihuana te da un leve subidón y hambre después.");
		case DRUG_ID_COCAINE:   SendClientMessage(playerid, COLOR_YELLOW2, "[EFECTO] La cocaína te enciende: más vitalidad, menos daño y pegás más fuerte.");
		case DRUG_ID_ECSTASY:   SendClientMessage(playerid, COLOR_YELLOW2, "[EFECTO] El éxtasis te acelera y te hace brillar... pero te va a dar sed después.");
		case DRUG_ID_LSD:       SendClientMessage(playerid, COLOR_YELLOW2, "[EFECTO] El LSD distorsiona tu mundo. No sabés si estás volando o mirando el cielo.");
	}

	Drugs_OnPlayerUsed(playerid, ItemDrug_GetDrugID(ItemDrug_dataId), ItemDrug_GetEffectDuration(ItemDrug_dataId), ItemDrug_GetWeather(ItemDrug_dataId)); 

	if(GetHandParam(playerid, hand) - 1 > 0) {
		SetHandItemAndParam(playerid, hand, itemid, GetHandParam(playerid, hand) - 1);
	} else {
		SetHandItemAndParam(playerid, hand, 0, 0); // Borrado lógico y grafico
	}
    return 1;
}
