/****************************************************************************************************
	Idea, string lines amount parser, and dynamic textdraw height data based on release 1.1.0 from
		"ThePez/td-notification"
			"Created by ThePez - NaS"

	Re-made from scratch with cleaner, simplier, and much faster code. Also bugs fixed.

****************************************************************************************************/

#if defined marp_noti_inc
	#endinput
#endif
#define marp_noti_inc

#include <YSI_Coding\y_hooks>

#define NOTI_MAX_AMOUNT (6)
#define NOTI_POS_Y_START (132.00)
#define NOTI_POS_Y_MAX (390.00)
#define NOTI_POS_X_START (498.00)
#define NOTI_WIDTH_X (134.00)
#define NOTI_FONT (1)
#define NOTI_FONT_SIZE_X (0.25)
#define NOTI_FONT_SIZE_Y (1.00)
#define NOTI_OUTLINE (1)
#define NOTI_DEFAULT_COLOR_FONT (0xFFFFFFFF)
#define NOTI_DEFAULT_COLOR_BOX (0x000000A0)
#define NOTI_DEFAULT_COLOR_BACKGROUND (0x000000FF)
#define NOTI_DISTANCE_BETWEEN (6.00)
#define NOTI_MAX_TEXT_LENGTH (300)

static enum e_NOTI_POSITION_DATA
{
	bool:nActive,
	nDataId,
	PlayerText:nPTD,
	Float:nPosY
}

static NotiPosData[MAX_PLAYERS][NOTI_MAX_AMOUNT][e_NOTI_POSITION_DATA];
static const NOTI_INVALID_POS_ID = -1;

static enum e_NOTI_DATA
{
	nUniqueId,
	nLinesAmount,
	nText[NOTI_MAX_TEXT_LENGTH],
	Float:nHeight,
	nTimer,
	nFontColor,
	nBoxColor,
	nBackgroundColor
}

static NotiData[MAX_PLAYERS][NOTI_MAX_AMOUNT][e_NOTI_DATA];
static const NOTI_INVALID_DATA_ID = -1;

/*

    Position ID                   Notifications wont
    can change                      change static
  notif. Data Id                        data

NotificationPosData                NotificationData
   _  _____  _                       _  _____  _
  | ||_____|| |                     | ||_____|| |
  | |       | |                     | |       | |
  | |Active,| |                     | | Static| |
  | |  PTD, |_|__                   | | Notif.| |
  | |Data Id _ _ \                  | | Data  | |
  | | _____ | | \ \                 | | _____ | |
  |_||_____||_|  \ \                |_||_____||_|
  | |       | |   \ \   Reference   | |       | |
  | |       | |    \ \  To Notif.   | |       | |
  | |       | |     \ \  Data Id    | |       | |
  | | _____ | |      \ \            | | _____ | |
  |_||_____||_|       \ \           |_||_____||_|
  | |       | |        \ \          | |       | |
  | |       | |         \ \___| \   | |       | |
  | |       | |          \____   |  | |       | |
  | | _____ | |               |_/   | | _____ | |
  |_||_____||_|                     |_||_____||_|

 Position ID changes notification Data ID reference when re-ordering notifications, avoiding data copying.

*/

CMD:anoticrear(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso de Development o Management
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas ser Development o Management para utilizar este comando.");
	
	new targetid, time, string[144];

	if(sscanf(params, "uis[144]", targetid, time, string))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anoticrear [ID/Jugador] [tiempo en ms] [texto] (para permanente use un tiempo de 0 ms)");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	new notiId = Noti_Create(targetid, time, string);

	if(notiId) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Creada notificación id %i al usuario %s (ID %i) con un tiempo de %i ms.", notiId, GetPlayerCleanName(targetid), targetid, time);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene espacio para nuevas notificaciones.");
	}
	return 1;
}

CMD:anotiborrar(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso de Development o Management
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas ser Development o Management para utilizar este comando.");
	
	new targetid, notiId;

	if(sscanf(params, "ui", targetid, notiId))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anotiborrar [ID/Jugador] [ID notificación]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	if(Noti_Hide(targetid, notiId)) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Notificación borrada al jugador %s (ID %i) con éxito.", GetPlayerCleanName(targetid), targetid);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene una notificación activa con la id ingresada.");
	}
    return 1;
}

Noti_Create(playerid, time, const text[], fontColor = NOTI_DEFAULT_COLOR_FONT, boxColor = NOTI_DEFAULT_COLOR_BOX, backgroundColor = NOTI_DEFAULT_COLOR_BACKGROUND)
{
	static uniqueid;

	new posId = Noti_GetFirstFreePosId(playerid);
	new dataId = Noti_GetFirstFreeDataId(playerid);

	if(posId == NOTI_INVALID_POS_ID || dataId == NOTI_INVALID_DATA_ID)
		return 0;

	NotiPosData[playerid][posId][nPosY] = (posId == 0) ? (NOTI_POS_Y_START) : (NotiPosData[playerid][posId - 1][nPosY] + NotiData[playerid][NotiPosData[playerid][posId - 1][nDataId]][nHeight] + NOTI_DISTANCE_BETWEEN);

	if(NotiPosData[playerid][posId][nPosY] >= NOTI_POS_Y_MAX)
		return 0;

	NotiPosData[playerid][posId][nDataId] = dataId;
	NotiPosData[playerid][posId][nActive] = true;

	NotiData[playerid][dataId][nUniqueId] = ++uniqueid;
	NotiData[playerid][dataId][nFontColor] = fontColor;
	NotiData[playerid][dataId][nBoxColor] = boxColor;
	NotiData[playerid][dataId][nBackgroundColor] = backgroundColor;

	Noti_ProcessText(playerid, dataId, text);
	//NotiData[playerid][dataId][nHeight] = (NOTI_FONT_SIZE_Y * 2.0) + 2.0 + (NOTI_FONT_SIZE_Y * 5.75 * float(NotiData[playerid][dataId][nLinesAmount])) + (float(NotiData[playerid][dataId][nLinesAmount] - 1) * ((NOTI_FONT_SIZE_Y * 2.0) + 2.0 + NOTI_FONT_SIZE_Y)) + NOTI_FONT_SIZE_Y + 3.0;
	NotiData[playerid][dataId][nHeight] = (NOTI_FONT_SIZE_Y * 2.0) + 2.0 + (NOTI_FONT_SIZE_Y * 5.75 * float(NotiData[playerid][dataId][nLinesAmount])) + (float(NotiData[playerid][dataId][nLinesAmount] - 1) * ((NOTI_FONT_SIZE_Y * 2.0) + 1.35)) + NOTI_FONT_SIZE_Y + 3.0;
	Noti_CreateAndShowPTD(playerid, posId, dataId);

	if(time) {
		NotiData[playerid][dataId][nTimer] = SetTimerEx("Noti_AutoHide", (time < 500) ? (500) : (time), false, "ii", playerid, uniqueid);
	} else {
		NotiData[playerid][dataId][nTimer] = 0;
	}

	return uniqueid;
}

static Noti_GetFirstFreePosId(playerid)
{
	for(new posId = 0; posId < NOTI_MAX_AMOUNT; posId++)
	{
		if(!NotiPosData[playerid][posId][nActive]) {
			return posId;
		}
	}

	return NOTI_INVALID_POS_ID;
}

static Noti_GetFirstFreeDataId(playerid)
{
	for(new dataId = 0; dataId < NOTI_MAX_AMOUNT; dataId++)
	{
		if(!NotiData[playerid][dataId][nUniqueId]) {
			return dataId;
		}
	}

	return NOTI_INVALID_DATA_ID;
}

static Noti_CreateAndShowPTD(playerid, posId, dataId)
{
	new PlayerText:ptd = CreatePlayerTextDraw(playerid, NOTI_POS_X_START, NotiPosData[playerid][posId][nPosY], NotiData[playerid][dataId][nText]);

	PlayerTextDrawFont(playerid, ptd, NOTI_FONT);
	PlayerTextDrawLetterSize(playerid, ptd, NOTI_FONT_SIZE_X, NOTI_FONT_SIZE_Y);
	PlayerTextDrawTextSize(playerid, ptd, NOTI_POS_X_START + NOTI_WIDTH_X, 1.0);
	PlayerTextDrawSetOutline(playerid, ptd, NOTI_OUTLINE);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawColor(playerid, ptd, NotiData[playerid][dataId][nFontColor]);
	PlayerTextDrawBackgroundColor(playerid, ptd, NotiData[playerid][dataId][nBackgroundColor]);
	PlayerTextDrawBoxColor(playerid, ptd, NotiData[playerid][dataId][nBoxColor]);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	PlayerTextDrawShow(playerid, ptd);

	NotiPosData[playerid][posId][nPTD] = ptd;
}

static Noti_Destroy(playerid, posId)
{
	NotiData[playerid][NotiPosData[playerid][posId][nDataId]][nUniqueId] = 0;
	NotiData[playerid][NotiPosData[playerid][posId][nDataId]][nTimer] = 0;
	PlayerTextDrawDestroy(playerid, NotiPosData[playerid][posId][nPTD]); // Borramos su textdraw actual

	for(; posId + 1 < NOTI_MAX_AMOUNT && NotiPosData[playerid][posId + 1][nActive]; posId++) // Si hay una notificación en la posición actual
	{
		PlayerTextDrawDestroy(playerid, NotiPosData[playerid][posId + 1][nPTD]); // Borramos el textdraw de la posición siguiente
		NotiPosData[playerid][posId][nDataId] = NotiPosData[playerid][posId + 1][nDataId]; // Re-asignamos los datos estáticos de la posición siguiente a la actual
		NotiPosData[playerid][posId + 1][nPosY] = NotiPosData[playerid][posId][nPosY] + NotiData[playerid][NotiPosData[playerid][posId][nDataId]][nHeight] + NOTI_DISTANCE_BETWEEN; // Re-calculamos la posición Y de la posición siguiente para dejarla lista para un eventual corrimiento
		Noti_CreateAndShowPTD(playerid, posId, NotiPosData[playerid][posId][nDataId]); // Re-creamos el textdraw del siguiente en la posición actual con los datos estáticos nuevos
	}

	NotiPosData[playerid][posId][nActive] = false;
}

static Noti_UniqueIdToPosId(playerid, uniqueid)
{
	for(new posId = 0; posId < NOTI_MAX_AMOUNT; posId++)
	{
		if(NotiPosData[playerid][posId][nActive] && NotiData[playerid][NotiPosData[playerid][posId][nDataId]][nUniqueId] == uniqueid) {
			return posId;
		}
	}
	return NOTI_INVALID_POS_ID;
}

static Noti_ResetDataId(playerid, dataId)
{
	NotiData[playerid][dataId][nUniqueId] = 0;

	if(NotiData[playerid][dataId][nTimer])
	{
		KillTimer(NotiData[playerid][dataId][nTimer]);
		NotiData[playerid][dataId][nTimer] = 0;
	}
}

forward Noti_Hide(playerid, uniqueid);
public Noti_Hide(playerid, uniqueid)
{
	new posId = Noti_UniqueIdToPosId(playerid, uniqueid);

	if(posId == NOTI_INVALID_POS_ID)
		return 0;

	if(NotiData[playerid][NotiPosData[playerid][posId][nDataId]][nTimer]) {
		KillTimer(NotiData[playerid][NotiPosData[playerid][posId][nDataId]][nTimer]);
	}

	Noti_Destroy(playerid, posId);
	return 1;
}

forward Noti_AutoHide(playerid, uniqueid);
public Noti_AutoHide(playerid, uniqueid)
{
	new posId = Noti_UniqueIdToPosId(playerid, uniqueid);

	if(posId == NOTI_INVALID_POS_ID)
		return 0;

	Noti_Destroy(playerid, posId);
	return 1;
}

static Noti_ProcessText(playerid, dataId, const string[])
{
	new lines = 1, Float:width, lastspace = -1, supr, len = strlen(string);

	if(len > NOTI_MAX_TEXT_LENGTH)
		len = NOTI_MAX_TEXT_LENGTH;

	for(new i = 0; i < len; i++)
	{
		NotiData[playerid][dataId][nText][i] = ASCIIChar_To_TextDrawChar[string[i]];

		if(NotiData[playerid][dataId][nText][i] == '~') {
			supr = !supr;
		}
		else
		{
			if(supr && NotiData[playerid][dataId][nText][i] == 'n')
			{
				lines++;
				lastspace = -1;
				width = 0;
			}
			else
			{
				if(NotiData[playerid][dataId][nText][i] == ' ') {
					lastspace = i;
				}

				width += NOTI_FONT_SIZE_X * GetTextDrawCharacterWidth(NotiData[playerid][dataId][nText][i], NOTI_FONT, true);

				if(width > NOTI_WIDTH_X - 3.0)
				{
					if(lastspace != i && lastspace != -1) {
						i = lastspace;
					}

					lines++;
					lastspace = -1;
					width = 0;
				}
			}
		}
	}

	NotiData[playerid][dataId][nText][len] = EOS;
	NotiData[playerid][dataId][nLinesAmount] = lines;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	for(new i = 0; i < NOTI_MAX_AMOUNT; i++)
	{
		if(!NotiPosData[playerid][i][nActive]) {
			return 1; // Como estan siempre ordenadas, al encontrar la primera no activa las demas tampoco lo estarán
		}

		Noti_ResetDataId(playerid, NotiPosData[playerid][i][nDataId]);
		NotiPosData[playerid][i][nActive] = false;
	}
	return 1;
}