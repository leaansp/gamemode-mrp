#if defined _marp_licenses_included
	#endinput
#endif
#define _marp_licenses_included

#include <YSI_Coding\y_hooks>

#define PRICE_LIC_GUN 			2000
#define PRICE_LIC_DRIVING 		400
#define PRICE_LIC_SAILING       4400
#define PRICE_LIC_FLYING        15400

static const Float:LIC_TAKE_POS[3] = {-2033.2118, -117.4678, 1035.1719};

static const Float:LIC_TEST_POS[30][3] = {
	{0.0, 0.0, 0.0},
	{2740.02, -1452.85, 30.28},
	{2740.18, -1279.24, 57.58},
	{2668.73, -1253.89, 52.17},
	{2593.26, -1253.93, 46.89},
	{2470.15, -1253.65, 26.31},
	{2368.31, -1286.32, 23.83},
	{2318.29, -1381.35, 23.86},
	{2181.01, -1382.26, 23.82},
	{2087.90, -1382.46, 23.82},
	{2072.97, -1315.48, 23.82},
	{2073.08, -1235.49, 23.80},
	{2072.96, -1108.52, 24.50},
	{2114.50, -1110.70, 25.11},
	{2219.93, -1136.00, 25.62},
	{2311.07, -1155.46, 26.79},
	{2384.60, -1097.64, 36.15},
	{2546.05, -1088.91, 63.31},
	{2585.98, -1051.02, 69.41},
	{2683.31, -1050.04, 69.41},
	{2818.54, -1051.83, 25.61},
	{2835.39, -1139.82, 24.76},
	{2866.22, -1355.30, 10.92},
	{2872.67, -1472.14, 10.78},
	{2840.69, -1583.38, 10.92},
	{2820.18, -1644.06, 10.72},
	{2752.44, -1654.68, 12.79},
	{2740.64, -1575.60, 17.73},
	{2739.93, -1499.55, 30.28},
	{2752.33, -1470.93, 30.46}
};

enum pLicInfo {
	lDTakingVehicle,
	lDStep,
	lDTime,
	Float:lDMaxSpeed,
};

static playerLicense[MAX_PLAYERS][pLicInfo];
static PlayerText:PTD_LicenseCountdown[MAX_PLAYERS] = {INVALID_PLAYER_TEXT_DRAW, ...};
static PlayerText:PTD_LicenseCountdownIcon[MAX_PLAYERS] = {INVALID_PLAYER_TEXT_DRAW, ...};
static PlayerText:PTD_LicenseCountdownTime[MAX_PLAYERS] = {INVALID_PLAYER_TEXT_DRAW, ...};
static PlayerText:PTD_LicenseCountdownMin[MAX_PLAYERS] = {INVALID_PLAYER_TEXT_DRAW, ...};
static PlayerText:PTD_LicenseCountdownBackground[MAX_PLAYERS] = {INVALID_PLAYER_TEXT_DRAW, ...};
static carLicTimer[MAX_PLAYERS];

hook OnPlayerDisconnect(playerid, reason) {
	KillTimer(carLicTimer[playerid]);
	playerLicense[playerid][lDStep] = 0;
	playerLicense[playerid][lDTakingVehicle] = 0;
	playerLicense[playerid][lDTime] = 0;
	playerLicense[playerid][lDMaxSpeed] = 0.0;
	return true;
}

CMD:licencias(playerid, params[]) {
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, LIC_TAKE_POS[0], LIC_TAKE_POS[1], LIC_TAKE_POS[2]))
		return true;

	new string[128];
	format(string, sizeof(string), "Lic. de conducción\t$%i\nLic. de navegación\t$%i\nLic. de vuelo\t$%i", PRICE_LIC_DRIVING, PRICE_LIC_SAILING, PRICE_LIC_FLYING);
	Dialog_Show(playerid, DLG_LICENSES, DIALOG_STYLE_TABLIST, "Licencias", string, "Aceptar", "Cerrar");
	return true;
}

Dialog:DLG_LICENSES(playerid, response, listitem, inputtext[]) {
	if(!response)
		return true;

	switch(listitem)
	{
		case 0: {
			if(playerLicense[playerid][lDTakingVehicle])
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya estás tomando una licencia!");
			if(GetPlayerCash(playerid) < PRICE_LIC_DRIVING)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes el dinero suficiente!");
			if(PlayerInfo[playerid][pCarLic])
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes tener más de una licencia de conducción!");

			SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡La prueba ha comenzado! Sal del edificio, entra a uno de los autos blancos del estacionamiento, y usa '/iniciar examen'.");
		}
		case 1: {
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Esta licencia no se encuentra disponible actualmente.");
		}
		case 2: {
			if(PlayerInfo[playerid][pFlyLic])
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya tienes una licencia de vuelo!");
			if(GetPlayerCash(playerid) < PRICE_LIC_FLYING)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes el dinero suficiente!");

			PlayerInfo[playerid][pFlyLic] = 1;
			GivePlayerCash(playerid, -PRICE_LIC_FLYING);
			SendFMessage(playerid, COLOR_LIGHTGREEN, "¡Felicidades, has conseguido la licencia de vuelo por $%d!", PRICE_LIC_FLYING);
		}
	}
	return true;
}

CMD:manuales(playerid, params[]) {
    if(!IsPlayerInRangeOfPoint(playerid, 4.0, LIC_TAKE_POS[0], LIC_TAKE_POS[1], LIC_TAKE_POS[2]))
		return true;

	Dialog_Show(playerid, DLG_MANUALES, DIALOG_STYLE_LIST, "Licencias", "Lic. de conducción\nLic. de navegación\nLic. de vuelo", "Aceptar", "Cerrar");
	return true;
}

Dialog:DLG_MANUALES(playerid, response, listitem, inputtext[]) {
	if(!response)
		return true;

	switch(listitem)
	{
		case 0: {
			Dialog_Show(playerid, DLG_MANUAL_LIC_CAR, DIALOG_STYLE_MSGBOX, "Manual de conducción",
				"- (1) Deberá conducir a 50 KM/H en calles y no más de 70 KM/H en avenidas.\n\
				- (2) Deberá respetar todo semáforo.\n\
				- (3) Deberá conducir siempre por el carril derecho.\n\
				- (3-bis) En el caso de tener que pasar a otro vehículo podrá emplearse el carril de la izquierda.\n\
				- (4) No empleará la bocina para generar disturbios ni molestar a los ciudadanos.\n\
				- (5) Respetará la dirección de los carriles.\n\
				- (6) Los peatones tienen prioridad para cruzar en las esquinas.\n\
				De no respetar alguna de las normas podrá ser multado por una suma de entre $100 a $30,000 según la gravedad.",
				"Cerrar", "");
		}
		default: {
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El manual que intentó leer no existe o bien la licencia no se encuentra disponible actualmente.");
		}
	}
	return true;
}

hook function OnPlayerEnterCPId(playerid, checkpointid) {
	if(!IsPlayerInAnyVehicle(playerid))
		return continue(playerid, checkpointid);

	if(playerLicense[playerid][lDStep] && VehicleInfo[GetPlayerVehicleID(playerid)][VehType] == VEH_SCHOOL)
	{
		playerLicense[playerid][lDStep]++;

		if(playerLicense[playerid][lDStep] < sizeof(LIC_TEST_POS)) {
			SetPlayerCheckpoint(playerid, LIC_TEST_POS[playerLicense[playerid][lDStep]][0], LIC_TEST_POS[playerLicense[playerid][lDStep]][1], LIC_TEST_POS[playerLicense[playerid][lDStep]][2], 4.0);
		} else {
			KillTimer(carLicTimer[playerid]);
			PlayerTextDrawDestroy(playerid, PTD_LicenseCountdown[playerid]);
			PlayerTextDrawDestroy(playerid, PTD_LicenseCountdownIcon[playerid]);
			PlayerTextDrawDestroy(playerid, PTD_LicenseCountdownTime[playerid]);
			PlayerTextDrawDestroy(playerid, PTD_LicenseCountdownMin[playerid]);
			PlayerTextDrawDestroy(playerid, PTD_LicenseCountdownBackground[playerid]);

			new vehicleID = GetPlayerVehicleID(playerid), Float:vehicleHP;
			GetVehicleHealth(vehicleID, vehicleHP);

			if(vehicleHP < 1000.0) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "¡Has fallado la prueba! El vehículo se encuentra dañado.");
			}
			else if(playerLicense[playerid][lDMaxSpeed] > 100.0) {
				SendFMessage(playerid, COLOR_LIGHTRED, "¡Has fallado la prueba! Has conducido muy rápido. Velocidad máxima permitida: 100 km/h. Velocidad máxima registrada: %.0f km/h.", playerLicense[playerid][lDMaxSpeed]);
			}
			else
			{
				SendFMessage(playerid, COLOR_LIGHTGREEN, "¡Has superado la prueba!, ahora tienes una licencia de conducir. Velocidad máxima registrada: %.0f km/h.", playerLicense[playerid][lDMaxSpeed]);
				PlayerInfo[playerid][pCarLic] = 1;
				GivePlayerCash(playerid, -PRICE_LIC_DRIVING);
			}

		    SetVehicleToRespawn(vehicleID);
		    playerLicense[playerid][lDTakingVehicle] = 0;
            playerLicense[playerid][lDStep] = 0;
            playerLicense[playerid][lDTime] = 0;
            playerLicense[playerid][lDMaxSpeed] = 0;
		}
		return true;
	}
	return continue(playerid, checkpointid);
}

forward licenseTimer(playerid, lic);
public licenseTimer(playerid, lic) {
	new vehicleID = GetPlayerVehicleID(playerid), Float:pSpeed = GetPlayerSpeed(playerid), string[128];

	switch(lic)
	{
		case 1:
		{
			if(pSpeed > playerLicense[playerid][lDMaxSpeed]) {
				playerLicense[playerid][lDMaxSpeed] = pSpeed;
			}

			playerLicense[playerid][lDTime]++;
			format(string, sizeof(string), "%d", playerLicense[playerid][lDTime]);
			PlayerTextDrawSetString(playerid, PTD_LicenseCountdown[playerid], string);

			if(playerLicense[playerid][lDTime] >= 520)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "Has fallado la prueba por exceder el tiempo Límite (520 segundos).");
				DisablePlayerCheckpoint(playerid);
				SetVehicleToRespawn(vehicleID);
				PutPlayerInVehicle(playerid, vehicleID, 0);
				RemovePlayerFromVehicle(playerid);
				playerLicense[playerid][lDTakingVehicle] = 0;
				playerLicense[playerid][lDTime] = 0;
				playerLicense[playerid][lDStep] = 0;
				playerLicense[playerid][lDMaxSpeed] = 0;
				PlayerTextDrawDestroy(playerid, PTD_LicenseCountdown[playerid]);
				PlayerTextDrawDestroy(playerid, PTD_LicenseCountdownIcon[playerid]);
				PlayerTextDrawDestroy(playerid, PTD_LicenseCountdownTime[playerid]);
				PlayerTextDrawDestroy(playerid, PTD_LicenseCountdownMin[playerid]);
				PlayerTextDrawDestroy(playerid, PTD_LicenseCountdownBackground[playerid]);
			}

			if(playerLicense[playerid][lDTakingVehicle] != 0) {
				carLicTimer[playerid] = SetTimerEx("licenseTimer", 1000, false, "dd", playerid, 1);
			}
		}
	}
	return true;
}

CMD:iniciar(playerid, params[]) {
	if(!strcmp(params, "examen", true))
	{
		new vehicleid;

		if(PlayerInfo[playerid][pCarLic])
			return true;
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !(vehicleid = GetPlayerVehicleID(playerid)) || Veh_GetSystemType(vehicleid) != VEH_SCHOOL)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras como conductor en un vehículo dispuesto para exámen.");
		if(playerLicense[playerid][lDTakingVehicle])
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya te encuentras rindiendo un exámen de conducción.");

		License_CreatePTD(playerid);
		PlayerTextDrawShow(playerid, PTD_LicenseCountdown[playerid]);
		PlayerTextDrawShow(playerid, PTD_LicenseCountdownIcon[playerid]);
		PlayerTextDrawShow(playerid, PTD_LicenseCountdownTime[playerid]);
		PlayerTextDrawShow(playerid, PTD_LicenseCountdownMin[playerid]);
		PlayerTextDrawShow(playerid, PTD_LicenseCountdownBackground[playerid]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "------------------------");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "¡La prueba ha comenzado!");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Enciende el vehículo con el comando '/motor' o presiona (~k~~TOGGLE_SUBMISSIONS~), y conduce por los puntos marcados en el mapa.");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Recuerda que deberás respetar todas las normas de tránsito, y tu velocidad máxima no debe superar los 100km/h.");
		playerLicense[playerid][lDTakingVehicle] = vehicleid;
		playerLicense[playerid][lDStep] = 1;
		SetPlayerCheckpoint(playerid, LIC_TEST_POS[playerLicense[playerid][lDStep]][0], LIC_TEST_POS[playerLicense[playerid][lDStep]][1], LIC_TEST_POS[playerLicense[playerid][lDStep]][2], 4.0);
		carLicTimer[playerid] = SetTimerEx("licenseTimer", 1000, false, "dd", playerid, 1);
	}
	return true;
}

License_CreatePTD(playerid) {	

	PTD_LicenseCountdownBackground[playerid] = CreatePlayerTextDraw(playerid, 693.000000, 440.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, PTD_LicenseCountdownBackground[playerid], 5);
	PlayerTextDrawLetterSize(playerid, PTD_LicenseCountdownBackground[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PTD_LicenseCountdownBackground[playerid], -257.500000, -131.500000);
	PlayerTextDrawSetOutline(playerid, PTD_LicenseCountdownBackground[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PTD_LicenseCountdownBackground[playerid], 0);
	PlayerTextDrawAlignment(playerid, PTD_LicenseCountdownBackground[playerid], 1);
	PlayerTextDrawColor(playerid, PTD_LicenseCountdownBackground[playerid], 50);
	PlayerTextDrawBackgroundColor(playerid, PTD_LicenseCountdownBackground[playerid], 0);
	PlayerTextDrawBoxColor(playerid, PTD_LicenseCountdownBackground[playerid], 0);
	PlayerTextDrawUseBox(playerid, PTD_LicenseCountdownBackground[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PTD_LicenseCountdownBackground[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_LicenseCountdownBackground[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, PTD_LicenseCountdownBackground[playerid], 1625);
	PlayerTextDrawSetPreviewRot(playerid, PTD_LicenseCountdownBackground[playerid], 0.000000, 90.000000, 0.000000, 2.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, PTD_LicenseCountdownBackground[playerid], 1, 1);

	PTD_LicenseCountdownTime[playerid] = CreatePlayerTextDraw(playerid, 546.000000, 378.000000, "TIEMPO");
	PlayerTextDrawFont(playerid, PTD_LicenseCountdownTime[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PTD_LicenseCountdownTime[playerid], 0.200000, 1.049999);
	PlayerTextDrawTextSize(playerid, PTD_LicenseCountdownTime[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PTD_LicenseCountdownTime[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PTD_LicenseCountdownTime[playerid], 0);
	PlayerTextDrawAlignment(playerid, PTD_LicenseCountdownTime[playerid], 1);
	PlayerTextDrawColor(playerid, PTD_LicenseCountdownTime[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_LicenseCountdownTime[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_LicenseCountdownTime[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_LicenseCountdownTime[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PTD_LicenseCountdownTime[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_LicenseCountdownTime[playerid], 0);

	PTD_LicenseCountdown[playerid] = CreatePlayerTextDraw(playerid, 582.000000, 376.000000, "99:99");
	PlayerTextDrawFont(playerid, PTD_LicenseCountdown[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PTD_LicenseCountdown[playerid], 0.254166, 1.450000);
	PlayerTextDrawTextSize(playerid, PTD_LicenseCountdown[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PTD_LicenseCountdown[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PTD_LicenseCountdown[playerid], 0);
	PlayerTextDrawAlignment(playerid, PTD_LicenseCountdown[playerid], 1);
	PlayerTextDrawColor(playerid, PTD_LicenseCountdown[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_LicenseCountdown[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_LicenseCountdown[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_LicenseCountdown[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PTD_LicenseCountdown[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_LicenseCountdown[playerid], 0);

	PTD_LicenseCountdownMin[playerid] = CreatePlayerTextDraw(playerid, 619.000000, 380.000000, "seg.");
	PlayerTextDrawFont(playerid, PTD_LicenseCountdownMin[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PTD_LicenseCountdownMin[playerid], 0.162499, 0.800000);
	PlayerTextDrawTextSize(playerid, PTD_LicenseCountdownMin[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PTD_LicenseCountdownMin[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PTD_LicenseCountdownMin[playerid], 0);
	PlayerTextDrawAlignment(playerid, PTD_LicenseCountdownMin[playerid], 1);
	PlayerTextDrawColor(playerid, PTD_LicenseCountdownMin[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_LicenseCountdownMin[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_LicenseCountdownMin[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_LicenseCountdownMin[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PTD_LicenseCountdownMin[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_LicenseCountdownMin[playerid], 0);

	PTD_LicenseCountdownIcon[playerid] = CreatePlayerTextDraw(playerid, 536.000000, 379.000000, "HUD:radar_mafiacasino");
	PlayerTextDrawFont(playerid, PTD_LicenseCountdownIcon[playerid], 4);
	PlayerTextDrawLetterSize(playerid, PTD_LicenseCountdownIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PTD_LicenseCountdownIcon[playerid], 9.500000, 10.000000);
	PlayerTextDrawSetOutline(playerid, PTD_LicenseCountdownIcon[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PTD_LicenseCountdownIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, PTD_LicenseCountdownIcon[playerid], 1);
	PlayerTextDrawColor(playerid, PTD_LicenseCountdownIcon[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_LicenseCountdownIcon[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_LicenseCountdownIcon[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_LicenseCountdownIcon[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PTD_LicenseCountdownIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_LicenseCountdownIcon[playerid], 0);
}

GetPlayerLicenseTakingVehicleid(playerid) {
	return playerLicense[playerid][lDTakingVehicle];
}