#if defined _marp_vehicle_wear_included
    #endinput
#endif
#define _marp_vehicle_wear_included

#include <YSI_Coding\y_hooks>

// ============================= CONFIG =============================

// Cada cuánto muestreamos movimiento para sumar km
#define VW_SAMPLE_MS                (10000)   // 10s

// Cada cuánto chequeamos si “se rompe”
#define VW_ISSUE_CHECK_MS           (300000)   // 5m
// Cada cuánto intentamos guardar en DB cuando el vehículo queda inactivo
#define VW_SAVE_MS                  (15000)   // 15s

// Umbral base mínimo (km desde último service) para empezar a aumentar probabilidad
#if !defined VW_MIN_THRESHOLD_KM
#define VW_MIN_THRESHOLD_KM         (2000.0)
#endif



// Umbral máximo “razonable” (si supera esto, ya tiene alta probabilidad)
#define VW_MAX_THRESHOLD_KM         (4000.0)

// Probabilidad mínima y máxima (por chequeo, cuando está pasando el umbral)
#define VW_PROB_MIN                 (2)       // 2% por minuto
#define VW_PROB_MAX                 (18)      // 18% por minuto

// Probabilidad de pinchar rueda (por minuto y por vehículo en marcha)
// Pasado el umbral, suma una probabilidad extra muy baja.
// Usamos "permille" para soportar sub-porcentajes (‰ sobre 1000).
#define VW_PUNCTURE_BASE_PERMILLE       (1)       // 0.1‰ (0.1% por minuto)
#define VW_PUNCTURE_EXTRA_MAX_PERMILLE  (8)       // +0.8‰ máx (total ~1.0%)
#define VW_PUNCTURE_EXTRA_RANGE_KM      (Float:800.0) // rango de km por encima del umbral para llegar al extra máx


#define VW_FIX_ANIM_LIB             "BOMBER"
#define VW_FIX_ANIM_NAME            "BOM_Plant"
#define VW_FIX_ANIM_TIME_MS         (6500)

#define VW_PI                (Float:3.14159265)
#define VW_DEG2RAD           (Float:3.14159265/Float:180.0)
#define VW_WHEEL_FWD         (Float:1.2)
#define VW_MAX_LEGIT_SPEED_KMH (180.0)   // velocidad máxima plausible para segmentado (km/h)
#define VW_TELEPORT_BUFFER_FACTOR (1.15) // small buffer to allow slightly above max
#define VW_WHEEL_BACK        (Float:-1.2)
#define VW_WHEEL_LEFT        (Float:-0.9)
#define VW_WHEEL_RIGHT       (Float:0.9)
#define VW_NEAR_WHEEL_DIST   (Float:2.5)

// ============================= DATA =============================

// VehTotalKm, VehKmSinceService, VehNextIssueAtKm, VehMechProblem
// están definidos en `vehicle/marp_vehicles_core.pwn` e incluidos por `vehicle/marp_vehicles.pwn`.

new bool:VehDirty[MAX_VEH];

new Float:VW_LastX[MAX_VEH];
new Float:VW_LastY[MAX_VEH];
new Float:VW_LastZ[MAX_VEH];
new VW_LastInit[MAX_VEH];

new VW_TimerSample;
new VW_TimerIssue;
new VW_TimerSave;

// ============================= UTILS =============================

static stock VW_IsWearTrackedVehicle(vehicleid)
{
    if(!Veh_IsValidId(vehicleid)) return 0;
    if(VehicleInfo[vehicleid][VehType] != VEH_OWNED && VehicleInfo[vehicleid][VehType] != VEH_FACTION)
        return 0;

    // Excluir “jobs”
    if(VehicleInfo[vehicleid][VehType] == VEH_JOB || VehicleInfo[vehicleid][VehJob] > 0)
        return 0;

    return 1;
}

static stock VW_IsEngineOn(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    return (engine == 1);
}

static stock VW_IsVehicleOccupied(vehicleid)
{
    foreach(new p : Player)
    {
        if(IsPlayerInVehicle(p, vehicleid)) return 1;
    }
    return 0;
}

static stock Float:VW_ClampFloat(Float:v, Float:minv, Float:maxv)
{
    if(v < minv) return minv;
    if(v > maxv) return maxv;
    return v;
}

static stock VW_ChanceFromKm(Float:sinceService, Float:threshold)
{
    // desde threshold -> escala lineal hasta VW_MAX_THRESHOLD_KM
    if(sinceService < threshold) return 0;

    new Float:t = (sinceService - threshold) / (VW_MAX_THRESHOLD_KM - threshold);
    t = VW_ClampFloat(t, 0.0, 1.0);

    new prob = floatround( (VW_PROB_MIN + (VW_PROB_MAX - VW_PROB_MIN) * t) );
    if(prob < 0) prob = 0;
    if(prob > 100) prob = 100;
    return prob;
}

static stock VW_ForceSaveDB(vehicleid)
{
    // Guardado “extra” de las columnas nuevas (sin tocar tu SaveVehicle gigante)
    new q[256];
    mysql_format(MYSQL_HANDLE, q, sizeof q,
        "UPDATE `vehicles` SET `VehTotalKm`=%f,`VehKmSinceService`=%f,`VehNextIssueAtKm`=%f,`VehMechProblem`=%i WHERE `VehSQLID`=%i LIMIT 1;",
        VehTotalKm[vehicleid],
        VehKmSinceService[vehicleid],
        VehNextIssueAtKm[vehicleid],
        VehMechProblem[vehicleid],
        VehicleInfo[vehicleid][VehSQLID]
    );
    mysql_tquery(MYSQL_HANDLE, q);
}

// ============================= INIT =============================

forward VW_Init();
forward VW_OnSampleTick();
forward VW_OnIssueTick();
forward VW_OnWorkshopRepair(vehicleid);
forward VW_FinishTireFix(playerid, vehicleid, wheel);
forward VW_StartTireFixAnim(playerid, vehicleid, wheel);
forward VW_SaveIfDirty(vehicleid);

public VW_Init()
{
    if(VW_TimerSample) KillTimer(VW_TimerSample);
    if(VW_TimerIssue)  KillTimer(VW_TimerIssue);
    if(VW_TimerSave)   KillTimer(VW_TimerSave);

    VW_TimerSample = SetTimer("VW_OnSampleTick", VW_SAMPLE_MS, true);
    VW_TimerIssue  = SetTimer("VW_OnIssueTick",  VW_ISSUE_CHECK_MS, true);
    VW_TimerSave   = SetTimer("VW_OnSaveTick",   VW_SAVE_MS, true);

    for(new v = 1; v < MAX_VEH; v++)
    {
        VW_LastInit[v] = 0;
    }
    print("[VEH-WEAR] Sistema de kilometraje/fallas inicializado.");
    return 1;
}

 
public VW_OnSampleTick()
{
    for(new v = 1; v < MAX_VEH; v++)
    {
        if(!VW_IsWearTrackedVehicle(v)) continue;
        if(!VW_IsEngineOn(v)) { VW_LastInit[v] = 0; continue; }

        // Si querés que sume km sólo si hay alguien arriba:
        if(!VW_IsVehicleOccupied(v)) { VW_LastInit[v] = 0; continue; }

        new Float:x, Float:y, Float:z;
        GetVehiclePos(v, x, y, z);

        if(!VW_LastInit[v])
        {
            VW_LastX[v] = x; VW_LastY[v] = y; VW_LastZ[v] = z;
            VW_LastInit[v] = 1;
            continue;
        }

        new Float:dx = x - VW_LastX[v];
        new Float:dy = y - VW_LastY[v];

        // Distancia 2D en metros aprox (coord GTA). 
        new Float:dist = floatsqroot(dx*dx + dy*dy);

        // Filtro anti “teleport”: si mueve una locura en 10s no suma
        if(dist > Float:400.0)
        {
            // Si la distancia es mayor a 400m, comprobamos si es plausible
            // considerando una velocidad máxima plausible (p.ej. 130 km/h).
            new Float:dt = float(VW_SAMPLE_MS) / 1000.0; // segundos por sample
            new Float:maxSpeedMS = VW_MAX_LEGIT_SPEED_KMH / Float:3.6; // km/h -> m/s
            new Float:maxLegitDist = maxSpeedMS * dt * VW_TELEPORT_BUFFER_FACTOR;

            // Si incluso a la velocidad máxima plausible la distancia es demasiado
            // grande, la consideramos teleport y la ignoramos.
            if(dist > maxLegitDist)
            {
                VW_LastX[v] = x; VW_LastY[v] = y; VW_LastZ[v] = z;
                continue;
            }
            // Si no supera maxLegitDist, aceptamos el movimiento (era plausible).
        }

        // pasar a KM: (dist / 1000)
        new Float:addKm = dist / Float:1000.0;

        VehTotalKm[v] += addKm;
        VehKmSinceService[v] += addKm;

        // Probabilidad de pinchadura basada en distancia recorrida (no por minuto)
        // Base muy baja + extra muy baja que escala por encima del umbral
        if(addKm > Float:0.0)
        {
            new Float:thresholdP = VehNextIssueAtKm[v];
            if(thresholdP < VW_MIN_THRESHOLD_KM) thresholdP = VW_MIN_THRESHOLD_KM;

            new Float:beyond = VehKmSinceService[v] - thresholdP;
            if(beyond < Float:0.0) beyond = Float:0.0;

            new Float:tP = beyond / VW_PUNCTURE_EXTRA_RANGE_KM; // 0..1
            if(tP > Float:1.0) tP = Float:1.0;

            new extraPermille = floatround(Float:VW_PUNCTURE_EXTRA_MAX_PERMILLE * tP);
            if(extraPermille < 0) extraPermille = 0;

            // permille por km -> prob acumulada en este sample = addKm * (permille/1000)
            new chancePermillePerKm = VW_PUNCTURE_BASE_PERMILLE + extraPermille;
            new chancePerMillion = floatround(Float:chancePermillePerKm * addKm * Float:1000.0);

            if(chancePerMillion > 0 && random(1000000) < chancePerMillion)
            {
                // pinchar si no hay ya
                new panels, doors, lights, tires;
                GetVehicleDamageStatus(v, panels, doors, lights, tires);
                if(tires == 0)
                {
                    new bit = random(4);
                    tires |= (1 << bit);
                    UpdateVehicleDamageStatus(v, panels, doors, lights, tires);

                    foreach(new p : Player)
                    {
                        if(IsPlayerInVehicle(p, v))
                            SendClientMessage(p, COLOR_ACT1, "Escuchás un golpe seco… se te pinchó una rueda.");
                    }
                }
            }
        }

        // marcar como sucio; se guardará luego cuando el vehículo esté inactivo
        VehDirty[v] = true;

        VW_LastX[v] = x; VW_LastY[v] = y; VW_LastZ[v] = z;
    }
    return 1;
}

 
public VW_OnIssueTick()
{
    for(new v = 1; v < MAX_VEH; v++)
    {
        if(!VW_IsWearTrackedVehicle(v)) continue;
        if(!VW_IsEngineOn(v)) continue;
        if(!VW_IsVehicleOccupied(v)) continue;

        // 2) Falla mecánica por kilometraje
        new Float:threshold = VehNextIssueAtKm[v];
        if(threshold < VW_MIN_THRESHOLD_KM) threshold = VW_MIN_THRESHOLD_KM;

        new prob = VW_ChanceFromKm(VehKmSinceService[v], threshold);
        if(prob <= 0) continue;

        if(random(100) < prob)
        {
            // Marca problema
            VehMechProblem[v] = 1;
            VW_ForceSaveDB(v);

            // Efecto de falla: bajar vida un poco y marcar problema.
            new Float:hp;
            GetVehicleHealth(v, hp);
            hp -= Float:120.0;
            if(hp < Float:300.0) hp = Float:300.0;
            SetVehicleHealth(v, hp);

            foreach(new p : Player)
            {
                if(IsPlayerInVehicle(p, v))
                    SendClientMessage(p, COLOR_ACT1, "El motor empieza a fallar y a largar humo. Necesitas pasar por un taller pronto.");
            }
        }
    }
    return 1;
}

forward VW_OnSaveTick();
public VW_OnSaveTick()
{
    for(new v = 1; v < MAX_VEH; v++)
    {
        if(!VehDirty[v]) continue;
        // guardar sólo si motor apagado y sin ocupantes
        if(VW_IsEngineOn(v)) continue;
        if(VW_IsVehicleOccupied(v)) continue;

        VW_ForceSaveDB(v);
        VehDirty[v] = false;
    }
    return 1;
}

public VW_SaveIfDirty(vehicleid)
{
    if(!VW_IsWearTrackedVehicle(vehicleid)) return 0;
    if(!VehDirty[vehicleid]) return 0;
    VW_ForceSaveDB(vehicleid);
    VehDirty[vehicleid] = false;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid > 0 && VehDirty[vehicleid]) {
        VW_ForceSaveDB(vehicleid);
        VehDirty[vehicleid] = false;
    }
    return 1;
}

// ============================= API: TALLER =============================

public VW_OnWorkshopRepair(vehicleid)
{
    if(!Veh_IsValidId(vehicleid)) return 0;

    // Para vehículos no seguidos, al menos limpamos flag de falla para que /avinfo y diálogos muestren OK.
    if(!VW_IsWearTrackedVehicle(vehicleid)) {
        VehMechProblem[vehicleid] = 0;
        return 1;
    }

    // Guardamos cuánto km tenía desde el service antes de resetear
    new Float:oldSince = VehKmSinceService[vehicleid];

    VehKmSinceService[vehicleid] = 0.0;
    VehMechProblem[vehicleid] = 0;

    // Sólo reasignar un nuevo umbral aleatorio si previamente había
    // superado el umbral mínimo; si no, mantenemos el umbral existente.
    if (oldSince >= VW_MIN_THRESHOLD_KM)
    {
        // nuevo umbral grande, aleatorio dentro de un rango
        new Float:r = float(random(300)); // 0..300
        VehNextIssueAtKm[vehicleid] = VW_MIN_THRESHOLD_KM + r;
    }

    VW_ForceSaveDB(vehicleid);
    return 1;
}

 

// ============================= RUEDA AUXILIO =============================

static stock VW_Container_DecreaseTake(containerId, itemid)
{
    // Busca item en contenedor. Si es stack (param>1) decrementa param. Si param==1, lo saca.
    new slot = Container_SearchItem(containerId, itemid);
    if(slot < 0) return 0;

    new item, param;
    item = Container_GetItem(containerId, slot);
    param = vector_get(containerId, Container_SlotToVecIndex(slot) + 1);

    if(param > 1)
    {
        // bajar param en memoria
        vector_set(containerId, Container_SlotToVecIndex(slot) + 1, param - 1);

        // update db (no tenías helper, lo hacemos acá)
        new q[196];
        mysql_format(MYSQL_HANDLE, q, sizeof q,
            "UPDATE `containers_slots` SET `Param`=%i WHERE `id`=%i AND `Item`=%i AND `Param`=%i LIMIT 1;",
            (param - 1), Container_GetSQLID(containerId), itemid, param
        );
        mysql_tquery(MYSQL_HANDLE, q);

        Container_UpdateOpenedDialogs(containerId);
        return 1;
    }
    else
    {
        // sacar slot completo
        Container_TakeItem(containerId, slot, item, param);
        Container_UpdateOpenedDialogs(containerId);
        return 1;
    }
}

static stock VW_FixTires(vehicleid, wheel = -1)
{
    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

    if(wheel < 0)
    {
        if(tires == 0) return 0;
        tires = 0;
    }
    else
    {
        if(!(tires & (1 << wheel))) return 0; // wheel not punctured
        tires &= ~(1 << wheel);
    }

    UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    return 1;
}

CMD:cambiarrueda(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return SendClientMessage(playerid, COLOR_YELLOW2, "Tenés que estar a pie para cambiar una rueda.");

    // Usar el vehículo más cercano en vez de exigir estar detrás del maletero
    new vehicleid = VW_GetNearestVehicleForPlayer(playerid, Float:6.0);
    if(!vehicleid)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás cerca de ningún vehículo.");

    // Tiene rueda pinchada?
    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    if(tires == 0)
        return SendClientMessage(playerid, COLOR_INFO, "No hay ruedas pinchadas en este vehículo.");

    // Determinar rueda pinchada y su posición aproximada
    new bit = -1;
    for(new i = 0; i < 4; i++){
        if(tires & (1 << i)) { bit = i; break; }
    }
    if(bit == -1) return SendClientMessage(playerid, COLOR_INFO, "No hay ruedas pinchadas en este vehículo.");

    // Requiere tener la rueda de auxilio en mano (no se toma automático del maletero)
    new hand = SearchHandsForItem(playerid, ITEM_ID_SPARE_TIRE);
    if(hand == -1)
        return SendClientMessage(playerid, COLOR_ERROR, "Debés tener la rueda de auxilio en una de tus manos.");

    // Consumir 1 unidad de la mano
    if(GetHandParam(playerid, hand) <= 1) {
        SetHandItemAndParam(playerid, hand, 0, 0);
    } else {
        SetHandItemAndParam(playerid, hand, ITEM_ID_SPARE_TIRE, GetHandParam(playerid, hand) - 1);
    }

    // Requerir proximidad a la rueda pinchada (aprox. offset según orientación del vehículo)
    new Float:vx, Float:vy, Float:vz; GetVehiclePos(vehicleid, vx, vy, vz);
    new Float:ang; GetVehicleZAngle(vehicleid, ang);
    new Float:rad = ang * VW_DEG2RAD;
    new Float:fx = floatcos(rad), Float:fy = floatsin(rad);
    new Float:rx = -floatsin(rad), Float:ry = floatcos(rad);

    // offsets (aprox): front/back: +-1.2, left/right: +-0.9
    new Float:fwd, Float:lateral;
    if(bit < 2) fwd = VW_WHEEL_FWD; else fwd = VW_WHEEL_BACK; // 0,1 = front
    if((bit % 2) == 0) lateral = VW_WHEEL_LEFT; else lateral = VW_WHEEL_RIGHT; // even = left

    new Float:wheelx = vx + fx * fwd + rx * lateral;
    new Float:wheely = vy + fy * fwd + ry * lateral;

    new Float:px, Float:py, Float:pz; GetPlayerPos(playerid, px, py, pz);
    new Float:dx = px - wheelx, Float:dy = py - wheely;
    new Float:distw = floatsqroot(dx*dx + dy*dy);

    if(distw > VW_NEAR_WHEEL_DIST)
    {
        return SendClientMessage(playerid, COLOR_YELLOW2, "Tenés que acercarte a la rueda pinchada para cambiarla.");
    }

    // Aplicar animación tras un pequeño delay para evitar conflictos con cambios de mano
    SetTimerEx("VW_StartTireFixAnim", 100, false, "iii", playerid, vehicleid, bit);

    SendClientMessage(playerid, COLOR_ACT1, "* comienza a cambiar la rueda pinchada.");
    return 1;
}

public VW_FinishTireFix(playerid, vehicleid, wheel)
{
    if(IsPlayerConnected(playerid))
    {
        ClearAnimations(playerid);
        TogglePlayerControllable(playerid, true);
    }

    if(Veh_IsValidId(vehicleid))
    {
        VW_FixTires(vehicleid, wheel);
        // Al cambiar rueda limpiamos flag de falla y guardamos el estado
        VehMechProblem[vehicleid] = 0;
        VehDirty[vehicleid] = true;
        VW_SaveIfDirty(vehicleid);
        SendClientMessage(playerid, COLOR_WHITE, "Rueda cambiada. Ya podés seguir.");
    }
    return 1;
}

public VW_StartTireFixAnim(playerid, vehicleid, wheel)
{
    if(!IsPlayerConnected(playerid)) return 0;
    // reaplicar comprobación de proximidad/estado sencillo
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 0;

    ApplyAnimationEx(playerid, VW_FIX_ANIM_LIB, VW_FIX_ANIM_NAME, 4.1, 0, 0, 0, 0, 0, 1);
    // temporizador que completará la reparación
    SetTimerEx("VW_FinishTireFix", VW_FIX_ANIM_TIME_MS, false, "iii", playerid, vehicleid, wheel);
    return 1;
}

// ============================= HELPERS / CMD =============================

stock VW_GetNearestVehicleForPlayer(playerid, Float:range)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new nearest = 0;
    new Float:bestd = range;
    for(new v = 1; v < MAX_VEH; v++)
    {
        if(!IsValidVehicle(v) || !Veh_IsValidId(v)) continue;
        if(Veh_GetInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)) continue;
        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(v, vx, vy, vz);
        new Float:dx = vx - px;
        new Float:dy = vy - py;
        new Float:dist = floatsqroot(dx*dx + dy*dy);
        if(dist <= bestd)
        {
            bestd = dist;
            nearest = v;
        }
    }
    return nearest;
}

CMD:verkm(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == 0)
        vehicleid = VW_GetNearestVehicleForPlayer(playerid, Float:6.0);

    if(vehicleid == 0)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás en un vehículo ni hay uno cerca.");

    new msg[180];
    format(msg, sizeof msg,
        "KM: Total %.2f km | Desde service %.2f km | Estado: %s",
        VehTotalKm[vehicleid],
        VehKmSinceService[vehicleid],
        (VehMechProblem[vehicleid] ? ("CON FALLA") : ("OK"))
    );
    SendClientMessage(playerid, COLOR_INFO, msg);
    return 1;
}

