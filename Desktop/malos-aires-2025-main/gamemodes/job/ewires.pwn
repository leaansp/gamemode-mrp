#if defined _marp_ewires_included
	#endinput
#endif
#define _marp_ewires_included

/*
Clickable TextDraw electrician minigame (Option B) - FULL VERSION
- Fondo general (panel) cubriendo todo
- Filas con fondo por color (suave)
- “Chip” de color a la izquierda por fila (opcional, incluido)
- Columnas más a la izquierda
- Textos FUENTE/DESTINO con color de cable
*/

#include <a_samp>

// =========================
// Config
// =========================
#define ELEC_WIRES_MAX (4)
#define ELEC_TD_NONE   (-1)

static const WIRE_LABELS[ELEC_WIRES_MAX][] = { "R", "V", "AZ", "AM" };
// ARGB (AA RR GG BB) -> acá tenés colores vivos con alpha full en texto
static const WIRE_COLORS[ELEC_WIRES_MAX]   = { 0xFF4D4DFF, 0x4DFF4DFF, 0x4D4DFFFF, 0xFFD84DFF };

// Fondo de filas
#define BTN_IDLE_A  (0x80)   // alpha idle
#define BTN_SEL_A   (0xC0)   // alpha selected
#define CLR_DONE    (0x3D3D3DDD)

// utils
#define FMAX(%0,%1) ((%0) > (%1) ? (%0) : (%1))
#define IMAX(%0,%1) ((%0) > (%1) ? (%0) : (%1))

// =========================
// State
// =========================
forward ew_onptd(playerid, PlayerText:playertextid);
forward OnElecWiresComplete(playerid);

static bool:g_ElecWires_Active[MAX_PLAYERS];
static g_ElecWires_SelectedLeft[MAX_PLAYERS];
static g_ElecWires_MapRight[MAX_PLAYERS][ELEC_WIRES_MAX];
static bool:g_ElecWires_DoneLeft[MAX_PLAYERS][ELEC_WIRES_MAX];
static bool:g_ElecWires_DoneRight[MAX_PLAYERS][ELEC_WIRES_MAX];
static g_ElecWires_Pairs[MAX_PLAYERS];

// =========================
// UI handles
// =========================
static PlayerText:g_tdPanelBg[MAX_PLAYERS];
static PlayerText:g_tdTitle[MAX_PLAYERS];
static PlayerText:g_tdHint[MAX_PLAYERS];
static PlayerText:g_tdStatus[MAX_PLAYERS];
static PlayerText:g_tdExit[MAX_PLAYERS];

static PlayerText:g_tdLeftBtn[MAX_PLAYERS][ELEC_WIRES_MAX];
static PlayerText:g_tdRightBtn[MAX_PLAYERS][ELEC_WIRES_MAX];
static PlayerText:g_tdRowBg[MAX_PLAYERS][ELEC_WIRES_MAX];
static PlayerText:g_tdColorChip[MAX_PLAYERS][ELEC_WIRES_MAX];

// =========================
// Helpers
// =========================
stock bool:SamePTD(PlayerText:a, PlayerText:b) { return (_:a == _:b); }

stock ElecWires_ResetPlayer(playerid)
{
	g_ElecWires_Active[playerid] = false;
	g_ElecWires_SelectedLeft[playerid] = ELEC_TD_NONE;
	g_ElecWires_Pairs[playerid] = 0;

	for (new i = 0; i < ELEC_WIRES_MAX; i++)
	{
		g_ElecWires_DoneLeft[playerid][i] = false;
		g_ElecWires_DoneRight[playerid][i] = false;
		g_ElecWires_MapRight[playerid][i] = i;
	}
	return 1;
}

stock ElecWires_ShuffleRight(playerid)
{
	for (new i = ELEC_WIRES_MAX - 1; i > 0; i--)
	{
		new j = random(i + 1);
		new tmp = g_ElecWires_MapRight[playerid][i];
		g_ElecWires_MapRight[playerid][i] = g_ElecWires_MapRight[playerid][j];
		g_ElecWires_MapRight[playerid][j] = tmp;
	}
	return 1;
}

// =========================
// UI Create/Destroy/Show
// =========================
stock ElecWires_CreateUI(playerid)
{
	// ==== Ajustes globales
	new Float:shiftX = 0.0; // centrado real

	// Panel bounds (cubre todo el minijuego)
	new Float:panelLeft  = 160.0 + shiftX;
	new Float:panelRight = 480.0 + shiftX;
    new Float:panelTopY  = 115.0;
    new Float:panelBotY  = 355.0;
	// Centrados dentro del panel
	new Float:cx = ((panelLeft + panelRight) / 2.0);

	// Columnas (más a la izquierda y con buena separación)
	new Float:leftX  = panelLeft + 40.0;
	new Float:rightX = panelLeft + 210.0;

	new Float:startY = 195.0;
	new Float:stepY  = 26.0;

	// ===== Panel BG (caja que cubre todo)
	g_tdPanelBg[playerid] = CreatePlayerTextDraw(playerid, panelLeft, panelTopY, " ");
	PlayerTextDrawFont(playerid, g_tdPanelBg[playerid], 1);
	PlayerTextDrawLetterSize(playerid, g_tdPanelBg[playerid], 0.0, 0.0);
	PlayerTextDrawUseBox(playerid, g_tdPanelBg[playerid], 1);
	PlayerTextDrawBoxColor(playerid, g_tdPanelBg[playerid], 0x101010E0); // gris oscuro alpha
	PlayerTextDrawTextSize(playerid, g_tdPanelBg[playerid], panelRight, panelBotY); // RIGHT + BOTTOM
	PlayerTextDrawSetSelectable(playerid, g_tdPanelBg[playerid], 0);

	// ===== Title
	g_tdTitle[playerid] = CreatePlayerTextDraw(playerid, cx, 120.0, "REPARACION: CABLEADO");
	PlayerTextDrawAlignment(playerid, g_tdTitle[playerid], 2);
	PlayerTextDrawFont(playerid, g_tdTitle[playerid], 2);
	PlayerTextDrawLetterSize(playerid, g_tdTitle[playerid], 0.30, 1.30);
	PlayerTextDrawSetShadow(playerid, g_tdTitle[playerid], 1);
	PlayerTextDrawColor(playerid, g_tdTitle[playerid], 0xFFFFFFFF);

	// ===== Hint
	g_tdHint[playerid] = CreatePlayerTextDraw(playerid, cx, 145.0, "Click en una FUENTE y luego en su DESTINO");
	PlayerTextDrawAlignment(playerid, g_tdHint[playerid], 2);
	PlayerTextDrawFont(playerid, g_tdHint[playerid], 1);
	PlayerTextDrawLetterSize(playerid, g_tdHint[playerid], 0.22, 1.05);
	PlayerTextDrawSetShadow(playerid, g_tdHint[playerid], 1);
	PlayerTextDrawColor(playerid, g_tdHint[playerid], 0xCFCFCFFF);

	// ===== Status
	g_tdStatus[playerid] = CreatePlayerTextDraw(playerid, cx, 285.0, "CONEXIONES: 0/4");
	PlayerTextDrawAlignment(playerid, g_tdStatus[playerid], 2);
	PlayerTextDrawFont(playerid, g_tdStatus[playerid], 2);
	PlayerTextDrawLetterSize(playerid, g_tdStatus[playerid], 0.26, 1.20);
	PlayerTextDrawSetShadow(playerid, g_tdStatus[playerid], 1);
	PlayerTextDrawColor(playerid, g_tdStatus[playerid], 0xFFFFFFFF);

	// ===== Exit
	g_tdExit[playerid] = CreatePlayerTextDraw(playerid, cx, 315.0, "~r~[ SALIR ]");
	PlayerTextDrawAlignment(playerid, g_tdExit[playerid], 2);
	PlayerTextDrawFont(playerid, g_tdExit[playerid], 2);
	PlayerTextDrawLetterSize(playerid, g_tdExit[playerid], 0.28, 1.25);
	PlayerTextDrawSetShadow(playerid, g_tdExit[playerid], 1);
	PlayerTextDrawColor(playerid, g_tdExit[playerid], 0xFFFFFFFF);
	PlayerTextDrawSetSelectable(playerid, g_tdExit[playerid], 1);

	// ===== Rows
	for (new i = 0; i < ELEC_WIRES_MAX; i++)
	{
		new Float:rowY = startY + stepY * i;

		// Fondo por fila (rectángulo)
		g_tdRowBg[playerid][i] = CreatePlayerTextDraw(playerid, panelLeft, rowY, " ");
		PlayerTextDrawFont(playerid, g_tdRowBg[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, g_tdRowBg[playerid][i], 0.0, 0.0);
		PlayerTextDrawUseBox(playerid, g_tdRowBg[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, g_tdRowBg[playerid][i], (WIRE_COLORS[i] & 0x00FFFFFF) | (BTN_IDLE_A << 24));
		PlayerTextDrawTextSize(playerid, g_tdRowBg[playerid][i], panelRight, rowY + 18.0);
		PlayerTextDrawSetSelectable(playerid, g_tdRowBg[playerid][i], 0);

		// Chip de color (bloquecito a la izquierda)
		g_tdColorChip[playerid][i] = CreatePlayerTextDraw(playerid, panelLeft + 8.0, rowY + 3.0, " ");
		PlayerTextDrawFont(playerid, g_tdColorChip[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, g_tdColorChip[playerid][i], 0.0, 0.0);
		PlayerTextDrawUseBox(playerid, g_tdColorChip[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, g_tdColorChip[playerid][i], (WIRE_COLORS[i] & 0x00FFFFFF) | (0xFF << 24));
		PlayerTextDrawTextSize(playerid, g_tdColorChip[playerid][i], panelLeft + 18.0, rowY + 16.0);
		PlayerTextDrawSetSelectable(playerid, g_tdColorChip[playerid][i], 0);

		// FUENTE (izquierda)
		new sL[32];
		format(sL, sizeof sL, "[%s] FUENTE", WIRE_LABELS[i]);

		g_tdLeftBtn[playerid][i] = CreatePlayerTextDraw(playerid, leftX, rowY, sL);
		PlayerTextDrawFont(playerid, g_tdLeftBtn[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, g_tdLeftBtn[playerid][i], 0.26, 1.18);
		PlayerTextDrawSetShadow(playerid, g_tdLeftBtn[playerid][i], 1);
		PlayerTextDrawColor(playerid, g_tdLeftBtn[playerid][i], WIRE_COLORS[i]); // color por cable
		PlayerTextDrawSetSelectable(playerid, g_tdLeftBtn[playerid][i], 1);

		// DESTINO (derecha) según mapeo shuffle
		new c = g_ElecWires_MapRight[playerid][i];
		new sR[32];
		format(sR, sizeof sR, "DESTINO [%s]", WIRE_LABELS[c]);

		g_tdRightBtn[playerid][i] = CreatePlayerTextDraw(playerid, rightX, rowY, sR);
		PlayerTextDrawFont(playerid, g_tdRightBtn[playerid][i], 2);
		PlayerTextDrawLetterSize(playerid, g_tdRightBtn[playerid][i], 0.26, 1.18);
		PlayerTextDrawSetShadow(playerid, g_tdRightBtn[playerid][i], 1);
		PlayerTextDrawColor(playerid, g_tdRightBtn[playerid][i], WIRE_COLORS[c]); // color por cable real
		PlayerTextDrawSetSelectable(playerid, g_tdRightBtn[playerid][i], 1);
	}

	return 1;
}

stock ElecWires_DestroyUI(playerid)
{
	PlayerTextDrawDestroy(playerid, g_tdPanelBg[playerid]);
	PlayerTextDrawDestroy(playerid, g_tdTitle[playerid]);
	PlayerTextDrawDestroy(playerid, g_tdHint[playerid]);
	PlayerTextDrawDestroy(playerid, g_tdStatus[playerid]);
	PlayerTextDrawDestroy(playerid, g_tdExit[playerid]);

	for (new i = 0; i < ELEC_WIRES_MAX; i++)
	{
		PlayerTextDrawDestroy(playerid, g_tdLeftBtn[playerid][i]);
		PlayerTextDrawDestroy(playerid, g_tdRightBtn[playerid][i]);
		PlayerTextDrawDestroy(playerid, g_tdRowBg[playerid][i]);
		PlayerTextDrawDestroy(playerid, g_tdColorChip[playerid][i]);
	}
	return 1;
}

stock ElecWires_ShowUI(playerid, bool:show)
{
	if (show)
	{
		PlayerTextDrawShow(playerid, g_tdPanelBg[playerid]);
		PlayerTextDrawShow(playerid, g_tdTitle[playerid]);
		PlayerTextDrawShow(playerid, g_tdHint[playerid]);
		PlayerTextDrawShow(playerid, g_tdStatus[playerid]);
		PlayerTextDrawShow(playerid, g_tdExit[playerid]);

		for (new i = 0; i < ELEC_WIRES_MAX; i++)
		{
			PlayerTextDrawShow(playerid, g_tdRowBg[playerid][i]);
			PlayerTextDrawShow(playerid, g_tdColorChip[playerid][i]);
			PlayerTextDrawShow(playerid, g_tdLeftBtn[playerid][i]);
			PlayerTextDrawShow(playerid, g_tdRightBtn[playerid][i]);
		}
	}
	else
	{
		PlayerTextDrawHide(playerid, g_tdPanelBg[playerid]);
		PlayerTextDrawHide(playerid, g_tdTitle[playerid]);
		PlayerTextDrawHide(playerid, g_tdHint[playerid]);
		PlayerTextDrawHide(playerid, g_tdStatus[playerid]);
		PlayerTextDrawHide(playerid, g_tdExit[playerid]);

		for (new i = 0; i < ELEC_WIRES_MAX; i++)
		{
			PlayerTextDrawHide(playerid, g_tdRowBg[playerid][i]);
			PlayerTextDrawHide(playerid, g_tdColorChip[playerid][i]);
			PlayerTextDrawHide(playerid, g_tdLeftBtn[playerid][i]);
			PlayerTextDrawHide(playerid, g_tdRightBtn[playerid][i]);
		}
	}
	return 1;
}

// =========================
// UI Updates
// =========================
stock ElecWires_UpdateStatus(playerid, const msg[])
{
	new st[32];
	format(st, sizeof st, "CONEXIONES: %d/4", g_ElecWires_Pairs[playerid]);
	PlayerTextDrawSetString(playerid, g_tdStatus[playerid], st);
	PlayerTextDrawSetString(playerid, g_tdHint[playerid], msg);
	PlayerTextDrawShow(playerid, g_tdStatus[playerid]);
	PlayerTextDrawShow(playerid, g_tdHint[playerid]);
	return 1;
}

stock ElecWires_SetLeftSelected(playerid, leftColor)
{
	g_ElecWires_SelectedLeft[playerid] = leftColor;

	for (new i = 0; i < ELEC_WIRES_MAX; i++)
	{
		new sL[40];

		if (g_ElecWires_DoneLeft[playerid][i])
			format(sL, sizeof sL, "~w~[X] FUENTE");
		else
			format(sL, sizeof sL, "[%s] FUENTE", WIRE_LABELS[i]);

		if (i == leftColor && !g_ElecWires_DoneLeft[playerid][i])
		{
			new tmp[48];
			format(tmp, sizeof tmp, "> %s <", sL);
			PlayerTextDrawSetString(playerid, g_tdLeftBtn[playerid][i], tmp);
		}
		else PlayerTextDrawSetString(playerid, g_tdLeftBtn[playerid][i], sL);

		// Mantener color del texto por cable (aunque cambie el string)
		PlayerTextDrawColor(playerid, g_tdLeftBtn[playerid][i], WIRE_COLORS[i]);

		// Fondo de fila según estado
		if (g_ElecWires_DoneLeft[playerid][i])
		{
			PlayerTextDrawBoxColor(playerid, g_tdRowBg[playerid][i], CLR_DONE);
		}
		else if (i == leftColor)
		{
			PlayerTextDrawBoxColor(playerid, g_tdRowBg[playerid][i], (WIRE_COLORS[i] & 0x00FFFFFF) | (BTN_SEL_A << 24));
		}
		else
		{
			PlayerTextDrawBoxColor(playerid, g_tdRowBg[playerid][i], (WIRE_COLORS[i] & 0x00FFFFFF) | (BTN_IDLE_A << 24));
		}

		PlayerTextDrawShow(playerid, g_tdRowBg[playerid][i]);
		PlayerTextDrawShow(playerid, g_tdLeftBtn[playerid][i]);
	}

	if (leftColor != ELEC_TD_NONE)
		ElecWires_UpdateStatus(playerid, "~y~Ahora click en el DESTINO correcto");
	else
		ElecWires_UpdateStatus(playerid, "~w~Click en otra FUENTE");

	return 1;
}

// =========================
// Flow
// =========================
public OnElecWiresComplete(playerid)
{
	SendClientMessage(playerid, 0x4DFF4DFF, "[ELECTRICISTA] Cableado reparado correctamente.");
	CallLocalFunction("ElecJob_FinishPoint", "i", playerid);
	return 1;
}

stock StopElecWiresMinigame(playerid, bool:success)
{
	if (!g_ElecWires_Active[playerid]) return 1;

	g_ElecWires_Active[playerid] = false;
	CancelSelectTextDraw(playerid);

	ElecWires_ShowUI(playerid, false);
	ElecWires_DestroyUI(playerid);

	TogglePlayerControllable(playerid, true);

	if (success) CallLocalFunction("OnElecWiresComplete", "i", playerid);
	return 1;
}

stock StartElecWiresMinigame(playerid, newcount)
{
	#pragma unused newcount
	ElecWires_ResetPlayer(playerid);
	ElecWires_ShuffleRight(playerid);
	ElecWires_CreateUI(playerid);
	ElecWires_ShowUI(playerid, true);

	g_ElecWires_Active[playerid] = true;
	g_ElecWires_SelectedLeft[playerid] = ELEC_TD_NONE;

	TogglePlayerControllable(playerid, false);
	SelectTextDraw(playerid, 0xFFFFFFFF);

	ElecWires_UpdateStatus(playerid, "~w~Click en una FUENTE para empezar");
	return 1;
}

// =========================
// Click handler
// =========================
public ew_onptd(playerid, PlayerText:playertextid)
{
	if (!g_ElecWires_Active[playerid]) return 1;

	// Exit
	if (SamePTD(playertextid, g_tdExit[playerid]))
	{
		ElecWires_UpdateStatus(playerid, "~r~Cancelaste la reparacion.");
		StopElecWiresMinigame(playerid, false);
		return 1;
	}

	// Click FUENTE
	for (new i = 0; i < ELEC_WIRES_MAX; i++)
	{
		if (SamePTD(playertextid, g_tdLeftBtn[playerid][i]))
		{
			if (g_ElecWires_DoneLeft[playerid][i])
			{
				ElecWires_UpdateStatus(playerid, "~y~Esa fuente ya esta conectada.");
				return 1;
			}
			ElecWires_SetLeftSelected(playerid, i);
			return 1;
		}
	}

	// Click DESTINO
	for (new slot = 0; slot < ELEC_WIRES_MAX; slot++)
	{
		if (SamePTD(playertextid, g_tdRightBtn[playerid][slot]))
		{
			if (g_ElecWires_SelectedLeft[playerid] == ELEC_TD_NONE)
			{
				ElecWires_UpdateStatus(playerid, "~y~Primero elegi una FUENTE.");
				return 1;
			}
			if (g_ElecWires_DoneRight[playerid][slot])
			{
				ElecWires_UpdateStatus(playerid, "~y~Ese destino ya esta ocupado.");
				return 1;
			}

			new leftColor  = g_ElecWires_SelectedLeft[playerid];
			new rightColor = g_ElecWires_MapRight[playerid][slot];

			if (rightColor == leftColor)
			{
				// Mark done
				g_ElecWires_DoneLeft[playerid][leftColor] = true;
				g_ElecWires_DoneRight[playerid][slot] = true;
				g_ElecWires_Pairs[playerid]++;

				// DESTINO -> X
				PlayerTextDrawSetString(playerid, g_tdRightBtn[playerid][slot], "~w~[X] DESTINO");
				PlayerTextDrawColor(playerid, g_tdRightBtn[playerid][slot], 0xFFFFFFFF);
				PlayerTextDrawShow(playerid, g_tdRightBtn[playerid][slot]);

				// FUENTE -> X
				PlayerTextDrawSetString(playerid, g_tdLeftBtn[playerid][leftColor], "~w~[X] FUENTE");
				PlayerTextDrawColor(playerid, g_tdLeftBtn[playerid][leftColor], 0xFFFFFFFF);
				PlayerTextDrawShow(playerid, g_tdLeftBtn[playerid][leftColor]);

				// Row done
				PlayerTextDrawBoxColor(playerid, g_tdRowBg[playerid][leftColor], CLR_DONE);
				PlayerTextDrawShow(playerid, g_tdRowBg[playerid][leftColor]);

				g_ElecWires_SelectedLeft[playerid] = ELEC_TD_NONE;

				if (g_ElecWires_Pairs[playerid] >= ELEC_WIRES_MAX)
				{
					ElecWires_UpdateStatus(playerid, "~g~Conexion correcta! (finalizado)");
					StopElecWiresMinigame(playerid, true);
					return 1;
				}

				ElecWires_UpdateStatus(playerid, "~g~Conexion correcta!");
				ElecWires_SetLeftSelected(playerid, ELEC_TD_NONE);
				return 1;
			}
			else
			{
				ElecWires_UpdateStatus(playerid, "~r~Conexion incorrecta (corto).");
				PlayerTextDrawBoxColor(playerid, g_tdRowBg[playerid][leftColor], (WIRE_COLORS[leftColor] & 0x00FFFFFF) | (BTN_IDLE_A << 24));
				PlayerTextDrawShow(playerid, g_tdRowBg[playerid][leftColor]);
				return 1;
			}
		}
	}

	return 1;
}



hook OnPlayerDisconnect(playerid, reason)
{
	#pragma unused reason
	if (g_ElecWires_Active[playerid]) StopElecWiresMinigame(playerid, false);
	return 1;
}

CMD:testwires(playerid, params[])
{
	#pragma unused params
	StartElecWiresMinigame(playerid, 4);
	return 1;
}