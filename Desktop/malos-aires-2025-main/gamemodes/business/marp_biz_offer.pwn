#if defined _marp_biz_offer_included
	#endinput
#endif
#define _marp_biz_offer_included

#include <YSI_Coding\y_hooks>

hook OnPlayerDisconnect(playerid, reason)
{
	BizOfferEmployee[playerid] = INVALID_PLAYER_ID;

	// Clear any pending offer this employee made to others
	foreach(new i : Player)
	{
		if(BizOfferEmployee[i] == playerid)
			BizOfferEmployee[i] = INVALID_PLAYER_ID;
	}
	return 1;
}

CMD:ofrecerproducto(playerid, params[])
{
	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(!BizEmp_IsEmployee(playerid, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres empleado de este negocio.");
	if(!BizEmp_IsOnDuty(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio para ofrecer productos.");
	if(Biz_IsLocked(bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El negocio esta cerrado.");

	new targetid;
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/ofrecerproducto [ID/Jugador]");
	if(!IsPlayerLogged(targetid) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador invalido.");
	if(!IsPlayerInRangeOfPlayer(5.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador debe estar cerca tuyo (menos de 5 metros).");

	BizOfferEmployee[targetid] = playerid;
	Biz_SetPlayerLastId(targetid, bizid);

	SendFMessage(playerid, COLOR_LIGHTBLUE, "[NEGOCIO] "COLOR_EMB_GREY"Le estas mostrando el catalogo a %s.", GetPlayerCleanName(targetid));
	SendFMessage(targetid, COLOR_LIGHTBLUE, "[NEGOCIO] "COLOR_EMB_GREY"%s te muestra el catalogo de %s.", GetPlayerCleanName(playerid), Biz_GetName(bizid));

	Biz_OnPlayerIntendsToBuy(targetid, bizid);
	return 1;
}
