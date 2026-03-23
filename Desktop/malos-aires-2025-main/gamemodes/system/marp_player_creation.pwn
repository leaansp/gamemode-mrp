#if defined _marp_char_creation_included
	#endinput
#endif
#define _marp_char_creation_included

#include <YSI_Coding\y_hooks>

#define PC_COLOR_SELECTION_YELLOW (0xFCF023FF)

// TODO: en un futuro si hay problemas de memoria pasar a vectores

static PlayerText:PCC_PTD_background[MAX_PLAYERS];
static PlayerText:PCC_PTD_nameTitle[MAX_PLAYERS];
static PlayerText:PCC_PTD_nameField[MAX_PLAYERS];
static PlayerText:PCC_PTD_sexTitle[MAX_PLAYERS];
static PlayerText:PCC_PTD_sexField[MAX_PLAYERS];
static PlayerText:PCC_PTD_ageTitle[MAX_PLAYERS];
static PlayerText:PCC_PTD_ageField[MAX_PLAYERS];
static PlayerText:PCC_PTD_line[MAX_PLAYERS];
static PlayerText:PCC_PTD_skinTitle[MAX_PLAYERS];
static PlayerText:PCC_PTD_skinModel[MAX_PLAYERS];
static PlayerText:PCC_PTD_skinNext[MAX_PLAYERS];
static PlayerText:PCC_PTD_skinPrev[MAX_PLAYERS];
static PlayerText:PCC_PTD_confirm[MAX_PLAYERS];

static PCC_active[MAX_PLAYERS];
static PCC_skinPos[MAX_PLAYERS];
static PCC_sex[MAX_PLAYERS];
static PCC_age[MAX_PLAYERS];

static const PCC_MALE_SKINS[] = {
	1, 2, 3, 6, 7, 14, 22, 23, 25, 26, 29, 30, 32, 43, 46, 48, 60, 94, 98, 101, 184, 188, 235
};

static const PCC_FEMALE_SKINS[] = {
	9, 38, 39, 41, 54, 56, 69, 88, 225, 233
};

forward PCC_Start(playerid, delay);
public PCC_Start(playerid, delay)
{
	if(delay > 0) {
		return SetTimerEx("PCC_Start", delay, false, "ii", playerid, 0);
	} else {
		PCC_Create(playerid);
		PCC_Show(playerid);
	}
	return 0;
}

static PCC_Create(playerid)
{
	// Create textdraws
	PCC_CreatePTD(playerid);

	// Default data
	PCC_skinPos[playerid] = random(sizeof(PCC_MALE_SKINS));
	PCC_sex[playerid] = 1;
	PCC_age[playerid] = 0;

	// Update textdraws default data
	new charName[MAX_PLAYER_NAME];
	if(strlen(PlayerInfo[playerid][pName]))
	{
		format(charName, sizeof(charName), "%s", PlayerInfo[playerid][pName]);
	}
	else
	{
		format(charName, sizeof(charName), "%s", GetPlayerCleanName(playerid));
	}

	PlayerTextDrawSetString(playerid, PCC_PTD_nameField[playerid], charName);
	PlayerTextDrawSetPreviewModel(playerid, PCC_PTD_skinModel[playerid], PCC_MALE_SKINS[PCC_skinPos[playerid]]);
}

static PCC_Show(playerid)
{
	PCC_active[playerid] = 1;
	PCC_ShowPTD(playerid);
	SelectTextDraw(playerid, PC_COLOR_SELECTION_YELLOW);
	TogglePlayerControllable(playerid, false);
}

static PCC_Destroy(playerid)
{
	PCC_active[playerid] = 0; // always before CancelSelectTextDraw
	CancelSelectTextDraw(playerid);
	PCC_DestroyPTD(playerid);
	TogglePlayerControllable(playerid, true);
}

static PCC_UpdateSkin(playerid, pos)
{
	if(PCC_sex[playerid]) {
		PlayerTextDrawSetPreviewModel(playerid, PCC_PTD_skinModel[playerid], PCC_MALE_SKINS[pos]);
	} else {
		PlayerTextDrawSetPreviewModel(playerid, PCC_PTD_skinModel[playerid], PCC_FEMALE_SKINS[pos]);
	}
	PlayerTextDrawShow(playerid, PCC_PTD_skinModel[playerid]);
}

static PCC_ChangeSex(playerid) // 1 = Masc, 0 = Fem
{
	if(PCC_sex[playerid])
	{
		PCC_sex[playerid] = 0;
		PCC_skinPos[playerid] = random(sizeof(PCC_FEMALE_SKINS));
		PlayerTextDrawSetString(playerid, PCC_PTD_sexField[playerid], "Femenino");
		PCC_UpdateSkin(playerid, PCC_skinPos[playerid]);
	}
	else
	{
		PCC_sex[playerid] = 1;
		PCC_skinPos[playerid] = random(sizeof(PCC_MALE_SKINS));
		PlayerTextDrawSetString(playerid, PCC_PTD_sexField[playerid], "Masculino");
		PCC_UpdateSkin(playerid, PCC_skinPos[playerid]);
	}
}

static PCC_NextSkin(playerid)
{
	if(PCC_sex[playerid]) {
		if((++PCC_skinPos[playerid]) >= sizeof(PCC_MALE_SKINS)) {
			PCC_skinPos[playerid] = 0;
		}
	} else {
		if((++PCC_skinPos[playerid]) >= sizeof(PCC_FEMALE_SKINS)) {
			PCC_skinPos[playerid] = 0;
		}
	}
	PCC_UpdateSkin(playerid, PCC_skinPos[playerid]);
}

static PCC_PrevSkin(playerid)
{
	if(PCC_sex[playerid]) {
		if((--PCC_skinPos[playerid]) < 0) {
			PCC_skinPos[playerid] = sizeof(PCC_MALE_SKINS) - 1;
		}
	} else {
		if((--PCC_skinPos[playerid]) < 0) {
			PCC_skinPos[playerid] = sizeof(PCC_FEMALE_SKINS) - 1;
		}
	}
	PCC_UpdateSkin(playerid, PCC_skinPos[playerid]);
}

static PCC_ChangeAge(playerid) {
	Dialog_Show(playerid, DLG_PC_CHANGE_AGE, DIALOG_STYLE_INPUT, "Creación de personaje", "Ingresa la edad de tu personaje:", "Ingresar", "Cerrar");
}

Dialog:DLG_PC_CHANGE_AGE(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	new age;

	if(isnull(inputtext) || sscanf(inputtext, "i", age))
		return Dialog_Show(playerid, DLG_PC_CHANGE_AGE, DIALOG_STYLE_INPUT, "Creación de personaje", "{E44A4A}Debes ingresar un número entre 18 y 80", "Ingresar", "Cerrar");
	
	if(18 <= age <= 80) {
		PCC_UpdateAge(playerid, age);
	} else {
		return Dialog_Show(playerid, DLG_PC_CHANGE_AGE, DIALOG_STYLE_INPUT, "Creación de personaje", "{E44A4A}Debes ingresar un número entre 18 y 80", "Ingresar", "Cerrar");
	}

	return 1;
}

static PCC_UpdateAge(playerid, age)
{
	new str[16];
	valstr(str, age);
	PlayerTextDrawSetString(playerid, PCC_PTD_ageField[playerid], str);
	PCC_age[playerid] = age;
}

static PCC_Confirm(playerid)
{
	if(PCC_age[playerid] < 18 || PCC_age[playerid] > 80) {
		return Dialog_Show(playerid, DLG_PC_AGE_MISSING, DIALOG_STYLE_MSGBOX, "Creación de personaje", "{E44A4A} ¡Debes ingresar una edad para poder confirmar tu personaje!", "Volver", "");
	}

	PCC_Destroy(playerid);

	new skin;

	if(PCC_sex[playerid]) {
		skin = PCC_MALE_SKINS[PCC_skinPos[playerid]];
	} else {
		skin = PCC_FEMALE_SKINS[PCC_skinPos[playerid]];
	}

	OnPlayerCreationSuccess(playerid, skin, PCC_sex[playerid], PCC_age[playerid]);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	PCC_active[playerid] = 0;
	return 1;
}

hook OnPlayerClickTD(playerid, Text:clickedid)
{
	if(!PCC_active[playerid])
		return 0;

	if(clickedid == Text:INVALID_TEXT_DRAW) {
		SelectTextDraw(playerid, PC_COLOR_SELECTION_YELLOW);
	}
	return 0;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(!PCC_active[playerid])
		return 0;

	if(playertextid == PCC_PTD_skinNext[playerid]) {
		PCC_NextSkin(playerid);
		return ~1;
	}
	else if(playertextid == PCC_PTD_skinPrev[playerid]) {
		PCC_PrevSkin(playerid);
		return ~1;
	}
	else if(playertextid == PCC_PTD_confirm[playerid]) {
		PCC_Confirm(playerid);
		return ~1;
	}
	else if(playertextid == PCC_PTD_sexField[playerid]) {
		PCC_ChangeSex(playerid);
		return ~1;
	}
	else if(playertextid == PCC_PTD_ageField[playerid]) {
		PCC_ChangeAge(playerid);
		return ~1;
	}
	return 0;
}

static PCC_ShowPTD(playerid)
{
	PlayerTextDrawShow(playerid, PCC_PTD_background[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_nameTitle[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_nameField[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_sexTitle[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_sexField[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_ageTitle[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_ageField[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_line[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_skinTitle[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_skinModel[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_skinNext[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_skinPrev[playerid]);
	PlayerTextDrawShow(playerid, PCC_PTD_confirm[playerid]);
}

static PCC_DestroyPTD(playerid)
{
	PlayerTextDrawDestroy(playerid, PCC_PTD_background[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_nameTitle[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_nameField[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_sexTitle[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_sexField[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_ageTitle[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_ageField[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_line[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_skinTitle[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_skinModel[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_skinNext[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_skinPrev[playerid]);
	PlayerTextDrawDestroy(playerid, PCC_PTD_confirm[playerid]);
}

static PCC_CreatePTD(playerid)
{
	new PlayerText:ptd;

	ptd = CreatePlayerTextDraw(playerid, 320.000000, 90.000000, "_");
	PlayerTextDrawLetterSize(playerid, ptd, 0.600000, 26.10000);
	PlayerTextDrawTextSize(playerid, ptd, 10.000000, 294.000000);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PlayerTextDrawBoxColor(playerid, ptd, 180);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	PCC_PTD_background[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 245.000000, 96.000000, "nombre");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.500000, 2.000000);
	PlayerTextDrawTextSize(playerid, ptd, 10.000000, 135.000000);
	PlayerTextDrawSetOutline(playerid, ptd, 1);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PlayerTextDrawBoxColor(playerid, ptd, -176);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	PCC_PTD_nameTitle[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 245.000000, 128.000000, "nombre_apellido");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.500000, 2.000000);
	PlayerTextDrawTextSize(playerid, ptd, 10.000000, 10.000000);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PCC_PTD_nameField[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 245.000000, 178.000000, "sexo");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.500000, 2.000000);
	PlayerTextDrawTextSize(playerid, ptd, 10.000000, 135.000000);
	PlayerTextDrawSetOutline(playerid, ptd, 1);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PlayerTextDrawBoxColor(playerid, ptd, -176);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	PCC_PTD_sexTitle[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 245.000000, 211.000000, "masculino");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.500000, 2.000000);
	PlayerTextDrawTextSize(playerid, ptd, 10.000000, 80.000000);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PlayerTextDrawSetSelectable(playerid, ptd, 1);
	PCC_PTD_sexField[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 245.000000, 245.000000, "edad");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.500000, 2.000000);
	PlayerTextDrawTextSize(playerid, ptd, 10.000000, 135.000000);
	PlayerTextDrawSetOutline(playerid, ptd, 1);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PlayerTextDrawBoxColor(playerid, ptd, -176);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	PCC_PTD_ageTitle[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 245.000000, 279.000000, "00");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.500000, 2.000000);
	PlayerTextDrawTextSize(playerid, ptd, 10.000000, 80.000000);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PlayerTextDrawSetSelectable(playerid, ptd, 1);
	PCC_PTD_ageField[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 320.000000, 90.000000, "_");
	PlayerTextDrawLetterSize(playerid, ptd, 0.600000, 23.75000);
	PlayerTextDrawTextSize(playerid, ptd, 10.000000, 1.500000);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PlayerTextDrawBoxColor(playerid, ptd, -176);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	PCC_PTD_line[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 395.000000, 96.000000, "apariencia");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ptd, 5.000000, 135.000000);
	PlayerTextDrawSetOutline(playerid, ptd, 1);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PlayerTextDrawBoxColor(playerid, ptd, -176);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	PCC_PTD_skinTitle[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 327.000000, 111.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ptd, 5);
	PlayerTextDrawTextSize(playerid, ptd, 133.000000, 166.000000);
	PlayerTextDrawBackgroundColor(playerid, ptd, 1296911616);
	PlayerTextDrawSetPreviewModel(playerid, ptd, 128);
	PlayerTextDrawSetPreviewRot(playerid, ptd, -10.000000, 0.000000, 0.000000);
	PCC_PTD_skinModel[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 404.000000, 274.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, ptd, 4);
	PlayerTextDrawTextSize(playerid, ptd, 17.000000, 17.000000);
	PlayerTextDrawSetSelectable(playerid, ptd, 1);
	PCC_PTD_skinNext[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 370.000000, 274.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, ptd, 4);
	PlayerTextDrawTextSize(playerid, ptd, 17.000000, 17.000000);
	PlayerTextDrawSetSelectable(playerid, ptd, 1);
	PCC_PTD_skinPrev[playerid] = ptd;

	ptd = CreatePlayerTextDraw(playerid, 320.000000, 307.000000, "confirmar");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ptd, 10.000000, 294.000000);
	PlayerTextDrawSetOutline(playerid, ptd, 1);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 2);
	PlayerTextDrawBoxColor(playerid, ptd, -176);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	PlayerTextDrawSetSelectable(playerid, ptd, 1);
	PCC_PTD_confirm[playerid] = ptd;
}