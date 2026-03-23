#if defined _marp_login_screen_included
	#endinput
#endif
#define _marp_login_screen_included

#include <YSI_Coding\y_hooks>

#define LoginScreen_SPRITES_AMOUNT 14
#define LoginScreen_ALPHA_UPDATE_TIME 80
#define LoginScreen_ALPHA_SPEED	4
#define LoginScreen_MAX_ALPHA_TIME 1000
#define LoginScreen_MIN_ALPHA 0xFFFFFF1E /* 0x1E = 30 */ /* Dont use less than 0xFFFFFF00 + LoginScreen_ALPHA_SPEED */
#define LoginScreen_MAX_ALPHA 0xFFFFFFFB /* 0xFB = 251 */ /* Dont use more than 0xFFFFFFFF - LoginScreen_ALPHA_SPEED */

static const LoginScreen_SPRITES_LIBRARIES[LoginScreen_SPRITES_AMOUNT][18] = {
	"loadsc1:loadsc1",
	"loadsc2:loadsc2",
	"loadsc3:loadsc3",
	"loadsc4:loadsc4",
	"loadsc5:loadsc5",
	"loadsc6:loadsc6",
	"loadsc7:loadsc7",
	"loadsc8:loadsc8",
	"loadsc9:loadsc9",
	"loadsc10:loadsc10",
	"loadsc11:loadsc11",
	"loadsc12:loadsc12",
	"loadsc13:loadsc13",
	"loadsc14:loadsc14"
};

//static const LoginScreen_SOUNDS[] = {157, 176, 180};

new Text:LoginScreen_TD_blackscreen;
static PlayerText:LoginScreen_PTD_image[MAX_PLAYERS][LoginScreen_SPRITES_AMOUNT];
static PlayerText:LoginScreen_PTD_leftBlackSquare[MAX_PLAYERS];
static PlayerText:LoginScreen_PTD_serverName[MAX_PLAYERS];
static LoginScreen_activeImage[MAX_PLAYERS];
static LoginScreen_timer[MAX_PLAYERS];
static LoginScreen_imageColor[MAX_PLAYERS];
static LoginScreen_fade[MAX_PLAYERS];
static LoginScreen_timeOn[MAX_PLAYERS];
static LoginScreen_isShowing[MAX_PLAYERS];

hook OnGameModeInitEnded()
{
	LoginScreen_TD_blackscreen = TextDrawCreate(0.0, 0.0, "ld_spac:white");
	TextDrawFont(LoginScreen_TD_blackscreen, 4);
	TextDrawTextSize(LoginScreen_TD_blackscreen, 640.0, 480.0);
	TextDrawColor(LoginScreen_TD_blackscreen, 255);
	return 1;
}

PlayerText:LoginScreen_CreatePTDImages(playerid, lib[])
{
	new PlayerText:txd = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, lib);
	PlayerTextDrawFont(playerid, txd, 4);
	PlayerTextDrawTextSize(playerid, txd, 640.000000, 480.000000);
	return txd;
}

LoginScreen_Start(playerid)
{
	TextDrawShowForPlayer(playerid, LoginScreen_TD_blackscreen);

	// ImagesSprites
	for(new i = 0; i < LoginScreen_SPRITES_AMOUNT; i++) {
		LoginScreen_PTD_image[playerid][i] = LoginScreen_CreatePTDImages(playerid, LoginScreen_SPRITES_LIBRARIES[i]);
	}

	new PlayerText:ptd;
	
	// LoginLogoBlackSquare
	ptd = CreatePlayerTextDraw(playerid, 0.0, 0.0, "_");
	PlayerTextDrawLetterSize(playerid, ptd, 10.0, 50.0);
	PlayerTextDrawTextSize(playerid, ptd, 239.0, 480.0);
	PlayerTextDrawBoxColor(playerid, ptd, 255);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	LoginScreen_PTD_leftBlackSquare[playerid] = ptd;

	// LoginServerName
	ptd = CreatePlayerTextDraw(playerid, 43.0, 144.0, "_malos~n~___aires~n~legacy~n~_roleplay~n~_");
	PlayerTextDrawFont(playerid, ptd, 3);
	PlayerTextDrawLetterSize(playerid, ptd, 1.14, 4.70);
	PlayerTextDrawTextSize(playerid, ptd, 217.0, 180.0);
	PlayerTextDrawSetOutline(playerid, ptd, 1);
	PlayerTextDrawSetShadow(playerid, ptd, 0);
	LoginScreen_PTD_serverName[playerid] = ptd;

	PlayerTextDrawShow(playerid, LoginScreen_PTD_leftBlackSquare[playerid]);
	PlayerTextDrawShow(playerid, LoginScreen_PTD_serverName[playerid]);
		
	//PlayerPlaySound(playerid, LoginScreen_SOUNDS[random(sizeof(LoginScreen_SOUNDS))], 0.0, 0.0, 0.0);
	LoginScreen_activeImage[playerid] = random(LoginScreen_SPRITES_AMOUNT);
	LoginScreen_ShowNextImage(playerid);
	LoginScreen_timer[playerid] = SetTimerEx("LoginScreen_FadeLoginSprite", LoginScreen_ALPHA_UPDATE_TIME, true, "i", playerid);
	LoginScreen_isShowing[playerid] = 1;
}

LoginScreen_ShowNextImage(pid)
{
	LoginScreen_activeImage[pid]++;

	if(LoginScreen_activeImage[pid] >= LoginScreen_SPRITES_AMOUNT) {
		LoginScreen_activeImage[pid] = 0;
	}

	LoginScreen_fade[pid] = 0;
	LoginScreen_imageColor[pid] = LoginScreen_MIN_ALPHA;
	LoginScreen_timeOn[pid] = 0;
	PlayerTextDrawColor(pid, LoginScreen_PTD_image[pid][LoginScreen_activeImage[pid]], LoginScreen_imageColor[pid]);
	PlayerTextDrawShow(pid, LoginScreen_PTD_image[pid][LoginScreen_activeImage[pid]]);
}

LoginScreen_SetImageAlpha(playerid, alpha)
{
	LoginScreen_imageColor[playerid] += alpha;
	PlayerTextDrawColor(playerid, LoginScreen_PTD_image[playerid][LoginScreen_activeImage[playerid]], LoginScreen_imageColor[playerid]);
	PlayerTextDrawShow(playerid, LoginScreen_PTD_image[playerid][LoginScreen_activeImage[playerid]]);
}

forward LoginScreen_FadeLoginSprite(pid);
public LoginScreen_FadeLoginSprite(pid)
{
	if(LoginScreen_fade[pid])
	{
		if(LoginScreen_imageColor[pid] >= LoginScreen_MIN_ALPHA) {
			LoginScreen_SetImageAlpha(pid, -LoginScreen_ALPHA_SPEED);
		} else {
			PlayerTextDrawHide(pid, LoginScreen_PTD_image[pid][LoginScreen_activeImage[pid]]);
			LoginScreen_ShowNextImage(pid);
		}
	} else if(LoginScreen_imageColor[pid] <= LoginScreen_MAX_ALPHA) {
		LoginScreen_SetImageAlpha(pid, LoginScreen_ALPHA_SPEED);
	} else {
		LoginScreen_timeOn[pid] += LoginScreen_ALPHA_UPDATE_TIME;
		if(LoginScreen_timeOn[pid] >= LoginScreen_MAX_ALPHA_TIME) {
			LoginScreen_fade[pid] = 1;
		}
	}
	return 1;
}

LoginScreen_End(playerid, destruction_delay = 0)
{
	if(!LoginScreen_isShowing[playerid])
		return 0;

	KillTimer(LoginScreen_timer[playerid]);

	if(destruction_delay > 0) {
		LoginScreen_timer[playerid] = SetTimerEx("LoginScreen_Destroy", destruction_delay, false, "i", playerid);
	} else {
		LoginScreen_Destroy(playerid);
	}
	return 1;
}

forward LoginScreen_Destroy(playerid);
public LoginScreen_Destroy(playerid)
{
	LoginScreen_isShowing[playerid] = 0;
	LoginScreen_timer[playerid] = 0;

	for(new i = 0; i < LoginScreen_SPRITES_AMOUNT; i++) {
		PlayerTextDrawDestroy(playerid, LoginScreen_PTD_image[playerid][i]);
	}
	TextDrawHideForPlayer(playerid, LoginScreen_TD_blackscreen);

	PlayerTextDrawDestroy(playerid, LoginScreen_PTD_leftBlackSquare[playerid]);
	PlayerTextDrawDestroy(playerid, LoginScreen_PTD_serverName[playerid]);

	//PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	LoginScreen_isShowing[playerid] = 0;
	if(LoginScreen_timer[playerid])
	{
		KillTimer(LoginScreen_timer[playerid]);
		LoginScreen_timer[playerid] = 0;
	}
	return 1;
}