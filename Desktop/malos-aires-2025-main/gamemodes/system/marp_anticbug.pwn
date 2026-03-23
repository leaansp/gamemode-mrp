#if defined _marp_anticbug_included
#endinput
#endif
#define _marp_anticbug_included

#include <YSI_Coding\y_hooks>

#define CBUG_FIRE_TO_CROUCH_MS 800      // max ms entre disparos y agacharse
#define CBUG_FREEZE_MS         1500     // ms para congelar al usuario cuando se detecta

new bool:pCBugging[MAX_PLAYERS];
new ptmCBugFreezeOver[MAX_PLAYERS];
new ptsLastFiredWeapon[MAX_PLAYERS];

// Forwards
forward CBugFreezeOver(playerid);
forward CBug_TimerTick();
forward CBug_Init();

// Polling worker variables
new lastKeys[MAX_PLAYERS];
new cbp_timer = 0;

stock bool:IsCbugWeapon(weaponid)
{
    return (weaponid == WEAPON_DEAGLE || weaponid == WEAPON_SHOTGUN || weaponid == WEAPON_SNIPER || weaponid == WEAPON_COLT45 || weaponid == WEAPON_ROCKETLAUNCHER);
}

stock ResetPlayerAntiCbugVars(playerid)
{
    pCBugging[playerid] = false;
    if (ptmCBugFreezeOver[playerid]) {
        KillTimer(ptmCBugFreezeOver[playerid]);
        ptmCBugFreezeOver[playerid] = 0;
    }
    ptsLastFiredWeapon[playerid] = 0;
    lastKeys[playerid] = 0;
    return 1;
}

public CBugFreezeOver(playerid)
{
    TogglePlayerControllable(playerid, true);
    pCBugging[playerid] = false;
    ptmCBugFreezeOver[playerid] = 0;
    return 1;
}

public CBug_TimerTick()
{
    new keys, ud, lr;
    new now = GetTickCount();

    for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if (!IsPlayerConnected(playerid))
        {
            ResetPlayerAntiCbugVars(playerid);
            continue;
        }

        if (AdminDuty[playerid]) { lastKeys[playerid] = 0; continue; }
        if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) { lastKeys[playerid] = 0; continue; }

        GetPlayerKeys(playerid, keys, ud, lr);

        // Detect fire press (edge)
        if ((keys & KEY_FIRE) && !(lastKeys[playerid] & KEY_FIRE))
        {
            new w = GetPlayerWeapon(playerid);
            if (IsCbugWeapon(w)) ptsLastFiredWeapon[playerid] = now;
        }

        // Detect crouch press (edge)
        if ((keys & KEY_CROUCH) && !(lastKeys[playerid] & KEY_CROUCH))
        {
            if (ptsLastFiredWeapon[playerid] != 0 && (now - ptsLastFiredWeapon[playerid]) <= CBUG_FIRE_TO_CROUCH_MS)
            {
                TogglePlayerControllable(playerid, false);
                pCBugging[playerid] = true;

                new gt[64];
                format(gt, sizeof gt, "~r~~h~Se detectó un intento de C-bug. Se le ha congelado el control por %i ms. Podés ser sancionado", CBUG_FREEZE_MS);
                GameTextForPlayer(playerid, gt, 1500, 4);

                ptsLastFiredWeapon[playerid] = 0;
                KillTimer(ptmCBugFreezeOver[playerid]);
                ptmCBugFreezeOver[playerid] = SetTimerEx("CBugFreezeOver", CBUG_FREEZE_MS, false, "i", playerid);
            }
        }

        lastKeys[playerid] = keys;
    }

    return 1;
}

public CBug_Init()
{
    if (cbp_timer) KillTimer(cbp_timer);
    cbp_timer = SetTimerEx("CBug_TimerTick", 80, true, "");
    return 1;
}
