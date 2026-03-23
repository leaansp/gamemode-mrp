#if defined _marp_fac_missions_included
    #endinput
#endif
#define _marp_fac_missions_included

#include <YSI_Coding\y_hooks>

// ============================================================================
// CONFIG
// ============================================================================
#define FACMIS_CALL_EXPIRE_MS      (2 * 60 * 1000)              // 2 min para aceptar
#define FACMIS_CALL_CHECK_MS       (5 * 60 * 1000)              // generador cada 5 min
#define FACMIS_COOLDOWN_MS         (7 * 24 * 60 * 60 * 1000)    // 7 días

#define FACMIS_REQ_MEMBERS         (30)                          // miembros online - lo dejamos en número grande para deshabilitar la función hasta que esté terminada
#define FACMIS_REQ_COPS_ONDUTY     (50)                          // cops duty

#define FACMIS_REWARD_START        (5000)
#define FACMIS_REWARD_MIN          (1500)
#define FACMIS_REWARD_DECAY_MS     (30 * 60 * 1000)             // 30 min

#define FACMIS_LOADING_MS          (20 * 1000)
#define FACMIS_PROB_911_ALERT      (25)                         // 25%
#define FACMIS_POLICE_NEARBY_DIST  (200.0)

#define FACMIS_VEH_MODEL           (408)                        // camión
#define FACMIS_SYS_NUMBER          (1159110931)

// debug: para testear solo
#define FACMIS_DBG_DEFAULT_COPS    (0)
#define FACMIS_DBG_DEFAULT_MEMBERS (1)
#define FACMIS_DBG_IGNORE_COOLDOWN (1)

// ============================================================================
// TYPES
// ============================================================================
enum e_FACMIS_TYPE
{
    FACMIS_NONE = 0,
    FACMIS_VEHICLE_THEFT,
    FACMIS_DRUG_RUN,
    FACMIS_WEAPON_RUN
};

// ============================================================================
// STATE (por facción)
// ============================================================================
new e_FACMIS_TYPE:gFacMis_Type[MAX_FACTIONS];
new gFacMis_Active[MAX_FACTIONS];
new gFacMis_Initiator[MAX_FACTIONS];
new gFacMis_Assigned[MAX_FACTIONS];
new gFacMis_Stage[MAX_FACTIONS];          // 0 waiting unlock/pickup, 1 unlocked wait enter, 2 loading, 3 transporting
new gFacMis_VehID[MAX_FACTIONS];
new gFacMis_StartTick[MAX_FACTIONS];
new gFacMis_CheckTimer[MAX_FACTIONS];
new gFacMis_LoadTimer[MAX_FACTIONS];
new gFacMis_Alarmed[MAX_FACTIONS];

new Float:gFacMis_Pickup[MAX_FACTIONS][3];
new Float:gFacMis_Delivery[MAX_FACTIONS][3];

// calls/pending
new gFacMis_CallPending[MAX_FACTIONS];
new e_FACMIS_TYPE:gFacMis_CallType[MAX_FACTIONS];
new gFacMis_CallTimer[MAX_FACTIONS];
new gFacMis_LastAcceptedTick[MAX_FACTIONS];

// ============================================================================
// INTERNAL HELPERS
// ============================================================================
static stock FACMIS_IsAdmin(playerid)
{
    return (IsPlayerConnected(playerid) && PlayerInfo[playerid][pAdmin] != 0);
}

static stock FACMIS_NotifyFaction(factionid, color, const msg[])
{
    // tu core ya lo tiene
    SendFactionMessage(factionid, color, msg);
    return 1;
}

static stock FACMIS_Debug(playerid, const fmt[], a=0, b=0, c=0, d=0, e=0, f=0)
{
    if(!FACMIS_IsAdmin(playerid)) return 0;

    new out[220];
    format(out, sizeof(out), fmt, a, b, c, d, e, f);
    SendClientMessage(playerid, COLOR_INFO, out);
    return 1;
}

static stock FACMIS_CleanupMission(factionid, bool:deleteVeh = true)
{
    if(gFacMis_CheckTimer[factionid]) { KillTimer(gFacMis_CheckTimer[factionid]); gFacMis_CheckTimer[factionid] = 0; }
    if(gFacMis_LoadTimer[factionid])  { KillTimer(gFacMis_LoadTimer[factionid]);  gFacMis_LoadTimer[factionid]  = 0; }

    if(deleteVeh && gFacMis_VehID[factionid])
    {
        Veh_Delete(gFacMis_VehID[factionid]);
        gFacMis_VehID[factionid] = 0;
    }

    gFacMis_Type[factionid] = FACMIS_NONE;
    gFacMis_Active[factionid] = 0;
    gFacMis_Initiator[factionid] = INVALID_PLAYER_ID;
    gFacMis_Assigned[factionid] = -1;
            if(!IsPlayerConnected(p)) continue;
            if(PlayerInfo[p][pFaction] != factionid) continue;
            if(!PlayerInfo[p][pAdmin] || !AdminDuty[p]) continue;
            if(GetPlayerVehicleID(p) == gFacMis_VehID[factionid]) { assignedNow = p; break; }
        }

        if(assignedNow >= 0) {
            gFacMis_Assigned[factionid] = assignedNow;
            gFacMis_Stage[factionid] = 1;
            FACMIS_NotifyFaction(factionid, COLOR_INFO, "[MISION] Un administrador en servicio se subió al vehículo; misión avanzó.");
            if(FACMIS_IsAdmin(gFacMis_Initiator[factionid])) FACMIS_Debug(gFacMis_Initiator[factionid], "[FACMIS] Admin-forced unlock: fac=%d assigned=%d", factionid, assignedNow);
            // fall through to allow immediate processing of stage 1 in this tick
        } else {
            return 1;
        }
    }

    new assigned = gFacMis_Assigned[factionid];
    // Si no hay asignado pero ya estamos en stage 1, permitir que un admin que se suba al camión se asigne
    if(assigned < 0 && gFacMis_Stage[factionid] == 1) {
        for(new p = 0; p < MAX_PLAYERS; p++) {
            if(!IsPlayerConnected(p)) continue;
            if(PlayerInfo[p][pFaction] != factionid) continue;
            if(!PlayerInfo[p][pAdmin] || !AdminDuty[p]) continue; // solo admins en servicio pueden forzar el avance
            new pv = GetPlayerVehicleID(p);
            if(pv != INVALID_VEHICLE_ID && pv == gFacMis_VehID[factionid]) {
                gFacMis_Assigned[factionid] = p;
                assigned = p;
                FACMIS_NotifyFaction(factionid, COLOR_INFO, "[MISION] Un administrador se subió al vehículo y la misión avanzó.");
                break;
            }
        }
    }

    if(assigned < 0 || !IsPlayerConnected(assigned))
    {
        FACMIS_CancelMission(factionid, "[MISION] Cancelada: asignado inválido/desconectado.");
        return 1;
    }

    if(PlayerInfo[assigned][pJailed] != JAIL_NONE)
    {
        FACMIS_CancelMission(factionid, "[MISION] Arrestado. Misión perdida.");
        return 1;
    }

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(assigned, px, py, pz);

    // STAGE 1: unlocked -> entrar al camión
    if(gFacMis_Stage[factionid] == 1)
    {
        if(GetPlayerVehicleID(assigned) == gFacMis_VehID[factionid])
        {
            gFacMis_Stage[factionid] = 2;

            SendClientMessage(assigned, COLOR_INFO, "Cargando...");

            gFacMis_Alarmed[factionid] = 0;
            if(random(100) < FACMIS_PROB_911_ALERT)
            {
                gFacMis_Alarmed[factionid] = 1;

                new alert[160];
                format(alert, sizeof(alert), "[911] Robo de vehículo en %.0f, %.0f.",
                    gFacMis_Pickup[factionid][0], gFacMis_Pickup[factionid][1]
                );

                        SendClientMessage(c, COLOR_CENTRALRED, alert);
                }
            }

            if(gFacMis_LoadTimer[factionid]) { KillTimer(gFacMis_LoadTimer[factionid]); gFacMis_LoadTimer[factionid] = 0; }
            gFacMis_LoadTimer[factionid] = SetTimerEx("FACMIS_LoadComplete", FACMIS_LOADING_MS, false, "i", factionid);
        }
        return 1;
    }

    // STAGE 3: delivery
    if(gFacMis_Stage[factionid] == 3)
    {
        new Float:dx = px - gFacMis_Delivery[factionid][0];
        new Float:dy = py - gFacMis_Delivery[factionid][1];

        if(floatsqroot(dx*dx + dy*dy) <= 10.0 && IsPlayerInAnyVehicle(assigned))
        {
            // cops nearby?
            new copsNearby = 0;
            foreach(new c : Player)
            {
                if(!isPlayerCopOnDuty(c)) continue;

                new Float:cx, Float:cy, Float:cz;
                GetPlayerPos(c, cx, cy, cz);

                new Float:ddx = cx - px;
                new Float:ddy = cy - py;

                if(floatsqroot(ddx*ddx + ddy*ddy) <= FACMIS_POLICE_NEARBY_DIST) { copsNearby = 1; break; }
            }

            if(copsNearby)
            {
                SendClientMessage(assigned, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Hay policía cerca. No podés completar todavía.");
            }
            else
            {
                CallLocalFunction("FACMIS_CompleteMission", "i", factionid);
            }
        }
    }

    return 1;
}

forward FACMIS_LoadComplete(factionid);
public FACMIS_LoadComplete(factionid)
{
    if(!gFacMis_Active[factionid]) return 1;
    if(gFacMis_Stage[factionid] != 2) return 1;

    new assigned = gFacMis_Assigned[factionid];
    if(assigned < 0 || !IsPlayerConnected(assigned))
    {
        FACMIS_CancelMission(factionid, "[MISION] Carga fallida: asignado desconectó.");
        return 1;
    }

    if(GetPlayerVehicleID(assigned) != gFacMis_VehID[factionid])
    {
        SendClientMessage(assigned, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Saliste del vehículo. Carga interrumpida.");
        gFacMis_Stage[factionid] = 1;
        gFacMis_LoadTimer[factionid] = 0;
        return 1;
    }

    gFacMis_Stage[factionid] = 3;
    gFacMis_LoadTimer[factionid] = 0;

    new msg[170];
    format(msg, sizeof(msg), "[MISION] Carga completa. Entrega en %.0f, %.0f.",
        gFacMis_Delivery[factionid][0], gFacMis_Delivery[factionid][1]
    );
    FACMIS_NotifyFaction(factionid, COLOR_INFO, msg);
    
    // crear marker de delivery para el asignado (y miembros de la facción conectados)
    new Float:dx = gFacMis_Delivery[factionid][0], Float:dy = gFacMis_Delivery[factionid][1], Float:dz = gFacMis_Delivery[factionid][2];
    for(new p = 0; p < MAX_PLAYERS; p++) {
        if(!IsPlayerConnected(p)) continue;
        if(PlayerInfo[p][pFaction] != factionid) continue;
        MapMarker_CreateForPlayer(p, dx, dy, dz, .color = COLOR_YELLOW2, .time = 300000);
    }
    return 1;
}

// ============================================================================
// CORE: ACCEPT / START
// ============================================================================
static stock FACMIS_StartMission(playerid, factionid, e_FACMIS_TYPE:type, bool:debugBypass = false)
{
    if(!Faction_IsValidId(factionid)) return 0;
    if(gFacMis_Active[factionid]) return 0;

    // sólo facciones con tag (excepto bypass admin)
    if(!debugBypass)
    {
        if(!Faction_HasTag(factionid, FAC_TAG_ILLEGAL_MISSIONS))
        {
            SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Esta facción no tiene permitido misiones ilegales.");
            return 0;
        }
    }

    // pools
    new Float:pickup_pool[5][3] = {
        {2284.64,-1678.97,14.34},
        {2519.51,-1469.08,23.98},
        {2794.66,-1571.89,10.92},
        {2604.48,-2207.23,13.54},
        {2453.21,-1767.26,13.57}
    };
    new Float:delivery_pool[5][3] = {
        {2136.56,-81.47,2.95},
        {1923.84,174.04,37.28},
        {1556.11,16.96,24.16},
        {1020.22,-322.45,73.99},
        {325.23,-55.92,1.53}
    };

    /*

    gFacMis_Delivery[factionid][0] = delivery_pool[idx][0];
    gFacMis_Delivery[factionid][1] = delivery_pool[idx][1];
    gFacMis_Delivery[factionid][2] = delivery_pool[idx][2];


    // Stubs: mantener firmas públicas/forwards mínimas para que el resto del gamemode compile.
    forward FactionMission_OnVehUnlocked(playerid, vehicleid);
    public FactionMission_OnVehUnlocked(playerid, vehicleid) { return 0; }

    forward FACMIS_Generator();
    public FACMIS_Generator() { return 0; }

    forward FACMIS_CallExpire(factionid);
    public FACMIS_CallExpire(factionid) { return 1; }

    forward FACMIS_CheckProgress(factionid);
    public FACMIS_CheckProgress(factionid) { return 1; }

    forward FACMIS_LoadComplete(factionid);
    public FACMIS_LoadComplete(factionid) { return 1; }

    forward FACMIS_CancelMission(factionid, const reason[]);
    public FACMIS_CancelMission(factionid, const reason[]) { return 1; }

    forward FACMIS_CompleteMission(factionid);
    public FACMIS_CompleteMission(factionid) { return 1; }

    static stock FACMIS_Init() { return 1; }
    static stock FACMIS_NotifyFaction(factionid, color, const msg[]) { return 1; }

    // Nota: el resto de símbolos del módulo han sido removidos/commentados.
    gFacMis_Type[factionid] = type;
    gFacMis_Active[factionid] = 1;
    gFacMis_Initiator[factionid] = playerid;
    gFacMis_Assigned[factionid] = -1;
    gFacMis_Stage[factionid] = 0;
    gFacMis_VehID[factionid] = 0;
    gFacMis_StartTick[factionid] = GetTickCount();
    gFacMis_LastAcceptedTick[factionid] = GetTickCount();

    // crear misión según tipo
    if(type == FACMIS_VEHICLE_THEFT)
    {
        new veh = Veh_Create(FACMIS_VEH_MODEL, 0, 0,
            gFacMis_Pickup[factionid][0],
            gFacMis_Pickup[factionid][1],
            gFacMis_Pickup[factionid][2],
            0.0, 0, 0, 0
        );

        gFacMis_VehID[factionid] = veh;
        VehicleInfo[veh][VehLocked] = 1;

        new msg[220];
        format(msg, sizeof(msg),
            "[MISION] %s aceptó: Robar camión. Objetivo en %.0f %.0f. Usa /barreta para abrirlo.",
            GetPlayerNameEx(playerid),
            gFacMis_Pickup[factionid][0], gFacMis_Pickup[factionid][1]
        );
        FACMIS_NotifyFaction(factionid, COLOR_INFO, msg);

        // Crear marker de pickup para miembros conectados
        new Float:px = gFacMis_Pickup[factionid][0], Float:py = gFacMis_Pickup[factionid][1], Float:pz = gFacMis_Pickup[factionid][2];
        for(new p = 0; p < MAX_PLAYERS; p++) {
            if(!IsPlayerConnected(p)) continue;
            if(PlayerInfo[p][pFaction] != factionid) continue;
            MapMarker_CreateForPlayer(p, px, py, pz, .color = COLOR_YELLOW2, .time = 300000);
        }
        if(FACMIS_IsAdmin(playerid))
        {
            FACMIS_Debug(playerid, "[FACMIS] Veh spawneado id=%d locked=%d", veh, VehicleInfo[veh][VehLocked]);
        }
    }
    else
    {
        // Para drug/weapon run, tu lógica actual puede extenderse después.
        // Por ahora lo dejamos preparado pero no implementamos el flujo completo de carga con vehículo propio
        // porque tu prioridad era VEHICLE_THEFT + barreta (lo que te trababa).
        FACMIS_CancelMission(factionid, "[MISION] (WIP) Tipo no soportado - misión cancelada.");
        return 0;
    }

    // monitor
    if(gFacMis_CheckTimer[factionid]) { KillTimer(gFacMis_CheckTimer[factionid]); gFacMis_CheckTimer[factionid] = 0; }
    gFacMis_CheckTimer[factionid] = SetTimerEx("FACMIS_CheckProgress", 5000, true, "i", factionid);

    return 1;
}

// ============================================================================
// VEH UNLOCK ENTRYPOINT (llamado desde /barreta via CallLocalFunction)
// ============================================================================
forward FactionMission_OnVehUnlocked(playerid, vehicleid);
public FactionMission_OnVehUnlocked(playerid, vehicleid)
{
    if(vehicleid == 0) return 0;

    for(new fid = 1; fid < MAX_FACTIONS; fid++)
    {
        if(!gFacMis_Active[fid]) continue;
        if(gFacMis_Type[fid] != FACMIS_VEHICLE_THEFT) continue;
        if(gFacMis_VehID[fid] != vehicleid) continue;
        if(gFacMis_Stage[fid] != 0) continue;

        // 1/10 alarma => cancel
        if(random(10) == 0)
        {
            foreach(new c : Player)
            {
                if(isPlayerCopOnDuty(c))
                    SendClientMessage(c, COLOR_CENTRALRED, "[911] Sonó una alarma durante un robo de vehículo (posible camión).");
            }

            FACMIS_CancelMission(fid, "[MISION] Alarma activada al forzar cerradura. Misión cancelada.");
            return 1;
        }

        gFacMis_Assigned[fid] = playerid;
        gFacMis_Stage[fid] = 1;

        new msg[170];
        format(msg, sizeof(msg), "[MISION] %s abrió la cerradura. Entra al camión para iniciar la carga.",
            GetPlayerNameEx(playerid)
        );
        FACMIS_NotifyFaction(fid, COLOR_INFO, msg);

        if(FACMIS_IsAdmin(gFacMis_Initiator[fid]))
            FACMIS_Debug(gFacMis_Initiator[fid], "[FACMIS] Unlock OK: fac=%d assigned=%d stage=%d", fid, playerid, gFacMis_Stage[fid]);

        return 1;
    }

    return 0;
}

// ============================================================================
// COMPLETE
// ============================================================================
forward FACMIS_CompleteMission(factionid);
public FACMIS_CompleteMission(factionid)
{
    if(!gFacMis_Active[factionid]) return 0;

    new now = GetTickCount();
    new elapsed = now - gFacMis_StartTick[factionid];
    if(elapsed < 0) elapsed = 0;

    new diff = FACMIS_REWARD_START - FACMIS_REWARD_MIN;
    new cap = (elapsed > FACMIS_REWARD_DECAY_MS) ? (FACMIS_REWARD_DECAY_MS) : (elapsed);
    new dec = (diff * cap) / FACMIS_REWARD_DECAY_MS;

    new per = FACMIS_REWARD_START - dec;
    if(per < FACMIS_REWARD_MIN) per = FACMIS_REWARD_MIN;

    new count = 0;
    foreach(new p : Player)
    {
        if(PlayerInfo[p][pFaction] != factionid) continue;
        GivePlayerCash(p, per);
        count++;
    }

    new msg[170];
    format(msg, sizeof(msg), "[MISION] %s completó la misión. %d jugadores cobraron $%d c/u.",
        FactionInfo[factionid][fName], count, per
    );
    FACMIS_NotifyFaction(factionid, COLOR_INFO, msg);

    FACMIS_CleanupMission(factionid);
    return 1;
}

// ============================================================================
// COMMANDS
// ============================================================================
CMD:afdbgstart(playerid, params[])
{
    if(!FACMIS_IsAdmin(playerid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo admins.");

    new factionid = PlayerInfo[playerid][pFaction];
    new typ = 1;

    // /afdbgstart [factionid] [tipo]
    if(sscanf(params, "ii", factionid, typ))
    {
        // 1 param?
        if(sscanf(params, "i", factionid))
        {
            factionid = PlayerInfo[playerid][pFaction];
        }
    }

    if(!Faction_IsValidId(factionid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Facción inválida.");

    new e_FACMIS_TYPE:type = FACMIS_VEHICLE_THEFT;
    if(typ == 2) type = FACMIS_DRUG_RUN;
    else if(typ == 3) type = FACMIS_WEAPON_RUN;

    // debug bypass: no cops/members/cooldown
    FACMIS_Debug(playerid, "[FACMIS][DBG] Forzando misión fac=%d type=%d (bypass=%d)", factionid, _:type, 1);

    // cancelar pending si hubiera
    FACMIS_ResetCall(factionid);

    if(!FACMIS_StartMission(playerid, factionid, type, true))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"[FACMIS][DBG] No se pudo iniciar (ya activa o tipo WIP).");

    SendClientMessage(playerid, COLOR_INFO, "[FACMIS][DBG] OK. Si es robo camión: andá al punto y usá /barreta.");
    return 1;
}

CMD:afinfomision(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	
    new factionid = PlayerInfo[playerid][pFaction];
    if(!Faction_IsValidId(factionid) || !gFacMis_Active[factionid])
        return SendClientMessage(playerid, COLOR_INFO, "No hay misión activa para tu facción.");

    new msg[200];
    format(msg, sizeof(msg),
        "Tipo=%d Stage=%d Assigned=%d Veh=%d Pickup=%.0f %.0f Delivery=%.0f %.0f",
        _:gFacMis_Type[factionid],
        gFacMis_Stage[factionid],
        gFacMis_Assigned[factionid],
        gFacMis_VehID[factionid],
        gFacMis_Pickup[factionid][0], gFacMis_Pickup[factionid][1],
        gFacMis_Delivery[factionid][0], gFacMis_Delivery[factionid][1]
    );
    SendClientMessage(playerid, COLOR_INFO, msg);
    return 1;
}

CMD:afabortar(playerid, params[])
{	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
		// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso avanzado a Faction Control
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 15 || level == 17 || level == 19 || level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	
    new factionid = PlayerInfo[playerid][pFaction];
    if(!Faction_IsValidId(factionid) || !gFacMis_Active[factionid])
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay misión activa.");

    if(!FACMIS_IsAdmin(playerid) && PlayerInfo[playerid][pRank] != 1 && gFacMis_Assigned[factionid] != playerid)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo líder/asignado (o admin).");

    FACMIS_CancelMission(factionid, "[MISION] Abortada por la facción.");
    return 1;
}

// ============================================================================
// SMS ACCEPT (hook)
// ============================================================================
hook OnSMSReceived(PHONE_HANDLE:phone, from_number)
{
    if(phone != Phone_GetNumberHandle(FACMIS_SYS_NUMBER))
        return 1;

    new msg[PHONESMS_MAX_LENGTH];
    new fn = 0;
    if(!PhoneSMS_GetFirst(phone, fn, msg))
        return 1;

    if(strcmp(msg, "acepto", true) != 0)
        return 1;

    // encontrar facción con pending cuyo líder tenga ese número
    for(new fid = 1; fid < MAX_FACTIONS; fid++)
    {
        if(!gFacMis_CallPending[fid]) continue;

        foreach(new p : Player)
        {
            if(PlayerInfo[p][pFaction] != fid) continue;
            if(PlayerInfo[p][pRank] != 1) continue;
            if(PlayerInfo[p][pPhoneNumber] != from_number) continue;

            new e_FACMIS_TYPE:type = gFacMis_CallType[fid];
            FACMIS_ResetCall(fid);

            if(!FACMIS_StartMission(p, fid, type, false))
            {
                PhoneSMS_Send(phone, from_number, "No se pudo iniciar la misión (ya activa o no permitida).");
                return 1;
            }

            PhoneSMS_Send(phone, from_number, "Aceptado. La misión comenzó.");
            return 1;
        }
    }

    PhoneSMS_Send(phone, from_number, "No se encontró un llamado para tu número (o no sos líder conectado).");
    return 1;
}
