#if defined _marp_clothes_included
	#endinput
#endif
#define _marp_clothes_included

#define PRICE_CLOTHES1 500
#define PRICE_CLOTHES2 2000

static const maleUrbanSkins[] = {
	1,2,4,5,6,7,8,14,15,16,18,19,21,22,23,26,27,28,29,30,
	32,35,36,37,42,44,45,47,48,49,50,51,52,58,60,62,66,67,72,73,
	78,79,80,81,86,94,95,96,97,101,102,103,104,105,106,107,108,109,110,114,
	115,116,173,174,175,121,122,128,132,133,134,135,136,137,142,143,144,146,149,154,
	155,156,158,159,160,161,162,167,168,170,176,179,180,181,182,183,188,200,202,206,
	209,210,212,213,220,222,229,230,234,235,236,239,241,242,250,252,260,261,262,264,
	268,269,270,271,273,289,291,292,293,297
};

static const maleFineSkins[] = {
	3,17,20,24,25,33,34,43,46,57,
	59,61,68,82,83,84,98,100,111,112,
	113,117,118,119,120,123,124,125,126,127,
	147,153,163,164,165,166,171,177,184,185,
	186,187,189,203,204,208,217,221,223,227,
	228,240,247,248,249,253,254,255,258,259,
	272,290,294,295,296,299,303,304,305
};

static const femaleUrbanSkins[] = {
	10,13,31,38,39,41,53,54,56,63,
	64,65,69,75,77,87,88,89,90,129,
	130,131,138,139,140,145,151,152,157,178,
	190,191,192,193,195,196,197,198,201,205,
	207,218,226,231,232,237,238,243,244,245,
	246,251,256,257,298
};

static const femaleFineSkins[] = {
	9,11,12,40,55,76,85,91,93,141,
	148,150,169,172,194,199,211,214,215,216,
	219,224,225,233,263
};

static List:BizClothMaleUrbanList = INVALID_LIST;
static List:BizClothMaleFineList = INVALID_LIST;
static List:BizClothFemaleUrbanList = INVALID_LIST;
static List:BizClothFemaleFineList = INVALID_LIST;

static playerSelectionBiz[MAX_PLAYERS];

hook OnGameModeInit()
{
	BizClothMaleUrbanList = PMM_NewItemList();
	BizClothMaleFineList = PMM_NewItemList();
	BizClothFemaleUrbanList = PMM_NewItemList();
	BizClothFemaleFineList = PMM_NewItemList();

	BizCloth_BuildList(BizClothMaleUrbanList, maleUrbanSkins, sizeof(maleUrbanSkins));
	BizCloth_BuildList(BizClothMaleFineList, maleFineSkins, sizeof(maleFineSkins));
	BizCloth_BuildList(BizClothFemaleUrbanList, femaleUrbanSkins, sizeof(femaleUrbanSkins));
	BizCloth_BuildList(BizClothFemaleFineList, femaleFineSkins, sizeof(femaleFineSkins));
	return 1;
}

hook OnGameModeExit()
{
	list_delete(BizClothMaleUrbanList);
	list_delete(BizClothMaleFineList);
	list_delete(BizClothFemaleUrbanList);
	list_delete(BizClothFemaleFineList);
	return 1;
}

BizCloth_BuildList(List:list, const input[], size)
{
	for(new i, desc[PMM_MAX_DESC_LENGTH]; i < size; i++)
	{
		format(desc, sizeof(desc), "skin %i", input[i]);
		PMM_AddItem(.list = list, .modelid = input[i], .desc = desc, .extraid = input[i]);
	}
}

Biz_OnPlayerBuyCloth(playerid, biz)
{
	new shopTitle[PMM_MAX_TITLE_LENGTH];
	format(shopTitle, sizeof(shopTitle), "%s ($%i)", Business[biz][bName], (Business[biz][bType] == BIZ_CLOT) ? (PRICE_CLOTHES1) : (PRICE_CLOTHES2));

	switch(Business[biz][bType])
	{
		case BIZ_CLOT: PMM_ShowForPlayer(playerid, "BizClothMenu", .itemList = (PlayerInfo[playerid][pSex]) ? (BizClothMaleUrbanList) : (BizClothFemaleUrbanList), .title = shopTitle, .deleteMenuDataWhenClosed = false, .defaultRotZ = 25.0);
		case BIZ_CLOT2: PMM_ShowForPlayer(playerid, "BizClothMenu", .itemList = (PlayerInfo[playerid][pSex]) ? (BizClothMaleFineList) : (BizClothFemaleFineList), .title = shopTitle, .deleteMenuDataWhenClosed = false, .defaultRotZ = 25.0);
	}

	playerSelectionBiz[playerid] = biz;
	return 1;
}

PMM_OnItemSelected:BizClothMenu(playerid, listitem, extraid)
{
	PMM_Close(playerid);

	new biz = playerSelectionBiz[playerid], price;

	switch(Business[biz][bType])
	{
		case BIZ_CLOT: price = PRICE_CLOTHES1;
		case BIZ_CLOT2: price = PRICE_CLOTHES2;
		default: return SendClientMessage(playerid, COLOR_RED, "[SCRIPT ERROR] El negocio no es del tipo BIZ_CLOT/2, reportar a un administrador.");
	}

	if(GetPlayerCash(playerid) < price)
	{
		SendFMessage(playerid, COLOR_YELLOW2, "No tienes el dinero necesario ($%d).", price);
		return 1;
	}

	GivePlayerCash(playerid, -price);
	Biz_AddTill(biz, price / 2);
	PlayerInfo[playerid][pSkin] = extraid;
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    PlayerActionMessage(playerid, 15.0, "compra unas vestimentas en el negocio y se las viste en el probador.");
	return 1;
}
