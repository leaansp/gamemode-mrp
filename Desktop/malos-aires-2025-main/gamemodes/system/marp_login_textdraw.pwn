// Login TextDraws - muestra/oculta/actualiza el UI de login vía PlayerTextDraws
#define _marp_login_textdraw_included

new PlayerText:PlayerTD[MAX_PLAYERS][8];
new g_LoginTD_Active[MAX_PLAYERS];

stock LoginTD_Show(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    // Si ya está activo, sólo actualizar y mantener selección (evita duplicados)
    if(g_LoginTD_Active[playerid])
    {
        LoginTD_Update(playerid);
        SelectTextDraw(playerid, 0xFFFFFFFF);
        return 1;
    }

    // Limpiar cualquier textdraw previo por si quedaron residuales
    for(new __i = 0; __i < 8; __i++)
    {
        if(PlayerTD[playerid][__i] != PlayerText:INVALID_TEXT_DRAW)
        {
            PlayerTextDrawDestroy(playerid, PlayerTD[playerid][__i]);
            PlayerTD[playerid][__i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }

    // Habilitar modo textdraw (marcar PVar por compatibilidad con otros módulos)
    SetPVarInt(playerid, "TextdrawMode", 1);

    // Crear los 8 textdraws exportados desde NTD (estéticos)
    PlayerTD[playerid][0] = CreatePlayerTextDraw(playerid, -1.0, -1.0, "mdl-2002:VintageEFX");
    PlayerTextDrawFont(playerid, PlayerTD[playerid][0], 4);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][0], 0.6, 2.0);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][0], 641.5, 450.5);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][0], 0);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][0], 50);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][0], 0);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][0]);

    PlayerTD[playerid][1] = CreatePlayerTextDraw(playerid, 219.0, 58.0, "mdl-2002:FondoLOGIN");
    PlayerTextDrawFont(playerid, PlayerTD[playerid][1], 4);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][1], 0.6, 2.0);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][1], 201.0, 332.0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][1], 0);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][1], 0);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][1]);

    PlayerTD[playerid][2] = CreatePlayerTextDraw(playerid, 251.0, 251.0, "mdl-2002:BotonLOGIN");
    PlayerTextDrawFont(playerid, PlayerTD[playerid][2], 4);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][2], 0.6, 2.0);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][2], 137.0, 28.0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][2], 1097458175);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][2], 1687547186);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][2], 1);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][2]);

    PlayerTD[playerid][3] = CreatePlayerTextDraw(playerid, 299.0, 299.0, "mdl-2002:BotonSIGNIN");
    PlayerTextDrawFont(playerid, PlayerTD[playerid][3], 4);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][3], 0.6, 2.0);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][3], 41.5, 9.5);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][3], 0);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][3], 1);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][3]);

    PlayerTD[playerid][4] = CreatePlayerTextDraw(playerid, 272.0, 191.0, "Coloca tu usuario");
    PlayerTextDrawFont(playerid, PlayerTD[playerid][4], 1);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][4], 0.395833, 1.55);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][4], 432.5, 18.0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][4], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][4], -741092353);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][4], 255);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][4], 50);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][4], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][4], 1);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][4]);

    PlayerTD[playerid][5] = CreatePlayerTextDraw(playerid, 272.0, 219.0, "Coloca tu clave");
    PlayerTextDrawFont(playerid, PlayerTD[playerid][5], 1);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][5], 0.395833, 1.55);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][5], 432.5, 18.0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][5], -741092353);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][5], 255);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][5], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][5], 1);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][5]);

    PlayerTD[playerid][6] = CreatePlayerTextDraw(playerid, 522.0, 76.0, "mdl-2002:CHANGELOG");
    PlayerTextDrawFont(playerid, PlayerTD[playerid][6], 4);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][6], 0.6, 2.0);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][6], 111.5, 308.5);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][6], 0);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][6], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][6], 0);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][6], 50);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][6], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][6], 0);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][6]);

    PlayerTD[playerid][7] = CreatePlayerTextDraw(playerid, 3.0, 379.0, "mdl-2002:Music_CHALITA");
    PlayerTextDrawFont(playerid, PlayerTD[playerid][7], 4);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][7], 0.6, 2.0);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][7], 223.5, 60.0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][7], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][7], 0);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][7], 50);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][7], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][7], 0);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][7]);

    // Marcar como activo ANTES de actualizar para que LoginTD_Update funcione
    g_LoginTD_Active[playerid] = 1;
    
    // Actualizar campos con valores actuales (si existen)
    LoginTD_Update(playerid);

    // Activar selección de textdraws
    SelectTextDraw(playerid, 0xFFFFFFFF);

    return 1;
}

stock LoginTD_Update(playerid)
{
    if(!g_LoginTD_Active[playerid]) return 0;

    // Las variables g_MasterUsername / g_MasterPassword se esperan en el mismo unit (incluir marp_multichar después)
    new username[MAX_PLAYER_NAME];
    new password[MAX_PLAYER_NAME];
    username[0] = EOS; password[0] = EOS;
    // Intentaremos leer variables públicas si existen
    GetPVarString(playerid, "Login_Username_TMP", username, sizeof(username));
    GetPVarString(playerid, "Login_Password_TMP", password, sizeof(password));

    if(username[0] == EOS)
        PlayerTextDrawSetString(playerid, PlayerTD[playerid][4], "Coloca tu usuario");
    else
        PlayerTextDrawSetString(playerid, PlayerTD[playerid][4], username);
    
    PlayerTextDrawShow(playerid, PlayerTD[playerid][4]);

    if(password[0] == EOS)
        PlayerTextDrawSetString(playerid, PlayerTD[playerid][5], "Coloca tu clave");
    else
        PlayerTextDrawSetString(playerid, PlayerTD[playerid][5], "**************");
        
    PlayerTextDrawShow(playerid, PlayerTD[playerid][5]);

    return 1;
}

stock LoginTD_Hide(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!g_LoginTD_Active[playerid]) return 1;
    g_LoginTD_Active[playerid] = 0;

    CancelSelectTextDraw(playerid);
    DeletePVar(playerid, "TextdrawMode");

    // Aplicar un fade sobre cada PlayerTextDraw en lugar de destruir inmediatamente.
    // Usamos las utilidades de fade (PlayerTextDrawFadeInOut/PlayerTextDrawBoxFadeInOut)
    // para que se desvanezcan visualmente antes de ser destruidos.
    for(new i=0;i<8;i++)
    {
        if(PlayerTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
        {
            // Fade del color y del box (si tiene). 600ms de transición, sin hold.
            PlayerTextDrawBoxFadeInOut(playerid, PlayerTD[playerid][i], 1, 600, 0, 0xFFFFFFFF, 0, 252);
            PlayerTextDrawFadeInOut(playerid, PlayerTD[playerid][i], 1, 600, 0, 0xFFFFFFFF, 0, 252);

            // Marcar como inválido localmente (el destructor programado seguirá funcionando).
            PlayerTD[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }
    return 1;
}

// Manejar clicks en los textdraws (abrir diálogos o ejecutar acciones)
hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
    if(!g_LoginTD_Active[playerid]) return 0;

    for(new i=0;i<8;i++)
    {
        if(playertextid == PlayerTD[playerid][i])
        {
            switch(i)
            {
                case 2: // Boton LOGIN
                {
                    new username[64], password[64];
                    GetPVarString(playerid, "Login_Username_TMP", username, sizeof(username));
                    GetPVarString(playerid, "Login_Password_TMP", password, sizeof(password));
                    if(username[0] == EOS || password[0] == EOS)
                    {
                        SendClientMessage(playerid, 0xFF0000AA, "Debes completar usuario y contraseña.");
                        return 1;
                    }
                    new query[512], escaped[128];
                    format(escaped, sizeof(escaped), "%s", password);
                    mysql_escape_string(escaped, escaped, sizeof(escaped), MYSQL_HANDLE);
                    mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT id FROM master_accounts WHERE username='%e' AND password_hash=MD5('%s') LIMIT 1", username, escaped);
                    mysql_tquery(MYSQL_HANDLE, query, "OnVerifyMasterPasswordDirect", "i", playerid);
                    return 1;
                }
                case 3: // Boton SIGNIN (registrarse)
                {
                    new username[64], password[64];
                    GetPVarString(playerid, "Login_Username_TMP", username, sizeof(username));
                    GetPVarString(playerid, "Login_Password_TMP", password, sizeof(password));
                    if(username[0] == EOS || password[0] == EOS)
                    {
                        SendClientMessage(playerid, 0xFF0000AA, "Debes completar usuario y contraseña.");
                        return 1;
                    }
                    new query[256];
                    mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT id FROM master_accounts WHERE username='%e' LIMIT 1", username);
                    mysql_tquery(MYSQL_HANDLE, query, "OnCheckMaster_RegDirect", "i", playerid);
                    return 1;
                }
                case 4: // Campo usuario -> abrir diálogo de input
                {
                    // Reusar el diálogo ya existente DLG_MASTER_INPUT_NAME
                    MultiChar_ShowInputName(playerid);
                    return 1;
                }
                case 5: // Campo contraseña -> abrir diálogo de password
                {
                    MultiChar_ShowInputPassword(playerid);
                    return 1;
                }
                default: return 1;
            }
        }
    }
    return 0;
}

// Nota: la limpieza en disconnect/spawn debe ser llamada desde el handler central
// para evitar duplicar la implementación de callbacks globales.
