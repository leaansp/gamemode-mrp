// ===============================
// Mini sistema de asador (choripanes)
// ===============================
#if defined _marp_asador_included
    #endinput
#endif
#define _marp_asador_included

#include <a_samp>
#include <streamer>

// ===============================
// Config
// ===============================
#define ASADOR_MODEL_ID 19831
#define MAX_ASADORES    1024

// ===============================
// Data
// ===============================
new Asador_Objs[MAX_ASADORES];           // streamer objectid
new Asador_Containers[MAX_ASADORES];     // vector (itemid,param)
new Asador_Cooking[MAX_ASADORES];        // 0 idle | 1 cooking
new Text3D:Asador_Labels[MAX_ASADORES];  // floating label
new Asador_Count = 0;

// ===============================
// Forwards
// ===============================
forward Asador_DoCook(streamer_id);

// ===============================
// Utils
// ===============================
stock Asador_FindNearbyObject(playerid, Float:range = 3.0)
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    // Buscar en el array de asadores registrados (mas confiable que GetNearbyItems)
    for (new i = 0; i < Asador_Count; i++)
    {
        new Float:ox, Float:oy, Float:oz;
        Streamer_GetFloatData(STREAMER_TYPE_OBJECT, STREAMER_TAG_OBJECT:Asador_Objs[i], E_STREAMER_X, ox);
        Streamer_GetFloatData(STREAMER_TYPE_OBJECT, STREAMER_TAG_OBJECT:Asador_Objs[i], E_STREAMER_Y, oy);
        Streamer_GetFloatData(STREAMER_TYPE_OBJECT, STREAMER_TAG_OBJECT:Asador_Objs[i], E_STREAMER_Z, oz);
        if (floatabs(px - ox) <= range && floatabs(py - oy) <= range && floatabs(pz - oz) <= (range + 2.0))
            return Asador_Objs[i];
    }

    // Fallback: buscar por modelo con streamer
    new STREAMER_TAG_OBJECT:objs[64];
    new found = Streamer_GetNearbyItems(px, py, pz, STREAMER_TYPE_OBJECT, objs, sizeof(objs), range);
    for (new i = 0; i < found; i++)
    {
        if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, objs[i], E_STREAMER_MODEL_ID) == ASADOR_MODEL_ID)
            return _:objs[i];
    }
    return INVALID_STREAMER_ID;
}

stock Asador_GetIndex(streamer_id)
{
    for (new i = 0; i < Asador_Count; i++)
        if (Asador_Objs[i] == streamer_id)
            return i;
    return -1;
}

stock Asador_Create(streamer_id)
{
    new idx = Asador_GetIndex(streamer_id);
    if (idx != -1) return idx;

    if (Asador_Count >= MAX_ASADORES)
        return -1;

    idx = Asador_Count++;
    Asador_Objs[idx] = streamer_id;
    Asador_Containers[idx] = vector_create();
    Asador_Cooking[idx] = 0;
    Asador_Labels[idx] = Text3D:INVALID_3DTEXT_ID;

    // Crear label inicial
    new Float:x, Float:y, Float:z;
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, streamer_id, E_STREAMER_X, x);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, streamer_id, E_STREAMER_Y, y);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, streamer_id, E_STREAMER_Z, z);

    Asador_Labels[idx] = CreateDynamic3DTextLabel(
        "Parrilla\nVacío",
        COLOR_WHITE,
        x, y, z + 1.0,
        20.0,
        INVALID_PLAYER_ID,
        INVALID_VEHICLE_ID,
        1
    );
    return idx;
}

stock Asador_Destroy(idx)
{
    if (idx < 0 || idx >= Asador_Count) return 0;

    DestroyDynamicObject(Asador_Objs[idx]);
    DestroyDynamic3DTextLabel(Asador_Labels[idx]);
    vector_clear(Asador_Containers[idx]);

    new last = Asador_Count - 1;
    if (idx != last)
    {
        Asador_Objs[idx]       = Asador_Objs[last];
        Asador_Containers[idx] = Asador_Containers[last];
        Asador_Cooking[idx]    = Asador_Cooking[last];
        Asador_Labels[idx]     = Asador_Labels[last];
    }
    Asador_Count--;
    return 1;
}

// ===============================
// Container helpers
// ===============================
stock Asador_AddItem(streamer_id, itemid, param)
{
    new idx = Asador_Create(streamer_id);
    if (idx == -1) return 0;

    vector_push_back(Asador_Containers[idx], itemid);
    vector_push_back(Asador_Containers[idx], param);
    return 1;
}

stock Asador_TakeItem(streamer_id, &itemid, &param)
{
    new idx = Asador_GetIndex(streamer_id);
    if (idx == -1) return 0;

    new vec = Asador_Containers[idx];
    if (!vec || vector_size(vec) < 2) return 0;

    itemid = vector_get(vec, 0);
    param  = vector_get(vec, 1);

    vector_remove(vec, 0);
    vector_remove(vec, 0);
    return 1;
}

stock Asador_CountItem(streamer_id, itemid)
{
    new idx = Asador_GetIndex(streamer_id);
    if (idx == -1) return 0;

    new vec = Asador_Containers[idx];
    new cnt = 0;

    for (new i = 0; i < vector_size(vec); i += 2)
        if (vector_get(vec, i) == itemid)
            cnt++;

    return cnt;
}

// ===============================
// Label update
// ===============================
stock Asador_UpdateLabel(streamer_id)
{
    new idx = Asador_GetIndex(streamer_id);
    if (idx == -1) return 0;

    new text[64];

    if (Asador_Cooking[idx])
    {
        format(text, sizeof text, "Parrilla\nCocinando...");
    }
    else
    {
        new ready = Asador_CountItem(streamer_id, ITEM_ID_CHORIPAN);
        if (ready > 0)
            format(text, sizeof text, "Parrilla\nListo: %d", ready);
        else
            format(text, sizeof text, "Parrilla\nVacío");
    }

    UpdateDynamic3DTextLabelText(Asador_Labels[idx], COLOR_WHITE, text);
    return 1;
}

// ===============================
// Cooking logic
// ===============================
public Asador_DoCook(streamer_id)
{
    new idx = Asador_GetIndex(streamer_id);
    if (idx == -1) return 1;

    new vec = Asador_Containers[idx];
    new found = -1;

    for (new i = 0; i < vector_size(vec); i += 2)
    {
        if (vector_get(vec, i) == ITEM_ID_CHORIZO)
        {
            found = i;
            break;
        }
    }

    if (found == -1)
    {
        Asador_Cooking[idx] = 0;
        Asador_UpdateLabel(streamer_id);
        return 1;
    }

    // quitar chorizo
    vector_remove(vec, found);
    vector_remove(vec, found);

    // producir choripanes
    for (new i = 0; i < 3; i++)
        Asador_AddItem(streamer_id, ITEM_ID_CHORIPAN, 5);

    // ¿hay más chorizos?
    for (new j = 0; j < vector_size(vec); j += 2)
    {
        if (vector_get(vec, j) == ITEM_ID_CHORIZO)
        {
            SetTimerEx("Asador_DoCook", 10 * 1000, false, "i", streamer_id);
            Asador_Cooking[idx] = 1;
            Asador_UpdateLabel(streamer_id);
            return 1;
        }
    }

    Asador_Cooking[idx] = 0;
    Asador_UpdateLabel(streamer_id);
    return 1;
}

// ===============================
// Exclusion zones
// ===============================
static const Float:NoAsadorZones[][4] = {
    // {X, Y, Z, Radio}
    {0.0, 0.0, 0.0, 150.0}  // Villa Fierro -- coordenadas pendientes
};

// ===============================
// Commands
// ===============================
CMD:colocarparrilla(playerid, params[])
{
    if (Item_IsHandlingCooldownOn(playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar antes de usar la parrilla.");

    new hand = SearchHandsForItem(playerid, ITEM_ID_ASADOR);
    if (hand == -1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes una parrilla en la mano.");

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    for (new i = 0; i < sizeof(NoAsadorZones); i++)
    {
        if (IsPlayerInRangeOfPoint(playerid, NoAsadorZones[i][3], NoAsadorZones[i][0], NoAsadorZones[i][1], NoAsadorZones[i][2]))
            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No podes colocar una parrilla en esta zona.");
    }

    new Float:angle;
    GetPlayerFacingAngle(playerid, angle);
    new STREAMER_TAG_OBJECT:streamer_obj = CreateDynamicObject(ASADOR_MODEL_ID, px, py, pz - 0.9, 0.0, 0.0, angle);

    SetHandItemAndParam(playerid, hand, 0, 0);
    Asador_Create(streamer_obj);

    PlayerActionMessage(playerid, 15.0, "coloca una parrilla en el suelo.");
    ApplyAnimationEx(playerid, "carry", "putdwn105", 20.0, 0, 0, 0, 0, 0, 1);
    Item_ApplyHandlingCooldown(playerid);

    return SendClientMessage(playerid, COLOR_INFO, "Colocaste la parrilla. Usa /choripan con un chorizo para cocinar.");
}

CMD:levantarparrilla(playerid, params[])
{
    if (Item_IsHandlingCooldownOn(playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar antes de usar la parrilla.");

    new streamer_obj = Asador_FindNearbyObject(playerid);
    if (streamer_obj == INVALID_STREAMER_ID)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay una parrilla cerca.");

    new idx = Asador_GetIndex(streamer_obj);
    if (idx == -1) return 1;

    if (Asador_Cooking[idx])
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La parrilla esta cocinando, espera.");

    new vec = Asador_Containers[idx];
    if (vec && vector_size(vec) > 0)
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La parrilla tiene items adentro, vaciala antes de levantarla.");

    if (!SetAnyHandItemAndParam(playerid, ITEM_ID_ASADOR, 1))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes las manos libres.");

    Asador_Destroy(idx);

    PlayerActionMessage(playerid, 15.0, "levanta la parrilla del suelo.");
    ApplyAnimationEx(playerid, "carry", "liftup105", 20.0, 0, 0, 0, 0, 0, 1);
    Item_ApplyHandlingCooldown(playerid);

    return SendClientMessage(playerid, COLOR_INFO, "Levantaste la parrilla.");
}

CMD:choripan(playerid, params[])
{
    if (Item_IsHandlingCooldownOn(playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar antes de usar la parrilla.");

    new streamer_obj = Asador_FindNearbyObject(playerid);
    if (streamer_obj == INVALID_STREAMER_ID)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay una parrilla cerca.");

    new idx = Asador_Create(streamer_obj);
    if (idx == -1) return 1;

    // ¿poner chorizo?
    new hand = SearchHandsForItem(playerid, ITEM_ID_CHORIZO);
    if (hand != -1)
    {
        new param = GetHandParam(playerid, hand) - 1;
        if (param <= 0) SetHandItemAndParam(playerid, hand, 0, 0);
        else SetHandItemAndParam(playerid, hand, ITEM_ID_CHORIZO, param);

        PlayerActionMessage(playerid, 15.0, "coloca un chorizo en la parrilla.");
        ApplyAnimationEx(playerid, "carry", "putdwn105", 20.0, 0, 0, 0, 0, 0, 1);
        Item_ApplyHandlingCooldown(playerid);

        Asador_AddItem(streamer_obj, ITEM_ID_CHORIZO, 1);

        if (!Asador_Cooking[idx])
        {
            Asador_Cooking[idx] = 1;
            SetTimerEx("Asador_DoCook", 10 * 1000, false, "i", streamer_obj);
        }

        Asador_UpdateLabel(streamer_obj);
        return SendClientMessage(playerid, COLOR_INFO, "Pusiste un chorizo en la parrilla.");
    }

    // ¿sacar choripán?
    new item, param;
    if (!Asador_TakeItem(streamer_obj, item, param))
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay choripanes listos.");

    if (!SetAnyHandItemAndParam(playerid, item, param))
    {
        Asador_AddItem(streamer_obj, item, param);
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenés las manos libres.");
    }

    PlayerActionMessage(playerid, 15.0, "toma un choripán de la parrilla.");
    ApplyAnimationEx(playerid, "carry", "liftup105", 20.0, 0, 0, 0, 0, 0, 1);
    Item_ApplyHandlingCooldown(playerid);

    Asador_UpdateLabel(streamer_obj);
    return SendClientMessage(playerid, COLOR_INFO, "Has tomado un choripán.");
}