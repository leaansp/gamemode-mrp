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
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new STREAMER_TAG_OBJECT:objs[64];
    new found = Streamer_GetNearbyItems(
        x, y, z,
        STREAMER_TYPE_OBJECT,
        objs,
        sizeof(objs),
        range,
        .worldid = GetPlayerVirtualWorld(playerid)
    );

    for (new i = 0; i < found; i++)
    {
        if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, objs[i], E_STREAMER_MODEL_ID) == ASADOR_MODEL_ID)
            return objs[i];
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
        Asador_AddItem(streamer_id, ITEM_ID_CHORIPAN, 1);

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
// Command
// ===============================
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