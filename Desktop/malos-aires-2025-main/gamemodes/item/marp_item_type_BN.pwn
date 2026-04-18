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

stock Choripan_SendUseMessage(playerid, param)
{
    static const p5[][96] = {
        "¡Uy, la primera mordidita siempre es la más rica!",
        "Primer bocado y ya se nota que vale cada peso.",
        "Arrancar con un chori así es arrancar bien el día.",
        "El primer mordisco te cambia el humor al toque.",
        "¡Así se arranca una tarde de asado, con clase!",
        "¡Primera mordida y ya estás sonriendo solo!",
        "El olor ya prometía, pero el sabor es otro nivel.",
        "Primer mordisco y ya sabés que vas a querer otro.",
        "Así empieza una historia de amor con el chori.",
        "Primer bocado. Todo está bien en este mundo."
    };
    static const p4[][96] = {
        "Va tomando sabor, esto es gastronomía de verdad.",
        "Segundo mordisco y confirmás que fue buena idea.",
        "Cada bocado mejor que el anterior.",
        "Esto está en su punto justo, un diez.",
        "El pan se empapa del jugo... perfecta combinación.",
        "No para de mejorar a medida que avanzan los bocados.",
        "Eso es sabor casero, no de paquete.",
        "Le estás encontrando la vuelta al asunto.",
        "La salsa, el pan, la carne... todo en orden.",
        "Segundo bocado. Vas por buen camino, compañero."
    };
    static const p3[][96] = {
        "Llegaste a la mitad. Saboreéalo bien.",
        "El ecuador del chori. Ya no hay vuelta atrás.",
        "Mitad del camino. El sabor sigue en aumento.",
        "Vas a la mitad, y cada bocado vale doble ahora.",
        "Justo en el medio y el corazón empieza a doler un poco.",
        "La mitad del chori ya pasó, pero dejó su huella.",
        "A este ritmo, en dos bocados más te ponés triste.",
        "Mitad del chori. Empieza la cuenta regresiva.",
        "Esto se está acabando y todavía no estás listo.",
        "Mitad justa. Ahora viene la parte difícil: soltar."
    };
    static const p2[][96] = {
        "Te queda menos de la mitad del chori, te querés matar porque estaba buenísimo.",
        "Solo queda un bocado más y eso te parte el alma.",
        "Te diste cuenta que se acaba y el pecho aprieta.",
        "Poco chori, mucho dolor. Así es la vida.",
        "Queda casi nada y ya lo ves venir. Doloroso.",
        "El final está cerca y no hay forma de pararlo.",
        "Menos de la mitad y el corazón ya llora por dentro.",
        "Quedan los últimos pedacitos. Los mejores y los más tristes.",
        "Te quedás sin chori y nadie te va a entender el dolor.",
        "Un bocado más y chau, mi amor. Ya casi no hay."
    };
    static const p1[][96] = {
        "El último mordisco. Que descanse en paz.",
        "Último bocado. Fin de una era.",
        "Y así, sin avisar, el chori llegó a su fin.",
        "El último pedazo siempre es el más amargo. No por el sabor.",
        "Adiós, chori. Fuiste demasiado bueno para este mundo.",
        "Último bocado y ya estás pensando en cuándo comer otro.",
        "Se fue. Pero qué bien que vivió.",
        "El fin llegó. Fue glorioso hasta el final.",
        "Último mordisco. Llorás por dentro pero lo disimulás.",
        "Final del chori. El silencio que queda lo dice todo."
    };

    new out[128];
    switch(param)
    {
        case 5: format(out, sizeof(out), "[INFO] "COLOR_EMB_GREY"%s", p5[random(10)]);
        case 4: format(out, sizeof(out), "[INFO] "COLOR_EMB_GREY"%s", p4[random(10)]);
        case 3: format(out, sizeof(out), "[INFO] "COLOR_EMB_GREY"%s", p3[random(10)]);
        case 2: format(out, sizeof(out), "[INFO] "COLOR_EMB_GREY"%s", p2[random(10)]);
        case 1: format(out, sizeof(out), "[INFO] "COLOR_EMB_GREY"%s", p1[random(10)]);
        default: return;
    }
    SendClientMessage(playerid, COLOR_INFO, out);
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

	if(itemid == ITEM_ID_CHORIPAN)
		Choripan_SendUseMessage(playerid, GetHandParam(playerid, hand));

	if(GetHandParam(playerid, hand) - 1 > 0) {
		SetHandItemAndParam(playerid, hand, itemid, GetHandParam(playerid, hand) - 1);
	} else {
		SetHandItemAndParam(playerid, hand, 0, 0); // Borrado lógico y grafico
	}

	return 1;
}