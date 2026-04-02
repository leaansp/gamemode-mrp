#if defined _marp_damage_included
	#endinput
#endif
#define _marp_damage_included

#include "system\damage\marp_damage_wound.pwn"
#include "system\damage\marp_damage_weapon.pwn"

#include <YSI_Coding\y_hooks>

#define DAMAGE_FIREGUN_EXTREMITY_NERF	(0.6)
#define DAMAGE_MIN_TO_PROCCESS			(0.15) // Evita floodeo por daos de fuego en damage taken. Omite cerca de la mitad de las ocurrencias

#define DAMAGE_CRACK_HP_MIN_LIMIT		(1.0)
#define DAMAGE_CRACK_HP					(15.0)
#define DAMAGE_CRACK_HP_LOSS			(0.1)

static bool:Damage_dyingCamera[MAX_PLAYERS];
// Temporal suppression window to avoid re-triggering crack immediately after admin heal
new AdminHealSuppressUntil[MAX_PLAYERS];

forward Damage_SuppressCrack(playerid, duration_ms);
public Damage_SuppressCrack(playerid, duration_ms)
{
	AdminHealSuppressUntil[playerid] = gettime() + (duration_ms / 1000);
	return 1;
}

SetPlayerHealthEx(playerid, Float:health)
{
	PlayerInfo[playerid][pHealth] = health;
	SetPlayerHealth(playerid, health);
	return 1;
}

Float:GetPlayerHealthEx(playerid) {
	return PlayerInfo[playerid][pHealth];
}

SetPlayerArmourEx(playerid, Float:armour)
{
	PlayerInfo[playerid][pArmour] = armour;
	SetPlayerArmour(playerid, armour);
	return 1;
}

Float:GetPlayerArmourEx(playerid) {
	return PlayerInfo[playerid][pArmour];
}

hook OnGameModeInit()
{
    SetTeamCount(1);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    SetPlayerTeam(playerid, 1);
    Damage_dyingCamera[playerid] = false;
    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	static woundtype, itemid;

	if(!Weapon_IsValidId(weaponid))
		return false;
	// Allow processing even if the target is in crack (so we can detect "remates").
	if(!WeaponData[weaponid][wProccessWhenGiven] || AdminDuty[damagedid])
		return false;

	// Evitar daño si el jugador que recibe daño está en jail (cualquier tipo de jail)
	if(PlayerInfo[damagedid][pJailed] != JAIL_NONE)
		return false;

	// Evitar daño si el que causa daño está en jail
	if(PlayerInfo[playerid][pJailed] != JAIL_NONE)
		return false;

	if(WeaponData[weaponid][wItemIdLinked])
	{
		itemid = GetHandItem(playerid, HAND_RIGHT);

		if(ItemModel_GetType(itemid) == ITEM_WEAPON && weaponid == WeaponData[ItemModel_GetExtraId(itemid)][wEngineWeaponId]) {
			weaponid = ItemModel_GetExtraId(itemid); // Paso del weaponid de samp a la del servidor
		} else {
			return 0;
		}
	}

	if(WeaponData[weaponid][wHasArmedElbowHit] && amount == 2.6400001049041748046875) {
		woundtype = WOUND_TYPE_HIT;
	}
	else
	{
		amount = (WeaponData[weaponid][wUsesDamageMultiplier]) ? (amount * WeaponData[weaponid][wDamage]) : (WeaponData[weaponid][wDamage]);
		woundtype = WeaponData[weaponid][wWoundType];

		if(WeaponData[weaponid][wHasSpecialEffect]) {
			Weapon_ApplySpecialEffect(weaponid, playerid, damagedid);
		}

		if(bodypart == BODY_PART_HEAD) {
			amount = (WeaponData[weaponid][wUsesDamageMultiplier]) ? (amount * WeaponData[weaponid][wHeadShotDamage]) : (WeaponData[weaponid][wHeadShotDamage]);
		}
		else if(bodypart == BODY_PART_TORSO) // else if(bodypart == BODY_PART_TORSO || bodypart == BODY_PART_GROIN)
		{
			if(WeaponData[weaponid][wArmourAffected])
			{
				if(PlayerInfo[damagedid][pArmour] > 0.0)
				{
					if((PlayerInfo[damagedid][pArmour] -= amount) <= 0.0)
					{
						amount = -PlayerInfo[damagedid][pArmour];
						PlayerInfo[damagedid][pArmour] = 0.0;
					} else {
						amount = 0.0;
					}

					SetPlayerArmour(damagedid, PlayerInfo[damagedid][pArmour]);
				}
			}
		}
		else if(bodypart != BODY_PART_GROIN && WeaponData[weaponid][wType] == WEAPON_TYPE_FIREGUN) { // En piernas o brazos, el dao se reduce
			amount *= DAMAGE_FIREGUN_EXTREMITY_NERF;
		}
	}

	if(amount > DAMAGE_MIN_TO_PROCCESS)
	{
		PlayerInfo[damagedid][pHealth] -= amount;
		if (PlayerInfo[damagedid][pHealth] <= 0.0) {
			Damage_ApplyDeathEffect(damagedid);
			return true;
		} else if (PlayerInfo[damagedid][pHealth] <= DAMAGE_CRACK_HP && !PlayerInfo[damagedid][pCrack]) {
			Damage_ApplyCrackEffect(damagedid);
			SetPlayerHealth(damagedid, PlayerInfo[damagedid][pHealth]);
			Wound_OnPlayerReceived(damagedid, amount, bodypart, woundtype);
		} else {
			SetPlayerHealth(damagedid, PlayerInfo[damagedid][pHealth]);
			Wound_OnPlayerReceived(damagedid, amount, bodypart, woundtype);
		}
	}
	return true;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(!Weapon_IsValidId(weaponid))
		return false;
	if(!WeaponData[weaponid][wProccessWhenTaken] || AdminDuty[playerid])
	{
		SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
		return 0;
	}

	// No se realiza anlisis de headhsot, torso, 2.6400... , chaleco y dems ya que por la configuracin actual todos
	// los daos que se procesen ac son "naturales" o del ambiente, y no lo requieren. Si fuese necesario, el cdigo
	// a agregar sera mas o menos el de OnPlayerGiveDamage

	if(amount > DAMAGE_MIN_TO_PROCCESS)
	{
		// El siguiente código para daños auto-inflingidos no tiene sentido sin setear vida alta pues el cliente reporta la muerte instantanea:
		// if((PlayerInfo[playerid][pHealth] -= amount) <= DAMAGE_CRACK_HP_MIN_LIMIT) {
		// 	Damage_ApplyCrackEffect(playerid);
		// }
		// SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);

		PlayerInfo[playerid][pHealth] -= amount;
		if (PlayerInfo[playerid][pHealth] <= 0.0) {
			Damage_ApplyDeathEffect(playerid);
			return true;
		} else if (PlayerInfo[playerid][pHealth] <= DAMAGE_CRACK_HP && !PlayerInfo[playerid][pCrack]) {
			Damage_ApplyCrackEffect(playerid);
			SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
			Wound_OnPlayerReceived(playerid, amount, bodypart, WeaponData[weaponid][wWoundType]);
		} else {
			SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
			Wound_OnPlayerReceived(playerid, amount, bodypart, WeaponData[weaponid][wWoundType]);
		}
	}

	// En el caso de daños de fuego omitidos, esto actualizaría en tiempo real la barra de vida. Poco necesario dado que son 500ms hasta la sincronización del anticheat:
	// else {
	// 	SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
	// }

	return true;
}

IsPlayerCracked(playerid) {
	return (PlayerInfo[playerid][pCrack] || PlayerInfo[playerid][pDisabled] == DISABLE_DYING || PlayerInfo[playerid][pDisabled] == DISABLE_DEATHBED);
}

Damage_ApplyCrackEffect(playerid)
{
	// If suppressed (recent admin heal), skip applying crack
	if (gettime() < AdminHealSuppressUntil[playerid]) {
		return 0;
	}
	// Don't reset health - preserve actual damage value to prevent regeneration
	// PlayerInfo[playerid][pHealth] = DAMAGE_CRACK_HP;
	PlayerInfo[playerid][pCrack] = 1;
	Wound_UpdateLabel(playerid, "Gravemente herido");
	TogglePlayerControllable(playerid, false);
	Damage_ApplyCrackAnimation(playerid);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, " Te encuentras herido e incapaz de moverte!, con cada segundo que pase perderás algo de sangre.");
	PlayerInfo[playerid][pDisabled] = DISABLE_DYING;
	//Damage_ApplyDyingCamera(playerid);
	Dialog_Show(playerid, DLG_DYING, DIALOG_STYLE_MSGBOX, "Estás desangrándote", "Teniendo en cuenta el entorno en el que te encuentras, decide si es posible que alguien te haya visto y llame a emergencias.", "Avisar", "Cancelar");
	return 1;
}

Dialog:DLG_DYING(playerid, response, listitem, inputtext[])
{
	if(!response)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Desafortunadamente nadie ha notado tu agonía.");

	new Float:x, Float:y, Float:z, area[MAX_ZONE_NAME];

	new houseId = House_IsPlayerInAny(playerid);
	new bizId = Biz_IsPlayerInsideAny(playerid);
	new bldId = Bld_IsPlayerInsideAny(playerid);
	
	if(houseId)
	{
		House_GetOutDoorPos(houseId, x, y, z);
	}
	else if(bizId)
	{
		Biz_GetOutDoorPos(bizId, x, y, z);
	}
	else if(bldId)
	{
		Bld_GetOutDoorPos(bldId, x, y, z);
	}
	else
	{
		PlayerPos_GetExteriorPos(playerid, x, y, z);
	}
	
	GetCoords2DZone(x, y, area, MAX_ZONE_NAME);

	foreach(new i : Player)
	{
		if(IsMedicOnDuty(i) && PlayerHasRadio(i))
		{
			SendFMessage(i, COLOR_WHITE, "[EMERGENCIAS] Se solicita una ambulancia en el barrio de %s. Lo marcamos con rojo en su GPS.", area);
			MapMarker_CreateForPlayer(i, x, y, z, .color = COLOR_RED, .time = 300000);
		}
		else if(isPlayerCopOnDuty(i) && PlayerHasRadio(i))
		{
			SendFMessage(i, COLOR_CENTRALRED, "[911] Persona herida reportada en barrio de %s. Lo marcamos con rojo en su GPS.", area);
			MapMarker_CreateForPlayer(i, x, y, z, .color = COLOR_RED, .time = 300000);
		}
	}

	SendClientMessage(playerid, COLOR_CIVILIAN, "[AVISO] "COLOR_EMB_GREY" Un ciudadano notó tu agonía y ha reportado tu situación al 911!");
	return 1;
}

Damage_ApplyCrackAnimation(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
		ClearAnimations(playerid, 1);
		ApplyAnimationEx(playerid, "WUZI", "CS_DEAD_GUY", 4.0, 1, 1, 1, 1, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	}
	else 
	{
		new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));

		switch (modelid) 
		{
			case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: 
			{
				new Float:vx, Float:vy, Float:vz;
				GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);

				ClearAnimations(playerid, 1);
				if(VectorSize(vx, vy, vz) >= 0.63) {
					ApplyAnimationEx(playerid, "PED", "BIKE_fallR", 4.0, 0, 0, 0, 1, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
				} else {
					ApplyAnimationEx(playerid, "PED", "BIKE_fall_off", 4.0, 0, 0, 0, 1, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
				}
			}
			default: 
			{
				if(GetPlayerVehicleSeat(playerid) & 1) {
					ApplyAnimationEx(playerid, "PED", "CAR_dead_LHS", 4.0, 0, 0, 0, 1, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
				} else {
					ApplyAnimationEx(playerid, "PED", "CAR_dead_RHS", 4.0, 0, 0, 0, 1, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
				}
			}
		}
	}
	return 1;
}

hook function SetPlayerHealthEx(playerid, Float:health)
{
	// If health is set to 0 or below externally, treat as deathbed (allow /morir)
	if (health <= 0.0 && PlayerInfo[playerid][pDisabled] != DISABLE_DEATHBED) {
		Damage_ApplyDeathEffect(playerid);
		return continue(playerid, Float:0.0);
	}
	if(health >= 100.0 && PlayerInfo[playerid][pCrack])
	{
		SendClientMessage(playerid, COLOR_WHITE, " Has sido curado!, ten más cuidado la próxima vez.");
		TogglePlayerControllable(playerid, true);
		ClearAnimations(playerid, 1);
		PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
		PlayerInfo[playerid][pCrack] = 0;
	}

	// Para forzar el estado por si X o Y se le setea la vida a 15
	if(health <= DAMAGE_CRACK_HP && !PlayerInfo[playerid][pCrack])
	{

		Damage_ApplyCrackEffect(playerid);
		return continue(playerid, Float:DAMAGE_CRACK_HP);
	}

	return continue(playerid, health);
}

Damage_ApplyDeathEffect(playerid)
{
	PlayerInfo[playerid][pCrack] = 0;
	TogglePlayerControllable(playerid, false);
	ClearAnimations(playerid, 1);
	ApplyAnimationEx(playerid, "PED", "FLOOR_hit_f", 4.0, 0, 0, 0, 1, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "estás en tu lecho de muerte por lo que ya no podrán salvarte, puedes utilizar {FFFFFF}/morir{87CEFA} o continuar roleando.");
	PlayerInfo[playerid][pDisabled] = DISABLE_DEATHBED;
	Wound_UpdateLabel(playerid, "Muerto");
}

/*
Damage_ApplyDyingCamera(playerid)
{
	if(!GetPlayerInterior(playerid) && !GetPlayerVirtualWorld(playerid)) 
	{
		GetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
		SetPlayerCameraPos(playerid, PlayerInfo[playerid][pX] - 5.0, PlayerInfo[playerid][pY] - 5.0, PlayerInfo[playerid][pZ] + 6.0);
		SetPlayerCameraLookAt(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ], CAMERA_MOVE);
		Damage_dyingCamera[playerid] = true;
	}
}*/

CMD:morir(playerid, params[])
{
	if(PlayerInfo[playerid][pDisabled] == DISABLE_DEATHBED)
	{
		PlayerInfo[playerid][pDisabled] = DISABLE_NONE;

		// Send the player to the hospital when they choose to die (allow roleplay continuation there)
		InitiateHospital(playerid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes utilizarlo en este momento.");
	}
	return 1;
}

hook OnPlayerGlobalUpdate(playerid)
{
	if(!PlayerInfo[playerid][pHospitalized] && PlayerInfo[playerid][pJailed] != JAIL_OOC && !PlayerInfo[playerid][pDead])
	{
		if(Damage_dyingCamera[playerid])
		{
			if(PlayerInfo[playerid][pHealth] > DAMAGE_CRACK_HP || IsPlayerInAnyVehicle(playerid))
			{
				Damage_dyingCamera[playerid] = false;
				SetCameraBehindPlayer(playerid);
			}
		}

		if(PlayerInfo[playerid][pCrack])
		{
			if(PlayerInfo[playerid][pDisabled] != DISABLE_DYING && PlayerInfo[playerid][pDisabled] != DISABLE_DEATHBED) {
				Damage_ApplyCrackEffect(playerid);
			}
			else if(PlayerInfo[playerid][pDisabled] == DISABLE_DYING && PlayerInfo[playerid][pHealth] > DAMAGE_CRACK_HP_MIN_LIMIT) {
				PlayerInfo[playerid][pHealth] -= DAMAGE_CRACK_HP_LOSS;
			}
			else if(PlayerInfo[playerid][pDisabled] != DISABLE_DEATHBED && PlayerInfo[playerid][pHealth] <= DAMAGE_CRACK_HP_MIN_LIMIT) {
				Damage_ApplyDeathEffect(playerid);
			}
		}
	}
	return 1;
}

