#if defined _marp_item_type_BN_included
	#endinput
#endif
#define _marp_item_type_BN_included

#include <YSI_Coding\y_hooks>

static enum e_ITEM_BN_DATA {
	bnItemID,
	bnEat,
	bnDrink,
	bnAlcohol
};

static const ItemBN_Data[][e_ITEM_BN_DATA] = {
	{ITEM_ID_NULL, 0, 0, 0},
	{ITEM_ID_SANDWICH, 45, 0, 0},
	{ITEM_ID_ALFAJOR, 25, 0, 0},
	{ITEM_ID_AGUAMINERAL, 0, 60, 0},
	{ITEM_ID_MATE, 0, 50, 0},
	{ITEM_ID_VINO, 0, 40, 25},
	{ITEM_ID_WHISKY, 0, 50, 35},
	{ITEM_ID_VODKA, 0, 30, 50},
	{ITEM_ID_RON, 0, 40, 35},
	{ITEM_ID_HAMBURGUESA, 40, 0, 0},
	{ITEM_ID_JUGO_MANZANA_CAJA, 0, 60, 0},
	{ITEM_ID_JUGO_NARANJA_CAJA, 0, 60, 0},
	{ITEM_ID_POTE_HELADO, 25, 25, 0},
	{ITEM_ID_CAJA_LECHE, 0, 50, 0},
	{ITEM_ID_BOTELLA_LECHE, 0, 40, 0},
	{ITEM_ID_CERVEZA, 0, 50, 20},
	{ITEM_ID_NARANJA, 10, 10, 0},
	{ITEM_ID_MANZANA_ROJA, 10, 10, 0},
	{ITEM_ID_MANZANA_VERDE, 10, 10, 0},
	{ITEM_ID_TOMATE, 10, 5, 0},
	{ITEM_ID_BANANA, 20, 0, 0},
	{ITEM_ID_PAN, 10, 0, 0},
	{ITEM_ID_CAFE, 0, 30, 0},
	{ITEM_ID_TOSTADA, 10, 0, 0},
	{ITEM_ID_CEREALES_CRISPY, 40, 0, 0},
	{ITEM_ID_CEREALES_POPS, 40, 0, 0},
	{ITEM_ID_PECHUGA_POLLO, 70, 0, 0},
	{ITEM_ID_MILANESA_Y_ENSALADA, 80, 0, 0},
	{ITEM_ID_CROQUETAS_RELLENAS, 60, 0, 0},
	{ITEM_ID_LANGOSTINOS_EMPANADOS, 60, 0, 0},
	{ITEM_ID_WANTAN_SALMON, 90, 0, 0},
	{ITEM_ID_POLLO_VERDEO, 70, 0, 0},
	{ITEM_ID_ENSALADA_CESAR, 30, 60, 0},
	{ITEM_ID_ENSALADA_WALDORF, 40, 40, 0},
	{ITEM_ID_MUFFINS, 20, 0, 0},
	{ITEM_ID_DONAS_SURTIDAS, 40, 0, 0},
	{ITEM_ID_DONAS_BLANCAS, 30, 0, 0},
	{ITEM_ID_PIZZA_LEGENDARIA, 100, 0, 0},
	{ITEM_ID_PIZZA_CANTIMPALO, 90, 0, 0},
	{ITEM_ID_PIZZA_MUZZARELLA, 80, 0, 0},
	{ITEM_ID_PIZZA_ESPECIAL, 90, 0, 0},
	{ITEM_ID_P_PIZZA_HUEVO_ENS_PAPAS, 30, 20, 0},
	{ITEM_ID_P_PIZZA_MUZZA_ENS_PAPAS, 30, 20, 0},
	{ITEM_ID_P_PIZZA_ESPECIAL_PAPAS, 35, 20, 0},
	{ITEM_ID_P_PIZZA_ROQUE_PAPAS, 30, 20, 0},
	{ITEM_ID_P_PIZZA_MUZZA_PAPAS, 30, 20, 0},
	{ITEM_ID_PORCION_DE_PIZZA, 20, 0, 0},
	{ITEM_ID_BOTELLA_GASEOSA, 0, 40, 0},
	{ITEM_ID_LATA_GASEOSA, 0, 25, 0},
	{ITEM_ID_BOTELLA_FERNET, 0, 45, 40},
	{ITEM_ID_VASO_FERNET, 0, 25, 20},
	{ITEM_ID_BOTELLA_GANCIA, 0, 40, 35},
	{ITEM_ID_VASO_GANCIA, 0, 20, 15},
	{ITEM_ID_CHAMPAGNE, 0, 50, 35},
	{ITEM_ID_TEQUILA, 0, 35, 60},
	{ITEM_ID_LICOR, 0, 40, 40},
	{ITEM_ID_CAMPARI, 0, 30, 30},
	{ITEM_ID_RON_CALIDAD, 0, 60, 70},
	{ITEM_ID_WHISKY_CALIDAD, 0, 70, 75},
	{ITEM_ID_VODKA_CALIDAD, 0, 65, 110},
	{ITEM_ID_VINO_CALIDAD, 0, 50, 60},
	{ITEM_ID_CHAMPAGNE_CALIDAD, 0, 55, 80},
	{ITEM_ID_TEQUILA_CALIDAD, 0, 75, 120},
	{ITEM_ID_HAMB_COMBO_DELUXE, 50, 50, 0},
	{ITEM_ID_SAND_COMBO_DELUXE, 50, 50, 0},
	{ITEM_ID_CHORIPAN, 60, 0, 0}
};

ItemBN_GetFoodValue(dataid) {
	return ItemBN_Data[dataid][bnEat];
}

ItemBN_GetDrinkValue(dataid) {
	return ItemBN_Data[dataid][bnDrink];
}

ItemBN_GetAlcoholValue(dataid) {
	return ItemBN_Data[dataid][bnAlcohol];
}

ItemBN_IsValidDataId(dataid) {
	return (0 < dataid < sizeof(ItemBN_Data));
}

hook OnGameModeInitEnded()
{
	for(new i = 1, size = sizeof(ItemBN_Data); i < size; i++) {
		ItemModel_SetExtraId(ItemBN_Data[i][bnItemID], i);
	}

	printf("[INFO] Se han asociado los datos de comida y bebida de %i items.", sizeof(ItemBN_Data) - 1);
	return 1;
}

Item_OnUsed(playerid, hand, itemid, itemType)
{
	if(itemType != ITEM_BASIC_NEEDS)
		return 0;

	new ItemBN_dataId = ItemModel_GetExtraId(itemid);

	if(!ItemBN_IsValidDataId(ItemBN_dataId))
		return 0;

	if(ItemBN_GetFoodValue(ItemBN_dataId))
	{
		if(hand == HAND_RIGHT) {
			ApplyAnimationEx(playerid, "PED", "pass_Smoke_in_car", 1.8, 0, 1, 1, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		} else {
			ApplyAnimationEx(playerid, "VENDING", "VEND_Eat_P", 1.8, 0, 1, 1, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		}
	} else {
		if(hand == HAND_RIGHT) {
			ApplyAnimationEx(playerid, "Bar", "dnk_stndM_loop", 1.8, 0, 1, 1, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		} else {
			ApplyAnimationEx(playerid, "VENDING", "VEND_Drink_P", 1.8, 0, 1, 1, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		}
	}

	BN_PlayerEat(playerid, ItemBN_GetFoodValue(ItemBN_dataId) / ItemModel_GetParamDefaultValue(itemid));
	BN_PlayerDrink(playerid, ItemBN_GetDrinkValue(ItemBN_dataId) / ItemModel_GetParamDefaultValue(itemid));
	BN_PlayerDrinkAlcohol(playerid, ItemBN_GetAlcoholValue(ItemBN_dataId) / ItemModel_GetParamDefaultValue(itemid));

	new str[128];
	format(str, sizeof(str), "Consume un poco de su %s", ItemModel_GetName(itemid));
	PlayerCmeMessage(playerid, 15.0, 4000, str);

	if(GetHandParam(playerid, hand) - 1 > 0) {
		SetHandItemAndParam(playerid, hand, itemid, GetHandParam(playerid, hand) - 1);
	} else {
		SetHandItemAndParam(playerid, hand, 0, 0); // Borrado lógico y grafico
	}

	return 1;
}