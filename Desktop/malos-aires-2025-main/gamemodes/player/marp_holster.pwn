#if defined _marp_holster_included
	#endinput
#endif
#define _marp_holster_included

/*
	Sistema de funda de cadera (/cadera).
	Permite guardar armas cortas (pistolas, ametralladoras compactas) en la cadera
	con representacion visual via objeto adjunto al hueso del muslo derecho.

	SQL requerido (ejecutar en la DB antes de usar):
	CREATE TABLE IF NOT EXISTS `holster` (
		`playerid` INT UNSIGNED NOT NULL,
		`itemid`   INT UNSIGNED NOT NULL DEFAULT 0,
		`param`    INT UNSIGNED NOT NULL DEFAULT 0,
		`pos_x`    FLOAT NOT NULL DEFAULT 0.08,
		`pos_y`    FLOAT NOT NULL DEFAULT 0.07,
		`pos_z`    FLOAT NOT NULL DEFAULT -0.10,
		`rot_x`    FLOAT NOT NULL DEFAULT 0.0,
		`rot_y`    FLOAT NOT NULL DEFAULT 0.0,
		`rot_z`    FLOAT NOT NULL DEFAULT 0.0,
		`sc_x`     FLOAT NOT NULL DEFAULT 0.8,
		`sc_y`     FLOAT NOT NULL DEFAULT 0.8,
		`sc_z`     FLOAT NOT NULL DEFAULT 0.8,
		PRIMARY KEY (`playerid`)
	);
*/

#include <YSI_Coding\y_hooks>

#define HOLSTER_BONE        ATTACH_BONE_ID_RIGHT_THIGH

#define HOLSTER_DEFAULT_X   (0.08)
#define HOLSTER_DEFAULT_Y   (0.07)
#define HOLSTER_DEFAULT_Z   (-0.10)
#define HOLSTER_DEFAULT_RX  (0.0)
#define HOLSTER_DEFAULT_RY  (0.0)
#define HOLSTER_DEFAULT_RZ  (0.0)
#define HOLSTER_DEFAULT_SX  (0.8)
#define HOLSTER_DEFAULT_SY  (0.8)
#define HOLSTER_DEFAULT_SZ  (0.8)

#define HOLSTER_SPINE_X     (0.0)
#define HOLSTER_SPINE_Y     (-0.10)
#define HOLSTER_SPINE_Z     (0.05)
#define HOLSTER_SPINE_RX    (0.0)
#define HOLSTER_SPINE_RY    (0.0)
#define HOLSTER_SPINE_RZ    (90.0)
#define HOLSTER_DLG_CONFIG  9700

static HolsterItem[MAX_PLAYERS];           // itemid en la funda (0 = vacia)
static HolsterParam[MAX_PLAYERS];          // municion/param del arma en funda
static Float:HolsterPos[MAX_PLAYERS][6];   // x, y, z, rx, ry, rz
static Float:HolsterScale[MAX_PLAYERS][3]; // sx, sy, sz
static bool:HolsterEditing[MAX_PLAYERS];   // jugador en modo edicion
static HolsterMode[MAX_PLAYERS];           // 0 = muslo derecho, 1 = columna (pecho)

// ?????????????????????????????????????????????????????????????????
// CICLO DE VIDA
// ?????????????????????????????????????????????????????????????????

hook OnPlayerDisconnect(playerid, reason)
{
	HolsterItem[playerid]    = 0;
	HolsterParam[playerid]   = 0;
	HolsterEditing[playerid] = false;
	HolsterMode[playerid]    = 0;
	return 1;
}

hook OnPlayerCharSwitch(playerid)
{
	if(HolsterItem[playerid] != 0)
		Holster_SaveItemToDB(playerid);
	Holster_Detach(playerid);
	HolsterItem[playerid]    = 0;
	HolsterParam[playerid]   = 0;
	HolsterEditing[playerid] = false;
	HolsterMode[playerid]    = 0;
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(HolsterItem[playerid] != 0)
		SetTimerEx("Holster_AttachDelayed", 100, false, "i", playerid);
	return 1;
}

hook LoadAccountDataEnded(playerid)
{
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query),
		"SELECT `itemid`,`param`,`pos_x`,`pos_y`,`pos_z`,`rot_x`,`rot_y`,`rot_z`,`sc_x`,`sc_y`,`sc_z`,`mode` \
		FROM `holster` WHERE `playerid`=%i LIMIT 1",
		PlayerInfo[playerid][pID]);
	mysql_tquery(MYSQL_HANDLE, query, "Holster_OnLoad", "i", playerid);
	return 1;
}

forward Holster_OnLoad(playerid);
public Holster_OnLoad(playerid)
{
	Holster_SetDefaultPos(playerid);

	if(cache_num_rows() == 0)
		return 1;

	cache_get_value_index_int(0, 0, HolsterItem[playerid]);
	cache_get_value_index_int(0, 1, HolsterParam[playerid]);
	cache_get_value_index_float(0, 2, HolsterPos[playerid][0]);
	cache_get_value_index_float(0, 3, HolsterPos[playerid][1]);
	cache_get_value_index_float(0, 4, HolsterPos[playerid][2]);
	cache_get_value_index_float(0, 5, HolsterPos[playerid][3]);
	cache_get_value_index_float(0, 6, HolsterPos[playerid][4]);
	cache_get_value_index_float(0, 7, HolsterPos[playerid][5]);
	cache_get_value_index_float(0, 8, HolsterScale[playerid][0]);
	cache_get_value_index_float(0, 9, HolsterScale[playerid][1]);
	cache_get_value_index_float(0, 10, HolsterScale[playerid][2]);
	cache_get_value_index_int(0, 11, HolsterMode[playerid]);
	return 1;
}

forward Holster_AttachDelayed(playerid);
public Holster_AttachDelayed(playerid)
{
	Holster_Attach(playerid);
}

// Llamado desde marp_toy.pwn cuando index == ATTACH_INDEX_ID_HOLSTER
forward Holster_OnEditAttached(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
public Holster_OnEditAttached(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(!HolsterEditing[playerid])
		return 1;

	HolsterEditing[playerid] = false;

	if(!response)
	{
		// El jugador cancelo: re-aplicar posicion anterior sin cambios
		Holster_Detach(playerid);
		Holster_Attach(playerid);
		return 1;
	}

	HolsterPos[playerid][0] = fOffsetX;
	HolsterPos[playerid][1] = fOffsetY;
	HolsterPos[playerid][2] = fOffsetZ;
	HolsterPos[playerid][3] = fRotX;
	HolsterPos[playerid][4] = fRotY;
	HolsterPos[playerid][5] = fRotZ;
	HolsterScale[playerid][0] = fScaleX;
	HolsterScale[playerid][1] = fScaleY;
	HolsterScale[playerid][2] = fScaleZ;

	RemovePlayerAttachedObject(playerid, ATTACH_INDEX_ID_HOLSTER);
	SetPlayerAttachedObject(playerid, ATTACH_INDEX_ID_HOLSTER,
		modelid, boneid,
		fOffsetX, fOffsetY, fOffsetZ,
		fRotX, fRotY, fRotZ,
		fScaleX, fScaleY, fScaleZ);

	Holster_SavePosToDB(playerid);
	SendClientMessage(playerid, COLOR_INFO, "[CADERA] "COLOR_EMB_GREY"Posicion de la funda guardada.");
	return 1;
}

// ?????????????????????????????????????????????????????????????????
// HELPERS INTERNOS
// ?????????????????????????????????????????????????????????????????

static Holster_SetDefaultPos(playerid)
{
	HolsterPos[playerid][0]  = HOLSTER_DEFAULT_X;
	HolsterPos[playerid][1]  = HOLSTER_DEFAULT_Y;
	HolsterPos[playerid][2]  = HOLSTER_DEFAULT_Z;
	HolsterPos[playerid][3]  = HOLSTER_DEFAULT_RX;
	HolsterPos[playerid][4]  = HOLSTER_DEFAULT_RY;
	HolsterPos[playerid][5]  = HOLSTER_DEFAULT_RZ;
	HolsterScale[playerid][0] = HOLSTER_DEFAULT_SX;
	HolsterScale[playerid][1] = HOLSTER_DEFAULT_SY;
	HolsterScale[playerid][2] = HOLSTER_DEFAULT_SZ;
}

static Holster_Attach(playerid)
{
	new itemid = HolsterItem[playerid];
	if(!ItemModel_IsValidId(itemid) || !ItemModel_GetObjectModel(itemid))
		return;
	new holsterBone = (HolsterMode[playerid] == 1) ? ATTACH_BONE_ID_SPINE : HOLSTER_BONE;
	SetPlayerAttachedObject(playerid, ATTACH_INDEX_ID_HOLSTER,
		ItemModel_GetObjectModel(itemid), holsterBone,
		HolsterPos[playerid][0], HolsterPos[playerid][1], HolsterPos[playerid][2],
		HolsterPos[playerid][3], HolsterPos[playerid][4], HolsterPos[playerid][5],
		HolsterScale[playerid][0], HolsterScale[playerid][1], HolsterScale[playerid][2]);
}

static Holster_Detach(playerid)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_INDEX_ID_HOLSTER))
		RemovePlayerAttachedObject(playerid, ATTACH_INDEX_ID_HOLSTER);
}

static Holster_SaveItemToDB(playerid)
{
	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query),
		"INSERT INTO `holster` \
		(`playerid`,`itemid`,`param`,`pos_x`,`pos_y`,`pos_z`,`rot_x`,`rot_y`,`rot_z`,`sc_x`,`sc_y`,`sc_z`) \
		VALUES (%i,%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f) \
		ON DUPLICATE KEY UPDATE `itemid`=%i,`param`=%i",
		PlayerInfo[playerid][pID],
		HolsterItem[playerid], HolsterParam[playerid],
		HolsterPos[playerid][0], HolsterPos[playerid][1], HolsterPos[playerid][2],
		HolsterPos[playerid][3], HolsterPos[playerid][4], HolsterPos[playerid][5],
		HolsterScale[playerid][0], HolsterScale[playerid][1], HolsterScale[playerid][2],
		HolsterItem[playerid], HolsterParam[playerid]);
	mysql_tquery(MYSQL_HANDLE, query);
}

static Holster_SavePosToDB(playerid)
{
	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query),
		"INSERT INTO `holster` \
		(`playerid`,`itemid`,`param`,`pos_x`,`pos_y`,`pos_z`,`rot_x`,`rot_y`,`rot_z`,`sc_x`,`sc_y`,`sc_z`) \
		VALUES (%i,%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f) \
		ON DUPLICATE KEY UPDATE \
		`pos_x`=%f,`pos_y`=%f,`pos_z`=%f,`rot_x`=%f,`rot_y`=%f,`rot_z`=%f,`sc_x`=%f,`sc_y`=%f,`sc_z`=%f",
		PlayerInfo[playerid][pID],
		HolsterItem[playerid], HolsterParam[playerid],
		HolsterPos[playerid][0], HolsterPos[playerid][1], HolsterPos[playerid][2],
		HolsterPos[playerid][3], HolsterPos[playerid][4], HolsterPos[playerid][5],
		HolsterScale[playerid][0], HolsterScale[playerid][1], HolsterScale[playerid][2],
		HolsterPos[playerid][0], HolsterPos[playerid][1], HolsterPos[playerid][2],
		HolsterPos[playerid][3], HolsterPos[playerid][4], HolsterPos[playerid][5],
		HolsterScale[playerid][0], HolsterScale[playerid][1], HolsterScale[playerid][2]);
	mysql_tquery(MYSQL_HANDLE, query);
}

// ?????????????????????????????????????????????????????????????????
// API PUBLICA
// ?????????????????????????????????????????????????????????????????

stock bool:Holster_IsEligible(itemid)
{
	return ItemModel_IsValidId(itemid)
		&& ItemModel_GetType(itemid) == ITEM_WEAPON
		&& ItemModel_HasTag(itemid, ITEM_TAG_HOLSTER);
}

stock bool:Holster_IsEmpty(playerid)
{
	return HolsterItem[playerid] == 0;
}

// Usar cuando la policia confisca armas, etc.
stock Holster_ClearWeapon(playerid)
{
	if(HolsterItem[playerid] == 0) return;
	HolsterItem[playerid]  = 0;
	HolsterParam[playerid] = 0;
	Holster_Detach(playerid);
	Holster_SaveItemToDB(playerid);
}

stock Holster_PrintForPlayer(playerid, targetid)
{
	SendClientMessage(targetid, COLOR_WHITE, "_____________________[ CADERA ]_____________________");
	if(HolsterItem[playerid] > 0) {
		new param_display[32];
		Backpack_FormatParamDisplay(HolsterItem[playerid], HolsterParam[playerid], param_display, sizeof(param_display));
		SendFMessage(targetid, COLOR_INFO, "[Cadera] "COLOR_EMB_WHITE" %s - %s: %s", ItemModel_GetName(HolsterItem[playerid]), ItemModel_GetParamName(HolsterItem[playerid]), param_display);
	} else {
		SendClientMessage(targetid, COLOR_INFO, "[Cadera] "COLOR_EMB_WHITE" Nada");
	}
	SendClientMessage(targetid, COLOR_WHITE, "_____________________________________________________");
	return 1;
}

static Holster_SaveModeToDB(playerid)
{
	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query),
		"INSERT INTO `holster` \
		(`playerid`,`itemid`,`param`,`pos_x`,`pos_y`,`pos_z`,`rot_x`,`rot_y`,`rot_z`,`sc_x`,`sc_y`,`sc_z`,`mode`) \
		VALUES (%i,%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f,%i) \
		ON DUPLICATE KEY UPDATE \
		`mode`=%i,`pos_x`=%f,`pos_y`=%f,`pos_z`=%f,`rot_x`=%f,`rot_y`=%f,`rot_z`=%f,`sc_x`=%f,`sc_y`=%f,`sc_z`=%f",
		PlayerInfo[playerid][pID],
		HolsterItem[playerid], HolsterParam[playerid],
		HolsterPos[playerid][0], HolsterPos[playerid][1], HolsterPos[playerid][2],
		HolsterPos[playerid][3], HolsterPos[playerid][4], HolsterPos[playerid][5],
		HolsterScale[playerid][0], HolsterScale[playerid][1], HolsterScale[playerid][2],
		HolsterMode[playerid],
		HolsterMode[playerid],
		HolsterPos[playerid][0], HolsterPos[playerid][1], HolsterPos[playerid][2],
		HolsterPos[playerid][3], HolsterPos[playerid][4], HolsterPos[playerid][5],
		HolsterScale[playerid][0], HolsterScale[playerid][1], HolsterScale[playerid][2]);
	mysql_tquery(MYSQL_HANDLE, query);
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if (dialogid != HOLSTER_DLG_CONFIG) return 0;
	if (!response) return 1;
	switch (listitem)
	{
		case 0:
		{
			HolsterMode[playerid] = 0;
			Holster_SetDefaultPos(playerid);
			if (HolsterItem[playerid] != 0) { Holster_Detach(playerid); Holster_Attach(playerid); }
			Holster_SaveModeToDB(playerid);
			SendClientMessage(playerid, COLOR_INFO, "[CADERA] "COLOR_EMB_GREY"Modo cambiado: con movimiento. Usa /cadera editar para ajustar.");
		}
		case 1:
		{
			HolsterMode[playerid] = 1;
			HolsterPos[playerid][0] = HOLSTER_SPINE_X;
			HolsterPos[playerid][1] = HOLSTER_SPINE_Y;
			HolsterPos[playerid][2] = HOLSTER_SPINE_Z;
			HolsterPos[playerid][3] = HOLSTER_SPINE_RX;
			HolsterPos[playerid][4] = HOLSTER_SPINE_RY;
			HolsterPos[playerid][5] = HOLSTER_SPINE_RZ;
			HolsterScale[playerid][0] = HOLSTER_DEFAULT_SX;
			HolsterScale[playerid][1] = HOLSTER_DEFAULT_SY;
			HolsterScale[playerid][2] = HOLSTER_DEFAULT_SZ;
			if (HolsterItem[playerid] != 0) { Holster_Detach(playerid); Holster_Attach(playerid); }
			Holster_SaveModeToDB(playerid);
			SendClientMessage(playerid, COLOR_INFO, "[CADERA] "COLOR_EMB_GREY"Modo cambiado: sin movimiento. Usa /cadera editar para ajustar.");
		}
	}
	return 1;
}

// ?????????????????????????????????????????????????????????????????
// COMANDO /cadera
// ?????????????????????????????????????????????????????????????????

CMD:cadera(playerid, params[])
{
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");

	new subcmd[16];
	if(!sscanf(params, "s[16]", subcmd))
	{
		if(!strcmp(subcmd, "editar", true))
		{
			if(HolsterItem[playerid] == 0)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes nada en la cadera para editar.");
			if(HolsterEditing[playerid])
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya estas en modo edicion.");

			HolsterEditing[playerid] = true;
			Holster_Detach(playerid);
			Holster_Attach(playerid);
			EditAttachedObject(playerid, ATTACH_INDEX_ID_HOLSTER);
			SendClientMessage(playerid, COLOR_INFO, "[CADERA] "COLOR_EMB_GREY"Modo edicion activado. Ajusta la posicion y confirma para guardar.");
			return 1;
		}

		if(!strcmp(subcmd, "guardar", true))
		{
			Holster_SavePosToDB(playerid);
			SendClientMessage(playerid, COLOR_INFO, "[CADERA] "COLOR_EMB_GREY"Posicion de la funda guardada.");
			return 1;
		}

		if(!strcmp(subcmd, "configuracion", true))
		{
			ShowPlayerDialog(playerid, HOLSTER_DLG_CONFIG, DIALOG_STYLE_LIST, "Cadera - Configuracion",
				"Con movimiento (recomendada para la pierna)\nSin movimiento (recomendado: cintura/pecho)",
				"Seleccionar", "Cancelar");
			return 1;
		}

		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cadera [configuracion | editar | guardar]");
		return 1;
	}

	// Sin subcomando: sacar si tiene algo, guardar si tiene arma en mano
	if(HolsterItem[playerid] != 0)
	{
		if(Item_IsHandlingCooldownOn(playerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Espera un momento antes de volver a interactuar.");

		new freeHand = SearchFreeHand(playerid);
		if(freeHand == -1)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes manos libres para sacar el arma de la cadera.");

		new itemid = HolsterItem[playerid], param = HolsterParam[playerid];
		HolsterItem[playerid]  = 0;
		HolsterParam[playerid] = 0;
		Holster_Detach(playerid);
		SetHandItemAndParam(playerid, freeHand, itemid, param);
		Item_ApplyHandlingCooldown(playerid);
		Holster_SaveItemToDB(playerid);

		new str[64];
		format(str, sizeof(str), "Saca %s de la cadera.", ItemModel_GetName(itemid));
		PlayerCmeMessage(playerid, 15.0, 3500, str);
		return 1;
	}

	// Funda vacia: buscar arma elegible en manos
	new hand = -1;
	if(Holster_IsEligible(GetHandItem(playerid, HAND_RIGHT)))
		hand = HAND_RIGHT;
	else if(Holster_IsEligible(GetHandItem(playerid, HAND_LEFT)))
		hand = HAND_LEFT;

	if(hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes un arma compatible en la mano. Solo pistolas y armas cortas.");

	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Espera un momento antes de volver a interactuar.");

	new itemid = GetHandItem(playerid, hand);
	HolsterItem[playerid]  = itemid;
	HolsterParam[playerid] = GetHandParam(playerid, hand);
	SetHandItemAndParam(playerid, hand, 0, 0);
	SetTimerEx("Holster_AttachDelayed", 100, false, "i", playerid);
	Item_ApplyHandlingCooldown(playerid);
	Holster_SaveItemToDB(playerid);

	new str[64];
	format(str, sizeof(str), "Guarda %s en la cadera.", ItemModel_GetName(itemid));
	PlayerCmeMessage(playerid, 15.0, 3500, str);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Recuerda que cada vez que pongas el arma en tu cintura, debes realizar una interpretación acorde al entorno.");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Evita sanciones y el mal uso del /cadera, esforcemosnos por interpretar correctamente.");
	if(HolsterScale[playerid][0] == 0.0 && HolsterScale[playerid][1] == 0.0 && HolsterScale[playerid][2] == 0.0)
	{
		SendClientMessage(playerid, COLOR_INFO, "{FF0000}[CADERA] "COLOR_EMB_GREY"Es la primera vez que usas /cadera.");
		SendClientMessage(playerid, COLOR_INFO, "{FF0000}[CADERA] "COLOR_EMB_GREY"El arma guardada puede aparecer invisible hasta que configures la funda.");
		SendClientMessage(playerid, COLOR_INFO, "{FF0000}[CADERA] "COLOR_EMB_GREY"Usa /cadera configuracion y elige una de las dos opciones.");
		SendClientMessage(playerid, COLOR_INFO, "{FF0000}[CADERA] "COLOR_EMB_GREY"Luego podes ajustar la posicion con /cadera editar.");
	}
	return 1;
}
