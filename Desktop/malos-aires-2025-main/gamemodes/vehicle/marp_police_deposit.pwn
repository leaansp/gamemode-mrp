#if defined _marp_police_deposit_included
	#endinput
#endif
#define _marp_police_deposit_included

#include <YSI_Coding\y_hooks>

#define MAX_DEPO_REASON_LENGTH      128

#define DEPOSIT_CAR_PRICE           5500
#define DEPOSIT_BIKE_PRICE          3500
#define DEPOSIT_INDUSTRIAL_PRICE    12500

#define DEPOSIT_USE_X               -2789.38
#define DEPOSIT_USE_Y               3211.53
#define DEPOSIT_USE_Z               2412.72

#define DEPOSIT_DELIVERY_X 		    1374.66 
#define DEPOSIT_DELIVERY_Y		    -1500.32
#define DEPOSIT_DELIVERY_Z		    13.54
#define DEPOSIT_DELIVERY_ANG	    270.74

#define DEPO_CREATE           	    1
#define DEPO_UPDATE                 2
#define DEPO_REMOVE                 3

#define DEPOSIT_MAX_CARS            10

static enum e_DEPO_DATA {
    depoStatus,
    depoPname[MAX_PLAYER_NAME], // ID SQL del jugador que lo ingresa.
    depoReason[MAX_DEPO_REASON_LENGTH],
    depoDate[32],
    depoCanRemove
};

new Depo_Info[MAX_VEH][e_DEPO_DATA];

new Depo_Area;
new Depo_PickUp;
new Depo_InfoStr[4096];
new Depo_PlayerPrice[MAX_PLAYERS];
new Depo_PlayerCar[MAX_PLAYERS];
new Depo_RemoveCount = 0;

hook OnPlayerDisconect(playerid)
{
    Depo_PlayerPrice[playerid] = 0;
    Depo_PlayerCar[playerid] = 0;
    return 1;
}

hook OnGameModeInitEnded()
{
    Depo_Area = CreateDynamicRectangle(2839.69, 3201.06, 2845.98, 3208.58);
    Depo_PickUp = CreateDynamicPickup(1239, 1, DEPOSIT_USE_X, DEPOSIT_USE_Y, DEPOSIT_USE_Z);    
    return 1;
}

hook Veh_OnAllDataLoaded()
{
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "Depo_Load" @Format: "SELECT * FROM `deposit_info` LIMIT %i;", MAX_VEH - 1);
	return 1;
}

forward Depo_Load();
public Depo_Load()
{
	new rows = cache_num_rows();

	for(new row, vehid; row < rows; row++)
	{
		cache_get_value_name_int(row, "vehID", vehid);

		cache_get_value_name_int(row, "status", Depo_Info[vehid][depoStatus]);
		cache_get_value_name(row, "pName", Depo_Info[vehid][depoPname], MAX_PLAYER_NAME);
		cache_get_value_name(row, "reason", Depo_Info[vehid][depoReason], MAX_DEPO_REASON_LENGTH);
		cache_get_value_name(row, "date", Depo_Info[vehid][depoDate], 32);
		cache_get_value_name_int(row, "canRemove", Depo_Info[vehid][depoCanRemove]);

		if(Depo_Info[vehid][depoStatus]) {
			SetVehicleVirtualWorld(vehid, vehid);
		}
	}

	printf("[INFO] Carga de %i vehiculos en deposito finalizada.", rows);
	return 1;
}

Depo_IsVehicle(vehicleid) {
    return Depo_Info[vehicleid][depoStatus];
}

Depo_EnterVehicle(playerid, vehicleid, reason[MAX_DEPO_REASON_LENGTH])
{
	if(Depo_Info[vehicleid][depoStatus])
		return 0;

	new Float:angle;

	GetVehicleZAngle(vehicleid, angle);
	Veh_SetRespawnPoint(vehicleid, 2843.70, 2635.53, 10.82, angle, 0, vehicleid);
	Depo_Info[vehicleid][depoStatus] = 1;
    format(Depo_Info[vehicleid][depoPname], MAX_PLAYER_NAME, PlayerInfo[playerid][pName]);
    format(Depo_Info[vehicleid][depoReason], MAX_DEPO_REASON_LENGTH, reason);
    format(Depo_Info[vehicleid][depoDate], 32, GetDateString());
    Depo_Info[vehicleid][depoCanRemove] = 1;
    Depo_UpdateVehicle(vehicleid, DEPO_CREATE);
	return 1;
}

Depo_RemoveVehicle(vehicleid)
{
	if(!Depo_Info[vehicleid][depoStatus])
		return 0;
	
	SetVehiclePos(vehicleid, DEPOSIT_DELIVERY_X, DEPOSIT_DELIVERY_Y, DEPOSIT_DELIVERY_Z);
	SetVehicleZAngle(vehicleid, DEPOSIT_DELIVERY_ANG);
	Veh_SetRespawnPoint(vehicleid, DEPOSIT_DELIVERY_X, DEPOSIT_DELIVERY_Y - Depo_RemoveCount*5, DEPOSIT_DELIVERY_Z, DEPOSIT_DELIVERY_ANG, 0, 0);
	Depo_Info[vehicleid][depoStatus] = 0;
    format(Depo_Info[vehicleid][depoPname], MAX_PLAYER_NAME, "");
    format(Depo_Info[vehicleid][depoReason], MAX_DEPO_REASON_LENGTH, "");
    format(Depo_Info[vehicleid][depoDate], 32, "");
    Depo_Info[vehicleid][depoCanRemove] = 0;
    Depo_UpdateVehicle(vehicleid, DEPO_REMOVE);
    Depo_RemoveCount++;
    
    if(Depo_RemoveCount >= DEPOSIT_MAX_CARS)
        Depo_RemoveCount = 0;
        
	return 1;
}

Depo_GetPrice(vehicleid)
{
    new v_type = Veh_GetModelModelType(GetVehicleModel(vehicleid));


    if(v_type == VTYPE_BIKE || v_type == VTYPE_QUAD || v_type == VTYPE_BMX)
        return DEPOSIT_BIKE_PRICE;
    else if(v_type == VTYPE_CAR)
        return DEPOSIT_CAR_PRICE;
    else 
        return DEPOSIT_INDUSTRIAL_PRICE;
}

Depo_CanOpenTrunk(playerid) {
    return (IsPlayerInDynamicArea(playerid, Depo_Area) && CopDuty[playerid] == 1);
}

forward Depo_Reset_Count(); // Evita vehiculos superpuestos si se reterian rapido
public Depo_Reset_Count()
{
    Depo_RemoveCount = 0;
    return 1;
}

forward Depo_UpdateVehicle(vehicleid, option);
public Depo_UpdateVehicle(vehicleid, option)
{
    new query[256];

    if(option == DEPO_CREATE)
    {
        if(Depo_Info[vehicleid][depoStatus])
        {
            mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `deposit_info` (`vehID`, `status`, `pName`, `reason`, `date`, `canRemove`) VALUES (%i, %i, '%s', '%s', CURRENT_TIMESTAMP, %i)",
                        vehicleid,
                        Depo_Info[vehicleid][depoStatus],
                        Depo_Info[vehicleid][depoPname],
                        Depo_Info[vehicleid][depoReason],
                        Depo_Info[vehicleid][depoCanRemove]
                    );
        }
    }
    else if(option == DEPO_UPDATE)
    {
        mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `deposit_info` SET canRemove=%i WHERE `vehID`=%i", Depo_Info[vehicleid][depoCanRemove], vehicleid);
    }
    else if(option == DEPO_REMOVE)
    {
        format(query, sizeof(query), "DELETE FROM `deposit_info` WHERE `vehID`=%i", vehicleid);
    }
    mysql_tquery(MYSQL_HANDLE, query);
    return 1;
}

stock Depo_ShowVehicles(playerid) 
{
    new depoStr[256], count = 0;
    format(Depo_InfoStr, sizeof(Depo_InfoStr), "");
    strcat(Depo_InfoStr, "ID\tModelo\tIncautado por\tFecha\n", sizeof(Depo_InfoStr));

    foreach(new i : Vehicle) {
        
        if(Depo_Info[i][depoStatus] && Veh_IsValidId(i)) {
            format(depoStr, sizeof(depoStr), "%d\t%s\t%s\t%s\n", i, Veh_GetName(i), Depo_Info[i][depoPname], Depo_Info[i][depoDate]);
            strcat(Depo_InfoStr, depoStr, sizeof(Depo_InfoStr));
            count++;
        }		
    }
    if(count == 0)
        return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay veh�culos en el incautados.");

    Dialog_Show(playerid, DLG_DEPO_SHOW, DIALOG_STYLE_TABLIST_HEADERS, "Lista de veh�culos incautados", Depo_InfoStr, "Seleccionar", "Cerrar");
    return 1;
}

Dialog:DLG_DEPO_SHOW(playerid, response, listitem, inputtext[]) 
{
    if(!response)
        return 1;
    
    new vehicleid;

    if(sscanf(inputtext, "i", vehicleid) || (!Veh_IsValidId(vehicleid, true)))
		return 1;

    new str[256], title[32];

    format(title, sizeof(title), "Informacion de veh�culo ID: %i", vehicleid);

    format(str, sizeof(str), "Modelo: %s\nPatente: %s\ndue�o: %s\nraz�n de ingreso: %s\nIngresado por: %s\nFecha de ingreso: %s", 
        Veh_GetName(vehicleid),
        VehicleInfo[vehicleid][VehPlate], 
        VehicleInfo[vehicleid][VehOwnerName],
        Depo_Info[vehicleid][depoReason],
        Depo_Info[vehicleid][depoPname], 
        Depo_Info[vehicleid][depoDate]);
    
    Dialog_Show(playerid, DLG_DEPO_INFO, DIALOG_STYLE_MSGBOX, title, str, "Volver", "Salir");
    
    return 1;
}

Dialog:DLG_DEPO_INFO(playerid, response, listitem, inputtext[]) 
{
    if(response)
        Depo_ShowVehicles(playerid);
    return 1;
}

CMD:deposito(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] != FAC_PMA || PlayerInfo[playerid][pRank] == 10)
	  	return 1;
	if(CopDuty[playerid] == 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �Debes estar en servicio como oficial de polic�a!");
    
    new subcmd[18], subdata[MAX_DEPO_REASON_LENGTH], vehicleid;
	if(sscanf(params, "s[18]S(" ")[128]", subcmd, subdata)) {
        SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/deposito [comando]");
        return SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" ingresar - sacar - permitirretirar - ver");
    } 
    else 
    {
        if(!strcmp(subcmd, "ingresar", true)) {
            new reason[128];
            if(sscanf(subdata, "s[128]", reason))
                return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/deposito ingresar [raz�n]");
            if(!IsPlayerInDynamicArea(playerid, Depo_Area))
                return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �Debes estar en la zona del deposito!");

            vehicleid = GetPlayerVehicleID(playerid);
            if(!Veh_IsValidId(vehicleid))
                return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �Debes estar dentro de un veh�culo!");
            if(Depo_EnterVehicle(playerid, vehicleid, reason)) {
                ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/deposito", .playerid=playerid, .params="ingresar");
                SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ingresaste el veh�culo id: %d por %s al deposito.", vehicleid, reason);
            }
        } 
        else if(!strcmp(subcmd, "sacar", true)) {
            if(sscanf(subdata, "i", vehicleid))
                return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/deposito sacar [idvehiculo]");
            if(!Veh_IsValidId(vehicleid))
                return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �ID invalida!");
            if(PlayerInfo[playerid][pRank] > 3)
                return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �Tu rango no tiene acceso a este comando!");
            if(Depo_RemoveVehicle(vehicleid)) {
                ServerLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/deposito", .playerid=playerid, .params="sacar");
                SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Sacaste el veh�culo id: %d del deposito.", vehicleid);
            } else {
                return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �Ese veh�culo no se encuentra en el deposito!");
            }
        }
        else if(!strcmp(subcmd, "permitirretirar", true)) {
            if(sscanf(subdata, "i", vehicleid))
                return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/deposito permitirretirar [idveh�culo]");
            if(!Veh_IsValidId(vehicleid))
                return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �ID invalida!");
            if(!Depo_IsVehicle(vehicleid))
                return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �Ese veh�culo no se encuentra en el deposito!");
            if(Depo_Info[vehicleid][depoCanRemove]) {
                Depo_Info[vehicleid][depoCanRemove] = 0;
                SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El veh�culo id: %d no podra ser retirado del deposito por su due�o.", vehicleid);
            } else {
                Depo_Info[vehicleid][depoCanRemove] = 1;
                SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El veh�culo id: %d podra ser retirado del deposito por su due�o.", vehicleid);
            }
            Depo_UpdateVehicle(vehicleid, DEPO_UPDATE);
            return 1;
        }
        else if(!strcmp(subcmd, "ver", true)) {
            Depo_ShowVehicles(playerid);
        }
    }
    return 1;
}

Depo_InformOfficers(playerid, vehicleid)
{
    new string[128];
    format(string, sizeof(string), "[CENTRAL] El sujeto %s quiere retirar el veh�culo n�mero ((ID)) %i del dep�sito.", GetPlayerCleanName(playerid), vehicleid);
    SendFactionRadioMessage(FAC_PMA, COLOR_PMA, string);
    SendFactionRadioMessage(FAC_SIDE, COLOR_PMA, string);
}

CMD:sacarvehiculo(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 4.0, DEPOSIT_USE_X, DEPOSIT_USE_Y, DEPOSIT_USE_Z))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �Debes estar en el mostrador de la comisaria!");

    new vehicleid;
    if(sscanf(params, "i", vehicleid))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/sacarvehiculo [idvehiculo]");
    if(!Veh_IsValidId(vehicleid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �ID invalida!");
    if(!Veh_IsPlayerOwner(vehicleid, playerid) && (Veh_GetSystemType(vehicleid) != VEH_FACTION && PlayerInfo[playerid][pFaction] != VehicleInfo[vehicleid][VehFaction]))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �Este veh�culo no te pertenece o no es de tu faccion!");
    if(!Depo_IsVehicle(vehicleid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �Ese veh�culo no se encuentra en el deposito!");
    if(!Depo_Info[vehicleid][depoCanRemove]){
        PlayerDoMessage(playerid, 15.0, "El oficial de recepcion habla por su radio pidiendo a un superior.");
        Depo_InformOfficers(playerid, vehicleid);
        return 1;
    }
    Depo_PlayerPrice[playerid] = Depo_GetPrice(vehicleid);
    Depo_PlayerCar[playerid] = vehicleid;
    format(Depo_InfoStr, sizeof(Depo_InfoStr), ""COLOR_EMB_GREY"Total a pagar: $%d.\nElije el medio de pago:", Depo_PlayerPrice[playerid]);
	Dialog_Show(playerid, DLG_DEPO_REMOVE, DIALOG_STYLE_MSGBOX, "Pago de deposito", Depo_InfoStr, "Efectivo", "Tarjeta");
    return 1;
}

Dialog:DLG_DEPO_REMOVE(playerid, response, listitem, inputtext[]) 
{
    if(response)
    {
		if(GetPlayerCash(playerid) < Depo_PlayerPrice[playerid])
		{
			SendClientMessage(TicketOffer[playerid], COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto decidi� pagar en efectivo, pero no tiene el dinero suficiente.");
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �No tienes el dinero en efectivo suficiente!");
			return 1;
		}
		GivePlayerCash(playerid, -Depo_PlayerPrice[playerid]);
	}
	else
	{
		if(PlayerInfo[playerid][pBank] < Depo_PlayerPrice[playerid])
		{
			SendClientMessage(TicketOffer[playerid], COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto decidi� pagar por transferencia bancaria, pero no tiene dinero suficiente en su cuenta.");
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" �No tienes el dinero suficiente en tu cuenta bancaria!");
			return 1;
		}
		PlayerInfo[playerid][pBank] -= Depo_PlayerPrice[playerid];
	}

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Vehiculo retirado - costo: $%d.", Depo_PlayerPrice[playerid]);
    SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu veh�culo esta estacionado detras de comisaria. Recuarda usar /vehestacionar luego de retirarlo.");
	Faction_GiveMoney(FAC_PMA, Depo_PlayerPrice[playerid]);
    ServerLog(LOG_TYPE_ID_VEHICLES, .id=Depo_PlayerCar[playerid], .entry="/sacarvehiculo", .playerid=playerid);
    Depo_RemoveVehicle(Depo_PlayerCar[playerid]);
    Depo_PlayerCar[playerid] = 0;
	Depo_PlayerPrice[playerid] = 0;
    return 1;
}