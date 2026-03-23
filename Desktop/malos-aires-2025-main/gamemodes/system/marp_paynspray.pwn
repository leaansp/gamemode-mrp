#if defined marp_paynspray_inc
	#endinput
#endif
#define marp_paynspray_inc

#include <YSI_Coding\y_hooks>

static const PAYNSPRAY_START_PRICE = 1500;

static enum  
{
    PAYNSPRAY_INVALID_ID,
    PAYNSPRAY_BEACH,
    PAYNSPRAY_NORTH,
    PAYNSPRAY_WILLOWFIELD,
    PAYNSPRAY_AMOUNT
};

static enum e_PAYNSPRAY_INFO
{
    Float:paynsprayInt[3],
    Float:paynsprayRot,
    Float:paynsprayExit[3],
    bool:paynsprayOccupied
};

static PaynsprayInfo[PAYNSPRAY_AMOUNT][e_PAYNSPRAY_INFO] = {
    {
        /*Float:paynsprayInt[3]*/ {0.0, 0.0, 0.0},
        /*Float:paynsprayRot*/ 0.0,
        /*Float:paynsprayExit[3]*/ {0.0, 0.0, 0.0},
        /*bool:paynsprayOccupied*/ false
    },
    {
        /*Float:paynsprayInt[3]*/ {487.4321, -1741.4934, 11.6462},
        /*Float:paynsprayRot*/ 172.5599,
        /*Float:paynsprayExit[3]*/ {488.6190, -1731.6849, 11.1661},
        /*bool:paynsprayOccupied*/ false
    },
    {
        /*Float:paynsprayInt[3]*/ {1024.7690, -1023.3354, 32.5920},
        /*Float:paynsprayRot*/ 0.0,
        /*Float:paynsprayExit[3]*/ {1024.9825, -1032.6246, 31.9083},
        /*bool:paynsprayOccupied*/ false
    },
    {
        /*Float:paynsprayInt[3]*/ {2063.2903, -1831.4307, 13.9557},
        /*Float:paynsprayRot*/ 90.0,
        /*Float:paynsprayExit[3]*/ {2074.8698, -1831.4533, 13.4793},
        /*bool:paynsprayOccupied*/ false
    }
};

static PlayerOnPaySpray[MAX_PLAYERS] = {PAYNSPRAY_INVALID_ID, ...};

static PAYNSPRAY_ON_ENTER_ADDR;
static PAYNSPRAY_ON_LEAVE_ADDR;

hook OnGameModeInit()
{
    PAYNSPRAY_ON_ENTER_ADDR = GetPublicAddressFromName("Paynspray_OnPlayerEnter");
    PAYNSPRAY_ON_LEAVE_ADDR = GetPublicAddressFromName("Paynspray_OnPlayerLeave");
	return 1;
}

hook OnGameModeInitEnded()
{
    new str[BUTTON_MAX_LABEL_TEXT_LENGTH];
    format(str, BUTTON_MAX_LABEL_TEXT_LENGTH, "/repararvehiculo (Min $%d)\n El costo depende del daño de tu vehículo.", PAYNSPRAY_START_PRICE);

    for(new paynspray = 1; paynspray < sizeof(PaynsprayInfo); paynspray++)
    {
        Button_Create(paynspray, 
                    PaynsprayInfo[paynspray][paynsprayExit][0], 
                    PaynsprayInfo[paynspray][paynsprayExit][1], 
                    PaynsprayInfo[paynspray][paynsprayExit][2], 
                    .size = 1.5, .streamDistance = 10.0, .labelText = str, 
                    .onEnterCallbackAddress = PAYNSPRAY_ON_ENTER_ADDR, .onExitCallbackAddress = PAYNSPRAY_ON_LEAVE_ADDR);
    }
    
    return 1;
}

forward Paynspray_OnUse(playerid, paynspray);
public Paynspray_OnUse(playerid, paynspray) {
	return 1;
}

forward Paynspray_OnPlayerEnter(playerid, paynspray);
public Paynspray_OnPlayerEnter(playerid, paynspray) 
{
    if(IsPlayerInAnyVehicle(playerid)) {
        PlayerOnPaySpray[playerid] = paynspray;
    }
    return 1;
}

forward Paynspray_OnPlayerLeave(playerid, paynspray);
public Paynspray_OnPlayerLeave(playerid, paynspray)
{
	if(paynspray == PlayerOnPaySpray[playerid]) {
		PlayerOnPaySpray[playerid] = PAYNSPRAY_INVALID_ID;
	}
    return 1;
}

stock Paynspray_IsPlayerAt(playerid) {
    return (PlayerOnPaySpray[playerid] != PAYNSPRAY_INVALID_ID);
}

hook OnPlayerDisconnect(playerid, reason)
{
	PlayerOnPaySpray[playerid] = PAYNSPRAY_INVALID_ID;
	return 1;
}

CMD:repararvehiculo(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid),
		price,
		paynsprayid = PlayerOnPaySpray[playerid];
	
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Paynspray_IsPlayerAt(playerid))
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en la puerta de un taller o asiento del conductor de un vehículo.");
	
	if(BizEmp_IsAnyMechanicOnDuty())
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hay mecánicos de taller trabajando en este momento. Debes reparar tu vehículo con un mecánico.");
	
	if(PaynsprayInfo[paynsprayid][paynsprayOccupied])
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Hay otro vehículo en reparación en el taller, espera a que salga.");

	price = (6 * Mec_GetMaterialRepairCost(vehicleid) * ItemModel_GetPrice(ITEM_ID_REPUESTOAUTO)) + PAYNSPRAY_START_PRICE;

	if(GetPlayerCash(playerid) < price)
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes dinero suficiente para reparar el vehículo. ($%d)", price);
		return 1;
	}

    SetVehiclePos(vehicleid, PaynsprayInfo[paynsprayid][paynsprayInt][0], 
                    PaynsprayInfo[paynsprayid][paynsprayInt][1], 
                    PaynsprayInfo[paynsprayid][paynsprayInt][2]);
    SetVehicleZAngle(vehicleid, PaynsprayInfo[paynsprayid][paynsprayRot]);

	TogglePlayerControllable(playerid, false);
	PaynsprayInfo[paynsprayid][paynsprayOccupied] = true;
	GivePlayerCash(playerid, -price);
	GameTextForPlayer(playerid, "Su vehiculo esta siendo reparado...", 6000, 1);
	SendFMessage(playerid, COLOR_WHITE, "Su vehículo estará listo en 15 segundos por $%d pesos.", price);
	SendClientMessage(playerid, COLOR_WHITE, "Asegúrese de que ningún ocupante del vehículo descienda del mismo durante la reparación.");
	SetTimerEx("Paynspray_Repair", 15 * 1000, false, "iii", playerid, vehicleid, paynsprayid);
	return 1;
}

forward Paynspray_Repair(playerid, vehicleid, paynsprayid);
public Paynspray_Repair(playerid, vehicleid, paynsprayid)
{
	if(IsPlayerLogged(playerid))
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Su vehículo ha sido reparado exitosamente.");
		TogglePlayerControllable(playerid, true);
	}

	ChangeVehicleColor(vehicleid, VehicleInfo[vehicleid][VehColor1], VehicleInfo[vehicleid][VehColor2]);
	RepairVehicle(vehicleid);
	VehicleInfo[vehicleid][VehHP] = 100;

	SetVehiclePos(vehicleid, PaynsprayInfo[paynsprayid][paynsprayExit][0], 
                    PaynsprayInfo[paynsprayid][paynsprayExit][1], 
                    PaynsprayInfo[paynsprayid][paynsprayExit][2]);
    SetVehicleZAngle(vehicleid, PaynsprayInfo[paynsprayid][paynsprayRot] - 180);

	PaynsprayInfo[paynsprayid][paynsprayOccupied] = false;
	return 1;
}