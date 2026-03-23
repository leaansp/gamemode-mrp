#if defined _marp_player_drugs_included
	#endinput
#endif
#define _marp_player_drugs_included

#include <YSI_Coding\y_hooks>


#define FMIN(%0,%1) ((%0) < (%1) ? (%0) : (%1))
#define FMAX(%0,%1) ((%0) > (%1) ? (%0) : (%1))
#define IMAX(%0,%1) ((%0) > (%1) ? (%0) : (%1))
#define DRUGS_TOX_THRESHOLD       (10)          // suma de toxicidades
#define DRUGS_OVERDOSE_MS         (120*1000)   // 120s "reventado"


// Estado de sobredosis
static g_Drugs_Toxicity[MAX_PLAYERS]      = {0, ...};
static bool:g_Drugs_IsOverdosed[MAX_PLAYERS] = {false, ...};
static g_Drugs_OverdoseTimer[MAX_PLAYERS] = {0, ...};

// Forwards
forward Drugs_TriggerOverdose(playerid);
forward Drugs_OverdoseEnd(playerid);

forward Drugs_RemoveConfig(playerid, drugid);
forward Drug_CocaineEffectEnd(playerid);

static Drugs_PlayerWeather[MAX_PLAYERS] = {-1, ...};
static bool:Drugs_PlayerEffects[MAX_PLAYERS][DRUG_IDS_AMOUNT] = {false, ...};
static Drugs_PlayerTimers[MAX_PLAYERS][DRUG_IDS_AMOUNT] = {0, ...};

static const Drugs_EffectTimerEnd[DRUG_IDS_AMOUNT][MAX_FUNC_NAME] = {
    {"NULL"},
    {"Drug_MarijuanaEffectEnd"},
    {"Drug_CocaineEffectEnd"},
    {"Drug_EcstasyEffectEnd"},
    {"Drug_LSDEffectEnd"}
};

// =========================
// Config y estado de efectos
// =========================

enum e_DRUG_EFFECT_CFG
{
    Float:eff_overheal,        // Vida virtual extra (ej: 50 => 100 + 50 virtuales)
    Float:eff_armour_set,      // Chaleco a setear al consumir (-1 = no tocar)
    Float:eff_regen_per_sec,   // Regeneración por segundo (0 = nada)
    Float:eff_dmg_in_mult,     // Multiplicador de daño recibido (0.8 = recibe 20% menos)
    Float:eff_dmg_out_mult,    // Multiplicador de daño que inflige (1.2 = pega 20% más)
    eff_drunk_lvl,             // Nivel de borrachera (0-50000 aprox.)
    eff_time_h, eff_time_m,    // -1 = no tocar hora
    eff_weather_override,       // -1 = no tocar clima (si LSD lo maneja aparte, dejar -1)
    eff_toxicity              // nivel de toxicidad 
};

static const Drugs_Config[DRUG_IDS_AMOUNT][e_DRUG_EFFECT_CFG] = {
    {0.0, -1.0, 0.0, 1.0, 1.0, 0,  -1, -1, -1, 0},   // NONE
    {15.0, -1.0, 0.50, 1.0, 0.95, 7000, -1, -1, 126, 1}, // MARIHUANA
    {30.0, -1.0, 0.00, 0.75, 1.10, 0, -1, -1, 126, 3},   // COCAINE
    {10.0, -1.0, 0.75, 0.95, 1.05, 10000, -1, -1, 18, 2},// ECSTASY
    {0.0,  -1.0, 0.00, 1.05, 0.90, 11000, -1, -1, -1, 2} // LSD
};

// =========================
// Estado por jugador
// =========================


static Float:g_Drugs_OverhealAdded[MAX_PLAYERS] = {0.0, ...};
static Float:g_Drugs_OverhealAddedByDrug[MAX_PLAYERS][DRUG_IDS_AMOUNT] = {0.0, ...};

// Multiplicadores activos (combinados de todas las drogas en simultáneo).
static Float:g_Drugs_DmgInMult[MAX_PLAYERS]  = {1.0, ...};
static Float:g_Drugs_DmgOutMult[MAX_PLAYERS] = {1.0, ...};

// Regen por segundo acumulada (suma de todas las drogas).
static Float:g_Drugs_RegenPerSec[MAX_PLAYERS] = {0.0, ...};

// Nivel de borrachera target (máximo de todas las drogas).
static g_Drugs_DrunkLevelTarget[MAX_PLAYERS] = {0, ...};

// Handle al timer de tick
static g_Drugs_EffectTick[MAX_PLAYERS] = {0, ...};

hook OnPlayerSpawn(playerid)
{
    Drugs_ResetEffects(playerid);
    SyncPlayerWeather(playerid);
    return 1;
}

IsPlayerDrugged(playerid)
{
	return (Drugs_PlayerEffects[playerid][DRUG_ID_MARIJUANA] || Drugs_PlayerEffects[playerid][DRUG_ID_COCAINE] || 
		Drugs_PlayerEffects[playerid][DRUG_ID_ECSTASY] || Drugs_PlayerEffects[playerid][DRUG_ID_LSD]);
}

Drugs_GetPlayerWeather(playerid) {
    return Drugs_PlayerWeather[playerid];
}


static const DRUGS_TICK_MS = 500; // cada 0.5s aplicamos regen y ajuste fino

Drugs_OnPlayerUsed(playerid, drugid, duration, weatherid) 
{
    if(drugid == DRUG_ID_NONE)
        return 0;

    Drugs_PlayerWeather[playerid] = weatherid;

    
    if(weatherid != -1 && drugid != DRUG_ID_LSD) {
        SetPlayerWeather(playerid, weatherid);
    }
    if(drugid == DRUG_ID_LSD) {
        SetTimerEx("Drug_LSDEffectInit", 10*1000, false, "iiii", playerid, PlayerInfo[playerid][pID], duration, weatherid);        
    }

    if(Drugs_PlayerTimers[playerid][drugid]) {
        KillTimer(Drugs_PlayerTimers[playerid][drugid]);
    }
    if (g_Drugs_Toxicity[playerid] >= DRUGS_TOX_THRESHOLD - 1) {
        SendClientMessage(playerid, COLOR_RED, "Estás al límite. Una más y te da algo...");
    }

    Drugs_PlayerEffects[playerid][drugid] = true;
    Drugs_PlayerTimers[playerid][drugid] = SetTimerEx(Drugs_EffectTimerEnd[drugid], duration*60*1000, false, "i", playerid);
     // === NUEVO: aplicar config ===
    new Float:cfg_overheal          = Drugs_Config[drugid][eff_overheal];
    new Float:cfg_armour_set        = Drugs_Config[drugid][eff_armour_set];
    new Float:cfg_regen_per_sec     = Drugs_Config[drugid][eff_regen_per_sec];
    new Float:cfg_dmg_in_mult       = Drugs_Config[drugid][eff_dmg_in_mult];
    new Float:cfg_dmg_out_mult      = Drugs_Config[drugid][eff_dmg_out_mult];
    new       cfg_drunk_lvl         = Drugs_Config[drugid][eff_drunk_lvl];
    new       cfg_weather_override  = Drugs_Config[drugid][eff_weather_override];
    new       cfg_toxicity          = Drugs_Config[drugid][eff_toxicity];

    if (g_Drugs_IsOverdosed[playerid]) {
    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu cuerpo no soporta más sustancias.");
    return 1;
    }

    // AUMENTAR toxicidad y evaluar sobredosis ANTES de aplicar efectos
    new tox = g_Drugs_Toxicity[playerid] + cfg_toxicity;
    if (tox >= DRUGS_TOX_THRESHOLD && cfg_toxicity > 0) {
        Drugs_TriggerOverdose(playerid);
        return 1;
    }
    g_Drugs_Toxicity[playerid] = tox;


    if (cfg_overheal > 0.0)
    {
        
        new Float:allowed_max = 30.0;
        new Float:already = g_Drugs_OverhealAdded[playerid];
        new Float:to_add = cfg_overheal;
        if (already + to_add > allowed_max) to_add = allowed_max - already;
        if (to_add > 0.0)
        {
            new Float:hp; GetPlayerHealth(playerid, hp);
            SetPlayerHealthEx(playerid, hp + to_add);
            g_Drugs_OverhealAddedByDrug[playerid][drugid] = to_add;
            g_Drugs_OverhealAdded[playerid] += to_add;
        }
    }

    // Chaleco: set si corresponde y si el valor es mayor al actual
    if(cfg_armour_set >= 0.0)
    {
        new Float:arm;
        GetPlayerArmour(playerid, arm);
        if(cfg_armour_set > arm) SetPlayerArmour(playerid, cfg_armour_set);
    }

    // Regen acumulada
    g_Drugs_RegenPerSec[playerid] += cfg_regen_per_sec;

    // Multiplicadores combinados
    g_Drugs_DmgInMult[playerid]  *= cfg_dmg_in_mult;
    g_Drugs_DmgOutMult[playerid] *= cfg_dmg_out_mult;

    // Drunk level target: tomamos el máximo de las drogas vigentes
    if(cfg_drunk_lvl > g_Drugs_DrunkLevelTarget[playerid])
    {
        g_Drugs_DrunkLevelTarget[playerid] = cfg_drunk_lvl;
        SetPlayerDrunkLevel(playerid, g_Drugs_DrunkLevelTarget[playerid]);
    }

    // Hora/clima opcionales (si quisieramos tocar la hora específico por droga)
    // if(cfg_time_h != -1 && cfg_time_m != -1) SetPlayerTime(playerid, cfg_time_h, cfg_time_m);
    if(cfg_weather_override != -1 && drugid != DRUG_ID_LSD)
    SetPlayerWeather(playerid, cfg_weather_override);

    return 1;
}

forward Drugs_Tick(playerid);
public Drugs_Tick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    // Regeneración suave
    if(g_Drugs_RegenPerSec[playerid] > 0.0)
    {
        new Float:hp; GetPlayerHealth(playerid, hp);
        // No pasar de 100 de engine. Regen aplica al HP del engine (no usamos
        // un buffer persistente de "overheal" en esta implementación).
        if(hp < 100.0)
        {
            hp += (g_Drugs_RegenPerSec[playerid] * (float(DRUGS_TICK_MS) / 1000.0));
            if(hp > 100.0) hp = 100.0;
            SetPlayerHealth(playerid, hp);
        }
        else
        {
            // Si ya está en 100, podemos opcionalmente llenar overheal (mini-overheal pasivo)
            // g_Drugs_Overheal[playerid] = floatmin(g_Drugs_Overheal[playerid] + 0.2, 100.0);
        }
    }

    // Si ninguna droga queda activa, cortamos el tick
    if(!IsPlayerDrugged(playerid))
    {
        KillTimer(g_Drugs_EffectTick[playerid]);
        g_Drugs_EffectTick[playerid] = 0;
    }
    return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    // Aplicar multiplicador de daño recibido
    amount *= g_Drugs_DmgInMult[playerid];

    // NOTE: we removed the virtual overheal buffer. Damage is applied directly
    // to the player's health (after multiplying). We still perform the HP
    // adjustment below and re-set via timer to avoid race with engine.

    // Aplicar al HP real
    new Float:hp;
    GetPlayerHealth(playerid, hp);
    hp -= amount;
    if(hp < 0.0) hp = 0.0;
    SetPlayerHealth(playerid, hp);

    // Cancelar el daño por default del engine:
    // Opción A: devolver 0 en OnPlayerTakeDamage no evita la resta del engine.
    // Estrategia: setear HP manualmente y "neutralizar" restando luego de que el engine resta.
    // Truco seguro: devolver 1 y re-setear el HP tras un pequeño delay:
    SetTimerEx("Drugs_ApplyHPFix", 1, false, "if", playerid, hp);
    return 1;
}

forward Drugs_ApplyHPFix(playerid, Float:hp);
public Drugs_ApplyHPFix(playerid, Float:hp)
{
    if(IsPlayerConnected(playerid)) SetPlayerHealth(playerid, hp);
    return 1;
}

forward Drug_MarijuanaEffectEnd(playerid);
public Drug_MarijuanaEffectEnd(playerid)
{
    BN_PlayerEat(playerid, -20);
    Drugs_PlayerEffects[playerid][DRUG_ID_MARIJUANA] = false;
    Drugs_PlayerTimers[playerid][DRUG_ID_MARIJUANA] = 0;
    Drugs_RemoveConfig(playerid, DRUG_ID_MARIJUANA); // <<<
    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El efecto de la marihuana esta finalizando y comienzas a tener hambre.");
    SyncPlayerWeather(playerid);
    return 1;
}

public Drug_CocaineEffectEnd(playerid)
{
    Drugs_PlayerEffects[playerid][DRUG_ID_COCAINE] = false;
    Drugs_PlayerTimers[playerid][DRUG_ID_COCAINE] = 0;

    Drugs_RemoveConfig(playerid, DRUG_ID_COCAINE); 
    SyncPlayerWeather(playerid);
    return 1;
}

forward Drug_EcstasyEffectEnd(playerid);
public Drug_EcstasyEffectEnd(playerid)
{
    BN_PlayerDrink(playerid, -30);
    Drugs_PlayerEffects[playerid][DRUG_ID_ECSTASY] = false;
    Drugs_PlayerTimers[playerid][DRUG_ID_ECSTASY] = 0;
    Drugs_RemoveConfig(playerid, DRUG_ID_ECSTASY); // <<<
    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El efecto del extasis esta finalizando y comienzas a tener sed.");
    SyncPlayerWeather(playerid);
    return 1;
}

forward Drug_LSDEffectInit(playerid, playersqlid, duration, weatherid);
public Drug_LSDEffectInit(playerid, playersqlid, duration, weatherid)
{
	if(!IsPlayerLogged(playerid) || PlayerInfo[playerid][pID] != playersqlid)
		return 0;

    SetPlayerWeather(playerid, weatherid);
    SetPlayerDrunkLevel(playerid, duration*60*50);
    return 1;
}

forward Drug_LSDEffectEnd(playerid);
public Drug_LSDEffectEnd(playerid)
{
    SetPlayerDrunkLevel(playerid, 0);
    Drugs_PlayerEffects[playerid][DRUG_ID_LSD] = false;
    Drugs_PlayerTimers[playerid][DRUG_ID_LSD] = 0;

    Drugs_RemoveConfig(playerid, DRUG_ID_LSD); // <<<
    SyncPlayerWeather(playerid);
    return 1;
}

Drugs_ResetEffects(playerid)
{
    Drugs_PlayerWeather[playerid] = -1;
    Drugs_PlayerEffects[playerid] = bool:{false, false, false, false, false};

    for(new i = 1; i < DRUG_IDS_AMOUNT; i++)
    {
        if(Drugs_PlayerTimers[playerid][i]) { KillTimer(Drugs_PlayerTimers[playerid][i]); Drugs_PlayerTimers[playerid][i] = 0; }
    }
    if(g_Drugs_EffectTick[playerid]) { KillTimer(g_Drugs_EffectTick[playerid]); g_Drugs_EffectTick[playerid] = 0; }

    // no more overheal buffer to reset
    g_Drugs_DmgInMult[playerid]  = 1.0;
    g_Drugs_DmgOutMult[playerid] = 1.0;
    g_Drugs_RegenPerSec[playerid] = 0.0;
    g_Drugs_DrunkLevelTarget[playerid] = 0;
    SetPlayerDrunkLevel(playerid, 0);
    g_Drugs_Toxicity[playerid] = 0;
    g_Drugs_IsOverdosed[playerid] = false;
    if (g_Drugs_OverdoseTimer[playerid]) { KillTimer(g_Drugs_OverdoseTimer[playerid]); g_Drugs_OverdoseTimer[playerid] = 0; }

    // Revert any remaining applied HP bonuses (if any drugs were giving extra HP)
    if (g_Drugs_OverhealAdded[playerid] > 0.0)
    {
        new Float:hp; GetPlayerHealth(playerid, hp);
        new Float:newhp = hp - g_Drugs_OverhealAdded[playerid];
        if (newhp < 1.0) newhp = 1.0;
        SetPlayerHealthEx(playerid, newhp);
        g_Drugs_OverhealAdded[playerid] = 0.0;
        // zero per-drug values
        for(new d = 0; d < DRUG_IDS_AMOUNT; d++) g_Drugs_OverhealAddedByDrug[playerid][d] = 0.0;
    }

    return 1;
}

Drugs_RemoveConfig(playerid, drugid)
{
    new Float:cfg_regen = Drugs_Config[drugid][eff_regen_per_sec];
    new Float:cfg_in    = Drugs_Config[drugid][eff_dmg_in_mult];
    new Float:cfg_out   = Drugs_Config[drugid][eff_dmg_out_mult];


    // Regen
    g_Drugs_RegenPerSec[playerid] = FMAX(0.0, g_Drugs_RegenPerSec[playerid] - cfg_regen);

    // Multiplicadores (evitar bajar de 0.2)
    g_Drugs_DmgInMult[playerid]  = FMAX(0.2, g_Drugs_DmgInMult[playerid]  / cfg_in);
    g_Drugs_DmgOutMult[playerid] = FMAX(0.2, g_Drugs_DmgOutMult[playerid] / cfg_out);

    // Drunk: recalcular target según otras drogas activas
    new maxDrunk = 0;
    for (new d = 1; d < DRUG_IDS_AMOUNT; d++)
    {
        if (Drugs_PlayerEffects[playerid][d])
            maxDrunk = IMAX(maxDrunk, Drugs_Config[d][eff_drunk_lvl]);
    }

    g_Drugs_DrunkLevelTarget[playerid] = maxDrunk;
    SetPlayerDrunkLevel(playerid, g_Drugs_DrunkLevelTarget[playerid]);
    g_Drugs_Toxicity[playerid] = (g_Drugs_Toxicity[playerid] > Drugs_Config[drugid][eff_toxicity])
    ? (g_Drugs_Toxicity[playerid] - Drugs_Config[drugid][eff_toxicity])
    : 0;

    // If this drug had applied an HP bonus, remove exactly what we applied
    // for this drug and update the totals. We subtract the applied amount
    // (tracked in g_Drugs_OverhealAddedByDrug) and use SetPlayerHealthEx to
    // update the player's HP consistently with the rest of the system.
    new Float:removed = g_Drugs_OverhealAddedByDrug[playerid][drugid];
    if (removed > 0.0)
    {
        new Float:hp; GetPlayerHealth(playerid, hp);
        new Float:newhp = hp - removed;
        if (newhp < 1.0) newhp = 1.0;
        SetPlayerHealthEx(playerid, newhp);
        g_Drugs_OverhealAdded[playerid] = FMAX(0.0, g_Drugs_OverhealAdded[playerid] - removed);
        g_Drugs_OverhealAddedByDrug[playerid][drugid] = 0.0;
    }
    return 1;
}

public Drugs_TriggerOverdose(playerid)
{
    // Flag y timer
    g_Drugs_IsOverdosed[playerid] = true;
    if (g_Drugs_OverdoseTimer[playerid]) KillTimer(g_Drugs_OverdoseTimer[playerid]);
    g_Drugs_OverdoseTimer[playerid] = SetTimerEx("Drugs_OverdoseEnd", DRUGS_OVERDOSE_MS, false, "i", playerid);

    // Cortar buffs actuales (regen/multiplicadores) y dejarlo en 25 HP
    g_Drugs_RegenPerSec[playerid]   = 0.0;
    g_Drugs_DmgInMult[playerid]     = 1.0;
    g_Drugs_DmgOutMult[playerid]    = 1.0;


    SetPlayerHealthEx(playerid, 35.0);

    // Visual “reventado”
    SetPlayerDrunkLevel(playerid, 35000);
    SendClientMessage(playerid, COLOR_RED, "¡Sobredosis! Tu cuerpo no soporta más sustancias. Quedas hecho bolsa...");

    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid, "CRACK", "crckidle2", 4.1, 1, 0, 0, 0, 0, 1);

    return 1;
}

public Drugs_OverdoseEnd(playerid)
{
    if (!IsPlayerConnected(playerid)) return 0;

    // Liberar estado “reventado”
    g_Drugs_IsOverdosed[playerid] = false;
    g_Drugs_OverdoseTimer[playerid] = 0;

    // Bajar borrachera a lo que corresponda por otras drogas activas, o cero
    new maxDrunk = 0;
    for (new d = 1; d < DRUG_IDS_AMOUNT; d++)
        if (Drugs_PlayerEffects[playerid][d])
            maxDrunk = IMAX(maxDrunk, Drugs_Config[d][eff_drunk_lvl]);
    g_Drugs_DrunkLevelTarget[playerid] = maxDrunk;
    SetPlayerDrunkLevel(playerid, g_Drugs_DrunkLevelTarget[playerid]);

    // (Opcional) descongelar
    TogglePlayerControllable(playerid, 1);

    SendClientMessage(playerid, COLOR_YELLOW2, "Te recuperas de la sobredosis. Seguís más tranqui.");
    return 1;
}


hook OnPlayerDisconnect(playerid, reason)
{
	Drugs_ResetEffects(playerid);
    return 1;
}


