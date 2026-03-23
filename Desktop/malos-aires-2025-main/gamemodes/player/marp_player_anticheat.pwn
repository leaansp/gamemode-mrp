#if defined _marp_player_anticheat_included
	#endinput
#endif
#define _marp_player_anticheat_included

#include <YSI_Coding\y_hooks>

static playerAntiCheatTimer[MAX_PLAYERS];
static playerAntiCheatImmunity[MAX_PLAYERS];

static enum e_WS_STATE_DATA
{
	e_WS_STATE_NONE,
	e_WS_STATE_WAITING,
	e_WS_STATE_SYNCED
}

static enum e_WS_DATA
{
	e_WS_ID,
	e_WS_AMMO,
	e_WS_TICK_COUNT,
	e_WS_STATE_DATA:e_WS_STATE
}

static pWeaponSync[MAX_PLAYERS + 1][e_WS_DATA] = {{0, 0, 0, e_WS_STATE_NONE}, ...};
const WS_RESET_DATA_ID = MAX_PLAYERS;

hook LoginCamera_OnEnd(playerid)
{
	playerAntiCheatTimer[playerid] = SetTimerEx("OnPlayerAntiCheatUpdate", 503, true, "i", playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(playerAntiCheatTimer[playerid])
	{
		KillTimer(playerAntiCheatTimer[playerid]);
		playerAntiCheatTimer[playerid] = 0;
	}

	WeaponSync_ResetData(playerid);
	return 1;
}

WeaponSync_ResetData(playerid) {
	pWeaponSync[playerid] = pWeaponSync[WS_RESET_DATA_ID];
}

WeaponSync_NewWeaponSent(playerid, weaponid, ammo)
{
	if(weaponid > 0 && ammo > 0)
	{
		pWeaponSync[playerid][e_WS_ID] = weaponid;
		pWeaponSync[playerid][e_WS_AMMO] = ammo;
		pWeaponSync[playerid][e_WS_TICK_COUNT] = 0;
		pWeaponSync[playerid][e_WS_STATE] = e_WS_STATE_WAITING;
	}
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	static itemid, Float:vhealth;

	itemid = GetHandItem(playerid, HAND_RIGHT);

	if(ItemModel_GetType(itemid) == ITEM_WEAPON && weaponid == WeaponData[ItemModel_GetExtraId(itemid)][wEngineWeaponId])
	{
		Weapon_SyncAmmo(playerid, (--HandInfo[playerid][HAND_RIGHT][Amount]), .shotSynced = 1);

		if(hittype == BULLET_HIT_TYPE_VEHICLE)
		{
			GetVehicleHealth(hitid, vhealth);

			if(vhealth > 400.0)
			{
				weaponid = ItemModel_GetExtraId(itemid); // Paso del weaponid de samp a la del servidor
				SetVehicleHealth(hitid, vhealth - ((WeaponData[weaponid][wUsesDamageMultiplier]) ? (30.0 * WeaponData[weaponid][wDamage]) : (WeaponData[weaponid][wDamage])));
			}
			return 0;
		}
		return 1;
	}
	return 0;
}

public OnPlayerShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z) {
	return 1;
}

Weapon_SyncAmmo(playerid, ammo, shotSynced)
{
	if(ammo <= 0)
	{
		if(!shotSynced) {
			SendFMessage(playerid, COLOR_WHITE, "[OOC] Te quedaste sin Munición en tu %s. Si es un error, toma una foto con F8 y /timestamp activo.", ItemModel_GetName(GetHandItem(playerid, HAND_RIGHT)));
		}

		if(Weapon_GetMagazineId(ItemModel_GetExtraId(GetHandItem(playerid, HAND_RIGHT))))
		{
			HandInfo[playerid][HAND_RIGHT][Amount] = 0;
			Weapon_RemoveFromPlayer(playerid);
		} else {
			SetHandItemAndParam(playerid, HAND_RIGHT, 0, 0);
		}
	} else {
		HandInfo[playerid][HAND_RIGHT][Amount] = ammo;
	}
}

forward OnPlayerAntiCheatUpdate(playerid);
public OnPlayerAntiCheatUpdate(playerid)
{
	static holdingWeapon;
	static holdingAmmo;
	static handItem;
	static specificWeaponData;
	static specificAmmoData;
	static handEngineWeaponId;

	if(PlayerInfo[playerid][pDead] || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		return 0;

	/* Player Bars Sync **************************************************************************************************/

	SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
	SetPlayerArmour(playerid, PlayerInfo[playerid][pArmour]);

	/* Weapon sync ********************************************************************************************************/

	if(pWeaponSync[playerid][e_WS_STATE] == e_WS_STATE_WAITING)
	{
		GetPlayerWeaponData(playerid, Weapon_GetSlot(pWeaponSync[playerid][e_WS_ID]), specificWeaponData, specificAmmoData);

		if(specificWeaponData == pWeaponSync[playerid][e_WS_ID]) // && specificAmmoData > 0)
		{
			pWeaponSync[playerid][e_WS_STATE] = e_WS_STATE_SYNCED;
			pWeaponSync[playerid][e_WS_TICK_COUNT] = 0;
		}
		else if((++pWeaponSync[playerid][e_WS_TICK_COUNT]) > 5) // Resend after 5 AC ticks in case of lost package
		{
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, pWeaponSync[playerid][e_WS_ID], pWeaponSync[playerid][e_WS_AMMO]);
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El servidor está intentando darte el arma %s, pero tu cliente no la recibe.", ItemModel_GetName(pWeaponSync[playerid][e_WS_ID]));
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Si el problema persiste, es probable que estes con lag o desincronizado, y te recomendamos reconectarte.");
		}
	}

	/* Item and weapon ammo sync ******************************************************************************************/

	handItem = GetHandItem(playerid, HAND_RIGHT);
	holdingWeapon = GetPlayerWeapon(playerid);
	holdingAmmo = GetPlayerAmmo(playerid);

	// Notas de color:
	//		GetPlayerWeapon no detecta arma sostenida seteada dentro del vehículo, reporta el arma que sostenía al ingresar al vehículo.
	// 		GetPlayerAmmo si detecta correctamente la Munición del arma seleccionada dentro del vehículo, aún cuando no es la misma con la que ingresó.
	//		Usando GetPlayerWeaponData se puede sincronizar las balas aún cuando no tiene esa arma seleccionada
	// 		holdingAmmo: balas en arma que porta actualmente
	//		specificAmmoData: balas del slot correspondiente al arma legal de mano handItem
	//		Si el item es un arma custom, handItem toma el valor del item/weapon real que utiliza para poder realizar todo el procesamiento posterior de forma genérica

	// ESCENARIO DE ITEM ARMA EN MANO
	if(ItemModel_GetType(handItem) == ITEM_WEAPON)
	{
		handEngineWeaponId = Weapon_GetEngineWeaponId(ItemModel_GetExtraId(handItem));

		GetPlayerWeaponData(playerid, Weapon_GetSlot(handEngineWeaponId), specificWeaponData, specificAmmoData);

		// ESCENARIO EN VEHíCULO (muchas funciones nativas funcionan incorrectamente o de forma irregular)

		if(IsPlayerInAnyVehicle(playerid))
		{
			// Discrepancia entre las balas, significa que no sostiene el arma handEngineWeaponId -> Posible weapon cheat
			if(holdingAmmo != specificAmmoData)
			{
				// Analizamos los slots de armas para ver si hay alguna (que no sea la de mano) que tenga balas
				// Una forma mas simple sería resetear armas y dar la de mano, o setear la de mano como activa, pero se pierde la alerta específica y el reseteo del arma, respectivamente.
				// Esto no ocurre normalmente, solo cuando se sostiene un arma con municion distinta a la de mano
				for(new i = 0, w, a; i < 12; i++)
				{
					GetPlayerWeaponData(playerid, i, w, a);

					if(a > 0 && w != handEngineWeaponId)
					{
						SendAntiCheatAlert(playerid, ItemModel_GetName(w)); // Se alerta
						SetPlayerAmmo(playerid, w, 0); // Se elimina
					}
				}
			}

			// Tiene un arma que va en ese mismo slot pero no es la que tiene en la mano
			if(specificWeaponData && specificWeaponData != handEngineWeaponId)
			{
				SendAntiCheatAlert(playerid, ItemModel_GetName(specificWeaponData));
				ResetPlayerWeapons(playerid);

				if(pWeaponSync[playerid][e_WS_STATE] == e_WS_STATE_SYNCED && specificAmmoData) {
					GivePlayerWeapon(playerid, handEngineWeaponId, specificAmmoData);
				}
			}

			// Se setea como activa la de mano, si tuviese otra arma cheat con misma cantidad de balas que la de la mano, o arma cheat que ocupa mismo slot (ej: en mano 9mm, cheat deagle), seteamos la activa a la de mano
			if(pWeaponSync[playerid][e_WS_STATE] == e_WS_STATE_SYNCED && specificAmmoData) {
				SetPlayerArmedWeapon(playerid, handEngineWeaponId);
			}
		}
		// ESCENARIO A PIE (funcionamiento de nativas normal)
		else if(holdingWeapon != handEngineWeaponId)
		{
			if(holdingWeapon != 0)
			{
				SendAntiCheatAlert(playerid, ItemModel_GetName(holdingWeapon));
				ResetPlayerWeapons(playerid);

				if(pWeaponSync[playerid][e_WS_STATE] == e_WS_STATE_SYNCED && specificAmmoData) {
					GivePlayerWeapon(playerid, handEngineWeaponId, specificAmmoData);
				}
			} else if(pWeaponSync[playerid][e_WS_STATE] == e_WS_STATE_SYNCED && specificAmmoData) {
				SetPlayerArmedWeapon(playerid, handEngineWeaponId);
			}
		}

		if(pWeaponSync[playerid][e_WS_STATE] == e_WS_STATE_SYNCED)
		{
			if(!Weapon_IsPlayerAmmoShotSynced(playerid, handEngineWeaponId))
			{
				if(specificAmmoData > GetHandParam(playerid, HAND_RIGHT))
				{
					SendAntiCheatAlert(playerid, "balas extra para su arma");
					SetPlayerAmmo(playerid, handEngineWeaponId, GetHandParam(playerid, HAND_RIGHT));
				} else if(!playerAntiCheatImmunity[playerid]) {
					Weapon_SyncAmmo(playerid, specificAmmoData, .shotSynced = 0);
				}
			}
		}
	}
	// ESCENARIO SIN ITEM ARMA EN MANO Y EN VEHíCULO (funcionamiento de nativas irregular)
	else if(IsPlayerInAnyVehicle(playerid))
	{
		if(holdingAmmo > 0) // holdingAmmo > 0 previene alertas de armas legales usadas hasta agotarse a 0
		{
			SendAntiCheatAlert(playerid, "arma dentro del vehículo");
			ResetPlayerWeapons(playerid); // Prevents cheat weapon spawn inside vehicle
		}
	}
	// ESCENARIO SIN ITEM ARMA EN MANO Y A PIE (funcionamiento de nativas normal)
	else if(holdingWeapon != 0)
	{
		SendAntiCheatAlert(playerid, ItemModel_GetName(holdingWeapon));
		ResetPlayerWeapons(playerid);
	}

	/* Forbidden actions **************************************************************************************************/

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		// Forbidden weapon anticheat
		if((35 <= holdingWeapon <= 40) || (44 <= holdingWeapon <= 45))
		{
			new string[128];
			format(string, sizeof(string), "arma %d [%s] prohibida", holdingWeapon, ItemModel_GetName(holdingWeapon));
			SetPlayerAmmo(playerid, holdingWeapon, 0);
			KickPlayer(playerid, "el sistema", string);
		}

		// Jetpack anticheat
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK) {
			BanPlayer(playerid, INVALID_PLAYER_ID, "Cheat Jet Pack", 0);
		}
	}

	/* Money edit alerts **************************************************************************************************/

	if(GetPlayerCash(playerid) != GetPlayerMoney(playerid))
	{
		new hack = GetPlayerMoney(playerid) - GetPlayerCash(playerid);

		if(hack >= 100000)
		{
			new string[128];
			format(string, sizeof(string), "[ALERTA] "COLOR_EMB_ALERT" Posible edición de %s (ID %i) por $%i.", GetPlayerCleanName(playerid), playerid, hack);
			AdministratorMessage(COLOR_ALERT, string, 2);

			ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="ANTICHEAT", .playerid=playerid, .params=<"Intento editarse $%d", hack>);
		}

		SyncPlayerCash(playerid);
	}
	return 1;
}

SendAntiCheatAlert(playerid, const message[])
{
	static string[128];

	if(!playerAntiCheatImmunity[playerid])
	{
		format(string, sizeof(string), "[ALERTA] "COLOR_EMB_ALERT" Posible edición de %s (ID %i) por un/a %s.", GetPlayerCleanName(playerid), playerid, message);
		AdministratorMessage(COLOR_ALERT, string, 2);
	}
}

SetPlayerAntiCheatImmunity(playerid, time)
{
	if(playerAntiCheatImmunity[playerid]) {
		KillTimer(playerAntiCheatImmunity[playerid]);
	}
	
	playerAntiCheatImmunity[playerid] = SetTimerEx("PlayerAntiCheatImmunityEnd", time, false, "i", playerid);
}

forward PlayerAntiCheatImmunityEnd(playerid);
public PlayerAntiCheatImmunityEnd(playerid)
{
	playerAntiCheatImmunity[playerid] = 0;
	return 1;
}