#if defined _marp_atm_gui_included
	#endinput
#endif
#define _marp_atm_gui_included

#include <YSI_Coding\y_hooks>

#define ATM_INI_X 236.0
#define ATM_INI_Y 102.0

#define ATM_COLOR_GREEN (512118015)
#define ATM_COLOR_SEMIWHITE (-1061109505)
#define ATM_COLOR_RED_BUTTON (-1962934017)
#define ATM_COLOR_SELECTION_YELLOW (-3145473)

static ATM_active[MAX_PLAYERS];

static Text:ATM_TD_screen;
static Text:ATM_TD_topLeftCorner;
static Text:ATM_TD_topRightCorner;
static Text:ATM_TD_botLeftCorner;
static Text:ATM_TD_botRightCorner;
static Text:ATM_TD_grayBox;
static Text:ATM_TD_linkLogoCircle;
static Text:ATM_TD_linkLogoBackground;
static Text:ATM_TD_linkLogoText;

static PlayerText:ATM_PTD_screenText[MAX_PLAYERS];

static Text:ATM_TD_button1Frame;
static Text:ATM_TD_button2Frame;
static Text:ATM_TD_button3Frame;
static Text:ATM_TD_button4Frame;
static Text:ATM_TD_button1;
static Text:ATM_TD_button2;
static Text:ATM_TD_button3;
static Text:ATM_TD_button4;

ATM_Withdraw(playerid) {
	Dialog_Show(playerid, DLG_ATM_WITHDRAW, DIALOG_STYLE_INPUT, "Red Link", "Ingresa el monto a retirar:", "Ingresar", "Cerrar");
}

Dialog:DLG_ATM_WITHDRAW(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 0;

	new money;

	if(sscanf(inputtext, "i", money) || !Bank_PlayerWithdraw(playerid, money))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Cantidad de dinero inválida!");

	return 1;
}

ATM_Deposit(playerid) {
	Dialog_Show(playerid, DLG_ATM_DEPOSIT, DIALOG_STYLE_INPUT, "Red Link", "Ingresa el monto a depositar:", "Ingresar", "Cerrar");
}

Dialog:DLG_ATM_DEPOSIT(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 0;

	new money;

	if(sscanf(inputtext, "i", money) || !Bank_PlayerDeposit(playerid, money))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Cantidad de dinero inválida!");

	return 1;
}

ATM_Transfer(playerid) {
	Dialog_Show(playerid, DLG_ATM_TRANSFER, DIALOG_STYLE_INPUT, "Red Link", "Ingresa el destino de la transferencia\nAsegúrate de ingresarlo con el formato correcto: 'ID/Jugador cantidad'.\n \nEjemplo:\tRoberto_Martinez 4500", "Ingresar", "Cerrar");
}

Dialog:DLG_ATM_TRANSFER(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 0;

	new targetid, money;
	
	if(sscanf(inputtext, "ui", targetid, money) || !Bank_PlayerTransferTo(playerid, targetid, money))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡ID/Jugador o cantidad de dinero inválida!");

	return 1;
}

Bank_OnUpdate(playerid, new_balance, old_balance)
{
	if(ATM_active[playerid])
	{
		new str[128];
		new diff = new_balance - old_balance;

		if(diff < 0) {
			format(str, sizeof(str), "_~g~balance anterior: $%i~n~_~n~_____~r~-$%i~n~_~n~_~g~nuevo balance: $%i", old_balance, -diff, new_balance);
		} else {
			format(str, sizeof(str), "_~g~balance anterior: $%i~n~_~n~_____+$%i~n~_~n~_nuevo balance: $%i", old_balance, diff, new_balance);
		}

		PlayerTextDrawSetString(playerid, ATM_PTD_screenText[playerid], str);
		PlayerPlaySound(playerid, 45400, 0.0, 0.0, 0.0);
	}
}

hook OnPlayerClickTD(playerid, Text:clickedid)
{
	if(!ATM_active[playerid])
		return 0;

	if(clickedid == Text:INVALID_TEXT_DRAW) {
		ATM_Close(playerid, true);
	}
	else if(clickedid == ATM_TD_button1) {
		ATM_Withdraw(playerid);
		return ~1;
	}
	else if(clickedid == ATM_TD_button2) {
		ATM_Deposit(playerid);
		return ~1;
	}
	else if(clickedid == ATM_TD_button3) {
		ATM_Transfer(playerid);
		return ~1;
	}
	else if(clickedid == ATM_TD_button4) {
		ATM_Close(playerid);
		return ~1;
	}
	return 0;
}

forward ATM_Show(playerid, atmid);
public ATM_Show(playerid, atmid)
{
	new str[64];
	format(str, sizeof(str), "~g~balance: $%i", PlayerInfo[playerid][pBank]);
	PlayerTextDrawSetString(playerid, ATM_PTD_screenText[playerid], str);
	TogglePlayerControllable(playerid, false);
	ATM_ShowTextDrawsForPlayer(playerid);
	ATM_active[playerid] = 1;
	SelectTextDraw(playerid, ATM_COLOR_SELECTION_YELLOW);
	ApplyAnimationEx(playerid, "PED", "ATM", 4.0, 0, 1, 1, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	return 1;
}

ATM_Close(playerid, bool:forced = false)
{
	ATM_active[playerid] = 0; // no poner debajo del cancelSelect o lo llama 2 veces
	if(!forced) {
		CancelSelectTextDraw(playerid); // CancelSelect llama nuevamente a OnPlayerClickTextdraw
	}
	ATM_HideTextDrawsForPlayer(playerid);
	TogglePlayerControllable(playerid, true);
}

static ATM_HideTextDrawsForPlayer(playerid)
{
	TextDrawHideForPlayer(playerid, ATM_TD_screen);
	TextDrawHideForPlayer(playerid, ATM_TD_topLeftCorner);
	TextDrawHideForPlayer(playerid, ATM_TD_topRightCorner);
	TextDrawHideForPlayer(playerid, ATM_TD_botLeftCorner);
	TextDrawHideForPlayer(playerid, ATM_TD_botRightCorner);
	TextDrawHideForPlayer(playerid, ATM_TD_grayBox);
	TextDrawHideForPlayer(playerid, ATM_TD_linkLogoCircle);
	TextDrawHideForPlayer(playerid, ATM_TD_linkLogoBackground);
	TextDrawHideForPlayer(playerid, ATM_TD_linkLogoText);

	PlayerTextDrawHide(playerid, ATM_PTD_screenText[playerid]);

	TextDrawHideForPlayer(playerid, ATM_TD_button1Frame);
	TextDrawHideForPlayer(playerid, ATM_TD_button2Frame);
	TextDrawHideForPlayer(playerid, ATM_TD_button3Frame);
	TextDrawHideForPlayer(playerid, ATM_TD_button4Frame);
	TextDrawHideForPlayer(playerid, ATM_TD_button1);
	TextDrawHideForPlayer(playerid, ATM_TD_button2);
	TextDrawHideForPlayer(playerid, ATM_TD_button3);
	TextDrawHideForPlayer(playerid, ATM_TD_button4);
}

static ATM_ShowTextDrawsForPlayer(playerid)
{
	TextDrawShowForPlayer(playerid, ATM_TD_screen);
	TextDrawShowForPlayer(playerid, ATM_TD_topLeftCorner);
	TextDrawShowForPlayer(playerid, ATM_TD_topRightCorner);
	TextDrawShowForPlayer(playerid, ATM_TD_botLeftCorner);
	TextDrawShowForPlayer(playerid, ATM_TD_botRightCorner);
	TextDrawShowForPlayer(playerid, ATM_TD_grayBox);
	TextDrawShowForPlayer(playerid, ATM_TD_linkLogoCircle);
	TextDrawShowForPlayer(playerid, ATM_TD_linkLogoBackground);
	TextDrawShowForPlayer(playerid, ATM_TD_linkLogoText);

	PlayerTextDrawShow(playerid, ATM_PTD_screenText[playerid]);

	TextDrawShowForPlayer(playerid, ATM_TD_button1Frame);
	TextDrawShowForPlayer(playerid, ATM_TD_button2Frame);
	TextDrawShowForPlayer(playerid, ATM_TD_button3Frame);
	TextDrawShowForPlayer(playerid, ATM_TD_button4Frame);
	TextDrawShowForPlayer(playerid, ATM_TD_button1);
	TextDrawShowForPlayer(playerid, ATM_TD_button2);
	TextDrawShowForPlayer(playerid, ATM_TD_button3);
	TextDrawShowForPlayer(playerid, ATM_TD_button4);
}

static ATM_CreateTextDraws()
{
	ATM_TD_screen = TextDrawCreate(ATM_INI_X + 2.0, ATM_INI_Y + 2.0, "ld_dual:black");
	TextDrawFont(ATM_TD_screen, 4);
	TextDrawTextSize(ATM_TD_screen, 164.000000, 164.000000);

	ATM_TD_topLeftCorner = TextDrawCreate(ATM_INI_X, ATM_INI_Y, "ld_drv:tvcorn");
	TextDrawFont(ATM_TD_topLeftCorner, 4);
	TextDrawTextSize(ATM_TD_topLeftCorner, 84.000000, 84.000000);

	ATM_TD_topRightCorner = TextDrawCreate(ATM_INI_X + 168.0, ATM_INI_Y, "ld_drv:tvcorn");
	TextDrawFont(ATM_TD_topRightCorner, 4);
	TextDrawTextSize(ATM_TD_topRightCorner, -84.000000, 84.000000);

	ATM_TD_botLeftCorner = TextDrawCreate(ATM_INI_X, ATM_INI_Y + 168.0, "ld_drv:tvcorn");
	TextDrawFont(ATM_TD_botLeftCorner, 4);
	TextDrawTextSize(ATM_TD_botLeftCorner, 84.000000, -84.000000);

	ATM_TD_botRightCorner = TextDrawCreate(ATM_INI_X + 168.0, ATM_INI_Y + 168.0, "ld_drv:tvcorn");
	TextDrawFont(ATM_TD_botRightCorner, 4);
	TextDrawTextSize(ATM_TD_botRightCorner, -84.000000, -84.000000);

	ATM_TD_grayBox = TextDrawCreate(ATM_INI_X, ATM_INI_Y + 163.0, "ld_drv:tvbase");
	TextDrawFont(ATM_TD_grayBox, 4);
	TextDrawTextSize(ATM_TD_grayBox, 168.000000, 80.000000);

	ATM_TD_linkLogoCircle = TextDrawCreate(ATM_INI_X + 112.0, ATM_INI_Y + 6.0, "ld_beat:chit");
	TextDrawFont(ATM_TD_linkLogoCircle, 4);
	TextDrawTextSize(ATM_TD_linkLogoCircle, 47.000000, 47.000000);
	TextDrawColor(ATM_TD_linkLogoCircle, -3145473);

	ATM_TD_linkLogoBackground = TextDrawCreate(ATM_INI_X + 115.0, ATM_INI_Y + 9.0, "ld_beat:chit");
	TextDrawFont(ATM_TD_linkLogoBackground, 4);
	TextDrawTextSize(ATM_TD_linkLogoBackground, 41.000000, 41.000000);
	TextDrawColor(ATM_TD_linkLogoBackground, ATM_COLOR_GREEN);

	ATM_TD_linkLogoText = TextDrawCreate(ATM_INI_X + 147.0, ATM_INI_Y + 22.0, "BIENVENIDO A RED  LINK");
	TextDrawLetterSize(ATM_TD_linkLogoText, 0.320000, 1.600000);
	TextDrawTextSize(ATM_TD_linkLogoText, 449.000000, 0.000000);
	TextDrawSetShadow(ATM_TD_linkLogoText, 0);
	TextDrawAlignment(ATM_TD_linkLogoText, 3);
	TextDrawColor(ATM_TD_linkLogoText, -3145473);

	ATM_TD_button1Frame = TextDrawCreate(ATM_INI_X + 10.0, ATM_INI_Y + 173.0, "ld_otb2:butnc");
	TextDrawFont(ATM_TD_button1Frame, 4);
	TextDrawTextSize(ATM_TD_button1Frame, 69.000000, 41.000000);

	ATM_TD_button2Frame = TextDrawCreate(ATM_INI_X + 89.0, ATM_INI_Y + 173.0, "ld_otb2:butnc");
	TextDrawFont(ATM_TD_button2Frame, 4);
	TextDrawTextSize(ATM_TD_button2Frame, 69.000000, 41.000000);

	ATM_TD_button3Frame = TextDrawCreate(ATM_INI_X + 10.0, ATM_INI_Y + 208.0, "ld_otb2:butnc");
	TextDrawFont(ATM_TD_button3Frame, 4);
	TextDrawTextSize(ATM_TD_button3Frame, 69.000000, 41.000000);

	ATM_TD_button4Frame = TextDrawCreate(ATM_INI_X + 89.0, ATM_INI_Y + 208.0, "ld_otb2:butnc");
	TextDrawFont(ATM_TD_button4Frame, 4);
	TextDrawTextSize(ATM_TD_button4Frame, 69.000000, 41.000000);
	TextDrawColor(ATM_TD_button4Frame, -1962934017);

	ATM_TD_button1 = TextDrawCreate(ATM_INI_X + 45.0, ATM_INI_Y + 178.0, "retirar");
	TextDrawFont(ATM_TD_button1, 3);
	TextDrawLetterSize(ATM_TD_button1, 0.250000, 1.250000);
	TextDrawTextSize(ATM_TD_button1, 16.000000, 59.000000);
	TextDrawSetOutline(ATM_TD_button1, 1);
	TextDrawSetShadow(ATM_TD_button1, 0);
	TextDrawAlignment(ATM_TD_button1, 2);
	TextDrawColor(ATM_TD_button1, ATM_COLOR_GREEN);
	TextDrawSetSelectable(ATM_TD_button1, 1);

	ATM_TD_button2 = TextDrawCreate(ATM_INI_X + 124.0, ATM_INI_Y + 178.0, "depositar");
	TextDrawFont(ATM_TD_button2, 3);
	TextDrawLetterSize(ATM_TD_button2, 0.250000, 1.250000);
	TextDrawTextSize(ATM_TD_button2, 16.000000, 59.000000);
	TextDrawSetOutline(ATM_TD_button2, 1);
	TextDrawSetShadow(ATM_TD_button2, 0);
	TextDrawAlignment(ATM_TD_button2, 2);
	TextDrawColor(ATM_TD_button2, ATM_COLOR_GREEN);
	TextDrawSetSelectable(ATM_TD_button2, 1);

	ATM_TD_button3 = TextDrawCreate(ATM_INI_X + 45.0, ATM_INI_Y + 213.0, "transferir");
	TextDrawFont(ATM_TD_button3, 3);
	TextDrawLetterSize(ATM_TD_button3, 0.250000, 1.250000);
	TextDrawTextSize(ATM_TD_button3, 16.000000, 59.000000);
	TextDrawSetOutline(ATM_TD_button3, 1);
	TextDrawSetShadow(ATM_TD_button3, 0);
	TextDrawAlignment(ATM_TD_button3, 2);
	TextDrawColor(ATM_TD_button3, ATM_COLOR_GREEN);
	TextDrawSetSelectable(ATM_TD_button3, 1);

	ATM_TD_button4 = TextDrawCreate(ATM_INI_X + 124.0, ATM_INI_Y + 213.0, "salir");
	TextDrawFont(ATM_TD_button4, 3);
	TextDrawLetterSize(ATM_TD_button4, 0.250000, 1.250000);
	TextDrawTextSize(ATM_TD_button4, 16.000000, 59.000000);
	TextDrawSetOutline(ATM_TD_button4, 1);
	TextDrawSetShadow(ATM_TD_button4, 0);
	TextDrawAlignment(ATM_TD_button4, 2);
	TextDrawColor(ATM_TD_button4, ATM_COLOR_SEMIWHITE);
	TextDrawSetSelectable(ATM_TD_button4, 1);
}

hook OnPlayerDisconnect(playerid, reason)
{
	ATM_active[playerid] = 0;
	return 1;
}

hook LoadAccountDataEnded(playerid)
{
	new PlayerText:ptd = CreatePlayerTextDraw(playerid, ATM_INI_X + 15.0, ATM_INI_Y + 57.0, "_");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 0.250000, 1.250000);
	PlayerTextDrawTextSize(playerid, ptd, 377.000000, 10.000000);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	PlayerTextDrawColor(playerid, ptd, ATM_COLOR_GREEN);
	ATM_PTD_screenText[playerid] = ptd;
	return 1;
}

hook OnGameModeInitEnded()
{
	ATM_CreateTextDraws();
	return 1;
}
