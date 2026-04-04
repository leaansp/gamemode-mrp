#if defined _marp_biz_prods_manage_included
	#endinput
#endif
#define _marp_biz_prods_manage_included

#include <YSI_Coding\y_hooks>
#include "faction/marp_factions.pwn"
#define MAX_BIZ_LISTITEM        10
#define MAX_ITEM_STOCK          500
#define MAX_RANDOM_ITEM_STOCK	100000

// Límite porcentual máximode ganancias por venta automática de items (ventas - costos) respecto al precio del negocio
#define BIZ_MAX_PAYDAY_EARNING_PERCENT 0.01
#define BIZ_MAX_PAYDAY_EARNING_ABSOLUTE	7500

// Descuento porcentual en el costo de adquisición de los items respecto al precio base
#define BIZ_COST_UNIT_DISCOUNT 0.4

new BizPayCheck[MAX_BUSINESS],
	BizClientCount[MAX_BUSINESS],
	BizBonusLevel[MAX_BUSINESS],
	BizUnhappyClients[MAX_BUSINESS];

new stravitems[4096];

static const BizTypeAvailableItems[BIZ_TYPES_AMOUNT][] = { // TODO: separar en c/tipo y obtener tamaño con sizeof
	 //NULO
	{0},

	//RESTAURANT
	{ITEM_ID_VINO, ITEM_ID_WHISKY, ITEM_ID_VODKA, ITEM_ID_RON, ITEM_ID_PAN, ITEM_ID_HAMBURGUESA,
	ITEM_ID_CAFE, ITEM_ID_TOSTADA, ITEM_ID_PECHUGA_POLLO, ITEM_ID_MILANESA_Y_ENSALADA,
	ITEM_ID_CROQUETAS_RELLENAS, ITEM_ID_LANGOSTINOS_EMPANADOS, ITEM_ID_WANTAN_SALMON,
	ITEM_ID_POLLO_VERDEO, ITEM_ID_ENSALADA_CESAR, ITEM_ID_ENSALADA_WALDORF, ITEM_ID_MUFFINS,
	ITEM_ID_DONAS_SURTIDAS, ITEM_ID_DONAS_BLANCAS, ITEM_ID_PIZZA_LEGENDARIA, ITEM_ID_PIZZA_CANTIMPALO,
	ITEM_ID_PIZZA_MUZZARELLA, ITEM_ID_PIZZA_ESPECIAL, ITEM_ID_P_PIZZA_HUEVO_ENS_PAPAS,
	ITEM_ID_P_PIZZA_MUZZA_ENS_PAPAS, ITEM_ID_P_PIZZA_ESPECIAL_PAPAS, ITEM_ID_P_PIZZA_ROQUE_PAPAS,
	ITEM_ID_P_PIZZA_MUZZA_PAPAS, ITEM_ID_CAJA_DE_PIZZA_1, ITEM_ID_CAJA_DE_PIZZA_2, ITEM_ID_BOTELLA_GASEOSA,
	ITEM_ID_LATA_GASEOSA, ITEM_ID_BOTELLA_FERNET, ITEM_ID_VASO_FERNET, ITEM_ID_BOTELLA_GANCIA,
	ITEM_ID_VASO_GANCIA, ITEM_ID_CHAMPAGNE, ITEM_ID_TEQUILA, ITEM_ID_LICOR, ITEM_ID_CAMPARI, ITEM_ID_RON_CALIDAD,
	ITEM_ID_WHISKY_CALIDAD, ITEM_ID_VODKA_CALIDAD, ITEM_ID_VINO_CALIDAD, ITEM_ID_CHAMPAGNE_CALIDAD,
	ITEM_ID_TEQUILA_CALIDAD, 0},
	
	//BIZ_PHON
	{0}, 

	//24-7
	{ITEM_ID_CAMARA, ITEM_ID_TELEFONO_CELULAR, ITEM_ID_RADIO, ITEM_ID_PARLANTE,
	ITEM_ID_BIDON, ITEM_ID_SANDWICH, ITEM_ID_ALFAJOR, ITEM_ID_AGUAMINERAL,
	ITEM_ID_ENCENDEDOR, ITEM_ID_CIGARRILLOS, ITEM_ID_MEDIC_CASE,
	ITEM_ID_CERVEZA, ITEM_ID_VINO, ITEM_ID_WHISKY, ITEM_ID_VODKA,
	ITEM_ID_RON, ITEM_ID_JUGO_NARANJA_CAJA, ITEM_ID_JUGO_MANZANA_CAJA, ITEM_ID_POTE_HELADO,
	ITEM_ID_CAJA_LECHE, ITEM_ID_NARANJA, ITEM_ID_MANZANA_ROJA, ITEM_ID_MANZANA_VERDE,
	ITEM_ID_TOMATE, ITEM_ID_BANANA, ITEM_ID_PAN, ITEM_ID_CEREALES_CRISPY, ITEM_ID_CEREALES_POPS, 
	ITEM_ID_PACK_CERVEZA, ITEM_ID_BOTELLA_GASEOSA, ITEM_ID_LATA_GASEOSA, ITEM_ID_BOTELLA_FERNET, ITEM_ID_BOTELLA_GANCIA,
	ITEM_ID_CHAMPAGNE, ITEM_ID_TEQUILA, ITEM_ID_LICOR, ITEM_ID_CAMPARI, ITEM_ID_RON_CALIDAD,
	ITEM_ID_WHISKY_CALIDAD, ITEM_ID_VODKA_CALIDAD, ITEM_ID_VINO_CALIDAD, ITEM_ID_CHAMPAGNE_CALIDAD,
	ITEM_ID_TEQUILA_CALIDAD, ITEM_ID_FRENCH_DECK, ITEM_ID_CHORIZO, 0},

	//AMMUNATION
	{ITEM_ID_COLT45, ITEM_ID_DEAGLE, ITEM_ID_SHOTGUN, ITEM_ID_RIFLE, ITEM_ID_COLT_MAGAZINE, ITEM_ID_DEAGLE_MAGAZINE,
	ITEM_ID_SHOTGUN_SHELLS, ITEM_ID_RIFLE_BULLETS, 0},
	
	//BIZ_ADVE
	{0},
	
	//BIZ_CLOT
	{ITEM_ID_ROPA1, ITEM_ID_ROPA2, ITEM_ID_ROPA3, ITEM_ID_ROPA4, ITEM_ID_ROPA5, ITEM_ID_ROPA6,
	ITEM_ID_ROPA7, ITEM_ID_ROPA8, ITEM_ID_ROPA9, ITEM_ID_ROPA10, 0},

	//CLUB
	{ITEM_ID_AGUAMINERAL, ITEM_ID_CERVEZA, ITEM_ID_VINO, ITEM_ID_WHISKY, ITEM_ID_VODKA, ITEM_ID_ENCENDEDOR, 
	ITEM_ID_CIGARRILLOS, ITEM_ID_RON, ITEM_ID_BOTELLA_GASEOSA, ITEM_ID_LATA_GASEOSA, ITEM_ID_BOTELLA_FERNET,
	ITEM_ID_VASO_FERNET, ITEM_ID_BOTELLA_GANCIA, ITEM_ID_VASO_GANCIA, ITEM_ID_CHAMPAGNE, ITEM_ID_TEQUILA,
	ITEM_ID_LICOR, ITEM_ID_CAMPARI, ITEM_ID_RON_CALIDAD, ITEM_ID_WHISKY_CALIDAD, ITEM_ID_VODKA_CALIDAD,
	ITEM_ID_VINO_CALIDAD, ITEM_ID_CHAMPAGNE_CALIDAD, ITEM_ID_TEQUILA_CALIDAD, 0},
	
	//BIZ_CLOT2
	{ITEM_ID_ROPA1, ITEM_ID_ROPA2, ITEM_ID_ROPA3, ITEM_ID_ROPA4, ITEM_ID_ROPA5, ITEM_ID_ROPA6,
	ITEM_ID_ROPA7, ITEM_ID_ROPA8, ITEM_ID_ROPA9, ITEM_ID_ROPA10, 0},
	
	//BIZ_CASINO
	{ITEM_ID_AGUAMINERAL, ITEM_ID_CERVEZA, ITEM_ID_VINO, ITEM_ID_WHISKY, ITEM_ID_VODKA, ITEM_ID_ENCENDEDOR, 
	ITEM_ID_CIGARRILLOS, ITEM_ID_RON, ITEM_ID_BOTELLA_GASEOSA, ITEM_ID_LATA_GASEOSA, ITEM_ID_BOTELLA_FERNET,
	ITEM_ID_VASO_FERNET, ITEM_ID_BOTELLA_GANCIA, ITEM_ID_VASO_GANCIA, ITEM_ID_CHAMPAGNE, ITEM_ID_TEQUILA,
	ITEM_ID_LICOR, ITEM_ID_CAMPARI, ITEM_ID_RON_CALIDAD, ITEM_ID_WHISKY_CALIDAD, ITEM_ID_VODKA_CALIDAD,
	ITEM_ID_VINO_CALIDAD, ITEM_ID_CHAMPAGNE_CALIDAD, ITEM_ID_TEQUILA_CALIDAD, 0},

	//FERRETERIA
	{WEAPON_BRASSKNUCKLE, WEAPON_SHOVEL, WEAPON_CANE, WEAPON_GOLFCLUB, WEAPON_BAT, WEAPON_POOLSTICK,
	WEAPON_DILDO2, WEAPON_DILDO, WEAPON_VIBRATOR, WEAPON_VIBRATOR2, ITEM_ID_CASCOCOMUN,
	ITEM_ID_CASCOMOTOCROSS, ITEM_ID_CASCOROJO, ITEM_ID_CASCOBLANCO,	ITEM_ID_CASCOROSA,
	ITEM_ID_CASCO_OBRERO, ITEM_ID_BARRETA, ITEM_ID_LLAVE_DE_CRUZ, ITEM_ID_POT, ITEM_ID_FERTILIZER, 
	ITEM_ID_TACTIC_KNIFE, ITEM_ID_SLEDGEHAMMER, ITEM_ID_CHALECO_REFRACTARIO, ITEM_ID_SPRAYCAN, ITEM_ID_SPARE_TIRE, 0},
	
	//BIZ_CLUB2
	{ITEM_ID_AGUAMINERAL, ITEM_ID_CERVEZA, ITEM_ID_VINO, ITEM_ID_WHISKY, ITEM_ID_VODKA, ITEM_ID_ENCENDEDOR, 
	ITEM_ID_CIGARRILLOS, ITEM_ID_RON, ITEM_ID_BOTELLA_GASEOSA, ITEM_ID_LATA_GASEOSA, ITEM_ID_BOTELLA_FERNET,
	ITEM_ID_VASO_FERNET, ITEM_ID_BOTELLA_GANCIA, ITEM_ID_VASO_GANCIA, ITEM_ID_CHAMPAGNE, ITEM_ID_TEQUILA,
	ITEM_ID_LICOR, ITEM_ID_CAMPARI, ITEM_ID_RON_CALIDAD, ITEM_ID_WHISKY_CALIDAD, ITEM_ID_VODKA_CALIDAD,
	ITEM_ID_VINO_CALIDAD, ITEM_ID_CHAMPAGNE_CALIDAD, ITEM_ID_TEQUILA_CALIDAD, 0},
	
	//BIZ_PIZZERIA
	{ITEM_ID_PIZZA_LEGENDARIA, ITEM_ID_PIZZA_CANTIMPALO, ITEM_ID_PIZZA_MUZZARELLA, ITEM_ID_PIZZA_ESPECIAL, 
	ITEM_ID_P_PIZZA_HUEVO_ENS_PAPAS, ITEM_ID_P_PIZZA_MUZZA_ENS_PAPAS, ITEM_ID_P_PIZZA_ESPECIAL_PAPAS, 
	ITEM_ID_P_PIZZA_ROQUE_PAPAS, ITEM_ID_P_PIZZA_MUZZA_PAPAS, ITEM_ID_JUGO_NARANJA_CAJA, 
	ITEM_ID_JUGO_MANZANA_CAJA, ITEM_ID_ENSALADA_CESAR, ITEM_ID_ENSALADA_WALDORF, ITEM_ID_AGUAMINERAL, 
	ITEM_ID_CERVEZA, ITEM_ID_CAJA_DE_PIZZA_1, ITEM_ID_CAJA_DE_PIZZA_2, 0},
	
	//BIZ_BURGER1
	{ITEM_ID_HAMBURGUESA, ITEM_ID_JUGO_NARANJA_CAJA, ITEM_ID_JUGO_MANZANA_CAJA, ITEM_ID_ENSALADA_CESAR,
	ITEM_ID_ENSALADA_WALDORF, ITEM_ID_SANDWICH, ITEM_ID_AGUAMINERAL, ITEM_ID_POTE_HELADO, ITEM_ID_CAFE,
	ITEM_ID_MUFFINS, ITEM_ID_HAMB_COMBO_DELUXE, ITEM_ID_SAND_COMBO_DELUXE, 0},
	
	//BIZ_BURGER2
	{ITEM_ID_HAMBURGUESA, ITEM_ID_JUGO_NARANJA_CAJA, ITEM_ID_JUGO_MANZANA_CAJA, ITEM_ID_ENSALADA_CESAR,
	ITEM_ID_ENSALADA_WALDORF, ITEM_ID_SANDWICH, ITEM_ID_AGUAMINERAL, ITEM_ID_POTE_HELADO, ITEM_ID_CAFE, 
	ITEM_ID_MUFFINS, ITEM_ID_HAMB_COMBO_DELUXE, ITEM_ID_SAND_COMBO_DELUXE, 0},
	
	//BIZ_BELL
	{ITEM_ID_HAMBURGUESA, ITEM_ID_JUGO_NARANJA_CAJA, ITEM_ID_JUGO_MANZANA_CAJA, ITEM_ID_ENSALADA_CESAR,
	ITEM_ID_ENSALADA_WALDORF, ITEM_ID_PECHUGA_POLLO, ITEM_ID_MILANESA_Y_ENSALADA, ITEM_ID_CROQUETAS_RELLENAS,
	ITEM_ID_LANGOSTINOS_EMPANADOS, ITEM_ID_SANDWICH, ITEM_ID_AGUAMINERAL, ITEM_ID_HAMB_COMBO_DELUXE,
	ITEM_ID_SAND_COMBO_DELUXE, 0},

	//ACCESORIOS
	{ITEM_ID_SOMBRERO_COWBOY_NEGRO, ITEM_ID_SOMBRERO_COWBOY_MARRON, ITEM_ID_SOMBRERO_COWBOY_BORDO,
	ITEM_ID_RELOJ_SWATCH, ITEM_ID_RELOJ_ROLEX, ITEM_ID_RELOJ_CASIO, ITEM_ID_RELOJ_SWISSARMY,
	ITEM_ID_RELOJ_FESTINA, ITEM_ID_SOMBRERO_ANTIGUO, ITEM_ID_BIGOTE_FALSO1, ITEM_ID_BIGOTE_FALSO2,
	ITEM_ID_SOMBRERO_BLANCO, ITEM_ID_GORRO_ROJO, ITEM_ID_GORRO_ESTAMPADO, ITEM_ID_GORRO_NEGRO,
	ITEM_ID_GORRO_PLAYERO_NEGRO, ITEM_ID_GORRO_PLAYERO_CUADROS, ITEM_ID_GORRA_MILITAR,
	ITEM_ID_GORRA_GRIS_ESTAMPADA, ITEM_ID_GORRA_BLANCA_ESTAMPADA, ITEM_ID_ANTEOJO_DE_SOL,
	ITEM_ID_ANTEOJO_DEPORTIVO_NEGRO, ITEM_ID_ANTEOJO_DEPORTIVO_ROJO, ITEM_ID_ANTEOJO_DEPORTIVO_AZUL,
	ITEM_ID_ANTEOJO_RAYBAN_NEGRO,ITEM_ID_ANTEOJO_RAYBAN_AZUL,ITEM_ID_ANTEOJO_RAYBAN_VIOLETA,
	ITEM_ID_ANTEOJO_RAYBAN_ROSA,ITEM_ID_ANTEOJO_RAYBAN_ROJO,ITEM_ID_ANTEOJO_RAYBAN_NARANJA,
	ITEM_ID_ANTEOJO_RAYBAN_AMARILLO,ITEM_ID_ANTEOJO_RAYBAN_VERDE,ITEM_ID_GORRA_SIMPLE_NEGRA,
	ITEM_ID_GORRA_SIMPLE_AZUL, ITEM_ID_GORRA_SIMPLE_VERDE, ITEM_ID_TAPABOCA_1, ITEM_ID_TAPABOCA_2,
	ITEM_ID_TAPABOCA_3,	ITEM_ID_TAPABOCA_4,	ITEM_ID_TAPABOCA_5,	ITEM_ID_TAPABOCA_6,	ITEM_ID_TAPABOCA_7,
	ITEM_ID_TAPABOCA_8,	ITEM_ID_TAPABOCA_9,	ITEM_ID_TAPABOCA_10, ITEM_ID_PASAMONTANAS,
	ITEM_ID_MASCARA_TERROR_BLANCA, ITEM_ID_SOMBRERO_NEGRO, ITEM_ID_FAKE_HAIR, ITEM_ID_BANDANA1,
	ITEM_ID_BANDANA2, ITEM_ID_BANDANA3, ITEM_ID_BANDANA4, ITEM_ID_BANDANA5, ITEM_ID_BANDANA6, ITEM_ID_BANDANA7,
	ITEM_ID_BANDANA8, ITEM_ID_BANDANA9, ITEM_ID_BANDANA10, ITEM_ID_BANDANA11, ITEM_ID_BANDANA12,
	ITEM_ID_BANDANA13, ITEM_ID_BANDANA14, ITEM_ID_BANDANA15, ITEM_ID_BANDANA16, ITEM_ID_BANDANA17,
	ITEM_ID_BANDANA18, ITEM_ID_BANDANA19, ITEM_ID_BANDANA20, ITEM_ID_BOINA1, ITEM_ID_BOINA2, ITEM_ID_BOINA3,
	ITEM_ID_BOINA4, ITEM_ID_BOINA5, ITEM_ID_GORRA1, ITEM_ID_GORRA2, ITEM_ID_GORRA3, ITEM_ID_GORRA4,
	ITEM_ID_GORRA5, ITEM_ID_GORRA6, ITEM_ID_GORRA7, ITEM_ID_GORRA8, ITEM_ID_CASCO_CORTO1, ITEM_ID_CASCO_CORTO2,
	ITEM_ID_CASCO_CORTO3, ITEM_ID_SOMBRERO1, ITEM_ID_SOMBRERO2, ITEM_ID_SOMBRERO3, ITEM_ID_SOMBRERO4,
	ITEM_ID_SOMBRERO5, ITEM_ID_SOMBRERO6, ITEM_ID_SOMBRERO7, ITEM_ID_SOMBRERO8, ITEM_ID_SOMBRERO9,
	ITEM_ID_CASCO_BOXEO, ITEM_ID_GORRO_LANA1, ITEM_ID_GORRO_LANA2, ITEM_ID_GORRO_LANA3, ITEM_ID_GORRO_LANA4, 0},

	//BIZ_MECH
	{ITEM_ID_REPUESTOAUTO, ITEM_ID_WHEEL, ITEM_ID_TUNING_PART, ITEM_ID_SPARE_TIRE, 0}
};

new BizMaxAvailableItems[BIZ_TYPES_AMOUNT];

new BizItemOrderSelected[MAX_PLAYERS];

enum bCatalogInfo {
	bItemid, //id del item en la lista global de items, para referenciar
	bPrice, //precio asignado de venta del objeto en el negocio
	bStock //stock total del producto en el negoccio
}

new BusinessCatalog[MAX_BUSINESS][MAX_BIZ_LISTITEM][bCatalogInfo];
static const BusinessCatalogInfoReset[bCatalogInfo] = {0, 0, 0};

forward GetBizItemPrice(biz, slot); //devuelve el precio asignado del item en el negocio indicado
forward GetBizItemStock(biz, slot); //devuelve el stock disponible del item en el negocio indicado
forward GetListItemid(type, index);
forward GetBizItemIndex(biz, item); //devuelve la posición del objeto en la lista de productos. -1 si no existe
forward GetBusinessType(biz); //devuelve el tipo de negocio

hook OnGameModeInitEnded() 
{
	LoadAllBusinessStocks();
	Biz_GetMaxAvailableItems();
	return 1;
}

stock GetBizItemIndex(biz, item)
{
	for(new i = 0; i < MAX_BIZ_LISTITEM; i++)
	{
	    if(item == BusinessCatalog[biz][i][bItemid])
	        return i;
	}
	return -1;
}

stock GetBizItemPrice(biz, slot)
{
	return BusinessCatalog[biz][slot][bPrice];
}

stock GetBizItemStock(biz, slot)
{
	return BusinessCatalog[biz][slot][bStock];
}

stock GetListItemid(type, index)
{
 	return BizTypeAvailableItems[type][index];
}

stock GetBusinessType(biz)
{
	return Business[biz][bType];
}

BizStock_GetUnitCostPrice(itemid) {
	return floatround(float(ItemModel_GetPrice(itemid)) * (1 - BIZ_COST_UNIT_DISCOUNT) , floatround_ceil);
}

stock GetBizCantOfItems(biz)
{
	new cant = 0;
	for(new i = 0; i < MAX_BIZ_LISTITEM; i++)
	{
	    if(BusinessCatalog[biz][i][bItemid] != 0)
	        cant++;
	}
	return cant;
}

LoadAllBusinessStocks()
{
    mysql_tquery(MYSQL_HANDLE, "SELECT * FROM `business_stock` ORDER BY `businessid` ASC;", "OnBusinessStockLoad");
    print("[INFO] Cargando stock de negocios...");
}

forward OnBusinessStockLoad();
public OnBusinessStockLoad()
{
    new rows = cache_num_rows();

    for(new i = 0, auxid = 0, businessid = 0, index = 0; i < rows; i++, index++)
    {
        cache_get_value_name_int(i, "businessid", businessid);

        if(auxid != businessid)
        {
            auxid = businessid;
            index = 0;
        }

        cache_get_value_name_int(i, "stock", BusinessCatalog[businessid][index][bStock]);
        cache_get_value_name_int(i, "itemid", BusinessCatalog[businessid][index][bItemid]);
        cache_get_value_name_int(i, "price", BusinessCatalog[businessid][index][bPrice]);
    }

    printf("[INFO] Finalizó la carga de %i registros de stock en negocios.", rows);
    return 1;
}

Biz_GetMaxAvailableItems()
{
	for (new i = 1; i < BIZ_TYPES_AMOUNT; i++ )
	{
		for (new j = 0; BizTypeAvailableItems[i][j] != 0; j++)
		{
			BizMaxAvailableItems[i]++;
		}
	}
}

Biz_NewSQLItemStock(businessid, index)
{
    new query[128];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO business_stock (businessid,itemid,stock,price) values (%i,%i,%i,%i)",
        businessid,
        BusinessCatalog[businessid][index][bItemid],
        BusinessCatalog[businessid][index][bStock],
        BusinessCatalog[businessid][index][bPrice]
    );
    mysql_tquery(MYSQL_HANDLE, query);
}

Biz_UpdateSQLItemStock(businessid, index)
{
    new query[128];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE business_stock SET stock=%i,price=%i WHERE businessid=%i AND itemid=%i",
		BusinessCatalog[businessid][index][bStock],
		BusinessCatalog[businessid][index][bPrice],
		businessid,
		BusinessCatalog[businessid][index][bItemid]
	);
    mysql_tquery(MYSQL_HANDLE, query);
}

Biz_DeleteSQLItemStock(businessid, index)
{
    new query[128];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM business_stock WHERE businessid=%i AND itemid=%i",
        businessid,
        BusinessCatalog[businessid][index][bItemid]
    );
    mysql_tquery(MYSQL_HANDLE, query);
}

Biz_ResetSQLItemsStock(businessid)
{
    new query[64];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM business_stock WHERE businessid=%i",
        businessid
    );
    mysql_tquery(MYSQL_HANDLE, query);
}

stock AddItemCatalog(playerid, bizID, item)
{
	if(GetBizItemIndex(bizID, item) != -1) //si el objeto ya existe a la venta en este negocio
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este item ya se encuentra a la venta en el negocio");

	new i = 0;

	while(i < MAX_BIZ_LISTITEM && BusinessCatalog[bizID][i][bItemid] != 0) { //buscamos un lugar vacío en la lista
	    i++;
	}

	if(i >= MAX_BIZ_LISTITEM || BusinessCatalog[bizID][i][bItemid] != 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La lista de productos en venta está completa, no puedes agregar nada más");

	BusinessCatalog[bizID][i][bItemid] = item;
	BusinessCatalog[bizID][i][bPrice] = ItemModel_GetPrice(item);
	BusinessCatalog[bizID][i][bStock] = 0;
	Biz_NewSQLItemStock(bizID, i);
	SendFMessage(playerid, COLOR_WHITE, "{44FF44}%s {FFFFFF}fue agregado correctamente a la venta en el negocio.", ItemModel_GetName(item));
	return 1;
}

stock DeleteItemCatalog(playerid, bizID, slot)
{
	if(BusinessCatalog[bizID][slot][bItemid] == 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ningun objeto a la venta en ese slot");

	//Borramos el objeto en la lista
	Biz_DeleteSQLItemStock(bizID, slot);
	BusinessCatalog[bizID][slot] = BusinessCatalogInfoReset;
	
	//Desde el último elemento, buscamos un item para ordenar
	for(new i = MAX_BIZ_LISTITEM - 1; i >= slot; i--)
	{
	    if(BusinessCatalog[bizID][i][bItemid] != 0)
		{
			BusinessCatalog[bizID][slot][bItemid] = BusinessCatalog[bizID][i][bItemid];
			BusinessCatalog[bizID][slot][bPrice] = BusinessCatalog[bizID][i][bPrice];
			BusinessCatalog[bizID][slot][bStock] = BusinessCatalog[bizID][i][bStock];
			BusinessCatalog[bizID][i] = BusinessCatalogInfoReset;
			return 1;
		}
	}
	return 1;
}

ShowDialogBizInfo(playerid, bizid)
{
	new str[512];

	format(str, sizeof(str), "\
		Estado\t%s\n\
		Valuación fiscal\t$%i\n\
		Impuestos por día\t$%i\n\
		Propietario\t%s\n\
		Dinero en caja\t%s%i\n\
		Valor de entrada\t$%i\n\
		Radio en el local\t%i\n\
		Clientes atendidos\t%i\n\
		Clientes insatisfechos\t%i\n",
		(Business[bizid][bLocked]) ? ("{FF3333}Cerrado") : ("{33FF33}Abierto"),
		Business[bizid][bPrice],
		Biz_GetTaxes(bizid),
		Business[bizid][bOwner],
		(Business[bizid][bTill] >= 0) ? ("{33ff33}$") : ("{ff3333}-$"),
		(Business[bizid][bTill] >= 0) ? (Business[bizid][bTill]) : (-Business[bizid][bTill]),
		Business[bizid][bEntranceFee],
		Business[bizid][bRadio],
		BizClientCount[bizid],
		BizUnhappyClients[bizid]
	);

	Dialog_Open(playerid, "DLG_BizOrder_ShowMain", DIALOG_STYLE_TABLIST, Business[bizid][bName], str, "Volver", "");
	return 1;
}

Biz_ResetItemsStock(bizid)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	for(new i = 0; i < MAX_BIZ_LISTITEM; i++) {
		BusinessCatalog[bizid][i] = BusinessCatalogInfoReset; // Ojo, solo para la ultima dimension es válida esta asignacion en arrays.
	}

	Biz_ResetSQLItemsStock(bizid);
	return 1;
}

Biz_UpdateItemStock(bizid, index, cant) 
{
	if(!Biz_IsValidId(bizid))
		return 0;

	BusinessCatalog[bizid][index][bStock] = cant;
	return 1;
}

Biz_SetAllRandomItemsStock(stockToSet)
{
	if(!(0 <= stockToSet <= MAX_RANDOM_ITEM_STOCK))
		return 0;

	new auxVec = vector_create();

	for(new i = 1; i < MAX_BUSINESS; i++) {
		Biz_SetRandomItemsStock(i, stockToSet, .forceIfOwned = false, .useReceivedVector = auxVec);
	}

	return 1;
}

Biz_SetRandomItemsStock(bizid, stockToSet, forceIfOwned = true, useReceivedVector = 0)
{
	if(!Biz_IsValidId(bizid) || !(0 <= stockToSet <= MAX_RANDOM_ITEM_STOCK) || (!forceIfOwned && Business[bizid][bOwnerSQLID] != -1))
		return 0;

	Biz_ResetSQLItemsStock(bizid);

	new auxVec = (useReceivedVector) ? (useReceivedVector) : (vector_create());

	for(new i = 0, bizType = GetBusinessType(bizid); BizTypeAvailableItems[bizType][i] != 0; i++) {
		vector_push_back(auxVec, BizTypeAvailableItems[bizType][i]); // Cargo todos los modelos de items disponibles para cargar que correspondan a ese tipo de negocio
	}

	for(new i = 0, index, item, size = vector_size(auxVec); i < MAX_BIZ_LISTITEM; i++, size--)
	{
		if(size > 0) // Todavía tengo modelos de items disponibles para cargar
		{
			index = random(size);
			item = vector_get(auxVec, index);
			BusinessCatalog[bizid][i][bItemid] = item;
			BusinessCatalog[bizid][i][bStock] = stockToSet;
			BusinessCatalog[bizid][i][bPrice] = ItemModel_GetPrice(item);
			Biz_NewSQLItemStock(bizid, i);
			vector_remove(auxVec, index);
		} else {
			BusinessCatalog[bizid][i] = BusinessCatalogInfoReset;
		}
	}

	vector_clear(auxVec);
	return 1;
}

CMD:anrandomstock(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 8 || level == 9 || level == 12 || level == 13 || level == 16 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new bizid, stockToSet;

	if(sscanf(params, "ii", bizid, stockToSet))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anrandomstock [ID negocio] [stock]. Nota: se borrarán los items y stock actual, aun si tiene dueño.");

	if(Biz_SetRandomItemsStock(bizid, stockToSet)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se han seteados correctamente items aleatorios con un stock de %i para el negocio %i.", stockToSet, bizid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio o cantidad de stock inválida.");
	}
	return 1;
}

CMD:anrandomstockall(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso máximo a Property Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 16 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	if(PlayerInfo[playerid][pAdmin] <= 20) // Es un comando pesado, solo debería ejecutarse si realmente es considerado necesario por alguien que sepa, y en horario de poca concurrencia
		return 1;

	new stockToSet;

	if(sscanf(params, "i", stockToSet))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anrandomstockall [stock]. Nota: se borrarán los items y stock actual, excepto de los que tienen dueño.");

	if(Biz_SetAllRandomItemsStock(stockToSet)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se han seteados correctamente items aleatorios con un stock de %i para todos los negocios en el servidor.", stockToSet);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Cantidad de stock inválida.");
	}
	return 1;
}

ShowDialogPutBizAvailableItems(playerid, bizid)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	new bizType = GetBusinessType(bizid);
	stravitems = "Item\tPrecio base\n";

	for(new i = 0, lineStr[80]; BizTypeAvailableItems[bizType][i] != 0; i++)
	{
		format(lineStr, sizeof(lineStr), "%s\t$%d\n", ItemModel_GetName(BizTypeAvailableItems[bizType][i]), ItemModel_GetPrice(BizTypeAvailableItems[bizType][i]));
		strcat(stravitems, lineStr, sizeof(stravitems));
	}

	Dialog_Show(playerid, Put_Biz_Item, DIALOG_STYLE_TABLIST_HEADERS, "Elige el producto que quieres agregar al negocio", stravitems, "Continuar", "Volver");
	return 1;
}

Dialog:Put_Biz_Item(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return cmd_negociogestionar(playerid, "");

	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	new bizType = GetBusinessType(bizid);
	AddItemCatalog(playerid, bizid, GetListItemid(bizType, listitem));

	return cmd_negociogestionar(playerid, "");
}

Dialog:Delete_Biz_Item(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return cmd_negociogestionar(playerid, "");

	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	DeleteItemCatalog(playerid, bizid, listitem);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El item fue borrado correctamente");
	
	return cmd_negociogestionar(playerid, "");
}

AutoSalesForBusiness(biz)
{
	if(!Biz_IsValidId(biz))
		return 0;

	new itemsOnSaleAmount = GetBizCantOfItems(biz);
	new maxItems = (MAX_BIZ_LISTITEM <= BizMaxAvailableItems[Business[biz][bType]]) ? (MAX_BIZ_LISTITEM) : (BizMaxAvailableItems[Business[biz][bType]]);
	
	if(itemsOnSaleAmount < maxItems)
		return 0;

	// % del valor del negocio como maximo permitido para ganar por PayDay (ganancia = venta - costo)
	new maxPaydayEarnings;

	if(Business[biz][bType] != BIZ_MECH) {
		maxPaydayEarnings = floatround(Business[biz][bPrice] * BIZ_MAX_PAYDAY_EARNING_PERCENT);
	} else {
		maxPaydayEarnings = floatround(Business[biz][bPrice] * BIZ_MAX_PAYDAY_EARNING_PERCENT / 4); // 2.5 % en lugar de 10 % 
	} 

	maxPaydayEarnings = (maxPaydayEarnings > BIZ_MAX_PAYDAY_EARNING_ABSOLUTE) ? (BIZ_MAX_PAYDAY_EARNING_ABSOLUTE) : (maxPaydayEarnings);
	new currentEarnings, index;
	new clientsAmount = (itemsOnSaleAmount * 10) + random(itemsOnSaleAmount * 10 / 2); // numero de posibles ventas: 10 por c/ item a la venta, mas un random del total de 5 por cada item

	for(new i = 0; i < clientsAmount && currentEarnings < maxPaydayEarnings; i++)
	{
		index = random(itemsOnSaleAmount);

		if(BusinessCatalog[biz][index][bItemid])
		{
			BizClientCount[biz]++;

			if(GetBizItemStock(biz, index) > 0)
			{
				BusinessCatalog[biz][index][bStock]--;
				Biz_UpdateSQLItemStock(biz, index);
				BizPayCheck[biz] += GetBizItemPrice(biz, index);
				currentEarnings += GetBizItemPrice(biz, index) - BizStock_GetUnitCostPrice(BusinessCatalog[biz][index][bItemid]);				
			} else {
				BizUnhappyClients[biz]++;
			}
		}
	}
	return 1;
}

hook KeyChain_OnInit()
{
	KeyChain_SetKeyTypeData(
		.type = KEY_TYPE_BUSINESS,
		.typeName = "Negocio",
		.logType = LOG_TYPE_ID_NONE,
		.onPaydayAddr = GetPublicAddressFromName("Biz_OnPlayerPayday"),
		.onNameChangeAddr = GetPublicAddressFromName("Biz_OnPlayerNameChange"),
		.onCopyCheckAddr = 0
	);
	return 1;
}

forward Biz_OnPlayerNameChange(bizid, playerid, const name[]);
public Biz_OnPlayerNameChange(bizid, playerid, const name[]) {
	return Biz_SetOwnerName(bizid, name);
}

forward Biz_OnPlayerPayday(bizid, playerid, &income, &tax);
public Biz_OnPlayerPayday(bizid, playerid, &income, &tax)
{
	static delay; // delay to prevent heavy Biz_Payday stacking when player has many business

	delay += 40;

	if(delay > 40 * KeyChain_GetOccupiedSlots(playerid)) {
		delay = 40;
	}

	SetTimerEx("Biz_Payday", delay, false, "ii", bizid, playerid);
}

forward Biz_Payday(bizid, playerid);
// Client bonus thresholds and rewards
static const BizBonusThresholds[] = {5, 10, 15, 20, 25, 30, 40};
static const BizBonusRewards[]    = {3000, 8000, 17000, 35000, 40000, 45000, 70000};

stock BizBonus_CheckThresholds(bizid)
{
	if(!Biz_IsValidId(bizid)) return;
	new level = BizBonusLevel[bizid];
	new maxLevel = sizeof(BizBonusThresholds);
	while(level < maxLevel && BizClientCount[bizid] >= BizBonusThresholds[level])
	{
		new bonus = BizBonusRewards[level];
		Biz_AddTill(bizid, bonus);
		BizBonusLevel[bizid]++;
		level++;

		// Notify all employees and owner via CN format
		new msg[192];
		format(msg, sizeof(msg), "{FFAA00}[NEGOCIO]{FFFFFF} ¡El negocio %s alcanzó %i clientes y recibió un bono de $%i!", Business[bizid][bName], BizBonusThresholds[level-1], bonus);
		foreach(new id : Player)
		{
			if(BizEmp_IsEmployee(id, bizid) || Biz_IsPlayerOwner(id, bizid))
				SendClientMessage(id, -1, msg);
		}
	}
}

public Biz_Payday(bizid, playerid)
{
	if(!IsPlayerLogged(playerid) || !Biz_IsPlayerOwner(playerid, bizid))
		return 0;

	BizPayCheck[bizid] = 0;
	BizClientCount[bizid] = 0;
	BizBonusLevel[bizid] = 0;
	BizUnhappyClients[bizid] = 0;

	new bizTax = Biz_GetTaxes(bizid), string[256];
	new sfl_log[128];
	Faction_GiveMoney(FAC_GOB, bizTax); // Gobierno recibe los impuestos

	if(Business[bizid][bLocked] == 0)
	{
		AutoSalesForBusiness(bizid);
		BizBonus_CheckThresholds(bizid);
		Biz_AddTill(bizid, BizPayCheck[bizid] - bizTax);
		format(string, sizeof(string), " \n"COLOR_EMB_USAGE"[%s]\nVentas: $%i - Impuestos: $-%i - Clientes: %i (%i insatisfechos).\nCaja anterior: $%i - Caja actual: $%i.\n", Business[bizid][bName], BizPayCheck[bizid], bizTax, BizClientCount[bizid], BizUnhappyClients[bizid], Business[bizid][bTill] - BizPayCheck[bizid] + bizTax, Business[bizid][bTill]);
		Payday_AddStatementDeferedInfo(playerid, string);

		// Log business payday (store business name and net received)
		new netReceived = BizPayCheck[bizid] - bizTax;
		format(sfl_log, sizeof(sfl_log), "%s: $%d", Business[bizid][bName], netReceived);
		ServerLog(LOG_TYPE_ID_MONEY, .entry="PAYDAY NEGOCIO", .playerid=playerid, .params=sfl_log);
	} else {
		Biz_AddTill(bizid, -bizTax);
		format(string, sizeof(string), " \n"COLOR_EMB_USAGE"[%s]\nCaja: $%i. Tu negocio estuvo cerrado y Sólo se pagaron impuestos por $%i.\n", Business[bizid][bName], Business[bizid][bTill], bizTax);
		Payday_AddStatementDeferedInfo(playerid, string);

		// Log business payday when closed (net received = 0)
		format(sfl_log, sizeof(sfl_log), "%s: $%d", Business[bizid][bName], 0);
		ServerLog(LOG_TYPE_ID_MONEY, .entry="PAYDAY NEGOCIO", .playerid=playerid, .params=sfl_log);
	}
	return 1;
}

ShowDialogBizStock(playerid, bizid, useBothButtons, const title[] = "_", const onResponse[] = "DLG_NO_RESPONSE")
{
	if(BusinessCatalog[bizid][0][bItemid] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El negocio no tiene ningún producto.");

    new string[512] = "Item\tStock\tPrecio de venta\n";

	for(new i = 0, lineStr[80]; i < MAX_BIZ_LISTITEM && BusinessCatalog[bizid][i][bItemid] != 0; i++)
	{
	    format(lineStr, sizeof(lineStr), "%s\t%i\t%i\n", ItemModel_GetName(BusinessCatalog[bizid][i][bItemid]), GetBizItemStock(bizid, i), GetBizItemPrice(bizid, i));
	    strcat(string, lineStr, sizeof(string));
	}

	if(useBothButtons) {
		Dialog_Open(playerid, onResponse, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Continuar", "Volver");
	} else {
		Dialog_Open(playerid, onResponse, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Volver", "");
	}
	return 1;
}

ShowDialogBizOrderShow(playerid, biz)
{
	if(!BizOrder_ShowList(playerid, .allowInteraction = false, .filterBiz = biz, .onResponse = "DLG_BizOrder_ShowMain"))
	{
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay pedidos efectuados pendientes.");
		cmd_negociogestionar(playerid, "");
	}
}

Dialog:DLG_BizOrder_ShowMain(playerid, response, listitem, inputtext[]) {
	return cmd_negociogestionar(playerid, "");
}

Dialog:Order_Stock_Item_Step1(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return cmd_negociogestionar(playerid, "");

	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	new item = BusinessCatalog[bizid][listitem][bItemid];
	
	if(GetBizItemStock(bizid, listitem) >= MAX_ITEM_STOCK)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El producto seleccionado ya tiene suficiente stock");
		return cmd_negociogestionar(playerid, "");
	}

	new str[128];
	new stockUnitValue = floatround(float(ItemModel_GetPrice(item)) * 0.6, floatround_ceil);
	
	format(str, sizeof(str), "Producto: %s\nStock Actual: %d\nPrecio de stock por unidad: $%d\nmáximoque puede pedir: %d",
	ItemModel_GetName(item), GetBizItemStock(bizid, listitem), stockUnitValue, MAX_ITEM_STOCK - GetBizItemStock(bizid, listitem) );
    BizItemOrderSelected[playerid] = item;
	Dialog_Show(playerid, Order_Stock_Item_Step2, DIALOG_STYLE_INPUT, "¿Cuánto stock quiere pedir?", str, "Continuar", "Regresar");
	return 1;
}

Dialog:Order_Stock_Item_Step2(playerid, response, listitem, inputtext[])
{
	new item = BizItemOrderSelected[playerid];
	BizItemOrderSelected[playerid] = -1;

    if(!response)
	    return cmd_negociogestionar(playerid, "");
	if(strval(inputtext) < 1)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresaste un número/carácter inválido");
		return cmd_negociogestionar(playerid, "");
	}

	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	new cant = strval(inputtext);
	new index = GetBizItemIndex(bizid, item);

	if(index == -1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ha ocurrido un error al pedir los productos");

	if( (cant + GetBizItemStock(bizid, index) ) > MAX_ITEM_STOCK)
	{	
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La sumatoria de tu pedido mas lo que ya tienes en stock no puede superar las %i unidades", MAX_ITEM_STOCK);
	    return 1;
	}
	
	PO_CreateOrder(1, bizid, item, cant); // 1= ORDER_TYPE_REAL
	new totalPrice = (floatround(float(ItemModel_GetPrice(item)) * 0.6, floatround_ceil)) * cant;
	SendFMessage(playerid, COLOR_WHITE, "Has pedido {FF5555}%i{FFFFFF} unidades de {FF5555}%s{FFFFFF} por un total de {22FF22}$%i", cant, ItemModel_GetName(item), totalPrice);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Este llegara cuando algun transportista haga la entrega, esto puede tardar algunas horas.");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Cuando el pedido llegue, si no hay suficiente dinero en la caja no se entregara, y te ganarás la bronca del transportista.");
	return cmd_negociogestionar(playerid, "");
}

Dialog:Edit_Price_Step1(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return cmd_negociogestionar(playerid,"");

	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	new item = BusinessCatalog[bizid][listitem][bItemid];
	new str[128];
	BizItemOrderSelected[playerid] = item;
	format(str, sizeof(str), "Producto: %s\nPrecio Actual: %d\nmáximoPermitido: %d\nMínimo Permitido: %d", ItemModel_GetName(item), GetBizItemPrice(bizid, listitem), ItemModel_GetPrice(item) + floatround(float(ItemModel_GetPrice(item)) * 0.3, floatround_ceil), ItemModel_GetPrice(item) - floatround(float(ItemModel_GetPrice(item)) * 0.5, floatround_ceil));
	Dialog_Show(playerid, Edit_Price_Step2, DIALOG_STYLE_INPUT, "Escriba el nuevo precio", str, "Aceptar", "Regresar");
	return 1;
}

Dialog:Edit_Price_Step2(playerid, response, listitem, inputtext[])
{
	new item = BizItemOrderSelected[playerid];
	BizItemOrderSelected[playerid] = -1;

	if(!response)
	    return cmd_negociogestionar(playerid, "");
    if(strval(inputtext) < 1)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresaste un número/carácter inválido");
		return cmd_negociogestionar(playerid, "");
	}

	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	new price = strval(inputtext);
	new index = GetBizItemIndex(bizid, item);

	if(index == -1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ha ocurrido un error al editar el precio");

	new maxPrice = ItemModel_GetPrice(item) + floatround(float(ItemModel_GetPrice(item)) * 0.3, floatround_ceil);
	new minPrice = ItemModel_GetPrice(item) - floatround(float(ItemModel_GetPrice(item)) * 0.5, floatround_ceil);

	if( (price > maxPrice) || (price < minPrice) )
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes superar el mínimo o máximo permitido!");

	BusinessCatalog[bizid][index][bPrice] = price;
	Biz_UpdateSQLItemStock(bizid, index);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Precio modificado!");

	return cmd_negociogestionar(playerid, "");
}

CMD:negociogestionar(playerid, params[])
{
	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	Dialog_Show(playerid, Gestion_Biz, DIALOG_STYLE_LIST, "¿Qué quieres hacer con tu negocio?",
		"Ver informacion general\n\
		Agregar item a la venta\n\
		Borrar item en venta\n\
		Consultar stock\n\
		Consultar pedidos\n\
		Pedir mercaderia\n\
		Editar precio de item",
		"Aceptar", "Cerrar"
	);
	return 1;
}

ShowDialogDeleteBizItem(playerid, bizid)
{
	ShowDialogBizStock(playerid, bizid, .useBothButtons = true, .title = "Elige el ítem que quieres borrar", .onResponse = "Delete_Biz_Item");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Recuerda que al borrar un item a la venta, perderás todo el stock disponible.");
}

Dialog:Gestion_Biz(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una llave de este negocio.");

	switch(listitem)
	{
		case 0: ShowDialogBizInfo(playerid, bizid);
		case 1: ShowDialogPutBizAvailableItems(playerid, bizid);
		case 2: ShowDialogDeleteBizItem(playerid, bizid);
		case 3: ShowDialogBizStock(playerid, bizid, .useBothButtons = false, .title = "Stock del negocio", .onResponse = "DLG_BizOrder_ShowMain");
		case 4: ShowDialogBizOrderShow(playerid, bizid);
		case 5: ShowDialogBizStock(playerid, bizid, .useBothButtons = true, .title = "Seleccione el ítem", .onResponse = "Order_Stock_Item_Step1");
		case 6: ShowDialogBizStock(playerid, bizid, .useBothButtons = true, .title = "Seleccione el ítem", .onResponse = "Edit_Price_Step1");
	}
	return 1;
}

CMD:anstock(playerid,params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 8 || level == 9 || level == 12 || level == 13 || level == 16 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new biz, index, cant;

	if(sscanf(params, "iii", biz, index, cant))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anstock [idnegocio] [index] [cantidad]");
	if(!Biz_IsValidId(biz))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	if(index < 0 || index >= MAX_BIZ_LISTITEM || !BusinessCatalog[biz][index][bItemid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Index inválido.");

	SendFMessage(playerid, COLOR_WHITE, "%s - Stock anterior: %i - Stock actual: %i", ItemModel_GetName(BusinessCatalog[biz][index][bItemid]), BusinessCatalog[biz][index][bStock], cant);
	BusinessCatalog[biz][index][bStock] = cant;
	Biz_UpdateSQLItemStock(biz, index);
	return 1;
}

CMD:anitem(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Property Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 8 || level == 9 || level == 12 || level == 13 || level == 16 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Property Control para utilizar este comando.");
	
	new biz, item;

	if(sscanf(params, "ii", biz, item))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anitem [idnegocio] [item]");
	if(!Biz_IsValidId(biz))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de negocio inválida.");
	if(!ItemModel_IsValidId(item))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Item inválido.");

	AddItemCatalog(playerid, biz, item);
	return 1;
}