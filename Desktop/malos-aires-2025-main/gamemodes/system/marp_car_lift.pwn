#if defined marp_car_lift_inc
	#endinput
#endif
#define marp_car_lift_inc

#include <YSI_Coding\y_hooks>

const CAR_LIFT_MAX_AMOUNT = 16;
const CAR_LIFT_RESET_ID = CAR_LIFT_MAX_AMOUNT;
const INVALID_CAR_LIFT_ID = -1;

static CAR_LIFT_USE_ADDR;
static CAR_LIFT_STOP_ADDR;

static enum e_CAR_LIFT_DATA
{
	clState,
	clBiz,
	Button:clButton,
	Float:clPos[6],
	clBox[4],
	clRamp[4],
	STREAMER_TAG_OBJECT:clPillar[4],
	STREAMER_TAG_OBJECT:clPC
}

static CarLiftData[CAR_LIFT_MAX_AMOUNT + 1][e_CAR_LIFT_DATA] = {
	{
		/*clState*/ 0,
		/*clBiz*/ 0,
		/*Button:clButton*/ INVALID_BUTTON_ID,
		/*Float:clPos*/ {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
		/*clBox*/ {INVALID_OBJECT_ID, INVALID_OBJECT_ID, INVALID_OBJECT_ID, INVALID_OBJECT_ID},
		/*clRamp*/ {INVALID_OBJECT_ID, INVALID_OBJECT_ID, INVALID_OBJECT_ID, INVALID_OBJECT_ID},
		/*STREAMER_TAG_OBJECT:clPillar*/ {INVALID_STREAMER_ID, INVALID_STREAMER_ID, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
		/*STREAMER_TAG_OBJECT:clPC*/ INVALID_STREAMER_ID	
	}, ...
};

static Iterator:CarLiftData<CAR_LIFT_MAX_AMOUNT>;

hook OnGameModeInit()
{
	CAR_LIFT_USE_ADDR = GetPublicAddressFromName("CarLift_Use");
	CAR_LIFT_STOP_ADDR = GetPublicAddressFromName("CarLift_Stop");
	return 1;
} 

hook OnGameModeInitEnded()
{
	print("[INFO] Cargando elevadores de vehiculos...");

	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT * FROM `carlifts` LIMIT %i;", CAR_LIFT_MAX_AMOUNT);
	mysql_tquery(MYSQL_HANDLE, query, "CarLift_OnLoadAll");
	return 1;
}

forward CarLift_OnLoadAll();
public CarLift_OnLoadAll()
{
	new rows = cache_num_rows();

	for(new i = 0, carliftid, worldid; i < rows; i++)
	{
		carliftid = Iter_Add(CarLiftData, cache_name_int(i, "liftid"));

		if(carliftid == INVALID_ITERATOR_SLOT)
		{
			printf("[ERROR] Imposible cargar elevador ID %i, la ID ya se encuentra tomada. Iter_Count: %i.", cache_name_int(i, "liftid"), Iter_Count(CarLiftData));
			continue;
		}

		cache_get_value_name_int(i, "bizid", CarLiftData[carliftid][clBiz]);
		cache_get_value_name_float(i, "posx", CarLiftData[carliftid][clPos][0]);
		cache_get_value_name_float(i, "posy", CarLiftData[carliftid][clPos][1]);
		cache_get_value_name_float(i, "posz", CarLiftData[carliftid][clPos][2]);
		cache_get_value_name_float(i, "angle", CarLiftData[carliftid][clPos][5]);
		cache_get_value_name_int(i, "vworld", worldid);

		CarLiftData[carliftid][clPos][3] = 0.0;
		CarLiftData[carliftid][clPos][4] = 0.0;
		CarLiftData[carliftid][clState] = 0;

		CarLift_CreateObjsAndBtn(carliftid, CarLiftData[carliftid][clPos][0], CarLiftData[carliftid][clPos][1], CarLiftData[carliftid][clPos][2], CarLiftData[carliftid][clPos][5], worldid);
	}

	printf("[INFO] Carga de %i elevadores de vehiculos finalizada.", rows);
	return 1;
}

CarLift_Create(Float:x, Float:y, Float:z, Float:angle, worldid = -1, bizid = 0)
{
	new carliftid = Iter_Free(CarLiftData);

	if(carliftid == ITER_NONE)
	{
		printf("[ERROR] Alcanzado CAR_LIFT_MAX_AMOUNT (%i). Iter_Count: %i.", CAR_LIFT_MAX_AMOUNT, Iter_Count(CarLiftData));
		return INVALID_CAR_LIFT_ID;
	}

	GetXYBehindPoint(x, y, angle, x, y, 2.2175);
	GetXYBehindPoint(x, y, angle - 90.0, x, y, 1.724);

	// Una vez obtenido el punto sobre el cual del objeto principal (box gris izquierdo trasero), corregimos su rotación y altura
	
	angle += 180.0;
	z -= 1.63;

	CarLiftData[carliftid][clPos][0] = x;
	CarLiftData[carliftid][clPos][1] = y;
	CarLiftData[carliftid][clPos][2] = z;
	CarLiftData[carliftid][clPos][3] = 0.0;
	CarLiftData[carliftid][clPos][4] = 0.0;
	CarLiftData[carliftid][clPos][5] = angle;

	CarLiftData[carliftid][clState] = 0;
	CarLiftData[carliftid][clBiz] = (bizid < 0) ? (0) : (bizid);

	CarLift_CreateObjsAndBtn(carliftid, x, y, z, angle, worldid);

	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `carlifts` (`liftid`,`bizid`,`posx`,`posy`,`posz`,`angle`,`vworld`) VALUES (%i,'%i',%f,%f,%f,%f,'%i');", carliftid, CarLiftData[carliftid][clBiz], x, y, z, angle, worldid);
	mysql_tquery(MYSQL_HANDLE, query);

	Iter_Add(CarLiftData, carliftid);

	return carliftid;
}

CarLift_CreateObjsAndBtn(carliftid, Float:x, Float:y, Float:z, Float:angle, worldid)
{
	CarLiftData[carliftid][clBox][0] = CreateObject(1625, x, y, z, 0.0, 0.0, angle);

	new mainobjid = CarLiftData[carliftid][clBox][0];

	CarLiftData[carliftid][clBox][1] = CreateObject(1625, 0.00000, -4.43500, 0.00000,   0.00000, 0.00000, 0.00000);
	AttachObjectToObject(CarLiftData[carliftid][clBox][1], mainobjid, 0.00000, -4.43500, 0.00000,   0.00000, 0.00000, 0.00000);
	CarLiftData[carliftid][clBox][2] = CreateObject(1625, -3.48800, -4.43500, 0.00000,   0.00000, 0.00000, 180.00000);
	AttachObjectToObject(CarLiftData[carliftid][clBox][2], mainobjid, -3.48800, -4.43500, 0.00000,   0.00000, 0.00000, 180.00000);
	CarLiftData[carliftid][clBox][3] = CreateObject(1625, -3.48800, 0.00000, 0.00000,   0.00000, 0.00000, 180.00000);
	AttachObjectToObject(CarLiftData[carliftid][clBox][3], mainobjid, -3.48800, 0.00000, 0.00000,   0.00000, 0.00000, 180.00000);

	// Pillars
	new Float:pillarX, Float:pillarY;

	GetXYInFrontOfPoint(x, y, angle, pillarX, pillarY, 0.1420);
	CarLiftData[carliftid][clPillar][0] = CreateDynamicObject(2960, pillarX, pillarY, z + 0.9530, 0.0, 90.0, angle + 90.0);
	GetXYBehindPoint(pillarX, pillarY, angle, pillarX, pillarY, 4.4350);
	CarLiftData[carliftid][clPillar][1] = CreateDynamicObject(2960, pillarX, pillarY, z + 0.9530, 0.0, 90.0, angle + 90.0);
	GetXYInFrontOfPoint(pillarX, pillarY, angle + 90.0, pillarX, pillarY, 3.4650);
	CarLiftData[carliftid][clPillar][2] = CreateDynamicObject(2960, pillarX, pillarY, z + 0.9530, 0.0, 90.0, angle + 90.0);
	GetXYInFrontOfPoint(pillarX, pillarY, angle, pillarX, pillarY, 4.4350);
	CarLiftData[carliftid][clPillar][3] = CreateDynamicObject(2960, pillarX, pillarY, z + 0.9530, 0.0, 90.0, angle + 90.0);

	// Ramps
	CarLiftData[carliftid][clRamp][0] = CreateObject(2679, -1.13800, -1.13200, 0.67570,   90.00000, 0.00000, 180.00000);
	AttachObjectToObject(CarLiftData[carliftid][clRamp][0], mainobjid, -1.13800, -1.13200, 0.67570,   90.00000, 0.00000, 180.00000);
	CarLiftData[carliftid][clRamp][1] = CreateObject(2679, -1.13800, -3.57300, 0.67570,   90.00000, 0.00000, 180.00000);
	AttachObjectToObject(CarLiftData[carliftid][clRamp][1], mainobjid, -1.13800, -3.57300, 0.67570,   90.00000, 0.00000, 180.00000);
	CarLiftData[carliftid][clRamp][2] = CreateObject(2679, -3.09800, -3.57300, 0.67570,   90.00000, 0.00000, 180.00000);
	AttachObjectToObject(CarLiftData[carliftid][clRamp][2], mainobjid, -3.09800, -3.57300, 0.67570,   90.00000, 0.00000, 180.00000);
	CarLiftData[carliftid][clRamp][3] = CreateObject(2679, -3.09800, -1.13200, 0.67570,   90.00000, 0.00000, 180.00000);
	AttachObjectToObject(CarLiftData[carliftid][clRamp][3], mainobjid, -3.09800, -1.13200, 0.67570,   90.00000, 0.00000, 180.00000);

	// PC
	new Float:pcPos[2];

	GetXYBehindPoint(x, y, angle + 90.0, pcPos[0], pcPos[1], 0.4801);
	GetXYInFrontOfPoint(pcPos[0], pcPos[1], angle, pcPos[0], pcPos[1], 0.7432);
	CarLiftData[carliftid][clPC] = CreateDynamicObject(19903, pcPos[0], pcPos[1], z + 0.5259, 0.0, 0.0, angle - 60.0);

	// Button
	GetXYBehindPoint(x, y, angle + 90.0, x, y, 0.8);
	CarLiftData[carliftid][clButton] = Button_Create(carliftid, x, y, z + 1.62, .size = 0.6, .worldid = worldid, .streamDistance = 5.0, .labelText = "Elevador", .onEnterText = "Mantén (H) para usar elevador", .onEnterTextTime = 1800, .onPressCallbackAddress = CAR_LIFT_USE_ADDR, .onReleaseCallbackAddress = CAR_LIFT_STOP_ADDR);

	return 1;
}

CarLift_Destroy(carliftid)
{
	if(!Iter_Contains(CarLiftData, carliftid))
		return 0;

	for(new i = 0; i < 4; i++)
	{
		DestroyObject(CarLiftData[carliftid][clBox][i]);
		DestroyDynamicObject(CarLiftData[carliftid][clPillar][i]);
		DestroyObject(CarLiftData[carliftid][clRamp][i]);
	}

	DestroyDynamicObject(CarLiftData[carliftid][clPC]);
	Button_Destroy(CarLiftData[carliftid][clButton]);

	CarLiftData[carliftid] = CarLiftData[CAR_LIFT_RESET_ID];

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `carlifts` WHERE `liftid`=%i;", carliftid);
	mysql_tquery(MYSQL_HANDLE, query);

	Iter_Remove(CarLiftData, carliftid);
	return 1;
}

CarLift_CanPlayerUse(playerid, carliftid) {
	return (!CarLiftData[carliftid][clBiz] || Biz_CanUse(playerid, CarLiftData[carliftid][clBiz]));
}

forward CarLift_Use(playerid, carliftid);
public CarLift_Use(playerid, carliftid)
{
	if(!Iter_Contains(CarLiftData, carliftid))
		return 0;
	if(!CarLift_CanPlayerUse(playerid, carliftid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estás autorizado para usar este equipo.");

	if(CarLiftData[carliftid][clState]) {
		MoveObject(CarLiftData[carliftid][clBox][0], CarLiftData[carliftid][clPos][0], CarLiftData[carliftid][clPos][1], CarLiftData[carliftid][clPos][2], 0.3, CarLiftData[carliftid][clPos][3], CarLiftData[carliftid][clPos][4], CarLiftData[carliftid][clPos][5]);
	} else {
		MoveObject(CarLiftData[carliftid][clBox][0], CarLiftData[carliftid][clPos][0], CarLiftData[carliftid][clPos][1], CarLiftData[carliftid][clPos][2] + 2.6, 0.3, CarLiftData[carliftid][clPos][3], CarLiftData[carliftid][clPos][4], CarLiftData[carliftid][clPos][5]);
	}

	CarLiftData[carliftid][clState] = !CarLiftData[carliftid][clState];
	PlayerPlaySound(playerid, 1035, CarLiftData[carliftid][clPos][0], CarLiftData[carliftid][clPos][1], CarLiftData[carliftid][clPos][2]);
	PlayerCmeMessage(playerid, 15.0, 4000, "Presiona un botón en el tablero del elevador.");
	return 1;
}

forward CarLift_Stop(playerid, carliftid, presstime);
public CarLift_Stop(playerid, carliftid, presstime)
{
	if(!Iter_Contains(CarLiftData, carliftid))
		return 0;
	if(!CarLift_CanPlayerUse(playerid, carliftid))
		return 0;

	StopObject(CarLiftData[carliftid][clBox][0]);
	PlayerPlaySound(playerid, 1036, CarLiftData[carliftid][clPos][0], CarLiftData[carliftid][clPos][1], CarLiftData[carliftid][clPos][2]);
	return 1;
}

CMD:aelevador(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso de Development o Management
	new level = AccountInfo[playerid][accAdminLevel];
	if(!(level == 20 || level == 21))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas ser Development o Management para utilizar este comando.");
	
	new subcmd[32];

	if(sscanf(params, "s[32] ", subcmd))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aelevador [crear - borrar - info]");
	
	if(!strcmp(subcmd, "crear", true))
	{
		new Float:x, Float:y, Float:z, Float:angle, bizid;

		if(sscanf(params, "s[32] i", subcmd, bizid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aelevador crear [idnegocio]. Para uso libre usar idnegocio = 0.");

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		new liftid = CarLift_Create(x, y, z, angle, .worldid = -1, .bizid = bizid);

		if(liftid != INVALID_CAR_LIFT_ID) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Elevador ID %i creado correctamente.", liftid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Imposible crear el elevador, se alcanzó el máximoen el servidor.");
		}

		return 1;
	}
	else if(!strcmp(subcmd, "borrar", true))
	{
		new liftid;

		if(sscanf(params, "s[32] i", subcmd, liftid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aelevador borrar [idelevador]");

		if(CarLift_Destroy(liftid)) {
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Elevador ID %i borrado correctamente.", liftid);
		} else {
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de elevador inválida.");
		}

		return 1;
	}
	else if(!strcmp(subcmd, "info", true))
	{
		new title[64], count = Iter_Count(CarLiftData);
		format(title, sizeof(title), "[Eleveadores de autos] Creados %i de %i", count, CAR_LIFT_MAX_AMOUNT);

		if(count)
		{
			new line[64], string[CAR_LIFT_MAX_AMOUNT * (16 + BIZ_MAX_NAME_LENGTH)] = "[#]\tNegocio\n";

			foreach(new lift : CarLiftData)
			{
				format(line, sizeof(line), "[%i]\t%s (%i)\n", lift, Biz_GetName(CarLiftData[lift][clBiz]), CarLiftData[lift][clBiz]);
				strcat(string, line, sizeof(string));
			}

			Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_TABLIST_HEADERS, title, string, "Cerrar", "");
		} else {
			Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, title, "Ninguno creado", "Cerrar", "");
		}

		return 1;
	}
	else {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aelevador [crear - borrar - info]");
	}

	return 1;
}
