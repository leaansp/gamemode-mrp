#if defined _marp_ropero_included
	#endinput
#endif
#define _marp_ropero_included

#define ROPERO_SKIN_MIN 20011
#define ROPERO_SKIN_MAX 20092

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
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"/ropero [id] - Guia de skins disponibles:");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Barrios de emergencia: 20011 a 20035");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Civiles: 20036 a 20047");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Jovenes: 20048 a 20055");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Africanos: 20056 a 20059");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Etnia paraguaya: 20060 a 20067");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Mujeres: 20068 a 20076");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Chinos: 20077 a 20088 (sin 20085)");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Varios: 20089 a 20092");
		return 1;
	}

	if(skinid == 20085)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Esa skin es de uso exclusivo policial.");
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
