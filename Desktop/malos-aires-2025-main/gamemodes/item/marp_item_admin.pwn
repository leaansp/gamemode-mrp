#if defined _marp_item_admin_included
	#endinput
#endif
#define _marp_item_admin_included

static g_AdminEditItemId[MAX_PLAYERS];
static g_AdminEditHand[MAX_PLAYERS] = {-1, ...};

CMD:aitemdar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new targetid, itemid, amount, targetfreehand, string[128];

	if(sscanf(params, "uii", targetid, itemid, amount))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aitemdar [ID/Jugador] [ID de objeto] [cantidad].");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(!ItemModel_IsValidId(itemid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de objeto inválida.");
	if((targetfreehand = SearchFreeHand(targetid)) == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto tiene ambas manos ocupadas y no puede agarrar nada más.");

	if(!ItemModel_HasTag(itemid, ITEM_TAG_STACK))
	{
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El ítem especificado no acepta valores personalizados de parámetro. Se usará el valor por defecto.");
		amount = ItemModel_GetParamDefaultValue(itemid);
	}

	SetHandItemAndParam(targetid, targetfreehand, itemid, amount);
	format(string, sizeof(string), "[STAFF] El administrador %s le dió [%s - %s: %i] a %s.", GetPlayerCleanName(playerid), ItemModel_GetName(itemid), ItemModel_GetParamName(itemid), amount, GetPlayerCleanName(targetid));
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El administrador %s te dió el item [%s - %s: %i].", GetPlayerCleanName(playerid), ItemModel_GetName(itemid), ItemModel_GetParamName(itemid), amount);

	ServerFormattedLog(LOG_TYPE_ID_ADMIN, .entry="/aitemdar", .playerid=playerid, .targetid=targetid, .params=<"%i %s", GetHandParam(targetid, targetfreehand), ItemModel_GetName(itemid)>);
	return 1;
}

CMD:aitemquitar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new string[128], slot, targetid;

	if(sscanf(params, "ui", targetid, slot))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aitemquitar [ID/Jugador] [número de slot] (1.Mano derecha | 2.Mano izquierda | 3.Espalda)");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(slot > 3 || slot < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Slot inválido, los números de slot posibles van del 1 al 3.");

	new itemid; 
	new amount;

	switch(slot)
	{
		case 1: // Mano derecha
		{
			format(string, sizeof(string), "[STAFF] el administrador %s le ha retirado a %s el objeto de la mano derecha.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
			SendFMessage(targetid, COLOR_LIGHTBLUE, "El administrador %s te ha retirado el objeto que tenías en la mano derecha.", GetPlayerCleanName(playerid));
			
			itemid = GetHandItem(playerid, HAND_RIGHT);
			amount = GetHandParam(playerid, HAND_RIGHT);
			
			SetHandItemAndParam(targetid, HAND_RIGHT, 0, 0);
		}
		case 2: // Mano izquierda
		{
			format(string, sizeof(string), "[STAFF] el administrador %s le ha retirado a %s el objeto de la mano izquierda.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
			SendFMessage(targetid, COLOR_LIGHTBLUE, "El administrador %s te ha retirado el objeto que tenías en la mano izquierda.", GetPlayerCleanName(playerid));
			
			itemid = GetHandItem(playerid, HAND_LEFT);
			amount = GetHandParam(playerid, HAND_LEFT);
			
			SetHandItemAndParam(targetid, HAND_LEFT, 0, 0);
		}
		case 3: // Espalda
		{
			format(string, sizeof(string), "[STAFF] el administrador %s le ha retirado a %s el objeto de la espalda o pecho.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
			SendFMessage(targetid, COLOR_LIGHTBLUE, "El administrador %s te ha retirado el objeto que tenías en la espalda o pecho.", GetPlayerCleanName(playerid));
			
			itemid = Back_GetItem(playerid);
			amount = Back_GetParam(playerid);
			
			Back_SetItemAndParam(targetid, 0, 0, 0);
		}
	}

	ServerFormattedLog(LOG_TYPE_ID_ADMIN, .entry="/aitemquitar", .playerid=playerid, .targetid=targetid, .params=<"%i %s %i", slot, ItemModel_GetName(itemid), amount>);
	return 1;
}
// =================================
// Admin: editar posicion de item en mano
// =================================
forward ItemModelAdmin_OnLoad();
public ItemModelAdmin_OnLoad()
{
	new rows;
	cache_get_row_count(rows);
	new itemid, hand;
	new Float:px, Float:py, Float:pz, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz;
	for(new i = 0; i < rows; i++) {
		cache_get_value_name_int(i, "itemid", itemid);
		cache_get_value_name_int(i, "hand", hand);
		cache_get_value_name_float(i, "posx", px);
		cache_get_value_name_float(i, "posy", py);
		cache_get_value_name_float(i, "posz", pz);
		cache_get_value_name_float(i, "rotx", rx);
		cache_get_value_name_float(i, "roty", ry);
		cache_get_value_name_float(i, "rotz", rz);
		cache_get_value_name_float(i, "scalex", sx);
		cache_get_value_name_float(i, "scaley", sy);
		cache_get_value_name_float(i, "scalez", sz);
		if(!ItemModel_IsValidId(itemid)) continue;
		if(hand == HAND_RIGHT) {
			ItemModel_SetRightPos(itemid, px, py, pz);
			ItemModel_SetRightRot(itemid, rx, ry, rz);
			ItemModel_SetRightScale(itemid, sx, sy, sz);
		} else {
			ItemModel_SetLeftPos(itemid, px, py, pz);
			ItemModel_SetLeftRot(itemid, rx, ry, rz);
			ItemModel_SetLeftScale(itemid, sx, sy, sz);
		}
	}
	return 1;
}

hook OnGameModeInitEnded()
{
	mysql_tquery(MYSQL_HANDLE, "SELECT * FROM item_model_pos", "ItemModelAdmin_OnLoad", "");
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	g_AdminEditHand[playerid] = -1;
	return 1;
}

CMD:manoderechaadmin(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas ser nivel 20 de administrador.");

	new itemid = GetHandItem(playerid, HAND_RIGHT);
	if(!itemid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes ningun item en la mano derecha.");

	g_AdminEditHand[playerid] = HAND_RIGHT;
	g_AdminEditItemId[playerid] = itemid;

	EditAttachedObject(playerid, ATTACH_INDEX_ID_HAND_RIGHT);
	return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Edita la posicion del item. Confirma para guardar para todos los jugadores.");
}

CMD:manoizquierdaadmin(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas ser nivel 20 de administrador.");

	new itemid = GetHandItem(playerid, HAND_LEFT);
	if(!itemid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes ningun item en la mano izquierda.");

	g_AdminEditHand[playerid] = HAND_LEFT;
	g_AdminEditItemId[playerid] = itemid;

	EditAttachedObject(playerid, ATTACH_INDEX_ID_HAND_LEFT);
	return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Edita la posicion del item. Confirma para guardar para todos los jugadores.");
}

stock ItemModelAdmin_OnEdit(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(g_AdminEditHand[playerid] == -1) return 1;

	new hand = g_AdminEditHand[playerid];
	new item_idx = (hand == HAND_RIGHT) ? ATTACH_INDEX_ID_HAND_RIGHT : ATTACH_INDEX_ID_HAND_LEFT;
	if(index != item_idx) return 1;

	g_AdminEditHand[playerid] = -1;
	new itemid = g_AdminEditItemId[playerid];

	if(!response)
	{
		ItemModel_AttachOnHand(playerid, itemid, hand);
		return 1;
	}

	if(hand == HAND_RIGHT) {
		ItemModel_SetRightPos(itemid, fOffsetX, fOffsetY, fOffsetZ);
		ItemModel_SetRightRot(itemid, fRotX, fRotY, fRotZ);
		ItemModel_SetRightScale(itemid, fScaleX, fScaleY, fScaleZ);
	} else {
		ItemModel_SetLeftPos(itemid, fOffsetX, fOffsetY, fOffsetZ);
		ItemModel_SetLeftRot(itemid, fRotX, fRotY, fRotZ);
		ItemModel_SetLeftScale(itemid, fScaleX, fScaleY, fScaleZ);
	}

	for(new p = 0; p < MAX_PLAYERS; p++) {
		if(!IsPlayerConnected(p)) continue;
		if(GetHandItem(p, hand) == itemid)
			ItemModel_AttachOnHand(p, itemid, hand);
	}

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "REPLACE INTO item_model_pos (itemid, hand, posx, posy, posz, rotx, roty, rotz, scalex, scaley, scalez) VALUES (%d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f)", itemid, hand, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
	mysql_tquery(MYSQL_HANDLE, query);

	new msg[80];
	format(msg, sizeof(msg), "[INFO] Posicion de [%s] guardada para todos.", ItemModel_GetName(itemid));
	SendClientMessage(playerid, COLOR_INFO, msg);
	return 1;
}
