#if defined _marp_grafitis_included
    #endinput
#endif
#define _marp_grafitis_included

#define MAX_GRAFFITI 500
#define GRAFFITI_TEXT_LEN 14

#define DIALOG_GRAFFITI_COLOR 2100
#define DIALOG_GRAFFITI_TEXT  2101
#define GRAFFITI_OBJECT_MODEL 19482



#define GRAFFITI_COLOR_RED          0xFFFF0000
#define GRAFFITI_COLOR_LIGHTBLUE    0xFF00BFFF
#define GRAFFITI_COLOR_LIGHTGREEN   0xFF00FF00
#define GRAFFITI_COLOR_LIGHTORANGE  0xFFFFA500
#define GRAFFITI_COLOR_YELLOW       0xFFFFFF00
#define GRAFFITI_COLOR_MEDIUMBLUE2  0xFF1E90FF
#define GRAFFITI_COLOR_DARKPURPLE   0xFF800080
#define GRAFFITI_COLOR_WHITE        0xFFFFFFFF

// ===========================================================
// ENUMS Y VARIABLES
// ===========================================================
enum e_GRAFFITI_DATA {
    graffitiID,
    graffitiFaction,
    graffitiText[GRAFFITI_TEXT_LEN],
    graffitiFont[32], 
    Float:graffitiX,
    Float:graffitiY,
    Float:graffitiZ,
    Float:graffitiA,
    Float:graffitiRX,
    Float:graffitiRY,
    graffitiColor,
    graffitiCreator[32],
    graffitiCreatedAt[20],
    STREAMER_TAG_OBJECT:graffitiLabel
}

new GraffitiInfo[MAX_GRAFFITI][e_GRAFFITI_DATA];
new Iterator:GraffitiIter<MAX_GRAFFITI>;
new GraffitiSelectedColor[MAX_PLAYERS];
new GraffitiSelectedFont[MAX_PLAYERS][32];

#define DIALOG_GRAFFITI_FONT   2099
#define DIALOG_GRAFFITI_LIST 9510


new const GraffitiFonts[][] =
{
    "Graffiti",
    "Chiller",
    "Comic Sans MS",
    "Impact",
    "Arial Black",
    "Segoe Print",
    "Stencil"
};

// ===========================================================
// FORWARDS
// ===========================================================
forward Graffiti_OnLoadAll();
forward Graffiti_OnObjSelect(playerid, STREAMER_TAG_OBJECT:objectid, modelid);
forward Graffiti_FinishSpray(playerid);
forward GODOS(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
forward Graffiti_OnCreated(localId);

// ===========================================================
// CARGA DESDE DB
// ===========================================================
public Graffiti_OnLoadAll()
{
    new rows = cache_num_rows();

    if (!rows)
        return printf("[INFO] No hay grafitis cargados.");

    new tmp[64];

    for (new i = 0; i < rows; i++)
    {
        new id = Iter_Free(GraffitiIter);
        if (id == ITER_NONE) continue;

        // Lectura de datos tipada y segura
        cache_get_value_name_int(i, "id", GraffitiInfo[id][graffitiID]);
        cache_get_value_name_int(i, "faction_id", GraffitiInfo[id][graffitiFaction]);
        cache_get_value_name(i, "graffiti_text", GraffitiInfo[id][graffitiText], GRAFFITI_TEXT_LEN);
        
        // Lectura de floats (conversión explícita)
        cache_get_value_name(i, "pos_x", tmp); GraffitiInfo[id][graffitiX] = floatstr(tmp);
        cache_get_value_name(i, "pos_y", tmp); GraffitiInfo[id][graffitiY] = floatstr(tmp);
        cache_get_value_name(i, "pos_z", tmp); GraffitiInfo[id][graffitiZ] = floatstr(tmp);
        cache_get_value_name(i, "angle", tmp); GraffitiInfo[id][graffitiA] = floatstr(tmp);
        cache_get_value_name(i, "rot_x", tmp); GraffitiInfo[id][graffitiRX] = floatstr(tmp);
        cache_get_value_name(i, "rot_y", tmp); GraffitiInfo[id][graffitiRY] = floatstr(tmp);

        // Color (convertido a unsigned int)
        cache_get_value_name(i, "color", tmp);
        GraffitiInfo[id][graffitiColor] = strval(tmp);


        // Fuente
       // cache_get_value_name(i, "font", GraffitiInfo[id][graffitiFont], sizeof(GraffitiInfo[][graffitiFont]));

        // Forzar color visible y fuente por defecto
        if (GraffitiInfo[id][graffitiColor] == 0)
            GraffitiInfo[id][graffitiColor] = 0xFFFFFFFF;
        else
            GraffitiInfo[id][graffitiColor] |= 0xFF000000;
        
        cache_get_value_name(i, "creator",   GraffitiInfo[id][graffitiCreator],  32);
        cache_get_value_name(i, "created_at",GraffitiInfo[id][graffitiCreatedAt], 20);
       // if (!strlen(GraffitiInfo[id][graffitiFont]))
       //     strcpy(GraffitiInfo[id][graffitiFont], "Graffiti");

        // Crear el objeto
        Graffiti_CreateFromDB(id);
        Iter_Add(GraffitiIter, id);

    }

    printf("[INFO] Se cargaron %d grafitis correctamente.", rows);
    return 1;
}

// ===========================================================
// CREACIÓN DE OBJETO
// ===========================================================
stock Graffiti_CreateLabel(id)
{
    if (IsValidDynamicObject(GraffitiInfo[id][graffitiLabel]))
        DestroyDynamicObject(GraffitiInfo[id][graffitiLabel]);

    new Float:x = GraffitiInfo[id][graffitiX];
    new Float:y = GraffitiInfo[id][graffitiY];
    new Float:z = GraffitiInfo[id][graffitiZ];
    new Float:a = GraffitiInfo[id][graffitiA];

    // Un poco más adelante respecto al jugador
    x += 0.5 * floatsin(-a, degrees);
    y += 0.5 * floatcos(-a, degrees);

    GraffitiInfo[id][graffitiLabel] = CreateDynamicObject(
        GRAFFITI_OBJECT_MODEL,
        x, y, z,
        0.0, 0.0, a + 180.0,
        .worldid = -1, .interiorid = -1, .streamdistance = 300.0
    );

    new fontName[32];
    if (GraffitiInfo[id][graffitiFont][0])
        format(fontName, sizeof fontName, "%s", GraffitiInfo[id][graffitiFont]);
    else
        strcpy(fontName, "Graffiti");

    SetDynamicObjectMaterialText(
        GraffitiInfo[id][graffitiLabel],
        0,
        GraffitiInfo[id][graffitiText],
        OBJECT_MATERIAL_SIZE_256x128,
        fontName,
        35, true,
        GraffitiInfo[id][graffitiColor], // conversión de rgba a ARGB
        0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER
    );

    Streamer_SetIntData(STREAMER_TYPE_OBJECT,
        GraffitiInfo[id][graffitiLabel],
        E_STREAMER_EXTRA_ID,
        DYN_OBJ_TYPE_GRAFFITI
    );
}

stock Graffiti_CreateFromDB(id)
{
    // Crear el objeto físico
    GraffitiInfo[id][graffitiLabel] = CreateDynamicObject(
        GRAFFITI_OBJECT_MODEL,
        GraffitiInfo[id][graffitiX],
        GraffitiInfo[id][graffitiY],
        GraffitiInfo[id][graffitiZ],
        GraffitiInfo[id][graffitiRX], GraffitiInfo[id][graffitiRY], GraffitiInfo[id][graffitiA],
        .worldid = -1, .interiorid = -1, .streamdistance = 300.0
    );

    // Forzar alfa visible y conversión correcta a ARGB
    new colorARGB = (GraffitiInfo[id][graffitiColor] | 0xFF000000);
    new fontName[32];
    if (GraffitiInfo[id][graffitiFont][0])
        format(fontName, sizeof fontName, "%s", GraffitiInfo[id][graffitiFont]);
    else
        strcpy(fontName, "Graffiti");

    // Aplicar texto y color
    SetDynamicObjectMaterialText(
        GraffitiInfo[id][graffitiLabel],
        0,
        GraffitiInfo[id][graffitiText],
        OBJECT_MATERIAL_SIZE_256x128,
        fontName,
        35,
        true,
        colorARGB,
        0,
        OBJECT_MATERIAL_TEXT_ALIGN_CENTER
    );

    // Guardar en el streamer
    Streamer_SetIntData(STREAMER_TYPE_OBJECT,
        GraffitiInfo[id][graffitiLabel],
        E_STREAMER_EXTRA_ID,
        DYN_OBJ_TYPE_GRAFFITI
    );
    return 1;
}
// ===========================================================
// COMANDO /GRAFITI
// ===========================================================
CMD:grafiti(playerid, params[])
{
    if (PlayerInfo[playerid][pFaction] == 0)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No perteneces a ninguna facción.");

    new faction = PlayerInfo[playerid][pFaction];
    if (!Faction_IsValidId(faction))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Facción inválida.");
    if (!Faction_HasTag(faction, FAC_TAG_ALLOW_GRAFITI))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu facción no puede crear grafitis.");
    if (PlayerInfo[playerid][pRank] > 3)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo los rangos superiores pueden escribir grafitis.");

    if (GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_SPRAYCAN && GetHandItem(playerid, HAND_LEFT) != ITEM_ID_SPRAYCAN)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un spray de pintura en la mano.");
    if (Graffiti_CountByFaction(PlayerInfo[playerid][pFaction]) >= 20)
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu facción alcanzó el límite máximo de 20 grafitis activos.");

    ShowPlayerDialog(playerid, DIALOG_GRAFFITI_FONT, DIALOG_STYLE_LIST,
        "Selecciona una fuente para tu grafiti",
        "Graffiti\nChiller\nComic Sans MS\nImpact\nArial Black\nSegoe Print\nStencil",
        "Elegir", "Cancelar");
    return 1;
}

// ===========================================================
// DIALOGS DE COLOR Y TEXTO
// ===========================================================

stock ABGRtoARGB(c)
{
    new a = (c >> 24) & 0xFF;
    new b = (c >> 16) & 0xFF;
    new g = (c >> 8)  & 0xFF;
    new r =  c        & 0xFF;
    return (a << 24) | (r << 16) | (g << 8) | b;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_GRAFFITI_FONT)
    {
        if (!response) return 1;
        format(GraffitiSelectedFont[playerid], sizeof(GraffitiSelectedFont[]), "%s", GraffitiFonts[listitem]);

        ShowPlayerDialog(playerid, DIALOG_GRAFFITI_COLOR, DIALOG_STYLE_LIST,
            "Seleccioná un color para el grafiti",
            "Rojo\nAzul Claro\nVerde Claro\nNaranja\nAmarillo\nCeleste\nMorado\nBlanco",
            "Elegir", "Cancelar");
        return 1;
    }

    if (dialogid == DIALOG_GRAFFITI_COLOR)
    {
        if (!response) return 1;

        switch (listitem)
        {
            case 0: GraffitiSelectedColor[playerid] = GRAFFITI_COLOR_RED;
            case 1: GraffitiSelectedColor[playerid] = GRAFFITI_COLOR_LIGHTBLUE;
            case 2: GraffitiSelectedColor[playerid] = GRAFFITI_COLOR_LIGHTGREEN;
            case 3: GraffitiSelectedColor[playerid] = GRAFFITI_COLOR_LIGHTORANGE;
            case 4: GraffitiSelectedColor[playerid] = GRAFFITI_COLOR_YELLOW;
            case 5: GraffitiSelectedColor[playerid] = GRAFFITI_COLOR_MEDIUMBLUE2;
            case 6: GraffitiSelectedColor[playerid] = GRAFFITI_COLOR_DARKPURPLE;
            case 7: GraffitiSelectedColor[playerid] = GRAFFITI_COLOR_WHITE;
        }

        ShowPlayerDialog(playerid, DIALOG_GRAFFITI_TEXT, DIALOG_STYLE_INPUT,
            "Texto del grafiti",
            "Escribí el texto que querés pintar en la pared (máx. 14 caracteres):",
            "Pintar", "Cancelar");
        return 1;
    }

    
    if (dialogid == DIALOG_GRAFFITI_TEXT)
    {   
        if (!response) return 1;
        if (strlen(inputtext) < 1)
            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar un texto.");
        if (strlen(inputtext) > 14)
            return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No puedes realizar un graffiti de más de 14 caracteres. Intentalo nuevamente.");

        new faction = PlayerInfo[playerid][pFaction];
        if (!Faction_IsValidId(faction))
            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Facción inválida.");

        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);

        
        x += 0.5 * floatsin(-a, degrees);
        y += 0.5 * floatcos(-a, degrees);

        new id = Iter_Free(GraffitiIter);
        if (id == ITER_NONE)
            return SendClientMessage(playerid, COLOR_RED, "Límite de grafitis alcanzado.");

        // Guardar la información en memoria
        GraffitiInfo[id][graffitiFaction] = faction;
        strcpy(GraffitiInfo[id][graffitiText], inputtext, GRAFFITI_TEXT_LEN);
        strcpy(GraffitiInfo[id][graffitiFont], GraffitiSelectedFont[playerid], 32);
        GraffitiInfo[id][graffitiX] = x;
        GraffitiInfo[id][graffitiY] = y;
        GraffitiInfo[id][graffitiZ] = z;
        GraffitiInfo[id][graffitiA] = a;
        GraffitiInfo[id][graffitiColor] = GraffitiSelectedColor[playerid];

        
        Graffiti_CreateLabel(id);
        Iter_Add(GraffitiIter, id);

        
        new q[512];
        mysql_format(MYSQL_HANDLE, q, sizeof(q),
            "INSERT INTO graffiti (faction_id, graffiti_text, pos_x, pos_y, pos_z, angle, color, font, creator) \
            VALUES (%d, '%e', %f, %f, %f, %f, %u, '%e', '%e')",
            faction,
            inputtext,
            x, y, z, a,
            GraffitiSelectedColor[playerid],
            GraffitiSelectedFont[playerid],
            GetPlayerNameEx(playerid)
        );
        mysql_tquery(MYSQL_HANDLE, q, "Graffiti_OnCreated", "i", id);


        ApplyAnimation(playerid, "SPRAYCAN", "spraycan_fire", 4.1, 0, 1, 1, 0, 0);
        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Has pintado un grafiti en la pared.");
        PlayerActionMessage(playerid, 15.0, "rocia pintura sobre la pared.");

        SetPVarInt(playerid, "EditingGraffitiID", id);
        SetTimerEx("Graffiti_FinishSpray", 3000, false, "i", playerid);
        SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Comenzaste a hacer un graffiti! Recordá respetar la interpretación de la zona para evitar sanciones.");
        EditDynamicObject(playerid, GraffitiInfo[id][graffitiLabel]);
        SendClientMessage(playerid, COLOR_INFO, "Se ha abierto el editor para ajustar la posición del grafiti.");
        return 1;
    }
    if (dialogid == DIALOG_GRAFFITI_LIST)
    {
        if (!response) return 1;

        new idx = 0;
        foreach (new i : GraffitiIter)
        {
            if (idx == listitem)
            {
                new Float:x = GraffitiInfo[i][graffitiX];
                new Float:y = GraffitiInfo[i][graffitiY];
                new Float:z = GraffitiInfo[i][graffitiZ];

                SetPlayerPos(playerid, x + 1.0, y + 1.0, z + 1.0);
                SetPlayerFacingAngle(playerid, GraffitiInfo[i][graffitiA]);
                SetCameraBehindPlayer(playerid);
                SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Te teletransportaste al grafiti seleccionado.");
                break;
            }
            idx++;
        }
        return 1;
    }
    return 0;
}

public Graffiti_OnCreated(localId)
{
    // Guardar el ID autoincremental de la fila insertada
    GraffitiInfo[localId][graffitiID] = cache_insert_id();

    if (GraffitiInfo[localId][graffitiID] <= 0)
    {
        printf("[GRAFFITI][WARN] No se pudo obtener insert_id para localId=%d", localId);
    }
    else
    {
        printf("[GRAFFITI] Nuevo grafiti creado correctamente. DB id=%d (slot=%d)",
            GraffitiInfo[localId][graffitiID], localId);
    }
    return 1;
}

// ===========================================================
// EDICIÓN DESDE /editargrafiti
// ===========================================================
CMD:editargrafiti(playerid, params[])
{
    if (PlayerInfo[playerid][pFaction] == 0 && PlayerInfo[playerid][pAdmin] < 15)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No perteneces a una facción ni sos administrador.");

    if (PlayerInfo[playerid][pRank] > 3 && PlayerInfo[playerid][pAdmin] < 15)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo los rangos altos o un administrador nivel 15 pueden editar grafitis.");

    new closest = -1;
    new Float:minDist = 3.0;

    foreach (new i : GraffitiIter)
    {
        new Float:dist = GetPlayerDistanceFromPoint(playerid,
            GraffitiInfo[i][graffitiX],
            GraffitiInfo[i][graffitiY],
            GraffitiInfo[i][graffitiZ]);

        if (dist < minDist)
        {
            minDist = dist;
            closest = i;
        }
    }

    if (closest == -1)
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay grafitis cercanos.");

    if (PlayerInfo[playerid][pAdmin] < 15 &&
        GraffitiInfo[closest][graffitiFaction] != PlayerInfo[playerid][pFaction])
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes editar grafitis de otra facción.");

    SetPVarInt(playerid, "EditingGraffitiID", closest);
    EditDynamicObject(playerid, GraffitiInfo[closest][graffitiLabel]);
    SendClientMessage(playerid, COLOR_INFO, "Estás editando el grafiti. Usá el editor del juego para moverlo o rotarlo.");
    return 1;
}

// ===========================================================
// CALLBACKS
// ===========================================================
public Graffiti_OnObjSelect(playerid, STREAMER_TAG_OBJECT:objectid, modelid)
{
    return 1;
}

public GODOS(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    foreach (new i : GraffitiIter)
    {
        if (GraffitiInfo[i][graffitiLabel] == objectid)
        {
            if (response == EDIT_RESPONSE_CANCEL)
            {
        
                new Float:cx, Float:cy, Float:cz;

                GetDynamicObjectPos(objectid, cx, cy, cz);
                GetDynamicObjectRot(objectid, rx, ry, rz);

                GraffitiInfo[i][graffitiX] = cx;
                GraffitiInfo[i][graffitiY] = cy;
                GraffitiInfo[i][graffitiZ] = cz;
                GraffitiInfo[i][graffitiA] = rz;
                GraffitiInfo[i][graffitiRX] = rx;
                GraffitiInfo[i][graffitiRY] = ry;
                // No se actualiza en DB, pero se mantiene sincronizado en memoria
                SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Edición cancelada. El grafiti quedó donde lo dejaste.");
                return 1;
            }

            if (response == EDIT_RESPONSE_FINAL)
            {
                GraffitiInfo[i][graffitiX] = x;
                GraffitiInfo[i][graffitiY] = y;
                GraffitiInfo[i][graffitiZ] = z;
                GraffitiInfo[i][graffitiA] = rz;
                GraffitiInfo[i][graffitiRX] = rx;
                GraffitiInfo[i][graffitiRY] = ry;

                SetDynamicObjectPos(objectid, x, y, z);
                SetDynamicObjectRot(objectid, rx, ry, rz);

                new q[256];
                mysql_format(MYSQL_HANDLE, q, sizeof(q),
                    "UPDATE graffiti SET pos_x=%f, pos_y=%f, pos_z=%f, angle=%f, rot_x=%f, rot_y=%f WHERE id=%d",
                    x, y, z, rz, rx, ry, GraffitiInfo[i][graffitiID]
                );
                mysql_tquery(MYSQL_HANDLE, q);

                SendClientMessage(playerid, COLOR_INFO, "Has guardado la nueva posición del grafiti.");
                PlayerActionMessage(playerid, 15.0, "termina de ajustar el grafiti en la pared.");
                return 1;
            }
        }
    }
    return 1;
}

public Graffiti_FinishSpray(playerid)
{
    ClearAnimations(playerid);
    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Has terminado de pintar el grafiti.");
}


stock Graffiti_Destroy(id, bool:deleteFromDB = true)
{
    if (id == ITER_NONE) return 0;

    // 1) Borrar objeto del mundo
    if (IsValidDynamicObject(GraffitiInfo[id][graffitiLabel]))
    {
        DestroyDynamicObject(GraffitiInfo[id][graffitiLabel]);
        GraffitiInfo[id][graffitiLabel] = STREAMER_TAG_OBJECT:0;
    }

    // 2) Borrar en DB (si hay id válido)
    if (deleteFromDB && GraffitiInfo[id][graffitiID] > 0)
    {
        new q[96];
        mysql_format(MYSQL_HANDLE, q, sizeof(q),
            "DELETE FROM graffiti WHERE id=%d",
            GraffitiInfo[id][graffitiID]
        );
        mysql_tquery(MYSQL_HANDLE, q);
    }
    
    new msg[128];
    format(msg, sizeof(msg), "[INFO] Has borrado el grafiti ID %d (%s).", GraffitiInfo[id][graffitiID], GraffitiInfo[id][graffitiText]);

    // 3) Limpiar memoria y liberar slot
    GraffitiInfo[id][graffitiID] = 0;
    GraffitiInfo[id][graffitiFaction] = 0;
    GraffitiInfo[id][graffitiText][0] = '\0';
    GraffitiInfo[id][graffitiX] = 0.0;
    GraffitiInfo[id][graffitiY] = 0.0;
    GraffitiInfo[id][graffitiZ] = 0.0;
    GraffitiInfo[id][graffitiA] = 0.0;
    GraffitiInfo[id][graffitiColor] = 0;

    Iter_Remove(GraffitiIter, id);
    return 1;
}

stock Graffiti_FindClosest(playerid, Float:maxDist = 3.0)
{
    new closest = -1;
    new Float:minDist = maxDist;

    foreach (new i : GraffitiIter)
    {
        new Float:dist = GetPlayerDistanceFromPoint(
            playerid,
            GraffitiInfo[i][graffitiX],
            GraffitiInfo[i][graffitiY],
            GraffitiInfo[i][graffitiZ]
        );

        if (dist < minDist)
        {
            minDist = dist;
            closest = i;
        }
    }
    return closest;
}

stock Graffiti_CountByFaction(factionid)
{
    new count = 0;
    foreach (new i : GraffitiIter)
    {
        if (GraffitiInfo[i][graffitiFaction] == factionid)
            count++;
    }
    return count;
}



CMD:borrargrafiti(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 3 || level == 5 || level == 7 || level == 9 || level == 11 || level == 13 || level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");

    new idParam, id = -1;
    new Float:maxDist = 10.0; // distancia máxima para borrar por ID

    


    // Si se pasa un parámetro (ID de grafiti)
    if (sscanf(params, "i", idParam) == 0)
    {
        foreach (new i : GraffitiIter)
        {
            if (GraffitiInfo[i][graffitiID] == idParam)
            {
                // Verificar distancia
                new Float:dist = GetPlayerDistanceFromPoint(playerid,
                    GraffitiInfo[i][graffitiX],
                    GraffitiInfo[i][graffitiY],
                    GraffitiInfo[i][graffitiZ]);

                if (dist > maxDist)
                    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Estás demasiado lejos del grafiti indicado.");

                id = i;
                break;
            }
        }

        if (id == -1)
            return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No se encontró ningún grafiti con esa ID cerca.");
    }
    else
    {
        // Sin parámetro: borrar el más cercano
        id = Graffiti_FindClosest(playerid, 1.0);
        if (id == -1)
            return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay grafitis cercanos.");
    }

    // Si no es admin, solo puede borrar de su facción
    if (PlayerInfo[playerid][pAdmin] < 15 &&
        GraffitiInfo[id][graffitiFaction] != PlayerInfo[playerid][pFaction])
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes borrar grafitis de otra facción.");

    new tempGrafId = GraffitiInfo[id][graffitiID];
    new tempGrafText = GraffitiInfo[id][graffitiText]; //Lo guardamos acá porque después se destruye al invocar Graffiti_Destroy
    // Borrar el grafiti
    if (Graffiti_Destroy(id, true))
    {
        new msg[128];
        format(msg, sizeof(msg), "[INFO] Has borrado el grafiti ID %d (%s).", tempGrafId, tempGrafText);
        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, msg);
        PlayerActionMessage(playerid, 15.0, "retira el grafiti de la pared.");
    }
    else
    {
        SendClientMessage(playerid, COLOR_RED, "Ocurrió un error al borrar el grafiti.");
    }
    return 1;
}

CMD:debuggrafiti(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 20)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No sos administrador nivel 20.");

    new count = 0;
    foreach (new i : GraffitiIter)
    {
        count++;
        printf("[GRAFFITI][%d] id=%d faccion=%d texto='%s' color=%d pos=(%.2f, %.2f, %.2f, %.2f)",
            i,
            GraffitiInfo[i][graffitiID],
            GraffitiInfo[i][graffitiFaction],
            GraffitiInfo[i][graffitiText],
            GraffitiInfo[i][graffitiColor],
            GraffitiInfo[i][graffitiX],
            GraffitiInfo[i][graffitiY],
            GraffitiInfo[i][graffitiZ],
            GraffitiInfo[i][graffitiA]
        );
    }
    printf("[GRAFFITI] Total de grafitis en memoria: %d", count);
    return 1;
}

// OnGameModeInit hook removed: graffiti loading is handled centrally via `Graffiti_LoadAll()`
// to ensure the DB connection (`MYSQL_HANDLE`) is initialized before queries run.

//===========COMANDOS ADMIN==========================

CMD:agrafiti(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 3 || level == 5 || level == 7 || level == 9 || level == 11 || level == 13 || level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");


    new list[4096];
    new line[192];
    list[0] = '\0';

    new count = 0;

    foreach (new i : GraffitiIter)
    {
        if (!GraffitiInfo[i][graffitiID])
            continue;

        // Acá corregimos el acceso: el error venía de intentar formatear directamente arrays sin índice.
        format(line, sizeof(line),
            "[%03d] %s | Fac:%d | By:%s\n",
            GraffitiInfo[i][graffitiID],
            GraffitiInfo[i][graffitiText],      // Correctamente indexado (string)
            GraffitiInfo[i][graffitiFaction],
            GraffitiInfo[i][graffitiCreator]    // Correctamente indexado (string)
        );

        if (strlen(list) + strlen(line) >= sizeof(list) - 2)
            break;

        strcat(list, line);
        count++;
    }

    if (!count)
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay grafitis cargados actualmente.");

    
    Dialog_Show(playerid, DIALOG_GRAFFITI_LIST, DIALOG_STYLE_LIST,
        "Lista de Grafitis",
        list,
        "Ir", "Cerrar");

    return 1;
}

CMD:checkgraf(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 3 || level == 5 || level == 7 || level == 9 || level == 11 || level == 13 || level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");

    new closest = Graffiti_FindClosest(playerid, 3.0);
    if (closest == -1)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ningún grafiti cerca.");

    new msg[256];

    if (PlayerInfo[playerid][pAdmin] < 2)
    {
        format(msg, sizeof(msg),
            "Información del Grafiti\n\
            ID DB: %d\n\
            Texto: %s",
            GraffitiInfo[closest][graffitiID],
            GraffitiInfo[closest][graffitiText]
        );
    }
    else if(PlayerInfo[playerid][pAdmin] > 2)
    {
        format(msg, sizeof(msg),
            "Información del Grafiti\n\
            ID DB: %d\n\
            Texto: %s\n\
            Facción ID: %d\n\
            Creador: %s\n\
            Fecha de creación: %s",
            GraffitiInfo[closest][graffitiID],
            GraffitiInfo[closest][graffitiText],
            GraffitiInfo[closest][graffitiFaction],
            GraffitiInfo[closest][graffitiCreator],
            GraffitiInfo[closest][graffitiCreatedAt]
        );
    }
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Información del Grafiti", msg, "Cerrar", "");
    return 1;
}

Dialog:DIALOG_GRAFFITI_LIST(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    new index = 0;
    foreach (new i : GraffitiIter)
    {
        if (!GraffitiInfo[i][graffitiID])
            continue;

        if (index == listitem)
        {
            new Float:x = GraffitiInfo[i][graffitiX];
            new Float:y = GraffitiInfo[i][graffitiY];
            new Float:z = GraffitiInfo[i][graffitiZ];

            SetPlayerPos(playerid, x, y, z + 1.0);
            SetPlayerFacingAngle(playerid, GraffitiInfo[i][graffitiA]);
            SetCameraBehindPlayer(playerid);

            new msg[144];
            format(msg, sizeof(msg),
                "[INFO] "COLOR_EMB_GREY"Teletransportado al grafiti ID %d de la facción %d (%s).",
                GraffitiInfo[i][graffitiID],
                GraffitiInfo[i][graffitiFaction],
                GraffitiInfo[i][graffitiText]
        );
            SendClientMessage(playerid, COLOR_INFO, msg);
            return 1;
        }
        index++;
    }

    return 1;
}

CMD:gotografiti(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 3 || level == 5 || level == 7 || level == 9 || level == 11 || level == 13 || level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");

    new grafID;
    if (sscanf(params, "i", grafID))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/gotografiti [ID de grafiti]");

    foreach (new i : GraffitiIter)
    {
        if (GraffitiInfo[i][graffitiID] == grafID)
        {
            SetPlayerPos(playerid, GraffitiInfo[i][graffitiX], GraffitiInfo[i][graffitiY], GraffitiInfo[i][graffitiZ] + 1.0);
            SetPlayerFacingAngle(playerid, GraffitiInfo[i][graffitiA]);
            SetCameraBehindPlayer(playerid);

            new msg[128];
            format(msg, sizeof(msg), "[INFO] Teletransportado al grafiti ID %d de la facción %d (%s).",
                GraffitiInfo[i][graffitiID],
                GraffitiInfo[i][graffitiFaction],
                GraffitiInfo[i][graffitiText]);
            SendClientMessage(playerid, COLOR_INFO, msg);
            return 1;
        }
    }
    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró ningún grafiti con ese ID.");
    return 1;
}
