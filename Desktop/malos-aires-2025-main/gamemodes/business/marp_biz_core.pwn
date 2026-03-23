#if defined _marp_biz_core_included
	#endinput
#endif
#define _marp_biz_core_included

#define MAX_BUSINESS 200
#define BUSINESS_VW_OFFSET 2000

#define BIZ_MAX_NAME_LENGTH 64
#define BIZ_TYPE_MAX_NAME_LENGTH 32

const BIZ_RESET_ID = MAX_BUSINESS;

enum e_BUSINESS_INFO {
	bool:bLoaded,
	bName[BIZ_MAX_NAME_LENGTH],
	bOwner[MAX_PLAYER_NAME],
	bOwnerSQLID,
	bEnterable,
	bPrice,
	bEntranceFee,
	bTill,
	bLocked,
	bType,
	bRadio,

	/* Outside Point */
	Float:bOutsideX,
	Float:bOutsideY,
	Float:bOutsideZ,
	Float:bOutsideAngle,
	bOutsideWorld,
	bOutsideInt,
	STREAMER_TAG_3D_TEXT_LABEL:bOutsideLabel,
	STREAMER_TAG_PICKUP:bOutsidePickup,

	/* Inside Point */
	Float:bInsideX,
	Float:bInsideY,
	Float:bInsideZ,
	Float:bInsideAngle,
	bInsideWorld,
	bInsideInt,
	STREAMER_TAG_3D_TEXT_LABEL:bInsideLabel,
	STREAMER_TAG_PICKUP:bInsidePickup,

	/* Inside Buying Point */
	Float:bBuyingPointX,
	Float:bBuyingPointY,
	Float:bBuyingPointZ,
	Button:bBuyingPointButton,
	/*Delivery Point */

	/* NOTE: comma was missing after bBuyingPointButton above; add delivery coords */

	Float:bDelX,
	Float:bDelY,
	Float:bDelZ
}

new Business[MAX_BUSINESS + 1][e_BUSINESS_INFO] = {
	{
		/*bLoaded*/ false,
		/*bName*/ "Indefinido",
		/*bOwner*/ "Ninguno",
		/*bOwnerSQLID*/ -1,
		/*bEnterable*/ 0,
		/*bPrice*/ 0,
		/*bEntranceFee*/ 0,
		/*bTill*/ 0,
		/*bLocked*/ 0,
		/*bType*/ 0,
		/*bRadio*/ 0,

		/*bOutsideX*/ 0.0,
		/*bOutsideY*/ 0.0,
		/*bOutsideZ*/ 0.0,
		/*bOutsideAngle*/ 0.0,
		/*bOutsideWorld*/ 0,
		/*bOutsideInt*/ 0,
		/*bOutsideLabel*/ STREAMER_TAG_3D_TEXT_LABEL:0,
		/*bOutsidePickup*/ STREAMER_TAG_PICKUP:0,

		/*bInsideX*/ 0.0,
		/*bInsideY*/ 0.0,
		/*bInsideZ*/ 0.0,
		/*bInsideAngle*/ 0.0,
		/*bInsideWorld*/ 0,
		/*bInsideInt*/ 0,
		/*bInsideLabel*/ STREAMER_TAG_3D_TEXT_LABEL:0,
		/*bInsidePickup*/ STREAMER_TAG_PICKUP:0,

		/*bBuyingPointX*/ 0.0,
		/*bBuyingPointY*/ 0.0,
		/*bBuyingPointZ*/ 0.0,
		/*bBuyingPointButton*/ Button:INVALID_BUTTON_ID
	}, ...
};

enum {
	/*0*/ BIZ_NONE,
	/*1*/ BIZ_REST,
	/*2*/ BIZ_PHON,
	/*3*/ BIZ_247,
	/*4*/ BIZ_AMMU,
	/*5*/ BIZ_ADVE,
	/*6*/ BIZ_CLOT,
	/*7*/ BIZ_CLUB,
	/*8*/ BIZ_CLOT2,
	/*9*/ BIZ_CASINO,
	/*10*/ BIZ_HARD,
	/*11*/ BIZ_CLUB2,
	/*12*/ BIZ_PIZZERIA,
	/*13*/ BIZ_BURGER1,
	/*14*/ BIZ_BURGER2,
	/*15*/ BIZ_BELL,
	/*16*/ BIZ_ACCESS,
	/*17*/ BIZ_MECH,
	/*LEAVE LAST*/ BIZ_TYPES_AMOUNT
}

static const BusinessTypeName[BIZ_TYPES_AMOUNT][BIZ_TYPE_MAX_NAME_LENGTH] = {
	"Indefinido",
	"Restaurant",
	"Compañía telefonica",
	"Tienda 24-7",
	"Armería",
	"Publicidad",
	"Tienda de ropa urbana",
	"Bar",
	"Tienda de ropa fina",
	"Casino",
	"Ferretería",
	"Discoteca / Club Nocturno",
	"Pizzería",
	"McDonals",
	"Burger King",
	"Comidas Rápidas",
	"Tienda de accesorios",
	"Taller mecánico"
};

Biz_GetTypeName(type)
{
	new name[BIZ_TYPE_MAX_NAME_LENGTH];
	strcat(name, BusinessTypeName[type], BIZ_TYPE_MAX_NAME_LENGTH);
	return name;
}

stock Biz_GetName(bizid)
{
	new str[BIZ_MAX_NAME_LENGTH];
	strcat(str, Business[bizid][bName], BIZ_MAX_NAME_LENGTH);
	return str;
}

Biz_PrintTypesForPlayer(playerid)
{
	new line[128] = "[TIPOS] "COLOR_EMB_GREY" ";

	for(new i = 1; i < BIZ_TYPES_AMOUNT; i++)
	{
		format(line, sizeof(line), "%s[%i: %s] ", line, i, BusinessTypeName[i]);

		if(strlen(line) >= (sizeof(line) - BIZ_TYPE_MAX_NAME_LENGTH) || i == (BIZ_TYPES_AMOUNT - 1))
		{
			SendClientMessage(playerid, COLOR_INFO, line);
			line = "[TIPOS] "COLOR_EMB_GREY" ";
		}
	}
}

Biz_PrintInfoForPlayer(playerid, bizid)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	new string[128];

	SendFMessage(playerid, COLOR_WHITE, "=====================[Negocio ID %i ('%s')]=====================", bizid, Business[bizid][bName]);
	SendFMessage(playerid, COLOR_WHITE, "- dueño: %s [SQLID %i]", Business[bizid][bOwner], Business[bizid][bOwnerSQLID]);
	SendFMessage(playerid, COLOR_WHITE, "- Tipo: %s (%i) - Habilitado: %i - Cerrado: %i - Precio de compra: $%i", Biz_GetTypeName(Business[bizid][bType]), Business[bizid][bType], Business[bizid][bEnterable], Business[bizid][bLocked], Business[bizid][bPrice]);
	SendFMessage(playerid, COLOR_WHITE, "- Precio de entrada: $%i - Dinero en caja: $%i - Radio: %i", Business[bizid][bEntranceFee], Business[bizid][bTill], Business[bizid][bRadio]);
	
	Biz_GetOutsidePointInfo(bizid, string, sizeof(string));
	SendFMessage(playerid, COLOR_WHITE, "- Entrada %s", string);
	Biz_GetInsidePointInfo(bizid, string, sizeof(string));
	SendFMessage(playerid, COLOR_WHITE, "- Salida %s", string);
	Biz_GetBuyingPointInfo(bizid, string, sizeof(string));
	SendFMessage(playerid, COLOR_WHITE, "- Punto de compra %s", string);

	format(string, sizeof(string), "Stock de negocio %s (ID: %i)", Business[bizid][bName], bizid);
	ShowDialogBizStock(playerid, bizid, .useBothButtons = false, .title = string);
	return 1;
}

Biz_IsValidId(bizid) {
	return (0 < bizid < MAX_BUSINESS && Business[bizid][bLoaded]);
}

Biz_IsValidPrice(price) {
	return (1 <= price <= 10000000);
}

Biz_IsValidType(type) {
	return (1 <= type < BIZ_TYPES_AMOUNT);
}

Biz_Create(const name[], price, type, Float:outsideX, Float:outsideY, Float:outsideZ, Float:outsideAngle, outsideWorld, outsideInt, mapid)
{
	if(!IsValidServerInterior(mapid) || !Biz_IsValidPrice(price) || !Biz_IsValidType(type) || isnull(name))
		return 0;

	for(new bizid = 1; bizid < MAX_BUSINESS; bizid++)
	{
		if(!Business[bizid][bLoaded])
		{
			Business[bizid][bLoaded] = true;

			Business[bizid][bEnterable] = 1;
			Business[bizid][bPrice] = price;
			Business[bizid][bType] = type;
			Business[bizid][bOwnerSQLID] = -1;
			Business[bizid][bEntranceFee] = 0;
			Business[bizid][bLocked] = 0;
			Business[bizid][bRadio] = 0;

			strcopy(Business[bizid][bName], name, BIZ_MAX_NAME_LENGTH);
			strcopy(Business[bizid][bOwner], "Ninguno", MAX_PLAYER_NAME);

			GetServerInteriorInfo(mapid, Business[bizid][bInsideX], Business[bizid][bInsideY], Business[bizid][bInsideZ], Business[bizid][bInsideAngle], Business[bizid][bInsideInt]);
			Business[bizid][bInsideWorld] = BUSINESS_VW_OFFSET + bizid;

			Business[bizid][bOutsideX] = outsideX;
			Business[bizid][bOutsideY] = outsideY;
			Business[bizid][bOutsideZ] = outsideZ;
			Business[bizid][bOutsideAngle] = outsideAngle;
			Business[bizid][bOutsideInt] = outsideInt;
			Business[bizid][bOutsideWorld] = outsideWorld;

			GetXYInFrontOfPoint(Business[bizid][bInsideX], Business[bizid][bInsideY], Business[bizid][bInsideAngle], Business[bizid][bBuyingPointX], Business[bizid][bBuyingPointY], 1.75);
			GetXYInFrontOfPoint(Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideAngle], Business[bizid][bDelX], Business[bizid][bDelY], 2.75);
			Business[bizid][bBuyingPointZ] = Business[bizid][bInsideZ];

			Biz_ReloadAllPoints(bizid);
			Biz_SQLCreate(bizid);
			//CallLocalFunction("Biz_OnCreated", "i", bizid);
			return bizid;
		}
	}
	return 0;
}

Biz_Delete(bizid)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	//CallLocalFunction("Biz_OnDeleted", "i", bizid);
	Furn_DeleteAllBiz(bizid);
	Biz_ResetItemsStock(bizid);
	BizOrder_DestroyAllForBizId(bizid);

	Biz_RemoveCurrentOwner(bizid, .save = false);
	Biz_DestroyAllPoints(bizid, .save = false);
	Biz_SQLDelete(bizid);
	Business[bizid] = Business[BIZ_RESET_ID];
	return 1;
}

Biz_AddTill(bizid, money, bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	Business[bizid][bTill] += money;

	if(save) {
		Biz_SQLSaveTill(bizid);
	}
	return 1;
}

Biz_GetTill(bizid) {
	return Business[bizid][bTill];
}

Biz_SetTill(bizid, money, bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	Business[bizid][bTill] = money;

	if(save) {
		Biz_SQLSaveTill(bizid);
	}
	return 1;
}

Biz_IsLocked(bizid) {
	return Business[bizid][bLocked];
}

Biz_ToggleLock(bizid, bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	Business[bizid][bLocked] = !Business[bizid][bLocked];

	if(save) {
		Biz_SQLSaveLocked(bizid);
	}
	return 1;
}

Biz_IsEnterable(bizid) {
	return Business[bizid][bEnterable];
}

Biz_SetEnterable(bizid, status, bool:save = true)
{
	if(!Biz_IsValidId(bizid) || !(0 <= status <= 1))
		return 0;

	Business[bizid][bEnterable] = status;

	if(save) {
		Biz_SQLSaveEnterable(bizid);
	}
	return 1;
}

Biz_SetDeliveryCP(playerid, bizid, bool:save = true) {
	if(!Biz_IsValidId(bizid))
		return false;

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	Business[bizid][bDelX] = x, Business[bizid][bDelY] = y, Business[bizid][bDelZ] = z;

	// Normalize delivery to outside world/interior 0 so transport job checkpoints work consistently
	Business[bizid][bOutsideWorld] = 0;
	Business[bizid][bOutsideInt] = 0;

	if(save) {
		Biz_SQLSaveDelCP(bizid);
	}
	return true;
}

Biz_SetName(bizid, const name[], bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	strcopy(Business[bizid][bName], name, BIZ_MAX_NAME_LENGTH);
	Biz_ReloadOutsidePoint(bizid);
	
	if(save) {
		Biz_SQLSaveName(bizid);
	}
	return 1;
}

Biz_SetRadio(bizid, radio, bool:save = true)
{
	if(!Biz_IsValidId(bizid) || (!Radio_IsValidId(radio) && radio != 0))
		return 0;

	Business[bizid][bRadio] = radio;
	
	if(save) {
		Biz_SQLSaveRadio(bizid);
	}
	return 1;
}

Biz_GetPrice(bizid) {
	return Business[bizid][bPrice];
}

Biz_SetPrice(bizid, price, bool:save = true)
{
	if(!Biz_IsValidId(bizid) || !Biz_IsValidPrice(price))
		return 0;

	Business[bizid][bPrice] = price;
	Biz_ReloadOutsidePoint(bizid);
	
	if(save) {
		Biz_SQLSavePrice(bizid);
	}
	return 1;
}

Biz_SetEntranceFee(bizid, fee, bool:save = true)
{
	if(!Biz_IsValidId(bizid) || !(0 <= fee <= 10000))
		return 0;

	Business[bizid][bEntranceFee] = fee;
	Biz_ReloadOutsidePoint(bizid);

	if(save) {
		Biz_SQLSaveEntranceFee(bizid);
	}
	return 1;
}

Biz_SetType(bizid, type, bool:save = true)
{
	if(!Biz_IsValidId(bizid) || !Biz_IsValidType(type))
		return 0;

	Business[bizid][bType] = type;
	Biz_ReloadOutsidePoint(bizid);
	
	if(save) {
		Biz_SQLSaveType(bizid);
	}
	return 1;
}

Biz_SetInsideMap(bizid, mapid, bool:save = true)
{
	new Float:x, Float:y, Float:z, Float:angle, int;

	if(GetServerInteriorInfo(mapid, x, y, z, angle, int)) {
		return Biz_SetInsidePoint(bizid, x, y, z, angle, Business[bizid][bInsideWorld], int, save);
	}
	return 0;
}

Biz_SetOwner(bizid, playerid, bool:save = true)
{
	if(!Biz_IsValidId(bizid) || !IsPlayerLogged(playerid))
		return 0;
	if(!KeyChain_GetFreeSlots(playerid))
		return 0;

	Biz_RemoveCurrentOwner(bizid, .save = false);

	KeyChain_Add(playerid, KEY_TYPE_BUSINESS, bizid, Business[bizid][bName], .owner = true);

	Business[bizid][bOwnerSQLID] = PlayerInfo[playerid][pID];
	strcopy(Business[bizid][bOwner], PlayerInfo[playerid][pName], MAX_PLAYER_NAME);

	Biz_ReloadOutsidePoint(bizid);

	if(save) {
		Biz_SQLSaveOwner(bizid);
	}
	return 1;
}

Biz_SetOwnerName(bizid, const name[], bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	strcopy(Business[bizid][bOwner], name, MAX_PLAYER_NAME);

	if(save) {
		Biz_SQLSaveOwner(bizid);
	}
	return 1;
}

Biz_RemoveCurrentOwner(bizid, bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	KeyChain_DeleteAll(KEY_TYPE_BUSINESS, bizid, .allowIfOwnerKey = true);

	Business[bizid][bOwnerSQLID] = -1;
	strcopy(Business[bizid][bOwner], "Ninguno", MAX_PLAYER_NAME);
	Furn_ResetAccessBiz(bizid);

	if(save)
	{
		Biz_ReloadOutsidePoint(bizid);
		Biz_SQLSaveOwner(bizid);
	}
	return 1;
}

Biz_Sell(bizid, bool:save = true)
{
	if(!Biz_IsValidId(bizid))
		return 0;
	if(Business[bizid][bOwnerSQLID] == -1)
		return 0;

	Business[bizid][bLocked] = 0;
	Biz_RemoveCurrentOwner(bizid, .save = false);
	Biz_ReloadOutsidePoint(bizid);

	BizEmp_OnBizSell(bizid);

	if(save) {
		SaveBusiness(bizid);
	}
	return 1;
}

Biz_GetRandomIds(ids[], size = sizeof(ids), allowIdRepetition)
{
	new bizidArray[MAX_BUSINESS], bizAmount = 0;

	// Primero obtenemos todas las ids de negocios válidos creados y los ubicamos secuencialmente en bizidArray sin espacios
	// Con bizAmount obtenemos la cantidad total de negocios válidos para saber hasta donde mirar en el array

	for(new i = 1; i < MAX_BUSINESS; i++)
	{
		if(Business[i][bLoaded]) {
			bizidArray[bizAmount++] = i;
		}
	}

	if(!bizAmount)
		return 0;

	// Luego iteramos durante la cantidad recibida 'size' (tamaño del array recibido) para obtener 'size' ids aleatorias, o menor cantidad si no hubiese tantas

	if(allowIdRepetition) // Si el tipo es con reposición/repetición (si salió una bizid puede volver a salir nuevamente) iteramos 'size' veces y llenamos con ids aleatorias
	{
		for(new i = 0; i < size; i++) {
			ids[i] = bizidArray[random(bizAmount)];
		}
	}
	else // Si no, luego de asignar una id aleatoria la reemplazamos por la última disponible en bizidArray y decrementamos el indice máximoa buscar (amountRemaining)
	{
		for(new i = 0, rand, amountRemaining = bizAmount; i < size && i < bizAmount; i++)
		{
			rand = random(amountRemaining);
			ids[i] = bizidArray[rand];
			bizidArray[rand] = bizidArray[--amountRemaining];
		}
	}
	return 1;
}

Biz_GetRandomIdByType(type)
{
	new bizidArray[MAX_BUSINESS], bizAmount = 0;

	for(new i = 1; i < MAX_BUSINESS; i++)
	{
		if(Business[i][bLoaded] && Business[i][bType] == type) {
			bizidArray[bizAmount++] = i;
		}
	}

	return (bizAmount) ? (bizidArray[random(bizAmount)]) : (0);
}

Biz_IsPlayerOwner(playerid, bizid)
{
	if(!Biz_IsValidId(bizid))
		return 0;

	return (Business[bizid][bOwnerSQLID] == PlayerInfo[playerid][pID]);
}

Biz_OnPlayerCharacterKill(bizid, playerid, notifyid)
{
	if(!Biz_IsPlayerOwner(playerid, bizid))
		return 0;

	Biz_Sell(bizid, .save = true);
	GivePlayerCash(playerid, Business[bizid][bPrice] / 10 * 7); // 70 % del valor original.
	SendFMessage(notifyid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" Vendido el negocio ID %i.", bizid);
	return 1;
}

Biz_CanUse(playerid, bizid) {
	return (BizEmp_IsEmployee(playerid, bizid) || KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid) || AdminDuty[playerid]);
}