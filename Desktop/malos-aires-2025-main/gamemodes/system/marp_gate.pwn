#if defined marp_gate_inc
	#endinput
#endif
#define marp_gate_inc

#include <YSI_Coding\y_hooks>

const GATE_MAX_AMOUNT = 128;
const GATE_RESET_ID = GATE_MAX_AMOUNT;
const Float:GATE_DEFAULT_SPEED = 2.0;
const INVALID_GATE_ID = -1;

static GATE_USE_ON_FOOT_ADDR;

enum
{
	/*0*/ GATE_TYPE_NONE,
	/*1*/ GATE_TYPE_BUSINESS,
	/*2*/ GATE_TYPE_HOUSE,
	/*3*/ GATE_TYPE_FACTION,

	/*LEAVE LAST*/ 	GATE_TYPES_AMOUNT
};

static enum e_GATE_DATA
{
	gtState,
	gtType,
	gtExtraid,
	Float:gtPosClosed[6],
	Float:gtPosOpen[6],
	Float:gtSpeed,
	STREAMER_TAG_OBJECT:gtObject,
	Button:gtFrontButton,
	STREAMER_TAG_OBJECT:gtFrontPanelObject,
	Button:gtBackButton,
	STREAMER_TAG_OBJECT:gtBackPanelObject,
	STREAMER_TAG_AREA:gtVehArea,
	gtAutoCloseTime,
	gtAutoCloseTimer,
	gtAsociateGate
}

static GateData[GATE_MAX_AMOUNT + 1][e_GATE_DATA] = {
	{
		/*gtState*/ 0,
		/*gtType*/ GATE_TYPE_NONE,
		/*gtExtraid*/ 0,
		/*Float:gtPosClosed*/ {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
		/*Float:gtPosOpen*/ {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
		/*Float:gtSpeed*/ GATE_DEFAULT_SPEED,
		/*STREAMER_TAG_OBJECT:gtObject*/ INVALID_STREAMER_ID,
		/*Button:gtFrontButton*/ INVALID_BUTTON_ID,
		/*STREAMER_TAG_OBJECT:gtFrontPanelObject*/ INVALID_STREAMER_ID,
		/*Button:gtBackButton*/ INVALID_BUTTON_ID,
		/*STREAMER_TAG_OBJECT:gtBackPanelObject*/ INVALID_STREAMER_ID,
		/*STREAMER_TAG_AREA:gtVehArea*/ INVALID_STREAMER_ID,
		/*gtAutoCloseTime*/ 0,
		/*gtAutoCloseTimer*/ 0,
		/*gtAsociateGate*/ INVALID_GATE_ID,
	}, ...
};

static Iterator:GateData<GATE_MAX_AMOUNT>;

static GatePlayerData[MAX_PLAYERS] = {INVALID_GATE_ID, ...};

hook OnGameModeInit()
{
	GATE_USE_ON_FOOT_ADDR = GetPublicAddressFromName("Gate_UseOnFoot");
	return 1;
}

Gate_Create(modelid,
			Float:cx, Float:cy, Float:cz, Float:crx, Float:cry, Float:crz,
			Float:ox, Float:oy, Float:oz, Float:orx, Float:ory, Float:orz,
			worldid = -1,
			Float:speed = GATE_DEFAULT_SPEED,
			type = GATE_TYPE_NONE,
			extraid = 0,
			autoCloseTime = 0,
			bool:staticObject = false)
{
	if(type <= GATE_TYPE_NONE)
	{
		print("[ERROR] Intentando crear puerta sin tipo.");
		return INVALID_GATE_ID;
	}

	new gateid = Iter_Free(GateData);

	if(gateid == ITER_NONE)
	{
		printf("[ERROR] Alcanzado GATE_MAX_AMOUNT (%i). Iter_Count: %i.", GATE_MAX_AMOUNT, Iter_Count(GateData));
		return INVALID_GATE_ID;
	}

	GateData[gateid][gtState] = 0;

	if(staticObject) {
		GateData[gateid][gtObject] = CreateDynamicObject(modelid, cx, cy, cz, crx, cry, crz, .worldid = -1, .streamdistance = -1.0, .drawdistance = 300.0);
	} else {
		GateData[gateid][gtObject] = CreateDynamicObject(modelid, cx, cy, cz, crx, cry, crz, .worldid = worldid, .streamdistance = 300.0, .drawdistance = 300.0);
	}

	GateData[gateid][gtPosClosed][0] = cx, GateData[gateid][gtPosClosed][1] = cy, GateData[gateid][gtPosClosed][2] = cz, GateData[gateid][gtPosClosed][3] = crx, GateData[gateid][gtPosClosed][4] = cry, GateData[gateid][gtPosClosed][5] = crz;
	GateData[gateid][gtPosOpen][0] = ox, GateData[gateid][gtPosOpen][1] = oy, GateData[gateid][gtPosOpen][2] = oz, GateData[gateid][gtPosOpen][3] = orx, GateData[gateid][gtPosOpen][4] = ory, GateData[gateid][gtPosOpen][5] = orz;
	GateData[gateid][gtSpeed] = (speed <= 0.0) ? (0.1) : (speed);
	GateData[gateid][gtType] = type;
	GateData[gateid][gtExtraid] = (extraid < 0) ? (0) : (extraid);
	GateData[gateid][gtAutoCloseTime] = (autoCloseTime < 400) ? (0) : (autoCloseTime);
	GateData[gateid][gtAutoCloseTimer] = 0;

	Iter_Add(GateData, gateid);

	return gateid;
}

Gate_SetOnFootFrontDetection(gateid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, const labelText[BUTTON_MAX_LABEL_TEXT_LENGTH] = "")
{
	if(!Iter_Contains(GateData, gateid))
		return 0;

	if(GateData[gateid][gtFrontPanelObject]) {
		DestroyDynamicObject(GateData[gateid][gtFrontPanelObject]);
	}

	if(GateData[gateid][gtFrontButton] != INVALID_BUTTON_ID) {
		Button_Destroy(GateData[gateid][gtFrontButton]);
	}

	new worldid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, GateData[gateid][gtObject], E_STREAMER_WORLD_ID);

	GateData[gateid][gtFrontPanelObject] = CreateDynamicObject(2922, x, y, z, rx, ry, rz, .worldid = worldid, .streamdistance = 70.0);
	GetXYInFrontOfPoint(x, y, rz, x, y, .distance = 0.15);

	new onEnterText[BUTTON_MAX_ENTER_TEXT_LENGTH] = "(H) ";

	if(isnull(labelText)) {
		strcat(onEnterText, "Usar", sizeof(onEnterText));
	} else {
		strcat(onEnterText, labelText, sizeof(onEnterText));
	}

	GateData[gateid][gtFrontButton] = Button_Create(gateid, x, y, z, .size = 0.5, .worldid = worldid, .streamDistance = 4.0, .labelText = labelText, .onEnterText = onEnterText, .onEnterTextTime = 1800, .onPressCallbackAddress = GATE_USE_ON_FOOT_ADDR);
	return 1;
}

Gate_SetOnFootBackDetection(gateid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, const labelText[BUTTON_MAX_LABEL_TEXT_LENGTH] = "")
{
	if(!Iter_Contains(GateData, gateid))
		return 0;

	if(GateData[gateid][gtBackPanelObject]) {
		DestroyDynamicObject(GateData[gateid][gtBackPanelObject]);
	}

	if(GateData[gateid][gtBackButton] != INVALID_BUTTON_ID) {
		Button_Destroy(GateData[gateid][gtBackButton]);
	}

	new worldid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, GateData[gateid][gtObject], E_STREAMER_WORLD_ID);
	GateData[gateid][gtBackPanelObject] = CreateDynamicObject(2922, x, y, z, rx, ry, rz, .worldid = worldid, .streamdistance = 70.0);
	GetXYInFrontOfPoint(x, y, rz, x, y, .distance = 0.15);

	new onEnterText[BUTTON_MAX_ENTER_TEXT_LENGTH] = "(H) ";

	if(isnull(labelText)) {
		strcat(onEnterText, "Usar", sizeof(onEnterText));
	} else {
		strcat(onEnterText, labelText, sizeof(onEnterText));
	}

	GateData[gateid][gtBackButton] = Button_Create(gateid, x, y, z, .size = 0.5, .worldid = worldid, .streamDistance = 4.0, .labelText = labelText, .onEnterText = onEnterText, .onEnterTextTime = 1800, .onPressCallbackAddress = GATE_USE_ON_FOOT_ADDR);
	return 1;
}

Gate_SetVehicleDetection(gateid, Float:x, Float:y, Float:z, Float:size = 6.0)
{
	if(!Iter_Contains(GateData, gateid))
		return 0;

	if(GateData[gateid][gtVehArea]) {
		DestroyDynamicArea(GateData[gateid][gtVehArea]);
	}

	new worldid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, GateData[gateid][gtObject], E_STREAMER_WORLD_ID);
	GateData[gateid][gtVehArea] = CreateDynamicCylinder(x, y, z - 2.0, z + 2.0, .size = size, .worldid = worldid);
	Streamer_SetExtraIdArray(STREAMER_TYPE_AREA, GateData[gateid][gtVehArea], STREAMER_ARRAY_TYPE_GATE, gateid);
	return 1;
}

Gate_SetTexture(gateid, index, txdmodelid, const txdname[], const texturename[], materialcolor = 0x00000000)
{
	if(!Iter_Contains(GateData, gateid))
		return 0;

	SetDynamicObjectMaterial(GateData[gateid][gtObject], index, txdmodelid, txdname, texturename, materialcolor);
	return 1;
}

Gate_AssociateToGate(gateid, associategate)
{
	if(!Iter_Contains(GateData, gateid) || !Iter_Contains(GateData, associategate) || gateid == associategate)
		return 0;
	
	GateData[gateid][gtAsociateGate] = associategate;
	return 1;
}

Gate_Destroy(gateid)
{
	if(!Iter_Contains(GateData, gateid))
		return 0;

	Iter_Remove(GateData, gateid); // Lo ponemos primero por si hubiese una asociación circular y fuese invocado nuevamente el destroy del ID original
	DestroyDynamicObject(GateData[gateid][gtObject]);

	if(GateData[gateid][gtVehArea])
	{
		if(IsAnyPlayerInDynamicArea(GateData[gateid][gtVehArea]))
		{
			foreach(new playerid : Player)
			{
				if(gateid == GatePlayerData[playerid]) {
					GatePlayerData[playerid] = INVALID_GATE_ID;
				}
			}
		}

		DestroyDynamicArea(GateData[gateid][gtVehArea]);
	}

	if(GateData[gateid][gtFrontPanelObject]) {
		DestroyDynamicObject(GateData[gateid][gtFrontPanelObject]);
	}

	if(GateData[gateid][gtFrontButton] != INVALID_BUTTON_ID) {
		Button_Destroy(GateData[gateid][gtFrontButton]);
	}

	if(GateData[gateid][gtBackPanelObject]) {
		DestroyDynamicObject(GateData[gateid][gtBackPanelObject]);
	}
	
	if(GateData[gateid][gtBackButton] != INVALID_BUTTON_ID) {
		Button_Destroy(GateData[gateid][gtBackButton]);
	}
	
	if(GateData[gateid][gtAutoCloseTimer]) {
		KillTimer(GateData[gateid][gtAutoCloseTimer]);
	}

	if(GateData[gateid][gtAsociateGate] != INVALID_GATE_ID) {
		Gate_Destroy(GateData[gateid][gtAsociateGate]);
	}

	GateData[gateid] = GateData[GATE_RESET_ID];
	return 1;
}

Gate_OnPlayerEnterArea(playerid, gateid) {
	GatePlayerData[playerid] = gateid;
}

Gate_OnPlayerLeaveArea(playerid, gateid)
{
	if(gateid == GatePlayerData[playerid]) {
		GatePlayerData[playerid] = INVALID_GATE_ID;
	}
}

Gate_CanPlayerUse(playerid, gateid) 
{
	switch(GateData[gateid][gtType])
	{
		case GATE_TYPE_BUSINESS: return Biz_CanUse(playerid, GateData[gateid][gtExtraid]);
		case GATE_TYPE_HOUSE: return (KeyChain_Contains(playerid, KEY_TYPE_HOUSE, GateData[gateid][gtExtraid]) || AdminDuty[playerid]);
		case GATE_TYPE_FACTION: return (!GateData[gateid][gtExtraid] || GateData[gateid][gtExtraid] == PlayerInfo[playerid][pFaction] || AdminDuty[playerid]);
		default: return 0;
	}
			
	return 0;
}

forward Gate_UseOnFoot(playerid, gateid);
public Gate_UseOnFoot(playerid, gateid)
{
	if(!Iter_Contains(GateData, gateid))
		return 0;
	if(!Gate_CanPlayerUse(playerid, gateid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes la llave necesaria.");

	Gate_Move(gateid);
	PlayerPlaySound(playerid, 6002, 0.0, 0.0, 0.0);
	PlayerCmeMessage(playerid, 15.0, 4000, "Coloca una llave en el panel de la cerradura.");
	ApplyAnimationEx(playerid, "HEIST9", "USE_SWIPECARD", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	return 1;
}

Gate_UseOnVehicle(playerid, gateid)
{
	if(!Iter_Contains(GateData, gateid))
		return 0;
	if(!Gate_CanPlayerUse(playerid, gateid))
		return 0;

	Gate_Move(gateid);
	PlayerPlaySound(playerid, 6002, 0.0, 0.0, 0.0);
	PlayerCmeMessage(playerid, 15.0, 4000, "Toca un botón en su llave inalámbrica.");
	return 1;
}

static Gate_Move(gateid, chainMoveId = 0)
{
	static moveIdCounter;
	static moveId[GATE_MAX_AMOUNT];

	if(!chainMoveId) {
		chainMoveId = (++moveIdCounter);
	}

	moveId[gateid] = chainMoveId;

	if(GateData[gateid][gtState])
	{
		MoveDynamicObject(GateData[gateid][gtObject], GateData[gateid][gtPosClosed][0], GateData[gateid][gtPosClosed][1], GateData[gateid][gtPosClosed][2], GateData[gateid][gtSpeed], GateData[gateid][gtPosClosed][3], GateData[gateid][gtPosClosed][4], GateData[gateid][gtPosClosed][5]);

		if(GateData[gateid][gtAutoCloseTimer])
		{
			KillTimer(GateData[gateid][gtAutoCloseTimer]);
			GateData[gateid][gtAutoCloseTimer] = 0;
		}
	}
	else
	{
		MoveDynamicObject(GateData[gateid][gtObject], GateData[gateid][gtPosOpen][0], GateData[gateid][gtPosOpen][1], GateData[gateid][gtPosOpen][2], GateData[gateid][gtSpeed], GateData[gateid][gtPosOpen][3], GateData[gateid][gtPosOpen][4], GateData[gateid][gtPosOpen][5]);

		if(GateData[gateid][gtAutoCloseTime])
		{
			if(GateData[gateid][gtAutoCloseTimer]) {
				KillTimer(GateData[gateid][gtAutoCloseTimer]);
			}

			GateData[gateid][gtAutoCloseTimer] = SetTimerEx("Gate_AutoClose", GateData[gateid][gtAutoCloseTime], false, "i", gateid);
		}
	}

	GateData[gateid][gtState] = !GateData[gateid][gtState];	

	if(GateData[gateid][gtAsociateGate] != INVALID_GATE_ID && moveId[GateData[gateid][gtAsociateGate]] != chainMoveId) {
		Gate_Move(GateData[gateid][gtAsociateGate], chainMoveId);
	}
}

forward Gate_AutoClose(gateid);
public Gate_AutoClose(gateid)
{
	if(!Iter_Contains(GateData, gateid))
		return 0;

	GateData[gateid][gtAutoCloseTimer] = 0;

	if(GateData[gateid][gtState])
	{
		MoveDynamicObject(GateData[gateid][gtObject], GateData[gateid][gtPosClosed][0], GateData[gateid][gtPosClosed][1], GateData[gateid][gtPosClosed][2], GateData[gateid][gtSpeed], GateData[gateid][gtPosClosed][3], GateData[gateid][gtPosClosed][4], GateData[gateid][gtPosClosed][5]);
		GateData[gateid][gtState] = 0;
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GatePlayerData[playerid] != INVALID_GATE_ID && IsPlayerInAnyVehicle(playerid) && KEY_PRESSED_SINGLE(KEY_CROUCH)) {
		Gate_UseOnVehicle(playerid, GatePlayerData[playerid]);
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	GatePlayerData[playerid] = INVALID_GATE_ID;
	return 1;
}

CMD:areja(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new subcmd[32];

	if(sscanf(params, "s[32] ", subcmd))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/areja [ayuda - crear - borrar - detectarenveh - detectarapiefrontal - detectarapietrasero - asociar]");
	
	if(!strcmp(subcmd, "crear", true))
	{
		new modelid,
			Float:cx, Float:cy, Float:cz, Float:crx, Float:cry, Float:crz,
			Float:ox, Float:oy, Float:oz, Float:orx, Float:ory, Float:orz,
			worldid, Float:speed, type, extraid, autoCloseTime,	bool:staticObject;

		if(sscanf(params, "s[32] p<,>iffffffffffffifiiii", subcmd, modelid, cx, cy, cz, crx, cry, crz, ox, oy, oz, orx, ory, orz, worldid, speed, type, extraid, autoCloseTime, staticObject))
		{
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/areja crear [modelid,cx,cy,cz,crx,cry,crz,ox,oy,oz,orx,ory,orz,worldid,speed,type,extraid,autoCloseTime,staticObject]");
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"Utiliza '/areja ayuda' para mayor información.");
			return 1;
		}

		new gateid = Gate_Create(modelid,
				cx, cy, cz, crx, cry, crz,
				ox, oy, oz, orx, ory, orz,
				.worldid = worldid, .speed = speed, .type = type, .extraid = extraid, .autoCloseTime = autoCloseTime, .staticObject = staticObject);

		if(gateid != INVALID_GATE_ID) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Reja ID %i creada correctamente.", gateid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Imposible crear la reja, se alcanzó el máximoen el servidor.");
		}

		return 1;
	}
	else if(!strcmp(subcmd, "borrar", true))
	{
		new gateid;

		if(sscanf(params, "s[32] i", subcmd, gateid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/areja borrar [idreja]");

		if(Gate_Destroy(gateid)) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Reja ID %i borrada correctamente.", gateid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de reja inválida.");
		}

		return 1;
	}
	else if(!strcmp(subcmd, "detectarenveh", true))
	{
		new gateid, Float:x, Float:y, Float:z, Float:size;

		if(sscanf(params, "s[32] p<,>iffff", subcmd, gateid, x, y, z, size))
		{
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/areja detectarenveh [idreja,x,y,z,size]");
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"Utiliza '/areja ayuda' para mayor información.");
			return 1;
		}

		if(Gate_SetVehicleDetection(gateid, x, y, z, .size = size)) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Configurada la detección en vehículo de la reja ID %i correctamente.", gateid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de reja inválida.");
		}

		return 1;
	}
	else if(!strcmp(subcmd, "detectarapiefrontal", true))
	{
		new gateid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, labelText[BUTTON_MAX_LABEL_TEXT_LENGTH];

		if(sscanf(params, "s[32] p<,>iffffffS()["#BUTTON_MAX_LABEL_TEXT_LENGTH"]", subcmd, gateid, x, y, z, rx, ry, rz, labelText))
		{
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/areja detectarapiefrontal [idreja,x,y,z,rz,ry,rz,labelText]");
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"Utiliza '/areja ayuda' para mayor información.");
			return 1;
		}

		if(Gate_SetOnFootFrontDetection(gateid, x, y, z, rx, ry, rz, .labelText = labelText)) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Configurada la detección a pie primaria de la reja ID %i correctamente.", gateid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de reja inválida.");
		}

		return 1;
	}
	else if(!strcmp(subcmd, "detectarapietrasero", true))
	{
		new gateid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, labelText[BUTTON_MAX_LABEL_TEXT_LENGTH];

		if(sscanf(params, "s[32] p<,>iffffffS()["#BUTTON_MAX_LABEL_TEXT_LENGTH"]", subcmd, gateid, x, y, z, rx, ry, rz, labelText))
		{
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/areja detectarapietrasero [idreja,x,y,z,rz,ry,rz,labelText]");
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"Utiliza '/areja ayuda' para mayor información.");
			return 1;
		}

		if(Gate_SetOnFootBackDetection(gateid, x, y, z, rx, ry, rz)) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Configurada la detección a pie secundaria de la reja ID %i correctamente.", gateid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de reja inválida.");
		}

		return 1;
	}
	else if (!strcmp(subcmd, "asociar", true))
	{
		new gateid, associateid;

		if(sscanf(params, "s[32] ii", subcmd, gateid, associateid)) {
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/areja asociar [idreja] [idreja-a-asociar]");
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"Utiliza '/areja ayuda' para mayor información.");
			return 1;
		}

		if(Gate_AssociateToGate(gateid, associateid)) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Asociada la reja ID %i con la reja ID %i.", gateid, associateid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de reja inválida o la operación no se puede realizar puesto que ya existe la asociación a la inversa.");
		}

		return 1;
	}
	else if(!strcmp(subcmd, "ayuda", true))
	{
		Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "[AYUDA] Creación de reja",
					"[CREACION - Las comas indican donde dejar ESPACIO, no colocarlas]\n \n\
					Uso: '/areja crear [modelid,cx,cy,cz,crx,cry,crz,ox,oy,oz,orx,ory,orz,worldid,speed,type,extraid,autoCloseTime,staticObject]'.\n \n\
					(modelid)\tTipo: entero\tEj: 19906\tDetalle: modelo de objeto de la reja.\n\
					(cx,cy,cz,crx,cry,crz)\tTipo: float\tEj: -956.35\tDetalle: coordenadas de creación de la reja cerrada.\n\
					(ox,oy,oz,orx,ory,orz)\tTipo: float\tEj: 23.012\tDetalle: coordenadas de creación de la reja abierta.\n\
					(worldid)\tTipo: entero\tEj: -1, 0, 4\tDetalle: ID de mundo virtual. Si no está seguro o está en un exterior, lo normal y óptimo es -1 (todos).\n\
					(speed)\tTipo: float\tEj: 2.0\tDetalle: velocidad a la cual se moverá la reja. Lo normal son valores entre 1.0 y 3.0.\n\
					(type)\tTipo: entero\tEj: 0, 5\tDetalle: restringir el uso a determinada facción o propiedad. Negocios: 1, Casas: 2, Facciones: 3.\n\
					(extraid)\tTipo: entero\tEj: 0, 5\tDetalle: id de faccion o propiedad que podra utilizar. Para uso libre tipo faccion id 0.\n\
					(autoCloseTime)\tTipo: entero\tEj: 0, 4000\tDetalle: milisegundos hasta el cierre automático una vez abierta. Usar 0 deshabilita el auto-cierre.\n\
					(staticObject)\tTipo: 1 o 0\tEj: 0, 1\tDetalle: si el objeto de la reja debe ser estático. Usar 1 solo si entiende lo que implica. Lo normal es 0.\n \n\
					Ejemplo de uso: '/areja crear 969,2498.673,-1514.298,23.013,0.0,0.0,0.0,2507.514,-1514.298,23.013,0.0,0.0,0.0,-1,2.0,5,5000,0'.\n \n\
					[DETECCION EN VEHICULO]\n \n\
					Uso: '/areja detectarenveh [idreja,x,y,z,size]'.\n \n\
					(idreja)\tTipo: entero\tEj: 2, 15\tDetalle: ID de la reja a la cual aplicar la detección en vehículo. Si ya tuviese dicha detección, es reemplazada por la nueva.\n\
					(x,y,z)\tTipo: float\tEj: 15.984\tDetalle: coordenadas del punto central del área circular usada para la detección en vehículo. Lo normal es en mitad de la reja.\n\
					(size)\tTipo: float\tEj: 5.0\tDetalle: el diámetro del círculo con centro en (x,y,z) usado para la detección en vehículo. Lo normal es 8.0.\n \n\
					[DETECCION A PIE]\n \n\
					Uso: '/areja detectarapiefrontal [idreja,x,y,z,rz,ry,rz,labelText]'.\n \n\
					(idreja)\tTipo: entero\tEj: 1, 9\tDetalle: ID de la reja a la cual aplicar la detección a pie. Si ya tuviese dicha detección, es reemplazada por la nueva.\n\
					(x,y,z,rx,ry,rz)\tTipo: float\tEj: -2159.453\tDetalle: coordenadas de creación del panel de acceso a pie, basadas en el modelo de objeto 2922.\n \n\
					(labelText)\tTipo: texto\tEj: Portón\tDetalle: Opcional. Texto usado para el label del panel de acceso. Omitir si no se quiere usar label.\n \n\
					Nota: '/areja detectarapietrasero' es de idéntico funcionamiento, pero en una segunda posición.\n \tLa distinción de comandos hace a la posibilidad de realizar la detección a pie en 0, 1, o hasta 2 posiciones.\n \n\
					[BORRADO]\n \n\
					Uso: '/areja borrar [idreja]'.\n \n\
					(idreja)\tTipo: entero\tEj: 3, 27\tDetalle: ID de la reja a borrar.\n\n\
					[ASOCIACION]\n \n\
					Uso: '/areja asociar [idreja] [idreja-a-asociar]'.\n \n\
					(idreja)\tTipo: entero\tEj: 3, 27\tDetalle: ID de la reja a la que se asocia.\n\
					(idreja-a-asociar)\tTipo: entero\tEj: 3, 27\tDetalle: ID de la reja a asociar.",
					"Cerrar", "");
	}
	else {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/areja [ayuda - crear - borrar - detectarenveh - detectarapiefrontal - detectarapietrasero]");
	}

	return 1;
}
