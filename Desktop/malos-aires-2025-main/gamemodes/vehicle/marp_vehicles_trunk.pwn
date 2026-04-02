#if defined _marp_vehicles_trunk_included
	#endinput
#endif
#define _marp_vehicles_trunk_included

#include <YSI_Coding\y_hooks>

static playerAtVehicleTrunk[MAX_PLAYERS];

//VehTrunkInfo[MAX_VEHICLES][] = {TRUNK_AREA, CONTAINER SQLID, CONTAINER ID}

hook OnPlayerDisconnect(playerid, reason)
{
	playerAtVehicleTrunk[playerid] = 0;
	return 1;
}

stock VehTrunk_GetCenterPoint(vehicleid, &Float:x, &Float:y, &Float:z, Float:offset = 0.5)
{
	new Float:a, distance;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, x, y, z);
	distance = (y / 2) + offset;
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, a);
	x += (distance * -floatsin(-a, degrees));
	y += (distance * -floatcos(-a, degrees));
}

VehTrunk_LoadOrCreateContainer(vehicleid)
{
	if(VehicleInfo[vehicleid][VehContainerSQLID] > 0) {
		VehicleInfo[vehicleid][VehContainerID] = Container_Load(VehicleInfo[vehicleid][VehContainerSQLID]);
	} else {
		Container_Create(Veh_GetModelTrunkSpace(VehicleInfo[vehicleid][VehModel]), 1, VehicleInfo[vehicleid][VehContainerID], VehicleInfo[vehicleid][VehContainerSQLID]);

		// Dar rueda de auxilio por defecto (NO para jobs)
		if(VehicleInfo[vehicleid][VehType] != VEH_JOB && VehicleInfo[vehicleid][VehJob] == 0)
		{
			Container_AddItemAndParam(VehicleInfo[vehicleid][VehContainerID], ITEM_ID_SPARE_TIRE, 1);
			Container_AddItemAndParam(VehicleInfo[vehicleid][VehContainerID], ITEM_ID_CAJAHERRAMIENTAS, 1);

		}
	}
}

VehTrunk_Load(vehicleid)
{
	VehTrunk_LoadOrCreateContainer(vehicleid);

	if(Veh_GetTrunkSpace(vehicleid) > 0 && VehicleInfo[vehicleid][VehType] != VEH_NONE) {
		VehTrunk_CreateDynamicArea(vehicleid);
	}
}

VehTrunk_Create(vehicleid)
{
	if(Veh_GetTrunkSpace(vehicleid) > 0 && VehicleInfo[vehicleid][VehType] != VEH_NONE) {
		VehTrunk_CreateDynamicArea(vehicleid);
	}

	if(Veh_HasContainer(vehicleid)) //CARGAR DE DB y vaciar para evitar IDs residuales
	{
		// Aseguramos que el contenedor esté cargado en memoria
		if(VehicleInfo[vehicleid][VehContainerID] == 0 && VehicleInfo[vehicleid][VehContainerSQLID] > 0) {
			VehicleInfo[vehicleid][VehContainerID] = Container_Load(VehicleInfo[vehicleid][VehContainerSQLID]);
		}

		Container_Empty(VehicleInfo[vehicleid][VehContainerID]);
		Container_SetTotalSpace(VehicleInfo[vehicleid][VehContainerID], Veh_GetModelTrunkSpace(VehicleInfo[vehicleid][VehModel]));

		// Añadir defaults después de vaciar (persistirán via Container_AddItemAndParam)
		if(VehicleInfo[vehicleid][VehType] != VEH_JOB && VehicleInfo[vehicleid][VehJob] == 0)
		{
			new contId = VehicleInfo[vehicleid][VehContainerID];
			if(Container_SearchItem(contId, ITEM_ID_SPARE_TIRE) == -1) {
				Container_AddItemAndParam(contId, ITEM_ID_SPARE_TIRE, 1);
			}
			if(Container_SearchItem(contId, ITEM_ID_CAJAHERRAMIENTAS) == -1) {
				Container_AddItemAndParam(contId, ITEM_ID_CAJAHERRAMIENTAS, 1);
			}
		}
	} else { // Si no existe, crear contenedor y defaults
		VehTrunk_LoadOrCreateContainer(vehicleid);
	}
}

VehTrunk_Delete(vehicleid)
{
	if(IsValidDynamicArea(VehicleInfo[vehicleid][VehTrunkArea]))
	{
		DestroyDynamicArea(VehicleInfo[vehicleid][VehTrunkArea]);
		VehicleInfo[vehicleid][VehTrunkArea] = STREAMER_TAG_AREA:0;
	}

	if(Veh_HasContainer(vehicleid))
	{
		Container_Empty(VehicleInfo[vehicleid][VehContainerID]);
		Container_SetTotalSpace(VehicleInfo[vehicleid][VehContainerID], Veh_GetModelTrunkSpace(VehicleInfo[vehicleid][VehModel]));
	} else {
		printf("[ERROR] El vehículo %i fue borrado y no tiene un contenedor asociado a su maletero.", vehicleid);
	}
}

VehTrunk_Reload(vehicleid)
{
	if(IsValidDynamicArea(VehicleInfo[vehicleid][VehTrunkArea]))
	{
		DestroyDynamicArea(VehicleInfo[vehicleid][VehTrunkArea]);
		VehicleInfo[vehicleid][VehTrunkArea] = STREAMER_TAG_AREA:0;
	}
	if(Veh_GetTrunkSpace(vehicleid) > 0 && VehicleInfo[vehicleid][VehType] != VEH_NONE)
	{
		VehTrunk_CreateDynamicArea(vehicleid);
	}
}

static VehTrunk_CreateDynamicArea(vehicleid)
{
	new Float:x, Float:y, Float:z;

	GetVehicleModelInfo(VehicleInfo[vehicleid][VehModel], VEHICLE_MODEL_INFO_SIZE, x, y, z);
	// Usar -1 en worldid e interiorid para que funcione en cualquier interior/VW y siga al vehículo
	VehicleInfo[vehicleid][VehTrunkArea] = CreateDynamicCuboid(-(x / 2.0), -0.9, -1.2, (x / 2.0), 0.80, 1.2, -1, -1); // las coords van a funcionar como offsets respecto al centro del rectángulo
	AttachDynamicAreaToVehicle(VehicleInfo[vehicleid][VehTrunkArea], vehicleid, 0.0, -(y / 2.0) - 0.3, 0.0); // el offset sobre el centro de masa del vehiculo. La posicion resultante será el centro del rectangulo
	Streamer_SetExtraIdArray(STREAMER_TYPE_AREA, VehicleInfo[vehicleid][VehTrunkArea], STREAMER_ARRAY_TYPE_VEH_TRUNK, vehicleid);
}

VehTrunk_OnPlayerEnterArea(playerid, vehicleid)
{
	static notiCooldown[MAX_PLAYERS], lastNotiVehicle[MAX_PLAYERS];

	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 0;

	playerAtVehicleTrunk[playerid] = vehicleid;

	if(vehicleid != lastNotiVehicle[playerid] || gettime() >= notiCooldown[playerid])
	{
		if(Veh_CanPlayerInteract(vehicleid, playerid))
		{
			if(VehicleInfo[vehicleid][VehBoot] == 1) {
				Noti_Create(playerid, 2500, "(ALT+CLK DER) Cerrar maletero~n~(ESP+CLK DER) Usar maletero");
			} else {
				Noti_Create(playerid, 2500, "(ALT+CLK DER) Abrir maletero~n~(ESP+CLK DER) Usar maletero");
			}

			notiCooldown[playerid] = gettime() + 20;
			lastNotiVehicle[playerid] = vehicleid;
		}
		else if(VehicleInfo[vehicleid][VehBoot] == 1)
		{
			Noti_Create(playerid, 2500, "(ESP+CLK DER) Usar maletero");

			notiCooldown[playerid] = gettime() + 20;
			lastNotiVehicle[playerid] = vehicleid;
		}
	}

	return 1;
}

VehTrunk_OnPlayerLeaveArea(playerid, vehicleid)
{
	if(vehicleid == playerAtVehicleTrunk[playerid]) {
		playerAtVehicleTrunk[playerid] = 0;
	}
}

stock VehTrunk_GetNearestForPlayer(playerid)
{
	return playerAtVehicleTrunk[playerid];
}

static const KEY_CUSTOM_VEHMAL = KEY_WALK | KEY_HANDBRAKE;
static const KEY_CUSTOM_MAL = KEY_SPRINT | KEY_HANDBRAKE;

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(playerAtVehicleTrunk[playerid] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(KEY_PRESSED_MULTI(KEY_CUSTOM_VEHMAL))
		{
			cmd_vehmal(playerid, "");
			return ~1;
		}

		if(KEY_PRESSED_MULTI(KEY_CUSTOM_MAL))
		{
			cmd_maletero(playerid, "");
			return ~1;
		}
	}
	return 1;
}

CMD:mal(playerid, params[]) {
	return cmd_maletero(playerid, params);
}

CMD:maletero(playerid, params[])
{
	new vehicleid, subcmd[32];

	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar a pie y detrás de un maletero.");
	if(!(vehicleid = VehTrunk_GetNearestForPlayer(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras detrás de un vehículo con maletero.");
	if(Veh_GetTrunkSpace(vehicleid) == 0 || !Veh_HasContainer(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Este vehículo no tiene maletero!");
	if(VehicleInfo[vehicleid][VehBoot] != 1 && !AdminDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡El maletero está cerrado!");

	if(sscanf(params, "s[32]", subcmd))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/mal)etero [comando]");
		SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" guardar/guardari");

		if(!Container_Show(vehicleid, CONTAINER_TYPE_TRUNK, VehicleInfo[vehicleid][VehContainerID], playerid)) {
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error al mostrar el contenedor del maletero. Reportar a un administador.");
		}
	}
	else if(!strcmp(subcmd, "guardar", true)) {
		VehTrunk_PlayerSaveItem(vehicleid, playerid, HAND_RIGHT, GetHandItem(playerid, HAND_RIGHT));
	}
	else if(!strcmp(subcmd, "guardari", true)) {
		VehTrunk_PlayerSaveItem(vehicleid, playerid, HAND_LEFT, GetHandItem(playerid, HAND_LEFT));
	}
	return 1;
}

VehTrunk_PlayerSaveItem(vehicleid, playerid, hand, itemid)
{
	if(!ItemModel_IsValidId(itemid))
		return 0;
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" Debes esperar un tiempo antes de volver a interactuar con otro item!");
	if(!ItemModel_HasTag(GetHandItem(playerid, hand), ITEM_TAG_SAVE))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo con este tem.");

	new itemparam = GetHandParam(playerid, hand);
	
	if(!Container_AddItemAndParam(VehicleInfo[vehicleid][VehContainerID], itemid, itemparam))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay suficiente espacio libre en el maletero / El tem es demasiado chico para guardarse en un maletero.");

	SetHandItemAndParam(playerid, hand, 0, 0);
	Item_ApplyHandlingCooldown(playerid);
	new str[128];
	format(str, sizeof(str), "Guarda un/a %s en el maletero.", ItemModel_GetName(itemid));
	PlayerCmeMessage(playerid, 15.0, 5000, str);
	ServerFormattedLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/mal", .playerid=playerid, .params=<"guardar %d %s", itemparam, ItemModel_GetName(itemid)>);
	
	if(ItemModel_HasTag(itemid, ITEM_TAG_BOTH_HANDS)) {
		ApplyAnimationEx(playerid, "carry", "putdwn105", 20.0, 0, 0, 0, 0, 0, 1);
	}

	return 1;
}

Dialog:Dlg_Show_Trunk_Container(playerid, response, listitem, inputtext[])
{
	new vehicleid = Container_Selection[playerid][csOriginalId],
 		container_id = Container_Selection[playerid][csId];

	ResetContainerSelection(playerid);
	
	if(response)
	{
        new itemid,
            itemparam,
            free_hand = SearchFreeHand(playerid);

    	if(IsPlayerInAnyVehicle(playerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes salir del vehículo primero.");
		if(vehicleid != VehTrunk_GetNearestForPlayer(playerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras detrás del vehículo.");
	    if(Veh_GetTrunkSpace(vehicleid) == 0 || !Veh_HasContainer(vehicleid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este vehículo no tiene maletero.");
		if(VehicleInfo[vehicleid][VehBoot] != 1 && !AdminDuty[playerid])
		   	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El maletero está cerrado.");
		if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
		if(free_hand == -1)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes agarrar el item ya que tienes ambas manos ocupadas.");

		if(Container_TakeItem(container_id, listitem, itemid, itemparam))
		{
			SetHandItemAndParam(playerid, free_hand, itemid, itemparam); // Creación lógica y grafica en la mano.
            Item_ApplyHandlingCooldown(playerid);
            new str[128];
			format(str, sizeof(str), "Toma un/a %s del maletero.", ItemModel_GetName(itemid));
			PlayerCmeMessage(playerid, 15.0, 5000, str);
			ServerFormattedLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/mal", .playerid=playerid, .params=<"tomar %d %s", itemparam, ItemModel_GetName(itemid)>);
			
			if(ItemModel_HasTag(itemid, ITEM_TAG_BOTH_HANDS)) {
				ApplyAnimationEx(playerid, "carry", "liftup105", 20.0, 0, 0, 0, 0, 0, 1);
			}
		}
		else
		{
	        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Maletero vacio o el slot es inválido.");
		}
	}
	return 1;
}