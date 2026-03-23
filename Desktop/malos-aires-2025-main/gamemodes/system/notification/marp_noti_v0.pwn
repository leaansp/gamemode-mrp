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

#include "system\notification\marp_noti_char_data.pwn"

#include <YSI_Coding\y_hooks>

#define NOTI_MAX_AMOUNT (6)
#define NOTI_POS_Y_START (132.00)
#define NOTI_POS_Y_MAX (390.00)
#define NOTI_POS_X_START (498.00)
#define NOTI_WIDTH_X (134.00)
#define NOTI_FONT (1)
#define NOTI_FONT_SIZE_X (0.25)
#define NOTI_FONT_SIZE_Y (1.00)
#define NOTI_COLOR_FONT (0xFFFFFFFF)
#define NOTI_COLOR_BOX (0x000000A0)
#define NOTI_DISTANCE_BETWEEN (6.00)
#define NOTI_MAX_TEXT_LENGTH (300)

static enum e_NOTI_INFO
{
	bool:nActive,
	nUniqueId,
	nLinesAmount,
	nText[NOTI_MAX_TEXT_LENGTH],
	PlayerText:nPTD,
	Float:nPosY,
	Float:nHeight,
	nTimer
}

static NotiInfo[MAX_PLAYERS][NOTI_MAX_AMOUNT][e_NOTI_INFO];
static const INVALID_NOTI_ID = -1;

Noti_Show(playerid, const string[], time)
{
	static uniqueid;

	new id = Noti_GetFirstFreeId(playerid);

	if(id == INVALID_NOTI_ID)
		return 0;

	NotiInfo[playerid][id][nPosY] = (id == 0) ? (NOTI_POS_Y_START) : (NotiInfo[playerid][id - 1][nPosY] + NotiInfo[playerid][id - 1][nHeight] + NOTI_DISTANCE_BETWEEN);

	if(NotiInfo[playerid][id][nPosY] >= NOTI_POS_Y_MAX)
		return 0;

	Noti_ProcessText(playerid, id, string);

	NotiInfo[playerid][id][nUniqueId] = ++uniqueid;
	NotiInfo[playerid][id][nActive] = true;
	//NotiInfo[playerid][id][nHeight] = (NOTI_FONT_SIZE_Y * 2.0) + 2.0 + (NOTI_FONT_SIZE_Y * 5.75 * float(NotiInfo[playerid][id][nLinesAmount])) + (float(NotiInfo[playerid][id][nLinesAmount] - 1) * ((NOTI_FONT_SIZE_Y * 2.0) + 2.0 + NOTI_FONT_SIZE_Y)) + NOTI_FONT_SIZE_Y + 3.0;
	NotiInfo[playerid][id][nHeight] = (NOTI_FONT_SIZE_Y * 2.0) + 2.0 + (NOTI_FONT_SIZE_Y * 5.75 * float(NotiInfo[playerid][id][nLinesAmount])) + (float(NotiInfo[playerid][id][nLinesAmount] - 1) * ((NOTI_FONT_SIZE_Y * 2.0) + 1.35)) + NOTI_FONT_SIZE_Y + 3.0;

	Noti_CreateAndShowPTD(playerid, id);

	if(time) {
		NotiInfo[playerid][id][nTimer] = SetTimerEx("Noti_AutoHide", (time < 500) ? (500) : (time), false, "ii", playerid, uniqueid);
	} else {
		NotiInfo[playerid][id][nTimer] = 0;
	}

	return uniqueid;
}

static Noti_GetFirstFreeId(playerid)
{
	for(new i = 0; i < NOTI_MAX_AMOUNT; i++)
	{
		if(!NotiInfo[playerid][i][nActive])
			return i;
	}
	return INVALID_NOTI_ID;
}

static Noti_CreateAndShowPTD(playerid, id)
{
	new PlayerText:ptd = CreatePlayerTextDraw(playerid, NOTI_POS_X_START, NotiInfo[playerid][id][nPosY], NotiInfo[playerid][id][nText]);

	PlayerTextDrawFont(playerid, ptd, NOTI_FONT);
	PlayerTextDrawLetterSize(playerid, ptd, NOTI_FONT_SIZE_X, NOTI_FONT_SIZE_Y);
	PlayerTextDrawTextSize(playerid, ptd, NOTI_POS_X_START + NOTI_WIDTH_X, 1.0);
	PlayerTextDrawSetOutline(playerid, ptd, 1);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawAlignment(playerid, ptd, 1);
	PlayerTextDrawColor(playerid, ptd, NOTI_COLOR_FONT);
	PlayerTextDrawBackgroundColor(playerid, ptd, NOTI_COLOR_BOX);
	PlayerTextDrawBoxColor(playerid, ptd, NOTI_COLOR_BOX);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	PlayerTextDrawShow(playerid, ptd);

	NotiInfo[playerid][id][nPTD] = ptd;
}

static Noti_Move(playerid, fromid, toid)
{
	NotiInfo[playerid][toid][nUniqueId] = NotiInfo[playerid][fromid][nUniqueId];
	NotiInfo[playerid][toid][nLinesAmount] = NotiInfo[playerid][fromid][nLinesAmount];
	NotiInfo[playerid][toid][nHeight] = NotiInfo[playerid][fromid][nHeight];
	NotiInfo[playerid][toid][nTimer] = NotiInfo[playerid][fromid][nTimer];

	NotiInfo[playerid][toid][nText][0] = EOS;
	strcat(NotiInfo[playerid][toid][nText], NotiInfo[playerid][fromid][nText], NOTI_MAX_TEXT_LENGTH);

	// Re-calculamos la posición Y de la id vieja con la nueva altura para dejarla lista para un eventual corrimiento en cascada posterior
	NotiInfo[playerid][fromid][nPosY] = NotiInfo[playerid][toid][nPosY] + NotiInfo[playerid][toid][nHeight] + NOTI_DISTANCE_BETWEEN;
}

// static Noti_Destroy(playerid, id)
// {
// 	PlayerTextDrawDestroy(playerid, NotiInfo[playerid][id][nPTD]);

// 	NotiInfo[playerid][id][nTimer] = 0;

// 	if(id + 1 < NOTI_MAX_AMOUNT && NotiInfo[playerid][id + 1][nActive])
// 	{
// 		Noti_Move(playerid, id + 1, id);
// 		Noti_CreateAndShowPTD(playerid, id);
// 		Noti_Destroy(playerid, id + 1); // Cascade propagation
// 	} else {
// 		NotiInfo[playerid][id][nActive] = false;
// 	}
// }

static Noti_Destroy(playerid, id)
{
	PlayerTextDrawDestroy(playerid, NotiInfo[playerid][id][nPTD]);

	NotiInfo[playerid][id][nTimer] = 0;
	NotiInfo[playerid][id][nUniqueId] = 0;

	// Si hay una notificación en la id siguiente, movemos en cascada
	for(; id + 1 < NOTI_MAX_AMOUNT && NotiInfo[playerid][id + 1][nActive]; id++)
	{
		// Borramos el textdraw de la id siguiente
		PlayerTextDrawDestroy(playerid, NotiInfo[playerid][id + 1][nPTD]);

		// Movemos la data de la id siguiente a la id actual
		Noti_Move(playerid, id + 1, id);
		
		// Re-creamos el textdraw de la id actual con los datos estáticos movidos de la id siguiente
		Noti_CreateAndShowPTD(playerid, id);
	}

	NotiInfo[playerid][id][nActive] = false;
}

static Noti_FindByUniqueId(playerid, uniqueid)
{
	for(new i = 0; i < NOTI_MAX_AMOUNT; i++)
	{
		if(NotiInfo[playerid][i][nUniqueId] == uniqueid && NotiInfo[playerid][i][nActive])
			return i;
	}
	return INVALID_NOTI_ID;
}

forward Noti_Hide(playerid, uniqueid);
public Noti_Hide(playerid, uniqueid)
{
	new id = Noti_FindByUniqueId(playerid, uniqueid);

	if(id == INVALID_NOTI_ID)
		return 0;

	if(NotiInfo[playerid][id][nTimer]) {
		KillTimer(NotiInfo[playerid][id][nTimer]);
	}

	Noti_Destroy(playerid, id);
	return 1;
}

forward Noti_AutoHide(playerid, uniqueid);
public Noti_AutoHide(playerid, uniqueid)
{
	new id = Noti_FindByUniqueId(playerid, uniqueid);

	if(id == INVALID_NOTI_ID)
		return 0;

	Noti_Destroy(playerid, id);
	return 1;
}

static Noti_ProcessText(playerid, id, const string[])
{
	new lines = 1, Float:width, lastspace = -1, supr, len = strlen(string);

	if(len > NOTI_MAX_TEXT_LENGTH)
		len = NOTI_MAX_TEXT_LENGTH;

	for(new i = 0; i < len; i++)
	{
		NotiInfo[playerid][id][nText][i] = ASCIIChar_To_TextDrawChar[string[i]];

        if(NotiInfo[playerid][id][nText][i] == '~') {
        	supr = !supr;
        }
        else
        {
			if(supr == 1)
			{
				if(NotiInfo[playerid][id][nText][i] == 'n')
				{
					lines++;
					lastspace = -1;
					width = 0;
				}
			}
            else
            {
                if(NotiInfo[playerid][id][nText][i] == ' ') {
                	lastspace = i;
                }
 
                width += NOTI_FONT_SIZE_X * GetTextDrawCharacterWidth(NotiInfo[playerid][id][nText][i], NOTI_FONT, true);

				if(width > NOTI_WIDTH_X - 3.0)
				{
					if(lastspace != i && lastspace != -1) {
						i = lastspace;
					}

					lines ++;
					lastspace = -1;
					width = 0;
				}
			}
		}
	}
    
    NotiInfo[playerid][id][nText][len] = EOS;
    NotiInfo[playerid][id][nLinesAmount] = lines;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	for(new i = 0; i < NOTI_MAX_AMOUNT; i++)
	{
		if(NotiInfo[playerid][i][nActive])
		{
			NotiInfo[playerid][i][nActive] = false;
			if(NotiInfo[playerid][i][nTimer])
			{
				KillTimer(NotiInfo[playerid][i][nTimer]);
				NotiInfo[playerid][i][nTimer] = 0;
			}
		} else {
			return 1;
		}
	}
	return 1;
}