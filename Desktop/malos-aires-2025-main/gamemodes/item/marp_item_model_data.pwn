#if defined _marp_item_model_data_inc
	#endinput
#endif
#define _marp_item_model_data_inc

#include <YSI_Coding\y_hooks>

const ITEM_MODEL_MAX_AMOUNT = 512;
const ITEM_MODEL_MAX_NAME_LEN = 40;
const ITEM_MODEL_MAX_PARAM_NAME_LEN = 20;

enum e_ITEM_TAG(<<= 1)
{
	ITEM_TAG_INV = 1, // Si se puede guardar en el inventario (mayor prioridad que ITEM_TAG_SAVE en caso de inventario)
	ITEM_TAG_BACK, // Si se puede guardar en la espalda
	ITEM_TAG_BOTH_HANDS, // Si requiere ambas manos y animaci�n de carga
	ITEM_TAG_SAVE, // Si se puede guardar en contenedores
	ITEM_TAG_GIVE, // Si se puede dar a otro jugador
	ITEM_TAG_THROW, // Si se puede tirar al piso
	ITEM_TAG_USE, // Si se puede usar / equipar
	ITEM_TAG_COMBINE, // Si se puede combinar
	ITEM_TAG_STACK, // Si se puede stackear en cantidad. Ej: un bate no, una camara si
	ITEM_TAG_BLACK_MARKET, // Si se puede vender en el mercado negro
	ITEM_TAG_SPLIT,
	ITEM_TAG_FIX_PRICE, // Si el precio no depende de la cantidad del item
	ITEM_TAG_HOLSTER // Si se puede guardar en la funda de cadera
}

static enum e_ITEM_MODEL_DATA
{
	Name[ITEM_MODEL_MAX_NAME_LEN],
	TextDrawNameString[ITEM_MODEL_MAX_NAME_LEN],
	ParamName[ITEM_MODEL_MAX_PARAM_NAME_LEN],
	ParamDefaultValue, // Valor default para el par�metro al crearse el item (en general por compra)
	Type,
	BasePrice,
	ObjectModel,
	e_ITEM_TAG:ItemTag,
	Float:LeftPos[3], // posici�n para attachear en mano izquierda
	Float:LeftRot[3], // Rotaci�n para attachear en mano izquierda
	Float:LeftScale[3], // Escala para attachear en mano izquierda
	Float:RightPos[3], // posici�n para attachear en mano derecha
	Float:RightRot[3], // Rotaci�n para attachear en mano derecha
	Float:RightScale[3], // Escala para attachear en mano derecha
	OccupiedSpace, // Espacio/vol�men que ocupa el item en el mundo
	ExtraId // Campo �til para referenciar a otras estructuras de datos, seg�n convenga
};

static ServerItemModels[ITEM_MODEL_MAX_AMOUNT][e_ITEM_MODEL_DATA] = {
	{
		/*Name*/ "",
		/*TextDrawNameString*/ "",
		/*ParamName*/ "",
		/*ParamDefaultValue*/ 1,
		/*Type*/ ITEM_NONE,
		/*BasePrice*/ 1,
		/*ObjectModel*/ 0,
		/*ItemTag*/ e_ITEM_TAG:0,
		/*LeftPos*/ {0.0, 0.0, 0.0},
		/*LeftRot*/ {0.0, 0.0, 0.0},
		/*LeftScale*/ {1.0, 1.0, 1.0},
		/*RightPos*/ {0.0, 0.0, 0.0},
		/*RightRot*/ {0.0, 0.0, 0.0},
		/*RightScale*/ {1.0, 1.0, 1.0},
		/*OccupiedSpace*/ 0,
		/*ExtraId*/ 0
	}, ...
};

static ServerItemModelsCount;

ItemModel_SetNewDataId(
	itemid,
	const name[ITEM_MODEL_MAX_NAME_LEN] = "",
	const paramName[ITEM_MODEL_MAX_PARAM_NAME_LEN] = "",
	paramDefaultValue = 1,
	type = -1,
	basePrice = 1,
	objectModel = 0,
	e_ITEM_TAG:itemTag = e_ITEM_TAG:0,
	Float:leftPos[3] = {0.0, 0.0, 0.0},
	Float:leftRot[3] = {0.0, 0.0, 0.0},
	Float:leftScale[3] = {1.0, 1.0, 1.0},
	Float:rightPos[3] = {0.0, 0.0, 0.0},
	Float:rightRot[3] = {0.0, 0.0, 0.0},
	Float:rightScale[3] = {1.0, 1.0, 1.0},
	occupiedSpace = 0,
	extraId = 0)
{
	if(!(0 < itemid < ITEM_MODEL_MAX_AMOUNT))
	{
		printf("[ERROR] Se ha encontrado un modelo de item con ID %i invalida; se descarta.", itemid);
		return 0;
	}

	if(type < ITEM_NONE || basePrice <= 0 || occupiedSpace <= 0 || isnull(name) || isnull(paramName))
	{
		printf("[ERROR] Se ha encontrado un parametro invalido para el modelo de item ID %i; se descarta.", itemid);
		return 0;
	}

	if(ServerItemModels[itemid][Type] != ITEM_NONE || ServerItemModels[itemid][OccupiedSpace] > 0)
	{
		printf("[ERROR] Se ha encontrado un modelo de item con ID %i ya inicializada. Original: %s. Descartado: %s.", itemid, ServerItemModels[itemid][Name], name);
		return 0;
	}

	strcat(ServerItemModels[itemid][Name], name, ITEM_MODEL_MAX_NAME_LEN);
	strcat(ServerItemModels[itemid][TextDrawNameString], name, ITEM_MODEL_MAX_NAME_LEN);
	AsciiToTextDrawString(ServerItemModels[itemid][TextDrawNameString]);
	strcat(ServerItemModels[itemid][ParamName], paramName, ITEM_MODEL_MAX_PARAM_NAME_LEN);
	
	ServerItemModels[itemid][ParamDefaultValue] = paramDefaultValue;
	ServerItemModels[itemid][Type] = type;
	ServerItemModels[itemid][BasePrice] = basePrice;
	ServerItemModels[itemid][ObjectModel] = objectModel;
	ServerItemModels[itemid][ItemTag] = itemTag;
	ServerItemModels[itemid][LeftPos] = leftPos;
	ServerItemModels[itemid][LeftRot] = leftRot;
	ServerItemModels[itemid][LeftScale] = leftScale;
	ServerItemModels[itemid][RightPos] = rightPos;
	ServerItemModels[itemid][RightRot] = rightRot;
	ServerItemModels[itemid][RightScale] = rightScale;
	ServerItemModels[itemid][OccupiedSpace] = occupiedSpace;
	ServerItemModels[itemid][ExtraId] = extraId;

	ServerItemModelsCount++;
	return 1;
}

hook OnGameModeInit()
{

	CallLocalFunction("ItemModel_OnInit", "");
	printf("[INFO] Se han inicializado los datos de %i modelos de item.", ServerItemModelsCount);
	return 1;
}

forward ItemModel_OnInit();
public ItemModel_OnInit()
{
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BRASSKNUCKLE,
		.name = "Manopla",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 400,
		.objectModel = 331,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.occupiedSpace = 5,
		.extraId = WEAPON_BRASSKNUCKLE
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GOLFCLUB,
		.name = "Palo de Golf",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 300,
		.objectModel = 333,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.035, 0.074, 0.0},
		.leftRot = Float:{153.8, 0.0, 0.0},
		.occupiedSpace = 20,
		.extraId = WEAPON_GOLFCLUB
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_NITESTICK,
		.name = "Macana",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 300,
		.objectModel = 334,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.017, 0.048, -0.13},
		.leftRot = Float:{175.4, 0.0, 0.0},
		.occupiedSpace = 10,
		.extraId = WEAPON_NITESTICK
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_KNIFE,
		.name = "Navaja",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 350,
		.objectModel = 335,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.0, 0.074, 0.0},
		.leftRot = Float:{148.7, 0.0, 0.0},
		.occupiedSpace = 6,
		.extraId = WEAPON_KNIFE
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BAT,
		.name = "Bate",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 500,
		.objectModel = 336,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.024, 0.017, -0.13},
		.leftRot = Float:{157.0, 0.0, 0.0},
		.occupiedSpace = 25,
		.extraId = WEAPON_BAT
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SHOVEL,
		.name = "Pala",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 200,
		.objectModel = 337,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.032, 0.065, 0.0},
		.leftRot = Float:{163.1, 0.0, 0.0},
		.occupiedSpace = 30,
		.extraId = WEAPON_SHOVEL
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_POOLSTICK,
		.name = "Palo de pool",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 300,
		.objectModel = 338,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.04, 0.0, -0.182},
		.leftRot = Float:{152.0, 0.0, 0.0},
		.occupiedSpace = 20,
		.extraId = WEAPON_POOLSTICK
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_KATANA,
		.name = "Katana",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 6000,
		.objectModel = 339,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.022, 0.018, -0.123},
		.leftRot = Float:{162.7, -1.6, -8.8},
		.occupiedSpace = 25,
		.extraId = WEAPON_KATANA
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHAINSAW,
		.name = "Motosierra",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 15000,
		.objectModel = 341,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.0, 0.07, 0.0},
		.leftRot = Float:{161.0, 0.0, 0.0},
		.occupiedSpace = 40,
		.extraId = WEAPON_CHAINSAW
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_DILDO,
		.name = "Consolador doble punta",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 150,
		.objectModel = 321,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.0150, 0.080, 0.0},
		.leftRot = Float:{155.5, 0.0, 0.0},
		.occupiedSpace = 15,
		.extraId = WEAPON_DILDO
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_DILDO2,
		.name = "Consolador",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 150,
		.objectModel = 322,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.014, 0.067, -0.034},
		.leftRot = Float:{156.6, 0.0, 0.0},
		.occupiedSpace = 15,
		.extraId = WEAPON_DILDO2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_VIBRATOR,
		.name = "Vibrador",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 200,
		.objectModel = 323,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.019, 0.07, 0.0},
		.leftRot = Float:{161.4, 0.0, 0.0},
		.occupiedSpace = 15,
		.extraId = WEAPON_VIBRATOR
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_VIBRATOR2,
		.name = "Vibrador plateado",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 200,
		.objectModel = 324,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.008, 0.070, -0.036},
		.leftRot = Float:{161.5, 0.0, 0.0},
		.occupiedSpace = 15,
		.extraId = WEAPON_VIBRATOR2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FLOWER,
		.name = "Flores",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 50,
		.objectModel = 325,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW,
		.leftPos = Float:{0.0, 0.061, 0.0},
		.leftRot = Float:{153.6, 0.0, 0.0},
		.occupiedSpace = 15,
		.extraId = WEAPON_FLOWER
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CANE,
		.name = "Bast�n",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 150,
		.objectModel = 326,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.027, 0.023, -0.112},
		.leftRot = Float:{166.6, 0.0, 0.0},
		.occupiedSpace = 20,
		.extraId = WEAPON_CANE
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GRENADE,
		.name = "Granada",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 1000,
		.objectModel = 342,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.leftPos = Float:{0.046, 0.09, -0.017},
		.leftRot = Float:{155.1, 2.2, 0.0},
		.occupiedSpace = 6,
		.extraId = WEAPON_GRENADE
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TEARGAS,
		.name = "Granada de gas",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 750,
		.objectModel = 343,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.leftPos = Float:{0.024, 0.084, -0.029},
		.leftRot = Float:{161.3, 0.0, 0.0},
		.occupiedSpace = 6,
		.extraId = WEAPON_TEARGAS
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MOLTOV,
		.name = "Bomba molotov",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 450,
		.objectModel = 344,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.leftPos = Float:{0.038, 0.073, 0.0},
		.leftRot = Float:{159.3, 0.0, 0.0},
		.occupiedSpace = 10,
		.extraId = WEAPON_MOLTOV
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BERETTA_PX4_STORM,
		.name = "Pistola Beretta PX4 Storm",
		.paramName = "Munici�n",
		.paramDefaultValue = 17,
		.type = ITEM_WEAPON,
		.basePrice = 10200,
		.objectModel = 346,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.009, 0.061, -0.025},
		.leftRot = Float:{150.9, 8.6, -11.7},
		.occupiedSpace = 8,
		.extraId = WEAPON_BERETTA_PX4_STORM
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_COLT45,
		.name = "Pistola Colt 45 9mm",
		.paramName = "Munici�n",
		.paramDefaultValue = 17,
		.type = ITEM_WEAPON,
		.basePrice = 9000,
		.objectModel = 346,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.009, 0.061, -0.025},
		.leftRot = Float:{150.9, 8.6, -11.7},
		.occupiedSpace = 8,
		.extraId = WEAPON_COLT45
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SILENCED,
		.name = "Pistola 9mm con silenciador",
		.paramName = "Munici�n",
		.paramDefaultValue = 17,
		.type = ITEM_WEAPON,
		.basePrice = 12000,
		.objectModel = 347,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.043, 0.06, -0.022},
		.leftRot = Float:{160.0, -0.1, -9.3},
		.occupiedSpace = 10,
		.extraId = WEAPON_SILENCED
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_DEAGLE,
		.name = "Pistola Desert Eagle",
		.paramName = "Munici�n",
		.paramDefaultValue = 7,
		.type = ITEM_WEAPON,
		.basePrice = 14800,
		.objectModel = 348,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.011, 0.058, 0.0},
		.leftRot = Float:{-178.3, 0.0, 0.0},
		.occupiedSpace = 10,
		.extraId = WEAPON_DEAGLE
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SHOTGUN,
		.name = "Escopeta",
		.paramName = "Munici�n",
		.paramDefaultValue = 8,
		.type = ITEM_WEAPON,
		.basePrice = 15500,
		.objectModel = 349,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.035, 0.081, 0.023},
		.leftRot = Float:{154.4, 0.0, 0.0},
		.occupiedSpace = 30,
		.extraId = WEAPON_SHOTGUN
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SAWEDOFF,
		.name = "Escopeta recortada",
		.paramName = "Munici�n",
		.paramDefaultValue = 2,
		.type = ITEM_WEAPON,
		.basePrice = 14000,
		.objectModel = 350,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.026, 0.058, -0.023},
		.leftRot = Float:{170.9, 0.0, 0.0},
		.occupiedSpace = 20,
		.extraId = WEAPON_SAWEDOFF
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SHOTGSPA,
		.name = "Escopeta de combate",
		.paramName = "Munici�n",
		.paramDefaultValue = 7,
		.type = ITEM_WEAPON,
		.basePrice = 32000,
		.objectModel = 351,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.024, 0.059, -0.01},
		.leftRot = Float:{172.9, 0.0, 0.0},
		.occupiedSpace = 35,
		.extraId = WEAPON_SHOTGSPA
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_UZI,
		.name = "Uzi",
		.paramName = "Munici�n",
		.paramDefaultValue = 50,
		.type = ITEM_WEAPON,
		.basePrice = 16500,
		.objectModel = 352,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.024, 0.051, -0.022},
		.leftRot = Float:{167.6, 0.0, 0.0},
		.occupiedSpace = 15,
		.extraId = WEAPON_UZI
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MP5,
		.name = "Subfusil MP-5",
		.paramName = "Munici�n",
		.paramDefaultValue = 30,
		.type = ITEM_WEAPON,
		.basePrice = 28000,
		.objectModel = 353,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.03, 0.065, 0.0},
		.leftRot = Float:{163.8, 0.0, 0.0},
		.occupiedSpace = 25,
		.extraId = WEAPON_MP5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_AK47,
		.name = "Fusil AK-47",
		.paramName = "Munici�n",
		.paramDefaultValue = 30,
		.type = ITEM_WEAPON,
		.basePrice = 40000,
		.objectModel = 355,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.057, 0.076, 0.014},
		.leftRot = Float:{168.5, 0.0, 0.0},
		.occupiedSpace = 40,
		.extraId = WEAPON_AK47
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_M4,
		.name = "Fusil M4",
		.paramName = "Munici�n",
		.paramDefaultValue = 50,
		.type = ITEM_WEAPON,
		.basePrice = 48000,
		.objectModel = 356,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.031, 0.042, -0.021},
		.leftRot = Float:{174.1, 0.0, 0.0},
		.occupiedSpace = 40,
		.extraId = WEAPON_M4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TEC9,
		.name = "Pistola semiautom�tica TEC-9",
		.paramName = "Munici�n",
		.paramDefaultValue = 50,
		.type = ITEM_WEAPON,
		.basePrice = 19000,
		.objectModel = 372,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.022, 0.067, 0.0},
		.leftRot = Float:{168.5, 0.0, 0.0},
		.occupiedSpace = 15,
		.extraId = WEAPON_TEC9
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RIFLE,
		.name = "Rifle de caza",
		.paramName = "Munici�n",
		.paramDefaultValue = 10,
		.type = ITEM_WEAPON,
		.basePrice =  30000,
		.objectModel = 357,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.057, 0.083, -0.007},
		.leftRot = Float:{168.1, 19.8, 0.0},
		.occupiedSpace = 30,
		.extraId = WEAPON_RIFLE
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SNIPER,
		.name = "Rifle de francotirador",
		.paramName = "Munici�n",
		.paramDefaultValue = 10,
		.type = ITEM_WEAPON,
		.basePrice = 75000,
		.objectModel = 358,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.052, 0.086, 0.007},
		.leftRot = Float:{150.1, 8.6, 0.0},
		.occupiedSpace = 40,
		.extraId = WEAPON_SNIPER
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROCKETLAUNCHER,
		.name = "RPG-7",
		.paramName = "Munici�n",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 200000,
		.objectModel = 359,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.leftPos = Float:{0.004, 0.046, 0.0},
		.leftRot = Float:{158.8, 9.5, -4.0},
		.occupiedSpace = 50,
		.extraId = WEAPON_ROCKETLAUNCHER
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_HEATSEEKER,
		.name = "Lanzamisiles",
		.paramName = "Munici�n",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 250000,
		.objectModel = 360,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.leftPos = Float:{0.023, 0.067, -0.006},
		.leftRot = Float:{169.0, -7.2, -9.6},
		.occupiedSpace = 50,
		.extraId = WEAPON_HEATSEEKER
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FLAMETHROWER,
		.name = "Lanzallamas",
		.paramName = "Munici�n",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 150000,
		.objectModel = 361,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.leftPos = Float:{0.017, 0.071, -0.019},
		.leftRot = Float:{176.8, 0.0, 0.0},
		.occupiedSpace = 50,
		.extraId = WEAPON_FLAMETHROWER
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MINIGUN,
		.name = "Minigun",
		.paramName = "Munici�n",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.objectModel = 362,
		.leftPos = Float:{-0.039, 0.126, -0.079},
		.leftRot = Float:{-164.78, 0.0, 0.0},
		.occupiedSpace = 50,
		.extraId = WEAPON_MINIGUN
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SATCHEL,
		.name = "Carga C4",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 15000,
		.objectModel = 363,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.occupiedSpace = 15,
		.extraId = WEAPON_SATCHEL
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOMB,
		.name = "Detonador",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 100000,
		.objectModel = 364,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW,
		.occupiedSpace = 4,
		.extraId = WEAPON_BOMB
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SPRAYCAN,
		.name = "Aerosol",
		.paramName = "Contenido",
		.paramDefaultValue = 500,
		.type = ITEM_WEAPON,
		.basePrice = 250,
		.objectModel = 365,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.leftPos = Float:{0.029, 0.059, -0.109},
		.leftRot = Float:{-177.1, -0.9, -21.9},
		.occupiedSpace = 6,
		.extraId = WEAPON_SPRAYCAN
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FIREEXTINGUISHER,
		.name = "Matafuegos",
		.paramName = "Contenido",
		.paramDefaultValue = 500,
		.type = ITEM_WEAPON,
		.basePrice = 300,
		.objectModel = 366,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.occupiedSpace = 25,
		.extraId = WEAPON_FIREEXTINGUISHER
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CAMARA,
		.name = "C�mara fotogr�fica",
		.paramName = "Fotos",
		.paramDefaultValue = 20,
		.type = ITEM_WEAPON,
		.basePrice = 500,
		.objectModel = 367,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.occupiedSpace = 8,
		.extraId = WEAPON_CAMERA
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_NIGHT_VISION,
		.name = "Visi�n nocturna",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.objectModel = 368,
		.occupiedSpace = 10,
		.extraId = WEAPON_NIGHT_VISION
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_THERMAL_VISION,
		.name = "Visi�n t�rmica",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.objectModel = 369,
		.occupiedSpace = 10,
		.extraId = WEAPON_THERMAL_VISION
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PARACHUTE,
		.name = "Paraca�das",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.objectModel = 371,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW,
		.occupiedSpace = 50,
		.extraId = WEAPON_PARACHUTE
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MATERIALES,
		.name = "Caja de materiales",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 15,
		.objectModel = 2040,
		.itemTag = ITEM_TAG_BOTH_HANDS | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_STACK | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.076, 0.08, 0.0202},
		.leftRot = Float:{-72.0, 0.0, 15.1},
		.rightPos = Float:{0.028, 0.09, -0.191},
		.rightRot = Float:{-103.2, -13.2, -7.2},
		.occupiedSpace = 100
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BIDON,
		.name = "Bid�n de combustible",
		.paramName = "Contenido",
		.paramDefaultValue = 0,
		.type = ITEM_OTHER,
		.basePrice = 50,
		.objectModel = 1650,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.154, 0.028, 0.041},
		.leftRot = Float:{0.0, -97.3, -156.3},
		.rightPos = Float:{0.13, 0.028, -0.039},
		.rightRot = Float:{0.0, -97.3, -1.8},
		.occupiedSpace = 70
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MATERIAPRIMA,
		.name = "Bolsa de materia prima",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 10,
		.objectModel = 2060,
		.itemTag = ITEM_TAG_BOTH_HANDS | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.014, 0.118, 0.155},
		.leftRot = Float:{105.2, -10.7, 75.1},
		.rightPos = Float:{0.0, 0.086, -0.215},
		.rightRot = Float:{78.3, 11.0, 100.3},
		.occupiedSpace = 60
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PRODUCTOS,
		.name = "Productos",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 50,
		.objectModel = 2694,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_STACK | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.0, 0.063, 0.182},
		.leftRot = Float:{-75.89, -0.6, 23.1},
		.rightPos = Float:{0.0, 0.063, 0.182},
		.rightRot = Float:{-75.89, -0.6, 23.1},
		.occupiedSpace = 65
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_DINERO,
		.name = "Dinero",
		.paramName = "Cantidad ($)",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 1,
		.objectModel = 1212,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.leftPos = Float:{0.127, 0.034, 0.0},
		.leftRot = Float:{-85.2, -28.6, 91.0},
		.rightPos = Float:{0.115, 0.039, 0.0},
		.rightRot = Float:{1.9, -102.40, 10.8},
		.occupiedSpace = 3
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SANDWICH,
		.name = "Sandwich",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 40,
		.objectModel = 2769,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.1, 0.044, -0.022},
		.leftRot = Float:{-95.7, -25.3, -118.7},
		.rightPos = Float:{0.08, 0.056, 0.023},
		.rightRot = Float:{160.5, -94.56, -35.5},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHORIPAN,
		.name = "Chorip�n",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 40,
		.objectModel = 2769,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.1, 0.044, -0.022},
		.leftRot = Float:{-95.7, -25.3, -118.7},
		.rightPos = Float:{0.08, 0.056, 0.023},
		.rightRot = Float:{160.5, -94.56, -35.5},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ALFAJOR,
		.name = "Alfajor",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 20,
		.objectModel = 11741,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.144, 0.064, -0.013},
		.leftRot = Float:{-101.2, -50.3, 0.0},
		.leftScale = Float:{0.5, 0.5, 0.5},
		.rightPos = Float:{0.091, 0.077, 0.018},
		.rightRot = Float:{-101.2, -98.8, 0.0},
		.rightScale = Float:{0.5, 0.5, 0.5},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_AGUAMINERAL,
		.name = "Agua mineral",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 20,
		.objectModel = 1484,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.17, 0.007, -0.093},
		.leftRot = Float:{1.4, -145.5, 0.0},
		.rightPos = Float:{-0.005, 0.017, 0.097},
		.rightRot = Float:{-16.7, 27.9, -4.0},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MATE,
		.name = "Mate descartable",
		.paramName = "Usos",
		.paramDefaultValue = 20,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 250,
		.objectModel = -2100,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.17, 0.007, -0.093},
		.leftRot = Float:{1.4, -145.5, 0.0},
		.rightPos = Float:{-0.005, 0.017, 0.097},
		.rightRot = Float:{-16.7, 27.9, -4.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MALETINDINERO,
		.name = "Malet�n de dinero",
		.paramName = "$",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 300,
		.objectModel = 1210,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_STACK,
		.leftPos = Float:{0.308, 0.089, 0.003},
		.leftRot = Float:{0.0, -90.599, 3.41},
		.rightPos = Float:{0.288, 0.078, 0.014},
		.rightRot = Float:{0.0, -90.599, -0.99},
		.occupiedSpace = 55
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCOCOMUN,
		.name = "Casco com�n",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 350,
		.objectModel = 18645,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.214, 0.063, 0.0},
		.leftRot = Float:{-93.4, 0.0, 0.0},
		.rightPos = Float:{0.214, 0.063, 0.0},
		.rightRot = Float:{-93.4, 0.0, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCOMOTOCROSS,
		.name = "Casco de motocross",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 400,
		.objectModel = 18976,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.194, -0.032, -0.024},
		.leftRot = Float:{68.8, 0.0, 174.1},
		.rightPos = Float:{0.194, -0.032, -0.024},
		.rightRot = Float:{68.8, 0.0, 174.1},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCOROJO,
		.name = "Casco rojo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 250,
		.objectModel = 18977,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.214, 0.063, 0.0},
		.leftRot = Float:{-93.4, 0.0, 0.0},
		.rightPos = Float:{0.214, 0.063, 0.0},
		.rightRot = Float:{-93.4, 0.0, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCOBLANCO,
		.name = "Casco blanco",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 250,
		.objectModel = 18978,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.214, 0.063, 0.0},
		.leftRot = Float:{-93.4, 0.0, 0.0},
		.rightPos = Float:{0.214, 0.063, 0.0},
		.rightRot = Float:{-93.4, 0.0, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCOROSA,
		.name = "Casco rosa",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 250,
		.objectModel = 18979,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.214, 0.063, 0.0},
		.leftRot = Float:{-93.4, 0.0, 0.0},
		.rightPos = Float:{0.214, 0.063, 0.0},
		.rightRot = Float:{-93.4, 0.0, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_REPUESTOAUTO,
		.name = "Repuesto de auto",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 44,
		.objectModel = 1135,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.109, 0.072, 0.184},
		.leftRot = Float:{98.6, 0.0, 0.0},
		.rightPos = Float:{0.109, 0.072, 0.184},
		.rightRot = Float:{98.6, 0.0, 1.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SPARE_TIRE,
		.name = "Rueda de auxilio",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 2000,
		.objectModel = 1098,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_STACK,
		.leftPos = Float:{0.3019, 0.0829, -0.012},
		.leftRot = Float:{0.0, -90.5999, -0.9999},
		.leftScale = Float:{0.5, 0.5, 0.5},
		.rightPos = Float:{0.3019, 0.0829, -0.012},
		.rightRot = Float:{0.0, -90.5999, -0.9999},
		.rightScale = Float:{0.5, 0.5, 0.5},
		.occupiedSpace = 35
	);
	
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BARRETA,
		.name = "Barreta",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 150,
		.objectModel = 18634,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.108, 0.079, 0.148},
		.leftRot = Float:{-102.7, -87.12, 0.0},
		.rightPos = Float:{0.09, 0.057, -0.113},
		.rightRot = Float:{102.9, -105.7, 2.0},
		.occupiedSpace = 20
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCO_OBRERO,
		.name = "Casco de obrero",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 30,
		.objectModel = 18638,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO_COWBOY_NEGRO,
		.name = "Sombrero de cowboy negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 19096,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 25
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO_COWBOY_MARRON,
		.name = "Sombrero de cowboy marron",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 19095,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 25
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO_COWBOY_BORDO,
		.name = "Sombrero de cowboy bordo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 19097,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 25
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RELOJ_SWATCH,
		.name = "Reloj Swatch",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 350,
		.objectModel = 19040,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.123, 0.058, -0.022},
		.leftRot = Float:{-5.0, 79.0, 9.6},
		.rightPos = Float:{0.094, 0.044, -0.022},
		.rightRot = Float:{163.8, 86.6, 0.0},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RELOJ_ROLEX,
		.name = "Reloj Rolex",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 2500,
		.objectModel = 19042,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.123, 0.058, -0.022},
		.leftRot = Float:{-5.0, 79.0, 9.6},
		.rightPos = Float:{0.094, 0.044, -0.022},
		.rightRot = Float:{163.8, 86.6, 0.0},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RELOJ_CASIO,
		.name = "Reloj Casio",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 70,
		.objectModel = 19041,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.123, 0.058, -0.022},
		.leftRot = Float:{-5.0, 79.0, 9.6},
		.rightPos = Float:{0.094, 0.044, -0.022},
		.rightRot = Float:{163.8, 86.6, 0.0},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RELOJ_SWISSARMY,
		.name = "Reloj Swiss Army",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 750,
		.objectModel = 19039,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.123, 0.058, -0.022},
		.leftRot = Float:{-5.0, 79.0, 9.6},
		.rightPos = Float:{0.094, 0.044, -0.022},
		.rightRot = Float:{163.8, 86.6, 0.0},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RELOJ_FESTINA,
		.name = "Reloj Festina",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 1200,
		.objectModel = 19043,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.123, 0.058, -0.022},
		.leftRot = Float:{-5.0, 79.0, 9.6},
		.rightPos = Float:{0.094, 0.044, -0.022},
		.rightRot = Float:{163.8, 86.6, 0.0},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO_ANTIGUO,
		.name = "Sombrero antiguo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 19352,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.2, 0.025, -0.019},
		.leftRot = Float:{-80.4, 13.4, 0.0},
		.rightPos = Float:{0.147, 0.044, 0.0},
		.rightRot = Float:{-93.4, 0.0, 0.0},
		.occupiedSpace = 25
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BIGOTE_FALSO1,
		.name = "Bigote falso 1",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 10,
		.objectModel = 19351,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.135, 0.047, 0.0},
		.leftRot = Float:{-3.2, -1.6, -38.6},
		.rightPos = Float:{0.104, 0.062, 0.0},
		.rightRot = Float:{-3.2, -1.6, 11.3},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BIGOTE_FALSO2,
		.name = "Bigote falso 2",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 10,
		.objectModel = 19350,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.135, 0.047, 0.0},
		.leftRot = Float:{-3.2, -1.6, -38.6},
		.rightPos = Float:{0.104, 0.062, 0.0},
		.rightRot = Float:{-3.2, -1.6, 11.3},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO_BLANCO,
		.name = "Sombrero blanco",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 250,
		.objectModel = 19488,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.214, 0.088, -0.026},
		.leftRot = Float:{-93.4, 0.0, 0.0},
		.rightPos = Float:{0.186, 0.063, 0.0},
		.rightRot = Float:{-93.4, 9.5, 0.0},
		.occupiedSpace = 25
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRO_ROJO,
		.name = "Gorro rojo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 100,
		.objectModel = 19067,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-128.8, 0.5, 97.9},
		.rightPos = Float:{0.173, 0.025, 0.009},
		.rightRot = Float:{-146.8, 14.5, 89.4},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRO_ESTAMPADO,
		.name = "Gorro estampado",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 19068,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-128.8, 0.5, 97.9},
		.rightPos = Float:{0.173, 0.025, 0.009},
		.rightRot = Float:{-146.8, 14.5, 89.4},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRO_NEGRO,
		.name = "Gorro negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 100,
		.objectModel = 19069,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-128.8, 0.5, 97.9},
		.rightPos = Float:{0.173, 0.025, 0.009},
		.rightRot = Float:{-146.8, 14.5, 89.4},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRO_PLAYERO_NEGRO,
		.name = "Gorro playero negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 100,
		.objectModel = 18967,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-128.8, 0.5, 97.9},
		.rightPos = Float:{0.166, 0.036, 0.009},
		.rightRot = Float:{-103.0, 18.0, 87.5},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRO_PLAYERO_CUADROS,
		.name = "Gorro playero a cuadros",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 100,
		.objectModel = 18968,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-128.8, 0.5, 97.9},
		.rightPos = Float:{0.166, 0.036, 0.009},
		.rightRot = Float:{-103.0, 18.0, 87.5},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA_MILITAR,
		.name = "Gorra militar",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 125,
		.objectModel = 18926,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA_GRIS_ESTAMPADA,
		.name = "Gorra gris estampada",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 125,
		.objectModel = 18929,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA_BLANCA_ESTAMPADA,
		.name = "Gorra blanca estampada",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 125,
		.objectModel = 18933,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_DE_SOL,
		.name = "Anteojos de sol",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 50,
		.objectModel = 19033,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_DEPORTIVO_NEGRO,
		.name = "Anteojos deportivos negros",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 100,
		.objectModel = 19138,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_DEPORTIVO_ROJO,
		.name = "Anteojos deportivos rojos",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 100,
		.objectModel = 19139,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_DEPORTIVO_AZUL,
		.name = "Anteojos deportivos azules",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 100,
		.objectModel = 19140,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_RAYBAN_NEGRO,
		.name = "Anteojos Rayban negros",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 19022,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_RAYBAN_AZUL,
		.name = "Anteojos Rayban azules",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 19023,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_RAYBAN_VIOLETA,
		.name = "Anteojos Rayban violetas",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 19024,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_RAYBAN_ROSA,
		.name = "Anteojos Rayban rosa",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 19025,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_RAYBAN_ROJO,
		.name = "Anteojos Rayban rojos",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 19026,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_RAYBAN_NARANJA,
		.name = "Anteojos Rayban naranjas",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 19027,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_RAYBAN_AMARILLO,
		.name = "Anteojos Rayban amarillos",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 19028,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ANTEOJO_RAYBAN_VERDE,
		.name = "Anteojos Rayban verdes",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 19029,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.175, 0.045, 0.0},
		.leftRot = Float:{-93.4, 0.0, 89.3},
		.rightPos = Float:{0.173, 0.046, 0.015},
		.rightRot = Float:{-85.0, 0.0, -102.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA_SIMPLE_NEGRA,
		.name = "Gorra simple negra",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18941,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA_SIMPLE_AZUL,
		.name = "Gorra simple azul",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18942,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA_SIMPLE_VERDE,
		.name = "Gorra simple verde",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18943,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TELEFONO_CELULAR,
		.name = "tel�fono celular negro",
		.paramName = "n�mero",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 500,
		.objectModel = 18868,
		.rightPos = Float:{0.122, 0.009, 0.021},
		.rightRot = Float:{93.9, -150.5, -7.1},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ENCENDEDOR,
		.name = "Encendedor",
		.paramName = "Usos",
		.paramDefaultValue = 20,
		.type = ITEM_OTHER,
		.basePrice = 15,
		.objectModel = 19998,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.114, 0.026, -0.025},
		.leftRot = Float:{0.000, -175.4, -25.5},
		.leftScale = Float:{0.45, 0.79, 0.649},
		.rightPos = Float:{0.096, 0.024, 0.029},
		.rightRot = Float:{0.000, -4.5, 16.3},
		.rightScale = Float:{0.45, 0.79, 0.649},
		.occupiedSpace = 1
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CIGARRILLOS,
		.name = "Cigarrillos",
		.paramName = "Cantidad",
		.paramDefaultValue = 10,
		.type = ITEM_OTHER,
		.basePrice = 20,
		.objectModel = 19896,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.108, 0.037, -0.046},
		.leftRot = Float:{95.6, 30.7, 175.4},
		.rightPos = Float:{0.081, 0.02, 0.024},
		.rightRot = Float:{76.6, 24.2, 11.5},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RADIO,
		.name = "Radio Walkie Talkie",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 400,
		.objectModel = 19942,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.114, 0.036, -0.054},
		.leftRot = Float:{-2.1, 175.6, 143.9},
		.rightPos = Float:{0.08, 0.033, 0.053},
		.rightRot = Float:{-3.8, -8.6, -140.4},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_VALIJA,
		.name = "Valija",
		.paramName = "Espacio",
		.paramDefaultValue = 1,
		.type = ITEM_NONE,
		.basePrice = 400,
		.objectModel = 19624,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.085, 0.000, -0.018},
		.leftRot = Float:{-2.199, -98.699, 37.400},
		.rightPos = Float:{0.074, 0.013, 0.000},
		.rightRot = Float:{0.000, -98.100, 0.000},
		.occupiedSpace = 75
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MEDIC_CASE,
		.name = "Malet�n de primeros auxilios",
		.paramName = "Usos",
		.paramDefaultValue = 5,
		.type = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.basePrice = 150,
		.objectModel = 11738,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.268, 0.022, -0.007},
		.leftRot = Float:{0.000, -94.700, 12.699},
		.rightPos = Float:{0.270, 0.022, 0.036},
		.rightRot = Float:{0.000, -97.899, 0.000},
		.occupiedSpace = 45
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOLSO,
		.name = "Bolso deportivo",
		.paramName = "Espacio",
		.paramDefaultValue = 1,
		.type = ITEM_NONE,
		.basePrice = 300,
		.objectModel = 11745,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.198, -0.056, 0.055},
		.leftRot = Float:{0.000, -99.399, -46.499},
		.rightPos = Float:{0.214, -0.066, 0.014},
		.rightRot = Float:{0.000, -99.799, 87.300},
		.occupiedSpace = 65
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MOCHILAGRANDE,
		.name = "Mochila grande",
		.paramName = "Espacio",
		.paramDefaultValue = 0,
		.type = ITEM_CONTAINER,
		.basePrice = 550,
		.objectModel = 19559,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.412, 0.066, 0.000},
		.leftRot = Float:{0.000, -97.000, 24.599},
		.rightPos = Float:{0.400, 0.049, 0.066},
		.rightRot = Float:{0.000, -96.600, 0.000},
		.occupiedSpace = 55
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MOCHILACHICA,
		.name = "Mochila chica",
		.paramName = "Espacio",
		.paramDefaultValue = 0,
		.type = ITEM_CONTAINER,
		.basePrice = 300,
		.objectModel = 3026,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.504, 0.000, 0.000},
		.leftRot = Float:{146.999, 0.000, -173.799},
		.rightPos = Float:{0.473, -0.040, 0.000},
		.rightRot = Float:{-169.700, 0.000, -171.399},
		.occupiedSpace = 35
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MOCHILAMEDIANA,
		.name = "Mochila mediana",
		.paramName = "Espacio",
		.paramDefaultValue = 0,
		.type = ITEM_CONTAINER,
		.basePrice = 425,
		.objectModel = 371,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.377, 0.022, 0.049},
		.leftRot = Float:{0.000, -104.999, 26.500},
		.rightPos = Float:{0.340, -0.004, 0.074},
		.rightRot = Float:{0.000, -99.700, 0.000},
		.occupiedSpace = 45
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MALETIN,
		.name = "Malet�n",
		.paramName = "Espacio",
		.paramDefaultValue = 1,
		.type = ITEM_NONE,
		.basePrice = 400,
		.objectModel = 1210,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.3019, 0.0829, -0.012},
		.leftRot = Float:{0.0, -90.5999, -0.9999},
		.rightPos = Float:{0.3019, 0.0829, -0.012},
		.rightRot = Float:{0.0, -90.5999, -0.9999},
		.occupiedSpace = 45
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PARLANTE,
		.name = "Reproductor de m�sica",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 550,
		.objectModel = 2102,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.396, 0.000, 0.020},
		.leftRot = Float:{0.000, -93.600, 8.399},
		.rightPos = Float:{0.369, 0.021, 0.058},
		.rightRot = Float:{0.000, -99.599, 0.000},
		.occupiedSpace = 50
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CERVEZA,
		.name = "Cerveza",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 40,
		.objectModel = 1486,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.125, 0.056, -0.016},
		.leftRot = Float:{-29.0, -168.2, 23.9},
		.rightPos = Float:{0.077, 0.034, -0.021},
		.rightRot = Float:{-3.7, -4.3, 0.0},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_WHEEL,
		.name = "Rueda",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 2000,
		.objectModel = 1098,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.3019, 0.0829, -0.012},
		.leftRot = Float:{0.0, -90.5999, -0.9999},
		.leftScale = Float:{0.5, 0.5, 0.5},
		.rightPos = Float:{0.3019, 0.0829, -0.012},
		.rightRot = Float:{0.0, -90.5999, -0.9999},
		.rightScale = Float:{0.5, 0.5, 0.5},
		.occupiedSpace = 50
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_LLAVE_DE_CRUZ,
		.name = "Llave de cruz",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 100,
		.objectModel = 18633,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.108, 0.049, 0.036},
		.leftRot = Float:{-102.7, -97.3, 0.0},
		.rightPos = Float:{0.091, 0.027, -0.053},
		.rightRot = Float:{92.4, -79.4, 11.3},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_VINO,
		.name = "Vino",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 75,
		.objectModel = 1669,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.125, 0.059, 0.087},
		.leftRot = Float:{-14.0, -172.2, 0.0},
		.rightPos = Float:{0.091, 0.038, -0.082},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_WHISKY,
		.name = "Whisky",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 150,
		.objectModel = 19823,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_VODKA,
		.name = "Vodka",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 100,
		.objectModel = 1668,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.125, 0.059, 0.083},
		.leftRot = Float:{-14.3, -167.7, 0.0},
		.rightPos = Float:{0.075, 0.029, -0.08},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RON,
		.name = "Ron",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 125,
		.objectModel = 1668,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.125, 0.059, 0.083},
		.leftRot = Float:{-14.3, -167.7, 0.0},
		.rightPos = Float:{0.075, 0.029, -0.08},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GARBAGE_BAG,
		.name = "Bolsa de basura",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_JOB,
		.objectModel = 1265,
		.itemTag = ITEM_TAG_THROW,
		.leftPos = Float:{0.251, 0.053, -0.077},
		.leftRot = Float:{0.0, -101.4, -41.1},
		.leftScale = Float:{0.5, 0.5, 0.5},
		.rightPos = Float:{0.214, -0.007, -0.025},
		.rightRot = Float:{0.0, -119.4, 0.0},
		.rightScale = Float:{0.5, 0.5, 0.5},
		.occupiedSpace = 50
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_HAMBURGUESA,
		.name = "Hamburguesa",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 100,
		.objectModel = 2703,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.112, 0.062, -0.009},
		.leftRot = Float:{-112.0, 42.501, 96.9},
		.rightPos = Float:{0.095, 0.109, -0.01},
		.rightRot = Float:{5.3, 5.508, -106.7},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_JUGO_NARANJA_CAJA,
		.name = "Jugo de naranja",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 40,
		.objectModel = 19563,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.055, 0.036},
		.leftRot = Float:{-1.6, -171.4, 47.9},
		.leftScale = Float:{0.485, 0.806, 0.63},
		.rightPos = Float:{0.083, 0.053, -0.038},
		.rightRot = Float:{-5.2, -10.3, -0.4},
		.rightScale = Float:{0.485, 0.806, 0.63},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_JUGO_MANZANA_CAJA,
		.name = "Jugo de manzana",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 40,
		.objectModel = 19564,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.055, 0.036},
		.leftRot = Float:{-1.6, -171.4, 47.9},
		.leftScale = Float:{0.485, 0.806, 0.63},
		.rightPos = Float:{0.083, 0.053, -0.038},
		.rightRot = Float:{-5.2, -10.3, -0.4},
		.rightScale = Float:{0.485, 0.806, 0.63},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_POTE_HELADO,
		.name = "Pote de helado",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 60,
		.objectModel = 19567,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CAJA_LECHE,
		.name = "Caja de leche",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 35,
		.objectModel = 19569,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.104, 0.063, -0.036},
		.leftRot = Float:{1.0, -174.7, -31.0},
		.leftScale = Float:{0.6, 0.6, 0.8},
		.rightPos = Float:{0.095, 0.047, -0.053},
		.rightRot = Float:{0.0, -8.4, 30.4},
		.rightScale = Float:{0.6, 0.6, 0.8},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOTELLA_LECHE,
		.name = "Botella de leche",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 45,
		.objectModel = 19570,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.104, 0.063, 0.058},
		.leftRot = Float:{1.0, -174.7, -31.0},
		.leftScale = Float:{0.6, 0.6, 0.8},
		.rightPos = Float:{0.095, 0.047, -0.053},
		.rightRot = Float:{0.0, -8.4, 30.4},
		.rightScale = Float:{0.6, 0.6, 0.8},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PACK_CERVEZA,
		.name = "Pack de cerveza",
		.paramName = "Cervezas",
		.paramDefaultValue = 6,
		.type = ITEM_BATCH,
		.basePrice = 200,
		.objectModel = 19572,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.0462, 0.025, -0.009},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.0442, 0.028, 0.056},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 20
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_NARANJA,
		.name = "Naranja",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 10,
		.objectModel = 19574,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, 0.002},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, 0.04},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MANZANA_ROJA,
		.name = "Manzana roja",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 15,
		.objectModel = 19575,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, 0.002},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, 0.04},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MANZANA_VERDE,
		.name = "Manzana verde",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 15,
		.objectModel = 19576,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, 0.002},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, 0.04},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TOMATE,
		.name = "Tomate",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 10,
		.objectModel = 19577,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, 0.002},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, 0.04},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANANA,
		.name = "Banana",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 15,
		.objectModel = 19578,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, 0.0},
		.leftRot = Float:{85.0, -3.9, 92.1},
		.rightPos = Float:{0.095, 0.047, 0.014},
		.rightRot = Float:{77.4, -169.9, -102.2},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PAN,
		.name = "Pan",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 20,
		.objectModel = 19579,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.125, 0.037, 0.018},
		.leftRot = Float:{-79.8, -26.7, -74.8},
		.leftScale = Float:{1.0, 0.531, 0.443},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.rightScale = Float:{1.0, 0.531, 0.443},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CAFE,
		.name = "Caf�",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 40,
		.objectModel = 19835,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.053, -0.01},
		.leftRot = Float:{0.0, -170.0, 0.0},
		.leftScale = Float:{0.82, 0.82, 1.0},
		.rightPos = Float:{0.077, 0.048, 0.004},
		.rightRot = Float:{-9.8, -8.4, 4.6},
		.rightScale = Float:{0.82, 0.82, 1.0},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TOSTADA,
		.name = "Tostada",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 5,
		.objectModel = 19883,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.11, 0.041, -0.023},
		.leftRot = Float:{-93.2, -35.2, 7.0},
		.rightPos = Float:{0.081, 0.082, 0.014},
		.rightRot = Float:{92.0, -63.8, 0.9},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CEREALES_CRISPY,
		.name = "Cereales Crispy",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 50,
		.objectModel = 19561,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.192, 0.07, 0.117},
		.leftRot = Float:{11.8, -172.9, -24.3},
		.leftScale = Float:{0.872, 0.711, 0.766},
		.rightPos = Float:{0.192, 0.047, -0.106},
		.rightRot = Float:{-7.2, -8.9, 0.9},
		.rightScale = Float:{0.872, 0.711, 0.766},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CEREALES_POPS,
		.name = "Cereales Pops",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 50,
		.objectModel = 19562,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.192, 0.07, 0.117},
		.leftRot = Float:{11.8, -172.9, -24.3},
		.leftScale = Float:{0.872, 0.711, 0.766},
		.rightPos = Float:{0.192, 0.047, -0.106},
		.rightRot = Float:{-7.2, -8.9, 0.9},
		.rightScale = Float:{0.872, 0.711, 0.766},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PECHUGA_POLLO,
		.name = "Pechuga de pollo",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 200,
		.objectModel = 2355,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MILANESA_Y_ENSALADA,
		.name = "Milanesa y ensalada",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 175,
		.objectModel = 2355,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CROQUETAS_RELLENAS,
		.name = "Croquetas rellenas",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 130,
		.objectModel = 2355,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_LANGOSTINOS_EMPANADOS,
		.name = "Langostinos empanados",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 170,
		.objectModel = 2354,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_WANTAN_SALMON,
		.name = "Wantan de salm�n",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 200,
		.objectModel = 2354,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_POLLO_VERDEO,
		.name = "Pollo al verdeo",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 170,
		.objectModel = 2354,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ENSALADA_CESAR,
		.name = "Ensalada C�sar",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 90,
		.objectModel = 2353,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ENSALADA_WALDORF,
		.name = "Ensalada waldorf",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 120,
		.objectModel = 2353,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MUFFINS,
		.name = "Muffins con caf�",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 80,
		.objectModel = 2221,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_DONAS_SURTIDAS,
		.name = "Donas surtidas con caf�",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 90,
		.objectModel = 2222,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_DONAS_BLANCAS,
		.name = "Donas blancas con caf�",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 60,
		.objectModel = 2223,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PIZZA_LEGENDARIA,
		.name = "Pizza Legendaria",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 170,
		.objectModel = 2220,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PIZZA_CANTIMPALO,
		.name = "Pizza Cantimpalo",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 150,
		.objectModel = 2220,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PIZZA_MUZZARELLA,
		.name = "Pizza Muzzarella",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 120,
		.objectModel = 2220,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PIZZA_ESPECIAL,
		.name = "Pizza Especial",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 130,
		.objectModel = 2220,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_P_PIZZA_HUEVO_ENS_PAPAS,
		.name = "Pizza huevo con ensalada y papas",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 80,
		.objectModel = 2219,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_P_PIZZA_MUZZA_ENS_PAPAS,
		.name = "Pizza muzza con ensalada y papas",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 80,
		.objectModel = 2219,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_P_PIZZA_ESPECIAL_PAPAS,
		.name = "Pizza especial con papas",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 60,
		.objectModel = 2218,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_P_PIZZA_ROQUE_PAPAS,
		.name = "Pizza roquefort con papas",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 70,
		.objectModel = 2218,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHORIZO,
		.name = "Bolsa con 3 chorizos",
		.paramName = "Usos",
		.paramDefaultValue = 1,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 150,
		.objectModel = 2805,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.leftScale = Float:{0.65, 0.656000, 0.813999},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.rightScale = Float:{0.65, 0.656000, 0.813999},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_P_PIZZA_MUZZA_PAPAS,
		.name = "Pizza muzza con papas",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 50,
		.objectModel = 2218,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.095, 0.047, -0.038},
		.leftRot = Float:{0.0, -98.199, 0.0},
		.rightPos = Float:{0.095, 0.047, -0.038},
		.rightRot = Float:{0.0, -98.199, 0.0},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TASER,
		.name = "Pistola Taser",
		.paramName = "Munici�n",
		.paramDefaultValue = 10,
		.type = ITEM_WEAPON,
		.basePrice = 9000,
		.objectModel = 347,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.043, 0.06, -0.022},
		.leftRot = Float:{160.0, -0.1, -9.3},
		.occupiedSpace = 8,
		.extraId = WEAPON_TASER
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ESCOPETA_NO_LETAL,
		.name = "Escopeta no letal",
		.paramName = "Munici�n",
		.paramDefaultValue = 8,
		.type = ITEM_WEAPON,
		.basePrice = 12000,
		.objectModel = 349,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.035, 0.081, 0.023},
		.leftRot = Float:{154.4, 0.0, 0.0},
		.occupiedSpace = 30,
		.extraId = WEAPON_NON_LETAL_SHOTGUN
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CAJA_DE_PIZZA_1,
		.name = "Caja de pizza hub",
		.paramName = "Porciones",
		.paramDefaultValue = 8,
		.type = ITEM_BATCH,
		.basePrice = 250,
		.objectModel = 1582,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.035, 0.081, 0.023},
		.leftRot = Float:{154.4, 0.0, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CAJA_DE_PIZZA_2,
		.name = "Caja de pizza zoom",
		.paramName = "Porciones",
		.paramDefaultValue = 8,
		.type = ITEM_BATCH,
		.basePrice = 300,
		.objectModel = 19571,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.035, 0.081, 0.023},
		.leftRot = Float:{154.4, 0.0, 0.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PORCION_DE_PIZZA,
		.name = "Porci�n de pizza",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 50,
		.objectModel = 2881,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.035, 0.187, -0.013},
		.leftRot = Float:{175.2, 0.0, 30.6},
		.rightPos = Float:{-0.025, 0.0, 0.0},
		.rightRot = Float:{32.3, 0.0, 0.0},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA1,
		.name = "Pantalones jeans claros",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 400,
		.objectModel = 2391,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA2,
		.name = "Pantalones de gabardina",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 350,
		.objectModel = 2391,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA3,
		.name = "Pantalones americanos",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 300,
		.objectModel = 2391,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA4,
		.name = "Pantalones deportivos",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 150,
		.objectModel = 2390,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA5,
		.name = "Joggins oscuros",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 300,
		.objectModel = 2390,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA6,
		.name = "Buzo simple claro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 250,
		.objectModel = 2399,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA7,
		.name = "Remera gruesa de abrigo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 250,
		.objectModel = 2399,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA8,
		.name = "Buzo deportivo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 200,
		.objectModel = 2399,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA9,
		.name = "Remera manga larga negra",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 200,
		.objectModel = 2396,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_ROPA10,
		.name = "Sweater oscuro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 200,
		.objectModel = 2396,
		.leftPos = Float:{0.369000, -0.004999, 0.050999},
		.leftRot = Float:{0.0, -106.700134, 95.099967},
		.leftScale = Float:{0.572999, 0.656000, 0.813999},
		.rightPos = Float:{0.369000, -0.004999, 0.050999},
		.rightRot = Float:{0.0, -106.700134, 95.099967},
		.rightScale = Float:{0.572999, 0.656000, 0.813999},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_1,
		.name = "Tapaboca negro con calaveras",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18911,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_2,
		.name = "Tapaboca negro cl�sico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18912,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_3,
		.name = "Tapaboca verde cl�sico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18913,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_4,
		.name = "Tapaboca verde militar",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18914,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_5,
		.name = "Tapaboca rosa dise�o",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18915,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_6,
		.name = "Tapaboca amarillo dise�o",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18916,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_7,
		.name = "Tapaboca azul el�ctrico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18917,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_8,
		.name = "Tapaboca negro verdoso",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18918,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_9,
		.name = "Tapaboca blanco cl�sico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18919,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAPABOCA_10,
		.name = "Tapaboca de dise�o",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18920,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.172, 0.086, -0.026},
		.leftRot = Float:{0.0, 92.6, 0.0},
		.rightPos = Float:{0.166, 0.098, 0.021},
		.rightRot = Float:{0.0, 90.5, 0.0},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PASAMONTANAS,
		.name = "Pasamonta�as tejido",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 250,
		.objectModel = 19801,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.221, 0.0, -0.013},
		.leftRot = Float:{0.0, 92.0, -173.7},
		.rightPos = Float:{0.171, 0.0, 0.027},
		.rightRot = Float:{0.0, 73.3, -172.2},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MASCARA_TERROR_BLANCA,
		.name = "m�scara blanca de terror",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 19036,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.208, 0.044, -0.008},
		.leftRot = Float:{-100.2, 0.0, 0.0},
		.rightPos = Float:{0.197, 0.035, 0.0},
		.rightRot = Float:{-98.7, 0.0, 0.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA_POLICIA,
		.name = "Gorra de oficial de polic�a",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 500,
		.objectModel = 19521,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.184, 0.046, -0.041},
		.leftRot = Float:{159.7, -90.1, -77.7},
		.rightPos = Float:{0.132, 0.069, 0.038},
		.rightRot = Float:{1.0, 78.7, 110.7},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHALECO_1,
		.name = "Chaleco antibalas liviano",
		.paramName = "Integridad",
		.paramDefaultValue = 100,
		.type = ITEM_TOY,
		.basePrice = 1800,
		.objectModel = 1242,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.257, 0.0, 0.0},
		.leftRot = Float:{0.0, -99.0, 162.1},
		.rightPos = Float:{0.214, 0.0, 0.044},
		.rightRot = Float:{-10.2, -101.3, -178.3},
		.occupiedSpace = 35
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHALECO_2,
		.name = "Chaleco antibalas",
		.paramName = "Integridad",
		.paramDefaultValue = 100,
		.type = ITEM_TOY,
		.basePrice = 2000,
		.objectModel = 373,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.18, 0.102, 0.0},
		.leftRot = Float:{-163.0, -144.4, 44.2},
		.rightPos = Float:{0.142, -0.258, -0.015},
		.rightRot = Float:{22.8, -166.6, 33.9},
		.occupiedSpace = 35
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHALECO_3,
		.name = "Chaleco antibalas pesado",
		.paramName = "Integridad",
		.paramDefaultValue = 100,
		.type = ITEM_TOY,
		.basePrice = 2400,
		.objectModel = 19515,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.362, -0.032, 0.0},
		.leftRot = Float:{0.0, 0.0, -172.6},
		.rightPos = Float:{0.34, -0.068, 0.0},
		.rightRot = Float:{0.0, 0.0, 174.9},
		.occupiedSpace = 40
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHALECO_4,
		.name = "Chaleco antibalas policial",
		.paramName = "Integridad",
		.paramDefaultValue = 100,
		.type = ITEM_TOY,
		.basePrice = 2200,
		.objectModel = 19142,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.362, -0.032, 0.0},
		.leftRot = Float:{0.0, 0.0, -172.6},
		.rightPos = Float:{0.34, -0.068, 0.0},
		.rightRot = Float:{0.0, 0.0, 174.9},
		.occupiedSpace = 40
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MASCARA_GAS,
		.name = "m�scara de gas",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 1300,
		.objectModel = 19472,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.311, 0.0, 0.0},
		.leftRot = Float:{-85.4, 0.0, 0.0},
		.rightPos = Float:{0.3, 0.0, 0.0},
		.rightRot = Float:{-79.2, 0.0, 0.0},
		.occupiedSpace = 6
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_POT,
		.name = "Maceta",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 1800,
		.objectModel = 742,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_BOTH_HANDS | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.166, 0.116, 0.173},
		.leftRot = Float:{-84.4, 4.6, 5.2},
		.leftScale = Float:{0.55, 0.55, 0.32},
		.rightPos = Float:{0.166, 0.116, -0.153},
		.rightRot = Float:{-108.4, 2.5, 0.0},
		.rightScale = Float:{0.55, 0.55, 0.32},
		.occupiedSpace = 35
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_WEED_SEEDS,
		.name = "Bolsa de semillas de marihuana",
		.paramName = "Semillas",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 400,
		.objectModel = 11748,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK | ITEM_TAG_SPLIT,
		.leftPos = Float:{0.115, 0.061, -0.018},
		.leftRot = Float:{98.7, 36.7, 87.5},
		.rightPos = Float:{0.081, 0.035, 0.0},
		.rightRot = Float:{-96.6, -38.1, 87.1},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PACK_MARIHUANA,
		.name = "Paquete de marihuana",
		.paramName = "Gramos",
		.paramDefaultValue = 1,
		.type = ITEM_BATCH,
		.basePrice = 200,
		.objectModel = 1578,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_USE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK | ITEM_TAG_BLACK_MARKET | ITEM_TAG_SPLIT,
		.leftPos = Float:{0.152, 0.047, -0.014},
		.leftRot = Float:{-86.5, -26.7, 104.0},
		.leftScale = Float:{0.8, 0.8, 0.8},
		.rightPos = Float:{0.0, 0.025, 0.0},
		.rightRot = Float:{-101.7, 5.3, -95.1},
		.rightScale = Float:{0.8, 0.8, 0.8},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PORRO,
		.name = "Porro",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_DRUG,
		.basePrice = 100,
		.objectModel = 3027,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.0121, 0.035, -0.03},
		.leftRot = Float:{160.7, 87.3, 8.0},
		.rightPos = Float:{0.106, 0.032, 0.027},
		.rightRot = Float:{93.0, 15.9, 0.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FERTILIZER,
		.name = "Fertilizante",
		.paramName = "Gramos",
		.paramDefaultValue = 300,
		.type = ITEM_OTHER,
		.basePrice = 1500,
		.objectModel = 2663,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.0121, 0.035, -0.03},
		.leftRot = Float:{160.7, 87.3, 8.0},
		.rightPos = Float:{0.106, 0.032, 0.027},
		.rightRot = Float:{93.0, 15.9, 0.0},
		.occupiedSpace = 30
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PACK_COCAINA,
		.name = "Paquete de coca�na",
		.paramName = "Gramos",
		.paramDefaultValue = 1,
		.type = ITEM_BATCH,
		.basePrice = 550,
		.objectModel = 1575,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_USE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK | ITEM_TAG_BLACK_MARKET | ITEM_TAG_SPLIT,
		.leftPos = Float:{0.152, 0.047, -0.014},
		.leftRot = Float:{-86.5, -26.7, 104.0},
		.leftScale = Float:{0.8, 0.8, 0.8},
		.rightPos = Float:{0.0, 0.025, 0.0},
		.rightRot = Float:{-101.7, 5.3, -95.1},
		.rightScale = Float:{0.8, 0.8, 0.8},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PACK_EXTASIS,
		.name = "Paquete de �xtasis",
		.paramName = "Gramos",
		.paramDefaultValue = 1,
		.type = ITEM_BATCH,
		.basePrice = 750,
		.objectModel = 1577,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_USE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK | ITEM_TAG_BLACK_MARKET | ITEM_TAG_SPLIT,
		.leftPos = Float:{0.152, 0.047, -0.014},
		.leftRot = Float:{-86.5, -26.7, 104.0},
		.leftScale = Float:{0.8, 0.8, 0.8},
		.rightPos = Float:{0.0, 0.025, 0.0},
		.rightRot = Float:{-101.7, 5.3, -95.1},
		.rightScale = Float:{0.8, 0.8, 0.8},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_PACK_LSD,
		.name = "Plancha de LSD",
		.paramName = "Cartones",
		.paramDefaultValue = 1,
		.type = ITEM_BATCH,
		.basePrice = 850,
		.objectModel = 11736,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_USE | ITEM_TAG_THROW | ITEM_TAG_COMBINE | ITEM_TAG_STACK | ITEM_TAG_BLACK_MARKET | ITEM_TAG_SPLIT,
		.leftPos = Float:{0.152, 0.047, -0.014},
		.leftRot = Float:{-86.5, -26.7, 104.0},
		.leftScale = Float:{0.8, 0.8, 0.8},
		.rightPos = Float:{0.0, 0.025, 0.0},
		.rightRot = Float:{-101.7, 5.3, -95.1},
		.rightScale = Float:{0.8, 0.8, 0.8},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_COCAINA,
		.name = "Bolsa de coca�na",
		.paramName = "Usos",
		.paramDefaultValue = 1,
		.type = ITEM_DRUG,
		.basePrice = 100,
		.objectModel = 19874,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.115, 0.061, -0.018},
		.leftRot = Float:{98.7, 36.7, 87.5},
		.rightPos = Float:{0.081, 0.035, 0.0},
		.rightRot = Float:{-96.6, -38.1, 87.1},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_EXTASIS,
		.name = "Pastilla de �xtasis",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_DRUG,
		.basePrice = 100,
		.objectModel = 1899,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.0121, 0.035, -0.03},
		.leftRot = Float:{160.7, 87.3, 8.0},
		.rightPos = Float:{0.106, 0.032, 0.027},
		.rightRot = Float:{93.0, 15.9, 0.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_LSD,
		.name = "Cart�n de LSD",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_DRUG,
		.basePrice = 100,
		.objectModel = 1909,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.0121, 0.035, -0.03},
		.leftRot = Float:{160.7, 87.3, 8.0},
		.rightPos = Float:{0.106, 0.032, 0.027},
		.rightRot = Float:{93.0, 15.9, 0.0},
		.occupiedSpace = 5
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCO_BOMBERO1,
		.name = "Casco de bombero amarillo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 900,
		.objectModel = 19330,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.184, 0.046, -0.041},
		.leftRot = Float:{159.7, -90.1, -77.7},
		.rightPos = Float:{0.132, 0.069, 0.038},
		.rightRot = Float:{1.0, 78.7, 110.7},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCO_BOMBERO2,
		.name = "Casco de bombero negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 900,
		.objectModel = 19331,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.184, 0.046, -0.041},
		.leftRot = Float:{159.7, -90.1, -77.7},
		.rightPos = Float:{0.132, 0.069, 0.038},
		.rightRot = Float:{1.0, 78.7, 110.7},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FACA_TUMBERA,
		.name = "Faca tumbera",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 400,
		.objectModel = 11716,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.101999, 0.024999, -0.113000},
		.leftRot = Float:{89.599960, 0.000000, -172.300094},
		.leftScale = Float:{1.090000, 1.236000, 1.636999},
		.rightPos = Float:{0.061999, 0.035999, 0.114999},
		.rightRot = Float:{89.599960, 0.000000, 8.099999},
		.rightScale = Float:{1.090000, 1.236000, 1.636999},
		.occupiedSpace = 6,
		.extraId = WEAPON_FACA_TUMBERA
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TACTIC_KNIFE,
		.name = "Cuchillo t�ctico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 800,
		.objectModel = 335,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{-0.002000, 0.073000, -0.018000},
		.leftRot = Float:{160.899963, -2.000005, 0.000000},
		.leftScale = Float:{1.195999, 1.000000, 0.852999},
		.rightPos = Float:{-0.021000, -0.002999, 0.000999},
		.rightRot = Float:{0.000000, -2.000005, 0.000000},
		.rightScale = Float:{1.195999, 1.000000, 0.852999},
		.occupiedSpace = 6,
		.extraId = WEAPON_TACTIC_KNIFE
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHEF_KNIFE,
		.name = "Cuchillo de chef",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 500,
		.objectModel = 19583,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.087999, 0.031999, -0.011000},
		.leftRot = Float:{76.700080, -177.299819, -7.999999},
		.leftScale = Float:{1.227999, 0.849999, 1.000000},
		.rightPos = Float:{0.085999, 0.031999, 0.003999},
		.rightRot = Float:{-89.499923, -177.299819, 5.999997},
		.rightScale = Float:{1.227999, 0.849999, 1.000000},
		.occupiedSpace = 6,
		.extraId = WEAPON_CHEF_KNIFE
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SLEDGEHAMMER,
		.name = "Maza de dos manos",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 800,
		.objectModel = 19631,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.159999, -0.085999, -0.354999},
		.leftRot = Float:{-5.799996, 77.599967, 77.299934},
		.leftScale = Float:{1.000000, 1.121000, 1.000000},
		.rightPos = Float:{0.072999, 0.013000, 0.389000},
		.rightRot = Float:{-4.499998, 90.899986, -83.300041},
		.rightScale = Float:{1.000000, 1.121000, 1.000000},
		.occupiedSpace = 25,
		.extraId = WEAPON_SLEDGEHAMMER
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BERSA_BP9,
		.name = "Pistola Bersa BP9CC",
		.paramName = "Munici�n",
		.paramDefaultValue = 17,
		.type = ITEM_WEAPON,
		.basePrice = 8100,
		.objectModel = 346,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.009, 0.061, -0.025},
		.leftRot = Float:{150.9, 8.6, -11.7},
		.occupiedSpace = 8,
		.extraId = WEAPON_BERSA_BP9
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GLOCK_19,
		.name = "Pistola Glock 19",
		.paramName = "Munici�n",
		.paramDefaultValue = 17,
		.type = ITEM_WEAPON,
		.basePrice = 8700,
		.objectModel = 346,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.009, 0.061, -0.025},
		.leftRot = Float:{150.9, 8.6, -11.7},
		.occupiedSpace = 8,
		.extraId = WEAPON_GLOCK_19
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BALLESTER_MOLINA_45,
		.name = "Pistola Ballester Molina .45",
		.paramName = "Munici�n",
		.paramDefaultValue = 7,
		.type = ITEM_WEAPON,
		.basePrice = 15200,
		.objectModel = 348,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.011, 0.058, 0.0},
		.leftRot = Float:{-178.3, 0.0, 0.0},
		.occupiedSpace = 10,
		.extraId = WEAPON_BALLESTER_MOLINA_45
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BERSA_TPR_45,
		.name = "Pistola Bersa TPR-45C",
		.paramName = "Munici�n",
		.paramDefaultValue = 7,
		.type = ITEM_WEAPON,
		.basePrice = 14400,
		.objectModel = 348,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.011, 0.058, 0.0},
		.leftRot = Float:{-178.3, 0.0, 0.0},
		.occupiedSpace = 10,
		.extraId = WEAPON_BERSA_TPR_45
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_REVOLVER_ROSSI_38,
		.name = "Revolver Rossi Cal.38 Spl",
		.paramName = "Munici�n",
		.paramDefaultValue = 7,
		.type = ITEM_WEAPON,
		.basePrice = 13600,
		.objectModel = 348,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.011, 0.058, 0.0},
		.leftRot = Float:{-178.3, 0.0, 0.0},
		.occupiedSpace = 9,
		.extraId = WEAPON_REVOLVER_ROSSI_38
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_REVOLVER_SW_60,
		.name = "Revolver S&W 60 357 corto",
		.paramName = "Munici�n",
		.paramDefaultValue = 7,
		.type = ITEM_WEAPON,
		.basePrice = 14000,
		.objectModel = 348,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.011, 0.058, 0.0},
		.leftRot = Float:{-178.3, 0.0, 0.0},
		.occupiedSpace = 9,
		.extraId = WEAPON_REVOLVER_SW_60
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MOSSBERG_500,
		.name = "Escopeta Mossberg 500",
		.paramName = "Munici�n",
		.paramDefaultValue = 8,
		.type = ITEM_WEAPON,
		.basePrice = 16000,
		.objectModel = 349,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.035, 0.081, 0.023},
		.leftRot = Float:{154.4, 0.0, 0.0},
		.occupiedSpace = 30,
		.extraId = WEAPON_MOSSBERG_500
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_REMINGTON_870,
		.name = "Escopeta Remington 870",
		.paramName = "Munici�n",
		.paramDefaultValue = 8,
		.type = ITEM_WEAPON,
		.basePrice = 15000,
		.objectModel = 349,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.035, 0.081, 0.023},
		.leftRot = Float:{154.4, 0.0, 0.0},
		.occupiedSpace = 30,
		.extraId = WEAPON_REMINGTON_870
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BATAAN_71,
		.name = "Escopeta Bataan 71",
		.paramName = "Munici�n",
		.paramDefaultValue = 8,
		.type = ITEM_WEAPON,
		.basePrice = 14500,
		.objectModel = 349,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.035, 0.081, 0.023},
		.leftRot = Float:{154.4, 0.0, 0.0},
		.occupiedSpace = 30,
		.extraId = WEAPON_BATAAN_71
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SAWEDOFF_TUMBERA,
		.name = "Escopeta tumbera",
		.paramName = "Munici�n",
		.paramDefaultValue = 2,
		.type = ITEM_WEAPON,
		.basePrice = 13500,
		.objectModel = 350,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.026, 0.058, -0.023},
		.leftRot = Float:{170.9, 0.0, 0.0},
		.occupiedSpace = 18,
		.extraId = WEAPON_SAWEDOFF_TUMBERA
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAURUS_PT_92,
		.name = "Pistola Taurus PT92",
		.paramName = "Munici�n",
		.paramDefaultValue = 17,
		.type = ITEM_WEAPON,
		.basePrice = 8400,
		.objectModel = 346,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.009, 0.061, -0.025},
		.leftRot = Float:{150.9, 8.6, -11.7},
		.occupiedSpace = 8,
		.extraId = WEAPON_TAURUS_PT_92
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BENELLI_M3_S90,
		.name = "Escopeta Benelli M3 Super 90",
		.paramName = "Munici�n",
		.paramDefaultValue = 7,
		.type = ITEM_WEAPON,
		.basePrice = 30000,
		.objectModel = 351,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.024, 0.059, -0.01},
		.leftRot = Float:{172.9, 0.0, 0.0},
		.occupiedSpace = 35,
		.extraId = WEAPON_BENELLI_M3_S90
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_AKKAR_12_70,
		.name = "Escopeta Akkar 12/70",
		.paramName = "Munici�n",
		.paramDefaultValue = 7,
		.type = ITEM_WEAPON,
		.basePrice = 28000,
		.objectModel = 351,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.024, 0.059, -0.01},
		.leftRot = Float:{172.9, 0.0, 0.0},
		.occupiedSpace = 35,
		.extraId = WEAPON_AKKAR_12_70
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_STEYR_MPI_69,
		.name = "Subfusil Steyr MPi 69",
		.paramName = "Munici�n",
		.paramDefaultValue = 50,
		.type = ITEM_WEAPON,
		.basePrice = 17000,
		.objectModel = 352,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.024, 0.051, -0.022},
		.leftRot = Float:{167.6, 0.0, 0.0},
		.occupiedSpace = 15,
		.extraId = WEAPON_STEYR_MPI_69
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FMK_3,
		.name = "Subfusil FMK-3",
		.paramName = "Munici�n",
		.paramDefaultValue = 50,
		.type = ITEM_WEAPON,
		.basePrice = 17500,
		.objectModel = 352,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.024, 0.051, -0.022},
		.leftRot = Float:{167.6, 0.0, 0.0},
		.occupiedSpace = 18,
		.extraId = WEAPON_FMK_3
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BERETTA_93R,
		.name = "Pistola Ametralladora Beretta 93R",
		.paramName = "Munici�n",
		.paramDefaultValue = 50,
		.type = ITEM_WEAPON,
		.basePrice = 16000,
		.objectModel = 352,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.024, 0.051, -0.022},
		.leftRot = Float:{167.6, 0.0, 0.0},
		.occupiedSpace = 13,
		.extraId = WEAPON_BERETTA_93R
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_HECKLER_KOCH_UMP9,
		.name = "Subfusil Heckler & Koch UMP9",
		.paramName = "Munici�n",
		.paramDefaultValue = 30,
		.type = ITEM_WEAPON,
		.basePrice = 27500,
		.objectModel = 353,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.03, 0.065, 0.0},
		.leftRot = Float:{163.8, 0.0, 0.0},
		.occupiedSpace = 25,
		.extraId = WEAPON_HECKLER_KOCH_UMP9
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAURUS_SMT9,
		.name = "Subfusil Taurus SMT9",
		.paramName = "Munici�n",
		.paramDefaultValue = 30,
		.type = ITEM_WEAPON,
		.basePrice = 27000,
		.objectModel = 353,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.03, 0.065, 0.0},
		.leftRot = Float:{163.8, 0.0, 0.0},
		.occupiedSpace = 25,
		.extraId = WEAPON_TAURUS_SMT9
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FAMAE_SAF,
		.name = "Subfusil Famae SAF",
		.paramName = "Munici�n",
		.paramDefaultValue = 30,
		.type = ITEM_WEAPON,
		.basePrice = 26500,
		.objectModel = 353,
		.itemTag = ITEM_TAG_BACK | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.03, 0.065, 0.0},
		.leftRot = Float:{163.8, 0.0, 0.0},
		.occupiedSpace = 25,
		.extraId = WEAPON_FAMAE_SAF
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_INGRAM_MAC10,
		.name = "Pistola Ametralladora Ingram MAC-10",
		.paramName = "Munici�n",
		.paramDefaultValue = 50,
		.type = ITEM_WEAPON,
		.basePrice = 18000,
		.objectModel = 372,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.022, 0.067, 0.0},
		.leftRot = Float:{168.5, 0.0, 0.0},
		.occupiedSpace = 13,
		.extraId = WEAPON_INGRAM_MAC10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SKORPION_VZ68,
		.name = "Subfusil Skorpion vz. 68",
		.paramName = "Munici�n",
		.paramDefaultValue = 50,
		.type = ITEM_WEAPON,
		.basePrice = 18500,
		.objectModel = 372,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_HOLSTER,
		.leftPos = Float:{0.022, 0.067, 0.0},
		.leftRot = Float:{168.5, 0.0, 0.0},
		.occupiedSpace = 14,
		.extraId = WEAPON_SKORPION_VZ68
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOTELLA_GASEOSA,
		.name = "Botella de gaseosa",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 75,
		.objectModel = 1544,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_LATA_GASEOSA,
		.name = "Lata de Gaseosa",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 45,
		.objectModel = 2601,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOTELLA_FERNET,
		.name = "Botella de Fernet",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 400,
		.objectModel = 19822,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_VASO_FERNET,
		.name = "Vaso de Fernet",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 120,
		.objectModel = 1455,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOTELLA_GANCIA,
		.name = "Botella de Gancia",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 300,
		.objectModel = 19820,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_VASO_GANCIA,
		.name = "Vaso de Gancia",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 100,
		.objectModel = 1455,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 4
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHAMPAGNE,
		.name = "Botella de Champagne",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 400,
		.objectModel = 19824,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TEQUILA,
		.name = "Botella de Tequila",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 380,
		.objectModel = 19823,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 7
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_LICOR,
		.name = "Botella de Licor",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 200,
		.objectModel = 19821,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CAMPARI,
		.name = "Botella de Campari",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 275,
		.objectModel = 19820,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RON_CALIDAD,
		.name = "Botella de Ron de calidad",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 750,
		.objectModel = 19821,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_WHISKY_CALIDAD,
		.name = "Botella de Whisky de calidad",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 1000,
		.objectModel = 19823,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_VODKA_CALIDAD,
		.name = "Botella de Vodka de calidad",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 800,
		.objectModel = 1668,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_VINO_CALIDAD,
		.name = "Botella de Vino de calidad",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 600,
		.objectModel = 19822,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHAMPAGNE_CALIDAD,
		.name = "Botella de Champagne de calidad",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 900,
		.objectModel = 19824,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TEQUILA_CALIDAD,
		.name = "Botella de Tequila de Calidad",
		.paramName = "Usos",
		.paramDefaultValue = 3,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 950,
		.objectModel = 19823,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.129, 0.039, 0.061},
		.leftRot = Float:{-7.5, -161.6, -28.1},
		.leftScale = Float:{0.51, 0.716, 0.752},
		.rightPos = Float:{0.084, 0.031, -0.081},
		.rightRot = Float:{0.0, 0.0, 10.3},
		.rightScale = Float:{0.51, 0.716, 0.752},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_HAMB_COMBO_DELUXE,
		.name = "Combo Hamburguesa Deluxe",
		.paramName = "Usos",
		.paramDefaultValue = 5,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 500,
		.objectModel = 2214,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.112, 0.062, -0.009},
		.leftRot = Float:{-112.0, 42.501, 96.9},
		.rightPos = Float:{0.095, 0.109, -0.01},
		.rightRot = Float:{5.3, 5.508, -106.7},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SAND_COMBO_DELUXE,
		.name = "Combo Sandwich Deluxe",
		.paramName = "Usos",
		.paramDefaultValue = 5,
		.type = ITEM_BASIC_NEEDS,
		.basePrice = 500,
		.objectModel = 2214,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.112, 0.062, -0.009},
		.leftRot = Float:{-112.0, 42.501, 96.9},
		.rightPos = Float:{0.095, 0.109, -0.01},
		.rightRot = Float:{5.3, 5.508, -106.7},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA_POLICIA2,
		.name = "Gorra de Policia",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 300,
		.objectModel = 18636,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO_NEGRO,
		.name = "Sombrero negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 225,
		.objectModel = 18639,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 20
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FAKE_HAIR,
		.name = "Peluca",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 100,
		.objectModel = 18640,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 8
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA1,
		.name = "Pa�uelo azul oscuro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18891,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA2,
		.name = "Pa�uelo rojo oscuro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18892,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA3,
		.name = "Pa�uelo blanco y rojo a rayas",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 170,
		.objectModel = 18893,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA4,
		.name = "Pa�uelo amarillo chalas",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 175,
		.objectModel = 18894,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA5,
		.name = "Pa�uelo negro calaveras",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 160,
		.objectModel = 18895,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA6,
		.name = "Pa�uelo negro cl�sico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 18896,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA7,
		.name = "Pa�uelo azul cl�sico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 18897,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA8,
		.name = "Pa�uelo verde cl�sico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 18898,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA9,
		.name = "Pa�uelo rosa cl�sico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 180,
		.objectModel = 18899,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA10,
		.name = "Pa�uelo colores trip",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18900,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA11,
		.name = "Pa�uelo animal print",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 175,
		.objectModel = 18901,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA12,
		.name = "Pa�uelo amarillo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 160,
		.objectModel = 18902,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA13,
		.name = "Pa�uelo lila",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18903,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA14,
		.name = "Pa�uelo dise�o electrico",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18904,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA15,
		.name = "Pa�uelo dorado",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 170,
		.objectModel = 18905,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA16,
		.name = "Pa�uelo naranja dise�o",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 160,
		.objectModel = 18906,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA17,
		.name = "Pa�uelo colores trip 2",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18907,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA18,
		.name = "Pa�uelo azul dise�o",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 170,
		.objectModel = 18908,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA19,
		.name = "Pa�uelo claro dise�o",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 160,
		.objectModel = 18909,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BANDANA20,
		.name = "Pa�uelo naranja dise�o 2",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 160,
		.objectModel = 18910,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOINA1,
		.name = "Boina negra",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 140,
		.objectModel = 18921,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOINA2,
		.name = "Boina roja",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 140,
		.objectModel = 18922,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOINA3,
		.name = "Boina azul",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 140,
		.objectModel = 18923,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOINA4,
		.name = "Boina militar",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 175,
		.objectModel = 18924,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOINA5,
		.name = "Boina roja 2",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18925,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-112.7, 70.6, -24.1},
		.rightPos = Float:{0.166, 0.066, -0.016},
		.rightRot = Float:{176.3, -87.3, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA1,
		.name = "Gorra azul dise�o",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 145,
		.objectModel = 18927,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA2,
		.name = "Gorra rosa trip",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 125,
		.objectModel = 18928,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA3,
		.name = "Gorra roja fuego",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 125,
		.objectModel = 18930,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA4,
		.name = "Gorra estampada electrica",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 135,
		.objectModel = 18931,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA5,
		.name = "Gorra naranja dise�o",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 125,
		.objectModel = 18932,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA6,
		.name = "Gorra roja",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 145,
		.objectModel = 18934,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA7,
		.name = "Gorra amarilla",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 145,
		.objectModel = 18935,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRA8,
		.name = "Gorra de camionero",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 150,
		.objectModel = 18961,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CHALECO_REFRACTARIO,
		.name = "Chaleco refractario",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 750,
		.objectModel = 19904,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 30
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCO_CORTO1,
		.name = "Casco corto blanco",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 190,
		.objectModel = 18936,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCO_CORTO2,
		.name = "Casco corto rojo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 190,
		.objectModel = 18937,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCO_CORTO3,
		.name = "Casco corto gris",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 190,
		.objectModel = 18938,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 10
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO1,
		.name = "Sombrero naranja",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 18944,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO2,
		.name = "Sombrero gris",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 200,
		.objectModel = 18945,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO3,
		.name = "Sombrero claro con franja",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 220,
		.objectModel = 18946,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO4,
		.name = "Sombrero negro 2",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 220,
		.objectModel = 18947,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO5,
		.name = "Sombrero celeste y negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 220,
		.objectModel = 18948,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO6,
		.name = "Sombrero verde y negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 220,
		.objectModel = 18949,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO7,
		.name = "Sombrero rojo y negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 220,
		.objectModel = 18950,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO8,
		.name = "Sombrero amarillo y negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 220,
		.objectModel = 18951,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCO_BOXEO,
		.name = "Casco de boxeo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 300,
		.objectModel = 18952,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRO_LANA1,
		.name = "Gorro de lana negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 120,
		.objectModel = 18953,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRO_LANA2,
		.name = "Gorro de lana gris",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 120,
		.objectModel = 18954,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SOMBRERO9,
		.name = "Sombrero negro 3",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 230,
		.objectModel = 18962,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MASCARA_CJ,
		.name = "Mascara de Carlos",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 500,
		.objectModel = 18963,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 15
	);
	
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRO_LANA3,
		.name = "Gorro de lana en punta negro",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 120,
		.objectModel = 18964,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_GORRO_LANA4,
		.name = "Gorro de lana en punta gris",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 120,
		.objectModel = 18965,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.192, 0.083, -0.043},
		.leftRot = Float:{-93.4, -85.8, 12.6},
		.rightPos = Float:{0.16, 0.06, 0.032},
		.rightRot = Float:{96.4, 67.9, -3.5},
		.occupiedSpace = 12
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CASCO_SWAT1,
		.name = "Casco t�ctico de policia",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_TOY,
		.basePrice = 400,
		.objectModel = 19141,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.183, 0.053, -0.026},
		.leftRot = Float:{-139.1, -78.7, -30.1},
		.rightPos = Float:{0.156, 0.072, 0.009},
		.rightRot = Float:{168.8, 99.6, -68.0},
		.occupiedSpace = 15
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FLASHBANG,
		.name = "Granada cegadora",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_WEAPON,
		.basePrice = 2000,
		.objectModel = 343,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE | ITEM_TAG_COMBINE | ITEM_TAG_STACK,
		.leftPos = Float:{0.024, 0.084, -0.029},
		.leftRot = Float:{161.3, 0.0, 0.0},
		.occupiedSpace = 6,
		.extraId = WEAPON_FLASHBANG
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_COLT_MAGAZINE,
		.name = "Cargador de 9mm",
		.paramName = "Balas",
		.paramDefaultValue = 17,
		.type = ITEM_MAGAZINE,
		.basePrice = 1500,
		.objectModel = 19995,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_FIX_PRICE | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.1, 0.010, 0.0},
		.leftRot = Float:{-6.4, -154.2, -103.9},
		.rightPos = Float:{0.067, 0.039, 0.0},
		.rightRot = Float:{8.4, -30.3, 88.3},
		.occupiedSpace = 3
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_DEAGLE_MAGAZINE,
		.name = "Cargador de .50",
		.paramName = "Balas",
		.paramDefaultValue = 7,
		.type = ITEM_MAGAZINE,
		.basePrice = 2500,
		.objectModel = 19995,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_FIX_PRICE | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.1, 0.010, 0.0},
		.leftRot = Float:{-6.4, -154.2, -103.9},
		.rightPos = Float:{0.067, 0.039, 0.0},
		.rightRot = Float:{8.4, -30.3, 88.3},
		.occupiedSpace = 3
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_SHOTGUN_SHELLS,
		.name = "Cartuchos de escopeta",
		.paramName = "Cantidad",
		.paramDefaultValue = 8,
		.type = ITEM_MAGAZINE,
		.basePrice = 2000,
		.objectModel = 2039,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_FIX_PRICE | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.078, 0.042, -0.039},
		.leftRot = Float:{161.9, -90.8, -17.5},
		.rightPos = Float:{0.062, 0.042, 0.038},
		.rightRot = Float:{161.9, 107.2, 15.1},
		.occupiedSpace = 5
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_UZI_MAGAZINE,
		.name = "Cargador de UZI/TEC",
		.paramName = "Balas",
		.paramDefaultValue = 50,
		.type = ITEM_MAGAZINE,
		.basePrice = 2700,
		.objectModel = 19995,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.1, 0.010, 0.0},
		.leftRot = Float:{-6.4, -154.2, -103.9},
		.rightPos = Float:{0.067, 0.039, 0.0},
		.rightRot = Float:{8.4, -30.3, 88.3},
		.occupiedSpace = 5
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_MP5_MAGAZINE,
		.name = "Cargador de SMG",
		.paramName = "Balas",
		.paramDefaultValue = 30,
		.type = ITEM_MAGAZINE,
		.basePrice = 2800,
		.objectModel = 19995,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.1, 0.010, 0.0},
		.leftRot = Float:{-6.4, -154.2, -103.9},
		.rightPos = Float:{0.067, 0.039, 0.0},
		.rightRot = Float:{8.4, -30.3, 88.3},
		.occupiedSpace = 4
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_AK47_MAGAZINE,
		.name = "Cargador de 7.62",
		.paramName = "Balas",
		.paramDefaultValue = 30,
		.type = ITEM_MAGAZINE,
		.basePrice = 3000,
		.objectModel = 19995,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_FIX_PRICE | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.1, 0.010, 0.0},
		.leftRot = Float:{-6.4, -154.2, -103.9},
		.rightPos = Float:{0.067, 0.039, 0.0},
		.rightRot = Float:{8.4, -30.3, 88.3},
		.occupiedSpace = 6
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_M4_MAGAZINE,
		.name = "Cargador de 5.56",
		.paramName = "Balas",
		.paramDefaultValue = 50,
		.type = ITEM_MAGAZINE,
		.basePrice = 3100,
		.objectModel = 19995,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_FIX_PRICE | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.1, 0.010, 0.0},
		.leftRot = Float:{-6.4, -154.2, -103.9},
		.rightPos = Float:{0.067, 0.039, 0.0},
		.rightRot = Float:{8.4, -30.3, 88.3},
		.occupiedSpace = 6
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_RIFLE_BULLETS,
		.name = "Balas de rifle",
		.paramName = "Cantidad",
		.paramDefaultValue = 20,
		.type = ITEM_MAGAZINE,
		.basePrice = 3500,
		.objectModel = 2039,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_FIX_PRICE | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.078, 0.042, -0.039},
		.leftRot = Float:{161.9, -90.8, -17.5},
		.rightPos = Float:{0.062, 0.042, 0.038},
		.rightRot = Float:{161.9, 107.2, 15.1},
		.occupiedSpace = 5
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_LESSLETHAL_SHELL,
		.name = "Cartuchos no letales",
		.paramName = "Cantidad",
		.paramDefaultValue = 8,
		.type = ITEM_MAGAZINE,
		.basePrice = 2200,
		.objectModel = 2039,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_FIX_PRICE | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.078, 0.042, -0.039},
		.leftRot = Float:{161.9, -90.8, -17.5},
		.rightPos = Float:{0.062, 0.042, 0.038},
		.rightRot = Float:{161.9, 107.2, 15.1},
		.occupiedSpace = 5
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TAZER_CHARGE,
		.name = "Cargas de taser",
		.paramName = "Cantidad",
		.paramDefaultValue = 10,
		.type = ITEM_MAGAZINE,
		.basePrice = 500,
		.objectModel = 19995,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_FIX_PRICE | ITEM_TAG_COMBINE,
		.leftPos = Float:{0.1, 0.010, 0.0},
		.leftRot = Float:{-6.4, -154.2, -103.9},
		.rightPos = Float:{0.067, 0.039, 0.0},
		.rightRot = Float:{8.4, -30.3, 88.3},
		.occupiedSpace = 2
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOX_COLT_MAG,
		.name = "Caja de cargadores de 9mm",
		.paramName = "Cargadores",
		.paramDefaultValue = 20,
		.type = ITEM_BATCH,
		.basePrice = 15000,
		.objectModel = 19832,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.322, 0.014, 0.0},
		.leftRot = Float:{0.0, -91.7, -8.5},
		.rightPos = Float:{0.317, 0.035, 0.109},
		.rightRot = Float:{0.0, -108.5, 0.0},
		.occupiedSpace = 25
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOX_DEAGLE_MAG,
		.name = "Caja de cargadores de .50",
		.paramName = "Cargadores",
		.paramDefaultValue = 20,
		.type = ITEM_BATCH,
		.basePrice = 17000,
		.objectModel = 19832,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.322, 0.014, 0.0},
		.leftRot = Float:{0.0, -91.7, -8.5},
		.rightPos = Float:{0.317, 0.035, 0.109},
		.rightRot = Float:{0.0, -108.5, 0.0},
		.occupiedSpace = 25
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOX_SHOTGUN_SHELL,
		.name = "Caja de cartuchos de escopeta",
		.paramName = "Cartuchos",
		.paramDefaultValue = 15,
		.type = ITEM_BATCH,
		.basePrice = 20000,
		.objectModel = 19832,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.322, 0.014, 0.0},
		.leftRot = Float:{0.0, -91.7, -8.5},
		.rightPos = Float:{0.317, 0.035, 0.109},
		.rightRot = Float:{0.0, -108.5, 0.0},
		.occupiedSpace = 25
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOX_UZI_MAG,
		.name = "Caja de cargadores de UZI/TEC",
		.paramName = "Cargadores",
		.paramDefaultValue = 15,
		.type = ITEM_BATCH,
		.basePrice = 23000,
		.objectModel = 19832,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.322, 0.014, 0.0},
		.leftRot = Float:{0.0, -91.7, -8.5},
		.rightPos = Float:{0.317, 0.035, 0.109},
		.rightRot = Float:{0.0, -108.5, 0.0},
		.occupiedSpace = 25
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOX_MP5_MAG,
		.name = "Caja de cargadores de SMG",
		.paramName = "Cargadores",
		.paramDefaultValue = 20,
		.type = ITEM_BATCH,
		.basePrice = 25000,
		.objectModel = 19832,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.322, 0.014, 0.0},
		.leftRot = Float:{0.0, -91.7, -8.5},
		.rightPos = Float:{0.317, 0.035, 0.109},
		.rightRot = Float:{0.0, -108.5, 0.0},
		.occupiedSpace = 25
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOX_AK47_MAG,
		.name = "Caja de cargadores de 7.62",
		.paramName = "Cargadores",
		.paramDefaultValue = 10,
		.type = ITEM_BATCH,
		.basePrice = 30000,
		.objectModel = 19832,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.322, 0.014, 0.0},
		.leftRot = Float:{0.0, -91.7, -8.5},
		.rightPos = Float:{0.317, 0.035, 0.109},
		.rightRot = Float:{0.0, -108.5, 0.0},
		.occupiedSpace = 25
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOX_M4_MAG,
		.name = "Caja de cargadores de 5.56",
		.paramName = "Cargadores",
		.paramDefaultValue = 10,
		.type = ITEM_BATCH,
		.basePrice = 32000,
		.objectModel = 19832,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.322, 0.014, 0.0},
		.leftRot = Float:{0.0, -91.7, -8.5},
		.rightPos = Float:{0.317, 0.035, 0.109},
		.rightRot = Float:{0.0, -108.5, 0.0},
		.occupiedSpace = 25
	);
	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_BOX_RIFLE_BULLETS,
		.name = "Caja de balas de rifle",
		.paramName = "Balas",
		.paramDefaultValue = 15,
		.type = ITEM_BATCH,
		.basePrice = 35000,
		.objectModel = 19832,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.322, 0.014, 0.0},
		.leftRot = Float:{0.0, -91.7, -8.5},
		.rightPos = Float:{0.317, 0.035, 0.109},
		.rightRot = Float:{0.0, -108.5, 0.0},
		.occupiedSpace = 25
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_FRENCH_DECK,
		.name = "Mazo de poker",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 150,
		.objectModel = 19897,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET | ITEM_TAG_FIX_PRICE,
		.leftPos = Float:{0.108, 0.037, -0.046},
		.leftRot = Float:{95.6, 30.7, 175.4},
		.rightPos = Float:{0.081, 0.02, 0.024},
		.rightRot = Float:{76.6, 24.2, 11.5},
		.occupiedSpace = 2
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_TUNING_PART,
		.name = "Pieza de tuneo",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 2500,
		.objectModel = 19918,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.109, 0.072, 0.184},
		.leftRot = Float:{98.6, 0.0, 0.0},
		.rightPos = Float:{0.109, 0.072, 0.184},
		.rightRot = Float:{98.6, 0.0, 1.0},
		.occupiedSpace = 15
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_CAJAHERRAMIENTAS,
		.name = "Caja de herramientas",
		.paramName = "Usos",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 1000,
		.objectModel = 19921,
		.itemTag = ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_USE,
		.leftPos = Float:{0.014, 0.0, 0.0},
		.leftRot = Float:{-90.0, 0.0, 270.0},
		.rightPos = Float:{0.0, 0.0, -0.0},
		.rightRot = Float:{-90.0, 0.0, 270.0},
		.occupiedSpace = 60
	);

	ItemModel_SetNewDataId(
		.itemid = ITEM_ID_COPPER_WIRE,
		.name = "Cable de Cobre",
		.paramName = "Cantidad",
		.paramDefaultValue = 1,
		.type = ITEM_OTHER,
		.basePrice = 900, 
		.objectModel = 1944,
		.itemTag = ITEM_TAG_INV | ITEM_TAG_SAVE | ITEM_TAG_GIVE | ITEM_TAG_THROW | ITEM_TAG_STACK | ITEM_TAG_BLACK_MARKET,
		.leftPos = Float:{0.03, 0.06, 0.02},
		.leftRot = Float:{0.0, 0.0, 0.0},
		.leftScale = Float:{1.0, 1.0, 1.0},
		.rightPos = Float:{0.03, 0.06, 0.02},
		.rightRot = Float:{0.0, 0.0, 0.0},
		.rightScale = Float:{1.0, 1.0, 1.0},
		.occupiedSpace = 6
	);


}

stock ItemModel_IsValidId(itemid) {
	return (0 < itemid < ITEM_MODEL_MAX_AMOUNT && ServerItemModels[itemid][Type] != ITEM_NONE);
}

stock ItemModel_GetLeftPos(itemid, &Float:x, &Float:y, &Float:z)
{
	x = ServerItemModels[itemid][LeftPos][0];
	y = ServerItemModels[itemid][LeftPos][1];
	z = ServerItemModels[itemid][LeftPos][2];
}

stock ItemModel_GetLeftRot(itemid, &Float:x, &Float:y, &Float:z)
{
	x = ServerItemModels[itemid][LeftRot][0];
	y = ServerItemModels[itemid][LeftRot][1];
	z = ServerItemModels[itemid][LeftRot][2];
}

stock ItemModel_GetLeftScale(itemid, &Float:x, &Float:y, &Float:z)
{
	x = ServerItemModels[itemid][LeftScale][0];
	y = ServerItemModels[itemid][LeftScale][1];
	z = ServerItemModels[itemid][LeftScale][2];
}

stock ItemModel_GetRightPos(itemid, &Float:x, &Float:y, &Float:z)
{
	x = ServerItemModels[itemid][RightPos][0];
	y = ServerItemModels[itemid][RightPos][1];
	z = ServerItemModels[itemid][RightPos][2];
}

stock ItemModel_GetRightRot(itemid, &Float:x, &Float:y, &Float:z)
{
	x = ServerItemModels[itemid][RightRot][0];
	y = ServerItemModels[itemid][RightRot][1];
	z = ServerItemModels[itemid][RightRot][2];
}

stock ItemModel_GetRightScale(itemid, &Float:x, &Float:y, &Float:z)
{
	x = ServerItemModels[itemid][RightScale][0];
	y = ServerItemModels[itemid][RightScale][1];
	z = ServerItemModels[itemid][RightScale][2];
}

stock ItemModel_AttachOnHand(playerid, itemid, hand)
{
	if(hand == HAND_RIGHT) {
		SetPlayerAttachedObject(playerid, ATTACH_INDEX_ID_HAND_RIGHT, ServerItemModels[itemid][ObjectModel], ATTACH_BONE_ID_RIGHT_HAND, ServerItemModels[itemid][RightPos][0], ServerItemModels[itemid][RightPos][1], ServerItemModels[itemid][RightPos][2], ServerItemModels[itemid][RightRot][0], ServerItemModels[itemid][RightRot][1], ServerItemModels[itemid][RightRot][2], ServerItemModels[itemid][RightScale][0], ServerItemModels[itemid][RightScale][1], ServerItemModels[itemid][RightScale][2]);
	} else {
		SetPlayerAttachedObject(playerid, ATTACH_INDEX_ID_HAND_LEFT, ServerItemModels[itemid][ObjectModel], ATTACH_BONE_ID_LEFT_HAND, ServerItemModels[itemid][LeftPos][0], ServerItemModels[itemid][LeftPos][1], ServerItemModels[itemid][LeftPos][2], ServerItemModels[itemid][LeftRot][0], ServerItemModels[itemid][LeftRot][1], ServerItemModels[itemid][LeftRot][2], ServerItemModels[itemid][LeftScale][0], ServerItemModels[itemid][LeftScale][1], ServerItemModels[itemid][LeftScale][2]);
	}
}

stock ItemModel_GetType(itemid) {
	return ServerItemModels[itemid][Type];
}

stock ItemModel_GetObjectModel(itemid) {
	return ServerItemModels[itemid][ObjectModel];
}

stock ItemModel_GetSpaceSize(itemid) {
	return ServerItemModels[itemid][OccupiedSpace];
}

stock ItemModel_GetName(itemid)
{
	new str[ITEM_MODEL_MAX_NAME_LEN];
	strcat(str, ServerItemModels[itemid][Name]);
	return str;
}

stock ItemModel_GetTextDrawNameString(itemid)
{
	new str[ITEM_MODEL_MAX_NAME_LEN];
	strcat(str, ServerItemModels[itemid][TextDrawNameString]);
	return str;
}

stock ItemModel_GetParamName(itemid)
{
    new str[ITEM_MODEL_MAX_PARAM_NAME_LEN];
    strcat(str, ServerItemModels[itemid][ParamName]);
	return str;
}

stock ItemModel_GetParamDefaultValue(itemid) {
	return ServerItemModels[itemid][ParamDefaultValue];
}

stock ItemModel_GetPrice(itemid) {
	return ServerItemModels[itemid][BasePrice];
}

stock ItemModel_SetExtraId(itemid, extraid) {
	ServerItemModels[itemid][ExtraId] = extraid;
}

stock ItemModel_GetExtraId(itemid) {
	return ServerItemModels[itemid][ExtraId];
}

stock ItemModel_HasTag(itemid, e_ITEM_TAG:tag) {
	return (ServerItemModels[itemid][ItemTag] & tag);
}

stock ItemModel_HasAllTheseTags(itemid, e_ITEM_TAG:tags) {
	return ((ServerItemModels[itemid][ItemTag] & tag) == tag);
}