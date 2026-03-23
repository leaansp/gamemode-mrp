#if defined _marp_tuning_gui_included
	#endinput
#endif
#define _marp_tuning_gui_included

#include "system\tuning\marp_tuning_data.pwn"

#include <YSI_Coding\y_hooks>

/****************************************************************************************

                       __                          __        __        
   _____ __  __ _____ / /_ ___   ____ ___     ____/ /____ _ / /_ ____ _
  / ___// / / // ___// __// _ \ / __ `__ \   / __  // __ `// __// __ `/
 (__  )/ /_/ /(__  )/ /_ /  __// / / / / /  / /_/ // /_/ // /_ / /_/ / 
/____/ \__, //____/ \__/ \___//_/ /_/ /_/   \__,_/ \__,_/ \__/ \__,_/  
      /____/                                                           


****************************************************************************************/

#define TUNING_COLOR_SELECTION_YELLOW (0xFCF023FF)

#define TUNINGGUI_MAX_AMOUNT (17)
#define TUNINGGUI_FONT_SIZE_X (0.26)
#define TUNINGGUI_DISTANCE_BETWEEN (15.70)

static TuningGUI_TuningOnMenu[MAX_PLAYERS];

enum e_TUNINGGUI_TABS 
{
    TUNINGGUI_TABS_HOME,    
    TUNINGGUI_TABS_SPOILER,
	TUNINGGUI_TABS_HOOD,
	TUNINGGUI_TABS_ROOF,
	TUNINGGUI_TABS_SIDESKIRT,
	TUNINGGUI_TABS_LAMPS,
	TUNINGGUI_TABS_NOS,
	TUNINGGUI_TABS_EXHAUST,
	TUNINGGUI_TABS_WHEEL,
	TUNINGGUI_TABS_FRONTBUMPER,
	TUNINGGUI_TABS_REARBUMBPER,
	TUNINGGUI_TABS_COLOR
}

static e_TUNINGGUI_TABS:TuningGUI_ActiveTab[MAX_PLAYERS];
static e_TUNINGGUI_TABS:TuningGUI_OpenInTab[MAX_PLAYERS];
static TuningGUI_ButExtraId[MAX_PLAYERS + 1][TUNINGGUI_MAX_AMOUNT + 1] = {{0, ...}, ...};	

enum
{
	TUNINGGUI_COLOR_NONE,
	TUNINGGUI_COLOR_ONE,
	TUNINGGUI_COLOR_TWO
}

static TuningGUI_InputColor[MAX_PLAYERS + 1] = {TUNINGGUI_COLOR_NONE, ...};
static TuningGUI_SelectedColors[MAX_PLAYERS + 1][2] = {{-1, ...}, ...};
static TuningGUI_SelectedPaintjob[MAX_PLAYERS + 1] = {3, ...};

static enum e_TUNING_CAM_DATA
{
	Float:tunCamD,
	Float:tunCamAng,
	tunCamLastMove
}

static TuningGUI_CamStartPos[MAX_PLAYERS + 1][e_TUNING_CAM_DATA];

static TuningGUI_Categories[][24] = {
	"Alerones",
	"Capots",
	"Techos",
	"Faldónes laterales",
	"Luces",
	"Nitros",
	"Caños de escapes",
	"Ruedas",
	"Radios",
	"Hidraulicos",
	"Paragolpes delanteros",
	"Paragolpes traseros",
	"Vinilos",
	"Color"
};

static TuningGUI_TotalToPay[MAX_PLAYERS];

/****************************************************************************************

   __               __       __                            
  / /_ ___   _  __ / /_ ____/ /_____ ____ _ _      __ _____
 / __// _ \ | |/_// __// __  // ___// __ `/| | /| / // ___/
/ /_ /  __/_>  < / /_ / /_/ // /   / /_/ / | |/ |/ /(__  ) 
\__/ \___//_/|_| \__/ \__,_//_/    \__,_/  |__/|__//____/  

                                                           
****************************************************************************************/

static PlayerText:TuningGUI_PTD_title[MAX_PLAYERS];
static PlayerText:TuningGUI_PTD_frame[MAX_PLAYERS];
static PlayerText:TuningGUI_PTD_spanOne[MAX_PLAYERS];
static PlayerText:TuningGUI_PTD_spanTwo[MAX_PLAYERS];

static PlayerText:TuningGUI_PTD_but[MAX_PLAYERS][TUNINGGUI_MAX_AMOUNT + 1] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...};

static PlayerText:TuningGUI_PTD_acceptBut[MAX_PLAYERS];
static PlayerText:TuningGUI_PTD_closeBut[MAX_PLAYERS];

/****************************************************************************************

                __ __ __                  __            __                   __        
  _____ ____ _ / // // /_   ____ _ _____ / /__ _____   / /_   ____   ____   / /__ _____
 / ___// __ `// // // __ \ / __ `// ___// //_// ___/  / __ \ / __ \ / __ \ / //_// ___/
/ /__ / /_/ // // // /_/ // /_/ // /__ / ,<  (__  )  / / / // /_/ // /_/ // ,<  (__  ) 
\___/ \__,_//_//_//_.___/ \__,_/ \___//_/|_|/____/  /_/ /_/ \____/ \____//_/|_|/____/  

                                                                                       
****************************************************************************************/

hook OnGameModeInitEnded() 
{
	for (new i = 0; i < sizeof(TuningGUI_Categories); i++) {
		AsciiToTextDrawString(TuningGUI_Categories[i]);
	}
	return 1;
}

hook function OnPlayerResetStats(playerid)
{
	TuningGUI_PTD_frame[playerid] = PlayerText:INVALID_TEXT_DRAW;
	TuningGUI_ResetVariables(playerid);

	return continue(playerid);
}

hook OnPlayerClickTD(playerid, Text:clickedid)
{
	if(!TuningGUI_TuningOnMenu[playerid])
		return 0;

	return 0;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(!TuningGUI_TuningOnMenu[playerid])
		return 0;

	if(playertextid == TuningGUI_PTD_closeBut[playerid])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_Close(playerid);
			default: TuningGUI_Close(playerid);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_acceptBut[playerid])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_ShowConfirmMenu(playerid);
			default: TuningGUI_SelectHomeMenu(playerid);
		}
		return 1;
	}
	
	if(playertextid == TuningGUI_PTD_but[playerid][0])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectSpoilerMenu(playerid);
			case TUNINGGUI_TABS_COLOR: TuningGUI_ShowEditColorMenu(playerid, TUNINGGUI_COLOR_ONE);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][0]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][1])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectHoodsMenu(playerid);
			case TUNINGGUI_TABS_COLOR: TuningGUI_ShowEditColorMenu(playerid, TUNINGGUI_COLOR_TWO);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][1]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][2])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectRoofsMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][2]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][3])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectSidesMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][3]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][4])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectLampsMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][4]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][5])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectNosMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][5]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][6])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectExhaustMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][6]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][7])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectWheelsMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][7]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][8])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectRadio(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][8]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][9])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectHydraulics(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][9]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][10])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectFBumperMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][10]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][11])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectRBumperMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][11]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][12])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectPainjobMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][12]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][13])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectColorsMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][13]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][14])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectHomeMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][14]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][15])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectHomeMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][15]);
		}
		return 1;
	}

	if(playertextid == TuningGUI_PTD_but[playerid][16])
	{
		switch(TuningGUI_ActiveTab[playerid])
		{
			case TUNINGGUI_TABS_HOME: TuningGUI_SelectHomeMenu(playerid);
			default: AddVehicleComponent(GetPlayerVehicleID(playerid), TuningGUI_ButExtraId[playerid][16]);
		}
		return 1;
	}

	return 0;
}

hook OnPlayerUpdate(playerid)
{
	if(!TuningGUI_TuningOnMenu[playerid])
		return 1;

	new Keys, ud, lr;
    GetPlayerKeys(playerid, Keys, ud, lr);

	if(!lr || ((gettime() - TuningGUI_CamStartPos[playerid][tunCamLastMove]) < 1)) 
		return 1;
	
	TuningGUI_CamStartPos[playerid][tunCamAng] = NormalizeAngle(TuningGUI_CamStartPos[playerid][tunCamAng]);

	if(lr == KEY_LEFT) {
		TuningGUI_CamStartPos[playerid][tunCamAng] = TuningGUI_CamStartPos[playerid][tunCamAng] - 15;
	} else if(lr == KEY_RIGHT) {
		TuningGUI_CamStartPos[playerid][tunCamAng] = TuningGUI_CamStartPos[playerid][tunCamAng] + 15;
	}

	new Float:playerpos[3];
	GetPlayerPos(playerid, playerpos[0], playerpos[1], playerpos[2]);

	new Float:campos[3];
	GetPlayerCameraPos(playerid, campos[0], campos[1], campos[2]);

	new Float:newcampos[2];
	newcampos[0] = playerpos[0] + TuningGUI_CamStartPos[playerid][tunCamD]*floatcos(TuningGUI_CamStartPos[playerid][tunCamAng], degrees);
	newcampos[1] = playerpos[1] + TuningGUI_CamStartPos[playerid][tunCamD]*floatsin(TuningGUI_CamStartPos[playerid][tunCamAng], degrees);

	SetPlayerCameraPos(playerid, newcampos[0], newcampos[1], campos[2]);
	SetPlayerCameraLookAt(playerid, playerpos[0], playerpos[1], playerpos[2], CAMERA_MOVE);
		
	TuningGUI_CamStartPos[playerid][tunCamLastMove] = gettime();
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!TuningGUI_TuningOnMenu[playerid])
		return 1;

	if((newkeys & KEY_NO) && !(oldkeys & KEY_NO)) {
		SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);
	}
	return 1;
}

/****************************************************************************************

  _____ ____   ____ ___   ____ ___   ____   ____ 
 / ___// __ \ / __ `__ \ / __ `__ \ / __ \ / __ |
/ /__ / /_/ // / / / / // / / / / // /_/ // / / /
\___/ \____//_/ /_/ /_//_/ /_/ /_/ \____//_/ /_/ 
                                                 

****************************************************************************************/

TuningGUI_ResetVariables(playerid)
{
	TuningGUI_TuningOnMenu[playerid] = 0;
	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_HOME;
	TuningGUI_OpenInTab[playerid] = TUNINGGUI_TABS_HOME;

	TuningGUI_CamStartPos[playerid] = TuningGUI_CamStartPos[MAX_PLAYERS];
	TuningGUI_SelectedColors[playerid] = TuningGUI_SelectedColors[MAX_PLAYERS];
	TuningGUI_ButExtraId[playerid] = TuningGUI_ButExtraId[MAX_PLAYERS];
	TuningGUI_SelectedPaintjob[playerid] = TuningGUI_SelectedPaintjob[MAX_PLAYERS];
	TuningGUI_InputColor[playerid] = TuningGUI_InputColor[MAX_PLAYERS];
	TuningGUI_TotalToPay[playerid] = 0;
}

TuningGUI_CreatePTDIfNotExist(playerid)
{
	if(TuningGUI_PTD_frame[playerid] == PlayerText:INVALID_TEXT_DRAW) // creo a demanda la primera vez que ejecuta, si nunca lo usa no se crea.
	{
		TuningGUI_CreateMenuFrame(playerid);
		TuningGUI_CreateHomeMenu(playerid);
	}	
}

TuningGUI_Open(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Debes estar en un vehículo para usar este comando!");

	SendClientMessage(playerid, -1, "Usa ESC para poder mover la camara con '~k~~VEHICLE_STEERLEFT~' o '~k~~VEHICLE_STEERRIGHT~'. Con '~k~~CONVERSATION_NO~' reestableces el foco.");
	TuningGUI_StartCamera(playerid);
	TogglePlayerControllable(playerid, false);
	TuningGUI_ShowMenuFrame(playerid);
	TuningGUI_ShowHomeMenu(playerid);

	TuningGUI_TuningOnMenu[playerid] = 1;
	return 1;
}

TuningGUI_Close(playerid)
{
	TuningGUI_TuningOnMenu[playerid] = 0; // no poner debajo del cancelSelect o lo llama 2 veces
	CancelSelectTextDraw(playerid); // CancelSelect llama nuevamente a OnPlayerClickTextdraw

	TuningGUI_HideMenuFrame(playerid);
	TuningGUI_HideHomeMenu(playerid);

	TogglePlayerControllable(playerid, true);

	TuningGUI_HideButs(playerid);
	SetCameraBehindPlayer(playerid);
	TuningGUI_ResetVariables(playerid);

	new vehicleid = GetPlayerVehicleID(playerid);
	new seatid = GetPlayerVehicleSeat(playerid);

	new vworld = GetVehicleVirtualWorld(vehicleid); 
	new interior = GetPlayerInterior(playerid);
	new Float:vehX, Float:vehY, Float:vehZ, Float:ang;
	
	GetVehiclePos(vehicleid, vehX, vehY, vehZ);
	GetVehicleZAngle(vehicleid, ang);

	Veh_RecreateWithUpdatedParams(vehicleid);

	TeleportPlayerTo(playerid, vehX, vehY, vehZ, ang, Veh_GetInterior(vehicleid), GetVehicleVirtualWorld(vehicleid));
	PutPlayerInVehicle(playerid, vehicleid, seatid);
	TeleportVehicleTo(vehicleid, vehX, vehY, vehZ, ang, interior, vworld);
}

TuningGUI_HideButs(playerid)
{
	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawHide(playerid, TuningGUI_PTD_but[playerid][i]);
		PlayerTextDrawDestroy(playerid, TuningGUI_PTD_but[playerid][i]);
	}
}

TuningGUI_CreateBut(playerid, butid, const str[])
{

	PlayerTextDrawDestroy(playerid, TuningGUI_PTD_but[playerid][butid]);

	new Float:fontsize = 3.9 / strlen(str);

	if (fontsize > TUNINGGUI_FONT_SIZE_X) {
		fontsize = TUNINGGUI_FONT_SIZE_X;
	}

	TuningGUI_PTD_but[playerid][butid] = CreatePlayerTextDraw(playerid, 556.000000, 106.000000 + butid * TUNINGGUI_DISTANCE_BETWEEN, str);
	PlayerTextDrawFont(playerid, TuningGUI_PTD_but[playerid][butid], 1);
	PlayerTextDrawLetterSize(playerid, TuningGUI_PTD_but[playerid][butid], fontsize, 1.200000);
	PlayerTextDrawTextSize(playerid, TuningGUI_PTD_but[playerid][butid], 10.000000, 90.000000);
	PlayerTextDrawSetOutline(playerid, TuningGUI_PTD_but[playerid][butid], 1);
	PlayerTextDrawSetShadow(playerid, TuningGUI_PTD_but[playerid][butid], 0);
	PlayerTextDrawAlignment(playerid, TuningGUI_PTD_but[playerid][butid], 2);
	PlayerTextDrawColor(playerid, TuningGUI_PTD_but[playerid][butid], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningGUI_PTD_but[playerid][butid], 255);
	PlayerTextDrawBoxColor(playerid, TuningGUI_PTD_but[playerid][butid], 200);
	PlayerTextDrawUseBox(playerid, TuningGUI_PTD_but[playerid][butid], 1);
	PlayerTextDrawSetProportional(playerid, TuningGUI_PTD_but[playerid][butid], 1);
	PlayerTextDrawSetSelectable(playerid, TuningGUI_PTD_but[playerid][butid], 1);
}

TuningGUI_StartCamera(playerid)
{
	new Float:campos[3];
	GetPlayerCameraPos(playerid, campos[0], campos[1], campos[2]);

	new Float:playerpos[3];
	GetPlayerPos(playerid, playerpos[0], playerpos[1], playerpos[2]);

	TuningGUI_CamStartPos[playerid][tunCamD] = GetDistance3D(playerpos[0], playerpos[1], playerpos[2], campos[0], campos[1], campos[2]);
	TuningGUI_CamStartPos[playerid][tunCamAng] = atan2(campos[1] - playerpos[1], campos[0] - playerpos[0]);

	new Float:newcampos[2];
	newcampos[0] = playerpos[0] + TuningGUI_CamStartPos[playerid][tunCamD]*floatcos(TuningGUI_CamStartPos[playerid][tunCamAng], degrees);
	newcampos[1] = playerpos[1] + TuningGUI_CamStartPos[playerid][tunCamD]*floatsin(TuningGUI_CamStartPos[playerid][tunCamAng], degrees);

	SetPlayerCameraPos(playerid, newcampos[0], newcampos[1], campos[2]);
	SetPlayerCameraLookAt(playerid, playerpos[0], playerpos[1], playerpos[2]);
}

TuningGUI_ShowConfirmMenu(playerid) 
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new price = 0;

	for (new slot = 0; slot < 14; slot++)
	{
		if(GetVehicleComponentInSlot(vehicleid, slot) != VehicleInfo[vehicleid][VehCompSlot][slot]) {
			price++;
		}
	}
	
	if(TuningGUI_SelectedColors[playerid][0] != -1 || TuningGUI_SelectedColors[playerid][1] != -1) {
		price++;
	}

	if(0 <= TuningGUI_SelectedPaintjob[playerid] <= 2) {
		price++;
	}

	if(!price)
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "No se seleccionó ninguna pieza.");

	if(Mec_GetBizTuningParts(playerid) < price)
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡No hay piezas suficientes!");

	TuningGUI_TotalToPay[playerid] = price * Mec_GetPriceForTuning(playerid);

	if(GetPlayerCash(playerid) <= TuningGUI_TotalToPay[playerid] && PlayerInfo[playerid][pBank] <= TuningGUI_TotalToPay[playerid])
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "No tienes el dinero suficiente.");

	TuningGUI_HideMenuFrame(playerid);
	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_HideButs(playerid);

	new str[128];
	format(str, sizeof(str), " ¿Instalar piezas de tuneo por $%i?", TuningGUI_TotalToPay[playerid]);

	Dialog_Open(playerid, "DLG_TUNINGGUI_CONFIRM", DIALOG_STYLE_MSGBOX, "Confirmar tuneo", str, "Si", "No");
	return 1;
}

Dialog:DLG_TUNINGGUI_CONFIRM(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		SendClientMessage(playerid, -1, "Cancelaste la instalación de las piezas de tuneo.");
		TuningGUI_Close(playerid);
	} 
	else 
	{
		Mec_PayTuning(playerid, TuningGUI_TotalToPay[playerid]);
	}
	return 1;
}

TuningGUI_OnTuningPayed(playerid)
{
	Veh_SaveTuning(GetPlayerVehicleID(playerid), TuningGUI_SelectedColors[playerid][0], TuningGUI_SelectedColors[playerid][1], TuningGUI_SelectedPaintjob[playerid]);
	TuningGUI_Close(playerid);
}

TuningGUI_IsTuning(playerid) {
	return TuningGUI_TuningOnMenu[playerid];
}

/****************************************************************************************

                                  ____
   ____ ___  ___  ____  __  __   / __/________ _____ ___  ___
  / __ `__ \/ _ \/ __ \/ / / /  / /_/ ___/ __ `/ __ `__ \/ _ \
 / / / / / /  __/ / / / /_/ /  / __/ /  / /_/ / / / / / /  __/
/_/ /_/ /_/\___/_/ /_/\__,_/  /_/ /_/   \__,_/_/ /_/ /_/\___/


****************************************************************************************/

TuningGUI_CreateMenuFrame(playerid)
{
	TuningGUI_PTD_frame[playerid] = CreatePlayerTextDraw(playerid, 556.000000, 79.000000, "_");
	PlayerTextDrawFont(playerid, TuningGUI_PTD_frame[playerid], 1);
	PlayerTextDrawLetterSize(playerid, TuningGUI_PTD_frame[playerid], 0.500000, 35.800010);
	PlayerTextDrawTextSize(playerid, TuningGUI_PTD_frame[playerid], 296.000000, 104.000000);
	PlayerTextDrawSetOutline(playerid, TuningGUI_PTD_frame[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TuningGUI_PTD_frame[playerid], 0);
	PlayerTextDrawAlignment(playerid, TuningGUI_PTD_frame[playerid], 2);
	PlayerTextDrawColor(playerid, TuningGUI_PTD_frame[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningGUI_PTD_frame[playerid], 255);
	PlayerTextDrawBoxColor(playerid, TuningGUI_PTD_frame[playerid], 135);
	PlayerTextDrawUseBox(playerid, TuningGUI_PTD_frame[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TuningGUI_PTD_frame[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, TuningGUI_PTD_frame[playerid], 0);

	TuningGUI_PTD_title[playerid] = CreatePlayerTextDraw(playerid, 556.000000, 79.000000, "Menu tuneo");
	PlayerTextDrawFont(playerid, TuningGUI_PTD_title[playerid], 0);
	PlayerTextDrawLetterSize(playerid, TuningGUI_PTD_title[playerid], 0.250000, 1.600000);
	PlayerTextDrawTextSize(playerid, TuningGUI_PTD_title[playerid], 417.000000, 120.000000);
	PlayerTextDrawSetOutline(playerid, TuningGUI_PTD_title[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TuningGUI_PTD_title[playerid], 0);
	PlayerTextDrawAlignment(playerid, TuningGUI_PTD_title[playerid], 2);
	PlayerTextDrawColor(playerid, TuningGUI_PTD_title[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningGUI_PTD_title[playerid], 255);
	PlayerTextDrawBoxColor(playerid, TuningGUI_PTD_title[playerid], 50);
	PlayerTextDrawUseBox(playerid, TuningGUI_PTD_title[playerid], 0);
	PlayerTextDrawSetProportional(playerid, TuningGUI_PTD_title[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, TuningGUI_PTD_title[playerid], 0);

	TuningGUI_PTD_spanOne[playerid] = CreatePlayerTextDraw(playerid, 556.000000, 100.000000, "_");
	PlayerTextDrawFont(playerid, TuningGUI_PTD_spanOne[playerid], 1);
	PlayerTextDrawLetterSize(playerid, TuningGUI_PTD_spanOne[playerid], 0.500000, 0.000000);
	PlayerTextDrawTextSize(playerid, TuningGUI_PTD_spanOne[playerid], 296.000000, 104.000000);
	PlayerTextDrawSetOutline(playerid, TuningGUI_PTD_spanOne[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TuningGUI_PTD_spanOne[playerid], 0);
	PlayerTextDrawAlignment(playerid, TuningGUI_PTD_spanOne[playerid], 2);
	PlayerTextDrawColor(playerid, TuningGUI_PTD_spanOne[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningGUI_PTD_spanOne[playerid], 255);
	PlayerTextDrawBoxColor(playerid, TuningGUI_PTD_spanOne[playerid], 255);
	PlayerTextDrawUseBox(playerid, TuningGUI_PTD_spanOne[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TuningGUI_PTD_spanOne[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, TuningGUI_PTD_spanOne[playerid], 0);

	TuningGUI_PTD_spanTwo[playerid] = CreatePlayerTextDraw(playerid, 556.000000, 375.000000, "_");
	PlayerTextDrawFont(playerid, TuningGUI_PTD_spanTwo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, TuningGUI_PTD_spanTwo[playerid], 0.500000, 0.000000);
	PlayerTextDrawTextSize(playerid, TuningGUI_PTD_spanTwo[playerid], 296.000000, 104.000000);
	PlayerTextDrawSetOutline(playerid, TuningGUI_PTD_spanTwo[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TuningGUI_PTD_spanTwo[playerid], 0);
	PlayerTextDrawAlignment(playerid, TuningGUI_PTD_spanTwo[playerid], 2);
	PlayerTextDrawColor(playerid, TuningGUI_PTD_spanTwo[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningGUI_PTD_spanTwo[playerid], 255);
	PlayerTextDrawBoxColor(playerid, TuningGUI_PTD_spanTwo[playerid], 255);
	PlayerTextDrawUseBox(playerid, TuningGUI_PTD_spanTwo[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TuningGUI_PTD_spanTwo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, TuningGUI_PTD_spanTwo[playerid], 0);
}

TuningGUI_ShowMenuFrame(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_frame[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_spanOne[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_spanTwo[playerid]);
}

TuningGUI_HideMenuFrame(playerid)
{
	PlayerTextDrawHide(playerid, TuningGUI_PTD_title[playerid]);
	PlayerTextDrawHide(playerid, TuningGUI_PTD_frame[playerid]);
	PlayerTextDrawHide(playerid, TuningGUI_PTD_spanOne[playerid]);
	PlayerTextDrawHide(playerid, TuningGUI_PTD_spanTwo[playerid]);
}

/****************************************************************************************

    __                                                            
   / /_   ____   ____ ___   ___     ____ ___   ___   ____   __  __
  / __ \ / __ \ / __ `__ \ / _ \   / __ `__ \ / _ \ / __ \ / / / /
 / / / // /_/ // / / / / //  __/  / / / / / //  __// / / // /_/ / 
/_/ /_/ \____//_/ /_/ /_/ \___/  /_/ /_/ /_/ \___//_/ /_/ \__,_/  

                                                                  
****************************************************************************************/

TuningGUI_CreateHomeMenu(playerid)
{
	TuningGUI_PTD_acceptBut[playerid] = CreatePlayerTextDraw(playerid, 530.000000, 384.000000, "Confirmar");
	PlayerTextDrawFont(playerid, TuningGUI_PTD_acceptBut[playerid], 0);
	PlayerTextDrawLetterSize(playerid, TuningGUI_PTD_acceptBut[playerid], 0.250000, 1.299999);
	PlayerTextDrawTextSize(playerid, TuningGUI_PTD_acceptBut[playerid], 10.000000, 38.000000);
	PlayerTextDrawSetOutline(playerid, TuningGUI_PTD_acceptBut[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TuningGUI_PTD_acceptBut[playerid], 0);
	PlayerTextDrawAlignment(playerid, TuningGUI_PTD_acceptBut[playerid], 2);
	PlayerTextDrawColor(playerid, TuningGUI_PTD_acceptBut[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningGUI_PTD_acceptBut[playerid], 255);
	PlayerTextDrawBoxColor(playerid, TuningGUI_PTD_acceptBut[playerid], 200);
	PlayerTextDrawUseBox(playerid, TuningGUI_PTD_acceptBut[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TuningGUI_PTD_acceptBut[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, TuningGUI_PTD_acceptBut[playerid], 1);

	TuningGUI_PTD_closeBut[playerid] = CreatePlayerTextDraw(playerid, 582.000000, 384.000000, "Cerrar");
	PlayerTextDrawFont(playerid, TuningGUI_PTD_closeBut[playerid], 0);
	PlayerTextDrawLetterSize(playerid, TuningGUI_PTD_closeBut[playerid], 0.250000, 1.299999);
	PlayerTextDrawTextSize(playerid, TuningGUI_PTD_closeBut[playerid], 10.000000, 38.000000);
	PlayerTextDrawSetOutline(playerid, TuningGUI_PTD_closeBut[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TuningGUI_PTD_closeBut[playerid], 0);
	PlayerTextDrawAlignment(playerid, TuningGUI_PTD_closeBut[playerid], 2);
	PlayerTextDrawColor(playerid, TuningGUI_PTD_closeBut[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningGUI_PTD_closeBut[playerid], 255);
	PlayerTextDrawBoxColor(playerid, TuningGUI_PTD_closeBut[playerid], 200);
	PlayerTextDrawUseBox(playerid, TuningGUI_PTD_closeBut[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TuningGUI_PTD_closeBut[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, TuningGUI_PTD_closeBut[playerid], 1);
}

TuningGUI_RenderHomeMenuButs(playerid)
{
	for (new i = 0; i < sizeof(TuningGUI_Categories); i++) {
		TuningGUI_CreateBut(playerid, i, TuningGUI_Categories[i]);
	}
}

TuningGUI_ShowHomeMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	TuningGUI_RenderHomeMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], "Menu de tueno");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Confirmar");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");
    
	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);
	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_HOME;
}

TuningGUI_HideHomeMenu(playerid, bool:onclose = false)
{
	PlayerTextDrawHide(playerid, TuningGUI_PTD_title[playerid]);

	if(!onclose) {
		TuningGUI_HideButs(playerid);
	}

	PlayerTextDrawHide(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawHide(playerid, TuningGUI_PTD_closeBut[playerid]);
}

TuningGUI_SelectHomeMenu(playerid)
{
	TuningGUI_ButExtraId[playerid] = TuningGUI_ButExtraId[TUNINGGUI_MAX_AMOUNT];
	TuningGUI_HideButs(playerid);
	TuningGUI_ShowHomeMenu(playerid);
}

/****************************************************************************************

                     _ __
   _________  ____  (_) /__  __________   ____ ___  ___  ____  __  __
  / ___/ __ \/ __ \/ / / _ \/ ___/ ___/  / __ `__ \/ _ \/ __ \/ / / /
 (__  ) /_/ / /_/ / / /  __/ /  (__  )  / / / / / /  __/ / / / /_/ /
/____/ .___/\____/_/_/\___/_/  /____/  /_/ /_/ /_/\___/_/ /_/\__,_/
    /_/

****************************************************************************************/

TuningGUI_RenderSpoiMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningSpoilersData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningSpoilersData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningSpoilersData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowSpoilerMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderSpoiMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[0]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_SPOILER;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}		
}

TuningGUI_SelectSpoilerMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowSpoilerMenu(playerid);
	return 1;
}

/****************************************************************************************

    __                    __
   / /_  ____  ____  ____/ /____   ____ ___  ___  ____  __  __
  / __ \/ __ \/ __ \/ __  / ___/  / __ `__ \/ _ \/ __ \/ / / /
 / / / / /_/ / /_/ / /_/ (__  )  / / / / / /  __/ / / / /_/ /
/_/ /_/\____/\____/\__,_/____/  /_/ /_/ /_/\___/_/ /_/\__,_/


****************************************************************************************/

TuningGUI_RenderHoodMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningHoodsData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningHoodsData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningHoodsData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowHoodsMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderHoodMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[1]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_HOOD;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}
}

TuningGUI_SelectHoodsMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowHoodsMenu(playerid);
	return 1;
}

/****************************************************************************************

                     ____
   _________  ____  / __/____   ____ ___  ___  ____  __  __
  / ___/ __ \/ __ \/ /_/ ___/  / __ `__ \/ _ \/ __ \/ / / /
 / /  / /_/ / /_/ / __(__  )  / / / / / /  __/ / / / /_/ /
/_/   \____/\____/_/ /____/  /_/ /_/ /_/\___/_/ /_/\__,_/


****************************************************************************************/

TuningGUI_RenderRoofMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningRoofsData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningRoofsData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningRoofsData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowRoofsMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderRoofMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[2]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_ROOF;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}
}

TuningGUI_SelectRoofsMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowRoofsMenu(playerid);
	return 1;
}

/****************************************************************************************

         _     __          __   _      __
   _____(_)___/ /__  _____/ /__(_)____/ /______   ____ ___  ___  ____  __  __
  / ___/ / __  / _ \/ ___/ //_/ / ___/ __/ ___/  / __ `__ \/ _ \/ __ \/ / / /
 (__  ) / /_/ /  __(__  ) ,< / / /  / /_(__  )  / / / / / /  __/ / / / /_/ /
/____/_/\__,_/\___/____/_/|_/_/_/   \__/____/  /_/ /_/ /_/\___/_/ /_/\__,_/


****************************************************************************************/

TuningGUI_RenderSideMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningSideskirtsData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningSideskirtsData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningSideskirtsData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowSidesMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderSideMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[3]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_SIDESKIRT;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}
}

TuningGUI_SelectSidesMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowSidesMenu(playerid);
	return 1;
}

/****************************************************************************************

    __
   / /___ _____ ___  ____  _____   ____ ___  ___  ____  __  __
  / / __ `/ __ `__ \/ __ \/ ___/  / __ `__ \/ _ \/ __ \/ / / /
 / / /_/ / / / / / / /_/ (__  )  / / / / / /  __/ / / / /_/ /
/_/\__,_/_/ /_/ /_/ .___/____/  /_/ /_/ /_/\___/_/ /_/\__,_/
                 /_/

****************************************************************************************/

TuningGUI_RenderLampMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningLampsData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningLampsData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningLampsData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowLampsMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderLampMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[4]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_LAMPS;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}
}

TuningGUI_SelectLampsMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowLampsMenu(playerid);
	return 1;
}

/****************************************************************************************


   ____  ____  _____   ____ ___  ___  ____  __  __
  / __ \/ __ \/ ___/  / __ `__ \/ _ \/ __ \/ / / /
 / / / / /_/ (__  )  / / / / / /  __/ / / / /_/ /
/_/ /_/\____/____/  /_/ /_/ /_/\___/_/ /_/\__,_/


****************************************************************************************/

TuningGUI_RenderNosMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningNitroData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningNitroData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningNitroData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowNosMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderNosMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[5]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_NOS;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}
}

TuningGUI_SelectNosMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowNosMenu(playerid);
	return 1;
}

/****************************************************************************************

             __                     __
  ___  _  __/ /_  ____ ___  _______/ /______   ____ ___  ___  ____  __  __
 / _ \| |/_/ __ \/ __ `/ / / / ___/ __/ ___/  / __ `__ \/ _ \/ __ \/ / / /
/  __/>  </ / / / /_/ / /_/ (__  ) /_(__  )  / / / / / /  __/ / / / /_/ /
\___/_/|_/_/ /_/\__,_/\__,_/____/\__/____/  /_/ /_/ /_/\___/_/ /_/\__,_/


****************************************************************************************/

TuningGUI_RenderExhsMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningExhaustsData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningExhaustsData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningExhaustsData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowExhaustMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderExhsMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[6]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_EXHAUST;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}
}

TuningGUI_SelectExhaustMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowExhaustMenu(playerid);
	return 1;
}

/****************************************************************************************

           __              __
 _      __/ /_  ___  ___  / /____   ____ ___  ___  ____  __  __
| | /| / / __ \/ _ \/ _ \/ / ___/  / __ `__ \/ _ \/ __ \/ / / /
| |/ |/ / / / /  __/  __/ (__  )  / / / / / /  __/ / / / /_/ / 
|__/|__/_/ /_/\___/\___/_/____/  /_/ /_/ /_/\___/_/ /_/\__,_/  


****************************************************************************************/

TuningGUI_RenderWhlsMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningWheelsData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningWheelsData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningWheelsData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowWheelsMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderWhlsMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[7]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_WHEEL;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}
}

TuningGUI_SelectWheelsMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowWheelsMenu(playerid);
	return 1;
}

/**********************************************************************************************************

    ____                 __     __
   / __/________  ____  / /_   / /_  __  ______ ___  ____  ___  __________   ____ ___  ___  ____  __  __
  / /_/ ___/ __ \/ __ \/ __/  / __ \/ / / / __ `__ \/ __ \/ _ \/ ___/ ___/  / __ `__ \/ _ \/ __ \/ / / /
 / __/ /  / /_/ / / / / /_   / /_/ / /_/ / / / / / / /_/ /  __/ /  (__  )  / / / / / /  __/ / / / /_/ /
/_/ /_/   \____/_/ /_/\__/  /_.___/\__,_/_/ /_/ /_/ .___/\___/_/  /____/  /_/ /_/ /_/\___/_/ /_/\__,_/
                                                 /_/

*********************************************************************************************************/

TuningGUI_RenderFbumMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningFrontBumpersData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningFrontBumpersData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningFrontBumpersData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowFBumperMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderFbumMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[10]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_FRONTBUMPER;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}
}

TuningGUI_SelectFBumperMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowFBumperMenu(playerid);
	return 1;
}

/**************************************************************************************************************

                            __
   ________  ____ ______   / /_  __  ______ ___  ____  ___  __________   ____ ___  ___  ____  __  __
  / ___/ _ \/ __ `/ ___/  / __ \/ / / / __ `__ \/ __ \/ _ \/ ___/ ___/  / __ `__ \/ _ \/ __ \/ / / /
 / /  /  __/ /_/ / /     / /_/ / /_/ / / / / / / /_/ /  __/ /  (__  )  / / / / / /  __/ / / / /_/ /
/_/   \___/\__,_/_/     /_.___/\__,_/_/ /_/ /_/ .___/\___/_/  /____/  /_/ /_/ /_/\___/_/ /_/\__,_/
                                             /_/

***************************************************************************************************************/

TuningGUI_RenderRbumMenuButs(playerid)
{
	new but;

	for (new i = 0; i < sizeof(TuningRearBumpersData); i++)
	{
		new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

		new modelid = TuningRearBumpersData[i][e_TUN_PART_ID];
		new modsrt[TUNING_PART_MAX_NAME_LEN];
		strcopy(modsrt, TuningRearBumpersData[i][e_TUN_PART_NAME]);
		AsciiToTextDrawString(modsrt);

		if(TuningPartsData[modelid - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET])
		{
			TuningGUI_CreateBut(playerid, but, modsrt);

			TuningGUI_ButExtraId[playerid][but] = modelid;
			but++;
		} 		
	}
	return but;
}

TuningGUI_ShowRBumperMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	new buts = TuningGUI_RenderRbumMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[11]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_REARBUMBPER;

	if(!buts)
	{
		TuningGUI_SelectHomeMenu(playerid);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");
	}
}

TuningGUI_SelectRBumperMenu(playerid)
{
	if(!Tuning_IsVehModelSituable(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowRBumperMenu(playerid);
	return 1;
}

/****************************************************************************************

              __
  _________  / /___  __________   ____ ___  ___  ____  __  __
 / ___/ __ \/ / __ \/ ___/ ___/  / __ `__ \/ _ \/ __ \/ / / /
/ /__/ /_/ / / /_/ / /  (__  )  / / / / / /  __/ / / / /_/ / 
\___/\____/_/\____/_/  /____/  /_/ /_/ /_/\___/_/ /_/\__,_/  


****************************************************************************************/

TuningGUI_RenderColorMenuButs(playerid)
{
	TuningGUI_CreateBut(playerid, 0, "Color primario");
	TuningGUI_CreateBut(playerid, 1, "Color secundario");
}

TuningGUI_ShowColorsMenu(playerid)
{
	TuningGUI_CreatePTDIfNotExist(playerid);
	TuningGUI_RenderColorMenuButs(playerid);

	PlayerTextDrawSetString(playerid, TuningGUI_PTD_title[playerid], TuningGUI_Categories[13]);
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_acceptBut[playerid], "Atras");
	PlayerTextDrawSetString(playerid, TuningGUI_PTD_closeBut[playerid], "Cerrar");

	PlayerTextDrawShow(playerid, TuningGUI_PTD_title[playerid]);

	for (new i = 0; i < TUNINGGUI_MAX_AMOUNT; i++)
	{
		PlayerTextDrawShow(playerid, TuningGUI_PTD_but[playerid][i]);
	}

	PlayerTextDrawShow(playerid, TuningGUI_PTD_acceptBut[playerid]);
	PlayerTextDrawShow(playerid, TuningGUI_PTD_closeBut[playerid]);

	SelectTextDraw(playerid, TUNING_COLOR_SELECTION_YELLOW);

	TuningGUI_ActiveTab[playerid] = TUNINGGUI_TABS_COLOR;
}

TuningGUI_SelectColorsMenu(playerid)
{
	TuningGUI_HideHomeMenu(playerid);
	TuningGUI_ShowColorsMenu(playerid);
	return 1;
}

TuningGUI_ShowEditColorMenu(playerid, color = TUNINGGUI_COLOR_NONE)
{
	TuningGUI_InputColor[playerid] = color;

	new str[20];

	switch(color)
	{
		case TUNINGGUI_COLOR_ONE: strcopy(str, "Color primario");
		case TUNINGGUI_COLOR_TWO: strcopy(str, "Color secundario");
		default: return 1;
	}

	if(TuningGUI_SelectedColors[playerid][0] == -1) // Primera vez ingresando al menu.
	{
		TuningGUI_SelectedColors[playerid][0] = VehicleInfo[GetPlayerVehicleID(playerid)][VehColor1];
		TuningGUI_SelectedColors[playerid][1] = VehicleInfo[GetPlayerVehicleID(playerid)][VehColor2];
	}

	Dialog_Open(playerid, "DLG_TUNINGGUI_COLOR", DIALOG_STYLE_INPUT, str, "Ingresa un valor entre 0 y 255.", "Ingresar", "Volver");
	return 1;
}

Dialog:DLG_TUNINGGUI_COLOR(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;
	
	new color;
	if(sscanf(inputtext, "i", color) || !(0 <= color <= 255))
		return TuningGUI_ShowEditColorMenu(playerid, TuningGUI_InputColor[playerid]);

	new vehicleid = GetPlayerVehicleID(playerid);

	switch(TuningGUI_InputColor[playerid])
	{
		case TUNINGGUI_COLOR_ONE: ChangeVehicleColor(vehicleid, color, TuningGUI_SelectedColors[playerid][1]);
		case TUNINGGUI_COLOR_TWO: ChangeVehicleColor(vehicleid, TuningGUI_SelectedColors[playerid][0], color);
		default: return 1;
	}

	TuningGUI_SelectedColors[playerid][TuningGUI_InputColor[playerid] - 1] = color;
	TuningGUI_InputColor[playerid] = TUNINGGUI_COLOR_NONE;
	return 1;
}

/****************************************************************************************

                 _       __    _       __       __          __  __
    ____  ____ _(_)___  / /_  (_)___  / /_     / /_  __  __/ /_/ /_____  ____
   / __ \/ __ `/ / __ \/ __/ / / __ \/ __ \   / __ \/ / / / __/ __/ __ \/ __ \
  / /_/ / /_/ / / / / / /_  / / /_/ / /_/ /  / /_/ / /_/ / /_/ /_/ /_/ / / / /
 / .___/\__,_/_/_/ /_/\__/_/ /\____/_.___/  /_.___/\__,_/\__/\__/\____/_/ /_/
/_/                     /___/

****************************************************************************************/

TuningGUI_SelectPainjobMenu(playerid)
{
	if(!Tuning_VehModelHasPaintJob(GetVehicleModel(GetPlayerVehicleID(playerid))))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	Dialog_Open(playerid, "DLG_TUNINGGUI_PAINTJOB", DIALOG_STYLE_INPUT, "Capa de pintura", "Ingresa un valor entre 0 y 2.", "Ingresar", "Volver");
	return 1;
}

Dialog:DLG_TUNINGGUI_PAINTJOB(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;
	
	new paintjob;
	if(sscanf(inputtext, "i", paintjob) || !(0 <= paintjob <= 3))
		return Dialog_Open(playerid, "DLG_TUNINGGUI_PAINTJOB", DIALOG_STYLE_INPUT, "Capa de pintura", "Ingresa un valor entre 0 y 2.", "Ingresar", "Volver");

	ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), paintjob);
	TuningGUI_SelectedPaintjob[playerid] = paintjob;
	return 1;
}

/******************************************************************************************************

    __              __                 ___              ___                       ___
   / /_  __  ______/ /________ ___  __/ (_)_________   ( _ )      _________ _____/ (_)___
  / __ \/ / / / __  / ___/ __ `/ / / / / / ___/ ___/  / __ \/|   / ___/ __ `/ __  / / __ \
 / / / / /_/ / /_/ / /  / /_/ / /_/ / / / /__(__  )  / /_/  <   / /  / /_/ / /_/ / / /_/ /
/_/ /_/\__, /\__,_/_/   \__,_/\__,_/_/_/\___/____/   \____/\/  /_/   \__,_/\__,_/_/\____/
      /____/

******************************************************************************************************/

TuningGUI_SelectHydraulics(playerid)
{
	new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

	if(!(TuningPartsData[1087 - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET]))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);
	SendClientMessage(playerid, -1, "Instalada suspensión hidráulica.");
	return 1;
}

TuningGUI_SelectRadio(playerid)
{
	new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));

	if(!(TuningPartsData[1086 - TUNING_VEH_PART_OFFSET][vehiclemodel - TUNING_VEH_MODEL_OFFSET]))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, " ¡Este vehículo no soporta esta modificación!");

	AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);
	SendClientMessage(playerid, -1, "Instalada radio.");
	return 1;
}

/****************************************************************************************

               __
  __  ______  / /___  ______  ___     ____ ___  ___  ____  __  __
 / / / / __ \/ __/ / / / __ \/ _ \   / __ `__ \/ _ \/ __ \/ / / /
/ /_/ / / / / /_/ /_/ / / / /  __/  / / / / / /  __/ / / / /_/ /
\__,_/_/ /_/\__/\__,_/_/ /_/\___/  /_/ /_/ /_/\___/_/ /_/\__,_/


****************************************************************************************/

new const TuningGUI_PartsNames[15][32] = {
	/*0*/ "Alerón",
	/*1*/ "Capot",
	/*2*/ "Toma de aire (Techo)",
	/*3*/ "Faldón lateral",
	/*4*/ "Luces",
	/*5*/ "Nitro",
	/*6*/ "Caño de escape",
	/*7*/ "Ruedas",
	/*8*/ "Radio",
	/*9*/ "Hidraulicos",
	/*10*/ "Paragolpes delantero",
	/*11*/ "Paragolpes trasero",
	/*12*/ "Toma de aire (Capot)",
	/*13*/ "Vinilo",
	/*14*/ "Todo"
};

TuningGUI_ShowRemoveDialog(playerid)
{
	new title[64] = "Piesas a quitar", line[64], string[32*15];
	new vehicleid = GetPlayerVehicleID(playerid);

	new vehiclemodel = GetVehicleModel(vehicleid);
	if(!Tuning_IsVehModelSituable(vehiclemodel))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No es posible destunear este vehículo!");

	for(new partname = 0; partname < sizeof(TuningGUI_PartsNames); partname++)
	{
		format(line, sizeof(line), "%s\n", TuningGUI_PartsNames[partname]);
		strcat(string, line, sizeof(string));
	}
					
	Dialog_Open(playerid, "DLG_TUNINGGUI_UNTUNE", DIALOG_STYLE_LIST, title, string, "Quitar", "Cerrar");
	return 1;
}

Dialog:DLG_TUNINGGUI_UNTUNE(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Mec_OnUnTuningFinish(playerid);

	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar como conductor de un vehículo!");

	if(listitem == 14) 
	{
		for(new slot = 0; slot < 14; slot++)
		{
			new part = VehicleInfo[vehicleid][VehCompSlot][slot];

			RemoveVehicleComponent(vehicleid, part);
			VehicleInfo[vehicleid][VehCompSlot][slot] = 0;
		}
	}

	if(listitem < 13 && listitem != 14) 
	{
		new part = VehicleInfo[vehicleid][VehCompSlot][listitem];

		RemoveVehicleComponent(vehicleid, part);
		VehicleInfo[vehicleid][VehCompSlot][listitem] = 0;
	} 
	
	if (listitem == 13 || listitem == 14) 
	{
		VehicleInfo[vehicleid][VehPaintjob] = 3;
		ChangeVehiclePaintjob(vehicleid, 3);
	}

	SaveVehicle(vehicleid);

	new Float:pos[3], Float:angle;
	GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
	GetVehicleZAngle(vehicleid, angle);

	Veh_RecreateWithUpdatedParams(vehicleid);
	SetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
	SetVehicleZAngle(vehicleid, angle);

	PutPlayerInVehicle(playerid, vehicleid, 0);

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tuneo: %s. Quitado de tu auto.", TuningGUI_PartsNames[listitem]);

	// Si no retira todo le volvemos a dar la opcion.
	if(listitem != 14)
		return TuningGUI_ShowRemoveDialog(playerid);

	Mec_OnUnTuningFinish(playerid);
	return 1;
}
