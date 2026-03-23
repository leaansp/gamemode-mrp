#if defined _marp_item_admin_included
	#endinput
#endif
#define _marp_item_admin_included

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