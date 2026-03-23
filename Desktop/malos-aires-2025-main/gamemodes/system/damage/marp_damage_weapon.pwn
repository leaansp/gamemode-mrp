#if defined _marp_damage_weapon_included
	#endinput
#endif
#define _marp_damage_weapon_included

#include "item\marp_item_model_ids.pwn"

#include <YSI_Coding\y_hooks>

/*_______________ Originales y reales del GTA / SAMP _______________*/
/*__________________________ IDs [0 - 54] __________________________*/

#define WEAPON_NONE						(0)
#define WEAPON_INVALID_19				(19)
#define WEAPON_INVALID_20				(20)
#define WEAPON_INVALID_21				(21)
#define WEAPON_NIGHT_VISION				(44)
#define WEAPON_THERMAL_VISION			(45)
#define WEAPON_INVALID_47				(47)
#define WEAPON_INVALID_48				(48)
#define WEAPON_HELI_BLADE				(50)
#define WEAPON_EXPLOSION				(51)
#define WEAPON_INVALID_52				(52)

/*_____________ Nuevas IDs de armas custom del servidor ____________*/
/*__________________________ IDs [55, ...] _________________________*/

#define WEAPON_TASER					(55)
#define WEAPON_NON_LETAL_SHOTGUN		(56)
#define WEAPON_BERETTA_PX4_STORM		(57)
#define WEAPON_FACA_TUMBERA				(58)
#define WEAPON_TACTIC_KNIFE				(59)
#define WEAPON_CHEF_KNIFE				(60)
#define WEAPON_SLEDGEHAMMER				(61)
#define WEAPON_BERSA_BP9				(62)
#define WEAPON_GLOCK_19					(63)
#define WEAPON_BALLESTER_MOLINA_45		(64)
#define WEAPON_BERSA_TPR_45				(65)
#define WEAPON_REVOLVER_ROSSI_38		(66)
#define WEAPON_REVOLVER_SW_60			(67)
#define WEAPON_MOSSBERG_500				(68)
#define WEAPON_REMINGTON_870			(69)
#define WEAPON_BATAAN_71				(70)
#define WEAPON_SAWEDOFF_TUMBERA			(71)
#define WEAPON_TAURUS_PT_92				(72)
#define WEAPON_BENELLI_M3_S90			(73)
#define WEAPON_AKKAR_12_70				(74)
#define WEAPON_STEYR_MPI_69				(75)
#define WEAPON_FMK_3					(76)
#define WEAPON_BERETTA_93R				(77)
#define WEAPON_HECKLER_KOCH_UMP9		(78)
#define WEAPON_TAURUS_SMT9				(79)
#define WEAPON_FAMAE_SAF				(80)
#define WEAPON_INGRAM_MAC10				(81)
#define WEAPON_SKORPION_VZ68			(82)
#define WEAPON_FLASHBANG				(83)

#define EFFECT_NON_LETAL_SHOTGUN_RANGE	(20.0)
#define EFFECT_NON_LETAL_SHOTGUN_TIME	(2500)

#define EFFECT_TASER_RANGE				(7.5)
#define EFFECT_TASER_TIME				(15000)

enum
{
	WEAPON_TYPE_NONE,
	WEAPON_TYPE_MELEE,
	WEAPON_TYPE_FIREGUN,
	WEAPON_TYPE_FIRE,
	WEAPON_TYPE_EXPLOSIVE,
	WEAPON_TYPE_OTHER,

	WEAPON_TYPES_AMOUNT
};

enum e_WEAPON_DATA
{
	wId, // Solo propósito de identificar facilmente un arma en la estructura
	bool:wProccessWhenGiven, // Si es una fuente de daño válida para procesar al ocasionarse
	bool:wProccessWhenTaken, // Si es una fuente de daño válida para procesar al recibirse
	wSlot, // Slot que ocupa dentro del engine de samp
	wType, // Tipo de arma
	wWoundType, // Tipo de daño que efectúa el arma y que será procesado por el sistema de heridas. WOUND_TYPE_NONE no se procesa en heridas
	bool:wUsesDamageMultiplier, // Si los datos de daño son valores absolutos o un modificador porcentual del daño original
	Float:wDamage, // Daño que produce
	Float:wHeadShotDamage, // Daño específico al caso de headshot
	bool:wHasArmedElbowHit, // Si es un tipo de arma a distancia que en rango melee pega codazo
	bool:wHasSpecialEffect, // Si el arma posee un efecto especial ademas del daño corriente
	bool:wArmourAffected, // Si el daño es amortiguado por el chaleco en caso de que sea localizado en el pecho
	wItemIdLinked, // Si el arma necesita que el agresor tenga un item en mano, especifica qué item id
	wEngineWeaponId, // Especifica qué weapon id real de SAMP le corresponde a esa arma del servidor
	wMagazine // Especifica que cargador acepta esta arma
};

new const WeaponData[][e_WEAPON_DATA] = {
/*0*/ {
	/*wId*/ WEAPON_NONE,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.7,
	/*wHeadShotDamage*/ 0.7,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_NONE,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*1*/ {
	/*wId*/ WEAPON_BRASSKNUCKLE,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.5,
	/*wHeadShotDamage*/ 1.5,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_BRASSKNUCKLE,
	/*wEngineWeaponId*/ WEAPON_BRASSKNUCKLE,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*2*/ {
	/*wId*/ WEAPON_GOLFCLUB,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 1,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.2,
	/*wHeadShotDamage*/ 1.2,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_GOLFCLUB,
	/*wEngineWeaponId*/ WEAPON_GOLFCLUB,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*3*/ {
	/*wId*/ WEAPON_NITESTICK,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 1,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 2.2,
	/*wHeadShotDamage*/ 2.2,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_NITESTICK,
	/*wEngineWeaponId*/ WEAPON_NITESTICK,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*4*/ {
	/*wId*/ WEAPON_KNIFE,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 1,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_BLADE,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 2.7,
	/*wHeadShotDamage*/ 2.7,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_KNIFE,
	/*wEngineWeaponId*/ WEAPON_KNIFE,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*5*/ {
	/*wId*/ WEAPON_BAT,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 1,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.9,
	/*wHeadShotDamage*/ 1.9,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_BAT,
	/*wEngineWeaponId*/ WEAPON_BAT,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*6*/ {
	/*wId*/ WEAPON_SHOVEL,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 1,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.8,
	/*wHeadShotDamage*/ 1.8,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_SHOVEL,
	/*wEngineWeaponId*/ WEAPON_SHOVEL,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*7*/ {
	/*wId*/ WEAPON_POOLSTICK,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 1,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.9,
	/*wHeadShotDamage*/ 0.9,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_POOLSTICK,
	/*wEngineWeaponId*/ WEAPON_POOLSTICK,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*8*/ {
	/*wId*/ WEAPON_KATANA,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 1,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_BLADE,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 2.7,
	/*wHeadShotDamage*/ 2.7,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_KATANA,
	/*wEngineWeaponId*/ WEAPON_KATANA,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*9*/ {
	/*wId*/ WEAPON_CHAINSAW,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 1,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_BLADE,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.0,
	/*wHeadShotDamage*/ 1.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_CHAINSAW,
	/*wEngineWeaponId*/ WEAPON_CHAINSAW,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*10*/ {
	/*wId*/ WEAPON_DILDO,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 10,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.5,
	/*wHeadShotDamage*/ 0.5,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_DILDO,
	/*wEngineWeaponId*/ WEAPON_DILDO,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*11*/ {
	/*wId*/ WEAPON_DILDO2,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 10,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.5,
	/*wHeadShotDamage*/ 0.5,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_DILDO2,
	/*wEngineWeaponId*/ WEAPON_DILDO2,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*12*/ {
	/*wId*/ WEAPON_VIBRATOR,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 10,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.5,
	/*wHeadShotDamage*/ 0.5,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_VIBRATOR,
	/*wEngineWeaponId*/ WEAPON_VIBRATOR,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*13*/ {
	/*wId*/ WEAPON_VIBRATOR2,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 10,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.5,
	/*wHeadShotDamage*/ 0.5,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_VIBRATOR2,
	/*wEngineWeaponId*/ WEAPON_VIBRATOR2,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*14*/ {
	/*wId*/ WEAPON_FLOWER,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 10,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_FLOWER,
	/*wEngineWeaponId*/ WEAPON_FLOWER,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*15*/ {
	/*wId*/ WEAPON_CANE,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 10,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.8,
	/*wHeadShotDamage*/ 1.8,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_CANE,
	/*wEngineWeaponId*/ WEAPON_CANE,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*16*/ {
	/*wId*/ WEAPON_GRENADE,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 8,
	/*wType*/ WEAPON_TYPE_EXPLOSIVE,
	/*wWoundType*/ WOUND_TYPE_EXPLOSION,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_GRENADE,
	/*wEngineWeaponId*/ WEAPON_GRENADE,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*17*/ {
	/*wId*/ WEAPON_TEARGAS,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 8,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_TEARGAS,
	/*wEngineWeaponId*/ WEAPON_TEARGAS,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*18*/ {
	/*wId*/ WEAPON_MOLTOV,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 8,
	/*wType*/ WEAPON_TYPE_FIRE,
	/*wWoundType*/ WOUND_TYPE_FIRE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_MOLTOV,
	/*wEngineWeaponId*/ WEAPON_MOLTOV,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*19*/ {
	/*wId*/ WEAPON_INVALID_19,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_NONE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_INVALID_19,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*20*/ {
	/*wId*/ WEAPON_INVALID_20,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_NONE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_INVALID_20,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*21*/ {
	/*wId*/ WEAPON_INVALID_21,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_NONE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_INVALID_21,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*22*/ {
	/*wId*/ WEAPON_COLT45,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 16.50,
	/*wHeadShotDamage*/ 20.63,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_COLT45,
	/*wEngineWeaponId*/ WEAPON_COLT45,
	/*wMagazine*/ ITEM_ID_COLT_MAGAZINE
	},
/*23*/ {
	/*wId*/ WEAPON_SILENCED,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 16.50,
	/*wHeadShotDamage*/ 20.63,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_SILENCED,
	/*wEngineWeaponId*/ WEAPON_SILENCED,
	/*wMagazine*/ ITEM_ID_COLT_MAGAZINE
	},
/*24*/ {
	/*wId*/ WEAPON_DEAGLE,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_50,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 26.72,
	/*wHeadShotDamage*/ 33.76,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_DEAGLE,
	/*wEngineWeaponId*/ WEAPON_DEAGLE,
	/*wMagazine*/ ITEM_ID_DEAGLE_MAGAZINE
	},
/*25*/ {
	/*wId*/ WEAPON_SHOTGUN,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_SHOTGUN,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.80,
	/*wHeadShotDamage*/ 1.05,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_SHOTGUN,
	/*wEngineWeaponId*/ WEAPON_SHOTGUN,
	/*wMagazine*/ ITEM_ID_SHOTGUN_SHELLS
	},
/*26*/ {
	/*wId*/ WEAPON_SAWEDOFF,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_SHOTGUN,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.50,
	/*wHeadShotDamage*/ 0.7,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_SAWEDOFF,
	/*wEngineWeaponId*/ WEAPON_SAWEDOFF,
	/*wMagazine*/ ITEM_ID_SHOTGUN_SHELLS
	},
/*27*/ {
	/*wId*/ WEAPON_SHOTGSPA,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_SHOTGUN,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.70,
	/*wHeadShotDamage*/ 0.9,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_SHOTGSPA,
	/*wEngineWeaponId*/ WEAPON_SHOTGSPA,
	/*wMagazine*/ ITEM_ID_SHOTGUN_SHELLS
	},
/*28*/ {
	/*wId*/ WEAPON_UZI,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 11.20,
	/*wHeadShotDamage*/ 14.50,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_UZI,
	/*wEngineWeaponId*/ WEAPON_UZI,
	/*wMagazine*/ ITEM_ID_UZI_MAGAZINE
	},
/*29*/ {
	/*wId*/ WEAPON_MP5,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 14.85,
	/*wHeadShotDamage*/ 20.63,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_MP5,
	/*wEngineWeaponId*/ WEAPON_MP5,
	/*wMagazine*/ ITEM_ID_MP5_MAGAZINE
	},
/*30*/ {
	/*wId*/ WEAPON_AK47,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 5,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_762MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 19.31,
	/*wHeadShotDamage*/ 33.66,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_AK47,
	/*wEngineWeaponId*/ WEAPON_AK47,
	/*wMagazine*/ ITEM_ID_AK47_MAGAZINE
	},
/*31*/ {
	/*wId*/ WEAPON_M4,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 5,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_556MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 19.31,
	/*wHeadShotDamage*/ 33.66,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_M4,
	/*wEngineWeaponId*/ WEAPON_M4,
	/*wMagazine*/ ITEM_ID_M4_MAGAZINE
	},
/*32*/ {
	/*wId*/ WEAPON_TEC9,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 13.20,
	/*wHeadShotDamage*/ 16.50,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_TEC9,
	/*wEngineWeaponId*/ WEAPON_TEC9,
	/*wMagazine*/ ITEM_ID_UZI_MAGAZINE
	},
/*33*/ {
	/*wId*/ WEAPON_RIFLE,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 6,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_762MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 37.20,
	/*wHeadShotDamage*/ 52.08,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_RIFLE,
	/*wEngineWeaponId*/ WEAPON_RIFLE,
	/*wMagazine*/ ITEM_ID_RIFLE_BULLETS
	},
/*34*/ {
	/*wId*/ WEAPON_SNIPER,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 6,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_762MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 51.62,
	/*wHeadShotDamage*/ 138.60,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_SNIPER,
	/*wEngineWeaponId*/ WEAPON_SNIPER,
	/*wMagazine*/ ITEM_ID_RIFLE_BULLETS
	},
/*35*/ {
	/*wId*/ WEAPON_ROCKETLAUNCHER,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 7,
	/*wType*/ WEAPON_TYPE_EXPLOSIVE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_ROCKETLAUNCHER,
	/*wEngineWeaponId*/ WEAPON_ROCKETLAUNCHER,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*36*/ {
	/*wId*/ WEAPON_HEATSEEKER,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 7,
	/*wType*/ WEAPON_TYPE_EXPLOSIVE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_HEATSEEKER,
	/*wEngineWeaponId*/ WEAPON_HEATSEEKER,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*37*/ {
	/*wId*/ WEAPON_FLAMETHROWER,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 7,
	/*wType*/ WEAPON_TYPE_FIRE,
	/*wWoundType*/ WOUND_TYPE_FIRE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_FLAMETHROWER,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*38*/ {
	/*wId*/ WEAPON_MINIGUN,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 7,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_MINIGUN,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*39*/ {
	/*wId*/ WEAPON_SATCHEL,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 8,
	/*wType*/ WEAPON_TYPE_EXPLOSIVE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_SATCHEL,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*40*/ {
	/*wId*/ WEAPON_BOMB,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 12,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_BOMB,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*41*/ {
	/*wId*/ WEAPON_SPRAYCAN,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 9,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_SPRAYCAN,
	/*wEngineWeaponId*/ WEAPON_SPRAYCAN,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*42*/ {
	/*wId*/ WEAPON_FIREEXTINGUISHER,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 9,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_FIREEXTINGUISHER,
	/*wEngineWeaponId*/ WEAPON_FIREEXTINGUISHER,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*43*/ {
	/*wId*/ WEAPON_CAMERA,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 9,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_CAMARA,
	/*wEngineWeaponId*/ WEAPON_CAMERA,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*44*/ {
	/*wId*/ WEAPON_NIGHT_VISION,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 11,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_NIGHT_VISION,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*45*/ {
	/*wId*/ WEAPON_THERMAL_VISION,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 11,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_THERMAL_VISION,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*46*/ {
	/*wId*/ WEAPON_PARACHUTE,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 11,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_PARACHUTE,
	/*wEngineWeaponId*/ WEAPON_PARACHUTE,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*47*/ {
	/*wId*/ WEAPON_INVALID_47,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_NONE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_INVALID_47,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*48*/ {
	/*wId*/ WEAPON_INVALID_48,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_NONE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_INVALID_48,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*49*/ {
	/*wId*/ WEAPON_VEHICLE,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_TRAUMA,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_VEHICLE,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*50*/ {
	/*wId*/ WEAPON_HELI_BLADE,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_BLADE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_HELI_BLADE,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*51*/ {
	/*wId*/ WEAPON_EXPLOSION,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_EXPLOSIVE,
	/*wWoundType*/ WOUND_TYPE_EXPLOSION,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_EXPLOSION,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*52*/ {
	/*wId*/ WEAPON_INVALID_52,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_NONE,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_INVALID_52,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*53*/ {
	/*wId*/ WEAPON_DROWN,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_DROWN,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*54*/ {
	/*wId*/ WEAPON_COLLISION,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ true,
	/*wSlot*/ 0,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_TRAUMA,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ 0,
	/*wEngineWeaponId*/ WEAPON_COLLISION,
	/*wMagazine*/ ITEM_ID_NULL
	},

	/*_____________ Nuevas IDs de armas custom del servidor ____________*/
	/*__________________________ IDs [55, ...] _________________________*/

/*55*/ {
	/*wId*/ WEAPON_TASER,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ true,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_TASER,
	/*wEngineWeaponId*/ WEAPON_SILENCED,
	/*wMagazine*/ ITEM_ID_TAZER_CHARGE
	},
/*56*/ {
	/*wId*/ WEAPON_NON_LETAL_SHOTGUN,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 5.0,
	/*wHeadShotDamage*/ 5.0,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ true,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_ESCOPETA_NO_LETAL,
	/*wEngineWeaponId*/ WEAPON_SHOTGUN,
	/*wMagazine*/ ITEM_ID_LESSLETHAL_SHELL
	},
/*57*/ {
	/*wId*/ WEAPON_BERETTA_PX4_STORM,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 18.0,
	/*wHeadShotDamage*/ 22.10,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_BERETTA_PX4_STORM,
	/*wEngineWeaponId*/ WEAPON_COLT45,
	/*wMagazine*/ ITEM_ID_COLT_MAGAZINE
	},
/*58*/ {
	/*wId*/ WEAPON_FACA_TUMBERA,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 10,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_BLADE,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.4,
	/*wHeadShotDamage*/ 1.4,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_FACA_TUMBERA,
	/*wEngineWeaponId*/ WEAPON_VIBRATOR2,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*59*/ {
	/*wId*/ WEAPON_TACTIC_KNIFE,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 10,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_BLADE,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.8,
	/*wHeadShotDamage*/ 1.8,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_TACTIC_KNIFE,
	/*wEngineWeaponId*/ WEAPON_DILDO2,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*60*/ {
	/*wId*/ WEAPON_CHEF_KNIFE,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 10,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_BLADE,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.6,
	/*wHeadShotDamage*/ 1.6,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_CHEF_KNIFE,
	/*wEngineWeaponId*/ WEAPON_VIBRATOR2,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*61*/ {
	/*wId*/ WEAPON_SLEDGEHAMMER,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 1,
	/*wType*/ WEAPON_TYPE_MELEE,
	/*wWoundType*/ WOUND_TYPE_HIT,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 1.7,
	/*wHeadShotDamage*/ 1.7,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_SLEDGEHAMMER,
	/*wEngineWeaponId*/ WEAPON_GOLFCLUB,
	/*wMagazine*/ ITEM_ID_NULL
	},
/*62*/ {
	/*wId*/ WEAPON_BERSA_BP9,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 15.1,
	/*wHeadShotDamage*/ 18.85,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_BERSA_BP9,
	/*wEngineWeaponId*/ WEAPON_COLT45,
	/*wMagazine*/ ITEM_ID_COLT_MAGAZINE
	},
/*63*/ {
	/*wId*/ WEAPON_GLOCK_19,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 16.1,
	/*wHeadShotDamage*/ 19.93,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_GLOCK_19,
	/*wEngineWeaponId*/ WEAPON_COLT45,
	/*wMagazine*/ ITEM_ID_COLT_MAGAZINE
	},
/*64*/ {
	/*wId*/ WEAPON_BALLESTER_MOLINA_45,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_50,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 28.5,
	/*wHeadShotDamage*/ 36.15,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_BALLESTER_MOLINA_45,
	/*wEngineWeaponId*/ WEAPON_DEAGLE,
	/*wMagazine*/ ITEM_ID_DEAGLE_MAGAZINE
	},
/*65*/ {
	/*wId*/ WEAPON_BERSA_TPR_45,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_50,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 24.93,
	/*wHeadShotDamage*/ 31.51,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_BERSA_TPR_45,
	/*wEngineWeaponId*/ WEAPON_DEAGLE,
	/*wMagazine*/ ITEM_ID_DEAGLE_MAGAZINE
	},
/*66*/ {
	/*wId*/ WEAPON_REVOLVER_ROSSI_38,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_50,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 21.37,
	/*wHeadShotDamage*/ 27.1,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_REVOLVER_ROSSI_38,
	/*wEngineWeaponId*/ WEAPON_DEAGLE,
	/*wMagazine*/ ITEM_ID_DEAGLE_MAGAZINE
	},
/*67*/ {
	/*wId*/ WEAPON_REVOLVER_SW_60,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_50,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 23.15,
	/*wHeadShotDamage*/ 29.25,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_REVOLVER_SW_60,
	/*wEngineWeaponId*/ WEAPON_DEAGLE,
	/*wMagazine*/ ITEM_ID_DEAGLE_MAGAZINE
	},
/*68*/ {
	/*wId*/ WEAPON_MOSSBERG_500,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_SHOTGUN,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.85,
	/*wHeadShotDamage*/ 1.1,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_MOSSBERG_500,
	/*wEngineWeaponId*/ WEAPON_SHOTGUN,
	/*wMagazine*/ ITEM_ID_SHOTGUN_SHELLS
	},
/*69*/ {
	/*wId*/ WEAPON_REMINGTON_870,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_SHOTGUN,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.70,
	/*wHeadShotDamage*/ 0.95,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_REMINGTON_870,
	/*wEngineWeaponId*/ WEAPON_SHOTGUN,
	/*wMagazine*/ ITEM_ID_SHOTGUN_SHELLS
	},
/*70*/ {
	/*wId*/ WEAPON_BATAAN_71,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_SHOTGUN,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.60,
	/*wHeadShotDamage*/ 0.85,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_BATAAN_71,
	/*wEngineWeaponId*/ WEAPON_SHOTGUN,
	/*wMagazine*/ ITEM_ID_SHOTGUN_SHELLS
	},
/*71*/ {
	/*wId*/ WEAPON_SAWEDOFF_TUMBERA,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_SHOTGUN,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.45,
	/*wHeadShotDamage*/ 0.65,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_SAWEDOFF_TUMBERA,
	/*wEngineWeaponId*/ WEAPON_SAWEDOFF,
	/*wMagazine*/ ITEM_ID_SHOTGUN_SHELLS
	},
/*72*/ {
	/*wId*/ WEAPON_TAURUS_PT_92,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 2,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 15.65,
	/*wHeadShotDamage*/ 19.41,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_TAURUS_PT_92,
	/*wEngineWeaponId*/ WEAPON_COLT45,
	/*wMagazine*/ ITEM_ID_COLT_MAGAZINE
	},
/*73*/ {
	/*wId*/ WEAPON_BENELLI_M3_S90,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_SHOTGUN,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.60,
	/*wHeadShotDamage*/ 0.8,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_BENELLI_M3_S90,
	/*wEngineWeaponId*/ WEAPON_SHOTGSPA,
	/*wMagazine*/ ITEM_ID_SHOTGUN_SHELLS
	},
/*74*/ {
	/*wId*/ WEAPON_AKKAR_12_70,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 3,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_SHOTGUN,
	/*wUsesDamageMultiplier*/ true,
	/*wDamage*/ 0.50,
	/*wHeadShotDamage*/ 0.7,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_AKKAR_12_70,
	/*wEngineWeaponId*/ WEAPON_SHOTGSPA,
	/*wMagazine*/ ITEM_ID_SHOTGUN_SHELLS
	},
/*75*/ {
	/*wId*/ WEAPON_STEYR_MPI_69,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 12.20,
	/*wHeadShotDamage*/ 14.90,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_STEYR_MPI_69,
	/*wEngineWeaponId*/ WEAPON_UZI,
	/*wMagazine*/ ITEM_ID_UZI_MAGAZINE
	},
/*76*/ {
	/*wId*/ WEAPON_FMK_3,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 13.20,
	/*wHeadShotDamage*/ 16.50,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_FMK_3,
	/*wEngineWeaponId*/ WEAPON_UZI,
	/*wMagazine*/ ITEM_ID_UZI_MAGAZINE
	},
/*77*/ {
	/*wId*/ WEAPON_BERETTA_93R,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 10.1,
	/*wHeadShotDamage*/ 12.50,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_BERETTA_93R,
	/*wEngineWeaponId*/ WEAPON_UZI,
	/*wMagazine*/ ITEM_ID_UZI_MAGAZINE
	},
/*78*/ {
	/*wId*/ WEAPON_HECKLER_KOCH_UMP9,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 14.0,
	/*wHeadShotDamage*/ 19.54,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_HECKLER_KOCH_UMP9,
	/*wEngineWeaponId*/ WEAPON_MP5,
	/*wMagazine*/ ITEM_ID_MP5_MAGAZINE
	},
/*79*/ {
	/*wId*/ WEAPON_TAURUS_SMT9,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 13.25,
	/*wHeadShotDamage*/ 18.45,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_TAURUS_SMT9,
	/*wEngineWeaponId*/ WEAPON_MP5,
	/*wMagazine*/ ITEM_ID_MP5_MAGAZINE
	},
/*80*/ {
	/*wId*/ WEAPON_FAMAE_SAF,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 12.5,
	/*wHeadShotDamage*/ 17.37,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_FAMAE_SAF,
	/*wEngineWeaponId*/ WEAPON_MP5,
	/*wMagazine*/ ITEM_ID_MP5_MAGAZINE
	},
/*81*/ {
	/*wId*/ WEAPON_INGRAM_MAC10,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 10.0,
	/*wHeadShotDamage*/ 12.2,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_INGRAM_MAC10,
	/*wEngineWeaponId*/ WEAPON_TEC9,
	/*wMagazine*/ ITEM_ID_UZI_MAGAZINE
	},
/*82*/ {
	/*wId*/ WEAPON_SKORPION_VZ68,
	/*wProccessWhenGiven*/ true,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 4,
	/*wType*/ WEAPON_TYPE_FIREGUN,
	/*wWoundType*/ WOUND_TYPE_9MM,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 11.20,
	/*wHeadShotDamage*/ 13.10,
	/*wHasArmedElbowHit*/ true,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ true,
	/*wItemIdLinked*/ ITEM_ID_SKORPION_VZ68,
	/*wEngineWeaponId*/ WEAPON_TEC9,
	/*wMagazine*/ ITEM_ID_UZI_MAGAZINE
	},
/*83*/ {
	/*wId*/ WEAPON_FLASHBANG,
	/*wProccessWhenGiven*/ false,
	/*wProccessWhenTaken*/ false,
	/*wSlot*/ 8,
	/*wType*/ WEAPON_TYPE_OTHER,
	/*wWoundType*/ WOUND_TYPE_NONE,
	/*wUsesDamageMultiplier*/ false,
	/*wDamage*/ 0.0,
	/*wHeadShotDamage*/ 0.0,
	/*wHasArmedElbowHit*/ false,
	/*wHasSpecialEffect*/ false,
	/*wArmourAffected*/ false,
	/*wItemIdLinked*/ ITEM_ID_FLASHBANG,
	/*wEngineWeaponId*/ WEAPON_TEARGAS,
	/*wMagazine*/ ITEM_ID_NULL
	}
};

stock Weapon_IsValidEngineId(weaponid) {
	return (0 <= weaponid <= WEAPON_COLLISION);
}

stock Weapon_IsValidId(weaponid) {
	return (0 <= weaponid < sizeof(WeaponData));
}

Weapon_GetSlot(weaponid) {
	return WeaponData[weaponid][wSlot];
}

Weapon_GetEngineWeaponId(weaponid) {
	return WeaponData[weaponid][wEngineWeaponId];
}

Weapon_GetMagazineId(weaponid) {
	return WeaponData[weaponid][wMagazine];
}

hasFireGun(playerid) {
	return (ItemModel_GetType(GetHandItem(playerid, HAND_RIGHT)) == ITEM_WEAPON && WeaponData[ItemModel_GetExtraId(GetHandItem(playerid, HAND_RIGHT))][wType] == WEAPON_TYPE_FIREGUN);
}

Weapon_IsPlayerAmmoShotSynced(playerid, weaponid) {
	return (WeaponData[weaponid][wType] == WEAPON_TYPE_FIREGUN && GetPlayerState(playerid) != PLAYER_STATE_DRIVER);
}

hook function GivePlayerWeapon(playerid, weaponid, ammo)
{
	WeaponSync_NewWeaponSent(playerid, weaponid, ammo);
	return continue(playerid, weaponid, ammo);
}

Weapon_GiveToPlayer(playerid, weaponid, ammo)
{
	if(weaponid > 0 && ammo > 0)
	{
		if(!Weapon_IsPlayerAmmoShotSynced(playerid, weaponid)) {
			SendFMessage(playerid, COLOR_WHITE, "[OOC] El servidor te envió el arma [%s - %s: %i] a tu mano derecha.", ItemModel_GetName(WeaponData[weaponid][wItemIdLinked]), ItemModel_GetParamName(WeaponData[weaponid][wItemIdLinked]), ammo);
		}

		// Transform marp weaponid to samp engine weaponid
		if(weaponid > WEAPON_COLLISION) {
			weaponid = WeaponData[weaponid][wEngineWeaponId];
		}

		SetPlayerAntiCheatImmunity(playerid, 2000);
		GivePlayerWeapon(playerid, weaponid, ammo); // Samp engine call
	}
}

Weapon_RemoveFromPlayer(playerid)
{
	SetPlayerAntiCheatImmunity(playerid, 2000);
	WeaponSync_ResetData(playerid);
	ResetPlayerWeapons(playerid); // Samp engine call
}

Weapon_ApplySpecialEffect(weaponid, playerid, damagedid)
{
	if(weaponid == WEAPON_TASER)
	{
		if(PlayerInfo[damagedid][pDisabled] != DISABLE_NONE)
			return 0;
		if(IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(damagedid))
		{
			SendClientMessage(playerid, COLOR_YELLOW2, "Ambos deben estar a pie para que el taser tenga efecto.");
			return 0;
		}
		if(!IsPlayerInRangeOfPlayer(EFFECT_TASER_RANGE, playerid, damagedid))
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto estaba demasiado lejos para el alcance del taser.");
			return 0;
		}

		SendFMessage(damagedid, COLOR_LIGHTYELLOW, " ¡Has sido taseado por %s! El efecto dura %i segundos.", GetPlayerCleanName(playerid), EFFECT_TASER_TIME / 1000);
		SendFMessage(playerid, COLOR_LIGHTYELLOW, " ¡Has taseado a %s por %i segundos!", GetPlayerCleanName(damagedid), EFFECT_TASER_TIME / 1000);
		TogglePlayerControllable(damagedid, false);
		PlayerInfo[damagedid][pDisabled] = DISABLE_LESS_LETHAL;
		ClearAnimations(damagedid, 1);
		ApplyAnimationEx(damagedid, "PED", "KO_skid_back", 4.1, 0, 1, 1, 1, 1, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		SetTimerEx("Weapon_FinishShockingEffect", EFFECT_TASER_TIME, false, "i", damagedid);
		PlayerPlayerActionMessage(playerid, damagedid, 15.0, "dispara su pistola taser cargada y le acierta a");
		return 1;
	}
	else if(weaponid == WEAPON_NON_LETAL_SHOTGUN)
	{
		if(PlayerInfo[damagedid][pDisabled] != DISABLE_NONE)
			return 0;
		if(IsPlayerInAnyVehicle(damagedid))
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes incapacitar a alguien que esta en un vehículo.");
			return 0;
		}
		if(!IsPlayerInRangeOfPlayer(EFFECT_NON_LETAL_SHOTGUN_RANGE, playerid, damagedid))
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto estaba demasiado lejos para el alcance de la escopeta.");
			return 0;
		}

		SendFMessage(damagedid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Has sido alcanzado por una bala de goma de %s! El efecto dura %i segundos.", GetPlayerCleanName(playerid), EFFECT_NON_LETAL_SHOTGUN_TIME / 1000);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Le has dado a %s con la escopeta no letal. El efecto dura %i segundos!", GetPlayerCleanName(damagedid), EFFECT_NON_LETAL_SHOTGUN_TIME / 1000);
		TogglePlayerControllable(damagedid, false);
		PlayerInfo[damagedid][pDisabled] = DISABLE_LESS_LETHAL;
		ClearAnimations(damagedid, 1);
		ApplyAnimationEx(damagedid, "SWEET", "SWEET_INJUREDLOOP", 4.0, 0, 0, 1, 1, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		SetTimerEx("Weapon_FinishShockingEffect", EFFECT_NON_LETAL_SHOTGUN_TIME, false, "i", damagedid);
		PlayerPlayerActionMessage(playerid, damagedid, 15.0, "dispara con su escopeta no letal y le acierta a");
		return 1;
	}
	return 1;
}

forward Weapon_FinishShockingEffect(playerid);
public Weapon_FinishShockingEffect(playerid)
{
	if(IsPlayerLogged(playerid) && PlayerInfo[playerid][pDisabled] == DISABLE_LESS_LETHAL)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya no estas incapacitado.");
		TogglePlayerControllable(playerid, true);
		ClearAnimations(playerid, 1);
		ApplyAnimationEx(playerid, "PED", "getup_front", 4.1, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(KEY_PRESSED_SINGLE(KEY_CROUCH) && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER && GetPlayerCameraMode(playerid) == 55)
	{
		SetPlayerArmedWeapon(playerid, 0);
		ApplyAnimation(playerid, "PED", "CAR_GETIN_RHS", 4.1, 0, 0, 0, 0, 1, 1);
	}
	return 1;
}
