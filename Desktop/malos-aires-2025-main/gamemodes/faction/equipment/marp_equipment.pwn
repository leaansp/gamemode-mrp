#if defined _marp_equipment_included
	#endinput
#endif
#define _marp_equipment_included

#include "faction\equipment\marp_equipment_data.pwn"
#include "faction\equipment\marp_equipment_points.pwn"

#include <YSI_Coding\y_hooks>

hook OnGameModeInitEnded()
{
	// Cargar puntos de equipamiento desde DB
	EquipmentPoint_DBLoad();

	Equipment_SetFactionCallback(FAC_PMA, "Equipment_PoliceShow");
	Equipment_SetFactionCallback(FAC_SIDE, "Equipment_GNAShow");

	// SAME
	// Si la DB está vacía, puedes agregar puntos por admin command

	Equipment_SetFactionCallback(FAC_HOSP, "Equipment_FireShow");
	return 1;	
}

CMD:comprarinsumos(playerid, params[])
{
	if(!Faction_IsValidId(PlayerInfo[playerid][pFaction]))
        return 1;
		
	new amount;
	new freehand = SearchFreeHand(playerid);
	new bizid = Biz_IsPlayerInsideAny(playerid);
	new callbackaddr = Equipment_GetFactionCallback(PlayerInfo[playerid][pFaction]);
	
	if(!Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_EQUIPMENT))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene acceso a este comando.");
	if(callbackaddr == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene asociada una funcion de equipamiento. Contacta con un scripter.");
	if(GetBusinessType(bizid) != BIZ_AMMU)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes usar este comando en cualquier lado. Debes estar dentro de una armeria.");
    if(sscanf(params, "i", amount)) {
        SendFMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY" /comprarinsumos [cantidad] | $%d cada insumo.", ItemModel_GetPrice(ITEM_ID_MATERIALES)); 
		return 1;
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar a pie.");
	if(freehand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes ambas manos ocupadas y no puedes agarrar la caja de insumos.");
	if(amount < 1 || amount > 1300)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad de insumos no debe ser menor a 1 o mayor a 1300.");
	if(GetPlayerCash(playerid) < amount * ItemModel_GetPrice(ITEM_ID_MATERIALES)) {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero suficiente, necesitas $%d.", amount * ItemModel_GetPrice(ITEM_ID_MATERIALES)); 
		return 1;
	}

    SetHandItemAndParam(playerid, freehand, ITEM_ID_MATERIALES, amount);
	GivePlayerCash(playerid, - amount * ItemModel_GetPrice(ITEM_ID_MATERIALES));
	SendClientMessage(playerid, COLOR_WHITE, "Vé al depósito y descarga los insumos con /guardarinsumos. Utiliza /nocargar para sacar la animaicón de carga.");
	PlayerActionMessage(playerid, 15.0, "compra una caja de insumos.");
	return 1;
}

CMD:guardarinsumos(playerid, params[])
{
	if(!Faction_IsValidId(PlayerInfo[playerid][pFaction]))
        return 1;

	new amount;
	new hand = SearchHandsForItem(playerid, ITEM_ID_MATERIALES);
    new equipid = EquipmentPoint_GetId(playerid);
	new callbackaddr = Equipment_GetFactionCallback(PlayerInfo[playerid][pFaction]);

	if(!Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_EQUIPMENT))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene acceso a este comando.");   
	if(callbackaddr == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene asociada una funcion de equipamiento. Contacta con un scripter.");
	if(!EquipmentPoint_IsPlayerAt(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes usar este comando en cualquier lado. Debes estar en los casilleros.");
	if(!EquipmentPoint_CanPlayerUse(playerid, equipid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un casillero de tu faccion.");
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar a pie.");
	if(hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener una caja de insumos en tus manos para descargar.");
	amount = GetHandParam(playerid, hand);
	if(FactionInfo[PlayerInfo[playerid][pFaction]][fMaterials] + amount > 270000)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes cargar más insumos al depósito ya que el mismo está lleno.");
	
	FactionInfo[PlayerInfo[playerid][pFaction]][fMaterials] += amount;
	SetHandItemAndParam(playerid, hand, 0, 0);
	PlayerActionMessage(playerid, 15.0, "descarga una caja de insumos en el depósito.");
 	return 1;
}

CMD:verinsumos(playerid, params[])
{
	if(!Faction_IsValidId(PlayerInfo[playerid][pFaction]))
        return 1;
	if(!Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_EQUIPMENT))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tu faccion no tiene acceso a este comando.");
	if(PlayerInfo[playerid][pRank] > 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso al registro.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"[%s] El depósito cuenta actualmente con %d insumos.", FactionInfo[PlayerInfo[playerid][pFaction]][fName], FactionInfo[PlayerInfo[playerid][pFaction]][fMaterials]);
	return 1;
}

CMD:equipar(playerid, params[])
{
	if(!EquipmentPoint_IsPlayerAt(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes usar este comando en cualquier lado. Debes estar en los casilleros.");

	new equipid = EquipmentPoint_GetId(playerid);
	CallLocalFunction("EquipmentPnt_OnUse", "ii", playerid, equipid);
	return 1;
}

Equipment_OnPlayerTake(playerid, input, text[] = "\0")
{
	FactionInfo[PlayerInfo[playerid][pFaction]][fMaterials] -= input;

	new query[256];
	new logtext[128];
	
	// Si se proporciona texto, usarlo; si no, usar un formato genérico
	if(strlen(text) > 0)
		format(logtext, sizeof(logtext), "%s (%d insumos)", text, input);
	else
		format(logtext, sizeof(logtext), "Equipamiento tomado (%d insumos)", input);

	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `log_inputs` (pID, pName, pIP, date, text) VALUES (%d, '%s', '%s', CURRENT_TIMESTAMP, '%s')",
		PlayerInfo[playerid][pID],
		PlayerInfo[playerid][pName],
		PlayerInfo[playerid][pIP],
		logtext
	);
	mysql_tquery(MYSQL_HANDLE, query);

	return 1;
}

static Equipment_LogStr[4096];

forward Equipment_PrintLogs(playerid, const targetname[]);
public Equipment_PrintLogs(playerid, const targetname[])
{
	if(!IsPlayerLogged(playerid))
		return 0;

	new rows = cache_num_rows();

	if(!rows)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Esa persona no posee ningún registro de equipamiento.");

	new text[128], date[32], line[180], title[64];

	for(new i; i < rows; i++)
	{
		cache_get_value_name(i, "text", text, sizeof(text));
		cache_get_value_name(i, "date", date, sizeof(date));

		format(line, sizeof(line), "{5CCAF1}[%s]{C8C8C8} %s\n", date, text);
		strcat(Equipment_LogStr, line, sizeof(Equipment_LogStr));
	}

	format(title, sizeof(title), "[Registros] %s", targetname);
	Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, title, Equipment_LogStr, "Cerrar", "");
	return 1;
}

CMD:verregistros(playerid, params[])
{
	new targetname[MAX_PLAYER_NAME], callbackaddr = Equipment_GetFactionCallback(PlayerInfo[playerid][pFaction]);

	if(callbackaddr == -1)
		return 1;
    if(PlayerInfo[playerid][pRank] > 4)
        return 1;
    if(sscanf(params, "s[24]", targetname))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/verregistros [Nombre_Apellido del jugador]");
	if(!IsNameRoleplayValid(targetname))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes utilizar el formato Nombre_Apellido.");

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "Equipment_PrintLogs", "is", playerid, targetname @Format: "SELECT * FROM `log_inputs` WHERE `pName`='%e' ORDER BY `date` DESC LIMIT 20;", targetname);
	return 1;
}