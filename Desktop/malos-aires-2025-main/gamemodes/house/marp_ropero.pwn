#if defined _marp_ropero_included
	#endinput
#endif
#define _marp_ropero_included

#define ROPERO_SKIN_MIN 20010
#define ROPERO_SKIN_MAX 20070

CMD:ropero(playerid, params[])
{
	new houseid = House_IsPlayerInAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en una casa.");

	if(!KeyChain_Contains(playerid, KEY_TYPE_HOUSE, houseid) && !AdminDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes las llaves de esta casa.");

	new skinid;
	if(sscanf(params, "i", skinid))
	{
		SendFMessage(playerid, COLOR_USAGE, "[USO] /ropero [id] - Skins disponibles: %d a %d.", ROPERO_SKIN_MIN, ROPERO_SKIN_MAX);
		return 1;
	}

	if(skinid < ROPERO_SKIN_MIN || skinid > ROPERO_SKIN_MAX)
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID invalido. Rango disponible: %d a %d.", ROPERO_SKIN_MIN, ROPERO_SKIN_MAX);
		return 1;
	}

	PlayerInfo[playerid][pSkin] = skinid;
	SetPlayerSkin(playerid, skinid);
	PlayerActionMessage(playerid, 15.0, "se acerca al ropero y cambia su vestimenta.");
	return 1;
}
