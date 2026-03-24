#if defined _marp_cambiarpersonaje_included
	#endinput
#endif
#define _marp_cambiarpersonaje_included

#include <YSI_Coding\y_hooks>

/*
	Sistema de cambio de personaje en juego (/cambiarpersonaje, /cp).
	Permite al jugador cambiar de personaje sin desconectarse del servidor.

	Flujo:
	1. /cambiarpersonaje -> validaciones -> muestra DLG_CHAR_SELECT
	2. Jugador elige personaje -> CharSwitch_DoCleanup() -> carga nuevo personaje
	3. OnContinueCharacterLoad detecta CSwitchLoading y llama SpawnPlayer

	Sistemas que se limpian via hook OnPlayerCharSwitch:
	- marp_holster.pwn -> remueve objeto adjunto y resetea estado
	(Se puede hookear desde cualquier sistema que necesite limpieza)
*/

// ─── ESTADO ───────────────────────────────────────────────────────────────────

static bool:g_IsCharSwitching[MAX_PLAYERS];
static g_CSwitchFreezeTimer[MAX_PLAYERS];

stock bool:CharSwitch_IsSwitching(playerid)
{
	return g_IsCharSwitching[playerid];
}

stock CharSwitch_Begin(playerid)
{
	g_IsCharSwitching[playerid] = true;
}

stock CharSwitch_Reset(playerid)
{
	g_IsCharSwitching[playerid] = false;
}

// ─── CLEANUP ──────────────────────────────────────────────────────────────────

/*
	Guarda el personaje actual, limpia todas las estructuras de memoria
	y pone al jugador en modo espectador para que sea invisible durante la carga.

	Debe llamarse SOLO despues de confirmar que la seleccion es valida.
*/
stock CharSwitch_DoCleanup(playerid)
{
	// Resetear flag (ya no necesitamos distinguir en el dialog)
	g_IsCharSwitching[playerid] = false;

	// 1. Guardar posicion y datos actuales en DB
	PlayerPos_SyncCurrentData(playerid);
	SaveAccount(playerid);

	// 2. Timers
	if(pLoginTransitionTimer[playerid])
	{
		KillTimer(pLoginTransitionTimer[playerid]);
		pLoginTransitionTimer[playerid] = 0;
	}
	KillTimer(GetPVarInt(playerid, "CancelVehicleTransfer"));
	KillTimer(GetPVarInt(playerid, "CancelDrugTransfer"));
	KillTimer(GetPVarInt(playerid, "robberyCancel"));
	KillTimer(GetPVarInt(playerid, "fuelCar"));
	KillTimer(GetPVarInt(playerid, "fuelCarWithCan"));
	KillTimer(ReplenishDescTimer[playerid]);

	// 3. Sacar del vehiculo (para no dejar fantasmas en vehiculos)
	if(IsPlayerInAnyVehicle(playerid))
		RemovePlayerFromVehicle(playerid);

	// 4. Duties y actividades
	AdminDutyNickOff(playerid);
	ResetDescLabel(playerid);
	OnPlayerLeaveRobberyGroup(playerid, 1);
	EndPlayerDuty(playerid);
	deleteAbandonedSprintRace(playerid);
	OnPlayerLeaveRace(playerid);
	Radio_Stop(playerid);
	Cronometro_Borrar(playerid);
	ResetThiefCrime(playerid);
	Job_WorkingPlayerDisconnect(playerid);
	J_Garb_OnPlayerDisconnect(playerid);
	J_Bus_OnPlayerDisconnect(playerid);

	// 5. Notificar sistemas (holster, toys, etc.) para que limpien su estado
	CallLocalFunction("OnPlayerCharSwitch", "i", playerid);

	// 6. Destruir estructuras de memoria de items
	SetPlayerCarrying(playerid, false);
	DestroyPlayerInventory(playerid);
	DestroyPlayerDutyBelt(playerid);
	DestroyPlayerHands(playerid);
	Back_DestroyContainer(playerid);

	// 7. Limpiar freeze anterior y entrar en spectating con estado fisico limpio
	if(g_CSwitchFreezeTimer[playerid])
	{
		KillTimer(g_CSwitchFreezeTimer[playerid]);
		g_CSwitchFreezeTimer[playerid] = 0;
	}
	TogglePlayerControllable(playerid, true);
	gPlayerLogged[playerid] = 0;
	SetPVarInt(playerid, "CSwitchSpawn", 1);

	return 1;
}

// ─── HOOKS ────────────────────────────────────────────────────────────────────

// --- FREEZE / UNFREEZE POST-CAMBIO -------------------------------------------

forward CharSwitch_Unfreeze(playerid);
public CharSwitch_Unfreeze(playerid)
{
	g_CSwitchFreezeTimer[playerid] = 0;
	SetPlayerVelocity(playerid, 0.0, 0.0, 0.0);
	TogglePlayerControllable(playerid, true);
	return 1;
}

stock CharSwitch_FreezeOnSpawn(playerid)
{
	TogglePlayerControllable(playerid, false);
	SetPlayerVelocity(playerid, 0.0, 0.0, 0.0);
	if(g_CSwitchFreezeTimer[playerid])
		KillTimer(g_CSwitchFreezeTimer[playerid]);
	g_CSwitchFreezeTimer[playerid] = SetTimerEx("CharSwitch_Unfreeze", 10000, false, "i", playerid);
	return 1;
}


hook OnPlayerDisconnect(playerid, reason)
{
	g_IsCharSwitching[playerid] = false;
	if(g_CSwitchFreezeTimer[playerid])
	{
		KillTimer(g_CSwitchFreezeTimer[playerid]);
		g_CSwitchFreezeTimer[playerid] = 0;
	}
	return 1;
}
