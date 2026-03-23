/* old implementation removed */

#if defined _marp_black_market_included
    #endinput
#endif
#define _marp_black_market_included

#include <YSI_Coding\y_hooks>

// ================== CONFIG ==================
#define BM_MAX_LOCATIONS        (64)    // Máximo de ubicaciones que cacheamos
#define BM_NEAR_DELETE_RADIUS   (3.0)   // Radio para borrar el pickup más cercano

// BM_PICKUP_MODEL removed (unused)
static const Float:BM_BUY_PERCENTAGE = 1.5;
static const Float:BM_SELL_PERCENTAGE = 0.5;
static const BM_MAX_BUY_AMOUNT = 10;


// Usa el handle global del GM


// ================== STORAGE ==================
enum e_BLACK_MARKET_INFO {
    bmID,                                   // id en la DB
    STREAMER_TAG_PICKUP:blackmarketPickup,  // id de pickup streamer
    Float:blackmarketX,
    Float:blackmarketY,
    Float:blackmarketZ,
    blackmarketActor                        // actor id (NPC) asociado a la ubicación
};
new BlackMarket_Info[BM_MAX_LOCATIONS][e_BLACK_MARKET_INFO];
new BM_LocationCount;

// Items que vende/compra el BM (usa tu systema de items)
static BlackMarket_Items[] = {
    ITEM_ID_BARRETA,
    ITEM_ID_WEED_SEEDS,
    ITEM_ID_FACA_TUMBERA,
    ITEM_ID_CHEF_KNIFE,
    ITEM_ID_SPRAYCAN
};

static BlackMarket_Item[MAX_PLAYERS];
static BlackMarket_Dialog[4096];

// ================== HOOKS ==================
hook function LoadPickups()
{
    // Crear los pickups que ya tengamos cacheados
    for(new i = 0; i < BM_LocationCount; i++)
    {
        // Create an NPC (actor) at each cached black market location instead of a pickup icon
        if(!IsValidActor(BlackMarket_Info[i][blackmarketActor]))
        {
            // default skin for vendor NPC (force preferred skin)
            new vendorSkin = 28;
            new Float:angle = 0.0;
            BlackMarket_Info[i][blackmarketActor] = Actor_New(vendorSkin,
                BlackMarket_Info[i][blackmarketX],
                BlackMarket_Info[i][blackmarketY],
                BlackMarket_Info[i][blackmarketZ],
                angle,
                0, 0
            );
            if(IsValidActor(BlackMarket_Info[i][blackmarketActor])) {
                Actor_SetNickname(BlackMarket_Info[i][blackmarketActor], "El Rúcula - /comprar /vender", false);
                Actor_SetDescription(BlackMarket_Info[i][blackmarketActor], "Usa /comprar para ver items disponibles.", false);
            }
        }
    }
    return continue();
}

hook LoadAccountDataEnded(playerid)
{
    BlackMarket_Item[playerid] = -1;
    // No special initialization required for magazines or Rossi anymore.
    return 1;
}

// ================== UTIL ==================
stock bool:BlackMarket_IsPlayerAt(playerid)
{
    for(new i = 0; i < BM_LocationCount; i++)
    {
        if(IsPlayerInRangeOfPoint(
            playerid, 1.4,
            BlackMarket_Info[i][blackmarketX],
            BlackMarket_Info[i][blackmarketY],
            BlackMarket_Info[i][blackmarketZ]
        )) return true;
    }
    return false;
}

stock bool:IsBlackMarketPickup(pickupid)
{
    for(new i = 0; i < BM_LocationCount; i++)
    {
        if(pickupid == BlackMarket_Info[i][blackmarketPickup])
            return true;
    }
    return false;
}

stock BlackMarket_DestroyAllPickups()
{
    for(new i = 0; i < BM_LocationCount; i++)
    {
        if(IsValidDynamicPickup(BlackMarket_Info[i][blackmarketPickup]))
        {
            DestroyDynamicPickup(BlackMarket_Info[i][blackmarketPickup]);
            BlackMarket_Info[i][blackmarketPickup] = STREAMER_TAG_PICKUP:0;
        }
        if(IsValidActor(BlackMarket_Info[i][blackmarketActor]))
        {
            Actor_Delete(BlackMarket_Info[i][blackmarketActor]);
            BlackMarket_Info[i][blackmarketActor] = 0;
        }
    }
    return 1;
}

// ================== CARGA DESDE MYSQL ==================
BlackMarket_LoadLocations()
{
    // Destruir pickups anteriores y limpiar el cache
    BlackMarket_DestroyAllPickups();
    BM_LocationCount = 0;

    // Cargar desde DB (asincrónico)
    mysql_tquery(MYSQL_HANDLE,
        "SELECT id, x, y, z FROM black_market_locations ORDER BY id ASC",
        "OnBlackMarketLocationsLoaded"
    );

    printf("[BM] Carga de ubicaciones de mercado negro");
    return 1;
}

forward OnBlackMarketLocationsLoaded();
public OnBlackMarketLocationsLoaded()
{
    BM_LocationCount = 0;

    new rows = cache_num_rows();
    if(rows > 0)
    {
        if(rows > BM_MAX_LOCATIONS) rows = BM_MAX_LOCATIONS;

        for(new i = 0; i < rows; i++)
        {
            cache_get_value_name_int  (i, "id", BlackMarket_Info[i][bmID]);
            cache_get_value_name_float(i, "x",  BlackMarket_Info[i][blackmarketX]);
            cache_get_value_name_float(i, "y",  BlackMarket_Info[i][blackmarketY]);
            cache_get_value_name_float(i, "z",  BlackMarket_Info[i][blackmarketZ]);

            // Create an NPC (actor) at this black market location
            BlackMarket_Info[i][blackmarketActor] = 0;
            new vendorSkin = 28;
            new Float:angle = 0.0;
            BlackMarket_Info[i][blackmarketActor] = Actor_New(vendorSkin,
                BlackMarket_Info[i][blackmarketX],
                BlackMarket_Info[i][blackmarketY],
                BlackMarket_Info[i][blackmarketZ],
                angle,
                0, 0
            );
            if(IsValidActor(BlackMarket_Info[i][blackmarketActor])) {
                Actor_SetNickname(BlackMarket_Info[i][blackmarketActor], "El Rúcula - /comprar /vender", false);
                Actor_SetDescription(BlackMarket_Info[i][blackmarketActor], "Usa /comprar para ver items disponibles.", false);
            }

            BM_LocationCount++;
        }
    }

    printf("[BM] Cargadas %d ubicaciones de mercado negro.", BM_LocationCount);
    return 1;
}

// ================== COMANDOS ADMIN ==================
CMD:bmreload(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    BlackMarket_LoadLocations();
    SendClientMessage(playerid, -1, "[BM] Ubicaciones recargadas desde la base de datos.");
    return 1;
}

CMD:setbm(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    if(BM_LocationCount >= BM_MAX_LOCATIONS)
    return SendClientMessage(playerid, -1, "Límite de ubicaciones alcanzado (ampliá BM_MAX_LOCATIONS).");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new q[256];
    // Recomendado %f para floats, y usamos mysql_format para seguridad
    mysql_format(MYSQL_HANDLE, q, sizeof(q),
        "INSERT INTO `black_market_locations` (`x`,`y`,`z`) VALUES (%f,%f,%f);",
        x, y, z
    );
    mysql_tquery(MYSQL_HANDLE, q);
    // Create NPC immediately in-memory (will be resynced on next reload)
    if (BM_LocationCount < BM_MAX_LOCATIONS) {
        BlackMarket_Info[BM_LocationCount][bmID] = 0; // will be filled by DB on reload
        BlackMarket_Info[BM_LocationCount][blackmarketPickup] = STREAMER_TAG_PICKUP:0;
        BlackMarket_Info[BM_LocationCount][blackmarketX] = x;
        BlackMarket_Info[BM_LocationCount][blackmarketY] = y;
        BlackMarket_Info[BM_LocationCount][blackmarketZ] = z;
        new vendorSkin = 28; // requested skin
        new Float:angle = 0.0;
        BlackMarket_Info[BM_LocationCount][blackmarketActor] = Actor_New(vendorSkin, x, y, z, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
        if (IsValidActor(BlackMarket_Info[BM_LocationCount][blackmarketActor])) {
            Actor_SetNickname(BlackMarket_Info[BM_LocationCount][blackmarketActor], "El Rúcula - /comprar /vender", false);
            Actor_SetDescription(BlackMarket_Info[BM_LocationCount][blackmarketActor], "Usa /comprar para ver items disponibles.", false);
        } else {
            BlackMarket_Info[BM_LocationCount][blackmarketActor] = 0;
        }
        BM_LocationCount++;
    }

    SendClientMessage(playerid, -1, "[BM] NPC de mercado negro agregado y guardado en la base de datos.");
    return 1;
}

CMD:delbm(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    if(BM_LocationCount == 0)
        return SendClientMessage(playerid, -1, "[BM] No hay pickups para borrar.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    // Buscar el pickup más cercano
    new idx = -1;
    new Float:minDist = 999999.0, Float:dist;

    for(new i = 0; i < BM_LocationCount; i++)
    {
        dist = floatsqroot(
            floatpower(BlackMarket_Info[i][blackmarketX] - x, 2.0) +
            floatpower(BlackMarket_Info[i][blackmarketY] - y, 2.0) +
            floatpower(BlackMarket_Info[i][blackmarketZ] - z, 2.0)
        );
        if(dist < minDist)
        {
            minDist = dist;
            idx = i;
        }
    }

    if(idx == -1 || minDist > BM_NEAR_DELETE_RADIUS)
        return SendClientMessage(playerid, -1, "[BM] No hay pickup lo suficientemente cerca para borrar.");

    // Borrar en DB por ID y recargar cache
    new q[128];
    mysql_format(MYSQL_HANDLE, q, sizeof(q),
        "DELETE FROM `black_market_locations` WHERE `id`=%d LIMIT 1;",
        BlackMarket_Info[idx][bmID]
    );
    mysql_tquery(MYSQL_HANDLE, q);
    // Destroy any in-memory pickup or NPC immediately
    if(IsValidDynamicPickup(BlackMarket_Info[idx][blackmarketPickup]))
        DestroyDynamicPickup(BlackMarket_Info[idx][blackmarketPickup]);
    if(IsValidActor(BlackMarket_Info[idx][blackmarketActor])) {
        Actor_Delete(BlackMarket_Info[idx][blackmarketActor]);
        BlackMarket_Info[idx][blackmarketActor] = 0;
    }

    // Reload locations from DB to keep cache in sync
    BlackMarket_LoadLocations();
    SendClientMessage(playerid, -1, "[BM] NPC/ubicación eliminada (DB + mapa).");
    return 1;
}

// ================== LÓGICA DE COMPRAR/VENDER ==================


CMD:vender(playerid, params[])
{
    if(!BlackMarket_IsPlayerAt(playerid)) return 1;

    new item = GetHandItem(playerid, HAND_RIGHT);
    if(item == 0)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes nada en tu mano derecha para vender.");
    if(!ItemModel_HasTag(item, ITEM_TAG_BLACK_MARKET))
        return SendClientMessage(playerid, COLOR_WHITE, "Comprador: No estoy interesado.");

    // Do not allow selling weapons or magazines on the black market
    if(ItemModel_GetType(item) == ITEM_WEAPON || ItemModel_GetType(item) == ITEM_MAGAZINE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes vender armas ni cargadores en el mercado negro.");

    new cash;
    if(ItemModel_HasTag(item, ITEM_TAG_FIX_PRICE))
        cash = floatround(ItemModel_GetPrice(item) * BM_SELL_PERCENTAGE, floatround_ceil);
    else
        cash = floatround(ItemModel_GetPrice(item) * GetHandParam(playerid, HAND_RIGHT) * BM_SELL_PERCENTAGE, floatround_ceil);

    GivePlayerCash(playerid, cash);

    // Log the sell for auditing
    format(sfl_log_str, sizeof sfl_log_str, "%s - %s: %d por $%d", ItemModel_GetName(item), ItemModel_GetParamName(item), GetHandParam(playerid, HAND_RIGHT), cash);
    ServerLog(LOG_TYPE_ID_MONEY, .entry="VENTA MERCADO NEGRO", .playerid=playerid, .params=sfl_log_str);

    new msg[144];
    format(msg, sizeof msg, "Comprador: Bien, te daré $%d por tu %s - %s: %d",
        cash, ItemModel_GetName(item), ItemModel_GetParamName(item), GetHandParam(playerid, HAND_RIGHT));
    SendClientMessage(playerid, COLOR_WHITE, msg);

    new str[128];
    format(str, sizeof(str), "Le entrega un/a %s al sujeto", ItemModel_GetName(item));
    PlayerCmeMessage(playerid, 15.0, 4000, str);

    SetHandItemAndParam(playerid, HAND_RIGHT, 0, 0);
    return 1;
}

hook function OnPlayerCmdComprar(playerid, const params[])
{
    if(!BlackMarket_IsPlayerAt(playerid))
        return continue(playerid, params);

    new freehand = SearchFreeHand(playerid);
    if(freehand == -1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes ambas manos ocupadas y no puedes agarrar el item.");

    BlackMarket_ShowBuyDialog(playerid);
    return 1;
}

stock BlackMarket_ShowBuyDialog(playerid)
{
    new bmstr[256];
    new price = 0;
    format(BlackMarket_Dialog, sizeof(BlackMarket_Dialog), "");
    strcat(BlackMarket_Dialog, "Item\tPrecio por unidad\n", sizeof(BlackMarket_Dialog));

    for(new i = 0; i < sizeof(BlackMarket_Items); i++)
    {
        price = floatround(ItemModel_GetPrice(BlackMarket_Items[i]) * BM_BUY_PERCENTAGE, floatround_ceil);
        format(bmstr, sizeof(bmstr), "%s\t$%d\n", ItemModel_GetName(BlackMarket_Items[i]), price);
        strcat(BlackMarket_Dialog, bmstr, sizeof(BlackMarket_Dialog));
    }

    Dialog_Show(playerid, DLG_BM_SHOW, DIALOG_STYLE_TABLIST_HEADERS, "Items del mercado negro:", BlackMarket_Dialog, "Seleccionar", "Cerrar");
    return 1;
}

Dialog:DLG_BM_SHOW(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new itemid = BlackMarket_Items[listitem];

        // Si es un cuchillo/barreta, entregamos 1 unidad automáticamente y aplicamos cooldown
        if (itemid == ITEM_ID_FACA_TUMBERA || itemid == ITEM_ID_CHEF_KNIFE || itemid == ITEM_ID_BARRETA)
        {
            new freehand = SearchFreeHand(playerid);
            if (freehand == -1)
                return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes ambas manos ocupadas y no puedes agarrar el item.");

            // Comprobar cooldowns por item
            if (itemid == ITEM_ID_FACA_TUMBERA) {
                if (!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_FACA)) return 1;
            } else if (itemid == ITEM_ID_CHEF_KNIFE) {
                if (!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_CHEF_KNIFE)) return 1;
            } else if (itemid == ITEM_ID_BARRETA) {
                if (!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_BARRETA)) return 1;
            }

            new price = floatround(ItemModel_GetPrice(itemid) * BM_BUY_PERCENTAGE, floatround_ceil);
            if (GetPlayerCash(playerid) < price)
                return SendClientMessage(playerid, COLOR_WHITE, "Vendedor: Tomatela de aca y volvé cuando tengas la plata.");

            SetHandItemAndParam(playerid, freehand, itemid, 1);
            GivePlayerCash(playerid, -price);

            // Aplicar cooldown de 1 hora (3600 segundos)
            if (itemid == ITEM_ID_FACA_TUMBERA) {
                CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_FACA, .seconds = 60 * 60);
            } else if (itemid == ITEM_ID_CHEF_KNIFE) {
                CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_CHEF_KNIFE, .seconds = 60 * 60);
            } else if (itemid == ITEM_ID_BARRETA) {
                CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_BARRETA, .seconds = 60 * 60);
            }

            format(sfl_log_str, sizeof sfl_log_str, "%s x1 por $%d", ItemModel_GetName(itemid), price);
            ServerLog(LOG_TYPE_ID_MONEY, .entry="COMPRA MERCADO NEGRO", .playerid=playerid, .params=sfl_log_str);

            new msg[96];
            format(msg, sizeof msg, "Vendedor: Acá tenés tu %s, son $%i.", ItemModel_GetName(itemid), price);
            SendClientMessage(playerid, COLOR_WHITE, msg);
            return 1;
        }
        BlackMarket_Item[playerid] = listitem;
        new str[128];
        format(str, sizeof(str), "Ingrese la cantidad a comprar de %s", ItemModel_GetName(BlackMarket_Items[listitem]));
        Dialog_Show(playerid, DLB_BM_AMOUNT, DIALOG_STYLE_INPUT, "Compra:", str, "Ingresar", "Cerrar");
    }
    return 1;
}

Dialog:DLB_BM_AMOUNT(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new bm_item = BlackMarket_Item[playerid];
        new cant = 0;

        if(sscanf(inputtext, "i", cant) || !(1 <= cant <= BM_MAX_BUY_AMOUNT))
        {
            new str[128];
            format(str, sizeof(str), "Ingrese la cantidad a comprar de %s (máx: %i).",
                ItemModel_GetName(BlackMarket_Items[bm_item]), BM_MAX_BUY_AMOUNT);
            Dialog_Show(playerid, DLB_BM_AMOUNT, DIALOG_STYLE_INPUT, "Compra:", str, "Ingresar", "Cerrar");
            return 1;
        }

        new price = floatround(ItemModel_GetPrice(BlackMarket_Items[bm_item]) * cant * BM_BUY_PERCENTAGE, floatround_ceil);
        new freehand = SearchFreeHand(playerid);

        if (GetPlayerCash(playerid) < price)
            return SendClientMessage(playerid, COLOR_WHITE, "Vendedor: Tomátela de acá y volvé cuando tengas plata.");

        if (freehand == -1)
            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes ambas manos ocupadas y no puedes agarrar el item.");

        SetHandItemAndParam(playerid, freehand, BlackMarket_Items[bm_item], cant);
        GivePlayerCash(playerid, -price);

        new msg[96];
        format(msg, sizeof msg, "Vendedor: Acá tenés tu %s, son $%i.", ItemModel_GetName(BlackMarket_Items[bm_item]), price);
        SendClientMessage(playerid, COLOR_WHITE, msg);

        // Log the purchase for auditing
        format(sfl_log_str, sizeof sfl_log_str, "%s x%d por $%d", ItemModel_GetName(BlackMarket_Items[bm_item]), cant, price);
        ServerLog(LOG_TYPE_ID_MONEY, .entry="COMPRA MERCADO NEGRO", .playerid=playerid, .params=sfl_log_str);
    }
    else
    {
        BlackMarket_Item[playerid] = -1;
        BlackMarket_ShowBuyDialog(playerid);
    }
    return 1;
}

// Recompute whether a player can buy magazines now, based on BM_MagBoughtTimes ring buffer
// (Removed magazine cooldown and Rossi helper functions)
