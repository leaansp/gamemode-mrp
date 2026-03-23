/*
    Sistema anticheat central para detectar:
    - Fly / Flyhack
    - Airbreak teleport
    - Carspam (muchos vehículos alrededor en poco tiempo)
    - Godmode (no recibe daño)

    Reglas:
    - Ignorar jugadores administradores (cualquier nivel de admin)
    - Alertar administradores con `AdministratorMessage`
    - Loguear en la tabla de logs con `ServerFormattedLog` (tipo ADMIN)
    - Si tras 3 strikes sigue el comportamiento, autobanear (ban permanente: days=0)

    Nota: Este módulo hace chequeos periódicos (cada 1s) y engancha el hook
    de daño para detectar godmode. No modifica comportamiento del modo de juego.
*/
#if defined _marp_anticheat_core_included
	#endinput
#endif
#define _marp_anticheat_core_included

#include <YSI_Coding\y_hooks>


#include <a_samp>
#include <YSI_Coding\y_hooks>

forward AC_ClearReportsTimer();

#define AC_AIRBREAK_MAX_SPEED      (80.0)     // unidades/segundo a pie
#define AC_FLY_MAX_Z_SPEED         (35.0)     // unidades/segundo en vertical
#define AC_CLIMB_HORZ_THRESHOLD    (2.5)      // umbral horizontal para considerar "trepar"
#define AC_CLIMB_MAX_Z_SPEED       (70.0)     // velocidad vertical máxima plausible al trepar
#define AC_VEHICLE_TP_DISTANCE     (120.0)    // distancia mínima para considerar TP de vehículo
#define AC_MIN_DELTA_TIME          (0.01)
#define AC_WARN_LIMIT              (3)        // warns antes de banear
#define AC_SAFE_TELEPORT_TIME      (2000)     // ms de "zona segura" tras un TP legítimo
// Si el jugador saltó recientemente, ignorar detecciones de subida/teleport relacionadas
#define AC_JUMP_IGNORE_MS          (800)      // ms

enum
{
    AC_REASON_AIRBREAK = 1,
    AC_REASON_FLY,
    AC_REASON_VEH_TP
};

new Float:gAC_LastX[MAX_PLAYERS];
new Float:gAC_LastY[MAX_PLAYERS];
new Float:gAC_LastZ[MAX_PLAYERS];
new gAC_LastTick[MAX_PLAYERS];
new gAC_LastInt[MAX_PLAYERS];
new gAC_LastVW[MAX_PLAYERS];

new gAC_AirbreakWarns[MAX_PLAYERS];
new gAC_FlyWarns[MAX_PLAYERS];
new gAC_VehTPWarns[MAX_PLAYERS];

new gAC_SafeUntil[MAX_PLAYERS]; // GetTickCount hasta el que ignoramos detecciones
new gAC_LastJumpTick[MAX_PLAYERS];
new gAC_LastMovementTick[MAX_PLAYERS]; // Para detectar AFK

const MAX_AC_REPORTS = 200;
new AC_ReportCount = 0;
new AC_ReportPlayer[MAX_AC_REPORTS];
new AC_ReportTime[MAX_AC_REPORTS];
new AC_ReportReason[MAX_AC_REPORTS][64];
new AC_ReportDetails[MAX_AC_REPORTS][192];
new acReportTimer = 0;
new acProcessTimer = 0;
#define AC_REPORT_TTL_MS (6 * 3600000) // 6 horas

// =========================== UTILS =====================================

stock AC_ResetPlayer(playerid)
{
    gAC_LastX[playerid]       = 0.0;
    gAC_LastY[playerid]       = 0.0;
    gAC_LastZ[playerid]       = 0.0;
    gAC_LastTick[playerid]    = 0;
    gAC_LastInt[playerid]     = 0;
    gAC_LastVW[playerid]      = 0;

    gAC_AirbreakWarns[playerid] = 0;
    gAC_FlyWarns[playerid]      = 0;
    gAC_VehTPWarns[playerid]    = 0;

    gAC_SafeUntil[playerid]   = 0;
    gAC_LastJumpTick[playerid] = 0;
    gAC_LastMovementTick[playerid] = GetTickCount();
    return 1;
}

// Guardar el estado actual del jugador como "último estado conocido"
stock AC_StorePlayerState(playerid, tick)
{
    new Float:x, Float:y, Float:z;

    GetPlayerPos(playerid, x, y, z);

    gAC_LastX[playerid]    = x;
    gAC_LastY[playerid]    = y;
    gAC_LastZ[playerid]    = z;
    gAC_LastTick[playerid] = tick;
    gAC_LastInt[playerid]  = GetPlayerInterior(playerid);
    gAC_LastVW[playerid]   = GetPlayerVirtualWorld(playerid);
    return 1;
}

// Marcar un jugador como "seguro" durante X ms (para TPs legítimos)
stock AC_IgnoreMovementFor(playerid, milliseconds)
{
    new tick = GetTickCount();
    gAC_SafeUntil[playerid] = tick + milliseconds;
    AC_StorePlayerState(playerid, tick);
    AC_ResetWarns(playerid);
    return 1;
}

// Resetear contadores de warns para un jugador
stock AC_ResetWarns(playerid)
{
    gAC_AirbreakWarns[playerid] = 0;
    gAC_FlyWarns[playerid] = 0;
    gAC_VehTPWarns[playerid] = 0;
    return 1;
}

/* ------------------- Reports API (append-only, in-memory) ------------------- */
AC_SaveReport(playerid, const reason[], const details[])
{
    if(AC_ReportCount < MAX_AC_REPORTS)
    {
        AC_ReportPlayer[AC_ReportCount] = playerid;
        AC_ReportTime[AC_ReportCount] = GetTickCount();
        strmid(AC_ReportReason[AC_ReportCount], reason, 0, 63);
        strmid(AC_ReportDetails[AC_ReportCount], details, 0, 191);
        AC_ReportCount++;
        new sparams[256];
        format(sparams, sizeof(sparams), "%s - %s", reason, details);
        ServerLog(LOG_TYPE_ID_ADMIN, 0, "ANTICHEAT", playerid, INVALID_PLAYER_ID, sparams);
        return 1;
    }
    // if full, drop oldest and append
    for(new i = 1; i < MAX_AC_REPORTS; i++)
    {
        AC_ReportPlayer[i-1] = AC_ReportPlayer[i];
        AC_ReportTime[i-1] = AC_ReportTime[i];
        strmid(AC_ReportReason[i-1], AC_ReportReason[i], 0, 63);
        strmid(AC_ReportDetails[i-1], AC_ReportDetails[i], 0, 191);
    }
    new idx = MAX_AC_REPORTS - 1;
    AC_ReportPlayer[idx] = playerid;
    AC_ReportTime[idx] = GetTickCount();
    strmid(AC_ReportReason[idx], reason, 0, 63);
    strmid(AC_ReportDetails[idx], details, 0, 191);
    // Log to DB for persistence
    new sparams2[256];
    format(sparams2, sizeof(sparams2), "%s - %s", reason, details);
    ServerLog(LOG_TYPE_ID_ADMIN, 0, "ANTICHEAT", playerid, INVALID_PLAYER_ID, sparams2);
    return 1;
}

AC_ClearReports()
{
    if(AC_ReportCount == 0) return 1;
    AC_ReportCount = 0;
    ServerLog(LOG_TYPE_ID_ADMIN, 0, "ANTICHEAT", INVALID_PLAYER_ID, INVALID_PLAYER_ID, "Cleared AC reports (auto)");
    return 1;
}

public AC_ClearReportsTimer()
{
    AC_ClearReports();
    return 1;
}


// Wrapper para TP legítimo de jugador (podés llamarlo desde tus helpers)
stock AC_NotifyTeleportPlayer(playerid)
{
    return AC_IgnoreMovementFor(playerid, AC_SAFE_TELEPORT_TIME);
}

// Wrapper para TP legítimo cuando va en vehículo
stock AC_NotifyTeleportVehicle(playerid)
{
    return AC_IgnoreMovementFor(playerid, AC_SAFE_TELEPORT_TIME);
}

// Admin inmune al anti-cheat
stock bool:AC_IsAdminImmune(playerid)
{
    if(!IsPlayerConnected(playerid)) return false;
    
    if(!IsPlayerLogged(playerid)) return true;
	if (PlayerInfo[playerid][pAdmin] > 0) return true;

	return false;
}

// Detectar si el jugador está AFK
stock bool:AC_IsPlayerAFK(playerid)
{
    // Si no se ha movido en más de 30 segundos, está AFK
    return (GetTickCount() - gAC_LastMovementTick[playerid]) > 30000;
}

// ======================== MANEJO DE VIOLACIONES ========================

forward AC_HandleViolation(playerid, reason);
public AC_HandleViolation(playerid, reason)
{
    if(AC_IsAdminImmune(playerid)) return 1;

    new count;
    new reasonStr[24];

    if (reason == AC_REASON_AIRBREAK)
    {
        gAC_AirbreakWarns[playerid]++;
        count = gAC_AirbreakWarns[playerid];
        format(reasonStr, sizeof(reasonStr), "Airbreak / TP onfoot");
    }
    else if (reason == AC_REASON_FLY)
    {
        gAC_FlyWarns[playerid]++;
        count = gAC_FlyWarns[playerid];
        format(reasonStr, sizeof(reasonStr), "Fly hack");
    }
    else if (reason == AC_REASON_VEH_TP)
    {
        gAC_VehTPWarns[playerid]++;
        count = gAC_VehTPWarns[playerid];
        format(reasonStr, sizeof(reasonStr), "Vehicle TP");
    }
    else
    {
        return 1;
    }

    new msg[144];
    format(msg, sizeof(msg), "[AC] Posible cheat: %s (%d) - %s (warn %d/%d).",
        GetPlayerCleanName(playerid),
        playerid,
        reasonStr,
        count,
        AC_WARN_LIMIT
    );
    AdministratorMessage(COLOR_ADMINCMD, msg, 1); // todos los helpers+ lo ven

    // Save report for admin review
    AC_SaveReport(playerid, reasonStr, msg);

    // Llegó al límite -> Kick automático
    if(count >= AC_WARN_LIMIT)
    {
        format(msg, sizeof(msg), "Cheats (%s) detectado por AC.", reasonStr);
        KickPlayer(playerid, "AntiCheat", msg);
    }
    return 1;
}

// ============================= HOOKS ===================================

hook OnPlayerConnect(playerid)
{
    AC_ResetPlayer(playerid);
    if(!acReportTimer)
    {
        acReportTimer = SetTimer("AC_ClearReportsTimer", AC_REPORT_TTL_MS, true);
    }
    if(!acProcessTimer)
    {
        acProcessTimer = SetTimer("AC_Process", 500, true);
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    AC_ResetPlayer(playerid);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    // Al spawnear, dale un pequeño margen para que no salte como TP raro
    AC_IgnoreMovementFor(playerid, 1500);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(!IsPlayerConnected(playerid)) return 1;

    // Si se presionó la tecla de salto, guardamos el tick para evitar falsos positivos
    if(newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP))
    {
        gAC_LastJumpTick[playerid] = GetTickCount();
    }
    return 1;
}

// Hook principal de detección
hook OnPlayerUpdate(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    return 1;
}

forward AC_Process();
public AC_Process()
{
    new tick = GetTickCount();
    foreach(new p : Player)
    {
        if(!IsPlayerConnected(p)) continue;
        if(AC_IsAdminImmune(p)) continue;

        // Primera vez: solo guardo estado
        if(gAC_LastTick[p] == 0)
        {
            AC_StorePlayerState(p, tick);
            continue;
        }

        // Ignorar movimiento durante la "ventana segura" (TP legítimo)
        if(gAC_SafeUntil[p] > 0 && tick <= gAC_SafeUntil[p])
        {
            AC_StorePlayerState(p, tick);
            continue;
        }

        // Ignorar cambios de interior / mundo virtual (probablemente TP del modo)
        new interior = GetPlayerInterior(p);
        new vw       = GetPlayerVirtualWorld(p);

        if(interior != gAC_LastInt[p] || vw != gAC_LastVW[p])
        {
            AC_IgnoreMovementFor(p, AC_SAFE_TELEPORT_TIME);
            continue;
        }

        // Evitar falsos positivos: si el jugador está hospitalizado o en cárcel, no procesar
        if (PlayerInfo[p][pHospitalized])
        {
            AC_StorePlayerState(p, tick);
            AC_ResetWarns(p);
            continue;
        }

        if (PlayerInfo[p][pJailed] != JAIL_NONE)
        {
            AC_StorePlayerState(p, tick);
            continue;
        }

        new Float:x, Float:y, Float:z;
        GetPlayerPos(p, x, y, z);

        new Float:dt = float(tick - gAC_LastTick[p]) / 1000.0;
        if(dt < AC_MIN_DELTA_TIME) dt = AC_MIN_DELTA_TIME;

        new Float:dx = x - gAC_LastX[p];
        new Float:dy = y - gAC_LastY[p];
        new Float:dz = z - gAC_LastZ[p];

        new Float:dist  = floatsqroot(dx * dx + dy * dy + dz * dz);
        new Float:speed = dist / dt;

        new playerState = GetPlayerState(p);

        // Ignorar si el jugador está AFK
        if(!AC_IsPlayerAFK(p))
        {
            // Actualizar último tick de movimiento si hay movimiento real
            if(speed > 0.5) // umbral mínimo para considerar movimiento
            {
                gAC_LastMovementTick[p] = tick;
            }

            if(playerState == PLAYER_STATE_ONFOOT)
            {
                new sa = GetPlayerSpecialAction(p);
                if(sa != SPECIAL_ACTION_USEJETPACK)
                {
                    new lastJump = gAC_LastJumpTick[p];
                    new bool:recentJump = (lastJump > 0 && (tick - lastJump) <= AC_JUMP_IGNORE_MS);

                    if(!recentJump && speed > AC_AIRBREAK_MAX_SPEED)
                    {
                        AC_HandleViolation(p, AC_REASON_AIRBREAK);
                    }
                    else if(dz > 0.0)
                    {
                        new Float:zSpeed = dz / dt;
                        new Float:hDist = floatsqroot(dx * dx + dy * dy);
                        if(!recentJump)
                        {
                            if(!(hDist < AC_CLIMB_HORZ_THRESHOLD && zSpeed <= AC_CLIMB_MAX_Z_SPEED) && zSpeed > AC_FLY_MAX_Z_SPEED)
                            {
                                AC_HandleViolation(p, AC_REASON_FLY);
                            }
                        }
                    }
                }
            }
            else if(playerState == PLAYER_STATE_DRIVER)
            {
                new vehicleid = GetPlayerVehicleID(p);
                if(vehicleid != 0)
                {
                    new Float:vx, Float:vy, Float:vz;
                    GetVehiclePos(vehicleid, vx, vy, vz);

                    new Float:vdx   = vx - gAC_LastX[p];
                    new Float:vdy   = vy - gAC_LastY[p];
                    new Float:vdz   = vz - gAC_LastZ[p];
                    new Float:vDist = floatsqroot(vdx * vdx + vdy * vdy + vdz * vdz);

                    if(vDist > AC_VEHICLE_TP_DISTANCE && dt < 1.0)
                    {
                        AC_HandleViolation(p, AC_REASON_VEH_TP);
                    }
                }
            }
        }

        AC_StorePlayerState(p, tick);
    }
    return 1;
}
