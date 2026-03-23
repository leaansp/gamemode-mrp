#if defined _marp_previewmodelmenu_included
	#endinput
#endif
#define _marp_previewmodelmenu_included

#include <YSI_Coding\y_hooks>

#define PMM_Show(%0,%1, PMM_ShowForPlayer(%0,#%1,
#define PMM_OnItemSelected:%0(%1) forward PMM_%0(%1); public PMM_%0(%1)

#define PMM_MAX_MODELS 10
#define PMM_MAX_MODELS_LINE 5

#define PMM_MAX_TITLE_LENGTH 64
#define PMM_MAX_DESC_LENGTH 64

#define PMM_COLOR_BLUE (0x87CEFAFF)
#define PMM_COLOR_SEMIWHITE (0xC0C0C0E1)
#define PMM_COLOR_GREY (0x4D4D4DE1)
#define PMM_COLOR_SELECTION_YELLOW (0xFCF023FF)

#define PMM_DEFAULT_ROT_Z (-155.0)

/* Textdraws */

static PlayerText:PMM_PTD_frame[MAX_PLAYERS];

static PlayerText:PMM_PTD_titleText[MAX_PLAYERS];
static PlayerText:PMM_PTD_pageText[MAX_PLAYERS];
static PlayerText:PMM_PTD_titleLine[MAX_PLAYERS];

static PlayerText:PMM_PTD_model[MAX_PLAYERS][PMM_MAX_MODELS];
static PlayerText:PMM_PTD_modelButton[MAX_PLAYERS][PMM_MAX_MODELS];
static PlayerText:PMM_PTD_modelDesc[MAX_PLAYERS][PMM_MAX_MODELS];

static PlayerText:PMM_PTD_nextArrow[MAX_PLAYERS];
static PlayerText:PMM_PTD_nextButton[MAX_PLAYERS];
static PlayerText:PMM_PTD_prevArrow[MAX_PLAYERS];
static PlayerText:PMM_PTD_prevButton[MAX_PLAYERS];

static PlayerText:PMM_PTD_closeText[MAX_PLAYERS];
static PlayerText:PMM_PTD_closeButton[MAX_PLAYERS];

/* System data */

static PMM_active[MAX_PLAYERS];
static PMM_currentPage[MAX_PLAYERS];
static PMM_totalPages[MAX_PLAYERS];
static PMM_pageElements[MAX_PLAYERS];
static PMM_callFunctionName[MAX_PLAYERS][MAX_FUNC_NAME];
static PMM_menuTitle[MAX_PLAYERS][PMM_MAX_TITLE_LENGTH];
static List:PMM_playerMenuList[MAX_PLAYERS];
static PMM_deleteList[MAX_PLAYERS];
static PMM_extraId[MAX_PLAYERS][PMM_MAX_MODELS];

hook OnPlayerDisconnect(playerid, reason)
{
	if(PMM_active[playerid])
	{
		PMM_active[playerid] = 0;
		if(PMM_deleteList[playerid] && list_valid(PMM_playerMenuList[playerid])) {
			list_delete(PMM_playerMenuList[playerid]);
		}
	}
	return 1;
}

List:PMM_NewItemList() {
	return list_new();
}

static enum e_PMM_ITEM_DATA
{
	pmmModelid,
	pmmDesc[PMM_MAX_DESC_LENGTH],
	pmmExtraid,
	pmmColor1,
	pmmColor2
}

PMM_AddItem(List:list, modelid, const desc[PMM_MAX_DESC_LENGTH], extraid = 0, color1 = -1, color2 = -1, bool:convertdesc = false)
{
	new item[e_PMM_ITEM_DATA];

	item[pmmModelid] = modelid;
	strcat(item[pmmDesc], desc, PMM_MAX_DESC_LENGTH);
	item[pmmExtraid] = extraid;
	item[pmmColor1] = color1;
	item[pmmColor2] = color2;

	if(convertdesc) {
		AsciiToTextDrawString(item[pmmDesc]);
	}

	list_add_arr(list, item);
}

PMM_ShowForPlayer(playerid, const function[], List:itemList, const title[], deleteMenuDataWhenClosed, Float:defaultRotZ = PMM_DEFAULT_ROT_Z)
{
	/* Parameter validation */

	if(!list_valid(itemList) || !list_size(itemList) || isnull(function) || strlen(function) >= MAX_FUNC_NAME - 4)
	{
		/* Regarding to the previous menu already showing */
		/* If invalid parameters and there was another menu showing, we close everything. Not needed but just in case */

		if(PMM_active[playerid]) {
			PMM_Close(playerid);
		}

		/* Regarding to the current received menu */
		/* If invalid parameters received, then we delete dynamic data */

		if(deleteMenuDataWhenClosed && list_valid(itemList)) {
			list_delete(itemList);
		}

		return 0;
	}

	/* If there was another menu showing and it was set to delete data, we destroy the menu data. No need to set anything else as all other data will be overwriten  */

	if(PMM_active[playerid] && PMM_deleteList[playerid] && list_valid(PMM_playerMenuList[playerid])) {
		list_delete(PMM_playerMenuList[playerid]);
	}

	/* After the security checks, we now process the new menu to show */

	PMM_playerMenuList[playerid] = itemList;
	PMM_deleteList[playerid] = deleteMenuDataWhenClosed;
	PMM_totalPages[playerid] = PMM_GetTotalPagesForItemAmount(list_size(itemList));

	PMM_SetAllModelsRotZ(playerid, defaultRotZ);

	/* Saving title string */

	if(isnull(title)) {
		PMM_menuTitle[playerid] = "_";
	} else {
		PMM_menuTitle[playerid][0] = EOS;
		strcat(PMM_menuTitle[playerid], title, PMM_MAX_TITLE_LENGTH);
		AsciiToTextDrawString(PMM_menuTitle[playerid]);
	}

	/* Saving public name for calling when item selected */

	PMM_callFunctionName[playerid][0] = EOS;
	strcat(PMM_callFunctionName[playerid], function, MAX_FUNC_NAME);

	PMM_ShowPage(playerid, 1);
	return 1;
}

static PMM_ParsePage(playerid, List:list, listsize, page)
{
	new startIndex = ((page - 1) * PMM_MAX_MODELS);
	new endIndex = startIndex + PMM_MAX_MODELS - 1;

	if(endIndex >= listsize) {
		endIndex = listsize - 1;
	}

	new itemAmount;

	for(new listIndex = startIndex, item[e_PMM_ITEM_DATA]; listIndex <= endIndex; listIndex++, itemAmount++)
	{
		list_get_arr(list, listIndex, item, sizeof(item));

		PlayerTextDrawSetPreviewModel(playerid, PMM_PTD_model[playerid][itemAmount], item[pmmModelid]);
		PlayerTextDrawSetString(playerid, PMM_PTD_modelDesc[playerid][itemAmount], item[pmmDesc]);

		if(item[pmmColor1] >= 0) {
			PlayerTextDrawSetPreviewVehCol(playerid, PMM_PTD_model[playerid][itemAmount], item[pmmColor1], item[pmmColor2]);
		}

		PMM_extraId[playerid][itemAmount] = item[pmmExtraid];
	}

	return itemAmount;
}

static PMM_IsValidPage(playerid, page) {
	return (1 <= page <= PMM_totalPages[playerid]);
}

static PMM_ShowPage(playerid, page)
{
	if(!PMM_IsValidPage(playerid, page))
		return 0;

	new listsize;

	if(!list_valid(PMM_playerMenuList[playerid]) || !(listsize = list_size(PMM_playerMenuList[playerid])))
		return PMM_Close(playerid);

	/* Abort if total pages amount changed (modification in the item list) */

	if(PMM_totalPages[playerid] != PMM_GetTotalPagesForItemAmount(listsize))
		return PMM_Close(playerid);

	/* Parsing selected page from list and retrieving page's items amount */

	PMM_pageElements[playerid] = PMM_ParsePage(playerid, PMM_playerMenuList[playerid], listsize, page);

	/* Updating player menu data */

	PMM_currentPage[playerid] = page;
	PMM_SetPageNumberText(playerid, page);
	PlayerTextDrawSetString(playerid, PMM_PTD_titleText[playerid], PMM_menuTitle[playerid]);

	if(PMM_active[playerid]) // Already has menu opened
	{
		PMM_HideOnlyModelsForPlayer(playerid);
		PMM_ShowOnlyModelsForPlayer(playerid);
	}
	else // Open for the first time
	{
		PMM_ShowTextDrawsForPlayer(playerid);
		PMM_active[playerid] = 1;
	}

	TogglePlayerControllable(playerid, false);
	SelectTextDraw(playerid, PMM_COLOR_SELECTION_YELLOW);
	return 1;
}

static PMM_NextPage(playerid) {
	PMM_ShowPage(playerid, PMM_currentPage[playerid] + 1);
}

static PMM_PrevPage(playerid) {
	PMM_ShowPage(playerid, PMM_currentPage[playerid] - 1);
}

static PMM_SelectItem(playerid, i)
{
	new function[MAX_FUNC_NAME] = "PMM_";
	strcat(function, PMM_callFunctionName[playerid], MAX_FUNC_NAME);
	CallLocalFunction(function, "iii", playerid, ((PMM_currentPage[playerid] - 1) * PMM_MAX_MODELS + i), PMM_extraId[playerid][i]);
}

static PMM_SetPageNumberText(playerid, page)
{
	new str[16];
	format(str, sizeof(str), "pag %i/%i", page, PMM_totalPages[playerid]);
	PlayerTextDrawSetString(playerid, PMM_PTD_pageText[playerid], str);
}

static PMM_GetTotalPagesForItemAmount(amount) {
	return (floatround(float(amount) / float(PMM_MAX_MODELS), floatround_ceil));
}

static PMM_ShowTextDrawsForPlayer(playerid)
{
	PlayerTextDrawShow(playerid, PMM_PTD_frame[playerid]);

	PlayerTextDrawShow(playerid, PMM_PTD_titleText[playerid]);
	PlayerTextDrawShow(playerid, PMM_PTD_pageText[playerid]);
	PlayerTextDrawShow(playerid, PMM_PTD_titleLine[playerid]);

	for(new i = 0; i < PMM_pageElements[playerid] && i < PMM_MAX_MODELS; i++)
	{
		PlayerTextDrawShow(playerid, PMM_PTD_model[playerid][i]);
		PlayerTextDrawShow(playerid, PMM_PTD_modelButton[playerid][i]);
		PlayerTextDrawShow(playerid, PMM_PTD_modelDesc[playerid][i]);		
	}

	PlayerTextDrawShow(playerid, PMM_PTD_nextButton[playerid]);
	PlayerTextDrawShow(playerid, PMM_PTD_nextArrow[playerid]);
	PlayerTextDrawShow(playerid, PMM_PTD_prevButton[playerid]);
	PlayerTextDrawShow(playerid, PMM_PTD_prevArrow[playerid]);

	PlayerTextDrawShow(playerid, PMM_PTD_closeButton[playerid]);
	PlayerTextDrawShow(playerid, PMM_PTD_closeText[playerid]);
}

static PMM_HideTextDrawsForPlayer(playerid)
{
	PlayerTextDrawHide(playerid, PMM_PTD_frame[playerid]);

	PlayerTextDrawHide(playerid, PMM_PTD_titleText[playerid]);
	PlayerTextDrawHide(playerid, PMM_PTD_pageText[playerid]);
	PlayerTextDrawHide(playerid, PMM_PTD_titleLine[playerid]);

	for(new i = 0; i < PMM_MAX_MODELS; i++)
	{
		PlayerTextDrawHide(playerid, PMM_PTD_model[playerid][i]);
		PlayerTextDrawHide(playerid, PMM_PTD_modelButton[playerid][i]);
		PlayerTextDrawHide(playerid, PMM_PTD_modelDesc[playerid][i]);		
	}

	PlayerTextDrawHide(playerid, PMM_PTD_nextButton[playerid]);
	PlayerTextDrawHide(playerid, PMM_PTD_nextArrow[playerid]);
	PlayerTextDrawHide(playerid, PMM_PTD_prevButton[playerid]);
	PlayerTextDrawHide(playerid, PMM_PTD_prevArrow[playerid]);

	PlayerTextDrawHide(playerid, PMM_PTD_closeButton[playerid]);
	PlayerTextDrawHide(playerid, PMM_PTD_closeText[playerid]);
}

static PMM_ShowOnlyModelsForPlayer(playerid)
{
	for(new i = 0; i < PMM_pageElements[playerid] && i < PMM_MAX_MODELS; i++)
	{
		PlayerTextDrawShow(playerid, PMM_PTD_model[playerid][i]);
		PlayerTextDrawShow(playerid, PMM_PTD_modelButton[playerid][i]);
		PlayerTextDrawShow(playerid, PMM_PTD_modelDesc[playerid][i]);		
	}	
}

static PMM_HideOnlyModelsForPlayer(playerid)
{
	for(new i = 0; i < PMM_MAX_MODELS; i++)
	{
		PlayerTextDrawHide(playerid, PMM_PTD_model[playerid][i]);
		PlayerTextDrawHide(playerid, PMM_PTD_modelButton[playerid][i]);
		PlayerTextDrawHide(playerid, PMM_PTD_modelDesc[playerid][i]);		
	}
}

static PMM_SetAllModelsRotZ(playerid, Float:rz)
{
	for(new i = 0; i < PMM_MAX_MODELS; i++) {
		PlayerTextDrawSetPreviewRot(playerid, PMM_PTD_model[playerid][i], -15.000000, 0.000000, rz, 1.000000);
	}
}

PMM_Close(playerid, bool:forced = false)
{
	PMM_active[playerid] = 0;

	if(!forced) {
		CancelSelectTextDraw(playerid);
	}

	if(PMM_deleteList[playerid] && list_valid(PMM_playerMenuList[playerid])) {
		list_delete(PMM_playerMenuList[playerid]);
	}

	PMM_HideTextDrawsForPlayer(playerid);
	TogglePlayerControllable(playerid, true);
	return 1;
}

hook OnPlayerClickTD(playerid, Text:clickedid)
{
	if(!PMM_active[playerid])
		return 0;

	if(clickedid == Text:INVALID_TEXT_DRAW) {
		PMM_Close(playerid, true);
	}
	return 0;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(!PMM_active[playerid])
		return 0;

	if(playertextid == PMM_PTD_closeButton[playerid]) {
		PMM_Close(playerid);
		return ~1;
	}
	else if(playertextid == PMM_PTD_nextButton[playerid]) {
		PMM_NextPage(playerid);
		return ~1;
	}
	else if(playertextid == PMM_PTD_prevButton[playerid]) {
		PMM_PrevPage(playerid);
		return ~1;
	}
	else {
		for(new i = 0; i < PMM_MAX_MODELS; i++)
		{
			if(playertextid == PMM_PTD_modelButton[playerid][i]) {
				PMM_SelectItem(playerid, i);
				return ~1;
			}
		}
	}
	return 0;
}

hook OnPlayerConnectDelayed(playerid)
{
	PMM_CreateTextDrawsForPlayer(playerid);
	return 1;
}

static PMM_CreateTextDrawsForPlayer(playerid)
{
	PMM_PTD_frame[playerid] = CreatePlayerTextDraw(playerid, 123.000000, 75.000000, "LD_SPAC:white");
	PlayerTextDrawFont(playerid, PMM_PTD_frame[playerid], 4);
	PlayerTextDrawTextSize(playerid, PMM_PTD_frame[playerid], 394.000000, 298.000000);
	PlayerTextDrawSetOutline(playerid, PMM_PTD_frame[playerid], 1);
	PlayerTextDrawColor(playerid, PMM_PTD_frame[playerid], 210); // Muy leve transparencia

	PMM_PTD_titleText[playerid] = CreatePlayerTextDraw(playerid, 129.000000, 79.000000, "titulo del menu");
	PlayerTextDrawFont(playerid, PMM_PTD_titleText[playerid], 3);
	PlayerTextDrawLetterSize(playerid, PMM_PTD_titleText[playerid], 0.400000, 1.600000);
	PlayerTextDrawTextSize(playerid, PMM_PTD_titleText[playerid], 435.000000, 5.000000);
	PlayerTextDrawSetShadow(playerid, PMM_PTD_titleText[playerid], 0);
	PlayerTextDrawColor(playerid, PMM_PTD_titleText[playerid], PMM_COLOR_BLUE);

	PMM_PTD_pageText[playerid] = CreatePlayerTextDraw(playerid, 512.000000, 79.000000, "pag 0/0");
	PlayerTextDrawFont(playerid, PMM_PTD_pageText[playerid], 3);
	PlayerTextDrawLetterSize(playerid, PMM_PTD_pageText[playerid], 0.400000, 1.600000);
	PlayerTextDrawTextSize(playerid, PMM_PTD_pageText[playerid], 10.000000, 10.000000);
	PlayerTextDrawSetShadow(playerid, PMM_PTD_pageText[playerid], 0);
	PlayerTextDrawAlignment(playerid, PMM_PTD_pageText[playerid], 3);
	PlayerTextDrawColor(playerid, PMM_PTD_pageText[playerid], PMM_COLOR_BLUE);

	PMM_PTD_titleLine[playerid] = CreatePlayerTextDraw(playerid, 129.000000, 97.000000, "LD_SPAC:white");
	PlayerTextDrawFont(playerid, PMM_PTD_titleLine[playerid], 4);
	PlayerTextDrawTextSize(playerid, PMM_PTD_titleLine[playerid], 383.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, PMM_PTD_titleLine[playerid], 1);
	PlayerTextDrawColor(playerid, PMM_PTD_titleLine[playerid], PMM_COLOR_SEMIWHITE);

	for(new i = 0, x = 129, y = 102; i < PMM_MAX_MODELS; i++, x += 77)
	{
		x = (i == PMM_MAX_MODELS_LINE) ? (129) : (x);
		y = (i == PMM_MAX_MODELS_LINE) ? (220) : (y);

		PMM_PTD_modelButton[playerid][i] = CreatePlayerTextDraw(playerid, float(x), float(y), "LD_SPAC:white");
		PlayerTextDrawFont(playerid, PMM_PTD_modelButton[playerid][i], 4);
		PlayerTextDrawTextSize(playerid, PMM_PTD_modelButton[playerid][i], 75.000000, 90.000000);
		PlayerTextDrawSetOutline(playerid, PMM_PTD_modelButton[playerid][i], 1);
		PlayerTextDrawColor(playerid, PMM_PTD_modelButton[playerid][i], PMM_COLOR_SEMIWHITE);
		PlayerTextDrawSetSelectable(playerid, PMM_PTD_modelButton[playerid][i], 1);

		PMM_PTD_model[playerid][i] = CreatePlayerTextDraw(playerid, float(x+1), float(y+1), "Preview_Model");
		PlayerTextDrawFont(playerid, PMM_PTD_model[playerid][i], 5);
		PlayerTextDrawTextSize(playerid, PMM_PTD_model[playerid][i], 73.000000, 87.000000);
		PlayerTextDrawSetOutline(playerid, PMM_PTD_model[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, PMM_PTD_model[playerid][i], PMM_COLOR_GREY);
		PlayerTextDrawSetPreviewModel(playerid, PMM_PTD_model[playerid][i], 0);
		PlayerTextDrawSetPreviewVehCol(playerid, PMM_PTD_model[playerid][i], 24, 1);

		PMM_PTD_modelDesc[playerid][i] = CreatePlayerTextDraw(playerid, float(x+2), float(y+92), "descripcion del producto");
		PlayerTextDrawFont(playerid, PMM_PTD_modelDesc[playerid][i], 3);
		PlayerTextDrawLetterSize(playerid, PMM_PTD_modelDesc[playerid][i], 0.220000, 0.880000);
		PlayerTextDrawTextSize(playerid, PMM_PTD_modelDesc[playerid][i], float(x+73), 10.000000);
		PlayerTextDrawSetShadow(playerid, PMM_PTD_modelDesc[playerid][i], 0);
		PlayerTextDrawColor(playerid, PMM_PTD_modelDesc[playerid][i], PMM_COLOR_BLUE);
	}

	PMM_PTD_closeButton[playerid] = CreatePlayerTextDraw(playerid, 288.000000, 345.000000, "ld_spac:white");
	PlayerTextDrawFont(playerid, PMM_PTD_closeButton[playerid], 4);
	PlayerTextDrawTextSize(playerid, PMM_PTD_closeButton[playerid], 64.000000, 22.000000);
	PlayerTextDrawSetOutline(playerid, PMM_PTD_closeButton[playerid], 1);
	PlayerTextDrawColor(playerid, PMM_PTD_closeButton[playerid], PMM_COLOR_SEMIWHITE);
	PlayerTextDrawSetSelectable(playerid, PMM_PTD_closeButton[playerid], 1);

	PMM_PTD_closeText[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 348.000000, "Cerrar");
	PlayerTextDrawFont(playerid, PMM_PTD_closeText[playerid], 3);
	PlayerTextDrawLetterSize(playerid, PMM_PTD_closeText[playerid], 0.400000, 1.750000);
	PlayerTextDrawTextSize(playerid, PMM_PTD_closeText[playerid], 10.000000, 59.500000);
	PlayerTextDrawSetOutline(playerid, PMM_PTD_closeText[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PMM_PTD_closeText[playerid], 0);
	PlayerTextDrawAlignment(playerid, PMM_PTD_closeText[playerid], 2);
	PlayerTextDrawColor(playerid, PMM_PTD_closeText[playerid], PMM_COLOR_BLUE);
	PlayerTextDrawBoxColor(playerid, PMM_PTD_closeText[playerid], 255);
	PlayerTextDrawUseBox(playerid, PMM_PTD_closeText[playerid], 1);

	PMM_PTD_nextButton[playerid] = CreatePlayerTextDraw(playerid, 493.000000, 347.000000, "ld_pool:ball");
	PlayerTextDrawFont(playerid, PMM_PTD_nextButton[playerid], 4);
	PlayerTextDrawTextSize(playerid, PMM_PTD_nextButton[playerid], 19.000000, 19.000000);
	PlayerTextDrawSetOutline(playerid, PMM_PTD_nextButton[playerid], 1);
	PlayerTextDrawColor(playerid, PMM_PTD_nextButton[playerid], PMM_COLOR_BLUE);
	PlayerTextDrawSetSelectable(playerid, PMM_PTD_nextButton[playerid], 1);

	PMM_PTD_nextArrow[playerid] = CreatePlayerTextDraw(playerid, 497.000000, 348.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, PMM_PTD_nextArrow[playerid], 4);
	PlayerTextDrawTextSize(playerid, PMM_PTD_nextArrow[playerid], 14.000000, 18.000000);
	PlayerTextDrawSetOutline(playerid, PMM_PTD_nextArrow[playerid], 1);
	PlayerTextDrawColor(playerid, PMM_PTD_nextArrow[playerid], 255);

	PMM_PTD_prevButton[playerid] = CreatePlayerTextDraw(playerid, 129.000000, 347.000000, "ld_pool:ball");
	PlayerTextDrawFont(playerid, PMM_PTD_prevButton[playerid], 4);
	PlayerTextDrawTextSize(playerid, PMM_PTD_prevButton[playerid], 19.000000, 19.000000);
	PlayerTextDrawSetOutline(playerid, PMM_PTD_prevButton[playerid], 1);
	PlayerTextDrawColor(playerid, PMM_PTD_prevButton[playerid], PMM_COLOR_BLUE);
	PlayerTextDrawSetSelectable(playerid, PMM_PTD_prevButton[playerid], 1);

	PMM_PTD_prevArrow[playerid] = CreatePlayerTextDraw(playerid, 131.000000, 348.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, PMM_PTD_prevArrow[playerid], 4);
	PlayerTextDrawTextSize(playerid, PMM_PTD_prevArrow[playerid], 14.000000, 18.000000);
	PlayerTextDrawSetOutline(playerid, PMM_PTD_prevArrow[playerid], 1);
	PlayerTextDrawColor(playerid, PMM_PTD_prevArrow[playerid], 255);
}