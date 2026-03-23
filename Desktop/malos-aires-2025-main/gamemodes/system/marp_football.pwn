#if defined _marp_football_included
	#endinput
#endif
#define _marp_football_included

#include <YSI_Coding\y_hooks>

#define MAX_FIELDS     (3)        // cantidad máxima de canchas
#define BALL_OBJECT_ID 3065       // objeto pelota de basquet
#define MATCH_TIMEOUT  (300)      // 5 minutos de inactividad
#define KICK_RANGE      (1.5)   // rango máximo para patear
#define KICK_PUSH_DIST  (5.0)  // cuánto avanza la pelota
#define KICK_SPEED      (6.0)   // velocidad del movimiento
#define KICK_PUSH_DIST_STRONG  (8.5) // distancia fuerte
#define KICK_SPEED_STRONG      (10.0) // velocidad fuerte
#define KICK_HEIGHT_STRONG     (3.0)  // que la levante un poco
#define DOUBLE_CLICK_MS          (400)                 // ventana para doble click
#define KICK_PUSH_DIST_DOUBLE    (KICK_PUSH_DIST*2)  // 2x distancia
#define KICK_SPEED_DOUBLE        (KICK_SPEED*1.5)     // un toque más rápida

new LastClickTick[MAX_PLAYERS]; // track doble click
#define SCORE_COLOR         0xFFFFFFFF
#define SCORE_DRAW_DIST     (35.0)
#define SCORE_STREAM_DIST   (60.0)

new FieldTeamA[MAX_FIELDS][24];
new FieldTeamB[MAX_FIELDS][24];
new FieldScoreA[MAX_FIELDS];
new FieldScoreB[MAX_FIELDS];


enum e_FIELD {
    STREAMER_TAG_OBJECT:ballID,
    Float:centerX,
    Float:centerY,
    Float:centerZ,
    Float:fieldX1, Float:fieldY1,
    Float:fieldX2, Float:fieldY2,
    Float:lastBallX,
    Float:lastBallY,

        // cartelera marcador ---
    Float:scoreX,
    Float:scoreY,
    Float:scoreZ,
    Text3D:scoreLabel,

    // arcos (detección de gol)
    Float:goalA_X1, Float:goalA_Y1,
    Float:goalA_X2, Float:goalA_Y2,
    Float:goalA_ZMax,
    Float:goalB_X1, Float:goalB_Y1,
    Float:goalB_X2, Float:goalB_Y2,
    Float:goalB_ZMax,

    ballMoveGen,   
    active,
    starterID,
    lastKickTick,
    timerID  // Timer dinámico solo activo cuando el partido está en juego
};

new Fields[MAX_FIELDS][e_FIELD];

// -------------------------------------------------
// Función auxiliar: verificar si jugador está en la cancha
stock bool:IsPlayerInField(playerid, mid)
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    return (px >= Fields[mid][fieldX1] && px <= Fields[mid][fieldX2] &&
            py >= Fields[mid][fieldY1] && py <= Fields[mid][fieldY2]);
}

// -------------------------------------------------
// Función auxiliar: enviar mensaje solo a jugadores en esa cancha
stock SendMatchMessage(mid, color, const text[])
{
    for(new i=0; i<MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && IsPlayerInField(i, mid))
        {
            SendClientMessage(i, color, text);
        }
    }
}

// -------------------------------------------------
// Resetear pelota al centro de la cancha
stock ResetField(mid)
{
    StopDynamicObject(Fields[mid][ballID]);          // 1) frenar
    Fields[mid][ballMoveGen]++;                      // 2) invalidar timers viejos
    SetDynamicObjectPos(
        Fields[mid][ballID],
        Fields[mid][centerX], Fields[mid][centerY], Fields[mid][centerZ]
    );                                               // 3) posicionar
    Fields[mid][active] = 0;
    Fields[mid][starterID] = INVALID_PLAYER_ID;
    FieldScoreA[mid] = 0;
    FieldScoreB[mid] = 0;
    UpdateScoreboard(mid);
}

stock UpdateScoreboard(mid)
{
    new text[128];
    if (FieldTeamA[mid][0] == '\0') format(FieldTeamA[mid], 24, "Locales");
    if (FieldTeamB[mid][0] == '\0') format(FieldTeamB[mid], 24, "Visitantes");

    format(text, sizeof(text), "%s %d  -  %d %s",
           FieldTeamA[mid], FieldScoreA[mid], FieldScoreB[mid], FieldTeamB[mid]);

    if (Fields[mid][scoreLabel])
    {
        UpdateDynamic3DTextLabelText(Fields[mid][scoreLabel], SCORE_COLOR, text);
    }
}

stock CreateFixedScoreboard(mid)
{
    // Crea solo si no existe; no se mueve nunca.
    if (!Fields[mid][scoreLabel])
    {
        Fields[mid][scoreLabel] = CreateDynamic3DTextLabel(
            "MARCADOR DEL PARTIDO", SCORE_COLOR,
            Fields[mid][scoreX], Fields[mid][scoreY], Fields[mid][scoreZ],
            SCORE_DRAW_DIST,
            INVALID_PLAYER_ID,          // attachedplayer
            INVALID_VEHICLE_ID,         // attachedvehicle
            0,                          // testlos (0 = no requiere LOS)
            -1,                         // worldid
            -1,                         // interiorid
            -1,                         // playerid
            SCORE_STREAM_DIST           // Float:streamdistance ? (ahora en la posición correcta)
            // , -1, 0                  // (opcional) areas, priority
        );
    }
    UpdateScoreboard(mid);
}

stock GetRefereeField(playerid)
{
    for (new i = 0; i < MAX_FIELDS; i++)
    {
        if (Fields[i][active] && Fields[i][starterID] == playerid)
            return i;
    }
    return -1;
}

// -------------------------------------------------
// Comando para iniciar un partido
CMD:iniciarpartido(playerid, params[])
{
    for(new i=0; i<MAX_FIELDS; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 10.0, Fields[i][centerX], Fields[i][centerY], Fields[i][centerZ]))
        {
            if(Fields[i][active])
                return SendClientMessage(playerid, -1, "Esta cancha ya está en juego.");

            Fields[i][active] = 1;
            Fields[i][starterID] = playerid;
            Fields[i][lastKickTick] = GetTickCount();
            // Iniciar timer dinámico solo para esta cancha (100ms de intervalo bajo)
            Fields[i][timerID] = SetTimerEx("Field_Update_Selective", 100, true, "i", i);
            SendClientMessage(playerid, -1, "Has iniciado un partido, actuas como arbitro. Utiliza /finalizarpartido en el medio de la cancha para finalizarlo.");
            SendClientMessage(playerid, -1, "Recuerda que el sistema de detección de goles es semi-automático, así que asegurate de que haya sido gol o no!.");
            SendClientMessage(playerid, -1, "De ser necesario, puedes modificar el marcador con /setresultado y /resetresultado.");
            SendClientMessage(playerid, -1, "[COMANDOS] /falta, /setequipos (marcador), /setresultado, /resetresultado.");
            SendMatchMessage(i, -1, "[INFO] ¡El partido comenzó! La pelota ya está activa.");
            return 1;
        }
    }
    return SendClientMessage(playerid, -1, "Debes estar en el medio de una cancha para iniciar el partido.");
}

CMD:ayudafutbol(playerid, params[])
{
    SendClientMessage(playerid, -1, "[----- AYUDA FÚTBOL -----]");
    SendClientMessage(playerid, -1, "/iniciarpartido - Inicia un partido en la cancha donde estás (debes estar en el medio).");
    SendClientMessage(playerid, -1, "/finalizarpartido - Finaliza el partido actual (debes estar en el medio).");
    SendClientMessage(playerid, -1, "/falta - El árbitro puede cobrar falta y regresar la pelota frente a él.");
    SendClientMessage(playerid, -1, "/setequipos EquipoA|EquipoB - Cambia los nombres de los equipos en el marcador (solo árbitro).");
    SendClientMessage(playerid, -1, "/setresultado golesA golesB - Cambia el marcador actual (solo árbitro).");
    SendClientMessage(playerid, -1, "/resetresultado - Resetea el marcador a 0-0 (solo árbitro).");
    SendClientMessage(playerid, -1, "Para patear la pelota: click izquierdo normal (distancia normal), doble click izquierdo (2x distancia), click derecho (patada fuerte con bombeo).");
    return 1;
}   

// -------------------------------------------------
// Comando para finalizar un partido (iniciador o admin)
CMD:finalizarpartido(playerid, params[])
{
    for(new i=0; i<MAX_FIELDS; i++)
    {
        if(Fields[i][active] && IsPlayerInRangeOfPoint(playerid, 10.0, Fields[i][centerX], Fields[i][centerY], Fields[i][centerZ]))
        {
            if(Fields[i][starterID] != playerid && !AdminDuty[playerid])
                return SendClientMessage(playerid, -1, "Solo el jugador que inició o un administrador puede finalizar este partido.");

            // Matar el timer dinámico
            if(Fields[i][timerID] != 0)
                KillTimer(Fields[i][timerID]);
            
            ResetField(i);
            StopDynamicObject(Fields[i][ballID]); 
            SendMatchMessage(i, -1, "[INFO] El partido fue finalizado y la pelota volvió al centro.");
            return 1;
        }
    }
    return SendClientMessage(playerid, -1, "Debes estar cerca del medio para finalizar el partido.");
}

CMD:falta(playerid, params[])
{
    for(new i=0; i<MAX_FIELDS; i++)
    {
        if(Fields[i][active] && Fields[i][starterID] == playerid)
        {
            new Float:px, Float:py, Float:pz, Float:angle;
            GetPlayerPos(playerid, px, py, pz);
            GetPlayerFacingAngle(playerid, angle);

            // Posición enfrente del árbitro
            new Float:dist = 1.0; // distancia de la pelota al frente
            new Float:nx = px + (floatsin(-angle, degrees) * dist);
            new Float:ny = py + (floatcos(-angle, degrees) * dist);

            // Mover pelota
            SetDynamicObjectPos(Fields[i][ballID], nx, ny, pz);
            StopDynamicObject(Fields[i][ballID]);

            SendMatchMessage(i, -1, "[INFO] El árbitro ha cobrado falta. La pelota vuelve al frente suyo.");
            return 1;
        }
    }
    return SendClientMessage(playerid, -1, "Solo el árbitro (iniciador del partido) puede usar /falta.");
}

CMD:setequipos(playerid, params[])
{
    new mid = GetRefereeField(playerid);
    if (mid == -1) return SendClientMessage(playerid, -1, "No sos árbitro de una cancha activa.");

    new a[24], b[24];
    if (isnull(params))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setequipos Equipo A|Equipo B");
    if (sscanf(params, "p<|>S()[24]S()[24]", a, b))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setequipos Equipo A|Equipo B");

    format(FieldTeamA[mid], 24, "%s", a);
    format(FieldTeamB[mid], 24, "%s", b);
    UpdateScoreboard(mid);
    SendMatchMessage(mid, -1, "[INFO] El árbitro actualizó los nombres de los equipos.");
    return 1;
}

CMD:setresultado(playerid, params[])
{
    new mid = GetRefereeField(playerid);
    if (mid == -1) return SendClientMessage(playerid, -1, "No sos árbitro de una cancha activa.");

    new ga, gb;
    if (sscanf(params, "dd", ga, gb))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setresultado <golesA> <golesB>");

    if (ga < 0) ga = 0;
    if (gb < 0) gb = 0;

    FieldScoreA[mid] = ga;
    FieldScoreB[mid] = gb;
    UpdateScoreboard(mid);
    SendMatchMessage(mid, -1, "[INFO] El árbitro actualizó el marcador.");
    return 1;
}

CMD:resetresultado(playerid, params[])
{
    new mid = GetRefereeField(playerid);
    if (mid == -1) return SendClientMessage(playerid, -1, "No sos árbitro de una cancha activa.");

    FieldScoreA[mid] = 0;
    FieldScoreB[mid] = 0;
    UpdateScoreboard(mid);
    SendMatchMessage(mid, -1, "[INFO] El árbitro reseteó el marcador a 0-0.");
    return 1;
}

// -------------------------------------------------
// Patear pelota al hacer click
stock KickBall(playerid, mid, kickType = 0)
{
    if (!Fields[mid][active]) return 0;

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new Float:bx, Float:by, Float:bz;
    GetDynamicObjectPos(Fields[mid][ballID], bx, by, bz);

    new Float:dx = bx - px;
    new Float:dy = by - py;
    new Float:dist2D = floatsqroot(dx*dx + dy*dy);

    if (dist2D <= KICK_RANGE)
    {
        StopDynamicObject(Fields[mid][ballID]);
        GetDynamicObjectPos(Fields[mid][ballID], bx, by, bz);

        if (dist2D == 0.0) dist2D = 0.001;
        dx /= dist2D;
        dy /= dist2D;

        new Float:nx, Float:ny, Float:nz;

        // Invalidamos movimientos previos y tomamos un "gen" nuevo
        Fields[mid][ballMoveGen]++;
        new gen = Fields[mid][ballMoveGen];

        if (kickType == 1)
        {
            // Fuerte con bombeo (click derecho)
            nx = bx + dx * KICK_PUSH_DIST_STRONG;
            ny = by + dy * KICK_PUSH_DIST_STRONG;
            nz = bz + KICK_HEIGHT_STRONG;

            MoveDynamicObject(Fields[mid][ballID], nx, ny, nz, KICK_SPEED_STRONG);

            new mid_local = mid;
            SetTimerEx("Ball_Land", 1000, false, "iiifff",
                       playerid, mid_local, gen, nx, ny, Fields[mid][centerZ]);
        }
        else if (kickType == 2)
        {
            // Doble click izquierdo -> 2x distancia, sin bombeo
            nx = bx + dx * KICK_PUSH_DIST_DOUBLE;
            ny = by + dy * KICK_PUSH_DIST_DOUBLE;
            nz = bz;

            MoveDynamicObject(Fields[mid][ballID], nx, ny, nz, KICK_SPEED_DOUBLE);
        }
        else
        {
            // Normal
            nx = bx + dx * KICK_PUSH_DIST;
            ny = by + dy * KICK_PUSH_DIST;
            nz = bz;

            MoveDynamicObject(Fields[mid][ballID], nx, ny, nz, KICK_SPEED);
        }

        ApplyAnimation(playerid, "FIGHT_D", "FightD_1", 4.1, 0, 1, 1, 0, 0);
        PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0);

        Fields[mid][lastKickTick] = GetTickCount();
        Fields[mid][lastBallX] = nx;
        Fields[mid][lastBallY] = ny;
        return 1;
    }
    return 0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    // Click izquierdo: normal o doble (2x)
    if ((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE))
    {
        new now = GetTickCount();
        new kickType = 0; // 0=normal, 1=fuerte/lob (click derecho), 2=doble-distancia

        if (now - LastClickTick[playerid] <= DOUBLE_CLICK_MS)
        {
            kickType = 2;               
            LastClickTick[playerid] = 0; // reset
        }
        else
        {
            LastClickTick[playerid] = now;
        }

        for (new i = 0; i < MAX_FIELDS; i++)
        {
            if (Fields[i][active])
                KickBall(playerid, i, kickType);
        }
    }

    // Click derecho: patada fuerte (con bombeo)
    if ((newkeys & KEY_HANDBRAKE) && !(oldkeys & KEY_HANDBRAKE))
    {
        for (new i = 0; i < MAX_FIELDS; i++)
        {
            if (Fields[i][active])
                KickBall(playerid, i, 1); // 1 = fuerte / lob
        }
    }

    return 1;
}

// -------------------------------------------------
// Timer dinámico: solo chequea UNA cancha específica
forward Field_Update_Selective(mid);
public Field_Update_Selective(mid)
{
    if(!Fields[mid][active]) return 0;

    new now = GetTickCount();

    // Timeout de inactividad
    if((now - Fields[mid][lastKickTick]) > (MATCH_TIMEOUT*1000))
    {
        ResetField(mid);
        KillTimer(Fields[mid][timerID]);
        Fields[mid][timerID] = 0;
        SendMatchMessage(mid, -1, "[INFO] El partido terminó por inactividad, la pelota volvió al medio.");
        return 1;
    }

    // Detección de goles
    new Float:x, Float:y, Float:z;
    GetDynamicObjectPos(Fields[mid][ballID], x, y, z);

    // Verificar gol en arco A (equipo B anota) - lado sur
    if(x >= Fields[mid][goalA_X1] && x <= Fields[mid][goalA_X2] &&
       y >= Fields[mid][goalA_Y1] && y <= Fields[mid][goalA_Y2] &&
          z >= Fields[mid][centerZ] - 1.0 && z <= Fields[mid][goalA_ZMax])
    {
        FieldScoreB[mid]++;
        UpdateScoreboard(mid);
        
        new msg[128];
        format(msg, sizeof(msg), "[GOL!] ¡%s anotó un gol! Marcador: %s %d - %d %s",
               FieldTeamB[mid], FieldTeamA[mid], FieldScoreA[mid], FieldScoreB[mid], FieldTeamB[mid]);
        SendMatchMessage(mid, 0x00FF00FF, msg);
        
        // Resetear pelota al centro
        StopDynamicObject(Fields[mid][ballID]);
        Fields[mid][ballMoveGen]++;
        SetDynamicObjectPos(Fields[mid][ballID],
            Fields[mid][centerX], Fields[mid][centerY], Fields[mid][centerZ]);
        return 1;
    }

    // Verificar gol en arco B (equipo A anota) - lado norte
    if(x >= Fields[mid][goalB_X1] && x <= Fields[mid][goalB_X2] &&
       y >= Fields[mid][goalB_Y1] && y <= Fields[mid][goalB_Y2] &&
          z >= Fields[mid][centerZ] - 1.0 && z <= Fields[mid][goalB_ZMax])
    {
        FieldScoreA[mid]++;
        UpdateScoreboard(mid);
        
        new msg[128];
        format(msg, sizeof(msg), "[GOL!] ¡%s anotó un gol! Marcador: %s %d - %d %s",
               FieldTeamA[mid], FieldTeamA[mid], FieldScoreA[mid], FieldScoreB[mid], FieldTeamB[mid]);
        SendMatchMessage(mid, 0x00FF00FF, msg);
        
        // Resetear pelota al centro
        StopDynamicObject(Fields[mid][ballID]);
        Fields[mid][ballMoveGen]++;
        SetDynamicObjectPos(Fields[mid][ballID],
            Fields[mid][centerX], Fields[mid][centerY], Fields[mid][centerZ]);
        return 1;
    }

    // Detección de salida del campo
    if(x < Fields[mid][fieldX1] || x > Fields[mid][fieldX2] ||
    y < Fields[mid][fieldY1] || y > Fields[mid][fieldY2])
    {
        StopDynamicObject(Fields[mid][ballID]);
        Fields[mid][ballMoveGen]++;
        SetDynamicObjectPos(Fields[mid][ballID],
            Fields[mid][centerX], Fields[mid][centerY], Fields[mid][centerZ]);

        SendMatchMessage(mid, -1, "[INFO] La pelota salió de la cancha. Se ha regresado al mediocampo.");
    }
    return 1;
}

forward Ball_Land(playerid, mid, gen, Float:nx, Float:ny, Float:finalZ);
public Ball_Land(playerid, mid, gen, Float:nx, Float:ny, Float:finalZ)
{
    if(!Fields[mid][active]) return 0;
    if(gen != Fields[mid][ballMoveGen]) return 0;   // <- timer viejo: ignorar

    // caer al piso del campo
    StopDynamicObject(Fields[mid][ballID]);         // por las dudas, frenar
    MoveDynamicObject(Fields[mid][ballID], nx, ny, finalZ, KICK_SPEED);

   
    return 1;
}
// -------------------------------------------------
// Si el iniciador se desconecta
hook OnPlayerDisconnect(playerid, reason)
{
    for(new i=0; i<MAX_FIELDS; i++)
    {
        if(Fields[i][active] && Fields[i][starterID] == playerid)
        {
            // Matar el timer dinámico
            if(Fields[i][timerID] != 0)
                KillTimer(Fields[i][timerID]);
            
            ResetField(i);
            SendMatchMessage(i, -1, "[INFO] El iniciador se fue, la pelota volvió al centro.");
        }
    }
    return 1;
}

// -------------------------------------------------
// Crear las pelotas desde el inicio
hook OnGameModeInit()
{
    // Cancha 0
    Fields[0][centerX] = 2289.77;
    Fields[0][centerY] = -1527.53;
    Fields[0][centerZ] = 27.00;
    Fields[0][fieldX2] = 2300.09;
    Fields[0][fieldY2] = -1513.77;
    Fields[0][fieldX1] = 2280.48;
    Fields[0][fieldY1] = -1542.30;
    Fields[0][ballID] = CreateDynamicObject(BALL_OBJECT_ID, Fields[0][centerX], Fields[0][centerY], Fields[0][centerZ], 0.0, 0.0, 0.0);
    Fields[0][active] = 0;
    Fields[0][starterID] = INVALID_PLAYER_ID;

    Fields[0][scoreX] = 2280.24;
    Fields[0][scoreY] = -1527.53;
    Fields[0][scoreZ] = 26.88 + 2.5;

    // Arco 1 (Equipo A defiende) - lado sur de la cancha
    // Postes medidos (nuevos): X=2287.56 y X=2291.99 ; línea Y?-1542.44 ; Z travesaño?28.5
    Fields[0][goalA_X1] = 2287.56;
    Fields[0][goalA_X2] = 2291.99;
    Fields[0][goalA_Y1] = -1543.00;  // banda detrás?delante de la línea de gol
    Fields[0][goalA_Y2] = -1541.90;
    Fields[0][goalA_ZMax] = 28.50;

    // Arco 2 (Equipo B defiende) - lado norte de la cancha
    // Postes medidos (nuevos): X=2287.46 y X=2291.88 ; línea Y?-1513.74 ; Z travesaño?28.5
    Fields[0][goalB_X1] = 2287.46;
    Fields[0][goalB_X2] = 2291.88;
    Fields[0][goalB_Y1] = -1514.10;  // banda detrás?delante de la línea de gol
    Fields[0][goalB_Y2] = -1513.10;
    Fields[0][goalB_ZMax] = 28.50;

    // Nombres por defecto y score 0-0
    format(FieldTeamA[0], 24, "Locales");
    format(FieldTeamB[0], 24, "Visitantes");
    FieldScoreA[0] = 0;
    FieldScoreB[0] = 0;

    // Crear cartelera FIJA una sola vez
    CreateFixedScoreboard(0);

    SetDynamicObjectMaterial(Fields[0][ballID], 0, 3003, "pool_blsx", "poolballscue", 0);

    // Los timers se iniciarán dinámicamente cuando se inicie un partido
    // No hay timer global; cada cancha activa tendrá su propio timer de 100ms
    return 1;
}
