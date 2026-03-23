#if defined _marp_phone_gui_included
	#endinput
#endif
#define _marp_phone_gui_included

#include <YSI_Coding\y_hooks>

/****************************************************************************************

                       __                          __        __        
   _____ __  __ _____ / /_ ___   ____ ___     ____/ /____ _ / /_ ____ _
  / ___// / / // ___// __// _ \ / __ `__ \   / __  // __ `// __// __ `/
 (__  )/ /_/ /(__  )/ /_ /  __// / / / / /  / /_/ // /_/ // /_ / /_/ / 
/____/ \__, //____/ \__/ \___//_/ /_/ /_/   \__,_/ \__,_/ \__/ \__,_/  
      /____/                                                           


****************************************************************************************/

#define PMM_COLOR_SELECTION_YELLOW (0xFCF023FF)

static PhoneGUI_PhoneOnScreen[MAX_PLAYERS];

enum e_PHONEGUI_SCREENS {
	PHONEGUI_SCREEN_HOME,
	PHONEGUI_SCREEN_CALLING,
	PHONEGUI_SCREEN_INC_CALL,
	PHONEGUI_SCREEN_ONGOING_CALL,
	PHONEGUI_SCREEN_SMS,
	PHONEGUI_SCREEN_CONTACTS_LIST,
	PHONEGUI_SCREEN_CONTACTS_OPT
}

static e_PHONEGUI_SCREENS:PhoneGUI_ActiveScreen[MAX_PLAYERS];
static e_PHONEGUI_SCREENS:PhoneGUI_OpenInScreen[MAX_PLAYERS];
static PhoneGUI_CurrentContactsPage[MAX_PLAYERS];
static PhoneGUI_SelectionData[MAX_PLAYERS];

/****************************************************************************************

   __               __       __                            
  / /_ ___   _  __ / /_ ____/ /_____ ____ _ _      __ _____
 / __// _ \ | |/_// __// __  // ___// __ `/| | /| / // ___/
/ /_ /  __/_>  < / /_ / /_/ // /   / /_/ / | |/ |/ /(__  ) 
\__/ \___//_/|_| \__/ \__,_//_/    \__,_/  |__/|__//____/  

                                                           
****************************************************************************************/

static PlayerText:PhoneGUI_PTD_exteriorFrame[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_interiorFrame[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_backgroundImage[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_screenTitle[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_closeBut[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_prevBut[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_nextBut[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_newBut[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_replyBut[MAX_PLAYERS];

static PlayerText:PhoneGUI_PTD_App1But[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_App2But[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_App3But[MAX_PLAYERS];

static PlayerText:PhoneGUI_PTD_App1Name[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_App2Name[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_App3Name[MAX_PLAYERS];

static PlayerText:PhoneGUI_PTD_callAppModel[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_contactsAppModel[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_SMSAppModel[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_SMSAppNotif[MAX_PLAYERS];

static PlayerText:PhoneGUI_PTD_MenuCallAcceptBut[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_MenuCallRejectBut[MAX_PLAYERS];
static PlayerText:PhoneGUI_PTD_MenuCallHangBut[MAX_PLAYERS];

static PlayerText:PhoneGUI_PTD_SMSTextBody[MAX_PLAYERS];

static PlayerText:PhoneGUI_PTD_Contact[MAX_PLAYERS][6];

/****************************************************************************************

   ______ __  __ ____   __                       __ __    
  / ____// / / //  _/  / /_   ____ _ ____   ____/ // /___ 
 / / __ / / / / / /   / __ \ / __ `// __ \ / __  // // _ |
/ /_/ // /_/ /_/ /   / / / // /_/ // / / // /_/ // //  __/
\____/ \____//___/  /_/ /_/ \__,_//_/ /_/ \__,_//_/ \___/ 

                                                          
****************************************************************************************/

PhoneGUI_Open(playerid)
{
	PhoneGUI_ShowPhoneFrame(playerid);

	switch(PhoneGUI_OpenInScreen[playerid])
	{
		case PHONEGUI_SCREEN_CALLING: PhoneGUI_ShowCallingScreen(playerid);
		case PHONEGUI_SCREEN_INC_CALL: PhoneGUI_ShowIncomingCallScreen(playerid);
		case PHONEGUI_SCREEN_ONGOING_CALL: PhoneGUI_ShowOngoingCallScreen(playerid);
		default: PhoneGUI_ShowHomeMenu(playerid);
	}

	PhoneGUI_PhoneOnScreen[playerid] = 1;
	SelectTextDraw(playerid, PMM_COLOR_SELECTION_YELLOW);
}

PhoneGUI_Close(playerid)
{
	PhoneGUI_PhoneOnScreen[playerid] = 0; // no poner debajo del cancelSelect o lo llama 2 veces
	CancelSelectTextDraw(playerid); // CancelSelect llama nuevamente a OnPlayerClickTextdraw

	PhoneGUI_HidePhoneFrame(playerid);
	PhoneGUI_HideHomeMenu(playerid);
	PhoneGUI_HideCallMenu(playerid);
	PhoneGUI_HideSMSMenu(playerid);
	PhoneGUI_HideContactsListMenu(playerid);
	PhoneGUI_HideContactOptScreen(playerid);
}

PhoneGUI_HideSelection(playerid, bool:forced = false)
{
	if(!forced) {
		CancelSelectTextDraw(playerid); // CancelSelect llama nuevamente a OnPlayerClickTD
	} else {
		if(PhoneGUI_OpenInScreen[playerid] == PHONEGUI_SCREEN_HOME && PhoneGUI_ActiveScreen[playerid] != PHONEGUI_SCREEN_HOME) {
			PhoneGUI_SetOpenInScreen(playerid, PHONEGUI_SCREEN_HOME);
		}
	}
}

PhoneGUI_SelectPrevMenu(playerid)
{
	if(PhoneGUI_PhoneOnScreen[playerid])
	{
		switch(PhoneGUI_ActiveScreen[playerid])
		{
			case PHONEGUI_SCREEN_SMS:
			{
				PhoneGUI_HideSMSMenu(playerid);
				PhoneGUI_ShowHomeMenu(playerid);
			}
			case PHONEGUI_SCREEN_CONTACTS_LIST:
			{
				if(PhoneGUI_CurrentContactsPage[playerid] > 1)
				{
					PhoneGUI_HideContactsListMenu(playerid);
					PhoneGUI_CurrentContactsPage[playerid]--;
					PhoneGUI_ShowContactsListMenu(playerid);
				}
				else
				{
					PhoneGUI_HideContactsListMenu(playerid);
					PhoneGUI_ShowHomeMenu(playerid);
				}
			}
			case PHONEGUI_SCREEN_CONTACTS_OPT:
			{
				PhoneGUI_HideContactOptScreen(playerid);
				PhoneGUI_ShowContactsListMenu(playerid);
			}
		}
	}
	return 1;
}

/****************************************************************************************

                __ __ __                  __            __                   __        
  _____ ____ _ / // // /_   ____ _ _____ / /__ _____   / /_   ____   ____   / /__ _____
 / ___// __ `// // // __ \ / __ `// ___// //_// ___/  / __ \ / __ \ / __ \ / //_// ___/
/ /__ / /_/ // // // /_/ // /_/ // /__ / ,<  (__  )  / / / // /_/ // /_/ // ,<  (__  ) 
\___/ \__,_//_//_//_.___/ \__,_/ \___//_/|_|/____/  /_/ /_/ \____/ \____//_/|_|/____/  

                                                                                       
****************************************************************************************/

hook function OnPlayerResetStats(playerid)
{
	PhoneGUI_PTD_exteriorFrame[playerid] = PlayerText:INVALID_TEXT_DRAW;

	return continue(playerid);
}

hook LoginCamera_OnEnd(playerid)
{
	if(SearchHandsForItem(playerid, ITEM_ID_TELEFONO_CELULAR) != -1 && Phone_id[playerid]) {
		PhoneGUI_Open(playerid);
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	PhoneGUI_PhoneOnScreen[playerid] = 0;
	PhoneGUI_ActiveScreen[playerid] = PHONEGUI_SCREEN_HOME;
	PhoneGUI_OpenInScreen[playerid] = PHONEGUI_SCREEN_HOME;
	return 1;
}

hook OnPlayerClickTD(playerid, Text:clickedid)
{
	if(!PhoneGUI_PhoneOnScreen[playerid])
		return 0;

	if(clickedid == Text:INVALID_TEXT_DRAW) {
		PhoneGUI_HideSelection(playerid, true);
	}
	return 0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!PhoneGUI_PhoneOnScreen[playerid])
		return 1;

	if((newkeys & KEY_NO) && !(oldkeys & KEY_NO)) {
		SelectTextDraw(playerid, PMM_COLOR_SELECTION_YELLOW);
	}
	return 1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(!PhoneGUI_PhoneOnScreen[playerid])
		return 0;

	if(playertextid == PhoneGUI_PTD_App1But[playerid])
	{
		switch(PhoneGUI_ActiveScreen[playerid])
		{
			case PHONEGUI_SCREEN_HOME: PhoneGUI_SelectCallMenu(playerid); 
			case PHONEGUI_SCREEN_CONTACTS_OPT: PhoneGUI_SelectCallContact(playerid);
			default: PhoneGUI_Close(playerid);
		}
		return ~1;
	}
	else if(playertextid == PhoneGUI_PTD_App2But[playerid])
	{
		switch(PhoneGUI_ActiveScreen[playerid])
		{
			case PHONEGUI_SCREEN_HOME: PhoneGUI_SelectContactsListMenu(playerid);
			case PHONEGUI_SCREEN_CONTACTS_OPT: PhoneGUI_SelectDeleteContact(playerid);
			default: PhoneGUI_Close(playerid);
		}
		return ~1;
	}
	else if(playertextid == PhoneGUI_PTD_App3But[playerid])
	{
		switch(PhoneGUI_ActiveScreen[playerid])
		{
			case PHONEGUI_SCREEN_HOME: PhoneGUI_SelectSMSMenu(playerid);
			case PHONEGUI_SCREEN_CONTACTS_OPT: PhoneGUI_SelectSMSContact(playerid);
			default: PhoneGUI_Close(playerid);
		}
		return ~1;
	}
	else if(playertextid == PhoneGUI_PTD_closeBut[playerid]) {
		PhoneGUI_HideSelection(playerid, false);
		return ~1;
	}
	else if(playertextid == PhoneGUI_PTD_prevBut[playerid]) {
		PhoneGUI_SelectPrevMenu(playerid);
		return ~1;
	}
	else if(playertextid == PhoneGUI_PTD_nextBut[playerid])
	{
		switch(PhoneGUI_ActiveScreen[playerid])
		{
			case PHONEGUI_SCREEN_SMS: PhoneGUI_SelectNextSMSMenu(playerid);
			case PHONEGUI_SCREEN_CONTACTS_LIST: PhoneGUI_SelectNextContact(playerid);
			default: PhoneGUI_Close(playerid);
		}
		return ~1;
	}
	else if(playertextid == PhoneGUI_PTD_newBut[playerid])
	{
		switch(PhoneGUI_ActiveScreen[playerid])
		{
			case PHONEGUI_SCREEN_SMS: PhoneGUI_SelectNewSMS(playerid);
			case PHONEGUI_SCREEN_CONTACTS_LIST: PhoneGUI_SelectNewContact(playerid);
			default: PhoneGUI_Close(playerid);
		}
		return ~1;
	}
	else if(playertextid == PhoneGUI_PTD_replyBut[playerid]) {
		PhoneGUI_SelectReplySMS(playerid);
		return ~1;
	}
	else if(playertextid == PhoneGUI_PTD_MenuCallAcceptBut[playerid]) {
		cmd_atender(playerid, "");
		return ~1;
	}
	else if(playertextid == PhoneGUI_PTD_MenuCallRejectBut[playerid] || playertextid == PhoneGUI_PTD_MenuCallHangBut[playerid]) {
		cmd_colgar(playerid, "");
		return ~1;
	}
	else
	{
		for(new i = 0, size = sizeof(PhoneGUI_PTD_Contact[]); i < size; i++)
		{
			if(playertextid == PhoneGUI_PTD_Contact[playerid][i])
			{
				PhoneGUI_SelectContact(playerid, i);
				return ~1;
			}
		}
	}
	return 0;
}

/****************************************************************************************

  _____ ____   ____ ___   ____ ___   ____   ____ 
 / ___// __ \ / __ `__ \ / __ `__ \ / __ \ / __ |
/ /__ / /_/ // / / / / // / / / / // /_/ // / / /
\___/ \____//_/ /_/ /_//_/ /_/ /_/ \____//_/ /_/ 
                                                 

****************************************************************************************/

PhoneGUI_CreatePTDIfNotExist(playerid)
{
	if(PhoneGUI_PTD_exteriorFrame[playerid] == PlayerText:INVALID_TEXT_DRAW) // creo a demanda la primera vez que ejecuta, si nunca lo usa no se crea.
	{
		PhoneGUI_CreatePhoneFrame(playerid);
		PhoneGUI_CreateHomeMenu(playerid);
		PhoneGUI_CreateCallMenu(playerid);
		PhoneGUI_CreateSMSMenu(playerid);
		PhoneGUI_CreateContactsListMenu(playerid);
	}	
}

PhoneGUI_SetOpenInScreen(playerid, e_PHONEGUI_SCREENS:screen)
{
	PhoneGUI_OpenInScreen[playerid] = screen;

	if(PhoneGUI_PhoneOnScreen[playerid])
	{
		PhoneGUI_HideHomeMenu(playerid);
		PhoneGUI_HideCallMenu(playerid);
		PhoneGUI_HideSMSMenu(playerid);
		PhoneGUI_HideContactsListMenu(playerid);
		PhoneGUI_HideContactOptScreen(playerid);

		switch(screen)
		{
			case PHONEGUI_SCREEN_CALLING: PhoneGUI_ShowCallingScreen(playerid);
			case PHONEGUI_SCREEN_INC_CALL: PhoneGUI_ShowIncomingCallScreen(playerid);
			case PHONEGUI_SCREEN_ONGOING_CALL: PhoneGUI_ShowOngoingCallScreen(playerid);
			default: PhoneGUI_ShowHomeMenu(playerid);
		}
	}
}

/****************************************************************************************

            __                           ____                            
    ____   / /_   ____   ____   ___     / __/_____ ____ _ ____ ___   ___ 
   / __ \ / __ \ / __ \ / __ \ / _ \   / /_ / ___// __ `// __ `__ \ / _ |
  / /_/ // / / // /_/ // / / //  __/  / __// /   / /_/ // / / / / //  __/
 / .___//_/ /_/ \____//_/ /_/ \___/  /_/  /_/    \__,_//_/ /_/ /_/ \___/ 
/_/                                                                      

                                                              
****************************************************************************************/

PhoneGUI_CreatePhoneFrame(playerid)
{
	PhoneGUI_PTD_exteriorFrame[playerid] = CreatePlayerTextDraw(playerid, 539.000000, 327.000000, "ld_poke:cd9s");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_exteriorFrame[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_exteriorFrame[playerid], 97.000000, 169.000000);
	PlayerTextDrawColor(playerid, PhoneGUI_PTD_exteriorFrame[playerid], -421070081);

	PhoneGUI_PTD_interiorFrame[playerid] = CreatePlayerTextDraw(playerid, 540.000000, 328.000000, "ld_poke:cd9s");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_interiorFrame[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_interiorFrame[playerid], 95.000000, 167.000000);
	PlayerTextDrawColor(playerid, PhoneGUI_PTD_interiorFrame[playerid], 255);

	PhoneGUI_PTD_backgroundImage[playerid] = CreatePlayerTextDraw(playerid, 544.000000, 333.000000, "vehicle:vehicleenvmap128");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_backgroundImage[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_backgroundImage[playerid], 73.000000, 120.000000);

	PhoneGUI_PTD_closeBut[playerid] = CreatePlayerTextDraw(playerid, 617.000000, 332.000000, "ld_beat:cross");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_closeBut[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_closeBut[playerid], 17.000000, 17.000000);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_closeBut[playerid], 1);

	PhoneGUI_PTD_prevBut[playerid] = CreatePlayerTextDraw(playerid, 619.000000, 356.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_prevBut[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_prevBut[playerid], 13.000000, 13.000000);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_prevBut[playerid], 1);

	PhoneGUI_PTD_nextBut[playerid] = CreatePlayerTextDraw(playerid, 619.000000, 432.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_nextBut[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_nextBut[playerid], 13.000000, 13.000000);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_nextBut[playerid], 1);

	PhoneGUI_PTD_newBut[playerid] = CreatePlayerTextDraw(playerid, 618.000000, 375.000000, "HUD:radar_hostpital");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_newBut[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_newBut[playerid], 15.000000, 15.000000);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_newBut[playerid], 1);

	PhoneGUI_PTD_replyBut[playerid] = CreatePlayerTextDraw(playerid, 618.000000, 395.000000, "ld_chat:goodcha");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_replyBut[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_replyBut[playerid], 15.000000, 15.000000);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_replyBut[playerid], 1);
}

PhoneGUI_ShowPhoneFrame(playerid)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_exteriorFrame[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_interiorFrame[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_backgroundImage[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_closeBut[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_prevBut[playerid]);
}

PhoneGUI_HidePhoneFrame(playerid)
{
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_exteriorFrame[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_interiorFrame[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_backgroundImage[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_closeBut[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_prevBut[playerid]);
}

/****************************************************************************************

    __                                                            
   / /_   ____   ____ ___   ___     ____ ___   ___   ____   __  __
  / __ \ / __ \ / __ `__ \ / _ \   / __ `__ \ / _ \ / __ \ / / / /
 / / / // /_/ // / / / / //  __/  / / / / / //  __// / / // /_/ / 
/_/ /_/ \____//_/ /_/ /_/ \___/  /_/ /_/ /_/ \___//_/ /_/ \__,_/  

                                                                  
****************************************************************************************/

PhoneGUI_CreateHomeMenu(playerid)
{
	PhoneGUI_PTD_App1But[playerid] = CreatePlayerTextDraw(playerid, 550.000000, 350.000000, "vehicle:vehiclespecdot64");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_App1But[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_App1But[playerid], 28.000000, 36.000000);
	PlayerTextDrawColor(playerid, PhoneGUI_PTD_App1But[playerid], 1296911766);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_App1But[playerid], 1);

	PhoneGUI_PTD_callAppModel[playerid] = CreatePlayerTextDraw(playerid, 542.000000, 353.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_callAppModel[playerid], 5);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_callAppModel[playerid], 32.000000, 32.000000);
	PlayerTextDrawBackgroundColor(playerid, PhoneGUI_PTD_callAppModel[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, PhoneGUI_PTD_callAppModel[playerid], 18874);
	PlayerTextDrawSetPreviewRot(playerid, PhoneGUI_PTD_callAppModel[playerid], -99.000000, -1.000000, 181.000000, 1.000000);

	PhoneGUI_PTD_App1Name[playerid] = CreatePlayerTextDraw(playerid, 564.000000, 379.000000, "app1 name");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_App1Name[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_App1Name[playerid], 0.120, 0.800);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_App1Name[playerid], 20.0, 25.0);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_App1Name[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_App1Name[playerid], 0);
	PlayerTextDrawAlignment(playerid, PhoneGUI_PTD_App1Name[playerid], 2);

	PhoneGUI_PTD_App2But[playerid] = CreatePlayerTextDraw(playerid, 584.000000, 350.000000, "vehicle:vehiclespecdot64");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_App2But[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_App2But[playerid], 28.000000, 36.000000);
	PlayerTextDrawColor(playerid, PhoneGUI_PTD_App2But[playerid], 1296911766);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_App2But[playerid], 1);

	PhoneGUI_PTD_contactsAppModel[playerid] = CreatePlayerTextDraw(playerid, 584.000000, 353.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_contactsAppModel[playerid], 5);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_contactsAppModel[playerid], 27.000000, 31.000000);
	PlayerTextDrawBackgroundColor(playerid, PhoneGUI_PTD_contactsAppModel[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, PhoneGUI_PTD_contactsAppModel[playerid], 1314);
	PlayerTextDrawSetPreviewRot(playerid, PhoneGUI_PTD_contactsAppModel[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	PhoneGUI_PTD_App2Name[playerid] = CreatePlayerTextDraw(playerid, 598.000000, 379.000000, "app2 name");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_App2Name[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_App2Name[playerid], 0.120, 0.800);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_App2Name[playerid], 20.0, 25.0);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_App2Name[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_App2Name[playerid], 0);
	PlayerTextDrawAlignment(playerid, PhoneGUI_PTD_App2Name[playerid], 2);

	PhoneGUI_PTD_App3But[playerid] = CreatePlayerTextDraw(playerid, 550.000000, 390.000000, "vehicle:vehiclespecdot64");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_App3But[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_App3But[playerid], 28.000000, 36.000000);
	PlayerTextDrawColor(playerid, PhoneGUI_PTD_App3But[playerid], 1296911766);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_App3But[playerid], 1);

	PhoneGUI_PTD_SMSAppModel[playerid] = CreatePlayerTextDraw(playerid, 564.000000, 399.000000, "SMS");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_SMSAppModel[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_SMSAppModel[playerid], 0.220, 1.800);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_SMSAppModel[playerid], 15.0, 17.0);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_SMSAppModel[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_SMSAppModel[playerid], 0);
	PlayerTextDrawAlignment(playerid, PhoneGUI_PTD_SMSAppModel[playerid], 2);
	PlayerTextDrawColor(playerid, PhoneGUI_PTD_SMSAppModel[playerid], 16777215);

	PhoneGUI_PTD_App3Name[playerid] = CreatePlayerTextDraw(playerid, 564.000000, 419.000000, "app3 name");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_App3Name[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_App3Name[playerid], 0.120, 0.800);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_App3Name[playerid], 20.0, 25.0);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_App3Name[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_App3Name[playerid], 0);
	PlayerTextDrawAlignment(playerid, PhoneGUI_PTD_App3Name[playerid], 2);

	PhoneGUI_PTD_SMSAppNotif[playerid] = CreatePlayerTextDraw(playerid, 570.000000, 390.000000, "ld_chat:badchat");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_SMSAppNotif[playerid], 4);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_SMSAppNotif[playerid], 13.000000, 13.000000);

	PhoneGUI_PTD_screenTitle[playerid] = CreatePlayerTextDraw(playerid, 580.000000, 336.000000, "titulo pantalla");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_screenTitle[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_screenTitle[playerid], 0.140000, 1.100000);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_screenTitle[playerid], 10.000000, 71.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_screenTitle[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_screenTitle[playerid], 0);
	PlayerTextDrawAlignment(playerid, PhoneGUI_PTD_screenTitle[playerid], 2);
}

PhoneGUI_ShowHomeMenu(playerid)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_screenTitle[playerid], "menu principal");
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_screenTitle[playerid]);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App1But[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_callAppModel[playerid]);
	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_App1Name[playerid], "llamadas");
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App1Name[playerid]);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App2But[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_contactsAppModel[playerid]);
	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_App2Name[playerid], "contactos");
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App2Name[playerid]);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App3But[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_SMSAppModel[playerid]);
	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_App3Name[playerid], "mensajes");
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App3Name[playerid]);

	if(PhoneSMS_GetCount(Phone_id[playerid])) {
		PlayerTextDrawShow(playerid, PhoneGUI_PTD_SMSAppNotif[playerid]);
	}

	PhoneGUI_ActiveScreen[playerid] = PHONEGUI_SCREEN_HOME;
}

PhoneGUI_HideHomeMenu(playerid)
{
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_screenTitle[playerid]);

	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App1But[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_callAppModel[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App1Name[playerid]);

	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App2But[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_contactsAppModel[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App2Name[playerid]);

	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App3But[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_SMSAppModel[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App3Name[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_SMSAppNotif[playerid]);
}

PhoneGUI_SelectSMSMenu(playerid)
{
	PhoneGUI_HideHomeMenu(playerid);
	PhoneGUI_ShowSMSMenu(playerid);
}

PhoneGUI_SelectContactsListMenu(playerid)
{
	PhoneGUI_HideHomeMenu(playerid);
	PhoneGUI_CurrentContactsPage[playerid] = 1;
	PhoneGUI_ShowContactsListMenu(playerid);
}

/****************************************************************************************

                __ __                 __   _                    
  _____ ____ _ / // /  ____   ____   / /_ (_)____   ____   _____
 / ___// __ `// // /  / __ \ / __ \ / __// // __ \ / __ \ / ___/
/ /__ / /_/ // // /  / /_/ // /_/ // /_ / // /_/ // / / /(__  ) 
\___/ \__,_//_//_/   \____// .___/ \__//_/ \____//_/ /_//____/  
                          /_/                                   


****************************************************************************************/

PhoneGUI_CreateCallMenu(playerid)
{
	PhoneGUI_PTD_MenuCallAcceptBut[playerid] = CreatePlayerTextDraw(playerid, 563.000000, 368.000000, "atender");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 0.140, 1.100);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 10.000000, 29.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 0);
	PlayerTextDrawAlignment(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 2);
	PlayerTextDrawColor(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 16711935);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid], 1);

	PhoneGUI_PTD_MenuCallRejectBut[playerid] = CreatePlayerTextDraw(playerid, 599.000000, 368.000000, "rechazar");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], 0.140, 1.100);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], 10.000000, 29.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], 0);
	PlayerTextDrawAlignment(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], 2);
	PlayerTextDrawColor(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], -16776961);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid], 1);

	PhoneGUI_PTD_MenuCallHangBut[playerid] = CreatePlayerTextDraw(playerid, 581.000000, 368.000000, "colgar");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], 0.140, 1.100);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], 10.000000, 29.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], 0);
	PlayerTextDrawAlignment(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], 2);
	PlayerTextDrawColor(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], -16776961);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid], 1);
}

PhoneGUI_ShowIncomingCallScreen(playerid)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_screenTitle[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid]);

	PhoneGUI_ActiveScreen[playerid] = PHONEGUI_SCREEN_INC_CALL;
}

PhoneGUI_ShowCallingScreen(playerid)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_screenTitle[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid]);

	PhoneGUI_ActiveScreen[playerid] = PHONEGUI_SCREEN_CALLING;
}

PhoneGUI_ShowOngoingCallScreen(playerid)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_screenTitle[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid]);

	PhoneGUI_ActiveScreen[playerid] = PHONEGUI_SCREEN_ONGOING_CALL;
}

PhoneGUI_HideCallMenu(playerid)
{
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_screenTitle[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_MenuCallAcceptBut[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_MenuCallRejectBut[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_MenuCallHangBut[playerid]);
}

hook function PhoneCall_OnStarted(PHONE_HANDLE:from_phone, PHONE_HANDLE:to_phone)
{
	new from_playerid = Phone_GetPlayerid(from_phone);

	if(IsPlayerLogged(from_playerid))
	{
		PhoneGUI_SetCallTitle(from_playerid, "llamando...~n~", Phone_GetNumber(to_phone));
		PhoneGUI_SetOpenInScreen(from_playerid, PHONEGUI_SCREEN_CALLING);
	}
	return continue(_:from_phone, _:to_phone);
}

hook function PhoneCall_OnReceived(PHONE_HANDLE:from_phone, PHONE_HANDLE:to_phone)
{
	new to_playerid = Phone_GetPlayerid(to_phone);

	if(IsPlayerLogged(to_playerid))
	{
		PhoneGUI_SetCallTitle(to_playerid, "llamada entrante~n~", Phone_GetNumber(from_phone));
		PhoneGUI_SetOpenInScreen(to_playerid, PHONEGUI_SCREEN_INC_CALL);
	}
	return continue(_:from_phone, _:to_phone);
}

hook function PhoneCall_OnAnswered(PHONE_HANDLE:from_phone, PHONE_HANDLE:to_phone)
{
	new from_playerid = Phone_GetPlayerid(from_phone), to_playerid = Phone_GetPlayerid(to_phone);

	if(IsPlayerLogged(from_playerid))
	{
		PhoneGUI_SetCallTitle(from_playerid, "llamada en curso~n~", Phone_GetNumber(to_phone));
		PhoneGUI_SetOpenInScreen(from_playerid, PHONEGUI_SCREEN_ONGOING_CALL);
	}
	if(IsPlayerLogged(to_playerid))
	{
		PhoneGUI_SetCallTitle(to_playerid, "llamada en curso~n~", Phone_GetNumber(from_phone));
		PhoneGUI_SetOpenInScreen(to_playerid, PHONEGUI_SCREEN_ONGOING_CALL);
	}
	return continue(_:from_phone, _:to_phone);
}

hook function PhoneCall_OnNotAnswered(PHONE_HANDLE:from_phone, PHONE_HANDLE:to_phone)
{
	new from_playerid = Phone_GetPlayerid(from_phone), to_playerid = Phone_GetPlayerid(to_phone);

	if(IsPlayerLogged(from_playerid)) {
		PhoneGUI_SetOpenInScreen(from_playerid, PHONEGUI_SCREEN_HOME);
	}
	if(IsPlayerLogged(to_playerid)) {
		PhoneGUI_SetOpenInScreen(to_playerid, PHONEGUI_SCREEN_HOME);
	}
	return continue(_:from_phone, _:to_phone);
}

hook function PhoneCall_OnHanged(PHONE_HANDLE:hanger_phone, PHONE_HANDLE:hanged_phone, call_duration)
{
	new hanger_playerid = Phone_GetPlayerid(hanger_phone), hanged_playerid = Phone_GetPlayerid(hanged_phone);

	if(IsPlayerLogged(hanger_playerid)) {
		PhoneGUI_SetOpenInScreen(hanger_playerid, PHONEGUI_SCREEN_HOME);
	}
	if(IsPlayerLogged(hanged_playerid)) {
		PhoneGUI_SetOpenInScreen(hanged_playerid, PHONEGUI_SCREEN_HOME);
	}	
	return continue(_:hanger_phone, _:hanged_phone, call_duration);
}

PhoneGUI_SetCallTitle(playerid, const title[], number)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	new callTitle[64];
	PhoneContacts_GetNumberName(Phone_id[playerid], number, callTitle);
	strins(callTitle, title, 0);
	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_screenTitle[playerid], callTitle);
}

PhoneGUI_SelectCallMenu(playerid) {
	Dialog_Show(playerid, DLG_PHONE_CALL_MENU, DIALOG_STYLE_INPUT, "Realizar una llamada", " ¿A qué número quieres llamar?", "Continuar", "Cerrar");
}

Dialog:DLG_PHONE_CALL_MENU(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext))
		return 1;

	new number = strval(inputtext);

	if(!Phone_IsValidInputNumber(number))
	{
		Dialog_Show(playerid, DLG_PHONE_CALL_MENU, DIALOG_STYLE_INPUT, "Realizar una llamada", " ¿A qué número quieres llamar?\n{E44A4A}Por favor ingresa un número válido.", "Continuar", "Cerrar");
		return 1;
	}

	Phone_PlayerCallNumber(playerid, number);
	return 1;
}

/****************************************************************************************

                                           __   _                    
   _____ ____ ___   _____   ____   ____   / /_ (_)____   ____   _____
  / ___// __ `__ \ / ___/  / __ \ / __ \ / __// // __ \ / __ \ / ___/
 (__  )/ / / / / /(__  )  / /_/ // /_/ // /_ / // /_/ // / / /(__  ) 
/____//_/ /_/ /_//____/   \____// .___/ \__//_/ \____//_/ /_//____/  
                               /_/                                   

                                                                                   
****************************************************************************************/

PhoneGUI_CreateSMSMenu(playerid)
{
	PhoneGUI_PTD_SMSTextBody[playerid] = CreatePlayerTextDraw(playerid, 580.000000, 352.000000, "_");
	PlayerTextDrawFont(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 0.140, 1.100);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 10.000000, 71.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 0);
	PlayerTextDrawAlignment(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 2);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 1);
}

PhoneGUI_ShowSMSMenu(playerid)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_screenTitle[playerid], "mis mensajes");
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_screenTitle[playerid]);

	if(PhoneGUI_UpdateSMSData(playerid)) {
		PlayerTextDrawShow(playerid, PhoneGUI_PTD_replyBut[playerid]);
	}

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_SMSTextBody[playerid]);

	if(PhoneSMS_GetCount(Phone_id[playerid])) {
		PlayerTextDrawShow(playerid, PhoneGUI_PTD_nextBut[playerid]);
	}

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_newBut[playerid]);

	PhoneGUI_ActiveScreen[playerid] = PHONEGUI_SCREEN_SMS;
}

PhoneGUI_HideSMSMenu(playerid)
{
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_screenTitle[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_SMSTextBody[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_nextBut[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_newBut[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_replyBut[playerid]);
}

PhoneGUI_SelectNextSMSMenu(playerid)
{
	PhoneGUI_HideSMSMenu(playerid);
	PhoneGUI_ShowSMSMenu(playerid);
}

PhoneGUI_SelectNewSMS(playerid) {
	Dialog_Show(playerid, DLG_PHONEGUI_NEWSMS, DIALOG_STYLE_INPUT, "Enviar un SMS", " ¿A qué número quieres enviarle un mensaje?\nPor favor ingresa un número válido y usa el siguiente formato\n\tnumero mensaje\nEjemplo:\n\t1545983450 Hola,  ¿te parece juntarnos en Ganton?", "Continuar", "Cerrar");
}

Dialog:DLG_PHONEGUI_NEWSMS(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext))
		return 1;

	new number, message[144];
	if(sscanf(inputtext, "is[144]", number, message) || !Phone_IsValidInputNumber(number)) {
		Dialog_Show(playerid, DLG_PHONEGUI_NEWSMS, DIALOG_STYLE_INPUT, "Enviar un SMS", " ¿A qué número quieres enviarle un mensaje?\n{E44A4A}Por favor ingresa un número válido y usa el siguiente formato\n\tnumero mensaje\n"COLOR_EMB_DLG_DEFAULT"Ejemplo:\n\t1545983450 Hola,  ¿te parece juntarnos en Ganton?", "Continuar", "Cerrar");
		return 1;
	}

	SendClientMessage(playerid, COLOR_YELLOW2, "Mensaje enviado.");
	PhoneSMS_Send(Phone_id[playerid], number, message);
	return 1;
}

PhoneGUI_SelectReplySMS(playerid) {
	Dialog_Show(playerid, DLG_PHONEGUI_SMS_REPLY, DIALOG_STYLE_INPUT, "Enviar un SMS", "Escribe a continuación la respuesta al mensaje:", "Continuar", "Cerrar");
}

Dialog:DLG_PHONEGUI_SMS_REPLY(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext))
		return 1;

	SendClientMessage(playerid, COLOR_YELLOW2, "Mensaje enviado.");
	PhoneSMS_Send(Phone_id[playerid], PhoneGUI_SelectionData[playerid], inputtext);
	return 1;
}

PhoneGUI_UpdateSMSData(playerid)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	if(PhoneSMS_GetCount(Phone_id[playerid]))
	{
		new number, message[PHONESMS_MAX_LENGTH], name[32], body[192];

		PhoneSMS_GetFirst(Phone_id[playerid], number, message);
		AsciiToTextDrawString(message);
		PhoneContacts_GetNumberName(Phone_id[playerid], number, name);
		PhoneGUI_SelectionData[playerid] = number;
		format(body, sizeof(body), "nuevo mensaje de~n~%s~n~~n~%s", name, message);

		if(strlen(body) < 140) {
			PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 0.140, 1.100);
		} else {
			PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 0.115, 0.900);
		}
		PlayerTextDrawSetString(playerid, PhoneGUI_PTD_SMSTextBody[playerid], body);
		return 1;
	}
	else
	{
		PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_SMSTextBody[playerid], 0.140, 1.100);
		PlayerTextDrawSetString(playerid, PhoneGUI_PTD_SMSTextBody[playerid], "no tienes mensajes nuevos");
		return 0;
	}
}

/****************************************************************************************

                       __                __     __ _        __ 
  _____ ____   ____   / /_ ____ _ _____ / /_   / /(_)_____ / /_
 / ___// __ \ / __ \ / __// __ `// ___// __/  / // // ___// __/
/ /__ / /_/ // / / // /_ / /_/ // /__ / /_   / // /(__  )/ /_  
\___/ \____//_/ /_/ \__/ \__,_/ \___/ \__/  /_//_//____/ \__/  

                                                                                                                                      
****************************************************************************************/

PhoneGUI_CreateContactsListMenu(playerid)
{
	PhoneGUI_PTD_Contact[playerid][0] = CreatePlayerTextDraw(playerid, 545.000000, 352.000000, "contacto 1");
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_Contact[playerid][0], 0.140000, 0.900000);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_Contact[playerid][0], 616.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_Contact[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_Contact[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_Contact[playerid][0], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_Contact[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_Contact[playerid][0], 1);

	PhoneGUI_PTD_Contact[playerid][1] = CreatePlayerTextDraw(playerid, 545.000000, 364.000000, "contacto 2");
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_Contact[playerid][1], 0.140000, 0.900000);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_Contact[playerid][1], 616.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_Contact[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_Contact[playerid][1], 0);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_Contact[playerid][1], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_Contact[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_Contact[playerid][1], 1);

	PhoneGUI_PTD_Contact[playerid][2] = CreatePlayerTextDraw(playerid, 545.000000, 376.000000, "contacto 3");
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_Contact[playerid][2], 0.140000, 0.900000);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_Contact[playerid][2], 616.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_Contact[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_Contact[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_Contact[playerid][2], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_Contact[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_Contact[playerid][2], 1);

	PhoneGUI_PTD_Contact[playerid][3] = CreatePlayerTextDraw(playerid, 545.000000, 388.000000, "contacto 4");
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_Contact[playerid][3], 0.140000, 0.900000);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_Contact[playerid][3], 616.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_Contact[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_Contact[playerid][3], 0);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_Contact[playerid][3], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_Contact[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_Contact[playerid][3], 1);

	PhoneGUI_PTD_Contact[playerid][4] = CreatePlayerTextDraw(playerid, 545.000000, 400.000000, "contacto 5");
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_Contact[playerid][4], 0.140000, 0.900000);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_Contact[playerid][4], 616.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_Contact[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_Contact[playerid][4], 0);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_Contact[playerid][4], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_Contact[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_Contact[playerid][4], 1);

	PhoneGUI_PTD_Contact[playerid][5] = CreatePlayerTextDraw(playerid, 545.000000, 412.000000, "contacto 6");
	PlayerTextDrawLetterSize(playerid, PhoneGUI_PTD_Contact[playerid][5], 0.140000, 0.900000);
	PlayerTextDrawTextSize(playerid, PhoneGUI_PTD_Contact[playerid][5], 616.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, PhoneGUI_PTD_Contact[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, PhoneGUI_PTD_Contact[playerid][5], 0);
	PlayerTextDrawBoxColor(playerid, PhoneGUI_PTD_Contact[playerid][5], 150);
	PlayerTextDrawUseBox(playerid, PhoneGUI_PTD_Contact[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, PhoneGUI_PTD_Contact[playerid][5], 1);
}

PhoneGUI_ShowContactsListMenu(playerid)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	new i = (PhoneGUI_CurrentContactsPage[playerid] - 1) * sizeof(PhoneGUI_PTD_Contact[]);
	new size = PhoneContacts_GetCount(Phone_id[playerid]);

	if(size)
	{
		PlayerTextDrawSetString(playerid, PhoneGUI_PTD_screenTitle[playerid], "mis contactos");

		for(new name[32], count = 0, max_per_page = sizeof(PhoneGUI_PTD_Contact[]); i < size && count < max_per_page; i++, count++)
		{
			PhoneContacts_GetPosName(Phone_id[playerid], i, name);
			PlayerTextDrawSetString(playerid, PhoneGUI_PTD_Contact[playerid][count], name);
			PlayerTextDrawShow(playerid, PhoneGUI_PTD_Contact[playerid][count]);
		}

		if(i < size) {
			PlayerTextDrawShow(playerid, PhoneGUI_PTD_nextBut[playerid]);
		}
	} else {
		PlayerTextDrawSetString(playerid, PhoneGUI_PTD_screenTitle[playerid], "no tienes contactos");
	}

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_screenTitle[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_newBut[playerid]);

	PhoneGUI_ActiveScreen[playerid] = PHONEGUI_SCREEN_CONTACTS_LIST;
}

PhoneGUI_HideContactsListMenu(playerid)
{
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_screenTitle[playerid]);

	for(new i = 0, size = sizeof(PhoneGUI_PTD_Contact[]); i < size; i++) {
		PlayerTextDrawHide(playerid, PhoneGUI_PTD_Contact[playerid][i]);
	}

	PlayerTextDrawHide(playerid, PhoneGUI_PTD_nextBut[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_newBut[playerid]);
}

PhoneGUI_SelectContact(playerid, i)
{
	PhoneGUI_SelectionData[playerid] = i + ((PhoneGUI_CurrentContactsPage[playerid] - 1) * sizeof(PhoneGUI_PTD_Contact[]));

	PhoneGUI_HideContactsListMenu(playerid);
	PhoneGUI_ShowContactOptScreen(playerid);
}

PhoneGUI_SelectNextContact(playerid)
{
	PhoneGUI_HideContactsListMenu(playerid);
	PhoneGUI_CurrentContactsPage[playerid]++;
	PhoneGUI_ShowContactsListMenu(playerid);
}

PhoneGUI_SelectNewContact(playerid) {
	Dialog_Show(playerid, DLG_PHONEGUI_NEWCONTACT, DIALOG_STYLE_INPUT, "Nuevo contacto", "Ingresa los datos del contacto (máx 32 carácteres para el nombre).\nPor favor utiliza el formato\n\tnumero nombre\nEjemplo:\n\t1545983450 Pizzeria Ganton", "Continuar", "Cerrar");
}

Dialog:DLG_PHONEGUI_NEWCONTACT(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext))
		return 1;

	new number, name[32];
	if(sscanf(inputtext, "is[32]", number, name)) {
		Dialog_Show(playerid, DLG_PHONEGUI_NEWCONTACT, DIALOG_STYLE_INPUT, "Nuevo contacto", "Ingresa los datos del contacto (máx 32 carácteres para el nombre).\n{E44A4A}Por favor utiliza el formato\n\tnumero nombre\n"COLOR_EMB_DLG_DEFAULT"Ejemplo:\n\t1545983450 Pizzeria Ganton", "Continuar", "Cerrar");
		return 1;
	}

	SendClientMessage(playerid, COLOR_YELLOW2, "Contacto guardado.");
	PhoneContacts_New(Phone_id[playerid], number, name);
	PhoneGUI_HideContactsListMenu(playerid);
	PhoneGUI_ShowContactsListMenu(playerid);
	return 1;
}

/****************************************************************************************

                       __                __                   __   _                    
  _____ ____   ____   / /_ ____ _ _____ / /_   ____   ____   / /_ (_)____   ____   _____
 / ___// __ \ / __ \ / __// __ `// ___// __/  / __ \ / __ \ / __// // __ \ / __ \ / ___/
/ /__ / /_/ // / / // /_ / /_/ // /__ / /_   / /_/ // /_/ // /_ / // /_/ // / / /(__  ) 
\___/ \____//_/ /_/ \__/ \__,_/ \___/ \__/   \____// .___/ \__//_/ \____//_/ /_//____/  
                                                  /_/                                   


****************************************************************************************/

PhoneGUI_ShowContactOptScreen(playerid)
{
	PhoneGUI_CreatePTDIfNotExist(playerid);

	new name[32];
	PhoneContacts_GetPosName(Phone_id[playerid], PhoneGUI_SelectionData[playerid], name);
	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_screenTitle[playerid], name);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_screenTitle[playerid]);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App1But[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_callAppModel[playerid]);
	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_App1Name[playerid], "llamar");
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App1Name[playerid]);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App2But[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_contactsAppModel[playerid]);
	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_App2Name[playerid], "borrar");
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App2Name[playerid]);

	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App3But[playerid]);
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_SMSAppModel[playerid]);
	PlayerTextDrawSetString(playerid, PhoneGUI_PTD_App3Name[playerid], "enviar");
	PlayerTextDrawShow(playerid, PhoneGUI_PTD_App3Name[playerid]);

	PhoneGUI_ActiveScreen[playerid] = PHONEGUI_SCREEN_CONTACTS_OPT;
}

PhoneGUI_HideContactOptScreen(playerid)
{
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_screenTitle[playerid]);

	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App1But[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_callAppModel[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App1Name[playerid]);

	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App2But[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_contactsAppModel[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App2Name[playerid]);

	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App3But[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_SMSAppModel[playerid]);
	PlayerTextDrawHide(playerid, PhoneGUI_PTD_App3Name[playerid]);
}

PhoneGUI_SelectCallContact(playerid) {
	Phone_PlayerCallNumber(playerid, PhoneContacts_GetPosNumber(Phone_id[playerid], PhoneGUI_SelectionData[playerid]));
}

PhoneGUI_SelectSMSContact(playerid) {
	Dialog_Show(playerid, DLG_PHONEGUI_SMS_CONTACT, DIALOG_STYLE_INPUT, "Enviar un SMS", "Escribe a continuación el mensaje por favor:", "Continuar", "Cerrar");
}

Dialog:DLG_PHONEGUI_SMS_CONTACT(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext))
		return 1;

	SendClientMessage(playerid, COLOR_YELLOW2, "Mensaje enviado.");
	PhoneSMS_Send(Phone_id[playerid], PhoneContacts_GetPosNumber(Phone_id[playerid], PhoneGUI_SelectionData[playerid]), inputtext);
	return 1;
}

PhoneGUI_SelectDeleteContact(playerid)
{
	PhoneContacts_DeletePos(Phone_id[playerid], PhoneGUI_SelectionData[playerid]);
	PhoneGUI_HideContactOptScreen(playerid);
	PhoneGUI_SelectContactsListMenu(playerid);
	SendClientMessage(playerid, COLOR_YELLOW2, "Contacto borrado.");
}
