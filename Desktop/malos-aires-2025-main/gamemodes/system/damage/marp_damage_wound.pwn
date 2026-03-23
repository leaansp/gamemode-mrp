#if defined _marp_damage_wound_included
	#endinput
#endif
#define _marp_damage_wound_included

#include <YSI_Coding\y_hooks>

#define BODY_PART_TORSO			(3)
#define BODY_PART_GROIN			(4)
#define BODY_PART_LEFT_ARM		(5)
#define BODY_PART_RIGHT_ARM		(6)
#define BODY_PART_LEFT_LEG		(7)
#define BODY_PART_RIGHT_LEG		(8)
#define BODY_PART_HEAD			(9)

forward Float:GetPlayerHealthEx(playerid);

enum {
	WOUND_TYPE_NONE,
	WOUND_TYPE_HIT,
	WOUND_TYPE_BLADE,
	WOUND_TYPE_9MM,
	WOUND_TYPE_50,
	WOUND_TYPE_SHOTGUN,
	WOUND_TYPE_556MM,
	WOUND_TYPE_762MM,
	WOUND_TYPE_FIRE,
	WOUND_TYPE_EXPLOSION,
	WOUND_TYPE_TRAUMA,
	WOUND_TYPES_AMOUNT
}

static enum {
	WOUND_BODY_PART_TORSO,
	WOUND_BODY_PART_GROIN,
	WOUND_BODY_PART_LEFT_ARM,
	WOUND_BODY_PART_RIGHT_ARM,
	WOUND_BODY_PART_LEFT_LEG,
	WOUND_BODY_PART_RIGHT_LEG,
	WOUND_BODY_PART_HEAD,
	WOUND_BODY_PART_GENERAL,
	WOUND_BODY_PARTS_AMOUNT
};

static const WoundBodyPartName[WOUND_BODY_PARTS_AMOUNT][32] = {
	"Torso",
	"Ingle",
	"Brazo izquierdo",
	"Brazo derecho",
	"Pierna izquierda",
	"Pierna derecha",
	"Cabeza",
	"Todo el cuerpo"
};

static enum e_WOUND_TYPE_DATA {
	dType,
	bool:dAffectsLeg,
	bool:dUsesSpecificBodyPart,
	Float:dMinNeededToShowWound,
	bool:dSaveWound
}

static const WoundTypeData[WOUND_TYPES_AMOUNT][e_WOUND_TYPE_DATA] = {
/*0*/ {
	/*dType*/ WOUND_TYPE_NONE,
	/*dAffectsLeg*/ false,
	/*dUsesSpecificBodyPart*/ false,
	/*dMinNeededToShowWound*/ 0.0,
	/*dSaveWound*/ false
	},
/*1*/ {
	/*dType*/ WOUND_TYPE_HIT,
	/*dAffectsLeg*/ false,
	/*dUsesSpecificBodyPart*/ false,
	/*dMinNeededToShowWound*/ 10.0,
	/*dSaveWound*/ false
	},
/*2*/ {
	/*dType*/ WOUND_TYPE_BLADE,
	/*dAffectsLeg*/ false,
	/*dUsesSpecificBodyPart*/ false,
	/*dMinNeededToShowWound*/ 10.0,
	/*dSaveWound*/ false
	},
/*3*/ {
	/*dType*/ WOUND_TYPE_9MM,
	/*dAffectsLeg*/ true,
	/*dUsesSpecificBodyPart*/ true,
	/*dMinNeededToShowWound*/ 0.0,
	/*dSaveWound*/ true
	},
/*4*/ {
	/*dType*/ WOUND_TYPE_50,
	/*dAffectsLeg*/ true,
	/*dUsesSpecificBodyPart*/ true,
	/*dMinNeededToShowWound*/ 0.0,
	/*dSaveWound*/ true
	},
/*5*/ {
	/*dType*/ WOUND_TYPE_SHOTGUN,
	/*dAffectsLeg*/ true,
	/*dUsesSpecificBodyPart*/ true,
	/*dMinNeededToShowWound*/ 0.0,
	/*dSaveWound*/ true
	},
/*6*/ {
	/*dType*/ WOUND_TYPE_556MM,
	/*dAffectsLeg*/ true,
	/*dUsesSpecificBodyPart*/ true,
	/*dMinNeededToShowWound*/ 0.0,
	/*dSaveWound*/ true
	},
/*7*/ {
	/*dType*/ WOUND_TYPE_762MM,
	/*dAffectsLeg*/ true,
	/*dUsesSpecificBodyPart*/ true,
	/*dMinNeededToShowWound*/ 0.0,
	/*dSaveWound*/ true
	},
/*8*/ {
	/*dType*/ WOUND_TYPE_FIRE,
	/*dAffectsLeg*/ false,
	/*dUsesSpecificBodyPart*/ false,
	/*dMinNeededToShowWound*/ 10.0,
	/*dSaveWound*/ false
	},
/*9*/ {
	/*dType*/ WOUND_TYPE_EXPLOSION,
	/*dAffectsLeg*/ false,
	/*dUsesSpecificBodyPart*/ false,
	/*dMinNeededToShowWound*/ 10.0,
	/*dSaveWound*/ false
	},
/*10*/ {
	/*dType*/ WOUND_TYPE_TRAUMA,
	/*dAffectsLeg*/ false,
	/*dUsesSpecificBodyPart*/ false,
	/*dMinNeededToShowWound*/ 10.0,
	/*dSaveWound*/ false
	}
};

#define WOUND_MAX_DESC_RANGES 4

#define WOUND_DESC_RANGE_LOW (20.0)
#define WOUND_DESC_RANGE_MID (45.0)
#define WOUND_DESC_RANGE_HIGH (65.0)

static enum {
	WOUND_DESC_LOW_INDEX,
	WOUND_DESC_MID_INDEX,
	WOUND_DESC_HIGH_INDEX,
	WOUND_DESC_CRITICAL_INDEX,
}

static const WoundTypeDescription[WOUND_TYPES_AMOUNT][WOUND_MAX_DESC_RANGES][64] = {
/*0*/ {
	"",
	"",
	"",
	""
	},
/*1*/ {
	"Algunos moretones leves",
	"{FFDA7B}Golpes y moretones",
	"{FF9917}Golpes y moretones con sangrado",
	"{FF4B28}Golpes, moretones, y laceraciones graves con sangrado"
	},
/*2*/ {
	"Heridas punzantes superficiales",
	"{FFDA7B}Heridas punzantes profundas",
	"{FF9917}Heridas punzantes profundas y puñaladas",
	"{FF4B28}Heridas punzantes profundas con sangrado abundante"
	},
/*3*/ {
	"Herida de bala 9 x 19 mm",
	"{FFDA7B}Heridas de multiples balas 9 x 19 mm",
	"{FF9917}Heridas de multiples balas 9 x 19 mm",
	"{FF4B28}Heridas de multiples balas 9 x 19 mm"
	},
/*4*/ {
	"Herida de bala .44 magnum",
	"{FFDA7B}Herida de bala .44 magnum",
	"{FF9917}Heridas de multiples balas .44 magnum",
	"{FF4B28}Heridas de multiples balas .44 magnum"
	},
/*5*/ {
	"Perdigones de escopeta",
	"{FFDA7B}Perdigones de escopeta",
	"{FF9917}Perdigones de escopeta",
	"{FF4B28}Perdigones de escopeta"
	},
/*6*/ {
	"Herida de bala 5.56 x 45 mm",
	"{FFDA7B}Herida de bala 5.56 x 45 mm",
	"{FF9917}Heridas de multiples balas 5.56 x 45 mm",
	"{FF4B28}Heridas de multiples balas 5.56 x 45 mm"
	},
/*7*/ {
	"Herida de bala 7.62 x 39 mm",
	"{FFDA7B}Herida de bala 7.62 x 39 mm",
	"{FF9917}Herida de bala 7.62 x 39 mm",
	"{FF4B28}Heridas de multiples balas 7.62 x 39 mm"
	},
/*8*/ {
	"Quemaduras leves",
	"{FFDA7B}Quemaduras de primer grado",
	"{FF9917}Quemaduras de segundo grado",
	"{FF4B28}Quemaduras de tercer grado"
	},
/*9*/ {
	"Raspones y quemaduras leves",
	"{FFDA7B}Raspones, cortes superficiales, y quemaduras",
	"{FF9917}Moretones, cortes, y quemaduras",
	"{FF4B28}Carne expuesta, cortes profundos, y quemaduras graves"
	},
/*10*/ {
	"Traumatismos leves",
	"{FFDA7B}Traumatismos varios y esguince leve",
	"{FF9917}Traumatismos medios y fracturas internas",
	"{FF4B28}Traumatismos graves y fracturas expuestas"
	}
};

static Wound_active[MAX_PLAYERS];
static Wound_save[MAX_PLAYERS];
static STREAMER_TAG_3D_TEXT_LABEL:Wound_label[MAX_PLAYERS];
static Float:PlayerWoundData[MAX_PLAYERS][WOUND_BODY_PARTS_AMOUNT][WOUND_TYPES_AMOUNT];
static Float:PlayerWoundDataReset[WOUND_TYPES_AMOUNT];
static Wound_legShot[MAX_PLAYERS];
static Wound_legShotKeyCheckTimer[MAX_PLAYERS];

hook LoadAccountDataEnded(playerid)
{
	Wound_LoadWounds(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	Wound_SaveWounds(playerid);
	Wound_Reset(playerid);
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	Wound_Reset(playerid);
	return 1;
}

Wound_LoadWounds(playerid)
{
	if(isnull(PlayerInfo[playerid][pWounds]))
		return 0;

	sscanf(PlayerInfo[playerid][pWounds], "iifffff",
			Wound_active[playerid],
			Wound_legShot[playerid],
			Float:(PlayerWoundData[playerid][WOUND_BODY_PART_GENERAL][WOUND_TYPE_9MM]),
			Float:(PlayerWoundData[playerid][WOUND_BODY_PART_GENERAL][WOUND_TYPE_50]),
			Float:(PlayerWoundData[playerid][WOUND_BODY_PART_GENERAL][WOUND_TYPE_SHOTGUN]),
			Float:(PlayerWoundData[playerid][WOUND_BODY_PART_GENERAL][WOUND_TYPE_556MM]),
			Float:(PlayerWoundData[playerid][WOUND_BODY_PART_GENERAL][WOUND_TYPE_762MM])
	);

	if(Wound_active[playerid]) {
		Wound_UpdateLabel(playerid, "Herido");
	}

	return 1;
}

Wound_SaveWounds(playerid)
{
	if(Wound_active[playerid] && Wound_save[playerid])
	{
		new Float:total9MM, Float:total50, Float:totalShotgun, Float:total556M, Float:total762MM;

		for(new bp; bp < WOUND_BODY_PART_GENERAL; bp++)
		{
			total9MM += Float:(PlayerWoundData[playerid][bp][WOUND_TYPE_9MM]);
			total50 += Float:(PlayerWoundData[playerid][bp][WOUND_TYPE_50]);
			totalShotgun += Float:(PlayerWoundData[playerid][bp][WOUND_TYPE_SHOTGUN]);
			total556M += Float:(PlayerWoundData[playerid][bp][WOUND_TYPE_556MM]);
			total762MM += Float:(PlayerWoundData[playerid][bp][WOUND_TYPE_762MM]);
		}

		format(PlayerInfo[playerid][pWounds], 32, "%i %i %.1f %.1f %.1f %.1f %.1f", Wound_active[playerid], Wound_legShot[playerid], total9MM, total50, totalShotgun, total556M, total762MM);
	} else {
		PlayerInfo[playerid][pWounds][0] = EOS;
	}
}

Wound_Reset(playerid)
{
	Wound_active[playerid] = 0;
	Wound_save[playerid] = 0;

	if(Wound_label[playerid])
	{
		DestroyDynamic3DTextLabel(Wound_label[playerid]);
		Wound_label[playerid] = STREAMER_TAG_3D_TEXT_LABEL:0;
	}

	for(new i = 0; i < WOUND_BODY_PARTS_AMOUNT; i++) {
		PlayerWoundData[playerid][i] = PlayerWoundDataReset;
	}

	Wound_legShot[playerid] = 0;

	if(Wound_legShotKeyCheckTimer[playerid])
	{
		KillTimer(Wound_legShotKeyCheckTimer[playerid]);
		Wound_legShotKeyCheckTimer[playerid] = 0;
	}
}

hook function SetPlayerHealthEx(playerid, Float:health)
{
	if(health >= 100.0) {
		Wound_Reset(playerid);

		// If the player was in a crack/dying state, clear it and restore control
		if(PlayerInfo[playerid][pCrack] || PlayerInfo[playerid][pDisabled] == DISABLE_DYING || PlayerInfo[playerid][pDisabled] == DISABLE_DEATHBED)
		{
			PlayerInfo[playerid][pCrack] = 0;
			PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
			TogglePlayerControllable(playerid, true);
			ClearAnimations(playerid, 1);
		}
	}
	return continue(playerid, health);
}

Wound_OnPlayerReceived(playerid, Float:amount, bodypart, woundtype)
{
	if(woundtype == WOUND_TYPE_NONE)
		return 0;

	bodypart = (WoundTypeData[woundtype][dUsesSpecificBodyPart]) ? (bodypart - 3) : (WOUND_BODY_PART_GENERAL);
	PlayerWoundData[playerid][bodypart][woundtype] += amount;

	if(WoundTypeData[woundtype][dAffectsLeg] && (bodypart == WOUND_BODY_PART_RIGHT_LEG || bodypart == WOUND_BODY_PART_LEFT_LEG)) {
		Wound_legShot[playerid] = 1;
	}

	if(WoundTypeData[woundtype][dSaveWound]) {
		Wound_save[playerid] = 1;
	}

	if(!Wound_active[playerid] && PlayerWoundData[playerid][bodypart][woundtype] >= WoundTypeData[woundtype][dMinNeededToShowWound])
	{
		Wound_active[playerid] = 1;
		Wound_UpdateLabel(playerid, "Herido");
	}
	return 1;
}

Wound_UpdateLabel(playerid, const text[])
{
	if(Wound_label[playerid]) {
		UpdateDynamic3DTextLabelText(Wound_label[playerid], COLOR_WOUNDED_LABEL, text);
	} else {
		Wound_label[playerid] = CreateDynamic3DTextLabel(text, COLOR_WOUNDED_LABEL, 0.0, 0.0, -0.025, .drawdistance = 15.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 15.0);
	}
}

Wound_ShowForPlayer(fromplayerid, toplayerid)
{
	if(!Wound_active[fromplayerid])
		return 0;

	new title[48] = "Heridas de ";
	strcat(title, GetPlayerCleanName(fromplayerid), sizeof(title));
	new infostring[768] = "Localización\tDescripción (daño)\n";
	new woundstring[128];
	new Float:damage;

	for(new bp = 0, count = 0; bp < WOUND_BODY_PARTS_AMOUNT; bp++, count = 0)
	{
		for(new dt = 1; dt < WOUND_TYPES_AMOUNT; dt++)
		{
			if((damage = PlayerWoundData[fromplayerid][bp][dt]) > 0.0)
			{
				if(!count) {
					strcat(infostring, WoundBodyPartName[bp], sizeof(infostring));
				}

				format(woundstring, sizeof(woundstring), " \t%s (%.2f)\n",
					(damage < WOUND_DESC_RANGE_LOW) ? (WoundTypeDescription[dt][WOUND_DESC_LOW_INDEX]) : (
					(damage < WOUND_DESC_RANGE_MID) ? (WoundTypeDescription[dt][WOUND_DESC_MID_INDEX]) : (
					(damage < WOUND_DESC_RANGE_HIGH) ? (WoundTypeDescription[dt][WOUND_DESC_HIGH_INDEX]) : (WoundTypeDescription[dt][WOUND_DESC_CRITICAL_INDEX]))),
					damage
				);

				strcat(infostring, woundstring, sizeof(infostring));
				count++;
			}
		}
	}

	Dialog_Open(toplayerid, "DLG_NO_RESPONSE", DIALOG_STYLE_TABLIST_HEADERS, title, infostring, "Cerrar", "");
	return 1;
}

CMD:verheridas(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/verheridas [ID/Jugador]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se ha encontrado al jugador.");
	if(!IsPlayerInRangeOfPlayer(4.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La persona se encuentra demasiado lejos.");

	if(!Wound_ShowForPlayer(targetid, playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La persona no presenta heridas.");

	return 1;
}

CMD:levantar(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/levantar [ID/Nombre]");
	if(!IsPlayerLogged(targetid) || targetid == playerid)
		return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador!");
	if(!IsPlayerInRangeOfPlayer(0.8, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La persona está demasiado lejos.");
	if(GetPlayerHealthEx(targetid) > 25.0 || !PlayerWoundData[targetid][WOUND_BODY_PART_GENERAL][WOUND_TYPE_TRAUMA])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La persona presenta heridas más graves o no presenta heridas.");
	if(GetPlayerHealthEx(playerid) < 25.0)
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡Tu personaje no está en condiciones para levantar a otra persona!");

	TogglePlayerControllable(playerid, false); // Se congela al personaje que está levantando al otro con la finalidad de evitar abusos...

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estás ayudando a levantar a %s...", GetPlayerCleanName(targetid));
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s está ayudando a levantarte.", GetPlayerCleanName(playerid));
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 1, 0, 0, 0, 0, 1);
	SetTimerEx("Wound_PlayerStandUp", 20000, false, "ii", playerid, targetid);
	return 1;
}

forward Wound_PlayerStandUp(playerid, targetid);
public Wound_PlayerStandUp(playerid, targetid)
{
	TogglePlayerControllable(targetid, true);
	TogglePlayerControllable(playerid, true);
	EndAnim(playerid);

	SetPlayerHealthEx(targetid, 100.0);
	SetPlayerHealthEx(targetid, 25.0);
	SendClientMessage(targetid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu personaje despertó del noqueo.");
}

forward Wound_LegShotKeyCheck(playerid);
public Wound_LegShotKeyCheck(playerid)
{
	new keys, ud, lr;

	GetPlayerKeys(playerid, keys, ud, lr);

	if(keys & KEY_SPRINT)
	{
		ClearAnimations(playerid);
		ApplyAnimationEx(playerid, "PED", "FALL_collapse", 4.0, 0, 1, 1, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		Wound_legShotKeyCheckTimer[playerid] = SetTimerEx("Wound_LegShotKeyCheck", 1000, false, "i", playerid);
	} else {
		Wound_legShotKeyCheckTimer[playerid] = 0;
	}
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(Wound_legShot[playerid] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !PlayerInfo[playerid][pCrack] && (KEY_PRESSED_SINGLE(KEY_SPRINT) || KEY_PRESSED_SINGLE(KEY_JUMP)))
    {
		if(!Wound_legShotKeyCheckTimer[playerid])
		{
			ClearAnimations(playerid);
			ApplyAnimationEx(playerid, "PED", "FALL_collapse", 4.0, 0, 1, 1, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
			Wound_legShotKeyCheckTimer[playerid] = SetTimerEx("Wound_LegShotKeyCheck", 1000, false, "i", playerid);
		}
    }
    return 1;
}
